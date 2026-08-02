# Současný stav domů na Zahrádce (2026)

Kanonická evidence dnešního stavu domů a vsi pro oddíl „Dnešní stav (2026)“
na mapové stránce. Z tohoto souboru čte generátor
`nastroje/vytvorit_mapova_data.rb` (blok `window.MAPA_DNES` v `mapa_data.js`);
opravy se dělají zde a potom se generátor spustí znovu.

Zásady: pouze veřejné registry a úřední zdroje (RÚIAN, ARES/RŽP, veřejný
rejstřík, registr smluv, volby.cz, NPÚ, územní plán, úřední deska) a výslovně
označená **místní paměť** ([mistni_jmenne_stopy.md](mistni_jmenne_stopy.md)).
Sídlo podnikání ani kandidatura nejsou doklad bydliště ani vlastnictví; u
žijících osob se neuvádí nic nad rámec veřejného zdroje. Vlastníky jednotlivých
nemovitostí vede katastr; hromadný výpis není strojově veřejný (Nahlížení do KN
je za captchou, otevřená data ČÚZK vlastníky neobsahují — vyhláška
č. 50/2024 Sb.), doplňuje se proto jen z veřejně publikovaných listin (registr
smluv) nebo ručním nahlédnutím. Stav ověřen 1. 8. 2026; podrobná rešerše je
v [úplném výstupu](prameny_online/reserse/2026-07-31_soucasny_stav/README.md) a
v [rešerši obyvatel 1921–2026](prameny_online/reserse/2026-07-31_obyvatele_1921_2026/README.md).
Vazbu žijící osoby na konkrétní čp. uvádíme jen tam, kde ji zveřejnila úřední
listina — zejména smlouvy o kotlíkových dotacích Kraje Vysočina, které registr
smluv publikuje včetně bytové adresy příjemce, dále obchodní rejstřík a usnesení
zastupitelstva. Nic nad rámec takové listiny se nedoplňuje.
Klíč `obec` platí pro celou ves a zobrazuje se v úvodu mapového panelu.
Data dokončení „k 31. 12. roku“ jsou v RÚIAN zástupné roční údaje.

## Domy

