"""Training data, per-character state, prerequisites and the independent UI."""
import unittest
import xml.etree.ElementTree as ET
from test_forevertools import ROOT, MOCK, LuaRuntime

DATA = ROOT / 'ForeverTools/Data/Training'
TRAINING_MOCK = r'''
tinsert=table.insert
playerClass='MAGE'; playerLevel=20; playerRace=1
function UnitClass() return playerClass,playerClass end
function UnitRace() return 'Human','Human',playerRace end
function UnitLevel() return playerLevel end
known={}; petKnown={}; skills={}; reps={}; spellNames={}; requests={}
Enum={SpellBookSpellBank={Player=0,Pet=1},TrainerType={Pet=2,Class=1}}
C_Spell={GetSpellInfo=function(id)
    if missingSpell==id then return end
    return {name=spellNames[id] or 'Spell'..id,iconID=123}
end,GetSpellSubtext=function() return 'Rang 1' end,
RequestLoadSpellData=function(id) requests[#requests+1]=id end}
C_SpellBook={IsSpellKnown=function(id,bank) return (bank==1 and petKnown or known)[id] or false end}
C_SkillInfo={GetSkillLineInfoByID=function(id) return skills[id] end}
C_Reputation={GetFactionDataByID=function(id) return reps[id] end}
C_Map={GetAreaInfo=function(id) return 'Gebiet '..id end}
C_Trainer={GetTrainerType=function() return trainerType end}
C_TooltipInfo={GetTrainerService=function(i) return {id=trainerIDs[i]} end}
function GetNumTrainerServices() return #(trainerIDs or {}) end
local make=CreateFrame
function CreateFrame(...)
    local f=make(...)
    function f:SetAutoFocus() end
    function f:SetMaxLetters() end
    function f:GetText() return self.text or '' end
    function f:ClearFocus() end
    return f
end
'''


