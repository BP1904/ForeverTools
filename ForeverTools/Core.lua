local addonName, FT = ...
_G.ForeverTools = FT
FT.name = addonName
FT.modules = {}
FT.order = {}

function FT:RetireLegacyAddon(name)
    local api = C_AddOns or _G
    if type(api.DisableAddOn) == "function" and UnitName then
        -- Migrate each character when it logs in; do not disable unmigrated alts.
        local ok = pcall(api.DisableAddOn, name, UnitName("player"))
        if ok then
            self:Print(name .. ": Einstellungen übernommen. Die alte Einzelversion ist deaktiviert; ab dem nächsten /reload läuft das integrierte Modul.")
            return
        end
    end
    self:Print(name .. ": Einstellungen übernommen. Bitte die alte Einzelversion in der Addon-Auswahl deaktivieren und /reload eingeben.")
end

function FT:Print(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff65d6adForeverTools:|r " .. message)
end

function FT:RegisterModule(id, definition)
    assert(not self.modules[id], "Duplicate ForeverTools module: " .. id)
    self.modules[id] = definition
    self.order[#self.order + 1] = id
end

function FT:IsEnabled(id)
    return self.db and self.db.modules[id].enabled
end

function FT:SetEnabled(id, enabled)
    self.db.modules[id].enabled = enabled and true or false
    local module = self.modules[id]
    if module.OnSettingsChanged then module:OnSettingsChanged() end
end

function FT:Initialize()
    ForeverToolsDB = type(ForeverToolsDB) == "table" and ForeverToolsDB or {}
    self.db = ForeverToolsDB
    self.db.modules = type(self.db.modules) == "table" and self.db.modules or {}
    for _, id in ipairs(self.order) do
        local module = self.modules[id]
        local settings = self.db.modules[id]
        if type(settings) ~= "table" then
            settings = {}
            self.db.modules[id] = settings
        end
        if settings.enabled == nil then settings.enabled = true end
        for key, value in pairs(module.defaults or {}) do
            if settings[key] == nil then settings[key] = value end
        end
        module.settings = settings
        if module.Initialize then module:Initialize() end
    end
    if self.CreateLauncher and not self.launcher then self:CreateLauncher() end
    self:Print("geladen. Menü: Minimap-Schaltfläche, /ad oder /forevertools")
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(_, _, name)
    if name == addonName then
        events:UnregisterEvent("ADDON_LOADED")
        FT:Initialize()
    end
end)
