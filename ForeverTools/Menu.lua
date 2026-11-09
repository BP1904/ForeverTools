local _, FT = ...
local CONTENT_WIDTH = 600
local ACCENT = {0.40, 0.84, 0.69}

local function Label(parent, text, x, y, font)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", x, y)
    label:SetWidth(CONTENT_WIDTH - x - 12)
    label:SetJustifyH("LEFT")
    label:SetText(text)
    return label
end

function FT:CreateMenu()
    local panel = CreateFrame("Frame", "ForeverToolsMenu", UIParent, "BasicFrameTemplateWithInset")
    local height = UIParent.GetHeight and math.min(600, math.max(440, UIParent:GetHeight() - 80)) or 600
    panel:SetSize(660, height)
    panel:SetPoint("CENTER")
    panel:SetClampedToScreen(true)
    panel:SetMovable(true)
    panel:EnableMouse(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel.TitleText:SetText("ForeverTools")
    UISpecialFrames[#UISpecialFrames + 1] = "ForeverToolsMenu"
    panel.summary = Label(panel, "Deine Module", 24, -42, "GameFontNormalLarge")
    panel.summary:SetTextColor(unpack(ACCENT))
    local help = Label(panel, "Häkchen: ein/aus  |  Optionen: Einstellungen und Aktionen", 24, -66)
    help:SetTextColor(0.72, 0.76, 0.81)
    local update = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    update:SetSize(100, 26)
    update:SetPoint("TOPRIGHT", -28, -41)
    update:SetText("Updates")
    update:SetScript("OnClick", function() FT:ShowUpdates() end)

    local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -94)
    scroll:SetPoint("BOTTOMRIGHT", -40, 58)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(CONTENT_WIDTH, 1)
    scroll:SetScrollChild(content)
    panel.checks = {}
    panel.sections = {}
    panel.byModule = {}

    local function Check(parent, text, x, y, read, write, available)
        local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
        box:SetSize(28, 28)
        box:SetPoint("TOPLEFT", x, y)
        box.Text:SetText(text)
        box.Text:SetWidth(CONTENT_WIDTH - x - 52)
        box.Text:SetJustifyH("LEFT")
        box:SetScript("OnClick", function(self)
            write(self:GetChecked() and true or false)
            panel:Refresh()
        end)
        local check = {box = box, read = read, available = available}
        panel.checks[#panel.checks + 1] = check
        return check
    end

    for _, moduleID in ipairs(self.order) do
        local id = moduleID
        local module = self.modules[id]
        local section = {id = id, expanded = false, actions = {}}
        panel.sections[#panel.sections + 1] = section
        panel.byModule[id] = section
        section.frame = CreateFrame("Frame", nil, content, "BackdropTemplate")
        section.frame:SetSize(CONTENT_WIDTH, 58)
        section.frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1})
        section.frame:SetBackdropColor(0.055, 0.075, 0.09, 0.94)
        section.frame:SetBackdropBorderColor(0.18, 0.25, 0.28, 1)
        section.master = Check(section.frame, module.title, 10, -6,
            function() return self:IsEnabled(id) end,
            function(enabled) self:SetEnabled(id, enabled) end,
            function() return not module.IsAvailable or module:IsAvailable() end)
        section.master.box.Text:SetWidth(425)
        section.status = Label(section.frame, "", 44, -34)
        section.status:SetWidth(420)
        section.toggle = CreateFrame("Button", nil, section.frame, "UIPanelButtonTemplate")
        section.toggle:SetSize(94, 26)
        section.toggle:SetPoint("TOPRIGHT", -12, -14)
        section.toggle:SetScript("OnClick", function()
            section.expanded = not section.expanded
            panel:Layout()
        end)
        section.details = CreateFrame("Frame", nil, section.frame)
        section.details:SetPoint("TOPLEFT", 0, -58)
        local y = 0
        local description = Label(section.details, module.description, 44, y)
        description:SetTextColor(0.76, 0.81, 0.85)
        y = y - math.max(32, description.GetStringHeight and description:GetStringHeight() or 32) - 12
        for _, action in ipairs(module.actions or {}) do
            local item = action
            local button = CreateFrame("Button", nil, section.details, "UIPanelButtonTemplate")
            button:SetSize(CONTENT_WIDTH - 88, 26)
            button:SetPoint("TOPLEFT", 44, y)
            button:SetText(item.title)
            button:SetScript("OnClick", function()
                if self:IsEnabled(id) then item.run() end
            end)
            section.actions[#section.actions + 1] = button
            y = y - 32
        end
        for _, setting in ipairs(module.options or {}) do
            local key = setting.key
            local option = Check(section.details, setting.title, 34, y,
                function() return module.settings[key] end,
                function(enabled)
                    module.settings[key] = enabled
                    if module.OnSettingsChanged then module:OnSettingsChanged() end
                end,
                function() return self:IsEnabled(id) end)
            y = y - math.max(32, option.box.Text.GetStringHeight and option.box.Text:GetStringHeight() + 10 or 32)
        end
        section.detailsHeight = math.max(1, -y)
        section.details:SetSize(CONTENT_WIDTH, section.detailsHeight)
    end
    function panel:Layout()
        local y = 0
        for _, section in ipairs(self.sections) do
            section.frame:SetPoint("TOPLEFT", 0, y)
            local height = 58 + (section.expanded and section.detailsHeight or 0)
            section.frame:SetHeight(height)
            section.details:SetShown(section.expanded)
            section.toggle:SetText(section.expanded and "Schließen -" or "Optionen +")
            y = y - height - 8
        end
        local height = math.max(1, -y)
        content:SetHeight(height)
        -- Collapsing a section must not leave the overview scrolled below its rows.
        if scroll.GetVerticalScroll and scroll.SetVerticalScroll and scroll.GetHeight then
            local maximum = math.max(0, height - scroll:GetHeight())
            scroll:SetVerticalScroll(math.min(scroll:GetVerticalScroll(), maximum))
        end
    end
    function panel:Refresh()
        for _, check in ipairs(self.checks) do
            check.box:SetChecked(check.read())
            check.box:SetEnabled(not check.available or check.available())
        end
        local active = 0
        for _, section in ipairs(self.sections) do
            local module = FT.modules[section.id]
            local enabled = FT:IsEnabled(section.id)
            local available = not module.IsAvailable or module:IsAvailable()
            if enabled then active = active + 1 end
            section.status:SetText(module.initError and "Startfehler" or not available and "Nicht bereit" or enabled and "Aktiv" or "Ausgeschaltet")
            if module.initError or not available then section.status:SetTextColor(1, 0.72, 0.36)
            elseif enabled then section.status:SetTextColor(unpack(ACCENT))
            else section.status:SetTextColor(0.60, 0.65, 0.70) end
            section.master.box.Text:SetTextColor(enabled and 0.94 or 0.65, enabled and 0.96 or 0.69, enabled and 0.98 or 0.73)
            for _, button in ipairs(section.actions) do button:SetEnabled(enabled and available) end
        end
        self.summary:SetText(("Deine Module  |  %d von %d eingeschaltet"):format(active, #self.sections))
    end
    panel:SetScript("OnShow", panel.Refresh)
    local footer = Label(panel, "Händleraktionen beim Händler; Questabgabe beim Questgeber.", 24, 0)
    footer:ClearAllPoints(); footer:SetPoint("BOTTOMLEFT", 24, 32)
    footer:SetTextColor(0.72, 0.76, 0.81)
    local status = self.updateStatus
    local updateInfo = Label(panel, status and ("GitHub: " .. status.commit .. " | " .. status.checked)
        or "Updates: Helfer per Update.cmd starten, dann Updates klicken.", 24, 0)
    updateInfo:ClearAllPoints(); updateInfo:SetPoint("BOTTOMLEFT", 24, 14)
    updateInfo:SetTextColor(0.55, 0.62, 0.67)
    self.menu = panel
    panel:Layout()
    panel:Refresh()
end

function FT:ToggleMenu()
    if not FT.db then return end
    if self.launcherMenu then self.launcherMenu:SetShown(false) end
    if not FT.menu then
        FT:CreateMenu()
    else
        FT.menu:SetShown(not FT.menu:IsShown())
    end
end

function FT:ToggleLauncherMenu()
    if not self.db or not self.launcher then return end
    if not self.launcherMenu then
        local panel = CreateFrame("Frame", "ForeverToolsLauncherMenu", UIParent, "BasicFrameTemplateWithInset")
        self.launcherMenu = panel
        panel:SetSize(246, 263)
        panel:SetPoint("TOPRIGHT", self.launcher, "BOTTOMLEFT", 0, 0)
        panel:SetFrameStrata("DIALOG")
        panel:SetClampedToScreen(true)
        panel.TitleText:SetText("ForeverTools")
        UISpecialFrames[#UISpecialFrames + 1] = "ForeverToolsLauncherMenu"
        panel.entries = {}
        local entries = {
            {id = "attune", title = "Attune", icon = "Interface\\Icons\\INV_Scroll_03"},
            {id = "disenchantry", title = "Disenchantry", icon = 136244},
            {id = "bigwigs", title = "BigWigs", icon = "Interface\\Icons\\INV_Helmet_06"},
            {id = "novainstancetracker", title = "Nova Instance Tracker", icon = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar", options = "options"},
            {id = "experience", title = "Erfahrungsleiste", icon = "Interface\\Icons\\INV_Misc_Book_09"},
        }
        for index, entry in ipairs(entries) do
            local item = entry
            local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
            button:SetSize(218, 30)
            button:SetPoint("TOPLEFT", 14, -36 - (index - 1) * 36)
            button:SetText(item.title)
            local icon = button:CreateTexture(nil, "ARTWORK")
            icon:SetSize(22, 22)
            icon:SetPoint("LEFT", 7, 0)
            icon:SetTexture(item.icon)
            button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            button:SetScript("OnClick", function(_, mouse)
                local module = self.modules[item.id]
                if not module or not self:IsEnabled(item.id) then return end
                panel:SetShown(false)
                if GameTooltip then GameTooltip:Hide() end
                if item.id == "attune" then module:Open(mouse == "RightButton")
                else module:Open(mouse == "RightButton" and (item.options or "settings") or nil) end
            end)
            button:SetScript("OnEnter", function(b)
                GameTooltip:SetOwner(b, "ANCHOR_LEFT")
                GameTooltip:AddLine(item.title)
                GameTooltip:AddLine("Linksklick: öffnen. Rechtsklick: Einstellungen.", 1, 1, 1)
                GameTooltip:Show()
            end)
            button:SetScript("OnLeave", function() GameTooltip:Hide() end)
            panel.entries[item.id] = button
        end
        local manage = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        manage:SetSize(218, 26)
        manage:SetPoint("TOPLEFT", 14, -218)
        manage:SetText("Module verwalten")
        manage:SetScript("OnClick", function() self:ToggleMenu() end)
        panel.manage = manage
        panel:SetScript("OnShow", function()
            for id, button in pairs(panel.entries) do
                button:SetEnabled(self.modules[id] ~= nil and self:IsEnabled(id))
            end
        end)
        panel:SetScript("OnHide", function() if GameTooltip then GameTooltip:Hide() end end)
        panel:SetShown(false)
    end
    local shown = not self.launcherMenu:IsShown()
    if shown and self.menu then self.menu:SetShown(false) end
    self.launcherMenu:SetShown(shown)
end

function FT:CreateLauncher()
    if not Minimap or self.launcher then return end
    local button = CreateFrame("Button", "ForeverToolsLauncher", Minimap)
    button:SetSize(30, 30)
    -- Leave room for DungeonJournal's default button at the lower-left rim.
    button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -44, -4)
    button:SetFrameStrata("MEDIUM")
    button:SetNormalTexture("Interface\\Icons\\Trade_Engineering")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(_, mouse)
        if mouse == "RightButton" then self:ToggleMenu() else self:ToggleLauncherMenu() end
    end)
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(button, "ANCHOR_LEFT")
        GameTooltip:AddLine("ForeverTools")
        GameTooltip:AddLine("Linksklick: Attune und Disenchantry", 1, 1, 1)
        GameTooltip:AddLine("Rechtsklick: Module verwalten", 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    self.launcher = button
end

SLASH_FOREVERTOOLS1 = "/ad"
SLASH_FOREVERTOOLS2 = "/forevertools"
SlashCmdList.FOREVERTOOLS = function() FT:ToggleMenu() end

function FT:RaiseJournalButton()
    if InCombatLockdown and InCombatLockdown() then self.journalButtonPending=true; return end
    self.journalButtonPending=nil
    if not Minimap or not Minimap.GetFrameLevel then return end
    local button = _G.LibDBIcon10_ForeverDungeonJournal
    if not button and LibStub then
        local ok, lib = pcall(LibStub, "LibDBIcon-1.0", true)
        if ok and lib and lib.GetMinimapButton then button = lib:GetMinimapButton("ForeverDungeonJournal") end
    end
    if not button then return end
    -- LibDBIcon uses fixed level 8; the Forever minimap can be above that.
    -- Preserve visibility settings and scripts; only correct the draw order.
    if button.SetFixedFrameLevel then button:SetFixedFrameLevel(false) end
    button:SetFrameLevel(Minimap:GetFrameLevel() + 10)
    if button.SetFixedFrameLevel then button:SetFixedFrameLevel(true) end
end

local journalEvents = CreateFrame("Frame")
journalEvents:RegisterEvent("PLAYER_LOGIN")
journalEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
journalEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
journalEvents:SetScript("OnEvent", function(_,event)
    if event=="PLAYER_REGEN_ENABLED" and not FT.journalButtonPending then return end
    -- Journal creates its button in PLAYER_LOGIN; wait until all handlers ran.
    if C_Timer and C_Timer.After then C_Timer.After(0, function() FT:RaiseJournalButton() end)
    else FT:RaiseJournalButton() end
end)
