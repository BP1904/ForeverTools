"""Internal LoD packages, migration and source integrity for BigWigs/Nova."""
import re
import unittest
import xml.etree.ElementTree as ET
from test_forevertools import ROOT, MOCK, LuaRuntime

FEATURES = ROOT / 'ForeverTools/Features'


def execute(lua, path):
    lua.execute('assert(loadstring(...))("ForeverTools", namespace)', path.read_text(encoding='utf-8-sig'))


class EncounterAddonsTest(unittest.TestCase):
    def runtime(self, registry=True):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + '''
            namespace={}; disabled={}; nativeLoads={}
            function UnitName() return 'Tester' end
            C_AddOns={
                IsAddOnLoaded=function(name) return legacy and (name=='BigWigs' or name=='NovaInstanceTracker') end,
                DisableAddOn=function(name,character) assert(character=='Tester'); disabled[name]=true end,
                LoadAddOn=function(name) nativeLoads[#nativeLoads+1]=name; return true end,
            }
            local create=CreateFrame
            function CreateFrame(...)
                local f=create(...)
                function f:IsEventRegistered(e) return self.events[e] end
                function f:GetScript(e) return self.scripts[e] end
                function f:UnregisterAllEvents() self.events={} end
                function f:Hide() self.shown=false end
                return f
            end
        ''')
        execute(lua, ROOT/'ForeverTools/Core.lua')
        execute(lua, ROOT/'ForeverTools/Embedded.lua')
        if registry:
            for feature in ('BigWigs', 'NovaInstanceTracker'):
                execute(lua, FEATURES/feature/'Registry.lua')
        return lua

    def register_applications(self, lua, feature):
        manifest = FEATURES/feature/'Manifest.xml'
        for node in ET.parse(manifest).getroot():
            path = node.attrib.get('file', '')
            if path.endswith('.lua') and path != 'Registry.lua':
                execute(lua, manifest.parent/path)

    def test_complete_sources_compile_and_all_runtime_references_are_bundled(self):
        lua = LuaRuntime()
        for feature in ('BigWigs', 'NovaInstanceTracker'):
            root = FEATURES/feature
            for path in root.rglob('*.lua'):
                lua.execute('assert(loadstring(...))', path.read_text(encoding='utf-8-sig'))
            visited = set()

            def check(path):
                if path in visited:
                    return
                visited.add(path)
                self.assertTrue(path.is_file(), path)
                if path.suffix == '.xml':
                    text = re.sub(r'\s+xsi:schemaLocation="[^"]*"', '', path.read_text(encoding='utf-8-sig'))
                    for node in ET.fromstring(text).iter():
                        if node.tag.rsplit('}', 1)[-1] in ('Script', 'Include') and 'file' in node.attrib:
                            check(path.parent/node.attrib['file'].replace('\\', '/'))
            check(root/'Manifest.xml')
            self.assertGreater(len(visited), 40)

    def test_real_application_chunks_register_without_starting_or_requiring_originals(self):
        lua = self.runtime()
        for feature in ('BigWigs', 'NovaInstanceTracker'):
            self.register_applications(lua, feature)
        lua.execute('''
            local bw=namespace.embedded.BigWigs
            assert(#bw.order==12 and #bw.packages.BigWigs.chunks>10)
            assert(#bw.packages.BigWigs_TheVenomousAbyss.chunks==9)
            assert(#namespace.embedded.NovaInstanceTracker.packages.NovaInstanceTracker.chunks==20)
            assert(BigWigs==nil and BigWigsLoader==nil and NIT==nil)
            assert(not next(SlashCmdList))
            assert(#nativeLoads==0)
        ''')

    def test_actual_bigwigs_loader_core_plugins_and_options_start_in_private_environment(self):
        lua = self.runtime()
        lua.execute((ROOT/'tests/encounter_mock.lua').read_text())
        self.register_applications(lua, 'BigWigs')
        lua.execute('''
            local r=namespace.embedded.BigWigs
            r.running=true
            assert(r:Load('BigWigs'))
            assert(not r.packages.BigWigs_Core.loaded)
            assert(r:Load('BigWigs_Core'))
            assert(r:Load('BigWigs_Plugins'))
            assert(r:Load('BigWigs_Options'))
            assert(r.env.BigWigs and r.env.BigWigsOptions and r.env.BigWigsLoader)
            assert(r.env.BigWigs:GetPlugin('Bars'))
            assert(r.env.BigWigs:GetPlugin('Messages'))
            assert(ForeverToolsBigWigsDB and ForeverToolsBigWigsIconDB)
            assert(BigWigs==nil and BigWigs3DB==nil)
            assert(#nativeLoads==0 and #messages==0)
            assert(SLASH_FTEMBED_BigWigsBigWigs1=='/bw')
        ''')

    def test_actual_nova_sources_start_with_forever_detection_and_separate_identity(self):
        lua = self.runtime()
        lua.execute((ROOT/'tests/encounter_mock.lua').read_text())
        self.register_applications(lua, 'NovaInstanceTracker')
        lua.execute('''
            local r=namespace.embedded.NovaInstanceTracker
            r.running=true
            assert(r:Load('NovaInstanceTracker'))
            local app=r.env.NIT
            assert(app.isForever and app.hourlyLimit==10)
            assert(app.version==2.31 and app.name=='FTNovaInstanceTracker')
            assert(type(app.FTInitialize)=='function' and type(app.enteredInstance)=='function')
            assert(type(app.getInstanceLockoutInfo)=='function')
            assert(type(app.openInstanceLogFrame)=='function')
            assert(NIT==nil and NITdatabase==nil)
            assert(#nativeLoads==0 and #messages==0)
            assert(SLASH_FTEMBED_NovaInstanceTrackerNITCMD1=='/nit')
        ''')

    def test_virtual_loading_preserves_namespaces_dependencies_and_addon_events(self):
        lua = self.runtime(False)
        lua.execute('''
            r=namespace:NewEmbeddedRuntime('Example', {
                {name='Core',meta={Version='2.0'},deps={},lod=false},
                {name='Bosses',meta={['X-BigWigs-LoadOn-InstanceId']='123'},deps={'Core'},lod=true}})
            r:Add('Core',function(name,t)
                assert(name=='Core'); t.loaded=1; privateValue=123
                f=CreateFrame('Frame'); f:RegisterEvent('ADDON_LOADED')
                f:SetScript('OnEvent',function(_,_,loaded) t.last=loaded end)
                SLASH_EXAMPLE1='/example'; SlashCmdList.EXAMPLE=function() used=privateValue end
                assert(C_AddOns.GetNumAddOns()==2)
                assert(C_AddOns.GetAddOnInfo(2)=='Bosses')
                assert(C_AddOns.GetAddOnMetadata('Core','Version')=='2.0')
                assert(C_AddOns.IsAddOnLoadOnDemand('Bosses'))
            end,'Core.lua')
            r:Add('Bosses',function(name,t)
                assert(name=='Bosses' and t.loaded==nil)
                assert(C_AddOns.IsAddOnLoaded('Core')); bossCount=(bossCount or 0)+1
            end,'Bosses.lua')
            assert(not r:Load('Core'))
            r.running=true
            assert(r:Load('Bosses'))
            assert(r.packages.Core.namespace.last=='Bosses')
            assert(r:Load('Bosses') and r.env.bossCount==1)
            assert(privateValue==nil and r.env.privateValue==123)
            SlashCmdList.FTEMBED_ExampleEXAMPLE()
            assert(r.env.used==123 and SLASH_FTEMBED_ExampleEXAMPLE1=='/example')
            assert(#nativeLoads==0)
            assert(r.env.C_AddOns.LoadAddOn('Blizzard_DebugTools'))
            assert(nativeLoads[1]=='Blizzard_DebugTools')
            assert(C_AddOns.GetNumAddOns==nil)
        ''')

    def test_error_is_reported_once_and_broken_package_is_not_retried(self):
        lua = self.runtime(False)
        lua.execute('''
            r=namespace:NewEmbeddedRuntime('Broken',{{name='Core',meta={},deps={}}})
            r:Add('Core',function() count=(count or 0)+1; error('bad source') end,'broken.lua')
            r.running=true
            assert(not r:Load('Core')); assert(not r:Load('Core'))
            assert(r.env.count==1 and r.packages.Core.failed and not r.packages.Core.loaded)
            assert(#messages==1 and messages[1]:find('broken.lua',1,true))
        ''')

    def test_failed_nova_initialization_stops_events_and_reports_failure(self):
        lua = self.runtime()
        lua.execute('''
            namespace.embedded.NovaInstanceTracker:Add('NovaInstanceTracker',function()
                f=CreateFrame('Frame'); f:RegisterEvent('TEST')
                f:SetScript('OnEvent',function() eventRan=true end)
                NIT={FTInitialize=function() error('broken initialization') end}
            end,'fixture')
        ''')
        execute(lua, ROOT/'ForeverTools/Modules/EncounterAddons.lua')
        lua.execute('''
            Fire('ADDON_LOADED','ForeverTools')
            local r=namespace.embedded.NovaInstanceTracker
            assert(not r.running and not namespace.modules.novainstancetracker.ready)
            r:Dispatch('TEST'); assert(not r.env.eventRan)
            assert(not r.env.f:IsShown())
        ''')

    def test_legacy_migration_copies_data_and_blocks_duplicate_engines(self):
        lua = self.runtime()
        lua.execute('''
            legacy=true
            BigWigs3DB={profiles={Default={test=42}}}; BigWigsIconDB={hide=true}
            BigWigsStatsDB={kills=3}; NITdatabase={global={instances={a=5}}}
        ''')
        execute(lua, ROOT/'ForeverTools/Modules/EncounterAddons.lua')
        lua.execute('''
            Fire('ADDON_LOADED','ForeverTools')
            assert(disabled.BigWigs and disabled.BigWigs_Core and disabled.BigWigs_TheVoidspire)
            assert(disabled.NovaInstanceTracker)
            assert(ForeverToolsBigWigsDB.profiles.Default.test==42)
            assert(ForeverToolsBigWigsIconDB.hide and ForeverToolsBigWigsStatsDB.kills==3)
            assert(ForeverToolsNovaDB.global.instances.a==5)
            ForeverToolsNovaDB.global.instances.a=9
            assert(NITdatabase.global.instances.a==5)
            assert(not namespace.embedded.BigWigs.running and not namespace.embedded.NovaInstanceTracker.running)
            SlashCmdList.FOREVERTOOLSBIGWIGS()
            assert(messages[#messages]:find('/reload',1,true))
        ''')

    def test_existing_integrated_data_is_never_replaced_by_legacy_data(self):
        lua = self.runtime()
        lua.execute('legacy=true; NITdatabase={old=true}; ForeverToolsNovaDB={new=true}')
        execute(lua, ROOT/'ForeverTools/Modules/EncounterAddons.lua')
        lua.execute("Fire('ADDON_LOADED','ForeverTools'); assert(ForeverToolsNovaDB.new and not ForeverToolsNovaDB.old)")

    def test_off_at_login_does_not_start_engines_and_enable_requests_reload(self):
        lua = self.runtime()
        lua.execute('ForeverToolsDB={modules={bigwigs={enabled=false},novainstancetracker={enabled=false}}}')
        execute(lua, ROOT/'ForeverTools/Modules/EncounterAddons.lua')
        lua.execute('''
            Fire('ADDON_LOADED','ForeverTools')
            assert(not namespace.embedded.BigWigs.running and not namespace.embedded.NovaInstanceTracker.running)
            ForeverTools:SetEnabled('bigwigs',true)
            assert(not namespace.embedded.BigWigs.running)
            assert(messages[#messages]:find('/reload',1,true))
        ''')

    def test_module_start_and_commands_use_private_applications_once(self):
        lua = self.runtime()
        lua.execute('''
            namespace.embedded.BigWigs:Add('BigWigs',function()
                SlashCmdList.BigWigs=function() bwOpened=(bwOpened or 0)+1 end
            end,'fixture')
            namespace.embedded.NovaInstanceTracker:Add('NovaInstanceTracker',function()
                NIT={FTInitialize=function(self) self.started=(self.started or 0)+1 end}
                SlashCmdList.NITCMD=function(cmd) novaCommand=cmd end
            end,'fixture')
        ''')
        execute(lua, ROOT/'ForeverTools/Modules/EncounterAddons.lua')
        lua.execute('''
            Fire('ADDON_LOADED','ForeverTools')
            assert(namespace.embedded.NovaInstanceTracker.env.NIT.started==1)
            SlashCmdList.FOREVERTOOLSBIGWIGS()
            SlashCmdList.FOREVERTOOLSNOVA('options')
            assert(namespace.embedded.BigWigs.env.bwOpened==1)
            assert(namespace.embedded.NovaInstanceTracker.env.novaCommand=='options')
            ForeverTools:SetEnabled('bigwigs',false)
            SlashCmdList.FOREVERTOOLSBIGWIGS()
            assert(namespace.embedded.BigWigs.env.bwOpened==1)
            assert(NIT==nil and BigWigs==nil)
        ''')


if __name__ == '__main__':
    unittest.main()
