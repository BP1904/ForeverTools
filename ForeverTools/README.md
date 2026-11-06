# ForeverTools 1.16.7

**Update-Helfer repariert:** Die Dateiprüfung akzeptiert jetzt die enthaltenen Schriftdateien, `!Options.lua` und Bibliotheksdokumente. Ältere Helfer lehnen diese Dateien ab und können sich deshalb nicht selbst aktualisieren. Einmalig den Helfer am Windows-Uhr-Symbol beenden, `Updater/Update-ForeverTools.ps1` durch die reparierte Version ersetzen und `Update.cmd` neu starten. Danach funktioniert wieder der Update-Button im Spiel. Prüfsummen- und Pfadprüfungen bleiben aktiv.

**Kampffehler behoben:** Threat Plates schreibt Lebenswerte und Maximalwerte jetzt ausschließlich in einen eigenen reinen Anzeigebalken. Blizzards TextStatusBar-Wertfunktionen werden nicht mehr aus dem Modul aufgerufen; der gemeldete Vergleich geschützter Zahlen wird so vermieden. Der Anzeigebalken verschwindet beim Abschalten und bei der Wiederverwendung einer Plakette. Nach dem Update `/reload` eingeben.

**Threat Plates:** Lebensbalken erhalten jetzt zusätzlich direkt den aktuellen Lebenswert und das Maximum der Einheit. Dadurch werden stehengebliebene leere Balken bei NPCs und Spielern aktualisiert. Fehlende Daten werden nicht durch erfundene Lebenswerte ersetzt; geschützte Werte gehen direkt an die nativen Balkenfunktionen. Nach dem Update `/reload` eingeben.

DungeonJournal: Der vorhandene Minimapschalter wird nach dem Laden auf eine Zeichenebene über der Minimap gesetzt. Das behebt die feste Ebene 8 von LibDBIcon bei höher liegenden Forever-Minimaps. Sichtbarkeitseinstellungen und Klickfunktionen bleiben erhalten.

Das Schmiede-Symbol sitzt weiter links neben der Minimap, damit es den DungeonJournal-Button unten links nicht verdeckt. Nach dem Update `/reload` eingeben.

**Startkorrektur für Forever:** Nicht unterstützte klassische Auktionsereignisse brechen den Addonstart nicht mehr ab. Alle Module erhalten ihre gespeicherten Einstellungen vor dem Start. Ein einzelner Modulfehler wird im Chat genannt; die übrigen Module und das Schmiede-Symbol starten weiter. Die klassische Auktionssuche bleibt auf Clients ohne passende API nicht verfügbar.

**Sichtbarkeit:** Das Schmiede-Schnellmenü enthält jetzt **Erfahrungsleiste**. Ein Klick oder `/ftxp show` blendet die Leiste mittig oberhalb der Bildschirmmitte ein, auch auf Höchststufe. Anschließend lässt sie sich verschieben. Falls die alte Einzelversion noch geladen ist, nennt eine Chatmeldung den erforderlichen weiteren `/reload`.

**Neu: Erfahrungsleiste.** Einstellungen unter /ad → Erfahrungsleiste. XP, fertige Quest-XP, Erholung, XP/h, Levelprognose und Spielzeiten. Ziehen verschiebt die Leiste. Größe: /ftxp width 600, /ftxp height 30, /ftxp font 14. /ftxp reset setzt die Position zurück; /ftxp stats setzt die Sitzung zurück. Die Sitzung bleibt bei /reload erhalten und beginnt beim neuen Einloggen neu.

Zur Übernahme EasyExperienceBar einmal zusammen mit ForeverTools laden. Anzeigeeinstellungen und die Charakterposition werden kopiert; die Einzelversion wird für diesen Charakter deaktiviert. Anschließend nochmals /reload. Danach kann der Ordner EasyExperienceBar entfernt werden. Weitere Charaktere für ihre Positionsübernahme vorher ebenfalls einmal gemeinsam laden. Die neue Leiste läuft vollständig ohne das Original.

**BigWigs und Nova Instance Tracker sind vollständig enthalten.** Im Schmiede-Schnellmenü öffnen oder mit `/ad` verwalten. BigWigs-Einstellungen: `/ftbw` bzw. `/bw`. Nova-Instanzverlauf: `/ftnit` bzw. `/nit`; Einstellungen: `/ftnit options`. Die beiden Modulschalter speichern die Auswahl; zum Übernehmen `/reload` eingeben.

Aktive Einzelversionen werden beim ersten Laden für den aktuellen Charakter deaktiviert. Zuvor werden BigWigs-Profile, Symbolposition und Statistik sowie Novas Einstellungen und Verlauf in eigene ForeverTools-Speicher kopiert. Nach dem Hinweis nochmals `/reload` eingeben. Vorhandene ForeverTools-Daten werden nicht überschrieben. Originalordner und Originaldaten bleiben erhalten. Bereits deaktivierte Einzelversionen können ihre Daten nicht übergeben; für eine Übernahme einmal zusammen mit ForeverTools einschalten und neu laden.

Enthalten: BigWigs v427.8 mit Kern, Plugins, Optionen und den zwölf bisher installierten Paketen; Nova Instance Tracker 2.31 einschließlich aller Module, Bibliotheken und Medien. BigWigs lädt Kern, Optionen und Bossmodule bei Bedarf aus internen Paketen. Ein Classic-/Forever-Bosspaket war in der Ausgangsinstallation nicht enthalten; zusätzliche Bosswarnungen entstehen durch die Integration nicht. Quellen und Rechtehinweise stehen in `Features/BigWigs/NOTICE.txt` und `Features/NovaInstanceTracker/NOTICE.txt`. Die lokale Anpassung erteilt keine zusätzlichen Weiterveröffentlichungsrechte.

Prüfung: Lua-5.1-Syntax, vollständige Dateiverweise, Start der Originalanwendungen mit simulierten Spiel-APIs, internes Nachladen von BigWigs-Kern/Plugins/Optionen, Datenübernahme und Modulschalter. Live-Darstellung und Bosskämpfe müssen im Spiel geprüft werden.

**Neu in 1.14.1: Schnellmenü am Schmiede-Symbol.** Linksklick auf den ForeverTools-Minimapbutton öffnet **Attune** und **Disenchantry**. Dort öffnet Linksklick die Funktion, Rechtsklick deren Einstellungen. **Module verwalten**, Rechtsklick auf das Schmiede-Symbol oder `/ad` öffnet die bisherige Modulübersicht. Abgeschaltete Module sind im Schnellmenü ausgegraut. Escape schließt das Schnellmenü. MinimapButtonButton wird dafür nicht benötigt. Nach dem Update `/reload` eingeben.

**Neu in 1.14.0: Attune läuft direkt in ForeverTools.** Öffnen mit `/ftattune` oder `/ad → Attune: Freischaltungen und Questketten → Optionen`. Das separate Attune-Addon ist nicht erforderlich. Nach der Installation `/reload` eingeben.

Enthalten sind die Freischaltungs-, Schlüssel-, Dungeon- und Klassenquestketten der installierten Forever-Version 16001-34: Fortschritt je Charakter, verzweigte Ketten, Questgeberkarten, Gegenstands-/Zauberbelohnungen, Gruppenabfragen und gespeicherte Charakterübersichten. Die Datenbasis umfasst 144 Ketten mit 2.905 Schritten, einschließlich Fraktionsvarianten und noch leerer Vorschauketten. Unvollständige Referenzdaten bleiben entsprechend unvollständig. Der im Original abgeschaltete Raidplaner bleibt abgeschaltet.

Eine geladene Attune-Einzelversion wird erkannt. Einstellungen, Charakterdaten und die zuletzt ausgewählte Kette werden einmal kopiert; die Originaldaten bleiben erhalten. Die Einzelversion wird für den aktuellen Charakter deaktiviert. Danach **nochmals `/reload`** eingeben. In der Übergangssitzung bleibt die integrierte Laufzeit gesperrt. Weitere Charaktere übernehmen ihre Auswahl beim ersten Laden; vorhandene ForeverTools-Charakterdaten werden dabei nicht überschrieben.

`/ftattune settings` öffnet die vollständigen Attune-Optionen. Ein zusätzliches Attune-Minimapsymbol ist dort optional; neue Einstellungen verwenden zunächst unser gemeinsames Schmiede-Symbol. Abschalten im `/ad`-Menü beendet die Ereignisverarbeitung, blendet Fenster und Symbol aus und verwirft ausstehende Timer. Daten bleiben gespeichert.

Die Anpassung verwendet einen eigenen Namensraum, eigene Speicher-/Fensternamen und alle benötigten Bibliotheken im ForeverTools-Ordner. Keine Laufzeitdatei wird aus dem separaten Attune-Ordner geladen. Attune ist von CixiDelmont / Antoine Desmarets; Rechtehinweise stehen unter `Features/Attune/NOTICE.txt`. Die lokale Anpassung erteilt keine Weiterveröffentlichungsrechte am Original. Analyse: `../Attune-Analyse.md`.

