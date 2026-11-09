-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Small declarative UI vocabulary shared by every Disenchantry window.
local _, ns = ...
local App, UI = ns.App, {}
ns.UI = UI

-- Surfaces describe their appearance once; callers only choose a role.
local surfaces = {
    icon={backdrop="BACKDROP_ICON", fill={0, 0, 0, 1}, edge={0.3, 0.3, 0.3, 1}},
    list={backdrop="BACKDROP_PANEL", fill={0.12, 0.1, 0.08, 0.85}, edge={0.6, 0.55, 0.45, 1}},
    menu={backdrop="BACKDROP_WINDOW", fill={1, 1, 1, 1}, edge={1, 1, 1, 1}},
    window={backdrop="BACKDROP_WINDOW", fill={1, 1, 1, 1}, edge={1, 1, 1, 1}},
}
function UI.Surface(parent, role, spec)
    spec = spec or {}
    local style = assert(surfaces[role], "Unknown Disenchantry surface")
    local templates = "BackdropTemplate" .. (spec.template and "," .. spec.template or "")
    local region = CreateFrame("Frame", spec.name, parent, templates)
    region:SetBackdrop(App[style.backdrop])
    region:SetBackdropColor(unpack(style.fill))
    region:SetBackdropBorderColor(unpack(style.edge))
    if spec.width then region:SetSize(spec.width, spec.height or spec.width) end
    if spec.points then UI.Anchor(region, spec.points) end
    return region
end

function UI.DismissTooltip(owner)
    if owner and GameTooltip:IsOwned(owner) then
        GameTooltip:Hide()
    end
end
function UI.BindTooltip(control, enter)
    control:SetScript("OnEnter", enter)
    control:SetScript("OnLeave", UI.DismissTooltip)
    -- Hook instead of replacing the control's own cleanup.
    control:HookScript("OnHide", UI.DismissTooltip)
end

function UI.OpenView(control)
    App.SetCompactMode(control.compactDestination)
end

function UI.Row(parent, spec)
    local region = CreateFrame(spec.clickable and "Button" or "Frame", nil, parent)
    region:SetHeight(spec.height)
    if spec.clickable then region:RegisterForClicks("LeftButtonUp") end
    if spec.highlight then region:SetHighlightTexture(spec.highlight) end
    if spec.background then
        region.bg = region:CreateTexture(nil, "BACKGROUND")
        region.bg:SetAllPoints(region)
        region.bg:SetColorTexture(unpack(spec.background))
    end
    if spec.points then UI.Anchor(region, spec.points) end
    return region
end

function UI.Anchor(region, points)
    region:ClearAllPoints()
    for _, point in ipairs(points or {}) do region:SetPoint(unpack(point)) end
    return region
end
function UI.Text(parent, value, font, points, width)
    local region = parent:CreateFontString(nil, "OVERLAY", font or "GameFontNormalSmall")
    UI.Anchor(region, points)
    region:SetText(value or "")
    region:SetJustifyH("LEFT")
    if width then region:SetWidth(width) end
    return region
end
function UI.Hint(control, text, anchor)
    UI.BindTooltip(control, function(self)
        local value = type(text) == "function" and text(self) or text
        if not value then return end
        GameTooltip:SetOwner(self, anchor or "ANCHOR_TOP")
        GameTooltip:AddLine(value, 0.7, 0.8, 1, true)
        GameTooltip:Show()
    end)
end
function UI.Button(parent, spec)
    spec = spec or {}
    local templates = {"UIPanelButtonTemplate"}
    if spec.secure then templates[#templates + 1] = "SecureActionButtonTemplate,SecureHandlerStateTemplate" end
    local control = CreateFrame("Button", spec.name, parent, table.concat(templates, ","))
    local fonts = {Normal="GameFontNormalSmall", Highlight="GameFontHighlightSmall", Disabled="GameFontDisableSmall"}
    for state, font in pairs(fonts) do control["Set" .. state .. "FontObject"](control, _G[font]) end
    if spec.width then control:SetSize(spec.width, spec.height or 22) end
    if spec.points then UI.Anchor(control, spec.points) end
    if spec.text or spec.key then control:SetText(spec.text or App.L[spec.key]) end
    if spec.click then control:SetScript("OnClick", spec.click) end
    if spec.compactDestination ~= nil then
        control.compactDestination = spec.compactDestination
        control:SetScript("OnClick", UI.OpenView)
    end
    if spec.hint then UI.Hint(control, spec.hint) end
    return control
end
function UI.Check(parent, label, points, changed)
    local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    UI.Anchor(box, points)
    box:SetSize(26, 26)
    box.caption = UI.Text(parent, label, "GameFontNormal", {{"LEFT", box, "RIGHT", 4, 0}})
    if changed then box:SetScript("OnClick", function(self) changed(not not self:GetChecked()) end) end
    return box
end
function UI.Icon(parent, size, points)
    local border = UI.Surface(parent, "icon", {width=size, points=points})
    local art = border:CreateTexture(nil, "ARTWORK")
    UI.Anchor(art, {{"TOPLEFT", 2, -2}, {"BOTTOMRIGHT", -2, 2}})
    art:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    return border, art
end
function UI.Scroll(parent, points)
    local viewport = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    UI.Anchor(viewport, points)
    local canvas = CreateFrame("Frame", nil, viewport)
    canvas:SetSize(1, 1)
    viewport:SetScrollChild(canvas)
    return viewport, canvas
end
function UI.Color(region, quality, fallback)
    local color = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality]
    local c = color and {color.r or 1, color.g or 1, color.b or 1} or fallback or {1, 1, 1}
    region:SetTextColor(unpack(c))
    return c
