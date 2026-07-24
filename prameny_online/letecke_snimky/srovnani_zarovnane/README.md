# Výzkumné zarovnání leteckých snímků 1949–1992

Tato složka obsahuje odvozené výřezy starších měřických snímků převedené do společné geometrie historického ortofota CENIA z roku 1953. Nejde o úřední ortorektifikaci ani o měřický podklad. Smyslem je bezpečněji rozlišit areál dnešní parcely **st. 1 / Zahrádka čp. 11** od sousedních usedlostí a od samostatné dlouhé budovy na st. 2.

## Hlavní výsledky

- [srovnávací tabule 1949–2022](srovnani_zarovnane_st1_1949-2022.jpg) – osm použitelných historických obrazů a kontrolní ortofoto 2022; oranžová plocha je **dnešní** hranice st. 1 a modrá plocha dnešní stavební objekt čp. 11 z RÚIAN;
- [kontrola zarovnání proti roku 1953](kontrola_zarovnani_proti_1953.jpg) – průsvit historických snímků přes referenční ortofoto, určený ke kontrole cest, rybníka a stabilních hran;
- jednotlivé neoznačené výřezy `[rok]_st1_zarovnano_k_1953.jpg`, vhodné pro další porovnání bez grafické vrstvy.

Rok 1968 není v zarovnané tabuli. Dostupný rám je příliš neostrý a šikmý; automatické i ruční kontroly dávaly více navzájem neslučitelných řešení. Ponechán je pouze původní standardizovaný obraz ve [složce 1968](../1968/).

## Zdroje a společná geometrie