Mit Lua 5.1 und simulierten Forever-APIs geprüft: vollständiger Start ohne Originaladdon, Questabgabe/Freischaltung, Datenübernahme, Modulwechsel, Timer und Fehlstart. Die Darstellung und Bedienung im laufenden Spiel müssen noch geprüft werden.

**Neu in 1.13.0:** Die Lernübersicht ist aus dem Zauber-/Berufsbuch erreichbar, berücksichtigt Rufpreise und setzt Lehrer-Kartenpunkte. Grimoires werden pro Begleiterfamilie erkannt. Disenchantry erhält ein eigenes, optionales Minimapsymbol: `/ad → Entzaubern: Disenchantry → Optionen → Eigenes Disenchantry-Minimapsymbol anzeigen`. Nach dem Update `/reload` eingeben.

### Ergänzungen zur Lernübersicht

- **Im Buch öffnen:** Unter dem geöffneten Zauber-/Berufsbuch erscheint eine Schaltfläche zur jeweiligen Lernansicht. Auch geöffnete Herstellungs-/Verzauberungsfenster werden unterstützt. Der Link lässt sich im `/ad`-Menü unter „Was kann ich lernen?“ abschalten. Die nativen Buchseiten bleiben bedienbar.
- **Lehrerpreise:** „Rufrabatte bei Lehrerpreisen berücksichtigen“ ist standardmäßig aktiv. Der Automodus schätzt den günstigsten bekannten Preis je Fähigkeit; die Preisschaltfläche kann eine einzelne Lehrerfraktion oder Grundpreise auswählen. Aktuelle, direkt beim geöffneten Lehrer gelesene Preise sind gesondert markiert. Die Datenbasis verwendet für Forever 10 Prozent ab Wohlwollend; das ist eine Schätzung und keine Übernahme der Retail-Rabatttabelle. Grimoires und Lehrer ohne passende Fraktionsdaten erhalten keinen erfundenen Rabatt.
- **Kartenpunkt:** Waffenfertigkeit auswählen, unten den Lehrer wählen und „Kartenpunkt“ drücken. Es werden nur vorhandene, fraktionspassende Koordinaten verwendet. Zuerst wird ein nativer Kartenpunkt versucht, danach optional TomTom. Falls nötig, verwendet unser aktives Kartenmodul einen grünen Lehrer-Marker. Die Lernübersicht schaltet kein anderes Kartenaddon um und erfindet keine fehlenden NPC-Koordinaten.
- **Begleiterwissen:** Beschworene Hexerbegleiter werden nach einer stabilen Aktualisierung des Begleiter-Zauberbuchs gelesen. Ein Familienwechsel wartet auf das zugehörige Begleiterleisten-Ereignis. Höhere Ränge decken ersetzte niedrigere Ränge ab; unvollständige Daten erzeugen keinen falschen Gelernt-Status. Jägerwissen aktualisiert sich zusätzlich durch die eigene Lernmeldung.

Auto Rank, Materialkosten und unsere Kartendarstellung werden weiterverwendet; dafür wird keine zweite Umsetzung installiert.

**Neu in 1.12.0: Disenchantry ist integriert.** Öffnen über `/ad → Entzaubern: Disenchantry → Optionen` oder `/ftde`. Enthalten sind Gegenstandsauswahl, Schutzfilter, Sperrlisten, Materialprognosen, Hauptfenster, Kompaktleiste, Tastenkürzel und Statistik. Preise kommen zuerst aus unserem Auktionsscan; ein separates Disenchantry oder Auctionator wird nicht benötigt. Nach dem Update `/reload` eingeben. Eine aktive alte Disenchantry-Einzelversion wird nach Übernahme ihrer Einstellungen für den aktuellen Charakter deaktiviert; nach dem entsprechenden Hinweis nochmals `/reload` eingeben.

### Disenchantry kurz erklärt

1. `/ftde` oder die Aktion im `/ad`-Menü öffnen. Neue Installationen starten im Hauptfenster mit manueller Auswahl; seltene und epische Gegenstände sind zunächst ausgefiltert. Übernommene Original-Einstellungen bleiben erhalten.
2. Gewünschte Gegenstände markieren und pro Verarbeitung einmal auf **Entzaubern** klicken. Ausgerüstete Gegenstände werden nicht eingescannt. Vor jedem Klick werden Zielposition, Gegenstandsidentität, Sperre, Mindestmenge, Sperrliste und belegter Cursor geprüft.
3. Unter **Schutzfilter und Einstellungen** Gegenstandsstufe, Wertgrenze, Qualitätsfilter, Material-/Wertanzeige und Tastenkürzel einstellen. Die Tastenzuweisung gilt nur bei sichtbarem Verarbeitungsfenster. Schließen oder Abschalten gibt sie wieder frei.
4. **Kompaktleiste** bietet eine automatische Kandidatenauswahl, aber weiterhin nur eine Verarbeitung pro eigenem Klick. Set-, Stufen- und Wertschutz greifen bei dieser automatischen Auswahl. Bei eingeschaltetem Wertschutz werden auch unbekannte Preise übersprungen. Eine bewusst manuelle Auswahl kann diese automatischen Schutzfilter übersteuern. Die Sperrliste gilt weiterhin.
5. **Sperrliste** verwaltet ausgeschlossene Gegenstandsarten getrennt nach Modus. **Statistik** zeigt Sitzung und Gesamtwerte pro Charakter, Materialausbeute und geschätzte Werte; die Aufzeichnung beginnt beim ersten Öffnen des Moduls.

Mahlen und Sondieren sind nur nutzbar, wenn Client und gelernter Beruf passen; dafür werden mindestens fünf Kräuter bzw. Erze im Zielstapel benötigt. Im Kampf werden keine geschützten Ziele neu gesetzt. Beim Abschalten werden Entzauberziel, Auswahl und Tastenzuweisung freigegeben; nötige geschützte Änderungen warten bis Kampfende. Laufende, bereits gestartete Spielzauber werden nicht automatisch abgebrochen.

**Preise:** Zuerst unseren Auktionshaus-Vollscan durchführen. Marktwerte und Materialwerte sind Schätzungen aus gespeicherten Stückpreisen; fehlen Preise, wird kein Wert als Null vorgetäuscht. TSM oder Auctionator können optional weitere Preise liefern. Materialwahrscheinlichkeiten sind Tabellenprognosen und keine garantierte Ausbeute.

Befehle: `/ftde`, `/ftde settings`, `/ftde blacklist`, `/ftde stats`, `/ftde compact`, `/ftde de`, `/ftde mill`, `/ftde prospect`, `/ftde refresh`, `/ftde check`, `/ftde copy`. Alias: `/ftentzaubern`. Das vorhandene Schmiede-Symbol öffnet weiterhin das gemeinsame ForeverTools-Menü. Das zusätzliche Disenchantry-Symbol lässt sich dort unter Optionen per Häkchen anzeigen. Linksklick öffnet Disenchantry, Rechtsklick dessen Einstellungen. Ziehen ändert die gespeicherte Position.

Bei einer aktiven alten Einzelversion werden deren gespeicherte Einstellungen, Sperrlisten und Statistiken einmal kopiert. Die Originaldateien und Originaldaten bleiben erhalten. In dieser Sitzung bleibt die eingebettete Verarbeitung gesperrt, damit keine zwei Verarbeitungsoberflächen und Tastenzuweisungen konkurrieren. Nach dem angezeigten zweiten `/reload` läuft nur die integrierte Version. Die MIT-Lizenz und Hinweise von x_Raven_x und Rakuga liegen unter `Features/Disenchantry/LICENSE.txt` und `NOTICE.txt`.

**Neu in 1.11.0: „Was kann ich lernen?“** Die Lernübersicht nach dem Vorbild von What's Training ist direkt integriert: `/ad → Was kann ich lernen? → Optionen → Lernübersicht öffnen` oder `/ftlernen`. Vier Ansichten zeigen Klassenzauber, Waffenmeister, Begleiter und Berufsrezepte. Dazu kommen nächste Ränge, Voraussetzungen, Grundpreise, Suche, Ausblenden per Umschalt-Klick und Hinweise bei Stufenaufstieg. Ein separates What's Training ist nicht nötig. Nach dem Update `/reload` eingeben.

### Lernübersicht kurz erklärt

