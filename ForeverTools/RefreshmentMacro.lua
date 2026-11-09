local _, FT = ...

-- Only maintain the existing, plain mage refreshment macro named "wasser".
local water = {8079, 8078, 8077, 3772, 2136, 2288, 5350}
local food = {22895, 8076, 8075, 1487, 1114, 1113, 5349}
local allowed = {}
for _, ids in ipairs({water, food}) do
    for _, id in ipairs(ids) do allowed[id] = true end
end

function FT:RefreshRefreshmentMacro()
    if self.refreshmentMacroUpdating or (InCombatLockdown and InCombatLockdown()) then return end
    if not GetMacroIndexByName or not GetMacroInfo or not EditMacro then return end
    if MacroFrame and MacroFrame:IsShown() then return end
    local index = GetMacroIndexByName("wasser")
    if not index or index == 0 then return end
    local _, _, body = GetMacroInfo(index)
    if type(body) ~= "string" then return end
    local first, rest = body:match("^([^\n]*)\n(.*)$")
    if not first or not (first:match("^#showtooltip%s*$")
        or first:match("^#showtooltip%s+item:%d+%s*$")) then return end

    local present = {}
    for line in rest:gmatch("[^\r\n]+") do
        if line:match("%S") then
            local id = tonumber(line:match("^/use%s+item:(%d+)%s*$"))
            if not id or not allowed[id] then return end
            present[id] = true
        end
    end
    local count = C_Item and C_Item.GetItemCount or GetItemCount
    if not count then return end
    local selected
    for _, ids in ipairs({water, food}) do
        for _, id in ipairs(ids) do
            if present[id] and count(id, false) > 0 then selected = id; break end
        end
        if selected then break end
    end
    -- Keep a water icon with a zero count when all refreshments are gone.
    if not selected then
        for _, ids in ipairs({water, food}) do
            for _, id in ipairs(ids) do
                if present[id] then selected = id; break end
            end
            if selected then break end
        end
    end
    if not selected then return end
    local updated = "#showtooltip item:" .. selected .. "\n" .. rest
    if #updated > 255 or updated == body then return end
    self.refreshmentMacroUpdating = true
    -- The question-mark icon lets WoW display the chosen item's icon and count.
    local ok, err = pcall(EditMacro, index, nil, 134400, updated)
    self.refreshmentMacroUpdating = nil
    if not ok then error(err) end
end

local events = CreateFrame("Frame")
for _, event in ipairs({"PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "BAG_UPDATE_DELAYED",
    "UPDATE_MACROS", "PLAYER_REGEN_ENABLED"}) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function() FT:RefreshRefreshmentMacro() end)
