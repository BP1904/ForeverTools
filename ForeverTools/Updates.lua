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
        text = "ForeverTools mit allen Modulen aktualisieren\n\n1. ForeverTools-Updater.cmd in Windows starten und geöffnet lassen.\n2. Jetzt Update anfordern: Die Oberfläche wird neu geladen.\n3. Auf die Erfolgsmeldung im Updater warten, dann /reload eingeben.\n\nAlle Module einschließlich Anti Fett Finger und Auto Rank gehören zu diesem einen Addon. Ohne Windows-Updater erfolgt kein Download.",
        button1 = "Update anfordern",
        button2 = "Abbrechen",
        OnAccept = function() FT:RequestUpdate() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
end
