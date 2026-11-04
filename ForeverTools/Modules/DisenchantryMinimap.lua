-- Optional launcher, owned by the common module settings; no broker dependency.
local _, FT = ...
local M=FT.modules.disenchantry
M.defaults=M.defaults or {}; M.defaults.showMinimap=false
M.options=M.options or {}
M.options[#M.options+1]={key="showMinimap",title="Eigenes Disenchantry-Minimapsymbol anzeigen"}

function M:PlaceMinimapButton()
    if not self.minimapButton or not Minimap then return end
    local angle=tonumber(self.settings.minimapAngle)
    if not angle then
        local old=FT.disenchantry.App and FT.disenchantry.App.db
        angle=old and old.minimap and tonumber(old.minimap.minimapPos) or 200
    end
    local radius=(Minimap:GetWidth() or 140)/2+8
    self.minimapButton:ClearAllPoints()
    self.minimapButton:SetPoint("CENTER",Minimap,"CENTER",math.cos(math.rad(angle))*radius,math.sin(math.rad(angle))*radius)
end
function M:DragMinimapButton()
    local x,y=GetCursorPosition()
    local cx,cy=Minimap:GetCenter()
    if not cx or not cy then return end
    local scale=Minimap:GetEffectiveScale()
    x,y=x/scale-cx,y/scale-cy
    local angle
    if math.atan2 then angle=math.atan2(y,x)
    elseif x==0 then angle=y>=0 and math.pi/2 or -math.pi/2
    else angle=math.atan(y/x); if x<0 then angle=angle+math.pi end end
    self.settings.minimapAngle=math.deg(angle)%360
    self:PlaceMinimapButton()
end
function M:UpdateMinimapButton()
    local shown=self.settings and self.settings.showMinimap and FT:IsEnabled("disenchantry") and not self.legacyBlocked
    if not shown then
        if self.minimapButton then
            self.minimapButton:SetScript("OnUpdate",nil)
            self.minimapButton:Hide()
        end
        return
    end
    if not Minimap then return end
    if not self.minimapButton then
        if InCombatLockdown and InCombatLockdown() then return end
        local button=CreateFrame("Button","ForeverToolsDisenchantryMinimap",Minimap)
        self.minimapButton=button
        button:SetSize(30,30); button:SetFrameStrata("MEDIUM")
        button:SetNormalTexture(136244)
        button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        button:RegisterForClicks("LeftButtonUp","RightButtonUp")
        button:RegisterForDrag("LeftButton")
        button:SetScript("OnClick",function(_,mouse)
            if not FT:IsEnabled("disenchantry") or not self.settings.showMinimap then return end
            if mouse=="RightButton" then self:Open("settings") else self:Open() end
        end)
        button:SetScript("OnDragStart",function(b)
            if InCombatLockdown and InCombatLockdown() then return end
            b:SetScript("OnUpdate",function() self:DragMinimapButton() end)
        end)
        button:SetScript("OnDragStop",function(b) b:SetScript("OnUpdate",nil); self:DragMinimapButton() end)
        button:SetScript("OnEnter",function(b)
            if not GameTooltip then return end
            GameTooltip:SetOwner(b,"ANCHOR_LEFT")
            GameTooltip:AddLine("Disenchantry – ForeverTools",1,0.82,0)
            GameTooltip:AddLine("Linksklick: öffnen. Rechtsklick: Einstellungen.",1,1,1)
            GameTooltip:AddLine("Ziehen: Position ändern. Ausblenden im /ad-Menü.",0.7,0.7,0.7)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave",function(b)
            if GameTooltip and GameTooltip.IsOwned and GameTooltip:IsOwned(b) then GameTooltip:Hide() end
        end)
        button:SetScript("OnHide",function(b)
            b:SetScript("OnUpdate",nil)
            if GameTooltip and GameTooltip.IsOwned and GameTooltip:IsOwned(b) then GameTooltip:Hide() end
        end)
    end
    self:PlaceMinimapButton(); self.minimapButton:Show()
end
local Initialize=M.Initialize
function M:Initialize()
    Initialize(self)
    if self.frame then
        for _,event in ipairs({"PLAYER_ENTERING_WORLD","UI_SCALE_CHANGED","DISPLAY_SIZE_CHANGED","MINIMAP_UPDATE_ZOOM"}) do
            pcall(self.frame.RegisterEvent,self.frame,event)
        end
    end
    self:UpdateMinimapButton()
end
local Changed=M.OnSettingsChanged
function M:OnSettingsChanged()
    Changed(self); self:UpdateMinimapButton()
end
local Event=M.OnEvent
function M:OnEvent(event,...)
    if event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_REGEN_ENABLED" or event=="UI_SCALE_CHANGED"
        or event=="DISPLAY_SIZE_CHANGED" or event=="MINIMAP_UPDATE_ZOOM" then self:UpdateMinimapButton() end
    return Event(self,event,...)
end
