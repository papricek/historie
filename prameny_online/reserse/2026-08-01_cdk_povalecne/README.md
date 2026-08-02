# Celostátní audit České digitální knihovny, 1. 8. 2026

Cílem bylo ověřit, zda agregovaný fulltext České digitální knihovny obsahuje
další poválečnou vazbu **jméno – Zahrádka u Pošné – číslo popisné**, která
unikla samostatným rešerším Krameria KK Vysočiny a JVK/CBVK.

## Výsledek

- Přesný dotaz `text_ocr:"Zahrádka u Pošné"` vrátil **103 stran**; **23** z
  nich bylo veřejně přístupných. Uložena jsou metadata i krátké OCR úryvky
  všech výsledků v [vysledky.json](vysledky.json).
- Zastoupené sbírky: NKP 51, MZK 44, CBVK 23, SVK Hradec Králové 1 a SVK Ústí
  nad Labem 1. Součet je vyšší než 103, protože jedna stránka může být
  agregována z více sbírek.
- **Nepřibyla žádná nová poválečná osoba spojená s konkrétním čp. ani nový
  přímý doklad bydliště.** Poválečné výsledky tvoří hlavně statistické
  lexikony, územní a katastrální seznamy a duplikáty již známých pramenů.
- Jihočeská Pravda z 17. 11. 1989 zmiňuje soudružku Tomanovou a metodičku
  Zdeňku Zemanovou v článku o knihovnách. Text je nedokládá jako obyvatelky
  Zahrádky a neuvádí čp.; do domovní evidence proto nepatří.
- Čtyři dříve odložené stránky týdeníku *Zítřek* z let 1960–1968 nejsou
  pelhřimovským pramenem. Metadata je řadí k okresu Písek a text se týká jiné
  Zahrádky na Milevsku. Kandidáti čp. 8, 16, 29 a 31 jsou tím uzavřeni jako
  **falešná geografická shoda**.
- Audit nezměnil bilanci katalogu: 18 z 32 čp. má nějakou poválečnou osobní
  stopu a 7 čp. přímý doklad bydliště. Přesné domovní řezy 1950 a 1980
  zůstávají bez jmen.

## Metoda a omezení

- Reprodukovatelný průchod provádí
  [`nastroje/proverit_cdk_zahradka.rb`](../../../nastroje/proverit_cdk_zahradka.rb).
  Stránkuje celý výsledek klientského API v7, ukládá identifikátor, datum,
  titul, stránku, sbírku, přístupnost a nejvýše dva OCR úryvky.
- Použitý endpoint je
  [api.ceskadigitalniknihovna.cz](https://api.ceskadigitalniknihovna.cz/search/api/client/v7.0/search).
- Krátký OCR úryvek je pouze vyhledávací kandidát. Společný výskyt jména a vsi
  na jedné novinové straně sám neprokazuje, že člověk ve vsi bydlel nebo patřil
  ke konkrétnímu domu.
- Přesná fráze může minout chybu OCR nebo zápis bez přívlastku „u Pošné“.
  Proto je tento audit doplňkem již provedených variantních dotazů, nikoli
  důkazem absolutní úplnosti digitálního tisku.
