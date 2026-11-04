-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Window transitions coordinate the shared secure button and queue lifecycle.
local _, ns = ...
local App = ns.App
local function dock(parent, neighbor, gap, width)
    if InCombatLockdown() or not App.queueButton or not parent or not neighbor then return end
    local action = App.queueButton
    action:ClearAllPoints()
    action:SetParent(parent)
    action:SetPoint("RIGHT", neighbor, "LEFT", -gap, 0)
    action:SetSize(width, 24)
end
function App.DockQueueButtonToCompact() dock(App.compactFrame, App.compactSkipButton, 6, 100) end
function App.DockQueueButtonToPanel()
    local neighbor = App.mainSelectAllButton
    dock(neighbor and neighbor:GetParent(), neighbor, 8, 138)
end
function App.UpdateLayout()
    if not App.listPanel or not App.mainFrame then return end
    local inset = App.modeTabFrame and App.modeTabFrame:IsShown() and 82 or 56
    App.listPanel:ClearAllPoints()
    for _, point in ipairs({{"TOPLEFT", App.mainFrame, "TOPLEFT", 16, -inset},
        {"BOTTOMLEFT", App.mainFrame, "BOTTOMLEFT", 16, 16}, {"RIGHT", App.mainFrame, "RIGHT", -16, 0}}) do
        App.listPanel:SetPoint(unpack(point))
    end
end
function App.ToggleDisenchantMaterials()
    if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return end
    App.db.hideDisenchantMaterials = not App.db.hideDisenchantMaterials
    GameTooltip:Hide()
    App.RefreshUI()
end
function App.RefreshUI()
    if not App.mainFrame then return end
    local display = App.settingsControls and App.settingsControls.disenchantDisplay
    if display then for key, check in pairs(display) do check:SetChecked(not App.db[key]) end end
    local materialsLabel = App.L[App.db.hideDisenchantMaterials and "SHOW_MATERIALS" or "HIDE_MATERIALS"]
    for _, field in ipairs({"mainMaterialsButton", "compactMaterialsButton", "settingsMaterialsButton"}) do
        if App[field] then App[field]:SetText(materialsLabel) end
    end
    for _, field in ipairs({"compactPreviousButton", "compactNextButton"}) do
        if App[field] then App[field]:SetEnabled(#App.queue > 1 and not InCombatLockdown()) end
    end
    App.UpdateModeSurface()
    if not InCombatLockdown() then App.UpdateLayout() end
    for _, render in ipairs({App.UpdateListRows, App.UpdateStatusText, App.SyncActionTarget, App.UpdateCompactFrame, ns.Hotkeys.Update}) do render() end
    if App.mainSkipButton then App.mainSkipButton:SetEnabled(#App.queue > 0 and not InCombatLockdown()) end
end
function App.RefreshWorkspace()
    if not InCombatLockdown() then App.DiscoverCandidates(); App.RefreshUI(); return end
    App.needsRefreshAfterCombat = true
    App.UpdateStatusText()
    App.SyncActionTarget()
end
function App.SetCompactMode(compact)
    if not App.compactFrame or not App.queueButton then return end
    if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return end
    App.db.compactMode = not not compact
    local source = compact and App.mainFrame or App.compactFrame
    local destination = compact and App.compactFrame or App.mainFrame
    if source then source:Hide() end
    if compact then App.DockQueueButtonToCompact() else App.DockQueueButtonToPanel() end
    if destination then destination:Show(); App.RefreshWorkspace() end
end
function App.ToggleMainFrame()
    if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return end
    local compact = App.db and App.db.compactMode
    local target = compact and App.compactFrame or App.mainFrame
    if not target then return end
    if target:IsShown() then target:Hide(); return end
    if compact then App.DockQueueButtonToCompact() end
    target:Show()
    App.RefreshWorkspace()
end
-- Register outside lockdown; the secure environment owns visibility in combat.
function App.InstallCombatVisibility()
    if App.combatVisibilityInstalled or not App.mainFrame or InCombatLockdown() or not RegisterStateDriver then return end
    App.mainFrame:SetAttribute("_onstate-workspacevisibility", [[
        if newstate == "closed" then self:Hide() end
    ]])
    RegisterStateDriver(App.mainFrame, "workspacevisibility", "[combat] closed; available")
    App.combatVisibilityInstalled = true
end
function App.HideMainFrameForCombat()
    if not App.combatVisibilityInstalled and App.mainFrame and not App.mainFrame:IsProtected() then
        App.mainFrame:Hide()
    end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
