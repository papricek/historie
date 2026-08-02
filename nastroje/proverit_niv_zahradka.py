#!/usr/bin/env python3
"""Vybere zahrádecké řádky z veřejných seznamů NIV (.xls/.xlsx).

Skript záměrně nečte Nahlížení do KN. Z veřejného okresního nebo celostátního
souboru oddělí:

- parcely v k. ú. Zahrádka u Pošné 775606,
- osoby s přesnou poslední známou adresou Zahrádka {čp.}, 39501 Pošná,
- případné shody s přesnými stavebními parcelami dnešních domů.

Rodná čísla, IČ a jiné identifikátory osob se do výstupu nepřebírají.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
import sys
import unicodedata
import zipfile
from pathlib import Path
from typing import Iterable, Iterator
from xml.etree import ElementTree as ET


ROOT = Path(__file__).resolve().parent.parent
DEFAULT_OWNERS = ROOT / "vlastnici_2026_kontrolni_list.csv"
ADDRESS_RE = re.compile(r"^Zahrádka (\d+), 39501 Pošná$")
CADASTRAL_NAME = "Zahrádka u Pošné"


def local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def column_index(reference: str) -> int:
    letters = re.match(r"[A-Z]+", reference)
    if not letters:
        raise ValueError(f"Neplatný odkaz buňky: {reference}")
    value = 0
    for char in letters.group(0):
        value = value * 26 + ord(char) - ord("A") + 1
    return value - 1


def shared_strings(archive: zipfile.ZipFile) -> list[str]:
    try:
        stream = archive.open("xl/sharedStrings.xml")
    except KeyError:
        return []
    values: list[str] = []
    with stream:
        for _event, element in ET.iterparse(stream, events=("end",)):
            if local_name(element.tag) == "si":
                values.append("".join(element.itertext()))
                element.clear()
    return values


def xlsx_rows(path: Path) -> Iterator[list[object]]:
    with zipfile.ZipFile(path) as archive:
        strings = shared_strings(archive)
        sheets = sorted(
            name
            for name in archive.namelist()
            if re.fullmatch(r"xl/worksheets/sheet\d+\.xml", name)
        )
        if not sheets:
            raise ValueError("XLSX neobsahuje list s daty")
        with archive.open(sheets[0]) as stream:
            for _event, row in ET.iterparse(stream, events=("end",)):
                if local_name(row.tag) != "row":
                    continue
                cells: dict[int, object] = {}
                for cell in row:
                    if local_name(cell.tag) != "c":
                        continue
                    index = column_index(cell.attrib.get("r", ""))
                    cell_type = cell.attrib.get("t")
                    raw = None
                    for child in cell:
                        if local_name(child.tag) == "v":
                            raw = child.text
                            break
                        if local_name(child.tag) == "is":
                            raw = "".join(child.itertext())
                            break
                    if raw is None:
                        value: object = ""
                    elif cell_type == "s":
                        value = strings[int(raw)]
                    elif cell_type in {"inlineStr", "str"}:
                        value = raw
                    else:
                        value = raw
                    cells[index] = value
                width = max(cells, default=-1) + 1
                yield [cells.get(index, "") for index in range(width)]
                row.clear()


def xls_rows(path: Path) -> Iterator[list[object]]:
    try:
        import xlrd  # type: ignore
    except ImportError as error:
        raise RuntimeError("Pro čtení .xls je potřeba balíček xlrd") from error
    sheet = xlrd.open_workbook(path).sheet_by_index(0)
    for row_index in range(sheet.nrows):
        yield sheet.row_values(row_index)


def workbook_rows(path: Path) -> Iterator[list[object]]:
    if path.suffix.lower() == ".xls":
        yield from xls_rows(path)
    elif path.suffix.lower() == ".xlsx":
        yield from xlsx_rows(path)
    else:
        raise ValueError("Podporované jsou jen soubory .xls a .xlsx")


def normalized(value: object) -> str:
    decomposed = unicodedata.normalize("NFKD", str(value))
    ascii_value = "".join(char for char in decomposed if not unicodedata.combining(char))
    return re.sub(r"[^a-z0-9]+", "", ascii_value.lower())


def header_indexes(headers: list[object]) -> dict[str, int]:
    return {normalized(value): index for index, value in enumerate(headers) if str(value).strip()}


def find_column(indexes: dict[str, int], name: str) -> int:
    key = normalized(name)
    if key not in indexes:
        raise ValueError(f"V tabulce chybí sloupec: {name}")
    return indexes[key]


def value_at(row: list[object], index: int) -> object:
    return row[index] if index < len(row) else ""


def display_number(value: object) -> str:
    if isinstance(value, float) and value.is_integer():
        return str(int(value))
    text = str(value).strip()
    return text[:-2] if text.endswith(".0") and text[:-2].isdigit() else text


def canonical_parcel(formatted: object) -> str | None:
    text = str(formatted)
    match = re.search(r",\s*st\.\s*č\.\s*([0-9]+(?:/[0-9]+)?)", text, re.IGNORECASE)
    if match:
        return f"st.{match.group(1)}"
    match = re.search(r",\s*č\.\s*([0-9]+(?:/[0-9]+)?)", text, re.IGNORECASE)
    return f"p.{match.group(1)}" if match else None


def current_building_parcels(path: Path) -> dict[str, str]:
    result: dict[str, str] = {}
    with path.open(encoding="utf-8", newline="") as stream:
        for row in csv.DictReader(stream):
            parcel = row.get("stavebni_parcela", "").strip()
            match = re.fullmatch(r"st\.\s*([0-9]+(?:/[0-9]+)?)", parcel)
            if match:
                result[f"st.{match.group(1)}"] = row["cp"]
    return result


def sanitize_address(address: object) -> str:
    text = str(address).strip()
    if ADDRESS_RE.fullmatch(text) or text == "adresa neznámá":
        return text
    return "jiná adresa nezveřejněna" if text else ""


def analyze(path: Path, owners_path: Path, summary_only: bool) -> dict[str, object]:
    rows = workbook_rows(path)
    try:
        headers = next(rows)
    except StopIteration as error:
        raise ValueError("Prázdný tabulkový soubor") from error
    indexes = header_indexes(headers)

    ku_i = find_column(indexes, "Název kú")
    person_i = find_column(indexes, "OPSUB - název")
    address_i = find_column(indexes, "OPSUB - adresa")
    parcel_i = find_column(indexes, "Parcela (formátováno)")
    lv_i = find_column(indexes, "Číslo LV (parcela)")
    numerator_i = find_column(indexes, "Podíl čitatel")
    denominator_i = find_column(indexes, "Podíl jmenovatel")
    building_i = find_column(indexes, "Stavba (formátováno)")
    building_part_i = find_column(indexes, "stavba - název části obce")

    house_parcels = current_building_parcels(owners_path)
    selected: list[dict[str, object]] = []
    exact_ku_rows = 0
    exact_address_rows = 0
    exact_address_rows_outside_ku = 0
    people: set[str] = set()
    registers: set[str] = set()
    address_people: dict[str, set[str]] = {}
    parcel_matches: list[dict[str, str]] = []
    building_matches: list[dict[str, str]] = []

    for row_number, row in enumerate(rows, start=2):
        ku = str(value_at(row, ku_i)).strip()
        person = str(value_at(row, person_i)).strip()
        address = str(value_at(row, address_i)).strip()
        address_match = ADDRESS_RE.fullmatch(address)
        exact_ku = ku == CADASTRAL_NAME
        if not exact_ku and not address_match:
            continue

        exact_ku_rows += int(exact_ku)
        exact_address_rows += int(bool(address_match))
        exact_address_rows_outside_ku += int(bool(address_match) and not exact_ku)
        if person:
            people.add(person)
        if address_match:
            cp = address_match.group(1)
            address_people.setdefault(cp, set()).add(person)

        lv = display_number(value_at(row, lv_i))
        if lv:
            registers.add(lv)
        parcel_text = str(value_at(row, parcel_i)).strip()
        parcel_key = canonical_parcel(parcel_text)
        if parcel_key in house_parcels:
            parcel_matches.append(
                {"cp": house_parcels[parcel_key], "person": person, "parcel": parcel_text, "lv": lv}
            )

        building_text = str(value_at(row, building_i)).strip()
        building_part = str(value_at(row, building_part_i)).strip()
        building_cp = re.search(r"č\.\s*p\.\s*(\d+)", building_text, re.IGNORECASE)
        if building_cp and (building_part == "Zahrádka" or "část obce Zahrádka" in building_text):
            building_matches.append(
                {"cp": building_cp.group(1), "person": person, "building": building_text, "lv": lv}
            )

        if not summary_only:
            selected.append(
                {
                    "row": row_number,
                    "cadastral_area": ku,
                    "person": person,
                    "last_known_address": sanitize_address(address),
                    "share": f"{display_number(value_at(row, numerator_i))}/{display_number(value_at(row, denominator_i))}",
                    "parcel": parcel_text,
                    "parcel_lv": lv,
                    "building": building_text,
                }
            )

    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    result: dict[str, object] = {
        "source_file": str(path),
        "sha256": digest,
        "selected_rows": exact_ku_rows + exact_address_rows_outside_ku,
        "exact_cadastral_rows": exact_ku_rows,
        "exact_address_rows": exact_address_rows,
        "exact_address_rows_outside_cadastral_area": exact_address_rows_outside_ku,
        "distinct_people": sorted(people),
        "distinct_parcel_lvs": sorted(registers, key=lambda value: (not value.isdigit(), int(value) if value.isdigit() else value)),
        "address_people_by_house": {
            cp: sorted(names) for cp, names in sorted(address_people.items(), key=lambda item: int(item[0]))
        },
        "current_house_parcel_matches": parcel_matches,
        "zahradka_building_matches": building_matches,
        "privacy": "OPSUB r. č. / IČ a jiné osobní identifikátory se nevypisují.",
    }
    if not summary_only:
        result["rows"] = selected
    return result


def parse_args(argv: Iterable[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workbook", type=Path, help="veřejný soubor NIV ve formátu .xls nebo .xlsx")
    parser.add_argument("--owners", type=Path, default=DEFAULT_OWNERS, help="kontrolní list přesných stavebních parcel")
    parser.add_argument("--summary-only", action="store_true", help="nevypisovat jednotlivé řádky")
    return parser.parse_args(argv)


def main(argv: Iterable[str]) -> int:
    args = parse_args(argv)
    result = analyze(args.workbook.resolve(), args.owners.resolve(), args.summary_only)
    json.dump(result, sys.stdout, ensure_ascii=False, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
