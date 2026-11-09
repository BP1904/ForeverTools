"""Bounded, persistent blocked-action diagnostics without changing game handlers."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime


class DiagnosticsTest(unittest.TestCase):
    def runtime(self):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK+'''
            namespace={}; secret={}
            function issecretvalue(value) return value==secret end
            function date() return '09.11.2026 12:00:00' end
        ''')
        for file in ('Core.lua','Diagnostics.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools",namespace)',
                        (ROOT/'ForeverTools'/file).read_text(encoding='utf-8'))
        lua.execute("Fire('ADDON_LOADED','ForeverTools'); FT=ForeverTools")
        return lua

    def test_records_attribution_and_combat_without_hiding_original_events(self):
        self.runtime().execute('''
            observed=0; local frame=CreateFrame('Frame')
            frame:RegisterEvent('ADDON_ACTION_BLOCKED')
            frame:SetScript('OnEvent',function() observed=observed+1 end)
            combat=true; Fire('ADDON_ACTION_BLOCKED','ForeverTools','ProtectedFrame:Hide()')
            local entry=FT.db.diagnostics[1]
            assert(entry.addon=='ForeverTools' and entry.action=='ProtectedFrame:Hide()')
            assert(entry.combat and entry.stamp=='09.11.2026 12:00:00' and observed==1)
            local n=#messages
            SlashCmdList.FOREVERTOOLSERRORS()
            assert(#messages>n and messages[#messages-1]:find('ProtectedFrame:Hide()',1,true))
            assert(FT.db==ForeverToolsDB)
        ''')

    def test_deduplicates_limits_history_and_ignores_secret_fields(self):
        self.runtime().execute('''
            Fire('ADDON_ACTION_FORBIDDEN','OtherAddon','Restricted()')
            Fire('ADDON_ACTION_FORBIDDEN','OtherAddon','Restricted()')
            assert(#FT.db.diagnostics==1 and FT.db.diagnostics[1].count==2)
            Fire('ADDON_ACTION_BLOCKED',secret,'Hide()')
            Fire('ADDON_ACTION_BLOCKED','ForeverTools',secret)
            assert(#FT.db.diagnostics==1)
            for i=1,30 do Fire('ADDON_ACTION_BLOCKED','ForeverTools','Action'..i) end
            assert(#FT.db.diagnostics==20 and FT.db.diagnostics[1].action=='Action11')
        ''')

    def test_reports_initialization_errors_and_tolerates_invalid_saved_log(self):
        self.runtime().execute('''
            FT.db.diagnostics='invalid'; SlashCmdList.FOREVERTOOLSERRORS()
            FT:RegisterModule('broken',{Initialize=function() error('module failed') end})
            FT:Initialize()
            local entry=FT.db.diagnostics[1]
            assert(entry.event=='INITIALIZE_ERROR' and entry.action:find('broken',1,true))
        ''')

    def test_macro_events_have_distinct_source_and_bounded_stack(self):
        self.runtime().execute('''
            function debugstack() return string.rep('trace',600) end
            Fire('MACRO_ACTION_BLOCKED','CastSpellByName()')
            local entry=FT.db.diagnostics[1]
            assert(entry.addon=='Makro' and entry.action=='CastSpellByName()')
            assert(#entry.stack==2000)
            SlashCmdList.FOREVERTOOLSERRORS('details')
        ''')


if __name__=='__main__':
    unittest.main()
