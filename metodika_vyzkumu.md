# Metodika výzkumu a přehled pramenů

Souhrn metodiky používané při výzkumu vsi **Zahrádka u Pošné** (okres Pelhřimov)
a jejího dvora **čp. 11 / st. 1**, spolu s mapou pramenné základny. Podrobné
odůvodnění jednotlivých zjištění je vždy v příslušném spisu; tento soubor
popisuje, **jak** se pracuje a **kde** se hledá.

## Dvě linie výzkumu

1. **Dvůr N11 → st. 1 → čp. 11** — identita nemovitosti, držba, stavební vývoj,
   obyvatelé ([vyzkum_statku.md](vyzkum_statku.md)).
2. **Celá ves a přiřazování lidí ke konkrétním číslům domů** — hlavní směr od
   30. 7. 2026; kanonický registr je
   [obyvatele_zahradky_domy.md](obyvatele_zahradky_domy.md), novější dějiny obce
   1921–současnost shrnuje [vyzkum_1921_soucasnost.md](vyzkum_1921_soucasnost.md).

## Zásady

- **Každé tvrzení má pramen a míru jistoty** (`vysoká` / `střední` / `nízká`),
  s přesným odkazem: kniha + snímek (digi.ceskearchivy.cz), uuid strany
  (Kramerius), inventární číslo, strana tisku, URL registru. „Vysoká“ znamená,
  že údaj byl přečten přímo v primárním prameni.
- **Paleografie bez domýšlení.** Jména se přepisují, jak jsou zapsána; nejisté
  čtení se značí `(?)`, nečitelné se nechává nečitelným. Místní rodová znalost
  ([mistni_jmenne_stopy.md](mistni_jmenne_stopy.md): Plášil, Bulant, Pešta,
  Kříž, Kadlečík, Pudil, Coufal, Rohovec, Pachta…) smí pomoci při čtení rukopisu,
  nikdy nenahrazuje obrazový doklad. Relativní údaje („vedle“, „naproti“,
  „roubenka“) se nikdy nepřevádějí na odhadnuté čp.
- **Absence není důkaz.** Nulový výsledek hledání (fulltext, rejstřík, katalog)
  se zapisuje jako slepý konec, nikoli jako negativní fakt. Výjimkou je doložená
  skartace (např. sčítání 1961 pro okres Pelhřimov).
- **Adresní disciplína.** Historická domovní čísla (N11), stavební parcely
  (st. 1) a dnešní čp. jsou tři různé řady; **N1 je jiný dům než N11**. Adresní
  rozpory mezi paralelními prameny se nechávají otevřené. Interval dokladů
  (`1798–1800`) znamená jen krajní nalezené doklady, ne nepřetržité bydliště.
- **Slučování osob** jen při dostatečné shodě jména, dat, příbuzných nebo jiné
  identifikační opory; shoda příjmení sama nestačí.
- **Rozlišení lokalit.** Existuje více Zahrádek: **Zahrádka u Cetoraze (Hrobská
  Zahrádka)** je v témže okrese a patřila k farnosti Pacov; **zaniklá Zahrádka
  u Ledče nad Sázavou** ovládá výsledky vyhledávačů. Každý nález musí být
  ukotven souvýskytem s Pošnou, Pacovem, Pelhřimovem, Březinou nebo
  Outěchovicemi/Útěchovičkami. V dnešních katalozích funguje jen tvar
  **Útěchovičky / Útěchovice** (starý pravopis `Outěchovice` nikde); pozor na
  záměny s Útěchovičkami u Chvojnova a Útěchovicemi pod Stražištěm. Nezaměňovat
  Zahrádku se Zlátenkou v matrikách.
- **Soukromí a evidence.** Sídlo firmy či spolku nedokládá bydliště; vlastnictví
  nedokládá pobyt. Žijící osoby se uvádějí jen ve veřejných rolích z veřejných
  rejstříků a médií.
- **Ochrana zdrojů.** Originály (skeny, PDF, fotografie) se ukládají celé a
  needitují se; odvozené výřezy a překryvy jsou vždy vedle originálu. Mapová
  zarovnání jsou badatelská, nikoli úřední georeference — a takto se popisují.
