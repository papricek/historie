# Kontrola N11 podle skillu *dejiny-domu* (5. 11. 2026)

Skill [vzoha/dejiny-domu-skill](https://github.com/vzoha/dejiny-domu-skill) (verze 0.5.0) je český průvodce dějinami domu z archivů. Projekt jsme **nepřeváděli** do jeho struktury (`data/domy.py`, web v Astru): náš výzkum je hlubší a má vlastní kanonické soubory. Použili jsme jeho **pořadí pramenů**, kontrolní seznam a **tabulku podmínek portálů** a porovnali je se stavem N11.

## 1. Pokrytí pramenů podle pořadí skillu

| Pramen (skill, `reference/prameny.md`) | Stav u N11 |
|---|---|
| RÚIAN, katastr dnes | hotovo |
| letecké snímky 1949–2022, ortofoto CENIA 1953 | hotovo, zarovnaná řada |
| pozemkový katastr | hotovo, nedatovaná vrstva `pk_a` |
| **mapa evidence nemovitostí** | **nově 5. 11. 2026**: stav konec 1965 a 31. 12. 1980, viz [katalog](prameny_online/mapy_katastralni/1965_1980_mapa_evidence_nemovitosti/README.md) |
| **evidenční mapa B2/a/14C** (změny po 1883) | v Archivu ČÚZK pro k. ú. není; dotaz na ÚAZK doplněn |
| pozemkové knihy po 1870 | připravená žádost (katastrální pracoviště Pelhřimov) |
| sčítání 1857–1910 | **mezera**: online jen 1921 (MZA `PE0584`); 1869–1910 pro Zahrádku zatím nenalezeny |
| matriky podle čísla domu 1784–1937 | hotovo, velmi podrobně |
| stabilní katastr 1829 / reambulace 1878, indikační skica | hotovo |
| josefský katastr 1785 | hotovo (`Panský dvůr N. 11 zahrádecký`) |
| **tereziánský katastr 1748–57** | **mezera**. Skill upozorňuje, že vrchnostenský dvůr v rustikálu chybí: hledat v **dominikálu (fase vrchnosti)** v Národním archivu. Zatím bez žádosti |
| gruntovní knihy 1784–1876 | hotovo (8 knih, smlouvy 1813 a 1840) |
| berní rula 1654, soupis 1651 | hotovo |
| urbáře, účty velkostatku | inventář znám (SOkA J. Hradec), reprodukce nevyžádány |
| **zemské desky, hlavní kniha 18.–19. stol.** | **nově**: Sommer cituje samostatnou vložku *Gut Zahradka, Litt. Z, Tom. I, Fol. 141*; žádost připravena |
| **Sommerova topografie 1842** | **nově**: heslo „Gut Březina sammt Zahradka“, viz [katalog](prameny_online/tisky/1842_sommer_taborer_kreis/README.md) |
| vojenská mapování | hotovo |
| Kramerius, noviny | hotovo (audit 1878–1949) |
| ANNO (rakouské noviny), Amtsblatt zur Prager Zeitung | **hotovo 5. 11. 2026**: smrt majitele 1856, dražby 1856–1858, vlastníci 1861–1880, viz [nove_nalezy_2026-11-05.md](nove_nalezy_2026-11-05.md) |
| kroniky obce a školy | identifikovány v SOkA Pelhřimov, nejsou online |

## 2. Co nového přinesla tato kontrola

1. **Sommer 1842**: dvůr Zahrádka je jedním ze tří dvorů statku **ve vlastní režii vrchnosti** (stav 1837–1842). Ves má 22 domů a 142 obyvatel, hospodu a vinopal. Přesné datum koupě Eisensteinem je **21. 8. 1839**. Sommer také cituje samostatné deskové těleso **statek Zahrádka**.
2. **Mapa evidence nemovitostí**: první úředně datované plány st. 1 po válce (konec 1965, 31. 12. 1980), na obou stejný půdorys do tvaru L. Nedatovaná vrstva `pk_a` je starší než stav konce 1965.
3. Evidenční mapa po roce 1883, jediný mapový pramen, který by mohl přímo datovat přestavbu 1878–1949, v Archivu ČÚZK online **není**.

## 3. Podmínky portálů: co je třeba rozhodnout

Skill vede tabulku podmínek (stav 3. 11. 2026, z veřejných zdrojů, není to právní rada). Podle ní:

- **SOA Třeboň (digi.ceskearchivy.cz)**: snímky jen k prohlížení, kopírovat se nesmí; zveřejnit obrázek jen se souhlasem (`digi@ceskearchivy.cz`). Projekt má skripty `nastroje/stahnout_sken_trebon*.sh` a výřezy z Třeboně ukládá.
- **SOA Praha eBadatelna**: robots.txt zakazuje roboty, AI výslovně. Projekt má `nastroje/stahnout_sken_soapraha*.sh`. Doporučená cesta: ZIP knihy po registraci, stažený ručně.
- **MZA Acta Publica / sčítací operáty**: zveřejnit jen s písemným souhlasem.
- **Indikační skici** patří Národnímu archivu: zveřejnit jen se souhlasem.
- **Archivní letecké měřické snímky ČÚZK**: soubor jen pro vlastní potřebu, výřez nezveřejňovat. Ortofoto CENIA 1953 a mapy ÚAZK zveřejnit smí.

Veřejný web **historie.poutnazahradce.cz** (bez hesla) dnes ukazuje obrázky, které podle této tabulky potřebují souhlas archivu:
`matrika_1772.jpg`, `josefinsky_n11.jpg`, `smlouva_1840.jpg` (SOA Třeboň), `skica_1829.jpg`, `skica_n1_franek.jpg` (indikační skica, NA), `scitani_1921_arch.jpg`, `scitani_1921_hlavicka.jpg` (MZA), `letecka_zarovnana.jpg` (archivní letecké snímky).

Možnosti: (a) požádat archivy o souhlas se zveřejněním (Třeboň, NA, MZA; obvykle zdarma pro nevýdělečný web), (b) web dát za heslo, (c) nahradit obrázky přepisem a odkazem na snímek v archivu, letecké snímky ortofotem CENIA 1953. **Zjištění a vlastní přepisy zveřejnit lze vždy.**

## 4. Doporučené další kroky (pořadí)

1. Rozhodnout o obrázcích na veřejném webu (bod 3).
2. Odeslat žádost do NA na hlavní knihu zemských desek, statek Zahrádka (lit. Z, tom. I, fol. 141): nejlevnější nová stopa k držbě dvora v 18.–19. století.
3. Odeslat doplněný dotaz na ÚAZK (evidenční mapa po 1883 a vztah `pk_a` k mapě 1965).
4. Do žádosti NA přidat **tereziánský katastr, dominikál** statku Březina–Zahrádka (fase vrchnosti), protože dvůr v rustikálu nebude.
5. Hotovo (ANNO, Kramerius). Nově nejcennější cíl: soudní odhadní protokol z 20. 9. 1856 (N. E. 23792) v pozůstalosti Vojtěcha Eisensteina; žádost doplněna.
6. Ověřeno: MZA má pro okres Pelhřimov online jen 1921. Starší operáty hledat v SOkA Pelhřimov (fond Okresní úřad / Okresní hejtmanství Pacov).