class TrainingTest(unittest.TestCase):
    def runtime(self, extra='', with_extras=False):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK+TRAINING_MOCK+extra)
        lua.execute('namespace={}')
        files=[ROOT/'ForeverTools/Core.lua', DATA/'Bootstrap.lua']
        files += [DATA / element.attrib['file'] for element in ET.parse(DATA/'Manifest.xml').getroot()]
        files += [ROOT/'ForeverTools/Modules/Training.lua']
        if with_extras:
            files += [ROOT/'ForeverTools/Modules/TrainingExtras.lua']
        for path in files:
            lua.execute('assert(loadstring(...))("ForeverTools",namespace)',path.read_text(encoding='utf-8'))
        lua.execute('Fire("ADDON_LOADED","ForeverTools"); M=ForeverTools.modules.training; D=namespace.trainingData')
        return lua

    def test_complete_forever_catalog_and_mit_license(self):
        self.runtime().execute('''
            local n,spells,recipes=0,0,0
            for _,class in pairs(D.ClassData) do
                n=n+1
                for level,entries in pairs(class.spellsByLevel) do
                    assert(level>=1 and level<=60)
                    for _,entry in ipairs(entries) do assert(entry.id>0 and entry.cost>=0); spells=spells+1 end
                end
            end
            for _,entries in pairs(D.Recipes) do
                for _,entry in ipairs(entries) do assert(entry.spell>0); recipes=recipes+1 end
            end
            assert(n==9 and spells>1000 and recipes>1000)
            assert(D.WeaponSkills[196].classes.ROGUE and D.WeaponSkills[197].classes.SHAMAN)
            local changed=false
            for _,trainer in ipairs(D.WeaponSkills[201].trainers.Alliance) do
                if trainer.npc==11867 then assert(trainer.x==63.9 and trainer.y==69.1); changed=true end
            end
            assert(changed)
        ''')
        self.assertIn('MIT License',(DATA/'LICENSE.txt').read_text())
        self.assertIn('Copyright (c) 2019',(DATA/'LICENSE.txt').read_text())

    def test_all_nine_classes_build_all_four_views(self):
        for token in ('DRUID','HUNTER','MAGE','PALADIN','PRIEST','ROGUE','SHAMAN','WARLOCK','WARRIOR'):
            with self.subTest(token=token):
                self.runtime("playerClass='"+token+"'").execute('''
                    for _,mode in ipairs({'class','weapons','pets','recipes'}) do
                        M.mode=mode
                        for _,row in ipairs(M:Build()) do
                            assert(row.id and row.name and row.status and row.level)
                            assert(type(M:Details(row))=='string')
                        end
                    end
                ''')

    def test_player_class_available_future_prerequisites_and_cost(self):
        self.runtime().execute('''
            local rows=M:Build(); local byID={}
            for _,row in ipairs(rows) do byID[row.id]=row end
            assert(byID[1953].status=='available' and byID[1953].level==20)
            assert(M.available>0 and M.total>0)
            assert(M:Classify({id=9001,level=21},{},false)=='next')
            assert(M:Classify({id=9001,level=23},{},false)=='later')
            local row={id=9001,level=10}; assert(M:Classify(row,{requiredIds={9000}},false)=='missing')
            known[9000]=true; assert(M:Classify(row,{requiredIds={9000}},false)=='available')
            assert(M:Classify(row,{requiredTalentId=9999},false)=='missing')
            known[9999]=true; assert(M:Classify(row,{requiredTalentId=9999},false)=='available')
            known[9001]=true; assert(M:Classify(row,{},false)=='known')
        ''')

    def test_overridden_ranks_and_race_quest_filter(self):
        self.runtime("playerClass='WARRIOR'").execute('''
            local group=D.ClassData.WARRIOR.overriddenGroups[1]
            known[group[#group]]=true
            assert(M:Known(group[1]))
            assert(not M:Matches({race=2}) and not M:Matches({faction='Horde'}))
            assert(M:Matches({races={1,3}}))
            local found=false
            for _,row in ipairs(M:BuildClass()) do
                if row.id==71 then
                    assert(row.status=='quest' and row.cost==0 and row.entry.quests[1]==1665); found=true
                end
            end
            assert(found)
        ''')

    def test_ignored_known_search_and_character_persistence(self):
        self.runtime().execute('''
            M:Build(); M:ToggleIgnored(1953); assert(M.db.ignored[1953])
            for _,row in ipairs(M:Build()) do assert(row.id~=1953) end
            M.db.showIgnored=true; M.query='spell1953'
            local rows=M:Build(); assert(#rows==1 and rows[1].status=='ignored')
            M:ToggleIgnored(1953); known[1953]=true
            assert(#M:Build()==0)
            M.db.showKnown=true; assert(M:Build()[1].status=='known')
            local saved=ForeverToolsTrainingDB; M:Initialize(); assert(M.db==saved and M.db.showKnown)
        ''')

    def test_legacy_character_settings_migrate_without_foreign_dependency(self):
        self.runtime('''
            WT_IgnoredSpells={[1953]=true,MIGRATED=true}
            WT_LearnedPetAbilities={Biss={['Rang 1']=true}}
        ''').execute('''
            assert(M.db.ignored[1953] and M.db.legacyPet.Biss['Rang 1'] and M.db.migrated)
            M.db.ignored[1953]=nil; M:Initialize(); assert(not M.db.ignored[1953])
            assert(WhatsTraining==nil and WT_API==nil)
        ''')

    def test_hunter_pet_trainer_capture_not_current_pet_guess(self):
        self.runtime("playerClass='HUNTER'").execute('''
            petKnown[4187]=true; assert(not M:Known(4187,true))
            trainerIDs={4187,1953}; trainerType=1; Fire('TRAINER_SHOW'); assert(not M.db.pet[4187])
            trainerType=2; Fire('TRAINER_SHOW'); assert(M.db.pet[4187] and not M.db.pet[1953])
            assert(M:Known(4187,true))
            M.mode='pets'; local rows=M:Build(); assert(#rows>0)
            for _,row in ipairs(rows) do assert(row.pet) end
            M.mode='class'; for _,row in ipairs(M:Build()) do assert(not row.pet) end
        ''')

    def test_warlock_tomes_and_weapon_trainers(self):
        self.runtime("playerClass='WARLOCK'").execute('''
            M.mode='pets'; local found=false
            for _,row in ipairs(M:Build()) do if row.kind=='tome' then assert(row.itemID); found=true end end
            assert(found)
            M.mode='weapons'; local rows=M:Build(); assert(#rows>0)
            for _,row in ipairs(rows) do assert(D.WeaponSkills[row.id].classes.WARLOCK) end
            assert(M:Details(rows[1]):find('Grundpreis'))
        ''')

    def test_shared_grimoires_keep_separate_companion_entries(self):
        self.runtime("playerClass='WARLOCK'; playerLevel=60").execute('''
            local found={}
            for _,row in ipairs(M:BuildClass()) do
                if row.itemID==16375 then found[row.key]=row end
            end
            assert(found['SUC:16375'] and found['INC:16375'])
            assert(found['SUC:16375'].name~=found['INC:16375'].name)
            M:ToggleIgnored('SUC:16375')
            local hidden,other=false,false
            for _,row in ipairs(M:BuildClass()) do
                if row.key=='SUC:16375' then hidden=row.status=='ignored' end
                if row.key=='INC:16375' then other=row.status=='check' end
            end
            assert(hidden and other)
        ''')

    def test_recipes_skills_reputation_unknown_and_opposing_sources(self):
        self.runtime().execute('''
            skills[171]={name='Alchemie',rank=30,maxRank=75}; M.mode='recipes'
            local rows=M:Build(); assert(#rows>0)
            for _,row in ipairs(rows) do assert(row.profession=='Alchemie') end
            local row={id=9999,level=1}
            assert(M:RecipeStatus(row,{skill=25,source={'trainer'}},skills[171])=='available')
            assert(M:RecipeStatus(row,{skill=35,source={'trainer'}},skills[171])=='next')
            assert(M:RecipeStatus(row,{skill=300,source={'trainer'}},skills[171])=='later')
            assert(M:RecipeStatus(row,{source={'trainer'}},skills[171])=='check')
            assert(M:RecipeStatus(row,{skill=1,reputation={1,6,'Ruf'},source={'trainer'}},skills[171])=='missing')
            reps[1]={reaction=6}; assert(M:RecipeStatus(row,{skill=1,reputation={1,6,'Ruf'},source={'trainer'}},skills[171])=='available')
            assert(M:RecipeStatus(row,{skill=1,merchantFavor=30,source={'vendor'}},skills[171])=='check')
            assert(not M:RecipeAllowed({source={'vendor'},vendors={{faction='Horde'}}}))
            assert(M:RecipeAllowed({source={'vendor','drop'},vendors={{faction='Horde'}}}))
            M.settings.professions=false; assert(#M:Build()==0)
        ''')

    def test_missing_names_are_loaded_in_bounded_batches_and_refresh(self):
        self.runtime().execute('''
            missingSpell=1953; M:Build(); assert(M.requested[1953])
            for i=1,100 do M.loadQueue[#M.loadQueue+1]=9000+i end
            Advance(1); assert(#requests<=15)
            local count=#M.loadQueue; M:Spell(1953); assert(#M.loadQueue==count)
            ForeverTools:SetEnabled('training',false); local n=#requests; Advance(3); assert(#requests==n)
        ''')

    def test_window_paging_events_and_no_automatic_training(self):
        self.runtime().execute('''
            function BuyTrainerService() error('must not train automatically') end
            SlashCmdList.FOREVERTOOLSTRAINING(); local p=M.panel
            assert(p:IsShown() and #p.rows==8 and p.rows[1].row)
            p.rows[1].scripts.OnClick(); assert(p.detail.text:find('Grundpreis'))
            p.search:SetText('Spell1953'); p.search.scripts.OnTextChanged(p.search)
            assert(#M.rows==1)
            local n=#messages; playerLevel=21; Fire('PLAYER_LEVEL_UP'); Advance(1)
            assert(#messages==n+1 and M.level==21)
            ForeverTools:SetEnabled('training',false); assert(not p:IsShown())
            Fire('PLAYER_LEVEL_UP'); Advance(1); assert(#messages==n+1)
        ''')


if __name__=='__main__':
    unittest.main()
