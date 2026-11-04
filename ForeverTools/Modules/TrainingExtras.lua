-- Book launchers, training prices, waypoints and per-family grimoire knowledge.
local _, FT = ...
local M=FT.modules.training
local D=FT.trainingData or {}
local function Read(fn,...)
    if type(fn)~="function" then return end
    local ok,a,b,c=pcall(fn,...); if ok then return a,b,c end
end
local function Combat() return InCombatLockdown and InCombatLockdown() end
local function Money(n) return n and GetMoneyString(math.floor(n)) or "Preis nicht erfasst" end
local function KnownName(name) return type(name)=="string" and not name:find("^Zauber #") end

-- The copied Forever data reports a 10% trainer discount from Honored onward.
-- Do not apply the different retail/TBC discount ladder to this client.
function M:TrainerFactions(row)
    local data=D.TrainerFactions or {}; local result={}
    if row.kind=="weapon" then
        for _,trainer in ipairs(row.trainers or {}) do
            local id=(data.npcs or {})[trainer.npc]; if id then result[id]=true end
        end
    elseif row.kind=="class" then
        local role=row.pet and "PET" or self.class
        for _,id in ipairs(((data.roles or {})[role] or {})[self.faction] or {}) do result[id]=true end
    end
    return result
end
function M:ApplyPrices(rows)
    for _,row in ipairs(rows) do
        row.baseCost=row.cost; row.priceKind="base"
        local selected=self.db.priceFaction or "auto"
        local quote=self.trainerPrices and self.trainerPrices[row.id]
        if row.releasePrice and quote~=nil or row.cost and row.kind~="quest" and row.kind~="tome" and selected=="auto" and quote~=nil then
            row.cost=quote; row.priceKind="trainer"
        elseif row.cost and row.kind~="quest" and row.kind~="tome" and self.settings.reputationPrices and selected~="base" then
            local best=row.cost
            local checked=false
            for id in pairs(self:TrainerFactions(row)) do
                if selected=="auto" or selected==id then
                    local faction=Read(C_Reputation and C_Reputation.GetFactionDataByID,id)
                    if faction and type(faction.reaction)=="number" then checked=true end
                    local price=faction and faction.reaction and faction.reaction>=6 and math.floor(row.baseCost*0.9) or row.baseCost
                    if price<best then best=price; row.priceFaction=faction and faction.name or "Fraktion #" .. id end
                end
            end
            row.cost=best; row.priceKind=checked and "estimate" or "base"
        end
    end
    return rows
end
for _,method in ipairs({"BuildClass","BuildWeapons","BuildRecipes"}) do
    local original=M[method]
    M[method]=function(self,...) return self:ApplyPrices(original(self,...)) end
end
function M:CaptureTrainerPrices()
    self.trainerPrices={}
    for i=1,(Read(GetNumTrainerServices) or 0) do
        local data=Read(C_TooltipInfo and C_TooltipInfo.GetTrainerService,i)
        local cost=Read(GetTrainerServiceCost,i)
        if data and type(data.id)=="number" and type(cost)=="number" and cost>=0 then self.trainerPrices[data.id]=cost end
    end
end
function M:PriceDetails(row)
    if row.releasePrice then
        return row.cost and "Aktueller Lehrerpreis: " .. Money(row.cost) .. "." or "Aktuellen Preis beim Lehrer prüfen."
    end
    if row.priceKind=="trainer" then return "Aktueller Lehrerpreis: " .. Money(row.cost) .. " (Grundpreis " .. Money(row.baseCost) .. ")." end
    if row.priceKind=="estimate" then
        return "Geschätzter Lehrerpreis: " .. Money(row.cost) .. (row.priceFaction and " bei " .. row.priceFaction or "")
            .. ". Grundpreis: " .. Money(row.baseCost) .. ". Tatsächlichen Preis beim Lehrer prüfen."
    end
    return "Grundpreis: " .. Money(row.cost) .. ". Tatsächlichen Preis bzw. die Bezugsquelle prüfen."
