local _, FT = ...
local M = {
    title="Buffcheck: Gruppe und Bufffood",
    description="Prüft Buffs, Bufffood und passende Waffensteine. Zeigt mögliche Buffgeber. /ftbuff blendet die Anzeige ein/aus. Maus über Zeilen: Details.",
    defaults={showSolo=true,optional=false,foodAlert=true},
    options={
        {key="showSolo",title="Auch solo anzeigen (inklusive Bufffood)"},
        {key="optional",title="Zusätzlich Willenskraft und Schattenschutz prüfen"},
        {key="foodAlert",title="Bufffood: 60 Sekunden vorher und beim Ablauf melden"},
    },
}
FT:RegisterModule("buffcheck",M)

-- Single-target and group versions are alternatives, as are spell ranks.
-- Level thresholds follow the bundled Forever trainer data. Class membership
-- is potential availability, never proof of a remote player's learned spells.
local families={
    {key="fortitude",label="Seelenstärke",class="PRIEST",level=1,ids={1243,1244,1245,2791,10937,10938,21562,21564}},
    {key="mark",label="Mal der Wildnis",class="DRUID",level=1,ids={1126,5232,6756,5234,8907,9884,9885,21849,21850}},
    {key="intellect",label="Arkane Intelligenz",class="MAGE",level=1,ids={1459,1460,1461,10156,10157,23028}},
    {key="blessing",label="Paladinsegen (einer)",class="PALADIN",level=4,
        ids={19740,19834,19835,19836,19837,19838,25782,25916,19742,19850,19852,19853,19854,25894,25918,20217,25898,1038,25895,20911,20912,20913,20914,25899,19977,19978,19979,25890},
        note="Macht / Weisheit / Könige / Rettung / Refugium / Licht sind Alternativen. Ein Segen erfüllt diese Zeile; zusätzliche Paladine werden nicht als Pflichtsegen gezählt."},
    {key="shout",label="Schlachtruf",class="WARRIOR",level=1,subgroup=true,ids={6673,5242,6192,11549,11550,11551,25289}},
    {key="thorns",label="Dornen",class="DRUID",level=6,ids={467,782,1075,8914,9756,9910}},
    {key="spirit",label="Göttlicher Willen",class="PRIEST",level=30,optional=true,ids={14752,14818,14819,27841,27681},note="Talentabhängig: Ein Priester muss diesen Zauber nicht gelernt haben."},
    {key="shadow",label="Schattenschutz",class="PRIEST",level=30,optional=true,ids={976,10957,10958,27683}},
}
local foodIDs={19705,19706,19707,19708,19709,19710,18125,18141,18191,22730,24870,25661,25804,25941}
-- Well-Rested from the Cozy Sleeping Bag; not the Legacy rested-XP perk.
local sleepingBagIDs={429959}
local situational={
    PALADIN="Zusätzlich Auren und kurzzeitige Schutz-/Freiheitssegen (situativ).",
    SHAMAN="Totems, z. B. Stärke der Erde, Luftgleiche Anmut, Windzorn, Manaquelle und Widerstände (Auswahl und Reichweite erforderlich).",
    HUNTER="Aura des Volltreffers ist talentabhängig; Aspekt des Rudels ist situativ.",
    WARLOCK="Blutpakt hängt vom aktiven Wichtel ab; Unterwasseratmung ist situativ.",
    MAGE="Magie verstärken / dämpfen sind situative Alternativen.",
    PRIEST="Furchtzauberschutz und talentabhängige Buffs sind situativ.",
}
local colors={green={0,0.55,0,0.7},yellow={0.85,0.70,0,0.7},red={0.8,0,0,0.7},unknown={0.2,0.2,0.2,0.7}}
local fallbackIcons={
    fortitude="Interface\\Icons\\Spell_Holy_WordFortitude",
    mark="Interface\\Icons\\Spell_Nature_Regeneration",
    intellect="Interface\\Icons\\Spell_Holy_MagicalSentry",
    blessing="Interface\\Icons\\Spell_Holy_FistOfJustice",
    shout="Interface\\Icons\\Ability_Warrior_BattleShout",
    thorns="Interface\\Icons\\Spell_Nature_Thorns",
    spirit="Interface\\Icons\\Spell_Holy_DivineSpirit",
    shadow="Interface\\Icons\\Spell_Shadow_AntiShadow",
    sleepingBag="Interface\\Icons\\INV_Misc_Bag_10",
    food="Interface\\Icons\\INV_Misc_Food_15",
}
local function Secret(v) return issecretvalue and issecretvalue(v) end
local function Read(fn,fallback,...)
    if type(fn)~="function" then return fallback end
    local ok,value=pcall(fn,...)
    if not ok or Secret(value) then return fallback end
    return value
