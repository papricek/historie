#!/usr/bin/env ruby
# frozen_string_literal: true

# Vytvoří čitelný odrážkový katalog poválečných obyvatel po domech.
# Kanonická data jsou v obyvatele_1950_2026_data.json; Markdown se ručně
# neupravuje. Časový interval znamená jen rozsah konkrétního dokladu.

require "json"
require "csv"
require "uri"

ROOT = File.expand_path("..", __dir__)
SRC = File.join(ROOT, "obyvatele_1950_2026_data.json")
RECON_SRC = File.join(ROOT, "rekonstrukce_20_stoleti_data.json")
OUT = File.join(ROOT, "obyvatele_1950_2026.md")
AUDIT_OUT = File.join(ROOT, "mezery_obyvatel_1950_2026.csv")
OWNERS_SRC = File.join(ROOT, "vlastnici_2026_kontrolni_list.csv")

def cz_integer(value)
  value.to_s.reverse.scan(/.{1,3}/).join(" ").reverse
end

data = JSON.parse(File.read(SRC))
reconstruction = JSON.parse(File.read(RECON_SRC))
houses = data.fetch("houses")
types = data.fetch("evidence_types")
house_context = data.fetch("current_house_context")
current_telephone_audit = data.fetch("current_telephone_audit")
archival_audit = data.fetch("archival_source_audit")
cdk_audit = data.fetch("cdk_fulltext_audit")
telephone_2000_audit = data.fetch("telephone_directory_2000_audit")
telephone_audit = data.fetch("telephone_directory_audit")
niv_audit = data.fetch("niv_register_audit")
contract_audit = data.fetch("public_contract_audit")
ownership_audit = data.fetch("ownership_source_audit")
municipal_audit = data.fetch("municipal_fulltext_audit")
official_board_audit = data.fetch("official_board_audit")
trade_audit = data.fetch("trade_register_audit")
agricultural_audit = data.fetch("agricultural_register_audit")
subsidy_audit = data.fetch("subsidy_register_audit")
election_audit = data.fetch("election_register_audit")
owner_rows = CSV.read(OWNERS_SRC, headers: true).to_h { |row| [row.fetch("cp"), row.to_h] }
expected = (1..32).map(&:to_s)
abort "Chybějí čp.: #{(expected - houses.keys).join(', ')}" unless (expected - houses.keys).empty?
abort "Neočekávaná čp.: #{(houses.keys - expected).join(', ')}" unless (houses.keys - expected).empty?
reconstruction_houses = reconstruction.fetch("houses")
abort "Nesouhlasí čp. v rekonstrukci" unless reconstruction_houses.keys.sort == houses.keys.sort
abort "Nesouhlasí čp. v kontrolním listu vlastníků" unless owner_rows.keys.sort_by(&:to_i) == expected

allowed_certainty = %w[vysoká střední nízká].freeze
houses.each do |key, house|
  house.fetch("label")
  house.fetch("building")
  house.fetch("evidence").each do |item|
    %w[person period type certainty detail source publish].each { |field| item.fetch(field) }
    abort "#{key}: neznámý typ #{item['type']}" unless types.key?(item["type"])
    abort "#{key}: neznámá jistota #{item['certainty']}" unless allowed_certainty.include?(item["certainty"])
    if item.key?("current_2026") && ![true, false].include?(item["current_2026"])
      abort "#{key}: current_2026 musí být true/false"
    end
  end
  house.fetch("ownership", []).each do |item|
    %w[person period relation certainty detail source publish].each { |field| item.fetch(field) }
    abort "#{key}: neznámá jistota vlastnictví #{item['certainty']}" unless allowed_certainty.include?(item["certainty"])
  end
  house.fetch("ownership_context", []).each do |item|
    %w[person period relation certainty detail source publish].each { |field| item.fetch(field) }
    abort "#{key}: neznámá jistota majetkového kontextu #{item['certainty']}" unless allowed_certainty.include?(item["certainty"])
  end
end

data.fetch("village_only").each do |item|
  %w[period people note].each { |field| item.fetch(field) }
  if item.key?("certainty") && !allowed_certainty.include?(item.fetch("certainty"))
    abort "Obecní stopa #{item.fetch('period')}: neznámá jistota #{item.fetch('certainty')}"
  end
  if item.key?("url") && !item.key?("source")
    abort "Obecní stopa #{item.fetch('period')}: URL bez názvu pramene"
  end
end

house_context.each do |item|
  %w[period houses detail limits source url].each { |field| item.fetch(field) }
  unknown_houses = item.fetch("houses") - expected
  abort "Technická stopa obsahuje neznámá čp.: #{unknown_houses.join(', ')}" unless unknown_houses.empty?
end

%w[period source url exact_known_names_checked named_results locality_only_query_available phone_numbers_exported new_exact_person_links new_residence_links method findings limits].each do |field|
  current_telephone_audit.fetch(field)
end
abort "Současný telefonní audit vyvezl telefonní čísla" unless current_telephone_audit.fetch("phone_numbers_exported").zero?
abort "Současný telefonní audit má neočekávanou osobní vazbu" unless current_telephone_audit.fetch("new_exact_person_links").zero?
abort "Současný telefonní audit má neočekávaný pobytový zásah" unless current_telephone_audit.fetch("new_residence_links").zero?
abort "Současný telefonní audit má nelogický počet výsledků" if current_telephone_audit.fetch("named_results") > current_telephone_audit.fetch("exact_known_names_checked")

%w[period method new_exact_person_links new_residence_links sources findings limits].each do |field|
  archival_audit.fetch(field)
end
abort "Archivní audit má neočekávaný pobytový zásah" unless archival_audit.fetch("new_residence_links").zero?
abort "Archivní audit má neočekávanou přesnou osobní vazbu" unless archival_audit.fetch("new_exact_person_links").zero?
archival_audit.fetch("sources").each do |item|
  %w[checkpoint source url catalog_scope digital_objects attachments result].each { |field| item.fetch(field) }
  abort "Archivní audit má neznámý kontrolní rok" unless %w[1950 1980 2000].include?(item.fetch("checkpoint"))
  abort "Archivní audit má neočekávaný digitální objekt" unless item.fetch("digital_objects").zero?
  if item.key?("supporting_source") || item.key?("supporting_url")
    item.fetch("supporting_source")
    item.fetch("supporting_url")
  end
end

%w[period source url query documents_found public_documents collections new_exact_postwar_person_links new_residence_links method findings false_matches limits result_path].each do |field|
  cdk_audit.fetch(field)
