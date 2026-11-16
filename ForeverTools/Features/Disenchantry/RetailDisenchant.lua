-- Embedded from Disenchantry 1.2.5 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...

-- Baseline estimates, not character-specific probabilities. Reagent ranks and
-- yields depend on Enchanting skill and specialization. Keep Retail separate
-- from the pre-squish Classic tables; never infer expansion from item level.
-- Reference (community estimates, including pre-release Midnight samples):
-- https://github.com/brandanq2/disenchanting-advisor/blob/main/Data/DisenchantData.lua
-- Rows: item ID, approximate chance %, minimum, maximum, reagent rank.
local estimates = {
    [10] = { -- The War Within
        [2] = {{219946,15,1,3,1}, {219947,35,1,3,2}, {219948,50,1,2,3}},
        [3] = {{219949,15,1,1,1}, {219950,35,1,1,2}, {219951,50,1,1,3}},
        [4] = {{219952,15,1,1,1}, {219954,35,1,1,2}, {219955,50,1,1,3}},
    },
    [11] = { -- Midnight
        [2] = {{243599,10,1,2,1}, {243600,90,1,2,2}},
        [3] = {{243602,45,1,1,1}, {243603,45,1,1,2}, {243600,10,1,3,2}},
        [4] = {{243605,25,1,1,1}, {243606,75,1,1,2}},
    },
}

ns.RetailDisenchant = {}
function ns.RetailDisenchant.Get(item)
    if item.classID ~= 2 and item.classID ~= 4 then return nil end
    local expansion = estimates[item.expansionID]
    local rows = expansion and expansion[item.quality]
    if not rows then return nil end
    local results = {approximate = true}
    for _, row in ipairs(rows) do
        results[#results + 1] = {
            itemID = row[1], chance = row[2], minQuantity = row[3],
            maxQuantity = row[4], reagentRank = row[5],
        }
    end
    return results
end

end
LoadComponent("ForeverTools", FT.disenchantry)
