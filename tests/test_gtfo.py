"""Warning sounds, native registrations and readable fallback events."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime
from test_materials import MATERIAL_MOCK
from test_paladin import PALADIN_MOCK

GTFO_MOCK = r'''
played,stopped,visual={},{},{}
function PlaySoundFile(path,channel)
    played[#played+1]={path=path,channel=channel}
    return true,#played
end
function StopSound(handle) stopped[#stopped+1]=handle end
UIErrorsFrame={AddMessage=function(_,message) visual[#visual+1]=message end}
function UnitHealthMax() return 1000 end
function UnitLevel() return 30 end
breathTime=1000
function GetMirrorTimerProgress() return breathTime end
function Hit(id,source,dest,event,amount)
    G:CombatLog(0,event or 'SPELL_DAMAGE',false,source or 'Creature-0-0-0-0-123-abc',
        'Enemy',0,0,dest or 'p','Player',0,0,id,'Danger',4,amount or 100)
end
'''


class GTFOTest(unittest.TestCase):
    def load_restricted_client(self, interface, capabilities=''):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + MATERIAL_MOCK + PALADIN_MOCK + GTFO_MOCK)
        lua.execute('''
            forbiddenRegistrations=0
            known[4987]=true
            function RegisterStateDriver(frame,state,condition)
                assert(not combat); frame.visibilityCondition=condition
            end
            local create=CreateFrame
            function CreateFrame(...)
                local frame=create(...)
                local register=frame.RegisterEvent
                function frame:RegisterEvent(event)
                    if event=='COMBAT_LOG_EVENT_UNFILTERED' or event=='COMBAT_LOG_EVENT' then
                        forbiddenRegistrations=forbiddenRegistrations+1
                        error('ADDON_ACTION_FORBIDDEN: protected registration')
                    end
                    register(self,event)
                end
                return frame
            end
            namespace={}
        ''')
        if interface is not None:
            lua.execute('function GetBuildInfo() return "client", "70425", "date", ... end'.replace('...', str(interface)))
        lua.execute(capabilities)
        for line in (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8').splitlines():
            if line and not line.startswith(('#', 'Features\\')):
                source = (ROOT / 'ForeverTools' / line.replace('\\', '/')).read_text(encoding='utf-8')
                lua.execute('assert(loadstring(...))("ForeverTools",namespace)', source)
        lua.execute('Fire("ADDON_LOADED","ForeverTools"); G=ForeverTools.modules.gtfo')
        return lua

    def test_forever_startup_never_attempts_forbidden_combatlog_registration(self):
        lua = self.load_restricted_client(16001)
        lua.execute('''
            assert(forbiddenRegistrations==0 and G.combatLogSupported==false)
            assert(not G.frame.events.COMBAT_LOG_EVENT_UNFILTERED)
            local D=ForeverTools.modules.decursive
            assert(D.frame and D.display:IsShown() and #D.buttons==45)
            assert(D.buttons[1]:GetAttribute('spell1')=='Spell4987')
            Fire('PLAYER_LOGIN'); Fire('PLAYER_ENTERING_WORLD')
            assert(forbiddenRegistrations==0)
            G:Command('add 123 high'); auras.player={{spellId=123}}
            Fire('UNIT_AURA','player'); assert(#played==1)
            G:Status()
        ''')

    def test_modern_and_unknown_restricted_clients_do_not_probe_combatlog(self):
        for interface, capabilities in (
            (120100, ''),
            (None, 'C_DamageMeter={}'),
            (None, 'C_CombatLog={IsCombatLogRestricted=function() return false end}'),
            (None, 'C_RestrictedActions={GetAddOnRestrictionState=function() return 0 end}'),
        ):
            with self.subTest(interface=interface, capabilities=capabilities):
                lua = self.load_restricted_client(interface, capabilities)
                lua.execute('assert(forbiddenRegistrations==0 and not G.combatLogSupported)')

    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + MATERIAL_MOCK + PALADIN_MOCK + GTFO_MOCK)
        self.lua.execute('namespace={}')
        toc = (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8')
        for line in toc.splitlines():
            if line and not line.startswith(('#', 'Features\\')):
                source = (ROOT / 'ForeverTools' / line.replace('\\', '/')).read_text(encoding='utf-8')
                self.lua.execute('assert(loadstring(...))("ForeverTools",namespace)', source)
        self.lua.execute('Fire("ADDON_LOADED","ForeverTools"); G=ForeverTools.modules.gtfo')

    def test_classic_is_enabled_by_default_and_can_be_disabled(self):
        self.lua.execute('''
            assert(G.settings.classic and G.settings.classicDefaultApplied)
            assert(G.rules[19428] and G.rules[15284])
            assert(not G.rules[28062] and not G.rules[30122])
            G.settings.classic=false; G:OnSettingsChanged(); assert(not next(G.rules))
        ''')

    def test_legacy_client_can_still_use_readable_combatlog(self):
        self.lua.execute('''
            function GetBuildInfo() return 'Classic','1','date',11510 end
            G.frame=nil; G:Initialize()
            assert(G.combatLogSupported and G.frame.events.COMBAT_LOG_EVENT_UNFILTERED)
            G.rules[123]={sound=1}
            CombatLogGetCurrentEventInfo=function()
                return 0,'SPELL_DAMAGE',false,'enemy','Enemy',0,0,'p','Player',0,0,123,'Danger',4,100
            end
            G.frame.scripts.OnEvent(G.frame,'COMBAT_LOG_EVENT_UNFILTERED')
            assert(#played==1)
        ''')

    def test_four_test_sounds_and_sound_assets(self):
        self.lua.execute('''
            for i=1,4 do G:Command('test '..i) end
            assert(#played==4 and #visual==4)
            assert(played[1].channel=='Master')
            assert(string.find(played[1].path,'alarmbuzzer.ogg',1,true))
            assert(string.find(played[4].path,'alarmbuzz.ogg',1,true))
        ''')
        for name in ('alarmbuzzer.ogg', 'alarmbeep.ogg', 'alarmdouble.ogg', 'alarmbuzz.ogg'):
            source = ROOT / 'AddOns/GTFO/Sounds' / name
            installed = ROOT / 'ForeverTools/Sounds/GTFO' / name
            self.assertEqual(source.read_bytes(), installed.read_bytes())

    def test_custom_spell_persistence_remove_and_invalid_input(self):
        self.lua.execute('''
            G:Command('add 123 high'); assert(G.rules[123].sound==1)
            G:Command('add 456 fail'); assert(G.rules[456].sound==3)
            G:Command('add -1 high'); assert(not G.rules[-1])
            G:Command('add 12.5 high'); assert(not G.rules[12.5])
            assert(ForeverToolsDB.modules.gtfo.spells[123]==1)
            G:Command('remove 123'); assert(not G.rules[123])
        ''')

    def test_readable_auras_repeat_with_throttle_and_stop_on_disable(self):
        self.lua.execute('''
            G:Command('add 123 high'); auras.player={{spellId=123}}
            G:ScanAuras(); G:ScanAuras(); assert(#played==1)
            now=1; G:ScanAuras(); assert(#played==2)
            ForeverTools:SetEnabled('gtfo',false)
            now=2; G:ScanAuras(); assert(#played==2 and #stopped==1)
            G:Command('test 1'); assert(#played==2)
        ''')

    def test_application_only_and_tank_sound_zero(self):
        self.lua.execute('''
            G.settings.classic=true; G:OnSettingsChanged()
            auras.player={{spellId=19428}}; G:ScanAuras()
            now=2; G:ScanAuras(); assert(#played==1)
            auras.player={}; G:ScanAuras(); now=3
            auras.player={{spellId=19428}}; G:ScanAuras(); assert(#played==2)
            units.player.role='TANK'; now=4; Hit(9435); assert(#played==2)
        ''')

    def test_combatlog_destination_source_minimum_and_source_npc_filters(self):
        self.lua.execute('''
            G.rules[123]={sound=3,specificMobs={123},damageMinimum=50,trivialPercent=5}
            Hit(123,nil,'someoneElse'); assert(#played==0)
            Hit(123,'Creature-0-0-0-0-999-abc'); assert(#played==0)
            Hit(123,nil,nil,nil,20); assert(#played==0)
            Hit(123); assert(#played==1)
            now=2; G.rules[123]={sound=4,ignoreSelfInflicted=true}
            Hit(123,'p'); assert(#played==1)
            Hit(123); assert(#played==2)
        ''')

    def test_native_aura_registration_no_duplicate_scan_and_safe_cleanup(self):
        self.lua.execute('''
            G.settings.classic=false; G:OnSettingsChanged()
            registrations,removed={},{}
            Enum.UnitAuraSoundTrigger={Added=1}
            C_UnitAuras.AddAuraSound=function(trigger,info)
                assert(trigger==1 and info.unitToken=='player' and info.outputChannel=='Master')
                registrations[#registrations+1]=info; return #registrations
            end
            C_UnitAuras.RemoveAuraSound=function(handle) removed[#removed+1]=handle end
            G:Command('add 123 high'); assert(G.native[123]==1)
            auras.player={{spellId=123}}; G:ScanAuras(); assert(#played==0)
            combat=true; ForeverTools:SetEnabled('gtfo',false)
            assert(#removed==0 and G.pendingNative)
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(#removed==1 and not next(G.native))
        ''')

    def test_private_aura_fallback_and_registration_errors(self):
        self.lua.execute('''
            G.settings.classic=false; G:OnSettingsChanged()
            C_UnitAuras.AuraIsPrivate=function(id) return id==123 end
            C_UnitAuras.AddPrivateAuraAppliedSound=function(info) return 42 end
            C_UnitAuras.RemovePrivateAuraAppliedSound=function(handle) assert(handle==42) end
            G:Command('add 123 high'); G:Command('add 456 low')
            assert(G.native[123]==42 and not G.native[456])
            C_UnitAuras.AddPrivateAuraAppliedSound=function() error('unavailable') end
            G:OnSettingsChanged(); assert(not next(G.native))
        ''')

    def test_breath_exhaustion_and_nonhazardous_falling(self):
        self.lua.execute('''
            Fire('MIRROR_TIMER_START','EXHAUSTION',1000,1000,-1); assert(#played==1)
            now=2; Fire('MIRROR_TIMER_START','BREATH',1000,1000,-1)
            breathTime=0; Advance(3); assert(#played==2)
            Advance(10); assert(#played==2)
            Fire('MIRROR_TIMER_STOP','BREATH'); assert(not G.breath)
            now=10; G:CombatLog(0,'ENVIRONMENTAL_DAMAGE',false,nil,nil,nil,nil,'p',nil,nil,nil,'FALLING',100)
            assert(#played==2)
            G:CombatLog(0,'ENVIRONMENTAL_DAMAGE',false,nil,nil,nil,nil,'p',nil,nil,nil,'LAVA',100)
            assert(#played==3)
        ''')

    def test_secret_data_does_not_error_or_alert(self):
        self.lua.execute('''
            G:Command('add 123 high')
            auras.player={{spellId=secret}}; G:ScanAuras()
            G:CombatLog(0,secret,false,nil,nil,nil,nil,'p',nil,nil,nil,123,'danger',4,100)
            G:CombatLog(0,'SPELL_DAMAGE',false,nil,nil,nil,nil,secret,nil,nil,nil,123,'danger',4,100)
            Fire('MIRROR_TIMER_START',secret,0,0,-1)
            Fire('MIRROR_TIMER_START','EXHAUSTION',0,0,secret)
            assert(#played==0)
        ''')

    def test_alarm_switches_visual_setting_and_menu(self):
        self.lua.execute('''
            G.settings.high=false; G:Alert(1); assert(#played==0)
            G.settings.visual=false; G:Alert(2); assert(#played==1 and #visual==0)
            SlashCmdList.FOREVERTOOLS(); assert(#ForeverTools.menu.checks==44)
        ''')

    def test_classic_activation_migrates_once_then_preserves_user_choice(self):
        self.lua.execute('''
            G.frame=nil; G.settings.classic=false; G.settings.classicDefaultApplied=nil
            G:Initialize(); assert(G.settings.classic and G.rules[19428])
            G.frame=nil; G.settings.classic=false
            G:Initialize(); assert(not G.settings.classic and not next(G.rules))
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