- **Reprodukovatelnost.** Každý opakovatelný postup se ukládá do
  [nastroje/](nastroje/README.md); generované soubory se nikdy neopravují ručně
  (opravy patří do zdrojových registrů); adresář `tmp/` nesmí být jediným místem,
  kde postup přežije.
- **Komunikace.** Žádná žádost třetí straně se neodesílá bez uživatele; hotové
  koncepty čekají v [zadost_o_archivni_prameny.md](zadost_o_archivni_prameny.md).
- **Jazyk.** Vždy „na Zahrádce“, nikdy „v Zahrádce“ — výjimkou jsou doslovné
  citace pramenů v uvozovkách.

## Datový tok

```
prameny (skeny, OCR, registry)
  → prameny_online/…            katalog uložených kopií (index: prameny_online/README.md)
  → obyvatele_zahradky.md       podrobná evidence N11 (jistoty, výřezy)
  → obyvatele_zahradky_domy.md  kanonický jmenný registr celé vsi podle domů
      → ruby nastroje/vytvorit_index_n11.rb        → obyvatele_zahradky_domy/n11.md
      → ruby nastroje/vytvorit_domovni_pobyty.rb   → obyvatele_zahradky_domy/dolozene_pobyty.md
      → ruby nastroje/vytvorit_mapova_data.rb      → website/mapa_data.js
  → website/index.html          data v JS polích (BIRTHS, ROLES, OWNERS, POP, TIMELINE, BOOKS…)
  → nasazení: rsync -az --delete ~/Work/zahradka/website/ 192.168.1.111:projects/apps/historie/html/
```

Před nasazením: `awk '/<script>/{f=1;next}/<\/script>/{f=0}f' index.html | node --check /dev/stdin`.

## Nástroje (nastroje/)

| Skript | Účel |
|---|---|
| `stahnout_sken_trebon_z_knihy.sh` / `stahnout_rozsah_skenu_trebon.sh` | stažení snímků SOA Třeboň (Zoomify dlaždice → JPEG) podle ID knihy a čísla snímku |
| `hledat_matriky_trebon.rb` | dotaz do veřejného elektronického rejstříku matrik (výběrový — nula nic nedokazuje) |
| `stahnout_sken_mza_scitani.sh` | stažení snímků sčítacích operátů MZA (Deep Zoom) |
| `diagnostika_1829_lokalni.py`, `vykreslit_klad_1829.py`, `projit_archivni_vrstvy_st1.sh`, `dotaz_pozdejsi_katastralni_mapy.sh`, `stahnout_originalni_mapy_8865.sh` | stabilní katastr a Archiv ČÚZK |
| `vytvorit_zarovnane_srovnani.py`, `vytvorit_mapove_podklady.py` | badatelské zarovnání leteckých snímků a mapových vrstev do rámu 600 m EPSG:5514 |
| `vytvorit_index_n11.rb`, `vytvorit_domovni_pobyty.rb`, `vytvorit_mapova_data.rb` | generátory registrových pohledů a dat mapy |

## Pramenná základna

### Matriky (osy osob a domů)

- **Farnost Pošná, SOA Třeboň (digi.ceskearchivy.cz)** — 14 digitalizovaných
  knih 1670–1937 + 9 rejstříků; přístupový bod Zahrádka:
  <https://digi.ceskearchivy.cz/k/409642>. Stav prohlédnutí po knihách vede
  tabulka `BOOKS` na webu a HANDOFF. Narození do 1911 (11210), oddaní do 1930
  (6624), zemřelí do 1937 (11214).
- **Matriční úřad Pacov** (nám. Svobody 1, budova zámku) — nedigitalizované
  knihy N 1912–1949, O 10A 1931–1949, Z 12B 1938–1949, všechny s indexy.
  Podle § 25b zák. č. 301/2000 Sb. jsou zápisy starší 100 (N) / 75 (O) / 30 (Z)
  let přístupné komukoli; knihy O a Z čekají po lhůtě 2024 na předání SOA.
- Doplňkové knihy s vazbou na Zahrádku: civilní oddací Pelhřimov 3A 1929–1945
  (id 12260), ŘK Pacov 30A O do 1940, ŘK Tábor 40A O do 1938, ČCE Moraveč aj.;
  farnosti Pacov a Lukavec pro navazující osoby. Hrobská Zahrádka = farnost
  Pacov (rozlišovací klíč). Druhopisy: Sbírka druhopisů matrik Jihočeského
  kraje (obsah pro Pošnou nezjištěn).