end
local spellNames,spellIcons={},{}
local function Spell(id)
    if spellNames[id] then return spellNames[id] end
    local name=Read(C_Spell and C_Spell.GetSpellName or GetSpellInfo,nil,id)
    -- Unloaded spell data is retried; localized names remain stable this session.
    if type(name)=="string" then spellNames[id]=name end
    return name
end
local function Known(ids)
    for _,id in ipairs(ids) do
        if Read(C_SpellBook and C_SpellBook.IsSpellKnown,false,id)
            or Read(IsPlayerSpell,false,id) or Read(IsSpellKnown,false,id) then return true end
    end
    return false
end
local function AddNames(ids,names)
    for _,id in ipairs(ids) do
        local name=Spell(id)
        if type(name)=="string" then names[name]=true end
    end
end
local function Remaining(aura)
    local expiry=aura and Read(function() return aura.expirationTime end)
    if type(expiry)~="number" or expiry<=0 then return "aktiv" end
    local left=math.max(0,math.ceil(expiry-GetTime()))
    if left<60 then return left.." s" end
    return ("%d:%02d"):format(math.floor(left/60),left%60)
end

function M:Roster()
    local units={}
    local raid=Read(IsInRaid,false)
    local count=Read(GetNumGroupMembers,0)
    if raid then
        for i=1,count do units[#units+1]="raid"..i end
    else
        units[1]="player"
        for i=1,Read(GetNumSubgroupMembers,math.max(0,count-1)) do units[#units+1]="party"..i end
    end
    local roster,ownGroup={}
    for _,unit in ipairs(units) do
        if Read(UnitExists,false,unit) then
            local ok,_,class=pcall(UnitClass,unit)
            local subgroup
            if raid and GetRaidRosterInfo then
                local success,_,_,group=pcall(GetRaidRosterInfo,tonumber(unit:match("%d+")))
                if success and not Secret(group) then subgroup=group end
            end
            local player=unit=="player" or Read(UnitIsUnit,false,unit,"player")
            if player then ownGroup=subgroup end
            roster[#roster+1]={unit=unit,name=Read(UnitName,unit,unit),class=ok and not Secret(class) and class or "UNKNOWN",
                level=Read(UnitLevel,0,unit),group=subgroup,player=player,
                online=Read(UnitIsConnected,false,unit),dead=Read(UnitIsDeadOrGhost,false,unit)}
        end
    end
    self.roster,self.ownGroup,self.raid=roster,ownGroup,raid
end

function M:Providers(family)
    local providers={}
    for _,member in ipairs(self.roster) do
        if member.class==family.class and member.level>=family.level
            and (not family.subgroup or not self.raid or (self.ownGroup and member.group==self.ownGroup))
            and (not member.player or Known(family.ids)) then
            providers[#providers+1]=member
        end
    end
    return providers
end

function M:Auras()
    local auras,uncertain={},false
    local modern=C_UnitAuras and C_UnitAuras.GetAuraDataByIndex
    if not modern and not UnitBuff then return auras,true end
    for index=1,255 do
        local ok,aura
        if modern then ok,aura=pcall(modern,"player",index,"HELPFUL")
        else
            ok,aura=pcall(function()
                local name,icon,count,kind,duration,expiry,source,stealable,personal,id=UnitBuff("player",index)
                if Secret(name) then return name end
                if not name then return end
                return {name=name,spellId=id,icon=Read(function() return icon end),expirationTime=expiry}
            end)
        end
        if not ok or Secret(aura) then uncertain=true; break end
        if not aura then return auras,uncertain end
        local id=Read(function() return aura.spellId end)
        local name=Read(function() return aura.name end)
        if type(id)=="number" or type(name)=="string" then
            auras[#auras+1]={spellId=id,name=name,icon=Read(function() return aura.icon end),
                expirationTime=Read(function() return aura.expirationTime end)}
        end
        -- Any unreadable identity could be the missing buff. Never infer absence.
        if type(id)~="number" or type(name)~="string" then uncertain=true end
    end
    return auras,true
end

local function Find(auras,ids,names)
    local byID={}
    for _,id in ipairs(ids) do byID[id]=true end
    for _,aura in ipairs(auras) do
        if (aura.spellId and byID[aura.spellId]) or (aura.name and names[aura.name]) then
            if not aura.expirationTime or aura.expirationTime==0 or aura.expirationTime>GetTime() then return aura end
        end
    end
end

function M:FindBuff(auras,ids,names)
    local aura=Find(auras,ids,names)
    if aura then return aura end
    -- A hidden short-term aura must not obscure a readable long-term buff.
    -- Targeted queries are permitted for non-secret auras; nil alone does not
    -- prove absence when the general scan contains hidden identities.
    local query=C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
    if not query then return end
    for _,id in ipairs(ids) do
        local data=Read(query,nil,id)
        if type(data)=="table" then
            local expiry=Read(function() return data.expirationTime end)
            if not expiry or expiry==0 or expiry>GetTime() then
                return {spellId=id,name=Read(function() return data.name end) or Spell(id),
                    icon=Read(function() return data.icon end),expirationTime=expiry}
            end
        end
    end
end

function M:Remember(row)
    self.buffCache=self.buffCache or {}
    if row.state~="unknown" then
        self.buffCache[row.key]={state=row.state,aura=row.aura,time=GetTime()}
    else
        local cache=self.buffCache[row.key]
        if cache then row.state="cached"; row.cache=cache end
    end
end

local function CachedStatus(cache)
    if cache.state=="active" then
        local expiry=cache.aura and cache.aura.expirationTime
        if type(expiry)=="number" and expiry>0 then
            if expiry<=GetTime() then return "abgelaufen *" end
            return Remaining(cache.aura).." *"
        end
        return "zuletzt aktiv *"
    end
    if cache.state=="expired" then return "zuletzt ausgelaufen *" end
    if cache.state=="unavailable" then return "nicht bereit *" end
    return "fehlt *"
end

function M:RowAppearance(row)
    local cached=row.state=="cached" and row.cache
    local state=cached and cached.state or row.state
    local aura=cached and cached.aura or row.aura
    local expiry=aura and aura.expirationTime
    local color="unknown"
    if state=="active" then
        if type(expiry)=="number" then
            if expiry==0 then color=cached and "unknown" or "green"
            else
                local remaining=expiry-GetTime()
                color=remaining>180 and "green" or remaining>0 and "yellow" or "red"
            end
        end
    elseif state=="missing" or state=="expired" then color="red" end
    local status=cached and CachedStatus(cached)
        or state=="active" and Remaining(aura)
        or state=="unknown" and "unbekannt"
        or state=="unavailable" and "nicht bereit"
        or state=="expired" and "ausgelaufen" or "fehlt"
    local icon=aura and aura.icon
    if not icon then
        local id=aura and aura.spellId or row.spellID
        if id then
            icon=spellIcons[id] or Read(C_Spell and C_Spell.GetSpellTexture or GetSpellTexture,nil,id)
            if icon then spellIcons[id]=icon end
        end
    end
    return status,color,icon or row.icon or fallbackIcons[row.key] or 134400
end

function M:WeaponRows(rows)
    -- Item subclass IDs are independent of the client's language.
    local stones={[0]="Wetzstein",[1]="Wetzstein",[6]="Wetzstein",[7]="Wetzstein",[8]="Wetzstein",[15]="Wetzstein",
        [4]="Gewichtsstein",[5]="Gewichtsstein",[10]="Gewichtsstein",[13]="Gewichtsstein"}
    local info=C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant
    local ok,enchant=pcall(function()
        local function Pack(...) return {n=select("#",...),...} end
        return Pack(GetWeaponEnchantInfo())
    end)
    for _,slot in ipairs({16,17}) do
        local item=Read(GetInventoryItemLink,nil,"player",slot)
        if item and info then
            local success,_,_,_,_,_,class,subclass=pcall(info,item)
            local stone=success and not Secret(class) and class==2 and not Secret(subclass) and stones[subclass]
            if stone then
                local index=slot==16 and 1 or (ok and enchant.n>=8 and 5 or 4)
                local active=ok and enchant[index]
                local duration=ok and enchant[index+1]
                local readable=ok and not Secret(active) and (type(active)=="boolean" or active==nil)
                local aura
                if readable and active then
                    aura={expirationTime=not Secret(duration) and type(duration)=="number" and duration>0
                        and GetTime()+duration/1000 or nil}
                end
                rows[#rows+1]={key="weapon"..slot,weapon=true,
                    icon=stone=="Wetzstein" and "Interface\\Icons\\INV_Stone_SharpeningStone_05"
                        or "Interface\\Icons\\INV_Stone_WeightStone_05",
                    label=stone..(slot==16 and " (Haupthand)" or " (Nebenhand)"),aura=aura,
                    state=not readable and "unknown" or active and "active" or "missing",
                    note="Passender Stein für "..item..". Prüft den temporären Waffenbonus samt Restzeit. Auch Gifte, Öle und Waffenverzauberungen wie Windzorn zählen als aktiv; sie sollen nicht durch einen Stein ersetzt werden. Dauerhafte Verzauberungen zählen nicht."}
            end
        end
    end
end

function M:ShowFoodAlert(estimated,remaining)
    if not FT:IsEnabled("buffcheck") or not self.settings.foodAlert then return end
    if not self.foodAlertFrame then
        local frame=CreateFrame("Frame",nil,UIParent)
        self.foodAlertFrame=frame
        frame:SetSize(480,64)
        frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
        frame:SetFrameStrata("HIGH")
        frame:EnableMouse(false)
        frame.text=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
        frame.text:SetPoint("CENTER",0,10)
        frame.text:SetTextColor(1,0.65,0.15)
        frame.detail=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
        frame.detail:SetPoint("CENTER",0,-14)
        frame:SetScript("OnUpdate",function()
            if self.foodAlertUntil and GetTime()>=self.foodAlertUntil then
                self.foodAlertUntil=nil
                frame:SetShown(false)
            end
        end)
    end
    if remaining then
        self.foodAlertFrame.text:SetText(estimated and "Bufffood-Restzeit läuft bald ab" or "Dein Bufffood läuft gleich aus!")
        self.foodAlertFrame.detail:SetText("Noch "..math.ceil(remaining).." Sekunden"..(estimated and " – aktuell unbestätigt" or ""))
    else
        self.foodAlertFrame.text:SetText(estimated and "Bufffood-Restzeit abgelaufen" or "Dein Bufffood ist ausgelaufen!")
        self.foodAlertFrame.detail:SetText(estimated and "Letzter bekannter Stand – aktuell unbestätigt" or "")
    end
    self.foodAlertUntil=GetTime()+3
    self.foodAlertFrame:SetShown(true)
end

function M:CheckFoodAlert(row)
    if not self.settings.foodAlert or Read(UnitIsDeadOrGhost,false,"player") then
        self.foodWasActive=false; self.foodWarningExpiry=nil
        self.foodAlertUntil=nil
        if self.foodAlertFrame then self.foodAlertFrame:SetShown(false) end
        return
    end
    local cached=row.state=="cached" and row.cache and row.cache.state=="active"
    local aura=row.state=="active" and row.aura or cached and row.cache.aura
    local expiry=aura and aura.expirationTime
    if row.state=="active" then
        self.foodWasActive=true
    elseif self.foodWasActive then
        local cache=row.cache
        local expiry=cache and cache.aura and cache.aura.expirationTime
        local estimated=row.state=="cached" and cache.state=="active"
            and type(expiry)=="number" and expiry>0 and expiry<=GetTime()
        if row.state=="expired" or estimated then
            -- One notification per observed food buff, including the transition
            -- from an estimated combat expiry to a confirmed loss afterwards.
            self.foodWasActive=false
            self.foodWarningExpiry=nil
            self:ShowFoodAlert(estimated and true or false)
        end
    end
    if self.foodWasActive and type(expiry)=="number" and expiry>GetTime() then
        local remaining=expiry-GetTime()
        if remaining>60 then
            self.foodWarningExpiry=nil
        elseif self.foodWarningExpiry~=expiry then
            -- One advance warning per measured expiry, also after a readable refresh.
            self.foodWarningExpiry=expiry
            self:ShowFoodAlert(cached and true or false,remaining)
        end
    end
end

function M:Evaluate()
    self:Roster()
    -- Death invalidates previously observed buffs even if aura data is hidden.
    if Read(UnitIsDeadOrGhost,false,"player") then self.buffCache={} end
    local auras,uncertain=self:Auras()
    local rows={}
    for _,family in ipairs(families) do
        if not family.optional or self.settings.optional then
            local providers=self:Providers(family)
            -- An old buff from outside the current group must not keep its row visible.
            if #providers>0 then
                local names={}; AddNames(family.ids,names)
                local aura=self:FindBuff(auras,family.ids,names)
                local ready=false
                for _,p in ipairs(providers) do if p.online and not p.dead then ready=true end end
                rows[#rows+1]={key=family.key,label=family.label,spellID=family.ids[1],providers=providers,note=family.note,aura=aura,
                    state=aura and "active" or uncertain and "unknown" or ready and "missing" or "unavailable"}
            end
        end
    end
    local sleepingBagNames={}; AddNames(sleepingBagIDs,sleepingBagNames)
    local sleepingBag=self:FindBuff(auras,sleepingBagIDs,sleepingBagNames)
    rows[#rows+1]={key="sleepingBag",label="Schlafsack (EP)",spellID=sleepingBagIDs[1],aura=sleepingBag,
        state=sleepingBag and "active" or uncertain and "unknown" or "missing",
        note="Prüft den aktiven EP-Buff des Gemütlichen Schlafsacks. Bereits ein Stapel zählt als aktiv. Der Ruhebonus allein zählt nicht."}
    self:WeaponRows(rows)
    local ids={}; for _,id in ipairs(foodIDs) do ids[#ids+1]=id end
    for id in pairs(self.settings.foodSpells or {}) do ids[#ids+1]=id end
    local names={["Well Fed"]=true,["Satt"]=true}; AddNames(ids,names)
    local food=self:FindBuff(auras,ids,names)
    local state=food and "active" or uncertain and "unknown" or "missing"
    if food then self.hadFood=true
    elseif not uncertain and self.hadFood then state="expired" end
    rows[#rows+1]={key="food",label="Bufffood",spellID=foodIDs[1],aura=food,state=state,
        note="Prüft den aktiven Satt-Effekt, nicht Essen in der Tasche. Beim Essen erscheint der Bonus erst nach der nötigen Essenszeit. Eigene Forever-Zauber-ID: /ftbuff food ID"}
    for _,row in ipairs(rows) do if not row.weapon then self:Remember(row) end end
    self:CheckFoodAlert(rows[#rows])
    self.rows=rows
    return rows
end

function M:Tooltip(button)
    -- Keep buff details separate from the shared unit tooltip. Its lines must
    -- never carry over when the cursor moves from this panel to an enemy.
    if not self.tooltip then
        self.tooltip=CreateFrame("GameTooltip","ForeverToolsBuffTooltip",UIParent,"GameTooltipTemplate")
    end
    local tooltip=self.tooltip
    tooltip:SetOwner(button,"ANCHOR_RIGHT")
    tooltip:ClearLines()
    local row=button.row
    if row then
        tooltip:AddLine(row.label)
        if row.cache then
            tooltip:AddLine("* Letzter lesbarer Stand. Die Restzeit läuft weiter; Erneuerung oder vorzeitiger Verlust sind aktuell nicht bestätigt.",1,0.8,0.3,true)
        elseif row.state=="unknown" then
            tooltip:AddLine("Der Client verbirgt diese Buffdaten. Es liegt noch kein lesbarer Stand vor.",1,0.8,0.3,true)
        end
        for _,member in ipairs(row.providers or {}) do
            tooltip:AddLine(member.name.." (Stufe "..member.level..")"..(not member.online and " – offline" or member.dead and " – tot" or ""),1,1,1)
        end
        if row.aura and row.aura.name then tooltip:AddLine(row.aura.name,0.4,1,0.6) end
        if row.note then tooltip:AddLine(row.note,1,1,1,true) end
        tooltip:AddLine("Buffgeber werden nach Klasse und Stufe ermittelt. Gelernte Zauber und Reichweite sind bei Mitspielern nicht bestätigt.",0.7,0.7,0.7,true)
    else
        tooltip:AddLine("Deine Gruppe")
        local classes={}
        for _,member in ipairs(self.roster or {}) do
            tooltip:AddLine(member.name.." – "..member.class,1,1,1)
            classes[member.class]=true
        end
        for _,class in ipairs({"PALADIN","SHAMAN","HUNTER","WARLOCK","MAGE","PRIEST"}) do
            if classes[class] then tooltip:AddLine(situational[class],0.8,0.8,0.8,true) end
        end
        tooltip:AddLine("Geprüft: Seelenstärke, Mal, Intelligenz, ein Paladinsegen und Schlachtruf (eigene Untergruppe). Optional: Dornen, Willenskraft, Schattenschutz.",1,1,1,true)
        tooltip:AddLine("Situative Auren, Totems und Talent-/Begleiterbuffs werden nicht als fehlend gewertet. Paladinsegen sind Alternativen.",0.7,0.7,0.7,true)
        tooltip:AddLine("Ziehen: verschieben. /ftbuff: ein/aus. Einstellungen: /ad.",0.7,0.7,0.7,true)
    end
    tooltip:Show()
end

function M:HideTooltip()
    if self.tooltip then self.tooltip:Hide() end
end

function M:CreateDisplay()
    local frame=CreateFrame("Frame",nil,UIParent,"BackdropTemplate")
    self.display=frame
    frame:SetSize(104,40); frame:SetPoint("CENTER",UIParent,"CENTER",230,80)
    if self.settings.point then
        frame:ClearAllPoints()
        frame:SetPoint(self.settings.point,UIParent,self.settings.point,self.settings.x or 0,self.settings.y or 0)
    end
    frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
    frame:SetBackdropColor(0.04,0.06,0.08,0.88); frame:SetBackdropBorderColor(0.25,0.45,0.4,1)
    frame:SetClampedToScreen(true); frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart",frame.StartMoving)
    frame:SetScript("OnDragStop",function(f)
        f:StopMovingOrSizing()
        local point,_,_,x,y=f:GetPoint()
        self.settings.point,self.settings.x,self.settings.y=point,x,y
    end)
    frame:SetScript("OnEnter",function(f) self:Tooltip(f) end)
    frame:SetScript("OnLeave",function() self:HideTooltip() end)
    frame:SetScript("OnHide",function() self:HideTooltip() end)
    frame.title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    frame.title:SetPoint("TOPLEFT",4,-3); frame.title:SetText("Buffcheck")
    frame.notice=frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
    frame.notice:SetPoint("BOTTOMLEFT",4,3)
    frame.notice:SetText("* unbestätigt")
    frame.notice:SetTextColor(1,0.8,0.3)
    frame.notice:SetShown(false)
    frame.buttons={}
end

function M:Refresh()
    if not FT:IsEnabled("buffcheck") then self:HideTooltip(); self.display:SetShown(false); return end
    local rows=self:Evaluate()
    local shown=not self.settings.hidden and (self.settings.showSolo or #self.roster>1)
    self.display:SetShown(shown)
    if not shown then self:HideTooltip(); return end
    local cached=false
    for i,row in ipairs(rows) do
        local button=self.display.buttons[i]
        if not button then
            button=CreateFrame("Button",nil,self.display)
            self.display.buttons[i]=button
            button:SetSize(100,20); button:SetPoint("TOPLEFT",2,-16-(i-1)*21)
            button.background=button:CreateTexture(nil,"BACKGROUND")
            button.background:SetAllPoints(button)
            button.icon=button:CreateTexture(nil,"ARTWORK")
            button.icon:SetSize(18,18); button.icon:SetPoint("LEFT",1,0)
            button.time=button:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
            button.time:SetPoint("RIGHT",-3,0); button.time:SetWidth(74); button.time:SetJustifyH("RIGHT")
            button.text=button.time
            button:SetScript("OnEnter",function(b) self:Tooltip(b) end)
            button:SetScript("OnLeave",function() self:HideTooltip() end)
            button:SetScript("OnHide",function() self:HideTooltip() end)
        end
        button.row=row
        local status,color,icon=self:RowAppearance(row)
        button.color=color
        button.background:SetColorTexture(unpack(colors[color]))
        button.icon:SetTexture(icon)
        button.time:SetText(status); button:SetShown(true)
        if row.cache then cached=true end
    end
    for i=#rows+1,#self.display.buttons do self.display.buttons[i]:SetShown(false) end
    self.display.notice:SetShown(cached)
    self.display:SetHeight(18+#rows*21+(cached and 14 or 0))
end

function M:OnSettingsChanged()
    if not self.display then return end
    if not FT:IsEnabled("buffcheck") or not self.settings.foodAlert then
        self.foodAlertUntil=nil
        if self.foodAlertFrame then self.foodAlertFrame:SetShown(false) end
    end
    if FT:IsEnabled("buffcheck") then
        for _,event in ipairs({"PLAYER_ENTERING_WORLD","GROUP_ROSTER_UPDATE","UNIT_AURA","PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED","PLAYER_DEAD","PLAYER_LEVEL_UP","SPELLS_CHANGED","PLAYER_EQUIPMENT_CHANGED"}) do
            if event=="UNIT_AURA" and self.events.RegisterUnitEvent then
                local ok=pcall(self.events.RegisterUnitEvent,self.events,event,"player")
                if not ok then self.events:RegisterEvent(event) end
            else self.events:RegisterEvent(event) end
        end
        self.events:SetScript("OnUpdate",function(_,elapsed)
            self.elapsed=(self.elapsed or 0)+elapsed
            if self.elapsed>=1 then self.elapsed=0; self:Refresh() end
        end)
    else
        self.foodWasActive=false
        self.foodWarningExpiry=nil
        self.events:UnregisterAllEvents(); self.events:SetScript("OnUpdate",nil)
    end
    self:Refresh()
end

function M:Initialize()
    self.settings.foodSpells=type(self.settings.foodSpells)=="table" and self.settings.foodSpells or {}
    self:CreateDisplay()
    self.events=CreateFrame("Frame")
    self.events:SetScript("OnEvent",function(_,event,unit)
        if Secret(unit) then return end
        if event~="UNIT_AURA" or unit=="player" then self:Refresh() end
    end)
    SLASH_FOREVERTOOLSBUFF1="/ftbuff"
    SlashCmdList.FOREVERTOOLSBUFF=function(message)
        if message=="test" then self:ShowFoodAlert(false); return end
        if message=="testwarn" then self:ShowFoodAlert(false,60); return end
        local id=tonumber(message:match("^food%s+(%d+)%s*$"))
        if id and id>0 then
            self.settings.foodSpells[id]=true
            FT:Print("Zusätzlicher Bufffood-Zauber: "..id)
        elseif message=="show" then self.settings.hidden=false
        elseif message=="hide" then self.settings.hidden=true
        elseif message=="" then self.settings.hidden=not self.settings.hidden
        else FT:Print("/ftbuff [show|hide] – Anzeige; /ftbuff test – Ablaufmeldung; /ftbuff testwarn – Vorwarnung; /ftbuff food ID – zusätzlicher Bufffood-Zauber."); return end
        if not FT:IsEnabled("buffcheck") then FT:SetEnabled("buffcheck",true) else self:Refresh() end
    end
    self:OnSettingsChanged()
end
