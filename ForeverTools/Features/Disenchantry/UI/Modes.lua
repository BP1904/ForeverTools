-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Profession controls share one renderer for tabs and the compact menu.
local _, ns = ...
local App, UI = ns.App, ns.UI

function App.GetModeName(mode)
    if not mode then return App.L.UNKNOWN end
    return App.L[mode.modeNameKey] or mode.key
end
function App.SelectModeFromSurface(mode)
    if not mode then return end
    local _, accepted = App.ChooseProfession(mode.key)
    if accepted and App.compactModeMenu then App.compactModeMenu:Hide() end
end
local function choice(parent, mode, points, width, hintAnchor)
    local control = UI.Button(parent, {text=App.GetModeName(mode), width=width, points=points, click=function() App.SelectModeFromSurface(mode) end})
    control.mode = mode
    UI.Hint(control, function()
        if not mode.isKnown() then return App.GetModeName(mode) .. "\n" .. App.L.MODE_NOT_LEARNED_HINT end
    end, hintAnchor)
    return control
end
function App.CreateModeTabs()
    local holder = CreateFrame("Frame", nil, App.mainFrame)
    App.modeTabFrame = holder
    UI.Anchor(holder, {{"TOPLEFT", App.mainFrame, "TOPLEFT", 16, -52}})
    local available = App.AvailableProfessions()
    holder:SetSize(math.max(1, #available * 124), 24)
    for index, mode in ipairs(available) do
        App.modeTabButtons[index] = choice(holder, mode, {{"LEFT", holder, "LEFT", (index - 1) * 124, 0}}, 118, "ANCHOR_TOP")
    end
end
function App.CreateCompactModeMenu()
    local menu = UI.Surface(UIParent, "menu")
    App.compactModeMenu = menu
    menu:SetFrameStrata("DIALOG")
    local available = App.AvailableProfessions()
    menu:SetSize(132, math.max(30, #available * 24 + 8))
    for index, mode in ipairs(available) do
        App.compactModeMenuButtons[index] = choice(menu, mode,
            {{"TOPLEFT", 4, -4 - (index - 1) * 24}, {"TOPRIGHT", -4, -4 - (index - 1) * 24}}, 124, "ANCHOR_LEFT")
    end
    menu:Hide()
end
local function updateChoices(controls, colored)
    for _, control in ipairs(controls) do
        local mode = control.mode
        local active, known = mode == App.activeMode, mode.isKnown()
        control:SetEnabled(known and not active)
        if colored then
            local color = active and {1, 0.82, 0} or known and {1, 1, 1} or {0.5, 0.5, 0.5}
            local label = control:GetFontString()
            if label then label:SetTextColor(unpack(color)) end
        end
    end
end
function App.UpdateModeSurface()
    local multiple = #App.AvailableProfessions() > 1
    if App.mainSubtitle then App.mainSubtitle:SetText(App.L[App.activeMode.subtitleTextKey]) end
    if not InCombatLockdown() then
        if App.modeTabFrame then App.modeTabFrame:SetShown(multiple) end
        if App.compactModeSelector then
            App.compactModeSelector:SetShown(multiple)
            App.compactModeSelector:SetText(App.GetModeName(App.activeMode))
        end
        updateChoices(App.modeTabButtons, true)
        updateChoices(App.compactModeMenuButtons, false)
        if App.compactNameText then
            local right = multiple and {"RIGHT", App.compactModeSelector, "LEFT", -8, 0} or {"RIGHT", App.compactFrame, "RIGHT", -254, 0}
            UI.Anchor(App.compactNameText, {{"TOPLEFT", App.compactIcon:GetParent(), "TOPRIGHT", 8, -2}, right})
        end
    end
    if App.settingsProtectionGroup then
        App.settingsProtectionGroup:SetShown(App.activeMode.usesItemProtection == true)
        App.settingsModeHint:SetShown(App.activeMode.usesItemProtection ~= true)
    end
    if not multiple and App.compactModeMenu then App.compactModeMenu:Hide() end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
