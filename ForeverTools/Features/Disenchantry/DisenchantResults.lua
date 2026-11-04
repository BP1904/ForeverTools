-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local L = ns.L
-- Pre-squish item levels only. Forever uses the mainline project ID, but
-- has its own 1.60.x client version and original-era item levels.
-- Reference: https://warcraft.wiki.gg/wiki/Disenchanting_tables
-- Uncommon: min/max ilvl, dust/essence/shard IDs, armor/weapon chances,
-- dust min/max quantity, essence min/max quantity. Shards always yield one.
local uncommon = {
    {5,15,10940,10938,nil,80,20,20,80,1,2,1,2},
    {16,20,10940,10939,10978,75,20,20,75,2,3,1,2},
    {21,25,10940,10998,10978,75,15,15,75,4,6,1,2},
    {26,30,11083,11082,11084,75,20,20,75,1,2,1,2},
    {31,35,11083,11134,11138,75,20,20,75,2,5,1,2},
    {36,40,11137,11135,11139,75,20,20,75,1,2,1,2},
    {41,45,11137,11174,11177,75,20,20,75,2,5,1,2},
    {46,50,11176,11175,11178,75,20,20,75,1,2,1,2},
    {51,55,11176,16202,14343,75,20,22,75,2,5,1,2},
    {56,60,16204,16203,14344,75,20,22,75,1,2,1,2},
    {61,65,16204,16203,14344,75,20,22,75,2,5,2,3},
}
local outland = {
    {79,79,22445,22447,22448,75,22,22,75,1,2,1,2},
    {80,99,22445,22447,22448,75,22,22,75,2,3,2,3},
    {100,120,22445,22446,22449,75,22,22,75,2,5,1,2},
}
local northrend = {
    {130,151,34054,34056,34053,75,22,22,75,2,3,1,2},
    {152,200,34054,34055,34052,75,22,22,75,4,7,1,2},
}
local rare = {
    {1,25,10978}, {26,30,11084}, {31,35,11138}, {36,40,11139},
    {41,45,11177}, {46,50,11178}, {51,55,14343}, {56,80,14344,20725},
}
local function outcome(id, chance, minQuantity, maxQuantity)
    return {itemID = id, chance = chance, minQuantity = minQuantity or 1, maxQuantity = maxQuantity or minQuantity or 1}
end
local function find(rows, level)
    for _, row in ipairs(rows) do
        if level >= row[1] and level <= row[2] then return row end
    end
end

ns.DisenchantResults = {}
local pending = {}
function ns.DisenchantResults.ItemLoaded(id)
    local requested = pending[id]
    pending[id] = nil
    return requested
end
local function IsForever()
    local version = GetBuildInfo and GetBuildInfo()
    return type(version) == "string" and version:match("^1%.60%.") ~= nil
end
-- Tables cover pre-squish item levels only: no data on the mainline client.
function ns.DisenchantResults.IsSupported()
    return IsForever() or (WOW_PROJECT_ID ~= nil and WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE)
