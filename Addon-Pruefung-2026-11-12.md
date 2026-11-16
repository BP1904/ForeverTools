# Addonprüfung vom 12. November 2026

Ziel: WoW Forever 1.60.1, Interface 16001. ForeverTools wurde auf 1.16.13 aktualisiert.

## Installierte Einzeladdons

| Addon | Vorher | Geprüftes Update |
|---|---|---|
| [Questie](https://www.curseforge.com/wow/addons/questie/files/9563148) | 12.6.5 | 12.7.0 |
| [QuestieDB](https://github.com/Questie/Questie/releases/tag/bundle/v12.7.0%2Bv1.0.14) | 1.0.13 | 1.0.14 |
| [QuestieTrace](https://github.com/Questie/QuestieTrace/releases/tag/v1.10.0) | 1.9.2 | 1.10.0 |
| [RestedXP](https://www.curseforge.com/wow/addons/restedxp-guide/files/9566650) | 4.11.35 | 4.11.36 |
| [DungeonJournal](https://www.curseforge.com/wow/addons/dungeonjournal/files/9567829) | 2.0 | 2.0.3 |
| Anti Fett Finger / Auto Rank | 1.0.0 | Lokale Fassungen bereits identisch mit der Spielinstallation; Verhaltenstests bestanden. |

Questie und RestedXP enthielten gegenüber den bisherigen Originalpaketen keine lokalen Dateiänderungen. Zusätzliche vorhandene Dateien bleiben bei der Installation erhalten.

## In ForeverTools integrierte Addons und Vorlagen

| Bestandteil | Ergebnis |
|---|---|
| [Attune](https://www.curseforge.com/wow/addons/attune/files/9551043) | 16001-39 → 16001-40; Klassenquestketten und Volksfilter. Eigene Suche, Navigation und Modulsteuerung erhalten. |
| [BigWigs](https://www.curseforge.com/wow/addons/bigwigs/files/9516569) | v427.8 → v427.9; Forever-Korrekturen für Einheitennamen und Balkencallbacks, aktualisierte Bibliotheken. Private Laufzeit und gespeicherte Einstellungen erhalten. |
| [Nova Instance Tracker](https://www.curseforge.com/wow/addons/nova-instance-tracker/files/9387708) | 2.31 → 2.32; RPPvP-Erkennung. Forever-Limits und eigene Datenbankanbindung erhalten. |
| [Disenchantry](https://www.curseforge.com/wow/addons/disenchantry/files/9570581) | 1.1.2 → 1.2.4; Gegenstandsausschlüsse, Prognosen, Preise und Statistik aktualisiert. Eigene Kompaktleiste, sichere Schließfunktion, Kampf-/Ziehschutz und ForeverTools-Preise erhalten. Neue Auktionsfunktionen beachten den Modulschalter. |
| [What's Training?](https://www.curseforge.com/wow/addons/whats-training/files/9552818) | Daten 11.0.0-beta25 → 11.4.3; aktualisierte Klassenpreise und Forever-Berufsrezepte. Import berücksichtigt den neuen Camelot-Rezeptordner. Eigene Lernübersicht bleibt bestehen. |
| [Leatrix Maps](https://www.curseforge.com/wow/addons/leatrix-maps/files/9571295) | Verwendete Karten-/Ortsdaten 1.60.24 → 1.60.31; 218 statt 214 Orte. Eigene Kartenlaufzeit bleibt bestehen; neue Leatrix-Oberflächen und Dungeon-Grafiken wurden nicht übernommen. |
| [GTFO](https://www.curseforge.com/wow/addons/gtfo/files/9468096) | 6.12.3 geprüft. Beide verwendeten Classic-Regeldateien stimmen mit der bisherigen Vorlage überein; keine Änderung erforderlich. Eigener Forever-Warnweg getestet. |
| [Decursive](https://www.curseforge.com/wow/addons/decursive/files/9432475) | RC4 geprüft; TOC und seltene Fehlerkorrektur des Originaladdons betreffen keine übernommenen Dateien. Eigenständiger Reinigungskern getestet. |
| [Threat Plates](https://www.curseforge.com/wow/addons/tidy-plates-threat-plates/files/9526802) | 13.3.8 geprüft. Änderungen an Original-Widgets und deren CVar-Einstellungen betreffen den eigenen Namensplakettenkern nicht. Verhaltenstests bestanden. |
| [PallyPower](https://www.curseforge.com/wow/addons/pally-power/files/9495367) | 1.6.5 geprüft. Eigene Paladinimplementierung einschließlich Buffanzeige und Kampfbedienung getestet. Kein Austausch durch das Originaladdon. |
| [Auctionator](https://www.curseforge.com/wow/addons/auctionator) | Version 345 geprüft. Das Auktionshaus ist eine eigenständige ForeverTools-Implementierung; Scan, Handel und Preisweitergabe getestet. |
| [EasyExperienceBar](https://www.curseforge.com/wow/addons/easy-experience-bar/files/9527415) | 2026.11.09.A geprüft. Eigene Erfahrungsleiste verwendet TIME_PLAYED_MSG und laufende Zeitfortschreibung; vorhandene Reload-/Spielzeittests bestanden. |
| [MinimapButtonButton](https://www.curseforge.com/wow/addons/minimapbuttonbutton) | 1.24.17 geprüft. Kein eingebetteter Fremdcode; eigenes Schnellmenü und Minimapsymbol getestet. |

Weitere eigene Module: Händler/Taschen, Quests, Questmarkierungen, Materialien, Bankansicht, Buffprüfung und Berufsplaner wurden mit ihren bestehenden Tests geprüft. Damit deckt die Prüfung alle 21 registrierten ForeverTools-Module ab. Historische Originalordner unter `E:\Addons\AddOns` dienen als Referenz und werden nicht als zusätzliche Addons ins Spiel installiert.

## Prüfung und Installation

- 435 automatisierte Verhaltenstests bestanden, einschließlich kompletter Modulregistrierung, Daten, Migration, Kampfverhalten, Preise und Modulabschaltung.
- 2.066 Lua-Dateien syntaktisch geprüft; 1.281 referenzierte Dateien geprüft. Die aktualisierten Einzeladdons enthalten passende Interface-16001-TOCs.
- PowerShell-Updatertests bestanden, einschließlich Offline-Installation des vollständigen Katalogs mit 865 Dateien. Der erste Versuch scheiterte am langen Sandbox-Temp-Pfad; mit kurzem Testpfad erfolgreich wiederholt.
- Installierbares ForeverTools-ZIP und SHA-256-Katalog neu gebaut. Downloadprüfsummen und Prüfdetails liegen unter `.tools/addon-updates-2026-11-12`.
- Installation kopiert ausschließlich ForeverTools und die fünf aktualisierten Einzeladdonordner. Vorherige Dateien werden unter `.tools/deployment-backups` gesichert. Keine Löschung fremder Addons, Einstellungen oder zusätzlicher Guide-Dateien.

Nach der Installation außerhalb des Kampfes `/reload` eingeben. Alle Ordner waren bereits vorhanden. Ein Spieltest nach dem Reload steht noch aus; insbesondere echte Klickzauber, Bosswarnungen und das neue Auktionsfenster lassen sich außerhalb des laufenden Clients nicht abschließend bestätigen.
