#!/usr/bin/env ruby

# Vytvoří kompaktní domovní index N11 / čp. 11 z podrobné osobní evidence.
# Zdrojový soubor zůstává autoritativní pro interpretaci, jistotu a úplné poznámky;
# tento výstup zpřístupňuje stejné osoby v registru uspořádaném podle domů.

require "fileutils"

root = File.expand_path("..", __dir__)
source_path = File.join(root, "obyvatele_zahradky.md")
output_path = File.join(root, "obyvatele_zahradky_domy", "n11.md")

text = File.read(source_path, encoding: "UTF-8")
section = text
  .split("## Osoby doložené v hlavním statku", 2)
  .fetch(1)
  .split("## Chronologický rejstřík", 2)
  .first

def rebase_local_links(value)
  value.gsub(/\]\((?!https?:|mailto:|#|\/|\.\.\/)([^)]+)\)/, '](../\1)')
end

rows = section.lines.filter_map do |line|
  next unless line.start_with?("| ZAH-")

  cells = line.split("|").map(&:strip)
  {
    id: cells.fetch(1),
    person: cells.fetch(2),
    date: cells.fetch(3),
    house: cells.fetch(4),
    role: cells.fetch(5),
    source: rebase_local_links(cells.fetch(7))
  }
end

exact = rows.select do |row|
  row[:house].match?(/(?:N11|č\. 11)/) && !row[:house].match?(/sporné/i)
end
disputed = rows.select do |row|
  row[:house].match?(/N11/) && row[:house].match?(/sporné/i)
end

def markdown_rows(rows)
  rows.map do |row|
    "| #{row[:id]} | #{row[:person]} | #{row[:date]} | #{row[:house]} | #{row[:role]} | #{row[:source]} |"
  end.join("\n")
end

output = <<~MARKDOWN
  # Zahrádka N11 / čp. 11 — domovní index osob

  Kompaktní domovní pohled na osoby z podrobné
  [evidence hlavního statku](../obyvatele_zahradky.md#osoby-doložené-v-hlavním-statku-čp-11--st-1).
  Soubor je generován skriptem `nastroje/vytvorit_index_n11.rb`; ruční opravy patří
  do zdrojové evidence a poté se výstup znovu vytvoří.

  Každý řádek označuje jednu evidovanou osobu, nikoli nutně jednu událost. Tatáž
  osoba může mít v časové posloupnosti také jiný dům a osm obyvatel sčítání 1921 je
  současně uvedeno v hlavním [registru celé vsi](../obyvatele_zahradky_domy.md).
  Proto se tento počet nesmí přičítat k jiným obdobím jako počet unikátních lidí.

  ## Bezpečná nebo přímo zapsaná vazba k N11 / čp. 11

  **#{exact.length} osobních řádků.** Adresní sloupec zachovává případné dřívější či
  pozdější adresy, aby přesuny mezi domy nezanikly.

  | ID | Osoba | Datum / období | Adresní posloupnost | Událost nebo role | Pramen |
  |---|---|---|---|---|---|
  #{markdown_rows(exact)}

  ## Adresně sporná rodina N11 / N14

  Tyto řádky nejsou započteny mezi #{exact.length} bezpečných vazeb. Dvě paralelní
  knihy se u téhož křtu Václava Lenze z března 1791 rozcházejí mezi N11 a N14.

  | ID | Osoba | Datum / období | Sporná adresa | Událost nebo role | Pramen |
  |---|---|---|---|---|---|
  #{markdown_rows(disputed)}
MARKDOWN

FileUtils.mkdir_p(File.dirname(output_path))
File.write(output_path, output, encoding: "UTF-8")
puts "#{output_path}: #{exact.length} přesných, #{disputed.length} sporné"
