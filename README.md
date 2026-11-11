# ForeverTools – ein Addon für alle unsere Funktionen

**Neu in 1.16.12: Minimap-Button.** Das Schmiede-Symbol hängt direkt am linken Minimap-Rand und trägt einen runden Rahmen wie beim Dungeon Journal. Nach dem Update `/reload` eingeben.

**Neu in 1.16.11: Attune aktualisiert.** Die integrierte Forever-Version steigt auf 16001-39: abschaltbare Sounds, ausblendbare Kategorien, VC/DM-Namenswahl und korrigierte Dungeon-Questketten. Suche und Navigation bleiben erhalten. Nach dem Update `/reload` eingeben.

**Neu in 1.16.10: Paladinfenster im Kampf öffnen.** Das Zahnrad an der Paladinleiste schaltet die Zuweisungsansicht auch im Kampf um. „Optionen“ öffnet/schließt die Detailansicht; X und Escape schließen weiter. Die Fenster werden vorab vorbereitet, Buffziele und Zuweisungen bleiben im Kampf geschützt. Nach Installation außerhalb des Kampfes `/reload` eingeben.

**Neu in 1.16.9: Weniger Hintergrundarbeit.** Alle 21 ForeverTools-Module auf weitere Verbesserungen geprüft. Questmarkierungen prüfen alle 0,5 Sekunden; neue Plaketten und Questereignisse reagieren sofort. Die schnellen Threat-Plates-Updates bleiben erhalten. Bankaufnahme, Material-Tooltips, Berufsscans, Auktionsscans und Karten vermeiden doppelte Arbeit. Nach dem Update `/reload` eingeben. Einzelheiten: [Verbesserungen-2026-11-09.md](Verbesserungen-2026-11-09.md).

**Bank unterwegs:** Ein **Bank**-Button im kombinierten Blizzard-Rucksack öffnet den gespeicherten Bankinhalt mit Symbolen, Stapelmengen und Suche. Nach `/reload` einmal die Bank besuchen, danach ist die Ansicht auch unterwegs über den Button oder `/ftbank` verfügbar. Der letzte Stand wird pro Charakter gespeichert.

**Berufsplaner:** `/ftberufe` zeigt Herstellungsmengen aus Taschen und gespeicherter Bank, fehlende Rezepte mit Quelle sowie einen Skillvorschlag. Zum Start Bank und jeden Herstellberuf öffnen, dann „Neu scannen“. Maus über einem Rezept zeigt Materialien und Fehlmengen. Im Skillplan werden gemeinsame Materialien verrechnet; „bestenfalls“ ist wegen zufälliger Skillpunkte keine Garantie. Bedienung und Grenzen stehen in `ForeverTools/README.md`.

**Neu in 1.16.8: Attune aktualisiert.** Die integrierte Forever-Version steigt von 16001-34 auf 16001-38: Charakterfortschritt, „Attune: Next“, ausblendbare Ketten und ergänzte RoL-Voraussetzungen. Der neue Fenster- und Ereignisablauf wird beim Modulwechsel berücksichtigt. Nach dem Update `/reload` eingeben.

**Neu in 1.16.7: Update-Helfer repariert.** Die Dateiprüfung berücksichtigt nun alle enthaltenen Addondateien, einschließlich BigWigs-Schriften und `!Options.lua`. Betroffene alte Helfer müssen einmalig ersetzt und neu gestartet werden; anschließend kann wieder der Ingame-Update-Button verwendet werden. Der vollständige echte Release-Katalog wird jetzt zusätzlich im PowerShell-Test installiert und geprüft.

**Neu in 1.16.6: Threat-Plates-Kampffehler korrigiert.** Die Lebensfüllung verwendet einen eigenen Anzeigebalken. Dadurch werden die Blizzard-TextStatusBar-Aufrufe vermieden, die in Version 1.16.5 beim Kampf Fehler mit geschützten Zahlen auslösen konnten. Nach dem Update `/reload` eingeben. Prüfung: 336 automatisierte Tests einschließlich des nachgestellten Fehlerpfads; die Bestätigung im betroffenen Spielclient steht noch aus.

**Neu in 1.16.5: Lebensbalken und Journal-Button.** Threat Plates synchronisiert Lebenswert und Maximum zusätzlich direkt mit dem nativen Balken, damit ungefüllte NPC- und Spielerbalken aktualisiert werden. Das Schmiede-Symbol sitzt weiter links; der vorhandene DungeonJournal-Button wird nach dem Laden über der Minimap gehalten. Nach dem Update `/reload` eingeben. Prüfung: 335 automatisierte Tests bestanden; die Anzeige beim betroffenen Freund muss im Spiel bestätigt werden.

