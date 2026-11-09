"""Bound repeated API work while keeping displays and timers current."""
import unittest
import test_paladin as paladin_tests
import test_questmarkers as quest_tests
import test_threatplates as plate_tests
import test_buffcheck as buff_tests
import test_auctionator as auction_tests
import test_professionplanner as profession_tests
import test_materials as material_tests
import test_training as training_tests
import test_decursive as decursive_tests
import test_experience as experience_tests
import test_bankview as bank_tests
import test_maps as map_tests


class PerformanceTest(unittest.TestCase):
    def test_threatplates_keep_fast_polling_and_immediate_target_updates(self):
        fixture = plate_tests.ThreatPlatesTest()
        fixture.setUp()
        fixture.lua.execute('''
            local module=ForeverTools.modules.threatplates
            refreshes=0; module.RefreshAll=function() refreshes=refreshes+1 end
            module.frame.scripts.OnUpdate(module.frame,0.19); assert(refreshes==0)
            module.frame.scripts.OnUpdate(module.frame,0.02); assert(refreshes==1)
            Fire('PLAYER_TARGET_CHANGED'); assert(refreshes==2)
        ''')

    def test_quest_polling_is_slower_but_new_plates_and_events_are_immediate(self):
        fixture = quest_tests.QuestMarkersTest()
        fixture.setUp()
        fixture.lua.execute('''
            local refresh=Q.Refresh; refreshes=0
            Q.Refresh=function(self) refreshes=refreshes+1; return refresh(self) end
            Q.frame.scripts.OnUpdate(Q.frame,0.2)
            Q.frame.scripts.OnUpdate(Q.frame,0.2)
            assert(refreshes==0)
            Q.frame.scripts.OnUpdate(Q.frame,0.11)
            assert(refreshes==1)
            lines[2].leftText='8/15 Wölfe getötet'; Fire('QUEST_LOG_UPDATE')
            assert(record.text.text==icon..'8/15' and refreshes==2)
            MakePlate('nameplate2'); Fire('NAME_PLATE_UNIT_ADDED','nameplate2')
            assert(Q.byUnit.nameplate2.text.text==icon..'8/15')
        ''')

    def test_bank_names_are_shared_per_link_and_refreshed_in_the_next_scan(self):
        bank_tests.BankViewTest().runtime().execute('''
            inventory[5][2].hyperlink=inventory[-1][1].hyperlink
            local info=C_Item.GetItemInfo; reads=0
            C_Item.GetItemInfo=function(...) reads=reads+1; return info(...) end
            Fire('BANKFRAME_OPENED'); assert(reads==2)
            names[100]='Anderer Name'; reads=0; m:Scan()
            assert(reads==2 and m.db.snapshot.bags[2].items[2].name=='Anderer Name')
            inventory[5][2].hyperlink='item:100:999'; reads=0; m:Scan()
            assert(reads==3)
        ''')

    def test_material_professions_cached_until_skill_or_world_changes(self):
        fixture = material_tests.MaterialsTest()
        fixture.setUp()
        fixture.lua.execute('''
            local professions=GetProfessions; reads=0
            GetProfessions=function() reads=reads+1; return professions() end
            M.learned=nil
            assert(M:Learned()[171]); M:Learned(); assert(reads==1)
            profession=164; M.frame.scripts.OnEvent(M.frame,'SKILL_LINES_CHANGED')
            assert(M:Learned()[164] and not M:Learned()[171] and reads==2)
            M.frame.scripts.OnEvent(M.frame,'SPELLS_CHANGED'); M:Learned(); assert(reads==3)
            M.frame.scripts.OnEvent(M.frame,'PLAYER_ENTERING_WORLD'); M:Learned(); assert(reads==4)
        ''')

    def test_unrelated_addon_load_does_not_rebuild_map(self):
        map_tests.MapsTest().runtime('MakeMap()').execute('''
            local apply=M.OnSettingsChanged; rebuilds=0
            M.OnSettingsChanged=function(self) rebuilds=rebuilds+1; return apply(self) end
            Fire('ADDON_LOADED','SomeOtherAddon'); assert(rebuilds==0)
            Fire('ADDON_LOADED','Blizzard_WorldMap'); assert(rebuilds==1)
            Fire('ADDON_LOADED','Leatrix_Maps'); assert(rebuilds==2)
        ''')

    def test_legacy_recipe_names_read_once_per_scan_and_duplicates_not_guessed(self):
        profession_tests.ProfessionPlannerTest().runtime().execute('''
            GetTradeSkillLine=function() return 'Alchemie',rank,cap end
            GetNumTradeSkills=function() return 3 end
            GetTradeSkillInfo=function(i) return 'Spell'..(100+i),'optimal' end
            GetTradeSkillNumReagents=function() return 1 end
            GetTradeSkillReagentItemLink=function() return 'item:1' end
            GetTradeSkillReagentInfo=function() return 'Material',nil,2 end
            local spell=C_Spell.GetSpellName; reads={}
            C_Spell.GetSpellName=function(id) reads[id]=(reads[id] or 0)+1; return spell(id) end
            m:ScanRecipes()
            assert(m.db.recipes[101] and m.db.recipes[102] and m.db.recipes[103])
            assert(reads[101]==1 and reads[102]==1 and reads[103]==1 and not reads[201])
            m.db.recipes={}
            C_Spell.GetSpellName=function(id) return id==102 and 'Spell101' or spell(id) end
            m:ScanRecipes()
            assert(not m.db.recipes[101] and not m.db.recipes[102] and m.db.recipes[103])
        ''')

    def test_auction_scan_reuses_batch_timestamp_and_retains_cheapest_unit_price(self):
        auction_tests.AuctionTest().runtime().execute('''
            Fire('AUCTION_HOUSE_SHOW')
            auctions={}
            for i=1,200 do auctions[i]={name='Erz',count=2,buyout=402-i,link='item:1'} end
            M:StartScan(); Fire('AUCTION_ITEM_LIST_UPDATE')
            local clock=time; stamps=0
            time=function() stamps=stamps+1; return clock() end
            M:Tick()
            assert(not M.scan and M:Market().prices['1:0'].unit==101)
            assert(stamps==2) -- one for the batch, one for the completed market
        ''')

    def test_paladin_reads_each_aura_slot_once_per_timer_refresh(self):
        fixture = paladin_tests.PaladinTest()
        fixture.setUp()
        fixture.lua.execute('''
            Fire('PLAYER_LOGIN')
            assert(P.bar and P.bar.frame:IsShown())
            local read=C_UnitAuras.GetAuraDataByIndex
            reads={}; duplicateReads=0
            C_UnitAuras.GetAuraDataByIndex=function(unit,index,filter)
                local key=unit..':'..index
                if reads[key] then duplicateReads=duplicateReads+1 end
                reads[key]=true
                return read(unit,index,filter)
            end
            P:UpdateTimers()
        ''')
        self.assertEqual(fixture.lua.eval('duplicateReads'), 0)
        fixture.lua.execute('''
            reads={}; auras.player={{name='Spell20217',expirationTime=100}}
            P:UpdateTimers()
            assert(P:Remaining(P.byName[P.player],'Spell20217')==100)
            auras.player={}
            assert(P:Remaining(P.byName[P.player],'Spell20217')==0)
        ''')

    def test_quest_refresh_reads_each_tooltip_once(self):
        fixture = quest_tests.QuestMarkersTest()
        fixture.setUp()
        fixture.lua.execute('''
            local module=ForeverTools.modules.questmarkers
            MakePlate('nameplate1'); Fire('NAME_PLATE_UNIT_ADDED','nameplate1')
            local progress=module.TooltipProgress
            tooltipReads=0
            module.TooltipProgress=function(self,unit)
                tooltipReads=tooltipReads+1; return progress(self,unit)
            end
            module:Refresh()
        ''')
        self.assertEqual(fixture.lua.eval('tooltipReads'), 1)

    def test_paladin_discards_snapshot_even_when_painting_fails(self):
        fixture = paladin_tests.PaladinTest()
        fixture.setUp()
        fixture.lua.execute('''
            P.PaintTimers=function() error('display unavailable') end
            assert(not pcall(P.UpdateTimers,P))
            assert(P.timerAuras==nil)
        ''')

    def test_unrelated_unit_events_do_not_refresh_all_nameplates(self):
        fixture = plate_tests.ThreatPlatesTest()
        fixture.setUp()
        fixture.lua.execute('''
            local module=ForeverTools.modules.threatplates
            refreshes=0
            module.RefreshAll=function() refreshes=refreshes+1 end
            for i=1,40 do Fire('UNIT_AURA','raid'..i) end
        ''')
        self.assertEqual(fixture.lua.eval('refreshes'), 0)
        fixture.lua.execute("Fire('PLAYER_TARGET_CHANGED')")
        self.assertEqual(fixture.lua.eval('refreshes'), 1)

    def test_buff_names_are_reused_and_unloaded_spells_retry(self):
        fixture = buff_tests.BuffCheckTest()
        fixture.run_lua('''
            local spell=C_Spell.GetSpellName
            nameReads=0
            C_Spell.GetSpellName=function(id) nameReads=nameReads+1; return spell(id) end
            m:Evaluate(); local warmed=nameReads
            m:Evaluate(); assert(nameReads==warmed)
            local loaded=false
            C_Spell.GetSpellName=function(id)
                if id==999999 then return loaded and 'Neuer Foodbuff' or nil end
                return spell(id)
            end
            m.settings.foodSpells[999999]=true
            auras={{name='Neuer Foodbuff',expirationTime=120}}
            m:Evaluate(); assert(Row('food').state~='active')
            loaded=true; m:Evaluate(); assert(Row('food').state=='active')
        ''')

    def test_idle_auction_house_skips_ticks_but_pending_work_runs(self):
        lua = auction_tests.AuctionTest().runtime()
        lua.execute('''
            ticks=0; M.Tick=function() ticks=ticks+1 end
            Advance(10); assert(ticks==0)
            for _,key in ipairs({'scan','job','posting','ownerRequest'}) do
                M[key]={}; Advance(1); M[key]=nil
            end
            assert(ticks==4)
        ''')

    def test_profession_counts_only_selected_profession_then_refreshes_on_switch(self):
        lua = profession_tests.ProfessionPlannerTest().runtime()
        lua.execute('''
            namespace.materialUses[999998]={{164,201,1,50,1,30}}
            local count=C_Item.GetItemCount
            reads={}
            C_Item.GetItemCount=function(id,...)
                reads[id]=(reads[id] or 0)+1; return count(id,...)
            end
            m:Build(); assert(not reads[999998] and reads[1]==1)
            profession=164; m:Build(); assert(reads[999998]==1)
        ''')

    def test_recipe_search_counts_shared_material_once_per_search(self):
        fixture = material_tests.MaterialsTest()
        fixture.setUp()
        fixture.lua.execute('''
            namespace.recipes={[1000]={171,9001},[1001]={171,9002}}
            namespace.reagents={[9001]={2000,1},[9002]={2000,1}}
            counts[2000]=5; names[1000]='Rezept A'; names[1001]='Rezept B'
            local count=C_Item.GetItemCount
            reads=0
            C_Item.GetItemCount=function(id,...)
                if id==2000 then reads=reads+1 end; return count(id,...)
            end
            assert(#M:Matches()==2 and reads==1)
            counts[2000]=0; assert(#M:Matches()==0 and reads==2)
        ''')

    def test_training_level_notice_builds_once_with_open_window(self):
        lua = training_tests.TrainingTest().runtime()
        lua.execute('''
            M:Open()
            local build=M.Build; builds=0
            M.Build=function(self,...) builds=builds+1; return build(self,...) end
            Fire('PLAYER_LEVEL_UP',21); Advance(1)
            assert(builds==1 and M.panel:IsShown())
        ''')

    def test_decursive_unknown_unit_does_not_walk_group_buttons(self):
        fixture = decursive_tests.DecursiveTest()
        fixture.setUp()
        fixture.lua.execute('''
            local original={}; visits=0
            for _,button in ipairs(D.buttons) do
                original[button]=button.unit; button.unit=nil
                setmetatable(button,{__index=function(b,key)
                    if key=='unit' then visits=visits+1; return original[b] end
                end})
            end
            D:Refresh('nameplate1'); assert(visits==0)
            D:Refresh('party1'); assert(visits<10)
            assert(D.unitIndex.party1 and D.unitIndex.raid40)
        ''')

    def test_buffcheck_uses_native_player_filter_and_retains_fallback(self):
        buff_tests.BuffCheckTest().run_lua('''
            local calls=0
            m.events.RegisterUnitEvent=function(_,event,unit)
                calls=calls+1; assert(event=='UNIT_AURA' and unit=='player')
            end
            m:OnSettingsChanged(); assert(calls==1)
            m.events:RegisterEvent('UNIT_AURA')
            m.events.RegisterUnitEvent=function() error('unsupported') end
            m:OnSettingsChanged(); assert(m.events.events.UNIT_AURA)
        ''')

    def test_native_xp_bar_is_not_rewritten_when_already_hidden(self):
        lua = experience_tests.ExperienceTest().runtime()
        lua.execute('''
            writes=0; alpha=1
            MainMenuExpBar.GetAlpha=function() return alpha end
            MainMenuExpBar.SetAlpha=function(_,value) writes=writes+1; alpha=value end
            M.native=nil
            M:NativeBar(true); M:NativeBar(true); assert(writes==1 and alpha==0)
            M:NativeBar(false); assert(writes==2 and alpha==1)
            M:NativeBar(false); assert(writes==2)
            M:NativeBar(true); alpha=0.5
            M:NativeBar(true); assert(writes==4 and alpha==0)
        ''')


if __name__ == '__main__':
    unittest.main()
