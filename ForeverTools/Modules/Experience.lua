local _, FT = ...
local M = {
    title = "Erfahrungsleiste: XP und Erholung",
    description = "XP, fertige Quests, Erholung und Levelprognose. Ziehen verschiebt die Leiste; /ftxp zeigt Befehle.",
    defaults = {lockBar=false, questXpBar=true, questRestedText=true, showXpHourText=true,
        sessionTimeText=true, levelTimeText=true, totalPlayedText=false, showMaxLevel=false,
        resetReload=false, hideXpBar=true, darkMode=false, classColour=false,
        barWidth=600, barHeight=30, fontSize=14},
}
FT:RegisterModule("experience", M)
M.options = {
    {key="lockBar", title="Position sperren"},
    {key="questXpBar", title="XP fertiger Quests in der Leiste anzeigen"},
    {key="questRestedText", title="Quest-XP und Erholung als Text"},
    {key="showXpHourText", title="XP pro Stunde und Zeit bis zum Levelaufstieg"},
    {key="sessionTimeText", title="Sitzungszeit anzeigen"},
    {key="levelTimeText", title="Spielzeit auf dieser Stufe anzeigen"},
    {key="totalPlayedText", title="Gesamte Spielzeit anzeigen"},
    {key="showMaxLevel", title="Auch auf Höchststufe anzeigen"},
    {key="resetReload", title="Sitzung bei /reload zurücksetzen"},
    {key="hideXpBar", title="Blizzards XP-Leiste ausblenden"},
    {key="darkMode", title="Dunkle Farben verwenden"},
    {key="classColour", title="Klassenfarbe verwenden"},
}
local function Clone(t)
    if type(t) ~= "table" then return t end
    local out = {}; for k, v in pairs(t) do out[k] = Clone(v) end; return out
end
local function Clamp(n, low, high) return math.max(low, math.min(high, tonumber(n) or low)) end
local function Clock(n)
    if not n then return "--" end
    n = math.max(0, n)
    return string.format("%dh %02dm", math.floor(n / 3600), math.floor(n / 60) % 60)
end
local function XP() return UnitXP and UnitXP("player") or 0, UnitXPMax and UnitXPMax("player") or 0 end
local function Level() return UnitLevel and UnitLevel("player") or 1 end

function M:ResetSession()
    local xp, maximum = XP()
    self.session.elapsed, self.session.gained = 0, 0
    self.lastXP, self.lastMax, self.lastLevel = xp, maximum, Level()
end

function M:RecordXP()
    local xp, maximum = XP()
    local level = Level()
    local gain = xp - self.lastXP
    if level > self.lastLevel or gain < 0 then
        gain = self.lastMax - self.lastXP + xp
        self.session.levelPlayed = 0
        -- Some clients update UnitXP before UnitLevel. Remember the rollover now.
        if level <= self.lastLevel then level = self.lastLevel + 1 end
    end
    self.session.gained = self.session.gained + math.max(0, gain)
    self.lastXP, self.lastMax, self.lastLevel = xp, maximum, math.max(level, self.lastLevel)
end

function M:UpdateQuests()
    if self.scanning then return end
    self.scanning = true
    local q = C_QuestLog or {}
    local total, complete = 0, 0
    local count = q.GetNumQuestLogEntries or GetNumQuestLogEntries
    -- Modern API uses quest IDs. The legacy API uses the selected log index.
    local modern = q.GetInfo and q.GetSelectedQuest and q.SetSelectedQuest
    local getSelection = modern and q.GetSelectedQuest or GetQuestLogSelection
    local selectQuest = modern and q.SetSelectedQuest or SelectQuestLogEntry
    local selected = getSelection and getSelection()
    if count and GetQuestLogRewardXP and selectQuest then
        local ok = pcall(function()
            for i = 1, count() do
                local id, header, done
                if modern then
                    local info = q.GetInfo(i)
                    if info then id, header = info.questID, info.isHeader end
                elseif GetQuestLogTitle then
                    local title, level, tag, isHeader, collapsed, isComplete, frequency, questID = GetQuestLogTitle(i)
                    id, header, done = questID, isHeader, isComplete == 1
                end
                if id and id > 0 and not header then
                    selectQuest(modern and id or i)
                    local reward = GetQuestLogRewardXP(id) or 0
                    total = total + reward
                    if q.IsComplete then done = q.IsComplete(id)
                    elseif IsQuestComplete then done = IsQuestComplete(id) end
                    if done or (q.ReadyForTurnIn and q.ReadyForTurnIn(id)) then complete = complete + reward end
                end
            end
        end)
        if selected ~= nil then pcall(selectQuest, selected) end
        if not ok then total, complete = 0, 0 end
    end
    self.questTotal, self.questComplete, self.scanning = total, complete, false
