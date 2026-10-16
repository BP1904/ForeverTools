"""Single-addon loading order, settings persistence and legacy migration."""
import json
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime
from test_antifettfinger import SECURE_MOCK
from test_autorank import AUTORANK_MOCK
from test_materials import MATERIAL_MOCK
from test_paladin import PALADIN_MOCK


class BundleTest(unittest.TestCase):
    def runtime(self, full=False):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + (MATERIAL_MOCK + PALADIN_MOCK if full else '') + SECURE_MOCK + AUTORANK_MOCK)
        lua.execute('''
            namespace = {}
            function UnitName() return 'Tester' end
            disabled = {}
            C_AddOns = {DisableAddOn = function(name, character)
                assert(character == 'Tester')
                disabled[name] = true
            end}
        ''')
        return lua

    def load_bundle(self, lua, full=False):
        toc = (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8')
        selected = {'Features/AntiFettFinger.lua', 'Features/AutoRank.lua', 'Core.lua',
                    'Modules/AntiFettFinger.lua', 'Modules/AutoRank.lua', 'Menu.lua'}
        for line in toc.splitlines():
            filename = line.replace('\\', '/')
            if filename in selected or (full and filename and not filename.startswith('#')):
                code = (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8')
                lua.execute('assert(loadstring(...))("ForeverTools", namespace)', code)
        lua.execute('Fire("ADDON_LOADED", "ForeverTools")')

    def test_full_production_toc_loads_all_nine_modules(self):
        lua = self.runtime(full=True)
        self.load_bundle(lua, full=True)
        lua.execute('''
            assert(#ForeverTools.order == 9)
            ForeverTools:ToggleMenu()
            assert(#ForeverTools.menu.sections == 9)
            assert(ForeverTools.modules.antifettfinger:IsAvailable())
            assert(ForeverTools.modules.autorank:IsAvailable())
        ''')

    def test_both_features_load_in_one_namespace_and_menu_without_dependencies(self):
        lua = self.runtime()
        self.load_bundle(lua)
        lua.execute('''
            assert(ForeverTools == namespace)
            assert(AntiFettFinger ~= ForeverTools and AutoRank ~= ForeverTools)
            assert(ForeverTools.antiFettFinger == AntiFettFinger and ForeverTools.autoRank == AutoRank)
            assert(ForeverTools:IsEnabled('antifettfinger') and ForeverTools:IsEnabled('autorank'))
            ForeverTools:ToggleMenu()
            assert(#ForeverTools.menu.sections == 2)
            assert(AntiFettFinger.db == ForeverToolsAntiFettFingerDB)
            assert(AutoRank.db == ForeverToolsAutoRankDB)
            ForeverTools:SetEnabled('antifettfinger', false)
            ForeverTools:SetEnabled('autorank', false)
            assert(not AntiFettFinger:IsEnabled() and not AutoRank:IsEnabled())
        ''')

    def test_character_settings_remain_off_after_reload(self):
        lua = self.runtime()
        lua.execute('''
            ForeverToolsAntiFettFingerDB = {enabled=false, position={point='TOP', relativePoint='TOP', x=21, y=-75}}
            ForeverToolsAutoRankDB = {enabled=false, seen={Feuerball=true}, waiting={Sprint=true}}
        ''')
        self.load_bundle(lua)
        lua.execute('''
            assert(not ForeverTools:IsEnabled('antifettfinger') and not ForeverTools:IsEnabled('autorank'))
            assert(AutoRank.db.seen.Feuerball and AutoRank.db.waiting.Sprint)
            assert(AntiFettFinger.db.position.x == 21)
        ''')

    def test_enabled_legacy_copies_transfer_settings_without_duplicate_engines(self):
        lua = self.runtime()
        lua.execute('''
            local function Legacy(db)
                return {db=db, listeners={},
                    IsEnabled=function(self) return self.db.enabled end,
                    SetEnabled=function(self, enabled) self.db.enabled=enabled; return true end,
                    RegisterStateListener=function(self, callback) self.listeners[#self.listeners+1]=callback end}
            end
            AntiFettFinger=Legacy({enabled=false, position={x=42}})
            AutoRank=Legacy({enabled=true, seen={Feuerball=true}, waiting={Sprint=true}})
            oldAFF=AntiFettFinger; oldRank=AutoRank
        ''')
        self.load_bundle(lua)
        lua.execute('''
            assert(AntiFettFinger == oldAFF and AutoRank == oldRank)
            assert(ForeverToolsAntiFettFingerDB == oldAFF.db and ForeverToolsAutoRankDB == oldRank.db)
            assert(ForeverToolsAntiFettFingerDB.position.x == 42)
            assert(ForeverToolsAutoRankDB.seen.Feuerball and ForeverToolsAutoRankDB.waiting.Sprint)
            assert(disabled.AntiFettFinger and disabled.AutoRank)
            assert(AntiFettFingerController == nil)
            assert(#oldAFF.listeners == 1 and #oldRank.listeners == 1)
            assert(not ForeverTools:IsEnabled('antifettfinger') and ForeverTools:IsEnabled('autorank'))
        ''')

    def test_distribution_contains_exactly_one_addon_and_both_feature_files(self):
        self.assertEqual([a['folder'] for a in json.loads((ROOT / 'addons.json').read_text())], ['ForeverTools'])
        for tocname in ('ForeverTools.toc', 'ForeverTools_Camelot.toc'):
            toc = (ROOT / 'ForeverTools' / tocname).read_text(encoding='utf-8')
            self.assertNotIn('## Dependencies:', toc)
            self.assertIn('ForeverToolsAntiFettFingerDB', toc)
            self.assertIn('ForeverToolsAutoRankDB', toc)
            for feature in ('Features\\AntiFettFinger.lua', 'Features\\AutoRank.lua'):
                self.assertLess(toc.index(feature), toc.index('Core.lua'))
            for line in toc.splitlines():
                if line and not line.startswith('#'):
                    self.assertTrue((ROOT / 'ForeverTools' / line.replace('\\', '/')).is_file(), line)

    def test_legacy_screen_button_is_hidden_without_changing_enabled_state(self):
        for in_combat in (False, True):
            with self.subTest(in_combat=in_combat):
                lua = self.runtime()
                source = (ROOT / 'AntiFettFinger/AntiFettFinger.lua').read_text(encoding='utf-8')
                lua.execute('assert(loadstring(...))("AntiFettFinger", {})', source)
                lua.execute('''
                    Fire('ADDON_LOADED', 'AntiFettFinger')
                    oldAFF = AntiFettFinger
                    assert(oldAFF.button:IsShown())
                    function oldAFF.button:Hide()
                        assert(not combat, 'protected button must only hide outside combat')
                        self.shown = false
                    end
                ''')
                lua.execute('combat=' + ('true' if in_combat else 'false'))
                self.load_bundle(lua)
                if in_combat:
                    lua.execute('''
                        assert(oldAFF.button:IsShown())
                        State(false); Fire('PLAYER_REGEN_ENABLED')
                    ''')
                lua.execute('''
                    assert(not oldAFF.button:IsShown())
                    assert(AntiFettFinger == oldAFF and oldAFF:IsEnabled())
                    assert(disabled.AntiFettFinger)
                ''')


if __name__ == '__main__':
    unittest.main()