- měřické snímky 1949, 1961, 1967, 1975, 1978, 1990 a 1992: veřejný [Archiv ČÚZK](https://ags.cuzk.gov.cz/archiv/), standardizované náhledy z obrazových služeb `Archiv/LMS_1930_40_50_60s` a `Archiv/LMS_1970_80_90s`;
- [bodový katalogový dotaz](../katalog_cuzk_bod_st1_dotaz_2026-07-23.json) do první z těchto služeb vrátil nad st. 1 roky 1949, 1953, 1961, 1967 a 1968, celkem 29 překrývajících se rámů; žádný veřejně katalogizovaný rám nad bodem není z období 1930–1948;
- historické ortofoto: veřejná [služba CENIA](https://micka.cenia.cz/record/basic/50210752-9d9c-4f47-956b-1951c0a80137); dotazovatelná [vrstva roků snímkování](https://micka.cenia.cz/en/record/full/62208754-7a50-452b-8f4b-729ac0a80164?dlang=cze) v bodě statku vrací **1953**;
- kontrolní ortofoto 2022: [WMS – Archivní ortofoto ČÚZK](https://geoportal.gov.cz/php/micka/record/basic/CZ-CUZK-WMS-ORTOARCHIV), vrstva `2022`;
- hranice parcely: [RÚIAN, vrstva Parcela](https://ags.cuzk.gov.cz/arcgis/rest/services/RUIAN/MapServer/5), prvek `id=2959911304`; místně uložená [geometrie GeoJSON](../../mapy_katastralni/2026/parcela_st1_ruian.geojson);
- dnešní budova čp. 11: [RÚIAN, vrstva Stavební objekt](https://ags.cuzk.gov.cz/arcgis/rest/services/RUIAN/MapServer/3), prvek `kod=8831289`; místně uložená [geometrie GeoJSON](../../mapy_katastralni/2026/stavebni_objekt_cp11_ruian.geojson).

Společný výřez má souřadnicový systém `EPSG:5514`, rozsah `-706072,-1118450,-705472,-1117850` a velikost v terénu 600 × 600 metrů. Náhledy jednotlivých měřických rámů mají 2400 × 2400 px; před registrací byly sjednoceny na 2048 × 2048 px s ortofotem 1953 a kontrolním ortofotem 2022.

Přímý dotaz na dnešní parcelu byl proveden jako ArcGIS REST `query` nad vrstvou 5 s podmínkou `id=2959911304`, výstupem `geojson` a `outSR=5514`. Služba dne 23. 7. 2026 vrátila polygon o evidované výměře 3 543 m². Druhý dotaz nad vrstvou 3 s podmínkou `kod=8831289` vrátil polygon budovy s čp. 11, evidovanou zastavěnou plochu 304 m² a nevyplněné datum dokončení. Oba polygony se do starších let promítají **jen jako orientační poloha dnešních evidenčních objektů**; nedokládají, že historická hranice parcely nebo přesný půdorys budovy měly ve všech letech stejný průběh.

## Metoda a kontrola

Červená opakovaná razítka `© MO ČR` byla při hledání shodných bodů obrazově vyloučena, protože jinak vytvářela falešné shody. Ve výsledných výřezech zůstávají originální náhledy včetně razítek beze změny. Kontrolní body byly hledány mimo vlastní areál statku, především na cestách, okraji rybníka a stabilních hranách. Z nich byla robustně odhadnuta podobnostní transformace – posun, jednotné měřítko a malé natočení – do obrazu 1953.

| Rok | Přijaté kontrolní shody | Medián zbytku | Měřítko | Natočení | Hodnocení |
|---|---:|---:|---:|---:|---|
| 1949 | 97 | 3,8 px | 1,0025 | +0,03° | nejlepší starší registrace |
| 1961 | 35 | 4,5 px | 1,0594 | −0,44° | dobrá pro rozlišení hlavních hmot |
| 1967 | 17 | 4,1 px | 1,0452 | −1,03° | použitelná, ne pro měření střech |
| 1975 | 11 | 2,6 px | 1,0661 | +1,19° | méně kontrolních bodů; orientační |
| 1978 | 16 | 3,8 px | 0,9999 | −2,72° | použitelná, ne pro měření střech |
| 1990 | 12 | 3,8 px | 1,0505 | +0,24° | geometrie přijatelná, obraz velmi měkký |
| 1992 | 15 | 5,1 px | 1,0405 | +2,21° | orientační až střední |

Zbytky jsou počítány na obrazu širokém 2048 px. Nevyjadřují přesnost hran staveb. Měřický snímek je středovým promítáním; výška střech, náklon kamery a změny porostu způsobují místní posuny, které jediná podobnostní transformace nemůže odstranit. Výsledky se proto nepoužívají k výpočtu rozměrů ani jako důkaz totožnosti jednotlivé zdi.

## Co je po zarovnání patrné

- Přesný dnešní obrys st. 1 bezpečně odděluje cílový dvůr od dlouhé budovy st. 2 vpravo. Ta se už nesmí započítávat do půdorysu hledaného statku.
- Modrý polygon dnešního čp. 11 překrývá podélnou střešní hmotu stejné orientace už roku 1949 a ve všech dalších použitelných poválečných obrazech. Lze tedy tvrdit, že v poloze dnešního evidovaného domu stála zastřešená budova nejpozději roku 1949. Nelze bez stavebního spisu tvrdit, že jde po celou dobu o stejné zdi nebo jednu nepřerušeně trvající konstrukci.
- Uvnitř dnešní st. 1 je už roku 1949 rozpoznatelná protáhlá vícekřídlá zástavba. Hlavní podélné hmoty jsou zřetelné také v letech 1953, 1961, 1967, 1975, 1978 a 1992; snímek 1990 potvrzuje celek jen hrubě kvůli malé ostrosti.
- Řada neposkytuje obrazový důkaz úplného zániku dominantního hlavního celku v intervalu 1949–1992. Proměňují se menší střechy, přístavky, volné plochy a čitelnost dvora.
- Podoba roku 1949 je už odlišná od tří zděných hmot zakreslených na císařském otisku roku 1829. [Originální mapa stabilního katastru reambulovaná roku 1878](../../mapy_katastralni/1829_reambulace_1878/README.md) však tyto tři hmoty na st. 1 ještě zachovává bez zjevné červené náhrady. Hlavní přestavební interval proto nově vychází **1878–1949**, ale snímky ani mapa samy neurčí přesný rok, důvod nebo to, které dnešní zdi jsou původní.
- Pro přesné pojmenování jednotlivých křídel zůstávají rozhodující stavební a pojišťovací písemnosti a zaměření z roku 2017. Letecká řada určuje hlavně přítomnost hmot a časová rozmezí, ne jejich funkci.