### Sčítání a soupisy obyvatel

- **1857–1921 online (MZA)**: sada `PE0584` Zahrádka 1921 úplně přepsána
  (174 osob, 25 archů; arch čp. 13 chybí).
- **1930 a 1950**: Národní archiv Praha (fondy NAD 752/2 a 984), jen na žádost
  (výpisy; doklad příbuzenství nebo úmrtí); 1950 zahrnuje i soupisové archy
  zemědělských závodů. **1961 pro okres Pelhřimov skartováno.** Soupis 1947:
  jen agregát (123 osob); osud jmenných archů nezjištěn.
- Agregáty: Statistické lexikony obcí 1923, 1934 (osadní detail, Rohovcová
  Chalupa), 1955; Historický lexikon obcí ČSÚ (řada 1869–2011 + správní vývoj);
  SLDB 2021 otevřená data (část obce: 24 obyvatel, 12 obydlených bytů).

### Katastr, pozemkové knihy a majetek

- Josefínský katastr (knihy 342510, 342896; „Panský dvůr N. 11 zahrádecký“),
  stabilní katastr 1829 (císařský otisk, indikační skica) + originální mapa
  reambulovaná 1878, nedatovaný rastr PK, dnešní RÚIAN — řetězec N11 → st. 1 →
  čp. 11. Osm pozemkových knih velkostatku 1784–1876 online; mladší knihovní
  vložky: Katastrální pracoviště Pelhřimov (na žádost) a fond Okresní soud
  Pacov (SOkA Pelhřimov, z větší části nezpracován).
- Starší vrstvy: desky zemské (NA VadeMeCum + edice), Berní rula 1654, Soupis
  poddaných 1651 (Zahrádka chybí), tereziánský katastr (edice; dominikál zná
  samostatný „statek Zahrádka u Pošné“ — stopa).

### Tisk, statistika a digitální knihovny

- **Kramerius**: hledá se ve **třech instancích současně**, protože každá má jiné
  tituly a jiný přístupový režim k téže straně:
  - `kramerius5.nkp.cz` (NK ČR, API v5) — celostátní tisk, úřední listy,
    statistické lexikony, adresáře;
  - `kramerius.cbvk.cz` (Jihočeská vědecká knihovna, API v7) — *Tábor*,
    *Český jih*, *Palcát*, *Jihočeská Pravda*;
  - `kramerius.kkvysociny.cz` (Krajská knihovna Vysočiny, API v7) — *Týdeník
    z Českomoravské vysočiny*, *Vesnické noviny* 1952–1959, *Nástup* 1960–1990,
    *Z mého kraje*, *Vlastivědný sborník českého jihovýchodu*, *Zpravodaj JZD
    Velká Chyška*.

  API v7: `/search/api/client/v7.0/search?q=text_ocr:"fráze"&hl=true&hl.fl=text_ocr`
  vrací zvýrazněné úryvky **i u stránek v režimu DNNT** (meze serveru:
  `hl.fragsize` ≤ 120, `hl.snippets × hl.fragsize` ≤ 300); plný OCR text
  `/items/{uuid}/ocr/text` je dostupný jen u dokumentů s příznakem `public`.
  Tatáž strana bývá v jedné knihovně veřejná a v druhé pod DNNT — vyplatí se
  hledat týž uuid jinde. `api.ndk.cz` z tohoto prostředí neresolvuje, MZK K5
  zrušen. Text ze snippetu má jistotu nejvýše **střední** a poznámka to musí
  říct. Dotazy vždy ve více pádech a variantách; digivysocina.cz zůstává na
  ruční prohlížení.
- Vytěženo: schematismy velkostatků, adresáře, agrární statistika, pozemková
  reforma, volby, seznamy porotců, denní tisk 1875–1991 (jednotlivé nálezy
  v [vyzkum_statku.md](vyzkum_statku.md) a [vyzkum_1921_soucasnost.md](vyzkum_1921_soucasnost.md)).

### Nezdigitalizované archivní fondy (hlavní cíle žádostí)

