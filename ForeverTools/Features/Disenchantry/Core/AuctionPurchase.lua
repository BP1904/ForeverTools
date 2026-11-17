-- Embedded from Disenchantry 1.2.6 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local Buy = {state="idle"}
ns.AuctionPurchase = Buy
local function changed() if ns.AuctionScan.OnChanged then ns.AuctionScan.OnChanged() end end
local function same(a,b)
    return a and b and a.itemID==b.itemID and (a.itemLevel or 0)==(b.itemLevel or 0)
        and (a.itemSuffix or 0)==(b.itemSuffix or 0) and (a.battlePetSpeciesID or 0)==(b.battlePetSpeciesID or 0)
end
function Buy.Cancel(state)
    Buy.active, Buy.pending, Buy.waiting = false, nil, nil
    Buy.state = state or "cancelled"
    changed()
end
local function request(name)
    Buy.pending, Buy.waiting = name, nil
    Buy.deadline = GetTime()+15
end
function Buy.Prepare(row)
    if not ns.IsEnabled() then return end
    if Buy.active or not ns.AuctionScan.open or not row.auctionID or not row.itemKey
        or not C_AuctionHouse.PlaceBid then return end
    ns.AuctionScan.Stop()
    Buy.row = {}
    for k,v in pairs(row) do Buy.row[k]=v end -- freeze the exact displayed lot
    Buy.active, Buy.state = true, "checking"
    request("SendSearchQuery")
    changed()
end
local function currentLot()
    for i=1,C_AuctionHouse.GetNumItemSearchResults(Buy.row.itemKey) do
        local result=C_AuctionHouse.GetItemSearchResultInfo(Buy.row.itemKey,i)
        if result and result.auctionID==Buy.row.auctionID then return result end
    end
end
local function valid(result)
    return result and result.buyoutAmount==Buy.row.buyout and result.buyoutAmount>0
        and (result.quantity or 1)==Buy.row.quantity and result.itemLink==Buy.row.link
        and not result.containsOwnerItem and not result.containsAccountItem
end
local function finish(state)
    for i=#ns.AuctionScan.rows,1,-1 do
        if ns.AuctionScan.rows[i].auctionID==Buy.row.auctionID then table.remove(ns.AuctionScan.rows,i) end
    end
    Buy.Cancel(state)
end
-- Only called directly from the user's button click, never a timer/event.
function Buy.Confirm()
    if not ns.IsEnabled() then return end
    if not Buy.active or Buy.state~="ready" or not ns.AuctionScan.open then return end
    if GetTime()>Buy.deadline or not valid(currentLot()) then Buy.Cancel("stale"); return end
    if GetMoney and GetMoney()<Buy.row.buyout then Buy.Cancel("money"); return end
    if C_AuctionHouse.IsThrottledMessageSystemReady and not C_AuctionHouse.IsThrottledMessageSystemReady() then return end
    Buy.state, Buy.deadline = "sent", GetTime()+8
    -- A separate timer also releases the UI when its OnUpdate is not running.
    local submitted = Buy.row
    if C_Timer and C_Timer.After then C_Timer.After(8, function()
        if Buy.active and Buy.state=="sent" and Buy.row==submitted then Buy.Cancel("unknown") end
    end) end
    Buy.ownBid=true
    local ok=pcall(C_AuctionHouse.PlaceBid, Buy.row.auctionID, Buy.row.buyout)
    Buy.ownBid=false
    if not ok then Buy.Cancel("failed") else changed() end
end
function Buy.OnEvent(event, key, message)
    if not Buy.active then return end
    if event=="AUCTION_HOUSE_CLOSED" then Buy.Cancel(); return end
    if event=="UI_ERROR_MESSAGE" then Buy.Cancel("failed"); return end
    if event=="UI_INFO_MESSAGE" and Buy.state=="sent" and ERR_AUCTION_BID_PLACED
        and message==ERR_AUCTION_BID_PLACED then
        finish("bought"); return
    end
    if event=="CHAT_MSG_SYSTEM" and Buy.state=="sent" and ERR_AUCTION_WON_S then
        -- Clients can report a buyout in system chat instead of UI_INFO_MESSAGE.
        if key==string.format(ERR_AUCTION_WON_S, Buy.row.link)
            or Buy.row.name and key==string.format(ERR_AUCTION_WON_S, Buy.row.name) then
            finish("bought"); return
        end
    end
    if event=="ITEM_SEARCH_RESULTS_UPDATED" and Buy.state=="sent" and same(key,Buy.row.itemKey) then
        if C_AuctionHouse.HasFullItemSearchResults(key) and not currentLot() then
            -- Removal alone does not prove who bought it; unlock without claiming success.
            finish("unavailable")
        end
        return
    end
    if event~="ITEM_SEARCH_RESULTS_UPDATED" or not same(key,Buy.row.itemKey)
        or Buy.state~="checking" or not Buy.waiting then return end
    Buy.waiting=nil
    local result=currentLot()
    if result then
        if not valid(result) then Buy.Cancel("stale"); return end
        Buy.state, Buy.deadline="ready",GetTime()+15
        changed()
    elseif not C_AuctionHouse.HasFullItemSearchResults(key) then request("RequestMoreItemSearchResults")
    else Buy.Cancel("stale") end
end
function Buy.Tick()
    if not Buy.active then return end
    if GetTime()>Buy.deadline then Buy.Cancel(Buy.state=="sent" and "unknown" or "stale"); return end
    if not Buy.pending then return end
    if C_AuctionHouse.IsThrottledMessageSystemReady and not C_AuctionHouse.IsThrottledMessageSystemReady() then return end
    local name=Buy.pending
    Buy.pending, Buy.waiting, Buy.ownQuery=nil,true,true
    local ok
    if name=="SendSearchQuery" then ok=pcall(C_AuctionHouse[name],Buy.row.itemKey,{},true)
    else ok=pcall(C_AuctionHouse[name],Buy.row.itemKey) end
    Buy.ownQuery=false
    if not ok then Buy.Cancel("failed") end
end
function Buy.InstallHooks()
    if Buy.hooked then return end
    Buy.hooked=true
    if C_AuctionHouse.PlaceBid then hooksecurefunc(C_AuctionHouse,"PlaceBid",function()
        if Buy.active and not Buy.ownBid then Buy.Cancel("unknown") end
    end) end
    for _, name in ipairs({"SendSearchQuery","SendBrowseQuery","SearchForItemKeys","SearchForFavorites","SendSellSearchQuery",
        "RequestMoreBrowseResults","RequestMoreItemSearchResults"}) do
        if C_AuctionHouse[name] then hooksecurefunc(C_AuctionHouse,name,function()
            if Buy.active and not Buy.ownQuery then Buy.Cancel("stale") end
        end) end
    end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
