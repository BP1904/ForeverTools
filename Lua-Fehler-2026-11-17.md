# Lua-Fehler vom 16. November 2026

Behoben und als ForeverTools 1.16.16 direkt im Spielordner installiert.

## Ursache

`E:\World of Warcraft\_forever_\Logs\General.log` enthält 4.847 Lua-Fehler, ausschließlich aus dem integrierten BigWigs-Plug-in `BigWigs_Plugins/Nameplates.lua`:

- Zeile 2084: 2.041 Fehler beim Hinzufügen einer Namensplakette.
- Zeile 2103: 2.028 Fehler beim Entfernen einer Namensplakette.
- Zeile 2127: 778 Fehler beim Zielwechsel.

Meldung: `attempted to index a table that cannot be indexed with secret keys`.
Der Client liefert im Kampf geschützte GUIDs; diese wurden als Tabellenschlüssel verwendet.

Das Namensplaketten-Plug-in verwirft geschützte GUIDs jetzt vor Tabellenzugriffen, Zielvergleichen und dem Speichern des vorherigen Ziels. Auch Start-/Stoppnachrichten werden geprüft. Beim Wechsel zu einem geschützten Ziel wird die Darstellung des bisherigen öffentlichen Ziels weiterhin zurückgesetzt. Andere BigWigs-Plug-ins bleiben unverändert.

## Updateprüfung

Alle integrierten Komponenten und verwendeten Addonvorlagen erneut über ihre offiziellen Dateiseiten geprüft. Der direkte CurseForge-Abruf wurde mit HTTP 403 abgewiesen; die Dateiseiten waren über die Webabfrage erreichbar.

- [Disenchantry 1.2.6](https://www.curseforge.com/wow/addons/disenchantry/files/9621564) integriert. Original 1.2.5/1.2.6 verglichen und beide Versionen mit demselben Importer erzeugt; lokale Abweichungen erhalten. Neu sind die Wertfarben im Tooltip und eine Prüfung auf fehlende Fensteranker.
- [PallyPower 1.6.10](https://www.curseforge.com/wow/addons/pally-power/files/9653626) geprüft. Unser Paladinmodul ist eine eigenständige Implementierung ohne eingebetteten PallyPower-Code. Das neue Originalpaket ersetzt daher keine Laufzeitdateien in ForeverTools. Dessen neue Originaloberfläche und Funktionen wurden nicht übernommen.
- Unverändert aktuell: Attune 16001-41, What's Training 11.4.8, BigWigs v427.9, Nova 2.32, Leatrix Maps 1.60.31, GTFO 6.12.3, Decursive 2.9.0-RC4-forever, Threat Plates 13.3.8 und EasyExperienceBar 2026.11.09.A. Auctionator 347 und MinimapButtonButton 1.24.18 wurden bereits am 16.11. auf Relevanz für unsere eigenen Module geprüft.
- Questie/QuestieDB und Spoken entsprechen weiterhin den neuesten GitHub-Releases. DungeonJournal 2.0.9 war bereits installiert und stimmt vollständig mit dem Originalpaket überein. RestedXP 4.11.36 ist aktuell.
- Einzelne Spoken-Audio-Dateiseiten waren nicht erreichbar; diese Zusatzpakete wurden nicht als erneut vollständig geprüft gewertet. Keine fremden Addons verändert.

## Prüfung und Installation

- 437 automatisierte Tests bestanden. Neuer Regressionstest für alle drei gemeldeten Ereignisse, Start-/Stoppnachrichten und das Zurücksetzen des vorherigen Ziels. Da Lua 5.1 keine geschützten Werte kennt, simuliert der Test verbotene Tabellenschlüssel mit einer überwachten Tabelle.
- Alle 445 Lua-Dateien kompilieren; 408 Dateiverweise und beide Interface-16001-TOCs geprüft.
- PowerShell-Updatertests bestanden, einschließlich vollständiger Installation des Katalogs mit 865 Dateien. Wegen des Windows-Pfadlimits musste dieser Test außerhalb des langen Sandbox-Temporärpfads laufen.
- Release-ZIP und Katalog neu gebaut; `git diff --check` bestanden.
- 865 Addondateien im echten Spielordner kopiert und per SHA-256 abgeglichen. Keine Dateien gelöscht und keine Spieleinstellungen geändert.
- Sicherung: `E:\Addons\.tools\deployment-backups\lua-fix-20261117-081438`.
- Technische Nachweise unter `.tools/addon-updates-2026-11-17`.

Jetzt außerhalb des Kampfes `/reload` eingeben. Die Bestätigung in einer echten Instanz steht noch aus.
