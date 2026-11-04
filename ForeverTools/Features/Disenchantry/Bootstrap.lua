local _, FT = ...
FT.disenchantry = {}
function FT.disenchantry.IsEnabled()
    local module=FT.modules.disenchantry
    return module and module.settings and FT:IsEnabled("disenchantry") and not module.legacyBlocked or false
end
