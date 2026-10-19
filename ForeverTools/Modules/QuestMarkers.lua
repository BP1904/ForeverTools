local _, FT = ...
local M = {
    title = "Quest-Gegner",
    description = "Gelbes Questzeichen mit Fortschritt über dem Gegnernamen, z. B. 1/15. Gegnerplaketten auch ohne Auswahl anzeigen.",
    defaults = {objectSparkles = true, objectTooltips = true},
    options = {
        {key = "objectSparkles", title = "Quest-Sammelobjekte funkeln lassen"},
        {key = "objectTooltips", title = "Sammelobjekt-Tooltip: ! mit Zähler anzeigen"},
    },
}
FT:RegisterModule("questmarkers", M)

local function Secret(value)
    return issecretvalue and issecretvalue(value)
end

local function Safe(fn, ...)
    if not fn then return end
    local ok, value = pcall(fn, ...)
    if ok and not Secret(value) then return value end
end

local function Accessible(frame)
    return frame and frame.IsForbidden and Safe(frame.IsForbidden, frame) == false
end

-- Forever exposes the modern nameplate range (up to 100), despite its Classic ruleset.
local VISIBILITY = {
    nameplateMaxDistance = "100", nameplateShowAll = "1", nameplateShowEnemies = "1",
    nameplateShowEnemyMinus = "1", nameplateMinAlpha = "1", nameplateMaxAlpha = "1",
    nameplateNotSelectedAlpha = "1",
}
local QUEST_ICON = "|TInterface\\GossipFrame\\AvailableQuestIcon:16:16:0:0|t "
local SPARKLES = {
    outlineModeShowLootEffectWhenDisabled = "1", graphicsOutlineMode = "0", OutlineEngineMode = "0",
    raidGraphicsOutlineMode = "0", RAIDOutlineEngineMode = "0", Outline = "0",
    -- Optional on Classic clients; unknown CVars are never registered or written.
    ShowQuestObjectHighlightEffect = "1",
}
local PARTICLES = {particleDensity = 100, particleMTDensity = 100, RAIDparticleDensity = 100, RAIDparticleMTDensity = 100}
local OBJECT_INTERACTION = {
    SoftTargetInteract = "3", SoftTargetInteractRange = "60", SoftTargetInteractArc = "2",
    SoftTargetInteractOnlyInRange = "0", SoftTargetNameplateInteract = "0",
}
for key, value in pairs(SPARKLES) do VISIBILITY[key] = value end
for key, value in pairs(PARTICLES) do VISIBILITY[key] = tostring(value) end
for key, value in pairs(OBJECT_INTERACTION) do VISIBILITY[key] = value end
local CONTROLLED_KEYS = {}
for key in pairs(VISIBILITY) do CONTROLLED_KEYS[key:lower()] = true end
local GRAPHICS_KEYS = {graphicsquality = true, raidgraphicsquality = true}
for key in pairs(SPARKLES) do GRAPHICS_KEYS[key:lower()] = true end
for key in pairs(PARTICLES) do GRAPHICS_KEYS[key:lower()] = true end

function M:ScheduleVisibility(delay)
    -- The graphics engine finishes applying a preset after CVAR_UPDATE has fired.
    self.visibilityDue = GetTime() + delay
end

