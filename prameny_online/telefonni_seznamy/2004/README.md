# Český telefonní seznam 2004 Standard

- Zdroj: [veřejný obraz CD na Internet Archive](https://archive.org/details/cesky-telefon-2004-s).
- Edice: **2004**; databázový soubor `cztel.mdb` na obrazu má datum **14. 11. 2003**.
- Přesná lokalita v číselníku `OBEC`: **Zahrádka u Pošné**, ID **9231**. Tím jsou vyloučeny Hrobská Zahrádka, Zahrádka bez bližšího určení i jiné stejnojmenné obce.
- ISO: 485 982 208 bajtů, SHA-256 `698e157a6ad2b934d3f236eee02c0267bdc892e774fc7567e02421ed14cd7033`.
- `cztel.mdb`: 456 028 160 bajtů, SHA-256 `9a3f710ccfea0fdda848d457234b697ad8c42a19492f37cf8081c204b77fcb62`.
- Osobní část byla projita celá po 76 548 datových stránkách; nalezeno bylo **9 přesných řádků osoba–čp.**
- Firemní část byla projita celá po 12 126 datových stránkách; jediným výsledkem je veřejná telefonní stanice bez čp.
- Telefonní čísla nebyla exportována ani uložena.

## Výsledky po domech

- **Čp. 5:** Petr Veverka.
- **Čp. 6:** Zdeněk Svoboda.
- **Čp. 7:** Karel Adam.
- **Čp. 8:** Marie Křížová; totožnost s Marií Křížovou doloženou u domu roku 1956 není tímto pramenem prokázána.
- **Čp. 16:** Miroslav Kubiska.
- **Čp. 21:** Václav Dörrschmidt.
- **Čp. 24:** Ing. Jan Velich.
- **Čp. 27:** Ludmila Rohovcová.
- **Čp. 28:** Václav Bulant.

Všech devět vazeb jméno–čp. se nezávisle opakuje už v [Českém telefonu 2000](../2000/README.md); edice 2004 naopak neobsahuje tamní desátou vazbu Bohuslava Nacházela na čp. 29. Jde o historické adresy osobních telefonních stanic. Takový záznam silně spojuje uvedenou osobu s adresou, ale sám nedokládá trvalý pobyt, vlastnictví domu ani všechny členy domácnosti.

Strojově čitelný výsledek je v souboru [`zahradka_u_posne.json`](zahradka_u_posne.json). Reprodukce výběru z původního MDB:

```bash
python3 -m pip install --target /tmp/access_parser_deps access-parser
PYTHONPATH=/tmp/access_parser_deps \
  python3 nastroje/proverit_telefonni_seznam_2004.py \
  /cesta/k/cztel.mdb --include-businesses
```

Skript zpracovává databázi pouze pro čtení a telefonní čísla záměrně nezapisuje.
