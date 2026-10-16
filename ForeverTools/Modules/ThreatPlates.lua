-- Independent implementation of the supplied Threat Plates 13.3.0-beta6 core display.
-- Keeps Blizzard's unit frames, health updates, cast timing and click targets in place.
local _, FT = ...
local M={
    title="Threat Plates: Namensplaketten",
    description="Bedrohungsfarben und Zielleben ohne Auswahlrahmen. Namensplaketten im Spiel mit V einschalten.",
    defaults={threat=true,automaticRole=true,tank=false,classColors=true,healthText=true,castStyle=true,friendly=false},
    options={
        {key="threat",title="Gegner nach Bedrohung einfärben"},
        {key="automaticRole",title="Tankrolle automatisch erkennen"},
        {key="tank",title="Manuell: Tank (Automatik vorher ausschalten)"},
        {key="classColors",title="Spieler in ihrer Klassenfarbe anzeigen"},
        {key="healthText",title="Leben anzeigen (Ziel: Prozent und absolut)"},
        {key="castStyle",title="Native Zauberleiste mit flacher Textur gestalten"},
        {key="friendly",title="Auch freundliche Plaketten außerhalb von Instanzen"},
    },
}
FT:RegisterModule("threatplates",M)
local TEXTURE="Interface\\Buttons\\WHITE8X8"
local function Secret(v) return issecretvalue and issecretvalue(v) end
local function Safe(fn,fallback,...)
    if not fn then return fallback end
    local ok,value=pcall(fn,...)
    if not ok or Secret(value) then return fallback end
    return value
end
-- Raw values may only flow into native display sinks, never comparisons/arithmetic.
local function Raw(fn,...)
    if not fn then return end
    local ok,value=pcall(fn,...)
    if ok then return value end
end
local function Present(value) return Secret(value) or value~=nil end
local function Accessible(frame)
    return frame and not Safe(frame.IsForbidden,true,frame)
end
local function Fields(plate)
    local frame=plate.UnitFrame
    if not Accessible(frame) then return end
    local container=frame.HealthBarsContainer or frame.healthBarsContainer
    local health=frame.healthBar or frame.HealthBar or (container and (container.HealthBar or container.healthBar))
    if not Accessible(health) or not health.SetStatusBarColor then return end
    return frame,health,frame.castBar or frame.CastBar or (frame.CastBarsContainer and frame.CastBarsContainer.castBar)
end

function M:IsTank()
    if not self.settings.automaticRole then return self.settings.tank end
    local role=Safe(UnitGroupRolesAssigned,nil,"player")
    local aura=Safe(UnitHasEffectivelyTankAura,nil,"player")
    if role=="TANK" or aura==true then self.lastTank=true
    elseif aura==false or role=="HEALER" or role=="DAMAGER" then self.lastTank=false
    elseif not InCombatLockdown() then
        local buff=C_UnitAuras and Safe(C_UnitAuras.GetPlayerAuraBySpellID,nil,25780)
        self.lastTank=buff~=nil
    end
    return self.lastTank or false
end

function M:Color(unit)
    if Safe(UnitIsTapDenied,false,unit) then return {0.5,0.5,0.5},"Belegt" end
    local player=Safe(UnitIsPlayer,false,unit)
    local enemy=Safe(UnitCanAttack,nil,"player",unit)
    if self.settings.threat and enemy and not player then
        local status=Safe(UnitThreatSituation,nil,"player",unit)
        local combat=Safe(UnitAffectingCombat,false,unit) or Safe(UnitAffectingCombat,false,"player")
        if combat and type(status)=="number" and status>=0 and status<=3 then
            local tank=self:IsTank()
            if status>=3 then return tank and {0.1,0.85,0.15} or {1,0.12,0.08},"Aggro"
            elseif status>=1 then return {1,0.85,0.1},status==2 and "Aggro unsicher" or "Bedrohung steigt"
            else return tank and {1,0.12,0.08} or {0.1,0.85,0.15},tank and "Keine Aggro" or "Sicher" end
        end
        -- A hidden threat status must not be interpreted as zero/safe threat.
        if combat and status==nil then return nil,nil end
    end
    if self.settings.classColors and player then
        local ok,_,class=pcall(UnitClass,unit)
        if ok and not Secret(class) then
            local color=RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
            if color then return {color.r,color.g,color.b},nil end
        end
    end
    local reaction=Safe(UnitReaction,nil,unit,"player")
    if type(reaction)=="number" then
        if reaction<=3 then return {0.85,0.15,0.12},nil
        elseif reaction==4 then return {0.95,0.8,0.1},nil
        else return {0.15,0.75,0.3},nil end
    end
