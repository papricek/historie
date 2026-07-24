#!/usr/bin/env ruby

# Reprodukovatelné hledání ve veřejném elektronickém rejstříku matričních
# zápisů SOA Třeboň. Rejstřík je jen dílčí; nulový výsledek nenahrazuje
# prohlédnutí obrazů příslušné knihy.

require "cgi"
require "fileutils"
require "open3"
require "optparse"
require "tmpdir"
require "uri"

options = {
  page: 1,
  output: nil,
  date_from: "",
  date_to: ""
}

parser = OptionParser.new do |opts|
  opts.banner = "Použití: #{File.basename($PROGRAM_NAME)} [volby] HLEDANY_TEXT"
  opts.on("--od ROK", "Počáteční rok filtru") { |value| options[:date_from] = value }
  opts.on("--do ROK", "Koncový rok filtru") { |value| options[:date_to] = value }
  opts.on("--strana N", Integer, "Strana výsledků (výchozí 1)") { |value| options[:page] = value }
  opts.on("-o", "--vystup SOUBOR", "Uložit původní HTML výsledků") { |value| options[:output] = value }
end
parser.parse!

query = ARGV.join(" ").strip
abort parser.to_s if query.empty?
abort "Rok --od musí obsahovat jen číslice." unless options[:date_from].match?(/\A\d*\z/)
abort "Rok --do musí obsahovat jen číslice." unless options[:date_to].match?(/\A\d*\z/)

base = "https://digi.ceskearchivy.cz"
user_agent = "Mozilla/5.0"

def run!(*command)
  stdout, stderr, status = Open3.capture3(*command)
  abort "Příkaz selhal (#{status.exitstatus}): #{command.first}\n#{stderr}" unless status.success?
  stdout
end

def php_serialize(fields)
  body = fields.map do |key, value|
    encoded_key = "s:#{key.bytesize}:\"#{key}\";"
    encoded_value = if value.is_a?(Integer)
      "i:#{value};"
    else
      "s:#{value.bytesize}:\"#{value}\";"
    end
    encoded_key + encoded_value
  end.join
  "a:#{fields.length}:{#{body}}"
end

def text_only(html)
  CGI.unescapeHTML(html.gsub(/<[^>]+>/, " ").gsub("&nbsp;", " "))
    .gsub(/\s+/, " ").strip
end

slug = query.downcase.gsub(/[^[:alnum:]]+/u, "_").gsub(/\A_|_\z/, "")
default_output = File.join("tmp", "hledani_matriky_#{slug.empty? ? 'dotaz' : slug}.html")
output = options[:output] || default_output
FileUtils.mkdir_p(File.dirname(output))

fields = [
  ["searchtype", "3"],
  ["searcharch", ""],
  ["search", query],
  ["autor", ""],
  ["evc", ""],
  ["date_from", options[:date_from]],
  ["date_to", options[:date_to]],
  ["allwords", 0],
  ["userp", "1"],
  ["date_b_from", ""],
  ["date_b_to", ""],
  ["date_m_from", ""],
  ["date_m_to", ""],
  ["date_d_from", ""],
  ["date_d_to", ""],
  ["search_in", ""],
  ["subtyp", ""],
  ["ftx_id2", ""],
  ["ftx_page", ""],
  ["ai", ""],
  ["imagecontent", ""]
]

Dir.mktmpdir("zahradka-trebon-search-") do |work_dir|
  cookies = File.join(work_dir, "cookies.txt")
  search_page = File.join(work_dir, "search.html")
  query_params = {
    new: 1,
    menu: 1,
    sst: options[:page],
    id: "",
    doctree: 10,
    searchtype: 3,
    search: query,
    date_from: options[:date_from],
    date_to: options[:date_to],
    userp: 1
  }

  run!(
    "curl", "-fsSL", "-A", user_agent,
    "-c", cookies,
    "#{base}/pages/search.php?#{URI.encode_www_form(query_params)}",
    "-o", search_page
  )

  run!(
    "curl", "-fsSL", "-A", user_agent,
    "-b", cookies, "-c", cookies,
    "--data-urlencode", "sparam=#{php_serialize(fields)}",
    "--data", "zalozky=&obsah_sn=0&lang=cs&sst=#{options[:page]}&order=rel&ih=900&iw=1400&histstore=0",
    "#{base}/pages/search_result.php?id=&queryid=&doctree=10",
    "-o", output
  )
end

html = File.binread(output).force_encoding("UTF-8")
count = html[/id='pocet' value='(\d+)'/, 1]

if html.include?("Nic nebylo nalezeno") || count == "0"
  puts "Nenalezen žádný indexovaný zápis. HTML: #{output}"
  exit 0
end

puts "Počet hlášených výsledků: #{count || 'neurčen'}"
puts "HTML: #{output}"

chunks = html.split(/(?=<div id='[^']+' class='hledat_telo')/)
records = chunks.filter_map do |chunk|
  next unless chunk.start_with?("<div id=") && chunk.include?("class='hledat_telo'")

  pairs = chunk.scan(
    /<tr><td[^>]*class='popis3b_nadpis[^']*'[^>]*>(.*?)<\/td><td[^>]*class='popis3b[^']*'[^>]*>(.*?)<\/td><\/tr>/m
  ).to_h { |label, value| [text_only(label), text_only(value)] }
  next if pairs.empty?

  link = chunk[/top\.location\.href="([^"]+)"/, 1]
  [pairs, link]
end

records.each_with_index do |(record, link), index|
  summary = ["Jméno", "Druh", "Rok", "Lokalita", "Kniha", "Snímek"].filter_map do |key|
    "#{key}: #{record[key]}" if record[key]
  end.join(" | ")
  puts "#{index + 1}. #{summary}"
  puts "   #{base}#{link}" if link
end
