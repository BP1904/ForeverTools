-- Embedded from Disenchantry 1.2.6 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Market quotations are resolved through isolated adapters and a shared cache.
local addonName, ns = ...
addonName = addonName or "Disenchantry"
local Market = {}
ns.Prices = Market
local books, adapters = {}, {}
local function positive(value)
    if issecretvalue and issecretvalue(value) then return end
    if type(value) == "number" and value > 0 and value < math.huge then return value end
end
local function auction()
    return Auctionator and Auctionator.API and Auctionator.API.v1
end
function Market.GetAuctionatorSource()
    local db = ns.App and ns.App.db
    return db and db.auctionatorSource == "average" and "average" or "last"
end
function Market.GetAuctionatorAverageDays()
    local config = Auctionator and Auctionator.Config
    if config and type(config.Get) == "function" and config.Options and config.Options.AUCTION_MEAN_DAYS_LIMIT then
        local ok, days = pcall(config.Get, config.Options.AUCTION_MEAN_DAYS_LIMIT)
        if ok and type(days) == "number" and days >= 1 and days < math.huge then return math.floor(days) end
    end
    return 21
end
local function averagePrice(reference)
    local db = Auctionator and Auctionator.Database
    if not db or type(db.GetMeanPrice) ~= "function" then return end
    local days = Market.GetAuctionatorAverageDays()
    if type(reference) == "number" then return db:GetMeanPrice(tostring(reference), days) end
    local utilities = Auctionator.Utilities
    if not utilities or type(utilities.DBKeyFromLink) ~= "function" then return end
    local keys
    utilities.DBKeyFromLink(reference, function(result) keys = result end)
    -- Item information may still be loading. Retry on the next query in that case.
    if type(keys) ~= "table" then return end
    for _, key in ipairs(keys) do
        local value = positive(db:GetMeanPrice(key, days))
        if value then return value end
    end
end
adapters.tsm = {
    label="TSM",
    present=function()
        return TSM_API and type(TSM_API.ToItemString) == "function" and type(TSM_API.GetCustomPriceValue) == "function"
    end,
    quote=function(reference)
        local token = TSM_API.ToItemString(reference)
        if token then return TSM_API.GetCustomPriceValue("DBMarket", token) end
    end,
}
adapters.auctionator = {
    label="Auctionator",
    present=function()
        if Market.GetAuctionatorSource() == "average" then
            return Auctionator and Auctionator.Database and type(Auctionator.Database.GetMeanPrice) == "function"
        end
        local api = auction()
        return api and type(api.GetAuctionPriceByItemLink) == "function"
    end,
    quote=function(reference)
        if Market.GetAuctionatorSource() == "average" then return averagePrice(reference) end
        local api = auction()
        if type(reference) == "number" then
            if type(api.GetAuctionPriceByItemID) == "function" then
                return api.GetAuctionPriceByItemID(addonName, reference)
            end
            reference = "item:" .. reference
        end
        return api.GetAuctionPriceByItemLink(addonName, reference)
    end,
}
local order = {"tsm", "auctionator"}
local function available(adapter)
    local ok, present = pcall(adapter.present)
    return ok and present and true or false
end
function Market.Query(reference, channel)
    if issecretvalue and issecretvalue(reference) then return end
    if type(reference) ~= "string" and type(reference) ~= "number" then return end
    channel = channel or "preferred"
    local cacheKey = channel .. ":" .. Market.GetAuctionatorSource()
    if Market.GetAuctionatorSource() == "average" then cacheKey = cacheKey .. ":" .. Market.GetAuctionatorAverageDays() end
    local book = books[cacheKey]
    if not book then book = {}; books[cacheKey] = book end
    local now = GetTime()
    local quote = book[reference]
    if quote and quote.expires > now then return quote.value, quote.source, quote.label end
    quote = {expires=now + 60}
    for _, key in ipairs(channel == "preferred" and order or {channel}) do
        local adapter = adapters[key]
        if adapter and available(adapter) then
            local ok, value = pcall(adapter.quote, reference)
            value = ok and positive(value) or nil
            if value then
                quote.value, quote.source, quote.label = value, key, adapter.label
                break
            end
        end
    end
    book[reference] = quote.value and quote or nil
    return quote.value, quote.source, quote.label
end
function Market.GetValue(link) return Market.Query(link) end
function Market.GetAuctionatorValue(id)
    if type(id) == "number" then return Market.Query(id, "auctionator") end
end
function Market.GetProviderStatus()
    local status = {}
    for _, key in ipairs(order) do
        status[#status + 1] = {key=key, label=adapters[key].label, available=available(adapters[key])}
    end
    return status
end
function Market.HasAnySource()
    for _, adapter in pairs(adapters) do if available(adapter) then return true end end
    return false
end
function Market.ClearCache() books = {} end
local Prices = Market
local function goldNumber(copper, separators)
    local gold = math.floor(copper / 10000)
    if BreakUpLargeNumbers then return tostring(BreakUpLargeNumbers(gold)) end
    if not separators then return tostring(gold) end
    local separator = GetLocale and GetLocale() == "deDE" and "." or ","
    local result = tostring(gold):reverse():gsub("(%d%d%d)", "%1" .. separator):reverse()
    return result:gsub("^" .. (separator == "." and "%." or separator), "")
end
function Prices.FormatGold(copper)
    if type(copper) ~= "number" then return "" end
    return goldNumber(copper, true) .. " " .. (ns.L and ns.L.PRICE_GOLD or "g")
end
function Prices.FormatGoldIcon(copper)
    if type(copper) ~= "number" then return "" end
    return goldNumber(copper, false) .. " |TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
end
function Prices.FormatMoney(copper)
    if not positive(copper) then return "" end
    copper = math.floor(copper)
    local values = {math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100}
    local textures, parts = {"Gold", "Silver", "Copper"}, {}
    for index, value in ipairs(values) do
        if value > 0 or index == 3 and #parts == 0 then
            parts[#parts + 1] = value .. "|TInterface\\MoneyFrame\\UI-" .. textures[index] .. "Icon:0|t"
        end
    end
    return table.concat(parts, " ")
end

end
LoadComponent("ForeverTools", FT.disenchantry)
