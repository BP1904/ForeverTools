"""Keep the external Journal icon above a raised Forever minimap."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime


class JournalButtonTest(unittest.TestCase):
    def test_level_changes_wait_until_combat_ends(self):
        self.runtime().execute('''
            LibDBIcon10_ForeverDungeonJournal=button
            combat=true; Fire('PLAYER_ENTERING_WORLD')
            assert(button.level==8 and namespace.journalButtonPending)
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(button.level==40 and not namespace.journalButtonPending)
        ''')
    def runtime(self):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + '''
            namespace={}
            Minimap={GetFrameLevel=function() return 30 end}
            button={shown=false, level=8, click=function() end}
            function button:SetFixedFrameLevel(value) self.fixed=value end
            function button:SetFrameLevel(value) assert(not self.fixed); self.level=value end
        ''')
        for name in ('Core.lua', 'Menu.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / name).read_text(encoding='utf-8'))
        return lua

    def test_global_icon_is_raised_without_showing_or_rebinding(self):
        lua = self.runtime()
        lua.execute('''
            LibDBIcon10_ForeverDungeonJournal=button
            local click=button.click
            Fire('PLAYER_ENTERING_WORLD')
            assert(button.level==40 and button.fixed)
            assert(not button.shown and button.click==click)
        ''')

    def test_library_lookup_and_deferred_login(self):
        lua = self.runtime()
        lua.execute('''
            C_Timer={After=function(_,fn) pending=fn end}
            LibStub=function(name,silent)
                assert(name=='LibDBIcon-1.0' and silent)
                return {GetMinimapButton=function(_,key)
                    assert(key=='ForeverDungeonJournal'); return button
                end}
            end
            Fire('PLAYER_LOGIN'); assert(button.level==8)
            pending(); assert(button.level==40)
            LibStub=nil; ForeverTools:RaiseJournalButton()
        ''')


if __name__ == '__main__':
    unittest.main()
