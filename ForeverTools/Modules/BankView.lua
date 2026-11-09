local _, FT = ...
local M = {
    title="Bank unterwegs ansehen",
    description="Bank-Button im kombinierten Rucksack. Speichert deine Bank beim Bankbesuch. Ansicht auch unterwegs: /ftbank.",
    defaults={},
}
FT:RegisterModule("bankview",M)
M.actions={{title="Gespeicherte Bank öffnen",run=function() M:Open() end}}
local PAGE,COLUMNS=80,10
local function Secret(value) return issecretvalue and issecretvalue(value) end
local function Call(fn,...)
    if type(fn)~="function" then return false end
    local ok,value=pcall(fn,...)
    if not ok or Secret(value) then return false end
    return true,value
end
local function Read(fn,...)
    local ok,value=Call(fn,...)
    if ok then return value end
end
local function Slots(id)
    local value=Read(C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots,id)
    if type(value)=="number" and value>=0 then return value end
end
local function Stamp(value)
    return value and (Read(date,"%d.%m.%Y %H:%M",value) or "gespeichert") or "noch nicht gespeichert"
end
local function LegacyItem(bag,slot)
    local icon,count,_,quality,_,_,link,_,_,id=GetContainerItemInfo(bag,slot)
    if not icon and not link and not id then return end
    return {iconFileID=icon,stackCount=count,quality=quality,hyperlink=link,itemID=id}
end

