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
  return false if text.match?(/\Ajméno (?:otce|matky|dítěte) nejasné\b/i)

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
  event_type = if date.match?(/bez křtu/i) || child.match?(/nepokřtěné|mrtvě narozené/i) || note.match?(/bez křtu/i)
    "narození"
  else
    "narození / křest"
  end

  add_person(evidence, house, date, child, "#{event_type}; #{note}", source)
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
    when "Narození 1820–1821 — inventář snímku 97"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      # N1 je již zachyceno v oddílu přesně adresovaných starších osob; N11 se
      # obecně přebírá z úplnějšího samostatného indexu.
      next if normalize_house(row[0]) == "1"
      add_birth_family(evidence, row, "1820–1821")
    when "Narození 1821–1822 — inventář snímku 98"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1821–1822")
    when "Narození 1822–1823 — inventář snímku 99"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1822–1823")
    when "Narození 1823–1824 — inventář snímku 100"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1823–1824")
    when "Narození 1824 — inventář snímku 101"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1824")
    when "Narození 1824–1825 — inventář snímku 102"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1824–1825")
    when "Narození 1825–1826 — inventář snímku 103"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1825–1826")
    when "Narození 1826 — inventář snímku 104"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1826")
    when "Narození 1826–1828 — inventář snímku 105"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1826–1828")
    when "Narození 1828 — inventář snímku 106"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1828")
    when "Narození 1829 — inventář snímku 107"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1829")
    when "Narození 1830–1831 — inventář snímku 108"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1830–1831")
    when "Narození 1831–1833 — inventář snímku 109"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1831–1833")
    when "Narození 1833–1834 — inventář snímku 110"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1833–1834")
    when "Narození 1834–1835 — inventář snímku 111"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1834–1835")
    when "Narození 1836–1837 — inventář snímku 112"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1836–1837")
    when "Narození 1838–1839 — inventář snímku 113"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1838–1839")
    when "Narození 1839–1840 — inventář snímku 114"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1839–1840")
    when "Narození 1840–1841 — inventář snímku 115"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1840–1841")
    when "Narození 1841–1842 — inventář snímku 116"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1841–1842")
    when "Narození 1842–1843 — inventář snímku 117"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1842–1843")
    when "Narození 1844–1845 — inventář snímku 309 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1844–1845")
    when "Narození 1845–1846 — inventář snímku 310 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1845–1846")
    when "Narození 1846 — inventář snímku 311 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1846")
    when "Narození 1847 — inventář snímku 312 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1847")
    when "Narození 1848 — inventář snímku 313 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1848")
    when "Narození 1849 — inventář snímku 315 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      # Anna Fraňková a její rodiče v N1 jsou již vedeni mezi přesně
      # adresovanými staršími osobami, proto se z rodného inventáře neopakují.
      next if normalize_house(row[0]) == "1"
      add_birth_family(evidence, row, "1849")
    when "Narození 1850 — inventář snímku 316 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1850")
    when "Narození 1850–1851 — inventář snímku 317 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1850–1851")
    when "Narození 1851–1852 — inventář snímku 318 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1851–1852")
    when "Narození 1852–1853 — inventář snímku 319 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1852–1853")
    when "Narození 1854 — inventář snímku 320 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1854")
    when "Narození 1854–1855 — inventář snímku 321 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1854–1855")
    when "Narození 1855–1856 — inventář snímku 322 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1855–1856")
    when "Narození 1856–1857 — inventář snímku 323 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1856–1857")
    when "Narození 1857–1858 — inventář snímku 324 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1857–1858")
    when "Narození 1857–1858 — inventář snímku 325 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1857–1858")
    when "Narození 1858–1859 — inventář snímku 326 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1858–1859")
    when "Narození 1859 — inventář snímku 327 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1859")
    when "Narození 1860 — inventář snímku 328 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1860")
    when "Narození 1860–1861 — inventář snímku 329 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1860–1861")
    when "Narození 1861–1862 — inventář snímku 330 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1861–1862")
    when "Narození 1862–1863 — inventář snímku 331 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1862–1863")
    when "Narození 1863–1864 — inventář snímku 332 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1863–1864")
    when "Narození 1864–1865 — inventář snímku 333 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1864–1865")
    when "Narození 1865 — inventář snímku 334 knihy 6621"
      next unless header[0] == "Dům" && header[1] == "Dítě"
      add_birth_family(evidence, row, "1865")
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
