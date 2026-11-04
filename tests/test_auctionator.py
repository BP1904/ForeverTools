"""Standalone auction helper: scan integrity, prices, isolation and lifecycle."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

AH_MOCK = r'''
function time() return 100000 + now end
realm='Realm'; faction='Alliance'; npcFaction='Alliance'
function GetRealmName() return realm end
function UnitFactionGroup(unit) if unit=='npc' then return npcFaction end; return faction end
canQuery=true; canAll=true; queries=0; auctions={}
function CanSendAuctionQuery() return canQuery,canAll end
function QueryAuctionItems(text,lo,hi,page,usable,quality,all,exact,filter)
    queries=queries+1; lastAll=all
    if rejectQuery then error('query rejected') end
end
function hooksecurefunc(name, callback)
    local old=_G[name]
    _G[name]=function(...) old(...); callback(...) end
end
function GetNumAuctionItems() return #auctions,total or #auctions end
function GetAuctionItemInfo(_,i)
    local a=auctions[i]; return a.name,nil,a.count,nil,nil,nil,nil,nil,nil,a.buyout
end
function GetAuctionItemLink(_,i) return auctions[i].link end
function GetAuctionSellItemInfo() return saleName,nil,saleCount end
'''


class AuctionTest(unittest.TestCase):
    def runtime(self):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + AH_MOCK)
        lua.execute('namespace={}')
        for name in ('Core.lua', 'Modules/Auctionator.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / name).read_text(encoding='utf-8'))
        lua.execute('Fire("ADDON_LOADED", "ForeverTools"); M=ForeverTools.modules.auctionator')
        return lua

    def test_scan_unit_prices_variants_and_no_buyout(self):
        lua = self.runtime()
        lua.execute('''
            auctions={
              {name='Erz',count=20,buyout=1001,link='item:1:0:0:0:0:0:0'},
              {name='Erz',count=1,buyout=99,link='item:1'},
              {name='Schwert',count=1,buyout=200,link='item:2:0:0:0:0:0:-5'},
              {name='Schwert',count=1,buyout=300,link='item:2:0:0:0:0:0:-6'},
              {name='Gebot',count=1,buyout=0,link='item:3'}}
            Fire('AUCTION_HOUSE_SHOW'); M:StartScan()
            assert(queries==1 and lastAll and M.scan)
            Fire('AUCTION_ITEM_LIST_UPDATE'); Advance(1)
            local p=M:Market().prices
            assert(not M.scan and p['1:0'].unit==1001/20)
            assert(p['2:-5'].unit==200 and p['2:-6'].unit==300 and not p['3:0'])
            local tip={lines={},AddLine=function(self,line) self.lines[#self.lines+1]=line end}
            M:AddTooltip(tip,'item:1'); assert(#tip.lines==2)
            assert(tip.lines[2]:find('49'))
            M.settings.tooltips=false; M:AddTooltip(tip,'item:1'); assert(#tip.lines==2)
        ''')

    def test_incomplete_timeout_and_foreign_query_preserve_prices(self):
        lua = self.runtime()
        lua.execute('''
            Fire('AUCTION_HOUSE_SHOW'); old={['9:0']={unit=500,stamp=time()}}
            M:Market().prices=old
            auctions={{name='Erz',count=1,buyout=10,link='item:1'}}; total=20
            M:StartScan(); Fire('AUCTION_ITEM_LIST_UPDATE'); Advance(1)
            assert(M.scan and not M.scan.index and M:Market().prices==old)
            now=46; Advance(1); assert(not M.scan and M:Market().prices==old)
            total=nil; auctions[1].link=nil
            M:StartScan(); Fire('AUCTION_ITEM_LIST_UPDATE'); Advance(1)
            assert(M.scan and M:Market().prices==old)
            QueryAuctionItems('Other'); assert(not M.scan and M:Market().prices==old)
            auctions[1].link='item:1'; M:StartScan()
            Fire('AUCTION_ITEM_LIST_UPDATE'); Advance(1)
            assert(not M:Market().prices['9:0'] and M:Market().prices['1:0'])
        ''')

    def test_locks_close_disable_and_rejected_query(self):
        lua = self.runtime()
        lua.execute('''
            M:StartScan(); assert(queries==0)
            Fire('AUCTION_HOUSE_SHOW'); canAll=false; M:StartScan(); assert(queries==0)
            canAll=true; combat=true; M:StartScan(); assert(queries==0)
            combat=false; rejectQuery=true; M:StartScan(); assert(not M.scan)
            rejectQuery=false; M:StartScan(); Fire('AUCTION_HOUSE_CLOSED'); assert(not M.scan)
            Fire('AUCTION_HOUSE_SHOW'); M:StartScan()
            ForeverTools:SetEnabled('auctionator',false); assert(not M.scan)
            local n=queries; M:StartScan(); assert(queries==n)
        ''')

    def test_shopping_persistence_and_market_isolation(self):
        lua = self.runtime()
        lua.execute('''
            M:AddToList(' Erz '); M:AddToList('erz'); assert(#M.settings.shopping==1)
            M:AddToList('Stoff'); M:RemoveFromList(1); assert(M.settings.shopping[1]=='Stoff')
            local saved=ForeverToolsDB
            ForeverTools:Initialize(); assert(M.settings.shopping[1]=='Stoff' and ForeverToolsDB==saved)
            local home=M:Market(); home.prices['1:0']={unit=10,stamp=time()}
            npcFaction=nil; Fire('AUCTION_HOUSE_SHOW')
            assert(M:Market()~=home and not M:Market().prices['1:0'])
            Fire('AUCTION_HOUSE_CLOSED'); assert(M:Market()==home)
            realm='Other'; assert(M:Market()~=home)
            realm='Realm'; faction='Horde'; assert(M:Market()~=home)
        ''')

    def test_search_resets_filters_and_never_trades(self):
        lua = self.runtime()
        lua.execute('''
            BrowseName=CreateFrame(); BrowseMinLevel=CreateFrame(); BrowseMaxLevel=CreateFrame()
            IsUsableCheckButton=CreateFrame(); AuctionFrameBrowse={page=8,qualityIndex=4,selectedCategoryIndex=2}
            function AuctionFrameBrowse_Search() searched=true end
            function PlaceAuctionBid() error('must not buy') end
            function PostAuction() error('must not sell') end
            Fire('AUCTION_HOUSE_SHOW'); M:Search(' Erz ')
            assert(searched and BrowseName.text=='Erz' and AuctionFrameBrowse.page==0)
            assert(not AuctionFrameBrowse.qualityIndex and not AuctionFrameBrowse.selectedCategoryIndex)
            searched=false; M:StartScan(); M:Search('Stoff'); assert(not searched)
        ''')

    def test_chunked_scan_commits_only_at_end(self):
        lua = self.runtime()
        lua.execute('''
            Fire('AUCTION_HOUSE_SHOW'); local old=M:Market().prices
            for i=1,450 do auctions[i]={name='Erz',count=1,buyout=i,link='item:1'} end
            M:StartScan(); Fire('AUCTION_ITEM_LIST_UPDATE'); Advance(1)
            assert(M.scan and M:Market().prices==old)
            Advance(2); assert(not M.scan and M:Market().prices['1:0'].unit==1)
        ''')

    def test_panel_buttons_and_disable(self):
        lua = self.runtime()
        lua.execute('''
            local make=CreateFrame
            function CreateFrame(...)
                local f=make(...)
                function f:SetAutoFocus() end
                function f:SetMaxLetters() end
                function f:GetText() return self.text or '' end
                function f:ClearFocus() end
                return f
            end
            M:Open(); local p=M.panel
            assert(p:IsShown() and #p.rows==6)
            M:AddToList('Erz'); assert(p.rows[1].search.text=='Erz')
            p.rows[1].remove.scripts.OnClick(); assert(#M.settings.shopping==0)
            ForeverTools:SetEnabled('auctionator',false); assert(not p:IsShown())
        ''')

    def test_sale_suggestion_never_writes_prices(self):
        lua = self.runtime()
        lua.execute('''
            Fire('AUCTION_HOUSE_SHOW')
            M:Market().prices['1:0']={name='Erz',unit=100,stamp=time()}
            saleName='Erz'; saleCount=20; Fire('NEW_AUCTION_UPDATE')
            assert(M.status:find('1980') and M.status:find('99'))
            M:Market().prices['1:1']={name='Erz',unit=50,stamp=time()}
            M.status='unchanged'; Fire('NEW_AUCTION_UPDATE'); assert(M.status=='unchanged')
        ''')


if __name__ == '__main__':
    unittest.main()
