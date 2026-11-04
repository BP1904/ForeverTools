-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Settings are built from control descriptors with shared read/write bindings.
local _, ns = ...
local App, UI = ns.App, ns.UI
local limits = {
    {enabled="ilvlCapEnabled", value="ilvlCap", title="ILVL_PROTECT", prompt="ILVL_BELOW", hint="ILVL_HINT", warning="ILVL_CAP_EMPTY", top=42, digits=4, width=52},
    {enabled="priceWarnEnabled", value="priceThresholdGold", title="PRICE_PROTECT", prompt="PRICE_AT_LEAST", hint="PRICE_HINT", warning="PRICE_THRESHOLD_EMPTY", top=174, digits=9, width=76},
}
local function divider(parent, y)
    local line = parent:CreateTexture(nil, "ARTWORK")
    UI.Anchor(line, {{"TOPLEFT", 14, -y}, {"TOPRIGHT", -14, -y}})
    line:SetHeight(1)
    line:SetColorTexture(0.4, 0.4, 0.4, 0.4)
end
local function paragraph(parent, key, x, y)
    local text = UI.Text(parent, App.L[key], "GameFontDisableSmall", {{"TOPLEFT", x, -y}, {"RIGHT", parent, "RIGHT", -18, 0}})
    text:SetWordWrap(true)
    return text
end
local function threshold(parent, spec)
    local controls = {}
    local function warn()
        if App.db[spec.enabled] and not tonumber(App.db[spec.value]) then App.Print(App.L[spec.warning]) end
    end
    controls.check = UI.Check(parent, App.L[spec.title], {{"TOPLEFT", 14, -spec.top}}, function(on)
        App.db[spec.enabled] = on
        warn(); App.RefreshWorkspace()
    end)
    local label = UI.Text(parent, App.L[spec.prompt], nil, {{"TOPLEFT", 44, -spec.top - 38}})
    local input = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    controls.input = input
    UI.Anchor(input, {{"LEFT", label, "RIGHT", spec.value == "ilvlCap" and 14 or 10, 0}})
    input:SetSize(spec.width, 20)
    input:SetAutoFocus(false)
    input:SetNumeric(true)
    input:SetMaxLetters(spec.digits)
    local function commit()
        App.db[spec.value] = tonumber(input:GetText())
        warn(); App.RefreshWorkspace()
    end
    input:SetScript("OnEditFocusLost", commit)
    input:SetScript("OnEnterPressed", function() commit(); input:ClearFocus() end)
    input:SetScript("OnEscapePressed", function() input:ClearFocus() end)
    controls.sync = function()
        controls.check:SetChecked(App.db[spec.enabled])
        input:SetText(App.db[spec.value] and tostring(App.db[spec.value]) or "")
    end
    paragraph(parent, spec.hint, 44, spec.top + 66)
    if spec.value == "ilvlCap" then
        controls.suggest = UI.Button(parent, {key="ILVL_SUGGEST", width=90, points={{"TOPRIGHT", -14, -75}}, click=function()
            local suggestion = App.GetLowestEquippedItemLevel()
            if suggestion then input:SetText(tostring(suggestion)); commit() end
        end})
    else UI.Text(parent, App.L.PRICE_GOLD, nil, {{"LEFT", input, "RIGHT", 8, 0}}) end
    return controls
end
local function languageControls(window)
    UI.Text(window, App.L.LANGUAGE, "GameFontNormal", {{"TOPLEFT", 18, -438}})
    local pending, options = App.db.language or "auto", {}
    local function render()
        for _, control in ipairs(options) do control:SetEnabled(control.language ~= pending) end
    end
    for index, entry in ipairs({{"auto", App.L.LANGUAGE_AUTO}, {"ruRU", "Русский"}, {"enUS", "English"}, {"deDE", "Deutsch"}}) do
        local key, caption = entry[1], entry[2]
        local control = UI.Button(window, {text=caption, width=104, height=24,
            points={{"TOPLEFT", 18 + (index - 1) * 110, -460}}, click=function() pending=key; render() end})
        control.language = key
        options[index] = control
    end
    render()
    paragraph(window, "LANGUAGE_HINT", 18, 490)
    UI.Button(window, {key="LANGUAGE_APPLY", width=230, height=24, points={{"TOPRIGHT", -18, -526}}, click=function()
        if InCombatLockdown() then App.Print(App.L.NOT_IN_COMBAT); return end
        App.db.language = pending
        ReloadUI()
    end})
