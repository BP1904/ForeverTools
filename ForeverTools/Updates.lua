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
    self:RequestUpdate()
end