**Neu in 1.16.2: Erfahrungsleiste und korrigierter Addonstart.** Im Schmiede-Schnellmenü auf **Erfahrungsleiste** klicken oder `/ftxp show` eingeben. Enthalten sind XP, Erholung, fertige Quest-XP, XP/h, Levelprognose und Spielzeiten. Einstellungen unter `/ad → Erfahrungsleiste`. Eine aktive EasyExperienceBar-Einzelversion wird nach Übernahme der Anzeigeeinstellungen für den Charakter deaktiviert; nach dem Hinweis nochmals `/reload` eingeben. Danach kann der Originalordner entfernt werden.

Nicht unterstützte klassische Auktionsereignisse stoppen den Addonstart nicht mehr. Modulhäkchen, nachfolgende Module und Schmiede-Symbol werden wieder eingerichtet. Ein einzelner Modulfehler blockiert die übrigen Module nicht mehr. Die klassische Auktionssuche bleibt auf Clients ohne passende API nicht verfügbar. Prüfung: 331 Tests; die Startkorrektur wurde zusätzlich im Spiel bestätigt.

**Neu in 1.15.0: BigWigs und Nova Instance Tracker sind vollständig eingebaut.** Öffnen über das Schmiede-Schnellmenü oder `/ad → BigWigs / Nova Instance Tracker → Optionen`. Direktbefehle: `/ftbw` für BigWigs-Einstellungen, `/ftnit` für den Instanzverlauf und `/ftnit options` für Nova-Einstellungen. Auch `/bw` und `/nit` bleiben nach der Umstellung verfügbar. Die beiden Modulschalter werden mit `/reload` übernommen.

Beim ersten Laden werden Einstellungen und Verlauf aus aktiven Einzelversionen kopiert. Die alten Addons werden für den aktuellen Charakter deaktiviert; nach dem Hinweis **nochmals `/reload`** eingeben. Ihre Ordner und Originaldaten bleiben als Sicherung erhalten. Alle Laufzeitdateien und Medien liegen in ForeverTools. BigWigs übernimmt den vorhandenen Umfang von v427.8 einschließlich der installierten Bossmodule; ein Classic-/Forever-Bosspaket war bisher nicht installiert und wird dadurch nicht ergänzt. Nova 2.31 behält seine Forever-Erkennung und Instanzlimits. Darstellung und Bosswarnungen im Spiel müssen noch geprüft werden.

**Neu in 1.14.1: Schnellmenü am Schmiede-Symbol.** Linksklick auf den ForeverTools-Minimapbutton öffnet **Attune** und **Disenchantry**. Dort öffnet Linksklick die Funktion, Rechtsklick deren Einstellungen. **Module verwalten**, Rechtsklick auf das Schmiede-Symbol oder `/ad` öffnet die bisherige Modulübersicht. Abgeschaltete Module sind im Schnellmenü ausgegraut. Escape schließt das Schnellmenü. MinimapButtonButton wird dafür nicht benötigt. Nach dem Update `/reload` eingeben.

**Neu in 1.14.0: Attune ist eigenständig integriert.** `/ftattune` oder `/ad → Attune: Freischaltungen und Questketten → Optionen` öffnet Freischaltungen, Dungeon- und Klassenquests mit Fortschritt, Karten und Belohnungen. Das separate Attune ist nicht erforderlich. Eine aktive Einzelversion wird nach einmaliger Datenübernahme für den aktuellen Charakter deaktiviert; nach dem Hinweis nochmals `/reload` eingeben. Details und Rechtehinweise: [Attune-Analyse.md](Attune-Analyse.md).

**Neu in 1.13.0:** Die Lernübersicht ist aus dem Zauber-/Berufsbuch erreichbar, berücksichtigt Rufpreise und setzt Lehrer-Kartenpunkte. Grimoires werden pro Begleiterfamilie erkannt. Disenchantry erhält ein eigenes, optionales Minimapsymbol: `/ad → Entzaubern: Disenchantry → Optionen → Eigenes Disenchantry-Minimapsymbol anzeigen`. Nach dem Update `/reload` eingeben.

**Neu in 1.12.0: Disenchantry ist integriert.** Öffnen über `/ad → Entzaubern: Disenchantry → Optionen` oder `/ftde`. Enthalten sind Gegenstandsauswahl, Schutzfilter, Sperrlisten, Materialprognosen, Hauptfenster, Kompaktleiste, Tastenkürzel und Statistik. Preise kommen zuerst aus unserem Auktionsscan; ein separates Disenchantry oder Auctionator wird nicht benötigt. Nach dem Update `/reload` eingeben. Eine aktive alte Disenchantry-Einzelversion wird nach Übernahme ihrer Einstellungen für den aktuellen Charakter deaktiviert; nach dem entsprechenden Hinweis nochmals `/reload` eingeben.

