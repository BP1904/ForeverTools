"""The common-menu checkbox owns launcher visibility and saved position."""
import unittest
import test_disenchantry
from test_forevertools import ROOT

MINIMAP_MOCK=r'''
Minimap=CreateFrame('Frame','Minimap'); Minimap:SetSize(140,140)
function Minimap:GetCenter() return 200,200 end
function Minimap:GetEffectiveScale() return 1 end
cursorX=278; cursorY=200
function GetCursorPosition() return cursorX,cursorY end
'''


class MinimapTest(unittest.TestCase):
    def runtime(self,extra=''):
        return test_disenchantry.DisenchantryTest().runtime(MINIMAP_MOCK+extra,with_minimap=True)

    def test_checkbox_creates_single_launcher_and_hides_with_module(self):
        lua=self.runtime()
        lua.execute('assert(not M.settings.showMinimap and not M.minimapButton)')
        lua.execute('assert(loadstring(...))("ForeverTools",namespace)',(ROOT/'ForeverTools/Menu.lua').read_text(encoding='utf-8'))
        lua.execute('''
            ForeverTools:ToggleMenu()
            local check=ForeverTools.menu.checks[#ForeverTools.menu.checks].box
            check:SetChecked(true); check.scripts.OnClick(check)
            assert(M.settings.showMinimap and M.minimapButton:IsShown())
            local icon=M.minimapButton
            M:OnSettingsChanged(); assert(M.minimapButton==icon)
            ForeverTools:SetEnabled('disenchantry',false)
            assert(not icon:IsShown() and M.settings.showMinimap)
            ForeverTools:SetEnabled('disenchantry',true); assert(icon:IsShown())
            check:SetChecked(false); check.scripts.OnClick(check)
            assert(not icon:IsShown() and not M.settings.showMinimap)
        ''')

    def test_click_routes_left_to_window_and_right_to_settings(self):
        self.runtime().execute('''
            M.settings.showMinimap=true; M:OnSettingsChanged()
            M.minimapButton.scripts.OnClick(M.minimapButton,'LeftButton')
            assert(M.started and A.mainFrame:IsShown())
            M.minimapButton.scripts.OnClick(M.minimapButton,'RightButton')
            assert(A.settingsFrame:IsShown())
        ''')

    def test_drag_persists_angle_and_respects_ui_scale(self):
        self.runtime().execute('''
            M.settings.showMinimap=true; M:OnSettingsChanged()
            local icon=M.minimapButton
            icon.scripts.OnDragStart(icon); icon.scripts.OnUpdate(icon)
            assert(math.abs(M.settings.minimapAngle)<0.0001)
            assert(math.abs(icon.point[4]-78)<0.0001 and math.abs(icon.point[5])<0.0001)
            cursorX=200; cursorY=278; icon.scripts.OnDragStop(icon)
            assert(not icon.scripts.OnUpdate and math.abs(M.settings.minimapAngle-90)<0.0001)
            function Minimap:GetEffectiveScale() return 2 end
            cursorX=400; cursorY=556; M:DragMinimapButton()
            assert(math.abs(M.settings.minimapAngle-90)<0.0001)
            local saved=ForeverToolsDB.modules.disenchantry.minimapAngle
            M.settings.showMinimap=false; M:OnSettingsChanged()
            M.settings.showMinimap=true; M:OnSettingsChanged()
            assert(ForeverToolsDB.modules.disenchantry.minimapAngle==saved)
        ''')

    def test_first_creation_waits_for_combat_end(self):
        self.runtime().execute('''
            combat=true; M.settings.showMinimap=true; M:OnSettingsChanged()
            assert(not M.minimapButton)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(M.minimapButton:IsShown())
        ''')

    def test_legacy_engine_does_not_get_duplicate_launcher(self):
        self.runtime('''
            C_AddOns={IsAddOnLoaded=function() return true end,DisableAddOn=function() end}
        ''').execute('''
            assert(M.legacyBlocked)
            M.settings.showMinimap=true; M:OnSettingsChanged(); assert(not M.minimapButton)
        ''')

    def test_saved_checkbox_and_angle_restore_on_load(self):
        self.runtime('''
            ForeverToolsDB={modules={disenchantry={enabled=true,showMinimap=true,minimapAngle=123}}}
        ''').execute('''
            assert(M.minimapButton:IsShown() and M.settings.minimapAngle==123)
        ''')


if __name__=='__main__':
    unittest.main()
