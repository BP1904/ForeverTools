-- Independent trading engine for the classic auction API. Transactions require clicks.
local _, FT = ...
local M = FT.modules.auctionator
local PAGE = NUM_AUCTION_ITEMS_PER_PAGE or 50
local function Trim(s) return (s or ""):match("^%s*(.-)%s*$") end
local function Money(n) return (n<0 and "-" or "") .. GetMoneyString(math.floor(math.abs(n) + 0.5)) end
local function SameName(a,b)
    if strcmputf8i then return strcmputf8i(a,b)==0 end
    return a:lower()==b:lower()
end
local function Integer(n, lo, hi)
    n = tonumber(n)
    return n and n == math.floor(n) and n >= lo and n <= hi and n or nil
end
local function FullName(name, realm)
    if realm=="" then realm=nil end
    return name and (name:find("-", 1, true) and name or name .. "-" .. (realm or GetRealmName())):gsub("%s", "")
end
function M:IsMine(row)
    local name, realm
    if UnitFullName then name,realm=UnitFullName("player") end
    name = name or (UnitName and UnitName("player"))
    return name and FullName(row.ownerFull or row.owner) == FullName(name, realm) or false
end

-- Portable, deliberately simple list format: name;max=10000;minlevel=1;quality=2;exact=1.
function M:ParseTerm(text)
    if type(text) ~= "string" or #text > 512 then return nil, "Ungültiger Suchtext." end
    local term = {name = Trim(text:match("^[^;]*"))}
    if term.name == "" or #term.name > 127 or term.name:find("[\r\n|]") then return nil, "Bitte einen Gegenstandsnamen eingeben." end
    for field in text:gmatch(";([^;]+)") do
        local key, value = Trim(field):match("^(%a+)=(%d+)$")
        local limits = {max={1,2000000000}, minlevel={1,100}, maxlevel={1,100}, quality={0,7}, exact={0,1}}
        local limit = key and limits[key]
        if not limit or not Integer(value, limit[1], limit[2]) then return nil, "Unbekannter Filter: " .. field end
        term[key] = tonumber(value)
    end
    if term.minlevel and term.maxlevel and term.minlevel > term.maxlevel then return nil, "Stufenbereich ist vertauscht." end
    term.text = term.name
    for _, key in ipairs({"max", "minlevel", "maxlevel", "quality", "exact"}) do
        if term[key] then term.text = term.text .. ";" .. key .. "=" .. term[key] end
    end
    return term
end

function M:ReadAuction(kind, index)
    local name, _, count, quality, _, level, _, minBid, increment, buyout, bid,
        _, _, owner, ownerFull, saleStatus, itemID, complete = GetAuctionItemInfo(kind, index)
    local link = GetAuctionItemLink(kind, index)
    if not name or not count or count < 1 or not link or complete == false then return end
    return {name=name, count=count, quality=quality, level=level, minBid=minBid or 0,
        increment=increment or 0, buyout=buyout or 0, bid=bid or 0, owner=owner,
        ownerFull=ownerFull, saleStatus=saleStatus, itemID=itemID, link=link,
        key=self:Key(link), index=index, unit=buyout and buyout > 0 and buyout/count or math.huge}
end

function M:SameAuction(a, b)
    return a and b and a.link == b.link and a.name == b.name and a.count == b.count
        and a.buyout == b.buyout and a.bid == b.bid and a.minBid == b.minBid
        and a.owner == b.owner and a.ownerFull == b.ownerFull and a.saleStatus == b.saleStatus
end

function M:InvalidateTrade()
    self.pending = nil
    if StaticPopup_Hide then StaticPopup_Hide("FOREVERTOOLS_AUCTION_TRADE") end
end

function M:StopTrading(reason)
    local active = self.job or self.ownerRequest
    self.job = nil; self.ownerRequest = nil
    self:InvalidateTrade()
    self.browseEpoch = (self.browseEpoch or 0) + 1
    if active and reason then self:Message(reason) end
