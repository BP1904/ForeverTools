-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
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
    local function add(name, passes, detail)
        results[#results + 1] = {name=name, ok=not not passes, detail=detail}
    end
    local game, build, _, interface = GetBuildInfo()
    add("Client", true, tostring(game) .. "; build=" .. tostring(build) .. "; interface=" .. tostring(interface))
    add("Locale", App.L and App.L.DISENCHANT, GetLocale())
    add("Library registry", LibStub ~= nil)
    add("Launcher broker", LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true) ~= nil)
    add("Minimap library", App.libDBIcon ~= nil)
    add("Bag API", C_Container and C_Container.GetContainerItemInfo ~= nil)
    add("Equipment API", C_Item and C_Item.IsEquippableItem or IsEquippableItem)
    add("Item identity", true, C_Item and C_Item.GetItemGUID and "instance GUID" or "bag/slot fallback")
    add("Bag coverage", true, #App.BAGS_TO_SCAN .. " containers; reagent=" .. tostring(App.REAGENT_BAG))
    add("ForeverToolsDisenchantryDB", App.db == ForeverToolsDisenchantryDB and type(App.db) == "table")
    if App.db then
        local blocked = 0
        for _ in pairs(App.ExclusionBook()) do blocked = blocked + 1 end
        add("Protection settings", true, "ilvl=" .. tostring(App.db.ilvlCapEnabled) .. "/" .. tostring(App.db.ilvlCap)
            .. "; exclusions=" .. blocked .. "; compact=" .. tostring(App.db.compactMode))
    end
    for _, key in ipairs({"mainFrame", "compactFrame", "settingsFrame", "blacklistFrame"}) do add(key, App[key] ~= nil) end
    local providers = {}
    for _, source in ipairs(ns.Prices.GetProviderStatus()) do if source.available then table.insert(providers, source.label) end end
    add("Market data", not App.db or not App.db.priceWarnEnabled or #providers > 0,
        (#providers > 0 and table.concat(providers, ", ") or "no source") .. "; threshold=" .. tostring(App.db and App.db.priceThresholdGold))
    local modes = App.AvailableProfessions()
    add("Profession support", #modes > 0)
    for _, mode in ipairs(modes) do add("Spell: " .. mode.key, mode.spellName() ~= nil) end
    add("Learned profession", App.activeMode and App.activeMode.isKnown(), App.activeMode and App.activeMode.key)
    local expected = GetCVarBool and GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp"
    add("Click registration", App.queueButton and App.queueButton.clickEdge == expected, expected)
    if InCombatLockdown() then add("Inventory refresh", false, "deferred during combat")
    else
        App.DiscoverCandidates(); App.SyncActionTarget()
        add("Inventory refresh", true, #App.items .. " candidates; " .. #App.queue .. " queued")
        local item, action = App.queue[1], App.queueButton
        local armed = not item or action and action:GetAttribute("type") == "spell"
            and action:GetAttribute("target-bag") == item.bag and action:GetAttribute("target-slot") == item.slot
        add("Action target", armed, item and item.name or "empty queue")
    end
    return results
end
function App.InspectWorkspace(copy)
    local metadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
    local version = metadata and metadata(addonName, "Version") or "?"
    local text, failed = {"Disenchantry diagnostics " .. version}, false
    for _, result in ipairs(Diagnostics.Collect()) do
        local row = (result.ok and "[OK] " or "[FAIL] ") .. result.name
        if result.detail then row = row .. ": " .. tostring(result.detail) end
        text[#text + 1] = row
        App.Print(row)
        failed = failed or not result.ok
    end
    if copy or failed then App.ShowInspection(table.concat(text, "\n")) else App.Print(App.L.CHECK_ALL_OK) end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
