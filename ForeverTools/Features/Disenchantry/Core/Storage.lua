-- Embedded from Disenchantry 1.2.6 (MIT); see LICENSE.txt and NOTICE.txt.
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
    -- Always follow the active client, including profiles with an old override.
    data.language = nil
    for key, fallback in pairs(defaults) do
        if type(data[key]) ~= types[key] then data[key] = fallback end
    end
    for _, key in ipairs({"minimap", "qualityFilter", "blacklist"}) do
        if type(data[key]) ~= "table" then data[key] = {} end
    end
    if type(data.compactPoint) ~= "table" then data.compactPoint = nil end
    if type(data.priceThresholdGold) ~= "number" then data.priceThresholdGold = nil end
    local minimum = data.auctionMinProfitCopper
    if type(minimum) ~= "number" or minimum ~= minimum or minimum < 0 or minimum > 10000000000000 then minimum = 0 end
    data.auctionMinProfitCopper = math.floor(minimum)
    if data.minimapOpenMode~="compact" and data.minimapOpenMode~="full" then data.minimapOpenMode="last" end
    if data.listPriceSource~="vendor" then data.listPriceSource="auction" end
    if data.salvagerMode~="on" and data.salvagerMode~="off" then data.salvagerMode="auto" end
    local bonus=tonumber(data.salvagerBonusPercent)
    data.salvagerBonusPercent=bonus and bonus==bonus and bonus>=0 and bonus<=1000 and bonus or 0
    local material=tonumber(data.auctionMaterialID)
    data.auctionMaterialID=material and material>0 and material<10000000 and math.floor(material) or nil
    if data.auctionatorSource ~= "average" then data.auctionatorSource = "last" end
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
    data.profitProtection = data.profitProtection==true
    local margin=tonumber(data.minDEProfitPercent)
    data.minDEProfitPercent=margin and margin==margin and margin>=0 and margin<=1000 and margin or 0
    data.schemaVersion = 2
    return data
end
function Storage.Open(current) return Storage.Normalize(current) end
function App.OpenPreferences()
    ForeverToolsDisenchantryDB = Storage.Open(ForeverToolsDisenchantryDB)
    ForeverToolsDisenchantryCharacterDB = type(ForeverToolsDisenchantryCharacterDB)=="table" and ForeverToolsDisenchantryCharacterDB or {}
    if type(ForeverToolsDisenchantryCharacterDB.hideDisenchantMaterials)~="boolean" then ForeverToolsDisenchantryCharacterDB.hideDisenchantMaterials=false end
    local character=ForeverToolsDisenchantryCharacterDB
    App.db = setmetatable({}, {
        __index=function(_,key) if key=="hideDisenchantMaterials" then return character[key] end; return ForeverToolsDisenchantryDB[key] end,
        __newindex=function(_,key,value) if key=="hideDisenchantMaterials" then character[key]=value else ForeverToolsDisenchantryDB[key]=value end end,
    })
    ns.ApplyLocale()
end

end
LoadComponent("ForeverTools", FT.disenchantry)
