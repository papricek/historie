# Nástroje použité při výzkumu

Tato složka uchovává reprodukovatelné postupy, které by jinak zůstaly jen v dočasném adresáři nebo v historii terminálu. Skripty samy nic netvrdí o totožnosti osob či staveb; interpretace a odkazy na uložené výstupy jsou v `vyzkum_statku.md`, `obyvatele_zahradky.md` a `prameny_online/README.md`.

## SOA Třeboň: obrazy a jmenný rejstřík

### Stažení jednoho snímku podle knihy a čísla

```bash
nastroje/stahnout_sken_trebon_z_knihy.sh 6623 73 /tmp/snim73.jpg
```

Skript načte veřejný náhled knihy, zjistí interní `data1` identifikátor a zavolá `stahnout_sken_trebon.sh`. Ten přečte Zoomify popis obrazu, stáhne dlaždice a složí je přes ImageMagick. Volitelný čtvrtý argument určuje úroveň pyramidy; bez něj se použije maximum.

Přímý nízkoúrovňový tvar zůstává k dispozici pro již známý obrazový identifikátor:

```bash
nastroje/stahnout_sken_trebon.sh 114020796 /tmp/snim73.jpg 3 6623 73
```

Závislosti: `curl`, `ruby`, ImageMagick (`magick`). Server vyžaduje běžný `User-Agent` a `Referer`; oba skripty je nastavují.

Souvislý rozsah stáhne:

```bash
nastroje/stahnout_rozsah_skenu_trebon.sh 6623 73 75 /tmp/oddani_1841
```

### Veřejný elektronický rejstřík matrik

```bash
ruby nastroje/hledat_matriky_trebon.rb \
  -o tmp/josef_dominik_emerich.html \
  '+Josef +Dominik +Emerich'
```

Podporované jsou stejné operátory jako na webu archivu: `slovo`, `začátek*`, `+povinné`, `-vyloučené` a `"přesná fráze"`. Volby `--od ROK`, `--do ROK` a `--strana N` předávají časový filtr a stránkování. Skript nejprve založí webovou relaci přes `search.php`, potom odešle serializovaný dotaz na `search_result.php`, původní HTML uloží a na standardní výstup vypíše základní pole nalezených záznamů.

Elektronický rejstřík je jen výběrový. Nulový výsledek se v tomto výzkumu nikdy nepovažuje za důkaz, že událost neexistuje; rozhodující je kontrola originálních obrazů příslušné knihy.

## Stabilní katastr a Archiv ČÚZK

| Skript | Účel |
|---|---|
| `diagnostika_1829_lokalni.py` | souřadnicová mřížka, diagnostika a afinní překryv císařského otisku 1829 s dnešní st. 1 a objektem čp. 11 |
| `vykreslit_klad_1829.py` | vykreslení polygonu kladu stabilního katastru vráceného službou ČÚZK |
| `projit_archivni_vrstvy_st1.sh` | bodový dotaz souřadnicí S-JTSK `-705760,-1118170` do katalogových vrstev Archivu ČÚZK |
| `dotaz_pozdejsi_katastralni_mapy.sh` | cílená kontrola vrstvy 16, tedy možných mladších katastrálních map |
| `stahnout_originalni_mapy_8865.sh` | stažení čtyř konkrétních rastrů originální mapy Zahrádky, inventární číslo 8865 |

Tři shellové skripty pro Archiv ČÚZK očekávají dočasný výsledek tokenové úlohy v `tmp/lms_token_job.json`. Identifikátory rastrů a souřadnice jsou záměrně ponechány konkrétní pro tento výzkum, aby bylo zřejmé, co přesně bylo dotazováno. Výstupní JSON v `tmp/` je pracovní; popsané a důležité výsledky jsou katalogizovány v `prameny_online/mapy_katastralni/`.

## Sčítací operáty MZA

Veřejný prohlížeč sčítacích operátů MZA poskytuje obrazy jako dlaždice Deep Zoom.
Jeden snímek lze podle číselného ID digitální sady a pořadí v prohlížeči uložit takto:

```bash
nastroje/stahnout_sken_mza_scitani.sh 13183 4 /tmp/pe0584_snim004.jpg
```

Bez posledního argumentu skript použije přibližně poloviční rozlišení; hodnota `999`
vynutí nejvyšší dostupnou úroveň. Skript načte oficiální stránku sady, vybere z ní
příslušný DZI popis, stáhne dlaždice souběžně a složí je přes ImageMagick. Pro sadu
`PE0584` obce Zahrádka je veřejné ID `13183` a úplná mapa domů na snímky je v
`prameny_online/scitani_lidu/1921/zahradka_cela_obec/README.md`.

