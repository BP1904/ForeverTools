# ForeverTools – ein Addon für alle unsere Funktionen

Für **WoW Forever 1.60.1.70425 / Interface 16001**. Alle Funktionen liegen im einzigen Addon-Ordner **ForeverTools**: Händler & Taschen, Quests, Materialien, Paladin, GTFO, Threat Plates, Decursive, **Anti Fett Finger** und **Auto Rank**. Jedes Modul ist in der gemeinsamen Übersicht einzeln schaltbar.

**[HTML-Anleitung herunterladen](https://github.com/BP1904/ForeverTools/releases/latest/download/Anleitung.html)** – im Browser öffnen oder direkt an Freunde weitergeben. Die Quelldatei liegt unter [Anleitung.html](Anleitung.html).

## Für Freunde: einmal einrichten

1. **[ForeverTools.zip herunterladen](https://github.com/BP1904/ForeverTools/releases/latest/download/ForeverTools.zip)** und öffnen.
2. Den darin enthaltenen Ordner **ForeverTools** nach **`Interface\AddOns`** ziehen.
3. WoW vollständig neu starten und **ForeverTools** aktivieren. Fertig.

Die Datei liegt danach direkt unter `Interface\AddOns\ForeverTools\ForeverTools.toc`. Das fertige Paket enthält keinen zusätzlichen `ForeverTools-main`-Ordner. Menü: **`/ad`**, **`/forevertools`** oder das Schmiede-Symbol an der Minimap. Separate Installationen von Anti Fett Finger und Auto Rank sind nicht erforderlich.

## Ein Update aktualisiert alles

**Neu in 1.7.2:** Update-Aufträge bleiben beim verspäteten Start oder Neustart des Windows-Helfers erhalten. Im Spiel erscheint ein Hinweis auf die Windows-Fertigmeldung und den zweiten `/reload`.

**Seit 1.7.1:** Benötigte Quest-Gegner funkeln zusätzlich golden, auch im Kampf. Das Gegner-Funkeln lässt sich unabhängig vom Sammelobjekt-Funkeln abschalten.

**Seit 1.7.0:** Quest-Gegner erhalten ein gelbes Questzeichen mit kompaktem Fortschritt wie **2/7** über dem Namen. Quest-Sammelobjekte können funkeln und zeigen den Zähler beim Darüberfahren im Tooltip. Einstellungen: **`/ad → Quest-Gegner → Optionen`**. Die Funkeloption passt Umrandungen und bei Bedarf die Partikeldichte an; vorherige Werte werden beim Abschalten wiederhergestellt. Nach dem ersten Update einmal WoW vollständig neu starten.

**Jägermunition:** Unter `/ad → Händler & Taschen → Optionen` ist „Jäger: Köcher / Munitionsbeutel auffüllen“ standardmäßig aktiv. Beim Öffnen eines passenden Händlers kauft das Addon die beste Munition für eure Stufe und angelegte Fernkampfwaffe: Pfeile für Bogen/Armbrust, Kugeln für Schusswaffen. Es füllt nur den verfügbaren Platz im passenden Köcher/Munitionsbeutel und berücksichtigt Gold und Händlervorrat. Ohne passenden Beutel wird nichts gekauft. **Umschalt beim Öffnen des Händlers gedrückt halten**, um den Munitionskauf einmal auszusetzen.

**Einmal nach der Installation `Update.cmd` im ForeverTools-Ordner doppelklicken.** Dadurch wird der Helfer gestartet und für die automatische Ausführung bei eurer Windows-Anmeldung eingerichtet. Das muss nach einem Neustart nicht wiederholt werden. Er läuft unsichtbar im Hintergrund; sein Symbol findet ihr neben der Windows-Uhr. Keine Ordnerauswahl und kein offenes Helferfenster nötig.

Danach im Spiel einfach **`/ad → Update`** drücken – ohne zusätzlichen Bestätigungsdialog. Der Button speichert den Update-Auftrag und lädt die Oberfläche neu. Der Hintergrundhelfer lädt alle Module gemeinsam. Sobald Windows **„Update fertig“** meldet, im Spiel **`/reload`** eingeben. Dieser zweite Reload bleibt notwendig, damit WoW die heruntergeladenen Dateien einliest. WoW selbst darf keine Dateien herunterladen oder Windows-Programme starten. Die Menü-Fußzeile zeigt den zuletzt geprüften GitHub-Stand.

Windows PowerShell 5.1 und Internetzugriff auf GitHub reichen aus; kein Python, Git oder GitHub-Account nötig. Erfolg oder Fehler erscheinen als Windows-Meldung. Rechtsklick auf das ForeverTools-Symbol neben der Windows-Uhr bietet **„Autostart ausschalten und beenden“**. Es wird ausschließlich eine Verknüpfung im Autostartordner des aktuellen Windows-Benutzers angelegt. Ohne offenen Update-Auftrag wird nichts heruntergeladen. Erledigte Aufträge merkt sich der Helfer lokal unter `%LOCALAPPDATA%\ForeverTools`; beim Neustart holt er offene Aufträge nach. Die bisherige `ForeverTools-Updater.cmd` im Quellcode-Download kann die Einrichtung ebenfalls vornehmen.

**Falls der alte Updater festhängt:** Das aktuelle ZIP über den installierten ForeverTools-Ordner kopieren. Den bisherigen Helfer über sein Symbol neben der Windows-Uhr mit **„Update-Helfer beenden“** schließen und **`Update.cmd`** im installierten Ordner starten. Danach im Spiel Update anklicken, die Windows-Fertigmeldung abwarten und `/reload` eingeben.

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
