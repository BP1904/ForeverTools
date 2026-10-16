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
        text = "Alle ForeverTools-Module aktualisieren\n\n1. In Windows Interface\\AddOns\\ForeverTools öffnen.\n2. Update.cmd doppelklicken und auf ERFOLG warten.\n3. Hier auf Neu laden klicken.\n\nDer Spielordner wird automatisch erkannt. Der Download erfolgt durch Update.cmd außerhalb des Spiels.",
        button1 = "Neu laden",
        button2 = "Abbrechen",
        OnAccept = function()
            if InCombatLockdown() then FT:Print("Neu laden bitte außerhalb des Kampfes.")
            else ReloadUI() end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
end
