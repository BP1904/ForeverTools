local _, FT = ...

function FT:RequestUpdate()
    if InCombatLockdown() then
        self:Print("Updates bitte außerhalb des Kampfes anfordern.")
        return
    end
    self.db.updateRequest = math.max(time(), (tonumber(self.db.updateRequest) or 0) + 1)
    self.db.updatePending = true
    ReloadUI()
end

function FT:PrintUpdateStatus()
    if not self.db.updatePending then return end
    if self.updateStatus and tonumber(self.updateStatus.request) == self.db.updateRequest then
        self.db.updatePending = nil
        self:Print("Update installiert und geladen (" .. self.updateStatus.commit .. ").")
    else
        self:Print("Update angefordert: Windows-Meldung 'Update fertig' abwarten, danach nochmals /reload eingeben. Bleibt die Meldung aus: Update.cmd im installierten ForeverTools-Ordner starten und Update erneut anklicken.")
    end
end

function FT:ShowUpdates()
    self:RequestUpdate()
end
