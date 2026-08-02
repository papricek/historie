# Český telefon 2000 — Zahrádka u Pošné

- **Pramen:** veřejný obraz druhého CD přílohy *Chip 12/2000*, označený „Český telefon“, na [Internet Archive](https://archive.org/details/czchip200012cd).
- **Časový rozsah:** zadní strana obalu uvádí, že osobní údaje byly zpracovány z bytových seznamů platných do **dubna 2000** a firemní údaje ze seznamů platných do **ledna 2000**.
- **Výsledek:** osobní tabulka obsahuje deset přesných shod pro obec `Zahrádka u Pošné`; firemní tabulka jednu veřejnou telefonní stanici bez čp.
- **Význam:** jde o přesně datovanou účastnickou adresu, ne automaticky o trvalý pobyt, vlastnictví nebo úplný seznam členů domácnosti.
- **Soukromí:** telefonní čísla nebyla exportována ani uložena.

## Osobní účastnické adresy

- **čp. 5:** Petr Veverka — zdrojový řádek 619676.
- **čp. 6:** Zdeněk Svoboda — zdrojový řádek 619253.
- **čp. 7:** Karel Adam — zdrojový řádek 616737.
- **čp. 8:** Marie Křížová — zdrojový řádek 618082; totožnost s Marií Křížovou doloženou u téhož čp. roku 1956 není ověřena.
- **čp. 16:** Miroslav Kubiska — zdrojový řádek 618115.
- **čp. 21:** Václav Dörrschmidt — zdrojový řádek 617124.
- **čp. 24:** Ing. Jan Velich — zdrojový řádek 619652.
- **čp. 27:** Ludmila Rohovcová — zdrojový řádek 618990.
- **čp. 28:** Václav Bulant — zdrojový řádek 616944; samostatný rejstříkový pramen dokládá jeho adresu čp. 28 i po celý rok 2000.
- **čp. 29:** Bohuslav Nacházel — zdrojový řádek 618536; první nalezená poválečná osobní stopa tohoto čísla.

Prvních devět vazeb jméno–čp. se nezávisle opakuje v [Českém telefonním seznamu 2004](../2004/README.md). To podporuje správnost opisu adres, ale neprokazuje nepřetržité bydliště mezi oběma edicemi.

## Úplnost a kontrolní součty

- Obal inzeruje **3 488 096** telefonních čísel.
- Uložená osobní tabulka má **2 792 529** řádků a firemní tabulka **695 562** řádků, dohromady **3 488 091**. Rozdíl pěti záznamů proti údaji na obalu není vysvětlován odhadem.
- Původní `Chip_2000-12_cd2.bin`: SHA-1 `291573f9669e3893b4452b6246862bd6a1fc0f0c`, MD5 `afb193142f9c6dde9b97ff8c2f22c3c7`, SHA-256 `d9778d448d251e8f65e0fe8d4e98a5fa3b0782a40c19fc50b7cd6e92020aa38d`.
- Mechanicky odvozené ISO: SHA-256 `a06a548a60d06196d040c5f907e8673b363350d9baa3401895eacdf1ebd3ff39`.
- Databáze `Telefony.txt` (Microsoft Access Jet 3): SHA-256 `8a2e4ed15555a2de590dbfdd7492f137718f7c9f1b8675d77f466c48058019d9`.
- Strojový výsledek je v [zahradka_u_posne.json](zahradka_u_posne.json).

## Reprodukce výpisu

Databáze je šifrovaný Jet 3 a vyžaduje `mdb-export` z projektu mdbtools. Po rozbalení obrazu CD lze kontrolu zopakovat:

```sh
ruby nastroje/proverit_telefonni_seznam_2000.rb \
  --mdb-export /cesta/k/mdb-export \
  --include-businesses \
  /cesta/k/Telefony.txt
```

Skript projde celé tabulky, vybere jen přesnou hodnotu obce `Zahrádka u Pošné` a do výstupu vůbec nezařazuje sloupec s telefonním číslem.
