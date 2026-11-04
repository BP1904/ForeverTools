-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local H = {}
ns.Hotkeys = H
local owner = CreateFrame("Frame")
local db, target, enabled

function H.Update()
    if not db or InCombatLockdown() then return end
    ClearOverrideBindings(owner)
    if db.disenchantKey and enabled() then
        SetOverrideBindingClick(owner, true, db.disenchantKey, target:GetName(), "LeftButton")
    end
end

function H.Initialize(database, button, predicate)
    db, target, enabled = database, button, predicate
    button:HookScript("OnShow", H.Update)
    button:HookScript("OnHide", H.Update)
    H.Update()
end

function H.CreateControls(parent, createButton)
    local L = ns.L
    local header = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    header:SetPoint("TOPLEFT", 18, -566)
    header:SetText(L.HOTKEY_TITLE)
    local capture = createButton(parent)
    capture:SetSize(280, 26)
    capture:SetPoint("TOPLEFT", 18, -590)
    local listening = false
    local function stop()
        listening = false
        capture:EnableKeyboard(false)
        capture:SetText(db.disenchantKey or L.HOTKEY_SET)
    end
    capture:SetScript("OnClick", function()
        if InCombatLockdown() then return end
        listening = true
        capture:SetText(L.HOTKEY_PRESS)
        capture:EnableKeyboard(true)
        capture:SetPropagateKeyboardInput(false)
        -- Never hold the keyboard indefinitely if the user walks away.
        local token = {}
        capture.listenToken = token
        if C_Timer and C_Timer.After then
            C_Timer.After(10, function()
                if listening and capture.listenToken == token then stop() end
            end)
        end
    end)
    capture:SetScript("OnKeyDown", function(_, key)
        if not listening then return end
        if InCombatLockdown() or key == "ESCAPE" then stop(); return end
        if key == "LSHIFT" or key == "RSHIFT" or key == "LCTRL" or key == "RCTRL" or key == "LALT" or key == "RALT" then return end
        -- WoW's canonical modifier order is ALT-CTRL-SHIFT.
        local binding = (IsAltKeyDown() and "ALT-" or "")
            .. (IsControlKeyDown() and "CTRL-" or "") .. (IsShiftKeyDown() and "SHIFT-" or "") .. key
        -- The priority override replaces any existing action while the
        -- disenchant window is active; closing it restores the normal binding.
        db.disenchantKey = binding
        stop()
        H.Update()
    end)
    capture:SetScript("OnHide", stop)
    stop()
    local clear = createButton(parent)
    clear:SetSize(132, 26)
    clear:SetPoint("LEFT", capture, "RIGHT", 12, 0)
    clear:SetText(L.HOTKEY_CLEAR)
    clear:SetScript("OnClick", function()
        if InCombatLockdown() then return end
        db.disenchantKey = nil
        stop()
        H.Update()
    end)
    local hint = parent:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("TOPLEFT", 18, -624)
    hint:SetPoint("RIGHT", parent, "RIGHT", -18, 0)
    hint:SetJustifyH("LEFT")
    hint:SetWordWrap(true)
    hint:SetText(L.HOTKEY_HINT)
end

end
LoadComponent("ForeverTools", FT.disenchantry)
