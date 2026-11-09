-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- The compact view renders a small presentation model of the queue head.
local _, ns = ...
local App, UI = ns.App, ns.UI

function App.GetCompactSkippedText()
    local count = ns.GetValuableSkippedCount()
    if count == 0 then return end
    return count == 1 and App.L.COMPACT_SKIPPED_ONE or string.format(App.L.COMPACT_SKIPPED_MANY, count)
end
local function content()
    local item, mode = App.queue[1], App.activeMode
    local skipped = App.GetCompactSkippedText()
    local title = item and (item.name or App.L.UNKNOWN) or App.L[mode.emptyTextKey]
    if item and mode.usesItemProtection and item.bindTag then title = title .. "  " .. item.bindTag end
    local counter = item and string.format(App.L[mode.queueTextKey], #App.queue) or ""
    if skipped then counter = counter == "" and skipped or counter .. "  |  " .. skipped end
    return {item=item, title=title, counter=counter,
        icon=item and (item.texture or 134400) or mode.icon() or 134400,
        preview=item and not App.db.hideDisenchantMaterials and mode.key == "disenchant" and ns.DisenchantResults.IsSupported()}
end
function App.UpdateCompactFrame()
    local bar = App.compactFrame
    if not bar or not bar:IsShown() then return end
    local model = content()
    bar.currentItem = model.item
    App.compactNameText:SetText(model.title)
    App.compactQueueText:SetText(model.counter)
    App.compactIcon:SetTexture(model.icon)
    UI.Color(App.compactNameText, model.item and model.item.quality, model.item and {1, 1, 1} or {0.7, 0.7, 0.7})
    ns.DisenchantResults.UpdateStrip(App.compactResultsStrip, model.preview and model.item or nil)
    App.compactSkipButton:SetEnabled(model.item ~= nil and not InCombatLockdown())
    if InCombatLockdown() then return end
    local extra = App.compactModeSelector:IsShown() and 98 or 0
    local text = math.max(App.compactNameText:GetStringWidth(), App.compactQueueText:GetStringWidth())
    local fit = math.min(620 + extra, math.floor(text + 0.5) + 310 + extra)
    local materials = model.preview and App.compactResultsStrip.contentWidth + 84 or 0
    bar:SetSize(math.max(460 + extra, fit, materials), model.preview and 82 or 58)
end
local function savePosition(bar)
    if InCombatLockdown() then
        App.pendingDragStops=App.pendingDragStops or {}; App.pendingDragStops[bar]=savePosition
        return
    end
    bar:StopMovingOrSizing()
    local anchor, _, relative, horizontal, vertical = bar:GetPoint()
    App.db.compactPoint = {point=anchor, relPoint=relative, x=horizontal, y=vertical}
end
local function inspect(icon)
    local item = App.compactFrame.currentItem
    if not item then return end
    GameTooltip:SetOwner(icon, "ANCHOR_TOP")
    GameTooltip:SetBagItem(item.bag, item.slot)
    if App.activeMode.key == "disenchant" then ns.DisenchantResults.AddTooltip(item) end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(App.L[App.activeMode.blacklistHintKey], 0.6, 0.8, 1)
    GameTooltip:Show()
end
function App.CreateCompactFrame()
    local bar = UI.Surface(UIParent, "window", {name="ForeverToolsDisenchantry_CompactFrame", width=460, height=58,
        template="SecureHandlerShowHideTemplate"})
    App.compactFrame = bar
    local position = App.db.compactPoint or {x=0, y=-220}
    UI.Anchor(bar, {{position.point or "CENTER", UIParent, position.relPoint or "CENTER", position.x or 0, position.y or 0}})
    for _, method in ipairs({"SetMovable", "EnableMouse", "SetClampedToScreen"}) do bar[method](bar, true) end
    bar:RegisterForDrag("LeftButton")
    bar:SetScript("OnDragStart", function() if not InCombatLockdown() then bar:StartMoving() end end)
    bar:SetScript("OnDragStop", savePosition)
    bar:Hide()
    local close = CreateFrame("Button", "ForeverToolsDisenchantryCompactClose", bar, "UIPanelCloseButton,SecureHandlerClickTemplate")
    UI.Anchor(close, {{"TOPRIGHT", 2, 2}})
    close:SetScale(0.7)
    close:RegisterForClicks("AnyUp")
    close:SetFrameRef("window",bar)
    close:SetAttribute("_onclick",[[
        self:GetFrameRef("window"):Hide()
        local keys=self:GetFrameRef("keys")
        if keys and keys:GetAttribute("active") then keys:RunAttribute("apply") end
    ]])
    bar.CloseButton=close
    bar:SetFrameRef("close",close)
    bar:SetAttribute("_onshow",[[self:SetBindingClick(true,"ESCAPE",self:GetFrameRef("close"):GetName(),"LeftButton")]])
    bar:SetAttribute("_onhide",[[
        self:ClearBindings()
        local menu=self:GetFrameRef("modeMenu")
        if menu then menu:Hide() end
    ]])
    if AntiFettFinger and AntiFettFinger.RegisterEscapeCloser then AntiFettFinger:RegisterEscapeCloser(close) end
    local icon
    icon, App.compactIcon = UI.Icon(bar, 30, {{"TOPLEFT", 42, -10}})
    icon:EnableMouse(true)
    UI.BindTooltip(icon, inspect)
    icon:SetScript("OnMouseUp", function(owner, mouse)
        if mouse == "RightButton" and bar.currentItem then
            UI.DismissTooltip(owner)
            App.AddItemToBlacklist(bar.currentItem, App.L.ADDED_MANUAL)
        end
    end)
    App.compactFullButton = UI.Button(bar, {key="FULL_BUTTON", width=48, height=20,
        points={{"RIGHT", close, "LEFT", -6, 0}}, compactDestination=false})
    local statistics = UI.Button(bar, {key="STATS_BUTTON", width=90, height=20,
        points={{"RIGHT", App.compactFullButton, "LEFT", -6, 0}}, click=ns.Statistics.Toggle})
    App.compactMaterialsButton = UI.Button(bar, {width=58, height=20,
        points={{"RIGHT", statistics, "LEFT", -6, 0}}, click=App.ToggleDisenchantMaterials, hint=App.L.TOGGLE_MATERIALS_HINT})
    App.compactPreviousButton = UI.Button(bar, {text="<", width=28, height=32,
        points={{"LEFT", bar, "LEFT", 8, 0}}, click=function() App.CycleQueuedItem(-1) end, hint=App.L.PREVIOUS_ITEM})
    App.compactNextButton = UI.Button(bar, {text=">", width=28, height=32,
        points={{"RIGHT", bar, "RIGHT", -8, 0}}, click=function() App.CycleQueuedItem(1) end, hint=App.L.NEXT_ITEM})
    for _, arrow in ipairs({App.compactPreviousButton, App.compactNextButton}) do
        arrow:GetFontString():SetFontObject("GameFontNormalLarge")
    end
    App.compactBlacklistButton = UI.Button(bar, {key="BLACKLIST_ITEM_BUTTON", width=80, height=20,
        points={{"TOPRIGHT", bar, "TOPRIGHT", -42, -25}}, click=function()
            if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return end
            if UnitCastingInfo("player") or UnitChannelInfo("player") then return end
            local item = App.queue[1]
            if item then App.AddItemToBlacklist(item, App.L.ADDED_MANUAL) end
        end})
    App.compactSkipButton = UI.Button(bar, {key="SKIP_BUTTON", width=58, height=20,
        points={{"RIGHT", App.compactBlacklistButton, "LEFT", -6, 0}}, click=App.SkipQueuedItem, hint=App.L.SKIP_HINT})
    App.compactModeSelector = UI.Button(bar, {width=90, height=20,
        points={{"TOPRIGHT", bar, "TOPRIGHT", -298, -25}}, hint=App.L.MODE_SWITCH_HINT, click=function()
            if InCombatLockdown() then App.Print(App.L.MODE_CHANGE_IN_COMBAT or App.L.NOT_IN_COMBAT); return end
            local menu = App.compactModeMenu
            menu:SetShown(not menu:IsShown())
            if menu:IsShown() then menu:Raise() end
        end})
    App.CreateCompactModeMenu()
    bar:SetFrameRef("modeMenu",App.compactModeMenu)
    UI.Anchor(App.compactModeMenu, {{"BOTTOMRIGHT", App.compactModeSelector, "TOPRIGHT", 0, 6}})
    App.compactNameText = UI.Text(bar, "", "GameFontNormal",
        {{"TOPLEFT", icon, "TOPRIGHT", 8, -2}, {"RIGHT", bar, "RIGHT", -254, 0}})
    App.compactNameText:SetWordWrap(false)
    App.compactQueueText = UI.Text(bar, "", nil,
        {{"BOTTOMLEFT", icon, "BOTTOMRIGHT", 8, 2}, {"RIGHT", bar, "RIGHT", -298, 0}})
    App.compactQueueText:SetTextColor(0.75, 0.75, 0.75)
    App.compactResultsStrip = ns.DisenchantResults.CreateStrip(bar)
    UI.Anchor(App.compactResultsStrip, {{"TOPLEFT", bar, "TOPLEFT", 42, -50}})
    bar:HookScript("OnHide", function()
        ns.Queue.EndSession()
        if not InCombatLockdown() then App.compactModeMenu:Hide() end
    end)
    App.UpdateModeSurface()
end

end
LoadComponent("ForeverTools", FT.disenchantry)
