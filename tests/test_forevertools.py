"""Behavior tests using Lua 5.1 (WoW-compatible syntax) with mocked game APIs.
Run: python tests/test_forevertools.py
Test-only dependency: pip install --target .tools lupa
"""
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".tools"))
from lupa.lua51 import LuaRuntime

MOCK = r'''
now = 0
money = 10000
repairCost = 100
canRepair = true
combat = false
rejectSales = false
sortCalls = 0
rejectSort = false
deferSales = false
frames = {}
messages = {}
inventory = {[0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}}
sizes = {[0] = 8, [1] = 4, [2] = 0, [3] = 0, [4] = 0, [5] = 4}
families = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 32}
NUM_TOTAL_EQUIPPED_BAG_SLOTS = 5
UISpecialFrames = {}
SlashCmdList = {}
UIParent = {}
DEFAULT_CHAT_FRAME = {AddMessage = function(_, s) messages[#messages+1] = s end}
function CreateFrame(_, name)
    local f = {events = {}, scripts = {}, shown = true}
    function f:RegisterEvent(e) self.events[e] = true end
    function f:UnregisterEvent(e) self.events[e] = nil end
    function f:SetScript(e, callback) self.scripts[e] = callback end
    function f:SetSize() end
    function f:SetFrameStrata() end
    function f:SetNormalTexture() end
    function f:SetHighlightTexture() end
    function f:SetHeight() end
    function f:SetWidth() end
    function f:SetPoint() end
    function f:SetClampedToScreen() end
    function f:SetMovable() end
    function f:EnableMouse() end
    function f:RegisterForDrag() end
    function f:StartMoving() end
    function f:StopMovingOrSizing() end
    function f:SetJustifyH() end
    function f:SetText(t) self.text = t end
    function f:SetScrollChild(c) self.child = c end
    function f:SetChecked(c) self.checked = c end
    function f:GetChecked() return self.checked end
    function f:SetEnabled(c) self.enabled = c end
    function f:IsShown() return self.shown end
    function f:SetShown(c)
        self.shown = c
        if c and self.scripts.OnShow then self.scripts.OnShow(self) end
    end
    function f:CreateFontString() return CreateFrame() end
    f.TitleText = {SetText = function() end}
    f.Text = {SetText = function() end, SetWidth = function() end, SetJustifyH = function() end}
    if name then _G[name] = f end
    frames[#frames+1] = f
    return f
end
function Fire(event, ...)
    for _, frame in ipairs(frames) do
        if frame.events[event] then frame.scripts.OnEvent(frame, event, ...) end
    end
end
function Advance(ticks)
    for i = 1, ticks do
        now = now + 0.21
        for _, frame in ipairs(frames) do
            if frame.scripts.OnUpdate then frame.scripts.OnUpdate(frame, 0.21) end
        end
    end
end
function Put(bag, slot, id, quality, count, locked, family, price)
    inventory[bag][slot] = {itemID = id, hyperlink = 'item:' .. id, quality = quality,
        stackCount = count or 1, isLocked = locked, family = family or 0, price = price or 20}
end
function GetTime() return now end
function GetMoney() return money end
function GetMoneyString(n) return tostring(n) end
function CanMerchantRepair() return canRepair end
function GetRepairAllCost() return repairCost, repairCost > 0 end
function RepairAllItems(guild)
    assert(not guild)
    assert(money >= repairCost)
    money = money - repairCost
    repairCost = 0
end
function InCombatLockdown() return combat end
function CursorHasItem() return cursor ~= nil end
function ClearCursor()
    if origin then inventory[origin.bag][origin.slot] = cursor end
    cursor = nil
    origin = nil
end
bit = {band = function(a,b) if a == b then return a else return 0 end end}
C_Item = {}
function Find(link)
    for _, bag in pairs(inventory) do
        for _, item in pairs(bag) do if item.hyperlink == link then return item end end
    end
end
function C_Item.GetItemFamily(link) return Find(link).family end
function C_Item.GetItemInfo(link)
    local item = Find(link)
    return '', link, item.quality, nil, nil, nil, nil, nil, nil, nil, item.price
end
C_Container = {}
function C_Container.GetContainerNumSlots(bag) return sizes[bag] end
function C_Container.GetContainerNumFreeSlots(bag) return 0, families[bag] end
function C_Container.GetContainerItemInfo(bag, slot) return inventory[bag][slot] end
function C_Container.UseContainerItem(bag, slot)
    assert(ForeverTools.modules.merchant.merchantOpen)
    assert(not combat)
    local item = inventory[bag][slot]
    assert(item.quality == 0)
    if rejectSales then return end
    if deferSales then queuedSale = {bag=bag,slot=slot}; return end
    money = money + item.price * item.stackCount
    inventory[bag][slot] = nil
end
function ConfirmSale()
    local item = inventory[queuedSale.bag][queuedSale.slot]
    money = money + item.price * item.stackCount
    inventory[queuedSale.bag][queuedSale.slot] = nil
    queuedSale = nil
end
function C_Container.SortBags()
    assert(not combat)
    assert(not CursorHasItem())
    assert(not queuedSale, 'sale must settle before native cleanup')
    if rejectSort then error('cleanup blocked') end
    sortCalls = sortCalls + 1
end
function C_Container.PickupContainerItem()
    error('addon must not move items individually')
end
'''


class ForeverToolsTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK)
        self.lua.execute('namespace = {}')
        for filename in ('Core.lua', 'Updates.lua', 'Modules/Merchant.lua', 'Modules/Quests.lua', 'Menu.lua'):
            code = (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8')
            self.lua.execute('assert(loadstring(...))("ForeverTools", namespace)', code)
        self.lua.execute('Fire("ADDON_LOADED", "ForeverTools")')

    def run_lua(self, code):
        self.lua.execute(code)

    def test_update_request_is_saved_before_reload_and_increases(self):
        self.run_lua('''
            function time() return 100 end
            function ReloadUI()
                assert(ForeverToolsDB.updateRequest >= 100)
                reloads = (reloads or 0) + 1
            end
            ForeverTools:RequestUpdate()
            assert(ForeverToolsDB.updateRequest == 100 and reloads == 1)
            ForeverTools:RequestUpdate()
            assert(ForeverToolsDB.updateRequest == 101 and reloads == 2)
        ''')

    def test_update_request_is_blocked_in_combat(self):
        self.run_lua('''
            combat = true
            function ReloadUI() error('must not reload in combat') end
            ForeverTools:RequestUpdate()
            assert(ForeverToolsDB.updateRequest == nil)
        ''')

    def test_repair_sell_and_native_cleanup(self):
        self.run_lua('''
            Put(0,3,10,0,5); Put(0,6,20,2); Put(1,4,30,1)
            Put(5,4,40,1,1,false,32)
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(repairCost == 0 and money == 10000)
            assert(sortCalls == 1)
            assert(inventory[0][6].itemID == 20)
            assert(inventory[1][4].itemID == 30)
            assert(inventory[5][4].itemID == 40)
            assert(not ForeverTools.modules.merchant.run)
            assert(not CursorHasItem())
        ''')

    def test_insufficient_money_repair_after_sales(self):
        self.run_lua('''
            money = 0; Put(0,1,10,0,10)
            Fire('MERCHANT_SHOW'); Advance(80)
            assert(repairCost == 0 and money == 100)
        ''')

    def test_no_repair_vendor_still_sells(self):
        self.run_lua('''
            canRepair = false; Put(0,1,10,0)
            Fire('MERCHANT_SHOW'); Advance(80)
            assert(repairCost == 100 and money == 10020)
        ''')

    def test_locked_items_wait_then_resume(self):
        self.run_lua('''
            Put(0,4,10,0,1,true); Fire('MERCHANT_SHOW'); Advance(8)
            assert(inventory[0][4]); inventory[0][4].isLocked = false
            Advance(80); assert(not inventory[0][4])
        ''')

    def test_disabled_module_does_nothing_and_menu_works(self):
        self.run_lua('''
            ForeverTools:SetEnabled('merchant',false)
            Put(0,3,10,0); Fire('MERCHANT_SHOW'); Advance(80)
            assert(inventory[0][3] and repairCost == 100 and sortCalls == 0)
            SlashCmdList.FOREVERTOOLS()
            assert(ForeverTools.menu:IsShown())
            assert(#ForeverTools.menu.checks == 5)
            assert(not ForeverTools.menu.checks[2].box.enabled)
            SlashCmdList.FOREVERTOOLS(); assert(not ForeverTools.menu:IsShown())
        ''')

    def test_separate_feature_switches(self):
        self.run_lua('''
            local s = ForeverTools.modules.merchant.settings
            s.repair = false; s.sell = false; s.sort = false
            Put(0,4,10,0); Fire('MERCHANT_SHOW'); Advance(80)
            assert(inventory[0][4] and repairCost == 100 and money == 10000 and sortCalls == 0)
        ''')

    def test_combat_pauses_every_action(self):
        self.run_lua('''
            combat = true; Put(0,3,10,0)
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(inventory[0][3] and repairCost == 100 and sortCalls == 0)
            combat = false; Advance(80)
            assert(repairCost == 0 and not inventory[0][3])
        ''')

    def test_closed_vendor_never_uses_items(self):
        self.run_lua('''
            Put(0,4,10,0); Fire('MERCHANT_SHOW'); Fire('MERCHANT_CLOSED')
            Advance(80); assert(inventory[0][4].itemID == 10 and sortCalls == 1)
            assert(repairCost == 100)
        ''')

    def test_existing_cursor_is_untouched(self):
        self.run_lua('''
            cursor = {itemID=99}; Put(0,4,10,2)
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(cursor.itemID == 99 and inventory[0][4].itemID == 10 and sortCalls == 0)
            assert(not ForeverTools.modules.merchant.run)
        ''')

    def test_rejected_sales_terminate_without_loop(self):
        self.run_lua('''
            rejectSales = true; Put(0,4,10,0)
            Fire('MERCHANT_SHOW'); Advance(100)
            assert(inventory[0][4].itemID == 10 and sortCalls == 1)
            assert(not ForeverTools.modules.merchant.run)
        ''')

    def test_pending_sale_settles_before_sort_after_disabling_sales(self):
        self.run_lua('''
            deferSales = true; Put(0,3,10,0); Put(0,7,20,2)
            Fire('MERCHANT_SHOW'); Advance(2)
            local m = ForeverTools.modules.merchant
            assert(queuedSale)
            m.settings.sell = false; m:OnSettingsChanged(); Advance(3)
            assert(inventory[0][7] and sortCalls == 0)
            ConfirmSale(); Advance(80)
            assert(inventory[0][7].itemID == 20 and sortCalls == 1)
        ''')

    def test_native_cleanup_owns_special_bag_handling(self):
        self.run_lua('''
            sizes[0] = 0; sizes[1] = 0; sizes[4] = 2; families[4] = 32
            Put(5,3,10,2,1,false,0); Put(5,4,20,2,1,false,32)
            Fire('MERCHANT_SHOW'); Advance(80)
            assert(sortCalls == 1)
            assert(inventory[5][4].itemID == 20 and inventory[5][3].itemID == 10)
        ''')

    def test_disabling_module_cancels_current_run(self):
        self.run_lua('''
            Put(0,3,10,0); Fire('MERCHANT_SHOW'); Advance(1)
            ForeverTools:SetEnabled('merchant',false); Advance(100)
            assert(inventory[0][3] and not ForeverTools.modules.merchant.run)
        ''')

    def test_no_gold_and_permanently_locked_items_terminate(self):
        self.run_lua('''
            money=0; Put(0,4,10,0,1,true)
            Fire('MERCHANT_SHOW'); Advance(220)
            assert(repairCost == 100 and inventory[0][4])
            assert(not ForeverTools.modules.merchant.run)
        ''')

    def test_saved_switches_survive_initialization(self):
        self.run_lua('''
            ForeverToolsDB.modules.merchant.enabled=false
            ForeverToolsDB.modules.merchant.sell=false
            ForeverTools:Initialize()
            assert(not ForeverTools:IsEnabled('merchant'))
            assert(not ForeverTools.modules.merchant.settings.sell)
        ''')

    def test_cursor_does_not_cause_endless_sales_wait(self):
        self.run_lua('''
            cursor = {itemID=99}; Put(0,4,10,0)
            Fire('MERCHANT_SHOW'); Advance(220)
            assert(cursor.itemID == 99 and inventory[0][4].itemID == 10)
            assert(not ForeverTools.modules.merchant.run)
        ''')

    def test_native_cleanup_error_ends_run_without_moving_items(self):
        self.run_lua('''
            rejectSort = true; Put(0,4,10,2)
            Fire('MERCHANT_SHOW'); Advance(80)
            assert(inventory[0][4].itemID == 10 and not CursorHasItem())
            assert(not ForeverTools.modules.merchant.run)
        ''')

    def test_unsellable_gray_and_white_items_are_kept(self):
        self.run_lua('''
            Put(0,1,10,0); inventory[0][1].hasNoValue = true
            Put(0,2,20,1)
            Fire('MERCHANT_SHOW'); Advance(80)
            assert(inventory[0][1].itemID == 10 and inventory[0][2].itemID == 20)
            assert(money == 9900)
        ''')

    def test_minimap_launcher_opens_menu(self):
        self.run_lua('''
            Minimap = {}; ForeverTools:CreateLauncher()
            assert(ForeverTools.launcher)
            ForeverTools.launcher.scripts.OnClick()
            assert(ForeverTools.menu:IsShown())
        ''')

    def test_large_inventory_starts_cleanup_without_per_item_delays(self):
        self.run_lua('''
            sizes[0] = 200
            for i=50,200 do Put(0,i,i,2) end
            Fire('MERCHANT_SHOW'); Advance(8)
            assert(sortCalls == 1 and not ForeverTools.modules.merchant.run)
            Advance(100); assert(sortCalls == 1)
        ''')

    def test_cleanup_waits_for_locked_items(self):
        self.run_lua('''
            Put(0,4,10,2,1,true)
            Fire('MERCHANT_SHOW'); Advance(10); assert(sortCalls == 0)
            inventory[0][4].isLocked = false
            Advance(1); assert(sortCalls == 1)
        ''')

    def test_missing_native_cleanup_does_not_disable_sales_or_repair(self):
        self.run_lua('''
            C_Container.SortBags = nil; Put(0,4,10,0)
            Fire('MERCHANT_SHOW'); Advance(80)
            assert(not inventory[0][4] and repairCost == 0)
            assert(not ForeverTools.modules.merchant.run and sortCalls == 0)
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
