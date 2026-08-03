#!/usr/bin/env ruby
# frozen_string_literal: true

# Reprodukovatelný audit jmen a místních názvů z rozhovoru s Pavlem Peštou
# v regionálním tisku. Výstup ukládá i nulové dotazy: absence výsledku není
# důkazem neexistence, ale dokládá, co a jak bylo skutečně hledáno.

require "date"
require "json"
require "net/http"
require "optparse"
require "uri"

SERVERS = {
  "KK Vysočiny" => "https://kramerius.kkvysociny.cz/search/api/client/v7.0/search",
  "JVK/CBVK" => "https://kramerius.cbvk.cz/search/api/client/v7.0/search"
}.freeze

DEFAULT_TERMS = [
  "hampejz", "nevěstinec", "U Červeného kohouta", "Červený kohout",
  "cvičiště", "pastouška", "pazderna", "Hejdův lom", "lom",
  "Převor", "Pachta", "Pešta", "Kudrna", "Bartoška", "Vaněk",
  "Vaňková", "Markvart", "Zelenka", "Marousek", "Štípek", "Janda",
  "Dörrschmidt", "Dorrschmidt", "Pička", "Píček", "Kubiska", "Čekalová",
  "Coufal", "Plášil", "Krejčí",
  "Václav Převor", "Pavel Pešta", "Stanislav Marousek", "Marie Vaňková",
  "Jaroslav Kudrna", "Josef Kudrna", "Jan Kudrna", "Stanislav Janda",
  "Václav Dörrschmidt", "Miroslav Kubiska",
  "Marie Bartošková", "Marie Pavlíková", "Václav Bartoška",
  "Bartošková Peštová", "Bartoška Pešta", "Bartoškovi Peštovi",
  "Karel Adam", "Marie Pachtová", "Mánička Pachtová", "Pachta čp. 13",
  "Kudrna čp. 13", "Kudrna Zahrádka 13", "Šányk", "U Hejdů",
  "U Pícků", "U Coufalů", "Josef Vaněk čp. 25",
  "Maruna Plášilová", "Lída Plášilová", "Ludmila Plášilová",
  "Jarka Plášilová", "Jaroslava Plášilová", "Plášilovy dcery"
].freeze

options = {
  output: nil,
  as_of: Date.today.iso8601,
  locality: "Zahrádka u Pošné",
  terms: DEFAULT_TERMS
}

OptionParser.new do |parser|
  parser.banner = "Použití: ruby nastroje/proverit_rozhovor_kramerius.rb [volby]"
  parser.on("-o", "--output SOUBOR", "Výstupní JSON") { |value| options[:output] = value }
  parser.on("--as-of DATUM", "Datum auditu RRRR-MM-DD") { |value| options[:as_of] = Date.iso8601(value).iso8601 }
  parser.on("--locality NAZEV", "Přesný název lokality") { |value| options[:locality] = value }
  parser.on("--terms-file SOUBOR", "Jeden hledaný výraz na řádek") do |value|
    options[:terms] = File.readlines(value, chomp: true).map(&:strip).reject { |line| line.empty? || line.start_with?("#") }
  end
end.parse!

abort "Chybí -o/--output." unless options[:output]

def fetch_json(url, attempts: 3)
  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = "zahradka-rozhovor-audit/1.0"
  response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 15, read_timeout: 60) do |http|
    http.request(request)
  end
  raise "HTTP #{response.code}: #{url}" unless response.is_a?(Net::HTTPSuccess)

  JSON.parse(response.body)
rescue StandardError
  raise if attempts <= 1

  fetch_json(url, attempts: attempts - 1)
end

def query_url(endpoint, query)
  params = {
    "q" => query,
    "rows" => "100",
    "fl" => "pid,date.str,title.search,page.number,model,root.title,root.pid",
    "hl" => "true",
    "hl.fl" => "text_ocr",
    "hl.fragsize" => "100",
    "hl.snippets" => "3"
  }
  "#{endpoint}?#{URI.encode_www_form(params)}"
end

def clean_snippet(text)
  text.gsub(%r{</?em>}, "").gsub(/\s+/, " ").strip
end

results = []
locality_query = [
  "Zahrádka", "Zahrádky", "Zahrádce", "Zahrádku", "Zahrádkou"
].map { |form| %(text_ocr:"#{form}") }.join(" OR ")
district_query = ["Pošné", "Pošná", "Pošnou"].map { |form| %(text_ocr:"#{form}") }.join(" OR ")
SERVERS.each do |server, endpoint|
  options.fetch(:terms).each do |term|
    query = %(text_ocr:"#{term}" AND (#{locality_query}) AND (#{district_query}))
    url = query_url(endpoint, query)
    body = fetch_json(url)
    response = body.fetch("response")
    highlighting = body.fetch("highlighting", {})
    documents = response.fetch("docs").map do |doc|
      {
        "pid" => doc["pid"],
        "date" => doc["date.str"],
        "page" => doc["page.number"],
        "title" => doc["title.search"] || doc["root.title"],
        "root_pid" => doc["root.pid"],
        "snippets" => Array(highlighting.dig(doc.fetch("pid"), "text_ocr")).map { |text| clean_snippet(text) }
      }
    end
    results << {
      "server" => server,
      "term" => term,
      "query" => query,
      "url" => url,
      "num_found" => response.fetch("numFound"),
      "documents" => documents
    }
  end
end

payload = {
  "as_of" => options.fetch(:as_of),
  "locality" => options.fetch(:locality),
  "method" => "Kramerius API v7; přesný výraz AND pádové varianty Zahrádky AND varianty Pošné; OCR může obsahovat chyby a společný výskyt na stránce nemusí znamenat věcnou souvislost",
  "terms" => options.fetch(:terms),
  "queries" => results.length,
  "queries_with_hits" => results.count { |item| item.fetch("num_found").positive? },
  "results" => results
}

File.write(options.fetch(:output), JSON.pretty_generate(payload) + "\n")
puts "Uloženo #{results.length} dotazů, z toho #{payload.fetch("queries_with_hits")} s výsledkem: #{options.fetch(:output)}"
