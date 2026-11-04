-- Original ForeverTools trading views. No external addon globals are used.
local _, FT = ...
local M = FT.modules.auctionator
local function Money(n)
    if n==math.huge then return "nur Gebot" end
    return (n<0 and "-" or "") .. GetMoneyString(math.floor(math.abs(n)+0.5))
end
local function Label(parent,text,x,y,width)
    local f=parent:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
    f:SetPoint("TOPLEFT",x,y); f:SetWidth(width or 720); f:SetJustifyH("LEFT"); f:SetText(text)
    return f
end
local function Button(parent,text,x,y,width,callback)
    local b=CreateFrame("Button",nil,parent,"UIPanelButtonTemplate")
    b:SetSize(width,24); b:SetPoint("TOPLEFT",x,y); b:SetText(text); b:SetScript("OnClick",callback)
    return b
end
local function Input(parent,x,y,width,text,numeric)
    local b=CreateFrame("EditBox",nil,parent,"InputBoxTemplate")
    b:SetSize(width,24); b:SetPoint("TOPLEFT",x,y); b:SetAutoFocus(false); b:SetMaxLetters(numeric and 10 or 512)
    if numeric then b:SetNumeric(true) end
    b:SetText(text or ""); b:SetScript("OnEscapePressed",function(self) self:ClearFocus() end)
    return b
end
local function ItemTooltip(button,read)
    button:SetScript("OnEnter",function(self)
        local row=read()
        if row and row.link and GameTooltip and GameTooltip.SetHyperlink then
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:SetHyperlink(row.link); GameTooltip:Show()
        end
    end)
    button:SetScript("OnLeave",function(self)
        if GameTooltip and GameTooltip.IsOwned and GameTooltip:IsOwned(self) then GameTooltip:Hide() end
    end)
end

function M:ShowTradingTab(tab)
    if not self.panel then return end
    self.tab=tab
    for name,pane in pairs(self.panel.panes) do pane:SetShown(name==tab) end
    self:RefreshTrading()
end

