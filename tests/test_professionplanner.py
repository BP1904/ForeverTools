"""Profession stock snapshots, recipe scans and material-conserving skill proposals."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

EXTRA = r'''
bag={[1]=6,[2]=10}; bank={[1]=14}; rank=10; cap=75; known={[101]=true,[102]=true}
profession=2937
function GetProfessions() return 1 end
function GetProfessionInfo() return 'Alchemie','',rank,cap,nil,nil,profession end
function UnitLevel() return 60 end
function UnitRace() return 'Mensch','Human' end
function IsPlayerSpell(id) return known[id] or false end
function time() return 123456 end
function date() return '08.11. 15:00' end
C_Item.GetItemCount=function(id,includeBank)
    return (bag[id] or 0)+(includeBank and (bank[id] or 0) or 0)
end
C_Item.GetItemInfo=function(id) return 'Item'..id end
C_Spell={GetSpellName=function(id) return 'Spell'..id end}
local create=CreateFrame
function CreateFrame(...)
    local f=create(...)
    function f:SetAutoFocus() end
    function f:ClearFocus() end
    function f:GetText() return self.text or '' end
    function f:SetOwner(b) self.owner=b end
    function f:ClearLines() self.lines={} end
    function f:AddLine(text) self.lines[#self.lines+1]=text end
    function f:Show() self.shown=true end
    function f:Hide() self.shown=false end
    return f
end
namespace={materialUses={
    [1]={{171,101,1,15,2,12},{171,102,1,18,3,12},{171,103,1,20,1,14},
        {164,201,1,50,1,30}},
    [2]={{171,101,1,15,1,12}},
},recipes={[300]={171,103}},reagents={[101]={1,2,2,1},[102]={1,3},[103]={1,1}},
trainingData={Recipes={[171]={
    {spell=101,skill=10,source={'trainer'}},
    {spell=102,skill=10,source={'trainer'}},
    {spell=103,skill=12,teach=300,source={'vendor'},vendors={{npc=55,area=12}}},
}}}}
function Find(id) for _,r in ipairs(m.rows) do if r.id==id then return r end end end
'''


class ProfessionPlannerTest(unittest.TestCase):
    def runtime(self, before=''):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + EXTRA + before)
        for filename in ('Core.lua', 'Modules/ProfessionPlanner.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8'))
        lua.execute("Fire('ADDON_LOADED','ForeverTools');m=namespace.modules.professionplanner;assert(not m.initError,m.initError)")
        return lua

    def test_bags_bank_snapshot_and_no_bank_query_away_from_bank(self):
        self.runtime().execute('''
            m:Build(); assert(Find(101).bagCrafts==3 and Find(101).crafts==3)
            assert(not m.db.bankTime)
            Fire('BANKFRAME_OPENED');m:Build()
            assert(m.db.bank[1]==14 and m.db.bankTime==123456)
            assert(Find(101).bagCrafts==3 and Find(101).crafts==10)
            Fire('BANKFRAME_CLOSED')
            local count=C_Item.GetItemCount
            C_Item.GetItemCount=function(id,withBank) assert(not withBank);return count(id,false) end
            bank={};m:Build();assert(Find(101).crafts==10)
            m.settings.bank=false;m:Build();assert(Find(101).crafts==3)
        ''')

    def test_transfers_empty_bank_and_unavailable_reads(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED')
            bag[1]=10;bank[1]=10;Fire('BAG_UPDATE_DELAYED');m:Build()
            assert(m.db.bank[1]==10 and Find(101).crafts==10)
            local count=C_Item.GetItemCount
            C_Item.GetItemCount=function(id,b) if b then return nil end;return count(id,b) end
            Fire('PLAYERBANKSLOTS_CHANGED');assert(m.db.bank[1]==10)
            C_Item.GetItemCount=count;bank={};Fire('BAG_UPDATE_DELAYED')
            assert(not next(m.db.bank))
        ''')

    def test_plan_consumes_shared_stock_and_stops_at_grey(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED');m:Build()
            local used={}
            for _,step in ipairs(m.plan) do
                assert(step.recipe.known and step.to<=step.recipe.grey)
                assert(step.to-step.from==step.count)
                for id,n in pairs(step.recipe.reagents) do used[id]=(used[id] or 0)+n*step.count end
            end
            assert(used[1]<=20 and used[2]<=10)
            assert(m.target==18 and #m.plan==2)
            assert(m.stock[1]==20 and m.bags[1]==6)
        ''')

    def test_conditional_missing_recipe_unlocks_at_required_skill(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED');m:Build();local base=m.target
            m.settings.unlearned=true;m:Build()
            assert(m.target>base and m.target==20)
            local found=false
            for _,step in ipairs(m.plan) do
                if step.recipe.id==103 then assert(step.from>=12 and not step.recipe.known);found=true end
            end
            assert(found)
            m.query='does not exist';m:Build();assert(#m.rows==0 and m.target==20)
        ''')

    def test_recipe_source_material_quantities_and_foreign_professions(self):
        self.runtime().execute('''
            m:Build();assert(not Find(201))
            local r=Find(103);assert(not r.known and r.required==12 and r.teach==300)
            local text=table.concat(m:Details(r),'\\n')
            assert(text:find('Item300',1,true) and text:find('Händler',1,true) and text:find('NPC #55',1,true))
            assert(text:find('Taschen 6',1,true))
            bag={};m:Build()
            assert(Find(101).crafts==0 and m.target==rank)
            text=table.concat(m:Details(Find(101)),'\\n')
            assert(text:find('fehlt 2',1,true))
        ''')

    def test_skill_cap_unknown_thresholds_and_no_materials(self):
        self.runtime().execute('''
            cap=11;m:Build();assert(m.target==11)
            cap=75;namespace.materialUses[1][1][4]=nil
            namespace.materialUses[2][1][4]=nil
            known[102]=false;m:Build();assert(m.target==rank)
            assert(Find(101) and not Find(101).grey)
            namespace.reagents[102]={};m:Build();assert(not Find(102))
        ''')

    def test_modern_recipe_scan_authoritative_counts_and_known(self):
        self.runtime().execute('''
            C_TradeSkillUI={GetAllRecipeIDs=function() return {101,103} end,
                GetRecipeInfo=function(id) return {learned=id==103,name='Live'..id} end,
                GetRecipeSchematic=function() return {reagentSlotSchematics={
                    {required=true,quantityRequired=3,reagents={{itemID=1}}},
                    {required=false,quantityRequired=1,reagents={{itemID=999}}}}} end}
            Fire('TRADE_SKILL_LIST_UPDATE');m:Build()
            assert(not Find(101).known and Find(103).known)
            assert(Find(103).name=='Live103' and Find(103).crafts==2)
            assert(not Find(103).reagents[999])
            C_TradeSkillUI.IsTradeSkillLinked=function() return true end
            C_TradeSkillUI.GetRecipeInfo=function() error('must not scan someone else') end
            m:ScanRecipes();assert(m.db.recipes[103].known)
        ''')

    def test_unsupported_reagent_choices_excluded_from_plan(self):
        self.runtime().execute('''
            C_TradeSkillUI={GetAllRecipeIDs=function() return {101,102} end,
                GetRecipeInfo=function() return {learned=true} end,
                GetRecipeSchematic=function() return {reagentSlotSchematics={
                    {required=true,quantityRequired=2,reagents={{itemID=1},{itemID=2}}}}} end}
            m:ScanRecipes();m:Build();assert(m.target==rank and #m.plan==0)
        ''')

    def test_new_live_recipe_absent_from_database_is_tracked_without_forecast(self):
        self.runtime().execute('''
            C_TradeSkillUI={GetBaseProfessionInfo=function() return {professionID=171} end,
                GetAllRecipeIDs=function() return {999} end,
                GetRecipeInfo=function() return {learned=true,name='Neues Rezept'} end,
                GetRecipeSchematic=function() return {reagentSlotSchematics={
                    {required=true,quantityRequired=2,reagents={{itemID=1}}}}} end}
            m:ScanRecipes();m:Build()
            local r=Find(999)
            assert(r and r.known and r.crafts==3 and not r.grey)
            for _,step in ipairs(m.plan) do assert(step.recipe.id~=999) end
        ''')

    def test_no_profession_and_unavailable_events_preserve_startup(self):
        lua=self.runtime('''
            GetProfessions=nil
            local create2=CreateFrame
            function CreateFrame(...)
                local f=create2(...);local register=f.RegisterEvent
                function f:RegisterEvent(event)
                    if event=='CRAFT_UPDATE' then error('unsupported') end
                    register(self,event)
                end
                return f
            end
        ''')
        lua.execute('''
            m:Open();assert(m.panel.shown and #m.rows==0 and #m.plan==0)
            assert(m.panel.summary.text:find('Öffne deine Berufe',1,true))
        ''')

    def test_legacy_trade_and_enchanting_scan(self):
        self.runtime().execute('''
            function GetTradeSkillLine() return 'Alchemie',rank,cap end
            function GetNumTradeSkills() return 2 end
            function GetTradeSkillInfo(i) return i==1 and 'Header' or 'Testrezept',i==1 and 'header' or 'optimal' end
            function GetTradeSkillRecipeLink() return '|Henchant:101|h[Testrezept]|h' end
            function GetTradeSkillNumReagents() return 1 end
            function GetTradeSkillReagentItemLink() return 'item:1' end
            function GetTradeSkillReagentInfo() return 'Material',nil,3 end
            Fire('TRADE_SKILL_SHOW');m:Build()
            assert(Find(101).known and Find(101).name=='Testrezept' and Find(101).crafts==2)
            assert(m.db.recipes[101].reagents[1]==3 and not m.db.recipes[101].reagents[2])
            GetTradeSkillLine=nil
            function GetCraftDisplaySkillLine() return 'Alchemie',rank,cap end
            function GetNumCrafts() return 1 end
            function GetCraftInfo() return 'Verzauberung','', 'optimal' end
            GetCraftRecipeLink=GetTradeSkillRecipeLink;GetCraftNumReagents=GetTradeSkillNumReagents
            GetCraftReagentItemLink=GetTradeSkillReagentItemLink;GetCraftReagentInfo=GetTradeSkillReagentInfo
            Fire('CRAFT_UPDATE');m:Build();assert(Find(101).name=='Verzauberung')
        ''')

    def test_per_character_persistence_and_relearn_invalidates_recipes(self):
        lua=self.runtime('ForeverToolsProfessionDB={bank={[1]=30},bankTime=111,recipes={[103]={profession=171,known=true}},ranks={[171]=20}}')
        lua.execute('''
            m:Build();assert(not Find(103).known and m.db.bank[1]==30)
            m.db.recipes[103]={profession=171,known=true};m.db.ranks[171]=10
            profession=164;m:Build();assert(not m.db.recipes[103])
        ''')

    def test_faction_level_and_reputation_limits_on_conditional_plans(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED');m.settings.unlearned=true
            local e=namespace.trainingData.Recipes[171][3]
            e.faction='Horde';m:Build();assert(not Find(103) and m.target==18)
            e.faction=nil;e.reputationUnknown=true;m:Build();assert(m.target==18)
            e.reputationUnknown=nil;e.level=61;m:Build();assert(m.target==18)
        ''')

    def test_panel_controls_tooltip_and_disable(self):
        self.runtime().execute('''
            SlashCmdList.FOREVERTOOLSPROFESSIONS();assert(m.panel.shown)
            local p=m.panel
            assert(p.summary.text:find('Bank noch nicht gescannt',1,true))
            local b=p.rows[1];b.scripts.OnEnter(b);assert(m.tooltip.shown and #m.tooltip.lines>4)
            b.scripts.OnLeave();assert(not m.tooltip.shown)
            p.mode.scripts.OnClick();assert(m.mode=='plan' and p.rows[1].step)
            p.bank.scripts.OnClick();assert(not m.settings.bank)
            p.unlearned.scripts.OnClick();assert(m.settings.unlearned)
            p.search:SetText('nothing');p.search.scripts.OnTextChanged(p.search)
            assert(#m.rows==0 and #m.plan>0)
            namespace:SetEnabled('professionplanner',false);assert(not p.shown)
            SlashCmdList.FOREVERTOOLSPROFESSIONS();assert(not p.shown)
        ''')


if __name__ == '__main__':
    unittest.main()
