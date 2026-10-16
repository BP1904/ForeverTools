# Auto Rank

Eigenständiges Addon für WoW Forever 1.60.1, Interface 16001. Standardmäßig aktiviert; Einstellungen und vorgemerkte Fähigkeiten werden pro Charakter gespeichert. Optional in ForeverTools eingebunden.

## Automatik

- Nach dem Betreten der Spielwelt wird das Spieler-Zauberbuch ausgelesen. Passive, noch nicht gelernte und fremden Spezialisierungen zugeordnete Fähigkeiten werden ausgeschlossen; Haustierzauber und Zauber-Flyouts werden nicht automatisch einzeln verteilt.
- Gleiche Fähigkeiten werden anhand ihres lokalisierten Namens und ihrer Rangangaben zusammengefasst. Nichtnumerische Untertitel unterscheiden Varianten. Der höchste gelernte Rang wird verwendet; Zauber-IDs werden nicht als Rangnummer interpretiert. Native Ersatzzauber und die Basis-ID aus dem Zauberbuch werden berücksichtigt.
- Alle normalen Aktionsleistenplätze 1–180 werden geprüft, einschließlich ausgeblendeter Seiten und dort bereits vorhandener Zauber. Jeder niedrigere direkte Zaubereintrag wird am selben Platz aktualisiert. Bereits vom Client auf den höchsten Rang aufgelöste Einträge benötigen keinen erneuten Austausch.
- Beim ersten Durchlauf werden auch bereits gelernte aktive Fähigkeiten ergänzt, die auf keiner Leiste vorhanden sind. Danach werden neu hinzukommende Fähigkeiten automatisch ergänzt. Höhere Ränge einer vorhandenen Fähigkeit erzeugen keinen zusätzlichen Leistenplatz.
- Neue Fähigkeiten kommen auf freie Plätze der normalen Hauptleiste und eingeschalteter Zusatzleisten. Es werden keine Leisten automatisch eingeblendet. Fehlt Platz, bleibt die Fähigkeit vorgemerkt; nach Freimachen eines Platzes, Einschalten einer weiteren Leiste oder erneutem Login wird sie erneut berücksichtigt.
- Einträge mit Makros und Gegenständen bleiben unverändert. Wenn WoW den Zauber eines Makros meldet, zählt die Fähigkeit als bereits vorhanden. Makrotexte, einschließlich darin ausdrücklich angegebener niedriger Ränge, werden nicht umgeschrieben.
- Absichtlich entfernte Fähigkeiten werden nach erfolgreicher Platzierung nicht ständig neu eingefügt. Absichtlich gesetzte niedrigere direkte Zauberränge werden dagegen gemäß der Auto-Rank-Funktion wieder aktualisiert.
- Im Kampf, während einer Fahrzeugsteuerung oder bei belegtem Mauszeiger wartet das Addon. Die erste Prüfung startet erst nach `PLAYER_ENTERING_WORLD`. Änderungen werden gebündelt ausgeführt; Ereignisse eigener Platzierungen lösen keine Endlosschleife aus.

## Bedienung

In der ForeverTools-Übersicht (`/ad`) gibt es das Häkchen **Auto Rank**. Das separate Addon muss in WoWs Addon-Auswahl aktiviert sein. Unter **Optionen +** liegen die Aktionen **Zauberränge jetzt prüfen** und **Alle fehlenden Fähigkeiten ergänzen**. Ohne ForeverTools funktioniert Auto Rank ebenfalls.

- `/autorank on`: Automatik einschalten.
- `/autorank off`: Automatik ausschalten, auch im Kampf. Bereits angeordnete Leisten bleiben erhalten.
- `/autorank scan`: Ränge prüfen und vorgemerkte neue Fähigkeiten platzieren.
- `/autorank fill`: Zusätzlich alle derzeit fehlenden aktiven Fähigkeiten erneut berücksichtigen, auch zuvor absichtlich entfernte.

Nach einer manuellen Prüfung erscheint immer eine Abschlussmeldung, auch wenn keine höheren gelernten Ränge gefunden wurden. Bei aktualisierten Zaubern werden zusätzlich Name, eingesetzter Rang und Anzahl der betroffenen Leistenplätze genannt. Die Zusammenfassung nennt aktualisierte Plätze und ergänzte Fähigkeiten. Bei fehlendem Platz wird die Anzahl wartender Fähigkeiten gemeldet; Kampf, belegter Mauszeiger, Fahrzeugsteuerung und ein noch nicht verfügbares Zauberbuch erhalten eine Wartemeldung. Abbrüche werden ausdrücklich gemeldet. Automatische Prüfungen ohne Änderungen bleiben still. Ein-/Aus-Zustand in der Übersicht und per Befehl bleiben synchron.

## Installation und Prüfung

Installationsordner: `E:\World of Warcraft\_classic_beta_\Interface\AddOns\AutoRank`. Ein neu installierter Addon-Ordner kann einen vollständigen WoW-Neustart benötigen; spätere Änderungen werden normalerweise mit `/reload` geladen.

Grundlage sind die [Zauberbuch-Schnittstellen des Forever-Clients](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/SpellBookDocumentation.lua), die [Zauberrang-/Pickup-Schnittstellen](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/SpellDocumentation.lua) und die native Platzierung über `PlaceAction`. Ein Legacy-Zauberbuch-Fallback ist enthalten. Der eigene Mauszeiger wird nach bestätigter Platzierung aufgeräumt; ein vorher belegter Mauszeiger wird nicht angefasst. Nicht bestätigte Platzierungen pausieren die Automatik, damit sie nicht unablässig wiederholt werden. Ein fehlgeschlagener Austausch versucht zuerst, den vorherigen Zauber zurückzulegen; scheitert auch dies, bleibt die Originalaktion am Mauszeiger erhalten.

Automatische Lua-5.1-Tests simulieren Zauberbuch, Ränge, native Ersatzzauber, normale/ausgeblendete Leisten, neue Fähigkeiten, volle Leisten, Makros/Gegenstände, belegten Mauszeiger, Platzierungsfehler, Rücknahme eines falschen Austauschs, Kampfaufschub und den ForeverTools-Schalter. Sie bestätigen nicht die tatsächliche Aktionsleistenänderung im Spielclient. Nach dem ersten Start einen niedrigeren Rang sowie das Lernen eines neuen Rangs und einer neuen Fähigkeit im Spiel prüfen.