end

function M:Remember(term)
    local history = self.settings.searchHistory
    for i=#history,1,-1 do if history[i] == term then table.remove(history,i) end end
    table.insert(history, 1, term)
    while #history > 30 do table.remove(history) end
end

function M:BeginJob(kind, terms, extra)
    if not self:Ready() then return end
    if self.scan or self.job or self.ownerRequest or self.posting then self:Message("Eine Aktion läuft bereits. Bitte warten oder abbrechen."); return end
    self:InvalidateTrade()
    self.browseEpoch = (self.browseEpoch or 0) + 1
    local job = extra or {}
    job.kind=kind; job.terms=terms; job.termIndex=1; job.page=job.page or 0
    job.rows={}; job.minima={}; job.started=GetTime(); job.pageStarted=GetTime()
    self.job = job
    if kind == "search" or kind == "list" then self.results={}; self.resultOffset=0 end
    self:Message("Auktionsabfrage gestartet. Andere Suchen währenddessen bitte abwarten.")
    self:TradingTick()
end

function M:StartSearch(text)
    local term, err = self:ParseTerm(text)
    if not term then self:Message(err); return end
    if not self:Ready() then return end
    self:Remember(term.text)
    self:BeginJob("search", {term})
    if self.panel then self:ShowTradingTab("buy") end
end

