# Rešerše současného stavu domů (31. 7. 2026)

Úplný strojový výstup rešerše dnešního stavu vsi a domů na Zahrádce ze čtyř
směrů (`ruian`, `kn`, `subjekty`, `pamatky_obec`). Kurátorovaný výtah je
v [soucasny_stav_domu.md](../../../soucasny_stav_domu.md) (zdroj mapového
oddílu „Dnešní stav (2026)“) a v
[vyzkum_1921_soucasnost.md](../../../vyzkum_1921_soucasnost.md).

**Úplný čitelný záznam je v [zjisteni.md](zjisteni.md)** — 62 zjištění s URL
a jistotou, 113 domovních záznamů (po čp. i pro objekty bez čp.) a 33 slepých
konců; soubor `reserse_vystup.json` obsahuje tatáž data strojově. Klíčové
technické poznatky: RÚIAN ArcGIS REST je plně strojově čitelný (vrstvy 1, 3,
5, 7); vlastníci nejsou v žádném bezplatném strojovém kanálu (vyhláška
č. 50/2024 Sb.; Nahlížení do KN za captchou a bot‑managementem — neobcházeno);
publikované převody lze číst z registru smluv; Památkový katalog NPÚ má CSV
open data a nedokumentované JSON API `/api/legal-state/{id}`;
volby.cz open data obsahují bydliště kandidátů po část obce.
