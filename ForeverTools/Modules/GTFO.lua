-- Independent warning engine based on the supplied GTFO 6.11 feature model.
local _, FT = ...
local M = {
    title="GTFO: Gefahrenwarnungen",
    description="Vier Warntöne, Erschöpfung/Atem und eigene Gefahrenzauber. Befehle: /ftgtfo.",
    defaults={high=true,low=true,fail=true,friendly=true,environment=true,visual=true,classic=true},
    options={
        {key="high",title="Hoher Schaden: lauter Alarm"},
        {key="low",title="Niedriger Schaden: kurzer Alarm"},
        {key="fail",title="Vermeidbarer Treffer: Doppelton"},
        {key="friendly",title="Mitspieler-Schaden: eigener Alarm"},
        {key="environment",title="Erschöpfung, Atemnot und lesbare Umweltschäden"},
        {key="visual",title="Zusätzliche Warnmeldung auf dem Bildschirm"},
        {key="classic",title="Classic-Warnliste nutzen (für Forever unbestätigt)"},
    },
}
FT:RegisterModule("gtfo",M)
local KEYS={"high","low","fail","friendly"}
local TEXT={"Gefahr – raus aus dem Schaden!","Gefährliche Fläche verlassen!","Vermeidbarer Treffer!","Mitspieler-Schaden!"}
local FILES={"alarmbuzzer.ogg","alarmbeep.ogg","alarmdouble.ogg","alarmbuzz.ogg"}
M.actions={}
for i=1,4 do
    local level=i
    M.actions[#M.actions+1]={title="GTFO-Warnton testen: "..KEYS[i],run=function() M:Alert(level,"Testwarnung",true) end}
end

local function Secret(value) return issecretvalue and issecretvalue(value) end
local function Safe(fn,fallback,...)
    if not fn then return fallback end
    local ok,value=pcall(fn,...)
    if not ok or Secret(value) then return fallback end
    return value
end
local function SupportsCombatLog()
    -- Forever uses the restricted modern engine despite its small interface number.
    -- Attempting RegisterEvent itself raises ADDON_ACTION_FORBIDDEN, even in pcall.
    local ok,_,_,_,interface=pcall(function() return GetBuildInfo() end)
    if ok and not Secret(interface) and type(interface)=="number" then
        if (interface>=16000 and interface<17000) or interface>=120000 then return false end
        return true
    end
    -- With no usable build information, avoid probing a modern restricted API.
    if C_DamageMeter or (C_CombatLog and C_CombatLog.IsCombatLogRestricted) then return false end
    return not (C_RestrictedActions and C_RestrictedActions.GetAddOnRestrictionState)
end
local function SoundPath(level) return "Interface\\AddOns\\ForeverTools\\Sounds\\GTFO\\"..FILES[level] end
local function SpellName(id)
    if C_Spell and C_Spell.GetSpellName then return Safe(C_Spell.GetSpellName,nil,id) end
    return Safe(GetSpellInfo,nil,id)
end

function M:Alert(level,detail,test)
    if not KEYS[level] or not FT:IsEnabled("gtfo") or (not test and not self.settings[KEYS[level]]) then return end
    local now=GetTime()
    if not test and now-(self.lastAlert or -100)<0.8 then return end
    self.lastAlert=now
    if PlaySoundFile then
        local ok,_,handle=pcall(PlaySoundFile,SoundPath(level),"Master")
        if ok then self.soundHandle=handle end
    end
    if self.settings.visual and UIErrorsFrame and UIErrorsFrame.AddMessage then
        UIErrorsFrame:AddMessage("ForeverTools: "..(detail or TEXT[level]),1,level==2 and 0.8 or 0.15,0.1,1)
    end
end

function M:BuildRules()
    local rules={}
    if self.settings.classic then
        for id,rule in pairs(FT.gtfoClassicRules) do if not rule.test then rules[id]=rule end end
    end
    for id,level in pairs(self.settings.spells) do
        id=tonumber(id); level=tonumber(level)
        if id and id>0 and id==math.floor(id) and KEYS[level] then rules[id]={sound=level} end
    end
    self.rules=rules
end

function M:Level(rule)
    local level=rule.sound
    if Safe(UnitGroupRolesAssigned,"","player")=="TANK" and rule.tankSound~=nil then level=rule.tankSound end
    if not KEYS[level] or not self.settings[KEYS[level]] then return end
    if rule.trivialLevel and Safe(UnitLevel,0,"player")>=rule.trivialLevel then return end
    return level
end

function M:Restricted()
    if InCombatLockdown and InCombatLockdown() then return true end
    local types=Enum and Enum.AddOnRestrictionType
    local inactive=Enum and Enum.AddOnRestrictionState and Enum.AddOnRestrictionState.Inactive
    if types and inactive and C_RestrictedActions and C_RestrictedActions.GetAddOnRestrictionState then
        for _,key in ipairs({"Combat","Encounter","ChallengeMode","PvPMatch"}) do
            if types[key] then
                local state=Safe(C_RestrictedActions.GetAddOnRestrictionState,inactive,types[key])
                if state~=inactive then return true end
            end
        end
    end
    return false
end

function M:RefreshNative()
    if self:Restricted() then self.pendingNative=true; return end
    self.pendingNative=false
    local api=C_UnitAuras or {}
    local remove=api.RemoveAuraSound or api.RemovePrivateAuraAppliedSound
    for id,handle in pairs(self.native) do
        local ok=remove and pcall(remove,handle)
        if ok then self.native[id]=nil else self.pendingNative=true end
    end
    if not FT:IsEnabled("gtfo") then return end
    for id,rule in pairs(self.rules) do
        local level=self:Level(rule)
        -- Native aura sounds cannot implement damage amounts or source filters.
        if level and not self.native[id] and not rule.specificMobs and not rule.ignoreSelfInflicted
            and not rule.damageMinimum and not rule.trivialPercent then
            local add=api.AddAuraSound or api.AddPrivateAuraAppliedSound
            local private=api.AddAuraSound or Safe(api.AuraIsPrivate,false,id)
            if add and private then
                local info={spellID=id,unitToken="player",soundFileName=SoundPath(level),outputChannel="Master"}
                local ok,handle
                if api.AddAuraSound and Enum and Enum.UnitAuraSoundTrigger then
                    ok,handle=pcall(add,Enum.UnitAuraSoundTrigger.Added,info)
                elseif not api.AddAuraSound then ok,handle=pcall(add,info) end
                if ok and not Secret(handle) and handle then self.native[id]=handle end
            end
        end
    end
end

function M:ScanAuras()
    if not FT:IsEnabled("gtfo") then return end
    local current={}
    for i=1,255 do
        local aura
        if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
            aura=Safe(C_UnitAuras.GetAuraDataByIndex,nil,"player",i,"HARMFUL")
        elseif UnitDebuff then
            local ok,_,_,_,_,_,_,source,_,_,id=pcall(UnitDebuff,"player",i)
            if ok and id and not Secret(id) then aura={spellId=id,sourceUnit=source} end
        end
        if not aura then break end
        local id=Safe(function() return aura.spellId end)
        local rule=id and self.rules[id]
        if rule then
            current[id]=true
            local level=self:Level(rule)
            -- Rules requiring combat-log-only evidence must never be guessed from a debuff alone.
            if level and not self.native[id] and not rule.specificMobs and not rule.ignoreSelfInflicted
                and not rule.damageMinimum and not rule.trivialPercent
                and (not rule.applicationOnly or not self.seen[id]) then
                self:Alert(level,SpellName(id) or TEXT[level])
            end
        end
    end
    self.seen=current
end

function M:CombatLog(...)
    local e={...}
    for _,index in ipairs({2,4,8,12,15}) do if Secret(e[index]) then return end end
    local player=Safe(UnitGUID,nil,"player")
    if not player or e[8]~=player then return end
    local event=e[2]
    if event=="ENVIRONMENTAL_DAMAGE" and self.settings.environment then
        local kind=e[12]
        if kind=="DROWNING" or kind=="FATIGUE" then self:Alert(1)
        elseif kind=="LAVA" or kind=="FIRE" then self:Alert(2) end
        return
    end
    local application=event=="SPELL_AURA_APPLIED" or event=="SPELL_AURA_APPLIED_DOSE" or event=="SPELL_AURA_REFRESH"
    local damage=event=="SPELL_DAMAGE" or event=="SPELL_PERIODIC_DAMAGE"
    if not application and not damage then return end
    local id=e[12]; local rule=self.rules[id]
    if not rule or self.native[id] then return end
    -- Readable aura scans handle the same aura application; do not play it a second time.
    if application and not rule.specificMobs and not rule.ignoreSelfInflicted and not rule.damageMinimum and not rule.trivialPercent then return end
    if rule.applicationOnly and not application then return end
    if rule.ignoreSelfInflicted and e[4]==e[8] then return end
    if rule.specificMobs then
        local mob=type(e[4])=="string" and tonumber(e[4]:match("%-(%d+)%-[^%-]+$"))
        local found=false
        for _,allowed in ipairs(rule.specificMobs) do if allowed==mob then found=true end end
        if not found then return end
    end
    if damage then
        local amount=e[15]
        if type(amount)~="number" or amount<=0 then return end
        if rule.damageMinimum and amount<rule.damageMinimum then return end
        local health=Safe(UnitHealthMax,0,"player")
        if rule.trivialPercent and health>0 and amount*100/health<rule.trivialPercent then return end
    end
    local level=self:Level(rule)
    if level then self:Alert(level,SpellName(id) or TEXT[level]) end
end

function M:OnSettingsChanged()
    self.seen={}; self.breath=nil
    if self.soundHandle and StopSound then pcall(StopSound,self.soundHandle); self.soundHandle=nil end
    self:BuildRules(); self:RefreshNative()
end

function M:Status()
    local count,native=0,0
    for _ in pairs(self.rules) do count=count+1 end
    for _ in pairs(self.native) do native=native+1 end
    FT:Print(("GTFO: %d Warnregeln, %d native Aura-Töne. Forever-Listen der Vorlage sind leer."):format(count,native))
    if not self.combatLogSupported then
        FT:Print("Kampflog auf diesem Client gesperrt; Aura- und Umgebungswarnungen bleiben verfügbar.")
    end
    if self.pendingNative then FT:Print("Native Tonregistrierung wartet auf das Ende der Spielbeschränkung.") end
end

function M:Command(text)
    local cmd,a,b=(text or ""):match("^(%S*)%s*(%S*)%s*(%S*)")
    if cmd=="test" then
        local level=tonumber(a)
        for i,key in ipairs(KEYS) do if key==a then level=i end end
        if not KEYS[level] then level=1 end
        self:Alert(level,"Testwarnung",true)
    elseif cmd=="add" then
        local id=tonumber(a); local level=tonumber(b)
        for i,key in ipairs(KEYS) do if key==b then level=i end end
        if not id or id<=0 or id~=math.floor(id) or not KEYS[level] then
            FT:Print("/ftgtfo add ZAUBERID high|low|fail|friendly"); return
        end
        self.settings.spells[id]=level; self:OnSettingsChanged(); self:Status()
    elseif cmd=="remove" and tonumber(a) then
        self.settings.spells[tonumber(a)]=nil; self.settings.spells[a]=nil
        self:OnSettingsChanged(); self:Status()
    else
        self:Status()
        FT:Print("/ftgtfo test 1–4 | add ZAUBERID high|low|fail|friendly | remove ZAUBERID")
    end
end

function M:Initialize()
    if self.frame then return end
    -- Apply the requested default once to existing installations as well.
    -- Later manual changes to this checkbox remain saved.
    if not self.settings.classicDefaultApplied then
        self.settings.classic=true
        self.settings.classicDefaultApplied=true
    end
    self.settings.spells=type(self.settings.spells)=="table" and self.settings.spells or {}
    self.native,self.seen={},{}
    self.combatLogSupported=SupportsCombatLog()
    self:BuildRules()
    local frame=CreateFrame("Frame"); self.frame=frame
    for _,event in ipairs({"PLAYER_LOGIN","PLAYER_ENTERING_WORLD","UNIT_AURA","MIRROR_TIMER_START",
        "MIRROR_TIMER_STOP","PLAYER_REGEN_ENABLED","GROUP_ROSTER_UPDATE","PLAYER_ROLES_ASSIGNED",
        "ADDON_RESTRICTION_STATE_CHANGED"}) do
        pcall(frame.RegisterEvent,frame,event)
    end
    if self.combatLogSupported then frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end
    frame:SetScript("OnEvent",function(_,event,...)
        if event=="PLAYER_LOGIN" or event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_REGEN_ENABLED"
            or event=="GROUP_ROSTER_UPDATE" or event=="PLAYER_ROLES_ASSIGNED" or event=="ADDON_RESTRICTION_STATE_CHANGED" then
            self:RefreshNative(); return
        end
        if not FT:IsEnabled("gtfo") then return end
        if event=="UNIT_AURA" then
            local unit=...; if not Secret(unit) and unit=="player" then self:ScanAuras() end
        elseif event=="COMBAT_LOG_EVENT_UNFILTERED" and self.combatLogSupported and CombatLogGetCurrentEventInfo then
            pcall(function() self:CombatLog(CombatLogGetCurrentEventInfo()) end)
        elseif event=="MIRROR_TIMER_START" and self.settings.environment then
            local kind,_,_,scale=...
            if Secret(kind) or Secret(scale) then return end
            if kind=="EXHAUSTION" and scale and scale<0 then self:Alert(1,"Erschöpfungsgebiet verlassen!")
            elseif kind=="BREATH" then self.breath=true; self.breathAlerted=false end
        elseif event=="MIRROR_TIMER_STOP" then
            local kind=...; if not Secret(kind) and kind=="BREATH" then self.breath=nil end
        end
    end)
    local elapsed=0
    frame:SetScript("OnUpdate",function(_,delta)
        elapsed=elapsed+delta; if elapsed<0.5 then return end; elapsed=0
        if self.pendingNative and not self:Restricted() then self:RefreshNative() end
        if not FT:IsEnabled("gtfo") then return end
        if self.breath and not self.breathAlerted and self.settings.environment then
            local remaining=Safe(GetMirrorTimerProgress,nil,"BREATH")
            if remaining and remaining<=0 then self.breathAlerted=true; self:Alert(1,"Keine Luft – auftauchen!") end
        end
        self:ScanAuras()
    end)
end

SLASH_FOREVERTOOLSGTFO1="/ftgtfo"
SlashCmdList.FOREVERTOOLSGTFO=function(text)
    if FT.db then M:Command(text) end
end
