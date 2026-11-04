-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- The action controller owns secure attributes; windows only place its button.
local _, ns = ...
local App = ns.App
local Action = {}
ns.Action = Action
local attributes = {"type", "spell", "target-item", "target-bag", "target-slot", "target-key"}

function App.PaintActionState(enabled, label)
    local button = App.queueButton
    if not button then return end
    for _, part in ipairs({"Left", "Middle", "Right"}) do
        if button[part] then button[part]:SetAlpha(enabled and 1 or 0.55) end
    end
    if App.queueButtonText then
        App.queueButtonText:SetText(label or App.L.DISENCHANT)
        if enabled then App.queueButtonText:SetTextColor(1, 0.82, 0)
        else App.queueButtonText:SetTextColor(0.7, 0.7, 0.7) end
    end
end
function App.InstallActionCombatGuard()
    local button = App.queueButton
    if not button or InCombatLockdown() or not RegisterStateDriver then return end
    button:SetAttribute("_onstate-processingcombat", [[
        -- Never restore a stale target on leaving combat; Lua rescans the bags first.
        if newstate == "blocked" then self:SetAttribute("type", nil) end
    ]])
    RegisterStateDriver(button, "processingcombat", "[combat] blocked; ready")
    RegisterStateDriver(button, "visibility", "[combat] hide; show")
end
function App.DisarmAction()
    if not App.queueButton or InCombatLockdown() then return end
    for _, key in ipairs(attributes) do App.queueButton:SetAttribute(key, nil) end
end
function App.SyncClickPolicy()
    if not App.queueButton or InCombatLockdown() then return end
    local edge = GetCVarBool and GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp"
    App.queueButton:RegisterForClicks(edge)
    App.queueButton.clickEdge = edge
end
function App.SyncActionTarget()
    local button, mode, item = App.queueButton, App.activeMode, App.queue[1]
    if not button or InCombatLockdown() then return end
    local enabled = item ~= nil and mode.isKnown()
    local label = App.L[mode.buttonTextKey]
    App.DisarmAction()
    if enabled then
        App.SyncClickPolicy()
        button:SetAttribute("spell", mode.spellName() or App.L[mode.buttonTextKey])
        button:SetAttribute("target-item", string.format("%d %d", item.bag, item.slot))
        button:SetAttribute("target-bag", item.bag)
        button:SetAttribute("target-slot", item.slot)
        button:SetAttribute("target-key", item.key)
        button:SetAttribute("type", "spell")
    end
    button:SetEnabled(enabled)
    if App.manualBlacklistButton then App.manualBlacklistButton:SetEnabled(enabled) end
    if App.compactBlacklistButton then App.compactBlacklistButton:SetEnabled(enabled) end
    App.PaintActionState(enabled, label)
end

local function retry(callback)
    App.DisarmAction()
    App.queueButton:Disable()
    App.PaintActionState(false, App.L[App.activeMode.buttonTextKey])
    if C_Timer and C_Timer.After then C_Timer.After(0.2, callback) end
end
function Action.BeforeClick(button)
    local now, combat = GetTime(), InCombatLockdown()
    if combat then
        App.ClearPendingDisenchant()
        App.needsRefreshAfterCombat = true
        return
    end
    if UnitCastingInfo("player") or UnitChannelInfo("player") then
        retry(App.RefreshWorkspace)
        return
    end
    if now < App.nextAllowedQueueClickAt then
        if not combat then retry(App.SyncActionTarget) end
        return
    end
    local item = App.queue[1]
    if not item then App.DisarmAction(); App.ClearPendingDisenchant(); return end
    local bag, slot = button:GetAttribute("target-bag"), button:GetAttribute("target-slot")
    local stale = item.bag ~= bag or item.slot ~= slot or App.GetBagItemLinkSafe(bag, slot) ~= item.link
    if not stale and button:GetAttribute("target-key") then
        stale = App.InstanceIdentity(bag, slot, item.link) ~= button:GetAttribute("target-key")
    end
    if stale then
        if combat then
            -- Lua cannot cancel a secure action during lockdown. Defer rearming.
            App.ClearPendingDisenchant()
            App.needsRefreshAfterCombat = true
        else retry(App.RefreshWorkspace) end
        return
    end
    if not combat and App.TryBlacklistQueuedItemBeforeCast() then retry(App.SyncActionTarget); return end
    App.nextAllowedQueueClickAt, App.pendingLootUntil = now + 0.35, now + 6
    App.SetPendingDisenchant(item)
    if App.activeMode.key == "disenchant" then ns.Statistics.Prepare(item) end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