| Čp. | Údaj | Zdroj |
|---|---|---|
| obec | Sčítání 2021: 24 obyvatel s obvyklým pobytem, 12 obydlených bytů. ČÚZK k 26. 7. 2026: 26 adresních míst (čp. 1–11, 13–16, 20, 21, 24–32) a 38 budov — 26 s čp., 11 bez čp. a jedna rozestavěná; čp. 12, 17, 18, 19, 22, 23 zanikla. Katastr má 786 parcel o výměře 371,6916 ha | ČSÚ SLDB 2021; ČÚZK, podrobné informace k. ú. 775606; RÚIAN |
| obec | Stopy zaniklých stavení v katastru: zbořeniště st. 27/2 (u čp. 6), st. 28/1 a 28/2; „objekt k bydlení“ bez čp. na st. 49 a „zemědělská usedlost“ bez čp. na st. 37; v řadě stavebních parcel chybí 18 kmenových čísel — kandidátní místa zaniklých čp. | RÚIAN, rozbor 31. 7. 2026 |
| obec | Kaple sv. Jana Nepomuckého (st. 42) s žulovým křížem je kulturní památka od 3. 5. 1958 (ÚSKP 28918/3‑3351): zděná návesní kaple 19. století se stanovou střechou a lucernou; kříž z roku 1884 nese nápis fundátorů „Tento kříž založil ke cti a chvále Boží Václav a Marie Kejval ze Zahrádky 1884“ | Památkový katalog NPÚ |
| obec | Jediný zastupitel obce Pošná s bydlištěm na Zahrádce: Luděk Bulant (zvolen 2018 i 2022 za Sdružení nezávislých kandidátů Pošná; 2022 třetí nejvyšší počet hlasů) — bydliště dle kandidátní listiny jen na úroveň části obce | volby.cz, otevřená data KV2018/KV2022 |
| obec | Pouť sv. Jana Nepomuckého obnovena rokem 2025; ročník 2026 ohlášen na 16. 5. s trasou od kaple k areálu bývalého dvora | poutnazahradce.cz |
| obec | Pole katastru (198 ha v LPIS) obhospodařují: ZD Velká Chyška 151,4 ha, Bc. David Andrew Homolka (Březina 1) 38,2 ha, SPV Pelhřimov a.s. 5,2 ha a dva menší uživatelé; Státní pozemkový úřad propachtovává ZD Velká Chyška 0,86 ha státních pozemků | LPIS 25. 7. 2026; registr smluv 74N1648 |
| obec | Prodeje státního lesa 5/2026: Lesy ČR prodaly parc. 155/2 (0,36 ha, 70 500 Kč) manželům Duffkovým z Pacova a parc. 288/1 (1,23 ha, 300 000 Kč) Bc. Davidu A. Homolkovi a Mileně Homolkové — potomek posledních majitelů velkostatku tak získává i les na katastru | registr smluv, kupní smlouvy Lesů ČR |
| obec | Obec Pošná 2023–2026: oprava místních komunikací 5c a 6c na Zahrádce (SWIETELSKY, 1,11 mil. Kč, 2024), žádost o opravu mostku (2025), vodné/stočné vodovodu Zahrádka shodné s Pošnou; ČOV (plocha Z27 dle ÚP 2017) zatím bez kroků v usneseních | usnesení ZO Pošná |
| obec | Odstávka elektřiny EG.D 7. 8. 2026 uvádí vypínaná odběrná místa u 22 platných čp.: 1–11, 13, 14, 15, 20, 21, 24–28 a 31 + odběry na parcelách bez čp. (3/1, 12/2, 44, 420/7); mimo seznam této odstávky jsou čp. 16, 29, 30 a 32 | EG.D, úřední deska Pošné |
| 1 | RÚIAN: rodinný dům na st. 29/1, zastavěná plocha 415 m², 2 podlaží, dokončení 22. 9. 2023 (novostavba/přestavba na místě historického N1 rodu Fraňků); vedle „jiná stavba“ bez čp. na st. 29/2 | RÚIAN, SO 8831181 |
| 1a | Historické označení bytu ze sčítání 1921; dnes bez samostatné adresy v RÚIAN | RÚIAN |
| 2 | Kulturní památka „venkovská usedlost“ od 3. 5. 1958 (ÚSKP 36052/3‑3350): zděné hospodářské budovy a roubené obytné stavení s trojdílnou dispozicí, doklad stavebního vývoje 19. století; stodola úředně zanikla (oznámení NPÚ 12. 1. 2021); chráněna st. 15/1, na st. 15/2 novostavba RD z 30. 3. 2016 (mimo ochranu) | Památkový katalog NPÚ; RÚIAN |
| 3 | RÚIAN: rodinný dům na st. 16/6 (78 m²); vedle zemědělská stavba bez čp. na st. 16/5 | RÚIAN, SO 8831203 |
| 4 | RÚIAN: rodinný dům na st. 17, 152 m², dokončení evidováno k roku 1919 (nejstarší evidovaný údaj vsi spolu s čp. 21). Místní paměť MJS‑001: „naše chalupa“ — posloupnost rodin Novák → Markvart. Martin Vaněk zde měl veřejně zachycenou podnikatelskou adresu ještě 13. 3. 2026; ARES od 8. 6. 2026 uvádí Prahu, takže nejde o aktuální pobytový doklad | RÚIAN, SO 8831211; místní paměť; Finance.cz; ARES |
| 5 | RÚIAN: rodinný dům na st. 21, 240 m², dokončení evidováno k roku 1960. Vasyl Liakh zde měl podnikatelskou adresu od 2. 6. 2025 nejpozději do 19. 3. 2026; od 20. 3. 2026 ARES uvádí Milotice, nejde tedy o aktuální pobytovou stopu | RÚIAN, SO 8831220; Finance.cz; ARES/RŽP |
| 6 | RÚIAN: rodinný dům na st. 27/1, 113 m², dokončení evidováno k roku 1960; sousední st. 27/2 (404 m²) je zbořeniště | RÚIAN, SO 8831238 |
| 7 | RÚIAN: rodinný dům na st. 8, 145 m², dokončení evidováno k roku 1945 | RÚIAN, SO 8831246 |
| 8 | RÚIAN: rodinný dům na st. 22, zastavěná plocha 536 m² (největší ve vsi), 2 podlaží, dokončení evidováno k roku 1970. Anna Vlčková: místo podnikání na čp. 8 od 26. 3. 2024 a veřejná adresa pro zasílání klubových dokladů ověřená 1. 8. 2026; ani jedna stopa sama neprokazuje bydliště | RÚIAN, SO 8831254; ARES/RŽP; Český klub rhodéských ridgebacků |
| 9 | RÚIAN: rodinný dům na st. 24, 397 m², 2 podlaží, 2 byty, dokončení evidováno k roku 1980 | RÚIAN, SO 8831262 |
| 10 | RÚIAN: rodinný dům na st. 26, 234 m², dokončení evidováno k roku 1980 | RÚIAN, SO 8831271 |
| 11 | RÚIAN: rodinný dům (bývalý panský dvůr) na st. 1 — s 3 543 m² zdaleka největší stavební parcele katastru; zastavěná plocha 304 m², způsob využití „rodinný dům“ od 2. 6. 2022 | RÚIAN, SO 8831289 |
| 11 | Areál bývalého dvora je cílem obnovené pouti („ruiny hospodářské usedlosti“); pozor — elektronická dražba 8/2026 se týká Pošné čp. 11 (jiný dům v k. ú. Pošná), nikoli tohoto areálu | poutnazahradce.cz; portaldrazeb.cz |
| 13 | RÚIAN: „objekt k bydlení“ (ne rodinný dům) na st. 12, 99 m², bez evidovaného bytu; aktivní odběr elektřiny 2026 | RÚIAN, SO 8831297; EG.D |
| 14 | RÚIAN: rodinný dům na st. 40, 242 m², 2 byty | RÚIAN, SO 8831301 |
| 15 | RÚIAN: rodinný dům na st. 10/3, 235 m², dokončení evidováno k roku 2006. Pavla Moravcová: podnikatelská adresa od 2019; Petr Moravec: starší podnikatelská stopa na čp. 15, ukončená nejpozději 18. 7. 2016 | RÚIAN, SO 8831319; ARES/RŽP; Atlasfirem |
| 16 | RÚIAN: rodinný dům na st. 7, 159 m², dokončení evidováno k roku 1960; jediné obydlené starší čp. mimo seznam odstávky EG.D 8/2026 | RÚIAN, SO 8831327; EG.D |
| 20 | RÚIAN: „objekt k bydlení“ na st. 18, 138 m², 1 byt. Sídlo podnikání: Michael Marousek (od 26. 6. 2025; ubytovací služby — možný nástup agroturistiky) | RÚIAN, SO 8831335; ARES/RŽP |
| 21 | RÚIAN: rodinný dům na st. 38, 281 m², dokončení evidováno k roku 1919 (nejstarší evidovaný údaj vsi spolu s čp. 4) | RÚIAN, SO 8831343 |
| 24 | RÚIAN: rodinný dům na st. 31, 111 m² | RÚIAN, SO 8831351 |
| 25 | RÚIAN: stavba pro rodinnou rekreaci na st. 34/2, 39 m²; tvoří dvojici s čp. 29 na st. 34/1 | RÚIAN, SO 8831360 |
| 26 | RÚIAN: rodinný dům na st. 32, 206 m² | RÚIAN, SO 8831378 |
| 27 | RÚIAN: rodinný dům na st. 43, 223 m², 2 podlaží, dokončení evidováno k roku 1960. Sídlo podnikání: Stanislav Janda (živnost zednictví od 1. 3. 1999, **místo podnikání na čp. 27 od 27. 6. 2005**, živnost přerušena od 13. 1. 2025). Místní paměť MJS‑004: „Standa Janda byl původně Rohovec“ (sdělení bez čísla domu; nespojovat automaticky) | RÚIAN, SO 8831386; ARES/RŽP; místní paměť |
| 28 | RÚIAN: rodinný dům na st. 47, 142 m², 2 podlaží, 2 byty, dokončení evidováno k roku 1990 — číslo nad historickou řadou, dosud bez historických dokladů ve spisu | RÚIAN, SO 8831394 |
| 29 | RÚIAN: drobný objekt na st. 34/1 (40 m², bez bytu), vedle rekreačního čp. 25 | RÚIAN, SO 8831408 |
| 30 | RÚIAN: stavba pro rodinnou rekreaci na st. 10/4, 193 m², vedle čp. 15 | RÚIAN, SO 30401500 |
| 31 | RÚIAN: rekreační dřevostavba na st. 53, 87 m², dokončena 17. 5. 2019 | RÚIAN, SO 97458104 |
| 32 | RÚIAN: rodinný dům na st. 3/1, 220 m², 2 podlaží, dokončen 13. 2. 2025 — nejnovější dům vsi (vytápění dřevo/biomasa, vlastní ČOV); sousední st. 3/2 je „společný dvůr“ | RÚIAN, SO 150466081 |
| obec | Ves má **vlastní vodovod „Vodovod Zahrádka“** s prameništěm v lese asi 500 m jihovýchodně od vsi, oddělený od soustavy Pošné; proto obec stanovovala pro Zahrádku výrazně nižší vodné (2007: 5 vs 12 Kč/m³ v Pošné; 2012 vč. DPH: 12,50 vs 21,70) | Územní plán Pošná, kap. 2.1.2; usnesení ZO Pošná 2007–2012 |
| obec | Na Zahrádce stojí **samostatná hasičská zbrojnice**; obec ji roku 2011 opravovala a roku 2012 jí vyměnila a podbila střechu (Lacina – Střechy, Hořepník). Téhož roku byla zrušena zahrádecká stříkačka PPS 8 a pořízeno plovoucí kalové čerpadlo | usnesení ZO Pošná č. 4/2011, 4/2012, 5/2012 a 1/2012 |
| obec | Územní plán (účinný 7. 3. 2017) vymezuje na Zahrádce jen dvě zastavitelné plochy: **Z26 pro venkovské bydlení, 0,32 ha, výslovně pro dva rodinné domy**, a Z27 pro technickou infrastrukturu, 0,08 ha, pro ČOV na části p. č. 386/1 | Územní plán Pošná |
| obec | Katastrální území měří **371,4467 ha**, sídlo leží ve výšce 515–540 m n. m. Houskův Mlýn stojí při Kejtovském potoce v k. ú. Zahrádka u Pošné, ale jeho budovy nesou čísla popisná části obce Pošná (čp. 35 a 79) | Územní plán Pošná |
| obec | V katastru je evidováno **poddolované území č. 2509 „Zahrádka u Pošné“** po těžbě rud před 16. stoletím — ves stojí na starém hornickém revíru | Územní plán Pošná, odůvodnění |
| obec | Kaple a kříž pod dlouhodobou péčí obce: 2007 žádost o dotaci z POV Vysočina, 2008 oprava kapličky, 2013 další oprava, **2020 zjištěn havarijní stav památného kříže** a získána dotace Ministerstva kultury; kříž restauroval MgA. Jan Vodáček | usnesení ZO Pošná 2007–2020; Z mého kraje |
| obec | Lesní pozemky p. č. 206/5 a 302/8 v katastru vlastnila k roku 2021 společnost Zem. spol. SKALSKO, s. r. o.; obec si nechala zpracovat znalecký posudek a jednala o odkupu | usnesení ZO Pošná 2021/2/15 |
| obec | Podle pamětníků vyřezal sošku sv. Jana Nepomuckého v návesní kapličce „pan Franěk z chalupy, kde se říkalo u Lučanů“; kříž za vsí dal postavit Antonín Franěk a místu se říká „U Fraňku“ nebo „u Lučanovského křížku“ | Z mého kraje (vzpomínky pamětníků) |
| 2 | Územní plán uvádí úřední členění kulturní památky do pěti chráněných částí: obytná část, stáje, kolna, stodola a ohradní zeď s brankou (stodola úředně zanikla roku 2021) | Územní plán Pošná; NPÚ |
| 6 | Zdeněk Svoboda: v letech 2019–2020 zde měl trvalý pobyt a byl vlastníkem rodinného domu — smlouva Kraje Vysočina o kotlíkové dotaci (PR02737.1375, 120 000 Kč, 9. 4. 2020) uvádí adresu „Zahrádka 6, 395 01 Pošná“ | registr smluv, KUJIP01F3XZV |
| 9 | Jaroslav Plášil, bytem Zahrádka 9, byl od 26. 9. 2001 do 22. 2. 2013 členem představenstva Zemědělského družstva Velká Chyška (a dříve 1993–1998); v komunálních volbách 1998 byl za sdružení nezávislých kandidátů zvolen zastupitelem obce Pošná | obchodní rejstřík (ARES), volby.cz KV1998 |
| 9 | Martin Plášil je s adresou „Zahrádka čp. 9, Pošná“ uveden mezi jednotlivě obesílanými účastníky vodoprávního řízení v rozhodnutí Městského úřadu Pacov z 18. 12. 2023. Listina dokládá jeho úřední kontaktní adresu k tomuto dni; sama nedokládá vlastnictví čp. 9 ani nepřetržitý pobyt | [rozhodnutí MÚ Pacov č. j. MP/15025/2023/Kp](https://www.obecdul.cz/sites/default/files/2023-12/Ve%C5%99ejn%C3%A1%20vyhl%C3%A1%C5%A1ka.pdf) |
| 9 | Roku 2008 schválilo zastupitelstvo obce úpravu veřejného prostranství u čp. 9 spolu s dezinfekcí obecní studny a opravou kanalizace na Zahrádce | usnesení ZO Pošná č. 3/2008 |
| 15 | Pavla Moravcová zde má nejen sídlo podnikání, ale doloženě i bydliště — smlouva o kotlíkové dotaci (PR02270.0027, 120 000 Kč, 27. 3. 2018) uvádí adresu čp. 15 a je podepsána „V Zahrádce“ | registr smluv, KUJIP018KO5Y |
| 27 | Stanislav Janda je v kotlíkové dotaci Kraje Vysočina (PR01537.0092, smlouva 16. 5. 2016, dodatek 12. 1. 2017) veden s adresou „Zahrádka 27, 395 01 Pošná“ — čp. 27 je tedy jeho bydliště, nejen sídlo živnosti | registr smluv, KUJIP01683BH |
| 28 | Luděk Bulant, zastupitel obce Pošná, měl v letech 2017–2018 na čp. 28 trvalý pobyt: smlouva o kotlíkové dotaci (PR02270.2421, 100 000 Kč, 27. 3. 2018) uvádí adresu „Zahrádka 28, Pošná“ a žádost místo realizace v k. ú. 775606 | registr smluv, KUJIP018KDEU |
| 28 | Zvolen zastupitelem v šesti po sobě jdoucích komunálních volbách (2002, 2006, 2010, 2014, 2018, 2022; roku 2002 s nejvyšším počtem hlasů v obci) a opakovaně předsedou kontrolního výboru (2014, 2018, 2022) | volby.cz, otevřená data; usnesení ZO Pošná |
| 28 | Starší vazba téhož domu: Václav Bulant (nar. 1939) byl členem představenstva ZD Velká Chyška 1993–2001, před ním Růžena Bulantová (1993); obchodní rejstřík u obou uvádí adresu „č. p. 28, Zahrádka“ (ARES ji chybně standardizoval na Zahrádku u Třebíče) | obchodní rejstřík (ARES) |
| obec | **Nedostatečně identifikovaní vlastníci** (úřední seznam ÚZSVM a ČÚZK) drží v katastru dodnes podíly na několika parcelách a uvádějí u nich poslední známou adresu — jediná veřejná strojově čitelná cesta ke jménům vlastníků. Bez adresy jsou vedeni František a Anežka Zelenkovi (parc. 306 a 307/1, LV 129), Matěj a Marie Dvořákovi (307/2, LV 111), František a Josefa Pikalovi (304/3, LV 119), Felix a Johana Pečenkovi (369/1, LV 116) a Stanislav Pečený s Marií Pečenou (342/17 a 342/32, LV 117). Polovinu podílů na společné parcele 305/3 (LV 21) drží sedm těchto osob | ÚZSVM, seznam NIV k 10. 8. 2020 |
| 9 | Antonín Plášil a Anna Plášilová, oba s poslední známou adresou Zahrádka čp. 9, jsou v seznamu nedostatečně identifikovaných vlastníků vedeni jako spoluvlastníci parcel 483/4 a 484/2 na LV 187 v sousedním k. ú. Pošná | ÚZSVM, seznam NIV |
| 18 | Antonín Kudrna a Marie Kudrnová, oba s adresou Zahrádka čp. 18, jsou vedeni jako spoluvlastníci (každý 1/2) parcel 297/1 (6 296 m²), 242/11 (3 525 m²) a 242/15 (10 250 m²) na LV 148 — dům sice zanikl, ale pozemky jsou v katastru dosud na jeho adresu | ÚZSVM, seznam NIV |
| 20 | Jan Zelenka s adresou Zahrádka čp. 20 je veden jako vlastník šesti parcel v katastru o výměře 23 470 m² (LV 149) — navazuje na rodinu Zelenkových doloženou v tomto domě od roku 1912 | ÚZSVM, seznam NIV |
| 5 | Vazba konkrétního jména na tento dům je doložena od roku 1992 (matriční rubrika Městského úřadu Pacov v měsíčníku Z mého kraje). Jde o žijící osobu mimo veřejné registry, proto se jméno uvádí jen v úplném záznamu rešerše | Z mého kraje 3/1992 |
| obec | Program rozvoje obce Pošná 2020–2024 uvádí pro Zahrádku 23 obyvatel, tj. 8,2 % obce (Pošná 147, Proseč 93, Nesvačily 18) | Program rozvoje obce Pošná |
| 12 | Číslo dnes v RÚIAN neexistuje (bez adresního místa i objektu); polohu a zánik domu je nutné dohledat ve starších mapách a knihách | RÚIAN, 31. 7. 2026 |
| 17 | Číslo dnes v RÚIAN neexistuje (bez adresního místa i objektu); polohu a zánik domu je nutné dohledat ve starších mapách a knihách | RÚIAN, 31. 7. 2026 |
| 18 | Číslo dnes v RÚIAN neexistuje (bez adresního místa i objektu); polohu a zánik domu je nutné dohledat ve starších mapách a knihách | RÚIAN, 31. 7. 2026 |
| 19 | Číslo dnes v RÚIAN neexistuje (bez adresního místa i objektu); polohu a zánik domu je nutné dohledat ve starších mapách a knihách | RÚIAN, 31. 7. 2026 |
| 22 | Číslo dnes v RÚIAN neexistuje (bez adresního místa i objektu); polohu a zánik domu je nutné dohledat ve starších mapách a knihách | RÚIAN, 31. 7. 2026 |
| 23 | Číslo dnes v RÚIAN neexistuje (bez adresního místa i objektu); polohu a zánik domu je nutné dohledat ve starších mapách a knihách | RÚIAN, 31. 7. 2026 |

Ruční recept na vlastníka kteréhokoli domu: nahlizenidokn.cuzk.gov.cz →
Vyhledat stavbu (obec Pošná, část obce Zahrádka, čp.) nebo Vyhledat parcelu
(k. ú. 775606, st. číslo dle tabulky) → captcha → číslo LV a vlastníci.
