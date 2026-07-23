# Handoff — web historie.poutnazahradce.cz

Stav k 23. 7. 2026. Rychlý start pro navazující práci na webu výzkumu dvora na Zahrádce (st. 1 / čp. 11).

## Co kde je

| Co | Kde |
|---|---|
| Web (jeden soubor, vše inline) | `website/index.html` |
| Obrázky pro web (zmenšené náhledy) | `website/img/*.jpg` |
| Obrázky v plném rozlišení (lightbox) | `website/img/full/*.jpg` |
| Zdrojové výzkumné spisy | `vyzkum_statku.md`, `obyvatele_zahradky.md`, `zadost_o_archivni_prameny.md`, `josef.md` |
| Katalog stažených pramenů | `prameny_online/` (README.md = index) |
| Vlastní fotografie 2015–2018 | `Velká Zahrádka/` (EXIF data jsou směrodatná, ne názvy složek) |
| Popis serveru | `~/Work/claude/server.md` |

## Nasazení

Server: home server (`ssh 192.168.1.111`, WAN `89.203.217.139`). Kontejner `historie`
(nginx:alpine) v `~/projects/apps/historie/`, servíruje mount `./html`. Routing v
`~/projects/traefik/conf.d/routes.yml` (router `historie`, Let's Encrypt; záloha
původního souboru: `routes.yml.bak-historie`). DNS `historie.poutnazahradce.cz` → WAN IP už nastaveno.

**Redeploy = jediný příkaz** (nginx nic restartovat nepotřebuje):

```bash
rsync -az --delete ~/Work/zahradka/website/ 192.168.1.111:projects/apps/historie/html/
```

Rychlá kontrola po nasazení:

```bash
curl -sS -o /dev/null -w "%{http_code}\n" https://historie.poutnazahradce.cz/
```

## Jak je web postavený

Jedna HTML stránka, žádné závislosti, žádný build. CSS + data + vykreslování grafů je
inline v `index.html`. Struktura: oddíly I–IX (Identita, Lidé, Role, Držba,
Hospodářství, Proměny areálu, Časová osa, Prameny, Otevřené otázky).

Data jsou v JS polích na začátku `<script>` bloku — **při aktualizaci obsahu se mění
především tato pole**, vykreslovací kód se nemusí sahat:

| Pole | Co obsahuje | Kreslí se v |
|---|---|---|
| `BIRTHS` / `MARRIAGES` / `DEATHS` | matriční zápisy 1772–1930 (bod = zápis) | oddíl II (tečkový graf + tabulka) |
| `ROLES` | pracovní role po řádcích | oddíl III |
| `OWNERS` | držba 1378–1948 (karty) | oddíl IV |
| `ECON` / `SCALES` / `POP` | 1886 ha, tři veličiny, obyvatelé vsi | oddíl V |
| `TIMELINE` | časová osa (`["era", …]` = mezititulek) | oddíl VII |
| `BOOKS` | matriční knihy + stav prohlédnutí | oddíl VIII (gantt) |

Konvence jistoty u zápisů: `h` = bezpečné, `m` = částečně nejisté čtení, `w` = pracovní
nález, `d` = adresně sporné; `"sb"` jako 6. prvek = mrtvě narozené dítě.

**Pozor na konzistenci:** stat „104 matričních zápisů“ v hlavičce = součet délek
BIRTHS + MARRIAGES + DEATHS. Po přidání zápisů přepočítat. Stejně tak texty legend
(„z toho 4 mrtvě narozené…“) jsou psané ručně.

Časové osy grafů: oddíly II a III mají rozsah 1768–1934, gantt knih 1665–1958 se
značkou „1937 — hranice veřejně dostupných matrik“. Při rozšíření dat za tyto roky
posunout `Y1` a smyčky gridline.

## Obrázky a lightbox

Každý `<img>` ve `figure.ph` je obalený `<a class="lb" href="img/full/…">` — kliknutí
otevře lightbox (JS na konci skriptu), bez JS funguje jako odkaz na soubor. Nový
obrázek = vyrobit náhled i plnou verzi:

```bash
sips -Z 1600 -s format jpeg -s formatOptions 72 ZDROJ.jpg --out website/img/NAZEV.jpg      # náhled
cp ZDROJ.jpg website/img/full/NAZEV.jpg                                                    # skeny/mapy beze změny
sips -s format jpeg -s formatOptions 70 FOTO.JPG --out website/img/full/NAZEV.jpg          # velké fotky ~2–4 MB
```

## Pravidlo formulace (důležité)

Vždy **„na Zahrádce“**, nikdy „v Zahrádce“ — uživatelská preference, uloženo i v paměti.
Jediná výjimka: doslovné citace pramenů v uvozovkách — na webu záměrně zůstávají tři:
„Jul. Roubíčkovi v Zahrádce“ (schematismus 1902, 2×) a „obyvatelkyně v Zahrádce N11“
(oddací zápis 1862). Při hromadném nahrazování tyto citace maskovat.

## Ověření před nasazením

```bash
cd ~/Work/zahradka/website
awk '/<script>/{f=1;next}/<\/script>/{f=0}f' index.html | node --check /dev/stdin   # JS syntax
# headless render (počty prvků, screenshot):
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu \
  --virtual-time-budget=5000 --dump-dom "file://$PWD/index.html" > /tmp/r.html
```

## Co bylo uděláno 23. 7. 2026

1. Web aktualizován podle stavu spisů z téhož dne: adresní řada rozšířena za rok 1880
   (narození do 1911, sňatky do 1924, úmrtí do 1930; celkem 104 zápisů), nové rodiny a
   role (deputátník, dělníci, hospodářský pomocník, kočí), držba doplněna 1543–1664,
   hospodářství o „tři veličiny“ a demografii vsi 1869–2011.
2. Nový oddíl VI „Proměny areálu“ s hlavním novým zjištěním: **velká přestavba dvora
   proti stavu 1829 proběhla před rokem 1949** (letecká řada). Vloženo 8 obrázků
   (císařský otisk, indikační skica, matrika 1772, vojenská mapování, letecká tabule,
   3 pozemní fotky 2015/2018).
3. Nasazení na home server (kontejner `historie`, Traefik + Let's Encrypt) — viz výše.
4. Textové sloupce roztaženy na šířku grafů; obrázky dostaly lightbox s plným
   rozlišením; provedena náhrada „v Zahrádce“ → „na Zahrádce“ (mimo 3 citace).

## Nabízející se další kroky

- Odeslat připravené žádosti z `zadost_o_archivni_prameny.md` (5 konceptů, stačí doplnit
  jméno/kontakt) — hlavně inv. č. 23 (budovy/pojištění 1928–1948, klíč k demolicím)
  a inv. č. 40 (kniha služného 1940–44).
- Po každé aktualizaci spisů promítnout novinky do JS polí webu a redeploy.
- Otevřené výzkumné otázky jsou v oddílu IX webu (Q1–Q6) a v `vyzkum_statku.md`
  → „Další postup“.
