# Památková a archeologická evidence NPÚ – stav ověřený 23. 7. 2026

Veřejné mapové služby Národního památkového ústavu byly prostorově dotázány přes přesnou polohu cílového statku **st. 1 / čp. 11**. Službě byl bod předán v GIS pořadí `-705772,71, -1118150,40`; v tradičním označení souřadnic S-JTSK jde o `Y = -705772,71`, `X = -1118150,40`. Kontrolován byl také celý obal aktuální parcely st. 1. Výsledek rozlišuje dvě různé věci:

- statek leží v platném území s archeologickými nálezy **„Zahrádka.“, ID SAS 21475, kategorie ÚAN II**;
- parcela st. 1 ani dnešní objekt čp. 11 nejsou ve veřejných plošných vrstvách NPÚ vedeny jako kulturní památka, národní kulturní památka, součást památkové rezervace či zóny ani jako součást ochranného pásma.

Kategorie **ÚAN II** znamená území s důvodně předpokládaným výskytem archeologických nálezů, nikoli místo s už jednoznačně prokázanými nálezy. Karta charakterizuje lokalitu jako vesnici, intravilán, období středověk–novověk; podnětem vymezení byl vizuální průzkum a přesnost je uvedena s rozptylem přibližně 50 m. Schválena byla 18. 4. 2001 a aktualizována 9. 6. 2023. Poznámka k vymezení uvádí první zmínku roku 1379. Jde o stručný sekundární registrační údaj; archivní inventář použitý ve výzkumném spise uvádí 1378, takže karta sama neopravňuje tento jednoroční rozdíl rozhodnout.

## Kontrola ochrany cílové parcely

Přesný bodový dotaz do čtyř vrstev služby `CP_UAN` vrátil jediný zásah: vrstvu 1, tedy ÚAN II, s názvem `Zahrádka.`, ID SAS i polygonu `21475` a stavem `Platný`. Vrstvy ÚAN I, pásmo ÚAN II a ÚAN IV v bodě nic nevrátily.

Obálka celé dnešní parcely st. 1 (`xmin -705804,31`, `ymin -1118211,36`, `xmax -705722,84`, `ymax -1118131,26`) byla dále dotázána proti:

- vrstvám 0–9 služby NPÚ `CP_UAP_PVO` — národní kulturní památky, kulturní památky, statky světového dědictví a jejich nárazníkové zóny, části chráněných území, rezervace, zóny, krajinné památkové zóny a ochranná pásma;
- polygonové službě `CP_PrvekP` Památkového katalogu.

Všechny tyto dotazy vrátily **nula prvků**. Negativní výsledek platí pro veřejný stav uvedených služeb dne 23. 7. 2026. Neznamená, že statek nemá historickou hodnotu, že nebyl nikdy odborně dokumentován nebo že se v neveřejných spisech NPÚ nic nenachází.

## Dokumentační systém paGIS a MIS

Veřejná vrstva základních prostorových identifikátorů paGIS rozlišuje čp. 11 definičním bodem `IDOB_PG 974773`, přímo svázaným se stavebním objektem RÚIAN `8831289`. U bodu je však `IDREG 0`, `RADPORC 0`, bez názvu objektu a bez podrobného přírůstkového bodu. Přímé parametrické hledání v MIS podle tohoto paGIS ID vrátilo **0 dokumentů**. Nulový byl také kombinovaný dotaz na katastrální území `Zahrádka u Pošné` a domovní číslo `11`.

Přesný dotaz na celou lokalitu `Zahrádka u Pošné` vrátil 13 veřejných dokumentů. Všechny byly jednotlivě zkontrolovány a týkají se pouze kaple, kříže nebo chráněné usedlosti čp. 2:

