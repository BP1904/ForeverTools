-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Item presentation uses pooled rows and the shared UI layout primitives.
local _, ns = ...
local App, UI = ns.App, ns.UI

local function tooltip(row)
    local item = row.item
    if not item then return end
    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:SetBagItem(item.bag, item.slot)
    if App.activeMode.key == "disenchant" then ns.DisenchantResults.AddTooltip(item) end
    if item.isValuable and item.priceCopper and item.priceSource then
        GameTooltip:AddLine(string.format(App.L.VALUE_TOOLTIP, ns.Prices.FormatGold(item.priceCopper), item.priceSource), 1, 0.82, 0)
    end
    GameTooltip:Show()
end
function App.UpdateStatusText()
    if not App.statusText then return end
    local key = not App.activeMode.isKnown() and (App.activeMode.notLearnedTextKey or "STATUS_NOT_LEARNED")
        or InCombatLockdown() and "STATUS_IN_COMBAT"
    App.statusText:SetText(key and App.L[key] or string.format(App.L.FOUND_COUNT, #App.items))
end
function App.ToggleRowSelection(item)
    if not item then return end
    if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return end
    if App.selected[item.key] then App.selected[item.key] = nil else App.selected[item.key] = true end
    App.ReplanWork()
    App.RefreshUI()
end
local function describe(item)
    local pieces = {item.name or App.L.UNKNOWN}
    if (item.itemLevel or 0) > 0 then pieces[#pieces + 1] = " (ilvl " .. item.itemLevel .. ")" end
    if (item.count or 1) > 1 then pieces[#pieces + 1] = " x" .. item.count end
    return table.concat(pieces)
end
function App.SetListRowItem(row, item)
    row.item = item
    local checked = item and App.selected[item.key] == true or false
    row.checkbox:SetChecked(checked)
    row.icon:SetTexture(item and (item.texture or 134400))
    row.icon:SetDesaturated(item ~= nil and not checked)
    local brightness = item and not checked and 0.45 or 1
    row.icon:SetVertexColor(brightness, brightness, brightness, 1)
    local palette = checked and {0.34, 0.24, 0.08, 0.85} or {0.06, 0.05, 0.04, 0.85}
    row.bg:SetColorTexture(unpack(palette))
    row.label:SetText(item and describe(item) or "")
    UI.Color(row.label, item and item.quality)
    local valuable = item and item.isValuable and item.priceCopper
    row.valueText:SetText(valuable and ns.Prices.FormatGoldIcon(item.priceCopper) or "")
    row.valueText:SetWidth(valuable and 112 or 1)
    row.bindText:SetText(item and App.activeMode.usesItemProtection and item.bindTag or "")
    local preview = item and not App.db.hideDisenchantMaterials and App.activeMode.key == "disenchant" and ns.DisenchantResults.IsSupported()
    ns.DisenchantResults.UpdateStrip(row.resultsStrip, preview and item or nil)
    row.resultsStrip:SetWidth(preview and row.resultsStrip.contentWidth or 1)
end
function App.ClearListRow(row) App.SetListRowItem(row, nil); row:Hide() end
function App.CreateListRow(parent)
    local row = UI.Row(parent, {height=App.ROW_HEIGHT, clickable=true,
        highlight="Interface\\QuestFrame\\UI-QuestTitleHighlight", background={0.06, 0.05, 0.04, 0.85}})
    row.checkbox = UI.Check(row, "", {{"LEFT", 0, 0}}, function() App.ToggleRowSelection(row.item) end)
    row.checkbox:SetSize(22, 22)
    row.iconBorder, row.icon = UI.Icon(row, 24, {{"LEFT", row.checkbox, "RIGHT", 4, 0}})
    row.iconBorder:SetFrameLevel(row:GetFrameLevel() + 1)
    row.bindText = UI.Text(row, "", nil, {{"RIGHT", row, "RIGHT", -8, 0}}, 56)
    row.valueText = UI.Text(row, "", nil, {{"RIGHT", row.bindText, "LEFT", -6, 0}}, 112)
    for _, label in ipairs({row.bindText, row.valueText}) do label:SetJustifyH("RIGHT") end
    row.valueText:SetTextColor(1, 0.82, 0)
    row.resultsStrip = ns.DisenchantResults.CreateStrip(row)
    UI.Anchor(row.resultsStrip, {{"RIGHT", row.valueText, "LEFT", -6, 0}})
    row.label = UI.Text(row, "", "GameFontNormal", {{"LEFT", row.iconBorder, "RIGHT", 8, 0}, {"RIGHT", row.resultsStrip, "LEFT", -8, 0}})
    row.label:SetWordWrap(false)
    row:SetScript("OnClick", function() App.ToggleRowSelection(row.item) end)
    UI.BindTooltip(row, tooltip)
    return row
end
function App.UpdateListRows()
    if App.listScrollFrame then
        UI.RenderRows(App.listRows, App.items, App.listScrollFrame, App.listScrollChild,
            App.ROW_HEIGHT + App.ROW_SPACING, App.CreateListRow, App.SetListRowItem)
    end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