function M:BankBags()
    local indices=Enum and Enum.BagIndex or {}
    local kind=Enum and Enum.BankType and Enum.BankType.Character
    local tabs=kind and Read(C_Bank and C_Bank.FetchPurchasedBankTabIDs,kind)
    local metadata=kind and Read(C_Bank and C_Bank.FetchPurchasedBankTabData,kind)
    local names={}
    if type(metadata)=="table" then
        for _,tab in ipairs(metadata) do
            if type(tab.ID)=="number" and type(tab.name)=="string" then names[tab.ID]=tab.name end
        end
    end
    if type(tabs)~="table" and type(metadata)=="table" then
        tabs={}; for _,tab in ipairs(metadata) do tabs[#tabs+1]=tab.ID end
    end
    local bags,seen={},{}
    local function Add(id,name,required)
        if type(id)~="number" or seen[id] then return end
        seen[id]=true; bags[#bags+1]={id=id,name=name,required=required}
    end
    if type(tabs)=="table" and #tabs>0 then
        for i,id in ipairs(tabs) do Add(id,names[id] or ("Bankfach "..i),true) end
        return bags
    end
    -- Some clients expose bank-tab indices before the bank-tab listing API.
    if indices.CharacterBankTab_1 then
        for i=1,6 do
            local id=indices["CharacterBankTab_"..i]
            if id and (Slots(id) or 0)>0 then Add(id,names[id] or ("Bankfach "..i),true) end
        end
        if #bags>0 then return bags end
    end
    -- Classic bank: main storage plus purchased bank bags (never carried bags).
    Add(BANK_CONTAINER or indices.Bank or -1,"Bank",true)
    local first=indices.BankBag_1 or ((NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4)+1)
    for i=1,NUM_BANKBAGSLOTS or 7 do
        Add(indices["BankBag_"..i] or (first+i-1),"Banktasche "..i,false)
    end
    local reagent=REAGENTBANK_CONTAINER or indices.Reagentbank
    if reagent and (Slots(reagent) or 0)>0 then Add(reagent,"Materialbank",true) end
    return bags
end

function M:Scan()
    if not self.bankOpen or not FT:IsEnabled("bankview") then return false end
    local snapshot={bags={},total=0,occupied=0}
    local names={}
    for _,bag in ipairs(self:BankBags()) do
        local size=Slots(bag.id)
        if not size or (bag.required and size==0) then return false end
        if size>0 then
            local record={id=bag.id,name=bag.name,size=size,items={}}
            for slot=1,size do
                local ok,item=Call(C_Container and C_Container.GetContainerItemInfo or (GetContainerItemInfo and LegacyItem),bag.id,slot)
                if not ok then return false end
                if item then
                    if type(item)~="table" then return false end
                    local id,link,count,icon,quality=item.itemID,item.hyperlink,item.stackCount,item.iconFileID,item.quality
                    if Secret(id) or Secret(link) or Secret(count) or Secret(icon) or Secret(quality) then return false end
                    if not id and type(link)=="string" then id=tonumber(link:match("item:(%d+)")) end
                    if type(id)~="number" or type(count)~="number" or count<=0 then return false end
                    -- Reuse names only within this snapshot; item variants keep their full link.
                    local reference=type(link)=="string" and link or id
                    if names[reference]==nil then
                        names[reference]=Read(C_Item and C_Item.GetItemInfo or GetItemInfo,reference) or false
                    end
                    local name=names[reference]
                    record.items[slot]={id=id,count=count,link=type(link)=="string" and link or ("item:"..id),
                        icon=icon or "Interface\\Icons\\INV_Misc_QuestionMark",quality=quality,
                        name=type(name)=="string" and name or nil}
                    snapshot.occupied=snapshot.occupied+1
                end
            end
            snapshot.total=snapshot.total+size
            snapshot.bags[#snapshot.bags+1]=record
        end
    end
    if snapshot.total==0 then return false end
    snapshot.savedAt=Read(time) or 0
    self.db.snapshot=snapshot
    self:Refresh()
    return true
end

function M:QueueScan()
    if not self.bankOpen or self.scanQueued or not (C_Timer and C_Timer.After) then return end
    self.scanQueued=true
    local visit=self.visit
    C_Timer.After(0.2,function()
        if self.visit~=visit then return end
        self.scanQueued=false
        self:Scan()
    end)
end

function M:ItemName(item)
    local name=Read(C_Item and C_Item.GetItemInfo or GetItemInfo,item.link or item.id)
    if type(name)=="string" then item.name=name end
    if not item.name and not self.requested[item.id] then
        self.requested[item.id]=true
        Read(C_Item and C_Item.RequestLoadItemDataByID,item.id)
    end
    return item.name or ("Gegenstand #"..item.id)
end

function M:Rows()
    local rows={}
    local snapshot=self.db.snapshot
    if not snapshot then return rows end
    local query=(self.query or ""):lower()
    for _,bag in ipairs(snapshot.bags) do
        for slot=1,bag.size do
            local item=bag.items[slot]
            if query=="" or (item and (self:ItemName(item):lower():find(query,1,true)
                or tostring(item.id):find(query,1,true))) then
                rows[#rows+1]={item=item,bag=bag.name,slot=slot}
            end
        end
    end
    return rows
end

function M:HideTooltip() if self.tooltip then self.tooltip:Hide() end end
function M:Tooltip(button)
    if not button.entry then return end
    self.tooltip=self.tooltip or CreateFrame("GameTooltip","ForeverToolsBankTooltip",UIParent,"GameTooltipTemplate")
    local tip,entry=self.tooltip,button.entry
    tip:SetOwner(button,"ANCHOR_RIGHT"); tip:ClearLines()
    if entry.item then
        local ok=Call(tip.SetHyperlink,tip,entry.item.link)
        if not ok then tip:AddLine(self:ItemName(entry.item),1,1,1) end
        tip:AddLine("Gespeicherter Stapel: "..entry.item.count,1,0.82,0)
    else tip:AddLine("Leerer Bankplatz",1,1,1) end
    tip:AddLine(entry.bag..", Platz "..entry.slot,0.7,0.7,0.7)
    tip:AddLine("Stand: "..Stamp(self.db.snapshot and self.db.snapshot.savedAt),0.7,0.7,0.7)
    tip:AddLine("Gespeicherte Ansicht. Ein- und Auslagern beim Bankier.",0.7,0.7,0.7,true)
    tip:Show()
end

function M:Refresh()
    if not self.panel or not self.panel:IsShown() or not FT:IsEnabled("bankview") then return end
    local p,snapshot=self.panel,self.db.snapshot
    local rows=self:Rows(); self.rows=rows
    local pages=math.max(1,math.ceil(#rows/PAGE))
    self.page=math.max(1,math.min(self.page or 1,pages))
    p.status:SetText(snapshot and ("Stand: "..Stamp(snapshot.savedAt).." | "..snapshot.occupied.." / "..snapshot.total.." Plätze belegt")
        or "Noch kein Bankstand. Besuche einmal deine Bank, um sie zu speichern.")
    p.empty:SetText(not snapshot and "Bankinhalt wird beim nächsten Bankbesuch automatisch gespeichert."
        or (#rows==0 and "Keine passenden Gegenstände gefunden." or ""))
    for i,button in ipairs(p.slots) do
        local entry=rows[(self.page-1)*PAGE+i]; button.entry=entry
        local item=entry and entry.item
        button.icon:SetTexture(item and item.icon or "Interface\\PaperDoll\\UI-Backpack-EmptySlot")
        button.count:SetText(item and item.count>1 and tostring(item.count) or "")
        local r,g,b=0.25,0.25,0.25
        if item and type(item.quality)=="number" and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[item.quality] then
            local color=ITEM_QUALITY_COLORS[item.quality]; r,g,b=color.r,color.g,color.b
        end
        button:SetBackdropBorderColor(r,g,b,1)
        button:SetShown(entry~=nil)
    end
    p.page:SetText("Seite "..self.page.." / "..pages)
    p.previous:SetEnabled(self.page>1); p.next:SetEnabled(self.page<pages)
end

function M:Open()
    if not FT:IsEnabled("bankview") then return end
    if not self.panel then
        local p=CreateFrame("Frame","ForeverToolsBankView",UIParent,"BasicFrameTemplateWithInset"); self.panel=p
        p:SetSize(580,610); p:SetPoint("CENTER"); p:SetClampedToScreen(true); p:SetMovable(true); p:EnableMouse(true)
        p:RegisterForDrag("LeftButton"); p:SetScript("OnDragStart",p.StartMoving); p:SetScript("OnDragStop",p.StopMovingOrSizing)
        p:SetScript("OnHide",function() self:HideTooltip() end)
        p.TitleText:SetText("ForeverTools – Gespeicherte Bank")
        UISpecialFrames[#UISpecialFrames+1]="ForeverToolsBankView"
        local function Label(x,y,width,height)
            local text=p:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
            text:SetPoint("TOPLEFT",x,y); text:SetWidth(width); text:SetHeight(height); text:SetJustifyH("LEFT"); return text
        end
        p.status=Label(20,-36,540,34)
        Label(20,-82,60,24):SetText("Suche:")
        p.search=CreateFrame("EditBox",nil,p,"InputBoxTemplate"); p.search:SetSize(450,24); p.search:SetPoint("TOPLEFT",90,-82)
        p.search:SetAutoFocus(false); p.search:SetScript("OnEscapePressed",function(f) f:ClearFocus() end)
        p.search:SetScript("OnTextChanged",function(f) self.query=f:GetText(); self.page=1; self:HideTooltip(); self:Refresh() end)
        p.empty=Label(20,-112,540,30)
        p.slots={}
        for i=1,PAGE do
            local button=CreateFrame("Button",nil,p,"BackdropTemplate")
            button:SetSize(44,44); button:SetPoint("TOPLEFT",30+((i-1)%COLUMNS)*52,-146-math.floor((i-1)/COLUMNS)*48)
            button:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
            button:SetBackdropColor(0.05,0.05,0.05,1)
            button.icon=button:CreateTexture(nil,"ARTWORK"); button.icon:SetPoint("TOPLEFT",2,-2); button.icon:SetPoint("BOTTOMRIGHT",-2,2)
            button.count=button:CreateFontString(nil,"OVERLAY","NumberFontNormal"); button.count:SetPoint("BOTTOMRIGHT",-3,3)
            button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
            button:SetScript("OnEnter",function(b) self:Tooltip(b) end)
            button:SetScript("OnLeave",function() self:HideTooltip() end)
            button:SetScript("OnClick",function(b)
                local item=b.entry and b.entry.item
                if not item then return end
                if Read(IsShiftKeyDown) and ChatEdit_InsertLink then ChatEdit_InsertLink(item.link)
                elseif SetItemRef then
                    local ref=item.link:match("|H([^|]+)|h") or item.link
                    SetItemRef(ref,item.link,"LeftButton")
                end
            end)
            p.slots[i]=button
        end
        local function Button(text,x,callback)
            local b=CreateFrame("Button",nil,p,"UIPanelButtonTemplate"); b:SetSize(100,24); b:SetPoint("TOPLEFT",x,-538)
            b:SetText(text); b:SetScript("OnClick",callback); return b
        end
        p.previous=Button("Zurück",30,function() self.page=(self.page or 1)-1; self:HideTooltip(); self:Refresh() end)
        p.next=Button("Weiter",450,function() self.page=(self.page or 1)+1; self:HideTooltip(); self:Refresh() end)
        p.page=Label(220,-541,150,24)
        Label(20,-576,540,24):SetText("Gespeicherte Ansicht. Aktualisiert sich automatisch beim Bankbesuch.")
    end
    self.panel:SetShown(true); self:Refresh()
end

function M:AttachButton(preferred)
    if Read(InCombatLockdown) then return end
    self.bagHooks=self.bagHooks or {}
    -- Forever can use ContainerFrame1 for the combined backpack. The other
    -- combined frame may exist but remain hidden, so follow the visible frame.
    for _,name in ipairs({"ContainerFrameCombinedBags","ContainerFrame1"}) do
        local frame=_G[name]
        if frame and frame.HookScript and not self.bagHooks[frame] then
            self.bagHooks[frame]=true
            frame:HookScript("OnShow",function() self:AttachButton(frame) end)
        end
    end
    local combined,backpack=ContainerFrameCombinedBags,ContainerFrame1
    local bag=preferred and preferred:IsShown() and preferred
        or combined and combined:IsShown() and combined
        or backpack and backpack:IsShown() and backpack
        or combined or backpack
    if not bag then return end
    local button=self.button
    if not button then
        button=CreateFrame("Button","ForeverToolsBagBankButton",bag,"UIPanelButtonTemplate")
        button:SetSize(64,18); button:SetText("Bank")
        button:SetScript("OnClick",function()
            if self.panel and self.panel:IsShown() then self.panel:SetShown(false) else self:Open() end
        end)
        self.button=button
    end
    button:SetParent(bag)
    button:ClearAllPoints()
    button:SetPoint("BOTTOMLEFT",bag,"BOTTOMLEFT",12,7)
    button:SetFrameLevel((Read(bag.GetFrameLevel,bag) or 1)+20)
    button:SetShown(FT:IsEnabled("bankview"))
end

function M:OnSettingsChanged()
    self:AttachButton()
    local enabled=FT:IsEnabled("bankview")
    if self.button then self.button:SetShown(enabled) end
    if not enabled then
        self:HideTooltip(); if self.panel then self.panel:SetShown(false) end
    elseif self.bankOpen then self:Scan(); self:QueueScan() end
end

function M:Initialize()
    ForeverToolsBankDB=type(ForeverToolsBankDB)=="table" and ForeverToolsBankDB or {}
    self.db=ForeverToolsBankDB; self.requested={}; self.visit=0
    self.frame=CreateFrame("Frame")
    for _,event in ipairs({"BANKFRAME_OPENED","BANKFRAME_CLOSED","PLAYERBANKSLOTS_CHANGED","PLAYERBANKBAGSLOTS_CHANGED",
        "PLAYERREAGENTBANKSLOTS_CHANGED","BANK_TABS_CHANGED","BAG_UPDATE_DELAYED","ADDON_LOADED",
        "PLAYER_ENTERING_WORLD","PLAYER_REGEN_ENABLED","BAG_CONTAINER_UPDATE","GET_ITEM_INFO_RECEIVED"}) do
        pcall(self.frame.RegisterEvent,self.frame,event)
    end
    self.frame:SetScript("OnEvent",function(_,event)
        if event=="BAG_UPDATE_DELAYED" then self:AttachButton() end
        if event=="BANKFRAME_CLOSED" then
            self.bankOpen=false; self.scanQueued=false; self.visit=self.visit+1
        elseif event=="BANKFRAME_OPENED" then
            self.bankOpen=true; self.scanQueued=false; self.visit=self.visit+1
            self:Scan(); self:QueueScan()
        elseif event=="ADDON_LOADED" or event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_REGEN_ENABLED" or event=="BAG_CONTAINER_UPDATE" then
            self:AttachButton()
        elseif event=="GET_ITEM_INFO_RECEIVED" then self:Refresh()
        elseif self.bankOpen then self:Scan(); self:QueueScan() end
    end)
    SLASH_FOREVERTOOLSBANK1="/ftbank"
    SlashCmdList.FOREVERTOOLSBANK=function()
        if self.panel and self.panel:IsShown() then self.panel:SetShown(false) else self:Open() end
    end
    self:AttachButton()
end
