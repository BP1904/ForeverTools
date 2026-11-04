-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local ADDON_NAME, ns = ...
local App = ns.App
local failurePatterns = {
    hard = {"cannot be disenchanted", "can not be disenchanted"},
    generic = {"not a valid target", "invalid target", "kein gültiges ziel", "ungueltiges ziel", "ungültiges ziel"},
}
function App.ClassifyDisenchantFailure(message)
    if not ns.Client.IsPublicString(message) then return end
    local text = App.StripColorCodes(message):lower()
    for global, result in pairs({ERR_CANT_BE_DISENCHANTED="hard", ERR_INVALID_ITEM_TARGET="generic"}) do
        local value = _G[global]
        if ns.Client.IsPublicString(value) and text == value:lower() then return result end
    end
    for result, patterns in pairs(failurePatterns) do
        for _, pattern in ipairs(patterns) do
            if (result == "hard" and (text == pattern or text == pattern .. "."))
                or (result ~= "hard" and text:find(pattern, 1, true)) then return result end
        end
    end
    for _, language in ipairs({{"disenchant", "cannot", "can't", "cant", "not"}, {"entzauber", "nicht", "kein", "kann"}}) do
        if text:find(language[1], 1, true) then
            for index = 2, #language do if text:find(language[index], 1, true) then return "generic" end end
        end
    end
end

local function descriptor(key, id, verb, eligible, protected)
    local material = key ~= "disenchant"
    local suffix = material and "_" .. string.upper(key) or ""
    return {
        key = key,
        spellID = id,
        minStack = material and 5 or 1,
        usesItemProtection = protected,
        buttonTextKey = verb,
        countTextKey = verb .. "_COUNT",
        modeNameKey = "MODE_" .. string.upper(key),
        subtitleTextKey = "SUBTITLE" .. suffix,
        emptyTextKey = "COMPACT_EMPTY" .. suffix,
        notLearnedTextKey = material and "MODE_NOT_LEARNED_HINT" or "STATUS_NOT_LEARNED",
        queueNotLearnedKey = material and "MODE_NOT_LEARNED_HINT" or "QUEUE_NOT_LEARNED",
        blacklistHintKey = "COMPACT_BLACKLIST_HINT" .. suffix,
        queueTextKey = "COMPACT_QUEUE" .. suffix,
        spellName = function()
            return App.GetSpellNameSafe(id)
        end,
        icon = function()
            return App.GetSpellTextureSafe(id)
        end,
        isKnown = function()
            return App.PlayerKnowsSpellID(id)
        end,
        isAvailable = function()
            return (not material or App.IS_NON_RETAIL_CLIENT) and App.GetSpellNameSafe(id) ~= nil
        end,
        scanEligible = eligible,
        classifyFailure = material and function()

        end or App.ClassifyDisenchantFailure,
    }
end
local disenchant = descriptor("disenchant", App.SPELL_ID_DISENCHANT, "DISENCHANT", function(link, quality)
    return App.IsReasonablyDisenchantable(link, quality) and App.IsQualityEnabled(quality)
end, true)
local milling = descriptor("milling", App.SPELL_ID_MILLING, "MILL", App.IsMillableHerb, false)
local prospecting = descriptor("prospecting", App.SPELL_ID_PROSPECTING, "PROSPECT", App.IsProspectableOre, false)
ns.Modes = {
    list = {
        disenchant,
        milling,
        prospecting,
    },
    byKey = {
    },
    default = disenchant,
}
for _, mode in ipairs(ns.Modes.list) do
    ns.Modes.byKey[mode.key] = mode
end
App.DISENCHANT_MODE, App.MILLING_MODE, App.PROSPECTING_MODE = disenchant, milling, prospecting
function App.SupportsProfession(mode)
    return mode ~= nil and (mode.isAvailable == nil or mode.isAvailable())
end
function App.AvailableProfessions()
    local result = {}
    for _, entry in ipairs(ns.Modes.list) do if App.SupportsProfession(entry) then table.insert(result, entry) end end
    return result
end
function App.ResolveProfession(key)
    local wanted = ns.Modes.byKey[key]
    if App.SupportsProfession(wanted) then return wanted end
    return App.AvailableProfessions()[1] or ns.Modes.default
end
function App.ActivateProfession(key)
    local resolved = App.ResolveProfession(key)
    App.activeMode = resolved
    if App.db then App.db.activeMode = resolved.key end
    return resolved
end
function App.ChooseProfession(key)
    if InCombatLockdown() then App.Print(App.L.MODE_CHANGE_IN_COMBAT or App.L.NOT_IN_COMBAT); return App.activeMode, false end
    local requested = ns.Modes.byKey[key]
    if not App.SupportsProfession(requested) then return App.activeMode, false end
    if requested ~= App.activeMode then
        App.ClearPendingDisenchant()
        App.pendingLootUntil, App.nextAllowedQueueClickAt = 0, 0
        App.ActivateProfession(key)
        wipe(App.selected)
        if App.RefreshWorkspace then App.RefreshWorkspace() end
        if App.blacklistFrame and App.blacklistFrame:IsShown() then App.RefreshBlacklistUI() end
    end
    return App.activeMode, true
end
App.activeMode = ns.Modes.default
ns.Modes.GetActive = function() return App.activeMode end
ns.Modes.GetAvailable, ns.Modes.SetActive = App.AvailableProfessions, App.ChooseProfession

end
LoadComponent("ForeverTools", FT.disenchantry)
