"""Transactions use refreshed server rows, bounded jobs and explicit confirmation."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime
from test_auctionator import AH_MOCK

TRADING_MOCK = r'''
local make=CreateFrame
function CreateFrame(...)
    local f=make(...)
    function f:SetAutoFocus() end
    function f:SetMaxLetters() end
    function f:SetNumeric() end
    function f:SetMultiLine() end
    function f:SetFontObject() end
    function f:GetText() return tostring(self.text or '') end
    function f:ClearFocus() end
    function f:SetFocus() end
    function f:HighlightText() end
    return f
end
function UnitName() return 'Tester' end
function UnitFullName() return 'Tester','Realm' end
StaticPopupDialogs={}
function StaticPopup_Show(id,text,_,data) popup={id=id,text=text,data=data} end
function StaticPopup_Hide() popup=nil end
function Accept()
    local p=popup; assert(p,'missing confirmation')
    StaticPopupDialogs[p.id].OnAccept({},p.data)
end
buyCalls={}; cancelCalls={}; postCalls={}; ownerCalls={}; nextQuery=0
canCancel=true; ownerRows={}; ownTotal=0
function CanSendAuctionQuery() return canQuery and now>=nextQuery,canAll end
function QueryAuctionItems(name,lo,hi,page,usable,quality,all,exact)
    if rejectQuery then error('query rejected') end
    queries=queries+1; nextQuery=now+0.5
    query={name=name,lo=lo,hi=hi,page=page,quality=quality,all=all,exact=exact}
end
function GetNumAuctionItems(kind)
    if kind=='owner' then return #ownerRows,ownTotal end
    return #auctions,total or #auctions
end
function GetAuctionItemInfo(kind,i)
    local a=(kind=='owner' and ownerRows or auctions)[i]
    if not a then return end
    return a.name,nil,a.count,a.quality or 1,true,a.level or 1,nil,a.minBid or 1,1,
        a.buyout,a.bid or 0,nil,nil,a.owner,a.ownerFull,a.saleStatus or 0,a.itemID or 1,a.complete~=false
end
function GetAuctionItemLink(kind,i) return ((kind=='owner' and ownerRows or auctions)[i] or {}).link end
function Row(id,price,owner,count)
    return {name='Item'..id,link='item:'..id,count=count or 1,buyout=price,owner=owner or 'Other',ownerFull=(owner or 'Other')..'-Realm',itemID=id}
end
function Deliver(rows,n)
    auctions=rows; total=n or #rows; Fire('AUCTION_ITEM_LIST_UPDATE')
end
function GetOwnerAuctionItems(page) ownerCalls[#ownerCalls+1]=page or 0 end
function DeliverOwned(rows,n)
    ownerRows=rows; ownTotal=n or #rows; Fire('AUCTION_OWNED_LIST_UPDATE')
end
function PlaceAuctionBid(kind,index,price)
    buyCalls[#buyCalls+1]={kind=kind,index=index,price=price}
end
function CanCancelAuction() return canCancel end
function CancelAuction(index) cancelCalls[#cancelCalls+1]=index end
sale={name='Item1',count=20,maxStack=20,total=40,itemID=1,guid='abc'}
function GetAuctionSellItemInfo()
    if not sale then return end
    return sale.name,nil,sale.count,1,true,1,1,sale.maxStack,sale.total,sale.itemID,sale.guid
end
deposit=20
function GetAuctionDeposit() return deposit end
AuctionsCreateAuctionButton={StartPost=function(_,bid,buyout,duration,size,stacks,confirmed)
    postCalls[#postCalls+1]={bid=bid,buyout=buyout,duration=duration,size=size,stacks=stacks,confirmed=confirmed}
end}
AuctionFrame=CreateFrame(); AuctionsItemButton=CreateFrame()
function AuctionSellItemButton_OnClick() placed=true end
'''


class TradingTest(unittest.TestCase):
    def runtime(self):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + AH_MOCK + TRADING_MOCK)
        lua.execute('namespace={}')
        for name in ('Core.lua', 'Modules/Auctionator.lua', 'Modules/AuctionatorTrading.lua', 'Modules/AuctionatorUI.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / name).read_text(encoding='utf-8'))
        lua.execute('Fire("ADDON_LOADED","ForeverTools"); M=ForeverTools.modules.auctionator; Fire("AUCTION_HOUSE_SHOW")')
        return lua

    def test_pagination_filter_and_sorted_unit_prices(self):
        self.runtime().execute('''
            M:StartSearch('Item1;max=90;minlevel=2;maxlevel=60;quality=1;exact=1')
            assert(query.page==0 and query.lo==2 and query.hi==60 and query.exact and query.quality==1)
            local first={}; for i=1,50 do first[i]=Row(1,200,'Other',2) end
            Deliver(first,52); assert(M.job and M.job.page==1)
            Advance(2); assert(query.page==0)
            Advance(1); assert(query.page==1)
            Deliver({Row(1,50),Row(1,120,'Other',2)},52)
            assert(not M.job and #M.results==2)
            assert(M.results[1].unit==50 and M.results[2].unit==60)
            assert(M:Market().prices['1:0'].unit==50)
        ''')

    def test_buy_refresh_confirmation_and_exact_total(self):
        self.runtime().execute('''
            M:StartSearch('Item1'); Deliver({Row(1,250,'Other',5)})
            local row=M.results[1]; assert(#buyCalls==0)
            M:PrepareBuy(row); Advance(3); assert(M.job and M.job.kind=='buy')
            Deliver({Row(1,250,'Other',5)})
            assert(popup and #buyCalls==0 and popup.text:find('250'))
            Accept(); assert(#buyCalls==1 and buyCalls[1].price==250 and buyCalls[1].kind=='list')
            assert(#M.results==0); M:ConfirmTrade(popup.data); assert(#buyCalls==1)
        ''')

    def test_changed_price_owner_stack_or_row_never_buys(self):
        for change in ('buyout=251', 'owner="New"', 'count=6', 'link="item:2"'):
            with self.subTest(change=change):
                lua=self.runtime()
                lua.execute('''
                    M:StartSearch('Item1'); Deliver({Row(1,250,'Other',5)})
                    M:PrepareBuy(M.results[1]); Advance(3)
                    local changed=Row(1,250,'Other',5)
                ''' + 'changed.' + change + '''
                    Deliver({changed}); assert(not popup and #buyCalls==0)
                ''')

    def test_dialog_invalidated_by_update_close_disable_and_gold(self):
        for event in ('AUCTION_ITEM_LIST_UPDATE','AUCTION_HOUSE_CLOSED','PLAYER_REGEN_DISABLED'):
            with self.subTest(event=event):
                lua=self.runtime()
                lua.execute('''
                    M:StartSearch('Item1'); Deliver({Row(1,250)})
                    M:PrepareBuy(M.results[1]); Advance(3); Deliver({Row(1,250)})
                    local pending=M.pending
                ''' + f"Fire('{event}'); M:ConfirmTrade(pending); assert(#buyCalls==0)")
        self.runtime().execute('''
            M:StartSearch('Item1'); Deliver({Row(1,250)})
            M:PrepareBuy(M.results[1]); Advance(3); Deliver({Row(1,250)})
            money=0; Accept(); assert(#buyCalls==0)
        ''')

    def test_foreign_query_invalidates_work_and_mine_is_blocked(self):
        self.runtime().execute('''
            M:StartSearch('Item1'); QueryAuctionItems('Foreign'); assert(not M.job)
            Advance(3); M:StartSearch('Item1'); Deliver({Row(1,250,'Tester')})
            M:PrepareBuy(M.results[1]); assert(not M.job and not popup)
            assert(M:IsMine({owner='Tester',ownerFull='Tester-Realm'}))
            assert(not M:IsMine({owner='Tester',ownerFull='Tester-OtherRealm'}))
        ''')

    def test_missing_cache_retries_without_duplicate_query_and_timeout(self):
        self.runtime().execute('''
            M:StartSearch('Item1'); local row=Row(1,10); row.owner=nil
            Deliver({row}); local n=queries; Advance(5); assert(M.job and queries==n)
            row.owner='Other'; Advance(1); assert(not M.job and #M.results==1)
            M:StartSearch('Item1'); now=now+31; Advance(1); assert(not M.job)
        ''')

    def test_owned_all_pages_and_live_undercut_excludes_self(self):
        self.runtime().execute('''
            M:StartUndercut(); assert(ownerCalls[1]==0)
            local first={}; for i=1,50 do first[i]=Row(1,100,'Tester') end
            DeliverOwned(first,51); assert(ownerCalls[2]==1)
            DeliverOwned({Row(2,200,'Tester')},51)
            assert(M.job and M.job.kind=='undercut' and #M.owned==51)
            Deliver({Row(1,10,'Tester'),Row(1,99,'Other')})
            Advance(3); Deliver({Row(2,250,'Other')})
            assert(not M.job and M.owned[1].undercut and not M.owned[51].undercut)
            assert(M.owned[1].competitor==99)
        ''')

    def test_cancel_reloads_owner_page_and_rechecks(self):
        self.runtime().execute('''
            M:RequestOwned(1); DeliverOwned({Row(1,100,'Tester')},51)
            M:RequestOwned(M.owned[1].page,M.owned[1]); assert(ownerCalls[2]==1 and not popup)
            DeliverOwned({Row(1,100,'Tester')},51); assert(popup and #cancelCalls==0)
            Accept(); assert(#cancelCalls==1 and cancelCalls[1]==1)
            M:ConfirmTrade(popup.data); assert(#cancelCalls==1)
        ''')
        self.runtime().execute('''
            M:RequestOwned(0); DeliverOwned({Row(1,100,'Tester')})
            M:RequestOwned(0,M.owned[1]); DeliverOwned({Row(2,100,'Tester')})
            assert(not popup and #cancelCalls==0)
        ''')

    def test_multisell_total_deposit_confirmation_and_no_duplicates(self):
        self.runtime().execute('''
            M:PrepareSale('100','20','2',3)
            assert(popup and #postCalls==0 and popup.text:find('2000'))
            Accept(); assert(#postCalls==1)
            local post=postCalls[1]
            assert(post.bid==2000 and post.buyout==2000 and post.size==20 and post.stacks==2 and post.duration==3)
            assert(post.confirmed==false)
            M:PrepareSale(100,20,2,3); assert(#postCalls==1 and M.posting)
            Fire('AUCTION_MULTISELL_UPDATE',2,2); assert(not M.posting)
            assert(M.settings.activity[1].kind=='Einstellen bestätigt')
        ''')

    def test_invalid_or_changed_sales_do_not_post(self):
        for args in ('0,20,2,3','100,21,1,3','100,20,3,3','100,20,2,4','1.5,20,2,3'):
            with self.subTest(args=args):
                self.runtime().execute('M:PrepareSale('+args+'); assert(not popup and #postCalls==0)')
        for mutation in ("sale.itemID=2", "sale.guid='other'", "sale.total=1", "deposit=30", "money=0"):
            with self.subTest(mutation=mutation):
                self.runtime().execute('M:PrepareSale(100,20,2,3); '+mutation+'; Accept(); assert(#postCalls==0)')

    def test_low_price_warning_and_multi_failure(self):
        self.runtime().execute('''
            M:Market().prices['1:0']={name='Item1',unit=1000,stamp=time()}
            M:PrepareSale(100,20,2,3); assert(popup.text:find('50%%'))
            Accept(); Fire('AUCTION_MULTISELL_FAILURE'); assert(not M.posting)
        ''')

    def test_lists_migration_named_import_atomic_validation_and_filters(self):
        self.runtime().execute('''
            M:AddToList('Item1;max=100;exact=1'); assert(#M.settings.shopping==1)
            local old=M.settings.shopping
            M:SelectList('Beruf'); assert(#M.settings.shopping==0)
            M:ImportList('Item2\\nItem3;quality=2'); assert(#M.settings.shopping==2)
            M:ImportList('Item4\\nItem5;unknown=1'); assert(#M.settings.shopping==2)
            M:SelectList('Standard'); assert(M.settings.shopping==old)
            M:SearchShopping(); assert(query.exact and query.name=='Item1')
            assert(not M:ParseTerm('Item;minlevel=50;maxlevel=1'))
            assert(not M:ParseTerm('Item;max=0'))
            assert(not M:ParseTerm('|Hitem:1|h'))
        ''')

    def test_price_history_daily_limit(self):
        self.runtime().execute('''
            local market=M:Market()
            M:SavePriceHistory(market,{['1:0']={unit=10}})
            M:SavePriceHistory(market,{['1:0']={unit=20}})
            assert(#market.history['1:0']==1 and market.history['1:0'][1].unit==20)
            for i=1,40 do now=now+86400; M:SavePriceHistory(market,{['1:0']={unit=i}}) end
            assert(#market.history['1:0']==30)
        ''')

    def test_crafting_cost_profit_and_missing_prices(self):
        self.runtime().execute('''
            function GetTradeSkillSelectionIndex() return 1 end
            function GetTradeSkillNumReagents() return 1 end
            function GetTradeSkillReagentInfo() return 'Item1',nil,3 end
            function GetTradeSkillReagentItemLink() return 'item:1' end
            function GetTradeSkillNumMade() return 2 end
            function GetTradeSkillItemLink() return 'item:2' end
            M:Market().prices['1:0']={name='Item1',unit=100,stamp=time()}
            M:Market().prices['2:0']={name='Item2',unit=500,stamp=time()}
            M:CraftingCost(true)
            assert(M.status:find('300') and M.status:find('325') and #M.settings.shopping==1)
            M:Market().prices['1:0']=nil; M:CraftingCost(false); assert(M.status:find('Fehlende Scanpreise'))
        ''')

    def test_real_views_buttons_list_export_and_disable(self):
        self.runtime().execute('''
            M:Open(); local p=M.panel
            assert(p:IsShown() and #p.rows==6 and #p.buy.rows==8 and #p.own.rows==8)
            M:AddToList('Item1'); assert(p.rows[1].search.text=='Item1')
            for _,tab in ipairs({'buy','sell','own','lists','history'}) do
                M:ShowTradingTab(tab); assert(p.panes[tab]:IsShown())
            end
            M:RefreshSale(); assert(p.sell.size.text==20 and p.sell.stacks.text=='1')
            M:StartSearch('Item1'); ForeverTools:SetEnabled('auctionator',false)
            assert(not p:IsShown() and not M.job)
        ''')

    def test_partial_reply_foreign_owner_query_and_sold_deliveries(self):
        self.runtime().execute('''
            M:StartSearch('Item1'); Deliver({},50); assert(M.job and not M.results[1])
            M:Cancel(); M:RequestOwned(0)
            local row=Row(1,100,'Tester'); row.complete=false
            DeliverOwned({row}); assert(M.ownerRequest)
            row.complete=true; Advance(1); assert(not M.ownerRequest and #M.owned==1)
            M:RequestOwned(0); GetOwnerAuctionItems(1); assert(not M.ownerRequest)
            M:RequestOwned(0); local sold=Row(1,100,'Tester'); sold.count=0; sold.saleStatus=1
            DeliverOwned({sold}); assert(#M.owned==0)
        ''')

    def test_bid_only_auction_is_not_marked_undercut(self):
        self.runtime().execute('''
            M:StartUndercut(); DeliverOwned({Row(1,0,'Tester')})
            Deliver({Row(1,10,'Other')}); assert(not M.owned[1].undercut)
        ''')

    def test_live_sale_compare_and_old_price_history(self):
        self.runtime().execute('''
            M:Open(); M:Market().prices['1:0']={name='Item1',unit=1000,stamp=time()}
            M.settings.undercut=5; M:CompareSale()
            Deliver({Row(1,200,'Tester'),Row(1,500,'Other')})
            assert(M.panel.sell.unit.text==495 and M.sellPrices['1:0'].unit==500)
            M:ShowPriceHistory('Item1'); assert(M.panel.history.prices.text:find('500'))
        ''')

    def test_enchanting_material_costs(self):
        self.runtime().execute('''
            CraftFrame=CreateFrame()
            function GetCraftSelectionIndex() return 1 end
            function GetCraftNumReagents() return 1 end
            function GetCraftReagentInfo() return 'Item1',nil,2 end
            function GetCraftReagentItemLink() return 'item:1' end
            M:Market().prices['1:0']={name='Item1',unit=20,stamp=time()}
            M:CraftingCost(true); assert(M.status:find('40') and #M.settings.shopping==1)
        ''')

    def test_timed_out_dialog_and_insufficient_deposit(self):
        self.runtime().execute('''
            M:PrepareSale(100,20,2,3); now=now+31; Accept(); assert(#postCalls==0)
            money=0; popup=nil; M:PrepareSale(100,20,2,3); assert(not popup)
        ''')


if __name__ == '__main__':
    unittest.main()
