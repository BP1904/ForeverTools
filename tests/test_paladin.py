"""Independent paladin module: secure UI, assignment protocol and aura behavior."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime
from test_materials import MATERIAL_MOCK

PALADIN_MOCK = r'''
units={player={name='Anna Forever',class='PALADIN',guid='p',role='HEALER'},
    party1={name='Ben Forever',class='WARRIOR',guid='w',role='TANK'},
    party2={name='Cara Forever',class='MAGE',guid='m',role='DAMAGER'},
    party3={name='Dora Forever',class='PALADIN',guid='p2',role='HEALER'}}
function UnitExists(u) return units[u]~=nil end
function UnitName(u) return units[u] and units[u].name end
GetUnitName=UnitName
function UnitGUID(u) return units[u] and units[u].guid end
function UnitClass(u) return '',units[u].class end
function UnitGroupRolesAssigned(u) return units[u].role end
function UnitIsDeadOrGhost(u) return units[u].dead or false end
function UnitIsConnected(u) return not units[u].offline end
function UnitIsGroupLeader(u) return units[u].leader or false end
function UnitIsGroupAssistant(u) return units[u].assistant or false end
function GetNumGroupMembers() return 4 end
function GetNumSubgroupMembers() return 3 end
function IsInRaid() return false end
function IsInGroup(category) return false end
LE_PARTY_CATEGORY_INSTANCE=2
known={[19740]=true,[19742]=true,[20217]=true,[1038]=true,[25895]=true,
    [25780]=true,[465]=true,[1311656]=true}
C_Spell.GetSpellInfo=function(id) return {name='Spell'..id} end
C_Spell.IsSpellInRange=function(spell,unit) return not units[unit].outofrange end
auras={}
secret={}
function issecretvalue(value) return value==secret end
C_UnitAuras={GetAuraDataByIndex=function(u,i)
    if auras[u]=='error' then error('restricted') end
    return (auras[u] or {})[i]
end}
sent={}
C_ChatInfo={RegisterAddonMessagePrefix=function(p) assert(p=='PLPWR') end,
    SendAddonMessage=function(p,m,c) sent[#sent+1]={prefix=p,message=m,channel=c} end}
local baseCreate=CreateFrame
function CreateFrame(kind,name,parent,template)
    local f=baseCreate(kind,name)
    f.protected=template and string.find(template,'SecureActionButtonTemplate',1,true)
    function f:SetSize(w,h) self.width=w; self.height=h end
    function f:SetPoint(point,parent,relativePoint,x,y)
        self.position={point,parent,relativePoint,x,y}
    end
    function f:GetPoint() return unpack(self.position) end
    f.attributes={}; f.CloseButton={SetScript=function() end}
    function f:SetAttribute(key,value)
        assert(not combat,'protected mutation during combat')
        self.attributes[key]=value
    end
    function f:GetAttribute(key) return self.attributes[key] end
    function f:RegisterForClicks() end
    function f:EnableMouseWheel() end
    function f:HookScript(event,fn)
        self.hooks=self.hooks or {}; self.hooks[event]=fn
    end
    function f:RegisterAutoHide(delay) self.hideDelay=delay end
    function f:AddToAutoHide(child)
        self.autoHide=self.autoHide or {}; self.autoHide[#self.autoHide+1]=child
    end
    function f:ClearAllPoints() self.position=nil end
    function f:SetFrameRef(key,value)
        assert(not combat); self.refs=self.refs or {}; self.refs[key]=value
    end
    function f:GetFrameRef(key) return self.refs and self.refs[key] end
    function f:Hide() self:SetShown(false) end
    function f:Show() self:SetShown(true) end
    function f:CreateTexture()
        local t={}
        function t:SetAllPoints() end
        function t:SetColorTexture(...) self.color={...} end
        function t:SetSize(w,h) self.width=w; self.height=h end
        function t:SetPoint(...) self.point={...} end
        function t:SetTexture(texture) self.texture=texture end
        return t
    end
    function f:SetBackdrop() end
    function f:SetBackdropColor() end
    function f:SetBackdropBorderColor() end
    function f:SetVerticalScroll(value) self.scrollOffset=value end
    local oldShow=f.SetShown
    function f:SetShown(shown)
        assert(not combat or secureContext,'protected visibility during combat')
        oldShow(self,shown)
    end
    return f
end
'''


class PaladinTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + MATERIAL_MOCK + PALADIN_MOCK)
        self.lua.execute('namespace={}')
        toc = (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8')
        for line in toc.splitlines():
            if line and not line.startswith(('#', 'Features\\')):
                source = (ROOT / 'ForeverTools' / line.replace('\\', '/')).read_text(encoding='utf-8')
                self.lua.execute('assert(loadstring(...))("ForeverTools",namespace)', source)
        self.lua.execute('''
            Fire('ADDON_LOADED','ForeverTools')
            P=ForeverTools.modules.paladin; own=P:Profile(P.player)
            own.classes[1]=2; own.classes[5]=3; own.classes[7]=1
        ''')

    def test_window_menu_and_secure_spell_setup(self):
        self.lua.execute('''
            SlashCmdList.FOREVERTOOLSPALADIN(); assert(P.window:IsShown())
            assert(#P.roster==4 and #P.paladins==2)
            assert(P.classCasts[1]:GetAttribute('spell1')=='Spell19740')
            assert(P.classCasts[1]:GetAttribute('spell2')=='Spell19740')
            assert(P.classCasts[1]:GetAttribute('unit')=='Ben Forever')
            SlashCmdList.FOREVERTOOLS(); assert(#ForeverTools.menu.checks==40)
        ''')

    def test_greater_left_normal_right_and_player_override(self):
        self.lua.execute('''
            known[25782]=true; P:ScanSpells(); P:ToggleWindow()
            local b=P.classCasts[1]
            assert(b:GetAttribute('spell1')=='Spell25782' and b:GetAttribute('spell2')=='Spell19740')
            own.players['Ben Forever']=3; P:Refresh()
            local row
            for _,r in ipairs(P.rows) do if r.member and r.member.name=='Ben Forever' then row=r end end
            assert(row.buff:GetAttribute('spell1')=='Spell20217')
            assert(row.buff:GetAttribute('spell2')=='Spell20217')
        ''')

    def test_combat_freezes_attributes_and_defers_disable(self):
        self.lua.execute('''
            P:ToggleWindow(); local target=P.smart:GetAttribute('unit')
            combat=true; own.classes[1]=3
            P:Cycle(1); P:AutoAssign(); P:Preset(false)
            Fire('GROUP_ROSTER_UPDATE'); Fire('UNIT_AURA','party1')
            P.smart.scripts.PreClick(P.smart)
            assert(P.smart:GetAttribute('unit')==target)
            ForeverTools:SetEnabled('paladin',false)
            assert(P.window:IsShown())
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(not P.window:IsShown())
        ''')

    def test_mouse_down_up_does_not_advance_twice(self):
        self.lua.execute('''
            now=10; own.classes[5]=2; P.settings.duration=false; P:ToggleWindow()
            P.smart.scripts.PreClick(P.smart); local target=P.smart:GetAttribute('unit')
            P.smart.scripts.PostClick(P.smart); now=now+0.1
            P.smart.scripts.PreClick(P.smart); assert(P.smart:GetAttribute('unit')==target)
            now=now+1; P.smart.scripts.PreClick(P.smart)
            assert(P.smart:GetAttribute('unit')~=target)
        ''')

    def test_smart_avoids_dead_offline_out_of_range_and_fresh_buffs(self):
        self.lua.execute('''
            units.party1.dead=true; units.party2.outofrange=true; units.party3.offline=true
            auras.player={{name='Spell20217',expirationTime=3600}}
            assert(P:Pick()==nil)
            auras.player={}; assert(P:Pick().name=='Anna Forever')
            units.player.offline=true; assert(P:Pick()==nil)
        ''')

    def test_salvation_excludes_tanks_and_mass_on_mixed_class(self):
        self.lua.execute('''
            P.settings.salvation=true; P:ToggleWindow()
            for _,r in ipairs(P.rows) do
                if r.member and r.member.tank then assert(not r.salv:GetAttribute('type1')) end
            end
            assert(P:Pick(1,true)==nil)
            units.party3.role='TANK'; P:Roster()
            local b=CreateFrame('Button'); P:PrepareSmart(b,5,true)
            assert(b:GetAttribute('spell1')=='Spell1038')
            assert(b:GetAttribute('unit')=='Anna Forever')
        ''')

    def test_secret_aura_uses_measured_timer_and_readable_absence_clears(self):
        self.lua.execute('''
            local r=P.byName['Cara Forever']
            auras.party2={{name='Spell19742',expirationTime=600}}
            assert(P:BuffRemaining(r,1)==600)
            auras.party2={{name=secret}}; now=100
            assert(P:BuffRemaining(r,1)==500)
            auras.party2={}; assert(P:BuffRemaining(r,1)==0)
            auras.party2='error'; assert(P:BuffRemaining(r,1)==nil)
            auras.party2={{name='Spell19742',expirationTime=secret}}
            assert(P:BuffRemaining(r,1)==nil)
        ''')

    def test_recycled_unit_slot_does_not_reuse_previous_timer(self):
        self.lua.execute('''
            local r=P.byName['Cara Forever']; units.party2.guid='replacement'
            assert(P:BuffRemaining(r,1)==nil)
        ''')

    def test_sync_names_permissions_and_malformed_messages(self):
        self.lua.execute('''
            local function Receive(m,s) P:Receive('PLPWR',m,'PARTY',s or 'Dora Forever') end
            Receive('SELF 101010nnnnnn@123000000')
            assert(P:Profile('Dora Forever').classes[3]==3)
            Receive('ASSIGN Anna Forever 1 3'); assert(own.classes[1]==2)
            units.party3.leader=true
            Receive('ASSIGN Anna Forever 1 3'); assert(own.classes[1]==3)
            Receive('NASSIGN Anna_Forever 7 Cara_Forever 2')
            assert(own.players['Cara Forever']==2)
            Receive('NASSIGN Anna_Forever 7 Cara_Forever 0'); assert(not own.players['Cara Forever'])
            for _,m in ipairs({'SELF x@y','ASSIGN Anna Forever -1 99','NASSIGN ?','ASELF nn@99','AASSIGN Anna Forever 99'}) do Receive(m) end
            Receive('ASSIGN Anna Forever 1 1','outsider'); assert(own.classes[1]==3)
            Receive('ASSIGN Anna Forever 1 1','Dora Forever-Realm'); assert(own.classes[1]==1)
            P.settings.sync=false; Receive('ASSIGN Anna Forever 1 3'); assert(own.classes[1]==1)
        ''')

    def test_sync_throttling_broadcast_and_disabling_queue(self):
        self.lua.execute('''
            P:Broadcast(); assert(#P.outbox>=4 and #sent==0)
            Advance(1); assert(#sent==1 and sent[1].prefix=='PLPWR')
            assert(string.find(sent[1].message,'SELF ',1,true)==1)
            ForeverTools:SetEnabled('paladin',false); assert(#P.outbox==0)
            Advance(20); assert(#sent==1)
        ''')

    def test_presets_cycle_self_and_auto_assign_unique_blessings(self):
        self.lua.execute('''
            P:Preset(false)
            P:Preset(true); own.classes[1]=0; P:Preset(false)
            own=P:Profile(P.player); assert(own.classes[1]==2)
            P:CycleSelf('aura',namespace.paladinData.auras); assert(own.aura==1)
            P:CycleSelf('seal',namespace.paladinData.seals); assert(own.seal==11)
            P.capabilities['Dora Forever']={[1]=true,[2]=true,[3]=true}
            units.player.leader=true; P:AutoAssign()
            assert(own.classes[1]==2 and P:Profile('Dora Forever').classes[1]==3)
            assert(own.classes[7]==1 and P:Profile('Dora Forever').classes[7]==3)
        ''')

    def test_rogue_no_spells_and_no_group_are_tolerated(self):
        self.lua.execute('''
            known={}; units.player.class='ROGUE'; P:ScanSpells()
            GetNumGroupMembers=function() return 0 end
            GetNumSubgroupMembers=function() return 0 end
            P.settings.showSolo=false; P:ToggleWindow(); assert(not P.window:IsShown())
            P.settings.showSolo=true; P:Refresh(); assert(P.window:IsShown())
            assert(not P.smart:GetAttribute('type1'))
        ''')

    def test_compact_bar_appears_at_login_without_opening_editor(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN')
            assert(P.bar.frame:IsShown() and not P.window)
            assert(P.bar.frame.width==100 and P.bar.frame.height<250)
            SlashCmdList.FOREVERTOOLS(); SlashCmdList.FOREVERTOOLS()
            assert(P.bar.frame:IsShown())
            P:ToggleWindow(); P:ToggleWindow()
            assert(not P.window:IsShown() and P.bar.frame:IsShown())
            P.settings.showSolo=false
            GetNumGroupMembers=function() return 0 end
            GetNumSubgroupMembers=function() return 0 end
            Fire('GROUP_ROSTER_UPDATE'); assert(P.bar.frame:IsShown())
        ''')

    def test_compact_bar_position_saved_and_restored(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN')
            P.bar.frame:SetPoint('BOTTOMLEFT',UIParent,'BOTTOMLEFT',37,135)
            P.bar.frame.scripts.OnDragStop()
            assert(P.db.barPosition.x==37 and P.db.barPosition.y==135)
            P.bar=nil; P:CreateBar()
            local point,parent,relative,x,y=P.bar.frame:GetPoint()
            assert(point=='BOTTOMLEFT' and parent==UIParent and x==37 and y==135)
        ''')

    def test_compact_bar_spells_and_status_work_with_closed_editor(self):
        self.lua.execute('''
            own.aura=1; own.seal=11; Fire('PLAYER_LOGIN')
            assert(P.bar.classes[1]:GetAttribute('spell1')=='Spell19740')
            assert(P.bar.aura:GetAttribute('spell1')=='Spell465')
            assert(P.bar.seal:GetAttribute('spell2')=='Spell1311656')
            assert(P.bar.seal~=P.bar.fury)
            assert(P.bar.fury:GetAttribute('spell1')=='Spell25780')
            assert(P.bar.fury:GetAttribute('spell2')=='Spell25780')
            assert(not P.bar.smart:IsShown())
            assert(P.bar.fury:GetAttribute('unit')=='player')
            assert(not P.bar.salvation:IsShown() and not P.window)
            assert(string.find(P.bar.classes[7].count.text,'1',1,true))
            auras.party2={{name='Spell19742',expirationTime=3600}}
            Fire('UNIT_AURA','party2')
            assert(P.bar.classes[7].state=='good')
            P.settings.salvation=true; P:OnSettingsChanged()
            assert(P.bar.salvation:IsShown())
        ''')

    def test_compact_bar_combat_keeps_visibility_and_defers_hide(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); local target=P.bar.smart:GetAttribute('unit')
            combat=true; Fire('GROUP_ROSTER_UPDATE'); Advance(3)
            P.bar.smart.scripts.PreClick(P.bar.smart)
            assert(P.bar.frame:IsShown() and P.bar.smart:GetAttribute('unit')==target)
            P.bar.settings.scripts.OnClick(); assert(P.db.open and not P.window)
            ForeverTools:SetEnabled('paladin',false); assert(P.bar.frame:IsShown())
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(not P.bar.frame:IsShown())
            ForeverTools:SetEnabled('paladin',true); assert(P.bar.frame:IsShown())
        ''')

    def test_original_style_player_flyout_and_secure_hover_in_combat(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN')
            local b=P.bar.classes[5]
            assert(#b.players==2 and b.popup.width==148)
            assert(b.players[1].name.text=='Anna')
            assert(b.players[1]:GetAttribute('unit')=='Anna Forever')
            assert(b.hooks.OnEnter and not b.scripts.OnEnter)
            local function Hover(button)
                secureContext=true
                local fn=assert(loadstring(button:GetAttribute('_onenter')))
                setfenv(fn,setmetatable({self=button},{__index=_G})); fn()
                secureContext=false
            end
            combat=true; Hover(b)
            assert(b.popup:IsShown() and b.popup.hideDelay==0.6 and #b.popup.autoHide==3)
            Hover(P.bar.classes[1]); assert(not b.popup:IsShown())
            assert(b.players[1]:GetAttribute('unit')=='Anna Forever')
        ''')

    def test_original_style_colors_timer_and_exception(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); local b=P.bar.classes[5]
            assert(b.state=='all' and b.count.text=='2')
            auras.player={{name='Spell20217',expirationTime=3600}}; P:UpdateTimers()
            assert(b.state=='some' and b.count.text=='1' and b.time.text~='')
            own.players['Dora Forever']=1; P:Refresh()
            assert(b.state=='special' and b.time2.text=='')
            auras.party3={{name='Spell19742',expirationTime=1200}}; P:UpdateTimers()
            assert(b.state=='good' and b.count.text=='')
            assert(string.find(b.time.text,'20:00',1,true) and b.time2.text=='')
            units.party1.dead=true; P:UpdateTimers()
            assert(string.find(P.bar.classes[1].players[1].flags.text,'D',1,true))
        ''')

    def test_absent_classes_collapse_and_old_flyout_members_clear(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); local height=P.bar.frame.height
            assert(not P.bar.classes[2]:IsShown())
            units.party3=nil; GetNumSubgroupMembers=function() return 2 end
            Fire('GROUP_ROSTER_UPDATE')
            local p=P.bar.classes[5].players[2]
            assert(not p:IsShown() and not p.member and not p:GetAttribute('unit'))
            units.party2=nil; GetNumSubgroupMembers=function() return 1 end
            Fire('GROUP_ROSTER_UPDATE')
            assert(not P.bar.classes[7]:IsShown() and P.bar.frame.height<height)
        ''')

    def test_move_button_drags_entire_bar_and_saves_position(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); local f=P.bar.frame
            local starts,stops=0,0
            f.StartMoving=function() starts=starts+1 end
            f.StopMovingOrSizing=function() stops=stops+1 end
            P.bar.move.scripts.OnDragStart()
            f:SetPoint('TOPLEFT',UIParent,'TOPLEFT',150,-220)
            P.bar.move.scripts.OnDragStop()
            assert(starts==1 and stops==1 and P.db.barPosition.x==150 and P.db.barPosition.y==-220)
            combat=true; P.bar.move.scripts.OnDragStart(); P.bar.move.scripts.OnDragStop()
            assert(starts==1 and stops==1)
        ''')

    def test_self_buffs_have_independent_fields_and_only_one_timer(self):
        self.lua.execute('''
            own.aura=1; own.seal=11; Fire('PLAYER_LOGIN')
            auras.player={{name='Spell465',expirationTime=900},{name='Spell25780',expirationTime=1800},
                {name='Spell1311656',expirationTime=600},{name='Spell20217',expirationTime=1200}}
            P:UpdateTimers()
            assert(string.find(P.bar.fury.time.text,'30:00',1,true))
            assert(string.find(P.bar.seal.time.text,'10:00',1,true))
            for _,b in ipairs({P.bar.fury,P.bar.seal,P.bar.aura,P.bar.classes[5]}) do
                assert(b.time2.text=='')
            end
            assert(not P.bar.fury.buffIcon.texture and not P.bar.fury.scripts.OnMouseWheel)
            assert(P.bar.seal.scripts.OnMouseWheel and not P.bar.smart:IsShown())
        ''')

    def test_short_seal_stays_green_until_expiration_and_reapplication(self):
        self.lua.execute('''
            own.seal=11; Fire('PLAYER_LOGIN')
            local b=P.bar.seal
            auras.player={{name='Spell1311656',expirationTime=7}}
            Fire('UNIT_AURA','player')
            assert(b.background.color[1]==0 and b.background.color[2]==0.55)
            assert(b.time.text=='|cff55ee880:07|r')
            now=6.9; P:UpdateTimers()
            assert(b.background.color[2]==0.55)
            now=7; P:UpdateTimers()
            assert(b.background.color[1]==0.8 and b.background.color[2]==0)
            auras.player={}; Fire('UNIT_AURA','player')
            assert(b.background.color[1]==0.8)
            auras.player={{name='Spell1311656',expirationTime=37}}
            Fire('UNIT_AURA','player')
            assert(b.background.color[2]==0.55)
            auras.player='error'; P.auraCache={}; Fire('UNIT_AURA','player')
            assert(b.background.color[1]==0.2 and b.background.color[2]==0.2)
        ''')

    def test_every_aura_can_be_selected_when_only_higher_ranks_are_known(self):
        self.lua.execute('''
            known={[10293]=true,[10301]=true,[19746]=true,[19896]=true,
                [19898]=true,[19900]=true,[20218]=true,[32223]=true}
            P:ScanSpells(); Fire('PLAYER_LOGIN')
            local expected={10293,10301,19746,19896,19898,19900,20218,32223}
            own.aura=0
            for index,id in ipairs(expected) do
                P.bar.aura.scripts.OnMouseWheel(nil,1)
                assert(own.aura==index and P:AuraSpell(index)==id)
                assert(P.bar.aura:GetAttribute('spell1')=='Spell'..id)
                assert(P.bar.aura:GetAttribute('spell2')=='Spell'..id)
                assert(P.auraCapabilities[P.player][index])
            end
            P:CycleSelf('aura',namespace.paladinData.auras); assert(own.aura==0)
            P:CycleSelf('aura',namespace.paladinData.auras,true); assert(own.aura==8)
            P:ToggleWindow(); own.aura=1; P:Refresh()
            assert(P.auraButton:GetAttribute('spell1')=='Spell10293')
            P.outbox={}; P:Broadcast()
            local found=false
            for _,m in ipairs(P.outbox) do if m=='ASELF 1010101010101010@1' then found=true end end
            assert(found)
        ''')

    def test_aura_rank_updates_after_learning_and_modern_false_has_fallback(self):
        self.lua.execute('''
            known={[10290]=true,[10293]=true}
            C_SpellBook={IsSpellKnown=function() return false end}
            P:ScanSpells(); assert(P:AuraSpell(1)==10293)
            own.aura=1; Fire('PLAYER_LOGIN')
            assert(P.bar.aura:GetAttribute('spell1')=='Spell10293')
            known={[10290]=true}; Fire('SPELLS_CHANGED')
            assert(P.bar.aura:GetAttribute('spell1')=='Spell10290')
            known[10301]=true; Fire('SPELLS_CHANGED'); own.aura=1
            P:CycleAssignedAura(); assert(own.aura==2)
            combat=true; known[10293]=true; Fire('SPELLS_CHANGED')
            assert(P:AuraSpell(1)==10293)
            assert(P.bar.aura:GetAttribute('spell1')=='Spell10301')
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(P.bar.aura:GetAttribute('spell1')=='Spell10301')
        ''')

    def test_unknown_auras_are_skipped_and_base_rank_still_works(self):
        self.lua.execute('''
            known={[465]=true,[19898]=true}; P:ScanSpells()
            own.aura=0; P:CycleSelf('aura',namespace.paladinData.auras)
            assert(own.aura==1 and P:AuraSpell(1)==465)
            P:CycleSelf('aura',namespace.paladinData.auras); assert(own.aura==5)
            P:CycleSelf('aura',namespace.paladinData.auras); assert(own.aura==0)
            assert(not P:AuraSpell(2) and not P:AuraSpell(8))
        ''')

    def test_spellbook_resolves_client_specific_aura_rank_and_rejects_future_spell(self):
        self.lua.execute('''
            known={}
            local original=C_Spell.GetSpellInfo
            C_Spell.GetSpellInfo=function(id)
                if id==1300001 or id==465 then return {name='Devotion Aura',iconID=1} end
                return original(id)
            end
            Enum.SpellBookSpellBank={Player=0}; Enum.SpellBookItemType={FutureSpell=9}
            local future=false
            C_SpellBook={
                FindSpellBookSlotForSpell=function(name)
                    if name=='Devotion Aura' then return 17,0 end
                end,
                GetSpellBookItemInfo=function(slot,bank)
                    assert(slot==17 and bank==0)
                    return {spellID=1300001,itemType=future and 9 or 1}
                end,
            }
            P:ScanSpells(); assert(P:AuraSpell(1)==1300001)
            P:CycleSelf('aura',namespace.paladinData.auras); assert(own.aura==1)
            assert(P.bar.aura:GetAttribute('spell1')=='Devotion Aura')
            future=true; P:ScanSpells(); assert(not P:AuraSpell(1))
            C_SpellBook.GetSpellBookItemInfo=function() error('unavailable') end
            P:ScanSpells(); assert(not P:AuraSpell(1))
        ''')

    def test_class_click_can_refresh_an_already_active_blessing(self):
        self.lua.execute('''
            auras.player={{name='Spell20217',expirationTime=3600}}
            auras.party3={{name='Spell20217',expirationTime=3600}}
            Fire('PLAYER_LOGIN')
            assert(P:Pick(5)==nil)
            local b=P.bar.classes[5]
            assert(b:GetAttribute('type1')=='macro' and b:GetAttribute('type2')=='macro')
            assert(b:GetAttribute('macrotext1')=='/cast [@Anna Forever,help,nodead] Spell20217')
            assert(b:GetAttribute('macrotext2')=='/cast [@Anna Forever,help,nodead] Spell20217')
            b.scripts.PreClick(b,'LeftButton')
            assert(b:GetAttribute('macrotext1'))
        ''')

    def test_click_dispatch_uses_full_name_and_correct_left_right_blessing(self):
        self.lua.execute('''
            known[25782]=true; P:ScanSpells(); Fire('PLAYER_LOGIN')
            local function Click(button,mouse)
                if button.scripts.PreClick then button.scripts.PreClick(button,mouse) end
                local suffix=mouse=='LeftButton' and '1' or '2'
                assert(button:GetAttribute('type'..suffix)=='macro')
                local name,spell=button:GetAttribute('macrotext'..suffix):match('^/cast %[@(.-),help,nodead%] (.+)$')
                assert(P.byName[name] and spell)
                return name,spell
            end
            local b=P.bar.classes[1]
            local name,spell=Click(b,'LeftButton')
            assert(name=='Ben Forever' and spell=='Spell25782')
            name,spell=Click(b,'RightButton')
            assert(name=='Ben Forever' and spell=='Spell19740')
            own.players['Ben Forever']=3; P:Refresh()
            local p=b.players[1]
            name,spell=Click(p,'LeftButton')
            assert(name=='Ben Forever' and spell=='Spell20217')
            combat=true
            name,spell=Click(p,'RightButton')
            assert(name=='Ben Forever' and spell=='Spell20217')
        ''')

    def test_class_manual_cast_with_unknown_aura_or_unknown_range(self):
        self.lua.execute('''
            auras.player='error'; auras.party3='error'
            C_Spell.IsSpellInRange=function() return nil end
            Fire('PLAYER_LOGIN')
            assert(P:Pick(5)==nil)
            local b=P.bar.classes[5]
            assert(b:GetAttribute('macrotext1')=='/cast [@Anna Forever,help,nodead] Spell20217')
            C_Spell.IsSpellInRange=function() return false end
            P:Refresh(); assert(not b:GetAttribute('macrotext1') and not b:GetAttribute('type1'))
        ''')

    def test_no_cast_binding_for_dead_offline_or_absent_recipients(self):
        self.lua.execute('''
            units.player.dead=true; units.party3.offline=true
            Fire('PLAYER_LOGIN')
            local b=P.bar.classes[5]
            assert(not b:GetAttribute('type1') and not b:GetAttribute('macrotext1'))
            units.player.dead=false; P:Refresh()
            assert(b:GetAttribute('macrotext1'))
            units.player.offline=true; P:Refresh()
            assert(not b:GetAttribute('macrotext1') and not b:GetAttribute('macrotext2'))
        ''')

    def test_screenshot_grid_layout_and_direct_class_assignment(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); P:ToggleWindow()
            assert(P.window.width==912 and P.window.height==295)
            assert(P.window:IsShown() and not P.detailWindow:IsShown())
            assert(#P.gridRows==2 and P.gridHeaders[5].text=='Anna +1')
            local ownRow=P.gridRows[1]
            assert(ownRow.owner=='Anna Forever' and ownRow.name.text=='Anna Forever')
            local selected=P.selected
            ownRow.cells[1].scripts.OnClick(nil,'LeftButton')
            assert(own.classes[1]==3 and P.selected==selected)
            ownRow.cells[1].scripts.OnClick(nil,'RightButton')
            assert(own.classes[1]==2 and P.bar.classes[1]:GetAttribute('macrotext1'))
            ownRow.cells[0].scripts.OnClick(nil,'LeftButton'); assert(own.aura==1)
            assert(P.bar.aura:GetAttribute('spell1')=='Spell465')
        ''')

    def test_screenshot_grid_permissions_options_and_combat(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); P:ToggleWindow()
            local other=P.gridRows[2]
            assert(other.cells[1].enabled==false)
            P.capabilities['Dora Forever']={[1]=true,[2]=true,[3]=true}
            units.player.leader=true; P:Refresh()
            assert(other.cells[1].enabled)
            other.cells[1].scripts.OnClick(nil,'LeftButton')
            assert(P:Profile('Dora Forever').classes[1]==1)
            P.gridOptions.scripts.OnClick(); assert(P.detailWindow:IsShown())
            P.gridOptions.scripts.OnClick(); assert(not P.detailWindow:IsShown())
            combat=true; other.cells[1].scripts.OnClick(nil,'LeftButton')
            assert(P:Profile('Dora Forever').classes[1]==1)
            P.gridOptions.scripts.OnClick(); assert(not P.db.detailsOpen)
        ''')

    def test_screenshot_grid_free_assignment_and_salvation(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); P:ToggleWindow()
            P.gridFree:SetChecked(true); P.gridFree.scripts.OnClick(P.gridFree)
            assert(P.settings.freeassign)
            local ownRow=P.gridRows[1]
            ownRow.salvation:SetChecked(true); ownRow.salvation.scripts.OnClick(ownRow.salvation)
            assert(P.settings.salvation and P.bar.salvation:IsShown())
            P:Receive('PLPWR','SALV YES','PARTY','Dora Forever'); P:Refresh()
            assert(P.gridRows[2].salvation:GetChecked())
        ''')

    def test_screenshot_grid_clear_preserves_uncontrolled_paladins(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); P:ToggleWindow()
            local other=P:Profile('Dora Forever'); other.classes[1]=3
            own.players['Ben Forever']=3; own.aura=1
            P:ClearGridAssignments()
            assert(not next(own.classes) and not next(own.players) and own.aura==0)
            assert(other.classes[1]==3 and P.bar.frame:IsShown())
            assert(not P.gridRows[2].cells[1].enabled)
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
