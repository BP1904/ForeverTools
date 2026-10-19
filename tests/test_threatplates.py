"""Native nameplate styling, role colors, recycling and restoration."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime
from test_materials import MATERIAL_MOCK
from test_paladin import PALADIN_MOCK

NAMEPLATE_MOCK = r'''
local makeFrame=CreateFrame
function CreateFrame(...)
    local frame=makeFrame(...)
    function frame:SetAllPoints() end
    function frame:SetFrameLevel(value) self.frameLevel=value end
    function frame:GetFrameLevel() return self.frameLevel or 2 end
    function frame:IsForbidden() return self.forbidden or false end
    function frame:SetIgnoreParentAlpha() end
    function frame:SetAlpha(alpha) self.alpha=alpha end
    local makeTexture=frame.CreateTexture
    function frame:CreateTexture(...)
        local texture=makeTexture(self,...)
        function texture:SetHeight(h) self.height=h end
        function texture:SetWidth(w) self.width=w end
        function texture:Show() self.shown=true end
        function texture:Hide() self.shown=false end
        function texture:SetShown(value) self.shown=value end
        function texture:GetAlpha() return self.alpha or 1 end
        function texture:SetAlpha(value) self.alpha=value end
        function texture:SetBlendMode() end
        function texture:ClearAllPoints() self.point=nil end
        function texture:SetVertexColor(...) self.color={...} end
        return texture
    end
    return frame
end
function hooksecurefunc(object,method,fn)
    local original=object[method]
    object[method]=function(self,...)
        original(self,...); fn(self,...)
    end
end
RAID_CLASS_COLORS={MAGE={r=0.25,g=0.75,b=0.9}}
units.nameplate1={name='Enemy',class='WARRIOR',guid='npc1',enemy=true,health=750,max=1000,
    threat=3,inCombat=true,reaction=3}
plates={}
function UnitCanAttack(_,unit) return units[unit].enemy end
function UnitReaction(unit) return units[unit].reaction end
function UnitIsPlayer(unit) return units[unit].isPlayer or false end
function UnitIsUnit(a,b)
    if b=='target' then return a==currentTarget end
    return a==b
end
function UnitThreatSituation(_,unit) return units[unit].threat end
function UnitAffectingCombat(unit) return units[unit].inCombat or false end
function UnitHealth(unit) return units[unit].health end
function UnitHealthMax(unit) return units[unit].max end
function UnitIsTapDenied(unit) return units[unit].tapped or false end
function UnitHasEffectivelyTankAura() return tankAura end
function IsInInstance() return inInstance or false end
function MakeBar()
    local bar=CreateFrame('StatusBar')
    bar.color={0.7,0.2,0.1,1}; bar.texture='native'; bar.value=750
    function bar:SetStatusBarColor(...) self.color={...} end
    function bar:GetStatusBarColor() return unpack(self.color) end
    function bar:SetStatusBarTexture(texture) self.texture=texture end
    function bar:GetStatusBarTexture()
        return {GetTexture=function() return self.texture end}
    end
    return bar
end
function MakePlate(unit)
    local plate=CreateFrame('Frame')
    plate.UnitFrame=CreateFrame('Frame'); plate.UnitFrame.unit=unit
    plate.UnitFrame.healthBar=MakeBar(); plate.UnitFrame.castBar=MakeBar()
    plates[unit]=plate
    return plate
end
C_NamePlate={GetNamePlateForUnit=function(unit) return plates[unit] end,
    GetNamePlates=function() return plates end}
'''


class ThreatPlatesTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + MATERIAL_MOCK + PALADIN_MOCK + NAMEPLATE_MOCK)
        self.lua.execute('namespace={}')
        toc = (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8')
        for line in toc.splitlines():
            if line and not line.startswith(('#', 'Features\\')):
                source = (ROOT / 'ForeverTools' / line.replace('\\', '/')).read_text(encoding='utf-8')
                self.lua.execute('assert(loadstring(...))("ForeverTools",namespace)', source)
        self.lua.execute('''
            Fire('ADDON_LOADED','ForeverTools'); N=ForeverTools.modules.threatplates
            plate=MakePlate('nameplate1'); bar=plate.UnitFrame.healthBar
            Fire('NAME_PLATE_UNIT_ADDED','nameplate1'); record=N.byUnit.nameplate1
        ''')

    def test_dps_threat_and_tank_colors(self):
        self.lua.execute('''
            assert(bar.color[1]==1 and record.threat.text=='Aggro')
            units.player.role='TANK'; N:RefreshAll()
            assert(bar.color[2]==0.85 and bar.color[1]==0.1)
            units.nameplate1.threat=0; N:RefreshAll(); assert(bar.color[1]==1)
            units.nameplate1.threat=1; N:RefreshAll(); assert(bar.color[2]==0.85 and bar.color[1]==1)
            N.settings.automaticRole=false; N.settings.tank=false; N:OnSettingsChanged()
            units.nameplate1.threat=0; N:RefreshAll(); assert(bar.color[2]==0.85)
        ''')

    def test_native_health_cast_timing_and_target_are_preserved(self):
        self.lua.execute('''
            assert(record.percent.text=='75%' and bar.value==750)
            assert(bar.texture=='Interface\\\\Buttons\\\\WHITE8X8')
            currentTarget='nameplate1'; Fire('PLAYER_TARGET_CHANGED')
            assert(record.percent.text=='75% · 750' and not record.border)
            currentTarget=nil; Fire('PLAYER_TARGET_CHANGED'); assert(record.percent.text=='75%')
            assert(plate.UnitFrame.castBar.texture=='Interface\\\\Buttons\\\\WHITE8X8')
        ''')

    def test_engine_color_updates_and_disable_restore_original_state(self):
        self.lua.execute('''
            bar:SetStatusBarColor(0.3,0.4,0.5,1)
            assert(bar.color[1]==1 and record.originalColor[1]==0.3)
            ForeverTools:SetEnabled('threatplates',false)
            assert(bar.color[1]==0.3 and bar.color[2]==0.4 and bar.texture=='native')
            assert(plate.UnitFrame.castBar.texture=='native' and not record.overlay:IsShown())
            bar:SetStatusBarColor(0.8,0.8,0.8,1); assert(bar.color[1]==0.8)
            ForeverTools:SetEnabled('threatplates',true); assert(record.overlay:IsShown())
        ''')

    def test_secret_health_and_threat_use_native_fallback(self):
        self.lua.execute('''
            units.nameplate1.health=secret; units.nameplate1.max=secret; units.nameplate1.threat=secret
            Fire('UNIT_HEALTH','nameplate1')
            assert(record.percent.text=='' and record.threat.text=='')
            assert(bar.color[1]==0.7 and bar.value==750)
            units.nameplate1.health=500; units.nameplate1.max=1000; units.nameplate1.threat=0
            N:RefreshAll(); assert(record.percent.text=='50%')
        ''')

    def test_personal_friendly_instance_and_forbidden_plates_are_excluded(self):
        self.lua.execute('''
            units.nameplate1.enemy=false; units.nameplate1.reaction=5; N:RefreshAll()
            assert(not record.overlay:IsShown() and bar.texture=='native')
            N.settings.friendly=true; N:RefreshAll(); assert(record.overlay:IsShown())
            inInstance=true; N:RefreshAll(); assert(not record.overlay:IsShown())
            inInstance=false; plate.forbidden=true
            N.byUnit.nameplate1=nil; N:Attach('nameplate1'); assert(not N.byUnit.nameplate1)
            plate.forbidden=false; units.player.enemy=true
            MakePlate('player'); N:Attach('player'); assert(not N.byUnit.player.overlay:IsShown())
        ''')

    def test_class_colors_and_tapped_units(self):
        self.lua.execute('''
            units.nameplate1.isPlayer=true; units.nameplate1.class='MAGE'
            N:RefreshAll(); assert(bar.color[1]==0.25 and bar.color[3]==0.9)
            units.nameplate1.tapped=true; N:RefreshAll(); assert(bar.color[1]==0.5 and record.threat.text=='Belegt')
        ''')

    def test_recycled_plate_and_replaced_native_frame_detach_old_records(self):
        self.lua.execute('''
            Fire('NAME_PLATE_UNIT_REMOVED','nameplate1')
            assert(not record.unit and not record.overlay:IsShown() and bar.texture=='native')
            units.nameplate2=units.nameplate1; plates.nameplate2=plate
            plate.UnitFrame.unit='nameplate2'
            Fire('NAME_PLATE_UNIT_ADDED','nameplate2')
            assert(N.byUnit.nameplate2==record and record.unit=='nameplate2')
            local old=record
            plate.UnitFrame.healthBar=MakeBar(); Fire('NAME_PLATE_UNIT_ADDED','nameplate2')
            assert(N.byUnit.nameplate2~=old and not old.unit and not old.overlay:IsShown())
        ''')

    def test_late_native_frame_and_existing_plates_discovery(self):
        self.lua.execute('''
            units.nameplate2=units.nameplate1
            local late=CreateFrame('Frame'); plates.nameplate2=late
            Fire('NAME_PLATE_UNIT_ADDED','nameplate2'); assert(N.pending.nameplate2)
            late.UnitFrame=CreateFrame('Frame'); late.UnitFrame.unit='nameplate2'; late.UnitFrame.healthBar=MakeBar()
            Advance(2); assert(N.byUnit.nameplate2 and not N.pending.nameplate2)
            N.settings.castStyle=false; N:OnSettingsChanged()
            assert(plate.UnitFrame.castBar.texture=='native')
        ''')

    def test_target_absolute_health_full_number_and_target_data_fallback(self):
        self.lua.execute('''
            currentTarget='nameplate1'
            units.nameplate1.health=1234567; units.nameplate1.max=2000000
            Fire('PLAYER_TARGET_CHANGED')
            assert(record.percent.text=='62% · 1.234.567' and not record.border)
            units.target={health=900,max=1000}
            units.nameplate1.health=secret; units.nameplate1.max=secret
            Fire('UNIT_HEALTH','nameplate1'); assert(record.percent.text=='90% · 900')
            units.target.health=secret; Fire('UNIT_HEALTH','nameplate1')
            assert(record.percent.text=='')
        ''')

    def test_native_selection_art_stays_hidden_and_restores_when_disabled(self):
        self.lua.execute('''
            local frame=plate.UnitFrame
            frame.selectionHighlight=frame:CreateTexture()
            bar.selectedBorder=bar:CreateTexture()
            frame.levelFrame={selectedBorder=frame:CreateTexture()}
            local art={frame.selectionHighlight,bar.selectedBorder,frame.levelFrame.selectedBorder}
            N:RefreshAll()
            for _,texture in ipairs(art) do
                assert(texture.alpha==0)
                texture:SetAlpha(1); texture:Show(); assert(texture.alpha==0)
            end
            ForeverTools:SetEnabled('threatplates',false)
            for _,texture in ipairs(art) do
                assert(texture.alpha==1)
                texture:SetAlpha(0.6); assert(texture.alpha==0.6)
            end
            ForeverTools:SetEnabled('threatplates',true)
            for _,texture in ipairs(art) do assert(texture.alpha==0) end
            Fire('NAME_PLATE_UNIT_REMOVED','nameplate1')
            for _,texture in ipairs(art) do assert(texture.alpha==0.6) end
        ''')

    def test_secret_target_health_flows_directly_to_native_text_formatting(self):
        self.lua.execute('''
            currentTarget='nameplate1'
            units.target={health=secret,max=secret}
            units.nameplate1.health=secret; units.nameplate1.max=secret
            CurveConstants={ScaleTo100={}}
            UnitHealthPercent=function(unit,prediction,curve)
                assert(unit=='target' and prediction and curve==CurveConstants.ScaleTo100)
                return secret
            end
            record.percent.SetFormattedText=function(self,format,percent,health)
                assert(format=='%.0f%% · %.0f' and percent==secret and health==secret)
                self.text='native formatted health'
            end
            Fire('PLAYER_TARGET_CHANGED')
            assert(record.healthFormatMode=='native-percent-absolute')
            assert(record.percent.text=='native formatted health' and bar.value==750)
            UnitIsUnit=function() return secret end
            plates.target=plate
            Fire('UNIT_HEALTH','target')
            assert(record.healthFormatMode=='native-percent-absolute')
        ''')

    def test_secret_non_target_percent_uses_native_formatting(self):
        self.lua.execute('''
            units.nameplate1.health=secret; units.nameplate1.max=secret
            CurveConstants={ScaleTo100={}}
            UnitHealthPercent=function(unit) assert(unit=='nameplate1'); return secret end
            record.percent.SetFormattedText=function(self,format,value)
                assert(format=='%.0f%%' and value==secret); self.text='native percent'
            end
            Fire('UNIT_HEALTH','nameplate1')
            assert(record.healthFormatMode=='native-percent' and record.percent.text=='native percent')
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
