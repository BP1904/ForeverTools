"""Refreshment selection, macro preservation and combat-safe updates."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime


class RefreshmentMacroTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + r'''
            FT={}; counts={}; edits=0
            body='#showtooltip\n/use item:8079\n/use item:8078\n/use item:22895\n/use item:8076'
            original=body
            function GetMacroIndexByName(name) assert(name=='wasser'); return missing and 0 or 1 end
            function GetMacroInfo(index) assert(index==1); return 'wasser',895874,body end
            function GetItemCount(id, bank) assert(bank==false); return counts[id] or 0 end
            function EditMacro(index,name,icon,text)
                assert(not combat and index==1 and name==nil and icon==134400)
                edits=edits+1; body=text; Fire('UPDATE_MACROS')
            end
        ''')
        source = (ROOT / 'ForeverTools/RefreshmentMacro.lua').read_text(encoding='utf-8')
        self.lua.execute('assert(loadstring(...))("ForeverTools",FT)', source)

    def test_highest_owned_water_and_unchanged_use_commands(self):
        self.lua.execute(r'''
            counts={[8078]=20,[22895]=40}
            Fire('PLAYER_ENTERING_WORLD')
            assert(body=='#showtooltip item:8078'..original:sub(13))
            assert(edits==1)
            Fire('UPDATE_MACROS'); assert(edits==1)
            counts[8079]=10; Fire('BAG_UPDATE_DELAYED')
            assert(body:match('^#showtooltip item:8079\n'))
        ''')

    def test_food_fallback_and_empty_bags(self):
        self.lua.execute(r'''
            counts={[8076]=20,[22895]=10}; Fire('PLAYER_LOGIN')
            assert(body:match('^#showtooltip item:22895\n'))
            counts[22895]=nil; Fire('BAG_UPDATE_DELAYED')
            assert(body:match('^#showtooltip item:8076\n'))
            counts={}; Fire('BAG_UPDATE_DELAYED')
            assert(body:match('^#showtooltip item:8079\n'))
        ''')

    def test_combat_defers_until_combat_ends(self):
        self.lua.execute('''
            counts[8078]=10; combat=true
            Fire('BAG_UPDATE_DELAYED'); assert(edits==0)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(edits==1)
        ''')

    def test_custom_macro_and_missing_macro_are_preserved(self):
        self.lua.execute(r'''
            body=original..'\n/run print("custom")'
            Fire('PLAYER_LOGIN'); assert(edits==0)
            body=original; missing=true
            Fire('PLAYER_LOGIN'); assert(edits==0)
        ''')

    def test_modern_item_api_and_open_editor(self):
        self.lua.execute('''
            C_Item={GetItemCount=GetItemCount}; GetItemCount=nil; counts[8078]=10
            MacroFrame=CreateFrame(); Fire('PLAYER_LOGIN'); assert(edits==0)
            MacroFrame.shown=false; Fire('BAG_UPDATE_DELAYED'); assert(edits==1)
        ''')


if __name__ == '__main__':
    unittest.main()
