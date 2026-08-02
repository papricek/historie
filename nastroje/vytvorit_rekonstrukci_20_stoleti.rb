#!/usr/bin/env ruby
# frozen_string_literal: true

# Vytvoří čitelný odrážkový katalog rekonstrukce 1950/1980/2000.
# Jediným zdrojem údajů pro tento výstup a mapu je
# rekonstrukce_20_stoleti_data.json; výsledný Markdown se ručně neupravuje.

require "json"

ROOT = File.expand_path("..", __dir__)
SRC = File.join(ROOT, "rekonstrukce_20_stoleti_data.json")
OUT = File.join(ROOT, "rekonstrukce_20_stoleti.md")
YEARS = %w[1950 1980 2000].freeze

data = JSON.parse(File.read(SRC))
houses = data.fetch("houses")
snapshots = data.fetch("snapshots")

expected = (1..32).map(&:to_s)
missing_houses = expected - houses.keys
extra_houses = houses.keys - expected
abort "Chybějí domy: #{missing_houses.join(', ')}" unless missing_houses.empty?
abort "Neočekávané domy: #{extra_houses.join(', ')}" unless extra_houses.empty?

allowed_building = %w[documented probable unknown absent].freeze
allowed_people = %w[direct strong gap none not_applicable].freeze
houses.each do |key, house|
  YEARS.each do |year|
    cut = house.fetch("snapshots").fetch(year)
    abort "#{key}/#{year}: neznámý stav stavby" unless allowed_building.include?(cut["building_state"])
    abort "#{key}/#{year}: neznámý stav osob" unless allowed_people.include?(cut["people_state"])
    %w[building people anchor].each { |field| cut.fetch(field) }
  end
end

building_labels = {
  "documented" => "doložená",
  "probable" => "pravděpodobná",
  "unknown" => "nezjištěná",
  "absent" => "dnešní číslo / objekt ještě neexistoval",
}
people_labels = {
  "direct" => "přímé přiřazení",
  "strong" => "silná opora, ale ne přímé přiřazení",
  "gap" => "časová opora mimo rozhodný rok",
  "none" => "bez jmenného dokladu",
  "not_applicable" => "řez se na dnešní číslo nevztahuje",
}

direct = Hash.new(0)
strong = Hash.new(0)
houses.each_value do |house|
  YEARS.each do |year|
    state = house.dig("snapshots", year, "people_state")
    direct[year] += 1 if state == "direct"
    strong[year] += 1 if state == "strong"
  end
end

lines = []
lines << "# Rekonstrukce obyvatel domů ve 20. století"
lines << ""
lines << "Odrážkový katalog celé Zahrádky u Pošné po jednotlivých číslech domu. " \
         "Stav rešerše k #{data.fetch('updated').split('-').reverse.join('. ')}. " \
         "Generováno z [kanonických dat](rekonstrukce_20_stoleti_data.json); tento soubor se ručně neupravuje."
lines << ""
lines << "## Jak výsledek číst"
lines << ""
lines << "- **Stavba** odpovídá jen tomu, co lze doložit pro adresní číslo nebo místo. " \
         "Viditelná střecha není automaticky důkazem stejného čp. ani stejných zdí."
lines << "- **Lidé** jsou k rozhodnému roku přiřazeni jen tehdy, když datovaný pramen " \
         "výslovně uvádí stejné čp."
lines << "- **Osobní účastnická adresa 2000** přesně spojuje jméno s obcí a čp. v bytovém " \
         "seznamu platném do dubna 2000. Je to silná časová opora, ale ne automatický " \
         "doklad trvalého bydliště ani úplné domácnosti."
lines << "- **Nejbližší opora** je vodítko pro další hledání. Není to hotové přiřazení " \
         "k roku 1950, 1980 nebo 2000."
lines << "- Počet domů ze sčítání znamená sčítané domy v obci, nikoli automaticky " \
         "souvislou řadu čp. ani počet všech stojících objektů."
lines << "- Priority: **A** = klíčový historický nebo stále neuzavřený dům; " \
         "**B** = novější či adresně nejisté číslo; **C** = bezpečně až po roce 2000."
lines << ""
lines << "## Skutečné pokrytí"
lines << ""
lines << "- **1950:** 99 obyvatel / 26 sčítaných domů; přímé jméno u čp. " \
         "#{direct['1950']}, silná nepřímá opora #{strong['1950']}."
lines << "- **1980:** 51 obyvatel / 16 sčítaných domů; přímé jméno u čp. " \
         "#{direct['1980']}, silná nepřímá opora #{strong['1980']}."
lines << "- **2000:** mezi sčítáními 1991 (29 obyvatel / 18 domů) a 2001 " \
         "(28 obyvatel / 18 domů); přímé jméno u čp. #{direct['2000']}, " \
         "silná nepřímá opora #{strong['2000']}."
