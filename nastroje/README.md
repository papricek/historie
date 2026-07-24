# Nástroje použité při výzkumu

Tato složka uchovává reprodukovatelné postupy, které by jinak zůstaly jen v dočasném adresáři nebo v historii terminálu. Skripty samy nic netvrdí o totožnosti osob či staveb; interpretace a odkazy na uložené výstupy jsou v `vyzkum_statku.md`, `obyvatele_zahradky.md` a `prameny_online/README.md`.

## SOA Třeboň: obrazy a jmenný rejstřík

### Stažení jednoho snímku podle knihy a čísla

```bash
nastroje/stahnout_sken_trebon_z_knihy.sh 6623 73 /tmp/snim73.jpg
```

Skript načte veřejný náhled knihy, zjistí interní `data1` identifikátor a zavolá `stahnout_sken_trebon.sh`. Ten přečte Zoomify popis obrazu, stáhne dlaždice a složí je přes ImageMagick. Volitelný čtvrtý argument určuje úroveň pyramidy; bez něj se použije maximum.

Přímý nízkoúrovňový tvar zůstává k dispozici pro již známý obrazový identifikátor:

```bash
nastroje/stahnout_sken_trebon.sh 114020796 /tmp/snim73.jpg 3 6623 73
```

Závislosti: `curl`, `ruby`, ImageMagick (`magick`). Server vyžaduje běžný `User-Agent` a `Referer`; oba skripty je nastavují.

Souvislý rozsah stáhne:

```bash
nastroje/stahnout_rozsah_skenu_trebon.sh 6623 73 75 /tmp/oddani_1841
```

### Veřejný elektronický rejstřík matrik

```bash
ruby nastroje/hledat_matriky_trebon.rb \
  -o tmp/josef_dominik_emerich.html \
  '+Josef +Dominik +Emerich'
```

Podporované jsou stejné operátory jako na webu archivu: `slovo`, `začátek*`, `+povinné`, `-vyloučené` a `"přesná fráze"`. Volby `--od ROK`, `--do ROK` a `--strana N` předávají časový filtr a stránkování. Skript nejprve založí webovou relaci přes `search.php`, potom odešle serializovaný dotaz na `search_result.php`, původní HTML uloží a na standardní výstup vypíše základní pole nalezených záznamů.

Elektronický rejstřík je jen výběrový. Nulový výsledek se v tomto výzkumu nikdy nepovažuje za důkaz, že událost neexistuje; rozhodující je kontrola originálních obrazů příslušné knihy.

## Stabilní katastr a Archiv ČÚZK

| Skript | Účel |
|---|---|
| `diagnostika_1829_lokalni.py` | souřadnicová mřížka, diagnostika a afinní překryv císařského otisku 1829 s dnešní st. 1 a objektem čp. 11 |
| `vykreslit_klad_1829.py` | vykreslení polygonu kladu stabilního katastru vráceného službou ČÚZK |
| `projit_archivni_vrstvy_st1.sh` | bodový dotaz souřadnicí S-JTSK `-705760,-1118170` do katalogových vrstev Archivu ČÚZK |
| `dotaz_pozdejsi_katastralni_mapy.sh` | cílená kontrola vrstvy 16, tedy možných mladších katastrálních map |
| `stahnout_originalni_mapy_8865.sh` | stažení čtyř konkrétních rastrů originální mapy Zahrádky, inventární číslo 8865 |

Tři shellové skripty pro Archiv ČÚZK očekávají dočasný výsledek tokenové úlohy v `tmp/lms_token_job.json`. Identifikátory rastrů a souřadnice jsou záměrně ponechány konkrétní pro tento výzkum, aby bylo zřejmé, co přesně bylo dotazováno. Výstupní JSON v `tmp/` je pracovní; popsané a důležité výsledky jsou katalogizovány v `prameny_online/mapy_katastralni/`.

## Letecké snímky

`vytvorit_zarovnane_srovnani.py` reprodukuje badatelské zarovnání let 1949, 1953, 1961, 1967, 1975, 1978, 1990, 1992 a 2022 do geometrie ortofota 1953 a kreslí současnou st. 1 a objekt čp. 11. Matice jsou empirické podobnostní transformace odhadnuté podle cest a mezí mimo areál; nejde o úřední georeferenci. Závislosti: Python, NumPy a OpenCV.

## Pravidlo pro další práci

Nový opakovatelný postup nejprve uložit sem nebo jej přidat k existujícímu skriptu. Dočasný adresář `tmp/` je ignorovaný Gitem a nemá být jediným místem, kde algoritmus či dotaz přežije.
