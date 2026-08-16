#!/usr/bin/env bash

# Složí jeden veřejný Zoomify obraz z Digitální badatelny SOA Litoměřice.
# Použití: stahnout_sken_litomerice.sh ZOOMIFY_URL VYSTUP [UROVEN]
#
# ZOOMIFY_URL je hodnota `zoomifyImgPath` z veřejného prohlížeče,
# např. https://images.soalitomerice.cz/ximage/.../obraz.jpg
# Bez UROVEN se stáhne nejvyšší dostupná úroveň.

set -euo pipefail

if (( $# < 2 || $# > 3 )); then
  echo "Použití: $0 ZOOMIFY_URL VYSTUP [UROVEN]" >&2
  exit 2
fi

base=${1%/}
output=$2
requested_level=${3:-999}
work_dir=$(mktemp -d)
user_agent="Mozilla/5.0"

cleanup() {
  rm -rf -- "$work_dir"
}
trap cleanup EXIT

curl -L --fail --silent --show-error -A "$user_agent" \
  "$base/ImageProperties.xml" -o "$work_dir/properties.xml"

width=$(sed -n 's/.*WIDTH="\([0-9][0-9]*\)".*/\1/p' "$work_dir/properties.xml")
height=$(sed -n 's/.*HEIGHT="\([0-9][0-9]*\)".*/\1/p' "$work_dir/properties.xml")
tile_size=$(sed -n 's/.*TILESIZE="\([0-9][0-9]*\)".*/\1/p' "$work_dir/properties.xml")

if [[ -z "$width" || -z "$height" || -z "$tile_size" ]]; then
  echo "Nelze přečíst Zoomify popis $base." >&2
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
if (( level < 0 )); then
  echo "Úroveň nesmí být záporná." >&2
  exit 2
fi

level_geometry() {
  local wanted_level=$1
  local divisor=1
  local i
  for ((i=wanted_level; i<top_level; i++)); do
    divisor=$((divisor * 2))
  done
  level_width=$(((width + divisor - 1) / divisor))
  level_height=$(((height + divisor - 1) / divisor))
  level_columns=$(((level_width + tile_size - 1) / tile_size))
  level_rows=$(((level_height + tile_size - 1) / tile_size))
}

tile_offset=0
for ((prior_level=0; prior_level<level; prior_level++)); do
  level_geometry "$prior_level"
  tile_offset=$((tile_offset + level_columns * level_rows))
done

level_geometry "$level"
scaled_width=$level_width
scaled_height=$level_height
columns=$level_columns
rows=$level_rows

index=0
for ((row=0; row<rows; row++)); do
  for ((column=0; column<columns; column++)); do
    global_index=$((tile_offset + row * columns + column))
    tile_group=$((global_index / 256))
    printf -v tile_name 'tile_%04d.jpg' "$index"
    curl -L --fail --silent --show-error -A "$user_agent" \
      "$base/TileGroup${tile_group}/${level}-${column}-${row}.jpg" \
      -o "$work_dir/$tile_name"
    index=$((index + 1))
  done
done

mkdir -p "$(dirname "$output")"
magick montage "$work_dir"/tile_*.jpg -tile "${columns}x${rows}" -geometry +0+0 \
  "$work_dir/montage.jpg"
magick "$work_dir/montage.jpg" \
  -crop "${scaled_width}x${scaled_height}+0+0" +repage "$output"

echo "$output (${scaled_width}x${scaled_height}, úroveň ${level}/${top_level})"
