"""Material tooltip and auction search integration with simulated WoW APIs."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

MATERIAL_MOCK = r'''
profession = 2937
function GetProfessions() return 1, nil, nil, 4 end
function GetProfessionInfo(i) return '', '', 1, 300, nil, nil, i == 1 and profession or 185 end
function UnitClass() return 'Mage', 'MAGE' end
known = {}
function IsPlayerSpell(id) return known[id] end
C_Spell = {GetSpellName=function(id) return 'Spell'..id end}
function NewTooltip()
    local tip = {lines={}}
    function tip:AddLine(text, r, g, b) self.lines[#self.lines+1]={text,r,g,b} end
    function tip:Show() end
    function tip:HookScript(event, fn) self.hook = fn end
    function tip:GetItem() return '', 'item:765' end
    return tip
end
GameTooltip = NewTooltip()
ItemRefTooltip = NewTooltip()
Enum = {TooltipDataType={Item=0}}
TooltipDataProcessor = {AddTooltipPostCall=function(_, fn) postcall=fn end}
counts, names, requests = {}, {}, {}
C_Item.GetItemCount = function(id, bank) assert(bank); return counts[id] or 0 end
C_Item.GetItemInfo = function(id) return names[id] end
C_Item.RequestLoadItemDataByID = function(id) requests[id]=true end
timers = {}
C_Timer = {After=function(delay, fn) timers[#timers+1]={delay=delay, fn=fn} end}
function RunTimers(delay)
    local old=timers; timers={}
    for _, t in ipairs(old) do
        if t.delay == delay then t.fn() else timers[#timers+1]=t end
    end
end
queries = {}
AuctionHouseFrame = {SearchBar={SearchBox={SetText=function(_, text) query=text end},
    StartSearch=function() queries[#queries+1]=query end}}
results = {}
C_AuctionHouse = {GetBrowseResults=function() return results end}
mail = {}
function GetInboxNumItems() return #mail end
function GetInboxItemLink(m,a) return mail[m][a] end
'''


class MaterialsTest(unittest.TestCase):
    def setup_runtime(self, legacy=False):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + MATERIAL_MOCK)
        if legacy:
            self.lua.execute('TooltipDataProcessor=nil')
        self.lua.execute('namespace={}')
        toc = (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8')
        for line in toc.splitlines():
            if line and not line.startswith(('#', 'Features\\')):
                source = (ROOT / 'ForeverTools' / line.replace('\\', '/')).read_text(encoding='utf-8')
                self.lua.execute('assert(loadstring(...))("ForeverTools", namespace)', source)
        self.lua.execute('Fire("ADDON_LOADED", "ForeverTools"); M=ForeverTools.modules.materials')

    def setUp(self):
        self.setup_runtime()

    def test_source_database_integrity(self):
        self.lua.execute('''
            local materials, recipes=0,0
            for id, rows in pairs(namespace.materialUses) do
                materials=materials+1
                for _,r in ipairs(rows) do
                    assert(#r==6 and r[5]>0 and r[6]<=r[4])
                end
            end
            for id,r in pairs(namespace.recipes) do
                recipes=recipes+1
                assert(namespace.reagents[r[2]], 'missing reagent record')
            end
            assert(materials>500 and recipes>500)
        ''')

    def test_tooltip_profession_alias_known_color_and_cap(self):
        self.lua.execute('''
            known[1245250]=true
            postcall(GameTooltip, {id=765})
            assert(GameTooltip.lines[2][1]=='Verwendet für:')
            assert(GameTooltip.lines[3][3]==1)
            assert(string.find(GameTooltip.lines[3][1], '×1', 1, true))
            GetProfessions=function() return 1 end
            GameTooltip.lines={}; postcall(GameTooltip, {id=785})
            assert(#GameTooltip.lines==12)
            assert(string.find(GameTooltip.lines[11][1], 'weitere'))
            assert(GameTooltip.lines[12][1]=='Auch für: Kochkunst')
        ''')

    def test_unknown_items_and_other_tooltips_and_switches(self):
        self.lua.execute('''
            postcall(GameTooltip, {id=99999999}); postcall(GameTooltip, nil)
            local other=NewTooltip(); postcall(other, {id=765}); assert(#other.lines==0)
            M.settings.tooltips=false; postcall(GameTooltip, {id=765}); assert(#GameTooltip.lines==0)
            M.settings.tooltips=true; ForeverTools:SetEnabled('materials',false)
            postcall(GameTooltip, {id=765}); assert(#GameTooltip.lines==0)
            ForeverTools:SetEnabled('materials',true); postcall(ItemRefTooltip,{id=765})
            assert(#ItemRefTooltip.lines>0)
        ''')

    def test_legacy_tooltips_and_spell_name_fallback(self):
        self.setup_runtime(legacy=True)
        self.lua.execute('''
            C_Spell=nil; GetSpellInfo=function(id) return 'Legacy'..id end
            ItemRefTooltip.hook(ItemRefTooltip)
            assert(string.find(ItemRefTooltip.lines[3][1],'Legacy'))
            GetSpellInfo=nil; GameTooltip.hook(GameTooltip)
            assert(string.find(GameTooltip.lines[3][1],'#1245250',1,true))
        ''')

    def candidates(self):
        self.lua.execute('''
            namespace.recipes = {[101]={171,201},[102]={171,202},[103]={164,203},
                [104]={171,204},[105]={171,205},[106]={171,206},[107]={171,207}}
            namespace.reagents = {[201]={1,20,2,10}, [202]={1,20},[203]={1,1},
                [204]={1,1},[205]={1,1},[206]={},[207]={3,1}}
            names={[101]='A',[102]='B',[103]='C',[104]='D',[105]='E'}
            counts={[1]=1,[104]=1}; known[204]=true
            ForeverToolsMaterialMail[105]=true
        ''')

    def test_candidates_coverage_order_known_owned_mail_and_missing_data(self):
        self.candidates()
        self.lua.execute('''
            local list=M:Matches()
            assert(#list==2 and list[1].id==102 and list[2].id==101)
            assert(list[2].have==1 and list[2].total==2)
            counts[104]=nil; local again=M:Matches(); assert(#again==2)
            known[204]=nil; local third=M:Matches(); assert(#third==3)
            names[102]=nil; local cached,unloaded=M:Matches()
            assert(#cached==2 and unloaded and requests[102])
        ''')

    def test_search_skips_empty_stops_at_hit_and_next_click_advances(self):
        self.candidates()
        self.lua.execute('''
            Fire('AUCTION_HOUSE_SHOW'); M.button.scripts.OnClick()
            assert(queries[1]=='B')
            Fire('AUCTION_HOUSE_BROWSE_RESULTS_UPDATED'); RunTimers(0.7)
            assert(queries[2]=='A')
            results={{}}; Fire('AUCTION_HOUSE_BROWSE_RESULTS_UPDATED'); RunTimers(0.7)
            assert(not M.search)
            M:StartSearch(); assert(queries[3]=='B')
        ''')

    def test_all_empty_and_timeout_stop(self):
        self.candidates()
        self.lua.execute('''
            Fire('AUCTION_HOUSE_SHOW'); M:StartSearch()
            for i=1,2 do Fire('AUCTION_HOUSE_BROWSE_RESULTS_UPDATED'); RunTimers(0.7) end
            assert(#queries==2 and not M.search)
            M:StartSearch(); RunTimers(12); assert(not M.search and #queries==3)
        ''')

    def test_close_disable_and_reclick_invalidate_pending_callbacks(self):
        self.candidates()
        self.lua.execute('''
            Fire('AUCTION_HOUSE_SHOW'); M:StartSearch()
            Fire('AUCTION_HOUSE_BROWSE_RESULTS_UPDATED')
            Fire('AUCTION_HOUSE_CLOSED'); RunTimers(0.7); assert(#queries==1 and not M.search)
            Fire('AUCTION_HOUSE_SHOW'); M:StartSearch()
            Fire('AUCTION_HOUSE_BROWSE_RESULTS_UPDATED')
            M:StartSearch(); RunTimers(0.7); assert(#queries==3)
            ForeverTools:SetEnabled('materials',false); RunTimers(12)
            assert(not M.search and not M.button:IsShown())
            ForeverTools:SetEnabled('materials',true); assert(M.button:IsShown())
            M:StartSearch(); M.settings.auction=false; M:OnSettingsChanged()
            assert(not M.search and not M.button:IsShown())
        ''')

    def test_mail_snapshot_and_legacy_auction(self):
        self.candidates()
        self.lua.execute('''
            mail={{'item:101', 'item:102'}}; Fire('MAIL_INBOX_UPDATE')
            assert(ForeverToolsMaterialMail[101] and ForeverToolsMaterialMail[102])
            mail={}; Fire('MAIL_INBOX_UPDATE'); assert(not next(ForeverToolsMaterialMail))
            AuctionHouseFrame=nil; AuctionFrame={}; M.button=nil
            BrowseName={SetText=function(_,text) query=text end}
            AuctionFrameBrowse_Search=function() queries[#queries+1]=query end
            GetNumAuctionItems=function() return 1 end
            Fire('AUCTION_HOUSE_SHOW'); M:StartSearch()
            Fire('AUCTION_ITEM_LIST_UPDATE'); RunTimers(0.7)
            assert(queries[1]=='B' and not M.search)
        ''')

    def test_menu_and_tocs(self):
        self.lua.execute('''
            SlashCmdList.FOREVERTOOLS()
            local checks=ForeverTools.menu.checks
            local master=ForeverTools.menu.byModule.materials.master.box
            assert(#checks==43 and master:GetChecked())
            master:SetChecked(false); master.scripts.OnClick(master)
            assert(not ForeverTools:IsEnabled('materials') and ForeverTools:IsEnabled('merchant'))
        ''')
        a = (ROOT / 'ForeverTools/ForeverTools.toc').read_text(encoding='utf-8')
        b = (ROOT / 'ForeverTools/ForeverTools_Camelot.toc').read_text(encoding='utf-8')
        self.assertEqual(a, b)


if __name__ == '__main__':
    unittest.main(verbosity=2)
