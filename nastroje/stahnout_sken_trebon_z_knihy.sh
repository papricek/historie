#!/usr/bin/env bash

# Najde interní obrazový identifikátor podle veřejného čísla knihy a snímku
# a stáhne snímek pomocí stahnout_sken_trebon.sh.
#
# Použití:
#   stahnout_sken_trebon_z_knihy.sh ID_KNIHY SNIMEK VYSTUP [UROVEN]
#
# Bez UROVNE se požádá o maximum; stahovací skript hodnotu sám omezí na
# nejvyšší úroveň, která je pro daný obraz skutečně dostupná.

set -euo pipefail

if (( $# < 3 || $# > 4 )); then
  echo "Použití: $0 ID_KNIHY SNIMEK VYSTUP [UROVEN]" >&2
  exit 2
fi

book_id=$1
page=$2
output=$3
level=${4:-999}
base="https://digi.ceskearchivy.cz"
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)
preview=$(mktemp)
user_agent="Mozilla/5.0"

cleanup() {
  rm -f -- "$preview"
}
trap cleanup EXIT

preview_url="${base}/pages/preview.php?id=${book_id}&page=${page}&page2=${page}&menu=2&doctree=1nrpI&thumord=3"
curl -L --fail --silent --show-error -A "$user_agent" -e "${base}/" \
  "$preview_url" -o "$preview"

data_id=$(ruby -e '
  html = File.binread(ARGV[0]).gsub(/\\"/, "\x27")
  page = Regexp.escape(ARGV[1])
  fragment = html.scan(/document\.write\("(.*?)"\);/m).flatten.find do |candidate|
    candidate.match?(Regexp.new(%q{[?&]page=} + page + %q{(?!\d)}))
  end
  match = fragment&.match(%r{data1/(\d+)\.0\.thumb})
  abort "Na náhledové stránce se nepodařilo najít požadovaný snímek." unless match
  puts match[1]
' "$preview" "$page")

echo "Kniha ${book_id}, snímek ${page}: data1/${data_id}"
"${script_dir}/stahnout_sken_trebon.sh" "$data_id" "$output" "$level" "$book_id" "$page"
