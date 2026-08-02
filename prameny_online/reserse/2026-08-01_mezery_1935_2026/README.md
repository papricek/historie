# Rešerše mezer 1935–2026 (1. 8. 2026)

Třetí rešerše novější historie, tentokrát cílená výhradně na dvě mezery, které
zbyly po předchozích kolech: **jména obyvatel mezi lety 1935 a 1990** a **vazba
jména na konkrétní číslo popisné po roce 1990**. Sedm směrů (`nastup-1960-1990`,
`tisk-1945-1960`, `protektorat-1938-1945`, `zpravodaje-1978-2026`,
`vlastnici-pozemku-dnes`, `volby-a-obec-1990-2026`, `matriky-a-evidence-1931-1965`),
každý s nezávislým ověřovatelem, jehož úkolem bylo nálezy vlastního směru
vyvrátit.

**Úplný čitelný záznam je v [zjisteni.md](zjisteni.md)** — 192 zjištění, z toho
69 s číslem domu, 47 ověřovacích verdiktů, 92 slepých konců a 67 navazujících
stop; `reserse_vystup.json` obsahuje tatáž data strojově.

## Dva prameny, které nikdo neotevřel

1. **Abecední rejstřík úmrtní knihy Pošná 12A** (id 11214, snímky 275–297).
   Elektronický rejstřík DigiArchivu zemřelé vůbec nezná, takže tato část knihy
   zůstávala nečtená. Uvádí jméno, ves, **číslo popisné** a datum, a posouvá tím
   matriční řadu se jmény a domy z roku 1930 až do roku **1937** — devatenáct
   zahrádeckých úmrtí, u sedmi nejmladších dohledány i plné zápisy s povoláním
   a rodinnými vazbami.
2. **Úřední seznam nedostatečně identifikovaných vlastníků (ÚZSVM/ČÚZK)**.
   Vlastníky dnešních domů nelze získat strojově z katastru, ale tento veřejný
   seznam uvádí u vlastníků jiných parcel poslední známou adresu. Audit vydání
   2014, 2020, 2022 a 2024 našel přesné adresní stopy čp. 9, 14, 18 a 20.
   Ani jedna uvedená parcela není stavební parcelou dnešního zahrádeckého domu;
   záznamy proto nejsou důkazem bydliště ani vlastnictví domu.

## Upřesnění seznamů NIV po srovnání čtyř vydání

- Dochovaná veřejná kopie okresního souboru s daty k 3. 3. 2014 doplnila
  Josefa Pudila a Aloisii Pudilovou s poslední známou adresou čp. 14. Stejný
  pár je na čp. 14 přímo doložen matrikou roku 1937; stáří adresy v seznamu NIV
  však není uvedeno a ve vydání 2020 už dvojice chybí.
- Přesné řezy souborů: 2014 — 42 relevantních řádků, 19 osob, 11 LV a adresy
  čp. 9/14/18/20; 2020 — 36 řádků, 15 osob, 9 LV a čp. 9/18/20; 2022 — 30
  řádků, 13 osob, 8 LV a čp. 9/20; 2024 — 24 řádků, 12 osob, 7 LV a čp. 9.
  „Relevantní“ zde znamená buď parcelu v cílovém k. ú., nebo přesnou poslední
  známou adresu v Zahrádce u parcely v jiném katastru; nejde o počet obyvatel.
- Tentýž soubor uvádí Františka a Miladu Olivovy jen u lesní parcely 292 na
  LV 115, bez adresy a bez bezpečné vazby ke konkrétnímu domu.
- Ve čtyřech vydáních bylo kumulativně nalezeno 11 různých LV. Porovnání se
  stavebními parcelami dnešních domů dalo nula shod, takže žádné jméno nebylo
  doplněno do kontrolního listu vlastníků domů.
- Zmizení řádku mezi vydáními dokládá jen změnu evidence, nikoli její právní
  důvod. Ani přítomnost ve veřejném souboru po 1. 1. 2024 sama nedokládá přechod
  majetku na stát.
- Postup reprodukuje `nastroje/proverit_niv_zahradka.py`; osobní identifikátory
  se do jeho výstupu nepřebírají.

## Co rešerše rozhodla

- **Čp. 23 byla hájovna** — Jan Jirků, lesní hajný, a jeho dcera Jiřina
  (civilní sňatek 27. 9. 1935 v Pelhřimově). Statistický lexikon hájovnu
  u obce jmenuje už roku 1921, ale bez čísla a jména.
