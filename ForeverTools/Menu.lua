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
        or "Alle Module aktualisieren: Update.cmd im ForeverTools-Ordner.", 20, -399)
    self.menu = panel
    panel:Layout()
    panel:Refresh()
end

function FT:ToggleMenu()
    if not FT.db then return end
    if not FT.menu then
        FT:CreateMenu()
    else
        FT.menu:SetShown(not FT.menu:IsShown())
    end
end

function FT:CreateLauncher()
    if not Minimap then return end
    local button = CreateFrame("Button", "ForeverToolsLauncher", Minimap)
    button:SetSize(30, 30)
    button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -4, -4)
    button:SetFrameStrata("MEDIUM")
    button:SetNormalTexture("Interface\\Icons\\Trade_BlackSmithing")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    button:SetScript("OnClick", function() self:ToggleMenu() end)
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(button, "ANCHOR_LEFT")
        GameTooltip:AddLine("ForeverTools")
        GameTooltip:AddLine("Klicken: Module ein- und ausschalten", 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    self.launcher = button
end

SLASH_FOREVERTOOLS1 = "/ad"
SLASH_FOREVERTOOLS2 = "/forevertools"
SlashCmdList.FOREVERTOOLS = function() FT:ToggleMenu() end