**Neu in 1.11.0: „Was kann ich lernen?“** Die Lernübersicht nach dem Vorbild von What's Training ist direkt integriert: `/ad → Was kann ich lernen? → Optionen → Lernübersicht öffnen` oder `/ftlernen`. Vier Ansichten zeigen Klassenzauber, Waffenmeister, Begleiter und Berufsrezepte. Dazu kommen nächste Ränge, Voraussetzungen, Grundpreise, Suche, Ausblenden per Umschalt-Klick und Hinweise bei Stufenaufstieg. Ein separates What's Training ist nicht nötig. Nach dem Update `/reload` eingeben.

**Neu in 1.10.0: Auktionshaus erweitert – ohne separates Auctionator.** Unter `/ad → Auktionshaus → Optionen` stehen jetzt **Kaufen**, **Verkaufen**, **Eigene Auktionen**, **Einkaufslisten** und **Verlauf** bereit. Käufe und Abbrüche laden das Angebot erneut und verlangen eine Bestätigung. Verkaufsansicht mit Stückpreis, Stapelgröße, Stapelanzahl, Konkurrenzvergleich und Mehrfach-Einstellen. Eigene Auktionen lassen sich über alle Seiten auf Unterbietungen prüfen. Dazu kommen benannte Listen, Suchfilter, Text-Import/Export, Such- und Preisverlauf sowie Materialkosten und Gewinnschätzung für das ausgewählte Berufsrezept. Nach dem Update `/reload` eingeben.

**Neu in 1.9.0: Eigenes Auktionshaus-Modul ohne Auctionator.** Unter `/ad → Auktionshaus → Optionen` das Fenster öffnen oder beim Auktionator auf **FT Auktionshaus** klicken. Vollscan starten, danach Stückpreis und Verkaufsvorschlag im Gegenstands-Tooltip lesen. Namen eingeben, zur Einkaufsliste hinzufügen und per Klick suchen. Kaufen und Einstellen erfolgen über das normale Spielfenster. Nach dem Update `/reload` eingeben. Das alte Auctionator ist nicht erforderlich und kann in der Addon-Auswahl deaktiviert werden.

Für **WoW Forever 1.60.1.70425 / Interface 16001**. Alle Funktionen liegen im einzigen Addon-Ordner **ForeverTools**: Händler & Taschen, Quests, Materialien, Paladin, GTFO, Threat Plates, Decursive, **Anti Fett Finger**, **Auto Rank** und **Karten**. Jedes Modul ist in der gemeinsamen Übersicht einzeln schaltbar.

