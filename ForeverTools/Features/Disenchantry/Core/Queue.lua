-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Work plans record executable entries and exclusion decisions together.
local _, ns = ...
local App, Queue = ns.App, {}
ns.Queue = Queue
function Queue.Plan(candidates, selection, skipped, automatic, evaluate)
    local plan = {entries={}, decisions={}, counts={}, manual=false}
    for key, chosen in pairs(selection) do
        if chosen then plan.manual = true; break end
    end
    for _, item in ipairs(candidates) do
        local reason
        if skipped[item.key] then reason = "skipped"
        elseif plan.manual then
            if not selection[item.key] then reason = "unselected" end
        elseif not automatic then reason = "unselected"
        else reason = evaluate(item) end
        local category = reason or "ready"
        plan.decisions[item.key] = category
        plan.counts[category] = (plan.counts[category] or 0) + 1
        if not reason then plan.entries[#plan.entries + 1] = item end
    end
    return plan
end
function App.ReplanWork()
    local automatic = App.db and App.db.compactMode and App.compactFrame and App.compactFrame:IsShown()
    local protected = App.activeMode and App.activeMode.usesItemProtection
    App.workPlan = Queue.Plan(App.items, App.selected, App.sessionSkipped, automatic, function(item)
        return protected and ns.ItemRules.Assess(item).primary or nil
    end)
    wipe(App.queue)
    for index, item in ipairs(App.workPlan.entries) do App.queue[index] = item end
    if App.browsedQueueKey then
        local index
        for i, item in ipairs(App.queue) do if item.key == App.browsedQueueKey then index = i; break end end
        if index then
            for _ = 2, index do
                local first = table.remove(App.queue, 1)
                App.queue[#App.queue + 1] = first
            end
        else App.browsedQueueKey = nil end
    end
    App.valuableSkippedCount = App.workPlan.counts.value or 0
end
function App.CycleQueuedItem(direction)
    if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return false end
    if UnitCastingInfo("player") or UnitChannelInfo("player") or #App.queue < 2 then return false end
    if direction < 0 then table.insert(App.queue, 1, table.remove(App.queue))
    else
        local first = table.remove(App.queue, 1)
        App.queue[#App.queue + 1] = first
    end
    App.browsedQueueKey = App.queue[1].key
    App.RefreshUI()
    return true
end
function App.SkipQueuedItem()
    if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return false end
    if UnitCastingInfo("player") or UnitChannelInfo("player") then return false end
    local current = App.queue[1]
    if not current then return false end
    App.sessionSkipped[current.key] = true
    App.ReplanWork()
    App.RefreshUI()
    return true
end
function Queue.EndSession() wipe(App.sessionSkipped); App.browsedQueueKey = nil end
function ns.GetValuableSkippedCount() return App.valuableSkippedCount end

end
LoadComponent("ForeverTools", FT.disenchantry)
