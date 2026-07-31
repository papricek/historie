# Rešerše obyvatel domů 1921–2026 (31. 7. 2026, druhá téhož dne)

Systematická rešerše veřejných pramenů k otázce **kdo v kterém domě na Zahrádce
bydlel v letech 1921–2026**. Sedm směrů (`uredni-vestniky`, `tisk-osoby`,
`adresare`, `valky-a-obeti`, `moderni-registry`, `matriky-prechod`,
`regionalni-pamet`), každý s nezávislým ověřovatelem, jehož úkolem bylo nálezy
vlastního směru **vyvrátit**.

**Úplný čitelný záznam je v [zjisteni.md](zjisteni.md)** — 209 zjištění
s doslovnou citací, URL a mírou jistoty, 98 ověřovacích verdiktů, 70 slepých
konců a 74 navazujících stop; `reserse_vystup.json` obsahuje tatáž data strojově.

Kurátorované výtahy:

- [vyzkum_1921_soucasnost.md](../../../vyzkum_1921_soucasnost.md) → oddíly
  „Druhá rešerše 31. 7. 2026 — lidé v domech 1920–2026“, „Obecní samospráva,
  volby a veřejný život 1918–1948“, „Válka a oběti — nový jmenný pramen“,
  „Konec velkostatku a JZD 1948–1980“ a „Lidé ve vsi 1932–1989“;
- [obyvatele_zahradky_domy.md](../../../obyvatele_zahradky_domy.md) → 79 nových
  domovních řádků 1920–1934 a 26 osob v oddílu „dům nezjištěn“;
- [obyvatele_zahradky.md](../../../obyvatele_zahradky.md) → ZAH‑0236 až ZAH‑0240
  (osazenstvo dvora čp. 11 v letech 1890 a 1921–1929);
- [soucasny_stav_domu.md](../../../soucasny_stav_domu.md) → dnešní obyvatelé
  čp. 6, 9, 15, 27 a 28 a obecní infrastruktura.

## Co rešerše změnila metodicky

1. **Kramerius Jihočeské vědecké knihovny** (kramerius.cbvk.cz) a **Krajské
   knihovny Vysočiny** (kramerius.kkvysociny.cz) mají prakticky úplný regionální
   tisk Pacovska: *Tábor*, *Český jih*, *Palcát*, *Jihočeská Pravda*, *Týdeník
   z Českomoravské vysočiny*, *Vesnické noviny* 1952–1959, *Nástup* 1960–1990,
   *Z mého kraje*, *Zpravodaj JZD Velká Chyška* 1978–1980. Klientské API
   (`/search/api/client/v7.0/search`, `hl=true&hl.fl=text_ocr`) vrací zvýrazněné
   úryvky i u stránek v režimu DNNT; u veřejných stran lze číst celý OCR text
   (`/items/{uuid}/ocr/text`). Meze serveru: `hl.fragsize` max 120,
   `hl.snippets*hl.fragsize` max 300. Captcha ani DNNT se neobcházejí.
2. **Oddací matrika je nejvydatnější zdroj domovních čísel** — uvádí dům ženicha,
   nevěsty, obou rodičovských párů i svědků. Kniha 6624 (Pošná, O 1881–1930)
   vydala v jednom průchodu 79 domovních řádků.
3. **Evangelické matriky obcházejí hranici roku 1930**: sňatky zahrádeckých osob
   nekatolického vyznání jsou v knihách ČCE Moraveč (id 13243) a Červená Řečice
   (id 13251) a jsou digitalizované — odtud pochází zatím nejmladší online
   matriční doklad s číslem domu, 3. 2. 1934.
4. **Registr smluv zveřejňuje bytovou adresu** příjemců kotlíkových dotací Kraje
   Vysočina — jediná legální strojová cesta k vazbě žijící osoby na čp.
5. **Ztrátové seznamy 1914–1918** (des.genealogy.net) mají domovskou obec; úplný
   výsledek vrací jen dotaz se zástupným znakem `value07=Zahr?dka`, protože část
   záznamů je psána s diakritikou.

## Co ověření zachytilo

Ze 98 verdiktů skončily **2 jako vyvrácené** a 42 jako upřesněné. Obě vyvrácení
byla věcná a týkala se čísel domů čtených ze zmenšenin (nevěsta šafáře Vitisky
byla z č. 12, nikoli č. 11; Karolína Kejvalová se vdávala z č. 16, nikoli č. 14).
Do spisů se přebíralo vždy opravené znění. Ověřovatelé také odhalili tři případy,
kdy rešeršista zkrátil citaci právě před slovem, které jeho výklad oslabovalo —
proto jsou v `zjisteni.md` u každého verdiktu ponechána celá odůvodnění.
