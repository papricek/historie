#!/usr/bin/env ruby
# frozen_string_literal: true

# Vyčte přesnou obec z databáze Českého telefonu 2000. Telefonní čísla se
# záměrně nepřebírají do mezivýsledku ani do JSON výstupu. Databáze je Jet 3
# a k bezpečnému čtení vyžaduje mdb-export z projektu mdbtools.

require "csv"
require "digest"
require "json"
require "open3"
require "optparse"

SOURCE_URL = "https://archive.org/details/czchip200012cd"
SOURCE_BIN = "Chip_2000-12_cd2.bin"
SOURCE_BIN_SHA1 = "291573f9669e3893b4452b6246862bd6a1fc0f0c"
SOURCE_BIN_MD5 = "afb193142f9c6dde9b97ff8c2f22c3c7"
SOURCE_BIN_SHA256 = "d9778d448d251e8f65e0fe8d4e98a5fa3b0782a40c19fc50b7cd6e92020aa38d"
SOURCE_ISO_SHA256 = "a06a548a60d06196d040c5f907e8673b363350d9baa3401895eacdf1ebd3ff39"
ADVERTISED_NUMBERS = 3_488_096

options = {
  locality: "Zahrádka u Pošné",
  mdb_export: ENV.fetch("MDB_EXPORT", "mdb-export"),
  include_businesses: false
}

OptionParser.new do |parser|
  parser.banner = "Použití: #{File.basename($PROGRAM_NAME)} [volby] /cesta/Telefony.txt"
  parser.on("--locality NÁZEV", "přesný název obce") { |value| options[:locality] = value }
  parser.on("--mdb-export CESTA", "cesta k mdb-export") { |value| options[:mdb_export] = value }
  parser.on("--include-businesses", "prověřit také firemní tabulku") { options[:include_businesses] = true }
end.parse!

mdb_path = ARGV.fetch(0) { abort "Chybí cesta k databázi Telefony.txt" }
abort "Databáze neexistuje: #{mdb_path}" unless File.file?(mdb_path)

def clean(value)
  value&.strip
end

def export_table(mdb_export, mdb_path, table)
  rows = 0
  selected = []
  error_text = +""

  Open3.popen3({ "MDB_JET3_CHARSET" => "WINDOWS-1250" }, mdb_export, mdb_path, table) do |stdin, stdout, stderr, wait_thread|
    stdin.close
    error_reader = Thread.new { error_text << stderr.read }
    CSV.new(stdout, headers: true).each do |row|
      rows += 1
      item = yield(row)
      selected << item if item
    end
    error_reader.join
    abort "mdb-export #{table} selhal: #{error_text.strip}" unless wait_thread.value.success?
  end

  [rows, selected]
rescue Errno::ENOENT
  abort "Nenalezen mdb-export: #{mdb_export}. Nainstalujte mdbtools nebo použijte --mdb-export."
end

locality = options.fetch(:locality)
person_rows, persons = export_table(options.fetch(:mdb_export), mdb_path, "Osoby") do |row|
  next unless clean(row["Mesto"]) == locality

  person = [row["Titul"], row["Jmeno"], row["Prijmeni"]]
           .map { |value| clean(value) }.compact.reject(&:empty?).join(" ")
  {
    "source_row_id" => Integer(row.fetch("ID")),
    "person" => person,
    "ulice" => clean(row["Ulice"]),
    "psc" => clean(row["PSC"]),
    "obec" => clean(row["Mesto"]),
    "cast" => clean(row["Cast"]),
    "cp" => clean(row["CP"]),
    "uto" => clean(row["UTO"])
  }
end

business_rows = nil
businesses = []
if options.fetch(:include_businesses)
  business_rows, businesses = export_table(options.fetch(:mdb_export), mdb_path, "Firmy") do |row|
    next unless clean(row["Mesto"]) == locality

    {
      "source_row_id" => Integer(row.fetch("ID")),
      "organization" => clean(row["Firma"]),
      "contact" => clean(row["Osoba"]),
      "ulice" => clean(row["Ulice"]),
      "psc" => clean(row["PSC"]),
      "obec" => clean(row["Mesto"]),
      "cast" => clean(row["Cast"]),
      "cp" => clean(row["CP"]),
      "uto" => clean(row["UTO"])
    }
  end
end

persons.sort_by! { |item| [item.fetch("cp").to_i, item.fetch("person"), item.fetch("source_row_id")] }
businesses.sort_by! do |item|
  [(item["cp"] || "").to_i, item["organization"] || "", item.fetch("source_row_id")]
end

output = {
  "source" => "Český telefon 2000 — CD Chip 12/2000",
  "source_url" => SOURCE_URL,
  "source_bin" => SOURCE_BIN,
  "source_bin_sha1" => SOURCE_BIN_SHA1,
  "source_bin_md5" => SOURCE_BIN_MD5,
  "source_bin_sha256" => SOURCE_BIN_SHA256,
  "source_iso_sha256" => SOURCE_ISO_SHA256,
  "source_database_sha256" => Digest::SHA256.file(mdb_path).hexdigest,
  "date_scope" => {
    "persons" => "údaje z bytových seznamů platných do dubna 2000",
    "businesses" => "údaje z firemních seznamů platných do ledna 2000"
  },
  "advertised_numbers" => ADVERTISED_NUMBERS,
  "locality" => locality,
  "evidence_class" => "historická adresa osobní telefonní stanice; sama nedokládá trvalý pobyt, vlastnictví ani všechny členy domácnosti",
  "privacy" => "Telefonní čísla nebyla exportována.",
  "person_rows_scanned" => person_rows,
  "business_rows_scanned" => business_rows,
  "persons" => persons,
  "businesses" => businesses,
  "person_matches" => persons.length,
  "business_matches" => businesses.length,
  "phone_numbers_exported" => 0
}

puts JSON.pretty_generate(output)