function M:ApplyVisibility()
    if self.applyingVisibility then return end
    if Safe(InCombatLockdown) then self.visibilityPending = true; return end
    self.visibilityPending = nil
    local get = C_CVar and C_CVar.GetCVar or GetCVar
    local set = C_CVar and C_CVar.SetCVar or SetCVar
    if not get or not set then return end
    self.applyingVisibility = true
    self.settings.visibilityBackup = self.settings.visibilityBackup or {}
    local backup = self.settings.visibilityBackup
    -- Graphics CVars affect one another: save their values before changing any of them.
    local original = {}
    for key in pairs(VISIBILITY) do original[key] = Safe(get, key) end
    for key, desired in pairs(VISIBILITY) do
        if key == "SoftTargetNameplateInteract" then desired = self.objectGate and "1" or "0" end
        local current = Safe(get, key)
        if PARTICLES[key] and tonumber(current) and tonumber(current) >= PARTICLES[key] then desired = current end
        if type(current) == "string" then
            local enabled = FT:IsEnabled("questmarkers")
                and (not (SPARKLES[key] or PARTICLES[key] or OBJECT_INTERACTION[key]) or self.settings.objectSparkles)
            if enabled then
                if original[key] ~= desired and not backup[key] then backup[key] = {previous = original[key]} end
                if current ~= desired then
                    pcall(set, key, desired)
                end
                if backup[key] then backup[key].applied = Safe(get, key) end
            elseif backup[key] then
                -- Preserve changes the player made after enabling the module.
                if original[key] == backup[key].applied then pcall(set, key, backup[key].previous) end
                backup[key] = nil
            end
        end
    end
    self.applyingVisibility = nil
    local sparkles = FT:IsEnabled("questmarkers") and self.settings.objectSparkles
    if self.sparklesActive and not sparkles then
        FT:Print("Sammelobjekte: Bereits sichtbares Funkeln kann bis zum vollständigen Spielneustart bleiben.")
    end
    self.sparklesActive = sparkles
end

