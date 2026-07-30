#!/usr/bin/env ruby

# Vytvoří domovní pohled, v němž má každý osobní řádek datum nebo mezní data
# přímých dokladů. Zdrojové přepisy se opravují v obyvatele_zahradky_domy.md a
# obyvatele_zahradky_domy/n11.md; generovaný výstup se ručně neupravuje.

require "date"

ROOT = File.expand_path("..", __dir__)
MAIN_PATH = File.join(ROOT, "obyvatele_zahradky_domy.md")
N11_PATH = File.join(ROOT, "obyvatele_zahradky_domy", "n11.md")
OUTPUT_PATH = File.join(ROOT, "obyvatele_zahradky_domy", "dolozene_pobyty.md")

Evidence = Data.define(:house, :date, :person, :detail, :source, :order_note)

def cells(line)
  line.strip.sub(/\A\|/, "").sub(/\|\z/, "").split(/\s*\|\s*/, -1).map(&:strip)
end

def separator_row?(row)
  row.all? { |cell| cell.match?(/\A:?-{3,}:?\z/) }
end

def normalize_house(raw)
  text = raw.to_s.gsub(/[`*]/, "").strip
  return "1a" if text.match?(/(?:\A|\s)1a(?:\z|\s)/i)
  return text if text.match?(/\A\d+\z/)

  match = text.match(/N\s*(\d+)/i) || text.match(/č(?:p\.)?\s*(\d+)/i)
  match && match[1]
end

def valid_person?(raw)
  text = raw.to_s.gsub(/[`*]/, "").strip
  return false if text.empty?
  return false if text.match?(/\A(?:neuveden|otec neuveden|jméno zatím|dosud nepřepsaná matka)\b/i)

  true
end

def add_person(evidence, house_raw, date, person, detail, source, order_note = nil)
  house = normalize_house(house_raw)
  return unless house
  return if house == "11" # N11 se přebírá úplněji ze samostatného indexu.
  return unless valid_person?(person)

  evidence << Evidence.new(
    house: house,
    date: date.to_s.strip,
    person: person.to_s.strip,
    detail: detail.to_s.strip,
    source: source,
    order_note: order_note
  )
end

def date_with_year(date, year)
  text = date.to_s.strip
  return text if text.match?(/\b\d{4}\b/)

  "#{text} #{year}".strip
end

def relocate_main_links(text)
  text.to_s
    .gsub("](prameny_online/", "](../prameny_online/")
    .gsub("](obyvatele_zahradky", "](../obyvatele_zahradky")
end

def add_birth_family(evidence, row, year_label)
  house, child, date, father, mother, status = row
  date = date_with_year(date, year_label)
  source = "[hlavní registr](../obyvatele_zahradky_domy.md)"
  note = status.to_s

  add_person(evidence, house, date, child, "narození / křest; #{note}", source)
  add_person(evidence, house, date, father, "otec při narození dítěte #{child}", source)
  add_person(evidence, house, date, mother, "matka při narození dítěte #{child}", source)
end

