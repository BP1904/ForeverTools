-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- A processing attempt has one target and a revision that invalidates callbacks.
local _, ns = ...
local App = ns.App
local Processing = {}
ns.Processing = Processing
App.IsUsableString = ns.Client.IsPublicString

function App.ExtractMessageFromEventArgs(...)
    local cursor = select("#", ...)
    while cursor > 0 do
        local candidate = select(cursor, ...)
        if ns.Client.IsPublicString(candidate) then return candidate end
        cursor = cursor - 1
    end
end
function App.ClearPendingDisenchant()
    App.pendingDisenchantItem, App.pendingDisenchantUntil = nil, 0
    App.pendingValidationToken = App.pendingValidationToken + 1
    if ns.Statistics and ns.Statistics.CancelTarget then ns.Statistics.CancelTarget() end
end
function App.SetPendingDisenchant(source)
    App.ClearPendingDisenchant()
    if not source then return end
    local target = {}
    for _, field in ipairs({"bag", "slot", "key", "link"}) do target[field] = source[field] end
    -- Without a GUID, delayed destructive decisions cannot identify an instance safely.
    if C_Item and C_Item.GetItemGUID and C_Item.DoesItemExist and ItemLocation and ItemLocation.CreateFromBagAndSlot then
        local location = ItemLocation:CreateFromBagAndSlot(source.bag, source.slot)
        if C_Item.DoesItemExist(location) then target.guid = C_Item.GetItemGUID(location) end
    end
    target.name = source.name or App.L.UNKNOWN
    target.itemID = App.GetItemIDFromLink(source.link)
    App.pendingDisenchantItem, App.pendingDisenchantUntil = target, GetTime() + 8
end
local function refreshAfterValidation()
    App.ClearPendingDisenchant()
    local visible = App.mainFrame and App.mainFrame:IsShown() or App.compactFrame and App.compactFrame:IsShown()
    if visible then App.RefreshWorkspace() end
end
function App.AddItemToBlacklist(item, message)
    if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return false end
    if not App.db or not item then return false end
    local key = App.ExclusionIdentity(item.link)
    if key then App.ExclusionBook()[key] = true end
    if item.key then App.selected[item.key] = nil end
    if message ~= false then
        App.Print((message or App.L.ADDED_AUTO) .. ": " .. (item.name or App.L.UNKNOWN))
    end
    App.DiscoverCandidates()
    if App.blacklistFrame and App.blacklistFrame:IsShown() then App.RefreshBlacklistUI() end
    App.RefreshUI()
    return key ~= nil
end
function App.AddPendingItemToBlacklist()
    local target = App.pendingDisenchantItem
    App.ClearPendingDisenchant()
    if target then App.AddItemToBlacklist(target, App.L.ADDED_AUTO) end
end
function App.ValidatePendingItemForBlacklist(delay, definitive)
    if not App.pendingDisenchantItem or not C_Timer or not C_Timer.After then return end
    App.pendingValidationToken = App.pendingValidationToken + 1
    local revision = App.pendingValidationToken
    C_Timer.After(tonumber(delay) or 0.2, function()
        local target = App.pendingDisenchantItem
        if revision ~= App.pendingValidationToken or not target then return end
        local probe = App.FindPendingItem(target)
        if InCombatLockdown() or not probe then refreshAfterValidation(); return end
        if definitive or App.TooltipSaysCantDisenchant(probe) then App.AddPendingItemToBlacklist()
        else refreshAfterValidation() end
    end)
end
function App.TryBlacklistQueuedItemBeforeCast()
    if App.activeMode.key ~= "disenchant" then return false end
    local target = App.queue[1]
    if not target or not App.TooltipSaysCantDisenchant(target) then return false end
    App.SetPendingDisenchant(target)
    App.AddPendingItemToBlacklist()
    return true
end

end
LoadComponent("ForeverTools", FT.disenchantry)
