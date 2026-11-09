"""Buff availability, aura restrictions, food expiry and lifecycle in Lua 5.1."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

EXTRA = r'''
members={player={name='Ich',class='MAGE',level=60},party1={name='Priester',class='PRIEST',level=60}}
auras={}; known={[1459]=true}; raid=false
function UnitExists(u) return members[u]~=nil end
function UnitName(u) return members[u].name end
function UnitClass(u) return members[u].class,members[u].class end
function UnitLevel(u) return members[u].level end
function UnitIsUnit(u,v) return u==v or (members[u] and members[u].player) end
function UnitIsConnected(u) return not members[u].offline end
function UnitIsDeadOrGhost(u) return members[u].dead or false end
function IsInRaid() return raid end
function GetNumGroupMembers() local n=0;for _ in pairs(members) do n=n+1 end;return n end
function GetNumSubgroupMembers() return GetNumGroupMembers()-1 end
function GetRaidRosterInfo(i) return '',0,members['raid'..i].group end
function IsSpellKnown(id) return known[id] end
C_Spell={GetSpellName=function(id)
    if id==1459 or id==1460 or id==23028 then return 'Intelligenz' end
    if id==19705 or id==19706 then return 'Satt' end
    return 'Spell'..id
end}
C_UnitAuras={GetAuraDataByIndex=function(u,i,f) assert(u=='player' and f=='HELPFUL');return auras[i] end}
secret={}
function issecretvalue(v) return rawequal(v,secret) end
local create=CreateFrame
function CreateFrame(...)
    local f=create(...)
    function f:SetAllPoints() end
    function f:SetBackdrop() end
    function f:SetBackdropColor() end
    function f:SetBackdropBorderColor() end
    function f:SetColorTexture(...) self.color={...} end
    function f:SetTexture(texture) self.texture=texture end
    function f:ClearAllPoints() end
    function f:UnregisterAllEvents() self.events={} end
    function f:GetPoint() return 'CENTER',nil,'CENTER',20,30 end
    function f:SetOwner(owner) self.owner=owner end
    function f:ClearLines() self.lines={} end
    function f:AddLine(text) self.lines[#self.lines+1]=text end
    function f:Show() self.shown=true end
    function f:Hide() self.shown=false end
    return f
end
function Row(key) for _,r in ipairs(m.rows) do if r.key==key then return r end end end
'''


class BuffCheckTest(unittest.TestCase):
    def test_bar_colors_follow_exact_three_minute_boundary_and_expiry(self):
        self.run_lua('''
            local function FoodButton()
                for _,button in ipairs(m.display.buttons) do
                    if button.row and button.row.key=='food' and button:IsShown() then return button end
                end
            end
            auras={{spellId=19705,name='Satt',icon=12345,expirationTime=181}}
            m:Refresh(); local button=FoodButton()
            assert(button.icon.texture==12345 and not button.label)
            button.scripts.OnEnter(button)
            assert(m.tooltip.lines[1]=='Bufffood')
            button.scripts.OnLeave(button)
            assert(button.time.text=='3:01' and button.color=='green')
            assert(button.background.color[2]>button.background.color[1])
            now=1; m:Refresh()
            assert(button.time.text=='3:00' and button.color=='yellow')
            now=122; m:Refresh()
            assert(button.time.text=='59 s' and button.color=='yellow')
            now=181; m:Refresh()
            assert(button.time.text=='ausgelaufen' and button.color=='red')
            assert(button.background.color[1]>button.background.color[2])
            auras={{spellId=19705,name='Satt',icon=12346,expirationTime=1000}}
            m:Refresh(); assert(button.color=='green' and button.icon.texture==12346)
        ''')

    def test_missing_icons_unknown_data_and_cached_timer_colors(self):
        self.run_lua('''
            for _,button in ipairs(m.display.buttons) do
                assert(button.icon.texture and button.time and not button.label)
                if button.row.state=='missing' then assert(button.color=='red') end
            end
            auras={{spellId=1459,name='Intelligenz',icon=34567,expirationTime=400}}
            m:Refresh()
            local button
            for _,b in ipairs(m.display.buttons) do if b.row.key=='intellect' then button=b end end
            local count=#frames
            auras={secret}; now=220; m:Refresh()
            assert(button.row.state=='cached' and button.color=='yellow')
            assert(button.time.text=='3:00 *' and button.icon.texture==34567)
            now=400; m:Refresh()
            assert(button.color=='red' and button.time.text=='abgelaufen *')
            assert(m.display.notice.shown and #frames==count)
            m.buffCache={}; m:Refresh()
            assert(button.row.state=='unknown' and button.color=='unknown')
            assert(button.icon.texture and button.time.text=='unbekannt')
        ''')

    def test_permanent_buffs_and_unreadable_duration_are_distinguished(self):
        self.run_lua('''
            local text,color=m:RowAppearance({key='intellect',state='active',aura={expirationTime=0}})
            assert(text=='aktiv' and color=='green')
            text,color=m:RowAppearance({key='intellect',state='active',aura={}})
            assert(text=='aktiv' and color=='unknown')
        ''')

    def test_thorns_is_checked_by_default_for_druids_and_all_ranks(self):
        self.run_lua('''
            assert(not m.settings.optional and not Row('thorns'))
            members.party1={name='Druide',class='DRUID',level=6}
            m:Refresh()
            assert(Row('thorns').state=='missing')
            assert(Row('thorns').providers[1].name=='Druide')
            for _,id in ipairs({467,782,1075,8914,9756,9910}) do
                auras={{spellId=id,name='Spell'..id,expirationTime=120}}
                m:Refresh();assert(Row('thorns').state=='active')
            end
            auras={};members.party1.level=5;m:Refresh();assert(not Row('thorns'))
            members.party1=nil;members.player.class='DRUID';known={[467]=true}
            m:Refresh();assert(Row('thorns').state=='missing')
            known={};m:Refresh();assert(not Row('thorns'))
        ''')

    def test_weapon_stones_follow_equipment_and_temporary_enchants(self):
        self.run_lua('''
            weapons={[16]=7,[17]=4}
            function GetInventoryItemLink(_,slot) return weapons[slot] and 'item:'..slot end
            C_Item={GetItemInfoInstant=function(link)
                local slot=tonumber(link:match('item:(%d+)'))
                return slot,'Weapon','',nil,nil,2,weapons[slot]
            end}
            function GetWeaponEnchantInfo() return false,0,0,nil,true,120000,0,123 end
            Fire('PLAYER_EQUIPMENT_CHANGED',16)
            assert(Row('weapon16').label=='Wetzstein (Haupthand)')
            assert(Row('weapon16').state=='missing')
            assert(Row('weapon17').label=='Gewichtsstein (Nebenhand)')
            assert(Row('weapon17').state=='active' and Row('weapon17').aura.expirationTime==120)
            weapons[16]=10;weapons[17]=nil;Fire('PLAYER_EQUIPMENT_CHANGED',16)
            assert(Row('weapon16').label=='Gewichtsstein (Haupthand)' and not Row('weapon17'))
            weapons[16]=2;m:Refresh();assert(not Row('weapon16'))
            local weaponInfo=C_Item.GetItemInfoInstant
            C_Item.GetItemInfoInstant=function() return 1,'Armor','',nil,nil,4,4 end
            weapons[16]=4;m:Refresh();assert(not Row('weapon16'))
            C_Item.GetItemInfoInstant=weaponInfo
            weapons[16]=15
            function GetWeaponEnchantInfo() return true,60000,0,false,0,0 end
            weapons[17]=5
            m:Refresh();assert(Row('weapon16').state=='active' and Row('weapon16').aura.expirationTime==60)
            assert(Row('weapon17').state=='missing')
            function GetWeaponEnchantInfo() return true,secret,0,nil,false,0,0,nil end
            m:Refresh();assert(Row('weapon16').state=='active' and not Row('weapon16').aura.expirationTime)
            function GetWeaponEnchantInfo() return secret,secret,0,nil,false,0,0,nil end
            m:Refresh();assert(Row('weapon16').state=='unknown' and not Row('weapon16').cache)
            GetWeaponEnchantInfo=nil;m:Refresh();assert(Row('weapon16').state=='unknown')
        ''')

    def run_lua(self, code):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + EXTRA + '\nnamespace={}\n')
        for filename in ('Core.lua', 'Modules/BuffCheck.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8'))
        lua.execute("Fire('ADDON_LOADED','ForeverTools');m=namespace.modules.buffcheck;assert(not m.initError,m.initError)")
        lua.execute(code)

    def test_roster_missing_rank_and_group_alternatives(self):
        self.run_lua('''
            assert(Row('fortitude').state=='missing')
            assert(Row('fortitude').providers[1].name=='Priester')
            assert(Row('intellect').state=='missing' and not Row('mark'))
            auras={{spellId=21564,name='Spell21564',expirationTime=200},
                {spellId=999999,name='Intelligenz',expirationTime=120}}
            m:Refresh()
            assert(Row('fortitude').state=='active' and Row('intellect').state=='active')
            members.party1=nil;Fire('GROUP_ROSTER_UPDATE');assert(not Row('fortitude'))
            assert(Row('intellect').state=='active')
            members.party1={name='Priester',class='PRIEST',level=60}
            Fire('GROUP_ROSTER_UPDATE');assert(Row('fortitude').state=='active')
            members.party1=nil;Fire('GROUP_ROSTER_UPDATE');assert(not Row('fortitude'))
            auras={};m:Refresh();assert(not Row('fortitude'))
        ''')

    def test_sleeping_bag_active_missing_cached_and_separate_from_food(self):
        self.run_lua('''
            assert(Row('sleepingBag').state=='missing')
            auras={{spellId=1225478,name='Legacy Well Rested'}};m:Refresh()
            assert(Row('sleepingBag').state=='missing')
            auras={{spellId=429959,name='Schlafsackbonus',expirationTime=120}};m:Refresh()
            assert(Row('sleepingBag').state=='active' and Row('food').state=='missing')
            assert(Row('sleepingBag').aura.expirationTime==120)
            auras={secret};m:Refresh()
            assert(Row('sleepingBag').state=='cached')
            assert(Row('sleepingBag').cache.aura.expirationTime==120)
            now=121;auras={};m:Refresh()
            assert(Row('sleepingBag').state=='missing' and not m.foodAlertFrame)
            m.buffCache={};auras={secret};m:Refresh()
            assert(Row('sleepingBag').state=='unknown')
            C_UnitAuras.GetPlayerAuraBySpellID=function(id)
                if id==429959 then return {name='Schlafsackbonus',expirationTime=300} end
            end
            m:Refresh();assert(Row('sleepingBag').state=='active')
        ''')

    def test_food_active_expired_reapplied_and_custom_food(self):
        self.run_lua('''
            assert(Row('food').state=='missing')
            auras={{spellId=19706,name='Satt',expirationTime=20}};m:Refresh()
            assert(Row('food').state=='active')
            now=21;m:Refresh();assert(Row('food').state=='expired')
            auras={{spellId=777777,name='Forever-Essen',expirationTime=60}}
            SlashCmdList.FOREVERTOOLSBUFF('food 777777')
            assert(Row('food').state=='active')
            auras={};m:Refresh();assert(Row('food').state=='expired')
        ''')

    def test_food_expiry_alert_is_brief_once_and_rearms_after_eating(self):
        self.run_lua('''
            assert(not m.foodAlertFrame)
            m.settings.hidden=true
            auras={{spellId=19705,name='Satt',expirationTime=20}};m:Refresh()
            now=21;auras={};m:Refresh()
            assert(m.foodAlertFrame.shown and not m.display.shown)
            assert(m.foodAlertFrame.text.text=='Dein Bufffood ist ausgelaufen!')
            assert(m.foodAlertUntil==24)
            now=22;m:Refresh();assert(m.foodAlertUntil==24)
            now=25;m.foodAlertFrame.scripts.OnUpdate();assert(not m.foodAlertFrame.shown)
            m:Refresh();assert(not m.foodAlertFrame.shown)
            auras={{spellId=19705,name='Satt',expirationTime=50}};m:Refresh()
            now=51;auras={};m:Refresh();assert(m.foodAlertFrame.shown and m.foodAlertUntil==54)
        ''')

    def test_combat_food_alert_marks_estimate_and_does_not_repeat_on_confirmation(self):
        self.run_lua('''
            auras={{spellId=19705,name='Satt',expirationTime=10}};m:Refresh()
            now=11;auras={secret};m:Refresh()
            assert(m.foodAlertFrame.shown and m.foodAlertUntil==14)
            assert(m.foodAlertFrame.detail.text:find('unbestätigt',1,true))
            now=12;auras={};m:Refresh();assert(m.foodAlertUntil==14)
        ''')

    def test_food_advance_warning_at_sixty_seconds_once_then_expiry(self):
        self.run_lua('''
            m.settings.hidden=true
            auras={{spellId=19705,name='Satt',expirationTime=120}};m:Refresh()
            assert(not m.foodAlertFrame)
            now=59;m:Refresh();assert(not m.foodAlertFrame)
            now=60;m:Refresh()
            assert(m.foodAlertFrame.shown and not m.display.shown)
            assert(m.foodAlertFrame.text.text=='Dein Bufffood läuft gleich aus!')
            assert(m.foodAlertFrame.detail.text=='Noch 60 Sekunden' and m.foodAlertUntil==63)
            now=64;m.foodAlertFrame.scripts.OnUpdate();m:Refresh()
            assert(not m.foodAlertFrame.shown and not m.foodAlertUntil)
            now=119;m:Refresh();assert(not m.foodAlertFrame.shown)
            now=120;auras={};m:Refresh()
            assert(m.foodAlertFrame.text.text=='Dein Bufffood ist ausgelaufen!')
            assert(m.foodAlertFrame.shown and m.foodAlertUntil==123)
        ''')

    def test_food_advance_warning_rearms_after_refresh_and_short_replacement(self):
        self.run_lua('''
            auras={{spellId=19705,name='Satt',expirationTime=50}};m:Refresh()
            assert(m.foodAlertFrame.detail.text=='Noch 50 Sekunden')
            now=5;auras={{spellId=19705,name='Satt',expirationTime=200}};m:Refresh()
            assert(not m.foodWarningExpiry)
            now=140;m:Refresh();assert(m.foodAlertUntil==143 and m.foodWarningExpiry==200)
            now=145;auras={{spellId=19706,name='Satt',expirationTime=190}};m:Refresh()
            assert(m.foodAlertUntil==148 and m.foodAlertFrame.detail.text=='Noch 45 Sekunden')
        ''')

    def test_cached_advance_warning_is_marked_estimated_without_duplicate(self):
        self.run_lua('''
            auras={{spellId=19705,name='Satt',expirationTime=100}};m:Refresh()
            now=40;auras={secret};m:Refresh()
            assert(m.foodAlertFrame.text.text=='Bufffood-Restzeit läuft bald ab')
            assert(m.foodAlertFrame.detail.text:find('unbestätigt',1,true))
            assert(m.foodAlertUntil==43)
            now=41;auras={{spellId=19705,name='Satt',expirationTime=100}};m:Refresh()
            assert(m.foodAlertUntil==43)
            now=100;auras={secret};m:Refresh()
            assert(m.foodAlertFrame.text.text=='Bufffood-Restzeit abgelaufen' and m.foodAlertUntil==103)
        ''')

    def test_unknown_timers_do_not_warn_and_death_clears_warning(self):
        self.run_lua('''
            auras={secret};m:Refresh();assert(not m.foodAlertFrame)
            for _,expiry in ipairs({0,secret}) do
                auras={{spellId=19705,name='Satt',expirationTime=expiry}};m:Refresh()
                assert(not m.foodAlertFrame)
            end
            auras={{spellId=19705,name='Satt',expirationTime=40}};m:Refresh()
            assert(m.foodAlertFrame.shown)
            members.player.dead=true;auras={};Fire('PLAYER_DEAD')
            assert(not m.foodAlertFrame.shown and not m.foodAlertUntil and not m.foodWarningExpiry)
            members.player.dead=false;now=50;m:Refresh();assert(not m.foodAlertFrame.shown)
            SlashCmdList.FOREVERTOOLSBUFF('testwarn')
            assert(m.foodAlertFrame.shown and m.foodAlertFrame.detail.text=='Noch 60 Sekunden')
        ''')

    def test_food_alert_respects_option_disable_and_death(self):
        self.run_lua('''
            m.settings.foodAlert=false
            auras={{spellId=19705,name='Satt',expirationTime=10}};m:Refresh()
            auras={};m:Refresh();assert(not m.foodAlertFrame)
            m.settings.foodAlert=true
            auras={{spellId=19705,name='Satt',expirationTime=120}};m:Refresh()
            members.player.dead=true;auras={};m:Refresh();assert(not m.foodAlertFrame)
            members.player.dead=false;m:Refresh();assert(not m.foodAlertFrame)
            SlashCmdList.FOREVERTOOLSBUFF('test');assert(m.foodAlertFrame.shown)
            namespace:SetEnabled('buffcheck',false);assert(not m.foodAlertFrame.shown)
        ''')

    def test_restrictions_never_report_false_missing(self):
        self.run_lua('''
            m.buffCache={}
            auras={{spellId=secret,name=secret,expirationTime=secret}};m:Refresh()
            assert(Row('fortitude').state=='unknown' and Row('food').state=='unknown')
            auras={{spellId=1243,name='Spell1243',expirationTime=secret},secret};m:Refresh()
            assert(Row('fortitude').state=='active' and Row('food').state=='unknown')
            C_UnitAuras.GetAuraDataByIndex=function() error('restricted') end;m:Refresh()
            assert(Row('food').state=='unknown')
            C_UnitAuras=nil;m:Refresh();assert(Row('food').state=='unknown')
        ''')

    def test_combat_keeps_measured_timer_and_marks_it_unconfirmed(self):
        self.run_lua('''
            auras={{spellId=1243,name='Spell1243',expirationTime=100},
                {spellId=19705,name='Satt',expirationTime=50}}
            m:Refresh();assert(Row('food').state=='active')
            combat=true;now=30;auras={{spellId=secret,name=secret,expirationTime=secret}}
            Fire('PLAYER_REGEN_DISABLED');assert(Row('food').state=='cached')
            assert(Row('food').cache.aura.expirationTime==50)
            assert(m.display.notice.shown and m.display.buttons[#m.rows].text.text:find('20 s',1,true))
            now=51;m:Refresh()
            assert(Row('food').state=='cached')
            assert(m.display.buttons[#m.rows].text.text:find('abgelaufen',1,true))
            combat=false;auras={};Fire('PLAYER_REGEN_ENABLED')
            assert(Row('food').state=='expired' and Row('fortitude').state=='missing')
            assert(not m.display.notice.shown)
        ''')

    def test_targeted_query_reads_buffs_despite_unrelated_secret_aura(self):
        self.run_lua('''
            auras={{spellId=secret,name=secret,expirationTime=secret}}
            C_UnitAuras.GetPlayerAuraBySpellID=function(id)
                if id==1243 then return {name=secret,expirationTime=200} end
                if id==19705 then return {name='Satt',expirationTime=80} end
            end
            m:Refresh()
            assert(Row('fortitude').state=='active' and Row('food').state=='active')
            assert(Row('food').aura.expirationTime==80)
            assert(Row('intellect').state=='cached')
            C_UnitAuras.GetPlayerAuraBySpellID=function() return secret end
            m:Refresh();assert(Row('food').state=='cached')
        ''')

    def test_unknown_without_cache_and_secret_unit_event(self):
        self.run_lua('''
            m.buffCache={};auras={secret};m:Refresh()
            assert(Row('food').state=='unknown' and not m.display.notice.shown)
            Fire('UNIT_AURA',secret)
            assert(Row('food').state=='unknown')
            auras={{spellId=19705,name='Satt',expirationTime=80}};m:Refresh()
            members.player.dead=true;auras={secret};Fire('PLAYER_DEAD')
            assert(Row('food').state=='unknown')
        ''')

    def test_level_offline_optional_and_known_self(self):
        self.run_lua('''
            members.party1.level=0;m:Refresh();assert(not Row('fortitude'))
            members.party1.level=60;members.party1.offline=true;m:Refresh()
            assert(Row('fortitude').state=='unavailable' and not Row('spirit'))
            m.settings.optional=true;m:Refresh();assert(Row('spirit').state=='unavailable')
            known={};m:Refresh();assert(not Row('intellect'))
        ''')

    def test_raid_shout_only_own_subgroup_and_blessing_alternatives(self):
        self.run_lua('''
            raid=true;members={raid1={name='Ich',class='MAGE',level=60,player=true,group=1},
                raid2={name='Krieger',class='WARRIOR',level=60,group=2},
                raid3={name='Paladin',class='PALADIN',level=60,group=2}}
            m:Refresh();assert(not Row('shout') and Row('blessing').state=='missing')
            members.raid2.group=1;auras={{spellId=25898,name='Spell25898'}};m:Refresh()
            assert(Row('shout').state=='missing' and Row('blessing').state=='active')
        ''')

    def test_toggle_solo_drag_and_disable(self):
        self.run_lua('''
            m.display.scripts.OnDragStop(m.display)
            assert(m.settings.x==20 and m.settings.y==30)
            SlashCmdList.FOREVERTOOLSBUFF('hide');assert(not m.display.shown)
            SlashCmdList.FOREVERTOOLSBUFF('show');assert(m.display.shown)
            members.party1=nil;m.settings.showSolo=false;m:OnSettingsChanged();assert(not m.display.shown)
            namespace:SetEnabled('buffcheck',false)
            assert(not m.display.shown and not next(m.events.events) and not m.events.scripts.OnUpdate)
            SlashCmdList.FOREVERTOOLSBUFF('show');assert(namespace:IsEnabled('buffcheck'))
            assert(m.events.events.UNIT_AURA)
        ''')

    def test_legacy_aura_api(self):
        self.run_lua('''
            C_UnitAuras=nil
            function UnitBuff(u,i)
                if i==1 then return 'Satt',nil,1,nil,60,60,nil,nil,nil,19705 end
            end
            m:Refresh();assert(Row('food').state=='active')
        ''')

    def test_buff_tooltip_is_separate_from_enemy_tooltip(self):
        self.run_lua('''
            GameTooltip={SetOwner=function() error('shared tooltip touched') end,
                AddLine=function() error('buff details leaked into unit tooltip') end,
                Hide=function() error('shared tooltip hidden') end}
            local button=m.display.buttons[1]
            button.scripts.OnEnter(button)
            assert(m.tooltip~=GameTooltip and m.tooltip.shown)
            assert(m.tooltip.owner==button and m.tooltip.lines[1]=='Seelenstärke')
            button.scripts.OnLeave(button);assert(not m.tooltip.shown)
            m.display.scripts.OnEnter(m.display)
            assert(m.tooltip.lines[1]=='Deine Gruppe')
            m.display.scripts.OnLeave(m.display);assert(not m.tooltip.shown)
            button.scripts.OnEnter(button)
            namespace:SetEnabled('buffcheck',false);assert(not m.tooltip.shown)
        ''')


if __name__ == '__main__':
    unittest.main()
