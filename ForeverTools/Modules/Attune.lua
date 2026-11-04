local _, FT = ...
local M = {
    title = "Attune: Freischaltungen und Questketten",
    description = "Dungeon-, Schlachtzugs- und Klassenquests mit Fortschritt, Karte und Belohnungen. Öffnen: /ftattune. Einstellungen und Charakterdaten werden aus Attune übernommen.",
}
FT:RegisterModule("attune", M)
local function Clone(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local copy = {}; seen[value] = copy
    for key, item in pairs(value) do copy[key] = Clone(item, seen) end
    return copy
end
function M:Active()
    return self.settings and FT:IsEnabled("attune") and not self.legacyBlocked and not self.failed or false
end
function M:IsAvailable() return FT.attuneEnv and FT.attuneEnv.FTAttune ~= nil end
function M:Apply()
    local env = FT.attuneEnv
    local app = env and env.FTAttune
    if not app or not app.ftReady then return end
    if not self:Active() then
        env.epoch = env.epoch + 1
        app:Disable()
        return
    end
    if IsLoggedIn and not IsLoggedIn() then return end
    app:Enable()
end
function M:Open(options)
    if self.legacyBlocked then
        FT:Print("Attune wurde übernommen. Bitte nochmals /reload eingeben.")
        return
    end
    if not self:Active() then FT:Print("Attune bitte im /ad-Menü einschalten."); return end
    self:Apply()
    local app = FT.attuneEnv and FT.attuneEnv.FTAttune
    if not app or not app.ftStarted then FT:Print("Attune ist noch nicht bereit. Bitte die Lua-Fehlermeldung prüfen."); return end
    if options then LibStub("AceConfigDialog-3.0"):Open("FTAttune")
    else FT.attuneEnv.FTAttune_SlashCommandHandler("") end
end
function M:OnSettingsChanged() self:Apply() end
function M:Initialize()
    local api = C_AddOns or _G
    self.legacyBlocked = api.IsAddOnLoaded and api.IsAddOnLoaded("Attune") or false
    if not ForeverToolsAttuneMigrated and type(Attune_DB) == "table" then
        if type(ForeverToolsAttuneDB) ~= "table" then
            ForeverToolsAttuneDB = Clone(Attune_DB)
        else
            ForeverToolsAttuneDB.toons = ForeverToolsAttuneDB.toons or {}
            for key, toon in pairs(Attune_DB.toons or {}) do
                if not ForeverToolsAttuneDB.toons[key] then ForeverToolsAttuneDB.toons[key] = Clone(toon) end
            end
        end
        ForeverToolsAttuneLastViewed = Clone(AttuneLastViewed)
        ForeverToolsAttuneTreeExpandStatus = Clone(TreeExpandStatus)
        ForeverToolsAttuneMigrated = true
    end
    ForeverToolsAttuneDB = type(ForeverToolsAttuneDB) == "table" and ForeverToolsAttuneDB or {}
    if self.legacyBlocked then FT:RetireLegacyAddon("Attune") end
    self.events = CreateFrame("Frame")
    self.events:RegisterEvent("PLAYER_LOGIN")
    self.events:SetScript("OnEvent", function() self:Apply() end)
    -- AceAddon initializes after the files have loaded; defer the first attempt.
    if C_Timer and C_Timer.After then C_Timer.After(0, function() self:Apply() end) end
end
M.actions = {
    {title = "Freischaltungen und Questketten öffnen", run = function() M:Open() end},
    {title = "Attune-Einstellungen öffnen", run = function() M:Open(true) end},
}
SLASH_FOREVERTOOLSATTUNE1 = "/ftattune"
SlashCmdList.FOREVERTOOLSATTUNE = function(message)
    M:Open(message == "options" or message == "settings")
end
