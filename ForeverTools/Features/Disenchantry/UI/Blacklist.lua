-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- The blacklist window is a view over the active profession's exclusion set.
local _, ns = ...
local App, UI = ns.App, ns.UI
local function displayEntry(key)
    local reference = tonumber(key) and "item:" .. key or tostring(key)
    local name, link, quality, _, _, _, _, _, _, icon = App.GetItemInfoSafe(reference)
    local title = App.GetDisplayName(name, link or reference)
    if title == App.L.UNKNOWN_ITEM or title == "" then title = tostring(key) end
    return {key=key, link=link or reference, name=title, quality=quality, texture=icon or 134400}
end
function App.GetBlacklistEntries()
    local entries = {}
    if not App.db then return entries end
    for key, blocked in pairs(App.ExclusionBook()) do
        if blocked then table.insert(entries, displayEntry(key)) end
    end
    table.sort(entries, function(left, right) return left.name < right.name end)
    return entries
end
local function remove(row)
    local entry = row.entry
    if not entry then return end
    App.ExclusionBook()[entry.key] = nil
    App.Print(string.format(App.L.REMOVED_FROM_BLACKLIST, entry.name))
    App.RefreshBlacklistUI()
    App.RefreshWorkspace()
end
function App.CreateBlacklistRow(canvas)
    local row = UI.Row(canvas, {height=26, clickable=true})
    row.iconBorder, row.icon = UI.Icon(row, 20, {{"LEFT", 0, 0}})
    row.label = UI.Text(row, "", nil, {{"LEFT", row.iconBorder, "RIGHT", 6, 0}, {"RIGHT", row, "RIGHT", -70, 0}})
    row.label:SetWordWrap(false)
    row.removeButton = UI.Button(row, {width=56, height=20, key="DELETE", points={{"RIGHT", row, "RIGHT", -2, 0}}, click=function() remove(row) end})
    UI.BindTooltip(row, function()
        if not row.entry then return end
        GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(row.entry.link)
        GameTooltip:Show()
    end)
    return row
end
local function paint(row, entry)
    row.entry = entry
    if not entry then row.icon:SetTexture(nil); row.label:SetText(""); return end
    row.icon:SetTexture(entry.texture)
    row.label:SetText(entry.name)
    local color = UI.Color(row.label, entry.quality)
    local frameColor = entry.quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[entry.quality] and color or {0.3, 0.3, 0.3}
    row.iconBorder:SetBackdropBorderColor(frameColor[1], frameColor[2], frameColor[3], 1)
end
function App.RefreshBlacklistUI()
    if not App.blacklistScrollFrame then return end
    local entries = App.GetBlacklistEntries()
    UI.RenderRows(App.blacklistRows, entries, App.blacklistScrollFrame, App.blacklistScrollChild, 28, App.CreateBlacklistRow, paint)
    App.blacklistEmptyText:SetShown(#entries == 0)
end
function App.ToggleBlacklistFrame()
    local points = App.mainFrame and App.mainFrame:IsShown()
        and {{"TOPLEFT", App.mainFrame, "TOPRIGHT", 20, -12}} or {{"CENTER", UIParent, "CENTER", 300, 0}}
    UI.Toggle(App.blacklistFrame, points, App.RefreshBlacklistUI)
end
function App.CreateBlacklistFrame()
    local window = App.CreateStyledWindow("ForeverToolsDisenchantry_BlacklistFrame", 500, 420)
    App.blacklistFrame = window
    UI.Anchor(window, {{"CENTER", UIParent, "CENTER", 300, 0}})
    window:Hide()
    window.title:SetText(App.L.BLACKLIST_TITLE)
    window:SetScript("OnShow", function() App.RaiseAddonWindows(window) end)
    local intro = UI.Text(window, App.L.BLACKLIST_SUBTITLE, nil, {{"TOPLEFT", 16, -38}})
    intro:SetTextColor(0.7, 0.7, 0.7)
    App.blacklistScrollFrame, App.blacklistScrollChild = UI.Scroll(window, {{"TOPLEFT", 12, -56}, {"BOTTOMRIGHT", -30, 44}})
    App.blacklistEmptyText = UI.Text(window, App.L.BLACKLIST_EMPTY, "GameFontDisable", {{"TOPLEFT", App.blacklistScrollFrame, "TOPLEFT", 4, -4}})
    UI.Button(window, {width=110, key="CLEAR_ALL", points={{"BOTTOMRIGHT", window, "BOTTOMRIGHT", -12, 12}}, click=function()
        wipe(App.ExclusionBook())
        App.Print(App.L.BLACKLIST_CLEARED)
        App.RefreshBlacklistUI()
        App.RefreshWorkspace()
    end})
end

end
LoadComponent("ForeverTools", FT.disenchantry)
