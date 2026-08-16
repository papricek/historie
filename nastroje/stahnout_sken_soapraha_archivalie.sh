#!/usr/bin/env bash

# Stáhne jeden veřejný snímek archiválie (např. sčítacího operátu) z
# eBadatelny SOA Praha.
# Použití: stahnout_sken_soapraha_archivalie.sh ARCHIVALIE_ID SNIMEK VYSTUP
#
# Stabilní citace snímku má tvar https://ebadatelna.soapraha.cz/a/ID/SNIMEK.
# Vlastní obraz používá krátkodobé Wicket URL a cookie; skript je zjistí
# z veřejné stránky a obraz uloží v rámci téže relace.

set -euo pipefail

if (( $# != 3 )); then
  echo "Použití: $0 ARCHIVALIE_ID SNIMEK VYSTUP" >&2
  exit 2
fi

archivalie_id=$1
scan=$2
output=$3

if [[ ! "$archivalie_id" =~ ^[0-9]+$ || ! "$scan" =~ ^[0-9]+$ ]]; then
  echo "ID archiválie a číslo snímku musejí být kladná celá čísla." >&2
  exit 2
fi

work_dir=$(mktemp -d)
user_agent="Mozilla/5.0"
page_url="https://ebadatelna.soapraha.cz/a/${archivalie_id}/${scan}"
curl_args=(-L --fail --silent --show-error -A "$user_agent")

if [[ -n "${SOA_PRAHA_IP:-}" ]]; then
  if [[ ! "$SOA_PRAHA_IP" =~ ^[0-9a-fA-F:.]+$ ]]; then
    echo "SOA_PRAHA_IP nemá platný tvar IP adresy: $SOA_PRAHA_IP" >&2
    exit 2
  fi
  curl_args+=(--resolve "ebadatelna.soapraha.cz:443:${SOA_PRAHA_IP}")
fi

cleanup() {
  rm -rf -- "$work_dir"
}
trap cleanup EXIT

curl "${curl_args[@]}" \
  -c "$work_dir/cookies.txt" "$page_url" -o "$work_dir/page.html"

image_path=$(sed -n \
  's/.*<img id="scanImage"[^>]*src="\.\/\([^"]*\)".*/\1/p' \
  "$work_dir/page.html")

if [[ -z "$image_path" ]]; then
  echo "Na stránce $page_url nebylo nalezeno URL obrazu." >&2
  exit 1
fi

mkdir -p "$(dirname "$output")"
curl "${curl_args[@]}" \
  -b "$work_dir/cookies.txt" \
  "https://ebadatelna.soapraha.cz/a/${archivalie_id}/${image_path}" \
  -o "$output"

if ! magick identify "$output" >/dev/null 2>&1; then
  echo "Stažený soubor není rozpoznaný obraz: $output" >&2
  exit 1
fi

dimensions=$(magick identify -format '%wx%h' "$output")
echo "$output ($dimensions; $page_url)"
