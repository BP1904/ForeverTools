local _, FT = ...

-- Future standalone addons get a row without changing Menu.lua.
for _, entry in ipairs(FT.addonCatalog or {}) do
    if entry.folder ~= "ForeverTools" and not FT.modules[entry.module or entry.folder] then
        local folder = entry.folder
        local api = C_AddOns or _G
        local module = {
            title = entry.title,
            description = "Separates Addon. Nach Ein-/Ausschalten /reload eingeben; erstmals installierte Addons benötigen eventuell einen Spielneustart.",
        }
        function module:IsAvailable()
            return type(api.GetAddOnEnableState) == "function"
                and type(api.EnableAddOn) == "function" and type(api.DisableAddOn) == "function"
                and (not api.DoesAddOnExist or api.DoesAddOnExist(folder))
        end
        function module:Initialize()
            if self:IsAvailable() then
                local state
                if C_AddOns then state = api.GetAddOnEnableState(folder, UnitName("player"))
                else state = api.GetAddOnEnableState(UnitName("player"), folder) end
                self.settings.enabled = state > 0
            end
        end
        function module:OnSettingsChanged()
            if not self:IsAvailable() then return end
            if InCombatLockdown() then
                self:Initialize()
                FT:Print("Addon-Umschaltung bitte außerhalb des Kampfes vornehmen.")
                return
            end
            if self.settings.enabled then api.EnableAddOn(folder, UnitName("player"))
            else api.DisableAddOn(folder, UnitName("player")) end
            FT:Print("Addon-Auswahl geändert. Bitte /reload eingeben.")
        end
        FT:RegisterModule(entry.module or folder, module)
    end
end
