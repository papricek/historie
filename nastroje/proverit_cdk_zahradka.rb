#!/usr/bin/env ruby
# frozen_string_literal: true

# Stáhne všechny stránky v České digitální knihovně, na nichž se v OCR
# vyskytuje přesná fráze "Zahrádka u Pošné". Výstup je objevovací audit:
# společný výskyt osoby a obce na jedné straně ještě není důkazem vazby.

require "date"
require "json"
require "net/http"
require "optparse"
require "uri"

ENDPOINT = "https://api.ceskadigitalniknihovna.cz/search/api/client/v7.0/search"
DEFAULT_LOCALITY = "Zahrádka u Pošné"
ROWS = 100

options = {
  output: nil,
  as_of: Date.today.iso8601,
  locality: DEFAULT_LOCALITY
}
OptionParser.new do |parser|
  parser.banner = "Použití: ruby nastroje/proverit_cdk_zahradka.rb [volby]"
  parser.on("-o", "--output SOUBOR", "Uložit JSON do souboru místo stdout") { |value| options[:output] = value }
  parser.on("--as-of DATUM", "Datum auditu ve formátu RRRR-MM-DD") { |value| options[:as_of] = Date.iso8601(value).iso8601 }
  parser.on("--locality NAZEV", "Přesný název lokality") { |value| options[:locality] = value }
end.parse!

def fetch_json(url, attempts: 3)
  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = "zahradka-historicky-audit/1.0"
  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 60) do |http|
    http.request(request)
  end
  raise "HTTP #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

  JSON.parse(response.body)
rescue StandardError
  raise if attempts <= 1

  fetch_json(url, attempts: attempts - 1)
end

def query_url(locality, start)
  query = %(text_ocr:"#{locality}")
  params = {
    "q" => query,
    "start" => start.to_s,
    "rows" => ROWS.to_s,
    "fl" => "pid,compositeId,date.str,title.search,page.number,model,root.title,root.pid,cdk.collection,cdk.leader,accessibility",
    "sort" => "date.min asc",
    "hl" => "true",
    "hl.fl" => "text_ocr",
    "hl.fragsize" => "120",
    "hl.snippets" => "2"
  }
  "#{ENDPOINT}?#{URI.encode_www_form(params)}"
end

def clean_snippet(text)
  text.gsub(%r{</?em>}, "").gsub(/\s+/, " ").strip
end

documents = []
total = nil
start = 0
loop do
  url = query_url(options.fetch(:locality), start)
  body = fetch_json(url)
  response = body.fetch("response")
  total ||= response.fetch("numFound")
  highlighting = body.fetch("highlighting", {})
  docs = response.fetch("docs")
  documents.concat(docs.map do |doc|
    highlight_key = doc["compositeId"] || doc.fetch("pid")
    {
      "pid" => doc.fetch("pid"),
      "composite_id" => doc["compositeId"],
      "date" => doc["date.str"],
      "page" => doc["page.number"] || doc["title.search"],
      "title" => doc["root.title"],
      "root_pid" => doc["root.pid"],
      "collections" => doc.fetch("cdk.collection", []),
      "leader" => doc["cdk.leader"],
      "accessibility" => doc["accessibility"],
      "snippets" => highlighting.fetch(highlight_key, {}).fetch("text_ocr", []).map { |text| clean_snippet(text) }
    }
  end)
  start += docs.length
  break if docs.empty? || start >= total
end

raise "ČDK oznámila #{total} výsledků, ale staženo bylo #{documents.length}" unless documents.length == total

payload = {
  "as_of" => options.fetch(:as_of),
  "locality" => options.fetch(:locality),
  "endpoint" => ENDPOINT,
  "method" => "Všechny stránky agregované Českou digitální knihovnou s přesnou OCR frází názvu obce; řazeno vzestupně podle data. Úryvek je kandidát k ručnímu čtení, ne automatický důkaz osoby, bydliště nebo čp.",
  "documents_found" => documents.length,
  "public_documents" => documents.count { |doc| doc.fetch("accessibility") == "public" },
  "collections" => documents.flat_map { |doc| doc.fetch("collections") }.tally.sort.to_h,
  "documents" => documents
}
json = JSON.pretty_generate(payload) + "\n"

if options[:output]
  File.write(options.fetch(:output), json)
else
  puts json
end
