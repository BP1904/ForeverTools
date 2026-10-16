local _, FT = ...
local M = {
    title = "Händler & Taschen",
    description = "Automatisch reparieren, graue Gegenstände verkaufen und WoWs Funktion „Taschen aufräumen“ starten.",
    defaults = {repair = true, sell = true, sort = true},
    options = {
        {key = "repair", title = "Alle mitgeführten Gegenstände reparieren"},
        {key = "sell", title = "Graue Gegenstände automatisch verkaufen"},
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
        revenue = 0, lastChange = GetTime()}
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
            self:BeginSort()
        end
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