- **Klasse:** Offene Lehrerzauber, nächste Ränge und noch fehlende Voraussetzungen. Bereits gelernte Zauber sind zunächst verborgen. Ersetzte ältere Ränge werden berücksichtigt.
- **Waffenmeister:** Für die Klasse geeignete Waffenfertigkeiten mit Lehrernamen, Gebiet und Koordinaten. Eintrag anklicken, um die Angaben unten zu lesen.
- **Begleiter:** Jägerfähigkeiten und Hexer-Grimoires. Jäger öffnen einmal die Begleiter-Ausbildung, damit bereits erlernte Fähigkeiten erfasst werden. Hexer beschwören jede Begleiterfamilie einmal. Nach Aktualisierung des Begleiter-Zauberbuchs werden bekannte und fehlende Grimoires pro Familie gespeichert. Sukkubus und Inkubus bleiben getrennt; nicht sicher erfasste Fähigkeiten bleiben als „Bitte prüfen“ markiert.
- **Berufsrezepte:** Nur eigene erlernte Berufe; Anforderungen an Fertigkeit, Stufe, Ruf und Händlergunst sowie Lehrer-, Händler-, Quest- und andere Quellen. Unbekannte Voraussetzungen werden als zu prüfen gekennzeichnet.

**Eintrag anklicken** zeigt Details, **Umschalt-Klick** blendet ihn aus bzw. wieder ein. „Gelernte ein/aus“ und „Versteckte ein/aus“ ändern die Ansicht. Ignorierliste und Begleiterwissen werden pro Charakter gespeichert. Wenn die alte Einzelversion beim ersten Laden aktiv ist, werden deren Ignorierliste und vorhandene Jägerdaten übernommen; andere Original-Einstellungen werden nicht übertragen. Das alte What's Training kann anschließend deaktiviert werden. `/wt` bleibt dem Original vorbehalten.

Lehrerpreise berücksichtigen auf Wunsch Rufrabatte. Schätzungen und Grundpreise sind gekennzeichnet; beim geöffneten Lehrer gelesene Preise haben im Automodus Vorrang. „Preise: Auto“ wechselt zwischen Automodus, Grundpreisen und einzelnen Lehrerfraktionen. Gelernt wird weiterhin manuell beim Lehrer. Auto Rank verwendet anschließend die gelernten Ränge auf den Aktionsleisten; die Lernübersicht verändert diese nicht. Datenbasis: Forever/Camelot aus What's Training 11.0.0-beta25, MIT-Lizenz einschließlich Originalhinweis unter `Data/Training/LICENSE.txt`.

**Neu in 1.10.0: Auktionshaus erweitert – ohne separates Auctionator.** Unter `/ad → Auktionshaus → Optionen` stehen jetzt **Kaufen**, **Verkaufen**, **Eigene Auktionen**, **Einkaufslisten** und **Verlauf** bereit. Käufe und Abbrüche laden das Angebot erneut und verlangen eine Bestätigung. Verkaufsansicht mit Stückpreis, Stapelgröße, Stapelanzahl, Konkurrenzvergleich und Mehrfach-Einstellen. Eigene Auktionen lassen sich über alle Seiten auf Unterbietungen prüfen. Dazu kommen benannte Listen, Suchfilter, Text-Import/Export, Such- und Preisverlauf sowie Materialkosten und Gewinnschätzung für das ausgewählte Berufsrezept. Nach dem Update `/reload` eingeben.

### Auktionshaus kurz erklärt

- **Kaufen:** Namen eingeben und suchen. Alle Ergebnisseiten werden geladen und nach Stückpreis sortiert. „Kaufen“ lädt das Angebot erneut; die Bestätigung zeigt den Gesamtpreis des Stapels.
- **Verkaufen:** Gegenstand aus der Tasche auf das Verkaufsfeld ziehen. Stückpreis in Kupfer, Stapelgröße und Stapelanzahl eingeben. „Aktuelle Konkurrenz suchen“ schlägt einen Preis vor. „Einstellen“ bestätigt Menge, Stapelpreis und Anzahlung; zusätzliche Spielwarnungen bleiben wirksam. Ein Klick auf das belegte Feld nimmt den Gegenstand wieder auf.
- **Eigene Auktionen:** Aktualisieren oder „Unterbietungen prüfen (alle)“. Ein Abbruch lädt die betreffende Serverseite erneut und verlangt eine Bestätigung. Die Anzahlung geht dabei verloren. Kein automatischer Massenabbruch.
- **Listen:** Listenname eingeben und öffnen/anlegen. Import/Export verwendet lesbare Zeilen, je eine Suche. Beispiel: `Kupfererz;max=10000;minlevel=1;maxlevel=60;quality=1;exact=1`. `max` ist der maximale Stückpreis in Kupfer, `quality` die Qualitätsnummer (0 grau, 1 weiß, 2 grün usw.). Filter können weggelassen werden. Bis zu 20 Listen mit je 100 Einträgen. Alte ForeverTools-Listen werden übernommen.
- **Verlauf:** Bis zu 30 Suchtexte, 30 Scantage je Gegenstandsvariante und 100 Aktionsmeldungen. Ein angefragter Kauf ist noch keine Serverbestätigung.
- **Materialkosten:** Rezept im Berufsfenster auswählen, dann den Knopf unten im FT-Auktionsfenster drücken. Gewinnschätzung berücksichtigt AH-Gebühr, aber keine Anzahlung; Grundlage sind gespeicherte Scanpreise. „Reagenzien auf Liste“ ergänzt die Materialnamen. Verzauberungsmaterialien werden ebenfalls unterstützt.

Alle Geld-Eingaben sind **Kupfer**: 1 Silber = 100 Kupfer, 1 Gold = 10000 Kupfer. Einkaufslisten können auch außerhalb des Auktionshauses bearbeitet werden. Die Abfragesperre des Servers wird eingehalten; laufende Abfragen lassen sich abbrechen. Alte Auctionator-SavedVariables und dessen eigenes Exportformat werden nicht automatisch importiert. Der Textimport führt keinen Lua-Code aus.

**Neu in 1.9.0: Eigenes Auktionshaus-Modul ohne Auctionator.** Unter `/ad → Auktionshaus → Optionen` das Fenster öffnen oder beim Auktionator auf **FT Auktionshaus** klicken. Vollscan starten, danach Stückpreis und Verkaufsvorschlag im Gegenstands-Tooltip lesen. Namen eingeben, zur Einkaufsliste hinzufügen und per Klick suchen. Kaufen und Einstellen erfolgen über das normale Spielfenster. Nach dem Update `/reload` eingeben. Das alte Auctionator ist nicht erforderlich und kann in der Addon-Auswahl deaktiviert werden.

## GitHub-Updates

**Einmal nach der Installation `Update.cmd` doppelklicken.** Damit wird der Helfer gestartet und für die automatische Ausführung bei eurer Windows-Anmeldung eingerichtet. Danach genügt zum Anfordern ein Klick auf **Update** im `/ad`-Menü, ohne weiteren Bestätigungsdialog. Der Helfer lädt alle Module und meldet **Update fertig** als Windows-Hinweis, der nicht bestätigt werden muss. `Update.cmd` prüft den Start und zeigt den Pfad zum lokalen Protokoll an. Danach **`/reload`** eingeben, damit WoW die neuen Dateien einliest. Der Helfer lädt weder im Leerlauf noch beim Windows-Start selbstständig Updates. Autostart abschalten: Rechtsklick auf sein Symbol neben der Windows-Uhr → **Autostart ausschalten und beenden**.

Ein erweiterbares Addon für **WoW Forever 1.60.1.70425** (Interface 16001).
Keine zusätzlichen Addons oder Bibliotheken im Spiel erforderlich.

## Installation

