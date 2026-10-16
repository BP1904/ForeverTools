# ForeverTools – Addons für WoW Forever

Für **WoW Forever 1.60.1.70425 / Interface 16001**. Enthält ForeverTools mit der gemeinsamen Menüübersicht sowie Anti Fett Finger und Auto Rank.

## Für Freunde: einmal einrichten

1. [ZIP herunterladen](https://github.com/BP1904/ForeverTools/archive/refs/heads/main.zip), vollständig entpacken.
2. **ForeverTools-Updater.cmd** doppelklicken. Windows PowerShell 5.1 ist ausreichend; kein Python, Git oder GitHub-Account erforderlich. Der Updater braucht Internetzugriff auf GitHub.
3. Den tatsächlich verwendeten WoW-Clientordner auswählen, z.B. `World of Warcraft\_classic_beta_` mit `Wow.exe` und `Interface`. Der Pfad wird lokal gespeichert.
4. Auf die grüne **ERFOLG**-Meldung warten. Die drei Addons werden in `Interface\AddOns` installiert. WoW danach starten bzw. bei erstmals installierten Addons neu starten und diese in der Addon-Auswahl aktivieren.

Der Updater installiert ausschließlich die in `catalog.json` aufgeführten Addon-Dateien. Spielkonten, Einstellungen und andere Addons werden nicht hochgeladen oder gelöscht. Er schreibt nur in die aufgeführten Addon-Ordner; eigene Änderungen an deren Dateien können dabei überschrieben werden.

## Später im Spiel aktualisieren

Den Windows-Updater geöffnet lassen. **`/ad` → Update → Update anfordern** lädt die Oberfläche neu und speichert den Update-Wunsch. Der Windows-Updater liest nur diesen Zahlenwert aus den lokalen ForeverTools-Einstellungen, lädt die aktuelle veröffentlichte Version und meldet Erfolg oder Fehler in seinem Fenster. Danach **`/reload`** eingeben. Neue Addon-Ordner können einen vollständigen WoW-Neustart und die Aktivierung in der Addon-Auswahl benötigen. Neue Module im bereits vorhandenen ForeverTools-Ordner erscheinen nach `/reload`.

WoW kann selbst keine Dateien aus GitHub herunterladen oder Programme starten. Daher gehören der Windows-Helfer und die beiden Reload-Schritte zu diesem Ablauf. Ohne geöffneten Helfer bewirkt der Button keinen Download. Die Menü-Fußzeile zeigt den zuletzt vom Helfer geprüften GitHub-Stand, keine Live-Abfrage.

Beim Start prüft/installiert der Helfer einmal alle veröffentlichten Addons. Danach prüft er nur lokale Update-Wünsche; er lädt nicht regelmäßig selbstständig neue Versionen. Fehler im Fenster prüfen und anschließend erneut Update anfordern. Schließen des Fensters beendet den Helfer. Ein neuer Spielpfad lässt sich mit `powershell -NoProfile -ExecutionPolicy Bypass -File tools\Update-ForeverTools.ps1 -GamePath "D:\WoW\_classic_beta_" -Watch` setzen.

## Für die Entwicklung

Nur unsere Ordner `ForeverTools`, `AntiFettFinger` und `AutoRank` werden veröffentlicht/installiert. Der lokale Ordner `AddOns` mit fremden Referenzaddons, ZIP-Dateien und `.tools` gehört nicht ins Repository.

Neue eigene Addons in `addons.json` eintragen, Ordner hinzufügen und **`python tools/build_catalog.py`** ausführen. Dadurch entstehen Dateiliste mit SHA-256-Prüfsummen und der Ingame-Katalog. Neue separate Addons bekommen automatisch einen Menüeintrag; für eine eigene Optionsoberfläche kann ein ForeverTools-Modul registriert werden. Bereits integrierte Einträge werden nicht doppelt angezeigt. Neue ForeverTools-Module müssen weiterhin in beiden TOC-Dateien eingetragen sein.

Vor jedem Push nach `main`: Tests ausführen und Katalog neu bauen. `main` ist der Update-Kanal für Freunde: Jeder Push kann beim nächsten angeforderten Update installiert werden. Der Updater lädt einen festen Commit und prüft alle Dateien vor dem Kopieren. Er sichert überschriebene Dateien temporär und stellt sie bei Kopierfehlern wieder her. Veraltete Dateien werden nicht automatisch gelöscht. Der Helfer selbst wird aus Sicherheitsgründen nicht automatisch ersetzt; neue Helferversionen wieder als ZIP herunterladen.

Tests: `python -m unittest discover -s tests` (Lupa mit Lua 5.1 in `.tools`). Updater-Tests: `powershell -NoProfile -ExecutionPolicy Bypass -File tests/test_updater.ps1`.