**[HTML-Anleitung herunterladen](https://github.com/BP1904/ForeverTools/releases/latest/download/Anleitung.html)** – im Browser öffnen oder direkt an Freunde weitergeben. Die Quelldatei liegt unter [Anleitung.html](Anleitung.html).

## Für Freunde: einmal einrichten

1. **[ForeverTools.zip herunterladen](https://github.com/BP1904/ForeverTools/releases/latest/download/ForeverTools.zip)** und öffnen.
2. Den darin enthaltenen Ordner **ForeverTools** nach **`Interface\AddOns`** ziehen.
3. WoW vollständig neu starten und **ForeverTools** aktivieren. Fertig.

Die Datei liegt danach direkt unter `Interface\AddOns\ForeverTools\ForeverTools.toc`. Das fertige Paket enthält keinen zusätzlichen `ForeverTools-main`-Ordner. Menü: **`/ad`**, **`/forevertools`** oder das Schmiede-Symbol an der Minimap. Separate Installationen von Anti Fett Finger und Auto Rank sind nicht erforderlich.

## Ein Update aktualisiert alles

**Neu in 1.8.4:** Menethil und alle anderen Flugpunkte werden für beide Fraktionen angezeigt. Die Karte lässt sich durch Ziehen an der oberen Titelleiste verschieben; die Position wird gespeichert. Nach dem Update **`/reload`** eingeben.

**Seit 1.8.3:** Flugpunkte erscheinen nur auf einzelnen Gebietskarten. Horde-Flugpunkte sind rot, Allianz-Flugpunkte blau. Nach dem Update **`/reload`** eingeben.

**Seit 1.8.2:** Gebietsstufen erscheinen nur beim Darüberfahren direkt neben dem Gebietsnamen oben. Flugpunkte verwenden jetzt die native Kartenverwaltung und zusätzlich die aktuellen Clientdaten. Nach dem Update **`/reload`** eingeben.

**Seit 1.8.1:** Ein Fehler beim ersten Laden der Karte ist behoben. Flugpunkte und Gebietsstufen aktualisieren sich unabhängig von der Kartenaufdeckung. Auf der Kontinentkarte erscheinen jetzt ebenfalls Flugpunkte sowie die Stufen der einzelnen Gebiete. Nach dem Update **`/reload`** eingeben.

**Seit 1.8.0:** Kartenfunktionen im Leatrix-Stil sind integriert: **`/ad → Karten: Leatrix-Stil → Optionen`**. Unerforschte Bereiche werden blau aufgedeckt; Instanzen, Flugpunkte und Reiseorte erhalten Symbole. Dazu kommen Koordinaten und Gebietsstufen. Karte an der **oberen Titelleiste** verschieben; Größe und Position über die Aktionen ändern bzw. zurücksetzen. Eine aktive Leatrix-Maps-Einzelversion hat Vorrang. Nach dem Update genügt **`/reload`**.

**Seit 1.7.4:** Der Update-Helfer wird nicht mehr durch unbestätigte Windows-Meldungen angehalten. `Update.cmd` prüft den tatsächlichen Start, erkennt bereits laufende ältere Helfer und zeigt Startfehler an. Protokolle liegen lokal unter `%LOCALAPPDATA%\ForeverTools` im Unterordner des Spielclients.

**Seit 1.7.3:** Das Funkeln der Quest-Gegner wurde entfernt. Ausrufezeichen, Fortschrittszähler und das Funkeln der Sammelobjekte bleiben erhalten.

**Seit 1.7.2:** Update-Aufträge bleiben beim verspäteten Start oder Neustart des Windows-Helfers erhalten. Im Spiel erscheint ein Hinweis auf die Windows-Fertigmeldung und den zweiten `/reload`.

**Seit 1.7.0:** Quest-Gegner erhalten ein gelbes Questzeichen mit kompaktem Fortschritt wie **2/7** über dem Namen. Quest-Sammelobjekte können funkeln und zeigen den Zähler beim Darüberfahren im Tooltip. Einstellungen: **`/ad → Quest-Gegner → Optionen`**. Die Funkeloption passt Umrandungen und bei Bedarf die Partikeldichte an; vorherige Werte werden beim Abschalten wiederhergestellt. Nach dem ersten Update einmal WoW vollständig neu starten.

**Jägermunition:** Unter `/ad → Händler & Taschen → Optionen` ist „Jäger: Köcher / Munitionsbeutel auffüllen“ standardmäßig aktiv. Beim Öffnen eines passenden Händlers kauft das Addon die beste Munition für eure Stufe und angelegte Fernkampfwaffe: Pfeile für Bogen/Armbrust, Kugeln für Schusswaffen. Es füllt nur den verfügbaren Platz im passenden Köcher/Munitionsbeutel und berücksichtigt Gold und Händlervorrat. Ohne passenden Beutel wird nichts gekauft. **Umschalt beim Öffnen des Händlers gedrückt halten**, um den Munitionskauf einmal auszusetzen.

**Einmal nach der Installation `Update.cmd` im ForeverTools-Ordner doppelklicken.** Dadurch wird der Helfer gestartet und für die automatische Ausführung bei eurer Windows-Anmeldung eingerichtet. Das muss nach einem Neustart nicht wiederholt werden. Er läuft unsichtbar im Hintergrund; sein Symbol findet ihr neben der Windows-Uhr. Keine Ordnerauswahl und kein offenes Helferfenster nötig.

Danach im Spiel einfach **`/ad → Update`** drücken – ohne zusätzlichen Bestätigungsdialog. Der Button speichert den Update-Auftrag und lädt die Oberfläche neu. Der Hintergrundhelfer lädt alle Module gemeinsam. Sobald Windows **„Update fertig“** meldet, im Spiel **`/reload`** eingeben. Dieser zweite Reload bleibt notwendig, damit WoW die heruntergeladenen Dateien einliest. WoW selbst darf keine Dateien herunterladen oder Windows-Programme starten. Die Menü-Fußzeile zeigt den zuletzt geprüften GitHub-Stand.

Windows PowerShell 5.1 und Internetzugriff auf GitHub reichen aus; kein Python, Git oder GitHub-Account nötig. Erfolg oder Fehler erscheinen als Windows-Hinweis neben der Uhr und im lokalen Protokoll. Die Hinweise müssen nicht bestätigt werden. Falls Windows die Hinweise unterdrückt, lässt sich der Stand nach `/reload` im Addon-Menü prüfen. Rechtsklick auf das ForeverTools-Symbol neben der Windows-Uhr bietet **„Autostart ausschalten und beenden“**. Es wird ausschließlich eine Verknüpfung im Autostartordner des aktuellen Windows-Benutzers angelegt. Ohne offenen Update-Auftrag wird nichts heruntergeladen. Erledigte Aufträge merkt sich der Helfer lokal unter `%LOCALAPPDATA%\ForeverTools`; beim Neustart holt er offene Aufträge nach. Die bisherige `ForeverTools-Updater.cmd` im Quellcode-Download kann die Einrichtung ebenfalls vornehmen.

**Falls der alte Updater festhängt:** Das aktuelle ZIP über den installierten ForeverTools-Ordner kopieren. Eine noch offene Windows-Meldung des alten Helfers bestätigen und ihn über sein Symbol neben der Windows-Uhr mit **„Update-Helfer beenden“** schließen (alternativ Windows neu starten) und **`Update.cmd`** im installierten Ordner starten. Danach im Spiel Update anklicken, die Windows-Fertigmeldung abwarten und `/reload` eingeben.

## Übergang von den alten Einzeladdons

Bei bereits aktivierten Einzelversionen übernimmt ForeverTools beim nächsten Laden ihre Einstellungen für den aktuellen Charakter, einschließlich Schalter, Buttonposition und Auto-Rank-Verlauf. In dieser Sitzung wird die bereits geladene Funktion weiterverwendet, damit keine doppelten Tastensperren oder Leistenänderungen entstehen. Die jeweilige alte Einzelversion wird für diesen Charakter deaktiviert; ab dem folgenden `/reload` verwendet ForeverTools seine eingebauten Funktionen. Andere Charaktere werden bei ihrem nächsten Login einzeln umgestellt.

Die ursprünglichen Ordner und SavedVariables werden dabei nicht gelöscht. Bereits manuell deaktivierte Einzelversionen werden nicht geladen und können ihre alten Einstellungen nicht automatisch übergeben. Für deren Übernahme einmal die betreffende Einzelversion zusammen mit ForeverTools aktivieren und neu laden. Nur **ForeverTools** muss danach aktiv bleiben.

Wer eine ältere Version installiert hat, erhält `Update.cmd` auch über den bisherigen Updater oder durch Überkopieren des fertigen ZIP-Pakets.

## Für die Entwicklung

Alle neuen Funktionen als Module unter `ForeverTools/Modules` bzw. als interne Komponenten unter `ForeverTools/Features` ergänzen und in beiden TOC-Dateien eintragen. Menüeinträge über `FT:RegisterModule` registrieren. `addons.json` enthält dauerhaft nur **ForeverTools**. `python tools/build_catalog.py` erstellt dessen vollständige Dateiliste mit SHA-256-Prüfsummen. Separate Addon-Ordner werden vom Katalogbau und aktuellen Updater abgelehnt.

Vor jedem Push nach `main`: Tests ausführen und mit `python tools/build_release.py` Katalog und fertiges Paket bauen. Das ZIP unter `.tools/releases/ForeverTools.zip` als Release-Datei **ForeverTools.zip** veröffentlichen. Für Freunde ausschließlich den oben verlinkten fertigen Download teilen, nicht GitHubs automatisch erzeugten Quellcode-Download.

`main` ist der gemeinsame Update-Kanal. Der Updater lädt einen festen Commit, prüft alle Dateien vor dem Kopieren und sichert überschriebene Dateien für die Wiederherstellung bei Kopierfehlern. Der interne Helfer wird mitkopiert und beim nächsten manuellen Start verwendet. Heruntergeladene Programme werden während des Updates nicht gestartet. Andere Addons und Spieleinstellungen bleiben erhalten; eigene Änderungen innerhalb von ForeverTools können überschrieben werden. Veraltete Dateien werden nicht automatisch gelöscht.

Der lokale Ordner `AddOns` mit fremden Referenzaddons, alte lokale Einzelversionen, ZIP-Dateien und `.tools` werden nicht veröffentlicht. Einstellungen oder Kontodaten werden nicht zu GitHub hochgeladen.

Tests: `python -m unittest discover -s tests` (Lupa mit Lua 5.1 in `.tools`). Updater-Tests: `powershell -NoProfile -ExecutionPolicy Bypass -File tests/test_updater.ps1`.
