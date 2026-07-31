#!/usr/bin/env ruby
# frozen_string_literal: true

# Vytvoří datový soubor website/mapa_data.js pro interaktivní mapu vsi.
# Zdrojem je generovaný domovní přehled obyvatele_zahradky_domy/dolozene_pobyty.md;
# opravy patří do zdrojové evidence, potom se spustí vytvorit_domovni_pobyty.rb
# a tento skript. Výstup se ručně neupravuje.

require "json"

ROOT = File.expand_path("..", __dir__)
SRC = File.join(ROOT, "obyvatele_zahradky_domy", "dolozene_pobyty.md")
SRC_REGISTR = File.join(ROOT, "obyvatele_zahradky_domy.md")
OUT = File.join(ROOT, "website", "mapa_data.js")

def html_escape(text)
  text.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
end

# Markdown buňky → malé HTML: tučné role, nejistá čtení, odkazy jen jako text.
def cell_to_html(cell)
  t = html_escape(cell.strip)
  t = t.gsub(/\[([^\]]*)\]\(([^)]*)\)/, '\1')
  t = t.gsub(/\*\*([^*]+)\*\*/, '<b>\1</b>')
  t = t.gsub(/`([^`]+)`/, '<span class="nej">\1</span>')
  t
end

# Sloupec pramenů: veřejné odkazy zůstávají klikací, odkazy do místních souborů
# se vypouštějí i s popiskem; zbylý text (ID, „tentýž zápis…“) se zachová.
def zdroj_to_html(cell)
  t = html_escape(cell.strip)
  t = t.gsub(/\[([^\]]*)\]\((https?:[^)]*)\)/) do
    "<a href=\"#{Regexp.last_match(2)}\" target=\"_blank\" rel=\"noopener\">#{Regexp.last_match(1)}</a>"
  end
  t = t.gsub(/,?\s*\[[^\]]*\]\([^)]*\)/, "")
  t = t.gsub(/\*\*([^*]+)\*\*/, '<b>\1</b>')
  t = t.gsub(/`([^`]+)`/, '<span class="nej">\1</span>')
  t = t.gsub(/\A[\s;,]+|[\s;,]+\z/, "").gsub(/,\s*,/, ", ")
  t
end

# Z volneho ceskeho datoveho udaje odvodi klice pro chronologicke razeni:
# [rok_od, mesic, den] + pripadny rok_do. Bez nalezeneho roku se radi na konec.
def date_keys(text)
  plain = text.gsub(/<[^>]+>/, "")
  years = plain.scan(/\b(1\d{3})\b/).flatten.map(&:to_i)
  return [9999, 99, 99, nil] if years.empty?

  r = years.min
  rr = years.max > r ? years.max : nil
  month = 99
  day = 99
  if (m = plain.match(/(\d{1,2})\.\s*(?:\/\s*\d{1,2}\.\s*)?(\d{1,2})\.\s*(1\d{3})/))
    day = m[1].to_i
    month = m[2].to_i
    r = m[3].to_i if years.length == 1
  end
  [r, month, day, rr]
end

# Rodicovske radky narozeni se na strance vnoruji pod dite.
def parent_role(p_html)
  plain = p_html.gsub(/<[^>]+>/, "")
  return "o" if plain.start_with?("otec při narození dítěte")
  return "m" if plain.start_with?("matka při narození dítěte")

  nil
end

lines = File.readlines(SRC, chomp: true)

houses = []
current = nil
in_summary = false
ranges = {}

lines.each do |line|
  if line.start_with?("## ")
    heading = line[3..].strip
    in_summary = heading == "Souhrn domů"
    current = nil
    next if in_summary || heading == "Dosud bez čísla domu"

    key =
      case heading
      when /\AČ\. 1a\z/i then "1a"
      when /\AN(\d+)\s*\/\s*čp\. \d+\z/ then Regexp.last_match(1)
      else
        warn "Nerozpoznaný nadpis domu: #{heading}"
        next
      end
    current = { "klic" => key, "nazev" => heading, "osoby" => [] }
    houses << current
    next
  end

  next unless line.start_with?("|")

  cells = line.split("|").map(&:strip)
  # cells[0] je prázdné před první svislicí
  next if cells.length < 4 || cells[1].start_with?("---") || cells[1] == "Dům" ||
          cells[1] == "Doložené datum / období"

  if in_summary
    ranges[cells[1]] = { "rozsah" => cells[2], "radku" => cells[3].to_i }
    next
  end

  next unless current

  radek = {
    "d" => cell_to_html(cells[1]),
    "j" => cell_to_html(cells[2]),
    "p" => cell_to_html(cells[3]),
  }
  zdroj = cells[4] ? zdroj_to_html(cells[4]) : ""
  radek["z"] = zdroj unless zdroj.empty?
  current["osoby"] << radek
end

# Osoby bez zjištěného domu z hlavního registru (sloupce: Osoba | Datum |
# Role | Pramen | Starší ID) — na mapě jako samostatná dlaždice.
nezjisteni = { "klic" => "x", "nazev" => "Dům nezjištěn", "osoby" => [] }
in_section = false
File.readlines(SRC_REGISTR, chomp: true).each do |line|
  if line.start_with?("## ")
    in_section = line[3..].strip == "Obyvatelé s dosud nezjištěným domem"
    next
  end
  next unless in_section && line.start_with?("|")

  cells = line.split("|").map(&:strip)
  next if cells.length < 6 || cells[1].start_with?("---") || cells[1] == "Osoba"

  radek = {
    "d" => cell_to_html(cells[2]),
    "j" => cell_to_html(cells[1]),
    "p" => cell_to_html(cells[3]),
  }
  # popisky pramenů zde nesou informaci (Berní rula, adresář 1915) — zachovat text
  zdroj = [cell_to_html(cells[4]), cell_to_html(cells[5])].reject(&:empty?).join(" · ")
  radek["z"] = zdroj unless zdroj.empty?
  nezjisteni["osoby"] << radek
end
if nezjisteni["osoby"].any?
  roky = nezjisteni["osoby"].flat_map { |o| o["d"].scan(/\b1\d{3}\b/) }.map(&:to_i)
  nezjisteni["rozsah"] = roky.empty? ? "?" : "#{roky.min}–#{roky.max}"
  houses << nezjisteni
end

houses.each do |house|
  house["osoby"].each_with_index do |o, i|
    r, month, day, rr = date_keys(o["d"])
    o["r"] = r unless r == 9999
    o["rr"] = rr if rr
    rod = parent_role(o["p"])
    o["rod"] = rod if rod
    o["_sort"] = [r, month, day, i]
  end
  house["osoby"].sort_by! { |o| o.delete("_sort") }
end

houses.each do |house|
  next if house["klic"] == "x"

  range_key = ranges.keys.find do |k|
    k == house["nazev"] || (house["klic"] == "1a" && k =~ /\Ač\. 1a\z/i)
  end
  info = ranges[range_key]
  house["rozsah"] = info ? info["rozsah"] : "?"
  if info && info["radku"] != house["osoby"].length
    warn "Nesouhlasí počet řádků u #{house['nazev']}: souhrn #{info['radku']}, tabulka #{house['osoby'].length}"
  end
end

total = houses.sum { |h| h["osoby"].length }

File.open(OUT, "w") do |f|
  f.puts "// Generováno skriptem nastroje/vytvorit_mapova_data.rb z"
  f.puts "// obyvatele_zahradky_domy/dolozene_pobyty.md — neupravovat ručně."
  f.puts "window.MAPA_DATA = #{JSON.pretty_generate({ 'domy' => houses })};"
end

puts "#{OUT}: #{houses.length} domů, #{total} osobních řádků"