end

function M:WriteColor(record,color)
    record.writing=true
    pcall(record.health.SetStatusBarColor,record.health,unpack(color))
    record.writing=false
end

function M:Restore(record)
    record.skinActive=false
    record.color=nil
    for _,state in pairs(record.highlights or {}) do
        if state.record==record and state.region.SetAlpha then
            state.writing=true
            pcall(state.region.SetAlpha,state.region,state.alpha)
            state.writing=false
        end
    end
    if record.overlay then record.overlay:Hide() end
    if Accessible(record.health) then
        if record.originalColor then self:WriteColor(record,record.originalColor) end
        if record.originalTexture and record.health.SetStatusBarTexture then
            pcall(record.health.SetStatusBarTexture,record.health,record.originalTexture)
        end
    end
    if record.cast and record.castTexture and Accessible(record.cast) and record.cast.SetStatusBarTexture then
        pcall(record.cast.SetStatusBarTexture,record.cast,record.castTexture)
    end
end

function M:HideNativeHighlights(record)
    local frame=record.plate.UnitFrame
    if not Accessible(frame) then return end
    record.highlights=record.highlights or {}
    local function Hide(region)
        if not region or not region.SetAlpha then return end
        local state=self.highlightStates[region]
        if not state then
            state={region=region,alpha=Safe(region.GetAlpha,1,region)}
            self.highlightStates[region]=state
            local function Enforce()
                if state.writing or not state.record or not state.record.skinActive or not FT:IsEnabled("threatplates") then return end
                state.writing=true; pcall(region.SetAlpha,region,0); state.writing=false
            end
            if hooksecurefunc then
                pcall(hooksecurefunc,region,"SetAlpha",function(_,alpha)
                    if state.writing then return end
                    if not Secret(alpha) then state.alpha=alpha end
                    Enforce()
                end)
                for _,method in ipairs({"Show","SetShown","SetAlphaFromBoolean"}) do
                    if region[method] then pcall(hooksecurefunc,region,method,Enforce) end
                end
            end
        end
        state.record=record; record.highlights[region]=state
        state.writing=true; pcall(region.SetAlpha,region,0); state.writing=false
    end
    -- Hide only native selection art, never health fill, raid marks, level text or absorb art.
    Hide(frame.selectionHighlight); Hide(frame.SelectionHighlight)
    Hide(record.health.selectedBorder); Hide(record.health.selectionHighlight)
    local level=frame.levelFrame or frame.LevelFrame
    if level then Hide(level.selectionHighlight); Hide(level.selectedBorder) end
end

function M:HealthText(record)
    local text=record.percent
    text:SetText("")
    record.healthFormatMode="off"
    if not self.settings.healthText then return end
    local unit=record.unit
    local targeted=Safe(UnitIsUnit,false,unit,"target")
    if not targeted and C_NamePlate then
        targeted=Safe(C_NamePlate.GetNamePlateForUnit,nil,"target")==record.plate
    end
    local displayUnit=targeted and "target" or unit
    local health=Raw(UnitHealth,displayUnit)
    local max=Raw(UnitHealthMax,displayUnit)
    if not Present(health) then health=Raw(UnitHealth,unit); displayUnit=unit end
    if not Present(max) then max=Raw(UnitHealthMax,unit) end
    if not Secret(health) and not Secret(max) and type(health)=="number" and type(max)=="number" and max>0 then
        local percent=math.floor(math.max(0,math.min(100,health*100/max))+0.5).."%"
        if targeted then
            local absolute=("%.0f"):format(math.max(0,health))
            absolute=absolute:reverse():gsub("(%d%d%d)","%1."):reverse():gsub("^%.","")
            percent=percent.." · "..absolute
        end
        text:SetText(percent); record.healthFormatMode="readable"; return
    end
    local curve=CurveConstants and CurveConstants.ScaleTo100 or self.healthPercentCurve
    local percent
    if UnitHealthPercent and curve then percent=Raw(UnitHealthPercent,displayUnit,true,curve) end
    local function Display(format,...)
        -- FontString/string formatting are native secret-aware display operations.
        if text.SetFormattedText and pcall(text.SetFormattedText,text,format,...) then return true end
        local values={...}
        return pcall(function() text:SetText(string.format(format,unpack(values))) end)
    end
    if Present(percent) and targeted and Present(health) then
        if Display("%.0f%% · %.0f",percent,health) then record.healthFormatMode="native-percent-absolute"; return end
    elseif Present(percent) then
        if Display("%.0f%%",percent) then record.healthFormatMode="native-percent"; return end
    end
    if targeted and Present(health) and Display("%.0f",health) then record.healthFormatMode="native-absolute"; return end
    record.healthFormatMode="unavailable"
