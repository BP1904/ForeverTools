-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local ADDON_NAME, ns = ...
local App = ns.App
local Inventory = {}
ns.Inventory = Inventory

function App.GetItemIDFromLink(link)
    return type(link) == "string" and tonumber(link:match("item:(%d+)")) or nil
end
function App.InstanceIdentity(bag, slot, link)
    local api = C_Item
    if api and api.GetItemGUID and api.DoesItemExist and ItemLocation and ItemLocation.CreateFromBagAndSlot then
        local location = ItemLocation:CreateFromBagAndSlot(bag, slot)
        if location and api.DoesItemExist(location) then
            local guid = api.GetItemGUID(location)
            if guid then return guid end
        end
    end
    return table.concat({tostring(bag), tostring(slot), tostring(App.GetItemIDFromLink(link) or "?")}, ":")
end
function App.ExclusionIdentity(link)
    local id = App.GetItemIDFromLink(link)
    if id then return tostring(id) end
    if type(link) == "string" then return link:match("|H(item:[^|]+)|h") or link:match("(item:[^|]+)") end
end
function App.ExclusionBook(mode)
    local key = mode or App.activeMode and App.activeMode.key or "disenchant"
    local lists = App.db.blacklist
    if type(lists) ~= "table" then lists = {}; App.db.blacklist = lists end
    if type(lists[key]) ~= "table" then lists[key] = {} end
    return lists[key]
end
function App.IsExcluded(link)
    local key = App.ExclusionIdentity(link)
    return App.db ~= nil and key ~= nil and App.ExclusionBook()[key] == true
end
-- Bag iteration is one contract for discovery and pending-item validation.
function Inventory.Visit(visitor)
    local bags = C_Container
    if not bags or not bags.GetContainerNumSlots then return end
    for _, bag in ipairs(App.BAGS_TO_SCAN) do
        for slot = 1, bags.GetContainerNumSlots(bag) or 0 do
            if visitor(bag, slot) then return true end
        end
    end
    return false
end
function App.GetBagItemLinkSafe(bag, slot)
    local getter = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
    return getter and getter(bag, slot) or nil
end
function App.FindPendingItem(item)
    if not item or not item.guid then return end
    local found
    Inventory.Visit(function(bag, slot)
        local link = App.GetBagItemLinkSafe(bag, slot)
        if link and App.InstanceIdentity(bag, slot, link) == item.guid then
            found = {bag=bag, slot=slot, link=link}
            return true
        end
    end)
    return found
end
function App.DoesPendingItemStillExist(item) return App.FindPendingItem(item) ~= nil end
function App.OrderCandidates()
    local fields = {"quality", "itemLevel"}
    table.sort(App.items, function(left, right)
        for _, field in ipairs(fields) do
            local a, b = left[field] or 0, right[field] or 0
            if a ~= b then return a > b end
        end
        return left.name < right.name
    end)
end
local function scheduleRefresh()
    if App.itemLoadRefreshQueued or not C_Timer or not C_Timer.After then return end
    App.itemLoadRefreshQueued = true
    C_Timer.After(0.25, function()
        App.itemLoadRefreshQueued = false
        local main = App.mainFrame and App.mainFrame:IsShown()
        local compact = App.compactFrame and App.compactFrame:IsShown()
        if (main or compact) and App.RefreshWorkspace then App.RefreshWorkspace() end
    end)
end
function App.AwaitCandidateData(bag, slot)
    if not Item or not Item.CreateFromBagAndSlot then return end
    local request = Item:CreateFromBagAndSlot(bag, slot)
    if request and not request:IsItemEmpty() then request:ContinueOnItemLoad(scheduleRefresh) end
end
function App.ReadProtectionPrice(link)
    local settings, mode = App.db or {}, App.activeMode
    if not mode or not mode.usesItemProtection or not settings.priceWarnEnabled
        or not tonumber(settings.priceThresholdGold) then return end
    local value, _, source = ns.Prices.GetValue(link)
    return value, source
end
local function readSlot(bag, slot, info)
    local link = info.hyperlink
    local key = App.InstanceIdentity(bag, slot, link)
    if info.isLocked then
        return nil, key
    end
    local name, _, quality, level, _, _, _, _, _, texture, _, class, _, bind, expansion, set = App.GetItemInfoSafe(link)
    local retryKey = bag .. ":" .. slot
    if quality == nil then
        local attempts = (App.itemLoadRetries[retryKey] or 0) + 1
        App.itemLoadRetries[retryKey] = attempts
        if attempts <= App.MAX_ITEM_LOAD_RETRIES then
            App.AwaitCandidateData(bag, slot)
        end
        return nil, key
    end
    App.itemLoadRetries[retryKey] = nil
    local mode = App.activeMode
    if (info.stackCount or 1) < mode.minStack or App.IsExcluded(link) or not mode.scanEligible(link, quality, info) then
        return 
    end
    local item = {
        key = key,
        bag = bag,
        slot = slot,
        link = link,
        count = info.stackCount or 1,
        quality = quality,
        texture = info.iconFileID or texture or 134400,
        name = App.GetDisplayName(name, link),
        itemLevel = ns.Client.ItemLevel(link),
        baseItemLevel = level,
        classID = class,
        expansionID = expansion,
        isSet = (set ~= nil and set ~= 0) or nil,
    }
    item.priceCopper, item.priceSource = App.ReadProtectionPrice(link)
    item.isValuable = App.HasValueSafeguard(item)
    item.bindTag = App.GetBindTagText(bind, info.isBound)
    if item.isSet then
        item.bindTag = (item.bindTag and item.bindTag .. " " or "") .. "|cffff7f00SET|r"
    end
    return item, key
end
function App.DiscoverCandidates()
    local live = {}
    wipe(App.items)
    if C_Container and C_Container.GetContainerItemInfo then
        Inventory.Visit(function(bag, slot)
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if not info or not info.hyperlink then return end
            local item, key = readSlot(bag, slot, info)
            if key then live[key] = true end
            if item then App.items[#App.items + 1] = item end
        end)
    end
    for key in pairs(App.selected) do if not live[key] then App.selected[key] = nil end end
    App.OrderCandidates()
    App.ReplanWork()
end

end
LoadComponent("ForeverTools", FT.disenchantry)
