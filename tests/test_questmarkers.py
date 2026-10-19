"""Quest markers using the Forever tooltip API: progress, ownership and plate reuse."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime
from test_materials import MATERIAL_MOCK
from test_paladin import PALADIN_MOCK
from test_threatplates import NAMEPLATE_MOCK


class QuestMarkersTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + MATERIAL_MOCK + PALADIN_MOCK + NAMEPLATE_MOCK)
        self.lua.execute('''
            local create=CreateFrame
            function CreateFrame(...)
                local f=create(...)
                f.parent=select(3,...)
                function f:SetFont(...) self.font={...} end
                function f:SetTextColor(...) self.color={...} end
                function f:SetParent(parent) assert(not combat); self.parent=parent end
                function f:SetAlpha(alpha) self.alpha=alpha end
                function f:SetIgnoreParentAlpha(value) self.ignoreAlpha=value end
                local createTexture=f.CreateTexture
                function f:CreateTexture(...)
                    local t=createTexture(self,...)
                    function t:SetBlendMode(mode) self.blend=mode end
                    function t:ClearAllPoints() self.point=nil end
                    function t:SetVertexColor(...) self.color={...} end
                    return t
                end
                return f
            end
            icon='|TInterface\\\\GossipFrame\\\\AvailableQuestIcon:16:16:0:0|t '
            Enum.TooltipDataLineType={QuestTitle=17,QuestPlayer=18,QuestObjective=8}
            C_QuestLog={GetNumQuestLogEntries=function() return 1 end,
                GetInfo=function() return {title='Wolfsjagd'} end}
            lines={{type=17,leftText='Wolfsjagd'},{type=8,leftText='Wölfe getötet: 1/15'}}
            C_TooltipInfo={GetUnit=function() return {lines=lines} end}
            cvars={nameplateMaxDistance='41',nameplateShowAll='0',nameplateShowEnemies='0',
                nameplateShowEnemyMinus='0',nameplateMinAlpha='0',nameplateMaxAlpha='1',
                nameplateNotSelectedAlpha='0'}
            C_CVar={GetCVar=function(key) return cvars[key] end,
                SetCVar=function(key,value)
                    assert(not combat, 'nameplate settings must wait for combat end')
                    cvars[key]=value
                end}
            cvars.outlineModeShowLootEffectWhenDisabled='0'
            cvars.graphicsOutlineMode='2'; cvars.OutlineEngineMode='1'
            cvars.raidGraphicsOutlineMode='2'; cvars.RAIDOutlineEngineMode='1'
            cvars.Outline='2'; cvars.ShowQuestObjectHighlightEffect='0'
            cvars.particleDensity='10'; cvars.particleMTDensity='20'
            cvars.RAIDparticleDensity='10'; cvars.RAIDparticleMTDensity='20'
            cvars.SoftTargetInteract='1'; cvars.SoftTargetInteractRange='10'
            cvars.SoftTargetInteractArc='0'; cvars.SoftTargetInteractOnlyInRange='1'
            cvars.SoftTargetNameplateInteract='0'
            function UnitIsGameObject(unit) return units[unit] and units[unit].object or false end
            tooltipCallbacks={}
            TooltipDataProcessor={AllTypes='ALL',AddTooltipPostCall=function(kind,fn)
                tooltipCallbacks[kind]=fn
            end}
            Enum.TooltipDataType={Item=0,Unit=2,Object=3}
            GameTooltip.hooks={}
            function GameTooltip:HookScript(event,fn) self.hooks[event]=fn end
            function ObjectTooltip(data)
                GameTooltip.lines={}; GameTooltip.hooks.OnTooltipCleared()
                tooltipCallbacks.ALL(GameTooltip,data)
            end
            namespace={}
        ''')
        for filename in ('Core.lua', 'Modules/QuestMarkers.lua'):
            self.lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                             (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8'))
        self.lua.execute('''
            Fire('ADDON_LOADED','ForeverTools'); Q=ForeverTools.modules.questmarkers
            plate=MakePlate('nameplate1'); Fire('NAME_PLATE_UNIT_ADDED','nameplate1')
            record=Q.byUnit.nameplate1
        ''')

    def test_progress_updates_and_completed_objectives_disappear(self):
        self.lua.execute('''
            assert(record.text.text==icon..'1/15')
            lines[2].leftText='14/15 Wölfe getötet'; Fire('QUEST_LOG_UPDATE')
            assert(record.text.text==icon..'14/15')
            lines[2].leftText='15/15 Wölfe getötet'; Advance(3)
            assert(record.text.text=='')
        ''')

    def test_custom_sparkles_on_nearby_quest_object_and_animation(self):
        self.lua.execute('''
            units.softinteract={name='Vorräte',guid='GameObject-1',object=true}
            local objectPlate=MakePlate('softinteract')
            Fire('PLAYER_SOFT_INTERACT_CHANGED')
            assert(Q.objectEffectActive and Q.objectGlow.parent==objectPlate)
            assert(cvars.SoftTargetNameplateInteract=='1' and cvars.SoftTargetInteract=='3')
            Q:AnimateObjectSparkles(0.05)
            assert(#Q.objectGlow.stars==5 and Q.objectGlow.stars[1].color[4]>0)
            assert(Q.objectGlow.stars[1].texture=='Interface\\\\Cooldown\\\\star4')
            local first=Q.objectGlow.stars[1].color[4]
            Q:AnimateObjectSparkles(0.05); assert(Q.objectGlow.stars[1].color[4]~=first)
            units.softinteract=nil; Fire('PLAYER_SOFT_INTERACT_CHANGED')
            assert(not Q.objectEffectActive and Q.objectGlow.alpha==0)
            assert(cvars.SoftTargetNameplateInteract=='0')
        ''')

    def test_custom_sparkles_do_not_mark_npcs_or_completed_objects(self):
        self.lua.execute('''
            units.softinteract={name='Questgeber',object=false}
            MakePlate('softinteract'); Q:Refresh(); assert(not Q.objectEffectActive)
            units.softinteract.object=true
            lines[2].leftText='Vorräte: 7/7'
            C_QuestLog.UnitIsRelatedToActiveQuest=function() return true end
            Q:Refresh(); assert(not Q.objectEffectActive and cvars.SoftTargetNameplateInteract=='0')
            lines[2].leftText='Vorräte: 2/7'; Q:Refresh(); assert(Q.objectEffectActive)
            lines[1].leftText='Fremde Quest'; Q:Refresh(); assert(not Q.objectEffectActive)
        ''')

    def test_custom_sparkles_wait_for_anchor_and_hide_in_combat(self):
        self.lua.execute('''
            units.softinteract={name='Vorräte',guid='GameObject-1',object=true}
            Q:Refresh(); assert(Q.objectGate and not Q.objectEffectActive)
            MakePlate('softinteract'); Q:Refresh(); assert(Q.objectEffectActive)
            combat=true; Fire('PLAYER_REGEN_DISABLED')
            assert(not Q.objectEffectActive and Q.objectGlow.alpha==0)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); Advance(1)
            assert(Q.objectEffectActive)
            Q.settings.objectSparkles=false; Q:OnSettingsChanged()
            assert(not Q.objectEffectActive and Q.objectGlow.alpha==0)
            assert(cvars.SoftTargetInteract=='1' and cvars.SoftTargetInteractRange=='10')
            assert(cvars.SoftTargetNameplateInteract=='0')
        ''')

    def test_custom_sparkles_can_use_object_relation_without_readable_tooltip(self):
        self.lua.execute('''
            units.softinteract={name='Vorräte',guid='GameObject-1',object=true}
            MakePlate('softinteract')
            C_TooltipInfo.GetUnit=function() error('unavailable') end
            Q:Refresh(); assert(not Q.objectEffectActive)
            C_QuestLog.UnitIsRelatedToActiveQuest=function() return true end
            Q:Refresh(); assert(Q.objectEffectActive)
            C_QuestLog.UnitIsRelatedToActiveQuest=function() return secret end
            Q:Refresh(); assert(not Q.objectEffectActive)
        ''')

    def test_custom_sparkles_use_each_object_plate_without_soft_token_lookup(self):
        self.lua.execute('''
            units.softinteract={name='Vorräte',object=true}
            units.nameplate2={name='Vorräte',object=true}; local objectPlate=MakePlate('nameplate2')
            Q:Refresh(); assert(Q.objectEffectActive and Q.objectAnchor==objectPlate)
            units.nameplate3={name='Vorräte',object=true}; MakePlate('nameplate3')
            Q:Refresh(); assert(Q.objectEffectCount==2)
            assert(Q.objectGlows[objectPlate].active and Q.objectGlows[plates.nameplate3].active)
            units.softinteract.guid='GameObject-2'; units.nameplate2.guid='GameObject-2'
            Q:Refresh(); assert(Q.objectEffectCount==2 and Q.objectGlows[objectPlate].active)
        ''')

    def test_four_objects_sparkle_together_and_recycled_or_removed_plates_stop(self):
        self.lua.execute('''
            for i=2,5 do
                local token='nameplate'..i
                units[token]={name='Mirkkrautsamenkapseln',object=true,guid='GameObject-'..i}
                MakePlate(token)
            end
            Q:Refresh(); assert(Q.objectEffectCount==4)
            Q:AnimateObjectSparkles(0.05)
            for i=2,5 do
                local glow=Q.objectGlows[plates['nameplate'..i]]
                assert(glow.active and glow.alpha==1 and glow.stars[1].color[4]>0)
            end
            local oldPlate=plates.nameplate2; local removedPlate=plates.nameplate3
            units.nameplate2.object=false; plates.nameplate3=nil
            Q:Refresh(); assert(Q.objectEffectCount==2)
            assert(Q.objectGlows[oldPlate].alpha==0 and Q.objectGlows[removedPlate].alpha==0)
            combat=true; Fire('PLAYER_REGEN_DISABLED')
            for _,glow in pairs(Q.objectGlows) do assert(glow.alpha==0) end
            combat=false; Fire('PLAYER_REGEN_ENABLED'); Advance(1)
            assert(Q.objectEffectCount==2)
            ForeverTools:SetEnabled('questmarkers',false)
            for _,glow in pairs(Q.objectGlows) do assert(glow.alpha==0) end
        ''')

    def test_native_global_highlighting_and_particle_minimum_restore_original_values(self):
        self.lua.execute('''
            assert(cvars.Outline=='0' and cvars.ShowQuestObjectHighlightEffect=='1')
            assert(cvars.particleDensity=='100' and cvars.RAIDparticleMTDensity=='100')
            Q.settings.objectSparkles=false; Q:OnSettingsChanged()
            assert(cvars.Outline=='2' and cvars.ShowQuestObjectHighlightEffect=='0')
            assert(cvars.particleDensity=='10' and cvars.particleMTDensity=='20')
            cvars.particleDensity='200'; Q.settings.objectSparkles=true; Q:OnSettingsChanged()
            assert(cvars.particleDensity=='200')
            cvars.ShowQuestObjectHighlightEffect=nil
            local set=C_CVar.SetCVar
            C_CVar.SetCVar=function(key,value)
                assert(key~='ShowQuestObjectHighlightEffect', 'unknown CVars must not be written')
                set(key,value)
            end
            Q:ApplyVisibility()
        ''')

    def test_custom_sparkles_learn_tooltip_guid_and_forget_after_quest_changes(self):
        self.lua.execute('''
            Q.settings.objectTooltips=false
            ObjectTooltip({type=3,guid='GameObject-1',lines=lines})
            units.softinteract={name='Vorräte',guid='GameObject-1',object=true}
            MakePlate('softinteract')
            C_TooltipInfo.GetUnit=function() return nil end
            Fire('PLAYER_SOFT_INTERACT_CHANGED'); assert(Q.objectEffectActive)
            Fire('QUEST_LOG_UPDATE'); assert(not Q.objectEffectActive)
        ''')

    def test_sparkles_apply_restore_and_follow_graphics_changes(self):
        self.lua.execute('''
            assert(cvars.outlineModeShowLootEffectWhenDisabled=='1' and cvars.graphicsOutlineMode=='0')
            assert(cvars.OutlineEngineMode=='0' and cvars.raidGraphicsOutlineMode=='0')
            cvars.graphicsOutlineMode='2'; Fire('CVAR_UPDATE','graphicsoutlinemode')
            Advance(6)
            assert(cvars.graphicsOutlineMode=='0')
            Q.settings.objectSparkles=false; Q:OnSettingsChanged()
            assert(cvars.outlineModeShowLootEffectWhenDisabled=='0' and cvars.graphicsOutlineMode=='2')
            assert(cvars.OutlineEngineMode=='1' and cvars.RAIDOutlineEngineMode=='1')
            assert(cvars.nameplateShowEnemies=='1' and Q.settings.objectTooltips)
            assert(string.find(messages[#messages],'Spielneustart'))
        ''')

    def test_graphics_preset_is_reapplied_after_the_engine_finishes(self):
        self.lua.execute('''
            Fire('CVAR_UPDATE','graphicsQuality')
            Advance(3)
            cvars.graphicsOutlineMode='2'; cvars.outlineModeShowLootEffectWhenDisabled='0'
            assert(cvars.graphicsOutlineMode=='2')
            Advance(3)
            assert(cvars.graphicsOutlineMode=='0' and cvars.outlineModeShowLootEffectWhenDisabled=='1')
            assert(not Q.visibilityDue)
        ''')

    def test_login_rechecks_late_loaded_graphics_settings(self):
        self.lua.execute('''
            Fire('PLAYER_LOGIN'); Advance(10)
            cvars.graphicsOutlineMode='2'; cvars.OutlineEngineMode='2'
            cvars.outlineModeShowLootEffectWhenDisabled='0'
            Advance(15)
            assert(cvars.graphicsOutlineMode=='0' and cvars.OutlineEngineMode=='0')
            assert(cvars.outlineModeShowLootEffectWhenDisabled=='1')
        ''')

    def test_delayed_graphics_changes_wait_for_combat_and_respect_disable(self):
        self.lua.execute('''
            Fire('CVAR_UPDATE','raidGraphicsQuality'); combat=true
            cvars.graphicsOutlineMode='2'; Advance(6)
            assert(cvars.graphicsOutlineMode=='2' and Q.visibilityPending)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(cvars.graphicsOutlineMode=='0')
            Fire('CVAR_UPDATE','graphicsQuality')
            Q.settings.objectSparkles=false; Q:OnSettingsChanged()
            local restored=cvars.graphicsOutlineMode; Advance(8)
            assert(cvars.graphicsOutlineMode==restored and cvars.outlineModeShowLootEffectWhenDisabled=='0')
        ''')

    def test_sparkle_diagnostics_report_actual_values_including_unavailable(self):
        self.lua.execute('''
            cvars.outlineModeShowLootEffectWhenDisabled=nil
            SlashCmdList.FOREVERTOOLSQUEST('sparkle')
            local found=false
            for _,message in ipairs(messages) do
                if message:find('outlineModeShowLootEffectWhenDisabled=nil',1,true) then found=true end
            end
            assert(found)
        ''')

    def test_sparkle_restore_waits_for_combat_end(self):
        self.lua.execute('''
            combat=true; Q.settings.objectSparkles=false; Q:OnSettingsChanged()
            assert(Q.visibilityPending and cvars.graphicsOutlineMode=='0')
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(cvars.graphicsOutlineMode=='2')
            Q.settings.objectSparkles=true; Q:OnSettingsChanged()
            ForeverTools:SetEnabled('questmarkers',false)
            assert(cvars.graphicsOutlineMode=='2' and cvars.outlineModeShowLootEffectWhenDisabled=='0')
        ''')

    def test_object_tooltip_shows_open_collection_count_and_skips_finished(self):
        self.lua.execute('''
            local data={type=3,guid='GameObject-1',lines={
                {type=17,leftText='Wolfsjagd'},{type=8,leftText='Vorräte: 2/7'},
                {type=8,leftText='Wasser: 3/3'}}}
            ObjectTooltip(data)
            assert(#GameTooltip.lines==1 and GameTooltip.lines[1][1]==icon..'2/7')
            tooltipCallbacks.ALL(GameTooltip,data); assert(#GameTooltip.lines==1)
            data.lines[2].leftText='Vorräte: 7/7'; ObjectTooltip(data)
            assert(#GameTooltip.lines==0)
        ''')

    def test_object_tooltip_respects_player_ownership_and_switches(self):
        self.lua.execute('''
            local data={type=3,lines={{type=17,leftText='Wolfsjagd'},
                {type=18,leftText='Ben Forever'},{type=8,leftText='1/7 Vorräte'},
                {type=18,leftText='Anna Forever'},{type=8,leftText='2/7 Vorräte'}}}
            ObjectTooltip(data); assert(GameTooltip.lines[1][1]==icon..'2/7')
            data.lines[1].leftText='Fremde Quest'; ObjectTooltip(data); assert(#GameTooltip.lines==0)
            data.lines[1].leftText='Wolfsjagd'; Q.settings.objectTooltips=false
            ObjectTooltip(data); assert(#GameTooltip.lines==0)
            Q.settings.objectTooltips=true; ForeverTools:SetEnabled('questmarkers',false)
            ObjectTooltip(data); assert(#GameTooltip.lines==0)
        ''')

    def test_object_tooltip_excludes_items_units_and_restricted_data(self):
        self.lua.execute('''
            local data={type=0,lines=lines}
            ObjectTooltip(data); assert(#GameTooltip.lines==0)
            data.type=2; ObjectTooltip(data); assert(#GameTooltip.lines==0)
            data.type=3; data.lines={{type=17,leftText='Wolfsjagd'},{type=8,leftText=secret}}
            ObjectTooltip(data); assert(#GameTooltip.lines==0)
            ObjectTooltip(secret); assert(#GameTooltip.lines==0)
            data.lines=lines; tooltipCallbacks.ALL(ItemRefTooltip,data)
            assert(#ItemRefTooltip.lines==0)
        ''')

    def test_world_cursor_tooltip_without_object_enum_uses_its_getter(self):
        self.lua.execute('''
            Enum.TooltipDataType.Object=nil
            function GameTooltip:GetPrimaryTooltipInfo() return {getterName='GetWorldCursor'} end
            ObjectTooltip({type=99,lines=lines}); assert(GameTooltip.lines[1][1]==icon..'1/15')
        ''')

    def test_early_visibility_and_restore_without_overwriting_manual_changes(self):
        self.lua.execute('''
            assert(cvars.nameplateMaxDistance=='100')
            assert(cvars.nameplateShowAll=='1' and cvars.nameplateShowEnemies=='1')
            cvars.nameplateShowEnemies='0'
            ForeverTools:SetEnabled('questmarkers',false)
            assert(cvars.nameplateMaxDistance=='41' and cvars.nameplateShowAll=='0')
            assert(cvars.nameplateShowEnemies=='0')
            ForeverTools:SetEnabled('questmarkers',true)
            assert(cvars.nameplateMaxDistance=='100' and cvars.nameplateShowEnemies=='1')
        ''')

    def test_visibility_changes_wait_for_combat_end(self):
        self.lua.execute('''
            combat=true; ForeverTools:SetEnabled('questmarkers',false)
            assert(Q.visibilityPending and cvars.nameplateMaxDistance=='100')
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(not Q.visibilityPending and cvars.nameplateMaxDistance=='41')
            combat=true; ForeverTools:SetEnabled('questmarkers',true)
            assert(Q.visibilityPending and cvars.nameplateMaxDistance=='41')
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(cvars.nameplateMaxDistance=='100')
        ''')

    def test_newly_available_tooltip_is_retried_after_one_tenth_second(self):
        self.lua.execute('''
            C_TooltipInfo.GetUnit=function() return nil end
            Q:Refresh(); assert(record.text.text=='')
            C_TooltipInfo.GetUnit=function() return {lines=lines} end
            Q.frame.scripts.OnUpdate(Q.frame,0.1)
            assert(record.text.text==icon..'1/15')
        ''')

    def test_unselected_creatures_use_quest_log_without_tooltip_or_click(self):
        self.lua.execute('''
            C_QuestLog.GetInfo=function() return {title='Wolfsjagd',questID=12} end
            objectives={{type='monster',text='Enemy getötet: 2/7',numFulfilled=2,numRequired=7}}
            C_QuestLog.GetQuestObjectives=function(id) assert(id==12); return objectives end
            C_TooltipInfo.GetUnit=function() return nil end
            Fire('QUEST_LOG_UPDATE')
            assert(currentTarget==nil and record.text.text==icon..'2/7')
            units.nameplate2={name='Enemy',enemy=true}
            MakePlate('nameplate2'); Fire('NAME_PLATE_UNIT_ADDED','nameplate2')
            assert(Q.byUnit.nameplate2.text.text==icon..'2/7')
            objectives[1].numFulfilled=7; Fire('QUEST_LOG_UPDATE')
            assert(record.text.text=='' and Q.byUnit.nameplate2.text.text=='')
        ''')

    def test_name_matching_excludes_similar_creatures_and_item_objectives(self):
        self.lua.execute('''
            C_QuestLog.GetInfo=function() return {title='Wolfsjagd',questID=12} end
            C_QuestLog.GetQuestObjectives=function() return {
                {type='monster',text='Enemy Scout slain: 2/7',numFulfilled=2,numRequired=7},
                {type='item',text='Enemy: 1/3',numFulfilled=1,numRequired=3}} end
            C_TooltipInfo.GetUnit=function() error('unavailable') end
            Fire('QUEST_LOG_UPDATE'); assert(record.text.text=='')
            units.nameplate1.name='Enemy Scout'
            Q:Refresh(); assert(record.text.text==icon..'2/7')
            C_QuestLog.GetNumQuestLogEntries=function() return 0 end
            Fire('QUEST_LOG_UPDATE'); assert(record.text.text=='')
        ''')

    def test_visibility_remains_enabled_after_client_settings_are_loaded(self):
        self.lua.execute('''
            assert(cvars.nameplateNotSelectedAlpha=='1' and cvars.nameplateMinAlpha=='1')
            local set=C_CVar.SetCVar
            C_CVar.SetCVar=function(key,value) set(key,value); Fire('CVAR_UPDATE',key) end
            cvars.nameplateShowAll='0'; Fire('CVAR_UPDATE','nameplateShowAll')
            assert(cvars.nameplateShowAll=='1')
            combat=true; cvars.nameplateShowEnemies='0'; Fire('CVAR_UPDATE','nameplateShowEnemies')
            assert(Q.visibilityPending)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(cvars.nameplateShowEnemies=='1')
            ForeverTools:SetEnabled('questmarkers',false)
            assert(cvars.nameplateNotSelectedAlpha=='0' and cvars.nameplateMinAlpha=='0')
            assert(cvars.nameplateShowAll=='0')
        ''')

    def test_discovery_uses_plate_token_before_native_frame_has_a_unit(self):
        self.lua.execute('''
            Fire('NAME_PLATE_UNIT_REMOVED','nameplate1')
            plate.namePlateUnitToken='nameplate1'; plate.UnitFrame.unit=nil
            plate.UnitFrame.healthBar=nil
            Q:Refresh(); assert(Q.byUnit.nameplate1.text.text==icon..'1/15')
        ''')

    def test_group_members_do_not_supply_the_players_progress(self):
        self.lua.execute('''
            lines={{type=17,leftText='Wolfsjagd'},
                {type=18,leftText='Ben Forever'},{type=8,leftText='Wölfe: 1/15'},
                {type=18,leftText='Anna Forever'},{type=8,leftText='Wölfe: 14/15'}}
            Q:Refresh(); assert(record.text.text==icon..'14/15')
            lines[1].leftText='Fremde Quest'; Q:Refresh(); assert(record.text.text=='')
        ''')

    def test_multiple_objectives_skip_completed_and_duplicate_lines(self):
        self.lua.execute('''
            lines[3]={type=8,leftText='Felle: 2/10'}
            lines[4]={type=8,leftText='Wölfe getötet: 1/15'}
            lines[5]={type=8,leftText='Krallen: 3/3'}
            Q:Refresh(); assert(record.text.text==icon..'1/15\\n'..icon..'2/10')
        ''')

    def test_removed_recycled_plates_and_disable(self):
        self.lua.execute('''
            Fire('NAME_PLATE_UNIT_REMOVED','nameplate1')
            assert(record.text.text=='' and not Q.byUnit.nameplate1)
            units.nameplate2=units.nameplate1; plates.nameplate1=nil; plates.nameplate2=plate
            plate.UnitFrame.unit='nameplate2'; Fire('NAME_PLATE_UNIT_ADDED','nameplate2')
            assert(Q.byUnit.nameplate2==record and record.text.text==icon..'1/15')
            ForeverTools:SetEnabled('questmarkers',false); assert(record.text.text=='')
            Advance(3); assert(record.text.text=='')
            ForeverTools:SetEnabled('questmarkers',true); assert(record.text.text==icon..'1/15')
        ''')

    def test_restricted_missing_tooltips_dead_and_friendly_units(self):
        self.lua.execute('''
            lines[2].leftText=secret; Q:Refresh(); assert(record.text.text=='')
            C_TooltipInfo.GetUnit=function() error('restricted') end
            Q:Refresh(); assert(record.text.text=='')
            C_TooltipInfo=nil; Q:Refresh(); assert(record.text.text=='')
            C_TooltipInfo={GetUnit=function() return {lines={
                {type=17,leftText='Wolfsjagd'},{type=8,leftText='1/15 Wölfe'}}} end}
            units.nameplate1.dead=true; Q:Refresh(); assert(record.text.text=='')
            units.nameplate1.dead=false; units.nameplate1.enemy=false
            Q:Refresh(); assert(record.text.text=='')
        ''')

    def test_abandoned_quests_and_late_native_frames(self):
        self.lua.execute('''
            C_QuestLog.GetNumQuestLogEntries=function() return 0 end
            Fire('QUEST_LOG_UPDATE'); assert(record.text.text=='')
            C_QuestLog.GetNumQuestLogEntries=function() return 1 end
            Fire('QUEST_LOG_UPDATE'); assert(record.text.text==icon..'1/15')
            units.nameplate2=units.nameplate1; plates.nameplate2=CreateFrame('Frame')
            Fire('NAME_PLATE_UNIT_ADDED','nameplate2'); assert(not Q.byUnit.nameplate2)
            local native=MakePlate('nameplate2').UnitFrame
            plates.nameplate2.UnitFrame=native; Advance(3)
            assert(Q.byUnit.nameplate2.text.text==icon..'1/15')
        ''')


if __name__ == '__main__':
    unittest.main()