| ID MIS | Datum uvedené v MIS | Obsah | Licence / místní uložení |
|---|---|---|---|
| [184158](https://iispp.npu.cz/mis_public/documentDetail.htm?id=184158) | 1988 | usedlost čp. 2, celkový pohled | neurčena, pouze odkaz |
| [184159](https://iispp.npu.cz/mis_public/documentDetail.htm?id=184159) | 1988 | návesní kaple, vstupní strana | neurčena, pouze odkaz |
| [376862](https://iispp.npu.cz/mis_public/documentDetail.htm?id=376862) | 23. 1. 2005 | návesní kaple od JZ | neurčena, pouze odkaz |
| [376863](https://iispp.npu.cz/mis_public/documentDetail.htm?id=376863) | 23. 1. 2005 | kříž před kaplí od SZ | neurčena, pouze odkaz |
| [376867](https://iispp.npu.cz/mis_public/documentDetail.htm?id=376867) | 23. 1. 2005 | usedlost čp. 2 od východu | neurčena, pouze odkaz |
| [376871](https://iispp.npu.cz/mis_public/documentDetail.htm?id=376871) | 23. 1. 2005 | usedlost čp. 2 ze dvora | neurčena, pouze odkaz |
| [376872](https://iispp.npu.cz/mis_public/documentDetail.htm?id=376872) | 23. 1. 2005 | chlévy usedlosti čp. 2 od JZ | neurčena, pouze odkaz |
| [376874](https://iispp.npu.cz/mis_public/documentDetail.htm?id=376874) | 23. 1. 2005 | kolna usedlosti čp. 2 od JV | neurčena, pouze odkaz |
| [376875](https://iispp.npu.cz/mis_public/documentDetail.htm?id=376875) | 23. 1. 2005 | kolna usedlosti čp. 2 od SV | neurčena, pouze odkaz |
| [1427880](https://iispp.npu.cz/mis_public/documentDetail.htm?id=1427880) | 23. 1. 2005 | kolna usedlosti čp. 2 od JV | [CC BY-NC-ND 4.0; uložen veřejný náhled](../2005/README.md) |
| [1051971](https://iispp.npu.cz/mis_public/documentDetail.htm?id=1051971) | 1963–2015, neověřeno | původní evidenční list kaple | neurčena, pouze odkaz |
| [1051976](https://iispp.npu.cz/mis_public/documentDetail.htm?id=1051976) | 1963–2015, neověřeno | původní evidenční list usedlosti | neurčena, pouze odkaz |
| [1439420](https://iispp.npu.cz/mis_public/documentDetail.htm?id=1439420) | 12. 1. 2021 | oznámení o zániku stodoly usedlosti čp. 2 | [úřední dílo; uložen úplný PDF](../2021/README.md) |

Úplná kontrola tedy nepřinesla snímek čp. 11. Přinesla však přesně datovaný obrazový kontext z let 1988 a 2005 a úřední stavební chronologii sousedního čp. 2: jeho stodola degradovala od 60. let a pravděpodobně zanikla v 80. letech 20. století. Tento zánik se nesmí přičítat cílovému statku.

## Dvě skutečně chráněné památky v okolí

Kontrolní dotaz v okruhu 500 m potvrzuje, že evidence v Zahrádce není prázdná:

| Přibližná vzdálenost od použitého bodu čp. 11 | Památka | Evidence |
|---|---|---|
| 92 m západně | kaple s křížem | kulturní památka, rejstříkové číslo `28918/3-3351`, právní stav 140254, stavební objekt RÚIAN 39261450 |
| 127 m západně | venkovská usedlost, dnešní čp. 2 | kulturní památka, rejstříkové číslo `36052/3-3350`, právní stav 147883, stavební objekt RÚIAN 8831190 |

Chráněná venkovská usedlost je **čp. 2**, nikoli cílové čp. 11 a také nikoli historické N1 / dnešní čp. 1.

## Uložené soubory

- [soucasna_pamatkova_a_archeologicka_evidence_st1_cp11.png](soucasna_pamatkova_a_archeologicka_evidence_st1_cp11.png) – odvozený orientační výřez: RÚIAN, polygon ÚAN II, cílový statek a dvě kulturní památky;
- [uan_zahradka_id21475.geojson](uan_zahradka_id21475.geojson) – úplný polygon a veřejné atributy ÚAN II v `EPSG:5514`;
- [kulturni_pamatky_do_500m_od_cp11.geojson](kulturni_pamatky_do_500m_od_cp11.geojson) – bodové atributy obou kulturních památek do 500 m;
- [isad_zahradka_21475.xlsx](isad_zahradka_21475.xlsx) – veřejný tabulkový export karty ISAD;
- [ruian_podklad_zahradka.png](ruian_podklad_zahradka.png), [uan_zahradka_id21475_pruhledne.png](uan_zahradka_id21475_pruhledne.png) a [uan_zahradka_id21475_vyrez.png](uan_zahradka_id21475_vyrez.png) – nezměněné servisní podklady použité pro označený výřez.

Odvozená mapa je badatelská pomůcka, nikoli úřední mapový výstup. Fialový polygon znázorňuje archeologické území celé části intravilánu; oranžový a modré kruhy jsou dodatečná označení podle přesných souřadnic veřejných dat.

## Veřejné originály

- [ISAD – Zahrádka., ID SAS 21475](https://isad.npu.cz/zahradka-21475)
- [NPÚ Geoportál – služba Území s archeologickými nálezy](https://geoportal.npu.cz/arcgis/rest/services/Tematicke/CP_UAN/MapServer)
- [NPÚ Geoportál – plošné vymezení údajů pro územně analytické podklady](https://geoportal.npu.cz/arcgis/rest/services/Tematicke/CP_UAP_PVO/MapServer)
- [NPÚ Geoportál – plošné vymezení prvků Památkového katalogu](https://geoportal.npu.cz/arcgis/rest/services/Tematicke/CP_PrvekP/MapServer)
- [Památkový katalog – venkovská usedlost, právní stav 147883](https://pamatkovykatalog.cz/pravni-ochrana/venkovska-usedlost-147883)
- [Památkový katalog – kaple, právní stav 140254](https://pamatkovykatalog.cz/pravni-ochrana/kaple-140254)
- [ČÚZK – veřejná mapová služba RÚIAN](https://ags.cuzk.gov.cz/arcgis/rest/services/RUIAN/MapServer)
- [NPÚ – Metainformační systém, parametrické hledání](https://iispp.npu.cz/mis_public/paramSearch.htm)
- [NPÚ – základní prostorové identifikátory paGIS](https://geoportal.npu.cz/arcgis/rest/services/Tematicke/CP_PIP_basic/MapServer)