lines << "- Jediné současné přímé přiřazení v cílových řezech je **Václav Bulant, " \
         "čp. 28, rok 2000**; jistota konkrétní adresy je vysoká, jistota lokality " \
         "rejstříkového zápisu střední."
lines << "- Český telefon 2000 přidal přesné účastnické adresy na čp. **5, 6, 7, 8, 16, " \
         "21, 24, 27, 28 a 29**. Devět se opakuje v edici 2004; čp. 29 získalo první " \
         "nalezenou poválečnou osobní stopu."
lines << ""
lines << "## Dům po domu"

houses.sort_by { |key, _| key.to_i }.each do |key, house|
  lines << ""
  lines << "### #{house.fetch('label')}"
  lines << ""
  lines << "- **Priorita:** #{house.fetch('priority')}"
  YEARS.each do |year|
    cut = house.fetch("snapshots").fetch(year)
    lines << "- **#{year}**"
    lines << "  - **Stavba — #{building_labels.fetch(cut.fetch('building_state'))}:** #{cut.fetch('building')}"
    lines << "  - **Lidé — #{people_labels.fetch(cut.fetch('people_state'))}:** #{cut.fetch('people')}"
    lines << "  - **Nejbližší opora:** #{cut.fetch('anchor')}"
    lines << "  - **Co chybí:** #{cut["missing"] || snapshots.fetch(year).fetch('default_missing')}"
  end
end

lines << ""
lines << "## Nezařazení pováleční lidé"
lines << ""
lines << "- **50. léta, pouze obec:** rodina Coufalova; předseda JZD Rohovec; " \
         "tajemník Josef Pachta; účetní Kejval; František Kříž a Křížová; " \
         "Svoboda, Kejvalová a Rohovcová; Zdeněk a Emil Svobodovi; Václav " \
         "Bulant; vedoucí prodejny Jaroslav Plášil."
lines << "- **60.–80. léta, pouze obec:** J. Kudrna; Marie Plášilová; Jan Zelenka; " \
         "Marie Bartošková; František Kříž; Jan, Anežka a Karel Kejvalovi; " \
         "František Rohovec."
lines << "- **Rok 1978:** doloženo je 34 družstevníků bydlících v Zahrádce " \
         "(17 důchodců, dvě ženy na mateřské, 15 pracujících), ale bez čp."
lines << ""
lines << "## Prameny, které mezery uzavřou"
lines << ""
lines << "- **1950 přímo:** Národní archiv, Národní sčítání lidu 1950, NAD 984 — " \
         "[formulář žádosti o operáty](https://www.nacr.cz/verejnost/badatelna/formulare/ze-scitacich-operatu-na-uzemi-byvaleho-ceskoslovenska)."
lines << "- **Most 1948–1951:** [AO Zahrádka, NAD 1334](https://portal.nacr.cz/aron/apu/83298f4c-5f90-4ef9-8caa-0c8ccfc69353) " \
         "a [MNV Zahrádka, NAD 1335](https://portal.nacr.cz/aron/apu/1a1d03ad-79f2-40d0-807c-c447fd08f2c5)."
lines << "- **1980:** [MNV Útěchovičky, NAD 1262](https://portal.nacr.cz/aron/apu/16e489c1-dc65-4e14-8160-b427510d8a25) — " \
         "domovní seznamy do roku 1978; potom evidence MNV Pošná."
lines << "- **1980–2000:** [MNV Pošná, NAD 1544](https://portal.nacr.cz/aron/apu/54847c40-9fe6-4a9a-879c-5da368791582) — " \
         "kronika a domovní/personální přílohy."
lines << "- **Rok 2000, veřejní telefonní účastníci:** [Český telefon 2000](https://archive.org/details/czchip200012cd) " \
         "je už kompletně vytěžen; deset přesných vazeb je zapsáno u domů. Pro úplné " \
         "domácnosti stále chybí pobytová nebo domovní evidence."
lines << "- **Stavby a zaniklá čp.:** stavební agenda MNV Útěchovičky, MNV Pošná " \
         "a MěÚ Pacov; propojit s leteckými snímky 1949–2001."
lines << "- Připravený text žádosti je v [zadost_o_archivni_prameny.md](zadost_o_archivni_prameny.md); " \
         "žádost zatím nebyla odeslána."
lines << ""
lines << "## Publikační pravidlo"
lines << ""
lines << "- U osob, které mohou žít, se nezveřejňují data narození, rodinné poměry " \
         "ani jiné nadbytečné osobní údaje."
lines << "- Rozdíl proti obecnímu součtu se nezakrývá. Označuje chybějící arch, " \
         "prázdný dům, samotu, institucionální objekt nebo rozdílnou sčítací definici."

File.write(OUT, lines.join("\n") + "\n")
puts "#{OUT}: #{houses.length} domů, #{houses.length * YEARS.length} domovních řezů"
