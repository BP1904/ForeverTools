local _, FT = ...

local function Label(parent, text, x, y, font)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", x, y)
    label:SetWidth(425 - x)
    label:SetJustifyH("LEFT")
    label:SetText(text)
    return label
end

function FT:CreateMenu()
    local panel = CreateFrame("Frame", "ForeverToolsMenu", UIParent, "BasicFrameTemplateWithInset")
    panel:SetSize(490, 440)
    panel:SetPoint("CENTER")
    panel:SetClampedToScreen(true)
    panel:SetMovable(true)
    panel:EnableMouse(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel.TitleText:SetText("ForeverTools – Module")
    UISpecialFrames[#UISpecialFrames + 1] = "ForeverToolsMenu"
    Label(panel, "Häkchen: ein/aus. Optionen: aufklappen.", 20, -42)
    local update = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    update:SetSize(88, 24)
    update:SetPoint("TOPRIGHT", -28, -36)
    update:SetText("Update")
    update:SetScript("OnClick", function() FT:ShowUpdates() end)

    local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 16, -70)
    scroll:SetPoint("BOTTOMRIGHT", -36, 65)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(425, 1)
    scroll:SetScrollChild(content)
    panel.checks = {}
    panel.sections = {}
    panel.byModule = {}

    local function Check(parent, text, x, y, read, write, available)
        local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
        box:SetSize(28, 28)
        box:SetPoint("TOPLEFT", x, y)
        box.Text:SetText(text)
        box.Text:SetWidth(370 - x)
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
        section.frame = CreateFrame("Frame", nil, content)
        section.frame:SetSize(425, 36)
        section.master = Check(section.frame, module.title, 0, 0,
            function() return self:IsEnabled(id) end,
            function(enabled) self:SetEnabled(id, enabled) end,
            function() return not module.IsAvailable or module:IsAvailable() end)
        section.master.box.Text:SetWidth(300)
        section.toggle = CreateFrame("Button", nil, section.frame, "UIPanelButtonTemplate")
        section.toggle:SetSize(86, 24)
        section.toggle:SetPoint("TOPRIGHT", 0, -2)
        section.toggle:SetScript("OnClick", function()
            section.expanded = not section.expanded
            panel:Layout()
        end)
        section.details = CreateFrame("Frame", nil, section.frame)
        section.details:SetPoint("TOPLEFT", 0, -36)
        local y = 0
        Label(section.details, module.description, 32, y)
        y = y - 42
        for _, action in ipairs(module.actions or {}) do
            local item = action
            local button = CreateFrame("Button", nil, section.details, "UIPanelButtonTemplate")
            button:SetSize(350, 24)
            button:SetPoint("TOPLEFT", 32, y)
            button:SetText(item.title)
            button:SetScript("OnClick", function()
                if self:IsEnabled(id) then item.run() end
            end)
            section.actions[#section.actions + 1] = button
            y = y - 32
        end
        for _, setting in ipairs(module.options or {}) do
            local key = setting.key
            Check(section.details, setting.title, 24, y,
                function() return module.settings[key] end,
                function(enabled)
                    module.settings[key] = enabled
                    if module.OnSettingsChanged then module:OnSettingsChanged() end
                end,
                function() return self:IsEnabled(id) end)
            y = y - 32
        end
        section.detailsHeight = math.max(1, -y)
        section.details:SetSize(425, section.detailsHeight)
    end
    function panel:Layout()
        local y = 0
        for _, section in ipairs(self.sections) do
            section.frame:SetPoint("TOPLEFT", 0, y)
            local height = 36 + (section.expanded and section.detailsHeight or 0)
            section.frame:SetHeight(height)
            section.details:SetShown(section.expanded)
            section.toggle:SetText(section.expanded and "Optionen -" or "Optionen +")
            y = y - height - 4
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
        for _, section in ipairs(self.sections) do
            for _, button in ipairs(section.actions) do button:SetEnabled(FT:IsEnabled(section.id)) end
        end
    end
    panel:SetScript("OnShow", panel.Refresh)
    Label(panel, "Händleraktionen beim Händler; Questabgabe beim Questgeber.", 20, -381)
    local status = self.updateStatus
    Label(panel, status and ("GitHub: " .. status.commit .. " | " .. status.checked)
        or "Updates: Helfer per Update.cmd starten, dann Update klicken.", 20, -399)
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
        panel:SetSize(246, 227)
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
        manage:SetPoint("TOPLEFT", 14, -182)
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
    button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -4, -4)
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
