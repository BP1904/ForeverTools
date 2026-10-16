-- Independent compact cleansing display inspired by the supplied Decursive.
-- Aura selection is delegated to native AuraContainers when data is restricted.
local _, FT = ...
local M = {
    title="Decursive: Reinigung",
    description="Kleine Gruppenfelder: Farbe zeigt die Klickbelegung. /ftdcr zeigt Hilfe.",
    defaults={showSolo=true,sound=true,magic=true,curse=true,disease=true,poison=true},
    options={
        {key="showSolo",title="Reinigungsanzeige auch solo anzeigen"},
        {key="sound",title="Warnton bei neuem lesbarem, entfernbarem Effekt"},
        {key="magic",title="Magie anzeigen und reinigen"},
        {key="curse",title="Flüche anzeigen und reinigen"},
        {key="disease",title="Krankheiten anzeigen und reinigen"},
        {key="poison",title="Gifte anzeigen und reinigen"},
    },
}
FT:RegisterModule("decursive",M)
local TYPES={"Magic","Curse","Disease","Poison"}
local LABELS={Magic="Magie",Curse="Fluch",Disease="Krankheit",Poison="Gift"}
local KEYS={"type1","type2","shift-type1","shift-type2"}
local SPELLKEYS={"spell1","spell2","shift-spell1","shift-spell2"}
local CLICKS={"Linksklick","Rechtsklick","Umschalt + Linksklick","Umschalt + Rechtsklick"}
local COLORS={{0.9,0.15,0.1,1},{0.15,0.45,1,1},{1,0.85,0.1,1},{0.85,0.2,0.85,1}}
local function Secret(value) return issecretvalue and issecretvalue(value) end
local function Read(fn,fallback,...)
    if not fn then return fallback end
    local ok,value=pcall(fn,...)
    if not ok or Secret(value) then return fallback end
    return value
end
local function Combat() return Read(InCombatLockdown,false) end
local function Known(id)
    return (C_SpellBook and Read(C_SpellBook.IsSpellKnown,false,id))
        or Read(IsPlayerSpell,false,id) or Read(IsSpellKnown,false,id)
end
local function Spell(id)
    if C_Spell and C_Spell.GetSpellInfo then
        local info=Read(C_Spell.GetSpellInfo,nil,id)
        return info and Read(function() return info.name end)
    end
    return Read(GetSpellInfo,nil,id)
end
local function Learned(family)
    for _,id in ipairs(family.ids) do if Known(id) then return id,Spell(id) end end
    -- Forever may expose a replacement ID under the same localized spellbook name.
    if not C_SpellBook or not C_SpellBook.FindSpellBookSlotForSpell or not C_SpellBook.GetSpellBookItemInfo then return end
    for _,baseID in ipairs(family.ids) do
        local name=Spell(baseID)
        if name then
            local ok,slot,bank=pcall(C_SpellBook.FindSpellBookSlotForSpell,name)
            if ok and not Secret(slot) and slot then
                if Secret(bank) then bank=nil end
                bank=bank or (Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player)
                local info=Read(C_SpellBook.GetSpellBookItemInfo,nil,slot,bank)
                local id=info and Read(function()
                    if info.isPassive or info.isOffSpec then return end
                    if Enum and Enum.SpellBookItemType and Enum.SpellBookItemType.FutureSpell
                        and info.itemType==Enum.SpellBookItemType.FutureSpell then return end
                    return info.spellID
                end)
                if type(id)=="number" and id>0 and Spell(id)==name then return id,name end
            end
        end
    end
end