end

local function OriginalTexture(bar)
    local texture=Safe(bar.GetStatusBarTexture,nil,bar)
    return texture and Safe(texture.GetTexture,nil,texture)
end

function M:CreateRecord(plate,health,cast)
    local record={plate=plate,health=health,cast=cast,originalTexture=OriginalTexture(health)}
    if Accessible(cast) then record.castTexture=OriginalTexture(cast) end
    local ok,r,g,b,a=pcall(health.GetStatusBarColor,health)
    if Secret(a) then a=1 end
    if ok and not Secret(r) and not Secret(g) and not Secret(b) then record.originalColor={r,g,b,a or 1} end
    local overlay=CreateFrame("Frame",nil,health)
    overlay:SetAllPoints(health); overlay:EnableMouse(false)
    overlay:SetFrameLevel(Safe(health.GetFrameLevel,1,health)+4)
    record.overlay=overlay
    local function Text(point,x,y,width)
        local text=overlay:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
        text:SetPoint(point,health,point,x,y); text:SetWidth(width); return text
    end
    record.percent=Text("CENTER",0,0,180)
    if record.percent.SetFont then record.percent:SetFont("Fonts\\FRIZQT__.TTF",11,"OUTLINE") end
    record.threat=Text("BOTTOMLEFT",0,-12,160)
    record.percent:SetJustifyH("CENTER"); record.threat:SetJustifyH("LEFT")
    overlay:Hide()
    if hooksecurefunc then
        hooksecurefunc(health,"SetStatusBarColor",function(_,red,green,blue,alpha)
            if record.writing then return end
            if not Secret(red) and not Secret(green) and not Secret(blue) then
                record.originalColor={red,green,blue,not Secret(alpha) and alpha or 1}
            end
            if record.color and record.unit and FT:IsEnabled("threatplates") then self:WriteColor(record,record.color) end
        end)
    end
    return record
end

function M:Attach(unit)
    if not FT:IsEnabled("threatplates") or not C_NamePlate or not C_NamePlate.GetNamePlateForUnit then return end
    local plate=Safe(C_NamePlate.GetNamePlateForUnit,nil,unit)
    if not Accessible(plate) then return end
    local frame,health,cast=Fields(plate)
    if not frame then self.pending[unit]=GetTime()+2; return end
    self.pending[unit]=nil
    local record=self.byPlate[plate]
    if not record or record.health~=health then
        if record then self:Restore(record); if record.unit then self.byUnit[record.unit]=nil end; record.unit=nil end
        record=self:CreateRecord(plate,health,cast); self.byPlate[plate]=record
    elseif record.cast~=cast then
        if record.cast and record.castTexture and Accessible(record.cast) then
            pcall(record.cast.SetStatusBarTexture,record.cast,record.castTexture)
        end
        record.cast=cast; record.castTexture=Accessible(cast) and OriginalTexture(cast)
    end
    if record.unit and record.unit~=unit then self.byUnit[record.unit]=nil end
    local previous=self.byUnit[unit]
    if previous and previous~=record then self:Restore(previous); previous.unit=nil end
    record.unit=unit; self.byUnit[unit]=record
    self:Update(record)
end

