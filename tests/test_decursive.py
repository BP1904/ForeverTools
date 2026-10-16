"""Cleansing priorities, secure click bindings, raid units and native aura slots."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime
from test_materials import MATERIAL_MOCK
from test_paladin import PALADIN_MOCK

DECURSIVE_MOCK = r'''
known[4987]=true
function GameTooltip:Hide() end
warnings={}
SOUNDKIT={RAID_WARNING=123}
function PlaySound(sound,channel) warnings[#warnings+1]={sound,channel} end
function RegisterStateDriver(frame,state,condition)
    assert(not combat); frame.visibilityCondition=condition
end
function EnableNativeMock()
    Enum={CustomAuraButtonDispelTypeTextureStyle={PreserveAsset=1},LuaCurveType={Step=1}}
    function CreateColor(...) return {...} end
    C_CurveUtil={CreateColorCurve=function()
        return {SetType=function() end,AddPoint=function() end}
    end}
end
local makeFrame=CreateFrame
function CreateFrame(kind,...)
    local frame=makeFrame(kind,...)
    function frame:RegisterForDrag(...) self.dragButtons={...} end
    function frame:RegisterForClicks(...) self.clickButtons={...} end
    function frame:SetAllPoints() assert(not self.nativeLocked) end
    function frame:GetFrameLevel() assert(not self.nativeLocked); return 3 end
    function frame:SetFrameLevel(value) assert(not self.nativeLocked); self.level=value end
    if kind=='AuraContainer' then
        frame.slots={}
        function frame:AddAuraSlot(key,filter,options)
            assert(not combat)
            local auraButton=CreateFrame('Button')
            function auraButton:ClearDispelTypeTextures() assert(not self.nativeLocked) end
            function auraButton:AddDispelTypeTexture(texture,config)
                assert(not self.nativeLocked); self.config=config
            end
            options.initializeFrame(auraButton)
            auraButton.nativeLocked=true
            self.slots[key]={filter=filter,options=options,auraButton=auraButton}
        end
        function frame:SetAuraSlotCandidateFilters(key,filters)
            assert(not combat); self.slots[key].options.candidateFilters=filters
        end
        function frame:SetUnit(unit) assert(not combat); self.unit=unit end
    end
    return frame
end
'''


class DecursiveTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + MATERIAL_MOCK + PALADIN_MOCK + DECURSIVE_MOCK)
        self.lua.execute('namespace={}')
        for line in (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8').splitlines():
            if line and not line.startswith('#'):
                source = (ROOT / 'ForeverTools' / line.replace('\\', '/')).read_text(encoding='utf-8')
                self.lua.execute('assert(loadstring(...))("ForeverTools",namespace)', source)
        self.lua.execute("Fire('ADDON_LOADED','ForeverTools'); D=ForeverTools.modules.decursive; b=D.buttons[1]")

    def test_paladin_cleanse_combines_types_and_prepares_fixed_click(self):
        self.lua.execute('''
            assert(#D.actions==1 and D.actions[1].id==4987)
            assert(D.byType.Magic==D.byType.Disease and D.byType.Poison==D.byType.Magic)
            assert(b:GetAttribute('unit')=='player')
            assert(b:GetAttribute('type1')=='spell' and b:GetAttribute('spell1')=='Spell4987')
            assert(not b:GetAttribute('type2') and not b:GetAttribute('checkselfcast'))
            assert(#D.buttons==45 and string.find(b.visibilityCondition,'group:raid',1,true))
        ''')

    def test_unlearned_spells_and_druid_two_button_mapping(self):
        self.lua.execute('''
            known={[2893]=true,[2782]=true}; units.player.class='DRUID'
            D:Rebuild()
            assert(#D.actions==2 and not D.byType.Magic)
            assert(b:GetAttribute('spell1')=='Spell2782')
            assert(b:GetAttribute('spell2')=='Spell2893')
            known={}; D:Rebuild(); assert(not D.display:IsShown())
            assert(not b:GetAttribute('type1') and not b:GetAttribute('spell2'))
        ''')

    def test_priest_higher_rank_and_paladin_purify_fallback(self):
        self.lua.execute('''
            known={[988]=true,[552]=true}; units.player.class='PRIEST'; D:Rebuild()
            assert(b:GetAttribute('spell1')=='Spell988' and b:GetAttribute('spell2')=='Spell552')
            known={[1152]=true}; units.player.class='PALADIN'; D:Rebuild()
            assert(not D.byType.Magic and D.byType.Poison==D.byType.Disease)
            assert(b:GetAttribute('spell1')=='Spell1152')
        ''')

    def test_forever_spellbook_override_and_future_spell_rejection(self):
        self.lua.execute('''
            known={}
            C_Spell.GetSpellInfo=function(id)
                if id==4987 or id==999001 then return {name='Cleanse'} end
                return {name='Spell'..id}
            end
            Enum={SpellBookItemType={FutureSpell=9},SpellBookSpellBank={Player=0}}
            local info={spellID=999001}
            C_SpellBook={FindSpellBookSlotForSpell=function(name)
                if name=='Cleanse' then return 3,0 end
            end,GetSpellBookItemInfo=function() return info end}
            D:Rebuild(); assert(b:GetAttribute('spell1')=='Cleanse' and D.actions[1].id==999001)
            info.itemType=9; D:Rebuild(); assert(#D.actions==0)
            info.itemType=nil; info.isPassive=true; D:Rebuild(); assert(#D.actions==0)
        ''')

    def test_legacy_debuff_api_and_shaman_click_priority(self):
        self.lua.execute('''
            known={[2870]=true,[526]=true}; units.player.class='SHAMAN'; D:Rebuild()
            assert(b:GetAttribute('spell1')=='Spell2870' and b:GetAttribute('spell2')=='Spell526')
            C_UnitAuras=nil
            UnitDebuff=function(unit,index)
                if unit=='player' and index==1 then return 'Poison',123,1,'Poison',30,30 end
            end
            D:Refresh(); assert(b.state=='afflicted' and b.background.color[3]==1)
        ''')

    def test_readable_harmful_effect_filter_priority_and_expiration(self):
        self.lua.execute('''
            local original=C_UnitAuras.GetAuraDataByIndex
            C_UnitAuras.GetAuraDataByIndex=function(unit,index,filter)
                assert(filter=='HARMFUL' or filter=='HELPFUL')
                return original(unit,index,filter)
            end
            auras.player={{name='Curse',dispelName='Curse'},
                {name='Expired',dispelName='Magic',expirationTime=1},
                {name='Poison',dispelName='Poison',expirationTime=100}}
            now=2; D:Refresh()
            assert(b.state=='afflicted' and b.affliction=='Poison')
            assert(b.background.color[1]==0.9)
            D.settings.poison=false; D:Rebuild()
            assert(b.state=='clear')
            auras.player={{name='Magic',dispelName='Magic'}}; D:Refresh()
            assert(b.affliction=='Magic')
        ''')

    def test_unknown_data_never_means_clean_and_recovers(self):
        self.lua.execute('''
            auras.player={{name=secret,dispelName=secret}}
            D:Refresh(); assert(b.state=='unknown' and b.label.text=='?')
            auras.player='error'; D:Refresh(); assert(b.state=='unknown')
            auras.player={}; D:Refresh(); assert(b.state=='clear' and not b.afflicted)
            auras.player={{name=secret,dispelName='Magic',expirationTime=secret}}
            D:Refresh(); assert(b.state=='afflicted' and b.affliction=='Magie')
        ''')

    def test_warning_only_on_new_readable_effect_and_throttled(self):
        self.lua.execute('''
            auras.player={{name='Bad',dispelName='Magic'}}
            D:Refresh(); D:Refresh(); assert(#warnings==1)
            auras.player={}; D:Refresh()
            auras.player={{name='Again',dispelName='Disease'}}
            D:Refresh(); assert(#warnings==1)
            auras.player={}; D:Refresh(); now=4
            auras.player={{name='Again',dispelName='Disease'}}
            D:Refresh(); assert(#warnings==2)
            D.settings.sound=false; auras.player={}; D:Refresh(); now=8
            auras.player={{dispelName='Poison'}}; D:Refresh(); assert(#warnings==2)
        ''')

    def test_dead_offline_and_range_status(self):
        self.lua.execute('''
            auras.player={{name='Bad',dispelName='Magic'}}
            units.player.dead=true; D:Refresh(); assert(b.state=='dead' and b.label.text=='D')
            units.player.dead=false; units.player.offline=true
            D:Refresh(); assert(b.state=='offline' and b.label.text=='OFF')
            units.player.offline=false; units.player.outofrange=true
            D:Refresh(); assert(b.state=='afflicted' and b.label.text=='R' and #warnings==0)
            assert(b.background.color[4]==0.3)
        ''')

    def test_combat_updates_visuals_but_freezes_secure_configuration(self):
        self.lua.execute('''
            combat=true
            auras.player={{name='Bad',dispelName='Poison'}}
            Fire('UNIT_AURA','player'); assert(b.state=='afflicted')
            known={[1152]=true}; Fire('SPELLS_CHANGED')
            assert(D.dirty and b:GetAttribute('spell1')=='Spell4987')
            Fire('GROUP_ROSTER_UPDATE')
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(not D.dirty and b:GetAttribute('spell1')=='Spell1152')
            combat=true; ForeverTools:SetEnabled('decursive',false)
            assert(D.dirty and D.display:IsShown())
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(not D.display:IsShown())
        ''')

    def test_raid_tokens_are_fixed_and_visibility_driven_securely(self):
        self.lua.execute('''
            IsInRaid=function() return true end
            units.raid40={name='Last',class='MAGE',guid='last'}
            D:Rebuild()
            local last=D.buttons[45]
            assert(last.unit=='raid40' and last:GetAttribute('unit')=='raid40')
            assert(last.visibilityCondition=='[group:raid,@raid40,exists] show; hide')
            auras.raid40={{name='Bad',dispelName='Magic'}}
            combat=true; D:Refresh(); assert(last.state=='afflicted')
            assert(last:GetAttribute('spell1')=='Spell4987')
        ''')

    def test_native_slots_filter_only_supported_types_and_never_reinspect_children(self):
        self.lua.execute('''
            EnableNativeMock(); D:Rebuild()
            local container=b.native
            assert(container.unit=='player')
            assert(container.slots.cure1.filter=='HARMFUL')
            local types=container.slots.cure1.options.candidateFilters.includeDispelTypes
            assert(types.Magic and types.Poison and types.Disease and not types.Curse)
            assert(not next(container.slots.cure2.options.candidateFilters.includeDispelTypes))
            assert(container.slots.cure1.auraButton.config.showWhenHarmful)
            auras.player='error'; combat=true; D:Refresh()
            assert(b.state=='native' and #warnings==0)
            combat=false; D.settings.magic=false; D:Rebuild()
            assert(not container.slots.cure1.options.candidateFilters.includeDispelTypes.Magic)
            assert(container.slots.cure1.options.candidateFilters.includeDispelTypes.Poison)
        ''')

    def test_native_api_failure_falls_back_without_breaking_secure_casts(self):
        self.lua.execute('''
            EnableNativeMock()
            C_CurveUtil.CreateColorCurve=function() error('unsupported') end
            D:Rebuild(); assert(D.nativeUnavailable and not b.native)
            assert(b:GetAttribute('spell1')=='Spell4987')
            auras.player={{name='Bad',dispelName='Magic'}}; D:Refresh()
            assert(b.state=='afflicted')
        ''')

    def test_position_reset_and_solo_visibility(self):
        self.lua.execute('''
            GetNumSubgroupMembers=function() return 0 end
            D.settings.showSolo=false; D:Rebuild(); assert(not D.display:IsShown())
            D.settings.showSolo=true; D:Rebuild(); assert(D.display:IsShown())
            D.settings.position={point='TOPLEFT',relativePoint='TOPLEFT',x=42,y=-83}
            D:Rebuild(); assert(D.display.position[4]==42)
            combat=true; SlashCmdList.FOREVERTOOLSDECURSIVE('reset')
            assert(D.dirty and D.display.position[4]==42)
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(D.display.position[4]==0 and D.display.position[5]==-160)
        ''')

    def test_right_drag_moves_whole_display_saves_position_and_respects_combat(self):
        self.lua.execute('''
            local starts,stops=0,0
            D.display.StartMoving=function() assert(not combat); starts=starts+1 end
            D.display.StopMovingOrSizing=function() assert(not combat); stops=stops+1 end
            assert(b.dragButtons[1]=='RightButton' and b.clickButtons[1]=='AnyUp')
            assert(b:GetAttribute('useOnKeyDown')==false)
            local spell=b:GetAttribute('spell1')
            b.scripts.OnDragStart(b,'LeftButton'); assert(starts==0)
            b.scripts.OnDragStart(b,'RightButton'); assert(starts==1 and D.moving)
            D.display:SetPoint('TOPLEFT',UIParent,'TOPLEFT',200,-300)
            b.scripts.OnDragStop(b)
            assert(stops==1 and not D.moving)
            assert(D.settings.position.x==200 and D.settings.position.y==-300)
            D:Rebuild(); assert(D.display.position[4]==200 and b:GetAttribute('spell1')==spell)
            combat=true; b.scripts.OnDragStart(b,'RightButton'); b.scripts.OnDragStop(b)
            assert(starts==1 and stops==1 and not D.moving)
            combat=false; b.scripts.OnDragStart(b,'RightButton')
            combat=true; b.scripts.OnDragStop(b); assert(D.moving and stops==1)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(not D.moving and stops==2)
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
