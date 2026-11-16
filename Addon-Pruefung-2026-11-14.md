# Addonprüfung vom 14. November 2026

Ziel: WoW Forever 1.60.1.70425, Interface 16001. Alle 23 vorhandenen Addonordner und alle integrierten Komponenten geprüft.

## Aktualisiert

| Bestandteil | Bisher | Neu |
|---|---|---|
| ForeverTools | 1.16.13 | 1.16.14 |
| [Attune integriert](https://www.curseforge.com/wow/addons/attune/files/9600741) | 16001-40 | 16001-41 |
| [Disenchantry integriert](https://www.curseforge.com/wow/addons/disenchantry/files/9588980) | 1.2.4 | 1.2.5 |
| [What's Training? Lerndaten](https://www.curseforge.com/wow/addons/whats-training/files/9604805) | 11.4.3 | 11.4.7 |
| [Spoken mit sechs vorhandenen Modulordnern](https://github.com/rusty-key/spoken-wow/releases/tag/spoken/v3.9.0) | 3.8.7 | 3.9.0 |
| [Spoken German Audio: Gossip](https://www.curseforge.com/wow/addons/spoken-german-audio-gossip/files/9608545) | 1.1.14 | 1.1.16 |

Attune korrigiert unter anderem wiederholte Fortschrittsmeldungen, Gildenmeldungen im Kampf, Dungeonstufen und Questdaten. Disenchantry ergänzt Gewinnanzeige und Schutzoptionen; die Materialanzeige wird pro Charakter gespeichert. Dafür wurde ein eigener gespeicherter ForeverTools-Charakterspeicher ergänzt, einschließlich Übernahme der bisherigen Einstellung. Lerndaten enthalten aktualisierte Berufsrezepte und Druidenzauber.

Die Integration wurde gegen die vorherigen Originalversionen abgeglichen und ohne Mergekonflikte übernommen. Eigene Suche, Navigation, Modulschalter, Preisversorgung, kompakte Entzauberleiste und Kampf-/Schließschutz bleiben erhalten. Die sechs installierten Spoken-Ordner stimmen vor dem Update mit dem Original 3.8.7 überein; 67 Dateien wurden vom Hersteller geändert, keine entfernt.

## Bereits aktuell

| Installiertes Einzeladdon | Geprüfter Stand |
|---|---|
| [Questie / QuestieDB](https://github.com/Questie/Questie/releases) | 12.9.0 / 1.1.1 |
| [QuestieTrace](https://github.com/Questie/QuestieTrace/releases) | 1.11.0 |
| [RestedXP](https://www.curseforge.com/wow/addons/restedxp-guide/files/all) | 4.11.36 |
| [DungeonJournal](https://www.curseforge.com/wow/addons/dungeonjournal/files/9595820) | 2.0.5 |
| Anti Fett Finger / Auto Rank | Lokale Versionen 1.0.0; eigene Funktionen getestet |
| [Spoken German Metapaket](https://www.curseforge.com/wow/addons/spoken-german) | 1.1.0 |
| [Spoken Bosses Deutsch](https://www.curseforge.com/wow/addons/spoken-german-audio-bosses) | 1.0.0 |
| [Spoken Places Deutsch](https://www.curseforge.com/wow/addons/spoken-german-audio-places) | 2.2.5 |
| [Spoken Readables Deutsch](https://www.curseforge.com/wow/addons/spoken-german-audio-readables) | 2.2.13 |
| [Spoken Quests Allianz](https://www.curseforge.com/wow/addons/spoken-german-audio-quests-alliance), [Horde](https://www.curseforge.com/wow/addons/spoken-german-audio-quests-horde), [Shared](https://www.curseforge.com/wow/addons/spoken-german-audio-quests-shared) | Je 1.1.14 |

| Weitere integrierte Vorlage | Geprüfter Stand |
|---|---|
| [BigWigs](https://www.curseforge.com/wow/addons/bigwigs/files/all) | v427.9 |
| [Nova Instance Tracker](https://www.curseforge.com/wow/addons/nova-instance-tracker/files/all) | 2.32 |
| [Leatrix Maps](https://www.curseforge.com/wow/addons/leatrix-maps/files/all) | 1.60.31 |
| [GTFO](https://www.curseforge.com/wow/addons/gtfo) | 6.12.3 |
| [Decursive](https://www.curseforge.com/wow/addons/decursive) | 2.9.0-RC4-forever |
| [Threat Plates](https://www.curseforge.com/wow/addons/tidy-plates-threat-plates) | 13.3.8 |
| [PallyPower](https://www.curseforge.com/wow/addons/pally-power) | 1.6.5 |
| [EasyExperienceBar](https://www.curseforge.com/wow/addons/easy-experience-bar) | 2026.11.09.A |
| [MinimapButtonButton](https://www.curseforge.com/wow/addons/minimapbuttonbutton) | 1.24.17 |
| [Auctionator](https://www.curseforge.com/wow/addons/auctionator/files/9572997) | 346 geprüft; Änderung entfernt eine Kupferpreis-Sonderbehandlung, die unser eigener Auktionskern nicht verwendet. Kein Fremdcode auszutauschen. |

Weitere eigene Module sind durch die vorhandenen Verhaltenstests abgedeckt. Historische Originalordner unter `E:\Addons\AddOns` bleiben Referenzmaterial und werden nicht zusätzlich installiert.

## Prüfung und Installation

- 436 automatisierte Verhaltenstests bestanden, einschließlich neuer Prüfung für Charakterspeicher und Einstellungsübernahme.
- 731 Lua-Dateien und 718 Dateiverweise der zu installierenden Addons geprüft; alle acht Ordner haben passende Interface-16001-TOCs.
- PowerShell-Updatertests bestanden, einschließlich Installation und SHA-256-Abgleich des vollständigen Katalogs mit 865 Dateien.
- ForeverTools-ZIP und Katalog neu gebaut. Pakete auf ZIP-Integrität geprüft; Downloadprüfsummen, Releasekataloge, Vergleiche und Testprotokolle liegen unter `.tools/addon-updates-2026-11-14`.
- Installation ausschließlich der acht geprüften Addonordner, mit Sicherung unter `.tools/deployment-backups` und SHA-256-Abgleich jeder kopierten Datei. Keine Löschung zusätzlicher Dateien oder Änderung der Spiel-SavedVariables.
- Der tatsächliche Installationsnachweis einschließlich Sicherungspfad steht in `.tools/addon-updates-2026-11-14/deployment-result.json`.

Danach außerhalb des Kampfes `/reload` eingeben. Alle Ordner waren bereits vorhanden. Ein Funktionstest im laufenden Spiel steht noch aus.
