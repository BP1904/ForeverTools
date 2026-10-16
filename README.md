# ForeverTools – ein Addon für alle unsere Funktionen

Für **WoW Forever 1.60.1.70425 / Interface 16001**. Alle Funktionen liegen im einzigen Addon-Ordner **ForeverTools**: Händler & Taschen, Quests, Materialien, Paladin, GTFO, Threat Plates, Decursive, **Anti Fett Finger** und **Auto Rank**. Jedes Modul ist in der gemeinsamen Übersicht einzeln schaltbar.

## Für Freunde: einmal einrichten

1. [ZIP herunterladen](https://github.com/BP1904/ForeverTools/archive/refs/heads/main.zip), vollständig entpacken.
2. **ForeverTools-Updater.cmd** doppelklicken. Windows PowerShell 5.1 ist ausreichend; kein Python, Git oder GitHub-Account erforderlich.
3. Den tatsächlich verwendeten WoW-Clientordner auswählen, z.B. `World of Warcraft\_classic_beta_` mit `Wow.exe` und `Interface`. Der Pfad wird lokal gespeichert.
4. Auf die grüne **ERFOLG**-Meldung warten. Installiert wird ausschließlich `Interface\AddOns\ForeverTools` mit sämtlichen Modulen. WoW starten bzw. bei der ersten Installation neu starten und **ForeverTools** aktivieren.

Alternativ lässt sich der Ordner `ForeverTools` manuell nach `Interface\AddOns` kopieren. Separate Installationen von Anti Fett Finger und Auto Rank sind nicht erforderlich. Menü: **`/ad`**, **`/forevertools`** oder das Schmiede-Symbol an der Minimap.

## Ein Update aktualisiert alles

Den Windows-Updater geöffnet lassen. **`/ad` → Update → Update anfordern** lädt die Oberfläche neu und speichert den Update-Wunsch. Der Helfer lädt das vollständige gemeinsame Addon einschließlich aller neuen und bestehenden Module. Auf seine Erfolgsmeldung warten, anschließend **`/reload`** eingeben. Neue Funktionen werden künftig im vorhandenen ForeverTools-Ordner veröffentlicht; weitere Addon-Ordner sind dafür nicht nötig.

WoW kann selbst keine Dateien aus GitHub herunterladen oder Programme starten. Deshalb gehören der Windows-Helfer und die beiden Reload-Schritte zum Ablauf. Ohne geöffneten Helfer erfolgt kein Download. Die Menü-Fußzeile zeigt den zuletzt vom Helfer geprüften GitHub-Stand, keine Live-Abfrage.

Beim Start aktualisiert der Helfer einmal das gesamte Addon. Danach lädt er nur auf lokale Update-Anforderung. Fehler im Fenster prüfen und Update erneut anfordern. Schließen des Fensters beendet den Helfer. Anderen Spielpfad setzen: `powershell -NoProfile -ExecutionPolicy Bypass -File tools\Update-ForeverTools.ps1 -GamePath "D:\WoW\_classic_beta_" -Watch`.

## Übergang von den alten Einzeladdons

Bei bereits aktivierten Einzelversionen übernimmt ForeverTools beim nächsten Laden ihre Einstellungen für den aktuellen Charakter, einschließlich Schalter, Buttonposition und Auto-Rank-Verlauf. In dieser Sitzung wird die bereits geladene Funktion weiterverwendet, damit keine doppelten Tastensperren oder Leistenänderungen entstehen. Die jeweilige alte Einzelversion wird für diesen Charakter deaktiviert; ab dem folgenden `/reload` verwendet ForeverTools seine eingebauten Funktionen. Andere Charaktere werden bei ihrem nächsten Login einzeln umgestellt.

Die ursprünglichen Ordner und SavedVariables werden dabei nicht gelöscht. Bereits manuell deaktivierte Einzelversionen werden nicht geladen und können ihre alten Einstellungen nicht automatisch übergeben. Für deren Übernahme einmal die betreffende Einzelversion zusammen mit ForeverTools aktivieren und neu laden. Nur **ForeverTools** muss danach aktiv bleiben.

Wer den bisherigen Updater bereits heruntergeladen hat, kann auch damit das gemeinsame Paket laden. Für die aktualisierte Anleitung und den auf ein Addon begrenzten Helfer einmal die neue ZIP herunterladen.

## Für die Entwicklung

Alle neuen Funktionen als Module unter `ForeverTools/Modules` bzw. als interne Komponenten unter `ForeverTools/Features` ergänzen und in beiden TOC-Dateien eintragen. Menüeinträge über `FT:RegisterModule` registrieren. `addons.json` enthält dauerhaft nur **ForeverTools**. `python tools/build_catalog.py` erstellt dessen vollständige Dateiliste mit SHA-256-Prüfsummen. Separate Addon-Ordner werden vom Katalogbau und aktuellen Updater abgelehnt.

Vor jedem Push nach `main`: Tests ausführen und Katalog neu bauen. `main` ist der gemeinsame Update-Kanal. Der Updater lädt einen festen Commit, prüft alle Dateien vor dem Kopieren und sichert überschriebene Dateien für die Wiederherstellung bei Kopierfehlern. Andere Addons und Spieleinstellungen bleiben erhalten; eigene Änderungen innerhalb von ForeverTools können überschrieben werden. Veraltete Dateien werden nicht automatisch gelöscht. Der Helfer selbst wird nicht automatisch ersetzt.

Der lokale Ordner `AddOns` mit fremden Referenzaddons, alte lokale Einzelversionen, ZIP-Dateien und `.tools` werden nicht veröffentlicht. Einstellungen oder Kontodaten werden nicht zu GitHub hochgeladen.

Tests: `python -m unittest discover -s tests` (Lupa mit Lua 5.1 in `.tools`). Updater-Tests: `powershell -NoProfile -ExecutionPolicy Bypass -File tests/test_updater.ps1`.