end
function App.CreateSettingsFrame()
    local window = App.CreateStyledWindow("ForeverToolsDisenchantry_SettingsFrame", 470, 800)
    App.settingsFrame = window
    UI.Anchor(window, {{"CENTER", UIParent, "CENTER", -300, 0}})
    window:Hide()
    window.title:SetText(App.L.SETTINGS_TITLE)
    local group = CreateFrame("Frame", nil, window)
    group:SetAllPoints(window)
    App.settingsProtectionGroup = group
    App.settingsModeHint = UI.Text(window, App.L.MODE_NO_PROTECTION_SETTINGS, "GameFontNormal",
        {{"TOPLEFT", 24, -54}, {"RIGHT", window, "RIGHT", -24, 0}})
    App.settingsModeHint:SetWordWrap(true)
    local controls = {limits={}, qualities={}}
    App.settingsControls = controls
    for _, spec in ipairs(limits) do controls.limits[spec.value] = threshold(group, spec) end
    divider(group, 162); divider(group, 300)
    UI.Text(group, App.L.QUALITY_HEADER, "GameFontNormal", {{"TOPLEFT", 14, -312}})
    for index, quality in ipairs({2, 3, 4}) do
        local check = UI.Check(group, App.L["QUALITY_" .. quality] or _G["ITEM_QUALITY" .. quality .. "_DESC"],
            {{"TOPLEFT", 24, -338 - (index - 1) * 30}}, function(on)
                App.db.qualityFilter[quality] = on; App.RefreshWorkspace()
            end)
        UI.Color(check.caption, quality)
        controls.qualities[quality] = check
    end
    languageControls(window)
    ns.Hotkeys.CreateControls(window, App.CreateStyledButton)
    App.settingsMaterialsButton = UI.Button(window, {width=100, height=22,
        points={{"TOPRIGHT", window, "TOPRIGHT", -18, -666}},
        click=App.ToggleDisenchantMaterials, hint=App.L.TOGGLE_MATERIALS_HINT})
    controls.disenchantDisplay = {}
    for index, spec in ipairs({
        {key="hideDisenchantMaterials", label="SHOW_DE_MATERIALS"},
        {key="hideDisenchantChances", label="SHOW_DE_CHANCES"},
        {key="hideDisenchantValue", label="SHOW_DE_VALUE"},
    }) do
        local key = spec.key
        controls.disenchantDisplay[key] = UI.Check(window, App.L[spec.label],
            {{"TOPLEFT", 14, -700 - (index - 1) * 28}}, function(show)
                if InCombatLockdown() then
                    App.Print(App.L.NOT_IN_COMBAT)
                    controls.disenchantDisplay[key]:SetChecked(not App.db[key])
                    return
                end
                App.db[key] = not show
                GameTooltip:Hide()
                App.RefreshUI()
            end)
    end
    for _, key in ipairs({"ForeverToolsDisenchantry_SettingsFrame", "ForeverToolsDisenchantry_BlacklistFrame"}) do table.insert(UISpecialFrames, key) end
    window:SetScript("OnShow", function()
        App.UpdateModeSurface()
        for _, field in pairs(controls.limits) do field.sync() end
        for quality, check in pairs(controls.qualities) do check:SetChecked(App.db.qualityFilter[quality] ~= false) end
        for key, check in pairs(controls.disenchantDisplay) do check:SetChecked(not App.db[key]) end
        App.settingsMaterialsButton:SetText(App.L[App.db.hideDisenchantMaterials and "SHOW_MATERIALS" or "HIDE_MATERIALS"])
    end)
end
function App.ToggleSettingsFrame()
    local points = App.mainFrame and App.mainFrame:IsShown()
        and {{"TOPRIGHT", App.mainFrame, "TOPLEFT", -20, -12}} or {{"CENTER", UIParent, "CENTER", -300, 0}}
    UI.Toggle(App.settingsFrame, points)
end

end
LoadComponent("ForeverTools", FT.disenchantry)
