# ForeverTools 1.5.0

## GitHub-Updates

**Einmal nach der Installation `Update.cmd` doppelklicken.** Damit wird der Helfer gestartet und für die automatische Ausführung bei eurer Windows-Anmeldung eingerichtet. Danach genügt zum Anfordern ein Klick auf **Update** im `/ad`-Menü, ohne weiteren Bestätigungsdialog. Der Helfer lädt alle Module und meldet **Update fertig**. Danach **`/reload`** eingeben, damit WoW die neuen Dateien einliest. Der Helfer lädt weder im Leerlauf noch beim Windows-Start selbstständig Updates. Autostart abschalten: Rechtsklick auf sein Symbol neben der Windows-Uhr → **Autostart ausschalten und beenden**.

Ein erweiterbares Addon für **WoW Forever 1.60.1.70425** (Interface 16001).
Keine zusätzlichen Addons oder Bibliotheken im Spiel erforderlich.

## Installation

1. [Fertiges ForeverTools.zip herunterladen](https://github.com/BP1904/ForeverTools/releases/latest/download/ForeverTools.zip), öffnen und den enthaltenen Ordner `ForeverTools` nach `Interface\AddOns` ziehen. Bei einer Launcher-Installation liegt dieser gegebenenfalls unter `_classic_beta_`.
2. Die Datei muss anschließend unter `Interface\AddOns\ForeverTools\ForeverTools.toc` liegen, ohne einen zusätzlichen verschachtelten Ordner.
3. WoW starten beziehungsweise `/reload` eingeben und ForeverTools in der Addon-Auswahl aktivieren. Neu kopierte Addon-Ordner können einen vollständigen Neustart erfordern.

Menü öffnen: **Schmiede-Symbol unten links an der Minimap**, **`/ad`** oder **`/forevertools`**. Das Fenster ist verschiebbar und lässt sich mit Escape schließen.

Die Hauptübersicht zeigt nur ein Ein-/Aus-Häkchen pro Modul, derzeit neun einschließlich **Anti Fett Finger** und **Auto Rank**. Alle Unterpunkte starten eingeklappt. **„Optionen +“** öffnet die Beschreibung, Aktionen und Einstellungen des jeweiligen Moduls; **„Optionen -“** klappt sie wieder zu. Das Aufklappen verändert keine Einstellungen. Unterpunkte und Aktionen ausgeschalteter Module sind deaktiviert, die Optionen lassen sich weiterhin ansehen.

**Anti Fett Finger** ist vollständig integriert. Sein Häkchen und sein eigener Mausbutton bleiben synchron. Der Zustand und die Buttonposition werden pro Charakter in ForeverTools gespeichert. Änderungen über die Übersicht während eines Kampfes werden bis Kampfende vorgemerkt; der eigene Mausbutton kann weiterhin sofort umschalten. Bei einer noch aktivierten alten Einzelversion werden deren Einstellungen übernommen und die alte Version für den aktuellen Charakter deaktiviert. Sie wird in dieser Sitzung weiterverwendet; ab dem folgenden `/reload` läuft die integrierte Funktion.

**Auto Rank** ist ebenfalls vollständig integriert und hat ein eigenes Häkchen. Es ersetzt niedrigere direkte Zauberränge auf allen normalen Aktionsleisten durch den höchsten gelernten Rang. Beim ersten Durchlauf ergänzt es fehlende aktive Fähigkeiten; anschließend werden neu gelernte Fähigkeiten auf freie Plätze der Hauptleiste oder eingeschalteter Zusatzleisten gelegt. Bei Platzmangel warten sie auf freie Plätze. Makros und Gegenstände bleiben erhalten. Im Kampf und bei belegtem Mauszeiger wird gewartet. Unter „Optionen +“ lassen sich Ränge manuell prüfen oder alle fehlenden Fähigkeiten erneut ergänzen; Befehle: `/autorank scan`, `/autorank fill`, `/autorank on/off`. Ein-/Aus-Schalter und Befehle sind synchron. Einstellungen, bekannte Fähigkeiten und wartende Ergänzungen liegen pro Charakter in ForeverTools. Eine aktivierte alte Einzelversion wird wie Anti Fett Finger übernommen und deaktiviert.

## Erstes Modul: Händler & Taschen

Das Modul und seine drei Funktionen sind anfangs aktiviert. Jedes Häkchen wirkt sofort; Einstellungen werden über WoWs SavedVariables accountweit gespeichert.

Beim Öffnen eines Händlerfensters:

1. Alle über WoWs „Alles reparieren“ reparierbaren Gegenstände am Charakter und in den mitgeführten Taschen reparieren. Voraussetzung: Reparaturhändler und genügend eigenes Gold. Die Gildenbank wird nicht verwendet.
2. Alle verkäuflichen grauen Gegenstände in den mitgeführten Taschen stapelweise verkaufen. Weiße und höherwertige Gegenstände sowie angelegte Ausrüstung werden nicht verkauft. Unverkäufliche Gegenstände bleiben erhalten.
3. Falls zuvor Gold fehlte, die Reparatur mit dem Verkaufserlös erneut versuchen.
4. Danach einmal WoWs integrierte Funktion **„Taschen aufräumen“** aufrufen (`C_Container.SortBags()`). WoW übernimmt alle Verschiebungen. Dadurch entfällt das langsame Verschieben einzelner Gegenstände durch das Addon.

Es gelten dieselben Regeln wie beim manuellen Klick auf „Taschen aufräumen“, einschließlich WoWs Sortierrichtung, Taschenzuweisungen, Spezialtaschen und ausgeschlossenen Taschen. Diese Einstellungen werden vom Addon nicht verändert. Die Chatmeldung bestätigt den Start; das eigentliche Aufräumen führt der Client aus.

Im Kampf wartet das Modul. Gesperrte Gegenstände werden abgewartet; dauerhafte Blockaden beenden den betreffenden Schritt mit einer Chatmeldung. Ein bereits belegter Mauszeiger wird nicht verändert. Beim Schließen des Händlerfensters werden keine weiteren Verkäufe oder Reparaturen ausgelöst; das anschließende Aufräumen kann noch fertiglaufen. Nach einer fehlgeschlagenen Aktion startet ein neuer Versuch beim nächsten Händlerbesuch.

Das übergeordnete Modul-Häkchen stoppt laufende Automatik. Einzelne Funktionen lassen sich unabhängig abschalten. Eine bereits vom Spiel angenommene Aktion wird durch das Abschalten nicht rückgängig gemacht.

## Automatische Questabgabe

Das zweite Modul integriert die Quest-Schnellabgabe aus `Guschi.zip`, Datei `Guschi/QuickTurnIn.lua` (Guschi 1.2.1, Autor: Philipp).

- Im Menü `/ad` über das eigene Häkchen **„Automatische Questabgabe“** ein- und ausschalten. Anfangs aktiviert, unabhängig von „Händler & Taschen“.
- Beim Anklicken eines Questgebers fertige Quests aus dessen Liste auswählen, den Fortschrittsdialog bestätigen und die Quest abgeben.
- Ohne Belohnungsauswahl oder bei genau einer wählbaren Belohnung automatisch abschließen. Bei mehreren Belohnungen bleibt die Auswahl dir überlassen.
- **SHIFT/Umschalttaste gedrückt halten**, um die Automatik vorübergehend zu pausieren.
- Neue Quests werden nicht automatisch angenommen. Die normale Questgeber-Interaktion bleibt notwendig.

Die Funktion reagiert wie die Vorlage auf `GOSSIP_SHOW`, `QUEST_GREETING`, `QUEST_PROGRESS` und `QUEST_COMPLETE`. Weitere fertige Quests werden ausgewählt, wenn der Client erneut die Questliste öffnet. Die Originaldateien im ZIP bleiben unverändert.

Die Integration ist mit simulierten WoW-APIs geprüft; ein Test dieser neuen Funktion im laufenden Client steht noch aus.

## Handwerksmaterial-Infos und Rezeptsuche

Aus `Guschi.zip` (Guschi 1.2.1, Autor Philipp) übernommen und in ForeverTools integriert:
`MatUse.lua` → `Modules/Materials.lua`, `Data.lua` → `Data/MaterialUses.lua` sowie
`AhButton.lua` und `Recipes.lua` → Rezeptsuche und `Data/Recipes.lua`.
Das Original-ZIP bleibt unverändert; Guschi muss nicht zusätzlich installiert sein.

- Eigenes Modul **„Handwerksmaterial-Infos“** im Menü `/ad`, anfangs aktiviert.
- Zwei einzeln schaltbare Funktionen: Material-Tooltips und Auktionshaus-Rezeptsuche.
- Tooltips zeigen bis zu acht Rezepte deiner gelernten Berufe, Materialmenge pro Herstellung und Skillwerte für gelb/grün. Bekannte Rezepte sind grün markiert; andere Berufe erscheinen unter „Auch für“. Weitere Rezepte werden gezählt.
- Im Auktionshaus erscheint **„Neue Rezepte suchen“** unter dem Fenster. Gesucht werden unbekannte Rezeptgegenstände deiner Berufe, für die mindestens die Hälfte der verschiedenen Materialsorten in Taschen oder Bank vorhanden ist. Die vollständigen Herstellungsmengen sind dafür nicht erforderlich. Die besten Materialabdeckungen stehen zuerst.
- Bereits in Taschen/Bank oder im zuletzt eingelesenen Briefkasten vorhandene Rezeptgegenstände werden übersprungen. Der Briefkastenstand wird pro Charakter gespeichert und beim Aktualisieren des Posteingangs neu eingelesen. Neu gekaufte Rezepte werden erst nach Erfassung im Briefkasten oder in den Taschen ausgeschlossen; die Vorlage markierte schon Gebotsversuche als gekauft, was hier bewusst entfällt.
- Leere Suchergebnisse führen zum nächsten Kandidaten. Beim Treffer stoppt die Suche; ein weiterer Klick geht zum nächsten Rezept. Käufe bleiben manuell. Schließen des Auktionshauses und Abschalten der Funktion brechen die Suche ab. Ohne Antwort stoppt sie nach zwölf Sekunden.

Die statischen Daten stammen laut ZIP aus **Beta 1.60.1.70245**. Vollständigkeit und Skillwerte für Client **1.60.1.70425** sind nicht bestätigt. Der grüne Skillwert wird wie in Guschi aus gelbem und grauem Wert berechnet. Fehlende Zaubernamen erscheinen als `#ZauberID`.

Verhaltenstests mit simulierten WoW-APIs prüfen Tooltips, Berufsfilter, Rezeptauswahl und Suchabbruch. Der Spieltest steht noch aus: `/reload`, Material-Tooltip ansehen, beide Häkchen einzeln prüfen und am Auktionshaus die Rezeptsuche testen. Falls Guschi ebenfalls aktiviert ist, dort „Handwerksmaterial-Infos“ ausschalten, um doppelte Tooltip-Zeilen zu vermeiden.

## Paladin: Segen & Gruppenbuffs

Eigenständiger Nachbau der Kernfunktionen aus dem bereitgestellten **PallyPower Forever v10.15.26** (`AddOns/PallyPower`). Das Modul verwendet eigene Lua-Dateien und WoW-Schaltflächen, ohne Ace3 oder andere mitgelieferte Bibliotheken. Die Quelldateien des bereitgestellten Addons bleiben unverändert.

**Dauerhafte Buffleiste im Stil der Vorlage:** Nach Login oder `/reload` erscheint bei aktiviertem Modul eine separate **100 UI-Punkte schmale Spalte**, deren Höhe mit den vorhandenen Klassen wächst. Ein Bufffeld ist 100 × 28 groß (Vorlage: 100 × 34). Sie bleibt auch bei geschlossenem `/ad`-Menü, geschlossener Zuweisungsansicht und ohne Gruppe sichtbar. Am Kopfbereich ziehen, um sie zu verschieben; die Position wird pro Charakter gespeichert.

Die Spalte enthält eigene Felder für Zorn der Gerechtigkeit, Siegel und Aura, optional Rettung und nur die in der Gruppe vorhandenen Klassen. Die zusätzliche Sammelzeile „Nächster Buff“ ist in der dauerhaften Leiste ausgeblendet, damit sie die Klassen-Buffanzeige nicht doppelt zeigt. Sie bleibt in der ausführlichen Zuweisungsansicht verfügbar. Jedes Feld zeigt nur eine Restzeit; bei Klassenbuffs mit Spieler-Ausnahmen zählt die kürzeste gemessene Restzeit. Klassenfelder zeigen außerdem Klassen- und Segenssymbol sowie fehlende Buffs. Hintergründe wie bei PallyPower: **Rot** = allen fehlt der Buff, **Gelb** = einigen fehlt er, **Blau** = Spieler-Ausnahmen fehlen, **Grün** = alle versorgt. Grau/`?` bedeutet unbekannt oder keine Zuweisung.

Beim Darüberfahren über eine Klasse klappt seitlich eine Liste auf: Vorname, Segenssymbol, Restzeit, `T` für Tank, `D` für tot, `OFF` für offline, `R` für außer Reichweite. Vollständige Namen bleiben für Zauberziele und Tooltips erhalten. Die Liste schließt kurz nach Verlassen des Mausbereichs und kann dank geschützter WoW-Handler auch im Kampf geöffnet werden. Bei mehr als 15 Spielern einer Klasse entstehen weitere Spalten. Die einzelnen Spieler sind direkt anklickbar; das Mausrad ändert die eigene Klassenzuweisung oder Spieler-Ausnahme außerhalb des Kampfes.

**Einzelne Selbstbuff-Felder:** Im Zorn-Feld wirken Links- und Rechtsklick ausschließlich Zorn der Gerechtigkeit. Das separate Siegel-Feld wirkt mit beiden Klicks das ausgewählte Siegel; sein Mausrad wählt das Siegel. Ein aktives Siegel erscheint bis zum tatsächlichen Ablauf grün, auch bei weniger als vier Minuten Restzeit; ein fehlendes Siegel rot und ein unbekannter Zustand grau. Das Aura-Feld wirkt die gewählte Aura; sein Mausrad wählt sie aus.

Die Aura-Auswahl erkennt alle gelernten Ränge der acht vorgesehenen Aura-Typen (Hingabe, Vergeltung, Konzentration, Schatten-/Frost-/Feuerwiderstand, Heiligkeit und Kreuzfahrer). Es genügt, dass der aktuelle höhere Rang gelernt ist; Rang 1 muss nicht mehr als bekannt gemeldet werden. Ein Zauberbuch-Abgleich per lokalisiertem Aura-Namen berücksichtigt auch abweichende Rang-/Ersatz-IDs des Clients. Ungelernte, passive, fremde Spezialisierungs- und ausdrücklich als künftig markierte Zauberbucheinträge werden dabei nicht angeboten. Die Erkennung wird bei Login und `SPELLS_CHANGED` aktualisiert und für kleine Leiste, Zuweisungsfenster und Aura-Synchronisierung gemeinsam verwendet. Gespeicherte Aura-Zuweisungen behalten ihre bisherigen Nummern.

**Verschieben:** Den kleinen Pfeilbutton oben links mit der linken Maustaste halten und ziehen. Er verschiebt die komplette Anzeige einschließlich der zugehörigen Spielerlisten. Die Position bleibt nach `/reload` erhalten. Während eines Kampfes ist Verschieben gesperrt.

**Zuweisungen bearbeiten:** `/ftpp`, das kleine Optionssymbol im Kopf der Leiste oder unter `/ad` die Aktion **„Paladin-Zuweisungen öffnen“**. Die Ansicht folgt dem bereitgestellten PallyPower-Screenshot: dunkler Hintergrund mit Raster, Aura- und Klassensymbole im Kopf, darunter eine Zeile pro Paladin. Die Aura steht in der ersten Symbolspalte, die neun Klassen rechts daneben. Links erscheinen Name, eigene Symbolanzahl, bekannte Segen, Rettungsschalter und Verbindungs-/Datenstatus. Unten stehen „Freie Zuweisung“, „Optionen“, „Auto-Zuweisung“, „Löschen“ und „Aktualisieren“. Die Breite beträgt 912 UI-Punkte, bei einem Paladin die Höhe 205; ab sechs Paladinen wird mit dem Mausrad über dem Tabellenhintergrund gescrollt. Die Buffleiste und ihre Zauberauslösung bleiben unabhängig von dieser Ansicht.

Links- oder Rechtsklick sowie Mausrad auf einer Segenszelle wechseln die Zuweisung des Paladins in dieser Zeile vorwärts/rückwärts. Die Aura-Zelle funktioniert ebenso. Fremde Zellen sind ohne passende Rechte/Freigabe deaktiviert. Der Rettungsschalter ändert nur deine eigene Einstellung. „Löschen“ entfernt nur Zuweisungen von Paladinen, die du steuern darfst; „Aktualisieren“ fragt die Gruppe erneut ab. „Optionen“ öffnet die bisherige Detailansicht mit Spieler-Ausnahmen, Voreinstellung und weiteren Funktionen. Beide Ansichten starten nach Login/Reload geschlossen. Ihr Schließen lässt die kleine Buffleiste sichtbar. Zuweisungen und eine Voreinstellung werden pro Charakter gespeichert.

- In der Tabelle den Segen direkt in der gewünschten Paladin-Zeile und Klassen-Spalte ändern. In der Detailansicht unter „Optionen“ lässt sich weiterhin oben der gewünschte Paladin auswählen. Rettung gehört wie in der Forever-Vorlage nicht zum normalen Segenzyklus.
- Die Buffschaltflächen wirken immer **deine** Zuweisungen: links großer Segen, falls gelernt, andernfalls normal; rechts normal. Spieler-Ausnahmen erhalten immer normale Segen. Ein Mausradschritt auf einer Spieler-Buffschaltfläche ändert dessen Ausnahme für den oben ausgewählten Paladin; „keine Ausnahme“ verwendet wieder die Klassenzuweisung.
- „Nächster Buff“ und die Klassen-„Buff“-Schaltflächen wählen außerhalb des Kampfes erreichbare, lebende Spieler aus. Fehlende Segen haben Vorrang. Die Vier-Minuten-Option steuert die automatische Empfehlung. **Ein Klassenfeld bleibt zusätzlich manuell anklickbar**, wenn alle Segen bereits länger laufen oder der Aura-Status unbekannt ist: Es erhält dafür weiterhin ein lebendes, verbundenes Ziel der Klasse. Bei unbekannter Reichweite darf ein bewusster Klick den Zauber versuchen; eine ausdrücklich gemeldete Reichweitenüberschreitung wird bei der Klassen-Zielwahl ausgeschlossen. Einzelne Spieler bleiben ebenfalls gezielt anklickbar.
- Die Segens-Schaltflächen verwenden geschützte, namensgebundene `/cast`-Aktionen wie die mitgelieferte Forever-PallyPower-Version. Damit bleibt das konkrete Ziel einschließlich Nachnamen festgelegt. Links wirkt den großen Segen, sofern gelernt und ohne Spieler-Ausnahme, andernfalls den normalen; rechts wirkt den normalen. Außerhalb des Kampfes wird die Belegung vorbereitet, im Kampf bleibt sie unverändert. Ein vorhandener Buff entfernt die manuelle Klassen-Zauberbelegung nicht mehr.
- Separate Rettungs-Schaltflächen über `/ad` aktivieren. Die Spielerschaltfläche wirkt normale Rettung; „Rettung: nächster Spieler“ verwendet links große Rettung, wenn gelernt und die Zielklasse keinen Tank enthält, sonst normale Rettung. Rechtsklick wirkt normal. Tanks werden durch die Vorschlagsfunktion und die Spieler-Rettungsbuttons ausgeschlossen.
- Aura und Siegel mit dem Mausrad an ihrer Schaltfläche auswählen, durch Klick wirken. Zorn der Gerechtigkeit hat eine eigene Schaltfläche. Die Aura-Zuweisung des ausgewählten Paladins lässt sich unten links vorwärts/rückwärts schalten.
- Bufflaufzeiten: rot = fehlt, gelb = unter vier Minuten, grün = aktiv, grau/`?` = unbekannt. Bei eingeschränkten Aura-Daten zählen nur zuvor tatsächlich gemessene Laufzeiten weiter. Ein unbekannter Buff wird nicht als frisch gewirkt angenommen.
- „Auto-Zuweisung“ verteilt bekannte Segen nach Klassenpräferenz ohne doppelte Segen, soweit mögliche Zuweisungen und bekannte Fähigkeiten das erlauben. Für andere Paladine benötigst du Gruppenleiter-/Assistentenrechte oder deren Freigabe. Aura-Zuweisungen werden manuell gewählt.
- „Speichern“/„Laden“ verwalten eine eigene Voreinstellung aus Klassenzuweisungen, Spieler-Ausnahmen, Aura und Siegel. „Abgleichen“ fragt die Gruppe nach ihren Zuweisungen und meldet deine eigenen.

Die Synchronisierung verwendet den `PLPWR`-Nachrichtenaufbau der gelieferten Forever-Version (`SELF`, `ASELF`, `ASSIGN`, `PASSIGN`, `MASSIGN`, `NASSIGN`, `AASSIGN`, `CLEAR`, `FREEASSIGN`, `REQ`). Fremde Zuweisungen werden nur von aktuellen Gruppenmitgliedern mit passenden Rechten übernommen. Vor- und Nachnamen bleiben erhalten. Versand wird zeitlich begrenzt. Die Kompatibilität ist mit simulierten Nachrichten getestet, noch nicht mit einem zweiten Spieler im laufenden Client.

**Im Kampf:** Vorbereitete Spieler und Zauber bleiben fest. Neue Ziele, Zuweisungen, Öffnen/Schließen und Abschalten des Fensters werden bis zum Kampfende aufgeschoben. Bereits vorbereitete Zauberschaltflächen können bis dahin weiter angeklickt werden. Jeder Zauber erfordert einen eigenen Klick. Das Modul wirkt keine Zauber selbständig.

Der Nachbau übernimmt nicht sämtliche Zusatzfunktionen der Vorlage: deren Skins, Ace-Profile, Gruppenberichte, Tastenkürzel, Reagenzienzählung und Cooldownübersicht sind nicht Bestandteil dieser Umsetzung. Das eigenständige PallyPower wird nicht verändert oder abgeschaltet. Für die Nutzung des Nachbaus allein kannst du es in WoWs Addon-Auswahl deaktivieren; gleichzeitiger Betrieb kann doppelte Oberflächen und Synchronisierungsnachrichten erzeugen.

**Prüfung:** Verhaltenstests mit Lua 5.1 prüfen die geschützten Schaltflächen, Kampfverhalten, Rollen-/Reichweitenfilter, Aura-Zwischenspeicher, Zuweisungsrechte, Protokoll und Voreinstellungen. Im Client noch zu prüfen: `/reload`, `/ftpp`, zuerst einen eigenen Segen auswählen und auf dich wirken, dann Gruppenmitglieder sowie Links-/Rechtsklick und Kampfverhalten prüfen.

## GTFO: Gefahrenwarnungen

Eigenständige Warntechnik nach dem bereitgestellten **GTFO 6.11** (Zensunim of Dragonblight; Classic: Myzrael). Die vier Alarmdateien aus der Vorlage sind unter `Sounds/GTFO` enthalten. Das ursprüngliche Addon muss nicht zusätzlich installiert sein.

**Wichtige Datengrundlage:** Die im Forever-TOC der Vorlage geladenen Dateien `GTFO_Spells_Forever.lua` und `GTFO_Fail_Forever.lua` sind leer. Deshalb ist auch hier keine vollständige Forever-Boss-/Flächenabdeckung vorgegeben. Das Modul erfindet keine Warnzauber und behandelt nicht jeden erlittenen Schaden als vermeidbar.

- Unter `/ad` das eigenständige Modul „GTFO: Gefahrenwarnungen“ sowie hohen Schaden, niedrigen Schaden, Fehlertreffer und Mitspieler-Schaden einzeln schalten. Anfangs aktiviert. Vier Testknöpfe spielen die unterschiedlichen Alarmarten ab.
- **`/ftgtfo test 1`** (alternativ 2, 3, 4): Warnton über den Master-Kanal testen. Die Lautstärke-/Stummschalteinstellungen des Spiels werden nicht geändert.
- **`/ftgtfo`**: Anzahl aktiver Regeln und nativer Tonregistrierungen sowie Befehlshilfe anzeigen.
- **`/ftgtfo add ZAUBERID high|low|fail|friendly`**: eigene Warnregel für einen bekannten Gefahrenzauber hinzufügen, z. B. `/ftgtfo add 123456 high`. Die ID im Beispiel ist ein Platzhalter und muss durch eine tatsächliche Gefahren-ID ersetzt werden. Regeln werden accountweit gespeichert. **`/ftgtfo remove ZAUBERID`** entfernt eine eigene Regel.
- Erschöpfungsgebiete und auslaufende Atemluft werden über WoWs Spiegel-Timer erkannt. Lava-/Feuerschäden werden zusätzlich ausgewertet, soweit der Client lesbare Kampflogdaten liefert. Fallschaden löst keinen Alarm aus.
- Die Classic-Liste mit **23 importierten Regeln** lässt sich separat einschalten. Sie ist **standardmäßig aktiviert** und wird beim ersten Reload dieses Updates auch für vorhandene Einstellungen eingeschaltet. Danach bleibt ein manuelles Abschalten gespeichert. Die IDs und Mechaniken sind für Forever weiterhin unbestätigt. Experimentelle Einträge der Vorlage werden ausgelassen. Tank-Ausnahmen, bestimmte NPC-Quellen, Mindestschaden und triviale Schadensanteile bleiben berücksichtigt, soweit lesbare Daten dafür vorliegen.
- Forever sperrt die Registrierung des Kampflog-Ereignisses. Das Modul versucht diese Registrierung auf Forever und modernen eingeschränkten Clients deshalb nicht. `pcall` würde die Blizzard-Blockierungswarnung nicht verhindern. Die Classic-Liste bleibt aktiv und wird weiter für nutzbare Aura-Warnwege verwendet; Regeln, die zwingend Kampflog-Schadensdaten benötigen, können auf Forever nicht ausgewertet werden. `/ftgtfo` zeigt diesen Status an.
- Verfügbare native Aura-Töne (`AddAuraSound`, andernfalls private Auren) werden genutzt. Alternativ werden ausschließlich konfigurierte, lesbare schädliche Spieler-Auren geprüft. Verborgene Werte werden nicht umgangen. Regeln, die Schadenshöhe oder bestimmte Quellen benötigen, werden nicht allein aus einer Aura erraten.
- Zusatztext erscheint bei vom Modul ausgewerteten Warnungen, wenn „Warnmeldung“ aktiv ist. Native Aura-Töne werden vom Spiel abgespielt und erzeugen hier keinen zusätzlichen Textcallback. Wiederholungen des Lua-Warnwegs sind auf einen Alarm pro 0,8 Sekunden begrenzt.

Das Abschalten stoppt den Lua-Warnweg und den zuletzt gestarteten Ton sofort. Änderungen an nativen Aura-Tönen dürfen bei Kampf-/Instanzbeschränkungen gegebenenfalls erst nach deren Ende registriert oder entfernt werden; bis dahin kann eine zuvor registrierte native Warnung weiter ausgelöst werden. `/ftgtfo` zeigt ausstehende Änderungen an. Gleichzeitig aktiviertes Original-GTFO kann eigene zusätzliche Töne erzeugen.

Mit simulierten APIs geprüft sind Warnkategorien, eigene Regeln, Tank-/Quellenfilter, deaktivierte Kategorien, Tonbegrenzung, native Registrierungen, deren Aufschub, geheime Werte und Umwelttimer. Ein Test im laufenden Forever-Client steht noch aus. Nach `/reload` zuerst die vier Töne testen; mechanikspezifische Warnungen benötigen passende Regeln.

## Threat Plates: Namensplaketten

Eigenständiger Nachbau der Kernanzeige des bereitgestellten **Threat Plates 13.3.0-beta6** (Suicidal Katt, Blacksalsify). Unter `/ad` als Modul **„Threat Plates: Namensplaketten“** schaltbar, anfangs aktiviert. Namensplaketten selbst mit **V** im Spiel ein-/ausblenden. Das Modul verändert dafür keine CVars und keine gespeicherten Sichtbarkeitseinstellungen des Spiels.

- Gegner erhalten Bedrohungsfarben. Als Schadensverursacher bedeutet Grün wenig Bedrohung, Gelb steigende/unsichere Bedrohung und Rot Aggro. Als Tank ist sichere Aggro grün und fehlende Aggro rot. Die Farben greifen bei lesbarem Bedrohungsstatus und erkennbarer Kampfbeteiligung.
- Automatische Tankerkennung über die Gruppenrolle und WoWs `UnitHasEffectivelyTankAura`, außerhalb des Kampfes zusätzlich über lesbaren Zorn der Gerechtigkeit. Bei eingeschränkten Rollen-/Auradaten im Kampf bleibt die zuletzt bekannte Rolle erhalten. Alternativ Automatik ausschalten und den manuellen Tank-Schalter verwenden.
- Spieler erhalten optional ihre Klassenfarbe, belegte Gegner Grau und andere Einheiten ihre Reaktionsfarbe. Die nativen Auswahltexturen am Lebensbalken und am Level werden transparent gehalten, auch wenn der Client sie erneut einblendet. Leveltext und Lebensbalken bleiben erhalten.
- Lebenswerte erscheinen im nativen Lebensbalken: beim anvisierten Ziel als Prozentzahl und voller aktueller Lebenswert (z. B. `75% · 12.345`), bei anderen Einheiten als Prozentzahl. Für das anvisierte Ziel wird bevorzugt der `target`-Token verwendet. Verborgene Werte werden ohne Lua-Berechnung über `UnitHealthPercent` und native Textformatierung angezeigt; dabei entfällt die eigene Tausendertrennung. Wenn die erforderliche Anzeige-API fehlt, wird nur der verfügbare Wert angezeigt. Ein verborgener Bedrohungsstatus wird nicht als „keine Bedrohung“ interpretiert.
- Flache Lebensbalkentextur und optional flache native Zauberleiste. **Lebensbalkenfüllung, Absorptionen, Zauberfortschritt, Unterbrechungsanzeige, Namen, Symbole und Klickziele bleiben beim Spiel.** Das Modul ersetzt diese Daten-/Aktionslogik nicht.
- Freundliche Plaketten werden anfangs nicht bearbeitet; optional nur außerhalb von Instanzen. Persönliche und gesperrte/forbidden Namensplaketten bleiben ausgenommen. Bei wiederverwendeten oder nachträglich aufgebauten Plaketten werden alte Bindungen gelöst und neue Einheiten zugeordnet.
- Beim Abschalten werden die ursprünglichen Balkenfarben, Texturen und die Transparenz der nativen Auswahlrahmen wiederhergestellt; die eigenen Texte werden ausgeblendet. Sichere Hooks bleiben registriert, bewirken bei deaktiviertem Modul aber keine Änderungen.

Der Nachbau verwendet keine Bibliotheken oder Grafiken des Originaladdons. Dessen zusätzliche Aura-/Quest-/Ressourcen-Widgets, individuelle NPC-Profile, Skripte, Skins, Offtank-Heuristiken, Namensplakettenskalierungen und vollständiger Optionseditor sind nicht Teil dieses Moduls. Nativ angezeigte entsprechende Informationen bleiben bestehen. Ist das ursprüngliche Threat Plates ebenfalls aktiviert, kann es die native Anzeige ausblenden oder überschreiben; für die Nutzung dieses Nachbaus das Original in WoWs Addon-Auswahl deaktivieren.

Mit simulierten APIs geprüft: Tank-/Schadensfarben, native Auswahltexturen einschließlich erneuter Client-Einblendung und Wiederherstellung, Klassenfarben, native Formatierung geheimer Lebenswerte, Plaketten-Recycling, nachträglich verfügbare Frames, Farben-/Texturwiederherstellung und Rückkehr zu nativen Zauberleisten. Im Spiel noch zu prüfen: `/reload`, Gegnerplaketten mit V einschalten, Gegner auswählen, einen Kampf beginnen, Rolle wechseln sowie Modul und Einzelfunktionen unter `/ad` testen.

## Decursive: Reinigung

Eigenständiger Nachbau des Reinigungskerns von **Decursive 2.9.0-RC3** (John Wellesz). Unter `/ad` als **„Decursive: Reinigung“** schaltbar und anfangs aktiviert. Sobald der Charakter einen unterstützten Reinigungszauber gelernt hat, erscheinen die Reinigungsfelder ohne Kopfzeile unterhalb der Bildschirmmitte, solo, in Gruppe und im Schlachtzug. Zum Verschieben außerhalb des Kampfes die **rechte Maustaste auf einem Feld halten und ziehen**. Die Position wird gespeichert. Ein kurzer Klick verwendet weiterhin die im Tooltip angegebene Reinigungsbelegung.

- Bis zu 40 kleine Gruppenfelder. Name und Tooltip zeigen die Einheit; Farbe und Tooltip erklären den nötigen Klick. **Rot = Linksklick**, **Blau = Rechtsklick**. Zusätzliche vorbereitete Belegungen sind Gelb/Umschalt-Linksklick und Violett/Umschalt-Rechtsklick. Die unterstützten Classic-Klassen benötigen höchstens zwei Zauber.
- Paladin: Reinigung beziehungsweise Läuterung; Priester: Magiebannung und Krankheitsreinigung; Druide: Fluch-/Giftreinigung; Magier: Fluchreinigung; Schamane: Krankheits-/Giftreinigung. Nur gelernte Fähigkeiten werden zugewiesen. Fähigkeiten, die mehrere Typen entfernen, teilen sich eine Klickbelegung.
- Beim Paladin entfernt ein **Linksklick** auf ein rotes Gruppenfeld den entsprechenden Effekt mit Reinigung, sofern gelernt. Der gewirkte Zauber bestimmt selbst, welchen passenden Effekt er entfernt.
- Native AuraContainer zeigen verborgene Effekte farbig an. Ohne diese API werden unlesbare Zustände als `?` markiert; lesbare Effekte funktionieren weiter. `D` = tot, `OFF` = offline, `R` = bekannte fehlende Reichweite bei einem lesbaren Auftrag.
- `/ad` enthält getrennte Schalter für Magie, Fluch, Krankheit, Gift, Soloanzeige und Warnton. Der Ton meldet neue lesbare Aufträge mit mindestens drei Sekunden Abstand; für verborgene Effekte gibt es keinen allgemeinen Lua-Warnton.
- `/ftdcr` erklärt die aktuellen Belegungen, `/ftdcr reset` setzt die Position zurück. Einstellungen und Position bleiben gespeichert. Gruppenfelder verwenden feste Einheitentokens und sichere Sichtbarkeitstreiber. Änderungen an geschützten Belegungen, Position und Sichtbarkeit werden während des Kampfes bis Kampfende aufgeschoben.

Die Umsetzung umfasst Gruppenreinigung. Die vollständigen Optionen, Prioritäts-/Ignorierlisten, Haustierzauber, offensives Entzaubern, Gedankenkontrolle, Spezialregeln einzelner Begegnungen und moderne Talentvarianten der Vorlage sind nicht enthalten. Das Originaladdon wird nicht verändert. Die Prüfung mit simulierten APIs ist erfolgt; tatsächliche Klickzauber und native Aura-Farben müssen nach `/reload` im Spiel getestet werden.

## Weitere Module ergänzen

`Core.lua` verwaltet Registrierung und gespeicherte Einstellungen. `Menu.lua` erzeugt die Auswahlkästchen aus den registrierten Modulen. `Modules/Merchant.lua` enthält das erste Modul.

Neue Lua-Datei vor `Menu.lua` in beiden TOC-Dateien (`ForeverTools.toc` und `ForeverTools_Camelot.toc`) eintragen:

```lua
local _, FT = ...
local module = {
    title = "Mein neues Modul",
    description = "Beschreibung seiner Funktion.",
    defaults = {example = true},
    options = {{key = "example", title = "Beispieloption"}},
}

function module:Initialize()
    -- self.settings enthält die gespeicherten Optionen.
    -- Vor Aktionen FT:IsEnabled("example") prüfen.
end

function module:OnSettingsChanged()
    -- Bei Bedarf laufende Aktionen abbrechen oder Optionen anwenden.
end

FT:RegisterModule("example", module)
```

Das neue Modul erhält automatisch ein eigenes Häkchen. Diese Modulverwaltung steuert die Funktionen der ForeverTools-Sammlung; fremde installierte Addons werden darüber nicht entladen.

## Prüfung

Die mitgelieferten Verhaltenstests unter `../tests/test_forevertools.py` laufen in Lua 5.1 mit simulierten WoW-APIs. Sie prüfen unter anderem Goldmangel, die Reihenfolge der Aktionen, ausstehende Verkäufe, Gegenstandssperren, Kampf und die Modulschalter. Für „Taschen aufräumen“ werden der einmalige native Aufruf, Fehler und der Start ohne Verzögerung pro Gegenstand geprüft; WoWs eigene Sortierlogik wird nicht nachgebaut. Die Testlaufzeit gehört nicht in den Spielordner.

Die bisherige Taschenfunktion wurde vom Benutzer im Spiel erfolgreich getestet. **Der Wechsel auf WoWs integrierte Funktion muss noch im Spiel geprüft werden.**

Für den ersten Spieltest: einen grauen Gegenstand und einen höherwertigen Gegenstand mitnehmen, Taschenlücken schaffen, einen Reparaturhändler öffnen und danach Verkauf, Reparatur, Taschenpositionen sowie jedes Häkchen einzeln prüfen. Bei einer Fehlermeldung mit `/console scriptErrors 1` die Fehleranzeige aktivieren und die Meldung sichern.

API-Referenz: [Container-API im WoW-UI-Quelltext](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/ContainerDocumentation.lua). Versions-/Interface-Abgleich: [Forever-Addon-Manager](https://github.com/julius-retzer/forever-addons).
