-- Embedded from Disenchantry 1.2.5 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local Scan, App, Buy = ns.AuctionScan, ns.App, ns.AuctionPurchase
local ru = GetLocale() == "ruRU"
local text = ru and {
    scan="Сканировать", stop="Остановить", item="Предмет / количество", buyout="Выкуп лота", value="Среднее распыление",
    profit="Прибыль / %", hint="Среднее с учётом шансов, без комиссии. Цены — из настроенного источника. Колесо мыши: прокрутка. Нажмите предмет, чтобы раскрыть лоты. Цены указаны за один лот.",
    idle="Нажмите «Сканировать». Нужны цены всех материалов в Auctionator для Forever.", browse="Загрузка списка предметов…",
    search="Проверка выгодных кандидатов · список обновляется", filtering="Быстрый отбор по сводным ценам", monitoring="Наблюдение: следующий проход через 5 сек.", loading="Загрузка данных предметов", complete="Сканирование завершено", stopped="Остановлено — неполный список",
    closed="Аукцион закрыт — результаты устарели", unsupported="Этот интерфейс аукциона не поддерживается.",
    timeout="Нет ответа сервера — список неполный. Повторите сканирование.", failed="Ошибка запроса — повторите сканирование.",
    interrupted="Поиск прерван другим поиском аукциона — список неполный.",
    counts="Кандидаты: %d/%d · Лоты: %d · Выгодные: %d · Нет цен/данных: %d", empty="Выгодных лотов пока нет.",
    round="Проход %d · В сводке: %d · Отсеяно: %d · Ждут данных: %d · Без изменений: %d",
    minimum="Минимальная прибыль за лот:", range="Показано: %d–%d из %d", noMatch="Нет лотов с указанной минимальной прибылью.",
} or {
    scan="Scan", stop="Stop", item="Item / quantity", buyout="Lot buyout", value="Expected disenchant",
    profit="Profit / %", hint="Probability-weighted estimate, no fee. Uses your price source. Mouse wheel: scroll. Click an item to expand lots. Prices are per lot.",
    idle="Click Scan. Forever requires Auctionator prices for every material.", browse="Loading item list…",
    search="Checking candidates · refreshing results", filtering="Filtering browse prices", monitoring="Monitoring: next pass in 5 sec.", loading="Loading item data", complete="Scan complete", stopped="Stopped — partial results",
    closed="Auction house closed — results are stale", unsupported="This auction interface is not supported.",
    timeout="Server timed out — partial results. Scan again.", failed="Query failed — scan again.",
    interrupted="Interrupted by another auction search — partial results.",
    counts="Candidates: %d/%d · Lots: %d · Profitable: %d · Missing prices/data: %d", empty="No profitable auctions yet.",
    round="Pass %d · Summary keys: %d · Filtered: %d · Awaiting data: %d · Unchanged: %d",
    minimum="Minimum profit per lot:", range="Showing: %d–%d of %d", noMatch="No auctions meet the minimum profit.",
}
local panel, tabLibrary, offset = nil, nil, 0
local sortKey, descending = "profit", true
local function label(parent, value, x, y, width)
    local font = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    font:SetPoint("TOPLEFT", x, y)
    font:SetWidth(width)
    font:SetJustifyH("LEFT")
    font:SetText(value)
    return font