| Uložení | Fond (NAD) | Klíčový obsah |
|---|---|---|
| SOkA Jindřichův Hradec | Velkostatek Březina–Zahrádka (2499/299) | budovy a pojištění 1928–48 (inv. 23), předání 1948 (21–22), kniha služného 1940–44 (inv. 40) |
| SOkA Pelhřimov | **Archiv obce Zahrádka (1334)** | pamětní kniha 1937–1962 (retrospektiva od 1919), evidence obyvatel 1874–1948, zastupitelstvo 1911–44 |
| SOkA Pelhřimov | MNV Zahrádka (1335), MNV Útěchovičky (1262), MNV Pošná (1544), AO Pošná (1077) | poválečná správa, občanské výbory Zahrádky 1964–67, domovní seznamy 1951–78, kroniky 1898–2007 |
| SOkA Pelhřimov | ZŠ Pošná (1079), FÚ Pošná (1080), ONV Pacov (10) | školní kroniky 1873–1984, farní kronika, okresní agenda 1949–60 |
| NA Praha | sčítání 1930/1950 (752/2, 984), Svaz čs. velkostatkářů, HBMa | operáty; složka Ing. J. Homolky; židovské zápisy „Zahrádka u Pošné“ |
| mimo archiv | JZD Zahrádka, JZD Pošná, ZD Velká Chyška | družstevní písemnosti 1950–1992 (držitel: ZD Velká Chyška / nezjištěno) |

### Mapy, snímky a obraz

Vojenská mapování 1783/1852/1877–80, SMO-5 1951/1975/1993, letecké snímky
1949–1992 + ortofota 2001–2022 (badatelsky zarovnaná řada), pozemní fotografie
2015–2018 (EXIF směrodatné), Wikimedia Commons, web obce, drobnepamatky.cz,
pouť 2025/2026. Katalog: [prameny_online/README.md](prameny_online/README.md).

### Osoby v databázích 20. století

Legionáři (csol.cz — data VÚA-VHA; rodiště nutno ověřovat matrikou), Centrální
evidence válečných hrobů (evidencevh.mo.gov.cz; POST endpointy fungují bez
přihlášení), Paměť národa (hledat oklikou přes Google), holocaust.cz (negativní),
ÚSTR (negativní). Kartotéka padlých VHA zatím neumí hledání dle rodiště pro
Pacovsko.

### Současné registry

RÚIAN/VDP (adresy, parcely, stavební objekty — i historické stavy), ARES a
veřejný rejstřík (subjekty; sídlo ≠ bydliště), LPIS (uživatelé půdy dle k. ú.;
veřejný SHP export), SZIF (příjemci dotací), NPÚ (památky, ÚAN, MIS), územní
plán Pošná (web ORP Pacov), úřední deska obce.

## Postup velkých rešerší (použito 31. 7. 2026)

Rozsáhlé průzkumy veřejných zdrojů se vedou jako **paralelní rešerše s dělbou
na směry** (správa, archivy, tisk, registry…), kde každý směr pracuje
samostatně a odevzdává strukturovaná zjištění ve tvaru *tvrzení + období +
citace + URL + jistota + poznámka o tom, co bylo skutečně viděno*; zvlášť se
odevzdávají slepé konce a navazující stopy. Klíčová tvrzení poté prochází
**nezávislou adversariální kontrolou**: kontrolor dostane hotové tvrzení
s URL a má je vyvrátit — potvrzuje se jen to, co sám znovu viděl u zdroje
(výsledky: potvrzeno / neověřeno / vyvráceno + případné upřesnění).

Obrazová rešerše matrik probíhá po snímcích: stažení přes skripty v
`nastroje/`, čtení celé strany, u drobného písma výřezy (ImageMagick),
u čísel domů vždy zvětšení sloupce před finálním čtením; přepisuje se, co je
napsáno, s `(?)` u nejistot, a vede se **účetnictví pokrytí po snímcích**
(i „žádná Zahrádka“ je záznam), aby nevznikaly tiché mezery. Datum se
ohraničuje sousedními zápisy — teprve ohraničený negativ je čistý negativ.