## Letecké snímky

`vytvorit_zarovnane_srovnani.py` reprodukuje badatelské zarovnání let 1949, 1953, 1961, 1967, 1975, 1978, 1990, 1992 a 2022 do geometrie ortofota 1953 a kreslí současnou st. 1 a objekt čp. 11. Matice jsou empirické podobnostní transformace odhadnuté podle cest a mezí mimo areál; nejde o úřední georeferenci. Závislosti: Python, NumPy a OpenCV.

## Pravidlo pro další práci

Nový opakovatelný postup nejprve uložit sem nebo jej přidat k existujícímu skriptu. Dočasný adresář `tmp/` je ignorovaný Gitem a nemá být jediným místem, kde algoritmus či dotaz přežije.

## Domovní index N11

Podrobná evidence `obyvatele_zahradky.md` zůstává autoritativní pro jednotlivé
prameny a míru jistoty. Její kompaktní domovní pohled se reprodukuje příkazem:

```bash
ruby nastroje/vytvorit_index_n11.rb
```

Výstup `obyvatele_zahradky_domy/n11.md` obsahuje všechny osobní řádky s přímou
vazbou k N11 / čp. 11 a samostatně adresně spornou rodinu N11/N14. Součet je počet
evidovaných osobních řádků, nikoli demografický součet unikátních obyvatel.

## Doložená období osob podle domů

Průřezový seznam, který ke každému člověku přidává datum nebo mezní data jeho
doložené vazby k domu, se obnoví příkazem:

```bash
ruby nastroje/vytvorit_domovni_pobyty.rb
```

Výstup `obyvatele_zahradky_domy/dolozene_pobyty.md` spojuje všech 174 obyvatel
sčítání 1921 s dosud přepsanými staršími zápisy a s úplným bezpečným indexem N11.
Rozsah let je rozsahem nalezených dokladů, nikoli tvrzením o nepřetržitém pobytu.
Generovaný výstup se ručně neopravuje; změny patří do hlavního domovního registru
nebo do zdrojové evidence N11.

## Interaktivní mapa vsi (website/mapa.html)

Dva generátory připravují podklady mapové stránky; samotná stránka se edituje ručně.

```bash
python3 nastroje/vytvorit_mapove_podklady.py   # vrstvy website/img/mapa/podklad_*.jpg
ruby nastroje/vytvorit_mapova_data.rb          # data website/mapa_data.js
```

`vytvorit_mapove_podklady.py` skládá všechny vrstvy do společného čtverce
600 m EPSG:5514 (stejný rám a stejné zarovnávací matice jako
`vytvorit_zarovnane_srovnani.py`; stačí mu ale jen Pillow a NumPy, OpenCV
nepotřebuje). Císařský otisk 1829 registruje řetězením kontrolních bodů z
`diagnostika_1829_lokalni.py` a korelačně doloženého umístění výřezu
`cisarsky_otisk_statek_st1.jpg` v listu II (měřítko přesně 2/3, posun 1250, 700;
NCC 0,979). Stejným řetězením přes otisk se registrují i originální mapa
s reambulací 1878 (list II) a rastr bývalého pozemkového katastru; parametry
a míry jistoty jsou komentovány přímo ve skriptu. Jde o badatelské zarovnání,
nikoli úřední georeferenci.

`vytvorit_mapova_data.rb` čte generovaný přehled
`obyvatele_zahradky_domy/dolozene_pobyty.md`, takže po každé změně registru je
pořadí: `vytvorit_domovni_pobyty.rb` → `vytvorit_mapova_data.rb` → nasazení webu.
Souřadnice bodů domů v `website/mapa.html` pocházejí z
`prameny_online/mapy_katastralni/2026/adresni_mista_zahradka_ruian.geojson`.

## Pováleční obyvatelé 1950–2026

