# Rešerše mezer 1935–2026 (1. 8. 2026)

Třetí rešerše novější historie, tentokrát cílená výhradně na dvě mezery, které
zbyly po předchozích kolech: **jména obyvatel mezi lety 1935 a 1990** a **vazba
jména na konkrétní číslo popisné po roce 1990**. Sedm směrů (`nastup-1960-1990`,
`tisk-1945-1960`, `protektorat-1938-1945`, `zpravodaje-1978-2026`,
`vlastnici-pozemku-dnes`, `volby-a-obec-1990-2026`, `matriky-a-evidence-1931-1965`),
každý s nezávislým ověřovatelem, jehož úkolem bylo nálezy vlastního směru
vyvrátit.

**Úplný čitelný záznam je v [zjisteni.md](zjisteni.md)** — 192 zjištění, z toho
69 s číslem domu, 47 ověřovacích verdiktů, 92 slepých konců a 67 navazujících
stop; `reserse_vystup.json` obsahuje tatáž data strojově.

## Dva prameny, které nikdo neotevřel

1. **Abecední rejstřík úmrtní knihy Pošná 12A** (id 11214, snímky 275–297).
   Elektronický rejstřík DigiArchivu zemřelé vůbec nezná, takže tato část knihy
   zůstávala nečtená. Uvádí jméno, ves, **číslo popisné** a datum, a posouvá tím
   matriční řadu se jmény a domy z roku 1930 až do roku **1937** — devatenáct
   zahrádeckých úmrtí, u sedmi nejmladších dohledány i plné zápisy s povoláním
   a rodinnými vazbami.
2. **Úřední seznam nedostatečně identifikovaných vlastníků (ÚZSVM/ČÚZK)**.
   Vlastníky nemovitostí nelze získat strojově z katastru, ale tento seznam je
   veřejný a uvádí u osob poslední známou adresu — odtud pocházejí vlastníci
   s adresami Zahrádka čp. 9, 18 a 20.

## Co rešerše rozhodla

- **Čp. 23 byla hájovna** — Jan Jirků, lesní hajný, a jeho dcera Jiřina
  (civilní sňatek 27. 9. 1935 v Pelhřimově). Statistický lexikon hájovnu
  u obce jmenuje už roku 1921, ale bez čísla a jména.
- **Deputátník Jan Plášil bydlel v čp. 22** — dosud byl veden bez domu.
- **Josef Vacík** je v čp. 11 doložen podruhé, úmrtím roku 1930.
- **Václav Pařízek, šafář († 26. 5. 1939)** je posledním jménem známým šafářem
  dvora, nástupcem Františka Vytisky.
- Knihy **Pošná 10A (O 1931–1949)** a **12B (Z 1938–1949)** už nejsou na
  matrice v Pacově — DigiArchiv je vede jako uložené v archivu se statusem
  „připravováno k digitalizaci“.

## Co ověření zachytilo

Tři tvrzení byla vyvrácena a všechna měla stejnou příčinu: **datum vzniku
živnosti není datem vzniku adresy**. Stanislav Janda podniká od 1. 3. 1999, ale
místo podnikání na čp. 27 má v rejstříku až od 27. 6. 2005; Anna Vlčková má
živnost od 20. 11. 2006, ale adresu čp. 8 teprve od 26. 3. 2024. Detailní výpis
RŽP (`/ekonomicke-subjekty-rzp/{ico}`) obsahuje u adresy pole `platnostOd` —
základní záznam ARES je neuvádí.

## Vědomě nepřevzato

Matriční rubriky měsíčníku *Z mého kraje* z let 1991–1992 uvádějí jménem sňatky
tehdejších obyvatel čp. 5 a čp. 28. U čp. 28 jde o osobu, která je jako
zastupitel obce ve veřejných registrech, takže dům je doložen i jinak; u čp. 5
jde o soukromou žijící osobu, a proto je v `soucasny_stav_domu.md` uvedena jen
existence vazby, nikoli jméno. Jméno zůstává v tomto úplném záznamu.
