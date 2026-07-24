# Stabilní katastr 1829 – statek st. 1 / N11

## Uložené obrazy

| Soubor | Obsah |
|---|---|
| [cisarsky_otisk_list_II.jpg](cisarsky_otisk_list_II.jpg) | celý list II císařského povinného otisku |
| [cisarsky_otisk_statek_st1.jpg](cisarsky_otisk_statek_st1.jpg) | výřez stavební parcely 1, rybníka 21 a samostatné st. 2 |
| [indikacni_skica_A04A.jpg](indikacni_skica_A04A.jpg) | celý list A04A indikační skici se západní částí vsi a historickým N1 |
| [indikacni_skica_A04B.jpg](indikacni_skica_A04B.jpg) | celý list A04B indikační skici |
| [indikacni_skica_n1_franek_joseph_st29.jpg](indikacni_skica_n1_franek_joseph_st29.jpg) | detail historického N1, jména `Franek Joseph` a stavební parcely 29 |
| [indikacni_skica_statek_st1_cp11.jpg](indikacni_skica_statek_st1_cp11.jpg) | detail, který spojuje st. 1 s domem `N. 11. Dom:` |
| [prekryv_st1_cp11_1829-2026.png](prekryv_st1_cp11_1829-2026.png) | výzkumné lokální zarovnání dnešních polygonů st. 1 a objektu čp. 11 na otisk 1829 |

Veřejné originály: [císařský otisk, signatura B2/a/6C, inv. č. 9077, list II](https://ags.cuzk.gov.cz/archiv/openmap.html?typ=cioc&idrastru=B2_a_6C_9077-1_2) a [indikační skica TAB550018290](https://ags.cuzk.gov.cz/archiv/openmap.html?typ=skicic&idrastru=TAB550018290).

## Historický N1 je dnešní čp. 1, nikoli st. 1 / čp. 11

List A04A přímo uvádí `N. 1. Franek Joseph` u hospodářství se stavební parcelou **29**. Čtení jména je vysoké jistoty; přesný vztah Josefa Fraňka k pozdějšímu sedláku Františku Fraňkovi zatím doložen není. Aktuální RÚIAN vede na následnické parcele **st. 29/1** stavební objekt 8831181 s domovním číslem **1**. Historické N1 tak lze nově lokalizovat přibližně 180 metrů od cílové st. 1 / čp. 11.

[Aktuální srovnávací mapa](../2026/ruian_srovnani_st1_cp11_st29_cp1.png) modře označuje st. 29/1 / čp. 1 a oranžově cílovou st. 1 / čp. 11. Přímé polygonové výstupy jsou v [katalogu RÚIAN 2026](../2026/README.md). Tato prostorová návaznost je další nezávislý důkaz, že domovní číslo `N1` nebylo starším číslem cílového dvora.

## Lokální zarovnání 1829 / současnost

Otisk není v uloženém JPEG přímo georeferencovaný. Překryv je proto výzkumná registrace, ne zeměměřický výstup. Vstupem byly přesné současné geometrie RÚIAN v `EPSG:5514`:

- [parcela st. 1](../2026/parcela_st1_ruian.geojson), identifikátor 2959911304;
- [stavební objekt čp. 11](../2026/stavebni_objekt_cp11_ruian.geojson), kód 8831289;
- [kontrolní parcely 2 a 21](../2026/kontrolni_parcely_2_21_ruian.geojson); pro výpočet bylo použito těžiště rybníka 21. Dnešní polygon st. 2 v jednoduchém lokálním afinním modelu neodpovídá starému obrysu s přijatelným reziduem, proto do transformace nevstoupil.

Do lokální afinní transformace vstoupily čtyři hlavní rohy dnešní st. 1 (vrcholy 6, 2, 1 a 9 uloženého polygonu) a těžiště sousední parcely rybníka 21. Jejich protějšky byly ručně odečteny na otisku. Zbytkové odchylky pěti bodů jsou přibližně **5,7–18,0 obrazového bodu**, při místním měřítku zhruba 2,2–2,5 bodu na metr tedy řádově **2–8 metrů**. Čísla označují přesnost tohoto badatelského překryvu, ne přesnost původního katastrálního měření.

Přes toto omezení je výsledek pro rozlišení tří stavebních hmot jednoznačný: současný polygon objektu čp. 11 se klade na **severní růžovou budovu při okraji st. 1**, se shodnou podélnou orientací, a ne na západní nebo jižní hmotu. Lze proto bezpečně mluvit o kontinuitě **polohy stavební hmoty** od roku 1829. Překryv sám nedokazuje totožnost dnešních zdí, krovu ani nepřerušené trvání jedné konstrukce.

Registrační a kreslicí skript je uložen pracovně v `tmp/diagnostika_1829_lokalni.py`.
