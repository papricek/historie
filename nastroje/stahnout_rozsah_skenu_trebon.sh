#!/usr/bin/env bash

# Stáhne souvislý rozsah veřejných snímků jedné knihy SOA Třeboň.
# Použití: stahnout_rozsah_skenu_trebon.sh ID_KNIHY PRVNI POSLEDNI SLOZKA [UROVEN]

set -euo pipefail

if (( $# < 4 || $# > 5 )); then
  echo "Použití: $0 ID_KNIHY PRVNI_SNIMEK POSLEDNI_SNIMEK VYSTUPNI_SLOZKA [UROVEN]" >&2
  exit 2
fi

book_id=$1
first_page=$2
last_page=$3
output_dir=$4
level=${5:-999}
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)

if (( first_page > last_page )); then
  echo "První snímek musí být menší nebo roven poslednímu." >&2
  exit 2
fi

mkdir -p -- "$output_dir"

for ((page=first_page; page<=last_page; page++)); do
  printf -v output_file '%s/snim_%03d.jpg' "$output_dir" "$page"
  "${script_dir}/stahnout_sken_trebon_z_knihy.sh" \
    "$book_id" "$page" "$output_file" "$level"
done
