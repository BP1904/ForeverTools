# ForeverTools – ein Addon für alle unsere Funktionen

Für **WoW Forever 1.60.1.70425 / Interface 16001**. Alle Funktionen liegen im einzigen Addon-Ordner **ForeverTools**: Händler & Taschen, Quests, Materialien, Paladin, GTFO, Threat Plates, Decursive, **Anti Fett Finger** und **Auto Rank**. Jedes Modul ist in der gemeinsamen Übersicht einzeln schaltbar.

**[HTML-Anleitung herunterladen](https://github.com/BP1904/ForeverTools/releases/download/v1.4.0/Anleitung.html)** – im Browser öffnen oder direkt an Freunde weitergeben. Die Quelldatei liegt unter [Anleitung.html](Anleitung.html).

## Für Freunde: einmal einrichten

1. **[ForeverTools.zip herunterladen](https://github.com/BP1904/ForeverTools/releases/latest/download/ForeverTools.zip)** und öffnen.
2. Den darin enthaltenen Ordner **ForeverTools** nach **`Interface\AddOns`** ziehen.
3. WoW vollständig neu starten und **ForeverTools** aktivieren. Fertig.

Die Datei liegt danach direkt unter `Interface\AddOns\ForeverTools\ForeverTools.toc`. Das fertige Paket enthält keinen zusätzlichen `ForeverTools-main`-Ordner. Menü: **`/ad`**, **`/forevertools`** oder das Schmiede-Symbol an der Minimap. Separate Installationen von Anti Fett Finger und Auto Rank sind nicht erforderlich.

## Ein Update aktualisiert alles

Nach jedem Windows-Start einmal im installierten **ForeverTools**-Ordner **`Update.cmd` doppelklicken**. Der Helfer läuft danach unsichtbar im Hintergrund; ein Symbol neben der Windows-Uhr zeigt ihn an. Der Spielordner wird automatisch erkannt. Kein Fenster muss offen bleiben. Eine Verknüpfung zu `Update.cmd` auf dem Desktop ist möglich. Es wird kein Windows-Autostart eingerichtet.

Im Spiel **`/ad → Update → Jetzt aktualisieren`** drücken. Der Button speichert den Update-Auftrag und lädt die Oberfläche neu. Der Hintergrundhelfer erkennt den Auftrag und lädt alle Module gemeinsam. Sobald Windows **„Update fertig“** meldet, im Spiel **`/reload`** eingeben. Der Button fordert den Download tatsächlich an. Ohne gestarteten Helfer kann er keinen Download auslösen: WoW selbst darf keine Dateien aus GitHub herunterladen oder Windows-Programme starten. Die Menü-Fußzeile zeigt den zuletzt geprüften GitHub-Stand.

Windows PowerShell 5.1 und Internetzugriff auf GitHub reichen aus; kein Python, Git oder GitHub-Account nötig. Erfolg oder Fehler eines angeforderten Updates erscheinen als Windows-Meldung. Über Rechtsklick auf das ForeverTools-Symbol neben der Windows-Uhr lässt sich der Helfer beenden. Im Leerlauf werden keine Updates heruntergeladen. Die bisherige `ForeverTools-Updater.cmd` im Quellcode-Download startet ebenfalls den Hintergrundhelfer.

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
