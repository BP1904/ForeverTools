-- Embedded from Disenchantry 1.1.2 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local L = ns.L
local Stats = {}
ns.Statistics = Stats
local db, session, window, pending, target
local lifetime = false

local function empty()
    return {count = 0, vendor = 0, materials = {}, items = {}, qualities = {}, ahValue = 0, unknownAH = 0}
end

function Stats.CancelTarget() target = nil end

function Stats.Prepare(item)
    local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
    local vendor = item and select(11, getInfo(item.link))
    local quality = item and select(3, getInfo(item.link))
    local id = item and tonumber(item.link:match("item:(%d+)"))
    local ah = id and ns.Prices.GetAuctionatorValue(id)
    target = item and {vendor = vendor, ah = ah, link = item.link, quality = quality, expires = GetTime() + 10} or nil
end

local function money(value)
    if value == 0 then return "0" end
    return (value < 0 and "-" or "") .. ns.Prices.FormatMoney(math.abs(value))
end

function Stats.Refresh()
    if not window or not window:IsShown() then return end
    local data = lifetime and db.total or session
    local rows, value, missing = {}, 0, false
    local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
    for id, count in pairs(data.materials) do
        local name, link = getInfo(id)
        local price = ns.Prices.GetAuctionatorValue(id)
        if price then value = value + price * count else missing = true end
        rows[#rows + 1] = {id = id, name = name or ("#" .. id), link = link or ("item:" .. id), count = count, price = price}
    end
    table.sort(rows, function(a, b) return a.name < b.name end)
    local itemValue = data.ahValue or 0
    local qualities = {}
    for quality = 2, 5 do
        local count = (data.qualities or {})[quality]
        if count then
            local color = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality]
            qualities[#qualities + 1] = (color and color.hex or "|cffffffff")
                .. (_G["ITEM_QUALITY" .. quality .. "_DESC"] or tostring(quality)) .. ": " .. count .. "|r"
        end
    end
    window.summary:SetText(string.format(L.STATS_OVERVIEW, data.count, money(data.vendor), data.maxLink or L.UNKNOWN or "—")
        .. "\n" .. L.STATS_QUALITY .. " " .. table.concat(qualities, "   "))
    window.itemValue:SetText(money(itemValue))
    window.materialValue:SetText(money(value))
    local profit = value - (db.useVendor and data.vendor or itemValue)
    local incomplete = missing
        or (db.useVendor and (data.unknownVendor or 0) > 0)
        or (not db.useVendor and (data.unknownAH or 0) > 0)
    window.profitLabel:SetText((profit < 0 and L.STATS_LOSS or L.STATS_PROFIT) .. (incomplete and " *" or ""))
    window.profitLabel:SetTextColor(profit < 0 and 1 or 0.2, profit < 0 and 0.25 or 1, 0.2)
    window.profitValue:SetText(money(profit))
    window.basis:SetText(db.useVendor and L.STATS_BASIS_VENDOR or L.STATS_BASIS_AH)
    window.warning:SetText(incomplete and L.STATS_INCOMPLETE or "")
    window.sessionButton:SetEnabled(lifetime)
    window.totalButton:SetEnabled(not lifetime)
    window.rows = window.rows or {}
    for index, entry in ipairs(rows) do
        local row = window.rows[index]
        if not row then
            row = CreateFrame("Button", nil, window.content)
            row:SetHeight(28)
            row:SetPoint("TOPLEFT", 0, -(index - 1) * 28)
            row:SetPoint("RIGHT", window.content, "RIGHT", 0, 0)
            row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            row.text:SetPoint("LEFT", 28, 0)
            row.text:SetWidth(170)
            row.text:SetWordWrap(false)
            row.icon = row:CreateTexture(nil, "ARTWORK")
            row.icon:SetSize(22, 22)
            row.icon:SetPoint("LEFT", 0, 0)
            row.count = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            row.count:SetPoint("RIGHT", row, "RIGHT", -200, 0)
            row.unit = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            row.unit:SetPoint("RIGHT", row, "RIGHT", -100, 0)
            row.total = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            row.total:SetPoint("RIGHT", row, "RIGHT", 0, 0)
            row.text:SetJustifyH("LEFT")
            ns.UI.BindTooltip(row, function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(self.link)
                GameTooltip:Show()
            end)
            window.rows[index] = row
        end
        row.link = entry.link
        local getIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
        row.icon:SetTexture(getIcon and getIcon(entry.id) or 134400)
        row.text:SetText(entry.name)
        row.count:SetText(entry.count)
        row.unit:SetText(entry.price and money(entry.price) or "—")
        row.total:SetText(entry.price and money(entry.price * entry.count) or "—")
        row:Show()
    end
    for index = #rows + 1, #window.rows do window.rows[index]:Hide() end
    window.content:SetHeight(math.max(1, #rows * 28))
    window.empty:SetShown(#rows == 0)
    local viewport = math.max(28, math.min(168, #rows * 28))
    window:SetHeight(174 + viewport + 150)
    window.scroll.ScrollBar:SetShown(#rows * 28 > viewport)
    window.scroll:SetVerticalScroll(math.min(window.scroll:GetVerticalScroll(), math.max(0, #rows * 28 - viewport)))
end

function Stats.Toggle()
    if window:IsShown() then window:Hide() else window:Show(); window:Raise(); Stats.Refresh() end
end

function Stats.Initialize(root, createWindow, createButton)
    root.statistics = type(root.statistics) == "table" and root.statistics or {}
    db = root.statistics
    db.characters = type(db.characters) == "table" and db.characters or {}
    local key = UnitGUID("player") or ((UnitName("player") or "") .. "-" .. (GetRealmName() or ""))
    db.characters[key] = db.characters[key] or {}
    local settings = db
    db = db.characters[key]
    db.total = db.total or empty()
    if not db.total.items then
        db.legacyCount = db.total.count
        db.total.items = {}
    end
    db.total.qualities = db.total.qualities or {}
    if db.total.ahValue == nil then db.total.ahValue = 0; db.total.unknownAH = db.total.count end
    session = empty()
    window = createWindow("ForeverToolsDisenchantry_StatisticsFrame", 520, 380)
    window.title:SetText(L.STATS_BUTTON)
    local point = settings.point
    if type(point) == "table" and type(point.x) == "number" and type(point.y) == "number" then
        window:SetPoint("CENTER", UIParent, "BOTTOMLEFT", point.x, point.y)
    else window:SetPoint("CENTER") end
    window.TitleBar:HookScript("OnDragStop", function()
        local x, y = window:GetCenter()
        settings.point = {x = x, y = y}
    end)
    window:Hide()
    local function button(label, x, callback)
        local b = createButton(window)
        b:SetSize(152, 22)
        b:SetPoint("TOPLEFT", x, -42)
        b:SetText(label)
        b:SetScript("OnClick", callback)
        return b
    end
    window.sessionButton = button(L.STATS_SESSION, 16, function() lifetime = false; Stats.Refresh() end)
    window.totalButton = button(L.STATS_TOTAL, 184, function() lifetime = true; Stats.Refresh() end)
    button(L.STATS_RESET, 352, function() session = empty(); lifetime = false; Stats.Refresh() end)
    window.summary = window:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    window.summary:SetPoint("TOPLEFT", 18, -74)
    window.summary:SetPoint("RIGHT", -18, 0)
    window.summary:SetJustifyH("LEFT")
    window.summary:SetSpacing(3)
    local scroll = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
    window.scroll = scroll
    scroll:SetPoint("TOPLEFT", 18, -174)
    scroll:SetPoint("BOTTOMRIGHT", -36, 150)
    window.content = CreateFrame("Frame", nil, scroll)
    window.content:SetSize(466, 1)
    scroll:SetScrollChild(window.content)
    window.empty = window:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    window.empty:SetPoint("TOPLEFT", 18, -179)
    window.empty:SetText(L.STATS_EMPTY)
    local function text(parent, label, x, y, right, bottom)
        local f = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        f:SetPoint(bottom and (right and "BOTTOMRIGHT" or "BOTTOMLEFT") or (right and "TOPRIGHT" or "TOPLEFT"), x, y)
        f:SetText(label)
        return f
    end
    local heading = text(window, L.STATS_MATERIALS, 18, -153)
    heading:SetTextColor(1, 0.82, 0)
    text(window, L.STATS_COUNT, -236, -153, true)
    text(window, L.STATS_UNIT, -136, -153, true)
    text(window, L.STATS_VALUE, -36, -153, true)
    local function separator(y)
        local line = window:CreateTexture(nil, "ARTWORK")
        line:SetColorTexture(0.65, 0.48, 0.18, 0.6)
        line:SetPoint("BOTTOMLEFT", 18, y)
        line:SetPoint("BOTTOMRIGHT", -18, y)
        line:SetHeight(1)
    end
    separator(143)
    text(window, L.STATS_AH_ITEMS, 18, 126, false, true)
    window.itemValue = text(window, "", -20, 126, true, true)
    text(window, L.STATS_AH_MATERIALS, 18, 104, false, true)
    window.materialValue = text(window, "", -20, 104, true, true)
    window.profitLabel = text(window, L.STATS_PROFIT, 18, 82, false, true)
    window.profitValue = text(window, "", -20, 82, true, true)
    window.basis = createButton(window)
    window.basis:SetSize(260, 22)
    window.basis:SetPoint("BOTTOMLEFT", 16, 49)
    window.basis:SetScript("OnClick", function() db.useVendor = not db.useVendor; Stats.Refresh() end)
    window.warning = text(window, "", 18, 32, false, true)
    window.warning:SetTextColor(1, 0.8, 0.2)
    local note = text(window, L.STATS_ESTIMATE, 18, 14, false, true)
    note:SetTextColor(0.6, 0.6, 0.6)
    UISpecialFrames[#UISpecialFrames + 1] = "ForeverToolsDisenchantry_StatisticsFrame"
end

local function lootPattern(template)
    return "^" .. template:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"):gsub("%%%%s", "(.+)"):gsub("%%%%d", "(%%d+)") .. "$"
end

function Stats.OnEvent(event, ...)
    if not db then return end
    if event == "UNIT_SPELLCAST_SENT" then
        local unit, _, castGUID, spell = ...
        if unit == "player" and spell == 13262 and target and not target.castGUID and target.expires >= GetTime() then
            target.castGUID = castGUID
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, castGUID, spell = ...
        if unit ~= "player" or spell ~= 13262 then return end
        pending = {expires = GetTime() + 8, candidates = {}}
        local item = target and target.expires >= GetTime() and target.castGUID == castGUID and target
        local vendor = item and item.vendor
        for _, data in ipairs({session, db.total}) do
            data.count = data.count + 1
            if item and item.ah then data.ahValue = data.ahValue + item.ah
            else data.unknownAH = (data.unknownAH or 0) + 1 end
            if item and item.link then
                data.items[item.link] = (data.items[item.link] or 0) + 1
                if item.quality then data.qualities[item.quality] = (data.qualities[item.quality] or 0) + 1 end
                if vendor and vendor > (data.maxVendor or -1) then data.maxVendor = vendor; data.maxLink = item.link end
            end
            if vendor then data.vendor = data.vendor + vendor
            else data.unknownVendor = (data.unknownVendor or 0) + 1 end
        end
        target = nil
        Stats.Refresh()
    elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
        local unit, _, spell = ...
        if unit == "player" and spell == 13262 then target = nil end
    elseif event == "LOOT_READY" or event == "LOOT_OPENED" then
        if not pending or GetTime() > pending.expires then pending = nil; return end
        if pending.closed then pending = nil; return end
        -- LOOT_READY and LOOT_OPENED both fire: read the window once, and sum
        -- quantities so a material split across several slots counts fully.
        if pending.open then return end
        local slots = GetNumLootItems()
        if slots == 0 then return end
        pending.open = true
        for slot = 1, slots do
            local link = GetLootSlotLink(slot)
            local id = link and tonumber(link:match("item:(%d+)"))
            local quantity = select(3, GetLootSlotInfo(slot))
            if id and quantity and quantity > 0 then pending.candidates[id] = (pending.candidates[id] or 0) + quantity end
        end
    elseif event == "LOOT_CLOSED" then
        if pending then pending.closed = true; pending.expires = GetTime() + 2 end
    elseif event == "CHAT_MSG_LOOT" then
        if not pending or (not pending.open or pending.closed) and GetTime() > pending.expires then pending = nil; return end
        local message = ...
        if type(message) ~= "string" then return end
        local link, quantity
        if LOOT_ITEM_SELF_MULTIPLE then link, quantity = message:match(lootPattern(LOOT_ITEM_SELF_MULTIPLE)) end
        if not link and LOOT_ITEM_SELF then link = message:match(lootPattern(LOOT_ITEM_SELF)); quantity = 1 end
        local id = link and tonumber(link:match("item:(%d+)"))
        local remaining = id and pending.candidates[id]
        if not remaining then return end
        quantity = math.min(tonumber(quantity) or 1, remaining)
        pending.candidates[id] = remaining - quantity
        for _, data in ipairs({session, db.total}) do data.materials[id] = (data.materials[id] or 0) + quantity end
        Stats.Refresh()
    elseif event == "GET_ITEM_INFO_RECEIVED" then Stats.Refresh() end
end

function Stats.CancelProcessing() target=nil; pending=nil end

end
LoadComponent("ForeverTools", FT.disenchantry)
