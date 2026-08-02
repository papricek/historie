#!/usr/bin/env ruby
# frozen_string_literal: true

# Prověří jména z Českého telefonu 2000 proti přesnému názvu obce v Krameriu
# KK Vysočiny a JVK/CBVK. Výstup je objevovací audit: společný výskyt jména a
# obce na jedné stránce ještě není důkazem, že se navzájem vztahují.

require "date"
require "json"
require "net/http"
require "optparse"
require "uri"

ROOT = File.expand_path("..", __dir__)
DATA = File.join(ROOT, "obyvatele_1950_2026_data.json")
DEFAULT_LOCALITY = "Zahrádka u Pošné"
SERVERS = {
  "KK Vysočiny" => "https://kramerius.kkvysociny.cz/search/api/client/v7.0/search",
  "JVK/CBVK" => "https://kramerius.cbvk.cz/search/api/client/v7.0/search"
}.freeze

options = {
  output: nil,
  as_of: Date.today.iso8601,
  locality: DEFAULT_LOCALITY
}
OptionParser.new do |parser|
  parser.banner = "Použití: ruby nastroje/proverit_povalecna_jmena_kramerius.rb [volby]"
  parser.on("-o", "--output SOUBOR", "Uložit JSON do souboru místo stdout") { |value| options[:output] = value }
  parser.on("--as-of DATUM", "Datum auditu ve formátu RRRR-MM-DD") { |value| options[:as_of] = Date.iso8601(value).iso8601 }
  parser.on("--locality NAZEV", "Přesný název lokality") { |value| options[:locality] = value }
end.parse!

data = JSON.parse(File.read(DATA))
people = data.fetch("houses").flat_map do |cp, house|
  house.fetch("evidence").filter_map do |item|
    next unless item.fetch("type") == "telephone_subscriber_address"
    next unless item.fetch("url", "").include?("czchip200012cd")

    [cp, item.fetch("person")]
  end
end.to_h

def searchable_name(name)
  name.sub(/\A(?:Ing\.|Bc\.|Mgr\.|JUDr\.|MUDr\.)\s+/i, "")
end

def surname_aliases(name)
  surname = searchable_name(name).split.last
  aliases = [surname]
  aliases << "Dorrschmidt" if surname == "Dörrschmidt"
  aliases.uniq
end

def fetch_json(url, attempts: 3)
  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = "zahradka-historicky-audit/1.0"
  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 45) do |http|
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
SERVERS.each do |server, endpoint|
  people.each do |cp, person|
    full_name = searchable_name(person)
    variants = [["full_name", full_name]] + surname_aliases(person).map { |surname| ["surname", surname] }
    variants.each do |kind, term|
      query = %(text_ocr:"#{term}" AND text_ocr:"#{options.fetch(:locality)}")
      url = query_url(endpoint, query)
      body = fetch_json(url)
      response = body.fetch("response")
      highlighting = body.fetch("highlighting", {})
      docs = response.fetch("docs").map do |doc|
        {
          "pid" => doc.fetch("pid"),
          "date" => doc["date.str"],
          "page" => doc["page.number"] || doc["title.search"],
          "title" => doc["root.title"],
          "root_pid" => doc["root.pid"],
          "snippets" => highlighting.fetch(doc.fetch("pid"), {}).fetch("text_ocr", []).map { |snippet| clean_snippet(snippet) }
        }
      end
      results << {
        "server" => server,
        "cp_2000" => cp,
        "person_2000" => person,
        "query_kind" => kind,
        "query_term" => term,
        "query" => query,
        "url" => url,
        "num_found" => response.fetch("numFound"),
        "documents" => docs
      }
    end
  end
end

payload = {
  "as_of" => options.fetch(:as_of),
  "locality" => options.fetch(:locality),
  "method" => "Přesné celé jméno a příjmení každého osobního účastníka Českého telefonu 2000 bylo na dvou serverech Krameria spojeno s přesnou frází názvu obce. Výsledek je pouze kandidátní společný výskyt na stránce; rozhoduje ruční čtení úryvků.",
  "people_checked" => people.length,
  "queries" => results.length,
  "results_with_hits" => results.count { |item| item.fetch("num_found").positive? },
  "results" => results
}
json = JSON.pretty_generate(payload) + "\n"

if options[:output]
  File.write(options.fetch(:output), json)
else
  puts json
end