Kanonická strukturovaná evidence je v `obyvatele_1950_2026_data.json`; přesné
řezy 1950/1980/2000 čte generátor také z `rekonstrukce_20_stoleti_data.json`.
Záznamy rozlišují přímé bydliště, pouhou úřední adresu, veřejnou kontaktní
adresu, sídlo podnikání, poslední známou adresu vlastníka, sídlo organizace,
statutární roli v organizaci u domu a žadatele úředního záměru vázaného k domu.
Samostatným typem je také historická adresa osobní telefonní stanice.
Statutární role, žadatel úředního záměru ani telefonní účastnická adresa nejsou
samy bydlištěm nebo vlastnictvím; telefonní záznam navíc není úplným soupisem
domácnosti.
Jmennou zpětnou kontrolu deseti účastníků z roku 2000 v plnotextu dvou
Krameriů reprodukuje `proverit_povalecna_jmena_kramerius.rb`. Hledá celé jméno
i příjmení společně s přesným názvem vsi, ale výstup ponechává jako kandidátní:
společný výskyt na jedné stránce není bez ručního přečtení vazbou osoby k obci
ani k domu.
Celostátní doplňkovou kontrolu provádí `proverit_cdk_zahradka.rb`. Přes
federované API České digitální knihovny stáhne všechny stránky s přesnou OCR
frází `Zahrádka u Pošné`, včetně sbírky, přístupnosti a krátkých úryvků:

```bash
ruby nastroje/proverit_cdk_zahradka.rb --as-of 2026-08-01 \
  --output prameny_online/reserse/2026-08-01_cdk_povalecne/vysledky.json
```

Výsledek je objevovací audit. Společný výskyt osoby a lokality na jedné straně
není bez ručního přečtení dokladem bydliště ani vazby ke konkrétnímu čp.
Časový rozsah je vždy jen rozsahem pramene. Pole `current_2026` samostatně říká,
zda podpůrná stopa stále platila k 1. 8. 2026; pouhý výskyt letopočtu 2026 nestačí.
Kanonická data obsahují také souhrnné audity `official_board_audit`,
`trade_register_audit`, `agricultural_register_audit`, `subsidy_register_audit`,
`election_register_audit`, `niv_register_audit` a `ownership_source_audit`.
Historické sídlo z RŽP se zapisuje s přesným
intervalem, ale vždy jako `business_address`; bydliště kandidáta z volebního
registru bez čp. patří pouze do `village_only`. Negativní kontrola aktuálních
zemědělských registrů je metodický audit a nevytváří prázdné osobní záznamy u
jednotlivých domů. Také obecní záznam příjemce dotace bez části obce a čp. se
nepřevádí na pobyt: u čp. 9 a 28 se zobrazuje jen jako oddělená jmenná stopa s
výslovným omezením.
Úplný průchod Českým telefonem 2000 je popsán v
`telephone_directory_2000_audit`: deset přesných osobních shod pochází z
bytových seznamů platných do dubna 2000. Navazující
`telephone_directory_audit` popisuje devět shod v edici 2004. Ukládá se jméno,
čp. a zdrojový řádek, nikoli telefonní číslo.
`current_telephone_audit` drží omezenou negativní kontrolu veřejného adresáře
1188 z 1. 8. 2026. Protože služba neposkytla úplný lokalitní výpis, nulový
výsledek nevytváří prázdné osobní záznamy a nesmí se vykládat jako nepřítomnost
obyvatele. `archival_source_audit` navíc eviduje fyzický Úřední telefonní
seznam roku 1950 ve čtyřech přesně určených exemplářích: Knihovna Národního
archivu IM489, Národní knihovna II 038397 a III 016575 a knihovna ČGHSP,
přírůstkové číslo 1428. Používají se jen jako doplněk sčítacího archu; stav
„dostupný“ se nesmí zaměnit za již přečtený obsah.
Odrážkový výstup a mapová data se obnoví v tomto pořadí:

```bash
ruby nastroje/vytvorit_obyvatele_1950_2026.rb
ruby nastroje/vytvorit_mapova_data.rb
```

První příkaz vytváří `obyvatele_1950_2026.md` s rychlým indexem hned nahoře a
s odrážkami 1950, 1980, 2000 a 2026 u každého čp. V domovním oddílu jsou
nejprve obyvatelé a časové řezy; bodové historické vlastnictví, současný
vlastník, technické identifikátory, veřejné
smlouvy a jediná orientační stavební věta následují až potom. Současně generuje
`mezery_obyvatel_1950_2026.csv` se 128 kontrolními řezy a přesným cílovým
fondem nebo způsobem ověření pro každý dům a rok. Každý řádek navíc nese
parcelu, identifikátor stavebního objektu a adresního místa, stav ručního
ověření vlastníka a samostatný výsledek OCR auditu veřejných smluv pro dané
čp.; nejde o důkaz úplnosti ani o náhradu pobytové evidence. Pole
`archival_source_audit` navíc drží živě ověřenou online dostupnost cílových
archiválií a katalogové signatury doplňkových telefonních seznamů; nulový počet
digitálních objektů se nesmí vykládat jako neexistence archiválie. Druhý příkaz
přidává do mapy objekty `window.MAPA_OBYVATELE` a `window.MAPA_VLASTNICI`.
Oba generátory vyžadují právě čp. 1–32. Jména možná
žijících osob se publikují jen v rozsahu veřejného úředního, rejstříkového nebo
adresního mediálního pramene. U společenské kroniky se přebírá jen jméno,
datum a přesná adresa; datum narození, rodinný vztah, údaje druhé osoby ani
telefonní číslo se do vrstvy nepřebírají.

