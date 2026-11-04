local _, FT = ...
local data = {ClassData={}, gameVersion="forever", locale=GetLocale and GetLocale() or "deDE"}
FT.trainingData = data
function data.forClass(token)
    data.ClassData[token] = data.ClassData[token] or {}
    return data.ClassData[token]
end
-- Recipe data includes translated faction names; the live reputation API supplies
-- localized names in the UI, with these readable fallbacks for unknown factions.
data.L = setmetatable({}, {__index=function(_, key) return "Fraktion " .. (key:match("%d+") or key) end})
