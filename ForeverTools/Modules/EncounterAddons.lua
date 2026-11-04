local _, FT = ...
local function Clone(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local copy = {}; seen[value] = copy
    for key, item in pairs(value) do copy[key] = Clone(item, seen) end
    return copy
end

local function Register(id, feature, title, description, saved)
    local M = {title=title, description=description .. " Ein-/Ausschalten mit /reload übernehmen."}
    FT:RegisterModule(id, M)
    function M:IsAvailable() return FT.embedded and FT.embedded[feature] ~= nil end
    function M:Initialize()
        self.runtime = FT.embedded and FT.embedded[feature]
        if not self.runtime then return end
        local api = C_AddOns or _G
        self.legacyBlocked = api.IsAddOnLoaded and api.IsAddOnLoaded(feature) or false
        if self.legacyBlocked then
            for old, new in pairs(saved) do
                if type(_G[new]) ~= "table" and type(_G[old]) == "table" then _G[new] = Clone(_G[old]) end
            end
            FT:RetireLegacyAddon(feature)
            -- Disable every old BigWigs content package for this character too.
            if feature == "BigWigs" and api.DisableAddOn and UnitName then
                for _, name in ipairs(self.runtime.order) do
                    if name ~= feature then pcall(api.DisableAddOn, name, UnitName("player")) end
                end
            end
            return
        end
        self.startedEnabled = self.settings.enabled
        if not self.startedEnabled then return end
        self.runtime.running = true
        self.ready = self.runtime:Load(feature) and true or false
        if feature == "NovaInstanceTracker" and self.ready then
            local app = self.runtime.env.NIT
            if app and app.FTInitialize then
                local ok, err = pcall(app.FTInitialize, app)
                self.ready = ok
                if not ok then FT:Print("Nova Instance Tracker: " .. tostring(err)) end
            end
        end
        if not self.ready then self.runtime:Stop() end
    end
    function M:OnSettingsChanged()
        FT:Print(self.title .. ": Änderung gespeichert. Bitte /reload eingeben.")
    end
    function M:Open(command)
        if self.legacyBlocked then FT:Print(self.title .. ": Übernahme vorbereitet. Bitte nochmals /reload eingeben."); return end
        if not self.ready or not self.settings.enabled or self.settings.enabled ~= self.startedEnabled then
            FT:Print(self.title .. ": Im /ad-Menü einschalten und /reload eingeben."); return
        end
        if InCombatLockdown and InCombatLockdown() then FT:Print("Bitte nach dem Kampf öffnen."); return end
        local handlers = self.runtime.env.SlashCmdList
        local handler = feature == "BigWigs" and handlers.BigWigs or handlers.NITCMD
        if handler then handler(command or "") end
    end
    return M
end

local BW = Register("bigwigs", "BigWigs", "BigWigs: Bosswarnungen",
    "Bosswarnungen, Timer und Einstellungen vollständig integriert. Öffnen: /ftbw.",
    {BigWigs3DB="ForeverToolsBigWigsDB", BigWigsIconDB="ForeverToolsBigWigsIconDB", BigWigsStatsDB="ForeverToolsBigWigsStatsDB"})
BW.actions = {{title="BigWigs-Einstellungen öffnen", run=function() BW:Open() end}}

local NIT = Register("novainstancetracker", "NovaInstanceTracker", "Nova Instance Tracker: Instanzen",
    "Instanzbesuche, Sperrzeiten, Erfahrung, Gold und Verlauf. Öffnen: /ftnit.",
    {NITdatabase="ForeverToolsNovaDB"})
NIT.actions = {
    {title="Instanzübersicht öffnen", run=function() NIT:Open() end},
    {title="Nova-Einstellungen öffnen", run=function() NIT:Open("options") end},
    {title="Handelsverlauf öffnen", run=function() NIT:Open("trades") end},
}
SLASH_FOREVERTOOLSBIGWIGS1 = "/ftbw"
SlashCmdList.FOREVERTOOLSBIGWIGS = function() BW:Open() end
SLASH_FOREVERTOOLSNOVA1 = "/ftnit"
SlashCmdList.FOREVERTOOLSNOVA = function(message) NIT:Open(message) end