Úplné archivní domovní seznamy se nejprve přepisují do
`archivni_prepis_obyvatel.csv`: jeden řádek na osobu, nebo jeden řádek na
neobydlený dům. Povinná je citace fondu, jednotky, data a strany/snímku;
moderní čp. se nesmí doplňovat jen podle shodného příjmení.

Současní vlastníci se doplňují do `vlastnici_2026_kontrolni_list.csv`. RÚIAN
identifikátory jsou předvyplněné, ale jméno vlastníka, podíl, LV, datum a zdroj
musí pocházet z ručního výpisu KN nebo z výstupu katastrálního pracoviště.
Vlastník se nikdy nepřenáší do obyvatelské osy bez samostatného pobytového
dokladu.

Přesné historické vlastnictví se v kanonických datech ukládá u domu do pole
`ownership`; nejbližší, ale parcelně nedoložený majetkový kontext patří do
`ownership_context`. Dotační formulář se smí převést do `ownership` pouze tehdy,
když současně určuje osobu, její vlastnickou způsobilost a stejné čp. nebo
stavební parcelu místa realizace. Takto jsou zatím doložena čp. 6, 15 a 28.
Čp. 27 zůstává odmítnutým kandidátem, protože příloha samostatně neidentifikuje
vlastněnou nemovitost. Tyto bodové doklady nesmějí vyplnit prázdný sloupec
současného vlastníka v `vlastnici_2026_kontrolni_list.csv`.

### Český telefon 2000

Druhé CD přílohy Chip 12/2000 obsahuje velkou databázi Microsoft Access Jet 3
v souboru `Telefony.txt`. Pro její čtení je potřeba `mdb-export` z projektu
mdbtools. Přesnou obec lze vyčíst bez exportu telefonních čísel:

```bash
ruby nastroje/proverit_telefonni_seznam_2000.rb \
  --mdb-export /cesta/k/mdb-export \
  --include-businesses \
  /cesta/k/Telefony.txt
```

Skript proudově projde celé tabulky `Osoby` a `Firmy`, vybere jen přesnou
hodnotu `Zahrádka u Pošné` a ověří kontrolní součet databáze. Reprodukovatelný
výstup a popis datace jsou v `prameny_online/telefonni_seznamy/2000/`.

### Český telefonní seznam 2004

Veřejný obraz CD obsahuje databázi `cztel.mdb`. Přesnou lokalitu Zahrádka u
Pošné, ID 9231, lze bezpečně vytěžit bez telefonních čísel takto:

```bash
python3 -m pip install --target /tmp/access_parser_deps access-parser
PYTHONPATH=/tmp/access_parser_deps \
  python3 nastroje/proverit_telefonni_seznam_2004.py \
  /cesta/k/cztel.mdb --include-businesses
```

Skript prochází velké tabulky po stránkách, používá přesný číselník obcí a
záměrně exportuje jen jméno nebo název, adresní pole a interní ID zdrojového
řádku. Uložený výsledek a oba kontrolní součty jsou v
`prameny_online/telefonni_seznamy/2004/`.

### Audit seznamů nedostatečně identifikovaných vlastníků

Veřejné soubory ÚZSVM/ČÚZK ve formátu `.xls` nebo `.xlsx` lze jednotně
zkontrolovat příkazem:

```bash
python3 nastroje/proverit_niv_zahradka.py /cesta/k/pelhrimov.xls --summary-only
```

Bez `--summary-only` skript vypíše také vybrané řádky. Odděleně počítá parcely
v k. ú. Zahrádka u Pošné, osoby s přesnou poslední známou adresou některého
zahrádeckého čp. a případné shody s přesnými stavebními parcelami dnešních domů
z `vlastnici_2026_kontrolni_list.csv`. Poslední známá adresa osoby, vlastnictví
uvedené parcely a vlastnictví domu jsou tři rozdílné vazby; skript je neslučuje.
Rodná čísla, IČ a jiné osobní identifikátory do výstupu nepřebírá.
