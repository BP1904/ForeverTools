local _, FT = ...
local M = {
    title = "Händler & Taschen",
    description = "Reparieren, Graues verkaufen, Jägermunition auffüllen und Taschen aufräumen. Umschalt beim Öffnen: kein Munitionskauf.",
    defaults = {repair = true, sell = true, sort = true, ammo = true},
    options = {
        {key = "repair", title = "Alle mitgeführten Gegenstände reparieren"},
        {key = "sell", title = "Graue Gegenstände automatisch verkaufen"},
        {key = "ammo", title = "Jäger: Köcher / Munitionsbeutel auffüllen"},
        {key = "sort", title = "Danach WoWs „Taschen aufräumen“ starten"},
    },
}
FT:RegisterModule("merchant", M)
local C = C_Container
local INTERVAL = 0.20
local TIMEOUT = 15

local function Bags()
    local result = {}
    -- Only carried bags; never bank, account bank or equipped inventory slots.
    local last = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4
    for bag = 0, last do
        for slot = 1, C.GetContainerNumSlots(bag) do
            result[#result + 1] = {bag = bag, slot = slot}
        end
    end
    return result
end

local function Info(position)
    return C.GetContainerItemInfo(position.bag, position.slot)
end

local function Key(position)
    return position.bag .. ":" .. position.slot
end

function M:OnSettingsChanged()
    if not FT:IsEnabled("merchant") then
        self.run = nil
    elseif self.run and self.run.phase == "sell" and not self.settings.sell then
        -- Wait for an already-issued sale before starting any bag moves.
        self.run.stopSelling = true
    end
end

function M:Repair(finalAttempt)
    if not self.settings.repair or not self.merchantOpen or not CanMerchantRepair() then return end
    local cost, needed = GetRepairAllCost()
    if not needed or not cost or cost <= 0 then return end
    if GetMoney() < cost then
        if finalAttempt then FT:Print("Nicht genug Gold für alle Reparaturen.") end
        return
    end
    RepairAllItems(false)
    -- Check the actual result on a later tick instead of announcing an API call as success.
    self.run.repairRequested = true
end

function M:Start()
    if not FT:IsEnabled("merchant") or self.run then return end
    self.run = {phase = "repair", started = GetTime(), skipped = {}, sold = 0,
        revenue = 0, lastChange = GetTime(), skipAmmo = IsShiftKeyDown and IsShiftKeyDown()}
end

function M:BeginSort()
    local run = self.run
    if not run then return end
    run.phase = "sort"
    run.pending = nil
    run.lastChange = GetTime()
end

function M:Finish(reason)
    local run = self.run
    if not run then return end
    if run.sold > 0 then
        FT:Print(run.sold .. " graue Gegenstände verkauft (" .. GetMoneyString(run.revenue) .. ").")
    end
    if run.ammoBought and run.ammoBought > 0 then
        FT:Print(run.ammoBought .. " × " .. run.ammoName .. " nachgekauft.")
    end
    if run.repairRequested then
        local remaining = GetRepairAllCost()
        if remaining == 0 then
            FT:Print("Alle reparierbaren, mitgeführten Gegenstände repariert.")
        else
            FT:Print("Reparatur konnte nicht vollständig bestätigt werden.")
        end
    end
    if reason then FT:Print(reason) end
    self.run = nil
end

-- Adapted from Guschi/AutoAmmo.lua: bow/crossbow -> arrows, gun -> bullets.
local WEAPON_TO_AMMO = {[2] = 2, [18] = 2, [3] = 3}

local function AmmoCount(id)
    local count = 0
    for _, position in ipairs(Bags()) do
        local item = Info(position)
        if item and item.itemID == id then count = count + item.stackCount end
    end
    return count
end

local function MerchantInfo(index)
    if GetMerchantItemInfo then return GetMerchantItemInfo(index) end
    local info = C_MerchantFrame and C_MerchantFrame.GetItemInfo and C_MerchantFrame.GetItemInfo(index)
    if info then
        return info.name, info.texture, info.price, info.stackCount, info.numAvailable,
            info.isPurchasable, info.isUsable, info.hasExtendedCost
    end
end

local function AmmoRoom(id, stack, family)
    local room = 0
    -- Only dedicated, equipped quivers/ammo pouches; normal bags never add capacity.
    for bag = 1, NUM_BAG_SLOTS or 4 do
        local free, bagFamily = C.GetContainerNumFreeSlots(bag)
        if free and bagFamily and bagFamily > 0 and bit.band(bagFamily, family) > 0 then
            room = room + free * stack
            for slot = 1, C.GetContainerNumSlots(bag) do
                local item = C.GetContainerItemInfo(bag, slot)
                if item and item.itemID == id and not item.isLocked then
                    room = room + math.max(0, stack - item.stackCount)
                end
            end
        end
    end
    return room
end

function M:AmmoTick()
    local run = self.run
    -- Settle an issued purchase before sorting, even if the option was disabled.
    if run.ammoPending then
        local pending = run.ammoPending
        local gained = AmmoCount(run.ammoID) - pending.before
        if gained >= pending.quantity then
            run.ammoBought = (run.ammoBought or 0) + gained
            run.ammoLeft = math.max(0, run.ammoLeft - gained)
            run.ammoPending = nil
        elseif GetTime() - pending.time >= 2 then
            run.ammoBought = (run.ammoBought or 0) + math.max(0, gained)
            FT:Print("Munitionskauf nicht vollständig bestätigt; Auffüllen beendet.")
            self:BeginSort()
            return
        else
            return
        end
    end
    if not self.merchantOpen or not self.settings.ammo or run.skipAmmo
        or (IsShiftKeyDown and IsShiftKeyDown()) then self:BeginSort(); return end
    if not UnitClass or select(2, UnitClass("player")) ~= "HUNTER"
        or not C_Item.GetItemInfoInstant or not C_Item.GetItemFamily
        or not C.GetContainerNumFreeSlots or not bit or not bit.band
        or not GetInventoryItemID or not GetMerchantNumItems or not GetMerchantItemLink
        or not BuyMerchantItem or not UnitLevel then self:BeginSort(); return end
    if not run.ammoID then
        local weapon = GetInventoryItemID("player", 18)
        if not weapon then self:BeginSort(); return end
        local _, _, _, _, _, class, subclass = C_Item.GetItemInfoInstant(weapon)
        local want = class == 2 and WEAPON_TO_AMMO[subclass]
        if not want then self:BeginSort(); return end
        local best, bestLevel, bestID, bestStack, waiting
        for index = 1, GetMerchantNumItems() do
            local link = GetMerchantItemLink(index)
            if link then
                local id, _, _, _, _, itemClass, itemSubclass = C_Item.GetItemInfoInstant(link)
                if not id or not itemClass then
                    waiting = true
                elseif itemClass == 6 and itemSubclass == want then
                    local name, _, _, _, level, _, _, stack = C_Item.GetItemInfo(id)
                    local _, _, _, _, available, purchasable, usable, extended = MerchantInfo(index)
                    if not name or not level or not stack then
                        waiting = true
                    elseif level <= UnitLevel("player") and purchasable ~= false and usable ~= false
                        and not extended and available ~= 0 and (not bestLevel or level > bestLevel) then
                        best, bestLevel, bestID, bestStack = index, level, id, stack
                    end
                end
            else
                waiting = true
            end
        end
        -- Missing data must not cause a purchase of weaker/unknown ammunition.
        if waiting then
            if GetTime() - run.ammoStarted >= 2 then self:BeginSort() end
            return
        end
        if not best then self:BeginSort(); return end
        local family = C_Item.GetItemFamily(bestID)
        if not family or family == 0 then self:BeginSort(); return end
        run.ammoID, run.ammoIndex, run.ammoStack = bestID, best, bestStack
        run.ammoFamily = family
        run.ammoLeft = AmmoRoom(bestID, bestStack, family)
    end
    if CursorHasItem() then
        if GetTime() - run.ammoStarted >= TIMEOUT then self:BeginSort() end
        return
    end
    local index = run.ammoIndex
    local link = GetMerchantItemLink(index)
    if not link or C_Item.GetItemInfoInstant(link) ~= run.ammoID then self:BeginSort(); return end
    local name, _, price, quantity, available, purchasable, usable, extended = MerchantInfo(index)
    if not price or price < 0 or not quantity or quantity < 1 or purchasable == false
        or usable == false or extended then self:BeginSort(); return end
    local maxStack = GetMerchantItemMaxStack or (C_MerchantFrame and C_MerchantFrame.GetItemMaxStack)
    local limit = maxStack and maxStack(index) or run.ammoStack
    local count = math.min(run.ammoLeft, limit or run.ammoStack, run.ammoStack,
        AmmoRoom(run.ammoID, run.ammoStack, run.ammoFamily))
    if available and available >= 0 then count = math.min(count, available) end
    if price > 0 then count = math.min(count, math.floor(GetMoney() / price) * quantity) end
    count = math.floor(count / quantity) * quantity
    if count < quantity then self:BeginSort(); return end
    run.ammoName = name or "Munition"
    run.ammoPending = {before = AmmoCount(run.ammoID), quantity = count, time = GetTime()}
    -- The API takes individual items, not the number of merchant bundles.
    BuyMerchantItem(index, count)
end

function M:SellTick()
    local run = self.run
    -- A sale must be acknowledged before scanning again or sorting the bags.
    if run.pending then
        local current = Info(run.pending.position)
        if not current or current.hyperlink ~= run.pending.link or current.stackCount < run.pending.count then
            local removed = run.pending.count
            if current and current.hyperlink == run.pending.link then
                removed = removed - current.stackCount
            end
            run.sold = run.sold + removed
            run.revenue = run.revenue + removed * run.pending.price
            run.pending = nil
            run.lastChange = GetTime()
        elseif GetTime() - run.pending.time >= 2 then
            run.skipped[Key(run.pending.position)] = true
            run.pending = nil
            run.saleFailed = true
        else
            return
        end
    end
    if not self.merchantOpen or not self.settings.sell or run.stopSelling then
        run.phase = "repairAfterSales"
        return
    end
    local waiting = false
    for _, position in ipairs(Bags()) do
        local item = Info(position)
        if item and not run.skipped[Key(position)] then
            if item.quality == nil then
                waiting = true
            elseif item.quality == 0 and not item.hasNoValue then
                local _, _, _, _, _, _, _, _, _, _, price = C_Item.GetItemInfo(item.hyperlink or item.itemID)
                if item.isLocked or price == nil then
                    waiting = true
                elseif price > 0 then
                    if CursorHasItem() then
                        if GetTime() - run.lastChange > TIMEOUT then
                            run.saleFailed = true
                            run.phase = "repairAfterSales"
                        end
                        return
                    end
                    run.pending = {position = position, link = item.hyperlink, count = item.stackCount,
                        price = price, time = GetTime()}
                    C.UseContainerItem(position.bag, position.slot)
                    return
                end
            end
        end
    end
    if waiting and GetTime() - run.lastChange < TIMEOUT then return end
    if waiting then run.saleFailed = true end
    run.phase = "repairAfterSales"
end

function M:SortTick()
    local run = self.run
    if not self.settings.sort then self:Finish(); return end
    if CursorHasItem() then
        if GetTime() - run.lastChange > TIMEOUT then
            self:Finish("Taschen nicht vollständig aufgeräumt: Gegenstand am Mauszeiger.")
        end
        return
    end
    if not C.SortBags then
        self:Finish("WoWs Funktion „Taschen aufräumen“ ist nicht verfügbar.")
        return
    end
    for _, position in ipairs(Bags()) do
        local item = Info(position)
        if item and item.isLocked then
            if GetTime() - run.lastChange > TIMEOUT then
                self:Finish("„Taschen aufräumen“ nicht gestartet: Gegenstände gesperrt.")
            end
            return
        end
    end
    -- One native request; WoW handles all moves and honors its bag settings.
    C.SortBags()
    self:Finish("WoWs „Taschen aufräumen“ gestartet.")
end

function M:Tick()
    local run = self.run
    if not run then return end
    if not FT:IsEnabled("merchant") then self.run = nil; return end
    if InCombatLockdown() then
        run.lastChange = GetTime()
        if run.pending then run.pending.time = GetTime() end
        if run.ammoPending then run.ammoPending.time = GetTime() end
        if run.ammoStarted then run.ammoStarted = GetTime() end
        return
    end
    if run.phase == "repair" then
        self:Repair(false)
        run.phase = "sell"
    elseif run.phase == "sell" then
        self:SellTick()
    elseif run.phase == "repairAfterSales" then
        self:Repair(true)
        run.phase = "settle"
        run.settleAt = GetTime()
    elseif run.phase == "settle" then
        if GetTime() - run.settleAt >= 0.5 then
            if run.saleFailed then FT:Print("Einige graue Gegenstände konnten nicht verkauft werden.") end
            run.phase = "ammo"
            run.ammoStarted = GetTime()
            self:AmmoTick()
        end
    elseif run.phase == "ammo" then
        self:AmmoTick()
    elseif run.phase == "sort" then
        self:SortTick()
    end
end

function M:Initialize()
    if not C or not C.GetContainerItemInfo or not C.GetContainerNumSlots or not C.UseContainerItem
        or not C_Item or not C_Item.GetItemInfo then
        FT:Print("Händler & Taschen: benötigte WoW-API fehlt; Modul bleibt inaktiv.")
        return
    end
    local frame = CreateFrame("Frame")
    self.frame = frame
    frame:RegisterEvent("MERCHANT_SHOW")
    frame:RegisterEvent("MERCHANT_CLOSED")
    frame:SetScript("OnEvent", function(_, event)
        self.merchantOpen = event == "MERCHANT_SHOW"
        if self.merchantOpen then self:Start() end
    end)
    local elapsed = 0
    frame:SetScript("OnUpdate", function(_, delta)
        if not self.run then return end
        elapsed = elapsed + delta
        if elapsed < INTERVAL then return end
        elapsed = 0
        local ok, errorMessage = pcall(self.Tick, self)
        if not ok then
            self:Finish("Aktion abgebrochen: " .. tostring(errorMessage))
        end
    end)
end