end
function ns.DisenchantResults.Get(item)
    if not item or not ns.DisenchantResults.IsSupported() then return nil end
    local forever = IsForever()
    local level, quality, expansion = item.baseItemLevel, item.quality, item.expansionID
    if not level or level <= 0 then return nil end
    -- Classic clients may return a sentinel (254) rather than an expansion.
    -- Era has only original materials. Elsewhere infer only the unambiguous
    -- low-level original range; do not guess across expansion overlaps.
    if forever or (WOW_PROJECT_CLASSIC and WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
        expansion = 0
    elseif expansion == nil or expansion == 254 or expansion < 0 then
        if level <= 65 then expansion = 0 else return nil end
    end
    if item.classID ~= 2 and item.classID ~= 4 then return nil end
    if quality == 2 then
        local rows = expansion == 0 and uncommon or expansion == 1 and outland or expansion == 2 and northrend
        local row = rows and find(rows, level)
        if not row then return nil end
        local weapon = item.classID == 2
        local dust, essence = row[weapon and 8 or 6], row[weapon and 9 or 7]
        local essenceID = row[4]
        -- Forever: uncommon weapons ilvl 16-30 all yield Greater Magic Essence
        -- (Wowhead Forever disenchant data); armor keeps the classic essences.
        if forever and weapon and level >= 21 and level <= 30 then essenceID = 10939 end
        local results = {outcome(row[3], dust, row[10], row[11]), outcome(essenceID, essence, row[12], row[13])}
        if row[5] then results[#results + 1] = outcome(row[5], 100 - dust - essence) end
        return results
    elseif quality == 3 then
        local rows = expansion == 0 and rare
            or expansion == 1 and {{66,99,22448,20725},{100,115,22449,22450}}
            or expansion == 2 and {{130,166,34053},{167,200,34052}}
        local row = rows and find(rows, level)
        if not row then return nil end
        if row[4] then return {outcome(row[3],99.5),outcome(row[4],0.5)} end
        return {outcome(row[3],100)}
    elseif quality == 4 then
        local rows = expansion == 0 and {{40,45,11177,2,4},{46,50,11178,2,4},{51,55,14343,2,4},{56,60,20725,1,1},{61,88,20725,1,2}}
            or expansion == 1 and {{90,100,22450,1,2},{101,164,22450,1,2}}
            or expansion == 2 and {{185,199,34057,1,2},{200,284,34057,1,1}}
        local row = rows and find(rows, level)
        if row then return {outcome(row[3],100,row[4],row[5])} end
    end
end

local function materialInfo(id)
    local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
    local name, _, _, _, _, _, _, _, _, texture = getInfo(id)
    if not name then pending[id] = true end
    if not texture then
        local getIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
        texture = getIcon and getIcon(id)
    end
    return name or ("#" .. id), texture or 134400
end

local function chanceText(result)
    local quantity = tostring(result.minQuantity)
    if result.maxQuantity ~= result.minQuantity then
        quantity = quantity .. "-" .. result.maxQuantity
    end
    local text = quantity .. "x"
    if not ns.App.db.hideDisenchantChances then text = text .. " " .. result.chance .. "%" end
    local prices = ns.Prices
    local copper = prices and prices.GetAuctionatorValue and prices.GetAuctionatorValue(result.itemID)
    if copper then
        text = text .. " |cffffd100" .. prices.FormatMoney(copper) .. "|r"
    end
    return text
end

function ns.DisenchantResults.Text(item)
    if ns.App.db.hideDisenchantMaterials then return "" end
    local results = ns.DisenchantResults.Get(item)
    if not results then return L.DE_UNKNOWN end
    local parts = {}
    for _, result in ipairs(results) do
        local _, texture = materialInfo(result.itemID)
        parts[#parts + 1] = string.format("|T%s:16:16:0:0|t %s", texture, chanceText(result))
    end
    return table.concat(parts, "  ")
end

-- Quantity ranges have no individual probabilities: use their midpoint.
function ns.DisenchantResults.ExpectedValue(item)
    local results = ns.DisenchantResults.Get(item)
    local prices = ns.Prices
    if not results or not prices or not prices.GetAuctionatorValue then return nil end
    local total = 0
    for _, result in ipairs(results) do
        if result.chance > 0 then
            local copper = prices.GetAuctionatorValue(result.itemID)
            if not copper then return nil end
            local quantity = (result.minQuantity + result.maxQuantity) / 2
            total = total + result.chance / 100 * quantity * copper
        end
    end
    return total
end

function ns.DisenchantResults.AddTooltip(item, tooltip)
    if not ns.IsEnabled() then return end
    tooltip = tooltip or GameTooltip
    local results = ns.DisenchantResults.Get(item)
    if not results or tooltip.foreverToolsDisenchantryResults then return end
    local db = ns.App.db
    if db.hideDisenchantMaterials and db.hideDisenchantValue then return end
    tooltip.foreverToolsDisenchantryResults = true
    if not db.hideDisenchantMaterials then
        tooltip:AddLine(" ")
        tooltip:AddLine(db.hideDisenchantChances and L.DE_MATERIALS or L.DE_RESULTS, 0.6, 0.85, 1)
        for _, result in ipairs(results) do
            local name, texture = materialInfo(result.itemID)
            tooltip:AddDoubleLine(string.format("|T%s:16|t %s", texture, name), chanceText(result), 1, 1, 1, 0.7, 0.9, 1)
        end
    end
    if not db.hideDisenchantValue then
        local expected = ns.DisenchantResults.ExpectedValue(item)
        local value = expected and ns.Prices.FormatMoney(expected) or L.DE_UNKNOWN
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(L.DE_EXPECTED_VALUE or "Expected disenchant value", value, 0.6, 0.85, 1, 1, 0.82, 0)
    end
    return true
end

function ns.DisenchantResults.InstallTooltipHooks()
    local watched = setmetatable({}, {__mode = "k"})
    local function enhance(tooltip, data, explicitRef)
        if not ns.IsEnabled() then return end
        if not tooltip or (tooltip.GetName and tooltip:GetName() == "ForeverToolsDisenchantry_ScanTooltip") then return end
        if not watched[tooltip] then
            watched[tooltip] = true
            tooltip:HookScript("OnTooltipCleared", function(self) self.foreverToolsDisenchantryResults = nil end)
        end
        local _, link
        if tooltip.GetItem then _, link = tooltip:GetItem() end
        if issecretvalue and issecretvalue(link) then return end
        local ref = explicitRef or link or (data and (data.hyperlink or data.id))
        if issecretvalue and issecretvalue(ref) then return end
        if not ref then return end
        local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
        local _, _, quality, level, _, _, _, _, _, _, _, classID, _, _, expansion = getInfo(ref)
        if issecretvalue and (issecretvalue(quality) or issecretvalue(level) or issecretvalue(classID) or issecretvalue(expansion)) then return end
        local added = ns.DisenchantResults.AddTooltip({quality=quality, baseItemLevel=level, classID=classID, expansionID=expansion}, tooltip)
        -- Setter hooks run after the base tooltip has already laid out its lines.
        if added and tooltip.IsShown and tooltip:IsShown() then tooltip:Show() end
    end
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, enhance)
    end
    -- Forever exposes TooltipDataProcessor, but some item tooltips bypass it.
    -- Install setter hooks as well, using the actual bag/slot or link instead
    -- of relying on GetItem() being populated by that client path.
    for _, tooltip in pairs({GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2}) do
        if tooltip.HasScript and tooltip:HasScript("OnTooltipSetItem") then
            tooltip:HookScript("OnTooltipSetItem", function(self) enhance(self) end)
        end
        if hooksecurefunc then
            local function hook(method, resolve)
                if type(tooltip[method]) ~= "function" then return end
                hooksecurefunc(tooltip, method, function(self, ...)
                    local ref = resolve and resolve(...)
                    enhance(self, nil, ref)
                end)
            end
            hook("SetBagItem", function(bag, slot)
                local getLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
                return getLink and getLink(bag, slot)
            end)
            hook("SetInventoryItem", function(unit, slot)
                return GetInventoryItemLink and GetInventoryItemLink(unit, slot)
            end)
            hook("SetHyperlink", function(link) return link end)
            hook("SetItemByID", function(id) return id end)
            hook("SetAuctionItem", function(kind, index)
                return GetAuctionItemLink and GetAuctionItemLink(kind, index)
            end)
            hook("SetAuctionSellItem", function()
                return GetAuctionSellItemLink and GetAuctionSellItemLink()
            end)
            hook("SetMerchantItem", function(index)
                return GetMerchantItemLink and GetMerchantItemLink(index)
            end)
        end
    end
end

-- Real mouse targets, not inline texture escapes in a FontString.
function ns.DisenchantResults.CreateStrip(parent)
    local strip = CreateFrame("Frame", nil, parent)
    strip:SetSize(186, 22)
    strip.buttons = {}
    strip.empty = strip:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    strip.empty:SetAllPoints()
    strip.empty:SetJustifyH("LEFT")
    strip.empty:SetTextColor(0.7, 0.9, 1)
    for index = 1, 3 do
        local button = CreateFrame("Button", nil, strip)
        button:SetSize(22, 22)
        button:SetPoint("LEFT", strip, "LEFT", (index - 1) * 62, 0)
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetAllPoints()
        button.chance = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        button.chance:SetPoint("LEFT", button, "RIGHT", 3, 0)
        button.chance:SetTextColor(0.7, 0.9, 1)
        ns.UI.BindTooltip(button, function(self)
            if not self.itemID then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. self.itemID)
            GameTooltip:Show()
        end)
        button:Hide()
        strip.buttons[index] = button
    end
    return strip
end

function ns.DisenchantResults.UpdateStrip(strip, item)
    if ns.App.db.hideDisenchantMaterials then item = nil end
    local results = item and ns.DisenchantResults.Get(item)
    strip.empty:SetText(item and not results and L.DE_UNKNOWN or "")
    local width = 0
    for index, button in ipairs(strip.buttons) do
        local result = results and results[index]
        if result then
            if button.itemID ~= result.itemID and GameTooltip:IsOwned(button) then GameTooltip:Hide() end
            button.itemID = result.itemID
            local _, texture = materialInfo(result.itemID)
            button.icon:SetTexture(texture)
            button.chance:SetText(chanceText(result))
            button:ClearAllPoints()
            button:SetPoint("LEFT", strip, "LEFT", width, 0)
            width = width + math.max(62, 22 + 3 + (button.chance:GetStringWidth() or 30) + 10)
            button:Show()
        else
            button.itemID = nil
            button.chance:SetText("")
            button:Hide()
        end
    end
    strip.contentWidth = math.max(186, width)
    strip:SetWidth(item and strip.contentWidth or 1)
end

end
LoadComponent("ForeverTools", FT.disenchantry)
