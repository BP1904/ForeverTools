-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Persistent state is stored exclusively under ForeverToolsDisenchantryDB.
local _, ns = ...
local App, Storage = ns.App, {}
ns.Storage = Storage
local modeKeys = {"disenchant", "milling", "prospecting"}
local defaults = {hideDisenchantChances=false, hideDisenchantValue=false, hideDisenchantMaterials=false, compactMode=true, ilvlCapEnabled=false, priceWarnEnabled=false, activeMode="disenchant"}
local types = {hideDisenchantChances="boolean", hideDisenchantValue="boolean", hideDisenchantMaterials="boolean", compactMode="boolean", ilvlCapEnabled="boolean", priceWarnEnabled="boolean", activeMode="string"}

function Storage.Normalize(input)
    local data = type(input) == "table" and input or {}
    for key, fallback in pairs(defaults) do
        if type(data[key]) ~= types[key] then data[key] = fallback end
    end
    for _, key in ipairs({"minimap", "qualityFilter", "blacklist"}) do
        if type(data[key]) ~= "table" then data[key] = {} end
    end
    if type(data.compactPoint) ~= "table" then data.compactPoint = nil end
    if type(data.priceThresholdGold) ~= "number" then data.priceThresholdGold = nil end
    local oldFlat, lists = {}, data.blacklist
    local hasModes = false
    for _, key in ipairs(modeKeys) do hasModes = hasModes or type(lists[key]) == "table" end
    if not hasModes then
        for id, blocked in pairs(lists) do if blocked == true then oldFlat[id] = true end end
        lists = {disenchant=oldFlat}; data.blacklist = lists
    end
    for _, key in ipairs(modeKeys) do if type(lists[key]) ~= "table" then lists[key] = {} end end
    for _, mode in ipairs(modeKeys) do
        local normalized = {}
        for key, blocked in pairs(lists[mode]) do
            if blocked == true then
                local id = tonumber(key) or (type(key) == "string" and tonumber(key:match("item:(%d+)")))
                normalized[id and tostring(id) or key] = true
            end
        end
        lists[mode] = normalized
    end
    if data.minimapAngle ~= nil and data.minimap.minimapPos == nil then data.minimap.minimapPos = data.minimapAngle end
    if data.hidden ~= nil and data.minimap.hide == nil then data.minimap.hide = data.hidden and true or false end
    data.minimapAngle, data.hidden = nil, nil
    data.schemaVersion = 2
    return data
end
function Storage.Open(current) return Storage.Normalize(current) end
function App.OpenPreferences()
    ForeverToolsDisenchantryDB = Storage.Open(ForeverToolsDisenchantryDB)
    App.db = ForeverToolsDisenchantryDB
    ns.ApplyLocale(App.db.language)
end

end
LoadComponent("ForeverTools", FT.disenchantry)