function M:ScanSpells()
    self.actions,self.byType={},{}
    local ok,_,class=pcall(function() return UnitClass("player") end)
    if not ok or Secret(class) then return end
    local candidates={}
    for _,family in ipairs(FT.cleansingSpells[class] or {}) do
        local id,name=Learned(family)
        if type(name)=="string" then
            for _,kind in ipairs(family.types) do
                if self.settings[kind:lower()] and not candidates[kind] then
                    candidates[kind]={id=id,name=name}
                end
            end
        end
    end
    local bySpell={}
    for _,kind in ipairs(TYPES) do
        local candidate=candidates[kind]
        if candidate then
            local action=bySpell[candidate.id]
            if not action then
                action={id=candidate.id,name=candidate.name,types={},index=#self.actions+1}
                self.actions[#self.actions+1]=action; bySpell[candidate.id]=action
            end
            action.types[kind]=true; self.byType[kind]=action
        end
    end
end

function M:Tooltip(button)
    if not GameTooltip then return end
    GameTooltip:SetOwner(button,"ANCHOR_RIGHT")
    GameTooltip:AddLine(Read(UnitName,button.unit,button.unit))
    for i,action in ipairs(self.actions) do
        local kinds={}
        for _,kind in ipairs(TYPES) do if action.types[kind] then kinds[#kinds+1]=LABELS[kind] end end
        local color=COLORS[i]
        GameTooltip:AddLine(CLICKS[i]..": "..action.name.." ("..table.concat(kinds,", ")..")",color[1],color[2],color[3],true)
    end
    if button.affliction then GameTooltip:AddLine(button.affliction,1,1,1) end
    if button.state=="unknown" or button.state=="native" then
        GameTooltip:AddLine(button.native and "Verborgene Effekte: native Farbanzeige verwenden."
            or "Effekte momentan nicht lesbar.",0.8,0.8,0.8)
    end
    GameTooltip:AddLine("Rechte Maustaste halten und ziehen: Anzeige verschieben (außerhalb des Kampfes).",0.8,0.8,0.8,true)
    GameTooltip:AddLine("Grau: kein lesbarer entfernbarer Effekt. D: tot, OFF: offline, R: Reichweite.",0.8,0.8,0.8,true)
    GameTooltip:Show()
end

function M:SetupNative(button)
    if not C_CurveUtil or not C_CurveUtil.CreateColorCurve or not CreateColor
        or not Enum or not Enum.CustomAuraButtonDispelTypeTextureStyle then return end
    if button.native then
        for i=1,4 do
            button.native:SetAuraSlotCandidateFilters("cure"..i,
                {includeDispelTypes=self.actions[i] and self.actions[i].types or {}})
        end
        return
    end
    if self.nativeUnavailable then return end
    local container
    local ok=pcall(function()
        container=CreateFrame("AuraContainer",nil,button,"CustomAuraContainerTemplate")
        container:SetAllPoints(button); container:EnableMouse(false)
        for i=4,1,-1 do
            local index=i
            local curve=C_CurveUtil.CreateColorCurve()
            if curve.SetType and Enum.LuaCurveType then curve:SetType(Enum.LuaCurveType.Step) end
            local color=CreateColor(unpack(COLORS[i]))
            curve:AddPoint(0,color); curve:AddPoint(11,color)
            container:AddAuraSlot("cure"..i,"HARMFUL",{
                sortMethod=0,sortDirection=0,
                candidateFilters={includeDispelTypes=self.actions[i] and self.actions[i].types or {}},
                initializeFrame=function(auraButton)
                    -- Never access this AuraButton again once native secret data is attached.
                    auraButton:EnableMouse(false)
                    auraButton:SetSize(26,18)
                    auraButton:SetPoint("TOP",button,"TOP",0,-2)
                    if auraButton.SetFrameLevel and button.GetFrameLevel then
                        auraButton:SetFrameLevel(button:GetFrameLevel()+10-index)
                    end
                    local texture=auraButton:CreateTexture(nil,"OVERLAY")
                    texture:SetAllPoints(auraButton); texture:SetColorTexture(1,1,1,1)
                    auraButton:ClearDispelTypeTextures()
                    auraButton:AddDispelTypeTexture(texture,{
                        showIcon=false,showWhenHarmful=true,showWhenHelpful=false,
                        showWithoutDispelType=false,
                        style=Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset,
                        customDispelColorCurve=curve,
                    })
                end,
            })
        end
        container:SetUnit(button.unit); container:SetEnabled(true); container:Show()
    end)
    if ok then button.native=container
    else
        if container then pcall(container.Hide,container) end
        self.nativeUnavailable=true
        FT:Print("Decursive: Native Aura-Anzeige nicht verfügbar; lesbare Effekte werden weiter angezeigt.")
    end
end

function M:StopMoving()
    if not self.moving or Combat() then return end
    local frame=self.display
    frame:StopMovingOrSizing(); self.moving=false
    local point,_,relativePoint,x,y=frame:GetPoint()
    self.settings.position={point=point,relativePoint=relativePoint,x=x,y=y}
end

function M:CreateDisplay()
    if self.display or Combat() then return end
    local frame=CreateFrame("Frame","ForeverToolsDecursive",UIParent)
    self.display=frame; self.buttons={}
    frame:SetSize(300,138); frame:SetClampedToScreen(true); frame:SetMovable(true)
    local function Add(unit,index,raid)
        local b=CreateFrame("Button",nil,frame,"SecureActionButtonTemplate")
        b.unit=unit; b.raid=raid
        b:SetSize(28,32); b:SetPoint("TOPLEFT",((index-1)%10)*30,-math.floor((index-1)/10)*34)
        -- Act on release so pressing the right button can begin a drag first.
        b:RegisterForClicks("AnyUp"); b:SetAttribute("useOnKeyDown",false)
        b:RegisterForDrag("RightButton"); b:SetAttribute("unit",unit)
        b:SetScript("OnDragStart",function(_,mouse)
            if mouse~="RightButton" or Combat() then return end
            self.moving=true; frame:StartMoving()
            if GameTooltip then GameTooltip:Hide() end
        end)
        b:SetScript("OnDragStop",function() self:StopMoving() end)
        b.background=b:CreateTexture(nil,"BACKGROUND")
        b.background:SetAllPoints(b); b.background:SetColorTexture(0.16,0.16,0.16,0.85)
        b.label=b:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
        b.label:SetPoint("BOTTOM",0,1); b.label:SetWidth(28)
        b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        b:SetScript("OnEnter",function(button) self:Tooltip(button) end)
        b:SetScript("OnLeave",function() if GameTooltip then GameTooltip:Hide() end end)
        if RegisterStateDriver then
            local condition=raid and ("[group:raid,@"..unit..",exists] show; hide")
                or ("[group:raid] hide; [@"..unit..",exists] show; hide")
            RegisterStateDriver(b,"visibility",condition)
        end
        self.buttons[#self.buttons+1]=b
    end
    Add("player",1,false)
    for i=1,4 do Add("party"..i,i+1,false) end
    for i=1,40 do Add("raid"..i,i,true) end
end

function M:Rebuild()
    if Combat() then self.dirty=true; return end
    self:StopMoving()
    self.dirty=false; self:ScanSpells()
    if not self.display and #self.actions==0 then return end
    self:CreateDisplay()
    local frame=self.display
    local p=self.settings.position
    frame:ClearAllPoints()
    if type(p)=="table" and type(p.x)=="number" and type(p.y)=="number"
        and type(p.point)=="string" and type(p.relativePoint)=="string" then
        frame:SetPoint(p.point,UIParent,p.relativePoint,p.x,p.y)
    else frame:SetPoint("CENTER",UIParent,"CENTER",0,-160) end
    local raid=Read(IsInRaid,false)
    local grouped=raid or Read(GetNumSubgroupMembers,0)>0
    frame:SetShown(FT:IsEnabled("decursive") and #self.actions>0 and (grouped or self.settings.showSolo))
    for _,b in ipairs(self.buttons) do
        for i=1,4 do
            b:SetAttribute(KEYS[i],self.actions[i] and "spell" or nil)
            b:SetAttribute(SPELLKEYS[i],self.actions[i] and self.actions[i].name)
        end
        b:SetAttribute("checkselfcast",false); b:SetAttribute("checkfocuscast",false)
        b:SetAttribute("checkmouseovercast",false)
        if not RegisterStateDriver then b:SetShown(b.raid==raid and Read(UnitExists,false,b.unit)) end
        self:SetupNative(b)
    end
    self:Refresh()
end

-- Only readable fields enter comparisons. Unknown is never treated as a clean unit.
function M:FindAffliction(unit)
    local best,bestName,hidden
    for i=1,255 do
        local ok,aura
        if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
            ok,aura=pcall(C_UnitAuras.GetAuraDataByIndex,unit,i,"HARMFUL")
        elseif UnitDebuff then
            ok,aura=pcall(function()
                local name,icon,count,kind,duration,expiration=UnitDebuff(unit,i)
                if Secret(name) then return {dispelName=name} end
                if not name then return end
                return {name=name,dispelName=kind,expirationTime=expiration}
            end)
        else return nil,nil,true end
        if not ok or Secret(aura) then return best,bestName,true end
        if not aura then break end
        local readable,kind,name,expiration=pcall(function() return aura.dispelName,aura.name,aura.expirationTime end)
        if not readable or Secret(kind) then hidden=true
        else
            local action=self.byType[kind]
            local expired=not Secret(expiration) and type(expiration)=="number" and expiration>0 and expiration<=GetTime()
            if action and not expired and (not best or action.index<best) then
                best=action.index; bestName=not Secret(name) and type(name)=="string" and name or LABELS[kind]
            end
        end
    end
    return best,bestName,hidden
end

function M:Refresh(changedUnit)
    if not FT:IsEnabled("decursive") or not self.display or not self.display:IsShown() then return end
    local raid=Read(IsInRaid,false)
    for _,b in ipairs(self.buttons) do
        if (not changedUnit or changedUnit==b.unit) and b.raid==raid and Read(UnitExists,false,b.unit) then
            local name=Read(UnitName,b.unit,b.unit)
            local label=type(name)=="string" and name:sub(1,4) or b.unit
            local dead=Read(UnitIsDeadOrGhost,false,b.unit)
            local offline=Read(UnitIsConnected,true,b.unit)==false
            local index,affliction,hidden
            if not dead and not offline then index,affliction,hidden=self:FindAffliction(b.unit) end
            local outOfRange=false
            if index and C_Spell and C_Spell.IsSpellInRange then
                local range=Read(C_Spell.IsSpellInRange,nil,self.actions[index].name,b.unit)
                outOfRange=range==false or range==0
            end
            b.state=dead and "dead" or offline and "offline" or index and "afflicted"
                or hidden and (b.native and "native" or "unknown") or "clear"
            b.affliction=affliction
            b.label:SetText(dead and "D" or offline and "OFF" or outOfRange and "R"
                or hidden and not b.native and "?" or label)
            if index then
                local color=COLORS[index]
                b.background:SetColorTexture(color[1],color[2],color[3],outOfRange and 0.3 or 0.9)
            else b.background:SetColorTexture(0.16,0.16,0.16,0.85) end
            if index and not b.afflicted and not outOfRange and self.settings.sound
                and GetTime()>=(self.nextSound or 0) then
                if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
                    pcall(PlaySound,SOUNDKIT.RAID_WARNING,"Master")
                end
                self.nextSound=GetTime()+3
            end
            b.afflicted=index~=nil
        elseif not changedUnit or changedUnit==b.unit then b.afflicted=false end
    end
end

function M:OnSettingsChanged() self:Rebuild() end
function M:Command(text)
    if (text or ""):lower():match("^reset%s*$") then
        self.settings.position=nil; self:Rebuild()
        FT:Print(Combat() and "Decursive: Position wird nach dem Kampf zurückgesetzt." or "Decursive: Position zurückgesetzt.")
        return
    end
    FT:Print("Reinigung: farbiges Gruppenfeld anklicken; Belegung im Tooltip. Mit rechter Maustaste ziehen. /ftdcr reset setzt die Position zurück.")
    if #self.actions==0 then FT:Print("Keine unterstützten Reinigungszauber gelernt oder alle Effekttypen ausgeschaltet.") end
    for i,action in ipairs(self.actions) do FT:Print(CLICKS[i]..": "..action.name) end
end
M.actions={{title="Reinigungsanzeige: Hilfe und Klickbelegung",run=function() M:Command("") end}}

function M:Initialize()
    self.actions={}; self.byType={}
    local frame=CreateFrame("Frame"); self.frame=frame
    for _,event in ipairs({"PLAYER_LOGIN","PLAYER_ENTERING_WORLD","GROUP_ROSTER_UPDATE","SPELLS_CHANGED",
        "PLAYER_REGEN_ENABLED","UNIT_AURA","UNIT_FLAGS","UNIT_CONNECTION","UNIT_NAME_UPDATE"}) do
        frame:RegisterEvent(event)
    end
    frame:SetScript("OnEvent",function(_,event,unit)
        if event=="UNIT_AURA" or event=="UNIT_FLAGS" or event=="UNIT_CONNECTION" or event=="UNIT_NAME_UPDATE" then
            if not Secret(unit) then self:Refresh(unit) end
        else self:Rebuild() end
    end)
    local elapsed=0
    frame:SetScript("OnUpdate",function(_,delta)
        elapsed=elapsed+delta
        if elapsed>=0.3 then elapsed=0; self:Refresh() end
    end)
    SLASH_FOREVERTOOLSDECURSIVE1="/ftdcr"
    SlashCmdList.FOREVERTOOLSDECURSIVE=function(text) self:Command(text) end
    self:Rebuild()
end