function M:Update(record)
    local unit=record.unit
    if not unit or not FT:IsEnabled("threatplates") or not Accessible(record.health) then return end
    if Safe(UnitIsUnit,false,unit,"player") then self:Restore(record); return end
    local hostile=Safe(UnitCanAttack,nil,"player",unit)
    local inInstance=Safe(IsInInstance,false)
    if hostile~=true and (not self.settings.friendly or inInstance) then self:Restore(record); return end
    local color,label=self:Color(unit)
    record.skinActive=true
    self:HideNativeHighlights(record)
    record.color=color
    if color then self:WriteColor(record,color)
    elseif record.originalColor then self:WriteColor(record,record.originalColor) end
    if record.health.SetStatusBarTexture then pcall(record.health.SetStatusBarTexture,record.health,TEXTURE) end
    if Accessible(record.cast) and record.cast.SetStatusBarTexture then
        local texture=self.settings.castStyle and TEXTURE or record.castTexture
        if texture then pcall(record.cast.SetStatusBarTexture,record.cast,texture) end
    end
    self:HealthText(record)
    record.threat:SetText(label or "")
    record.overlay:Show()
end

function M:RefreshAll()
    for _,record in pairs(self.byUnit) do self:Update(record) end
end

function M:Discover()
    if not FT:IsEnabled("threatplates") then return end
    local plates=C_NamePlate and Safe(C_NamePlate.GetNamePlates,nil)
    for _,plate in pairs(plates or {}) do
        if Accessible(plate) then
            local frame=plate.UnitFrame
            local unit=frame and Safe(function() return frame.unit end)
            if type(unit)=="string" then self:Attach(unit) end
        end
    end
end

function M:OnSettingsChanged()
    for _,record in pairs(self.byUnit) do self:Restore(record) end
    if FT:IsEnabled("threatplates") then self:Discover(); self:RefreshAll() else self.pending={} end
end

function M:Initialize()
    if self.frame then return end
    self.byPlate=setmetatable({},{__mode="k"}); self.byUnit={}; self.pending={}
    self.highlightStates=setmetatable({},{__mode="k"})
    if not (CurveConstants and CurveConstants.ScaleTo100) and C_CurveUtil and C_CurveUtil.CreateCurve then
        local ok,curve=pcall(function()
            local c=C_CurveUtil.CreateCurve(); c:AddPoint(0,0); c:AddPoint(1,100); return c
        end)
        if ok then self.healthPercentCurve=curve end
    end
    if not C_NamePlate or not C_NamePlate.GetNamePlateForUnit then
        FT:Print("Threat Plates: Nameplate-API fehlt; Modul bleibt inaktiv."); return
    end
    local frame=CreateFrame("Frame"); self.frame=frame
    for _,event in ipairs({"NAME_PLATE_UNIT_ADDED","NAME_PLATE_UNIT_REMOVED","PLAYER_ENTERING_WORLD",
        "PLAYER_TARGET_CHANGED","UNIT_THREAT_SITUATION_UPDATE","UNIT_THREAT_LIST_UPDATE","UNIT_HEALTH",
        "UNIT_MAXHEALTH","UNIT_FACTION","UNIT_FLAGS","UNIT_AURA","PLAYER_ROLES_ASSIGNED",
        "PLAYER_SPECIALIZATION_CHANGED","UPDATE_SHAPESHIFT_FORM","PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED"}) do
        pcall(frame.RegisterEvent,frame,event)
    end
    frame:SetScript("OnEvent",function(_,event,unit)
        if Secret(unit) then return end
        if event=="NAME_PLATE_UNIT_REMOVED" then
            self.pending[unit]=nil
            local record=self.byUnit[unit]
            if record then self:Restore(record); record.unit=nil; self.byUnit[unit]=nil end
        elseif not FT:IsEnabled("threatplates") then return
        elseif event=="NAME_PLATE_UNIT_ADDED" then self:Attach(unit)
        elseif event=="PLAYER_ENTERING_WORLD" then self:Discover()
        elseif unit and self.byUnit[unit] then self:Update(self.byUnit[unit])
        else self:RefreshAll() end
    end)
    local elapsed=0
    frame:SetScript("OnUpdate",function(_,delta)
        elapsed=elapsed+delta; if elapsed<0.2 then return end; elapsed=0
        if not FT:IsEnabled("threatplates") then return end
        for unit,expires in pairs(self.pending) do
            if GetTime()<expires then
                local deadline=expires; self:Attach(unit)
                if self.pending[unit] then self.pending[unit]=deadline end
            else self.pending[unit]=nil end
        end
        self:RefreshAll()
    end)
end
