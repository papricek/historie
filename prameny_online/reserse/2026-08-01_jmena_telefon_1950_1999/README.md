# Jmenná kontrola účastníků Českého telefonu 2000 ve starším tisku

Audit porovnává deset jmen s přesnými účastnickými adresami z roku 2000 s
plnotextem Krameria KK Vysočiny a JVK/CBVK. Pro každou osobu hledá přesné celé
jméno i příjmení na stránce, na níž se zároveň vyskytuje přesná fráze
`Zahrádka u Pošné`.

Celkem proběhlo **42 dotazů** (deset celých jmen, příjmení a pravopisná varianta
`Dorrschmidt` na obou serverech); **12 dotazů** mělo alespoň jeden zásah.

Výstup je záměrně jen objevovací. Dvě slova nalezená na stejné novinové straně
nemusejí patřit k sobě; každý zásah se musí přečíst v širším kontextu. Právě
tak byl vyloučen Karel Adam z *Vesnických novin* 31. 1. 1957: jméno patří do
samostatného článku o okresní komisi Národní fronty, zatímco Zahrádka u Pošné
je na téže straně jen v tabulce výsledků JZD.

Reprodukce:

```bash
ruby nastroje/proverit_povalecna_jmena_kramerius.rb \
  --as-of 2026-08-01 \
  --output prameny_online/reserse/2026-08-01_jmena_telefon_1950_1999/vysledky.json
```

Významné zásahy podle samotných příjmení potvrdily Emila Svobodu,
nejmenovanou družstevnici Rohovcovou a osoby příjmením Bulant pouze na úrovni
vsi. Ostatní zásahy byly obecná slova, odlišné osoby nebo oddělené články na
téže straně. Žádný nalezený článek nově nespojil některého z deseti
telefonních účastníků s konkrétním čp. před rokem 2000. Shodné příjmení se
proto nepřenáší k pozdějšímu domu. František Kříž a Kejvalovi v následujícím
seznamu pocházejí ze starší samostatné rešerše, nikoli z tohoto desetijmenného
auditu.

Nejpřesnější časové opory použitelné pro kontrolu řezu 1980 jsou:

- František Kříž, Zahrádka u Pošné, šedesátiny 2. 10. 1980; bez čp.;
- Jan a Anežka Kejvalovi, Zahrádka, zlatá svatba 13. 7. 1979; bez čp.;
- Václav Bulant, Zahrádka u Pošné, třída IV. B SPŠS Pelhřimov ve školním roce
  1984/85; jde o mladšího jmenovce a nelze jej ztotožnit s Václavem Bulantem
  doloženým později na čp. 28;
- František Rohovec, Zahrádka u Pošné, členské jubileum v srpnu 1989; bez čp.

Ani jedna z těchto stop nenahrazuje domovní seznam. Pro rozdělení osob mezi
čp. zůstává rozhodující evidence MNV Útěchovičky do roku 1978 a její dosud
neurčené pokračování pro rok 1980.
