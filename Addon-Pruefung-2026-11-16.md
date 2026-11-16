# Addonprüfung vom 16. November 2026

Ziel: WoW Forever 1.60.1.70425 / Interface 16001. Alle 23 installierten Addonordner und alle integrierten Komponenten auf kompatible Updates geprüft.

## Aktualisiert und installiert

| Bestandteil | Bisher | Neu |
|---|---|---|
| ForeverTools | 1.16.14 | 1.16.15 |
| [What's Training? – integrierte Lerndaten](https://www.curseforge.com/wow/addons/whats-training/files/9621224) | 11.4.7 | 11.4.8 |
| [QuestieTrace](https://github.com/Questie/QuestieTrace/releases/tag/v1.12.0) | 1.11.0 | 1.12.0 |

Die Lerndaten ergänzen Talentvoraussetzungen für die höheren Aufschlitzen-Ränge des Druiden. Eigene Lernübersicht und Anpassungen für unterschiedliche Clientbuilds bleiben erhalten. Der Import wurde gegen die vorherige Originalversion abgeglichen; keine Mergekonflikte. QuestieTrace hatte gegenüber dem Original 1.11.0 keine lokalen Änderungen; das Update entfernt keine bisherigen Dateien.

## Bereits aktuell

| Installierte Addons | Stand |
|---|---|
| [Questie / QuestieDB](https://github.com/Questie/Questie/releases) | 12.9.0 / 1.1.1 |
| [RestedXP](https://www.curseforge.com/wow/addons/restedxp-guide/files/all) | 4.11.36 |
| [ForeverDungeonJournal](https://www.curseforge.com/wow/addons/dungeonjournal/files/all) | 2.0.8 bereits installiert |
| Anti Fett Finger / Auto Rank | Je 1.0.0; identisch mit lokaler Quelle |
| [Spoken mit Contributions, Bosses, Places, Quests und Readables](https://github.com/rusty-key/spoken-wow/releases/tag/spoken/v3.9.0) | 3.9.0 |
| [Spoken German Metapaket](https://www.curseforge.com/wow/addons/spoken-german) | 1.1.0 |
| [Bosses Deutsch](https://www.curseforge.com/wow/addons/spoken-german-audio-bosses) | 1.0.0 |
| [Places Deutsch](https://www.curseforge.com/wow/addons/spoken-german-audio-places) | 2.2.5 |
| [Readables Deutsch](https://www.curseforge.com/wow/addons/spoken-german-audio-readables) | 2.2.16 bereits installiert |
| [Quests Allianz](https://www.curseforge.com/wow/addons/spoken-german-audio-quests-alliance), [Horde](https://www.curseforge.com/wow/addons/spoken-german-audio-quests-horde), [Shared](https://www.curseforge.com/wow/addons/spoken-german-audio-quests-shared) und [Gossip](https://www.curseforge.com/wow/addons/spoken-german-audio-gossip) | Je 1.1.17 bereits installiert |

## Weitere integrierte Addons und Vorlagen

| Bestandteil | Ergebnis |
|---|---|
| [Attune](https://www.curseforge.com/wow/addons/attune/files/all) | 16001-41 aktuell |
| [Disenchantry](https://www.curseforge.com/wow/addons/disenchantry/files/all) | 1.2.5 aktuell |
| [BigWigs](https://www.curseforge.com/wow/addons/bigwigs/files/all) | v427.9 aktuell |
| [Nova Instance Tracker](https://www.curseforge.com/wow/addons/nova-instance-tracker/files/all) | 2.32 aktuell |
| [Leatrix Maps](https://www.curseforge.com/wow/addons/leatrix-maps/files/all) | Forever 1.60.31 aktuell |
| [GTFO](https://www.curseforge.com/wow/addons/gtfo/files/all) | 6.12.3 aktuell |
| [Decursive](https://www.curseforge.com/wow/addons/decursive/files/all) | 2.9.0-RC4-forever aktuell |
| [Threat Plates](https://www.curseforge.com/wow/addons/tidy-plates-threat-plates/files/all) | 13.3.8 aktuell |
| [PallyPower](https://www.curseforge.com/wow/addons/pally-power/files/all) | 1.6.5 aktuell |
| [EasyExperienceBar](https://www.curseforge.com/wow/addons/easy-experience-bar/files/all) | 2026.11.09.A aktuell |
| [Auctionator 347](https://www.curseforge.com/wow/addons/auctionator/files/9620638) | Originalpakete 346/347 verglichen. Änderungen betreffen den modernen Abbruchdialog und Händlerpreis-Vorrang der originalen Handwerksanzeige. Unser eigener klassischer Handelskern und seine Scanpreise verwenden diese Funktionen nicht; kein Fremdcode auszutauschen. |
| [MinimapButtonButton 1.24.18](https://www.curseforge.com/wow/addons/minimapbuttonbutton/files/9632718) | Änderungen an Haustierkämpfen, Addonfach und Original-Hilfsfunktion betreffen unser eigenes Schnellmenü nicht. Kein eingebetteter Originalcode vorhanden. |

Eigene Module sind durch die vollständige Testsuite abgedeckt. Historische Referenzordner unter `E:\Addons\AddOns` werden nicht zusätzlich installiert.

## Prüfung und Installation

- 436 automatisierte Verhaltenstests bestanden.
- 484 Lua-Dateien und 449 Dateiverweise der beiden vorbereiteten Addons geprüft; passende Interface-16001-TOCs vorhanden.
- PowerShell-Updatertests bestanden, einschließlich Installation und Hashprüfung des vollständigen Katalogs mit 865 Dateien.
- ForeverTools-ZIP und SHA-256-Katalog neu gebaut; ZIP-Integrität geprüft.
- Installierte ForeverTools-Dateien waren vor dem Update identisch mit der lokalen Quelle. Bestehende lokale Anpassungen wurden erhalten.
- ForeverTools (865 Dateien) und QuestieTrace (47 Dateien) direkt im Spielordner installiert und jede kopierte Datei per SHA-256 abgeglichen.
- Sicherung: `E:\Addons\.tools\deployment-backups\addon-update-20261116-114912`.
- Keine Dateien gelöscht, keine Spieleinstellungen oder fremden Addons verändert. Downloads, Vergleiche, Prüfsummen, Testprotokolle und Installationsnachweis liegen unter `.tools/addon-updates-2026-11-16`.

Jetzt außerhalb des Kampfes `/reload` eingeben. Ein Funktionstest im laufenden Spiel steht noch aus.
