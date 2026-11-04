-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local App = ns.App
local Client = {
}
ns.Client = Client
local function call(modern, legacy, ...)
    local api = modern or legacy
    if api then
        return api(...)
    end
end
function App.GetSpellNameSafe(id)
    return call(C_Spell and C_Spell.GetSpellName, GetSpellInfo, id)
end
function App.GetSpellTextureSafe(id)
    return call(C_Spell and C_Spell.GetSpellTexture, GetSpellTexture, id)
end
function App.GetItemInfoSafe(item)
    return call(C_Item and C_Item.GetItemInfo, GetItemInfo, item)
end
function App.PlayerKnowsSpellID(id)
    if not id then
        return false
    end
    return call(C_SpellBook and C_SpellBook.IsSpellKnown, IsPlayerSpell or IsSpellKnown, id) or false
end
function App.PlayerKnowsDisenchant()
    return App.PlayerKnowsSpellID(App.SPELL_ID_DISENCHANT)
end
function App.GetItemClassIDs(link)
    if not link then
        return 
    end
    local id, _, _, _, _, class, subclass = call(C_Item and C_Item.GetItemInfoInstant, GetItemInfoInstant, link)
    return class, subclass, id
end
function App.IsMillableHerb(link)
    local class, subclass = App.GetItemClassIDs(link)
    return class == App.TRADEGOODS_CLASS and subclass == App.HERB_SUBCLASS
end
function App.IsProspectableOre(link)
    local class, subclass, id = App.GetItemClassIDs(link)
    return class == App.TRADEGOODS_CLASS and subclass == App.METAL_STONE_SUBCLASS and App.PROSPECTABLE_ORE_IDS[id] == true
end
function App.StripColorCodes(text)
    if type(text) ~= "string" then
        return ""
    end
    return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h(.-)|h", "%1"))
end
function App.GetDisplayName(name, link)
    local plain = App.StripColorCodes(name)
    if plain == "" and type(link) == "string" then
        plain = App.StripColorCodes(link:match("%[(.-)%]"))
    end
    return plain ~= "" and plain or App.L.UNKNOWN_ITEM
end
function Client.ItemLevel(link)
    return call(C_Item and C_Item.GetDetailedItemLevelInfo, GetDetailedItemLevelInfo, link) or 0
end
function Client.IsPublicString(value)
    if type(value) ~= "string" then
        return false
    end
    if issecretvalue and issecretvalue(value) then
        return false
    end
    local ok, valid = pcall(function()
        return value ~= ""
    end)
    return ok and valid == true
end

end
LoadComponent("ForeverTools", FT.disenchantry)
