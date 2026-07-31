# Rešerše matrik 31. 7. 2026 — částečná (běh měkce ukončen)

Výstup obrazové rešerše dvou úloh nad knihami farnosti Pošná, ukončené na
žádost uživatele před dokončením. Výsledky dokončených agentů jsou zachovány
zde: **úplné čitelné přepisy v [prepisy.md](prepisy.md)** (verdikty legionářů
v plném znění, všech 47 úmrtních zápisů a účetnictví pokrytí po snímcích)
a surová data v `reserse_vystup.json`. **Do hlavního registru zatím promítnuty
nejsou** — přepisy jsou pracovní a před převzetím do
`obyvatele_zahradky_domy.md` je namístě obrazová kontrola citovaných snímků.

## 1. Legionáři — HOTOVO (všech 10 kandidátů rozhodnuto)

Ověření rodných zápisů kandidátů z databáze ČsOL (rodiště „Zahrádka“,
okr. Pelhřimov/Pacov) v knize narozených 11210 (1881–1911):

| Kandidát | Verdikt | Doklad |
|---|---|---|
| **Karel Vaněk** | **narozen 3. 1. 1891 v Zahrádce č. 19** (datum ČsOL „1. 3." je přesmyčka, ověřeno ohraničením) | kniha 11210, snímek 117, zápis 37; otec Josef Vaněk, chalupník č. 19 (děd Josef Vaněk, rolník č. 5); marginálie: oddán 1923 v Pošné s Annou Markvartovou; sestra Anna *14. 5. 1889 (snímek 101) |
| **Karel Lhota** | **narozen 26. 10. 1895 v Zahrádce č. 22** | kniha 11210, snímek 169, zápis 58; otec František Lhotta, **lesní hajný v č. 22**; přípis 1941 úředně opravuje příjmení na „Lhota“ |
| **Josef Zika** | **narozen 21. 1. 1892 v Zahrádce č. 9** | kniha 11210, snímek 128, zápis 11; otec Václav Zika, rolník č. 9; starší bratr František *29./30. 1. 1887 (snímek 78) = patrně „Zíka František 1907“ z katalogu hospodářské školy Tábor |
| Jan Trpák | nenalezen (čistý negativ, datum ohraničeno) → patrně Hrobská Zahrádka | snímky 101, 104 |
| Václav Růžička | nenalezen; Růžičkové mají v knize vazbu na Hrobskou Zahrádku | snímky 162–164, 170 |
| Ladislav Franěk | nenalezen (mezera 8. 12. 1894 – 3. 1. 1895 souvislá) → patrně Hrobská Zahrádka | snímky 158–159, 165 |
| František Makovec | nenalezen (vč. kontroly mimopořadních zápisů) | snímky 74–75 |
| Felix Vlach | nenalezen (květen 1887 souvisle) | snímky 78, 81 |
| František Vlach | nenalezen (červenec 1883 souvisle) | snímky 35, 38–39 |
| František Charouzek | nejasné (datum ČsOL nevalidní; konec roku 1897 čistý negativ) | snímky 188–190, 195 |

Vedlejší nálezy: Ludmila, nemanželská, *8. 1. 1895 v Zahrádce č. 1 — matka
Otilie, dcera Františka Fraňka, rolníka č. 1, a Kateřiny **roz. Kejval z č. 15**
(sňatková vazba rodů č. 1 × č. 15); tatáž Otylie je roku 1905 doložena jako
provdaná Kudrnová v č. 2 (úmrtí syna Josefa, kniha 11214, snímek 123).

## 2. Kniha 11214 (zemřelí 1881–1937) — ČÁSTEČNĚ (4 z 14 úseků)

Pokryty snímky **43–82** (léta ~1888–1895) a **123–162** (léta ~1904–1911);
celkem 80 snímků a **47 zahrádeckých úmrtních zápisů** s číslem domu, věkem,
vztahy a příčinou; nejistá čtení značena `(?)`. Nepokryto zůstává: snímky
**3–42** (1881–1888), **83–122** (1895–1904) a **163–274** (1911–1937).

Nejcennější adresní nálezy (výběr; úplný výpis v [prepisy.md](prepisy.md)):
hostinský **Josef Plášil v č. 6** (1891, 1894); kovář **František Dušánek
v č. 17** a u Dušánků dva vídeňští nalezenci (1890–1892); hajný **František
Lhota v č. 17** (1894) a poté v č. 22 (1895) — posloupnost hájovny; tesař
**Jan Rohovec v č. 18** (1894, srov. MJS‑004); **Bartoškovi** u č. 3 (1911,
srov. MJS‑002); rolník **František Kříž v č. 8** (1906, srov. MJS); nádeník
**Pudil v č. 22** (1906); rolníci **Zikovi v č. 9** (1891–1893, před
Plášilovými); **Kejvalové v č. 10, 15 a 16**; šafář **František Jaroš**
postupně u č. 27 (1891!), č. 21 (1892) a č. 11 (1894) a hajný **Mrkvička
v č. 29** (1906) — čísla 27 a 29 se tedy objevují už před rokem 1921 a
zaslouží zvláštní prověření (možná čísla dvorových a lesních budov, možná
písařova nedůslednost).

## Jak navázat

Běh lze obnovit se zachováním hotových výsledků (dokončení zbývajících 10
úseků knihy 11214 se přehraje z cache):

```
Workflow({scriptPath: "~/.claude/projects/-Users-patrikjira-Work-zahradka/836bfe9f-a695-4c18-95d7-864bdb02ca03/workflows/scripts/zahradka-domy-obyvatele-wf_15cf377f-ede.js",
          resumeFromRunId: "wf_15cf377f-ede"})
```

(Cesta i ID běhu platí pro tuto pracovní stanici; skript je uložen i v adresáři
uvedeném výše.)