end
function UI.RenderRows(pool, entries, view, canvas, step, create, update)
    local width = math.max(100, view:GetWidth() - 24)
    for index = 1, math.max(#entries, #pool) do
        local entry, row = entries[index], pool[index]
        if entry then
            if not row then row = create(canvas); pool[index] = row end
            UI.Anchor(row, {{"TOPLEFT", canvas, "TOPLEFT", 0, -(index - 1) * step}})
            row:SetWidth(width)
            update(row, entry)
            row:Show()
        elseif row then update(row, nil); row:Hide() end
    end
    canvas:SetSize(width, math.max(view:GetHeight(), #entries * step, 1))
end
function UI.Toggle(window, points, update)
    if not window then return end
    if window:IsShown() then window:Hide(); return end
    UI.Anchor(window, points)
    window:Show()
    window:Raise()
    if update then update() end
end
function App.RaiseAddonWindows(focus)
    for _, key in ipairs({"mainFrame", "settingsFrame", "blacklistFrame"}) do
        local window = App[key]
        if window and window:IsShown() then window:Raise() end
    end
    if focus and focus:IsShown() then focus:Raise() end
end
function App.CreateIconBorder(parent, size)
    local border = UI.Icon(parent, size)
    return border
end
function App.CreateStyledButton(parent, secure, name)
    return UI.Button(parent, {secure=secure, name=name})
end
function App.CreateStyledWindow(name, width, height, extra)
    local window = UI.Surface(UIParent, "window", {name=name, width=width, height=height, template=extra})
    for _, method in ipairs({"SetMovable", "EnableMouse", "SetClampedToScreen", "SetToplevel"}) do window[method](window, true) end
    window:SetScript("OnMouseDown", function() App.RaiseAddonWindows(window) end)
    local drag = CreateFrame("Frame", nil, window)
    UI.Anchor(drag, {{"TOPLEFT", 4, -4}, {"TOPRIGHT", -4, -4}})
    drag:SetHeight(28)
    drag:EnableMouse(true)
    drag:RegisterForDrag("LeftButton")
    drag:SetScript("OnMouseDown", function() App.RaiseAddonWindows(window) end)
    drag:SetScript("OnDragStart", function() if not InCombatLockdown() then window:StartMoving() end end)
    drag:SetScript("OnDragStop", function()
        if InCombatLockdown() then
            App.pendingDragStops=App.pendingDragStops or {}; App.pendingDragStops[window]=true
        else window:StopMovingOrSizing() end
    end)
    window.TitleBar = drag
    local fill = drag:CreateTexture(nil, "ARTWORK")
    fill:SetAllPoints(drag)
    fill:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
    local edge = window:CreateTexture(nil, "ARTWORK")
    UI.Anchor(edge, {{"TOPLEFT", drag, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", drag, "BOTTOMRIGHT", 0, 0}})
    edge:SetHeight(1)
    edge:SetColorTexture(0.65, 0.48, 0.18, 0.7)
    window.title = UI.Text(window, "", "GameFontHighlight", {{"LEFT", drag, "LEFT", 12, 0}})
    window.title:SetTextColor(1, 0.82, 0)
    window.title:SetJustifyV("MIDDLE")
    window.CloseButton = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    UI.Anchor(window.CloseButton, {{"TOPRIGHT", 1, 1}})
    window.CloseButton:SetFrameLevel(drag:GetFrameLevel() + 5)
    window.CloseButton:SetScript("OnClick", function()
        if InCombatLockdown() and window:IsProtected() then App.Print(App.L.NOT_IN_COMBAT)
        else window:Hide() end
    end)
    return window
end

end
LoadComponent("ForeverTools", FT.disenchantry)
