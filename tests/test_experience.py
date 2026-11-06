"""Experience bar: rollover, quest APIs, migration, reload and shutdown."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

EXTRA = r'''
xp, maximum, level = 900, 1000, 10
function UnitXP() return xp end
function UnitXPMax() return maximum end
function UnitLevel() return level end
function UnitName() return 'Tester' end
function GetMaxPlayerLevel() return 60 end
function GetXPExhaustion() return 500 end
function RequestTimePlayed() requests = (requests or 0) + 1 end
local baseCreate = CreateFrame
function CreateFrame(...)
    local f = baseCreate(...)
    function f:SetAllPoints() end
    function f:SetMinMaxValues() end
    function f:SetFrameLevel() end
    function f:GetFrameLevel() return 1 end
    function f:SetStatusBarTexture() end
    function f:SetStatusBarColor() end
    function f:SetValue(v) self.value = v end
    function f:ClearAllPoints() end
    function f:UnregisterAllEvents() self.events = {} end
    function f:Hide() self.shown = false end
    function f:SetAlpha(a) self.alpha = a end
    function f:GetAlpha() return self.alpha or 1 end
    return f
end
MainMenuExpBar = CreateFrame('Frame')
selected = 77
C_QuestLog = {
    GetNumQuestLogEntries = function() return 3 end,
    GetInfo = function(i) return i == 1 and {isHeader=true} or {questID=i+100} end,
    GetSelectedQuest = function() return selected end,
    SetSelectedQuest = function(id) selected=id end,
    IsComplete = function(id) return id==102 end,
}
function GetQuestLogRewardXP(id) assert(selected==id); return id==102 and 200 or 300 end
'''


class ExperienceTest(unittest.TestCase):
    def runtime(self, setup=''):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + EXTRA + '\nnamespace={}\n' + setup)
        for name in ('Core.lua', 'Modules/Experience.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / name).read_text(encoding='utf-8'))
        lua.execute('Fire("ADDON_LOADED", "ForeverTools"); M=ForeverTools.modules.experience')
        return lua

    def test_rollover_both_event_orders_and_duplicate_events(self):
        for first in (True, False):
            lua = self.runtime()
            lua.execute('Fire("PLAYER_ENTERING_WORLD", true, false); Advance(10)')
            if first:
                lua.execute('Fire("PLAYER_LEVEL_UP",11)')
            lua.execute('xp=50; maximum=1200; level=11; Fire("PLAYER_XP_UPDATE","player")')
            if not first:
                lua.execute('Fire("PLAYER_LEVEL_UP",11)')
            lua.execute('''
                Fire('PLAYER_XP_UPDATE','player')
                assert(M.session.gained==150)
                assert(M.bars.progress.value==50/1200)
                assert(M.session.elapsed>0)
                Fire('TIME_PLAYED_MSG', 7200, 60)
                M:ResetSession()
                assert(M.session.totalPlayed==7200 and M.session.levelPlayed==60)
            ''')

    def test_quest_selection_restored_and_bars_clamped(self):
        lua = self.runtime()
        lua.execute('''
            assert(selected==77)
            assert(M.questComplete==200 and M.questTotal==500)
            assert(M.bars.quest.value==1 and M.bars.rested.value==1)
            C_QuestLog.GetInfo=function() error('temporary unavailable') end
            Fire('QUEST_LOG_UPDATE')
            assert(selected==77 and M.questComplete==0)
        ''')

    def test_rollover_before_unit_level_updates(self):
        lua = self.runtime()
        lua.execute('''
            xp=50; maximum=1200; Fire('PLAYER_XP_UPDATE','player')
            assert(M.session.gained==150)
            level=11; Fire('PLAYER_LEVEL_UP',11); Fire('PLAYER_XP_UPDATE','player')
            assert(M.session.gained==150)
            xp=100; Fire('PLAYER_XP_UPDATE','player'); assert(M.session.gained==200)
        ''')

    def test_legacy_quest_api_uses_indices_and_excludes_failed_quests(self):
        lua = self.runtime(r'''
            C_QuestLog={}
            function GetNumQuestLogEntries() return 3 end
            function GetQuestLogSelection() return selected end
            function SelectQuestLogEntry(i) selected=i end
            function GetQuestLogTitle(i)
                return 'Quest',1,nil,i==1,false,i==2 and 1 or -1,nil,i+100
            end
            function GetQuestLogRewardXP() return 200 end
        ''')
        lua.execute('assert(selected==77 and M.questComplete==200 and M.questTotal==400)')

    def test_disable_restores_native_bar_and_stops_all_updates(self):
        lua = self.runtime()
        lua.execute('''
            assert(MainMenuExpBar:GetAlpha()==0)
            ForeverTools:SetEnabled('experience',false)
            assert(not M.bar:IsShown() and MainMenuExpBar:GetAlpha()==1)
            assert(next(M.events.events)==nil and M.events.scripts.OnUpdate==nil)
            local elapsed=M.session.elapsed
            Advance(3); assert(M.session.elapsed==elapsed)
            ForeverTools:SetEnabled('experience',true)
            assert(M.bar:IsShown() and M.events.events.PLAYER_XP_UPDATE)
            level=60; Fire('PLAYER_XP_UPDATE','player')
            assert(not M.bar:IsShown() and MainMenuExpBar:GetAlpha()==1)
            M.settings.showMaxLevel=true; M:OnSettingsChanged()
            assert(M.bar:IsShown())
        ''')

    def test_reload_session_and_login_reset(self):
        lua = self.runtime('ForeverToolsExperienceDB={elapsed=60,gained=100,totalPlayed=500}')
        lua.execute('''
            Fire('PLAYER_ENTERING_WORLD',false,true)
            assert(M.session.elapsed==60 and M.session.gained==100)
            M.settings.resetReload=true
            Fire('PLAYER_ENTERING_WORLD',false,true)
            assert(M.session.elapsed==0 and M.session.gained==0 and M.session.totalPlayed==500)
            M.session.gained=50; Fire('PLAYER_ENTERING_WORLD',true,false)
            assert(M.session.gained==0)
        ''')

    def test_show_recovers_hidden_max_level_and_disabled_module(self):
        lua = self.runtime()
        lua.execute('''
            level=60; maximum=0
            ForeverTools:SetEnabled('experience',false)
            SlashCmdList.FOREVERTOOLSXP('show')
            assert(M.settings.enabled and M.settings.showMaxLevel and M.bar:IsShown())
            assert(M.settings.frameStrata=='MEDIUM' and M.session.location[1]=='CENTER')
        ''')

    def test_minimap_shortcut_shows_bar(self):
        lua = self.runtime()
        lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                    (ROOT / 'ForeverTools/Menu.lua').read_text(encoding='utf-8'))
        lua.execute('''
            ForeverTools.launcher=CreateFrame('Button')
            ForeverTools:ToggleLauncherMenu()
            local panel=ForeverTools.launcherMenu
            assert(panel.entries.experience)
            level=60; maximum=0; M:Refresh(); assert(not M.bar:IsShown())
            panel.entries.experience.scripts.OnClick(nil,'LeftButton')
            assert(M.bar:IsShown() and not panel:IsShown())
        ''')

    def test_original_migrated_once_and_duplicate_bar_blocked(self):
        lua = self.runtime('''
            EasyExperienceDB={global={barWidth=777,darkMode=true},
                char={['Tester - TestRealm']={location={'TOP',nil,'TOP',20,-100}}}}
            C_AddOns={IsAddOnLoaded=function() return true end,
                DisableAddOn=function(name,character) disabled=name..character end}
        ''')
        lua.execute('''
            assert(M.settings.barWidth==777 and M.settings.darkMode)
            assert(M.session.location[4]==20)
            assert(M.session.location~=EasyExperienceDB.char['Tester - TestRealm'].location)
            assert(M.legacyBlocked and not M.bar:IsShown())
            assert(disabled=='EasyExperienceBarTester')
            assert(next(M.events.events)==nil)
            M:Open()
            assert(not M.bar:IsShown() and messages[#messages]:find('nochmals /reload',1,true))
        ''')


if __name__ == '__main__':
    unittest.main()
