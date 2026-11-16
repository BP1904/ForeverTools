# ForeverTools 1.16.15 – Prüfung vor der Veröffentlichung

Zielclient: WoW Forever 1.60.1.70425, Interface 16001.

## Ergebnis

Alle 436 automatisierten Verhaltenstests bestanden. Die Tests prüfen die Registrierung und Initialisierung aller 21 Module sowie unter anderem Modulschalter, Einstellungsübernahme, Kampfverhalten, Paladinbedienung, Namensplaketten, Questmarkierungen, Karten, Bank, Berufsplaner, Lernübersicht, Auktionen, Attune, Disenchantry, BigWigs und Nova.

Syntax und Dateiverweise der vorbereiteten Addons wurden geprüft. Das ForeverTools-Paket enthält genau die 865 im SHA-256-Katalog aufgeführten Dateien, einschließlich des Windows-Updatehelfers. ZIP und Katalog werden vor der Veröffentlichung neu gebaut. `git diff --check` meldet keine Fehler.

## Updatefunktion

- Ingame-Auftrag, Kampfsperre, Reload und Erkennung der Installationsrückmeldung durch Lua-Verhaltenstests geprüft.
- PowerShell-Tests für Download, Installation, Sicherung, Prüfsummenfehler, sichere Dateipfade und Erhalt anderer Addons bestanden.
- Aufträge vor Helferstart, Neustart, erneuter Versuch nach Fehlern und mehrere Updates ohne Bestätigung einer Windows-Meldung geprüft.
- Vollständiger aktueller Releasekatalog mit 865 Dateien erfolgreich im Testclient installiert und geprüft.
- Zusätzlich den unveränderten echten Updater gegen GitHub ausgeführt: Download des bisherigen main-Commits `d17d1b4c370c54c0b01a127254abaaac6f0285e0`, Katalogprüfung, Installation und Rückmeldung des Auftrags `161115` erfolgreich. Alle installierten Katalogdateien per SHA-256 geprüft; `UpdateStatus.lua` separat auf Commit und Auftrag geprüft, weil der Updater diese Datei absichtlich neu schreibt.

Nach dem Hochladen wird derselbe Netzwerktest für den neuen main-Commit wiederholt und das veröffentlichte ZIP erneut heruntergeladen und verglichen. Protokolle liegen lokal unter `.tools/release-1.16.15-check`.

## Grenzen

Automatisierte Tests verwenden nachgebildete Spiel-APIs. Echte Bossbegegnungen, geschützte Klickzauber und die Darstellung im laufenden WoW-Client wurden in dieser Prüfung nicht manuell getestet. Der echte Downloadtest läuft in einem getrennten Testordner und verändert keine Spieleinstellungen.

Änderungen und Quellen der integrierten Addons: [Addonprüfung vom 16. November](Addon-Pruefung-2026-11-16.md), [14. November](Addon-Pruefung-2026-11-14.md) und [12. November](Addon-Pruefung-2026-11-12.md).