function M:SearchShopping()
    local terms={}
    for _, text in ipairs(self.settings.shopping) do
        local term, err=self:ParseTerm(text)
        if not term then self:Message(err); return end
        terms[#terms+1]=term
    end
    if #terms==0 then self:Message("Die Einkaufsliste ist leer."); return end
    self:BeginJob("list", terms)
    if self.panel then self:ShowTradingTab("buy") end
end

function M:TradingTick()
    if self.posting and GetTime()-self.posting.started > 60 then
        self.posting=nil; self:Message("Keine Einstellbestätigung erhalten. Vor erneutem Einstellen eigene Auktionen prüfen.")
    end
    if self.ownerRequest and GetTime()-self.ownerRequest.started > 30 then
        self.ownerRequest=nil; self:Message("Eigene Auktionen: Zeitüberschreitung. Bitte aktualisieren.")
    end
    if self.ownerRequest and self.ownerRequest.received then self:OnOwnedResults() end
    local job=self.job
    if not job then return end
    if GetTime()-job.pageStarted > 30 or GetTime()-job.started > 900 then self:Cancel("Auktionssuche: Zeitüberschreitung."); return end
    if job.received then self:TradingResults(); return end
    if job.waiting or not CanSendAuctionQuery() or (job.sentAt and GetTime()-job.sentAt < 0.5) then return end
    local term=job.terms[job.termIndex]
    self.status=("Suche %d/%d: %s – Seite %d"):format(job.termIndex,#job.terms,term.name,job.page+1)
    if self.panel then self.panel.status:SetText(self.status) end
    job.waiting=true; job.pageStarted=GetTime(); job.sentAt=GetTime()
    self.issuing=true
    local ok=pcall(QueryAuctionItems, term.name, term.minlevel, term.maxlevel, job.page,
        false, term.quality, false, term.exact==1, nil)
    self.issuing=nil
    if not ok then self:Cancel("Auktionssuche wurde vom Client abgelehnt.") end
end

function M:TradingResults()
    local job=self.job
    if not job or not job.waiting then return end
    job.received=true
    local count,total=GetNumAuctionItems("list")
    if type(count)~="number" or type(total)~="number" or count>PAGE or count<math.min(PAGE,math.max(0,total-job.page*PAGE)) then return end
    -- Wait for item and seller cache; owner resolution can arrive after the event.
    local rows={}
    local term=job.terms[job.termIndex]
    for i=1,count do
        local row=self:ReadAuction("list",i)
        if not row or not row.key or not row.owner then return end
        if term.exact==1 and not SameName(row.name,term.name) then return end
        row.page=job.page; row.term=job.terms[job.termIndex]
        rows[#rows+1]=row
    end
    if job.kind=="buy" then
        self.job=nil
        local found
        for _,row in ipairs(rows) do if self:SameAuction(job.expected,row) then found=row; break end end
        if not found then self:Message("Angebot verändert oder verkauft. Bitte erneut suchen."); return end
        self:AskTrade("buy",found)
        return
    end
    for _,row in ipairs(rows) do
        if row.buyout>0 and not self:IsMine(row) then
            local old=job.minima[row.key]
            if not old or row.unit < old.unit then job.minima[row.key]={unit=row.unit,name=row.name,stamp=time()} end
        end
        if not term.max or row.unit<=term.max then job.rows[#job.rows+1]=row end
    end
    if #job.rows > 50000 then self:Cancel("Zu viele Treffer. Bitte die Suche einschränken."); return end
    job.received=nil; job.waiting=nil
    if (job.page+1)*PAGE < total then job.page=job.page+1; return end
    job.termIndex=job.termIndex+1; job.page=0
    if job.termIndex <= #job.terms then return end
    self.job=nil
    table.sort(job.rows,function(a,b)
        if a.unit~=b.unit then return a.unit<b.unit end
        if a.name~=b.name then return a.name<b.name end
        return a.count<b.count
    end)
    if job.kind=="undercut" then
        for _,own in ipairs(self.owned or {}) do
            local min=job.minima[own.key]
            own.undercut=own.buyout>0 and min and min.unit < own.unit or false
            own.competitor=min and min.unit
        end
        self:Message("Unterbietungsprüfung fertig. Markierte Auktionen einzeln abbrechen.")
    elseif job.kind=="sell" then
        self.sellPrices=job.minima
        local min=job.minima[job.sellKey]
        if min and self.panel then self.panel.sell.unit:SetText(math.max(1,math.floor(min.unit)-self.settings.undercut)) end
        self:Message(min and "Verkaufspreis anhand aktueller Konkurrenz vorgeschlagen." or "Keine Konkurrenz gefunden. Preis selbst festlegen.")
    else
        self.results=job.rows
        self:Message(#job.rows .. " Angebote gefunden, nach Stückpreis sortiert. Kauf lädt das Angebot nochmals vom Server.")
    end
    if job.kind~="undercut" then
        local market=self:Market()
        self:SavePriceHistory(market,job.minima)
        for key,price in pairs(job.minima) do market.prices[key]=price end
    end
    self:RefreshTrading()
end

function M:PrepareBuy(row)
    if not row or not row.term or row.buyout<=0 or self:IsMine(row) then self:Message("Dieses Angebot kann nicht gekauft werden."); return end
    self:BeginJob("buy",{row.term},{page=row.page,expected=row})
end

function M:RequestOwned(page, cancelRow, collect)
    if not self:Ready() or not GetOwnerAuctionItems then return end
    if self.job or self.scan or self.ownerRequest then self:Message("Bitte die laufende Abfrage abwarten."); return end
    self:InvalidateTrade()
    self.ownerRequest={page=page or 0,expected=cancelRow,collect=collect,started=GetTime()}
    self.issuingOwner=true
    local ok=pcall(GetOwnerAuctionItems,page or 0)
    self.issuingOwner=nil
    if not ok then self.ownerRequest=nil; self:Message("Eigene Auktionen konnten nicht abgefragt werden.") end
end

function M:OnOwnedResults()
    self.ownerEpoch=(self.ownerEpoch or 0)+1
    self:InvalidateTrade()
    local request=self.ownerRequest
    if not request then return end
    request.received=true
    local count,total=GetNumAuctionItems("owner")
    if type(count)~="number" or type(total)~="number" then return end
    if count<math.min(PAGE,math.max(0,total-request.page*PAGE)) then return end
    local rows={}
    for i=1,count do
        local row=self:ReadAuction("owner",i)
        if not row then
            -- Sold deliveries can have a zero stack size; they cannot be cancelled.
            local status=select(16,GetAuctionItemInfo("owner",i))
            if status~=1 then return end
        elseif row.saleStatus~=1 then row.page=request.page; rows[#rows+1]=row end
    end
    self.ownerRequest=nil
    self.ownerPage=request.page; self.ownerTotal=total
    if request.expected then
        for _,row in ipairs(rows) do
            if self:SameAuction(row,request.expected) then self:AskTrade("cancel",row); return end
        end
        self:Message("Die eigene Auktion hat sich verändert. Bitte aktualisieren.")
        return
    end
    if request.collect then
        for _,row in ipairs(rows) do request.collect[#request.collect+1]=row end
        if count<total and (request.page+1)*PAGE<total then self:RequestOwned(request.page+1,nil,request.collect); return end
        self.owned=request.collect
        local seen,terms={},{}
        for _,row in ipairs(self.owned) do
            if not seen[row.name] then
                seen[row.name]=true
                terms[#terms+1]={name=row.name,exact=1,text=row.name .. ";exact=1"}
            end
        end
        if #terms>0 then self:BeginJob("undercut",terms)
        else self:Message("Keine aktiven eigenen Auktionen gefunden.") end
    else self.owned=rows; self:Message("Eigene Auktionen: Server-Seite " .. (request.page+1) .. ", insgesamt " .. total .. ".") end
    self.ownedOffset=0; self:RefreshTrading()
end

function M:StartUndercut()
    self:RequestOwned(0,nil,{})
end

function M:AskTrade(kind,row)
    if not self:Ready() then return end
    if kind=="buy" and (self:IsMine(row) or row.buyout<=0 or GetMoney()<row.buyout) then self:Message("Kauf nicht möglich: eigenes Angebot oder zu wenig Gold."); return end
    if kind=="cancel" and (not CanCancelAuction or not CanCancelAuction(row.index)) then self:Message("Diese Auktion kann nicht abgebrochen werden."); return end
    if not StaticPopup_Show or not StaticPopupDialogs then self:Message("Bestätigungsdialog ist nicht verfügbar."); return end
    local data={kind=kind,row=row,epoch=kind=="buy" and self.browseEpoch or self.ownerEpoch,started=GetTime()}
    self.pending=data
    local text=kind=="buy" and ("Kaufen: " .. row.name .. " ×" .. row.count .. " für insgesamt " .. Money(row.buyout) .. "?")
        or ("Abbrechen: " .. row.name .. " ×" .. row.count .. "? Die Anzahlung geht verloren.")
    StaticPopup_Show("FOREVERTOOLS_AUCTION_TRADE",text,nil,data)
end

function M:ConfirmTrade(data)
    if self.pending~=data then return end
    self.pending=nil
    if not self:Ready() or self.job or self.scan or self.ownerRequest or GetTime()-data.started>30 then return end
    local kind=data.kind=="buy" and "list" or "owner"
    local epoch=data.kind=="buy" and self.browseEpoch or self.ownerEpoch
    local live=self:ReadAuction(kind,data.row.index)
    if epoch~=data.epoch or not self:SameAuction(live,data.row) then self:Message("Angebot verändert. Bitte erneut prüfen."); return end
    if data.kind=="buy" then
        if not PlaceAuctionBid or self:IsMine(live) or live.buyout<=0 or GetMoney()<live.buyout then return end
        local ok=pcall(PlaceAuctionBid,"list",live.index,live.buyout)
        if ok then self:RecordTrade("Kauf angefragt",live,live.buyout); self.results={}; self:Message("Kauf angefragt. Die Serverantwort erscheint im Spiel.")
        else self:Message("Kauf wurde vom Client abgelehnt.") end
    elseif CanCancelAuction and CancelAuction and CanCancelAuction(live.index) then
        local ok=pcall(CancelAuction,live.index)
        if ok then self:RecordTrade("Abbruch angefragt",live,0); self.owned={}; self:Message("Abbruch angefragt. Eigene Auktionen anschließend aktualisieren.") end
    end
    self.browseEpoch=(self.browseEpoch or 0)+1
    self.ownerEpoch=(self.ownerEpoch or 0)+1
    self:RefreshTrading()
end

function M:RecordTrade(kind,row,total)
    local log=self.settings.activity
    table.insert(log,1,{kind=kind,name=row.name,count=row.count,total=total,stamp=time()})
    while #log>100 do table.remove(log) end
end

function M:SavePriceHistory(market, prices)
    market.history=market.history or {}
    local day=math.floor(time()/86400)
    for key,price in pairs(prices) do
        local list=market.history[key] or {}; market.history[key]=list
        if list[#list] and list[#list].day==day then list[#list]={day=day,unit=price.unit}
        else list[#list+1]={day=day,unit=price.unit} end
        while #list>30 do table.remove(list,1) end
    end
    for key,list in pairs(market.history) do
        if not list[#list] or list[#list].day<day-90 then market.history[key]=nil end
    end
end

function M:SellInfo()
    if not GetAuctionSellItemInfo then return end
    local name,_,count,_,_,_,_,maxStack,total,itemID,guid=GetAuctionSellItemInfo()
    if not name or not itemID then return end
    return {name=name,count=count or 1,maxStack=maxStack or count or 1,total=total or count or 1,itemID=itemID,guid=guid}
end

function M:FindSellKey(info)
    local found
    for key,price in pairs(self:Market().prices) do
        if price.name==info.name and key:match("^(%d+):")==tostring(info.itemID) then
            if found then return end
            found=key
        end
    end
    return found
end

function M:CompareSale()
    if not self:Ready() then return end
    local info=self:SellInfo()
    if not info then self:Message("Bitte zuerst einen Gegenstand in das Verkaufsfeld legen."); return end
    local key=self:FindSellKey(info)
    self:BeginJob("sell",{{name=info.name,exact=1,text=info.name .. ";exact=1"}},{sellKey=key or (info.itemID .. ":0")})
end

function M:PrepareSale(unit,size,stacks,duration)
    if not self:Ready() then return end
    if self.job or self.scan or self.ownerRequest or self.posting then self:Message("Bitte laufende Aktionen abwarten."); return end
    local info=self:SellInfo()
    unit=Integer(unit,1,MAXIMUM_BID_PRICE or 2000000000)
    size=Integer(size,1,1000); stacks=Integer(stacks,1,1000); duration=Integer(duration,1,3)
    if not info or not unit or not size or not stacks or not duration or size>info.maxStack or size*stacks>info.total
        or unit*size>(MAXIMUM_BID_PRICE or 2000000000) then self:Message("Preis, Stapelgröße oder Anzahl ist ungültig."); return end
    local total=unit*size
    if not GetAuctionDeposit then self:Message("Die Anzahlung kann nicht geprüft werden."); return end
    local deposit=GetAuctionDeposit(duration,total,total,size,stacks)
    if type(deposit)~="number" or deposit>GetMoney() then self:Message("Nicht genügend Gold für die Anzahlung."); return end
    local key=self:FindSellKey(info)
    local reference=key and ((self.sellPrices or {})[key] or self:Market().prices[key])
    local warning=reference and unit<reference.unit*0.5 and " ACHTUNG: unter 50% des Vergleichspreises!" or ""
    local data={kind="sell",info=info,unit=unit,size=size,stacks=stacks,duration=duration,deposit=deposit,started=GetTime()}
    if not StaticPopup_Show or not StaticPopupDialogs then return end
    self.pending=data
    local text=info.name .. ": " .. stacks .. " Stapel à " .. size .. " für je " .. Money(total)
        .. ". Anzahlung insgesamt " .. Money(deposit) .. ". Einstellen?" .. warning
    StaticPopup_Show("FOREVERTOOLS_AUCTION_TRADE",text,nil,data)
end

function M:ConfirmSale(data)
    if self.pending~=data then return end
    self.pending=nil
    if not self:Ready() or self.posting or self.job or self.scan or GetTime()-data.started>30 then return end
    local info=self:SellInfo()
    if not info or info.name~=data.info.name or info.itemID~=data.info.itemID or info.guid~=data.info.guid
        or data.size>info.maxStack or data.size*data.stacks>info.total then self:Message("Verkaufsgegenstand verändert. Bitte erneut prüfen."); return end
    local total=data.unit*data.size
    local deposit=GetAuctionDeposit(data.duration,total,total,data.size,data.stacks)
    if type(deposit)~="number" or deposit~=data.deposit or deposit>GetMoney() then self:Message("Anzahlung verändert. Bitte erneut prüfen."); return end
    -- Use Blizzard's post handler so its own warning/confirmation remains effective.
    local button=AuctionsCreateAuctionButton
    if not button or not button.StartPost then self:Message("Der Verkaufsdialog ist noch nicht bereit. Verkaufsansicht im Spiel öffnen."); return end
    self.posting={started=GetTime(),name=info.name,count=data.size*data.stacks,total=total*data.stacks}
    local ok=pcall(button.StartPost,button,total,total,data.duration,data.size,data.stacks,false)
    if not ok then self.posting=nil; self:Message("Einstellen wurde vom Client abgelehnt.")
    else self:RecordTrade("Einstellen angefragt",self.posting,self.posting.total); self:Message("Einstellen angefragt. Zusätzliche Spiel-Bestätigungen beachten.") end
end

function M:SelectList(name)
    name=Trim(name)
    if name=="" or #name>40 or name:find("[\r\n|]") then self:Message("Listenname: 1 bis 40 Zeichen."); return end
    local lists=self.settings.lists
    if not lists[name] then
        local n=0; for _ in pairs(lists) do n=n+1 end
        if n>=20 then self:Message("Maximal 20 Einkaufslisten."); return end
        lists[name]={}
    end
    self.settings.activeList=name; self.settings.shopping=lists[name]; self.offset=0; self:RefreshList()
end

function M:ImportList(text)
    local staged={}
    if type(text)~="string" or #text>51200 then self:Message("Import ist zu groß."); return end
    for line in text:gmatch("[^\r\n]+") do
        if Trim(line)~="" then
            local term,err=self:ParseTerm(line)
            if not term then self:Message(err); return end
            staged[#staged+1]=term.text
        end
    end
    if #staged+#self.settings.shopping>100 then self:Message("Maximal 100 Einträge pro Liste."); return end
    for _,line in ipairs(staged) do self:AddToList(line) end
    self:Message("Einkaufsliste importiert.")
end

local AddToList=M.AddToList
function M:AddToList(text)
    local term,err=self:ParseTerm(text)
    if not term then self:Message(err); return end
    AddToList(self,term.text)
end

function M:CraftingCost(addReagents)
    if not FT:IsEnabled("auctionator") then return end
    local craft=CraftFrame and CraftFrame:IsShown()
    local selection=craft and GetCraftSelectionIndex or GetTradeSkillSelectionIndex
    local numReagents=craft and GetCraftNumReagents or GetTradeSkillNumReagents
    local reagentInfo=craft and GetCraftReagentInfo or GetTradeSkillReagentInfo
    local reagentLink=craft and GetCraftReagentItemLink or GetTradeSkillReagentItemLink
    local index=selection and selection()
    if not index or index<1 or not numReagents or not reagentLink or not reagentInfo then self:Message("Bitte ein Rezept im Berufsfenster auswählen."); return end
    local count=numReagents(index)
    if not count or count<1 then self:Message("Keine Rezeptmaterialien verfügbar."); return end
    local cost,missing=0,{}
    for i=1,count do
        local name,_,required=reagentInfo(index,i)
        local link=reagentLink(index,i)
        local key=self:Key(link)
        local price=key and self:Market().prices[key]
        if name and addReagents then self:AddToList(name .. ";exact=1") end
        if not price or not required then missing[#missing+1]=name or "?" else cost=cost+price.unit*required end
    end
    if #missing>0 then self:Message("Fehlende Scanpreise: " .. table.concat(missing,", ")); return end
    local made=not craft and GetTradeSkillNumMade and GetTradeSkillNumMade(index) or 1
    made=math.max(1,made or 1)
    local output=not craft and GetTradeSkillItemLink and GetTradeSkillItemLink(index)
    local key=self:Key(output); local price=key and self:Market().prices[key]
    local cut=(self.auctionOpen and not self.houseFaction) and 0.15 or 0.05
    local message="Materialkosten: " .. Money(cost) .. " pro Herstellung, " .. Money(cost/made) .. " pro Stück."
    if price then message=message .. " Gewinn/Stück nach AH-Gebühr: " .. Money(price.unit*(1-cut)-cost/made) .. " (ohne Anzahlung)." end
    self:Message(message .. " Grundlage: gespeicherte Scanpreise.")
end

function M:TradingEvent(event,...)
    if event=="AUCTION_ITEM_LIST_UPDATE" then
        self.browseEpoch=(self.browseEpoch or 0)+1
        self:InvalidateTrade()
    elseif event=="AUCTION_OWNED_LIST_UPDATE" then self:OnOwnedResults(); return true
    elseif event=="NEW_AUCTION_UPDATE" then
        if self.pending and self.pending.kind=="sell" then self:InvalidateTrade() end
        self:RefreshSale()
    elseif event=="AUCTION_MULTISELL_UPDATE" then
        local done,total=...
        if self.posting and done and total and done>=total then
            self:RecordTrade("Einstellen bestätigt",self.posting,self.posting.total)
            self.posting=nil; self:Message("Mehrfach-Einstellen abgeschlossen.")
        end
        return true
    elseif event=="AUCTION_MULTISELL_FAILURE" then self.posting=nil; self:Message("Einstellen fehlgeschlagen. Eigene Auktionen vor erneutem Versuch prüfen."); return true
    elseif event=="AUCTION_HOUSE_CLOSED" then self.sellPrices=nil; self.posting=nil
    end
end

function M:InitializeTrading()
    local s=self.settings
    s.searchHistory=s.searchHistory or {}; s.activity=s.activity or {}; s.undercut=s.undercut or 1
    s.lists=s.lists or {Standard=s.shopping}
    s.activeList=s.activeList or "Standard"
    s.shopping=s.lists[s.activeList] or s.shopping; s.lists[s.activeList]=s.shopping
    if hooksecurefunc and GetOwnerAuctionItems then
        hooksecurefunc("GetOwnerAuctionItems",function()
            if self.ownerRequest and not self.issuingOwner then self:StopTrading("Andere Abfrage eigener Auktionen gestartet.") end
        end)
    end
    for _,event in ipairs({"AUCTION_OWNED_LIST_UPDATE","AUCTION_MULTISELL_UPDATE","AUCTION_MULTISELL_FAILURE"}) do
        local ok=pcall(self.frame.RegisterEvent,self.frame,event)
        if not ok then self.unsupportedEvents[event]=true end
    end
    if StaticPopupDialogs then
        StaticPopupDialogs.FOREVERTOOLS_AUCTION_TRADE={
            text="%s",button1="Bestätigen",button2="Abbrechen",timeout=30,whileDead=false,hideOnEscape=true,
            OnAccept=function(_,data) if data.kind=="sell" then self:ConfirmSale(data) else self:ConfirmTrade(data) end end,
            OnCancel=function() self.pending=nil end,
        }
    end
end
