-- Embedded from Disenchantry 1.2.5 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Serial auction scanning; purchases are handled by AuctionPurchase.
local _, ns = ...
local Scan = {rows={}, state="idle", checked=0, skipped=0, interval=5}
ns.AuctionScan = Scan
local function identity(key)
    return table.concat({key.itemID or 0, key.itemLevel or 0, key.itemSuffix or 0, key.battlePetSpeciesID or 0}, ":")
end
local function changed()
    table.sort(Scan.rows, function(a, b)
        if a.profit ~= b.profit then return a.profit > b.profit end
        return a.auctionID < b.auctionID
    end)
    if Scan.OnChanged then Scan.OnChanged() end
end
function Scan.Stop(reason)
    Scan.running, Scan.pending, Scan.waiting = false, nil, nil
    Scan.state = reason or "stopped"
    changed()
end
function Scan.Supported()
    local api = C_AuctionHouse
    for _, name in ipairs({"SendBrowseQuery", "GetBrowseResults", "HasFullBrowseResults", "RequestMoreBrowseResults",
        "SendSearchQuery", "GetNumItemSearchResults", "GetItemSearchResultInfo", "HasFullItemSearchResults", "RequestMoreItemSearchResults"}) do
        if not api or type(api[name]) ~= "function" then return false end
    end
    return true
end
local function enqueue(name, ...)
    Scan.pending = {name=name, args={...}}
    Scan.deadline = GetTime() + 30
end
function Scan.Evaluate(result)
    if ns.DisenchantResults.IsExcluded(result.itemLink) then return nil, "ignored" end
    if not result.auctionID or not result.itemLink or result.containsOwnerItem or result.containsAccountItem
        or not result.buyoutAmount or result.buyoutAmount <= 0 then return nil, "ignored" end
    local quantity = result.quantity or 1
    if quantity <= 0 then return nil, "ignored" end
    local name, _, quality, level, _, _, _, _, _, icon, _, class, _, _, expansion = ns.App.GetItemInfoSafe(result.itemLink)
    if not name then return nil, "loading" end
    local item = {link=result.itemLink, quality=quality, baseItemLevel=level, classID=class, expansionID=expansion}
    if ns.ForecastPolicy and not ns.ForecastPolicy.MatchesMaterial(item, ns.App.db and ns.App.db.auctionMaterialID) then return nil,"ignored" end
    if not ns.DisenchantResults.Get(item) then return nil, "ignored" end
    if ns.App.db and ns.App.db.blacklist and ns.App.db.blacklist.disenchant then
        local id = result.itemLink:match("item:(%d+)")
        if id and ns.App.db.blacklist.disenchant[id] then return nil, "ignored" end
    end
    if ns.ItemRules.Refuses(item) then return nil, "ignored" end
    local value = ns.DisenchantResults.ExpectedValue(item)
    if not value then return nil, "unpriced" end
    local total = value * quantity
    if total <= result.buyoutAmount then return nil, "ignored" end
    return {auctionID=result.auctionID, itemKey=result.itemKey, link=result.itemLink, name=name, icon=icon,
        quantity=quantity, buyout=result.buyoutAmount, value=total, profit=total-result.buyoutAmount,
        percent=(total/result.buyoutAmount-1)*100, item=item}
