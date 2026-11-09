# Weitere ForeverTools-Verbesserungen – 09.11.2026

Version 1.16.9. Geprüft wurden die 21 registrierten Module sowie gemeinsame Hilfsfunktionen. Vorhandene lokale Änderungen bleiben erhalten. Änderungen erfolgen dort, wo zusätzliche Arbeit vermieden werden kann, ohne die Schutzregeln oder die Bedienung zu verändern.

## Umgesetzt

| Modul | Verbesserung |
|---|---|
| Questmarkierungen | Periodische vollständige Prüfung alle 0,5 statt 0,1 Sekunden. Neue Plaketten und Questereignisse bleiben sofort sichtbar. Nach Kampfende werden Objektmarkierungen sofort wieder geprüft. Die Funkelanimation bleibt flüssig. |
| Bank unterwegs | Gleiche Gegenstandslinks innerhalb einer Bankaufnahme nur einmal nach ihrem Namen abfragen. Varianten behalten eigene Links. Jede neue Aufnahme liest frische Daten; sofortiges Speichern und verzögerte Nachprüfung bleiben erhalten. |
| Material-Infos/Rezeptsuche | Gelernte Berufe zwischen Tooltip- und Suchaufrufen wiederverwenden. Berufs-/Zauberänderungen und Welteintritt verwerfen den Zwischenspeicher. Bestände bleiben pro Suche frisch. |
| Berufsplaner | Klassische Rezepte ohne Rezeptlink über eine einmal je Beruf und Scan aufgebaute Namenstabelle auflösen. Mehrdeutige Namen weiterhin nicht zuordnen. Im nächsten Scan werden Namen erneut gelesen. |
| Auktionshaus | Einen gemeinsamen Zeitstempel pro verarbeiteter Vollscan-Portion verwenden. Niedrigster Stückpreis, Varianten, Abbruch und Zeitüberschreitungen bleiben erhalten. |
| Karten | Das Laden fremder Addons löst keinen vollständigen Kartenneuaufbau mehr aus. Blizzard_WorldMap und Leatrix_Maps werden weiterhin berücksichtigt. |

## Weitere geprüfte Module

| Modul | Ergebnis |
|---|---|
| Threat Plates | Auf Wunsch unverändert: unmittelbare Ereignisupdates und Prüfung alle 0,2 Sekunden. Das Intervall und Zielwechsel sind zusätzlich durch einen Test abgesichert. |
| Händler/Taschen | Verarbeitung bereits nur bei aktivem Auftrag und in begrenzten Schritten; Kampf- und Fehlerschutz beibehalten. |
| Automatische Questabgabe | Bereits ereignisgesteuert; Umschalt-Pause und manuelle Belohnungsauswahl beibehalten. |
| Paladin | Gemeinsamer Aura-Datenstand pro Anzeigedurchlauf bereits vorhanden. Reichweiten, Timer und Synchronisation beibehalten. |
| GTFO | Spieler-Auraereignisse bereits gefiltert; Warnintervalle und eingeschränkter Forever-Modus beibehalten. |
| Decursive | Einzelereignisse bereits direkt der betroffenen Einheit zugeordnet. Schnelle Aura- und Reichweitenprüfung beibehalten. |
| Buffcheck | Zaubernamen bereits zwischengespeichert; Restzeit-/Essenswarnungen müssen auch bei ausgeblendeter Anzeige laufen. Keine zusätzliche Verlangsamung. |
| Anti Fett Finger | Sichere Zustandssteuerung statt Dauerabfrage; Tastensperre und Escape unverändert. |
| Auto Rank | Ereignisse und ausstehende Prüfung bereits gebündelt; Leistenänderungen warten auf Kampfende und freien Cursor. |
| Lernübersicht | Fensteraktualisierungen und Zauberdatenanfragen bereits gebündelt. Lehrerpreise und Begleiterbuch bleiben aktuell. |
| Disenchantry | Bedarfsgesteuerte Scans und Preisabfragen vorhanden. Warteschlange und Prüfungen nach Kampfende bleiben erhalten, auch wenn das Hauptfenster verborgen ist. |
| Attune | Bereits abgesicherte Aktivierung/Deaktivierung und verzögerte Aufgaben; vorhandene Anzeige- und Fortschrittslogik beibehalten. |
| BigWigs | Bedarfslader und Bosswarnungen beibehalten. Kein zusätzliches Bossdatenpaket eingebaut; dessen fachliche Abdeckung ist eine eigene Erweiterung. |
| Nova Instance Tracker | Datenaufzeichnung und sichtbare Listen beibehalten; keine neue Dauerabfrage ergänzt. |
| Erfahrungsleiste | Unveränderte native Transparenz wird bereits nicht erneut geschrieben; laufende Spielzeit und XP-Berechnung beibehalten. |

Gemeinsames Menü, Paketlader, Diagnose, Update-Anforderung, Trinkmakro und Disenchantry-Minimapbutton wurden ebenfalls berücksichtigt. Keine zusätzlichen Änderungen notwendig. Diagnose arbeitet ereignisgesteuert; das Trinkmakro schreibt nur geänderte Inhalte; der Minimapbutton verwendet laufende Mausabfragen nur beim Ziehen.

**Zusätzlicher Update-Fix:** Der Windows-Helfer akzeptiert jetzt genau die mitgelieferte Attune-Datei `Features/Attune/Libs/LibDataBroker-1.1/README.textile`. Zuvor brach seine vollständige Paketprüfung an dieser Dokumentationsdatei ab. Andere `.textile`-Pfade bleiben gesperrt. Quellskript und im Addon gebündelte Kopie werden gemeinsam aktualisiert.

## Prüfung und Grenzen

Die automatisierten Lua-5.1-Tests prüfen insbesondere die verlangsamte Questprüfung, unmittelbare Quest-/Plakettenereignisse, weiterhin schnelle Threat-Plates-Updates, frische Banknamen, getrennte Gegenstandsvarianten, das Verwerfen des Berufs-Zwischenspeichers, doppelte Rezeptnamen und unveränderte Auktionspreise.

Ergebnis: **429 Tests bestanden**. Zusätzlich hat die Windows-Updateprüfung einschließlich kompletter Installation und Hashprüfung aller **857 Addondateien** bestanden. Ihre temporären Dateien lagen unter `.tools/updater-test-temp`, da das Umbenennen von Dateien im Sandbox-Tempordner eingeschränkt war.

Die Prüfung ersetzt keine CPU-/FPS-Messung und keinen Sichttest im laufenden Forever-Client. Nach Installation `/reload` eingeben und Questzähler, Objektfunkeln, Bank, Berufe und Karte ausprobieren. Eine bestimmte FPS-Steigerung wird nicht behauptet.
