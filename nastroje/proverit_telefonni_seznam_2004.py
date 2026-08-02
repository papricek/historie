#!/usr/bin/env python3
"""Vyčte jednu přesnou obec z archivního MDB Českého telefonu 2004.

Skript záměrně neexportuje telefonní čísla. Z osobní části zachová jen jméno,
adresní pole a interní identifikátor zdrojového řádku; z firemní části obdobně
jen název a adresu. Potřebuje čistě čtecí balík ``access-parser``.
"""

from __future__ import annotations

import argparse
from collections import defaultdict
import json
import logging
from pathlib import Path
import sys
import unicodedata

try:
    from access_parser import AccessParser
except ModuleNotFoundError as exc:  # pragma: no cover - uživatelská diagnostika
    raise SystemExit(
        "Chybí access-parser. Nainstalujte jej například do dočasného adresáře "
        "příkazem: python3 -m pip install --target /tmp/access_parser_deps access-parser"
    ) from exc


SOURCE_URL = "https://archive.org/details/cesky-telefon-2004-s"
LOOKUP_TABLES = {
    "OBEC": "OBEC",
    "CAST": "CAST",
    "CP": "CP",
    "PSC": "PSC",
    "ULICE": "ULICE",
    "PRIJMENI": "PRIJMENI",
    "JMENO": "JMENO",
    "TITUL": "TITUL",
    "FIRMA": "FIRMA",
}


def repair_text(value: object) -> object:
    """Opraví CP1250, kterou access-parser vrací jako jednobajtové Unicode."""

    if not isinstance(value, str):
        return value
    raw = bytes(ord(char) & 0xFF for char in value)
    return raw.decode("cp1250", errors="replace")


def normalized(value: object) -> str:
    text = unicodedata.normalize("NFKD", str(value))
    return "".join(char for char in text if not unicodedata.combining(char)).casefold()


def lookup(parser: AccessParser, table_name: str, value_column: str) -> dict[int, object]:
    table = parser.parse_table(table_name)
    ids = table["ID"]
    values = table[value_column]
    if len(ids) != len(values):
        raise RuntimeError(f"Tabulka {table_name} má nestejně dlouhé sloupce")
    return {row_id: repair_text(value) for row_id, value in zip(ids, values)}


def stream_matching_rows(
    parser: AccessParser,
    table_name: str,
    locality_id: int,
) -> list[dict[str, object]]:
    """Parsuje velkou tabulku po jedné datové stránce a drží jen cílovou obec."""

    access_table = parser.get_table(table_name)
    pages = list(access_table.table.linked_pages)
    matches: list[dict[str, object]] = []

    for page_number, page in enumerate(pages, start=1):
        access_table.table.linked_pages = [page]
        access_table.parsed_table = defaultdict(list)
        parsed = access_table.parse()
        row_count = len(parsed.get("ID", []))
        for row_index in range(row_count):
            if parsed["ID_Obec"][row_index] != locality_id:
                continue
            matches.append({column: parsed[column][row_index] for column in parsed})

        if page_number % 10_000 == 0:
            print(
                f"{table_name}: {page_number}/{len(pages)} stran, "
                f"nalezeno {len(matches)} řádků",
                file=sys.stderr,
            )

    access_table.table.linked_pages = pages
    return matches


def resolved_address(row: dict[str, object], maps: dict[str, dict[int, object]]) -> dict[str, object]:
    def resolve(table_name: str, field_name: str) -> object:
        value = row.get(field_name)
        return maps[table_name].get(value) if value not in (None, 0) else None

    return {
        "obec": resolve("OBEC", "ID_Obec"),
        "cast": resolve("CAST", "ID_Cast"),
        "ulice": resolve("ULICE", "ID_Ulice"),
        "cp": resolve("CP", "ID_CP"),
        "psc": resolve("PSC", "ID_PSC"),
    }


def clean_name(parts: list[object]) -> str:
    return " ".join(str(part).strip() for part in parts if part not in (None, "")).strip()


def main() -> None:
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument("mdb", type=Path)
    argument_parser.add_argument("--locality", default="Zahrádka u Pošné")
    argument_parser.add_argument("--include-businesses", action="store_true")
    args = argument_parser.parse_args()

    if not args.mdb.is_file():
        raise SystemExit(f"MDB neexistuje: {args.mdb}")

    logging.getLogger("access_parser").setLevel(logging.CRITICAL)
    parser = AccessParser(str(args.mdb))
    maps = {
        table_name: lookup(parser, table_name, value_column)
        for table_name, value_column in LOOKUP_TABLES.items()
    }

    locality_candidates = [
        row_id
        for row_id, name in maps["OBEC"].items()
        if normalized(name) == normalized(args.locality)
    ]
    if len(locality_candidates) != 1:
        raise SystemExit(
            f"Očekávána jedna přesná obec {args.locality!r}, nalezeno {locality_candidates}"
        )
    locality_id = locality_candidates[0]

    person_rows = stream_matching_rows(parser, "Osoby", locality_id)
    persons = []
    for row in person_rows:
        person = clean_name(
            [
                maps["TITUL"].get(row.get("ID_Titul")),
                maps["JMENO"].get(row.get("ID_Jmeno")),
                maps["PRIJMENI"].get(row.get("ID_Prijmeni")),
            ]
        )
        persons.append(
            {
                "source_row_id": row.get("ID"),
                "person": person,
                **resolved_address(row, maps),
            }
        )

    businesses = []
    if args.include_businesses:
        business_rows = stream_matching_rows(parser, "Firmy", locality_id)
        for row in business_rows:
            businesses.append(
                {
                    "source_row_id": row.get("ID"),
                    "organization": maps["FIRMA"].get(row.get("ID_Firma")),
                    **resolved_address(row, maps),
                }
            )

    def unique_sorted(rows: list[dict[str, object]], name_field: str) -> list[dict[str, object]]:
        seen: set[tuple[object, ...]] = set()
        result = []
        for row in sorted(
            rows,
            key=lambda item: (
                normalized(item.get("cp")),
                normalized(item.get(name_field)),
                item.get("source_row_id") or 0,
            ),
        ):
            identity = tuple(row.get(field) for field in row)
            if identity in seen:
                continue
            seen.add(identity)
            result.append(row)
        return result

    output = {
        "source": "Český telefonní seznam 2004 Standard",
        "source_url": SOURCE_URL,
        "source_iso_sha256": "698e157a6ad2b934d3f236eee02c0267bdc892e774fc7567e02421ed14cd7033",
        "source_database_sha256": "9a3f710ccfea0fdda848d457234b697ad8c42a19492f37cf8081c204b77fcb62",
        "edition": "2004; databázový soubor na ISO má datum 14. 11. 2003",
        "locality": args.locality,
        "locality_id": locality_id,
        "evidence_class": (
            "historická adresa účastnické stanice; sama nedokládá trvalý pobyt, "
            "vlastnictví ani všechny členy domácnosti"
        ),
        "privacy": "Telefonní čísla nebyla exportována.",
        "persons": unique_sorted(persons, "person"),
        "businesses": unique_sorted(businesses, "organization"),
    }
    output["person_rows"] = len(output["persons"])
    output["business_rows"] = len(output["businesses"])
    print(json.dumps(output, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
