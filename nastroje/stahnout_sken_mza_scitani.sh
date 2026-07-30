#!/usr/bin/env bash

# Stáhne jeden veřejný snímek sčítacího operátu z prohlížeče MZA,
# složí dlaždice Deep Zoom a ořízne výsledek na skutečný rozměr obrazu.
#
# Použití:
#   stahnout_sken_mza_scitani.sh ID_DIGISADY SNIMEK VYSTUP [UROVEN]
#
# SNIMEK je pořadí v prohlížeči od 1. Bez UROVNE se stáhne druhá nejvyšší
# úroveň, tedy přibližně poloviční rozlišení. Hodnota 999 znamená maximum.

set -euo pipefail

if (( $# < 3 || $# > 4 )); then
  echo "Použití: $0 ID_DIGISADY SNIMEK VYSTUP [UROVEN]" >&2
  exit 2
fi

set_id=$1
page=$2
output=$3
requested_level=${4:-998}

if [[ ! "$set_id" =~ ^[0-9]+$ || ! "$page" =~ ^[0-9]+$ || ! "$requested_level" =~ ^[0-9]+$ ]]; then
  echo "ID sady, snímek i úroveň musejí být celá nezáporná čísla." >&2
  exit 2
fi
if (( page < 1 )); then
  echo "Číslo snímku musí být alespoň 1." >&2
  exit 2
fi

detail_url="https://www.mza.cz/scitacioperaty/digisada/detail/${set_id}"
user_agent="Mozilla/5.0"
work_dir=$(mktemp -d)

cleanup() {
  rm -rf -- "$work_dir"
}
trap cleanup EXIT

curl -L --fail --silent --show-error -A "$user_agent" \
  "$detail_url" -o "$work_dir/detail.html"

dzi_url=$(ruby -rjson -e '
  html = File.binread(ARGV[0]).force_encoding("UTF-8")
  page = Integer(ARGV[1], 10)
  match = html.match(/var viewer = CreateSeadragon\(\s*(\[.*?\])\s*,/m)
  abort "Na stránce sady nebyl nalezen seznam obrazů." unless match
  images = JSON.parse(match[1])
  abort "Sada má jen #{images.length} snímků." unless (1..images.length).cover?(page)
  puts images.fetch(page - 1)
' "$work_dir/detail.html" "$page")

curl -L --fail --silent --show-error -A "$user_agent" -e "$detail_url" \
  "$dzi_url" -o "$work_dir/descriptor.dzi"

width=$(sed -n 's/.*Width="\([0-9][0-9]*\)".*/\1/p' "$work_dir/descriptor.dzi")
height=$(sed -n 's/.*Height="\([0-9][0-9]*\)".*/\1/p' "$work_dir/descriptor.dzi")
tile_size=$(sed -n 's/.*TileSize="\([0-9][0-9]*\)".*/\1/p' "$work_dir/descriptor.dzi")

if [[ -z "$width" || -z "$height" || -z "$tile_size" ]]; then
  echo "Nelze přečíst popis snímku ${page} v sadě ${set_id}." >&2
  exit 1
fi

max_dimension=$width
if (( height > max_dimension )); then
  max_dimension=$height
fi

top_level=0
covered=1
while (( covered < max_dimension )); do
  covered=$((covered * 2))
  top_level=$((top_level + 1))
done

if (( requested_level == 998 )); then
  level=$((top_level > 0 ? top_level - 1 : 0))
else
  level=$requested_level
  if (( level > top_level )); then
    level=$top_level
  fi
fi

divisor=1
for ((i=level; i<top_level; i++)); do
  divisor=$((divisor * 2))
done

scaled_width=$(((width + divisor - 1) / divisor))
scaled_height=$(((height + divisor - 1) / divisor))
columns=$(((scaled_width + tile_size - 1) / tile_size))
rows=$(((scaled_height + tile_size - 1) / tile_size))
tile_base=${dzi_url%.dzi}_files/${level}

pids=()
index=0
for ((row=0; row<rows; row++)); do
  for ((column=0; column<columns; column++)); do
    printf -v tile_name 'tile_%04d.jpg' "$index"
    curl -L --fail --silent --show-error -A "$user_agent" -e "$detail_url" \
      "${tile_base}/${column}_${row}.jpg" -o "$work_dir/$tile_name" &
    pids+=("$!")
    if (( ${#pids[@]} == 8 )); then
      for pid in "${pids[@]}"; do
        wait "$pid"
      done
      pids=()
    fi
    index=$((index + 1))
  done
done
for pid in "${pids[@]}"; do
  wait "$pid"
done

mkdir -p -- "$(dirname -- "$output")"
magick montage "$work_dir"/tile_*.jpg -tile "${columns}x${rows}" -geometry +0+0 \
  "$work_dir/montage.jpg"
magick "$work_dir/montage.jpg" -crop "${scaled_width}x${scaled_height}+0+0" +repage "$output"

echo "$output (${scaled_width}x${scaled_height}, úroveň ${level}/${top_level}, sada ${set_id}, snímek ${page})"