function M:RefreshTrading()
    local p=self.panel
    if not p or not p.panes then return end
    local results=self.results or {}
    local offset=self.resultOffset or 0
    for i,row in ipairs(p.buy.rows) do
        local data=results[offset+i]; row.data=data
        row.label:SetText(data and (data.name .. " ×" .. data.count .. " | Stück " .. Money(data.unit)
            .. " | Gesamt " .. Money(data.buyout) .. " | " .. (data.owner or "?")) or "–")
        row.buy:SetEnabled(data~=nil and data.buyout>0 and not self:IsMine(data) and not self.job and not self.scan)
    end
    p.buy.page:SetText("Angebote " .. math.min(#results,offset+1) .. "–" .. math.min(offset+8,#results) .. " / " .. #results)
    local owned=self.owned or {}; offset=self.ownedOffset or 0
    for i,row in ipairs(p.own.rows) do
        local data=owned[offset+i]; row.data=data
        local state=data and (data.undercut and " | UNTERBOTEN: " .. Money(data.competitor) .. "/Stück" or "") or ""
        row.label:SetText(data and (data.name .. " ×" .. data.count .. " | " .. Money(data.unit) .. "/Stück" .. state) or "–")
        row.cancel:SetEnabled(data~=nil and not self.job and not self.ownerRequest and not self.scan)
    end
    p.own.page:SetText(#owned .. " geladene Auktionen. Server-Seite " .. ((self.ownerPage or 0)+1) .. ". Unterbietungsprüfung lädt alle Seiten.")
    self:RefreshList()
    self:RefreshActivity()
end

local RefreshList=M.RefreshList
function M:RefreshList()
    RefreshList(self)
    if self.panel and self.panel.lists then
        self.panel.lists.current:SetText("Aktive Liste: " .. self.settings.activeList .. " (" .. #self.settings.shopping .. "/100)")
    end
end

function M:RefreshSale()
    local p=self.panel
    if not p or not p.sell then return end
    local info=self:SellInfo()
    p.sell.item:SetText(info and (info.name .. " | " .. info.total .. " verfügbar | maximal " .. info.maxStack .. " pro Stapel")
        or "Gegenstand aus der Tasche auf diesen Knopf ziehen")
    if info then
        local old=p.sell.identity
        local identity=info.itemID .. ":" .. info.name
        if old~=identity then
            p.sell.identity=identity; p.sell.size:SetText(math.min(info.total,info.maxStack)); p.sell.stacks:SetText("1")
            local key=self:FindSellKey(info); local price=key and self:Market().prices[key]
            p.sell.unit:SetText(price and math.max(1,math.floor(price.unit)-self.settings.undercut) or "")
        end
    else p.sell.identity=nil end
end

function M:RefreshActivity()
    if not self.panel or not self.panel.history then return end
    local lines={"Letzte Aktionen (Anfragen; endgültigen Erfolg im Spiel prüfen):"}
    for i=1,math.min(10,#self.settings.activity) do
        local a=self.settings.activity[i]
        lines[#lines+1]=(date and date("%d.%m. %H:%M",a.stamp) or tostring(a.stamp)) .. " | " .. a.kind .. ": " .. a.name .. " ×" .. a.count .. " | " .. Money(a.total)
    end
    self.panel.history.activity:SetText(table.concat(lines,"\n"))
end

function M:ShowPriceHistory(name)
    local market=self:Market(); local lines={}
    for key,price in pairs(market.prices) do
        if price.name:lower()==name:lower() then
            lines[#lines+1]=price.name .. " (" .. key .. ")"
            for _,sample in ipairs((market.history or {})[key] or {}) do
                lines[#lines+1]=(date and date("%d.%m.",sample.day*86400) or tostring(sample.day)) .. ": " .. Money(sample.unit) .. "/Stück"
            end
        end
    end
    if self.panel then self.panel.history.prices:SetText(#lines>0 and table.concat(lines,"\n") or "Noch kein Preisverlauf für diesen Namen.") end
end

function M:Open()
    if not FT:IsEnabled("auctionator") then return end
    if not self.panel then
        local p=CreateFrame("Frame","ForeverToolsAuctions",UIParent,"BasicFrameTemplateWithInset")
        self.panel=p
        p:SetSize(800,650); p:SetPoint("CENTER"); p:SetClampedToScreen(true)
        p:SetMovable(true); p:EnableMouse(true); p:RegisterForDrag("LeftButton")
        p:SetScript("OnDragStart",p.StartMoving); p:SetScript("OnDragStop",p.StopMovingOrSizing)
        p.TitleText:SetText("ForeverTools – Auktionshaus")
        UISpecialFrames[#UISpecialFrames+1]="ForeverToolsAuctions"
        local tabs={{"buy","Kaufen"},{"sell","Verkaufen"},{"own","Eigene Auktionen"},{"lists","Einkaufslisten"},{"history","Verlauf"}}
        p.panes={}
        for i,entry in ipairs(tabs) do
            local key=entry[1]
            Button(p,entry[2],20+(i-1)*152,-34,145,function() self:ShowTradingTab(key) end)
            local pane=CreateFrame("Frame",nil,p)
            pane:SetSize(760,480); pane:SetPoint("TOPLEFT",20,-72)
            p.panes[key]=pane; p[key]=pane
        end
        p.status=Label(p,self.status or "Beim Auktionator öffnen. Geldbeträge in Eingabefeldern: Kupfer (1 Gold = 10000 Kupfer).",20,-576,760)
        Button(p,"Vollscan",20,-536,130,function() self:StartScan() end)
        Button(p,"Abfrage abbrechen",160,-536,170,function() self:Cancel("Abfrage abgebrochen."); self:RefreshTrading() end)
        Button(p,"Materialkosten",340,-536,150,function() self:CraftingCost(false) end)
        Button(p,"Reagenzien auf Liste",500,-536,190,function() self:CraftingCost(true) end)

        local b=p.buy
        Label(b,"Name oder Suchfilter",0,0)
        b.input=Input(b,5,-24,440,"")
        p.input=b.input
        Button(b,"Suchen",460,-24,130,function() self:StartSearch(b.input:GetText()) end)
        Button(b,"Auf Liste",600,-24,150,function() self:AddToList(b.input:GetText()) end)
        Label(b,"Filterbeispiel: Kupfererz;max=10000;minlevel=1;quality=1;exact=1",0,-60)
        Button(b,"Liste suchen",0,-86,150,function() self:SearchShopping() end)
        Button(b,"Letzte Suche",160,-86,150,function()
            self.recentIndex=(self.recentIndex or 0)%math.max(1,#self.settings.searchHistory)+1
            b.input:SetText(self.settings.searchHistory[self.recentIndex] or "")
        end)
        b.rows={}
        for i=1,8 do
            local row={}; b.rows[i]=row
            row.label=Label(b,"–",0,-128-(i-1)*34,625)
            row.buy=Button(b,"Kaufen",640,-120-(i-1)*34,110,function() self:PrepareBuy(row.data) end)
            ItemTooltip(row.buy,function() return row.data end)
        end
        Button(b,"Zurück",0,-406,120,function() self.resultOffset=math.max(0,(self.resultOffset or 0)-8); self:RefreshTrading() end)
        Button(b,"Weiter",130,-406,120,function() self.resultOffset=math.min(math.max(0,#(self.results or {})-8),(self.resultOffset or 0)+8); self:RefreshTrading() end)
        b.page=Label(b,"",270,-412,470)

        local s=p.sell
        Label(s,"Gegenstand einlegen. Preis pro Stück festlegen; das Addon berechnet den Stapelpreis.",0,0)
        local function PlaceItem()
            if not self:Ready() or self.posting then return end
            if ((CursorHasItem and CursorHasItem()) or self:SellInfo()) and AuctionSellItemButton_OnClick and AuctionsItemButton then
                AuctionSellItemButton_OnClick(AuctionsItemButton,"LeftButton")
            else self:Message("Gegenstand aus der Tasche auf das Verkaufsfeld ziehen.") end
        end
        s.item=Button(s,"Gegenstand aus Tasche hierher ziehen",0,-34,750,PlaceItem)
        s.item:SetScript("OnReceiveDrag",PlaceItem)
        Label(s,"Stückpreis (Kupfer)",0,-80,220); s.unit=Input(s,5,-106,180,"",true)
        Label(s,"Stapelgröße",250,-80,180); s.size=Input(s,255,-106,140,"1",true)
        Label(s,"Anzahl Stapel",490,-80,200); s.stacks=Input(s,495,-106,140,"1",true)
        s.duration=3
        s.durationButton=Button(s,"Laufzeit: lang",0,-150,210,function()
            s.duration=s.duration%3+1
            s.durationButton:SetText("Laufzeit: " .. ({"kurz","mittel","lang"})[s.duration])
        end)
        Button(s,"Aktuelle Konkurrenz suchen",230,-150,250,function() self:CompareSale() end)
        Button(s,"Alle vollen Stapel",500,-150,250,function()
            local info=self:SellInfo()
            if info then local size=math.min(info.total,info.maxStack); s.size:SetText(size); s.stacks:SetText(math.floor(info.total/size)) end
        end)
        Label(s,"Unterbieten um (Kupfer)",0,-204,250); s.undercut=Input(s,5,-230,180,tostring(self.settings.undercut),true)
        Button(s,"Abstand speichern",210,-230,190,function()
            local value=tonumber(s.undercut:GetText())
            if value and value>=0 and value<=1000000 and value==math.floor(value) then self.settings.undercut=value; self:Message("Preisabstand gespeichert.") end
        end)
        Button(s,"Einstellen …",0,-290,250,function() self:PrepareSale(s.unit:GetText(),s.size:GetText(),s.stacks:GetText(),s.duration) end)
        Label(s,"Die Bestätigung zeigt Stapelpreis, Menge und Anzahlung. Bei einem Preis unter der Hälfte des gespeicherten Vergleichspreises erscheint ein Hinweis. Laufzeit kurz/mittel/lang folgt dem Client.",0,-340,730)

        local o=p.own
        Button(o,"Aktualisieren",0,0,180,function() self:RequestOwned(0) end)
        Button(o,"Unterbietungen prüfen (alle)",200,0,270,function() self:StartUndercut() end)
        o.rows={}
        for i=1,8 do
            local row={}; o.rows[i]=row
            row.label=Label(o,"–",0,-54-(i-1)*36,600)
            row.cancel=Button(o,"Abbrechen …",620,-46-(i-1)*36,130,function()
                if row.data then self:RequestOwned(row.data.page,row.data) end
            end)
            ItemTooltip(row.cancel,function() return row.data end)
        end
        Button(o,"Ansicht zurück",0,-352,160,function() self.ownedOffset=math.max(0,(self.ownedOffset or 0)-8); self:RefreshTrading() end)
        Button(o,"Ansicht weiter",170,-352,160,function() self.ownedOffset=math.min(math.max(0,#(self.owned or {})-8),(self.ownedOffset or 0)+8); self:RefreshTrading() end)
        Button(o,"Server-Seite zurück",0,-386,190,function() self:RequestOwned(math.max(0,(self.ownerPage or 0)-1)) end)
        Button(o,"Server-Seite weiter",200,-386,190,function()
            if ((self.ownerPage or 0)+1)*(NUM_AUCTION_ITEMS_PER_PAGE or 50)<(self.ownerTotal or 0) then self:RequestOwned((self.ownerPage or 0)+1) end
        end)
        o.page=Label(o,"",0,-430)

        local l=p.lists
        l.current=Label(l,"",0,0)
        l.name=Input(l,5,-26,300,self.settings.activeList)
        Button(l,"Liste öffnen / anlegen",320,-26,230,function() self:SelectList(l.name:GetText()) end)
        Button(l,"Nächste Liste",560,-26,190,function()
            local names={}; for name in pairs(self.settings.lists) do names[#names+1]=name end; table.sort(names)
            local nextIndex=1
            for i,name in ipairs(names) do if name==self.settings.activeList then nextIndex=i%#names+1 end end
            self:SelectList(names[nextIndex]); l.name:SetText(self.settings.activeList)
        end)
        l.input=Input(l,5,-64,540,"")
        Button(l,"Hinzufügen",560,-64,190,function() self:AddToList(l.input:GetText()) end)
        p.rows={}
        for i=1,6 do
            local row={}; p.rows[i]=row
            row.search=Button(l,"–",0,-100-(i-1)*30,700,function() self:Search(row.name) end)
            row.remove=Button(l,"X",710,-100-(i-1)*30,40,function() self:RemoveFromList(row.index) end)
        end
        Button(l,"Zurück",0,-286,100,function() self.offset=math.max(0,(self.offset or 0)-6); self:RefreshList() end)
        Button(l,"Weiter",110,-286,100,function() self.offset=math.min(math.max(0,#self.settings.shopping-6),(self.offset or 0)+6); self:RefreshList() end)
        Button(l,"Ganze Liste suchen",230,-286,220,function() self:SearchShopping() end)
        local scroll=CreateFrame("ScrollFrame",nil,l,"UIPanelScrollFrameTemplate")
        scroll:SetSize(715,100); scroll:SetPoint("TOPLEFT",5,-320)
        l.exchange=CreateFrame("EditBox",nil,scroll)
        l.exchange:SetMultiLine(true); l.exchange:SetFontObject(ChatFontNormal); l.exchange:SetAutoFocus(false)
        l.exchange:SetWidth(700); l.exchange:SetMaxLetters(51200); l.exchange:SetText("")
        l.exchange:SetScript("OnEscapePressed",function(box) box:ClearFocus() end)
        scroll:SetScrollChild(l.exchange)
        Button(l,"Import (eine Zeile je Suche)",0,-432,260,function() self:ImportList(l.exchange:GetText()) end)
        Button(l,"Export zum Kopieren",280,-432,230,function() l.exchange:SetText(table.concat(self.settings.shopping,"\n")); l.exchange:HighlightText(); l.exchange:SetFocus() end)

        local h=p.history
        h.input=Input(h,5,0,430,"")
        Button(h,"Preisverlauf zeigen",460,0,260,function() self:ShowPriceHistory(h.input:GetText()) end)
        local scrollHistory=CreateFrame("ScrollFrame",nil,h,"UIPanelScrollFrameTemplate")
        scrollHistory:SetSize(720,175); scrollHistory:SetPoint("TOPLEFT",0,-40)
        local historyContent=CreateFrame("Frame",nil,scrollHistory); historyContent:SetSize(700,900)
        scrollHistory:SetScrollChild(historyContent)
        h.prices=Label(historyContent,"Bis zu 30 Scantage pro Gegenstandsvariante.",0,0,690)
        h.activity=Label(h,"",0,-240)
    end
    self.panel:SetShown(true); self:RefreshSale(); self:ShowTradingTab(self.tab or "buy")
end
