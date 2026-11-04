-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Main-window composition. Button order and placement are declared together.
local _, ns = ...
local App, UI = ns.App, ns.UI

local function button(parent, definition, previous, title)
    local control = App.CreateStyledButton(parent, definition.secure, definition.name)
    control:SetSize(definition.width, definition.secure and 24 or 22)
    control:SetText(App.L[definition.label])
    if previous then control:SetPoint("RIGHT", previous, "LEFT", -8, 0)
    else control:SetPoint("RIGHT", title and parent.TitleBar or parent, "RIGHT", title and -26 or 0, 0) end
    if title then control:SetFrameLevel(parent:GetFrameLevel() + 10) end
    if definition.click then control:SetScript("OnClick", definition.click) end
    if definition.compactDestination ~= nil then
        control.compactDestination = definition.compactDestination
        control:SetScript("OnClick", UI.OpenView)
    end
    return control
end
local function closeChildren()
    ns.Queue.EndSession()
    for _, name in ipairs({"blacklistFrame", "settingsFrame"}) do
        local child = App[name]
        if child and child:IsShown() then child:Hide() end
    end
end
local function changeSelection(all)
    wipe(App.selected)
    if all then for _, item in ipairs(App.items) do App.selected[item.key] = true end end
    App.ReplanWork()
    App.RefreshUI()
end

function App.CreateMainFrame()
    local window = App.CreateStyledWindow("ForeverToolsDisenchantry_MainFrame", 820, 460, "SecureHandlerStateTemplate")
    App.mainFrame = window
    App.InstallCombatVisibility()
    window:SetPoint("CENTER")
    window:Hide()
    window.title:SetText("Disenchantry")
    window.RefreshUI = App.RefreshUI
    window:SetScript("OnHide", closeChildren)
    App.mainSubtitle = UI.Text(window, "", nil, {{"TOPLEFT", 16, -38}})
    App.mainSubtitle:SetTextColor(0.7, 0.7, 0.7)
    App.CreateModeTabs()

    local panel = UI.Surface(window, "list")
    App.listPanel = panel
    local footer = CreateFrame("Frame", nil, panel)
    footer:SetPoint("BOTTOMLEFT", 8, 8)
    footer:SetPoint("BOTTOMRIGHT", -8, 8)
    footer:SetHeight(24)
    App.listScrollFrame, App.listScrollChild = UI.Scroll(panel,
        {{"TOPLEFT", 8, -8}, {"BOTTOMRIGHT", footer, "TOPRIGHT", -22, 8}})

    local footerButtons = {
        {field="manualBlacklistButton", label="BLACKLIST_ITEM_BUTTON", width=92, click=function()
            local item = App.queue[1]
            if item then App.AddItemToBlacklist(item, App.L.ADDED_MANUAL) else App.Print(App.L.NO_QUEUE_ITEM) end
        end},
        {field="mainSkipButton", label="SKIP_BUTTON", width=92, click=App.SkipQueuedItem},
        {label="REFRESH", width=86, click=App.RefreshWorkspace},
        {label="CLEAR_SELECTION", width=120, click=function() changeSelection(false) end},
        {field="mainSelectAllButton", label="SELECT_ALL", width=110, click=function() changeSelection(true) end},
        {field="queueButton", label=App.activeMode.buttonTextKey, width=138, secure=true, name="ForeverToolsDisenchantry_QueueAction"},
    }
    local previous
    for _, definition in ipairs(footerButtons) do
        local control = button(footer, definition, previous)
        if definition.field then App[definition.field] = control end
        previous = control
    end
    App.queueButtonText = App.queueButton:GetFontString()
    App.InstallActionCombatGuard()
    App.SyncClickPolicy()
    App.queueButton:SetScript("PreClick", ns.Action.BeforeClick)
    UI.Hint(App.mainSkipButton, App.L.SKIP_HINT)
    -- Keep status anchored to this window: the action moves to the compact view.
    App.statusText = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    App.statusText:SetPoint("TOPRIGHT", window, "TOPRIGHT", -16, -38)
    App.statusText:SetWidth(240)
    App.statusText:SetJustifyH("RIGHT")
    App.statusText:SetWordWrap(false)

    local headerButtons = {
        {field="blacklistOpenButton", label="OPEN_BLACKLIST", width=128, click=App.ToggleBlacklistFrame},
        {label="COMPACT_BUTTON", width=80, compactDestination=true},
        {label="STATS_BUTTON", width=100, click=ns.Statistics.Toggle},
        {field="mainMaterialsButton", label="HIDE_MATERIALS", width=64, click=App.ToggleDisenchantMaterials},
        {label="SETTINGS_BUTTON", width=80, click=App.ToggleSettingsFrame},
    }
    previous = nil
    for _, definition in ipairs(headerButtons) do
        local control = button(window, definition, previous, true)
        if definition.field then App[definition.field] = control end
        previous = control
    end
    panel:SetScript("OnSizeChanged", App.UpdateListRows)
    App.CreateBlacklistFrame()
    App.UpdateModeSurface()
end

end
LoadComponent("ForeverTools", FT.disenchantry)