end
abort "Audit ČDK má nelogický počet veřejných stran" if cdk_audit.fetch("public_documents") > cdk_audit.fetch("documents_found")
abort "Audit ČDK má neočekávanou novou poválečnou vazbu" unless cdk_audit.fetch("new_exact_postwar_person_links").zero?
abort "Audit ČDK má neočekávaný pobytový zásah" unless cdk_audit.fetch("new_residence_links").zero?
abort "Audit ČDK míří na jinou obec" unless cdk_audit.fetch("query").include?("Zahrádka u Pošné")

%w[period source url source_bin_sha1 source_bin_md5 source_bin_sha256 iso_sha256 database_sha256 locality advertised_numbers personal_table_rows business_table_rows table_rows_total advertised_minus_table_rows personal_matches business_matches house_numbers phone_numbers_exported new_exact_person_links new_residence_links new_house_links corroborated_by_2004_person_links method findings limits].each do |field|
  telephone_2000_audit.fetch(field)
end
{
  "source_bin_sha1" => 40,
  "source_bin_md5" => 32,
  "source_bin_sha256" => 64,
  "iso_sha256" => 64,
  "database_sha256" => 64
}.each do |field, length|
  abort "Telefonní audit 2000 má neplatný #{field}" unless telephone_2000_audit.fetch(field).match?(/\A[0-9a-f]{#{length}}\z/)
end
abort "Telefonní audit 2000 míří na jinou lokalitu" unless telephone_2000_audit.fetch("locality") == "Zahrádka u Pošné"
abort "Telefonní audit 2000 má nesouhlasný součet tabulek" unless telephone_2000_audit.fetch("personal_table_rows") + telephone_2000_audit.fetch("business_table_rows") == telephone_2000_audit.fetch("table_rows_total")
abort "Telefonní audit 2000 má nesouhlasný rozdíl proti obalu" unless telephone_2000_audit.fetch("advertised_numbers") - telephone_2000_audit.fetch("table_rows_total") == telephone_2000_audit.fetch("advertised_minus_table_rows")
abort "Telefonní audit 2000 vyvezl telefonní čísla" unless telephone_2000_audit.fetch("phone_numbers_exported").zero?
abort "Telefonní audit 2000 má neočekávaný pobytový zásah" unless telephone_2000_audit.fetch("new_residence_links").zero?
abort "Telefonní audit 2000 má nesouhlasný počet přesných vazeb" unless telephone_2000_audit.fetch("new_exact_person_links") == telephone_2000_audit.fetch("personal_matches")
abort "Telefonní audit 2000 má nesouhlasný počet nových domů" unless telephone_2000_audit.fetch("new_house_links") == 1
unknown_telephone_2000_houses = telephone_2000_audit.fetch("house_numbers") - expected
abort "Telefonní audit 2000 obsahuje neznámá čp.: #{unknown_telephone_2000_houses.join(', ')}" unless unknown_telephone_2000_houses.empty?

telephone_2000_items = houses.flat_map do |key, house|
  house.fetch("evidence")
       .select do |item|
         item.fetch("type") == "telephone_subscriber_address" &&
           item.fetch("url", "") == telephone_2000_audit.fetch("url")
       end
       .map { |item| [key, item] }
end
expected_telephone_2000_people = {
  "5" => "Petr Veverka", "6" => "Zdeněk Svoboda", "7" => "Karel Adam",
  "8" => "Marie Křížová", "16" => "Miroslav Kubiska", "21" => "Václav Dörrschmidt",
  "24" => "Ing. Jan Velich", "27" => "Ludmila Rohovcová", "28" => "Václav Bulant",
  "29" => "Bohuslav Nacházel"
}.freeze
abort "Nesouhlasí počet osobních řádků telefonu 2000" unless telephone_2000_items.length == telephone_2000_audit.fetch("personal_matches")
abort "Nesouhlasí čp. telefonu 2000" unless telephone_2000_items.map(&:first).uniq.sort_by(&:to_i) == telephone_2000_audit.fetch("house_numbers").sort_by(&:to_i)
abort "Nesouhlasí osoby telefonu 2000" unless telephone_2000_items.to_h.transform_values { |item| item.fetch("person") } == expected_telephone_2000_people

%w[period source url iso_sha256 database_sha256 locality locality_id advertised_personal_numbers advertised_business_numbers personal_data_pages business_data_pages personal_matches business_matches house_numbers phone_numbers_exported new_exact_person_links new_residence_links method findings limits].each do |field|
  telephone_audit.fetch(field)
end
%w[iso_sha256 database_sha256].each do |field|
  abort "Telefonní audit má neplatný #{field}" unless telephone_audit.fetch(field).match?(/\A[0-9a-f]{64}\z/)
end
abort "Telefonní audit míří na jinou lokalitu" unless telephone_audit.fetch("locality") == "Zahrádka u Pošné" && telephone_audit.fetch("locality_id") == 9231
abort "Telefonní audit vyvezl telefonní čísla" unless telephone_audit.fetch("phone_numbers_exported").zero?
abort "Telefonní audit má neočekávaný pobytový zásah" unless telephone_audit.fetch("new_residence_links").zero?
abort "Telefonní audit má nesouhlasný počet přesných vazeb" unless telephone_audit.fetch("new_exact_person_links") == telephone_audit.fetch("personal_matches")
unknown_telephone_houses = telephone_audit.fetch("house_numbers") - expected
abort "Telefonní audit obsahuje neznámá čp.: #{unknown_telephone_houses.join(', ')}" unless unknown_telephone_houses.empty?
telephone_items = houses.flat_map do |key, house|
  house.fetch("evidence")
       .select do |item|
         item.fetch("type") == "telephone_subscriber_address" &&
           item.fetch("url", "") == telephone_audit.fetch("url")
       end
       .map { |item| [key, item] }
end
abort "Nesouhlasí počet osobních řádků telefonu 2004" unless telephone_items.length == telephone_audit.fetch("personal_matches")
abort "Nesouhlasí čp. telefonu 2004" unless telephone_items.map(&:first).uniq.sort_by(&:to_i) == telephone_audit.fetch("house_numbers").sort_by(&:to_i)
all_telephone_items = houses.values.flat_map { |house| house.fetch("evidence") }
                            .select { |item| item.fetch("type") == "telephone_subscriber_address" }
abort "Telefonní položka má neznámý pramen" unless all_telephone_items.length == telephone_2000_items.length + telephone_items.length

%w[period source url historical_source historical_url historical_context_url transition_source transition_url editions_checked editions latest_public_state latest_exact_cadastral_rows latest_exact_address_rows_outside_cadastral_area historical_2014_relevant_rows historical_2014_address_houses cumulative_distinct_land_registers current_house_parcel_matches new_address_houses new_named_house_links new_residence_links new_house_owner_links method findings limits].each do |field|
  niv_audit.fetch(field)
end
abort "Audit NIV má jiný počet edic" unless niv_audit.fetch("editions").length == niv_audit.fetch("editions_checked")
niv_audit.fetch("editions").each do |edition|
  %w[state scope format sha256 selected_rows exact_cadastral_rows exact_address_rows exact_address_rows_outside_cadastral_area distinct_people distinct_parcel_lvs address_houses].each do |field|
    edition.fetch(field)
  end
  abort "Audit NIV má neplatný SHA-256" unless edition.fetch("sha256").match?(/\A[0-9a-f]{64}\z/)
  unknown_edition_houses = edition.fetch("address_houses") - expected
  abort "Audit NIV obsahuje neznámá adresní čp.: #{unknown_edition_houses.join(', ')}" unless unknown_edition_houses.empty?
end
abort "Audit NIV má neočekávanou shodu s parcelou domu" unless niv_audit.fetch("current_house_parcel_matches").zero?
abort "Audit NIV má neočekávané vlastnictví domu" unless niv_audit.fetch("new_house_owner_links").zero?
abort "Audit NIV má neočekávaný pobytový doklad" unless niv_audit.fetch("new_residence_links").zero?
unknown_niv_houses = niv_audit.fetch("historical_2014_address_houses") - expected
abort "Audit NIV obsahuje neznámá čp.: #{unknown_niv_houses.join(', ')}" unless unknown_niv_houses.empty?

%w[period query_pattern source url_pattern method limits false_matches houses].each do |field|
  contract_audit.fetch(field)
end
contract_audit_houses = contract_audit.fetch("houses")
abort "Nesouhlasí čp. v auditu veřejných smluv" unless contract_audit_houses.keys.sort == expected.sort
contract_audit_houses.each do |key, item|
  item.fetch("result")
  if item.key?("url") && !item.key?("source")
    abort "#{key}: audit smluv má URL bez názvu pramene"
  end
end

%w[period method grant_files_checked new_exact_owner_links exact_owner_houses rejected_owner_candidates archival_sources findings limits].each do |field|
  ownership_audit.fetch(field)
end
abort "Audit vlastnictví má jiný počet dotačních spisů" unless ownership_audit.fetch("grant_files_checked") == 4
unknown_owner_houses = ownership_audit.fetch("exact_owner_houses") - expected
abort "Audit vlastnictví obsahuje neznámá čp.: #{unknown_owner_houses.join(', ')}" unless unknown_owner_houses.empty?
ownership_audit.fetch("rejected_owner_candidates").each do |item|
  %w[house person reason].each { |field| item.fetch(field) }
  abort "Audit vlastnictví odmítá neznámé čp. #{item.fetch('house')}" unless expected.include?(item.fetch("house"))
end
ownership_audit.fetch("archival_sources").each do |item|
  %w[source url catalog_scope digital_objects attachments result].each { |field| item.fetch(field) }
end

%w[period source url results document_results unique_attachments method findings limits].each do |field|
  municipal_audit.fetch(field)
end

%w[period source url official_source boards_checked known_name_queries exact_house_documents new_person_links new_residence_links new_owner_links method findings limits].each do |field|
  official_board_audit.fetch(field)
end
abort "Audit úředních desek má neočekávaný pobytový zásah" unless official_board_audit.fetch("new_residence_links").zero?
abort "Audit úředních desek má neočekávaný vlastnický zásah" unless official_board_audit.fetch("new_owner_links").zero?

%w[period source url subjects houses current_addresses historical_addresses method findings limits].each do |field|
  trade_audit.fetch(field)
end
abort "Audit RŽP má nelogický součet adres" unless trade_audit.fetch("current_addresses") + trade_audit.fetch("historical_addresses") == trade_audit.fetch("subjects")

%w[period source url eco_source eco_url ezp_municipality_results ezp_village_results known_ico_checked eco_municipality_results eco_address_zahradka_results eco_district_pelhrimov_results method findings limits].each do |field|
  agricultural_audit.fetch(field)
end
abort "Audit EZP má neočekávané zahrádecké výsledky" unless agricultural_audit.fetch("ezp_village_results").zero?
abort "Audit ekologických podnikatelů má neočekávaný pelhřimovský výsledek" unless agricultural_audit.fetch("eco_district_pelhrimov_results").zero?

%w[period source url description_source description_url municipality_results personal_results organization_results exact_village_results known_ico_checked known_ico_results known_name_rows method findings limits house_notes].each do |field|
  subsidy_audit.fetch(field)
end
abort "Audit dotací má nelogický součet subjektů" unless subsidy_audit.fetch("personal_results") + subsidy_audit.fetch("organization_results") == subsidy_audit.fetch("municipality_results")
abort "Audit dotací má neočekávaný přesný zásah v Zahrádce" unless subsidy_audit.fetch("exact_village_results").zero?
abort "Audit dotací má neočekávanou vazbu známého IČO" unless subsidy_audit.fetch("known_ico_results").zero?
abort "Audit dotací má nelogický počet jmenných shod" unless subsidy_audit.fetch("known_name_rows") == subsidy_audit.fetch("house_notes").length
unknown_subsidy_houses = subsidy_audit.fetch("house_notes").keys - expected
abort "Audit dotací obsahuje neznámá čp.: #{unknown_subsidy_houses.join(', ')}" unless unknown_subsidy_houses.empty?
subsidy_audit.fetch("house_notes").each do |key, item|
  %w[person payment_years szr_id detail_url interpretation].each { |field| item.fetch(field) }
  abort "#{key}: neplatné SZR-ID" unless item.fetch("szr_id").match?(/\A\d{10}\z/)
end

%w[period source url candidate_rows village_rows unique_village_people method findings limits].each do |field|
  election_audit.fetch(field)
end

owner_rows.each do |key, row|
  %w[stav stavebni_parcela stavebni_objekt adresni_misto vlastnik vztah_k_domu overeno_dne zdroj].each do |field|
    row.fetch(field)
  end
  abort "#{key}: neznámý stav v kontrolním listu" unless %w[aktivní zaniklé].include?(row.fetch("stav"))
end

current_context_by_house = expected.to_h { |key| [key, []] }
house_context.each do |item|
  item.fetch("houses").each { |key| current_context_by_house.fetch(key) << item }
end

published = houses.transform_values do |house|
  house.fetch("evidence").select { |item| item.fetch("publish") }
end
published_ownership = houses.transform_values do |house|
  house.fetch("ownership", []).select { |item| item.fetch("publish") }
end
published_ownership_context = houses.transform_values do |house|
  house.fetch("ownership_context", []).select { |item| item.fetch("publish") }
end
ownership_items = published_ownership.flat_map { |key, items| items.map { |item| [key, item] } }
abort "Nesouhlasí počet přesných vlastnických vazeb" unless ownership_items.length == ownership_audit.fetch("new_exact_owner_links")
abort "Nesouhlasí čp. přesných vlastnických vazeb" unless ownership_items.map(&:first).uniq.sort_by(&:to_i) == ownership_audit.fetch("exact_owner_houses").sort_by(&:to_i)
non_person_types = %w[organization project_applicant].freeze
resident_houses = published.count { |_key, items| items.any? { |item| item["type"] == "residence" } }
named_houses = published.count { |_key, items| items.any? { |item| !non_person_types.include?(item["type"]) } }
resident_people = published.values.flatten
                           .select { |item| item["type"] == "residence" }
                           .map { |item| item["person"] }.uniq
support_houses = published.count do |_key, items|
  items.any? { |item| item["type"] != "residence" && !non_person_types.include?(item["type"]) }
end
ownership_houses = published_ownership.count { |_key, items| items.any? }
ownership_people = published_ownership.values.flatten.map { |item| item.fetch("person") }.uniq

def source_md(item)
  return item.fetch("source") if item.fetch("url", "").empty?

  "[#{item.fetch('source')}](#{item.fetch('url')})"
end

def evidence_line(item, type_label)
  "  - **#{item.fetch('person')} — #{item.fetch('period')}** " \
    "(#{type_label}; jistota #{item.fetch('certainty')}): #{item.fetch('detail')} " \
    "Pramen: #{source_md(item)}."
end

def ownership_line(item)
  "  - **#{item.fetch('person')} — #{item.fetch('period')}** " \
    "(#{item.fetch('relation')}; jistota #{item.fetch('certainty')}): #{item.fetch('detail')} " \
    "Pramen: #{source_md(item)}."
end

def contract_audit_source(audit, key)
  query = audit.fetch("query_pattern").sub("{cp}", key)
  url = audit.fetch("url_pattern").sub("{query}", URI.encode_www_form_component(query))
  "[#{audit.fetch('source')}](#{url})"
end

def contract_audit_line(audit, key)
  item = audit.fetch("houses").fetch(key)
  line = "#{item.fetch('result')} Kontrolní dotaz: #{contract_audit_source(audit, key)}."
  if item.key?("source")
    line += " Doplňkový pramen: #{source_md(item)}."
  end
  line
end

def house_identity_line(row)
  return "Historické čp. je zaniklé; dnešní stavební parcela, stavební objekt ani adresní místo neexistují." if row.fetch("stav") == "zaniklé"

  "stavební parcela **#{row.fetch('stavebni_parcela')}**, RÚIAN stavební objekt " \
    "**#{row.fetch('stavebni_objekt')}**, adresní místo **#{row.fetch('adresni_misto')}**."
end

def owner_line(row)
  if row.fetch("vlastnik").to_s.strip.empty?
    return "**neověřen**. Přesný parcelní klíč je připraven v kontrolním listu; jméno se doplní až po ruční kontrole KN."
  end

  detail = "**#{row.fetch('vlastnik')}**"
  detail += " — #{row.fetch('vztah_k_domu')}" unless row.fetch("vztah_k_domu").to_s.strip.empty?
  detail += "; ověřeno #{row.fetch('overeno_dne')}" unless row.fetch("overeno_dne").to_s.strip.empty?
  detail += "; pramen #{row.fetch('zdroj')}" unless row.fetch("zdroj").to_s.strip.empty?
  detail + ". Vlastnictví samo neprokazuje bydliště."
end

def exact_verification(year, key, house, cut)
  if cut && cut.fetch("people_state") == "not_applicable"
    return "Nevyhledávat obyvatele pod tímto čp.; nejprve je doloženo, že číslo v daném roce ještě neexistovalo."
  end

  extinct = house.fetch("building").start_with?("Číslo zaniklo")
  case year
  when "1950"
    "[Národní archiv, fond Národní sčítání lidu 1950, NAD 984](https://portal.nacr.cz/aron/apu/9a5ca37a-bb27-4581-ba0c-77f0ac6ca5d0): vyžádat domovní " \
      "a bytový arch obce Zahrádka u Pošné pro čp. #{key}, stav k 1. 3. 1950; " \
      "ověřit proti součtu celé vsi 26 domů / 99 obyvatel. Žádný cílový arch " \
      "ani archivní pomůcka nemají k 1. 8. 2026 připojené veřejné obrazy. Při návštěvě " \
      "Chodovce zároveň projít dostupný prezenční [Úřední telefonní seznam 1950, " \
      "sign. IM489](https://www.knihovny.cz/Record/nacr.c9d28943-e9fa-481c-9f7d-57779479f9ee) " \
      "pod heslem Zahrádka nebo Pošná a hledat čp. #{key}. Záložní přesně cílený " \
      "exemplář je samostatný [kraj 9: Jihlava, sign. II 038397](https://www.knihovny.cz/Record/nkp.NKC01-001232628); " \
      "adresář ale zachytí jen zveřejněné účastníky, ne celou domácnost."
  when "1980"
    prefix = extinct ? "Nejprve zjistit, zda čp. #{key} ještě existovalo. " : ""
    prefix + "[SOkA Pelhřimov, MNV Útěchovičky, NAD 1262, pomůcka 559](https://portal.nacr.cz/aron/apu/16e489c1-dc65-4e14-8160-b427510d8a25): poslední " \
      "zahrádecký domovní seznam čp. #{key} do roku 1978. U archivu pak zjistit, " \
      "zda pokračování pro roky 1979–1980 převzal MNV nebo Obec Pošná. MNV Pošná, " \
      "[NAD 1544, inv. 60, karton 4](https://www.mza.cz/aron/apu/34333141-ad08-4de3-a43f-b0266836cabb) " \
      "(1963–1990), je v katalogu obecná evidence a výsledky sčítání; úplná kontrola " \
      "všech čtyř položek sekce nepotvrdila domovní seznam Zahrádky. Doplňkově ručně " \
      "zkontrolovat prezenční [Telefonní seznam TTO Tábor 1979–1980, sign. DT 6.504](https://katalog.cbvk.cz/arl-cbvk/cs/detail-cbvk_us_cat-0338681-Telefonni-seznam/); " \
      "ten ale nemůže nahradit úplný soupis domácností."
  when "2000"
    prefix = extinct ? "Nejprve určit poslední rok existence čp. #{key}. " : ""
    prefix + "Veřejný [Český telefon 2000](https://archive.org/details/czchip200012cd), " \
      "jehož bytové seznamy jsou platné do dubna 2000, už byl vytěžen celý; případná " \
      "přesná účastnická adresa je uvedena přímo u domu. Nejde však o úplnou domácnost " \
      "ani pobytový doklad. Ty musí SOkA Pelhřimov nebo Obec Pošná ověřit v pobytové či " \
      "domovní evidenci kolem sčítání 1991/2001. Doplňkově lze v MNV Pošná, NAD 1544, " \
      "[inv. 19 / kniha 19](https://www.mza.cz/aron/apu/7a158830-e446-49b6-9e7f-c2d119fa7834) " \
      "prověřit jmenné zmínky u čp. #{key} a ručně porovnat prezenční [Zlaté stránky " \
      "Jižní Čechy 1999–2001, sign. DT 9.279](https://katalog.cbvk.cz/arl-cbvk/cs/detail-cbvk_us_cat-0219386-Zlate-stranky/)."
  when "2026"
    if extinct
      "Bez současného pobytového řezu: čp. #{key} je zaniklé a v RÚIAN nemá dnešní adresní místo."
    else
      "Současné bydliště doplnit jen z přímého dokladu se souhlasem dotčené osoby " \
        "nebo z místního autorizovaného soupisu pro čp. #{key}. Vlastníka ověřit " \
        "ručně v KN do kontrolního listu, ale nezaměnit jej za obyvatele."
    end
  else
    raise "Neznámý kontrolní rok #{year}"
  end
end

def quick_house_line(key, house, items, ownership, types)
  residence = items.select { |item| item["type"] == "residence" }
  organization_types = %w[organization project_applicant]
  supporting = items.reject { |item| item["type"] == "residence" || organization_types.include?(item["type"]) }
  organizations = items.select { |item| organization_types.include?(item["type"]) }
  parts = []
  unless residence.empty?
    parts << "bydliště: " + residence.map { |item| "#{item.fetch('person')} (#{item.fetch('period')})" }.join("; ")
  end
  unless supporting.empty?
    parts << "jen další adresní stopa: " + supporting.map do |item|
      "#{item.fetch('person')} — #{types.fetch(item.fetch('type'))}"
    end.uniq.join("; ")
  end
  unless organizations.empty?
    parts << "organizace: " + organizations.map { |item| item.fetch("person") }.uniq.join("; ")
  end
  unless ownership.empty?
    parts << "historické vlastnictví: " + ownership.map { |item| item.fetch("person") }.uniq.join("; ")
  end
  parts << "bez přesně adresované poválečné osoby" if parts.empty?
  text = parts.join(". ").sub(/\.+\z/, "")
  "- **#{house.fetch('label')}:** #{text}."
end

checkpoint_labels = {
  "direct" => "přímo přiřazeno",
  "strong" => "silná časová opora",
  "gap" => "mezera v dokladech",
  "none" => "bez jmenného dokladu",
  "not_applicable" => "čp. tehdy ještě neexistovalo"
}.freeze

lines = []
lines << "# Obyvatelé Zahrádky po domech, 1950–2026"
lines << ""
lines << "Odrážkový pracovní katalog po jednotlivých čp.; stav k " \
         "#{data.fetch('updated').split('-').reverse.join('. ')}. Generováno z " \
         "[kanonických dat](obyvatele_1950_2026_data.json); tento soubor se ručně neupravuje."
lines << ""
lines << "## Jak výsledek číst"
lines << ""
lines << "- **Doložené bydliště** znamená, že datovaný pramen osobu přímo spojil s čp. Jen uvedený den nebo interval je doložený; sousední roky se nepřidávají odhadem."
lines << "- **Další adresní stopa** může být úřední kontakt, sídlo podnikání nebo poslední známá adresa vlastníka. Není automaticky pobytem."
lines << "- **Český telefon 2000** používá bytové seznamy platné do dubna 2000 a dává přesnou vazbu jméno–obec–čp. Jde o účastnickou adresu, nikoli automaticky o trvalý pobyt, vlastnictví nebo všechny členy domácnosti. Edice 2004 slouží jako pozdější nezávislá kontrola."
lines << "- **Stav domu** je jen jedna orientační věta, aby se jméno nepřiřadilo k domu, který v dané době neexistoval."
lines << "- U každého domu jsou zvlášť řezy **1950 / 1980 / 2000**. Jméno v položce ‚nejbližší opora‘ není obyvatelem daného roku, dokud to nepotvrdí domovní pramen."
lines << "- U možná žijících soukromých osob se z veřejného adresního pramene přebírá nejvýše jméno, datum a čp.; data narození, rodinné vztahy, telefonní čísla ani údaje dalších osob se nezveřejňují."
lines << "- **Vlastník není automaticky obyvatel.** Bodový historický doklad vlastnictví se vede zvlášť od bydliště i od současného stavu. Dotační žádost dokládá jen vlastnickou způsobilost v době podání; bez listu vlastnictví nerozlišuje podíl, další spoluvlastníky ani stav v roce 2026."
lines << "- **Seznam NIV rozlišuje adresu a majetek.** Poslední známá adresa osoby, parcela v katastru a vlastnictví samotného domu jsou tři různé údaje; datum vydání seznamu není datem pobytu."
lines << "- **Audit veřejných smluv** je u každého domu samostatný. Zachycuje i OCR skenovaných příloh, ale hromadné dopravní tabulky a čísla svazků se nepovažují za čp."
lines << "- **Živnostenský rejstřík** dává přesné intervaly sídel podnikatelů. Sídlo podnikání se mezi obyvatele nepřevádí, dokud jiný pramen výslovně nepotvrdí pobyt."
lines << "- **Zemědělské registry** byly zkontrolovány jako samostatný aktuální průřez. Evidence zemědělského ani ekologického podnikání není pobytovou evidencí."
lines << "- **Registr příjemců dotací MZe** uvádí u osob vyhledaných podle Pošné jen obec a PSČ. Ani stejné jméno a roky plateb proto bez části obce a čp. nepřiřazují člověka k domu."
lines << "- **Úřední desky** mohou přesně spojit osobu či organizaci se záměrem u domu. Žadatel, projektant nebo statutární zástupce však není automaticky obyvatel ani vlastník."
lines << "- **Identifikace a vlastník 2026** jsou u každého domu zvlášť. Parcela a identifikátory RÚIAN slouží k bezpečnému rozlišení domu; prázdné pole vlastníka znamená skutečně neověřený údaj, ne neznámého obyvatele."
lines << ""
lines << "## Rychlý index domů"
lines << ""
houses.sort_by { |key, _house| key.to_i }.each do |key, house|
  lines << quick_house_line(key, house, published.fetch(key), published_ownership.fetch(key), types)
end
lines << ""
main_lines = lines
lines = []
lines << "## Skutečné pokrytí"
lines << ""
lines << "- **#{resident_houses} z 32 čp.** má po roce 1950 alespoň jeden konkrétní doklad bydliště; jde o #{resident_people.length} zveřejněných jmenných položek."
lines << "- **#{named_houses} z 32 čp.** má alespoň nějakou poválečnou osobní stopu; u #{support_houses} čp. je část dokladů pouze podpůrná, nikoli pobytová."
lines << "- **#{ownership_houses} z 32 čp.** má přesný bodový doklad historického vlastnictví: #{ownership_people.join(', ')}. Jde o stav v době dotační žádosti, nikoli o úplnou vlastnickou posloupnost ani současný stav."
lines << "- **Rok 1950:** žádná osoba zatím není veřejným pramenem spojena současně s rokem a čp."
lines << "- **Rok 1980:** domovní mezera trvá; známe 51 obyvatel a k 1. 1. 1980 skladbu 33 členů JZD. Jmenně je přesně k roku 1980 ve vsi doložen František Kříž a těsně před řezem Jan s Anežkou Kejvalovými (13. 7. 1979), ale žádný z těchto pramenů neuvádí čp."
lines << "- **Rok 2000:** přímý pobytový doklad máme jen pro Václava Bulanta na čp. 28. Český telefon 2000 navíc přesně spojuje osoby s čp. 5, 6, 7, 8, 16, 21, 24, 27, 28 a 29; u devíti ostatních domů je to silná časová opora, ne jisté bydliště ani úplná domácnost."
lines << "- **Důležité omezení pramene:** MNV Pošná, inv. 61 / karton 4, je výslovně seznam **Pošné čp. 1–50 (1953–1967)**. Pro Zahrádku se nepoužívá."
lines << "- **Rok 2026:** aktuálně ověřené jsou adresy podnikání na čp. 8, 15, 20 a 27, sídlo spolku a dvě statutární role spojené s čp. 11. Žádný z těchto zápisů sám neprokazuje dnešní bydliště."
lines << "- **Veřejný telefonní adresář 2026:** #{current_telephone_audit.fetch('findings')} Prověřeno bylo #{current_telephone_audit.fetch('exact_known_names_checked')} již známých přesných jmen; lokalitní výpis bez jména formulář neposkytl. #{current_telephone_audit.fetch('limits')} Telefonní čísla exportována nebyla. Pramen: #{source_md(current_telephone_audit)}."
lines << "- **Dostupnost klíčových pramenů:** #{archival_audit.fetch('findings')} V archivní kontrole bylo nových osobních vazeb #{archival_audit.fetch('new_exact_person_links')}; samostatné audity digitálních telefonních databází následují níže."
archival_audit.fetch("sources").each do |item|
  lines << "  - **#{item.fetch('checkpoint')} — [#{item.fetch('source')}](#{item.fetch('url')}):** #{item.fetch('catalog_scope')}. #{item.fetch('result')} Digitální objekty: #{item.fetch('digital_objects')}; přílohy u cílové položky: #{item.fetch('attachments')}."
  if item.key?("supporting_source")
    lines << "    - **Doplňková obrazová opora:** [#{item.fetch('supporting_source')}](#{item.fetch('supporting_url')})."
  end
end
lines << "  - **Omezení:** #{archival_audit.fetch('limits')}"
lines << "- **Celostátní fulltext České digitální knihovny:** #{cdk_audit.fetch('findings')} #{cdk_audit.fetch('false_matches')} #{cdk_audit.fetch('limits')} Uložený audit: [vysledky.json](#{cdk_audit.fetch('result_path')}). Pramen: #{source_md(cdk_audit)}."
lines << "- **Český telefon 2000 — přesný účastnický řez:** #{telephone_2000_audit.fetch('findings')} Prošlo se všech #{cz_integer(telephone_2000_audit.fetch('personal_table_rows'))} osobních a #{cz_integer(telephone_2000_audit.fetch('business_table_rows'))} firemních řádků. Obal uvádí #{cz_integer(telephone_2000_audit.fetch('advertised_numbers'))} čísel, uložené tabulky mají dohromady #{cz_integer(telephone_2000_audit.fetch('table_rows_total'))} řádků; nevysvětlený rozdíl je #{telephone_2000_audit.fetch('advertised_minus_table_rows')}. #{telephone_2000_audit.fetch('limits')} Telefonní čísla exportována nebyla. Pramen: #{source_md(telephone_2000_audit)}."
lines << "- **Český telefon 2004 — vytěžená osobní část:** #{telephone_audit.fetch('findings')} Metadata edice uvádějí #{cz_integer(telephone_audit.fetch('advertised_personal_numbers'))} bytových a #{cz_integer(telephone_audit.fetch('advertised_business_numbers'))} firemních telefonních čísel; parser prošel všech #{cz_integer(telephone_audit.fetch('personal_data_pages'))} datových stran osobní a #{cz_integer(telephone_audit.fetch('business_data_pages'))} stran firemní tabulky. Přesných osobních zásahů bylo #{telephone_audit.fetch('personal_matches')} na čp. #{telephone_audit.fetch('house_numbers').join(', ')}. #{telephone_audit.fetch('limits')} Telefonní čísla exportována nebyla. Pramen: #{source_md(telephone_audit)}."
lines << "- **Historické seznamy NIV — výsledek:** #{niv_audit.fetch('findings')} Kumulativně jde o #{niv_audit.fetch('cumulative_distinct_land_registers')} různých LV; shod s přesnou stavební parcelou dnešního domu bylo #{niv_audit.fetch('current_house_parcel_matches')}."
niv_audit.fetch("editions").each do |edition|
  houses_text = edition.fetch("address_houses").empty? ? "žádné" : edition.fetch("address_houses").join(", ")
  lines << "  - **Stav #{edition.fetch('state')} (#{edition.fetch('scope')}):** relevantní řádky #{edition.fetch('selected_rows')}; v cílovém k. ú. #{edition.fetch('exact_cadastral_rows')}; řádky s přesnou zahrádeckou adresou #{edition.fetch('exact_address_rows')} (z toho #{edition.fetch('exact_address_rows_outside_cadastral_area')} u parcel mimo cílové k. ú.); osoby #{edition.fetch('distinct_people')}; LV #{edition.fetch('distinct_parcel_lvs')}; adresní čp. #{houses_text}."
end
lines << "  - **Omezení:** #{niv_audit.fetch('limits')}"
lines << "  - **Prameny:** #{source_md(niv_audit)}; [#{niv_audit.fetch('historical_source')}](#{niv_audit.fetch('historical_url')}); [#{niv_audit.fetch('transition_source')}](#{niv_audit.fetch('transition_url')})."
lines << "- **Veřejné smlouvy po všech čp.:** přesný OCR audit znovu potvrdil pobytové doklady čp. 6, 15, 27 a 28, ale nepřidal nového jmenovaného obyvatele. Vizuální kontrola původních příloh přidala samostatné bodové vlastnické doklady u čp. 6, 15 a 28; čp. 27 nebylo bez identifikace podporované nemovitosti převedeno mezi vlastníky. U čp. 11 audit doložil jen anonymizované místo výkonu práce roku 2025. #{contract_audit.fetch('false_matches')} #{contract_audit.fetch('limits')}"
lines << "- **Vlastnické prameny 1950–2026:** #{ownership_audit.fetch('findings')} #{ownership_audit.fetch('limits')}"
ownership_audit.fetch("archival_sources").each do |item|
  lines << "  - **[#{item.fetch('source')}](#{item.fetch('url')}):** #{item.fetch('catalog_scope')}. #{item.fetch('result')} Digitální objekty: #{item.fetch('digital_objects')}; přílohy: #{item.fetch('attachments')}."
end
lines << "- **Web Města Pacov:** #{municipal_audit.fetch('findings')} Audit zahrnul #{municipal_audit.fetch('results')} výsledků, z toho #{municipal_audit.fetch('document_results')} dokumentových záznamů a #{municipal_audit.fetch('unique_attachments')} jedinečných příloh. #{municipal_audit.fetch('limits')} Pramen: #{source_md(municipal_audit)}."
lines << "- **Archiv úředních desek:** #{official_board_audit.fetch('findings')} Prověřeny byly #{official_board_audit.fetch('boards_checked')} desky a #{official_board_audit.fetch('known_name_queries')} přesných jmenných dotazů; přímých nových dokladů bydliště bylo #{official_board_audit.fetch('new_residence_links')} a vlastnictví #{official_board_audit.fetch('new_owner_links')}. #{official_board_audit.fetch('limits')} Pramen: #{source_md(official_board_audit)}."
lines << "- **Živnostenský rejstřík:** #{trade_audit.fetch('findings')} Prověřeno bylo #{trade_audit.fetch('subjects')} subjektů na #{trade_audit.fetch('houses')} čp.; #{trade_audit.fetch('current_addresses')} adresy jsou aktuální a #{trade_audit.fetch('historical_addresses')} historických. #{trade_audit.fetch('limits')} Pramen: #{source_md(trade_audit)}."
lines << "- **Zemědělské registry:** #{agricultural_audit.fetch('findings')} #{agricultural_audit.fetch('limits')} Prameny: #{source_md(agricultural_audit)}; [#{agricultural_audit.fetch('eco_source')}](#{agricultural_audit.fetch('eco_url')})."
lines << "- **Registr příjemců dotací MZe:** #{subsidy_audit.fetch('findings')} Prověřeno bylo také všech #{subsidy_audit.fetch('known_ico_checked')} známých zahrádeckých IČO; přímo spárovaných bylo #{subsidy_audit.fetch('known_ico_results')}. #{subsidy_audit.fetch('limits')} Prameny: #{source_md(subsidy_audit)}; [#{subsidy_audit.fetch('description_source')}](#{subsidy_audit.fetch('description_url')})."
lines << "- **Komunální volby:** #{election_audit.fetch('findings')} Audit zahrnul #{election_audit.fetch('candidate_rows')} kandidátních řádků Pošné; #{election_audit.fetch('village_rows')} záznamů patří Zahrádce a představují #{election_audit.fetch('unique_village_people')} osobu. #{election_audit.fetch('limits')} Pramen: #{source_md(election_audit)}."
house_context.each do |item|
  lines << "- **Technická kontrola adres 2026:** #{item.fetch('detail')} #{item.fetch('limits')} Pramen: #{source_md(item)}."
end
audit_lines = lines
lines = main_lines
lines << "## Dům po domu"

houses.sort_by { |key, _house| key.to_i }.each do |key, house|
  items = house.fetch("evidence").select { |item| item.fetch("publish") }
  ownership = house.fetch("ownership", []).select { |item| item.fetch("publish") }
  ownership_context = house.fetch("ownership_context", []).select { |item| item.fetch("publish") }
  residence = items.select { |item| item["type"] == "residence" }
  supporting = items.reject { |item| item["type"] == "residence" }
  snapshots = reconstruction_houses.fetch(key).fetch("snapshots")
  owner_row = owner_rows.fetch(key)

  lines << ""
  lines << "### #{house.fetch('label')}"
  lines << ""
  if residence.empty?
    lines << "- **Doložené bydliště 1950–2026:** zatím žádná osoba."
  else
    lines << "- **Doložené bydliště:**"
    residence.each { |item| lines << evidence_line(item, types.fetch(item.fetch("type"))) }
  end
  lines << "- **Kontrolní řezy obyvatel:**"
  %w[1950 1980 2000].each do |year|
    cut = snapshots.fetch(year)
    status = checkpoint_labels.fetch(cut.fetch("people_state"))
    lines << "  - **#{year} — #{status}:** #{cut.fetch('people')}"
    lines << "    - **Nejbližší jmenná opora:** #{cut.fetch('anchor')}"
    lines << "    - **Ověřit přesně:** #{exact_verification(year, key, house, cut)}"
  end
  current_supporting = supporting.select { |item| item.fetch("current_2026", false) }
  extinct = house.fetch("building").start_with?("Číslo zaniklo")
  if extinct
    lines << "  - **2026 — bez současného pobytového řezu:** Číslo je zaniklé a v RÚIAN nemá dnešní adresní místo."
  else
    lines << "  - **2026 — současní obyvatelé veřejně nedoloženi:** Veřejné prameny nepotvrdily jméno žádného obyvatele tohoto čp. k 1. 8. 2026."
  end
  if current_supporting.empty?
    lines << "    - **Aktuální podpůrná stopa:** žádná veřejná adresní stopa platná k 1. 8. 2026."
  else
    current_labels = current_supporting.map do |item|
      "#{item.fetch('person')} (#{types.fetch(item.fetch('type'))})"
    end
    lines << "    - **Aktuální podpůrná stopa:** #{current_labels.join('; ')}; sama neprokazuje bydliště."
  end
  current_context_by_house.fetch(key).each do |item|
    lines << "    - **Technická opora adresy:** toto čp. je v oznámení EG.D pro odstávku 7. 8. 2026; dokládá jen zařazení adresy do rozsahu odstávky, ne obyvatele. Pramen: #{source_md(item)}."
  end
  lines << "    - **Ověřit přesně:** #{exact_verification('2026', key, house, nil)}"
  unless supporting.empty?
    lines << "- **Jiné adresní vazby — nejsou dokladem bydliště:**"
    supporting.each { |item| lines << evidence_line(item, types.fetch(item.fetch("type"))) }
  end
  if ownership.empty?
    lines << "- **Doložené historické vlastnictví 1950–2026:** zatím žádný přesný jmenný doklad."
  else
    lines << "- **Doložené historické vlastnictví — jen bodový stav v době pramene:**"
    ownership.each { |item| lines << ownership_line(item) }
  end
  unless ownership_context.empty?
    lines << "- **Nejbližší majetkový kontext — není přesným vlastníkem domu ve sledovaném roce:**"
    ownership_context.each { |item| lines << ownership_line(item) }
  end
  lines << "- **Vlastník k roku 2026:** #{owner_line(owner_row)}"
  lines << "- **Stav domu (orientačně):** #{house.fetch('building')}"
  lines << "- **Přesná identifikace domu:** #{house_identity_line(owner_row)}"
  lines << "- **Doplňkový audit veřejných smluv (#{contract_audit.fetch('period')}):** #{contract_audit_line(contract_audit, key)}"
  if subsidy_audit.fetch("house_notes").key?(key)
    subsidy_note = subsidy_audit.fetch("house_notes").fetch(key)
    lines << "- **Dotace MZe — jen obecní jmenná stopa, nikoli bydliště:** [#{subsidy_note.fetch('person')}, SZR-ID #{subsidy_note.fetch('szr_id')}](#{subsidy_note.fetch('detail_url')}) má záznamy za roky #{subsidy_note.fetch('payment_years')}. #{subsidy_note.fetch('interpretation')}"
  end
end

lines << ""
lines << "## Pováleční lidé dosud jen na úrovni vsi"
data.fetch("village_only").each do |item|
  lines << ""
  detail = "- **#{item.fetch('period')}:** #{item.fetch('people')}. #{item.fetch('note')}"
  detail += " Jistota: #{item.fetch('certainty')}." if item.key?("certainty")
  if item.key?("source")
    source = item.fetch("url", "").empty? ? item.fetch("source") : "[#{item.fetch('source')}](#{item.fetch('url')})"
    detail += " Pramen: #{source}."
  end
  lines << detail
end

lines << ""
lines << "## Co může mezery skutečně uzavřít"
lines << ""
lines << "- **1950:** domovní a bytové archy Národního sčítání lidu 1950, Národní archiv, NAD 984."
lines << "- **50.–70. léta:** AO Zahrádka NAD 1334, MNV Zahrádka NAD 1335 a domovní evidence MNV Útěchovičky NAD 1262."
lines << "- **Rok 1980:** poslední katalogově doložený zahrádecký domovní pramen končí rokem 1978 ve fondu MNV Útěchovičky; pokračování musí určit SOkA Pelhřimov nebo Obec Pošná."
lines << "- **Rok 2000:** veřejný Český telefon 2000 je už kompletně vytěžený a dává deset přesných účastnických adres. Úplnou domácnost ani trvalý pobyt však nenahrazuje; ty může uzavřít až pobytová či domovní evidence kolem sčítání 1991/2001. Kronika MNV Pošná, NAD 1544, inv. 19 / kniha 19 (1974–2007), může přidat jednotlivé jmenné zmínky."
lines << "- **Následná kontrola 2004:** veřejný Český telefon 2004 je také kompletně vytěžený; opakuje devět z deseti vazeb z roku 2000. Neprokazuje však nepřetržitý pobyt mezi oběma vydáními."
lines << "- **Doplňkové adresáře:** prezenční Telefonní seznam TTO Tábor 1979–1980 (JVK, DT 6.504) zůstává důležitý pro řez 1980. Zlaté stránky Jižní Čechy 1999–2001 (JVK, DT 9.279) mohou sloužit už jen jako srovnávací kontrola vytěženého CD z roku 2000; ani jeden adresář není úplným soupisem obyvatel."
lines << "- Připravený text žádosti je v [zadost_o_archivni_prameny.md](zadost_o_archivni_prameny.md); žádost zatím nebyla odeslána."
lines << ""
lines.concat(audit_lines)

File.write(OUT, lines.join("\n") + "\n")

CSV.open(AUDIT_OUT, "w", write_headers: true,
         headers: %w[cp dum stavebni_parcela stavebni_objekt adresni_misto vlastnik_2026 vlastnik_overen rok stav_osob vysledek nejblizsi_opora audit_verejnych_smluv overit_presne]) do |csv|
  houses.sort_by { |key, _house| key.to_i }.each do |key, house|
    snapshots = reconstruction_houses.fetch(key).fetch("snapshots")
    owner_row = owner_rows.fetch(key)
    owner_verified = owner_row.fetch("vlastnik").to_s.strip.empty? ? "ne" : "ano"
    %w[1950 1980 2000].each do |year|
      cut = snapshots.fetch(year)
      csv << [key, house.fetch("label"), owner_row.fetch("stavebni_parcela"),
              owner_row.fetch("stavebni_objekt"), owner_row.fetch("adresni_misto"),
              owner_row.fetch("vlastnik"), owner_verified, year, cut.fetch("people_state"),
              cut.fetch("people"), cut.fetch("anchor"),
              contract_audit_line(contract_audit, key),
              exact_verification(year, key, house, cut)]
    end
    current_items = published.fetch(key).select { |item| item.fetch("current_2026", false) }
    current_anchor = if current_items.empty?
                       "Žádná veřejná adresní stopa platná k 1. 8. 2026."
                     else
                       current_items.map { |item| "#{item.fetch('person')} — #{types.fetch(item.fetch('type'))}" }.join("; ")
                     end
    extinct = house.fetch("building").start_with?("Číslo zaniklo")
    current_state = extinct ? "not_applicable" : "gap"
    csv << [key, house.fetch("label"), owner_row.fetch("stavebni_parcela"),
            owner_row.fetch("stavebni_objekt"), owner_row.fetch("adresni_misto"),
            owner_row.fetch("vlastnik"), owner_verified, "2026", current_state,
            extinct ? "Číslo je zaniklé; bez současného pobytového řezu." : "Současní obyvatelé veřejně nedoloženi.", current_anchor,
            contract_audit_line(contract_audit, key),
            exact_verification("2026", key, house, nil)]
  end
end

puts "#{OUT}: #{houses.length} domů, #{published.values.flatten.length} zveřejněných stop, #{resident_houses} čp. s bydlištěm"
puts "#{AUDIT_OUT}: #{houses.length * 4} kontrolních řezů"