Výstupy každé rešerše se ukládají trojmo: surová strojová data (JSON),
**úplný čitelný záznam v Markdownu** a kurátorovaný výtah promítnutý do
hlavních spisů. Pracovní přepisy z obrazů se do kanonického registru
přebírají až po obrazové kontrole citovaných snímků. Přerušený běh se
ukončuje měkce: hotové výsledky se sklidí z žurnálu běhu a běh lze později
obnovit (dokončené části se přehrají z mezipaměti).

Uložené rešerše:

| Rešerše | Úplný záznam | Souhrn |
|---|---|---|
| Novější historie 1921–současnost (8 směrů, 136 zjištění, 18 ověřených tvrzení) | [zjisteni.md](prameny_online/reserse/2026-07-31_novejsi_historie/zjisteni.md) | [README](prameny_online/reserse/2026-07-31_novejsi_historie/README.md) |
| Současný stav domů 2026 (4 směry, 62 zjištění, 113 domovních záznamů) | [zjisteni.md](prameny_online/reserse/2026-07-31_soucasny_stav/zjisteni.md) | [README](prameny_online/reserse/2026-07-31_soucasny_stav/README.md) |
| Matriky — legionáři a úmrtí 1881–1937 (částečná; 10 verdiktů, 47 zápisů z 80 snímků) | [prepisy.md](prameny_online/reserse/2026-07-31_matriky_castecne/prepisy.md) | [README](prameny_online/reserse/2026-07-31_matriky_castecne/README.md) |
| Obyvatelé domů 1921–2026 (7 směrů, 209 zjištění, 98 verdiktů, 79 nových domovních řádků) | [zjisteni.md](prameny_online/reserse/2026-07-31_obyvatele_1921_2026/zjisteni.md) | [README](prameny_online/reserse/2026-07-31_obyvatele_1921_2026/README.md) |

Osvědčené pravidlo pro **jména s číslem domu ve 20. století**: nejvydatnější je
oddací matrika (uvádí dům ženicha, nevěsty, obou rodičovských párů i svědků),
po ní úřední a soudní vyhlášky (opatrovnictví, rejstříky společenstev), teprve
potom běžný tisk. Za hranici digitalizovaných katolických knih (Pošná: N 1911,
O 1930, Z 1937) se lze dostat **matrikami okolních farností a evangelických
sborů**, kam zahrádecké sňatky často patřily. U žijících osob je jedinou
legální strojovou cestou k číslu domu **registr smluv** (smlouvy o kotlíkových
dotacích uvádějí bytovou adresu příjemce).

## Technické poznámky k vyhledávání

- ARON (portal.nacr.cz/aron) je JS aplikace; strojově funguje JSON API:
  `POST /aron/api/aron/apu/list` s `{"filters":[{"operation":"FTX","value":"dotaz"}]}`
  a `GET /aron/api/aron/apu/{uuid}`. Starý portál `portalold.nacr.cz` umí
  evidenci SOkA Pelhřimov podle čísla NAD.
- digi.ceskearchivy.cz je SPA; obsah přístupových bodů dávají AJAX endpointy
  `pages/klicova/klicmaterial1.php?typ=…&id=…`.
- zakonyprolidi.cz odmítá WebFetch (403) — stahovat curl s běžným User-Agentem.
- Souřadnice dvora: S-JTSK zhruba `−705 772, −1 118 150`; rám mapových vrstev
  600 m s rohem `−706 072 / −1 117 850`.

## Kde co je (rozcestník)

| Co | Soubor |
|---|---|
| Předávací souhrn a stav | [HANDOFF.md](HANDOFF.md) |
| Spis dvora | [vyzkum_statku.md](vyzkum_statku.md) |
| Spis novější historie obce | [vyzkum_1921_soucasnost.md](vyzkum_1921_soucasnost.md) |
| Kanonický registr osob podle domů | [obyvatele_zahradky_domy.md](obyvatele_zahradky_domy.md) |
| Evidence N11 s jistotami | [obyvatele_zahradky.md](obyvatele_zahradky.md) |
| Místní jmenné stopy | [mistni_jmenne_stopy.md](mistni_jmenne_stopy.md) |
| Katalog uložených pramenů | [prameny_online/README.md](prameny_online/README.md) |
| Návod k nástrojům | [nastroje/README.md](nastroje/README.md) |
| Koncepty žádostí (neodeslané) | [zadost_o_archivni_prameny.md](zadost_o_archivni_prameny.md) |
