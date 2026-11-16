-- Embedded from Disenchantry 1.2.5 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Diagnostics produce structured results that can be printed or copied.
local addonName, ns = ...
local App, UI, Diagnostics = ns.App, ns.UI, {}
ns.Diagnostics = Diagnostics

function App.ShowInspection(report)
    local dialog = App.checkCopyFrame
    if not dialog then
        dialog = App.CreateStyledWindow("ForeverToolsDisenchantry_CheckFrame", 500, 420)
        App.checkCopyFrame = dialog
        UI.Anchor(dialog, {{"CENTER"}})
        dialog:SetFrameStrata("DIALOG")
        dialog.title:SetText(App.L.CHECK_TITLE)
        local help = UI.Text(dialog, App.L.CHECK_COPY_HINT, nil, {{"TOPLEFT", 16, -40}, {"RIGHT", dialog, "RIGHT", -16, 0}})
        help:SetTextColor(0.7, 0.7, 0.7)
        dialog.scroll, dialog.canvas = UI.Scroll(dialog, {{"TOPLEFT", 14, -62}, {"BOTTOMRIGHT", -32, 14}})
        dialog.edit = CreateFrame("EditBox", nil, dialog.canvas)
        UI.Anchor(dialog.edit, {{"TOPLEFT", 0, 0}})
        dialog.edit:SetWidth(440)
        dialog.edit:SetMultiLine(true)
        dialog.edit:SetFontObject(ChatFontNormal)
        dialog.edit:SetAutoFocus(false)
        dialog.edit:EnableMouse(true)
        dialog.edit:SetScript("OnEscapePressed", function(self) self:ClearFocus(); dialog:Hide() end)
    end
    local _, breaks = report:gsub("\n", "\n")
    local height = math.max(1, (breaks + 1) * 16)
    dialog.canvas:SetSize(440, height)
    dialog.edit:SetHeight(height)
    dialog.edit:SetText(report)
    dialog:Show(); dialog:Raise()
    dialog.edit:HighlightText(); dialog.edit:SetFocus()
end
function Diagnostics.Collect()
    local results = {}
    local L = App.L
    local function state(value)
        if value == nil then return L.UNKNOWN end
        if type(value) == "boolean" then return value and L.DIAG_ENABLED or L.DIAG_DISABLED end
        return tostring(value)
    end
    local function add(name, passes, detail)
        results[#results + 1] = {name=name, ok=not not passes, detail=detail}
    end
    local game, build, _, interface = GetBuildInfo()
    add(L.DIAG_CLIENT, true, tostring(game) .. " / " .. tostring(build) .. " / " .. tostring(interface))
    add(L.DIAG_LOCALE, L.DISENCHANT, GetLocale())
    add(L.DIAG_LIBRARIES, LibStub ~= nil)
    add(L.DIAG_BROKER, LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true) ~= nil)
    add(L.DIAG_MINIMAP, App.libDBIcon ~= nil)
    add(L.DIAG_BAGS, C_Container and C_Container.GetContainerItemInfo ~= nil)
    add(L.DIAG_EQUIPMENT, C_Item and C_Item.IsEquippableItem or IsEquippableItem)
    add(L.DIAG_IDENTITY, true, C_Item and C_Item.GetItemGUID and "GUID" or L.DIAG_SLOT_FALLBACK)
    add(L.DIAG_COVERAGE, true, string.format(L.DIAG_BAG_DETAIL, #App.BAGS_TO_SCAN, state(App.REAGENT_BAG)))
    add("ForeverToolsDisenchantryDB", type(ForeverToolsDisenchantryDB) == "table" and type(App.db) == "table")
    if App.db then
        local blocked = 0
        for _ in pairs(App.ExclusionBook()) do blocked = blocked + 1 end
        add(L.DIAG_PROTECTION, true, string.format(L.DIAG_PROTECTION_DETAIL,
            state(App.db.ilvlCapEnabled), state(App.db.ilvlCap), blocked, state(App.db.compactMode)))
    end
    for _, entry in ipairs({{"mainFrame", "FULL_BUTTON"}, {"compactFrame", "COMPACT_BUTTON"},
        {"settingsFrame", "SETTINGS_TITLE"}, {"blacklistFrame", "BLACKLIST_TITLE"}}) do add(L[entry[2]], App[entry[1]] ~= nil) end
    local providers = {}
    for _, source in ipairs(ns.Prices.GetProviderStatus()) do if source.available then table.insert(providers, source.label) end end
    add(L.DIAG_MARKET, not App.db or not App.db.priceWarnEnabled or #providers > 0,
        (#providers > 0 and table.concat(providers, ", ") or L.DIAG_NO_SOURCE) .. "; "
        .. string.format(L.DIAG_THRESHOLD, state(App.db and App.db.priceThresholdGold)))
    local modes = App.AvailableProfessions()
    add(L.DIAG_PROFESSIONS, #modes > 0)
    for _, mode in ipairs(modes) do add(string.format(L.DIAG_SPELL, App.GetModeName(mode)), mode.spellName() ~= nil) end
    add(L.DIAG_LEARNED, App.activeMode and App.activeMode.isKnown(), App.activeMode and App.GetModeName(App.activeMode))
    local expected = GetCVarBool and GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp"
    add(L.DIAG_CLICKS, App.queueButton and App.queueButton.clickEdge == expected, expected)
    if InCombatLockdown() then add(L.DIAG_REFRESH, false, L.DIAG_DEFERRED)
    else
        App.DiscoverCandidates(); App.SyncActionTarget()
        add(L.DIAG_REFRESH, true, string.format(L.DIAG_CANDIDATES, #App.items, #App.queue))
        local item, action = App.queue[1], App.queueButton
        local armed = not item or action and action:GetAttribute("type") == "spell"
            and action:GetAttribute("target-bag") == item.bag and action:GetAttribute("target-slot") == item.slot
        add(L.DIAG_TARGET, armed, item and item.name or L.QUEUE_EMPTY)
    end
    return results
end
function App.InspectWorkspace(copy)
    local metadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
    local version = metadata and metadata(addonName, "Version") or "?"
    local text, failed = {App.L.DIAG_HEADER .. " " .. version}, false
    for _, result in ipairs(Diagnostics.Collect()) do
        local row = "[" .. (result.ok and App.L.DIAG_OK or App.L.DIAG_FAIL) .. "] " .. result.name
        if result.detail then row = row .. ": " .. tostring(result.detail) end
        text[#text + 1] = row
        App.Print(row)
        failed = failed or not result.ok
    end
    if copy or failed then App.ShowInspection(table.concat(text, "\n")) else App.Print(App.L.CHECK_ALL_OK) end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