def extract_main_evidence
  evidence = []
  h2 = nil
  h3 = nil
  header = nil

  File.foreach(MAIN_PATH, chomp: true) do |line|
    if (match = line.match(/\A## (.+)/))
      h2 = match[1]
      h3 = nil
      header = nil
      next
    end

    if (match = line.match(/\A### (.+)/))
      h3 = match[1]
      header = nil
      next
    end

    unless line.start_with?("|")
      header = nil unless line.strip.empty?
      next
    end

    row = cells(line)
    if header.nil?
      header = row
      next
    end
    next if separator_row?(row)

    case h2
    when "Sčítání lidu 1921"
      next unless header[0] == "Domácnost" && header[1] == "Osoba"
      house = h3.to_s[/\AČ(?:p\.|\.)\s*([^—]+?)\s*—/, 1]
      next unless house

      add_person(
        evidence,
        house,
        "1921 (sčítací arch)",
        row[1],
        row[2],
        "[hlavní registr](../obyvatele_zahradky_domy.md)"
      )
    when "Narození 1788–1796 — celá obec"
      next unless header[0] == "Dům" && header[1] == "Dítě"

      date = if row[4].to_s.include?("1788")
        "13. / 14. 4. 1788"
      elsif row[4].to_s.include?("1790")
        "9. / 10. 10. 1790"
      else
        "1788–1796 (přesný rok zatím nepřepsán)"
      end
      add_person(
        evidence,
        row[0],
        date,
        row[1],
        "narození; dům v dobovém rejstříku; #{row[4]}",
        "[hlavní registr](../obyvatele_zahradky_domy.md)"
      )
    when "Narození 1797 — první úplně přepsaná strana"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1797")
    when "Narození 1798–1799 — inventář snímku 81"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1798–1799")
    when "Narození 1799–1801 — inventář snímku 82"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1799–1801")
    when "Narození 1801–1802 — inventář snímku 83"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1801–1802")
    when "Narození 1802–1804 — inventář snímku 84"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1802–1804")
    when "Narození 1804–1806 — inventář snímku 85"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1804–1806")
    when "Narození 1806–1807 — inventář snímku 86"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1806–1807")
    when "Narození 1808 — inventář snímku 87"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1808")
    when "Narození 1808–1810 — inventář snímku 88"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1808–1810")
    when "Narození 1810–1811 — inventář snímku 89"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1810–1811")
    when "Narození 1811–1812 — inventář snímku 90"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1811–1812")
    when "Narození 1812–1813 — inventář snímku 91"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1812–1813")
    when "Narození 1813–1815 — inventář snímku 92"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1813–1815")
    when "Narození 1815–1816 — inventář snímku 93"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1815–1816")
    when "Narození 1816–1817 — inventář snímku 94"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1816–1817")
    when "Narození 1817–1818 — inventář snímku 95"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1817–1818")
    when "Narození 1819 — inventář snímku 96"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1819")
    when "Další již doložené osoby mimo rok 1921"
      next unless header[0] == "Dům" && header[1] == "Osoba"
      add_person(
        evidence,
        row[0],
        row[2],
        row[1],
        row[3],
        row[4].to_s.empty? ? "[hlavní registr](../obyvatele_zahradky_domy.md)" : relocate_main_links(row[4])
      )
    end
  end

  evidence
end

def extract_n11_evidence
  evidence = []
  safe_section = false
  header = nil

  File.foreach(N11_PATH, chomp: true) do |line|
    if line == "## Bezpečná nebo přímo zapsaná vazba k N11 / čp. 11"
      safe_section = true
      header = nil
      next
    elsif line.start_with?("## ")
      safe_section = false
      header = nil
      next
    end
    next unless safe_section

    unless line.start_with?("|")
      header = nil unless line.strip.empty?
      next
    end

    row = cells(line)
    if header.nil?
      header = row
      next
    end
    next if separator_row?(row)
    next unless header[0] == "ID" && row[0].to_s.start_with?("ZAH-")

    evidence << Evidence.new(
      house: "11",
      date: row[2].to_s.strip,
      person: row[1].to_s.strip,
      detail: "#{row[4].to_s.strip}; adresní posloupnost: #{row[3].to_s.strip}",
      source: row[5].to_s.strip,
      order_note: row[0].to_s.strip
    )
  end

  evidence
end


def years(text)
  text.to_s.scan(/\b(1[5-9]\d{2}|20\d{2})\b/).flatten.map(&:to_i)
end

def first_year(item)
  years(item.date).min || 9999
end

def house_sort_key(house)
  return [1, 0] if house == "1a"

  [house.to_i, 1]
end

def escape_cell(text)
  text.to_s.gsub("|", "\\|").gsub(/\s+/, " ").strip
end

evidence = (extract_main_evidence + extract_n11_evidence).uniq do |item|
  [item.house, item.date, item.person, item.detail, item.order_note]
end
grouped = evidence.group_by(&:house)

lines = []
lines << "# Zahrádka — osoby a doložená období pobytu podle domů"
lines << ""
lines << "Tento soubor je generovaný skriptem `nastroje/vytvorit_domovni_pobyty.rb`."
lines << "Ruční opravy patří do `obyvatele_zahradky_domy.md` nebo do zdrojové evidence"
lines << "pro `obyvatele_zahradky_domy/n11.md`; potom se generátor spustí znovu."
lines << ""
lines << "`Od–do doloženo` znamená nejstarší a nejmladší nalezený datovaný doklad."
lines << "Neznamená to samo o sobě nepřetržité bydliště mezi oběma daty. Jediný křest,"
lines << "sňatek, úmrtí nebo sčítací arch je bodový doklad. U narození spojuje dům s"
lines << "dítětem a se zapsanými rodiči; zrušený řádek snímku 82 se nepočítá podruhé."
lines << "U N11 může pole osobních dat obsahovat také událost před příchodem nebo po"
lines << "odchodu z domu; rozhodující je proto současně uvedená adresní posloupnost."
lines << ""
lines << "## Souhrn domů"
lines << ""
lines << "| Dům | Od–do doloženo | Osobních dokladových řádků |"
lines << "|---|---|---:|"

grouped.keys.sort_by { |house| house_sort_key(house) }.each do |house|
  house_years = grouped.fetch(house).flat_map { |item| years(item.date) }
  interval = if house == "11"
    "1772–1930"
  elsif house_years.empty?
    "datum nevyhodnoceno"
  elsif house_years.min == house_years.max
    house_years.min.to_s
  else
    "#{house_years.min}–#{house_years.max}"
  end
  label = house == "1a" ? "č. 1a" : "N#{house} / čp. #{house}"
  lines << "| #{label} | #{interval} | #{grouped.fetch(house).length} |"
end

grouped.keys.sort_by { |house| house_sort_key(house) }.each do |house|
  label = house == "1a" ? "Č. 1a" : "N#{house} / čp. #{house}"
  items = grouped.fetch(house).sort_by do |item|
    [first_year(item), item.date, item.person, item.order_note.to_s]
  end

  lines << ""
  lines << "## #{label}"
  lines << ""
  if house == "11"
    lines << "Úplný výklad jistot a sporné adresy zůstávají v [domovním indexu N11](n11.md)."
    lines << ""
  end
  lines << "| Doložené datum / období | Osoba | Podklad vazby k domu | ID / pramen |"
  lines << "|---|---|---|---|"
  items.each do |item|
    source = item.order_note ? "#{item.order_note}; #{item.source}" : item.source
    lines << "| #{escape_cell(item.date)} | #{escape_cell(item.person)} | #{escape_cell(item.detail)} | #{escape_cell(source)} |"
  end
end

lines << ""
lines << "## Dosud bez čísla domu"
lines << ""
lines << "Osoby, které pramen spojuje jen s obcí, zůstávají v oddílu"
lines << "[Obyvatelé s dosud nezjištěným domem](../obyvatele_zahradky_domy.md#obyvatelé-s-dosud-nezjištěným-domem)."
lines << "Také Antonie z ledna 1801 na snímku 82 zůstává mimo domovní tabulky, protože"
lines << "číslo v jejím řádku zakrývá tmavý přepis."
lines << ""

File.write(OUTPUT_PATH, lines.join("\n"))
puts "Vytvořeno #{OUTPUT_PATH}: #{evidence.length} dokladových řádků v #{grouped.length} domech."
