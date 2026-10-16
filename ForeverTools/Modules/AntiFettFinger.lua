local _, FT = ...
local M={
    title="Anti Fett Finger",
    description="Im Kampf nur 1 bis ´ und Bewegung. Änderungen im Kampf gelten nach Kampfende.",
}
FT:RegisterModule("antifettfinger",M)

function M:IsAvailable()
    return AntiFettFinger and AntiFettFinger.db and type(AntiFettFinger.SetEnabled)=="function" or false
end

function M:Sync()
    self.settings.enabled=self:IsAvailable() and AntiFettFinger:IsEnabled() or false
    if FT.menu then FT.menu:Refresh() end
end

function M:Bind()
    if self:IsAvailable() and self.bound~=AntiFettFinger then
        self.bound=AntiFettFinger
        AntiFettFinger:RegisterStateListener(function() self:Sync() end)
    end
    self:Sync()
end

function M:OnSettingsChanged()
    if not self:IsAvailable() then
        self:Sync(); FT:Print("Anti Fett Finger ist noch nicht bereit.")
        return
    end
    if not AntiFettFinger:SetEnabled(self.settings.enabled) then
        FT:Print("Anti Fett Finger: Änderung gilt nach Kampfende.")
    end
    self:Sync()
end

function M:Initialize()
    local frame=CreateFrame("Frame"); self.frame=frame
    frame:RegisterEvent("ADDON_LOADED"); frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:SetScript("OnEvent",function(_,event,name)
        if event=="PLAYER_ENTERING_WORLD" or name=="AntiFettFinger" then self:Bind() end
    end)
    self:Bind()
end
