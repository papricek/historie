#!/usr/bin/env bash

# Stáhne jeden veřejný Zoomify sken z Digitálního archivu SOA Třeboň.
# Použití: stahnout_sken_trebon.sh DATA_ID VYSTUP [UROVEN] [ID_KNIHY]
# UROVEN 2 bývá přibližně poloviční rozlišení, nejvyšší úroveň se dopočítá.

set -euo pipefail

if (( $# < 2 || $# > 4 )); then
  echo "Použití: $0 DATA_ID VYSTUP [UROVEN] [ID_KNIHY]" >&2
  exit 2
fi

data_id=$1
output=$2
requested_level=${3:-2}
book_id=${4:-6621}
referer="https://digi.ceskearchivy.cz/view.php?menu=3&id=${book_id}&page=P&r=0"
base="https://digi.ceskearchivy.cz/cgi-bin/isrv6.cgi?data1/${data_id}.0"
work_dir=$(mktemp -d)

cleanup() {
  rm -rf -- "$work_dir"
}
trap cleanup EXIT

curl -L --fail --silent --show-error -e "$referer" "${base}.desc" -o "$work_dir/desc.xml"

width=$(sed -n 's/.*WIDTH="\([0-9][0-9]*\)".*/\1/p' "$work_dir/desc.xml")
height=$(sed -n 's/.*HEIGHT="\([0-9][0-9]*\)".*/\1/p' "$work_dir/desc.xml")
tile_size=$(sed -n 's/.*TILESIZE="\([0-9][0-9]*\)".*/\1/p' "$work_dir/desc.xml")

if [[ -z "$width" || -z "$height" || -z "$tile_size" ]]; then
  echo "Nelze přečíst popis skenu ${data_id}." >&2
  exit 1
fi

max_dimension=$width
if (( height > max_dimension )); then
  max_dimension=$height
fi

top_level=0
covered=$tile_size
while (( covered < max_dimension )); do
  covered=$((covered * 2))
  top_level=$((top_level + 1))
done

level=$requested_level
if (( level > top_level )); then
  level=$top_level
fi

divisor=1
for ((i=level; i<top_level; i++)); do
  divisor=$((divisor * 2))
done

scaled_width=$(((width + divisor - 1) / divisor))
scaled_height=$(((height + divisor - 1) / divisor))
columns=$(((scaled_width + tile_size - 1) / tile_size))
rows=$(((scaled_height + tile_size - 1) / tile_size))

index=0
for ((row=0; row<rows; row++)); do
  for ((column=0; column<columns; column++)); do
    printf -v tile_name 'tile_%04d.jpg' "$index"
    curl -L --fail --silent --show-error -e "$referer" \
      "${base}.${level}-${column}-${row}" -o "$work_dir/$tile_name"
    index=$((index + 1))
  done
done

mkdir -p "$(dirname "$output")"
magick montage "$work_dir"/tile_*.jpg -tile "${columns}x${rows}" -geometry +0+0 \
  "$work_dir/montage.jpg"
magick "$work_dir/montage.jpg" -crop "${scaled_width}x${scaled_height}+0+0" +repage "$output"

echo "$output (${scaled_width}x${scaled_height}, úroveň ${level}/${top_level})"