local function ObjectiveName(text)
    if Secret(text) or type(text) ~= "string" then return end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    text = text:gsub("%d+%s*/%s*%d+", ""):gsub("^%s+", ""):gsub("[%s:]+$", "")
    -- Kill objectives contain the creature name, optionally followed by a localized verb.
    for _, suffix in ipairs({" getötet", " besiegt", " slain", " killed"}) do
        if text:sub(-#suffix) == suffix then text = text:sub(1, -#suffix - 1); break end
    end
    return text
end

function M:ReadQuestLog()
    self.titles = {}
    self.killObjectives = {}
    self.knownObjectGUIDs = {}
    local count = C_QuestLog and Safe(C_QuestLog.GetNumQuestLogEntries)
    if type(count) ~= "number" then return end
    for index = 1, count do
        local info = Safe(C_QuestLog.GetInfo, index)
        if type(info) == "table" and not Secret(info.title) and not Secret(info.isHeader)
            and not info.isHeader and type(info.title) == "string" then
            self.titles[info.title] = true
            local objectives = not Secret(info.questID) and Safe(C_QuestLog.GetQuestObjectives, info.questID)
            for _, objective in ipairs(type(objectives) == "table" and objectives or {}) do
                local kind, current, required = objective.type, objective.numFulfilled, objective.numRequired
                if not Secret(kind) and kind == "monster" and not Secret(current) and not Secret(required)
                    and type(current) == "number" and type(required) == "number" and required > current then
                    local name = ObjectiveName(objective.text)
                    if name and name ~= "" then
                        local entries = self.killObjectives[name] or {}
                        self.killObjectives[name] = entries
                        entries[#entries + 1] = QUEST_ICON .. current .. "/" .. required
                    end
                end
            end
        end
    end
end

function M:ProgressFromTooltipData(data)
    if type(data) ~= "table" or Secret(data.lines) or type(data.lines) ~= "table" then return "" end
    local types = Enum and Enum.TooltipDataLineType
    if not types then return "" end
    local player = Safe(UnitName, "player")
    local ownQuest, ownProgress = false, false
    local result, seen = {}, {}
    for _, line in ipairs(data.lines) do
        local text, kind = line.leftText, line.type
        if not Secret(text) and not Secret(kind) then
            if kind == types.QuestTitle then
                ownQuest = self.titles[text] == true
                ownProgress = ownQuest
            elseif kind == types.QuestPlayer then
                ownProgress = ownQuest and player ~= nil and text == player
            elseif kind == types.QuestObjective and ownProgress and type(text) == "string" then
                text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                local current, required = text:match("(%d+)%s*/%s*(%d+)")
                current, required = tonumber(current), tonumber(required)
                if current and required and required > 0 and current < required and not seen[text] then
                    seen[text] = true
                    result[#result + 1] = QUEST_ICON .. current .. "/" .. required
                end
            end
        end
    end
    return table.concat(result, "\n")
end

function M:TooltipProgress(unit)
    return self:ProgressFromTooltipData(C_TooltipInfo and Safe(C_TooltipInfo.GetUnit, unit))
end

function M:AddObjectTooltip(tooltip, data)
    if tooltip ~= GameTooltip or not FT:IsEnabled("questmarkers")
        or Safe(tooltip.IsForbidden, tooltip) or Secret(data) or type(data) ~= "table"
        or self.objectTooltipData == data then return end
    local types = Enum and Enum.TooltipDataType
    if not types or Secret(data.type) or Secret(data.guid) then return end
    -- Restrict this to world objects; bag items and creature tooltips keep their normal layout.
    if data.type == types.Item or data.type == types.Unit then return end
    local object = types.Object and data.type == types.Object
        or type(data.guid) == "string" and data.guid:match("^GameObject%-")
    if not object then
        local info = Safe(tooltip.GetPrimaryTooltipInfo, tooltip)
        local getter = type(info) == "table" and info.getterName
        object = not Secret(getter) and (getter == "GetWorldCursor" or getter == "GetWorldLootObject")
    end
    if not object then return end
    local text = self:ProgressFromTooltipData(data)
    if text == "" then return end
    if type(data.guid) == "string" then self.knownObjectGUIDs[data.guid] = true end
    if not self.settings.objectTooltips then return end
    self.objectTooltipData = data
    for line in text:gmatch("[^\n]+") do tooltip:AddLine(line, 1, 0.82, 0) end
end

function M:SetObjectGate(open)
    if self.objectGate == open then return end
    self.objectGate = open
    self:ApplyVisibility()
end

function M:ObjectNeedsSparkles(unit)
    local data = C_TooltipInfo and Safe(C_TooltipInfo.GetUnit, unit)
    if self:ProgressFromTooltipData(data) ~= "" then return true end
    -- A readable completed objective must override any cached relation to an active quest.
    if type(data) == "table" and not Secret(data.lines) and type(data.lines) == "table" then
        local kind = Enum and Enum.TooltipDataLineType and Enum.TooltipDataLineType.QuestObjective
        for _, line in ipairs(data.lines) do
            if not Secret(line.type) and kind and line.type == kind then return false end
        end
    end
    local guid = Safe(UnitGUID, unit)
    return guid and self.knownObjectGUIDs[guid]
        or C_QuestLog and Safe(C_QuestLog.UnitIsRelatedToActiveQuest, unit) == true
end

function M:ShowObjectGlow(plate)
    local glow = self.objectGlows[plate]
    if not glow then
        glow = CreateFrame("Frame", nil, plate)
        glow:SetSize(1, 1); glow:EnableMouse(false)
        glow:SetIgnoreParentAlpha(true)
        glow:SetPoint("CENTER", plate, "CENTER", 0, -30)
        glow:SetFrameLevel((Safe(plate.GetFrameLevel, plate) or 1) + 5)
        glow.stars = {}
        for index = 1, 5 do
            local star = glow:CreateTexture(nil, "OVERLAY")
            star:SetTexture("Interface\\Cooldown\\star4")
            star:SetBlendMode("ADD")
            glow.stars[index] = star
        end
        self.objectGlows[plate] = glow
    end
    glow.active = true
    glow:SetAlpha(1)
    return glow
end

function M:UpdateObjectSparkles()
    self.objectEffectActive = false
    self.objectEffectCount = 0
    for _, glow in pairs(self.objectGlows) do glow.active = false; glow:SetAlpha(0) end
    if not FT:IsEnabled("questmarkers") or not self.settings.objectSparkles then
        self.objectEffectState = "aus"; self:SetObjectGate(false); return
    end
    if Safe(InCombatLockdown) then self.objectEffectState = "wartet auf Kampfende"; return end
    local soft = "softinteract"
    local wanted = Safe(UnitIsGameObject, soft) == true and self:ObjectNeedsSparkles(soft)
    self:SetObjectGate(wanted and true or false)
    local candidates = {}
    local plate = wanted and C_NamePlate and Safe(C_NamePlate.GetNamePlateForUnit, soft)
    if Accessible(plate) then candidates[plate] = true end
    local plates = C_NamePlate and Safe(C_NamePlate.GetNamePlates)
    for _, candidate in pairs(plates or {}) do
        if Accessible(candidate) then
            local token = Safe(function() return candidate.namePlateUnitToken end)
                or Safe(candidate.GetUnit, candidate)
                or Safe(function() return candidate.UnitFrame and candidate.UnitFrame.unit end)
            if type(token) == "string" and Safe(UnitIsGameObject, token) == true
                and self:ObjectNeedsSparkles(token) then candidates[candidate] = true end
        end
    end
    -- Each accessible object is checked independently; never reuse another object's position.
    for candidate in pairs(candidates) do
        local glow = self:ShowObjectGlow(candidate)
        self.objectEffectCount = self.objectEffectCount + 1
        if self.objectEffectCount == 1 then self.objectGlow = glow; self.objectAnchor = candidate end
    end
    self.objectEffectActive = self.objectEffectCount > 0
    if self.objectEffectActive then
        self.objectEffectState = "eigenes Funkeln an " .. self.objectEffectCount .. " Objekten"
    elseif wanted then self.objectEffectState = "wartet auf Objekt-Anker"
    else self.objectEffectState = "keine verfügbaren Questobjekt-Anker" end
end

function M:AnimateObjectSparkles(delta)
    if not self.objectEffectActive then return end
    if Safe(InCombatLockdown) then
        for _, glow in pairs(self.objectGlows) do glow:SetAlpha(0) end
        return
    end
    self.objectGlowTime = (self.objectGlowTime or 0) + math.min(delta, 0.1)
    for _, glow in pairs(self.objectGlows) do
        if glow.active then
            for index, star in ipairs(glow.stars) do
                local phase = (self.objectGlowTime * 0.65 + index * 0.19) % 1
                local brightness = math.sin(phase * math.pi)
                star:ClearAllPoints()
                star:SetPoint("CENTER", glow, "CENTER", (index - 3) * 12, phase * 22 - index % 2 * 14)
                star:SetSize(8 + brightness * 20, 8 + brightness * 20)
                star:SetVertexColor(1, 0.85, 0.35, brightness)
            end
        end
    end
end

function M:InitializeObjectTooltips()
    if not GameTooltip or not TooltipDataProcessor or not TooltipDataProcessor.AddTooltipPostCall then return end
    TooltipDataProcessor.AddTooltipPostCall(TooltipDataProcessor.AllTypes or "ALL", function(tooltip, data)
        -- Restricted data or another tooltip addon must never interrupt the game's tooltip.
        pcall(self.AddObjectTooltip, self, tooltip, data)
    end)
    if GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipCleared", function() self.objectTooltipData = nil end)
        GameTooltip:HookScript("OnHide", function() self.objectTooltipData = nil end)
    end
end

function M:Progress(unit)
    if Safe(UnitIsPlayer, unit) or Safe(UnitIsDeadOrGhost, unit)
        or Safe(UnitCanAttack, "player", unit) == false then return "" end
    local ok, text = pcall(self.TooltipProgress, self, unit)
    if ok and text ~= "" then return text end
    local name = Safe(UnitName, unit)
    local entries = name and self.killObjectives[name]
    return entries and table.concat(entries, "\n") or ""
end

function M:Update(unit)
    local record = self.byUnit[unit]
    if not record then return end
    record.text:SetText("")
    if not FT:IsEnabled("questmarkers") or not Accessible(record.plate) then return end
    -- Tooltip APIs may reject units or restrict data during combat. Retry next tick.
    local ok, text = pcall(self.Progress, self, unit)
    if ok then record.text:SetText(text) end
end

function M:Attach(unit)
    if not FT:IsEnabled("questmarkers") or type(unit) ~= "string" then return end
    local plate = C_NamePlate and Safe(C_NamePlate.GetNamePlateForUnit, unit)
    if not Accessible(plate) then return end
    local native = plate.UnitFrame
    if not Accessible(native) then return end
    local container = native.HealthBarsContainer or native.healthBarsContainer
    local anchor = native.healthBar or native.HealthBar or (container and (container.HealthBar or container.healthBar))
    if not Accessible(anchor) then anchor = native end
    local record = self.byPlate[plate]
    if not record then
        local overlay = CreateFrame("Frame", nil, plate)
        overlay:EnableMouse(false)
        overlay:SetAllPoints(plate)
        local text = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        text:SetTextColor(1, 0.82, 0)
        text:SetJustifyH("CENTER")
        -- Above native name/level regions, which otherwise cover the quest sign.
        overlay:SetFrameLevel((Safe(native.GetFrameLevel, native) or 1) + 5)
        record = {plate = plate, text = text}
        self.byPlate[plate] = record
    end
    if record.unit and record.unit ~= unit then self.byUnit[record.unit] = nil end
    local previous = self.byUnit[unit]
    if previous and previous ~= record then previous.text:SetText(""); previous.unit = nil end
    record.text:ClearAllPoints()
    local name = native.name or native.Name
    if name and name.GetObjectType and Safe(name.IsForbidden, name) ~= true then
        record.text:SetPoint("BOTTOM", name, "TOP", 0, 3)
    else
        record.text:SetPoint("BOTTOM", anchor, "TOP", 0, 20)
    end
    record.unit = unit
    self.byUnit[unit] = record
    self:Update(unit)
end

function M:Refresh()
    self:UpdateObjectSparkles()
    if not FT:IsEnabled("questmarkers") then return end
    local plates = C_NamePlate and Safe(C_NamePlate.GetNamePlates)
    for _, plate in pairs(plates or {}) do
        if Accessible(plate) and Accessible(plate.UnitFrame) then
            local unit = Safe(function() return plate.namePlateUnitToken end)
                or Safe(function() return plate.UnitFrame.unit end)
                or Safe(function() return plate.UnitFrame.unitToken end)
            if type(unit) == "string" then self:Attach(unit) end
        end
    end
    for unit in pairs(self.byUnit) do self:Update(unit) end
end

function M:OnSettingsChanged()
    for _, record in pairs(self.byUnit) do record.text:SetText("") end
    self:ApplyVisibility()
    self:ScheduleVisibility(1)
    self:ReadQuestLog()
    self:Refresh()
    self.objectTooltipData = nil
    if GameTooltip then Safe(GameTooltip.RebuildFromTooltipInfo, GameTooltip) end
end

function M:Initialize()
    if self.frame then return end
    self.byUnit = {}
    self.objectGlows = setmetatable({}, {__mode = "k"})
    self.byPlate = setmetatable({}, {__mode = "k"})
    self:ApplyVisibility()
    self:ReadQuestLog()
    self:InitializeObjectTooltips()
    SLASH_FOREVERTOOLSQUEST1 = "/ftquest"
    SlashCmdList.FOREVERTOOLSQUEST = function(command)
        local get = C_CVar and C_CVar.GetCVar or GetCVar
        if type(command) == "string" and command:lower():match("^%s*sparkle%s*$") then
            FT:Print("Sammelobjekt-Funkeln: " .. (self.settings.objectSparkles and "an" or "aus")
                .. (self.visibilityPending and "; wartet auf Kampfende" or ""))
            for key, wanted in pairs(SPARKLES) do
                FT:Print(key .. "=" .. tostring(Safe(get, key)) .. " (Soll " .. wanted .. ")")
            end
            for key, minimum in pairs(PARTICLES) do
                FT:Print(key .. "=" .. tostring(Safe(get, key)) .. " (mindestens " .. minimum .. ")")
            end
            FT:Print("Objekteffekt: " .. tostring(self.objectEffectState))
            for key, wanted in pairs(OBJECT_INTERACTION) do
                if key == "SoftTargetNameplateInteract" then wanted = self.objectGate and "1" or "0" end
                FT:Print(key .. "=" .. tostring(Safe(get, key)) .. " (Soll " .. wanted .. ")")
            end
            return
        end
        local total, marked = 0, 0
        for _, record in pairs(self.byUnit) do
            total = total + 1
            local text = Safe(record.text.GetText, record.text)
            if type(text) == "string" and text ~= "" then marked = marked + 1 end
        end
        FT:Print("Quest-Gegner: " .. (FT:IsEnabled("questmarkers") and "an" or "aus")
            .. "; Plaketten " .. total .. "; markiert " .. marked
            .. "; Reichweite " .. tostring(Safe(get, "nameplateMaxDistance"))
            .. "; Gegner " .. tostring(Safe(get, "nameplateShowEnemies"))
            .. "; immer " .. tostring(Safe(get, "nameplateShowAll"))
            .. "; ohne Auswahl " .. tostring(Safe(get, "nameplateNotSelectedAlpha")))
    end
    local frame = CreateFrame("Frame")
    self.frame = frame
    for _, event in ipairs({"NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "PLAYER_ENTERING_WORLD",
        "QUEST_LOG_UPDATE", "QUEST_WATCH_UPDATE", "GROUP_ROSTER_UPDATE", "PLAYER_REGEN_ENABLED",
        "CVAR_UPDATE", "PLAYER_TARGET_CHANGED", "PLAYER_LOGIN", "PLAYER_SOFT_INTERACT_CHANGED",
        "PLAYER_REGEN_DISABLED"}) do
        frame:RegisterEvent(event)
    end
    frame:SetScript("OnEvent", function(_, event, unit)
        if Secret(unit) then return end
        if event == "CVAR_UPDATE" then
            if type(unit) == "string" and FT:IsEnabled("questmarkers") and not self.applyingVisibility then
                local key = unit:lower()
                if GRAPHICS_KEYS[key] and self.settings.objectSparkles then self:ScheduleVisibility(1)
                elseif CONTROLLED_KEYS[key] then self:ApplyVisibility() end
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            if self.visibilityPending then self:ApplyVisibility(); self:ScheduleVisibility(1); self:Refresh() end
        elseif event == "NAME_PLATE_UNIT_REMOVED" then
            local record = self.byUnit[unit]
            if record then record.text:SetText(""); record.unit = nil; self.byUnit[unit] = nil end
        elseif event == "NAME_PLATE_UNIT_ADDED" then self:Attach(unit)
        else
            if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LOGIN" then
                self:ApplyVisibility(); self:ScheduleVisibility(5)
            end
            if event == "QUEST_LOG_UPDATE" or event == "QUEST_WATCH_UPDATE"
                or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LOGIN" then self:ReadQuestLog() end
            self:Refresh()
        end
    end)
    local elapsed = 0
    frame:SetScript("OnUpdate", function(_, delta)
        self:AnimateObjectSparkles(delta)
        if self.visibilityDue and GetTime() >= self.visibilityDue then
            self.visibilityDue = nil
            self:ApplyVisibility()
        end
        elapsed = elapsed + delta
        if elapsed < 0.1 then return end
        elapsed = 0
        self:Refresh()
    end)
    self:ScheduleVisibility(5)
end
