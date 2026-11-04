-- Explicit game/API fixtures for executing the unchanged application chunks.
function noop() end
function GetLocale() return 'enUS' end
function GetBuildInfo() return '1.60.1', '70425', '', 16001 end
function GetMaxPlayerLevel() return 60 end
function GetServerTime() return 1793000000 end
function GetRealmID() return 1 end
function GetNormalizedRealmName() return 'TestRealm' end
function UnitNameUnmodified() return 'Tester' end
function UnitGUID() return 'Player-1-12345' end
function UnitClass() return 'Mage','MAGE',8 end
function UnitLevel() return 60 end
function UnitSex() return 2 end
function UnitRace() return 'Human','Human',1 end
function UnitXP() return 0 end
function UnitXPMax() return 10000 end
function GetXPExhaustion() return 0 end
function UnitFactionGroup() return 'Alliance' end
function IsResting() return false end
GetGuildInfo=noop
GetProfessions=noop
function GetInventoryItemDurability() return 100,100 end
function GetNumSkillLines() return 0 end
function GetNumSavedInstances() return 0 end
function GetNumSavedWorldBosses() return 0 end
C_QuestLog={IsQuestFlaggedCompleted=function() return false end}
function IsPublicTestClient() return false end
function IsLoggedIn() return false end
function IsInGroup() return false end
function IsInRaid() return false end
function GetRealZoneText(id) return 'Zone '..tostring(id) end
function GetInstanceInfo() return 'Test', 'none', 1, '', 5, 0, false, 0 end
function Ambiguate(name) return name end
function strsplit(sep, str)
    local result={}
    for item in (str..sep):gmatch('(.-)'..sep) do result[#result+1]=item end
    return unpack(result)
end
function string:trim() return self:match('^%s*(.-)%s*$') end
strfind=string.find; strsub=string.sub; strmatch=string.match; strlower=string.lower
strlenutf8=string.len; format=string.format; floor=math.floor; ceil=math.ceil
date=os.date; time=os.time; tinsert=table.insert; tremove=table.remove; wipe=function(t) for k in pairs(t) do t[k]=nil end return t end
table.wipe=wipe
securecallfunction=function(f,...) return f(...) end
function geterrorhandler() return function(err) error(err) end end
function hooksecurefunc(...) end
ChatFrame_AddMessageEventFilter=noop
bit={band=function(a,b) return 0 end,lshift=function(a,b) return a*2^b end,bor=function(a,b) return a+b end}
local function API() return setmetatable({}, {__index=function() return noop end}) end
C_ChatInfo=API(); C_Map=API(); C_CreatureInfo=API(); C_UnitAuras=API(); C_Spell=API()
C_InstanceEncounter=API(); C_Item=API(); C_SpellBook=API(); C_BattleNet=API(); C_PartyInfo=API()
C_CVar={GetCVar=function() return '150000000' end,SetCVar=noop}
C_CurrencyInfo={GetCoinTextureString=function() return '' end}
C_GossipInfo=API(); C_GameRules={IsGameRuleActive=function() return false end}
C_UIFileAsset=API()
C_NamePlate=API()
C_RestrictedActions=API()
C_StringUtil=API()
C_StringUtil.CreateSecondsFormatter=API
C_DurationUtil={CreateDurationTextBinding=API,CreateDuration=API}
C_UIWidgetManager=API(); C_QuestLog=API(); C_ChallengeMode=API(); C_EncounterJournal=API()
C_TooltipInfo=API(); C_Container=API(); C_TradeSkillUI=API(); C_UnitAuras=API()
C_PetInfo=API()
C_DateAndTime={GetSecondsUntilWeeklyReset=function() return 86400 end,GetSecondsUntilDailyReset=function() return 86400 end}
C_Spell.GetSpellName=function(id) return 'Spell '..tostring(id) end
C_EncounterJournal.GetSectionInfo=function(id) return {title='Section '..tostring(id)} end
RAID_CLASS_COLORS={MAGE={r=1,g=1,b=1}}
for _,class in ipairs({'PALADIN','SHAMAN','DRUID','HUNTER','WARRIOR','PRIEST','ROGUE','WARLOCK','DEATHKNIGHT','MONK','DEMONHUNTER','EVOKER'}) do RAID_CLASS_COLORS[class]={r=1,g=1,b=1} end
PLAYER_DIFFICULTY1='Normal'; PLAYER_DIFFICULTY2='Heroic'; PLAYER_DIFFICULTY6='Mythic'
Enum={GameRule={HardcoreRuleset=1,RPRuleset=2,PvPRuleset=3}}
C_Timer={After=noop,NewTimer=function() return {Cancel=noop} end,NewTicker=function() return {Cancel=noop} end}
WOW_PROJECT_ID=1; WOW_PROJECT_CLASSIC=2
EnumUtil={MakeEnum=function(...) local t={} for i=1,select('#',...) do t[select(i,...)]=i end return t end}
GameFontNormal={GetFont=function() return 'font',12 end}
GameFontNormalSmall=GameFontNormal; GameFontHighlight=GameFontNormal
local create=CreateFrame
function CreateFrame(kind,name,...)
    local f=create(kind,name,...)
    local function child() return CreateFrame('Frame') end
    f.GetName=function() return name end
    f.GetFont=function() return 'font',12,'' end
    f.GetPoint=function() return 'CENTER',UIParent,'CENTER',0,0 end
    f.GetPointByName=f.GetPoint
    f.GetWidth=function() return 400 end; f.GetHeight=function() return 300 end
    f.GetStringWidth=function() return 100 end; f.GetStringHeight=function() return 12 end
    f.GetNumPoints=function() return 1 end
    f.GetFrameStrata=function() return 'MEDIUM' end
    f.GetFrameLevel=function() return 1 end
    f.GetAlpha=function() return 1 end
    f.Hide=function(self) self.shown=false end
    f.Show=function(self) self.shown=true end
    f.CreateFontString=child; f.CreateTexture=child
    f.CreateAnimationGroup=child; f.CreateAnimation=child
    f.GetNormalTexture=child; f.GetPushedTexture=child; f.GetHighlightTexture=child; f.GetDisabledTexture=child
    setmetatable(f,{__index=function(t,k)
        if k=='EditBox' or k=='ScrollBar' or k=='ScrollUpButton' or k=='ScrollDownButton' or k=='Label' or k=='Text' or k=='CharCount' or k=='Instructions' then
            local v=child(); rawset(t,k,v); return v
        end
        if k:match('^Set') or k:match('^Clear') or k:match('^Enable') or k:match('^Register') or k:match('^Unregister') or k:match('^Add') or k:match('^Hook') then return noop end
    end})
    return f
end
TimerTracker=CreateFrame('Frame')
UIParent=CreateFrame('Frame','UIParent')
ItemRefTooltip=CreateFrame('GameTooltip')
RaidWarningFrame=CreateFrame('Frame')
RaidWarningFrame.slot1=CreateFrame('Frame'); RaidWarningFrame.slot2=CreateFrame('Frame')
local libs={}
local locale={}
libs['AceLocale-3.0']={
    NewLocale=function(_,app,loc) if loc~='enUS' then return end locale[app]=locale[app] or {}; return locale[app] end,
    GetLocale=function(_,app) return locale[app] end,
}
libs['LibDataBroker-1.1']={NewDataObject=function(_,_,t) return t end}
libs['AceDBOptions-3.0']={GetOptionsTable=function() return {name='Profiles'} end}
libs['AceGUI-3.0']=setmetatable({Create=function()
    local f=CreateFrame('Frame'); f.scrollFrame=CreateFrame('Frame'); f.frame=CreateFrame('Frame'); return f
end}, {__index=function() return noop end})
libs['AceDB-3.0']={New=function(_,name,defaults)
    _G[name]=_G[name] or {}; local db={profile=defaults.profile or {},global=defaults.global or {},RegisterCallback=noop}
    function db:RegisterNamespace(n,d) return {profile=d and d.profile or {},global=d and d.global or {}} end
    return db
end}
libs['AceAddon-3.0']={NewAddon=function(_,name)
    return {name=name,RegisterComm=noop,SendCommMessage=noop}
end}
setmetatable(libs,{__index=function(t,k)
    local lib=setmetatable({MediaType={STATUSBAR='statusbar',SOUND='sound'}},{__index=function() return noop end})
    rawset(t,k,lib); return lib
end})
LibStub=setmetatable({GetLibrary=function(_,name) return libs[name] end},{__call=function(_,name) return libs[name] end})
