# ForeverTools: Prüfung blockierter Interface-Aktionen

Stand: 09.11.2026. Anlass ist die Meldung „Interface-Aktion auf Grund eines Addons fehlgeschlagen“. Das Bild nennt weder Addon noch Funktion. Ein zugehöriges Taint-Protokoll war in den lokalen Logs nicht vorhanden. Der konkrete Verursacher der abgebildeten Meldung ist deshalb noch nicht nachgewiesen.

## Gefundene und korrigierte Risiken

- **Lernübersicht:** Die an native Zauber-/Berufsbücher angehängten Zusatzbuttons wurden beim Kampfbeginn aus einem normalen Ereignishandler versteckt. Ihre Verankerung kann Schutzregeln des nativen Fensters übernehmen. Sichtbarkeitsänderungen im Kampf erfolgen jetzt über einen sicheren Zustands-Handler; normale Buch-Hooks ändern im Kampf nichts daran.
- **Karten:** Änderungen an Karten-CVars werden bis nach dem Kampf vorgemerkt. Wird eine Verschiebung bei Kampfbeginn beendet, wird `StopMovingOrSizing` ebenfalls erst nach Kampfende ausgeführt.
- **Paladinfenster:** Die DragStop-Handler der Zuweisungs- und Detailfenster riefen den Bewegungsstopp ohne Kampfprüfung auf. Die geschützten Fenster verschieben diesen Aufruf nun auf die erste Aktualisierung nach dem Kampf. Bestehende sichere Schließen-Schaltflächen bleiben erhalten.
- **Disenchantry:** Titelleisten starten im Kampf keine Verschiebung mehr. Das Beenden laufender Verschiebungen wird für Haupt-/Nebenfenster und Kompaktleiste nachgeholt. Ein direkter UI-Neuaufbau während des Kampfes wird vorgemerkt, statt geschützte Unterelemente neu anzuordnen.
- **Journal-Minimapbutton:** Die Korrektur seiner Zeichenreihenfolge wartet während des Kampfes bis `PLAYER_REGEN_ENABLED`.

Diese Codepfade sind plausible Auslöser von Schutzverletzungen. Ohne aufgezeichnete blockierte Funktion belegen sie nicht die Ursache der konkreten Bildschirmmeldung.

## Weitere geprüfte ForeverTools-Module

| Modul | Ergebnis der Prüfung |
|---|---|
| Händler/Taschen | Geschützte Händler- und Taschenarbeit pausiert im Kampf. |
| Questabgabe | Ereignisgesteuerte Questaktionen; keine automatische Zauber- oder Aktionsleistenänderung gefunden. |
| Questmarkierungen | CVar-Änderungen bereits mit Kampfprüfung; keine zusätzliche Änderung. |
| Materialien/Rezeptsuche | Tooltip- und Suchabläufe geprüft; kein sicher belegter weiterer Auslöser. |
| Bankansicht | Bankbutton-Verankerung bereits gegen Kampfsperre abgesichert. |
| Berufsplaner | Datenabfragen und eigene Anzeige; keine geschützten Zauberaktionen. |
| Buffcheck | Anzeige und Auraabfragen, keine automatischen Buffcasts oder geschützten Aktionsbuttons. |
| GTFO | Native Warnregistrierung berücksichtigt Einschränkungszustände; verbotene klassische Combatlog-Registrierung wird auf Forever vermieden. |
| Threat Plates | Lesbarkeit und verbotene Frames berücksichtigt; Anzeige-Hooks geprüft. Ohne Laufzeitdaten kein zusätzlicher Auslöser nachgewiesen. |
| Decursive | Geschützte Zauberattribute und Layoutänderungen erfolgen bereits außerhalb des Kampfes; normale Aura-Aktualisierungen verändern diese Attribute nicht. |
| Anti Fett Finger | Sichere Tastensperre und registrierte sichere Schließen-Handler geprüft. Gespeicherte Belegungen werden nicht umgeschrieben. |
| Auto Rank | Aktionsleistenänderungen bereits mit Kampf-/Cursorprüfung; vorhandene Verhaltenstests bleiben aktiv. |
| Auktionshaus | Aktive Aufträge und Abbruch bei Kampfbeginn geprüft; kein weiterer belegter Auslöser. |
| Attune | Forever-Fallback für verbotene Combatlog-Registrierung vorhanden; Quest- und Fensterpfade geprüft. |
| BigWigs | Verbotene klassische Log-Registrierung ist im modernen Pfad ausgeschlossen; sichere Zustands- und Warnabläufe beibehalten. |
| Nova Instance Tracker | Forever setzt eingeschränkten Datenmodus; klassische Combatlog-Registrierungen sind durch Versions-/Spielmodusbedingungen ausgeschlossen. |
| Erfahrungsleiste | Anzeige und Wiederherstellung der nativen EP-Leiste geprüft; keine automatische geschützte Aktion gefunden. |
| Trinkmakro-Hilfe | Makroänderungen bereits außerhalb des Kampfes; Befehle werden bei unverändertem ausgewähltem Gegenstand nicht neu geschrieben. |
| Gemeinsames Menü/Paketlader | Eigene Menüelemente und sichere Schließen-Wege geprüft; keine globalen Fehlerhandler ersetzt. |

## Diagnose beim nächsten Auftreten

Nach `/reload` werden `ADDON_ACTION_BLOCKED`, `ADDON_ACTION_FORBIDDEN` und die entsprechenden Makroereignisse aufgezeichnet. Die Ereignisnamen und Nutzdaten wurden mit Blizzards [Forever-API-Dokumentation](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/RestrictedActionsDocumentation.lua) abgeglichen.

`/ftfehler` zeigt die letzten fünf Meldungen mit Funktion, gemeldetem Addon und Kampfstatus. `/ftfehler details` zeigt zusätzlich verfügbare Aufrufstapel. Gleiche aufeinanderfolgende Ereignisse werden zusammengefasst; maximal 20 Einträge bleiben in den bestehenden ForeverTools-SavedVariables erhalten. Die Aufzeichnung läuft nur bei einem solchen Ereignis, nicht pro Bildaufbau. Die ursprünglichen Warnungen werden nicht unterdrückt. Ein genannter Addonname ist eine Zuordnung des Clients, keine Garantie für den ursprünglichen Verursacher einer weitergetragenen Verunreinigung.

Alle betroffenen Änderungen sind mit simulierten geschützten APIs geprüft. Eine fehlerfreie Spielsitzung oder die exakte Ursache der ursprünglichen Warnung kann damit noch nicht bestätigt werden.

Vollständiger Testlauf: **419 Tests bestanden**.
