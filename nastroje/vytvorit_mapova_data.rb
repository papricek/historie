#!/usr/bin/env ruby
# frozen_string_literal: true

# Vytvoří datový soubor website/mapa_data.js pro interaktivní mapu vsi.
# Zdrojem je generovaný domovní přehled obyvatele_zahradky_domy/dolozene_pobyty.md
# a kanonické vrstvy poválečných obyvatel a řezů 1950/1980/2000. Opravy patří
# do zdrojové evidence, potom se spustí generátory a tento skript. Výstup se
# ručně neupravuje.

require "json"
require "csv"

ROOT = File.expand_path("..", __dir__)
SRC = File.join(ROOT, "obyvatele_zahradky_domy", "dolozene_pobyty.md")
SRC_REGISTR = File.join(ROOT, "obyvatele_zahradky_domy.md")
SRC_DNES = File.join(ROOT, "soucasny_stav_domu.md")
SRC_REZY = File.join(ROOT, "rekonstrukce_20_stoleti_data.json")
SRC_OBYVATELE = File.join(ROOT, "obyvatele_1950_2026_data.json")
SRC_VLASTNICI = File.join(ROOT, "vlastnici_2026_kontrolni_list.csv")
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

# Domácnosti, rodiště a povolání ze sčítacích tabulek hlavního registru
# (sloupce: Domácnost | Osoba | Vztah | Rodiště | Povolání). Řádky sčítání
# v domovním přehledu nesou jen vztah; zbytek se dohledá podle jména a vztahu.
def plain(html)
  html.gsub(/<[^>]+>/, "").strip
end

cenzus = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = [] } }
census_house = nil
in_census = false
File.readlines(SRC_REGISTR, chomp: true).each do |line|
  if line.start_with?("## ")
    in_census = line[3..].strip == "Sčítání lidu 1921"
    census_house = nil
    next
  end
  next unless in_census

  if line.start_with?("### ")
    heading = line[4..].strip
    census_house =
      case heading
      when /\AČ\. 1a\b/i then "1a"
      when /\AČp\. (\d+)\b/ then Regexp.last_match(1)
      end
    next
  end
  next unless census_house && line.start_with?("|")

  cells = line.split("|").map(&:strip)
  next if cells.length < 4 || cells[1].start_with?("---") || cells[1] == "Domácnost"

  key = [plain(cell_to_html(cells[2])), plain(cell_to_html(cells[3]))]
  detail = [cells[4], cells[5]].compact.map { |c| cell_to_html(c) }.reject(&:empty?)
  cenzus[census_house][key] << { "h" => cells[1].to_i, "c" => detail.join(" · ") }
end

nesparovano = 0
houses.each do |house|
  fronta = cenzus[house["klic"]]
  next if fronta.empty?

  house["osoby"].each do |o|
    next unless o["d"].include?("1921 (sčítací arch)")

    zaznam = fronta[[plain(o["j"]), plain(o["p"])]].shift
    if zaznam
      o["h"] = zaznam["h"]
      o["c"] = zaznam["c"] unless zaznam["c"].empty?
    else
      nesparovano += 1
    end
  end
end
warn "Nespárovaných řádků sčítání 1921: #{nesparovano}" if nesparovano.positive?

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

# Dnešní stav (2026) ze soucasny_stav_domu.md: tabulka | Čp. | Údaj | Zdroj |.
# Klíč "obec" platí pro celou ves (úvod panelu); ostatní klíče jsou čp.
dnes = Hash.new { |h, k| h[k] = [] }
if File.exist?(SRC_DNES)
  in_table = false
  File.foreach(SRC_DNES, chomp: true) do |line|
    in_table = line.start_with?("## Domy") if line.start_with?("## ")
    next unless in_table && line.start_with?("|")

    cells = line.split("|").map(&:strip)
    next if cells.length < 4 || cells[1].start_with?("---") || cells[1] == "Čp."

    zaznam = { "u" => cell_to_html(cells[2]) }
    zdroj = cells[3] ? cell_to_html(cells[3]) : ""
    zaznam["z"] = zdroj unless zdroj.empty?
    dnes[cells[1]] << zaznam
  end
end

rezy = JSON.parse(File.read(SRC_REZY))
expected_rezy = %w[1950 1980 2000]
unless rezy.fetch("houses").length == 32 &&
       rezy.fetch("houses").values.all? { |h| expected_rezy.all? { |r| h.fetch("snapshots").key?(r) } }
  abort "Neúplná rekonstrukce 20. století v #{SRC_REZY}"
end

obyvatele = JSON.parse(File.read(SRC_OBYVATELE))
expected_houses = (1..32).map(&:to_s)
unless obyvatele.fetch("houses").keys.sort_by(&:to_i) == expected_houses
  abort "Neúplná poválečná evidence v #{SRC_OBYVATELE}"
end

vlastnici = CSV.read(SRC_VLASTNICI, headers: true).to_h { |row| [row.fetch("cp"), row.to_h] }
unless vlastnici.keys.sort_by(&:to_i) == expected_houses
  abort "Neúplný kontrolní list vlastníků v #{SRC_VLASTNICI}"
end

File.open(OUT, "w") do |f|
  f.puts "// Generováno skriptem nastroje/vytvorit_mapova_data.rb z"
  f.puts "// domovního registru, soucasny_stav_domu.md, obyvatele_1950_2026_data.json"
  f.puts "// a rekonstrukce_20_stoleti_data.json — neupravovat ručně."
  f.puts "window.MAPA_DATA = #{JSON.pretty_generate({ 'domy' => houses })};"
  f.puts "window.MAPA_DNES = #{JSON.pretty_generate(dnes)};"
  f.puts "window.MAPA_OBYVATELE = #{JSON.pretty_generate(obyvatele)};"
  f.puts "window.MAPA_VLASTNICI = #{JSON.pretty_generate(vlastnici)};"
  f.puts "window.MAPA_REZY = #{JSON.pretty_generate(rezy)};"
end

# Otisk dat se propíše do <script src="mapa_data.js?v=…"> v mapa.html, aby
# prohlížeč po nasazení nedržel starou verzi dat z mezipaměti.
require "digest"
verze = Digest::SHA256.file(OUT).hexdigest[0, 10]
stranka = File.join(ROOT, "website", "mapa.html")
html = File.read(stranka)
nove = html.sub(/<script src="mapa_data\.js(?:\?v=[0-9a-f]+)?"><\/script>/,
                "<script src=\"mapa_data.js?v=#{verze}\"></script>")
if nove != html
  File.write(stranka, nove)
  puts "mapa.html: verze dat nastavena na #{verze}"
end

puts "#{OUT}: #{houses.length} domovních oddílů, #{total} osobních řádků, " \
     "dnešní stav: #{dnes.values.sum(&:length)} údajů u #{dnes.length} klíčů, " \
     "řezy 20. století: #{rezy.fetch('houses').length} domů"
