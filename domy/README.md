# Dějiny jednotlivých domů Zahrádky

Spisy o domech mimo panský dvůr čp. 11 (ten má vlastní spis [vyzkum_statku.md](../vyzkum_statku.md)). Založeno 6. 11. 2026 podle pořadí pramenů skillu *dejiny-domu*. Osobní evidence zůstává v [obyvatele_zahradky_domy.md](../obyvatele_zahradky_domy.md) a [dolozene_pobyty.md](../obyvatele_zahradky_domy/dolozene_pobyty.md). Spis domu ji nekopíruje, ale skládá z ní dějiny stavby, držby a rodin.

| Dům | Spis | Parcela 1829 → dnes | Držitel 1829 | Hlavní rody |
|---|---|---|---|---|
| čp. 4 | [cp04.md](cp04.md) | st. 17 → st. 17 | Martin Votápek | Vondráčkovi, **Markvartovi 1863–1930**, dnes Vaňkovi |
| čp. 7 | [cp07.md](cp07.md) | st. 8 → st. 8 | Josef Barta | Píchovi, **Bartů 1829–1893**, **Pachtovi 1917–1943**, Adamovi |
| čp. 20 | [cp20.md](cp20.md) | st. 18 (?) → st. 18 | Václav Žák (?) | Žákovi, Dvořáčkovi, **Zelenkovi 1912–1932**, „Jihlavák“ |
| čp. 28 | [cp28.md](cp28.md) | (zahrada 32 domu N10) → st. 47 | – | **Bulantovi** (dům z let 1978–1990) |

## Společný základ pro všechny domy

- **[Domy Zahrádky 1829](../prameny_online/mapy_katastralni/1829/domy_1829.md)**: přiřazení popisných čísel N1–N22 ke stavebním parcelám stabilního katastru a jména držitelů z indikační skici. Šestnáct domů má parcelu určenou, N12, N13, N16 a N20 zůstávají otevřené.
- **Čísla stavebních parcel se od roku 1829 nezměnila**: čp. 4 stojí dnes na st. 17, čp. 7 na st. 8 a čp. 20 na st. 18, tedy na stejných číslech jako na mapě 1829. Pro každý dům lze proto sledovat stejnou parcelu přes mapy 1829, 1878, pozemkový katastr (před 1966), letecké snímky 1949–1990 a ortofoto 2022.
- Mapové řady `img/mapova_rada_cpNN.jpg` jsou výřezy 75 × 75 m ze zarovnaných vrstev mapy vsi (`website/img/mapa/podklad_*.jpg`). Obsahují archivní letecké snímky ČÚZK, které jsou jen pro vlastní potřebu; nepublikovat.
- **Oprava 6. 11. 2026:** usedlost st. 29 (čp. 1) na císařském otisku 1829 ještě není, vazba N1 = st. 29 platí až od doby před rokem 1878.

## Jak založit další dům

1. Z [domy_1829.md](../prameny_online/mapy_katastralni/1829/domy_1829.md) vzít parcelu a jméno roku 1829; z [soucasny_stav_domu.md](../soucasny_stav_domu.md) dnešní parcelu a RÚIAN.
2. Mapovou řadu vyrobit stejně jako u čp. 4, 7, 20, 28: výřez 200 × 200 px kolem adresního bodu RÚIAN ze všech vrstev `podklad_*.jpg` (rám 600 m, roh −706072 / −1117850, 0,375 m/px).
3. Z oddílu domu v `dolozene_pobyty.md` vybrat držitele a hlavy domácností (chalupník, rolník, domkář) a odlišit je od podruhů a čeledi.
4. Porovnat data narození ve sčítání 1921 s rodnými zápisy téhož domu: takto se u čp. 4 ukázalo, že pracovní příjmení `Mrázek` je ve skutečnosti **Markvart**.
5. Shrnutí a tabulka držitelů se generátorem `nastroje/vytvorit_mapova_data.rb` propíší do panelu domu na mapě vsi (blok „Dějiny domu“).

## Na řadě

- Spisy pro další domy podle [badatelské fronty](../badatelska_fronta_domu.md); nejvíc podkladů mají N1, N2, N3, N5, N6, N8, N9, N10 a N15.
- **Pozemkové (gruntovní) knihy 1784–1876 a josefínský katastr** (SOA Třeboň) jsou hlavní chybějící pramen pro držbu všech domů. Digitální archiv SOA Třeboň od listopadu 2026 vydává obrazy jen přes časově omezené podepsané odkazy; projektové skripty `nastroje/stahnout_sken_trebon*.sh` proto vracejí 404. Obrazy je třeba procházet v prohlížeči, nebo požádat archiv o reprodukce.
- **Písemný operát stabilního katastru** (Národní archiv): seznam stavebních parcel s čísly domů a držiteli potvrdí tabulku 1829 a doplní N12, N13, N16 a N20.
