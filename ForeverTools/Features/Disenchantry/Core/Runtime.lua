-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Runtime context: ephemeral model state plus client-specific constants.
local _, ns = ...
local function enum(section, key, fallback)
    local values = Enum and Enum[section]
    return values and values[key] or fallback
end
local App = {
    addon=CreateFrame("Frame"), L=ns.L,
    items={}, selected={}, queue={}, sessionSkipped={},
    listRows={}, blacklistRows={}, modeTabButtons={}, compactModeMenuButtons={},
    pendingValidationToken=0, pendingLootUntil=0, pendingDisenchantUntil=0,
    nextAllowedQueueClickAt=0, valuableSkippedCount=0, needsRefreshAfterCombat=false,
    itemLoadRefreshQueued=false, itemLoadRetries={}, MAX_ITEM_LOAD_RETRIES=10,
    ROW_HEIGHT=36, ROW_SPACING=4,
    SPELL_ID_DISENCHANT=13262, SPELL_ID_MILLING=51005, SPELL_ID_PROSPECTING=31252,
    BAGS_TO_SCAN={}, PROSPECTABLE_ORE_IDS={},
}
ns.App = App
for key, name in pairs({UNCOMMON_QUALITY="Uncommon", RARE_QUALITY="Rare", EPIC_QUALITY="Epic"}) do
    App[key] = enum("ItemQuality", name, ({Uncommon=2, Rare=3, Epic=4})[name])
end
local binding = {BIND_ON_ACQUIRE={"OnAcquire",1}, BIND_ON_EQUIP={"OnEquip",2},
    BIND_ACCOUNT={"ToWoWAccount",7}, BIND_BNET={"ToBnetAccount",8}, BIND_BNET_UNTIL_EQUIP={"ToBnetAccountUntilEquipped",9}}
for key, entry in pairs(binding) do App[key] = enum("ItemBind", entry[1], entry[2]) end
App.BACKPACK_BAG = enum("BagIndex", "Backpack", 0)
App.REAGENT_BAG = enum("BagIndex", "ReagentBag")
local bag = App.BACKPACK_BAG
repeat
    table.insert(App.BAGS_TO_SCAN, bag)
    bag = bag + 1
until bag > App.BACKPACK_BAG + (NUM_BAG_SLOTS or 4)
if App.REAGENT_BAG then table.insert(App.BAGS_TO_SCAN, App.REAGENT_BAG) end
App.IS_NON_RETAIL_CLIENT = WOW_PROJECT_ID ~= nil and WOW_PROJECT_MAINLINE ~= nil and WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE
App.TRADEGOODS_CLASS = enum("ItemClass", "Tradegoods", 7)
App.HERB_SUBCLASS = enum("ItemTradegoodsSubclass", "Herb", 9)
App.METAL_STONE_SUBCLASS = enum("ItemTradegoodsSubclass", "MetalAndStone", 7)
for _, id in ipairs({2770,2771,2772,3858,10620,23424,23425,36909,36912,36910,53038,52185,52183,72092,72093,72094,72103}) do
    App.PROSPECTABLE_ORE_IDS[id] = true
end
App.BACKDROP_WINDOW = {
    bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
    tile=true, tileSize=32, edgeSize=24, insets={left=6,right=6,top=6,bottom=6},
}
App.BACKDROP_PANEL = {
    bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
    tile=true, tileSize=16, edgeSize=16, insets={left=4,right=4,top=4,bottom=4},
}
App.BACKDROP_ICON = {
    bgFile="Interface\\Buttons\\WHITE8x8", edgeFile="Interface\\Buttons\\WHITE8x8",
    edgeSize=1, insets={left=2,right=2,top=2,bottom=2},
}
local last = {time=-math.huge}
function App.Print(value)
    local message, time = tostring(value), GetTime()
    if message ~= last.message or time - last.time >= 3 then
        DEFAULT_CHAT_FRAME:AddMessage("|cff7dd3fcDisenchantry:|r " .. message)
        last.message, last.time = message, time
    end
end

local build = GetBuildInfo and GetBuildInfo()
if type(build)=="string" and build:match("^1%.60%.") then App.IS_NON_RETAIL_CLIENT=true end

end
LoadComponent("ForeverTools", FT.disenchantry)
