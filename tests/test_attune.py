"""Attune namespace, data, completion, migration and lifecycle regression checks."""
import re
import unittest
import xml.etree.ElementTree as ET
from test_forevertools import ROOT, MOCK, LuaRuntime

VENDOR = ROOT / 'ForeverTools/Features/Attune'

EXTRA = r'''
C_Timer={After=function(delay,fn) timers[#timers+1]=fn end}; timers={}
function RunTimers() local pending=timers; timers={}; for _,fn in ipairs(pending) do fn() end end
function IsLoggedIn() return true end
function GetBuildInfo() return '1.60.1',nil,nil,16001 end
function GetLocale() return 'deDE' end
function UnitName() return 'Tester' end
C_QuestLog={IsQuestFlaggedCompleted=function(id) return completed[id] or false end}; completed={}
C_AddOns={IsAddOnLoaded=function() return legacy or false end,
    DisableAddOn=function(name,character) assert(name=='Attune' and character=='Tester'); retired=true end}
C_ChatInfo={RegisterAddonMessagePrefix=function() end}
locales={}
localeAPI={NewLocale=function(self,app,lang,default)
    if default then locales[app]=setmetatable({}, {__index=function(t,k) return k end}) end
    if lang=='enUS' or lang==GetLocale() then return locales[app] end
end, GetLocale=function(self,app) return locales[app] end}
config={RegisterOptionsTable=function() end, AddToBlizOptions=function() return nil,123 end,
    Open=function(self,name) openedOptions=name end, Close=function() end}
icon={Hide=function() iconHidden=true end, Show=function() iconHidden=false end,Register=function() end}
function LibStub(name)
    if name=='AceLocale-3.0' then return localeAPI end
    if name=='AceAddon-3.0' then return {NewAddon=function(self,name)
        return {name=name,SetEnabledState=function(self,value) self.enabled=value end,
          Enable=function(self) if not self.enabled then self.enabled=true; self:OnEnable() end end,
          Disable=function(self) if self.enabled then self.enabled=false; self:OnDisable() end end,
          RegisterEvent=function(self,e) self.events=self.events or {};self.events[e]=true end,
          RegisterComm=function() end, SendCommMessage=function() comms=(comms or 0)+1 end}
    end} end
    if name=='AceGUI-3.0' then return {RegisterLayout=function() end} end
    if name=='LibDBIcon-1.0' then return icon end
    if name=='LibDataBroker-1.1' then return {NewDataObject=function(self,n,t) return t end} end
    return config
end
local create=CreateFrame
function CreateFrame(...)
    local f=create(...)
    function f:UnregisterAllEvents() self.events={} end
    function f:Hide() self.shown=false end
    return f
end
'''

