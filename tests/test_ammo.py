"""Hunter restocking based on Guschi/AutoAmmo.lua, with asynchronous purchases."""
import unittest
import test_forevertools as base


AMMO_MOCK = r'''
playerClass = 'HUNTER'
weaponType = 2
playerLevel = 20
shift = false
buyCalls = {}
offers = {101, 102, 103, 104}
ammoItems = {
    [101] = {level=1, sub=2, family=1, price=10, quantity=200, available=-1},
    [102] = {level=10, sub=2, family=1, price=20, quantity=200, available=-1},
    [103] = {level=30, sub=2, family=1, price=30, quantity=200, available=-1},
    [104] = {level=10, sub=3, family=2, price=20, quantity=200, available=-1},
}
sizes[1] = 3; families[1] = 1
function UnitClass() return '', playerClass end
function UnitLevel() return playerLevel end
function IsShiftKeyDown() return shift end
function GetInventoryItemID() return weaponType and 900 end
function GetMerchantNumItems() return #offers end
function GetMerchantItemLink(i) return offers[i] and 'item:' .. offers[i] end
local originalInfo = C_Item.GetItemInfo
function C_Item.GetItemInfo(id)
    local item = ammoItems[id]
    if not item then return originalInfo(id) end
    if item.uncached then return end
    return 'Ammo' .. id, 'item:' .. id, 1, 1, item.level, '', '', 200
end
function C_Item.GetItemInfoInstant(id)
    id = tonumber(id) or tonumber(id:match('item:(%d+)'))
    if id == 900 then return id, '', '', '', '', 2, weaponType end
    local item = ammoItems[id]
    if item then return id, '', '', '', '', 6, item.sub end
end
function C_Item.GetItemFamily(id) return ammoItems[id].family end
function GetMerchantItemInfo(i)
    local id = offers[i]
    local item = ammoItems[id]
    return 'Ammo' .. id, nil, item.price, item.quantity, item.available,
        item.purchasable ~= false, true, item.extended
end
function GetMerchantItemMaxStack() return 200 end
function C_Container.GetContainerNumFreeSlots(bag)
    local count = 0
    for slot=1,sizes[bag] do
        if not inventory[bag][slot] then count = count + 1 end
    end
    return count, families[bag]
end
function ConfirmAmmo()
    local order = queuedAmmo
    queuedAmmo = nil
    local item = ammoItems[order.id]
    money = money - order.quantity / item.quantity * item.price
    if item.available >= 0 then item.available = item.available - order.quantity end
    local left = order.quantity
    for bag=1,4 do
        if families[bag] == item.family then
            for slot=1,sizes[bag] do
                local current = inventory[bag][slot]
                if current and current.itemID == order.id and not current.isLocked then
                    local add = math.min(left, 200-current.stackCount)
                    current.stackCount = current.stackCount + add
                    left = left-add
                end
            end
            for slot=1,sizes[bag] do
                if left > 0 and not inventory[bag][slot] then
                    local add = math.min(left,200)
                    Put(bag,slot,order.id,1,add)
                    left=left-add
                end
            end
        end
    end
    assert(left == 0, 'must never exceed quiver space')
end
function BuyMerchantItem(index, quantity)
    assert(ForeverTools.modules.merchant.merchantOpen and not combat)
    assert(not queuedAmmo, 'wait for previous purchase')
    assert(quantity <= 200 and quantity % ammoItems[offers[index]].quantity == 0)
    buyCalls[#buyCalls+1] = {id=offers[index], quantity=quantity}
    if rejectAmmo then return end
    queuedAmmo = {id=offers[index], quantity=quantity}
    if not deferAmmo then ConfirmAmmo() end
end
local sort = C_Container.SortBags
function C_Container.SortBags()
    assert(not queuedAmmo, 'purchase must settle before cleanup')
    sort()
end
'''