1. [Fertiges ForeverTools.zip herunterladen](https://github.com/BP1904/ForeverTools/releases/latest/download/ForeverTools.zip), öffnen und den enthaltenen Ordner `ForeverTools` nach `Interface\AddOns` ziehen. Bei einer Launcher-Installation liegt dieser gegebenenfalls unter `_classic_beta_`.
2. Die Datei muss anschließend unter `Interface\AddOns\ForeverTools\ForeverTools.toc` liegen, ohne einen zusätzlichen verschachtelten Ordner.
3. WoW starten beziehungsweise `/reload` eingeben und ForeverTools in der Addon-Auswahl aktivieren. Neu kopierte Addon-Ordner können einen vollständigen Neustart erfordern.

Menü öffnen: **Schmiede-Symbol unten links an der Minimap**, **`/ad`** oder **`/forevertools`**. Das Fenster ist verschiebbar und lässt sich mit Escape schließen.

Die Hauptübersicht zeigt ein Ein-/Aus-Häkchen pro Modul, einschließlich **Quest-Gegner**, **Anti Fett Finger** und **Auto Rank**. Alle Unterpunkte starten eingeklappt. **„Optionen +“** öffnet die Beschreibung, Aktionen und Einstellungen des jeweiligen Moduls; **„Optionen -“** klappt sie wieder zu. Das Aufklappen verändert keine Einstellungen. Unterpunkte und Aktionen ausgeschalteter Module sind deaktiviert, die Optionen lassen sich weiterhin ansehen.

**Anti Fett Finger** ist vollständig integriert. Die Steuerung erfolgt über das Häkchen in der ForeverTools-Übersicht (`/ad`) oder `/aff on` und `/aff off`. Der Zustand wird pro Charakter gespeichert. Änderungen während eines Kampfes gelten nach Kampfende. Bei einer noch aktivierten alten Einzelversion werden deren Einstellungen übernommen und die alte Version für den aktuellen Charakter deaktiviert. Sie wird in dieser Sitzung weiterverwendet; ab dem folgenden `/reload` läuft die integrierte Funktion.

**Auto Rank** ist ebenfalls vollständig integriert und hat ein eigenes Häkchen. Es ersetzt niedrigere direkte Zauberränge auf allen normalen Aktionsleisten durch den höchsten gelernten Rang. Beim ersten Durchlauf ergänzt es fehlende aktive Fähigkeiten; anschließend werden neu gelernte Fähigkeiten auf freie Plätze der Hauptleiste oder eingeschalteter Zusatzleisten gelegt. Bei Platzmangel warten sie auf freie Plätze. Makros und Gegenstände bleiben erhalten. Im Kampf und bei belegtem Mauszeiger wird gewartet. Unter „Optionen +“ lassen sich Ränge manuell prüfen oder alle fehlenden Fähigkeiten erneut ergänzen; Befehle: `/autorank scan`, `/autorank fill`, `/autorank on/off`. Ein-/Aus-Schalter und Befehle sind synchron. Einstellungen, bekannte Fähigkeiten und wartende Ergänzungen liegen pro Charakter in ForeverTools. Eine aktivierte alte Einzelversion wird wie Anti Fett Finger übernommen und deaktiviert.

## Erstes Modul: Händler & Taschen

Das Modul und seine drei Funktionen sind anfangs aktiviert. Jedes Häkchen wirkt sofort; Einstellungen werden über WoWs SavedVariables accountweit gespeichert.

Beim Öffnen eines Händlerfensters:

1. Alle über WoWs „Alles reparieren“ reparierbaren Gegenstände am Charakter und in den mitgeführten Taschen reparieren. Voraussetzung: Reparaturhändler und genügend eigenes Gold. Die Gildenbank wird nicht verwendet.
2. Alle verkäuflichen grauen Gegenstände in den mitgeführten Taschen stapelweise verkaufen. Weiße und höherwertige Gegenstände sowie angelegte Ausrüstung werden nicht verkauft. Unverkäufliche Gegenstände bleiben erhalten.
3. Falls zuvor Gold fehlte, die Reparatur mit dem Verkaufserlös erneut versuchen.
4. Danach einmal WoWs integrierte Funktion **„Taschen aufräumen“** aufrufen (`C_Container.SortBags()`). WoW übernimmt alle Verschiebungen. Dadurch entfällt das langsame Verschieben einzelner Gegenstände durch das Addon.

Es gelten dieselben Regeln wie beim manuellen Klick auf „Taschen aufräumen“, einschließlich WoWs Sortierrichtung, Taschenzuweisungen, Spezialtaschen und ausgeschlossenen Taschen. Diese Einstellungen werden vom Addon nicht verändert. Die Chatmeldung bestätigt den Start; das eigentliche Aufräumen führt der Client aus.

Im Kampf wartet das Modul. Gesperrte Gegenstände werden abgewartet; dauerhafte Blockaden beenden den betreffenden Schritt mit einer Chatmeldung. Ein bereits belegter Mauszeiger wird nicht verändert. Beim Schließen des Händlerfensters werden keine weiteren Verkäufe oder Reparaturen ausgelöst; das anschließende Aufräumen kann noch fertiglaufen. Nach einer fehlgeschlagenen Aktion startet ein neuer Versuch beim nächsten Händlerbesuch.

Das übergeordnete Modul-Häkchen stoppt laufende Automatik. Einzelne Funktionen lassen sich unabhängig abschalten. Eine bereits vom Spiel angenommene Aktion wird durch das Abschalten nicht rückgängig gemacht.

## Automatische Questabgabe

**Quest-Sammelobjekte:** Unter `/ad → Quest-Gegner → Optionen` sind Funkeln und Tooltip-Zähler anfangs eingeschaltet. Beim Darüberfahren zeigt der Objekt-Tooltip das gelbe Questzeichen mit einem Zähler wie **2/7** für offene eigene Questziele.

Das native Funkeln wird mit ausgeschalteten Umrandungen (`Outline` und Grafik-Outline-Modi) angefordert. `ShowQuestObjectHighlightEffect` wird zusätzlich aktiviert, sofern der Client diese Einstellung anbietet. Partikeldichten unter 100 werden auf den dokumentierten Standard 100 angehoben; höhere Werte bleiben erhalten. Das kann auch andere Partikeleffekte deutlicher machen. Die zuvor geänderten Grafikwerte werden beim Abschalten wiederhergestellt. Nach dem Laden und nach Grafikänderungen werden die Werte verzögert erneut geprüft.

Zusätzlich zeichnet ForeverTools goldene Lichtpunkte an **allen verfügbaren und einzeln als Questobjekt erkannten Ankern**. Mehrere Objekte können gleichzeitig funkeln; das Addon begrenzt den eigenen Effekt nicht mehr auf das Interaktionsziel. Es erfindet keine Bildschirmpositionen: Wenn der Client nur den nahen Interaktionsanker liefert, bleibt der eigene Effekt auf diesen beschränkt. Der native Effekt ist der Ansatz für alle weiteren vom Spiel dargestellten Questobjekte. Die allgemeine Interaktionsreichweite des Forever-Clients wird dadurch nicht aufgehoben.

NPCs, Leichen und erledigte Sammelziele erhalten den eigenen Effekt nicht. Im Kampf pausiert er; Änderungen an Einstellungen warten bis zum Kampfende. `/ftquest sparkle` zeigt Grafikwerte, Partikeldichten und die Zahl der gleichzeitig verwendeten Objekt-Anker. Nach Änderungen an der nativen Darstellung einmal vollständig neu starten, damit die Weltobjekte neu geladen werden. Bereits aktives natives Funkeln kann nach dem Abschalten bis zum Spielneustart bleiben. Die vierfach gleichzeitige Darstellung ist mit simulierten APIs geprüft. Das Funkeln bei den Mirkkrautsamenkapseln der Quest „Pigmente für Farben“ wurde zusätzlich im Forever-Client bestätigt; weitere Sammelquests wurden noch nicht einzeln im Spiel geprüft.

**Quest-Gegner:** Das eigene Modul unter `/ad` zeigt über dem Gegnernamen ein gelbes Quest-Ausrufezeichen mit kompaktem Zähler **1/15** für offene Questziele aus deinem Questlog. Das Modul schaltet Gegnerplaketten auch außerhalb des Kampfes ein und fordert 100 Reichweite an (vom Client begrenzt). Beim Ausschalten werden die vorherigen Werte wiederhergestellt, sofern du sie zwischenzeitlich nicht selbst geändert hast. Nicht ausgewählte Plaketten bleiben sichtbar; nachgeladene Client-Einstellungen werden berücksichtigt. Reine Weltnamen außerhalb der Namensplaketten-Reichweite können keine Questzeichen erhalten. Der Fortschritt aktualisiert sich automatisch; erfüllte Ziele verschwinden. Mehrere offene Ziele erscheinen untereinander. Tötungsziele werden zusätzlich anhand des exakten Gegnernamens aus dem Questlog erkannt, auch ohne Anklicken oder verfügbare Tooltipdaten. Sammelziele werden angezeigt, sofern der Gegner-Tooltip sie mit einem Zähler meldet. Ziele anderer Gruppenmitglieder werden nicht übernommen. Ohne passende Questdaten bleibt die Anzeige leer. `/ftquest` zeigt zur Fehlersuche die aktuelle Reichweite und die Anzahl erkannter Namensplaketten an. Die Funktion ist unabhängig von der automatischen Questabgabe und von Threat Plates schaltbar.

Das zweite Modul integriert die Quest-Schnellabgabe aus `Guschi.zip`, Datei `Guschi/QuickTurnIn.lua` (Guschi 1.2.1, Autor: Philipp).

- Im Menü `/ad` über das eigene Häkchen **„Automatische Questabgabe“** ein- und ausschalten. Anfangs aktiviert, unabhängig von „Händler & Taschen“.
- Beim Anklicken eines Questgebers fertige Quests aus dessen Liste auswählen, den Fortschrittsdialog bestätigen und die Quest abgeben.
- Ohne Belohnungsauswahl oder bei genau einer wählbaren Belohnung automatisch abschließen. Bei mehreren Belohnungen bleibt die Auswahl dir überlassen.
- **SHIFT/Umschalttaste gedrückt halten**, um die Automatik vorübergehend zu pausieren.
- Neue Quests werden nicht automatisch angenommen. Die normale Questgeber-Interaktion bleibt notwendig.

Die Funktion reagiert wie die Vorlage auf `GOSSIP_SHOW`, `QUEST_GREETING`, `QUEST_PROGRESS` und `QUEST_COMPLETE`. Weitere fertige Quests werden ausgewählt, wenn der Client erneut die Questliste öffnet. Die Originaldateien im ZIP bleiben unverändert.

Die Integration ist mit simulierten WoW-APIs geprüft; ein Test dieser neuen Funktion im laufenden Client steht noch aus.

## Handwerksmaterial-Infos und Rezeptsuche

Aus `Guschi.zip` (Guschi 1.2.1, Autor Philipp) übernommen und in ForeverTools integriert:
`MatUse.lua` → `Modules/Materials.lua`, `Data.lua` → `Data/MaterialUses.lua` sowie
`AhButton.lua` und `Recipes.lua` → Rezeptsuche und `Data/Recipes.lua`.
Das Original-ZIP bleibt unverändert; Guschi muss nicht zusätzlich installiert sein.

- Eigenes Modul **„Handwerksmaterial-Infos“** im Menü `/ad`, anfangs aktiviert.
- Zwei einzeln schaltbare Funktionen: Material-Tooltips und Auktionshaus-Rezeptsuche.
- Tooltips zeigen bis zu acht Rezepte deiner gelernten Berufe, Materialmenge pro Herstellung und Skillwerte für gelb/grün. Bekannte Rezepte sind grün markiert; andere Berufe erscheinen unter „Auch für“. Weitere Rezepte werden gezählt.
- Im Auktionshaus erscheint **„Neue Rezepte suchen“** unter dem Fenster. Gesucht werden unbekannte Rezeptgegenstände deiner Berufe, für die mindestens die Hälfte der verschiedenen Materialsorten in Taschen oder Bank vorhanden ist. Die vollständigen Herstellungsmengen sind dafür nicht erforderlich. Die besten Materialabdeckungen stehen zuerst.
- Bereits in Taschen/Bank oder im zuletzt eingelesenen Briefkasten vorhandene Rezeptgegenstände werden übersprungen. Der Briefkastenstand wird pro Charakter gespeichert und beim Aktualisieren des Posteingangs neu eingelesen. Neu gekaufte Rezepte werden erst nach Erfassung im Briefkasten oder in den Taschen ausgeschlossen; die Vorlage markierte schon Gebotsversuche als gekauft, was hier bewusst entfällt.
- Leere Suchergebnisse führen zum nächsten Kandidaten. Beim Treffer stoppt die Suche; ein weiterer Klick geht zum nächsten Rezept. Käufe bleiben manuell. Schließen des Auktionshauses und Abschalten der Funktion brechen die Suche ab. Ohne Antwort stoppt sie nach zwölf Sekunden.

Die statischen Daten stammen laut ZIP aus **Beta 1.60.1.70245**. Vollständigkeit und Skillwerte für Client **1.60.1.70425** sind nicht bestätigt. Der grüne Skillwert wird wie in Guschi aus gelbem und grauem Wert berechnet. Fehlende Zaubernamen erscheinen als `#ZauberID`.

Verhaltenstests mit simulierten WoW-APIs prüfen Tooltips, Berufsfilter, Rezeptauswahl und Suchabbruch. Der Spieltest steht noch aus: `/reload`, Material-Tooltip ansehen, beide Häkchen einzeln prüfen und am Auktionshaus die Rezeptsuche testen. Falls Guschi ebenfalls aktiviert ist, dort „Handwerksmaterial-Infos“ ausschalten, um doppelte Tooltip-Zeilen zu vermeiden.

## Paladin: Segen & Gruppenbuffs

Eigenständiger Nachbau der Kernfunktionen aus dem bereitgestellten **PallyPower Forever v10.15.26** (`AddOns/PallyPower`). Das Modul verwendet eigene Lua-Dateien und WoW-Schaltflächen, ohne Ace3 oder andere mitgelieferte Bibliotheken. Die Quelldateien des bereitgestellten Addons bleiben unverändert.

**Dauerhafte Buffleiste im Stil der Vorlage:** Nach Login oder `/reload` erscheint bei aktiviertem Modul eine separate **100 UI-Punkte schmale Spalte**, deren Höhe mit den vorhandenen Klassen wächst. Ein Bufffeld ist 100 × 28 groß (Vorlage: 100 × 34). Sie bleibt auch bei geschlossenem `/ad`-Menü, geschlossener Zuweisungsansicht und ohne Gruppe sichtbar. Am Kopfbereich ziehen, um sie zu verschieben; die Position wird pro Charakter gespeichert.

Die Spalte enthält eigene Felder für Zorn der Gerechtigkeit, Siegel und Aura, optional Rettung und nur die in der Gruppe vorhandenen Klassen. Die zusätzliche Sammelzeile „Nächster Buff“ ist in der dauerhaften Leiste ausgeblendet, damit sie die Klassen-Buffanzeige nicht doppelt zeigt. Sie bleibt in der ausführlichen Zuweisungsansicht verfügbar. Jedes Feld zeigt nur eine Restzeit; bei Klassenbuffs mit Spieler-Ausnahmen zählt die kürzeste gemessene Restzeit. Klassenfelder zeigen außerdem Klassen- und Segenssymbol sowie fehlende Buffs. Hintergründe wie bei PallyPower: **Rot** = allen fehlt der Buff, **Gelb** = einigen fehlt er, **Blau** = Spieler-Ausnahmen fehlen, **Grün** = alle versorgt. Grau/`?` bedeutet unbekannt oder keine Zuweisung.

Beim Darüberfahren über eine Klasse klappt seitlich eine Liste auf: Vorname, Segenssymbol, Restzeit, `T` für Tank, `D` für tot, `OFF` für offline, `R` für außer Reichweite. Vollständige Namen bleiben für Zauberziele und Tooltips erhalten. Die Liste schließt kurz nach Verlassen des Mausbereichs und kann dank geschützter WoW-Handler auch im Kampf geöffnet werden. Bei mehr als 15 Spielern einer Klasse entstehen weitere Spalten. Die einzelnen Spieler sind direkt anklickbar; das Mausrad ändert die eigene Klassenzuweisung oder Spieler-Ausnahme außerhalb des Kampfes.

**Einzelne Selbstbuff-Felder:** Im Zorn-Feld wirken Links- und Rechtsklick ausschließlich Zorn der Gerechtigkeit. Das separate Siegel-Feld wirkt mit beiden Klicks das ausgewählte Siegel; sein Mausrad wählt das Siegel. Ein aktives Siegel erscheint bis zum tatsächlichen Ablauf grün, auch bei weniger als vier Minuten Restzeit; ein fehlendes Siegel rot und ein unbekannter Zustand grau. Das Aura-Feld wirkt die gewählte Aura; sein Mausrad wählt sie aus.

Die Aura-Auswahl erkennt alle gelernten Ränge der acht vorgesehenen Aura-Typen (Hingabe, Vergeltung, Konzentration, Schatten-/Frost-/Feuerwiderstand, Heiligkeit und Kreuzfahrer). Es genügt, dass der aktuelle höhere Rang gelernt ist; Rang 1 muss nicht mehr als bekannt gemeldet werden. Ein Zauberbuch-Abgleich per lokalisiertem Aura-Namen berücksichtigt auch abweichende Rang-/Ersatz-IDs des Clients. Ungelernte, passive, fremde Spezialisierungs- und ausdrücklich als künftig markierte Zauberbucheinträge werden dabei nicht angeboten. Die Erkennung wird bei Login und `SPELLS_CHANGED` aktualisiert und für kleine Leiste, Zuweisungsfenster und Aura-Synchronisierung gemeinsam verwendet. Gespeicherte Aura-Zuweisungen behalten ihre bisherigen Nummern.

**Verschieben:** Den kleinen Pfeilbutton oben links mit der linken Maustaste halten und ziehen. Er verschiebt die komplette Anzeige einschließlich der zugehörigen Spielerlisten. Die Position bleibt nach `/reload` erhalten. Während eines Kampfes ist Verschieben gesperrt.

**Zuweisungen bearbeiten:** `/ftpp`, das kleine Optionssymbol im Kopf der Leiste oder unter `/ad` die Aktion **„Paladin-Zuweisungen öffnen“**. Die Ansicht folgt dem bereitgestellten PallyPower-Screenshot: dunkler Hintergrund mit Raster, Aura- und Klassensymbole im Kopf, darunter eine Zeile pro Paladin. Die Aura steht in der ersten Symbolspalte, die neun Klassen rechts daneben. Links erscheinen Name, eigene Symbolanzahl, bekannte Segen, Rettungsschalter und Verbindungs-/Datenstatus. Unten stehen „Freie Zuweisung“, „Optionen“, „Auto-Zuweisung“, „Löschen“ und „Aktualisieren“. Die Breite beträgt 912 UI-Punkte, bei einem Paladin die Höhe 205; ab sechs Paladinen wird mit dem Mausrad über dem Tabellenhintergrund gescrollt. Die Buffleiste und ihre Zauberauslösung bleiben unabhängig von dieser Ansicht.

Links- oder Rechtsklick sowie Mausrad auf einer Segenszelle wechseln die Zuweisung des Paladins in dieser Zeile vorwärts/rückwärts. Die Aura-Zelle funktioniert ebenso. Fremde Zellen sind ohne passende Rechte/Freigabe deaktiviert. Der Rettungsschalter ändert nur deine eigene Einstellung. „Löschen“ entfernt nur Zuweisungen von Paladinen, die du steuern darfst; „Aktualisieren“ fragt die Gruppe erneut ab. „Optionen“ öffnet die bisherige Detailansicht mit Spieler-Ausnahmen, Voreinstellung und weiteren Funktionen. Beide Ansichten starten nach Login/Reload geschlossen. Ihr Schließen lässt die kleine Buffleiste sichtbar. Zuweisungen und eine Voreinstellung werden pro Charakter gespeichert.

- In der Tabelle den Segen direkt in der gewünschten Paladin-Zeile und Klassen-Spalte ändern. In der Detailansicht unter „Optionen“ lässt sich weiterhin oben der gewünschte Paladin auswählen. Rettung gehört wie in der Forever-Vorlage nicht zum normalen Segenzyklus.
- Die Buffschaltflächen wirken immer **deine** Zuweisungen: links großer Segen, falls gelernt, andernfalls normal; rechts normal. Spieler-Ausnahmen erhalten immer normale Segen. Ein Mausradschritt auf einer Spieler-Buffschaltfläche ändert dessen Ausnahme für den oben ausgewählten Paladin; „keine Ausnahme“ verwendet wieder die Klassenzuweisung.
- „Nächster Buff“ und die Klassen-„Buff“-Schaltflächen wählen außerhalb des Kampfes erreichbare, lebende Spieler aus. Fehlende Segen haben Vorrang. Die Vier-Minuten-Option steuert die automatische Empfehlung. **Ein Klassenfeld bleibt zusätzlich manuell anklickbar**, wenn alle Segen bereits länger laufen oder der Aura-Status unbekannt ist: Es erhält dafür weiterhin ein lebendes, verbundenes Ziel der Klasse. Bei unbekannter Reichweite darf ein bewusster Klick den Zauber versuchen; eine ausdrücklich gemeldete Reichweitenüberschreitung wird bei der Klassen-Zielwahl ausgeschlossen. Einzelne Spieler bleiben ebenfalls gezielt anklickbar.
- Die Segens-Schaltflächen verwenden geschützte, namensgebundene `/cast`-Aktionen wie die mitgelieferte Forever-PallyPower-Version. Damit bleibt das konkrete Ziel einschließlich Nachnamen festgelegt. Links wirkt den großen Segen, sofern gelernt und ohne Spieler-Ausnahme, andernfalls den normalen; rechts wirkt den normalen. Außerhalb des Kampfes wird die Belegung vorbereitet, im Kampf bleibt sie unverändert. Ein vorhandener Buff entfernt die manuelle Klassen-Zauberbelegung nicht mehr.
- Separate Rettungs-Schaltflächen über `/ad` aktivieren. Die Spielerschaltfläche wirkt normale Rettung; „Rettung: nächster Spieler“ verwendet links große Rettung, wenn gelernt und die Zielklasse keinen Tank enthält, sonst normale Rettung. Rechtsklick wirkt normal. Tanks werden durch die Vorschlagsfunktion und die Spieler-Rettungsbuttons ausgeschlossen.
- Aura und Siegel mit dem Mausrad an ihrer Schaltfläche auswählen, durch Klick wirken. Zorn der Gerechtigkeit hat eine eigene Schaltfläche. Die Aura-Zuweisung des ausgewählten Paladins lässt sich unten links vorwärts/rückwärts schalten.
- Bufflaufzeiten: rot = fehlt, gelb = unter vier Minuten, grün = aktiv, grau/`?` = unbekannt. Bei eingeschränkten Aura-Daten zählen nur zuvor tatsächlich gemessene Laufzeiten weiter. Ein unbekannter Buff wird nicht als frisch gewirkt angenommen.
- „Auto-Zuweisung“ verteilt bekannte Segen nach Klassenpräferenz ohne doppelte Segen, soweit mögliche Zuweisungen und bekannte Fähigkeiten das erlauben. Für andere Paladine benötigst du Gruppenleiter-/Assistentenrechte oder deren Freigabe. Aura-Zuweisungen werden manuell gewählt.
- „Speichern“/„Laden“ verwalten eine eigene Voreinstellung aus Klassenzuweisungen, Spieler-Ausnahmen, Aura und Siegel. „Abgleichen“ fragt die Gruppe nach ihren Zuweisungen und meldet deine eigenen.

Die Synchronisierung verwendet den `PLPWR`-Nachrichtenaufbau der gelieferten Forever-Version (`SELF`, `ASELF`, `ASSIGN`, `PASSIGN`, `MASSIGN`, `NASSIGN`, `AASSIGN`, `CLEAR`, `FREEASSIGN`, `REQ`). Fremde Zuweisungen werden nur von aktuellen Gruppenmitgliedern mit passenden Rechten übernommen. Vor- und Nachnamen bleiben erhalten. Versand wird zeitlich begrenzt. Die Kompatibilität ist mit simulierten Nachrichten getestet, noch nicht mit einem zweiten Spieler im laufenden Client.

**Im Kampf:** Vorbereitete Spieler und Zauber bleiben fest. Neue Ziele, Zuweisungen, Öffnen/Schließen und Abschalten des Fensters werden bis zum Kampfende aufgeschoben. Bereits vorbereitete Zauberschaltflächen können bis dahin weiter angeklickt werden. Jeder Zauber erfordert einen eigenen Klick. Das Modul wirkt keine Zauber selbständig.

Der Nachbau übernimmt nicht sämtliche Zusatzfunktionen der Vorlage: deren Skins, Ace-Profile, Gruppenberichte, Tastenkürzel, Reagenzienzählung und Cooldownübersicht sind nicht Bestandteil dieser Umsetzung. Das eigenständige PallyPower wird nicht verändert oder abgeschaltet. Für die Nutzung des Nachbaus allein kannst du es in WoWs Addon-Auswahl deaktivieren; gleichzeitiger Betrieb kann doppelte Oberflächen und Synchronisierungsnachrichten erzeugen.

**Prüfung:** Verhaltenstests mit Lua 5.1 prüfen die geschützten Schaltflächen, Kampfverhalten, Rollen-/Reichweitenfilter, Aura-Zwischenspeicher, Zuweisungsrechte, Protokoll und Voreinstellungen. Im Client noch zu prüfen: `/reload`, `/ftpp`, zuerst einen eigenen Segen auswählen und auf dich wirken, dann Gruppenmitglieder sowie Links-/Rechtsklick und Kampfverhalten prüfen.

## GTFO: Gefahrenwarnungen

Eigenständige Warntechnik nach dem bereitgestellten **GTFO 6.11** (Zensunim of Dragonblight; Classic: Myzrael). Die vier Alarmdateien aus der Vorlage sind unter `Sounds/GTFO` enthalten. Das ursprüngliche Addon muss nicht zusätzlich installiert sein.

**Wichtige Datengrundlage:** Die im Forever-TOC der Vorlage geladenen Dateien `GTFO_Spells_Forever.lua` und `GTFO_Fail_Forever.lua` sind leer. Deshalb ist auch hier keine vollständige Forever-Boss-/Flächenabdeckung vorgegeben. Das Modul erfindet keine Warnzauber und behandelt nicht jeden erlittenen Schaden als vermeidbar.

- Unter `/ad` das eigenständige Modul „GTFO: Gefahrenwarnungen“ sowie hohen Schaden, niedrigen Schaden, Fehlertreffer und Mitspieler-Schaden einzeln schalten. Anfangs aktiviert. Vier Testknöpfe spielen die unterschiedlichen Alarmarten ab.
- **`/ftgtfo test 1`** (alternativ 2, 3, 4): Warnton über den Master-Kanal testen. Die Lautstärke-/Stummschalteinstellungen des Spiels werden nicht geändert.
- **`/ftgtfo`**: Anzahl aktiver Regeln und nativer Tonregistrierungen sowie Befehlshilfe anzeigen.
- **`/ftgtfo add ZAUBERID high|low|fail|friendly`**: eigene Warnregel für einen bekannten Gefahrenzauber hinzufügen, z. B. `/ftgtfo add 123456 high`. Die ID im Beispiel ist ein Platzhalter und muss durch eine tatsächliche Gefahren-ID ersetzt werden. Regeln werden accountweit gespeichert. **`/ftgtfo remove ZAUBERID`** entfernt eine eigene Regel.
- Erschöpfungsgebiete und auslaufende Atemluft werden über WoWs Spiegel-Timer erkannt. Lava-/Feuerschäden werden zusätzlich ausgewertet, soweit der Client lesbare Kampflogdaten liefert. Fallschaden löst keinen Alarm aus.
- Die Classic-Liste mit **23 importierten Regeln** lässt sich separat einschalten. Sie ist **standardmäßig aktiviert** und wird beim ersten Reload dieses Updates auch für vorhandene Einstellungen eingeschaltet. Danach bleibt ein manuelles Abschalten gespeichert. Die IDs und Mechaniken sind für Forever weiterhin unbestätigt. Experimentelle Einträge der Vorlage werden ausgelassen. Tank-Ausnahmen, bestimmte NPC-Quellen, Mindestschaden und triviale Schadensanteile bleiben berücksichtigt, soweit lesbare Daten dafür vorliegen.
- Forever sperrt die Registrierung des Kampflog-Ereignisses. Das Modul versucht diese Registrierung auf Forever und modernen eingeschränkten Clients deshalb nicht. `pcall` würde die Blizzard-Blockierungswarnung nicht verhindern. Die Classic-Liste bleibt aktiv und wird weiter für nutzbare Aura-Warnwege verwendet; Regeln, die zwingend Kampflog-Schadensdaten benötigen, können auf Forever nicht ausgewertet werden. `/ftgtfo` zeigt diesen Status an.
- Verfügbare native Aura-Töne (`AddAuraSound`, andernfalls private Auren) werden genutzt. Alternativ werden ausschließlich konfigurierte, lesbare schädliche Spieler-Auren geprüft. Verborgene Werte werden nicht umgangen. Regeln, die Schadenshöhe oder bestimmte Quellen benötigen, werden nicht allein aus einer Aura erraten.
- Zusatztext erscheint bei vom Modul ausgewerteten Warnungen, wenn „Warnmeldung“ aktiv ist. Native Aura-Töne werden vom Spiel abgespielt und erzeugen hier keinen zusätzlichen Textcallback. Wiederholungen des Lua-Warnwegs sind auf einen Alarm pro 0,8 Sekunden begrenzt.

Das Abschalten stoppt den Lua-Warnweg und den zuletzt gestarteten Ton sofort. Änderungen an nativen Aura-Tönen dürfen bei Kampf-/Instanzbeschränkungen gegebenenfalls erst nach deren Ende registriert oder entfernt werden; bis dahin kann eine zuvor registrierte native Warnung weiter ausgelöst werden. `/ftgtfo` zeigt ausstehende Änderungen an. Gleichzeitig aktiviertes Original-GTFO kann eigene zusätzliche Töne erzeugen.

Mit simulierten APIs geprüft sind Warnkategorien, eigene Regeln, Tank-/Quellenfilter, deaktivierte Kategorien, Tonbegrenzung, native Registrierungen, deren Aufschub, geheime Werte und Umwelttimer. Ein Test im laufenden Forever-Client steht noch aus. Nach `/reload` zuerst die vier Töne testen; mechanikspezifische Warnungen benötigen passende Regeln.

## Threat Plates: Namensplaketten

Eigenständiger Nachbau der Kernanzeige des bereitgestellten **Threat Plates 13.3.0-beta6** (Suicidal Katt, Blacksalsify). Unter `/ad` als Modul **„Threat Plates: Namensplaketten“** schaltbar, anfangs aktiviert. Namensplaketten selbst mit **V** im Spiel ein-/ausblenden. Das Modul verändert dafür keine CVars und keine gespeicherten Sichtbarkeitseinstellungen des Spiels.

- Gegner erhalten Bedrohungsfarben. Als Schadensverursacher bedeutet Grün wenig Bedrohung, Gelb steigende/unsichere Bedrohung und Rot Aggro. Als Tank ist sichere Aggro grün und fehlende Aggro rot. Die Farben greifen bei lesbarem Bedrohungsstatus und erkennbarer Kampfbeteiligung.
- Automatische Tankerkennung über die Gruppenrolle und WoWs `UnitHasEffectivelyTankAura`, außerhalb des Kampfes zusätzlich über lesbaren Zorn der Gerechtigkeit. Bei eingeschränkten Rollen-/Auradaten im Kampf bleibt die zuletzt bekannte Rolle erhalten. Alternativ Automatik ausschalten und den manuellen Tank-Schalter verwenden.
- Spieler erhalten optional ihre Klassenfarbe, belegte Gegner Grau und andere Einheiten ihre Reaktionsfarbe. Die nativen Auswahltexturen am Lebensbalken und am Level werden transparent gehalten, auch wenn der Client sie erneut einblendet. Leveltext und Lebensbalken bleiben erhalten.
- Lebenswerte erscheinen im nativen Lebensbalken: beim anvisierten Ziel als Prozentzahl und voller aktueller Lebenswert (z. B. `75% · 12.345`), bei anderen Einheiten als Prozentzahl. Für das anvisierte Ziel wird bevorzugt der `target`-Token verwendet. Verborgene Werte werden ohne Lua-Berechnung über `UnitHealthPercent` und native Textformatierung angezeigt; dabei entfällt die eigene Tausendertrennung. Wenn die erforderliche Anzeige-API fehlt, wird nur der verfügbare Wert angezeigt. Ein verborgener Bedrohungsstatus wird nicht als „keine Bedrohung“ interpretiert.
- Flache Lebensbalkentextur und optional flache native Zauberleiste. **Lebensbalkenfüllung, Absorptionen, Zauberfortschritt, Unterbrechungsanzeige, Namen, Symbole und Klickziele bleiben beim Spiel.** Das Modul ersetzt diese Daten-/Aktionslogik nicht.
- Freundliche Plaketten werden anfangs nicht bearbeitet; optional nur außerhalb von Instanzen. Persönliche und gesperrte/forbidden Namensplaketten bleiben ausgenommen. Bei wiederverwendeten oder nachträglich aufgebauten Plaketten werden alte Bindungen gelöst und neue Einheiten zugeordnet.
- Beim Abschalten werden die ursprünglichen Balkenfarben, Texturen und die Transparenz der nativen Auswahlrahmen wiederhergestellt; die eigenen Texte werden ausgeblendet. Sichere Hooks bleiben registriert, bewirken bei deaktiviertem Modul aber keine Änderungen.

Der Nachbau verwendet keine Bibliotheken oder Grafiken des Originaladdons. Dessen zusätzliche Aura-/Quest-/Ressourcen-Widgets, individuelle NPC-Profile, Skripte, Skins, Offtank-Heuristiken, Namensplakettenskalierungen und vollständiger Optionseditor sind nicht Teil dieses Moduls. Nativ angezeigte entsprechende Informationen bleiben bestehen. Ist das ursprüngliche Threat Plates ebenfalls aktiviert, kann es die native Anzeige ausblenden oder überschreiben; für die Nutzung dieses Nachbaus das Original in WoWs Addon-Auswahl deaktivieren.

Mit simulierten APIs geprüft: Tank-/Schadensfarben, native Auswahltexturen einschließlich erneuter Client-Einblendung und Wiederherstellung, Klassenfarben, native Formatierung geheimer Lebenswerte, Plaketten-Recycling, nachträglich verfügbare Frames, Farben-/Texturwiederherstellung und Rückkehr zu nativen Zauberleisten. Im Spiel noch zu prüfen: `/reload`, Gegnerplaketten mit V einschalten, Gegner auswählen, einen Kampf beginnen, Rolle wechseln sowie Modul und Einzelfunktionen unter `/ad` testen.

## Decursive: Reinigung

Eigenständiger Nachbau des Reinigungskerns von **Decursive 2.9.0-RC3** (John Wellesz). Unter `/ad` als **„Decursive: Reinigung“** schaltbar und anfangs aktiviert. Sobald der Charakter einen unterstützten Reinigungszauber gelernt hat, erscheinen die Reinigungsfelder ohne Kopfzeile unterhalb der Bildschirmmitte, solo, in Gruppe und im Schlachtzug. Zum Verschieben außerhalb des Kampfes die **rechte Maustaste auf einem Feld halten und ziehen**. Die Position wird gespeichert. Ein kurzer Klick verwendet weiterhin die im Tooltip angegebene Reinigungsbelegung.

- Bis zu 40 kleine Gruppenfelder. Name und Tooltip zeigen die Einheit; Farbe und Tooltip erklären den nötigen Klick. **Rot = Linksklick**, **Blau = Rechtsklick**. Zusätzliche vorbereitete Belegungen sind Gelb/Umschalt-Linksklick und Violett/Umschalt-Rechtsklick. Die unterstützten Classic-Klassen benötigen höchstens zwei Zauber.
- Paladin: Reinigung beziehungsweise Läuterung; Priester: Magiebannung und Krankheitsreinigung; Druide: Fluch-/Giftreinigung; Magier: Fluchreinigung; Schamane: Krankheits-/Giftreinigung. Nur gelernte Fähigkeiten werden zugewiesen. Fähigkeiten, die mehrere Typen entfernen, teilen sich eine Klickbelegung.
- Beim Paladin entfernt ein **Linksklick** auf ein rotes Gruppenfeld den entsprechenden Effekt mit Reinigung, sofern gelernt. Der gewirkte Zauber bestimmt selbst, welchen passenden Effekt er entfernt.
- Native AuraContainer zeigen verborgene Effekte farbig an. Ohne diese API werden unlesbare Zustände als `?` markiert; lesbare Effekte funktionieren weiter. `D` = tot, `OFF` = offline, `R` = bekannte fehlende Reichweite bei einem lesbaren Auftrag.
- `/ad` enthält getrennte Schalter für Magie, Fluch, Krankheit, Gift, Soloanzeige und Warnton. Der Ton meldet neue lesbare Aufträge mit mindestens drei Sekunden Abstand; für verborgene Effekte gibt es keinen allgemeinen Lua-Warnton.
- `/ftdcr` erklärt die aktuellen Belegungen, `/ftdcr reset` setzt die Position zurück. Einstellungen und Position bleiben gespeichert. Gruppenfelder verwenden feste Einheitentokens und sichere Sichtbarkeitstreiber. Änderungen an geschützten Belegungen, Position und Sichtbarkeit werden während des Kampfes bis Kampfende aufgeschoben.

Die Umsetzung umfasst Gruppenreinigung. Die vollständigen Optionen, Prioritäts-/Ignorierlisten, Haustierzauber, offensives Entzaubern, Gedankenkontrolle, Spezialregeln einzelner Begegnungen und moderne Talentvarianten der Vorlage sind nicht enthalten. Das Originaladdon wird nicht verändert. Die Prüfung mit simulierten APIs ist erfolgt; tatsächliche Klickzauber und native Aura-Farben müssen nach `/reload` im Spiel getestet werden.

## Weitere Module ergänzen

`Core.lua` verwaltet Registrierung und gespeicherte Einstellungen. `Menu.lua` erzeugt die Auswahlkästchen aus den registrierten Modulen. `Modules/Merchant.lua` enthält das erste Modul.

Neue Lua-Datei vor `Menu.lua` in beiden TOC-Dateien (`ForeverTools.toc` und `ForeverTools_Camelot.toc`) eintragen:

```lua
local _, FT = ...
local module = {
    title = "Mein neues Modul",
    description = "Beschreibung seiner Funktion.",
    defaults = {example = true},
    options = {{key = "example", title = "Beispieloption"}},
}

function module:Initialize()
    -- self.settings enthält die gespeicherten Optionen.
    -- Vor Aktionen FT:IsEnabled("example") prüfen.
end

function module:OnSettingsChanged()
    -- Bei Bedarf laufende Aktionen abbrechen oder Optionen anwenden.
end

FT:RegisterModule("example", module)
```

Das neue Modul erhält automatisch ein eigenes Häkchen. Diese Modulverwaltung steuert die Funktionen der ForeverTools-Sammlung; fremde installierte Addons werden darüber nicht entladen.

## Prüfung

Die mitgelieferten Verhaltenstests unter `../tests/test_forevertools.py` laufen in Lua 5.1 mit simulierten WoW-APIs. Sie prüfen unter anderem Goldmangel, die Reihenfolge der Aktionen, ausstehende Verkäufe, Gegenstandssperren, Kampf und die Modulschalter. Für „Taschen aufräumen“ werden der einmalige native Aufruf, Fehler und der Start ohne Verzögerung pro Gegenstand geprüft; WoWs eigene Sortierlogik wird nicht nachgebaut. Die Testlaufzeit gehört nicht in den Spielordner.

Die bisherige Taschenfunktion wurde vom Benutzer im Spiel erfolgreich getestet. **Der Wechsel auf WoWs integrierte Funktion muss noch im Spiel geprüft werden.**

Für den ersten Spieltest: einen grauen Gegenstand und einen höherwertigen Gegenstand mitnehmen, Taschenlücken schaffen, einen Reparaturhändler öffnen und danach Verkauf, Reparatur, Taschenpositionen sowie jedes Häkchen einzeln prüfen. Bei einer Fehlermeldung mit `/console scriptErrors 1` die Fehleranzeige aktivieren und die Meldung sichern.

API-Referenz: [Container-API im WoW-UI-Quelltext](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/ContainerDocumentation.lua). Versions-/Interface-Abgleich: [Forever-Addon-Manager](https://github.com/julius-retzer/forever-addons).

## Karten im Leatrix-Stil

Unter **`/ad → Karten: Leatrix-Stil → Optionen`** sind Kartenaufdeckung, blaue Markierung unerforschter Flächen, Instanzen und Schlachtzüge, Flugpunkte, Schiffe/Zeppeline/Tiefenbahn/Portale, native Koordinaten und Gebietsstufen einzeln schaltbar. Flugpunkte werden über die native Kartenverwaltung angezeigt und durch die Flugpunktdaten des Clients ergänzt. Gebietsstufen stehen ausschließlich beim Darüberfahren direkt neben dem Gebietsnamen oben, etwa „Westfall (10–20)“. Flugpunkte werden für beide Fraktionen angezeigt; Geistheiler und Reiseorte der gegnerischen Fraktion sind optional. Die Ortsnamen stammen aus den Referenzdaten und sind überwiegend Englisch. Die Daten decken 44 Kartenvarianten und 214 Orte ab; Karten ohne Daten behalten ihre normale Darstellung. Aufgedeckte Flächen zählen weiterhin als unerforscht und gewähren keine Erkundungserfolge.

Zum Verschieben die **obere Titelleiste der Karte mit der linken Maustaste ziehen**. Positionen werden für Fenster und Vollbild getrennt gespeichert. Die Aktionen ändern die Größe um jeweils 10 % (50–150 %) oder setzen Position und Größe zurück. Während eines Kampfes warten Layoutänderungen bis Kampfende. Beim Abschalten werden die vorherigen Koordinaten-, Kartenfade- und Instanzsymbol-Einstellungen sowie das Layout wiederhergestellt.

Eine gleichzeitig geladene **Leatrix_Maps**-Einzelversion hat Vorrang; das integrierte Modul pausiert dann. Für ForeverTools-Karten die Einzelversion deaktivieren und `/reload` eingeben. Es werden keine anderen Addons automatisch deaktiviert.

Referenz: [Leatrix Maps 1.60.24 für Forever](https://www.curseforge.com/wow/addons/leatrix-maps/files/9262568), Autor Leatrix. Eigenständige Laufzeit mit Blizzard-Grafiken und aufbereiteten Karten-/Ortsdaten. Nicht übernommen: Leatrix-Grafiken, dessen Einstellungsfenster, vereinfachter Kartenrahmen, Gebietspfeile, Angelstufen und Schlachtfeldkarten-Erweiterung. Es ist keine vollständige Kopie von Leatrix Maps.

**Korrektur in 1.8.1:** Beim ersten Laden sind die Zoomdaten der Karte noch nicht vorbereitet. Die Kartenaufdeckung wartet jetzt darauf und wird automatisch nachgeholt. Flugpunkte und Gebietsstufen werden unabhängig davon aktualisiert und über der Kartenfläche dargestellt.

**Korrektur in 1.8.2:** Die Ortsmarkierungen verwenden einen eigenen nativen MapCanvas-Pin-Pool und Datenprovider. Position, Maßstab und Wiederherstellung nach Kartenwechseln übernimmt die Kartenverwaltung. Flugpunkte aus `C_TaxiMap.GetTaxiNodesForMap` ergänzen die Referenzdaten; benachbarte doppelte Einträge werden zusammengeführt. Die bisherigen dauerhaften Gebietsbeschriftungen und der zusätzliche Text unten sind entfernt. Die vorhandene Gebietsüberschrift erhält den Stufenbereich nur beim Hover.

**Neu in 1.8.3:** Flugpunkte erscheinen ausschließlich auf Gebietskarten, nicht auf Kontinent- oder Weltübersichten. Horde-Flugpunkte sind rot, Allianz-Flugpunkte blau. Neutrale Flugpunkte behalten ihre ursprüngliche Darstellung.

**Neu in 1.8.4:** Menethil und andere Flugpunkte werden unabhängig von der Spielerfraktion angezeigt; Allianz bleibt blau, Horde rot. Der Schalter für gegnerische Orte betrifft nur die Reiseorte. Zum Verschieben die obere Titelleiste ziehen. Der Drag-Bereich liegt über dem Kartenrahmen und lässt Porträt, Schließen und Maximieren frei. Layoutaktualisierungen setzen die Karte während des Ziehens nicht mehr auf die alte Position zurück.
