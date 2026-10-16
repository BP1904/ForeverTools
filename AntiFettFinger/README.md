# Anti Fett Finger

Eigenständiges Addon für WoW Forever 1.60.1, Interface 16001. Standardmäßig eingeschaltet, Einstellungen pro Charakter. ForeverTools ist keine Voraussetzung.

## Verhalten

- Außerhalb des Kampfes gelten deine normalen Tastenbelegungen.
- Im Kampf bleiben die zwölf unmodifizierten Tasten der oberen Reihe **1, 2, 3, 4, 5, 6, 7, 8, 9, 0, ß, ´** frei. WoW bezeichnet die letzten beiden Tasten intern als `-` und `=`. Die bisherigen Aktionen dieser Tasten werden weiterverwendet; Aktionsleisten und Zauber werden nicht umbelegt.
- Deine belegten Bewegungsfunktionen bleiben nutzbar: vorwärts/rückwärts, seitwärts, drehen, springen, automatisches Laufen und vertikale Bewegung. Auch mit gehaltenen Umschalt-, Strg- und Alt-Tasten bleiben die unmodifiziert belegten Bewegungstasten Bewegungstasten. Falls beispielsweise Umschalt-W sonst eine andere Aktion ausführt, bewegt es im Kampf weiterhin vorwärts.
- Andere Spieltasten werden im Kampf abgefangen, darunter Taschen, Charakterfenster, Tab, Escape und Funktionstasten. Modifizierte Zahlentasten wie Umschalt-1 sind ebenfalls gesperrt, soweit sie nicht ausdrücklich einer Bewegungsfunktion zugewiesen sind.
- Mausklicks, zusätzliche Maustasten und Mausrad bleiben frei. Die Maus kann weiterhin Ziele auswählen, Aktionsleisten anklicken und den Ausschalter bedienen.
- Bei Kampfende wird die gesamte temporäre Sperre automatisch entfernt. Gespeicherte Tastenbelegungen werden nicht verändert.

Die Sperre betrifft Spielbelegungen, keine Betriebssystem-Tastenkombinationen. Fokussierte Texteingabefelder verarbeitet WoW gesondert; das Addon ist keine allgemeine Tastatur- oder Texteingabesperre.

## Bedienung

Oben unter dem Bildschirmrand steht ein kleiner Button:

- **bereit**: eingeschaltet, wartet auf den nächsten Kampf.
- **GESPERRT**: Kampfsperre aktiv.
- **AUS**: ausgeschaltet.

**Linksklick** schaltet ein/aus – auch im Kampf. **Rechte Maustaste halten und ziehen** verschiebt den Button außerhalb des Kampfes. Position und Ein-/Aus-Zustand werden pro Charakter gespeichert.

Wenn ForeverTools geladen ist, gibt es in dessen Übersicht (`/ad`) ein eigenes Häkchen **Anti Fett Finger**. Es steuert dieselbe Einstellung und wird mit dem Mausbutton sowie `/aff on/off` synchronisiert. Ein Umschalten über die Übersicht im Kampf wird bis Kampfende vorgemerkt; der eigene Mausbutton kann dagegen sofort umschalten und ersetzt dabei eine vorgemerkte Änderung. Das separate Addon muss in WoWs Addon-Auswahl aktiviert bleiben.

`/aff` oder `/antifettfinger` zeigt Hilfe. `/aff on` und `/aff off` schalten außerhalb des Kampfes um. Im Kampf dafür den Mausbutton verwenden. `/aff reset` setzt seine Position außerhalb des Kampfes zurück.

Wird die Oberfläche während eines Kampfes neu geladen, wartet die erstmalige Einrichtung geschützter Frames bis Kampfende. Neue Tastenbelegungen werden außerhalb des Kampfes übernommen.

## Installation und Prüfung

Installationsordner: `E:\World of Warcraft\_classic_beta_\Interface\AddOns\AntiFettFinger`. Bei der ersten Installation kann ein kompletter WoW-Neustart nötig sein, damit das neue Addon in der Auswahl erscheint. Danach reichen für Aktualisierungen normalerweise `/reload`.

Die Umsetzung verwendet [Blizzards geschützte Frame-Bindings](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/RestrictedFrames.lua) und einen [Attribute-Handler](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureHandlerTemplates.xml). Der Zustandswechsel und der Maus-Ausschalter führen geschützte Änderungen über sichere Snippets aus. Normale Lua-Ereignisse verändern im Kampf keine geschützten Tastenbelegungen. Es gibt keine Kampflog-Registrierung und keinen Aufruf von `SaveBindings`.

Automatische Tests führen die tatsächlichen Snippets mit simulierten geschützten APIs aus. Geprüft werden Zahlentasten, Bewegungsfunktionen, Modifikatoren, gesperrte Tasten, Maus-Ausschalter im Kampf, Freigabe bei Kampfende, gespeicherter Ausschaltzustand, geänderte Belegungen und Laden im Kampf. Die tatsächliche Eingabeverarbeitung im Forever-Client ist noch nicht im Spiel geprüft.