end

function M:CreateBar()
    local f = CreateFrame("Frame", "ForeverToolsExperienceBar", UIParent)
    self.bar = f
    f:SetMovable(true); f:SetClampedToScreen(true); f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function() if not self.settings.lockBar then f:StartMoving() end end)
    f:SetScript("OnDragStop", function()
        f:StopMovingOrSizing()
        local point, _, relativePoint, x, y = f:GetPoint()
        self.session.location = {point, nil, relativePoint, x, y}
    end)
    self.bars = {}
    for i, name in ipairs({"background", "rested", "quest", "progress"}) do
        local bar = CreateFrame("StatusBar", nil, f)
        bar:SetAllPoints(f); bar:SetMinMaxValues(0, 1); bar:SetFrameLevel(f:GetFrameLevel() + i)
        bar:EnableMouse(false)
        self.bars[name] = bar
    end
    self.text = {}
    for _, name in ipairs({"level", "xp", "percent", "times", "rate", "bonus"}) do
        local text = self.bars.progress:CreateFontString(nil, "OVERLAY")
        self.text[name] = text
    end
    self.text.level:SetPoint("LEFT", f, "LEFT", 5, 0)
    self.text.xp:SetPoint("CENTER", f, "CENTER", 0, 0)
    self.text.percent:SetPoint("RIGHT", f, "RIGHT", -5, 0)
    self.text.times:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 4)
    self.text.times:SetJustifyH("LEFT")
    self.text.rate:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -4)
    self.text.rate:SetJustifyH("LEFT")
    self.text.bonus:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -4)
    self.text.bonus:SetJustifyH("RIGHT")
    f:SetScript("OnEnter", function()
        if not GameTooltip then return end
        GameTooltip:SetOwner(f, "ANCHOR_TOP")
        GameTooltip:AddLine("ForeverTools: Erfahrung")
        GameTooltip:AddLine("Ziehen: verschieben. Einstellungen: /ad → Erfahrungsleiste.", 1, 1, 1, true)
        GameTooltip:AddLine("Alle Quest-XP: " .. (self.questTotal or 0), 1, 1, 1)
        GameTooltip:AddLine("Fertige Quest-XP: " .. (self.questComplete or 0), 1, 0.6, 0)
        GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
end

function M:Layout()
    local s = self.settings
    self.bar:SetSize(Clamp(s.barWidth, 180, 1400), Clamp(s.barHeight, 10, 100))
    self.bar:SetFrameStrata(s.frameStrata or "MEDIUM")
    self.bar:ClearAllPoints()
    local p = self.session.location or s.location or {"TOP", nil, "TOP", -7, -70}
    self.bar:SetPoint(p[1], UIParent, p[3], p[4], p[5])
    local colours = s.darkMode and {
        progress={0.55, 0.45, 0.45, 1}, background={0.18, 0.16, 0.16, 0.9},
        rested={0.55, 0.45, 0.45, 0.35}, quest={0.66, 0.09, 0.09, 1},
    } or {progress={0.55, 0.2, 0.8, 1}, background={0, 0, 0, 0.6}, rested={0.31, 0.56, 1, 0.5}, quest={1, 0.59, 0, 1}}
    if s.classColour and not s.darkMode and UnitClass and RAID_CLASS_COLORS then
        local _, class = UnitClass("player"); local c = RAID_CLASS_COLORS[class]
        if c then colours.progress = {c.r, c.g, c.b, 1} end
    end
    for name, bar in pairs(self.bars) do
        bar:SetStatusBarTexture(s.bartexture or "Interface\\TargetingFrame\\UI-StatusBar")
        local c = s.darkMode and s.darkColours and s.darkColours[name]
        if c then bar:SetStatusBarColor(c.r, c.g, c.b, c.a or 1)
        else bar:SetStatusBarColor(unpack(colours[name])) end
    end
    for _, text in pairs(self.text) do
        local outline = s.fontOutline or "OUTLINE"
        if outline == "NONE" then outline = "" end
        text:SetFont(s.font or "Fonts\\FRIZQT__.TTF", Clamp(s.fontSize, 8, 30), outline)
        local c = s.darkMode and s.darkColours and s.darkColours.text
        text:SetTextColor(c and c.r or 1, c and c.g or 1, c and c.b or 1, c and c.a or 1)
    end
end

function M:NativeBar(hide)
    -- Do not hide StatusTrackingBarManager: it also contains reputation/honor bars.
    local modern
    local kinds = Enum and Enum.StatusTrackingBarType
    local kind = kinds and (kinds.Experience or kinds.Exp)
    if kind and StatusTrackingBarManager and StatusTrackingBarManager.GetBarFromEnum then
        local ok, frame = pcall(StatusTrackingBarManager.GetBarFromEnum, StatusTrackingBarManager, kind)
        if ok then modern = frame end
    end
    for _, frame in pairs({MainMenuExpBar, modern}) do
        if frame and frame.SetAlpha then
            self.native = self.native or {}
            if hide then
                if self.native[frame] == nil then self.native[frame] = frame:GetAlpha() end
                frame:SetAlpha(0)
            end
        end
    end
    if not hide then
        for frame, alpha in pairs(self.native or {}) do if frame:GetAlpha() == 0 then frame:SetAlpha(alpha) end end
        self.native = {}
    end
end

function M:Refresh()
    local xp, maximum = XP()
    local level = Level()
    local cap = GetMaxPlayerLevel and GetMaxPlayerLevel()
    if GetMaxLevelForExpansionLevel and GetExpansionLevel then
        local expansionCap = GetMaxLevelForExpansionLevel(GetExpansionLevel())
        cap = cap and math.min(cap, expansionCap) or expansionCap
    end
    local atMax = (cap and level >= cap) or maximum <= 0
    local show = self.settings.enabled and not self.legacyBlocked and (not atMax or self.settings.showMaxLevel)
    self.bar:SetShown(show)
    self:NativeBar(show and self.settings.hideXpBar)
    if not show then return end
    local s, session = self.settings, self.session
    local fraction = maximum > 0 and xp / maximum or 0
    local quest = s.questXpBar and (self.questComplete or 0) or 0
    local rested = GetXPExhaustion and GetXPExhaustion() or 0
    self.bars.background:SetValue(1)
    self.bars.progress:SetValue(fraction)
    self.bars.quest:SetValue(maximum > 0 and math.min(1, (xp + quest) / maximum) or 0)
    self.bars.rested:SetValue(maximum > 0 and math.min(1, (xp + quest + rested) / maximum) or 0)
    self.text.level:SetText("Stufe " .. level)
    self.text.xp:SetText(atMax and "Höchststufe" or string.format("%d / %d (%d fehlen)", xp, maximum, maximum - xp))
    self.text.percent:SetText(string.format("%.1f%%", fraction * 100))
    local rate = session.elapsed > 0 and session.gained * 3600 / session.elapsed or 0
    self.text.rate:SetText(s.showXpHourText and not atMax and string.format("Nächste Stufe: %s | %.0f XP/h",
        Clock(rate > 0 and (maximum - xp) * 3600 / rate or nil), rate) or "")
    self.text.bonus:SetText(s.questRestedText and not atMax and string.format("Quests: %d | Erholt: %d", self.questComplete or 0, rested) or "")
    local times = {}
    if s.levelTimeText then times[#times+1] = "Stufe: " .. Clock(session.levelPlayed) end
    if s.sessionTimeText then times[#times+1] = "Sitzung: " .. Clock(session.elapsed) end
    if s.totalPlayedText then times[#times+1] = "Gesamt: " .. Clock(session.totalPlayed) end
    self.text.times:SetText(table.concat(times, " | "))
end

function M:OnSettingsChanged()
    if not self.bar then return end
    if not self.settings.enabled or self.legacyBlocked then
        self.events:UnregisterAllEvents(); self.events:SetScript("OnUpdate", nil)
        self.bar:StopMovingOrSizing(); self.bar:Hide(); self:NativeBar(false)
        return
    end
    for _, event in ipairs({"PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION",
        "QUEST_LOG_UPDATE", "TIME_PLAYED_MSG", "PLAYER_LOGOUT"}) do self.events:RegisterEvent(event) end
    self.lastXP, self.lastMax = XP(); self.lastLevel = Level()
    self.events:SetScript("OnUpdate", function(_, elapsed)
        self.session.elapsed = self.session.elapsed + elapsed
        if self.session.totalPlayed then self.session.totalPlayed = self.session.totalPlayed + elapsed end
        if self.session.levelPlayed then self.session.levelPlayed = self.session.levelPlayed + elapsed end
        self.tick = (self.tick or 0) + elapsed
        if self.tick >= 0.5 then self.tick = 0; self:Refresh() end
    end)
    self:Layout(); self:UpdateQuests(); self:Refresh()
    if RequestTimePlayed then RequestTimePlayed() end
end

function M:Initialize()
    if not UnitXP or not UnitXPMax then return end
    ForeverToolsExperienceDB = type(ForeverToolsExperienceDB) == "table" and ForeverToolsExperienceDB or {}
    self.session = ForeverToolsExperienceDB
    local api = C_AddOns or _G
    local legacy = api.IsAddOnLoaded and api.IsAddOnLoaded("EasyExperienceBar")
    if not self.session.migrated and legacy and type(EasyExperienceDB) == "table" then
        if not self.settings.migrated then
            for k, v in pairs(EasyExperienceDB.global or {}) do self.settings[k] = Clone(v) end
            self.settings.migrated = true
        end
        local key = UnitName("player") .. " - " .. GetRealmName()
        local char = EasyExperienceDB.char and EasyExperienceDB.char[key]
        if char and char.location then self.session.location = Clone(char.location) end
        self.session.migrated = true
    end
    self.legacyBlocked = legacy and true or false
    if legacy then FT:RetireLegacyAddon("EasyExperienceBar") end
    -- Keep copied media independent of the removable standalone addon.
    for key, fallback in pairs({font="Fonts\\FRIZQT__.TTF", bartexture="Interface\\TargetingFrame\\UI-StatusBar"}) do
        local path = self.settings[key]
        if type(path) == "string" and (path:lower():find("interface[\\/]addons[\\/]easyexperiencebar[\\/]")
            or (C_UIFileAsset and C_UIFileAsset.IsKnownFile and not C_UIFileAsset.IsKnownFile(path))) then
            self.settings[key] = fallback
        end
    end
    self.session.elapsed = self.session.elapsed or 0; self.session.gained = self.session.gained or 0
    self.lastXP, self.lastMax = XP(); self.lastLevel = Level()
    self:CreateBar()
    self.events = CreateFrame("Frame")
    self.events:SetScript("OnEvent", function(_, event, a, b)
        if event == "PLAYER_ENTERING_WORLD" then
            if a or (b and self.settings.resetReload) then self:ResetSession() end
            self:UpdateQuests()
        elseif event == "PLAYER_XP_UPDATE" and (not a or a == "player") then self:RecordXP()
        elseif event == "PLAYER_LEVEL_UP" then
            -- UnitXP/UnitLevel may still report the previous level here; count on PLAYER_XP_UPDATE.
            self.session.levelPlayed = 0
        elseif event == "QUEST_LOG_UPDATE" then self:UpdateQuests()
        elseif event == "TIME_PLAYED_MSG" then self.session.totalPlayed, self.session.levelPlayed = a, b end
        self:Refresh()
    end)
    self:OnSettingsChanged()
end

function M:ResetPosition()
    self.session.location, self.settings.location = nil, nil
    self:Layout(); self:Refresh()
end
function M:Open(command)
    if not self.bar then
        FT:Print("Erfahrungsleiste konnte nicht starten. Bitte /reload eingeben und eine mögliche Lua-Fehlermeldung mitteilen.")
        return
    end
    if self.legacyBlocked then
        FT:Print("Die alte EasyExperienceBar-Version ist noch geladen. Bitte nochmals /reload eingeben; danach erscheint unsere Erfahrungsleiste.")
        return
    end
    if command == "settings" then FT:ToggleMenu(); return end
    self.settings.showMaxLevel = true
    self.settings.frameStrata = "MEDIUM"
    self.session.location = {"CENTER", nil, "CENTER", 0, 180}
    self.settings.location = nil
    FT:SetEnabled("experience", true)
    FT:Print("Erfahrungsleiste eingeblendet. Ziehen: verschieben. Einstellungen: /ad → Erfahrungsleiste.")
end
M.actions = {
    {title="Leiste sichtbar einblenden", run=function() M:Open() end},
    {title="Position zurücksetzen", run=function() M:ResetPosition() end},
    {title="Sitzungsstatistik zurücksetzen", run=function() M:ResetSession(); M:Refresh() end},
}
SLASH_FOREVERTOOLSXP1 = "/ftxp"
SlashCmdList.FOREVERTOOLSXP = function(message)
    if not M.settings then return end
    local command, value = (message or ""):match("^(%S*)%s*(.-)%s*$")
    local keys = {width="barWidth", height="barHeight", font="fontSize"}
    if command == "" or command == "show" then M:Open()
    elseif command == "reset" then M:ResetPosition()
    elseif command == "stats" then M:ResetSession(); M:Refresh()
    elseif command == "on" or command == "off" then FT:SetEnabled("experience", command == "on")
    elseif keys[command] and tonumber(value) then
        local limits = {width={180,1400}, height={10,100}, font={8,30}}
        M.settings[keys[command]] = Clamp(value, unpack(limits[command])); M:Layout(); M:Refresh()
    else FT:Print("XP-Einstellungen: /ad → Erfahrungsleiste. /ftxp show | width 600 | height 30 | font 14 | reset | stats | on | off") end
end