end
function M:PriceSummary()
    return self.settings.reputationPrices and "Lehrerpreise/Schätzung gesamt" or "Grund-/aktuelle Lehrerpreise gesamt"
end
function M:CyclePriceFaction()
    local choices={"auto","base"}; local seen={}
    for _,row in ipairs(self:BuildClass()) do for id in pairs(self:TrainerFactions(row)) do seen[id]=true end end
    for _,row in ipairs(self:BuildWeapons()) do for id in pairs(self:TrainerFactions(row)) do seen[id]=true end end
    local ids={}; for id in pairs(seen) do ids[#ids+1]=id end; table.sort(ids)
    for _,id in ipairs(ids) do choices[#choices+1]=id end
    local index=1
    for i,value in ipairs(choices) do if value==(self.db.priceFaction or "auto") then index=i%#choices+1; break end end
    self.db.priceFaction=choices[index]; self:Refresh()
end

function M:WaypointTargets(row)
    local result,seen={},{}
    local current=Read(C_Map and C_Map.GetBestMapForUnit,"player")
    for _,trainer in ipairs(row and row.trainers or {}) do
        local map=(D.zoneUiMapIds or {})[trainer.zone]
        if type(map)=="number" and type(trainer.x)=="number" and type(trainer.y)=="number"
            and trainer.x>=0 and trainer.x<=100 and trainer.y>=0 and trainer.y<=100 then
            local key=map .. ":" .. trainer.x .. ":" .. trainer.y
            if not seen[key] then
                seen[key]=true
                result[#result+1]={mapID=map,x=trainer.x/100,y=trainer.y/100,title=trainer.name,npc=trainer.npc,current=map==current}
            end
        end
    end
    table.sort(result,function(a,b)
        if a.current~=b.current then return a.current end
        if a.title~=b.title then return a.title<b.title end
        return (a.npc or 0)<(b.npc or 0)
    end)
    return result
end
function M:SetTrainerWaypoint(target)
    if not FT:IsEnabled("training") or Combat() then return false end
    if type(target)~="table" or type(target.mapID)~="number" or target.mapID<=0 or target.mapID~=math.floor(target.mapID)
        or type(target.x)~="number" or type(target.y)~="number"
        or not (target.x>=0 and target.x<=1 and target.y>=0 and target.y<=1) then return false end
    local ok=false
    if C_Map and Read(C_Map.CanSetUserWaypointOnMap,target.mapID)==true and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
        local point=Read(UiMapPoint.CreateFromCoordinates,target.mapID,target.x,target.y)
        ok=point and Read(C_Map.SetUserWaypoint,point)==true or false
    end
    if not ok and TomTom and TomTom.AddWaypoint then
        local uid=Read(TomTom.AddWaypoint,TomTom,target.mapID,target.x,target.y,{title=target.title,persistent=false,minimap=true,world=true})
        ok=uid~=nil and uid~=false
    end
    local opened=false
    if not ok then
        local maps=FT.modules.maps
        if maps and maps.SetTrainerMarker then
            if C_Map and C_Map.OpenWorldMap then Read(C_Map.OpenWorldMap,target.mapID); opened=true end
            ok=maps:SetTrainerMarker(target)
        end
    end
    if not ok then FT:Print("Auf dieser Karte ist kein Wegpunkt verfügbar. Die Koordinaten stehen in den Details."); return false end
    if not opened and C_Map and C_Map.OpenWorldMap then Read(C_Map.OpenWorldMap,target.mapID) end
    FT:Print("Lehrer-Wegpunkt gesetzt: " .. (target.title or "Waffenmeister"))
    return true
end

function M:UpdateBookButtons()
    self.bookLinks=self.bookLinks or {}
    local enabled=FT:IsEnabled("training") and self.settings.bookButtons
    local owners={}
    local spellBook=PlayerSpellsFrame and (PlayerSpellsFrame.SpellBookFrame or PlayerSpellsFrame) or SpellBookFrame
    if spellBook then owners[spellBook]="class" end
    for _,owner in pairs({ProfessionsFrame,TradeSkillFrame,CraftFrame}) do owners[owner]="recipes" end
    for owner,mode in pairs(owners) do
        if not self.bookLinks[owner] and enabled and not Combat() then
            local button=CreateFrame("Button",nil,UIParent,"UIPanelButtonTemplate")
            self.bookLinks[owner]=button
            button:SetSize(200,24); button:SetClampedToScreen(true)
            button:SetText(mode=="recipes" and "Was kann ich herstellen?" or "Was kann ich lernen?")
            button:SetPoint("TOPRIGHT",owner,"BOTTOMRIGHT",-8,-4)
            button:SetScript("OnClick",function()
                if FT:IsEnabled("training") and self.settings.bookButtons and not Combat() then
                    self.mode=mode; self.offset=0; self:Open()
                end
            end)
            if owner.HookScript then
                owner:HookScript("OnShow",function() self:UpdateBookButtons() end)
                owner:HookScript("OnHide",function() button:SetShown(false) end)
            end
        end
    end
    for owner,button in pairs(self.bookLinks) do
        local visible
        if owner.IsVisible then visible=owner:IsVisible() else visible=owner:IsShown() end
        button:SetShown(enabled and not Combat() and owners[owner]~=nil and visible or false)
    end
end

local families={imp="Imp",wichtel="Imp",voidwalker="Voidwalker",leerwandler="Voidwalker",succubus="Succubus",
    sukkubus="Succubus",incubus="Incubus",inkubus="Incubus",felhunter="Felhunter",["teufelsjäger"]="Felhunter"}
function M:FamilyLabel(family)
    if not GetLocale or GetLocale()=="deDE" then
        return ({Imp="Wichtel",Voidwalker="Leerwandler",Succubus="Sukkubus",Incubus="Inkubus",Felhunter="Teufelsjäger"})[family] or family
    end
    return family
end
function M:CurrentDemonFamily()
    local family=Read(UnitCreatureFamily,"pet")
    if type(family)~="string" then return end
    if families[family:lower()] then return families[family:lower()] end
    for _,id in ipairs(Read(C_CreatureInfo and C_CreatureInfo.GetCreatureFamilyIDs) or {}) do
        local info=Read(C_CreatureInfo.GetCreatureFamilyInfo,id)
        if info and info.name==family then
            for canonical,icon in pairs(D.WarlockAltIcons or {}) do if icon==info.iconFile then return canonical end end
        end
    end
end
local function Rank(text)
    if type(text)~="string" or text=="" then return end
    local number=tonumber(text:match("%d+")); if number then return number end
    local roman=text:match("([IVX]+)$"); if not roman then return end
    local total,last=0,0; local digits={I=1,V=5,X=10}
    for i=#roman,1,-1 do local digit=digits[roman:sub(i,i)]; total=total+(digit<last and -digit or digit); last=digit end
    return total
end
function M:ReadDemonBook()
    if self.class~="WARLOCK" or Read(UnitExists,"pet")~=true or Read(UnitIsDead,"pet")==true then return end
    local family=self:CurrentDemonFamily(); local guid=Read(UnitGUID,"pet")
    local count=Read(C_SpellBook and C_SpellBook.HasPetSpells or HasPetSpells)
    if not family or not guid or type(count)~="number" or count<1 or count>100 then return end
    local bank=Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Pet
    local ids,names,fingerprint={},{},{}; local unresolved=false
    for index=1,count do
        local info=Read(C_SpellBook and C_SpellBook.GetSpellBookItemInfo,index,bank)
        local id,skip
        if type(info)=="table" then
            local types=Enum and Enum.SpellBookItemType
            skip=types and types.FutureSpell and info.itemType==types.FutureSpell
            id=not skip and info.spellID or nil
            local link=Read(C_SpellBook.GetSpellBookItemLink,index,bank)
            if not id and type(link)=="string" then id=tonumber(link:match("spell:(%d+)")) end
            if not id and Enum and Enum.SpellBookItemType and info.itemType==Enum.SpellBookItemType.Spell then id=info.actionID end
        else
            local kind,legacyID=Read(GetSpellBookItemInfo,index,BOOKTYPE_PET or "pet")
            if not kind then return end
            if type(kind)=="string" and kind:lower()=="spell" then id=legacyID end
        end
        if not skip and type(id)=="number" and id>0 then
            ids[id]=true; fingerprint[#fingerprint+1]=id
            local name,subtext=self:Spell(id)
            if KnownName(name) then names[name]=math.max(names[name] or 0,Rank(subtext) or 0) else unresolved=true end
        end
    end
    if not next(ids) or guid~=Read(UnitGUID,"pet") or family~=self:CurrentDemonFamily() then return end
    table.sort(fingerprint)
    local record={known={},observedAt=time and time() or 0}; local missingNames=unresolved
    for _,entries in pairs((D.ClassData.WARLOCK or {}).tomesByLevel or {}) do
        for _,entry in ipairs(entries) do
            if entry.family==family then
                local id=(D.ClassData.WARLOCK.tomeTaughtSpells or {})[entry.itemId]
                if id then
                    if ids[id] or Read(C_SpellBook and C_SpellBook.IsSpellKnown,id,bank)==true then record.known[id]=true
                    else
                        local name,subtext=self:Spell(id); local rank=Rank(subtext)
                        if not KnownName(name) then missingNames=true end
                        if KnownName(name) and names[name] and rank and names[name]>=rank then record.known[id]=true
                        elseif KnownName(name) and not unresolved and (not names[name] or not subtext or subtext=="" or rank) then record.known[id]=false end
                    end
                end
            end
        end
    end
    self.petNeedsNames=missingNames
    return family,record,guid .. ":" .. family .. ":" .. table.concat(fingerprint,",")
end
function M:TomeStatus(row,entry)
    local record=self.db.demons and self.db.demons[entry.family]
    local known=record and record.known and record.known[row.id]
    if known==true then return "known" end
    if row.level>self.level then return row.level<=self.level+2 and "next" or "later" end
    if known==false then row.reason="Für " .. self:FamilyLabel(entry.family) .. " noch nicht gelernt; beim Grimoire-Händler erhältlich"; return "available" end
    row.reason="Einmal " .. (self:FamilyLabel(entry.family) or "den passenden Begleiter") .. " beschwören; das Begleiter-Zauberbuch wird geprüft"
    return "check"
end
function M:ScheduleDemonScan()
    if self.class~="WARLOCK" then return end
    self.petDue=(GetTime and GetTime() or 0)+0.5; self.petRetries=0; self.petCandidate=nil
end
function M:ExtraTick()
    if self.petWaitingForBar or not self.petDue or GetTime()<self.petDue then return end
    local family,record,digest=self:ReadDemonBook()
    if digest and self.petCandidate==digest then
        self.db.demons[family]=record; self.petCandidate=nil; self.petDue=nil; self.refreshPending=true
    else
        self.petRetries=(self.petRetries or 0)+1
        self.petCandidate=digest
        self.petDue=self.petRetries<10 and GetTime()+0.3 or nil
    end
end

function M:CreateExtraControls(panel)
    local function Button(text,x,width,callback)
        local button=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
        button:SetSize(width,24); button:SetPoint("TOPLEFT",x,-494); button:SetText(text); button:SetScript("OnClick",callback)
        return button
    end
    panel.waypoint=Button("Kartenpunkt",250,130,function()
        local targets=self:WaypointTargets(self.selectedRow); self:SetTrainerWaypoint(targets[self.targetIndex or 1])
    end)
    panel.nextTrainer=Button("Lehrer wechseln",390,160,function()
        local targets=self:WaypointTargets(self.selectedRow)
        if #targets>0 then self.targetIndex=(self.targetIndex or 1)%#targets+1; self:RefreshExtraControls() end
    end)
    panel.priceChoice=Button("Preise: Auto",560,180,function() self:CyclePriceFaction() end)
end
function M:RefreshExtraControls()
    if not self.panel or not self.panel.waypoint then return end
    if self.selectedRow then
        local selected=self.selectedRow; self.selectedRow=nil
        for _,row in ipairs(self.rows or {}) do
            if (row.key or row.id)==(selected.key or selected.id) and row.kind==selected.kind then self.selectedRow=row; break end
        end
        if not self.selectedRow then self.panel.detail:SetText("Eintrag anklicken: Voraussetzungen und Bezugsquelle.") end
    end
    local targets=self:WaypointTargets(self.selectedRow)
    self.targetIndex=math.min(self.targetIndex or 1,math.max(1,#targets))
    self.panel.waypoint:SetEnabled(#targets>0 and not Combat())
    self.panel.nextTrainer:SetEnabled(#targets>1)
    self.panel.nextTrainer:SetText(#targets>0 and (self.targetIndex .. "/" .. #targets .. ": Lehrer wechseln") or "Keine Koordinaten")
    local target=targets[self.targetIndex]
    if self.selectedRow then self.panel.detail:SetText(self:Details(self.selectedRow) .. (target and "\nKartenpunkt: " .. target.title or "")) end
    local selected=self.db.priceFaction or "auto"
    local faction=type(selected)=="number" and Read(C_Reputation and C_Reputation.GetFactionDataByID,selected)
    self.panel.priceChoice:SetText(selected=="auto" and "Preise: Auto" or selected=="base" and "Preise: Grundpreis" or "Preise: " .. (faction and faction.name or tostring(selected)))
    self.panel.priceChoice:SetEnabled(self.settings.reputationPrices)
end
function M:ExtraEvent(event,...)
    if event=="ADDON_LOADED" or event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_REGEN_ENABLED" or event=="PLAYER_REGEN_DISABLED" then self:UpdateBookButtons() end
    if event=="TRAINER_SHOW" or event=="TRAINER_UPDATE" then self:CaptureTrainerPrices()
    elseif event=="TRAINER_CLOSED" then self.trainerPrices=nil end
    if event=="UNIT_PET" and (...)=="player" then
        local guid=Read(UnitGUID,"pet")
        if guid~=self.lastPetGUID then
            self.lastPetGUID=guid
            self.petWaitingForBar=self.petBarGUID~=guid
        end
        self:ScheduleDemonScan()
    elseif event=="PET_BAR_UPDATE" or event=="PET_UI_UPDATE" then
        self.petBarGUID=Read(UnitGUID,"pet"); self.petWaitingForBar=false; self:ScheduleDemonScan()
    elseif event=="PLAYER_ENTERING_WORLD" or event=="MERCHANT_SHOW" or event=="SPELL_DATA_LOAD_RESULT" and self.petNeedsNames then
        self:ScheduleDemonScan()
    end
    if event=="CHAT_MSG_SYSTEM" and self.class=="HUNTER" then
        local message=...
        if type(message)=="string" and type(ERR_LEARN_SPELL_S)=="string" then
            local pattern="^" .. ERR_LEARN_SPELL_S:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])","%%%1"):gsub("%%%%s","(.+)") .. "$"
            if message:match(pattern) then
                local id=tonumber(message:match("|Hspell:(%d+)"))
                if id and ((D.ClassData.HUNTER or {}).petAbilityIds or {})[id] then self.db.pet[id]=true end
            end
        end
    end
end
local Initialize=M.Initialize
function M:Initialize()
    Initialize(self)
    if self.extrasInitialized then return end
    self.extrasInitialized=true
    self.db.demons=type(self.db.demons)=="table" and self.db.demons or {}
    self.lastPetGUID=Read(UnitGUID,"pet"); self.petBarGUID=self.lastPetGUID
    for _,event in ipairs({"ADDON_LOADED","TRAINER_CLOSED","PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED",
        "PET_BAR_UPDATE","PET_UI_UPDATE","MERCHANT_SHOW","CHAT_MSG_SYSTEM"}) do pcall(self.frame.RegisterEvent,self.frame,event) end
    self:UpdateBookButtons(); self:ScheduleDemonScan()
end
