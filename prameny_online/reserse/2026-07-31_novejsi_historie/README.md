# Rešerše novější historie 1921–současnost (31. 7. 2026)

Úplný strojový výstup systematické rešerše veřejných online pramenů k dějinám
vsi Zahrádka u Pošné od roku 1921 do současnosti. Kurátorovaný a interpretovaný
výtah je v [vyzkum_1921_soucasnost.md](../../../vyzkum_1921_soucasnost.md);
tento soubor uchovává kompletní surová data.

**Úplný čitelný záznam všech zjištění je v [zjisteni.md](zjisteni.md).**
Soubor `reserse_vystup.json` obsahuje tatáž data strojově:

- `findings` — všech 136 zjištění z osmi směrů (`sprava`, `archivy`,
  `scitani1930`, `kramerius`, `valka`, `jzd`, `soucasnost`, `matriky`), každé
  s tvrzením, obdobím, citací, URL (včetně přesných uuid stran NKP Krameria)
  a mírou jistoty (vysoká / střední / nízká);
- `verified_subset` a `verdicts` — 18 klíčových tvrzení, která prošla nezávislou
  adversariální kontrolou u zdroje (všech 18 potvrzeno; čtyři s upřesněním:
  strana hesla Proseč, značka hájovny v lexikonu 1923, dovozený rozsah okresu
  Pacov 1949–1960, přejmenování kraje 2011);
- `dead_ends` — 80 negativních či zablokovaných pokusů (mj. DNNT bloky lexikonů
  1965–1982, nefunkční katalogová API a doložená skartace sčítání 1961);
- `new_leads` — 78 konkrétních navazujících stop s postupem, kde a jak pokračovat.

Zjištění s jistotou „nízká“ jsou pracovní stopy (často jen DNNT snippety) a bez
dalšího ověření se nepřebírají do hlavních spisů.
