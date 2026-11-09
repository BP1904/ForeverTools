# Addon-Prüfung vom 09.11.2026

Geprüft wurden Ereignishandler, laufende Aktualisierungen, wiederholte API-Abfragen, Fenster-Lebenszyklen und das Schließen im Kampf. Dies ist eine Codeprüfung mit Lua-5.1-Regressionstests. Es wurden keine FPS- oder CPU-Messungen im laufenden Spiel durchgeführt. Die Sichtprüfung des neuen Menüs übernimmt der Benutzer.

## Installierte Addons

| Addon | Ergebnis |
|---|---|
| ForeverTools | Alle 21 registrierten Module geprüft; Änderungen unten. Das Menü ist breiter, hat getrennte Modulzeilen und eine Statusanzeige. Alle Schalter und Aktionen bleiben erhalten. |
| AntiFettFinger | Installierte und lokale Einzelversion waren identisch. Escape wurde ausdrücklich gesperrt. Einzelversion und integrierte Version erhalten dieselbe Korrektur und Unterstützung für sichere Schließen-Schaltflächen. |
| AutoRank | Installierte und lokale Einzelversion identisch. Arbeit wird bereits gebündelt und nur bei vorgemerkter Prüfung ausgeführt; Schutz gegen doppelte Instanzen vorhanden. Keine zusätzliche Änderung erforderlich. |
| ForeverDungeonJournal | Porträtauflösung stoppt ihre Arbeit bei leerer Warteschlange; Questereignisse werden gebündelt und sichtbare Ansichten aktualisiert. Vergleichs-Tooltips prüfen den Besitzer und wechseln nur bei geändertem Modifikatorzustand. Keine zusätzliche Änderung vorgenommen. |
| RXPGuides | Aktive Schritthandler werden beim Freigeben entfernt; Taschenaufgaben werden gebündelt und stoppen danach; Importarbeiter stoppen nach Abschluss. Die geprüften Abläufe werden beibehalten. Keine Änderung am Fremdaddon. |

## ForeverTools: alle 21 Module

| Modul | Ergebnis |
|---|---|
| Händler und Taschen | Bereits begrenzte Verarbeitung; im Leerlauf keine Händlerarbeit. Beibehalten. |
| Automatische Questabgabe | Ereignisgesteuert, keine Dauerabfrage. Beibehalten. |
| Questmarkierungen | Vorheriger Fix verhindert doppelte Tooltipabfragen und unnötiges Neuverankern. Weiterhin aktiv. |
| Material-Infos und Rezeptsuche | Gemeinsame Materialien werden einmal pro Suche abgefragt; neue Suche liest frischen Bestand. |
| Bank unterwegs | Aktualisierung nur beim Bankbesuch, gebündelte Nachprüfung und Abbruch alter Bankbesuche vorhanden. Sofortige Speicherung beibehalten, damit schnelles Schließen keine Änderung verliert. |
| Paladin | Bufflisten werden innerhalb eines Anzeige-Durchlaufs gemeinsam verwendet. Sichere X-Schaltflächen und Escape-Unterstützung für die geschützten Fenster ergänzt. Buffleiste und Zauberattribute bleiben erhalten. |
| GTFO | Spieler-Buffereignisse über RegisterUnitEvent filtern, mit Rückfall für Clients ohne Unterstützung. Warnungen und Prüfintervalle bleiben erhalten. |
| Threat Plates | Vorheriger Fix ignoriert Ereignisse unbeteiligter Einheiten. Relevante Spieler-Auren und sichtbare Plaketten werden weiter aktualisiert. |
| Decursive | Bei Einzelereignissen direkt zur betroffenen Schaltfläche springen, statt alle 45 Schaltflächen zu durchlaufen. Periodische Reichweitenprüfung bleibt erhalten. |
| Buffcheck | Geladene Zaubernamen werden wiederverwendet. Zusätzlich Spieler-Buffereignisse im Client filtern. Warnungen, Cache-Verhalten und Restzeiten bleiben erhalten. |
| Anti Fett Finger | Keine neue Dauerabfrage. Escape erhält seine Schließen-Funktion; übrige Tastensperre bleibt bestehen. |
| Auto Rank | Ausstehende Prüfungen bereits gebündelt; keine zusätzliche Änderung. |
| Karten | Inhalte werden bei Änderungen erneuert; Mausposition und Beschriftung nur bei sichtbarer Karte geprüft. Bestehende Karten-Hooks und Intervalle beibehalten. |
| Auktionshaus | Vorheriger Fix überspringt Verarbeitung ohne aktive Aufgabe. Laufende Suchen, Scans und Zeitüberschreitungen bleiben erhalten. |
| Lernübersicht | Datenaufbau beim Stufenaufstieg mit geöffnetem Fenster einmal statt zweimal; Meldung und Anzeige verwenden denselben Datenstand. |
| Berufsplaner | Taschenbestand nur für Materialien des ausgewählten Berufs abfragen. Berufswechsel liest den neuen Bedarf frisch; Bankaufnahme behält alle Berufe bei. |
| Disenchantry | Scan- und Preisabläufe bereits bedarfsabhängig. Kompakte geschützte Leiste erhält sicheren X-/Escape-Schließen-Handler; Aktionen bleiben geschützt. |
| Attune | Wiederholtes Setzen derselben Gildenfensterhöhe entfernt. Diagramm und Ergebnistabelle haben bereits Änderungsprüfungen. |
| BigWigs | Inhalte werden über den eingebetteten Paketlader bei Bedarf geladen. Bestehende Bosswarnungen und Timer unverändert. |
| Nova Instance Tracker | Sichtbare Listen verwenden bereits begrenzte Aktualisierung; Fenster-Hooks und Datenaufzeichnung beibehalten. |
| Erfahrungsleiste | Unveränderte Transparenz der Blizzard-EP-Leiste nicht erneut schreiben; Originalwert beim Abschalten wiederherstellen. Zeitberechnung und Aktualisierungsintervall bleiben erhalten. |

## Zusätzliche Hilfsfunktion

Das Trinkmakro wird bei Taschen-/Makroereignissen aktualisiert. Seine Befehle werden nur geändert, wenn sich der ausgewählte Gegenstand tatsächlich ändert; keine neue Dauerabfrage erforderlich.

## Prüfung

Die Tests prüfen unter anderem Materialabfragen, Berufswechsel, frische Bestände, einmaligen Datenaufbau, Filter-Rückfall, unveränderte Schalter und Aktionen, sichere Sichtbarkeitsänderungen im Kampf sowie unveränderte Buff- und Entzauberungsaktionen. Die tatsächliche Darstellung und Eingabeverarbeitung im Forever-Client muss nach `/reload` noch geprüft werden.

Ergebnis des vollständigen Testlaufs: **408 Tests bestanden**.
