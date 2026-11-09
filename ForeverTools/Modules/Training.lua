-- ForeverTools UI and state engine; MIT source data lives in Data/Training.
local _, FT = ...
local D = FT.trainingData or {ClassData={},Recipes={},WeaponSkills={}}
local _, build = (GetBuildInfo or function() end)()
local releaseTraining = (tonumber(build) or 0) >= 70753
local removedTraining = {[1038]=true,[25895]=true,[1326053]=true,[1326054]=true,[1326055]=true}
local M = {
    title="Was kann ich lernen?",
    description="Lehrerzauber, Ränge, Voraussetzungen, Rufpreise, Waffenmeister, Begleiter und Berufsrezepte. Öffnen auch im Zauber-/Berufsbuch; gelernt wird beim Lehrer.",
    defaults={notify=true,professions=true,bookButtons=true,reputationPrices=true},
    options={
        {key="notify",title="Bei Stufenaufstieg auf neue Lehrerzauber hinweisen"},
        {key="professions",title="Berufsrezepte und ihre Bezugsquellen anzeigen"},
        {key="bookButtons",title="Lernübersicht im Zauber-/Berufsbuch verknüpfen"},
        {key="reputationPrices",title="Rufrabatte bei Lehrerpreisen berücksichtigen"},
    },
}
FT:RegisterModule("training",M)
local titles={available="Jetzt lernbar",next="Demnächst",later="Später",missing="Voraussetzung fehlt",
    known="Bereits gelernt",ignored="Ausgeblendet",quest="Quest",check="Bitte prüfen"}
local order={available=1,quest=2,next=3,missing=4,check=5,later=6,known=7,ignored=8}
local sources={trainer="Lehrer",vendor="Händler",quest="Quest",drop="Beute",crafted="Herstellung",world_object="Weltobjekt"}
local function Read(fn,...)
    if type(fn)~="function" then return end
    local ok,a,b,c,d,e,f,g=pcall(fn,...)
    if ok then return a,b,c,d,e,f,g end
end
local function Contains(list,value)
    for _,entry in ipairs(list or {}) do if entry==value then return true end end
    return false
end
local function Money(n) return n and GetMoneyString(math.floor(n)) or "Preis nicht erfasst" end
function M:Matches(entry)
    return (not entry.faction or entry.faction==self.faction) and (not entry.race or entry.race==self.race)
        and (not entry.races or Contains(entry.races,self.race))
