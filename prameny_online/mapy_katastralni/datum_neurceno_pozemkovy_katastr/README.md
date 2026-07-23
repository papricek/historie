# Mapa bývalého pozemkového katastru – datum rastru neurčeno

Nový veřejný [Archiv ČÚZK](https://ags.cuzk.gov.cz/archiv/) vykresluje nad Zahrádkou spojenou vrstvu **„Pozemkový katastr“**. Pro cílové místo poskytuje obraz interní dílčí vrstva `pk_a`; starší aplikace Archiv-WEB přitom pro k. ú. 775606 ve svém dotazu na rastry žádnou samostatnou položku nevrátila.

| Soubor | Obsah |
|---|---|
| [pozemkovy_katastr_zahradka.png](pozemkovy_katastr_zahradka.png) | širší georeferencovaný výřez Zahrádky z vrstvy `pk_a` |
| [vyrez_st1_cp11.png](vyrez_st1_cp11.png) | podrobný neoznačený výřez hlavního dvora a okolních parcel |
| [vyrez_st1_cp11_oznaceno.png](vyrez_st1_cp11_oznaceno.png) | stejný výřez; modrý kruh je dodatečná badatelská pomůcka podle reprezentativního bodu dnešního stavebního objektu čp. 11 v RÚIAN |

Mapa zřetelně ukazuje stavební parcelu **1**, rozsáhlou dvorní zástavbu a samostatnou dlouhou budovu na st. 2. Proti třem zděným hmotám stabilního katastru 1829 je půdorys hlavního dvora podstatně proměněný. Bez data konkrétního zdrojového listu však obraz sám neurčuje rok přestavby.

## Proč není složka označena rokem

[Produktová metadata ČÚZK](https://geoportal.cuzk.gov.cz/Default.aspx?head_tab=sekce-02-gp&menu=2925&metadataID=CZ-CUZK-PK-R&mode=TextMeta&side=dSady_archiv) uvádějí, že mapy bývalého pozemkového katastru byly od katastrálních pracovišť převzaty do ÚAZK v letech 2021–2022, zatím nejsou archivně zpracované a zpřístupňují se po celých katastrálních územích podle předávacích seznamů. Veřejná mapová služba u tohoto výřezu neukazuje signaturu ani datum jednotlivého rastru.

[Oficiální historie pozemkových evidencí](https://cuzk.gov.cz/Katastr-nemovitosti/O-katastru-nemovitosti/Historie-pozemkovych-evidenci.aspx) zasazuje pozemkový katastr do období po zákonu z 16. 12. 1927, upozorňuje na klesající spolehlivost po roce 1938 a uvádí, že po roce 1956 se přestal udržovat. To je pouze časový rámec druhu operátu, **nikoli datace tohoto konkrétního listu**. Proto je obraz uložen pod `datum_neurceno_pozemkovy_katastr`, nikoli pod odhadnutým rokem.

Zelené linie v obrazu pocházejí z publikované spojené vrstvy. Modrý kruh není součástí archiválie, nevyznačuje historickou hranici parcely ani přesnou polohu zaniklé budovy a nesmí se použít k vytyčování.

Připravený, dosud neodeslaný dotaz na ÚAZK žádá o identifikaci zdrojového listu, jeho signaturu, datum a případnou možnost získat nespojený sken s mimorámovými údaji; je v [zadost_o_archivni_prameny.md](../../../zadost_o_archivni_prameny.md).
