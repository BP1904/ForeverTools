"""Live trainer prices, book links, map navigation and demon-family isolation."""
import unittest
import test_training


class TrainingExtrasTest(unittest.TestCase):
    def runtime(self,extra=''):
        return test_training.TrainingTest().runtime(extra,with_extras=True)

    def test_launch_spells_and_live_prices(self):
        self.runtime("function GetBuildInfo() return '1.60.1','70790' end; playerClass='DRUID'; playerLevel=42").execute('''
            local function spells()
                local rows={}
                for _,row in ipairs(M:Build()) do rows[row.id]=row end
                return rows
            end
            known[768]=true
            local rows=spells()
            assert(rows[1328618].level==24 and rows[1328618].cost==nil and M.incompletePrice)
            assert(rows[1328829].level==32)
            assert(rows[1328616].status=='missing' and rows[414644].status=='missing')
            known[1328617]=true; known[1328616]=true
            assert(spells()[414644].status=='available')
            trainerIDs={1328618}; function GetTrainerServiceCost() return 1700 end
            Fire('TRAINER_SHOW')
            assert(spells()[1328618].cost==1700)
            Fire('TRAINER_CLOSED')
            assert(spells()[1328618].cost==nil)
            M.class='PALADIN'; rows=spells()
            assert(not rows[1038] and not rows[25895])
            M.class='MAGE'; rows=spells()
            assert(not rows[1326053] and not rows[1326054] and not rows[1326055])
        ''')

    def test_forever_reputation_ladder_actual_quote_and_base_switch(self):
        self.runtime().execute('''
            reps[72]={name='Sturmwind',reaction=6}
            local function blink()
                for _,row in ipairs(M:BuildClass()) do if row.id==1953 then return row end end
            end
            local row=blink(); assert(row.cost==1800 and row.baseCost==2000 and row.priceKind=='estimate')
            reps[72].reaction=8; assert(blink().cost==1800)
            M.db.priceFaction='base'; assert(blink().cost==2000)
            M.db.priceFaction='auto'; trainerIDs={1953}
            function GetTrainerServiceCost() return 1700 end
            Fire('TRAINER_SHOW'); row=blink(); assert(row.cost==1700 and row.priceKind=='trainer')
            assert(M:Details(row):find('Aktueller Lehrerpreis'))
            Fire('TRAINER_CLOSED'); assert(blink().cost==1800)
            M.settings.reputationPrices=false; assert(blink().cost==2000)
        ''')

    def test_discounts_do_not_apply_to_unrelated_teachers_or_grimoires(self):
        self.runtime("playerClass='WARLOCK'").execute('''
            reps[72]={name='Sturmwind',reaction=8}
            local rows=M:BuildClass()
            for _,row in ipairs(rows) do
                if row.kind=='tome' or row.kind=='quest' then assert(row.cost==row.baseCost and row.priceKind=='base') end
            end
            local row={id=1,kind='weapon',cost=1000,trainers={{npc=999999}}}
            M:ApplyPrices({row}); assert(row.cost==1000 and row.priceKind=='base')
        ''')

    def test_map_points_use_exact_forever_coordinates_and_reject_bad_requests(self):
        self.runtime().execute('''
            function C_Map.GetBestMapForUnit() return 1453 end
            function C_Map.CanSetUserWaypointOnMap() return true end
            function C_Map.SetUserWaypoint(point) marked=point; return true end
            function C_Map.OpenWorldMap(map) openedMap=map end
            UiMapPoint={CreateFromCoordinates=function(map,x,y) return {uiMapID=map,x=x,y=y} end}
            local targets=M:WaypointTargets({trainers=D.WeaponSkills[201].trainers.Alliance})
            assert(targets[1].npc==11867 and targets[1].mapID==1453)
            assert(math.abs(targets[1].x-0.639)<0.0001 and math.abs(targets[1].y-0.691)<0.0001)
            assert(M:SetTrainerWaypoint(targets[1]) and marked.uiMapID==1453 and openedMap==1453)
            assert(not M:SetTrainerWaypoint({mapID=-1,x=0.5,y=0.5}))
            assert(not M:SetTrainerWaypoint({mapID=1453,x=1.1,y=0.5}))
            combat=true; assert(not M:SetTrainerWaypoint(targets[1])); combat=false
            C_Map.CanSetUserWaypointOnMap=function() return false end
            TomTom={AddWaypoint=function() return false end}; assert(not M:SetTrainerWaypoint(targets[1]))
            TomTom.AddWaypoint=function() return 'uid' end; assert(M:SetTrainerWaypoint(targets[1]))
            ForeverTools:SetEnabled('training',false); assert(not M:SetTrainerWaypoint(targets[1]))
        ''')

    def test_lazy_book_frames_keep_native_handlers_and_link_to_correct_view(self):
        self.runtime('''
            local create=CreateFrame
            function CreateFrame(...)
                local frame=create(...); frame.attributes={}
                function frame:SetAttribute(key,value) self.attributes[key]=value end
                function frame:GetAttribute(key) return self.attributes[key] end
                function frame:Hide() self:SetShown(false) end
                return frame
            end
            function RegisterStateDriver(frame,key,condition)
                assert(not combat and key=='bookcombat' and condition=='[combat] combat; peace')
                frame.combatDriver=true
            end
        ''').execute('''
            local function Book()
                local book=CreateFrame()
                book:SetScript('OnShow',function() nativeShows=(nativeShows or 0)+1 end)
                function book:HookScript(event,fn)
                    local old=self.scripts[event]
                    self.scripts[event]=function(...) if old then old(...) end; fn(...) end
                end
                return book
            end
            PlayerSpellsFrame={SpellBookFrame=Book()}; ProfessionsFrame=Book()
            Fire('ADDON_LOADED','Blizzard_PlayerSpells')
            local link=M.bookLinks[PlayerSpellsFrame.SpellBookFrame]
            assert(link and link:IsShown() and M.bookLinks[ProfessionsFrame]:IsShown())
            PlayerSpellsFrame.SpellBookFrame.scripts.OnShow(); assert(nativeShows==1)
            M.bookLinks[ProfessionsFrame].scripts.OnClick(); assert(M.mode=='recipes' and M.panel:IsShown())
            link.scripts.OnClick(); assert(M.mode=='class')
            M.settings.bookButtons=false; M:OnSettingsChanged(); assert(not link:IsShown())
            M.settings.bookButtons=true; M:OnSettingsChanged(); assert(link:IsShown())
            local shown=link.SetShown
            function link:SetShown(value)
                assert(not combat or secureBook,'insecure book visibility in combat')
                shown(self,value)
            end
            combat=true
            assert(link.combatDriver)
            secureBook=true
            local driver=assert(loadstring('return function(self,newstate) '..link:GetAttribute('_onstate-bookcombat')..' end'))()
            driver(link,'combat'); secureBook=false
            Fire('PLAYER_REGEN_DISABLED')
            PlayerSpellsFrame.SpellBookFrame.scripts.OnHide()
            assert(not link:IsShown())
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(link:IsShown())
            ForeverTools:SetEnabled('training',false); assert(not link:IsShown())
        ''')

    def test_snapshot_is_stable_family_specific_and_preserves_other_demons(self):
        self.runtime("playerClass='WARLOCK'; playerLevel=60").execute('''
            local shared=D.ClassData.WARLOCK.tomeTaughtSpells[16375]
            petFamily='Sukkubus'; petGUID='Pet-Succubus'; book={shared}
            function UnitExists() return true end
            function UnitIsDead() return false end
            function UnitCreatureFamily() return petFamily end
            function UnitGUID() return petGUID end
            function C_SpellBook.HasPetSpells() return #book end
            function C_SpellBook.GetSpellBookItemInfo(i) return {spellID=book[i]} end
            petKnown[shared]=true
            M:ScheduleDemonScan(); Advance(3); assert(not M.db.demons.Succubus)
            Advance(2); assert(M.db.demons.Succubus.known[shared])
            local states={}; for _,row in ipairs(M:BuildClass()) do if row.itemID==16375 then states[row.family]=row.status end end
            assert(states.Succubus=='known' and states.Incubus=='check')
            petFamily='Inkubus'; petGUID='Pet-Incubus'; book={999999}; petKnown={}
            Fire('UNIT_PET','player'); Advance(5); assert(not M.db.demons.Incubus)
            Fire('PET_BAR_UPDATE'); Advance(5)
            assert(M.db.demons.Incubus.known[shared]==false and M.db.demons.Succubus.known[shared])
            states={}; for _,row in ipairs(M:BuildClass()) do if row.itemID==16375 then states[row.family]=row.status end end
            assert(states.Incubus=='available' and states.Succubus=='known')
        ''')

    def test_pet_cache_failure_does_not_erase_knowledge_and_high_rank_covers_low_rank(self):
        self.runtime("playerClass='WARLOCK'; playerLevel=60").execute('''
            local low=D.ClassData.WARLOCK.tomeTaughtSpells[16321]
            local high=D.ClassData.WARLOCK.tomeTaughtSpells[16322]
            spellNames[low]='Blutpakt'; spellNames[high]='Blutpakt'
            C_Spell.GetSpellSubtext=function(id) return id==high and 'Rang II' or 'Rang I' end
            function UnitExists() return true end
            function UnitIsDead() return false end
            function UnitCreatureFamily() return 'Wichtel' end
            function UnitGUID() return 'Pet-Imp' end
            function C_SpellBook.HasPetSpells() return 1 end
            function C_SpellBook.GetSpellBookItemInfo() return {spellID=high} end
            M:ScheduleDemonScan(); Advance(5)
            assert(M.db.demons.Imp.known[high] and M.db.demons.Imp.known[low])
            local before=M.db.demons.Imp
            C_SpellBook.GetSpellBookItemInfo=function() return nil end
            M:ScheduleDemonScan(); Advance(20); assert(M.db.demons.Imp==before)
        ''')

    def test_hunter_learn_messages_are_localized_and_limited_to_pet_abilities(self):
        self.runtime("playerClass='HUNTER'").execute('''
            ERR_LEARN_SPELL_S='Ihr habt %s erlernt.'
            Fire('CHAT_MSG_SYSTEM','Ihr habt |Hspell:4187|h[Biss]|h erlernt.')
            assert(M.db.pet[4187])
            Fire('CHAT_MSG_SYSTEM','Ihr habt |Hspell:1953|h[Blinzeln]|h erlernt.')
            assert(not M.db.pet[1953])
            Fire('CHAT_MSG_SYSTEM','Andere Nachricht |Hspell:4188|h[Biss]|h')
            assert(not M.db.pet[4188])
        ''')

    def test_extra_controls_show_prices_and_clear_hidden_selection(self):
        self.runtime().execute('''
            M.mode='weapons'; M:Open(); assert(M.panel.waypoint and M.panel.priceChoice)
            M.panel.rows[1].scripts.OnClick(); assert(M.selectedRow and M.panel.waypoint.enabled)
            M.panel.priceChoice.scripts.OnClick(); assert(M.db.priceFaction=='base')
            M.query='no match'; M:Refresh(); assert(not M.selectedRow and not M.panel.waypoint.enabled)
        ''')

    def test_waypoint_fallback_uses_existing_maps_module(self):
        self.runtime().execute('''
            C_Map.CanSetUserWaypointOnMap=function() return false end
            ForeverTools.modules.maps={SetTrainerMarker=function(_,target) selected=target; return true end}
            local target={mapID=1453,x=0.639,y=0.691,title='Woo Ping'}
            assert(M:SetTrainerWaypoint(target) and selected==target)
        ''')

    def test_future_pet_spells_are_not_recorded_as_learned(self):
        self.runtime("playerClass='WARLOCK'; playerLevel=60").execute('''
            local future=D.ClassData.WARLOCK.tomeTaughtSpells[16321]
            Enum.SpellBookItemType={Spell=1,FutureSpell=2}
            function UnitExists() return true end
            function UnitCreatureFamily() return 'Wichtel' end
            function UnitGUID() return 'Pet-Imp' end
            function C_SpellBook.HasPetSpells() return 2 end
            function C_SpellBook.GetSpellBookItemInfo(i)
                return i==1 and {spellID=999999,itemType=1} or {spellID=future,itemType=2}
            end
            M:ScheduleDemonScan(); Advance(5)
            assert(M.db.demons.Imp.known[future]==false)
        ''')

    def test_book_shortcut_stays_hidden_when_parent_window_is_hidden(self):
        self.runtime().execute('''
            SpellBookFrame=CreateFrame()
            function SpellBookFrame:IsVisible() return parentVisible or false end
            Fire('ADDON_LOADED','Blizzard_SpellBook')
            local button=M.bookLinks[SpellBookFrame]
            assert(SpellBookFrame:IsShown() and not button:IsShown())
            parentVisible=true; M:UpdateBookButtons(); assert(button:IsShown())
            parentVisible=false; Fire('PLAYER_REGEN_ENABLED'); assert(not button:IsShown())
        ''')


if __name__=='__main__':
    unittest.main()