class AttuneTest(unittest.TestCase):
    def load(self, legacy=False):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK+EXTRA)
        lua.execute('namespace={}; legacy='+str(legacy).lower())
        def execute(path):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',path.read_text(encoding='utf-8-sig'))
        execute(ROOT/'ForeverTools/Core.lua')
        execute(VENDOR/'Bootstrap.lua')
        for node in ET.parse(VENDOR/'Manifest.xml').getroot():
            path=node.attrib.get('file','')
            if node.tag.endswith('Script') and path!='Bootstrap.lua': execute(VENDOR/path)
        execute(ROOT/'ForeverTools/Modules/Attune.lua')
        lua.execute('env=namespace.attuneEnv; app=env.FTAttune; module=namespace.modules.attune')
        return lua

    def initialize(self,lua):
        lua.execute('app:OnInitialize(); Fire("ADDON_LOADED","ForeverTools")')

    def test_complete_source_compiles_and_xml_references_exist(self):
        lua=LuaRuntime()
        for path in VENDOR.rglob('*.lua'):
            lua.execute('assert(loadstring(...))',path.read_text(encoding='utf-8-sig'))
        for path in VENDOR.rglob('*.xml'):
            for node in ET.parse(path).iter():
                ref=node.attrib.get('file')
                if ref: self.assertTrue((path.parent/ref.replace('\\','/')).is_file(),(path,ref))
        main=(VENDOR/'Attune.lua').read_text(encoding='utf-8')
        self.assertNotIn('Interface\\\\AddOns\\\\FTAttune\\\\',main)
        self.assertNotIn('"/attune"', main)
        self.assertNotIn('FTAttunement', main)

    def test_namespace_and_all_data_load_without_touching_original(self):
        lua=self.load()
        lua.execute('''
            assert(Attune==nil and Attune_Data==nil and FTAttune==nil)
            assert(env.FTAttune_Data and #env.FTAttune_Data.attunes>100)
            assert(#env.FTAttune_Data.steps>2000)
            assert(env.FTAttune_Data.questGivers[12])
            assert(env._G==env)
            env.FTAttune_DB={example=42}
            assert(ForeverToolsAttuneDB.example==42 and Attune_DB==nil)
        ''')

    def test_migration_copies_data_and_blocks_until_reload(self):
        lua=self.load(True)
        lua.execute('''Attune_DB={toons={Tester={done={abc=1}}},autosurvey=false}
            AttuneLastViewed='selected'; TreeExpandStatus={open=true}''')
        self.initialize(lua)
        lua.execute('''
            RunTimers(); assert(retired and module.legacyBlocked and not app.enabled)
            assert(ForeverToolsAttuneDB.toons.Tester.done.abc==1)
            assert(ForeverToolsAttuneDB~=Attune_DB and ForeverToolsAttuneDB.toons~=Attune_DB.toons)
            assert(ForeverToolsAttuneLastViewed=='selected' and ForeverToolsAttuneTreeExpandStatus.open)
            assert(ForeverToolsAttuneMigrated)
            module:Open(); assert(not app.enabled)
        ''')

    def test_enable_disable_resume_cancels_old_callbacks(self):
        lua=self.load()
        self.initialize(lua)
        lua.execute('''
            starts=0
            function app:FTStart() starts=starts+1; env.FTAttune_DB.minimapbuttonpos={hide=true} end
            function env.FTAttune_CheckProgress() end
            function app:BAG_UPDATE() end
            function env.FTAttune_SaveTreeExpandStatus() end
            RunTimers(); assert(app.ftStarted and starts==1)
            env.C_Timer.After(1,function() fired=true end)
            callbackFrame=env.CreateFrame('Frame')
            callbackFrame:SetScript('OnEvent',function() eventsFired=(eventsFired or 0)+1 end)
            namespace:SetEnabled('attune',false)
            callbackFrame.scripts.OnEvent(); app:SendCommMessage('x')
            assert(iconHidden and not app.enabled and eventsFired==nil and comms==nil)
            namespace:SetEnabled('attune',true)
            RunTimers(); assert(fired==nil and starts==1 and app.enabled)
            callbackFrame.scripts.OnEvent(); assert(eventsFired==1)
            SlashCmdList.FOREVERTOOLSATTUNE('options'); assert(openedOptions=='FTAttune')
        ''')

    def test_failed_start_is_disabled_and_reported(self):
        lua=self.load();self.initialize(lua)
        lua.execute('''function app:FTStart() error('startup failure') end
            RunTimers(); assert(module.failed and not app.enabled and not module:Active())
            assert(messages[#messages]:find('startup failure'))''')

    def test_real_engine_start_completion_and_resume(self):
        lua=self.load()
        lua.execute('''
            function UnitName() return 'Tester','Forever' end
            function UnitLevel() return 60 end
            function UnitClass() return 'Paladin','PALADIN' end
            function UnitRace() return 'Mensch','Human' end
            function UnitSex() return 2 end
            function GetGuildInfo() end
            function time() return 123 end
            function GetNumQuestLogEntries() return 0 end
            function strsplit(separator,value) return value end
            function GetTime() return 1 end
            function IsInGuild() return false end
            function PlaySound() end
            function GetFactionInfoByID() end
            function GetQuestLogIndexByID() return 0 end
        ''')
        self.initialize(lua)
        lua.execute('''
            RunTimers()
            assert(app.ftStarted and not module.failed)
            local toon=ForeverToolsAttuneDB.toons['Tester Forever']
            assert(toon.done['20-20']==1 and not toon.done['20-45'])
            app:QUEST_TURNED_IN('QUEST_TURNED_IN',7848)
            RunTimers()
            assert(toon.done['20-45']==1)
            assert(toon.attuned['20']==100)
            assert(app.events.QUEST_TURNED_IN)
            for _,frame in ipairs(env.frames) do assert(not frame.events.COMBAT_LOG_EVENT_UNFILTERED) end
            app:BAG_UPDATE('BAG_UPDATE')
            namespace:SetEnabled('attune',false)
            namespace:SetEnabled('attune',true)
            app:BAG_UPDATE('BAG_UPDATE')
            RunTimers()
            assert(app.enabled and not module.failed and toon.attuned['20']==100)
            assert(Attune_DB==nil and attunelocal_panelDirty==nil and guildName==nil)
        ''')

if __name__=='__main__': unittest.main()
