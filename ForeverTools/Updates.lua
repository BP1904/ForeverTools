local _, FT = ...

function FT:RequestUpdate()
    if InCombatLockdown() then
        self:Print("Updates bitte außerhalb des Kampfes anfordern.")
        return
    end
    self.db.updateRequest = math.max(time(), (tonumber(self.db.updateRequest) or 0) + 1)
    ReloadUI()
end

function FT:ShowUpdates()
    if InCombatLockdown() then
        self:Print("Updates bitte außerhalb des Kampfes anfordern.")
        return
    end
    StaticPopup_Show("FOREVERTOOLS_UPDATE")
end

if StaticPopupDialogs then
    StaticPopupDialogs.FOREVERTOOLS_UPDATE = {
        text = "Alle ForeverTools-Module jetzt aktualisieren?\n\nDie Oberfläche wird neu geladen und der Windows-Helfer erhält den Update-Auftrag. Nach seiner Fertigmeldung bitte /reload eingeben.\n\nVoraussetzung: Update.cmd nach dem Windows-Start einmal starten. Der Helfer läuft anschließend im Hintergrund; erkennbar am Symbol neben der Windows-Uhr.",
        button1 = "Jetzt aktualisieren",
        button2 = "Abbrechen",
        OnAccept = function() FT:RequestUpdate() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
end
