-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Item rules are shared by scanning, queue policy and the settings panel.
local _, ns = ...
local App, Rules = ns.App, {}
ns.ItemRules = Rules

local refusalPhrases = {"cannot be disenchanted", "can not be disenchanted", "nicht entzauberbar", "kann nicht entzaubert"}
local function append(list, text)
    if ns.Client.IsPublicString(text) then list[#list + 1] = text end
end
function Rules.Tooltip(item)
    local text = {}
    if not item then return text end
    if C_TooltipInfo and C_TooltipInfo.GetBagItem and item.bag ~= nil and item.slot ~= nil then
        local payload = C_TooltipInfo.GetBagItem(item.bag, item.slot)
        for _, line in ipairs(payload and payload.lines or {}) do
            for _, field in ipairs({"leftText", "rightText", "text"}) do append(text, line[field]) end
        end
    end
    if #text > 0 then return text end
    if not App.scanTooltip then
        App.scanTooltip = CreateFrame("GameTooltip", "ForeverToolsDisenchantry_ScanTooltip", UIParent, "GameTooltipTemplate")
    end
    local tip = App.scanTooltip
    tip:SetOwner(UIParent, "ANCHOR_NONE")
    tip:ClearLines()
    if item.bag ~= nil and item.slot ~= nil then tip:SetBagItem(item.bag, item.slot)
    elseif item.link then tip:SetHyperlink(item.link)
    else tip:Hide(); return text end
    for number = 1, tip:NumLines() or 0 do
        local region = _G[tip:GetName() .. "TextLeft" .. number]
        append(text, region and region:GetText())
    end
    tip:Hide()
    return text
end
function Rules.Refuses(item)
    local exact = {}
    for _, global in ipairs({"ERR_CANT_BE_DISENCHANTED", "ITEM_DISENCHANT_NOT_DISENCHANTABLE"}) do
        local value = _G[global]
        if ns.Client.IsPublicString(value) then exact[App.StripColorCodes(value):lower()] = true end
    end
    for _, text in ipairs(Rules.Tooltip(item)) do
        local plain = App.StripColorCodes(text):lower()
        if exact[plain] then return true end
        for _, phrase in ipairs(refusalPhrases) do if plain:find(phrase, 1, true) then return true end end
    end
    return false
end
function Rules.Binding(kind, bound)
    local account = {[App.BIND_ACCOUNT]=true, [App.BIND_BNET]=true, [App.BIND_BNET_UNTIL_EQUIP]=true}
    if account[kind] then return "|cff00ccffWB|r" end
    if kind == App.BIND_ON_EQUIP and not bound then return "|cff1eff00BoE|r" end
    if bound or kind == App.BIND_ON_ACQUIRE then return "|cff9d9d9dBoP|r" end
end
function Rules.EquipmentFloor()
    local candidate
    if not GetInventoryItemLink then return end
    for equipmentSlot = 1, 18 do
        local link = equipmentSlot ~= 4 and GetInventoryItemLink("player", equipmentSlot)
        local level = link and ns.Client.ItemLevel(link) or 0
        if level > 0 then candidate = candidate and math.min(candidate, level) or level end
    end
    return candidate
end
function Rules.Quality(quality)
    local filter = App.db and App.db.qualityFilter
    return type(filter) ~= "table" or filter[quality] ~= false
end
function Rules.Disenchantable(link, quality)
    if not link or type(quality) ~= "number" or quality < 2 or quality > 4 then return false end
    local api = C_Item and C_Item.IsEquippableItem
    local result = api and api(link)
    if not result and IsEquippableItem then result = IsEquippableItem(link) end
    return result and true or false
end
function Rules.LevelProtected(item)
    local settings = App.db or {}
    local limit = settings.ilvlCapEnabled and tonumber(settings.ilvlCap)
    return limit ~= nil and limit ~= false and (item.itemLevel or 0) >= limit
end
function Rules.ValueProtected(item)
    local settings = App.db or {}
    local applies = App.activeMode and App.activeMode.usesItemProtection and settings.priceWarnEnabled
    local limit = applies and tonumber(settings.priceThresholdGold)
    return limit ~= nil and limit ~= false and (item.priceCopper == nil or item.priceCopper >= limit * 10000)
end
function Rules.SetProtected(item) return item.isSet == true end
local safeguards = {
    {key="set", check=Rules.SetProtected},
    {key="level", check=Rules.LevelProtected},
    {key="value", check=Rules.ValueProtected},
}
function Rules.Assess(item)
    local assessment = {reasons={}}
    for _, rule in ipairs(safeguards) do
        if rule.check(item) then
            assessment.reasons[#assessment.reasons + 1] = rule.key
            assessment.primary = assessment.primary or rule.key
        end
    end
    assessment.protected = assessment.primary ~= nil
    return assessment
end
function Rules.Automatic(item)
    return App.activeMode and App.activeMode.usesItemProtection and Rules.Assess(item).protected or false
end
App.GetTooltipLinesForItem, App.TooltipSaysCantDisenchant = Rules.Tooltip, Rules.Refuses
App.GetBindTagText, App.GetLowestEquippedItemLevel = Rules.Binding, Rules.EquipmentFloor
App.IsQualityEnabled, App.IsReasonablyDisenchantable = Rules.Quality, Rules.Disenchantable
App.HasSetSafeguard, App.HasLevelSafeguard, App.HasValueSafeguard = Rules.SetProtected, Rules.LevelProtected, Rules.ValueProtected
App.HasSafeguard = Rules.Automatic

end
LoadComponent("ForeverTools", FT.disenchantry)