class AmmoTest(unittest.TestCase):
    run_lua = base.ForeverToolsTest.run_lua

    def setUp(self):
        base.ForeverToolsTest.setUp(self)
        self.lua.execute(AMMO_MOCK)

    def test_best_usable_arrows_fill_quiver_in_item_sized_calls(self):
        self.run_lua('''
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(#buyCalls == 3 and money == 9840)
            for _, order in ipairs(buyCalls) do assert(order.id == 102 and order.quantity == 200) end
            assert(sortCalls == 1 and not ForeverTools.modules.merchant.run)
        ''')

    def test_crossbow_uses_arrows_and_gun_uses_bullets(self):
        for weapon, family, expected in ((18, 1, 102), (3, 2, 104)):
            with self.subTest(weapon=weapon):
                self.setUp()
                self.run_lua(f'''
                    weaponType={weapon}; families[1]={family}
                    Fire('MERCHANT_SHOW'); Advance(100)
                    assert(#buyCalls == 3 and buyCalls[1].id == {expected})
                ''')

    def test_partial_stack_and_other_ammo_are_respected(self):
        self.run_lua('''
            ammoItems[102].quantity=1
            Put(1,1,101,1,50); Put(1,2,102,1,150)
            Fire('MERCHANT_SHOW'); Advance(100)
            local total=0; for _, order in ipairs(buyCalls) do total=total+order.quantity end
            assert(total == 250 and inventory[1][1].stackCount == 50)
            assert(inventory[1][2].stackCount == 200 and inventory[1][3].stackCount == 200)
        ''')

    def test_missing_or_wrong_quiver_and_non_hunters_do_not_buy(self):
        for setup in ("families[1]=0", "families[1]=2", "playerClass='MAGE'", "weaponType=16", "weaponType=nil"):
            with self.subTest(setup=setup):
                self.setUp()
                self.run_lua(setup + "; Fire('MERCHANT_SHOW'); Advance(100); assert(#buyCalls == 0 and sortCalls == 1)")

    def test_full_or_locked_quiver_does_not_buy(self):
        self.run_lua('''
            for slot=1,3 do Put(1,slot,102,1,150,true) end
            Fire('MERCHANT_SHOW'); Advance(200)
            assert(#buyCalls == 0 and not ForeverTools.modules.merchant.run)
        ''')

    def test_shift_at_open_is_remembered_and_switch_is_persistent(self):
        self.run_lua('''
            shift=true; Fire('MERCHANT_SHOW'); shift=false; Advance(100)
            assert(#buyCalls == 0)
            local m=ForeverTools.modules.merchant
            m.settings.ammo=false
            Fire('MERCHANT_SHOW'); Advance(100); assert(#buyCalls == 0)
            assert(ForeverToolsDB.modules.merchant.ammo == false)
        ''')

    def test_stock_and_money_limit_purchase_after_repair(self):
        self.run_lua('''
            ammoItems[102].available=400; money=120
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(#buyCalls == 1 and money == 0)
        ''')
        self.setUp()
        self.run_lua('''
            ammoItems[102].available=200
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(#buyCalls == 1)
        ''')

    def test_rejected_purchase_stops_without_retry(self):
        self.run_lua('''
            rejectAmmo=true; Fire('MERCHANT_SHOW'); Advance(100)
            assert(#buyCalls == 1 and sortCalls == 1 and not ForeverTools.modules.merchant.run)
        ''')

    def test_delayed_purchase_settles_before_sort_when_vendor_closes(self):
        self.run_lua('''
            deferAmmo=true; Fire('MERCHANT_SHOW'); Advance(8)
            assert(#buyCalls == 1 and queuedAmmo and sortCalls == 0)
            Fire('MERCHANT_CLOSED'); ConfirmAmmo(); Advance(100)
            assert(#buyCalls == 1 and sortCalls == 1)
        ''')

    def test_uncached_items_wait_then_resume_or_stop(self):
        self.run_lua('''
            ammoItems[102].uncached=true
            Fire('MERCHANT_SHOW'); Advance(8); assert(#buyCalls == 0)
            ammoItems[102].uncached=false; Advance(100)
            assert(#buyCalls == 3 and buyCalls[1].id == 102)
        ''')
        self.setUp()
        self.run_lua('''
            ammoItems[102].uncached=true; Fire('MERCHANT_SHOW'); Advance(100)
            assert(#buyCalls == 0 and sortCalls == 1 and not ForeverTools.modules.merchant.run)
        ''')

    def test_table_merchant_api_and_extended_cost(self):
        self.run_lua('''
            local legacy=GetMerchantItemInfo
            C_MerchantFrame={GetItemInfo=function(i)
                local name, texture, price, qty, avail, purchasable, usable, extended=legacy(i)
                return {name=name, texture=texture, price=price, stackCount=qty,
                    numAvailable=avail, isPurchasable=purchasable, isUsable=usable, hasExtendedCost=extended}
            end}
            GetMerchantItemInfo=nil; ammoItems[102].extended=true
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(#buyCalls == 3 and buyCalls[1].id == 101)
        ''')

    def test_combat_and_disabling_option_wait_for_pending_purchase(self):
        self.run_lua('''
            deferAmmo=true; Fire('MERCHANT_SHOW'); Advance(8)
            assert(queuedAmmo)
            combat=true; Advance(100); assert(#buyCalls == 1 and sortCalls == 0)
            ConfirmAmmo(); ForeverTools.modules.merchant.settings.ammo=false
            combat=false; Advance(100)
            assert(#buyCalls == 1 and sortCalls == 1)
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