end
local function finishRound()
    local rows = {}
    for _, row in ipairs(Scan.rows) do
        if Scan.confirmed[row.auctionID] or row.itemKey and Scan.keepKeys[identity(row.itemKey)] then rows[#rows+1] = row end
    end
    Scan.rows = rows
    for key in pairs(Scan.verified) do if not Scan.seen[key] then Scan.verified[key]=nil end end
    Scan.state, Scan.waiting = "monitoring", nil
    Scan.nextRound = GetTime() + Scan.interval
    changed()
end
local function nextItem()
    Scan.index = Scan.index + 1
    Scan.current = Scan.keys[Scan.index]
    Scan.currentIncomplete = false
    if not Scan.current then finishRound(); return end
    Scan.state = "search"
    enqueue("SendSearchQuery", Scan.current, {}, true)
    changed()
end
local function beginRound()
    ns.Prices.ClearCache()
    Scan.keys, Scan.seen, Scan.lots, Scan.confirmed = {}, {}, {}, {}
    Scan.keepKeys, Scan.signatures = {}, {}
    Scan.unchanged, Scan.auditUsed = 0, false
    Scan.summaries, Scan.summaryIndices, Scan.deferred = {}, {}, {}
    Scan.rowsByID = {}
    for _, row in ipairs(Scan.rows) do Scan.rowsByID[row.auctionID] = row end
    Scan.round = (Scan.round or 0) + 1
    Scan.total, Scan.filtered, Scan.filterIndex, Scan.missingData = 0, 0, 1, 0
    Scan.checked, Scan.skipped, Scan.index = 0, 0, 0
    Scan.running, Scan.state = true, "browse"
    Scan.current = nil
    local filters = {}
    local quality = Enum and Enum.AuctionHouseFilter
    if quality and quality.UncommonQuality and quality.RareQuality and quality.EpicQuality then
        filters = {quality.UncommonQuality, quality.RareQuality, quality.EpicQuality}
    end
    enqueue("SendBrowseQuery", {searchString="", sorts={}, filters=filters, itemClassFilters={{classID=2}, {classID=4}}})
    changed()
end
function Scan.Start()
    if not ns.IsEnabled() then return end
    if ns.AuctionPurchase and ns.AuctionPurchase.active then return end
    if Scan.running then return end
    if not Scan.Supported() then Scan.Stop("unsupported"); return end
    if not Scan.open then Scan.Stop("closed"); return end
    Scan.rows, Scan.round, Scan.verified = {}, 0, {}
    beginRound()
end
-- No auction request per item: classify the browse snapshot using cached item
-- metadata. minPrice may include bids; that only adds conservative candidates.
-- Use max stack size as an upper bound so a cheap stack cannot be filtered out.
function Scan.IsCandidate(result)
    local key = result.itemKey
    if ns.DisenchantResults.IsExcluded(key.itemID) then return false end
    local name, _, quality, level, _, _, _, stack, _, _, _, class, _, _, expansion = ns.App.GetItemInfoSafe(key.itemID)
    if not name then return nil end
    if class ~= 2 and class ~= 4 then return false end
    local excluded = ns.App.db and ns.App.db.blacklist and ns.App.db.blacklist.disenchant
    if excluded and excluded[tostring(key.itemID)] then return false end
    local item = {itemID=key.itemID, quality=quality, baseItemLevel=level, classID=class, expansionID=expansion}
    if ns.ForecastPolicy and not ns.ForecastPolicy.MatchesMaterial(item, ns.App.db and ns.App.db.auctionMaterialID) then return false end
    local value = ns.DisenchantResults.ExpectedValue(item)
    -- Retail variants can have a different quality under the same item key.
    if ns.DisenchantResults.IsRetail and ns.DisenchantResults.IsRetail() then
        for q=2,4 do
            item.quality = q
            local estimate = ns.DisenchantResults.ExpectedValue(item)
            if estimate then value = math.max(value or 0, estimate) end
        end
    end
    if not value then return false, "unpriced" end
    if not result.minPrice or result.minPrice <= 0 then return true, nil, value end
    return result.minPrice < value * math.max(1, stack or 1), nil, value
end
local function filterBatch()
    local processed = 0
    while Scan.filterIndex <= #Scan.summaries and processed < 100 do
        local result = Scan.summaries[Scan.filterIndex]
        local candidate, reason, value = Scan.IsCandidate(result)
        local key = identity(result.itemKey)
        if candidate == nil then Scan.deferred[#Scan.deferred+1] = result
        elseif candidate then
            -- Missing summary fields cannot establish that an auction is unchanged.
            local signature = result.minPrice and result.totalQuantity and value
                and table.concat({result.minPrice,result.totalQuantity,value}, ":")
            Scan.signatures[key] = signature
            local cached = Scan.verified[key]
            local unchanged = signature and cached and cached.signature==signature
            -- Bounded audit: equal price/count can hide replacement auction IDs.
            -- At most one unchanged key per pass; never rescan the whole cache.
            local audit = unchanged and not Scan.auditUsed and GetTime()-cached.checkedAt >= 120
            if unchanged and not audit then
                Scan.keepKeys[key]=true
                Scan.unchanged=Scan.unchanged+1
            else
                if audit then Scan.auditUsed=true end
                Scan.keys[#Scan.keys+1] = result.itemKey
            end
        else
            Scan.verified[key]=nil
            Scan.filtered = Scan.filtered + 1
            if reason == "unpriced" then Scan.skipped = Scan.skipped + 1 end
        end
        Scan.filterIndex, processed = Scan.filterIndex + 1, processed + 1
    end
    if Scan.filterIndex > #Scan.summaries then
        if #Scan.deferred > 0 and GetTime() < Scan.filterDeadline then
            Scan.summaries, Scan.deferred, Scan.filterIndex = Scan.deferred, {}, 1
        else
            -- Never turn a cold local item cache into thousands of server searches.
            -- Retry metadata on the next monitoring pass and report incomplete coverage.
            Scan.missingData = #Scan.deferred
            Scan.skipped = Scan.skipped + Scan.missingData
            nextItem()
        end
    end
    changed()
end
local function readListings()
    local waiting = false
    for index = 1, C_AuctionHouse.GetNumItemSearchResults(Scan.current) do
        local result = C_AuctionHouse.GetItemSearchResultInfo(Scan.current, index)
        if result and result.auctionID and not Scan.lots[result.auctionID] then
            local row, reason = Scan.Evaluate(result)
            if reason == "loading" and GetTime() < Scan.loadDeadline then
                waiting = true
            else
                Scan.lots[result.auctionID] = true
                Scan.checked = Scan.checked + 1
                if reason == "loading" or reason == "unpriced" then
                    Scan.skipped = Scan.skipped + 1
                    Scan.currentIncomplete = true
                end
                if row then
                    row.itemKey = Scan.current
                    Scan.confirmed[row.auctionID] = true
                    local previous = Scan.rowsByID[row.auctionID]
                    if previous then
                        -- Preserve the row object: sorting makes numeric indices stale.
                        for field in pairs(previous) do previous[field] = nil end
                        for field, value in pairs(row) do previous[field] = value end
                    else
                        Scan.rows[#Scan.rows+1] = row
                        Scan.rowsByID[row.auctionID] = row
                    end
                end
            end
        end
    end
    if waiting then Scan.state = "loading"; changed(); return end
    if not C_AuctionHouse.HasFullItemSearchResults(Scan.current) then
        Scan.state = "search"
        enqueue("RequestMoreItemSearchResults", Scan.current)
    else
        local key=identity(Scan.current)
        if not Scan.currentIncomplete and Scan.signatures[key] then
            Scan.verified[key]={signature=Scan.signatures[key],checkedAt=GetTime()}
        else Scan.verified[key]=nil end
        nextItem()
    end
end
function Scan.OnEvent(event, key)
    if event == "AUCTION_HOUSE_SHOW" then Scan.open = true; return end
    if event == "AUCTION_HOUSE_CLOSED" then Scan.open = false; Scan.Stop("closed"); return end
    if not Scan.running then return end
    if event == "AUCTION_HOUSE_BROWSE_FAILURE" then Scan.Stop("failed"); return end
    if Scan.state == "browse" and Scan.waiting and
        (event == "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" or event == "AUCTION_HOUSE_BROWSE_RESULTS_ADDED") then
        Scan.waiting = nil
        for _, result in ipairs(C_AuctionHouse.GetBrowseResults() or {}) do
            local itemKey = result.itemKey
            if itemKey then
                local id = identity(itemKey)
                local index = Scan.summaryIndices[id]
                if index then
                    -- GetBrowseResults is cumulative; later pages may update totals
                    -- or prices of a key already present in an earlier page.
                    Scan.summaries[index] = result
                else
                    Scan.seen[id] = true
                    Scan.summaries[#Scan.summaries+1] = result
                    Scan.summaryIndices[id] = #Scan.summaries
                    Scan.total = Scan.total + 1
                end
            end
        end
        if C_AuctionHouse.HasFullBrowseResults() then
            Scan.state = "filtering"
            Scan.filterDeadline = GetTime() + 5
            filterBatch()
        else enqueue("RequestMoreBrowseResults"); changed() end
    elseif Scan.state == "search" and Scan.waiting and event == "ITEM_SEARCH_RESULTS_UPDATED"
        and key and identity(key) == identity(Scan.current) then
        Scan.waiting = nil
        Scan.loadDeadline = GetTime() + 5
        readListings()
    end
end
function Scan.Tick()
    if not Scan.running then return end
    if Scan.state == "monitoring" then
        if GetTime() >= Scan.nextRound then beginRound() end
        return
    end
    if Scan.state == "filtering" then filterBatch(); return end
    if GetTime() > Scan.deadline then Scan.Stop("timeout"); return end
    if Scan.state == "loading" then readListings(); return end
    if not Scan.pending then return end
    if C_AuctionHouse.IsThrottledMessageSystemReady and not C_AuctionHouse.IsThrottledMessageSystemReady() then return end
    local request = Scan.pending
    -- This also requests missing key metadata; uncached keys can silently drop a search.
    if request.name == "SendSearchQuery" and C_AuctionHouse.GetItemKeyInfo
        and not C_AuctionHouse.GetItemKeyInfo(Scan.current) then return end
    Scan.pending, Scan.waiting = nil, true
    Scan.deadline = GetTime() + 30
    Scan.ownQuery = true
    local ok = pcall(C_AuctionHouse[request.name], unpack(request.args))
    Scan.ownQuery = false
    if not ok then Scan.Stop("failed") end
end
-- Another addon or the default UI owns the next search: abandon our snapshot.
function Scan.InstallHooks()
    if Scan.hooked or not Scan.Supported() or not hooksecurefunc then return end
    Scan.hooked = true
    for _, name in ipairs({"SendBrowseQuery", "SendSearchQuery", "SearchForItemKeys", "SearchForFavorites",
        "SendSellSearchQuery", "RequestMoreBrowseResults", "RequestMoreItemSearchResults"}) do
        if C_AuctionHouse[name] then
            hooksecurefunc(C_AuctionHouse, name, function()
                if Scan.running and not Scan.ownQuery then Scan.Stop("interrupted") end
            end)
        end
    end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