end
function M:Spell(id)
    local info=Read(C_Spell and C_Spell.GetSpellInfo,id)
    if type(info)=="table" and info.name then
        return info.name,Read(C_Spell.GetSpellSubtext,id),info.iconID
    end
    local name,rank,icon=Read(GetSpellInfo,id)
    if type(name)=="string" then return name,rank,icon end
    if not self.requested[id] then self.requested[id]=true; self.loadQueue[#self.loadQueue+1]=id end
    return "Zauber #" .. id
end
function M:DirectKnown(id,pet)
    if pet and self.db.pet[id] then return true end
    -- A newly tamed hunter pet knowing a skill does not prove the hunter learned it.
    local petBook=pet and self.class=="WARLOCK"
    local bank=Enum and Enum.SpellBookSpellBank and (petBook and Enum.SpellBookSpellBank.Pet or Enum.SpellBookSpellBank.Player)
    local known=Read(C_SpellBook and C_SpellBook.IsSpellKnown,id,bank)
    if known==true then return true end
    if Read(C_SpellBook and C_SpellBook.IsSpellInSpellBook,id,bank,false)==true then return true end
    return Read(IsSpellKnown,id,petBook or false)==true or (not petBook and Read(IsPlayerSpell,id)==true) or false
end
function M:Known(id,pet)
    if self:DirectKnown(id,pet) then return true end
    local name,rank=self:Spell(id)
    if pet and rank and self.db.legacyPet[name] and self.db.legacyPet[name][rank] then return true end
    local group=self.overrides[id]
    if group then
        local found=false
        for _,other in ipairs(group) do
            if other==id then found=true end
            if found and self:DirectKnown(other,pet) then return true end
        end
    end
    return false
end
function M:Classify(row,entry,pet)
    if self.db.ignored[row.key or row.id] then return "ignored" end
    if row.kind=="tome" then
        if self.TomeStatus then return self:TomeStatus(row,entry) end
        if row.level>self.level then return row.level<=self.level+2 and "next" or "later" end
        row.reason="Mit dem passenden beschworenen Begleiter beim Händler prüfen"
        return "check"
    end
    if self:Known(row.id,pet) then return "known" end
    if row.level>self.level then return row.level<=self.level+2 and "next" or "later" end
    if entry.requiredTalentId and not self:Known(entry.requiredTalentId) then row.reason="Talent fehlt"; return "missing" end
    for _,id in ipairs(entry.requiredIds or {}) do
        if not self:Known(id,pet) then row.reason="Vorheriger Rang/Voraussetzung: " .. self:Spell(id); return "missing" end
    end
    if row.kind=="quest" then return "quest" end
    return "available"
end
function M:BuildClass()
    local rows,byID={},{}
    local class=D.ClassData[self.class] or {}
    local function Add(id,level,entry,kind)
        if (releaseTraining and removedTraining[id]) or not self:Matches(entry) then return end
        local name,rank=self:Spell(id)
        local key=kind=="tome" and (entry.id or "TOME:" .. entry.itemId) or id
        if kind=="tome" then name=name .. " – " .. (self.FamilyLabel and self:FamilyLabel(entry.family) or entry.family or "Begleiter") end
        local row={id=id,key=key,name=name,rank=rank,level=level,cost=entry.cost,kind=kind or "class",entry=entry,family=entry.family}
        if releaseTraining and row.kind=="class" and not (class.petAbilityIds or {})[id] then
            row.cost=nil
            row.releasePrice=true
        end
        row.pet=(class.petAbilityIds or {})[id] or kind=="tome"
        row.status=self:Classify(row,entry,row.pet)
        if byID[key] then rows[byID[key]]=row else rows[#rows+1]=row; byID[key]=#rows end
    end
    for level,entries in pairs(class.spellsByLevel or {}) do
        for _,entry in ipairs(entries) do
            if releaseTraining and self.class=="DRUID" then
                if entry.id==22568 then entry={id=22568,requiredIds={1328618}} end
                if entry.id==414644 then entry={id=414644,requiredIds={1328616},requiredTalentId=1328617} end
            end
            Add(entry.id,level,entry)
        end
    end
    if releaseTraining and self.class=="DRUID" then
        Add(1328618,24,{requiredIds={768}})
        Add(1328829,32,{})
        Add(1328616,34,{requiredTalentId=1328617})
    end
    for id,entries in pairs((D.QuestSpells or {})[self.class] or {}) do
        for _,entry in ipairs(entries) do
            if self:Matches(entry) then
                local quest={races=entry.races,cost=0,quests=entry.quests,areas=entry.areas or {entry.area}}
                Add(id,entry.level,quest,"quest"); break
            end
        end
    end
    for level,entries in pairs(class.tomesByLevel or {}) do
        for _,entry in ipairs(entries) do
            local id=(class.tomeTaughtSpells or {})[entry.itemId]
            if id then
                local before=#rows
                Add(id,level,entry,"tome")
                local row=rows[byID[entry.id or "TOME:" .. entry.itemId] or before+1]
                if row then row.itemID=entry.itemId; row.family=entry.family end
            end
        end
    end
    return rows
end
function M:BuildWeapons()
    local rows={}
    for id,entry in pairs(D.WeaponSkills or {}) do
        if entry.classes[self.class] then
            local name,rank=self:Spell(id)
            local row={id=id,name=name,rank=rank,level=entry.level or 1,cost=entry.cost or 1000,
                kind="weapon",trainers=entry.trainers[self.faction] or {}}
            row.status=self:Classify(row,entry,false)
            rows[#rows+1]=row
        end
    end
    return rows
end
function M:Skills()
    local result={}
    for id in pairs(D.Recipes or {}) do
        local info=Read(C_SkillInfo and C_SkillInfo.GetSkillLineInfoByID,id)
        if type(info)=="table" and type(info.rank)=="number" and info.rank>0 then result[id]=info end
    end
    if not next(result) and GetProfessions and GetProfessionInfo then
        for _,index in pairs({GetProfessions()}) do
            local name,_,rank,maxRank,_,_,id=Read(GetProfessionInfo,index)
            if id then result[id]={name=name,rank=rank,maxRank=maxRank} end
        end
    end
    return result
end
function M:RecipeStatus(row,recipe,skill)
    if self.db.ignored[row.id] then return "ignored" end
    if self:Known(row.id) then return "known" end
    if not recipe.skill or (recipe.rank and not recipe.level) then row.reason="Anforderung beim Lehrer prüfen"; return "check" end
    if recipe.skill>skill.rank then return recipe.skill<=skill.rank+10 and recipe.skill<=(skill.maxRank or math.huge) and "next" or "later" end
    if recipe.level and recipe.level>self.level then row.reason="Benötigt Charakterstufe " .. recipe.level; return "missing" end
    if recipe.reputationUnknown then row.reason="Rufanforderung prüfen"; return "check" end
    if recipe.reputation then
        local met=false
        for i=1,#recipe.reputation,3 do
            local info=Read(C_Reputation and C_Reputation.GetFactionDataByID,recipe.reputation[i])
            if info and info.reaction and info.reaction>=recipe.reputation[i+1] then met=true end
        end
        if not met then row.reason="Benötigter Ruf fehlt oder ist unbekannt"; return "missing" end
    end
    if recipe.merchantFavor then row.reason="Händlergunst " .. recipe.merchantFavor .. " prüfen"; return "check" end
    if not Contains(recipe.source,"trainer") then row.reason="Rezept über die angegebene Quelle beschaffen"; return "check" end
    return "available"
end
function M:BuildRecipes()
    local rows={}
    if not self.settings.professions then return rows end
    for id,skill in pairs(self:Skills()) do
        for _,recipe in ipairs(D.Recipes[id] or {}) do
            if self:Matches(recipe) and self:RecipeAllowed(recipe) and recipe.source and #recipe.source>0 then
                local name,rank=self:Spell(recipe.spell)
                local row={id=recipe.spell,name=name,rank=rank,level=recipe.skill or 0,cost=recipe.cost,
                    kind="recipe",entry=recipe,profession=skill.name or tostring(id)}
                row.status=self:RecipeStatus(row,recipe,skill)
                rows[#rows+1]=row
            end
        end
    end
    return rows
end
function M:RecipeAllowed(recipe)
    local otherOnly=false
    for _,source in ipairs(recipe.source or {}) do
        if source~="vendor" and source~="quest" then return true end
        local locations=recipe[source=="vendor" and "vendors" or "quests"] or {}
        if #locations==0 then
            if not recipe.side or recipe.side==self.faction then return true end
            otherOnly=true
        end
        for _,location in ipairs(locations) do
            if not location.faction or location.faction==self.faction then return true end
            otherOnly=true
        end
    end
    return not otherOnly
end
function M:Build()
    self.level=Read(UnitLevel,"player") or 1
    local classRows=self:BuildClass()
    self.total=0; self.available=0; self.incompletePrice=false
    for _,row in ipairs(classRows) do
        if row.status=="available" then
            self.available=self.available+1
            self.total=self.total+(row.cost or 0)
            if row.releasePrice and row.cost==nil then self.incompletePrice=true end
        end
    end
    local rows
    if self.mode=="weapons" then rows=self:BuildWeapons()
    elseif self.mode=="recipes" then rows=self:BuildRecipes()
    else
        rows={}
        for _,row in ipairs(classRows) do if (self.mode=="pets")==not not row.pet then rows[#rows+1]=row end end
    end
    local filtered={}; local query=(self.query or ""):lower()
    for _,row in ipairs(rows) do
        if (row.status~="known" or self.db.showKnown) and (row.status~="ignored" or self.db.showIgnored)
            and (query=="" or (row.name .. " " .. (row.rank or "") .. " " .. (row.profession or "")):lower():find(query,1,true)) then
            filtered[#filtered+1]=row
        end
    end
    table.sort(filtered,function(a,b)
        if order[a.status]~=order[b.status] then return order[a.status]<order[b.status] end
        if a.level~=b.level then return a.level<b.level end
        if a.name~=b.name then return a.name<b.name end
        return a.id<b.id
    end)
    self.rows=filtered
    return filtered
end
function M:Details(row)
    local lines={row.name .. (row.rank and row.rank~="" and " – " .. row.rank or ""),titles[row.status]}
    if row.reason then lines[#lines+1]=row.reason end
    if row.kind=="recipe" then
        local entry=row.entry; local labels={}
        for _,source in ipairs(entry.source or {}) do labels[#labels+1]=sources[source] or source end
        lines[#lines+1]=row.profession .. ": Fertigkeit " .. row.level .. "; " .. table.concat(labels,", ")
        if entry.teach then lines[#lines+1]="Rezeptgegenstand: item:" .. entry.teach end
        for _,source in ipairs(entry.vendors or entry.quests or {}) do
            if not source.faction or source.faction==self.faction then
                local area=Read(C_Map and C_Map.GetAreaInfo,source.area)
                lines[#lines+1]=(source.npc and "NPC #" .. source.npc or "Quest #" .. (source.id or "?")) .. " – " .. (area or tostring(source.area or "?"))
            end
        end
    elseif row.kind=="weapon" then
        for _,trainer in ipairs(row.trainers) do
            local area=Read(C_Map and C_Map.GetAreaInfo,trainer.zone)
            lines[#lines+1]=trainer.name .. " – " .. (area or "Gebiet #" .. trainer.zone) .. (" (%.1f, %.1f)"):format(trainer.x,trainer.y)
        end
    elseif row.kind=="quest" then
        for _,id in ipairs(row.entry.quests or {}) do lines[#lines+1]="Quest #" .. id end
    elseif row.itemID then lines[#lines+1]="Grimoire item:" .. row.itemID .. " (" .. (row.family or "Begleiter") .. ")" end
    if self.PriceDetails then lines[#lines+1]=self:PriceDetails(row)
    else lines[#lines+1]="Grundpreis: " .. Money(row.cost) .. ". Rufrabatte und tatsächliche Verfügbarkeit beim Lehrer prüfen." end
    return table.concat(lines,"\n")
end
function M:ToggleIgnored(id)
    if not FT:IsEnabled("training") then return end
    self.db.ignored[id]=not self.db.ignored[id] or nil
    self:Refresh()
end
function M:Refresh(alreadyBuilt)
    if not FT:IsEnabled("training") or not self.panel or not self.panel:IsShown() then return end
    if not alreadyBuilt then self:Build() end
    self.offset=math.min(self.offset or 0,math.max(0,#self.rows-8))
    local p=self.panel
    local prices=self.incompletePrice and "Gesamtpreis beim Lehrer prüfen"
        or (self.PriceSummary and self:PriceSummary() or "Grundpreis zusammen") .. ": " .. Money(self.total)
    p.summary:SetText(self.available .. " offene Klassen-/Begleiter-Lehrerränge. " .. prices
        .. ". Treffer: " .. #self.rows .. ". Umschalt-Klick: aus-/einblenden.")
    for i,button in ipairs(p.rows) do
        local row=self.rows[self.offset+i]; button.row=row
        button:SetText(row and ((row.profession and row.profession .. " | Fertigkeit " or "Stufe ") .. row.level .. " | "
            .. row.name .. (row.rank and row.rank~="" and " (" .. row.rank .. ")" or "") .. "\n" .. titles[row.status] .. " | " .. Money(row.cost)) or "–")
        button:SetEnabled(row~=nil)
    end
    if self.RefreshExtraControls then self:RefreshExtraControls() end
end
function M:Open()
    if not FT:IsEnabled("training") then return end
    if not self.panel then
        local p=CreateFrame("Frame","ForeverToolsTraining",UIParent,"BasicFrameTemplateWithInset"); self.panel=p
        p:SetSize(760,620); p:SetPoint("CENTER"); p:SetClampedToScreen(true); p:SetMovable(true); p:EnableMouse(true)
        p:RegisterForDrag("LeftButton"); p:SetScript("OnDragStart",p.StartMoving); p:SetScript("OnDragStop",p.StopMovingOrSizing)
        p.TitleText:SetText("ForeverTools – Was kann ich lernen?")
        UISpecialFrames[#UISpecialFrames+1]="ForeverToolsTraining"
        local function Button(text,x,y,width,callback)
            local b=CreateFrame("Button",nil,p,"UIPanelButtonTemplate"); b:SetSize(width,24); b:SetPoint("TOPLEFT",x,y)
            b:SetText(text); b:SetScript("OnClick",callback); return b
        end
        for i,tab in ipairs({{"class","Klasse"},{"weapons","Waffenmeister"},{"pets","Begleiter"},{"recipes","Berufsrezepte"}}) do
            local mode=tab[1]; Button(tab[2],20+(i-1)*180,-36,170,function() self.mode=mode; self.offset=0; self:Refresh() end)
        end
        p.search=CreateFrame("EditBox",nil,p,"InputBoxTemplate"); p.search:SetSize(350,24); p.search:SetPoint("TOPLEFT",25,-74)
        p.search:SetAutoFocus(false); p.search:SetMaxLetters(100)
        p.search:SetScript("OnTextChanged",function(box) self.query=box:GetText(); self.offset=0; self:Refresh() end)
        p.search:SetScript("OnEscapePressed",function(box) box:ClearFocus() end)
        Button("Gelernte ein/aus",400,-74,160,function() self.db.showKnown=not self.db.showKnown; self:Refresh() end)
        Button("Versteckte ein/aus",570,-74,170,function() self.db.showIgnored=not self.db.showIgnored; self:Refresh() end)
        p.summary=p:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); p.summary:SetPoint("TOPLEFT",20,-110)
        p.summary:SetWidth(720); p.summary:SetJustifyH("LEFT")
        p.rows={}
        for i=1,8 do
            local b
            b=Button("–",20,-150-(i-1)*42,720,function()
                if not b.row then return end
                if IsShiftKeyDown and IsShiftKeyDown() then self:ToggleIgnored(b.row.key or b.row.id)
                else
                    self.selectedRow=b.row; self.targetIndex=1
                    p.detail:SetText(self:Details(b.row))
                    if self.RefreshExtraControls then self:RefreshExtraControls() end
                end
            end)
            b:SetHeight(38); p.rows[i]=b
            b:SetScript("OnEnter",function(button)
                if button.row and GameTooltip and GameTooltip.SetHyperlink then
                    GameTooltip:SetOwner(button,"ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(button.row.itemID and "item:" .. button.row.itemID or "spell:" .. button.row.id)
                    GameTooltip:Show()
                end
            end)
            b:SetScript("OnLeave",function(button) if GameTooltip and GameTooltip.IsOwned and GameTooltip:IsOwned(button) then GameTooltip:Hide() end end)
        end
        Button("Zurück",20,-494,100,function() self.offset=math.max(0,(self.offset or 0)-8); self:Refresh() end)
        Button("Weiter",130,-494,100,function() self.offset=math.min(math.max(0,#(self.rows or {})-8),(self.offset or 0)+8); self:Refresh() end)
        local scroll=CreateFrame("ScrollFrame",nil,p,"UIPanelScrollFrameTemplate"); scroll:SetSize(690,72); scroll:SetPoint("TOPLEFT",20,-534)
        local content=CreateFrame("Frame",nil,scroll); content:SetSize(670,800); scroll:SetScrollChild(content)
        p.detail=content:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall"); p.detail:SetPoint("TOPLEFT"); p.detail:SetWidth(660); p.detail:SetJustifyH("LEFT")
        p.detail:SetText("Eintrag anklicken: Voraussetzungen und Bezugsquelle. Die Übersicht lernt keine Zauber automatisch.")
        if self.CreateExtraControls then self:CreateExtraControls(p) end
        p:SetScript("OnShow",function() self:Refresh() end)
    end
    self.panel:SetShown(true); self:Refresh()
end
function M:OnSettingsChanged()
    if not FT:IsEnabled("training") and self.panel then self.panel:SetShown(false) end
    if self.launcher then self.launcher:SetShown(FT:IsEnabled("training")) end
    if self.UpdateBookButtons then self:UpdateBookButtons() end
    self:Refresh()
end
function M:CapturePetTrainer()
    local petType=Enum and Enum.TrainerType and Enum.TrainerType.Pet
    if self.class~="HUNTER" or not petType or Read(C_Trainer and C_Trainer.GetTrainerType)~=petType then return end
    local abilities=(D.ClassData.HUNTER or {}).petAbilityIds or {}
    for i=1,(Read(GetNumTrainerServices) or 0) do
        local info=Read(C_TooltipInfo and C_TooltipInfo.GetTrainerService,i)
        if info and abilities[info.id] then self.db.pet[info.id]=true end
    end
end
function M:Initialize()
    ForeverToolsTrainingDB=type(ForeverToolsTrainingDB)=="table" and ForeverToolsTrainingDB or {}
    self.db=ForeverToolsTrainingDB
    for _,key in ipairs({"ignored","pet","legacyPet"}) do if type(self.db[key])~="table" then self.db[key]={} end end
    if not self.db.migrated then
        for id,value in pairs(type(WT_IgnoredSpells)=="table" and WT_IgnoredSpells or {}) do
            if (type(id)=="number" or type(id)=="string" and id:match("^[A-Z]+:%d+$")) and value==true then self.db.ignored[id]=true end
        end
        for name,ranks in pairs(type(WT_LearnedPetAbilities)=="table" and WT_LearnedPetAbilities or {}) do
            if type(name)=="string" and type(ranks)=="table" then self.db.legacyPet[name]=ranks end
        end
        -- Defer marking migration until the legacy addon actually supplied data.
        if WT_IgnoredSpells or WT_LearnedPetAbilities then self.db.migrated=true end
    end
    self.class=select(2,Read(UnitClass,"player"))
    self.level=Read(UnitLevel,"player") or 1
    self.faction=Read(UnitFactionGroup,"player")
    self.race=select(3,Read(UnitRace,"player"))
    self.requested={}; self.loadQueue={}; self.overrides={}; self.mode="class"; self.offset=0
    for _,group in ipairs((D.ClassData[self.class] or {}).overriddenGroups or {}) do
        for _,id in ipairs(group) do self.overrides[id]=group end
    end
    if releaseTraining and self.class=="DRUID" then
        local bite={1328618,22568,22827,22828,22829}
        for _,id in ipairs(bite) do self.overrides[id]=bite end
    end
    if self.frame then return end
    local frame=CreateFrame("Frame"); self.frame=frame
    for _,event in ipairs({"PLAYER_LEVEL_UP","SPELLS_CHANGED","LEARNED_SPELL_IN_SKILL_LINE","SKILL_LINES_CHANGED",
        "SPELL_DATA_LOAD_RESULT","TRAINER_SHOW","TRAINER_UPDATE","UPDATE_FACTION","PLAYER_ENTERING_WORLD","UNIT_PET"}) do
        pcall(frame.RegisterEvent,frame,event)
    end
    frame:SetScript("OnEvent",function(_,event,...)
        if not FT:IsEnabled("training") then return end
        if self.ExtraEvent then self:ExtraEvent(event,...) end
        if event=="TRAINER_SHOW" or event=="TRAINER_UPDATE" then self:CapturePetTrainer() end
        self.refreshPending=true
        if event=="PLAYER_LEVEL_UP" then self.levelNotice=true end
    end)
    frame:SetScript("OnUpdate",function(_,elapsed)
        if not FT:IsEnabled("training") then return end
        if self.ExtraTick then self:ExtraTick(elapsed) end
        self.elapsed=(self.elapsed or 0)+elapsed
        if self.elapsed<0.2 then return end
        self.elapsed=0
        for _=1,15 do
            local id=table.remove(self.loadQueue)
            if not id then break end
            Read(C_Spell and C_Spell.RequestLoadSpellData,id)
        end
        if self.refreshPending then
            self.refreshPending=nil
            local built=false
            if self.levelNotice then
                self.levelNotice=nil; self:Build()
                built=true
                if self.settings.notify and self.available>0 then FT:Print(self.available .. " offene Lehrerränge. Übersicht: /ftlernen oder /ad → Was kann ich lernen?") end
            end
            self:Refresh(built)
        end
    end)
    SLASH_FOREVERTOOLSTRAINING1="/ftlernen"
    SlashCmdList.FOREVERTOOLSTRAINING=function() self:Open() end
end
M.actions={{title="Lernübersicht öffnen",run=function() M:Open() end}}