- **Deputátník Jan Plášil bydlel v čp. 22** — dosud byl veden bez domu.
- **Josef Vacík** je v čp. 11 doložen podruhé, úmrtím roku 1930.
- **Václav Pařízek, šafář († 26. 5. 1939)** je posledním jménem známým šafářem
  dvora, nástupcem Františka Vytisky.
- Knihy **Pošná 10A (O 1931–1949)** a **12B (Z 1938–1949)** dosud nejsou
  digitalizované. Živá kontrola oficiálního katalogu 1. 8. 2026 opravila
  původní výklad: obě položky mají status **„čekáme na předání matriky do
  archivu“**, nikoli „připravováno k digitalizaci“. Praktický krok proto stále
  vede na matriku v Pacově; před případnou návštěvou je vhodné držení telefonicky
  potvrdit. — [DigiArchiv, přístupový bod Zahrádka](https://digi.ceskearchivy.cz/k/409642)

## Co ověření zachytilo

Tři tvrzení byla vyvrácena a všechna měla stejnou příčinu: **datum vzniku
živnosti není datem vzniku adresy**. Stanislav Janda podniká od 1. 3. 1999, ale
místo podnikání na čp. 27 má v rejstříku až od 27. 6. 2005; Anna Vlčková má
živnost od 20. 11. 2006, ale adresu čp. 8 teprve od 26. 3. 2024. Detailní výpis
RŽP (`/ekonomicke-subjekty-rzp/{ico}`) obsahuje u adresy pole `platnostOd` —
základní záznam ARES je neuvádí.

## Vědomě nepřevzato

Matriční rubriky měsíčníku *Z mého kraje* z let 1991–1992 uvádějí jménem sňatky
tehdejších obyvatel čp. 5 a čp. 28. U čp. 28 jde o osobu, která je jako
zastupitel obce ve veřejných registrech, takže dům je doložen i jinak; u čp. 5
jde o soukromou žijící osobu, a proto je v `soucasny_stav_domu.md` uvedena jen
existence vazby, nikoli jméno. Jméno zůstává v tomto úplném záznamu.

## Doplňkový audit po všech domech (1. 8. 2026)

- Kořen periodika *Z mého kraje* 1980–1993 byl v Krameriovi KK Vysočiny
  prohledán postupně na spojení `Zahrádka` s každým číslem **1–32**, potom na
  všechny výskyty Zahrádky/Pošné a na známá místní příjmení. Jediné bezpečné
  přesně adresované poválečné zásahy pro naši ves zůstaly **čp. 5 roku 1992**
  a **čp. 28 roku 1991**. Ostatní zásahy patřily jiné Zahrádce nebo neměly čp.;
  nulový výsledek se nepovyšuje na důkaz, že v periodiku další osoba není.
- Veřejné adresní přehledy RES byly prověřeny pro všech **26 dnešních adresních
  míst** podle jejich přesného identifikátoru. Potvrdily čp. 5, 8, 11, 15, 20
  a 27; starší přesunuté vazby čp. 4 a 15 byly ověřeny proti aktuálnímu ARES.
  Žádné další jméno nebylo bezpečně nalezeno. Podnikání ani sídlo organizace se
  nepovažuje za bydliště.
- Přesné webové hledání bylo zopakováno pro **čp. 1–32** i s nerozděleným PSČ
  `39501`, které se často používá v úředních PDF. Přibyly tři bezpečné
  nepobytové stopy: **Marie Vaňková, čp. 4** v úředním výpisu KN se stavem
  19. 3. 2025; **Stanislav Marousek, čp. 20** v archivovaném výpisu RES
  z 3. 2. 2024 (k 1. 8. 2026 už jej ARES nenachází); a **Růžena Bulantová s
  Václavem Bulantem, čp. 28** v rozhodnutí SPÚ z 26. 10. 2016. U žádné se
  úřední nebo podnikatelská adresa nevydává za bydliště. Data narození z
  veřejných příloh se do publikační vrstvy nepřebírají.
- Podrobné hledání v Registru smluv bylo metodicky ověřeno na všech číslech.
  Pole `party_address` je analyzované po slovech, nikoli jako přesná fráze:
  například dotaz na čp. 1 může vrátit smlouvu čp. 27. Úplný dotaz na výrazy
  `Pošná, Zahrádka` dal 43 smluv, ale jedinou přesnou adresu v metadatech naší
  vsi má nadále Stanislav Janda na čp. 27. Adresy v přílohách mohou chybět,
  zejména pokud PDF nemá textovou vrstvu; nulový výsledek proto není úplností.
- Výsledek tohoto auditu je promítnut do `obyvatele_1950_2026_data.json`.
  Přesný negativní a navazující plán pro každý dům a roky 1950/1980/2000/2026
  generuje `mezery_obyvatel_1950_2026.csv`.

## Dodatečný audit tisku podle čísla domu (1. 8. 2026)

- Přesné průniky tří pádových tvarů `Zahrádka/Zahrádce/Zahrádky u Pošné`
  s výrazy `čp.`, `č.` a `číslo` a následná kontrola čísel **1–32** v
  Krameriovi KK Vysočiny přidaly jedinou novou bezpečnou domovní vazbu:
  **Marie Křížová, čp. 8, 26. 2. 1956**. Článek o výroční členské schůzi JZD
  Zahrádka u Pošné ji výslovně nazývá „družstevnicí Marií Křížovou čp. 8“.
- Jméno se bez dalšího pramene neztotožňuje se dvěma staršími Mariemi Křížovými,
  které v čp. 8 zemřely v letech 1932 a 1933. Doklad zároveň neurčuje přesnou
  domácnost roku 1950; je bezpečnou oporou až pro rok 1956.
- Tři svůdné výsledky byly po přečtení širšího kontextu vyřazeny: Jan Dvořák
  čp. 1 a Josef Dvořák čp. 4 patří ve článku z 16. 6. 1956 do **Vysoké Lhoty**;
  Antonín Kříž čp. 5 s manželkou ve vydání z 4. 2. 1956 patří do kontextu
  **Chyšecka / Velké Chyšky**. Čtyři zásahy z píseckého týdeníku *Zítřek*
  (čp. 8, 16, 29 a 31) se týkají jiné Zahrádky na Milevsku.
- Metadata digitálních knihoven KKV, JVK/CBVK a MZK byla prověřena i pro
  telefonní seznamy kolem roku 2000. Veřejně dohledatelný adresář pro
  Pelhřimovsko/Pacovsko se nenašel; tento kanál proto žádnou osobu nepřidal.

## Uzavření zpravodaje JZD a nová obecní stopa (1. 8. 2026)

- Kořen zpravodaje JZD ČSP Velká Chyška byl znovu načten přímo přes API
  Krameria. Obsahuje **15 čísel a 358 stran pouze z let 1977–1980**; dřívější
  navazující stopa o digitalizovaných ročnících 1981–1989 byla chybná a byla
  v úplném rešeršním záznamu uzavřena.
- Všech **31 stran**, na nichž OCR v letech 1978–1980 zachytilo některý tvar
  názvu Zahrádky, bylo znovu vyhodnoceno. Neobsahují jméno bezpečně přiřazené
  k zahrádeckému domu. Kontrola místních příjmení našla například Jaroslava
  Plášila, pracovníky Kudrnu, Bulanta a Fraňka, ale zpravodaj je spojuje se
  stroji či pracovními skupinami celého JZD, nikoli s bydlištěm na Zahrádce.
- Strana 27 čísla z 20. 2. 1980 přesto zpřesňuje řez celé vsi. Tabulka
  „Celkové složení členské základny dle obcí“ uvádí k **1. 1. 1980** za
  Zahrádku **33 členů JZD**: 10 mužů a 5 žen v produktivním věku, 4 důchodce
  a 14 důchodkyň. Údaj se nesmí zaměnit za všech 51 obyvatel ani rozdělit mezi
  domy; pramen neuvádí jména ani čp.
- Veřejný rozhovor *Sestra pamětnice* (PDF vytvořené 14. 3. 2021) nově
  dokládá Marii Svobodovou, která podle textu bydlí s manželem „v malé vesnici
  Zahrádce“ a dříve pracovala v Proseči u Pošné. Kontext silně ukazuje na naši
  ves, text však neuvádí rozlišovací název ani číslo domu. Je proto vedena jen
  jako středně jistá obecní stopa a nesmí se podle příjmení domyslet k čp. 6.
- Veřejný telefonní seznam 1188 byl nakonec ověřen přes webový formulář. Osobní
  dotaz vyžaduje celé jméno a příjmení a neumožňuje výčet podle samotné
  lokality. Kontrolní dotaz `Luděk Bulant + Pošná` k 1. 8. 2026 nic nevrátil;
  nejde o negativní soupis vsi ani důkaz nepřítomnosti osoby.

## Audit dokumentů Obce Pošná a kontrola adres 2026 (1. 8. 2026)

- Vlastní fulltext obce vrátil pro `Zahrádka` **85 výsledků na čtyřech
  stránkách**. Textově bylo zkontrolováno **52 veřejných příloh** (PDF, DOCX a
  ODT), zejména usnesení zastupitelstva, závěrečné účty a zprávy o přezkoumání
  hospodaření. Žádná nepřidala bezpečné spojení soukromé osoby s konkrétním
  zahrádeckým čp.
- Majetkové dokumenty dokládají převody pozemků v k. ú. Zahrádka u Pošné,
  například p. č. 12/13, 420/9 a 420/14 s účinky vkladu 29. 2. 2024 a p. č.
  399/2 s účinky 21. 8. 2024. Kontrolní zpráva kupující uvádí jen iniciálami a
  pozemky nemají doloženou vazbu na některou stavební parcelu domu v projektu;
  proto se z nich nevytváří vlastník ani obyvatel žádného čp.
- [Oznámení EG.D č. 260306694](https://www.posna.cz/assets/File.ashx?id_org=12632&id_dokumenty=3660),
  datované 7. 7. 2026 a zveřejněné obcí 20. 7. 2026, vyjmenovává pro odstávku
  7. 8. 2026 adresy čp. **1–11, 13–15, 20–21, 24–28 a 31** (celkem 22
  dnešních čp.). Je to technická stopa adres v rozsahu jedné odstávky, nikoli
  důkaz existence odběru, vlastnictví nebo bydliště. Chybějící čp. se nesmí
  vyložit jako prázdné či nepřipojené.
- Totéž oznámení obsahuje také položky `čp. 0` a `čp. 61`, které nejsou mezi
  dnešními adresami projektu podle RÚIAN. Zůstávají anomálií adresního exportu
  EG.D a bez nezávislého potvrzení se nepřidávají jako další domy.

## OCR audit Registru smluv po každém čp. (1. 8. 2026)

- Protože oficiální vyhledávání neprohledá přílohy bez textové vrstvy, byla jako
  objevovací vrstva použita OCR/fulltextová nadstavba Hlídače státu. Pro každé
  číslo **1–32** proběhl zvláštní dotaz ve tvaru `"Zahrádka {čp}" AND "Pošná"`;
  každý zásah byl následně rozlišen podle stran, předmětu a OCR přílohy. Tvrzení
  převzatá do katalogu odkazují na původní záznam Registru smluv, nikoli jen na
  zrcadlo.
- Audit znovu bezpečně zachytil všechny čtyři již známé pobytové smlouvy:
  **Zdeněk Svoboda čp. 6**, **Pavla Moravcová čp. 15**, **Stanislav Janda
  čp. 27** a **Luděk Bulant čp. 28**. Žádného dalšího jmenovaného obyvatele
  nepřidal. Výsledek u každého čp., včetně negativního omezení, je nyní přímo v
  `obyvatele_1950_2026_data.json` a v každém domovním oddílu generovaného
  katalogu.
- U **čp. 11** přibyla přesná funkční stopa, nikoli obyvatel: dohoda Úřadu práce
  [PEA-SZ-67/2024](https://smlouvy.gov.cz/smlouva/31560192) uvádí Zahrádku 11
  jako místo výkonu práce anonymizovaného pomocníka správce objektu od 2. 1.
  nejdéle do 31. 10. 2025. Jméno je řádně redigované a smlouva neuvádí
  bydliště; osoba se proto do seznamu obyvatel nepřidává.
- Nejčastější falešnou shodou byly hromadné dopravní dokumenty, které obsahují
  název Zahrádky, Pošnou a dlouhé číselné tabulky. U čp. 3 se navíc objevila
  smlouva o digitalizaci pozemkové knihy a u čp. 4 další dopravní smlouva;
  žádná nepřiřazuje člověka k domu. Samotný zásah čísla v OCR se proto nikdy
  nepovažuje za číslo popisné.
- Svůdná smlouva PR02737-01.4544 byla obrazově i textově vyloučena. Uvádí
  trvalý pobyt i místo realizace **Pošná čp. 79**; jen budova leží na dvou
  katastrálních územích Pošná a Zahrádka u Pošné. K zahrádeckému čp. se tedy
  nepřiřazuje. Přímé stažení měsíčních exportů z oficiálního serveru otevřených
  dat bylo v této relaci opakovaně resetováno serverem; nejde o negativní
  výsledek datové sady.

## Fulltext webu Města Pacov a přesné klíče domů (1. 8. 2026)

- Celowebové vyhledávání Města Pacov uchovává i starší přílohy, které už
  nejsou na úřední desce aktivní. Dotaz `Zahrádka` vrátil **227 výsledků na
  deseti stranách**, z nich 196 dokumentových záznamů a 199 jedinečných
  příloh. Následovaly kombinace s čp. 1–32, stavebními parcelami dnešních domů
  a známými příjmeními. Číselné shody z územních plánů, jízdních řádů a jiných
  obcí se nepovažují za adresu.
- Kandidátní listina pro komunální volby 2014 nově potvrzuje **Luďka Bulanta**
  jako obyvatele místní části Zahrádka. Čp. neuvádí, proto jde jen o časovou
  oporu mezi přímými doklady čp. 28 z let 1991 a 2017, nikoli o důkaz
  nepřetržitého bydliště v témže domě.
- Přehled stanovisek na úseku ochrany ovzduší uvádí dne **24. 6. 2021 Josefa a
  Hanu Kadlečíkovy** u stavebního řízení pro rodinný dům v Zahrádce u Pošné.
  Čp. ani parcela chybějí; osoby se vedou pouze na úrovni vsi a jejich role se
  nesmí změnit na obyvatele či vlastníky.
- Hlavní katalog nyní u každého domu začíná lidmi, potom uvádí přesnou stavební
  parcelu a identifikátory RÚIAN, samostatný stav ověření vlastníka a teprve
  nakonec jednu stručnou stavební větu. Kontrolní CSV nese stejné identifikátory
  ve všech 128 časových řezech. Jména vlastníků zůstávají prázdná do ručního
  ověření v KN; CAPTCHA ani podmínky služby se neobcházejí.

## Úplná historická adresní rešerše RŽP (1. 8. 2026)

- Veřejná část živnostenského rejstříku byla dotázána na obec **Pošná** a část
  obce **Zahrádka** se zahrnutím platných i neplatných údajů. Vráceno bylo
  **15 podnikatelů-fyzických osob na 10 čp.**; u každého byl přečten úplný
  veřejný XML výpis s historií sídla. Všechny zásahy jsou sídlem podnikání,
  nikoli samostatnou provozovnou.
- Čtyři adresy jsou aktuální k 1. 8. 2026: Anna Vlčková na čp. 8 od
  26. 3. 2024, Pavla Moravcová na čp. 15 od 20. 8. 2019, Michael Marousek na
  čp. 20 od 30. 6. 2025 a Stanislav Janda na čp. 27 od 27. 6. 2005. Přerušení
  Jandovy živnosti od 13. 1. 2025 neruší zapsané sídlo.
- RŽP zpřesnil nebo nově přidal uzavřené intervaly: Martin Vaněk čp. 4
  (4. 11. 2020–8. 6. 2026); Vitalii Kotsan (22. 12. 2022–29. 12. 2025),
  Mykhailo Smarada (27. 12. 2022–29. 9. 2025), Volodymyr Sakalosh
  (2. 2. 2023–1. 9. 2025) a Vasyl Liakh (2. 6. 2025–20. 3. 2026) na čp. 5;
  Vitalii Forkosh čp. 7 (2. 1. 2023–8. 1. 2025); Jaroslav Plášil čp. 9
  (27. 2. 2012–4. 1. 2022); Petr Moravec čp. 15
  (2. 12. 2005–30. 3. 2015); Stanislav Marousek čp. 20
  (1. 6. 2015–10. 1. 2024); Jan Dubišar čp. 21
  (13. 12. 2022–20. 6. 2024) a Natálie Radová čp. 31
  (6. 2. 2024–24. 1. 2025).
- Tím přibyly první přesně adresované poválečné osobní stopy pro čp. 7, 21 a
  31 a tři další osoby pro čp. 5. **Žádný záznam se nepovýšil na bydliště**:
  sídlo podnikatele může být jen doručovací nebo administrativní adresou.
  Data narození a další nadbytečné osobní údaje z veřejných výpisů nebyly
  převzaty. Pramen: [Portál živnostenského podnikání](https://rzp.gov.cz/portal/cs/rejstrik).

## Komunální volební registry 2006–2022 (1. 8. 2026)

- Úplné registry kandidátů ČSÚ pro řádné komunální volby 2006, 2010, 2014,
  2018 a 2022 byly filtrovány na zastupitelstvo Pošné (`KODZASTUP=548600`) a
  bydliště `Zahrádka`. Z **40 kandidátních řádků Pošné** odpovídá Zahrádce pět
  záznamů, ve všech případech jde o **Luďka Bulanta**.
- Jde o bezpečnou stopu osoby na úrovni vsi v letech 2006, 2010, 2014, 2018 a
  2022. Registr uvádí jen obec nebo část obce, nikdy čp.; údaje proto nejsou
  důkazem nepřetržitého bydliště na čp. 28 mezi přímými doklady z let 1991 a
  2017–2018. Pramen: [ČSÚ, otevřená data komunálních voleb](https://volby.gov.cz/opendata/kv2022/kv2022_opendata_seznam.htm).
- Starší výsledkové tabulky 1998 a 2002 obsahují Luďka Bulanta a Jaroslava
  Plášila mezi kandidáty v obci Pošná, ale nemají sloupec části obce; pro
  tvrzení o Zahrádce proto použity nebyly.

## Aktuální zemědělské registry (1. 8. 2026)

- Veřejná [Evidence zemědělského podnikatele MZe](https://mze.gov.cz/public/app/SZR/EZP)
  byla dotázána na obec Pošná, kombinaci obce Pošná s adresním výrazem Zahrádka
  a jednotlivě na všech 15 IČO z úplného historického auditu RŽP. Obecní dotaz
  vrátil tři aktuální subjekty, ale na adresách Pošná čp. 80, Nesvačily čp. 1
  a Nesvačily čp. 3. Zahrádka neměla žádný zásah a žádné z patnácti známých
  zahrádeckých IČO nemělo aktuální záznam v EZP.
- [Registr ekologických podnikatelů MZe](https://mze.gov.cz/public/app/eagriapp/EKO/Prehled/)
  vrátil pro adresu Pošná dvě osoby, obě s místem podnikání Pošná čp. 80.
  Celostátní dotaz na adresní výraz Zahrádka vrátil čtyři osoby, ale žádnou v
  okrese Pelhřimov. Kontrola tedy nepřidala člověka k žádnému zahrádeckému čp.
- Jde pouze o aktuální veřejné podnikatelské registry. Nulový výsledek není
  dokladem historické absence zemědělce a adresa podnikání sama neprokazuje
  bydliště. Přesný výsledek je uložen v `agricultural_register_audit` v
  kanonickém JSONu.

## Registr příjemců dotací MZe (1. 8. 2026)

- Veřejný [Registr příjemců dotací MZe](https://mze.gov.cz/public/app/SZR/SubsidyReports/?ObecNaz=Po%C5%A1n%C3%A1&ObecKod=548600&searched=Reload)
  byl dotázán pomocí úředního kódu Pošné `548600`. Dvě stránky výsledků
  obsahují **13 příjemců**, z toho 11 fyzických osob a dvě organizace. U všech
  13 byly přečteny detaily plateb; nejstarší zde zobrazený rok je 2002 a
  nejnovější 2025.
- Výsledková adresa je u všech zkrácena na **„Pošná, 39501“**. Nerozlišuje
  Pošnou, Zahrádku, Nesvačily a Proseč a neuvádí čp. Mezi výsledky jsou jmenné
  shody **Jaroslav Plášil** (platby 2020–2025; SZR-ID 1001311476) a **Luděk
  Bulant** (2021–2023; SZR-ID 1014302245), avšak bez IČO. Záznamy proto
  nedokládají totožnost identifikátorem ani pobyt na čp. 9 či 28.
- Samostatně bylo ve formuláři prověřeno všech **15 IČO**, která RŽP historicky
  spojil s přesným zahrádeckým čp.; žádné IČO nemělo přímý zásah. To nevylučuje
  osobní záznam vedený bez IČO, jak ukazují právě oba jmenné výsledky, ani
  zemědělskou činnost mimo zobrazené dotační zdroje.
- Audit tedy nepřidal žádného obyvatele a neposouvá mezní rok přímého pobytu.
  U čp. 9 a 28 je v domovním katalogu pouze samostatná varovně označená obecní
  časová stopa. [Popis registru MZe](https://mze.gov.cz/public/portal/mze/farmar/registr-prijemcu-dotaci)
  upozorňuje, že data jednotlivých dotačních nástrojů se aktualizují v různých
  intervalech; ani aktuálnost hlavičky subjektu proto není pobytovým údajem.
  Reprodukovatelný výsledek je v `subsidy_register_audit` kanonického JSONu.

## Archiv úředních desek a čp. 11 (1. 8. 2026)

- Veřejný archiv eDesky byl prohledán samostatně pro zdroje **Město Pacov**,
  **Obec Pošná** a **Státní pozemkový úřad**. Vedle místních názvů následovalo
  na deskách Pacova a Pošné 22 přesných dotazů na jedenáct již známých plných
  jmen. Starší pošenský výsledek je jen oznámení EG.D z ledna 2024; dokument
  SPÚ patří stejnojmennému katastru v jižních Čechách.
- Jediný nový přesný domovní dokument je
  [souhlasné JES MěÚ Pacov č. j. R/2026/47724/3](https://edesky.cz/dokument/22774025-Z%C3%A1vazn%C3%A9%20stanovisko%20-%20JES%20-%20Stavebn%C3%AD%20%C3%BApravy%20zem%C4%9Bd%C4%9Blsk%C3%A9%20usedlosti%20Zahr%C3%A1dka%2011)
  z **18. 3. 2026**. Záměr se výslovně týká stavebních úprav Zahrádky čp. 11
  na st. 1 a parcelách 18/2 a 18/3; žadatelem je **IT Artist s.r.o.** Jméno
  zmocněné fyzické osoby je v publikované kopii redigované a nebylo doplněno.
- Oficiální veřejný rejstřík ARES pro spolek
  [iZahrádka, IČO 06725384](https://ares.gov.cz/ekonomicke-subjekty-v-be/rest/ekonomicke-subjekty-vr/06725384)
  zpřesnil dvě osoby spojené s organizací sídlící na čp. 11: **Patrik Jíra**
  je od 31. 1. 2018 předsedou a **Pavla Švantnerová** místopředsedkyní; u obou
  je funkce bez data ukončení. Data narození ani soukromé adresy z rejstříku
  nebyly převzaty.
- Jde výhradně o dvě statutární role a jednoho projektového žadatele. Ani jeden
  zápis není dokladem bydliště nebo vlastnictví čp. 11. Katalog proto získal
  tři přesné podpůrné položky, ale počet domů s přímým poválečným bydlištěm se
  nezměnil. Metoda a omezení jsou uloženy v `official_board_audit`.

## Položková kontrola archivních fondů (1. 8. 2026)

- Vlastní ARON Moravského zemského archivu obsahuje pro fond **MNV Pošná,
  NAD 1544** hlubší položkový inventář než národní portál. Přesně byly určeny
  pamětní knihy: inv. 17 / kniha 17 (1940–1964), inv. 18 / kniha 18
  (1965–1973) a inv. 19 / kniha 19 (1974–2007).
- Inv. 60 / karton 4 (1963–1990) se jmenuje „Evidence obyvatelstva, trvalý
  pobyt: obsahuje výsledky sčítání lidu a domů od roku 1869“. Z popisu fondu
  plyne hlavně přehled počtů domů a obyvatel osad; bez nahlédnutí se proto
  nesmí vydávat za jmenný domovní seznam Zahrádky.
- Zásadní negativní zjištění: inv. 61 / karton 4 (1953–1967) je výslovně
  **„Domovní seznamy: Pošná čp. 1–50“**. Nejde o Zahrádku a položka byla
  odstraněna z plánu jako domnělý pramen jejích domácností.
- Pro Zahrádku je poslední katalogově výslovně doložená řada domovních seznamů
  ve fondu **MNV Útěchovičky, NAD 1262**, s mezními daty 1951–1978. Přechod
  1979/1980 a držitel úplné evidence kolem let 1991/2001 musí potvrdit SOkA
  Pelhřimov nebo Obec Pošná. Kronika inv. 19 může dodat jména, nikoli zaručeně
  úplnou domácnost každého čp.
- U inv. 17–19 i inv. 60 jsou v ARONu pole digitálních objektů prázdná. Připojené
  PDF je pouze příloha k úvodu inventáře, nikoli obraz kroniky nebo evidence;
  jmenné údaje tedy nelze z katalogu rovnou přepsat.
