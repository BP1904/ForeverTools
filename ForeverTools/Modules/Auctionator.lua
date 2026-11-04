-- Original ForeverTools implementation; no Auctionator code or dependency.
local _, FT = ...
local M = {
    title = "Auktionshaus",
    description = "Kaufen, Verkaufen, Mehrfach-Einstellen, Unterbietungen, Einkaufslisten und Handwerkskosten. Vollständig in ForeverTools; kein separates Addon nötig.",
    defaults = {tooltips = true},
    options = {{key = "tooltips", title = "Scanpreis und Verkaufsvorschlag im Tooltip"}},
}
FT:RegisterModule("auctionator", M)
local function Money(value) return GetMoneyString(math.floor(value + 0.5)) end
local function Trim(value) return (value or ""):match("^%s*(.-)%s*$") end
local function Suggest(unit) return math.max(1, math.floor(unit) - 1) end

function M:Key(link)
    local item = type(link) == "string" and link:match("item:([%d:%-]+)")
    if not item then return end
    local fields = {}
    for part in (item .. ":"):gmatch("(.-):") do fields[#fields + 1] = part end
    local id = tonumber(fields[1])
    if id then return id .. ":" .. (tonumber(fields[7]) or 0) end
end

function M:Market()
    local faction
    if self.auctionOpen then faction = self.houseFaction
    else faction = UnitFactionGroup("player") end
    local key = (GetRealmName() or "?") .. ":" .. (faction or "Neutral")
    self.settings.markets = self.settings.markets or {}
    self.settings.markets[key] = self.settings.markets[key] or {prices = {}}
    return self.settings.markets[key]
end

function M:Message(text)
    self.status = text
    if self.panel then self.panel.status:SetText(text) end
    FT:Print(text)
end

function M:Cancel(reason)
    if self.StopTrading then self:StopTrading(reason) end
    local active = self.scan
    self.scan = nil
    if active and reason then self:Message(reason .. " Vorherige Preise bleiben erhalten.") end
end

function M:Ready()
    if not FT:IsEnabled("auctionator") then return false end
    if InCombatLockdown and InCombatLockdown() then self:Message("Bitte nach dem Kampf erneut versuchen."); return false end
    if not self.auctionOpen then self:Message("Bitte zuerst mit einem Auktionator sprechen."); return false end
    if not QueryAuctionItems or not CanSendAuctionQuery or not GetAuctionItemInfo or not GetNumAuctionItems or not GetAuctionItemLink then
        self:Message("Die klassische Auktionshaus-API ist in diesem Client nicht verfügbar."); return false
    end
    return true
end

function M:StartScan()
    if not self:Ready() then return end
    if self.job then self:Message("Bitte die laufende Suche zuerst abbrechen."); return end
    if self.scan then self:Message("Ein Scan läuft bereits. Bitte warten oder abbrechen."); return end
    local canQuery, canAll = CanSendAuctionQuery()
    if not canQuery or not canAll then self:Message("Der Server erlaubt gerade keinen Vollscan. Bitte später erneut versuchen."); return end
    self.scan = {started = GetTime(), prices = {}, market = self:Market()}
    self:Message("Vollscan läuft. Währenddessen nicht im Auktionshaus suchen.")
    self.issuing = true
    local ok = pcall(QueryAuctionItems, "", nil, nil, 0, false, nil, true, false, nil)
    self.issuing = nil
    if not ok then self:Cancel("Die Vollscan-Abfrage wurde abgelehnt.") end
end

function M:OnResults()
    if self.job then self:TradingResults(); return end
    local scan = self.scan
    if not scan then return end
    local count, total = GetNumAuctionItems("list")
    if type(count) ~= "number" or type(total) ~= "number" or count < total then return end
    scan.count = count; scan.index = 1; scan.prices = {}; scan.missing = 0
end

function M:Tick()
    if self.TradingTick then self:TradingTick() end
    local scan = self.scan
    if not scan then return end
    if GetTime() - scan.started > 45 then self:Cancel("Scan wegen Zeitüberschreitung abgebrochen."); return end
    if not scan.index then return end
    for i = scan.index, math.min(scan.index + 199, scan.count) do
        local name, _, count, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", i)
        local link = GetAuctionItemLink("list", i)
        local key = self:Key(link)
        if not name or not key or not count or count <= 0 or buyout == nil then
            scan.missing = scan.missing + 1
        elseif buyout > 0 then
            local unit = buyout / count
            local old = scan.prices[key]
            if not old or unit < old.unit then
                scan.prices[key] = {unit = unit, name = name, stamp = time()}
            end
        end
    end
    scan.index = scan.index + 200
    if scan.index > scan.count then
        if scan.missing > 0 then scan.index = nil; return end
        if self.SavePriceHistory then self:SavePriceHistory(scan.market, scan.prices) end
        scan.market.prices = scan.prices; scan.market.stamp = time()
        self.scan = nil
        self:Message("Vollscan fertig: " .. scan.count .. " Auktionen geprüft. Preise sind Momentaufnahmen.")
    end
end

function M:AddTooltip(tip, link)
    if not FT:IsEnabled("auctionator") or not self.settings.tooltips then return end
    local key = self:Key(link)
    local price = key and self:Market().prices[key]
    if not price then return end
    local hours = math.max(0, math.floor((time() - price.stamp) / 3600))
    tip:AddLine("FT AH/Stück: " .. Money(price.unit) .. " (Scan vor " .. hours .. " Std.)", 0.4, 1, 0.7)
    tip:AddLine("FT Verkaufsvorschlag/Stück: " .. Money(Suggest(price.unit)), 0.4, 1, 0.7)
end

function M:SaleSuggestion()
    if not FT:IsEnabled("auctionator") or not self.auctionOpen or not GetAuctionSellItemInfo then return end
    local name, _, count = GetAuctionSellItemInfo()
    if not name or not count or count < 1 then return end
    local match
    for _, price in pairs(self:Market().prices) do
        if price.name == name then
            if match then return end -- Do not guess between item variants.
            match = price
        end
    end
    if match then
        self:Message(name .. ": Vorschlag " .. Money(Suggest(match.unit)) .. "/Stück, " .. Money(Suggest(match.unit)*count) .. " für " .. count .. ". Scanpreis; aktuelle Angebote prüfen.")
    end
end

function M:Search(name)
    if self.StartSearch then return self:StartSearch(name) end
    if not self:Ready() then return end
    name = Trim(name)
    if name == "" then self:Message("Bitte einen Gegenstandsnamen eingeben."); return end
    if self.scan then self:Message("Bitte zuerst den Vollscan beenden oder abbrechen."); return end
    if not CanSendAuctionQuery() then self:Message("Suche noch gesperrt. Bitte kurz warten."); return end
    if not BrowseName or not AuctionFrameBrowse_Search then self:Message("Das normale Suchfenster ist noch nicht bereit."); return end
    if AuctionFrameTab_OnClick and AuctionFrameTab1 then AuctionFrameTab_OnClick(AuctionFrameTab1) end
    BrowseName:SetText(name)
    if AuctionFrameBrowse then
        AuctionFrameBrowse.page = 0
        AuctionFrameBrowse.selectedCategoryIndex = nil
        AuctionFrameBrowse.selectedSubCategoryIndex = nil
        AuctionFrameBrowse.selectedSubSubCategoryIndex = nil
        AuctionFrameBrowse.qualityIndex = nil
    end
    if BrowseMinLevel then BrowseMinLevel:SetText("") end
    if BrowseMaxLevel then BrowseMaxLevel:SetText("") end
    if IsUsableCheckButton then IsUsableCheckButton:SetChecked(false) end
    AuctionFrameBrowse_Search()
    self:Message("Suche: " .. name .. ". Kaufen über das normale Auktionshausfenster.")
end

function M:AddToList(name)
    if not FT:IsEnabled("auctionator") then return end
    name = Trim(name)
    if name == "" then return end
    local list = self.settings.shopping
    for _, entry in ipairs(list) do if entry:lower() == name:lower() then return end end
    if #list >= 100 then self:Message("Die Einkaufsliste ist voll (100 Einträge)."); return end
    list[#list + 1] = name; self:RefreshList()
end

function M:RemoveFromList(index)
    if not FT:IsEnabled("auctionator") then return end
    table.remove(self.settings.shopping, index)
    self.offset = math.min(self.offset or 0, math.max(0, #self.settings.shopping - 6))
    self:RefreshList()
end

function M:RefreshList()
    if not self.panel then return end
    for i, row in ipairs(self.panel.rows) do
        row.index = (self.offset or 0) + i
        row.name = self.settings.shopping[row.index]
        row.search:SetText(row.name or "–")
        row.search:SetEnabled(row.name ~= nil and FT:IsEnabled("auctionator"))
        row.remove:SetEnabled(row.name ~= nil and FT:IsEnabled("auctionator"))
    end
end

function M:Open()
    if not FT:IsEnabled("auctionator") then return end
    if not self.panel then
        local p = CreateFrame("Frame", "ForeverToolsAuctions", UIParent, "BasicFrameTemplateWithInset")
        self.panel = p
        p:SetSize(470, 430); p:SetPoint("CENTER"); p:SetClampedToScreen(true)
        p:SetMovable(true); p:EnableMouse(true); p:RegisterForDrag("LeftButton")
        p:SetScript("OnDragStart", p.StartMoving); p:SetScript("OnDragStop", p.StopMovingOrSizing)
        p.TitleText:SetText("ForeverTools – Auktionshaus")
        UISpecialFrames[#UISpecialFrames + 1] = "ForeverToolsAuctions"
        local function Button(text, x, y, width, callback)
            local b = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
            b:SetSize(width, 24); b:SetPoint("TOPLEFT", x, y); b:SetText(text); b:SetScript("OnClick", callback)
            return b
        end
        p.input = CreateFrame("EditBox", nil, p, "InputBoxTemplate")
        p.input:SetSize(420, 24); p.input:SetPoint("TOPLEFT", 25, -40)
        p.input:SetAutoFocus(false); p.input:SetMaxLetters(63)
        p.input:SetScript("OnEnterPressed", function(box) box:ClearFocus(); self:Search(box:GetText()) end)
        p.input:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
        Button("Suchen", 20, -72, 130, function() self:Search(p.input:GetText()) end)
        Button("Zur Einkaufsliste", 160, -72, 150, function() self:AddToList(p.input:GetText()) end)
        Button("Vollscan", 320, -72, 130, function() self:StartScan() end)
        p.rows = {}
        for i = 1, 6 do
            local row = {}; p.rows[i] = row
            row.search = Button("", 20, -108 - (i-1)*30, 385, function() self:Search(row.name) end)
            row.remove = Button("X", 415, -108 - (i-1)*30, 35, function() self:RemoveFromList(row.index) end)
        end
        Button("Zurück", 20, -292, 100, function() self.offset = math.max(0, (self.offset or 0)-6); self:RefreshList() end)
        Button("Weiter", 130, -292, 100, function() self.offset = math.min(math.max(0, #self.settings.shopping-6), (self.offset or 0)+6); self:RefreshList() end)
        Button("Scan abbrechen", 250, -292, 200, function() self:Cancel("Scan abgebrochen.") end)
        p.status = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        p.status:SetPoint("TOPLEFT", 20, -330); p.status:SetWidth(430); p.status:SetJustifyH("LEFT")
        p.status:SetText(self.status or "Suche und Scan beim Auktionator starten. Preise im Tooltip; Kaufen und Einstellen im normalen Auktionshausfenster.")
    end
    self.panel:SetShown(true); self:RefreshList()
end

function M:OnSettingsChanged()
    if not FT:IsEnabled("auctionator") then
        self:Cancel("Auktionsmodul ausgeschaltet.")
        if self.panel then self.panel:SetShown(false) end
    end
    if self.button then self.button:SetShown(self.auctionOpen and FT:IsEnabled("auctionator") or false) end
end

function M:Initialize()
    self.settings.shopping = self.settings.shopping or {}
    local frame = CreateFrame("Frame"); self.frame = frame
    for _, event in ipairs({"AUCTION_HOUSE_SHOW", "AUCTION_HOUSE_CLOSED", "AUCTION_ITEM_LIST_UPDATE", "PLAYER_REGEN_DISABLED", "NEW_AUCTION_UPDATE"}) do frame:RegisterEvent(event) end
    frame:SetScript("OnEvent", function(_, event, ...)
        if self.TradingEvent and self:TradingEvent(event, ...) then return end
        if event == "AUCTION_HOUSE_SHOW" then
            self.auctionOpen = true
            self.houseFaction = UnitFactionGroup("npc") -- nil means neutral auctioneer.
            if not self.button and AuctionFrame then
                self.button = CreateFrame("Button", nil, AuctionFrame, "UIPanelButtonTemplate")
                self.button:SetSize(170, 22); self.button:SetPoint("TOPLEFT", AuctionFrame, "BOTTOMLEFT", 10, 2)
                self.button:SetText("FT Auktionshaus"); self.button:SetScript("OnClick", function() self:Open() end)
            end
            self:OnSettingsChanged()
        elseif event == "AUCTION_HOUSE_CLOSED" then
            self.auctionOpen = false; self:Cancel("Auktionshaus geschlossen."); self:OnSettingsChanged()
        elseif event == "PLAYER_REGEN_DISABLED" then self:Cancel("Scan im Kampf abgebrochen.")
        elseif event == "NEW_AUCTION_UPDATE" then self:SaleSuggestion()
        else self:OnResults() end
    end)
    frame:SetScript("OnUpdate", function() self:Tick() end)
    if hooksecurefunc and QueryAuctionItems then
        hooksecurefunc("QueryAuctionItems", function()
            if not self.issuing then self:Cancel("Andere Suche gestartet.") end
        end)
    end
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tip)
            if tip == GameTooltip or tip == ItemRefTooltip then
                local _, link = tip:GetItem(); self:AddTooltip(tip, link)
            end
        end)
    else
        for _, tip in pairs({GameTooltip, ItemRefTooltip}) do
            if tip.HookScript then
                tip:HookScript("OnTooltipSetItem", function(t)
                    local _, link = t:GetItem(); self:AddTooltip(t, link)
                end)
            end
        end
    end
    if self.InitializeTrading then self:InitializeTrading() end
end

M.actions = {
    {title = "Auktionsfenster und Einkaufsliste", run = function() M:Open() end},
    {title = "Preise vollständig scannen (beim Auktionator)", run = function() M:StartScan() end},
    {title = "Scan abbrechen", run = function() M:Cancel("Scan abgebrochen.") end},
}