end
local expanded = {}
local buyText = ru and {
    buy="Купить", checking="Проверка…", ready="Купить", sent="Покупка…", cancel="Отмена",
    checkingNote="Проверяем выбранный лот…", readyNote="Цена проверена. Нажмите «Купить» ещё раз для выкупа одного лота.",
    sentNote="Ожидаем результат покупки…", bought="Лот куплен.", stale="Лот изменился, исчез или проверка устарела. Повторите поиск.",
    failed="Покупка не выполнена. Проверьте сообщение игры.", money="Недостаточно денег.",
    unknown="Нет подтверждения покупки. Проверьте почту и обновите список.",
    unavailable="Лот больше не доступен. Проверьте почту; можно продолжать покупки.", release="Снять ожидание",
} or {
    buy="Buy", checking="Checking…", ready="Buy", sent="Buying…", cancel="Cancel",
    checkingNote="Checking the selected lot…", readyNote="Price verified. Click Buy again to purchase this one lot.",
    sentNote="Waiting for purchase result…", bought="Lot purchased.", stale="Lot changed, disappeared or expired. Refresh the search.",
    failed="Purchase failed. Check the game message.", money="Not enough money.",
    unknown="Purchase not confirmed. Check your mail and refresh the list.",
    unavailable="Lot is no longer available. Check your mail; you can continue buying.", release="Stop waiting",
}
local function refresh()
    if not panel then return end
    local visible = {}
    local positions = {}
    local minimum = App.db and App.db.auctionMinProfitCopper or 0
    for index, row in ipairs(Scan.rows) do
        positions[row] = index
        if row.profit >= minimum and (not ns.ForecastPolicy or ns.ForecastPolicy.MatchesMaterial(row.item, App.db and App.db.auctionMaterialID)) then visible[#visible+1] = row end
    end
    table.sort(visible, function(a, b)
        local left, right
        if sortKey == "name" then
            left, right = string.lower(a.name or a.link or ""), string.lower(b.name or b.link or "")
        else left, right = a[sortKey] or 0, b[sortKey] or 0 end
        if left == right then
            return (a.auctionID or positions[a]) < (b.auctionID or positions[b])
        end
        if descending then return left > right end
        return left < right
    end)
    local groups, order = {}, {}
    for _, row in ipairs(visible) do
        -- Full link keeps different suffixes/bonuses separate.
        local key = row.link
        if not groups[key] then groups[key]={}; order[#order+1]=key end
        groups[key][#groups[key]+1]=row
    end
    visible = {}
    for _, key in ipairs(order) do
        local lots=groups[key]
        if #lots==1 then visible[#visible+1]=lots[1]
        else
            local group={}
            for k,v in pairs(lots[1]) do group[k]=v end
            group.groupKey, group.groupLots, group.target = key, lots, lots[1]
            visible[#visible+1]=group
            if expanded[key] then for _, row in ipairs(lots) do visible[#visible+1]=row end end
        end
    end
    local note = buyText[Buy.state .. "Note"] or buyText[Buy.state]
    panel.hint:SetText(note or text.hint)
    panel.scan:SetEnabled(not Buy.active)
    panel.cancelBuy:SetShown(Buy.active)
    panel.cancelBuy:SetText(Buy.state=="sent" and buyText.release or buyText.cancel)
    for key, header in pairs(panel.headers) do
        header.label:SetText(header.title .. (key == sortKey and (descending and " v" or " ^") or ""))
        header.label:SetTextColor(1, key == sortKey and 1 or 0.82, key == sortKey and 1 or 0)
    end
    panel.scan:SetText(Scan.running and text.stop or text.scan)
    local phase = (Scan.round or 0) > 1 and (ru and "Снайпер: " or "Sniper: ") or (ru and "Первичный проход: " or "Initial scan: ")
    panel.status:SetText(phase .. (text[Scan.state] or Scan.state) .. "\n" .. string.format(text.counts,
        math.min(Scan.index or 0, #(Scan.keys or {})), #(Scan.keys or {}), Scan.checked, #Scan.rows, Scan.skipped)
        .. "\n" .. string.format(text.round, Scan.round or 0, Scan.total or 0, Scan.filtered or 0, Scan.missingData or 0, Scan.unchanged or 0))
    local maximum = math.max(0, #visible - #panel.rows)
    offset = math.max(0, math.min(offset, maximum))
    panel.syncScroll = true
    panel.scrollbar:SetMinMaxValues(0, maximum)
    panel.scrollbar:SetValue(offset)
    panel.scrollbar:SetShown(maximum > 0)
    panel.syncScroll = false
    panel.range:SetText(string.format(text.range, #visible > 0 and offset+1 or 0, math.min(offset+#panel.rows, #visible), #visible))
    panel.empty:SetText(minimum > 0 and text.noMatch or text.empty)
    panel.empty:SetShown(#visible == 0)
    for index, button in ipairs(panel.rows) do
        local row = visible[index + offset]
        if button.row ~= row then ns.UI.DismissTooltip(button) end
        button.row = row
        if row then
            button.icon:SetTexture(row.icon or 134400)
            button.name:SetText((row.groupLots and (expanded[row.groupKey] and "[-] " or "[+] ") or "") .. row.link .. (row.groupLots and (" (" .. #row.groupLots .. ")") or ""))
            button.quantity:SetText(tostring(row.quantity))
            button.buyout:SetText(ns.Prices.FormatMoney(row.buyout))
            button.value:SetText(ns.Prices.FormatMoney(row.value))
            button.profit:SetText("|cff40ff80" .. ns.Prices.FormatMoney(row.profit) .. "|r")
            local selected = Buy.active and Buy.row and Buy.row.auctionID == row.auctionID
            button.purchase:SetText(selected and (buyText[Buy.state] or buyText.buy) or buyText.buy)
            button.purchase:SetEnabled(Scan.open and (not Buy.active or selected and Buy.state=="ready"))
            button:Show()
        else button:Hide() end
    end
end
local function scroll(_, delta)
    offset=offset-delta*3
    refresh()
end
Scan.OnChanged = refresh
local function create()
    if not ns.IsEnabled() then return end
    if ns.ftAuctionTab then ns.ftAuctionTab:Show() end
    if panel or not AuctionHouseFrame or not AuctionHouseFrame.Tabs or not AuctionHouseFrame.SetDisplayMode then return end
    Scan.InstallHooks()
    Buy.InstallHooks()
    local ah = AuctionHouseFrame
    panel = ns.UI.Surface(ah, "window")
    panel:SetPoint("TOPLEFT", ah, "TOPLEFT", 5, -34)
    panel:SetPoint("BOTTOMRIGHT", ah, "BOTTOMRIGHT", -5, 5)
    panel:SetFrameLevel(ah:GetFrameLevel()+10)
    panel:EnableMouse(true)
    panel:Hide()
    panel.scan = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    panel.scan:SetSize(145, 26)
    panel.scan:SetPoint("TOPLEFT", 15, -12)
    panel.scan:SetScript("OnClick", function()
        if Scan.running then Scan.Stop() else offset=0; Scan.Start() end
    end)
    panel.status = label(panel, "", 175, -12, 590)
    panel.status:SetHeight(44)
    panel.hint = label(panel, text.hint, 15, -58, 745)
    panel.hint:SetWidth(620)
    panel.hint:SetHeight(32)
    panel.cancelBuy=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
    panel.cancelBuy:SetSize(100,24)
    panel.cancelBuy:SetPoint("TOPRIGHT",-18,-58)
    panel.cancelBuy:SetText(buyText.cancel)
    panel.cancelBuy:SetScript("OnClick",function() Buy.Cancel(Buy.state=="sent" and "unknown" or nil) end)
    label(panel, text.minimum, 15, -94, 245)
    panel.moneyFields = {}
    local units = {{"Gold",10000,999999999,78}, {"Silver",100,99,36}, {"Copper",1,99,36}}
    local function savedPart(index)
        local amount = App.db and App.db.auctionMinProfitCopper or 0
        local value = math.floor(amount/units[index][2])
        return index == 1 and value or value%100
    end
    local x = 265
    for index, unit in ipairs(units) do
        local field = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
        panel.moneyFields[index] = field
        field:SetSize(unit[4], 24)
        field:SetPoint("TOPLEFT", x, -88)
        field:SetAutoFocus(false)
        field:SetNumeric(true)
        field:SetMaxLetters(index == 1 and 10 or 2)
        field:SetText(tostring(savedPart(index)))
        local icon = field:CreateTexture(nil, "ARTWORK")
        icon:SetSize(14,14)
        icon:SetPoint("LEFT", field, "RIGHT", 4, 0)
        icon:SetTexture("Interface\\MoneyFrame\\UI-" .. unit[1] .. "Icon")
        field:SetScript("OnTextChanged", function(_, userInput)
            if not userInput then return end
            local total = 0
            for i, input in ipairs(panel.moneyFields) do
                local raw = input:GetText()
                if raw ~= "" and not raw:match("^%d+$") then return end
                local value = tonumber(raw) or 0
                if value > units[i][3] then return end
                total = total + value*units[i][2]
            end
            if App.db then App.db.auctionMinProfitCopper = total end
            offset=0
            refresh()
        end)
        field:SetScript("OnEditFocusLost", function(self) self:SetText(tostring(savedPart(index))) end)
        field:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
        field:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        field:SetScript("OnTabPressed", function(self)
            self:ClearFocus()
            local nextField = panel.moneyFields[index%3+1]
            nextField:SetFocus(); nextField:HighlightText()
        end)
        x = x + unit[4] + 30
    end
    label(panel, ru and "Материал распыления:" or "Disenchant material:", 15, -124, 200)
    panel.material=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
    panel.material:SetSize(300,24); panel.material:SetPoint("TOPLEFT",220,-118)
    local menu=CreateFrame("Frame",nil,panel,"BackdropTemplate")
    menu:SetSize(340,252); menu:SetPoint("TOPLEFT",panel.material,"BOTTOMLEFT",0,-2)
    menu:SetFrameLevel(panel:GetFrameLevel()+30)
    menu:SetBackdrop(App.BACKDROP_PANEL); menu:SetBackdropColor(0.06,0.06,0.06,1)
    menu:EnableMouse(true); menu:Hide()
    panel.materialMenu=menu
    local materialIDs={0}
    for _,id in ipairs(ns.ForecastPolicy and ns.ForecastPolicy.MaterialIDs() or {}) do materialIDs[#materialIDs+1]=id end
    local menuOffset=0
    local function materialName(id)
        if not id or id==0 then return ru and "Все материалы" or "All materials" end
        local getInfo=C_Item and C_Item.GetItemInfo or GetItemInfo
        local name=getInfo and getInfo(id)
        return name or ("#"..id)
    end
    local function syncMaterial()
        panel.material:SetText(materialName(App.db and App.db.auctionMaterialID))
    end
    local choices={}
    local function drawMenu()
        for i,button in ipairs(choices) do
            local id=materialIDs[i+menuOffset]
            button.id=id; button:SetShown(id~=nil)
            if id then button:SetText(materialName(id)) end
        end
    end
    for i=1,10 do
        local button=CreateFrame("Button",nil,menu,"UIPanelButtonTemplate")
        button:SetSize(320,23); button:SetPoint("TOPLEFT",10,-8-(i-1)*24)
        button:SetScript("OnClick",function(self)
            if App.db then App.db.auctionMaterialID=self.id~=0 and self.id or nil end
            menu:Hide(); offset=0; syncMaterial()
            if App.ForecastPreferencesChanged then App.ForecastPreferencesChanged() else refresh() end
        end)
        button:EnableMouseWheel(true)
        button:SetScript("OnMouseWheel",function(_,delta)
            menuOffset=math.max(0,math.min(math.max(0,#materialIDs-10),menuOffset-delta*3)); drawMenu()
        end)
        choices[i]=button
    end
    menu:EnableMouseWheel(true)
    menu:SetScript("OnMouseWheel",function(_,delta)
        menuOffset=math.max(0,math.min(math.max(0,#materialIDs-10),menuOffset-delta*3)); drawMenu()
    end)
    panel.material:SetScript("OnClick",function()
        if menu:IsShown() then menu:Hide() else
            materialIDs={0}
            for _,id in ipairs(ns.ForecastPolicy and ns.ForecastPolicy.MaterialIDs() or {}) do materialIDs[#materialIDs+1]=id end
            menuOffset=math.max(0,math.min(menuOffset,math.max(0,#materialIDs-10)))
            drawMenu(); menu:Show()
        end
    end)
    syncMaterial()
    local columns = {
        {ru and "Предмет" or "Item", 15, 210, "name"},
        {ru and "Кол-во" or "Qty", 230, 70, "quantity"},
        {text.buyout, 310, 130, "buyout"}, {text.value, 445, 140, "value"},
        {ru and "Прибыль" or "Profit", 590, 95, "profit"},
    }
    panel.headers = {}
    for _, col in ipairs(columns) do
        local key = col[4]
        local header = CreateFrame("Button", nil, panel)
        header:SetPoint("TOPLEFT", col[2], -156)
        header:SetSize(col[3], 24)
        header:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        header.title = col[1]
        header.label = label(header, col[1], 0, -6, col[3])
        header.label:SetWordWrap(false)
        header:SetScript("OnClick", function()
            if sortKey == key then descending = not descending
            else sortKey, descending = key, key ~= "name" end
            offset=0
            refresh()
        end)
        panel.headers[key] = header
    end
    panel.empty = label(panel, text.empty, 15, -210, 740)
    panel.range = label(panel, "", 520, -94, 245)
    panel.scrollbar = CreateFrame("Slider", nil, panel)
    panel.scrollbar:SetOrientation("VERTICAL")
    panel.scrollbar:SetPoint("TOPRIGHT", -10, -181)
    panel.scrollbar:SetPoint("BOTTOMRIGHT", -10, 18)
    panel.scrollbar:SetWidth(16)
    panel.scrollbar:SetValueStep(1)
    panel.scrollbar:SetObeyStepOnDrag(true)
    local track = panel.scrollbar:CreateTexture(nil, "BACKGROUND")
    track:SetAllPoints()
    track:SetColorTexture(0.2, 0.17, 0.12, 0.9)
    local thumb = panel.scrollbar:CreateTexture(nil, "ARTWORK")
    thumb:SetSize(16, 35)
    thumb:SetColorTexture(0.8, 0.65, 0.3, 1)
    panel.scrollbar:SetThumbTexture(thumb)
    panel.scrollbar:SetScript("OnValueChanged", function(_, value)
        if panel.syncScroll then return end
        offset=math.floor(value+0.5)
        refresh()
    end)
    panel.scrollbar:EnableMouseWheel(true)
    panel.scrollbar:SetScript("OnMouseWheel", scroll)
    panel.rows = {}
    -- Match the native auction width; keep rows inside shorter client layouts.
    local count = math.max(5, math.floor(((ah:GetHeight() or 550 )-245)/30))
    for index=1, count do
        local button = CreateFrame("Button", nil, panel)
        button:SetPoint("TOPLEFT", 12, -181-(index-1)*30)
        button:SetPoint("RIGHT", panel, "RIGHT", -32, 0)
        button:SetHeight(29)
        button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetSize(24,24)
        button.icon:SetPoint("LEFT", 3, 0)
        button.name = label(button, "", 31, -7, 180)
        button.quantity = label(button, "", 218, -7, 68)
        button.buyout = label(button, "", 298, -7, 130)
        button.value = label(button, "", 433, -7, 140)
        button.profit = label(button, "", 578, -7, 95)
        button.purchase=CreateFrame("Button",nil,button,"UIPanelButtonTemplate")
        button.purchase:SetSize(75,24)
        button.purchase:SetPoint("LEFT",675,0)
        button.purchase:SetScript("OnClick",function()
            local row=button.row
            if not row then return end
            if Buy.active and Buy.row and Buy.row.auctionID==row.auctionID then Buy.Confirm()
            else Buy.Prepare(row.target or row) end
        end)
        button.purchase:EnableMouseWheel(true)
        button.purchase:SetScript("OnMouseWheel",scroll)
        for _, font in ipairs({button.name, button.buyout, button.value, button.profit}) do font:SetWordWrap(false) end
        ns.UI.BindTooltip(button, function(self)
            if self.row then GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetHyperlink(self.row.link); GameTooltip:Show() end
        end)
        button:SetScript("OnClick", function(self)
            if self.row and self.row.groupKey then expanded[self.row.groupKey]=not expanded[self.row.groupKey]; refresh() end
        end)
        button:EnableMouseWheel(true)
        button:SetScript("OnMouseWheel", scroll)
        panel.rows[index] = button
    end
    panel:EnableMouseWheel(true)
    panel:SetScript("OnMouseWheel", scroll)
    panel:SetScript("OnHide", function() menu:Hide(); if Scan.running then Scan.Stop() end; if Buy.active and Buy.state~="sent" then Buy.Cancel() end end)
    panel:SetScript("OnShow", refresh)
    tabLibrary = LibStub and LibStub("LibAHTab-1-0", true)
    if tabLibrary then
        tabLibrary:CreateTab("Disenchantry", panel, "Disenchantry", "Disenchantry")
    else
        -- No Auctionator: Retail can still obtain material prices through TSM.
        local tab = CreateFrame("Button", "ForeverToolsDisenchantryAuctionTab", ah, "AuctionHouseFrameDisplayModeTabTemplate")
        ns.ftAuctionTab = tab
        tab:SetText("Disenchantry")
        PanelTemplates_TabResize(tab, 10)
        tab:SetPoint("TOPLEFT", ah.Tabs[#ah.Tabs], "TOPRIGHT", 3, 0)
        PanelTemplates_DeselectTab(tab)
        tab:SetScript("OnClick", function()
            ah:SetDisplayMode({})
            ah.displayMode = nil
            for _, other in ipairs(ah.Tabs) do PanelTemplates_DeselectTab(other) end
            PanelTemplates_SelectTab(tab)
            ah:SetTitle("Disenchantry")
            panel:Show()
        end)
        hooksecurefunc(ah, "SetDisplayMode", function()
            panel:Hide(); PanelTemplates_DeselectTab(tab)
        end)
    end
    refresh()
end
local events = CreateFrame("Frame")
events:RegisterEvent("AUCTION_HOUSE_SHOW")
events:RegisterEvent("AUCTION_HOUSE_CLOSED")
if Scan.Supported() then
    for _, event in ipairs({"AUCTION_HOUSE_BROWSE_RESULTS_UPDATED", "AUCTION_HOUSE_BROWSE_RESULTS_ADDED",
        "AUCTION_HOUSE_BROWSE_FAILURE", "ITEM_SEARCH_RESULTS_UPDATED", "UI_INFO_MESSAGE", "UI_ERROR_MESSAGE", "CHAT_MSG_SYSTEM"}) do events:RegisterEvent(event) end
end
events:SetScript("OnEvent", function(_, event, ...)
    if not ns.IsEnabled() then return end
    Buy.OnEvent(event, ...)
    Scan.OnEvent(event, ...)
    if event == "AUCTION_HOUSE_SHOW" then
        -- Let Auctionator finish creating its tabs first.
        C_Timer.After(0, create)
    end
end)
local elapsed = 0
events:SetScript("OnUpdate", function(_, delta)
    if not ns.IsEnabled() or (not Buy.active and not Scan.running) then return end
    elapsed = elapsed + delta
    if elapsed >= 0.15 then elapsed=0; Buy.Tick(); Scan.Tick() end
end)

function ns.StopAuction()
    Scan.Stop(); Buy.Cancel()
    if panel then panel:Hide() end
    if ns.ftAuctionTab then ns.ftAuctionTab:Hide() end
end

end
LoadComponent("ForeverTools", FT.disenchantry)
