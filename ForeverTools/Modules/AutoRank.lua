local _,FT=...
local M={
    title="Auto Rank",
    description="Höchste gelernte Ränge auf Aktionsleisten. Neue Fähigkeiten auf freie Plätze; Änderungen erst außerhalb des Kampfes.",
}
FT:RegisterModule("autorank",M)
function M:IsAvailable()
    return AutoRank and AutoRank.db and type(AutoRank.SetEnabled)=="function" or false
end
function M:Sync()
    self.settings.enabled=self:IsAvailable() and AutoRank:IsEnabled() or false
    if FT.menu then FT.menu:Refresh() end
end
function M:Bind()
    if self:IsAvailable() and self.bound~=AutoRank then
        self.bound=AutoRank; AutoRank:RegisterStateListener(function() self:Sync() end)
    end
    self:Sync()
end
function M:OnSettingsChanged()
    if self:IsAvailable() then AutoRank:SetEnabled(self.settings.enabled) end
    self:Sync()
end
M.actions={
    {title="Zauberränge jetzt prüfen",run=function() if M:IsAvailable() then AutoRank:Command("scan") end end},
    {title="Alle fehlenden Fähigkeiten ergänzen",run=function() if M:IsAvailable() then AutoRank:Command("fill") end end},
}
function M:Initialize()
    local frame=CreateFrame("Frame"); self.frame=frame
    frame:RegisterEvent("ADDON_LOADED"); frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:SetScript("OnEvent",function(_,event,name)
        if event=="PLAYER_ENTERING_WORLD" or name=="AutoRank" then self:Bind() end
    end)
    self:Bind()
end
