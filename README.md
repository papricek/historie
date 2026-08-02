# Historie dvora na Zahrádce u Pošné

Průběžný výzkum vrchnostenského hospodářského dvora na stavební parcele **st. 1**
s domem **čp. 11** v Zahrádce u Pošné (okr. Pelhřimov) a jeho obyvatel.

Vizuální souhrn běží na **https://historie.poutnazahradce.cz** (zdroj: `website/index.html`).

## Obsah

- `vyzkum_statku.md` — výzkumný spis ke stavbě, držbě a pramenům
- `obyvatele_zahradky.md` — evidence osob doložených u čp. 11 (1772–1930)
- `zadost_o_archivni_prameny.md` — připravené žádosti do archivů (neodeslané)
- `josef.md` — původní korespondence a zachycené stopy
- `obyvatele_zahradky_domy.md` — hlavní jmenný registr celé vsi podle čísel popisných; obsahuje úplné sčítání 1921, index narozených 1788–1796 a úplné domovní inventáře zahrádeckých oddílů knih 6620 (1797–1843, snímky 80–117) a 6621 (1844–1880, snímky 309–362); u smíšených stran jsou převzaty jen řádky Zahrádky
- `obyvatele_zahradky_domy/dolozene_pobyty.md` — generovaný průřez po domech; u každé osoby uvádí datum nebo mezní data nalezených dokladů (2 001 dokladových řádků v 26 domech)
- `rekonstrukce_20_stoleti.md` — doplňkový generovaný podklad k existenci domů v řezech 1950, 1980 a 2000; stavební vývoj není hlavní osou výzkumu
- `rekonstrukce_20_stoleti_data.json` — kanonická strukturovaná data 32 domů × 3 řezy pro katalog i interaktivní mapu; upravovat zde, potom spustit `ruby nastroje/vytvorit_rekonstrukci_20_stoleti.rb` a `ruby nastroje/vytvorit_mapova_data.rb`
- `obyvatele_1950_2026.md` — hlavní čitelný odrážkový katalog poválečných obyvatel po všech 32 čp.; začíná rychlým indexem a přísně odděluje bydliště, úřední či veřejný kontakt, sídlo podnikání a nedatovanou vlastnickou stopu
- `obyvatele_1950_2026_data.json` — kanonická data poválečných osobních stop pro katalog i mapu; upravovat zde, potom spustit `ruby nastroje/vytvorit_obyvatele_1950_2026.rb` a `ruby nastroje/vytvorit_mapova_data.rb`
- `mezery_obyvatel_1950_2026.csv` — generovaný kontrolní plán 32 domů × roky 1950/1980/2000/2026; u každého řezu uvádí výsledek, nejbližší jmennou oporu, domovní OCR audit veřejných smluv a konkrétní fond či způsob dalšího ověření; výslovně rozlišuje poslední zahrádecký domovní pramen z roku 1978 od pošenského seznamu čp. 1–50
- `archivni_prepis_obyvatel.csv` — prázdná importní šablona pro úplný přepis domovních seznamů 1950/1980/2000; jeden řádek na osobu nebo neobydlený dům, vždy s přesnou archivní citací
- `vlastnici_2026_kontrolni_list.csv` — předvyplněný kontrolní list všech čp. pro ruční nebo úřední ověření vlastníků; u 26 existujících adres obsahuje parcelu, stavební objekt a adresní místo, vlastnická pole zůstávají záměrně prázdná
- `obyvatele_zahradky_domy/n11.md` — generovaný domovní pohled na 230 bezpečných osobních řádků N11 / čp. 11 a tři adresně sporné řádky N11/N14
- `mistni_jmenne_stopy.md` — oddělená evidence uživatelské místní znalosti, oprav příjmení a relativních poloh rodin; bez automatického domýšlení čísel domů
- `website/` — jednosouborový web (HTML + inline data a grafy)
- `prameny_online/**/README.md` — katalogy stažených pramenů (samotné obrazy a PDF nejsou verzovány)
- `nastroje/` — pomocné skripty
- `HANDOFF.md` — rychlý start: struktura webu, nasazení, konvence

Obrazové soubory (matriční výřezy, mapy, fotografie) a PDF jsou drženy jen lokálně;
jejich původ a veřejné odkazy dokumentují katalogy v `prameny_online/`.
