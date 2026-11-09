local _, FT = ...
local M = {
    title="Berufsplaner: Materialien und Skillen",
    description="/ftberufe: Taschen und gespeicherte Bank, herstellbare Rezepte, fehlende Rezepte und ein Skillvorschlag.",
    defaults={bank=true,unlearned=false},
}
FT:RegisterModule("professionplanner",M)
M.actions={{title="Berufsplaner öffnen",run=function() M:Open() end}}
local PROF={[164]="Schmiedekunst",[165]="Lederverarbeitung",[171]="Alchemie",[185]="Kochkunst",
    [129]="Erste Hilfe",[197]="Schneiderei",[202]="Ingenieurskunst",[333]="Verzauberkunst",[186]="Bergbau"}
local ALIAS={[2937]=171,[2938]=164,[2939]=185,[2940]=333,[2941]=202,[2942]=129,[2945]=165,[2946]=186,[2948]=197}
local SOURCE={trainer="Lehrer",vendor="Händler",quest="Quest",drop="Beute",crafted="Herstellung",world_object="Weltobjekt"}
local function Read(fn,...)
    if type(fn)~="function" then return end
    local ok,a,b,c,d,e,f,g=pcall(fn,...)
    if not ok then return end
    if issecretvalue and (issecretvalue(a) or issecretvalue(b) or issecretvalue(c) or issecretvalue(g)) then return end
    return a,b,c,d,e,f,g
end
local function Copy(t) local out={}; for k,v in pairs(t or {}) do out[k]=v end; return out end
local function Spell(id)
    return Read(C_Spell and C_Spell.GetSpellName or GetSpellInfo,id) or ("Zauber #"..id)
end
local function Item(id)
    local name=Read(C_Item and C_Item.GetItemInfo or GetItemInfo,id)
    if not name then Read(C_Item and C_Item.RequestLoadItemDataByID,id) end
    return name or ("Gegenstand #"..id)
end
local function Count(id,bank)
    local count=Read(C_Item and C_Item.GetItemCount or GetItemCount,id,bank,false,bank,false)
    if type(count)=="number" and count>=0 then return count end
end
local function Crafts(reagents,stock)
    local n
    for id,quantity in pairs(reagents or {}) do
        n=math.min(n or math.huge,math.floor((stock[id] or 0)/quantity))
    end
    return n or 0
end
local function Reagents(flat)
    local out={}
    for i=1,#(flat or {}),2 do
        local id,quantity=flat[i],flat[i+1]
        if type(id)=="number" and type(quantity)=="number" and quantity>0 then out[id]=(out[id] or 0)+quantity end
    end
    return out
end

function M:Skills()
    local skills={}
    if GetProfessions then
        for _,index in pairs({GetProfessions()}) do
            local name,_,rank,cap,_,_,id=Read(GetProfessionInfo,index)
            id=ALIAS[id] or id
            if PROF[id] and type(rank)=="number" and rank>0 then
                skills[id]={id=id,name=name or PROF[id],rank=rank,cap=cap or rank}
            end
        end
    end
    for id,name in pairs(PROF) do
        local info=Read(C_SkillInfo and C_SkillInfo.GetSkillLineInfoByID,id)
        if type(info)=="table" and type(info.rank)=="number" and info.rank>0 then
            skills[id]={id=id,name=info.name or name,rank=info.rank,cap=info.maxRank or info.rank}
        end
    end
    -- Losing and re-learning a profession invalidates its old recipe observations.
    for id,rank in pairs(self.db.ranks) do
        if not skills[id] or skills[id].rank<rank then
            for spell,live in pairs(self.db.recipes) do if live.profession==id then self.db.recipes[spell]=nil end end
        end
    end
    self.db.ranks={}
    for id,skill in pairs(skills) do self.db.ranks[id]=skill.rank end
    self.skills=skills
    return skills
end

function M:Index()
    local index={}
    local function Recipe(id,profession)
        index[id]=index[id] or {id=id,profession=profession,reagents={}}
        return index[id]
    end
    for item,uses in pairs(FT.materialUses or {}) do
        for _,use in ipairs(uses) do
            local r=Recipe(use[2],use[1])
            r.grey,r.yellow=use[4],use[6]
            r.reagents[item]=use[5]
        end
    end
    for profession,entries in pairs((FT.trainingData or {}).Recipes or {}) do
        for _,entry in ipairs(entries) do
            if not entry.rank then
                local r=Recipe(entry.spell,profession)
                r.entry=entry; r.required=entry.skill; r.teach=entry.teach
            end
        end
    end
    for item,entry in pairs(FT.recipes or {}) do Recipe(entry[2],entry[1]).teach=item end
    for id,r in pairs(index) do
        if FT.reagents and FT.reagents[id] then r.reagents=Reagents(FT.reagents[id]) end
    end
    for id,live in pairs(self.db.recipes) do
        local r=Recipe(id,live.profession)
        r.live=live
        if live.reagents then r.reagents=live.reagents end
    end
    self.index=index
    return index
end

function M:Stock()
    local bags,total={},{}
    for _,r in pairs(self.index) do
        if r.profession==self.profession then
            for id in pairs(r.reagents) do
                if bags[id]==nil then
                    bags[id]=Count(id,false) or 0
                    total[id]=bags[id]+(self.settings.bank and (self.db.bank[id] or 0) or 0)
                end
            end
        end
    end
    self.bags,self.stock=bags,total
end

function M:ScanBank()
    if not self.bankOpen then return end
    self:Index()
    local bank,seen={},{}
    for _,r in pairs(self.index) do
        for id in pairs(r.reagents) do
            if not seen[id] then
                seen[id]=true
                local bags,total=Count(id,false),Count(id,true)
                -- An unavailable count must not erase a previously readable bank.
                if not bags or not total or total<bags then return end
                if total>bags then bank[id]=total-bags end
            end
        end
    end
    self.db.bank=bank
    self.db.bankTime=Read(time) or 0
end

function M:ScanRecipes()
    self:Skills(); self:Index()
    local api=C_TradeSkillUI
    -- Linked and NPC profession windows must never mark recipes as our own.
    if Read(api and api.IsTradeSkillLinked) or Read(api and api.IsTradeSkillGuild)
        or Read(api and api.IsNPCCrafting) then return end
    local ids=Read(api and api.GetAllRecipeIDs)
    if type(ids)=="table" then
        local current=Read(api.GetBaseProfessionInfo)
        local currentID=type(current)=="table" and (ALIAS[current.professionID] or current.professionID)
        for _,id in ipairs(ids) do
            local r=self.index[id]
            local info=Read(api.GetRecipeInfo,id)
            if not r and self.skills[currentID] then r={profession=currentID} end
            if r and self.skills[r.profession] and type(info)=="table" and type(info.learned)=="boolean" then
                local live={profession=r.profession,known=info.learned,name=info.name}
                local schematic=Read(api.GetRecipeSchematic,id,false)
                if type(schematic)=="table" and type(schematic.reagentSlotSchematics)=="table" then
                    local reagents,valid={},true
                    for _,slot in ipairs(schematic.reagentSlotSchematics) do
                        if slot.required~=false then
                            local list=slot.reagents or {}
                            if #list~=1 or not list[1].itemID or not slot.quantityRequired or slot.quantityRequired<=0 then valid=false; break end
                            local item=list[1].itemID
                            reagents[item]=(reagents[item] or 0)+slot.quantityRequired
                        end
                    end
                    if valid then live.reagents=reagents else live.unsupported=true end
                end
                self.db.recipes[id]=live
            end
        end
    end
    -- Build the fallback name lookup once per profession, not once per recipe row.
    local names={}
    local function SpellByName(profession,name)
        if not names[profession] then
            local lookup={}; names[profession]=lookup
            for spell,r in pairs(self.index) do
                if r.profession==profession then
                    local label=Spell(spell)
                    if label then
                        if lookup[label]==nil then lookup[label]=spell else lookup[label]=false end
                    end
                end
            end
        end
        return names[profession][name] or nil
    end
    -- Classic tradeskills, including the separate enchanting Craft window.
    for _,craft in ipairs({false,true}) do
        local name
        if craft then name=Read(GetCraftDisplaySkillLine) else name=Read(GetTradeSkillLine) end
        local profession
        for id,skill in pairs(self.skills) do if skill.name==name then profession=id end end
        local count=Read(craft and GetNumCrafts or GetNumTradeSkills) or 0
        if profession then
            for i=1,count do
                local recipeName,kind,third=Read(craft and GetCraftInfo or GetTradeSkillInfo,i)
                if craft then kind=third end
                if recipeName and kind~="header" then
                    local link=Read(craft and GetCraftRecipeLink or GetTradeSkillRecipeLink,i)
                    local id=type(link)=="string" and tonumber(link:match("enchant:(%d+)") or link:match("spell:(%d+)"))
                    if not id then id=SpellByName(profession,recipeName) end
                    if id then
                        local reagents,valid={},true
                        local n=Read(craft and GetCraftNumReagents or GetTradeSkillNumReagents,i)
                        if type(n)~="number" then valid=false else
                            for j=1,n do
                                local itemLink=Read(craft and GetCraftReagentItemLink or GetTradeSkillReagentItemLink,i,j)
                                local _,_,quantity=Read(craft and GetCraftReagentInfo or GetTradeSkillReagentInfo,i,j)
                                local item=type(itemLink)=="string" and tonumber(itemLink:match("item:(%d+)"))
                                if not item or not quantity or quantity<=0 then valid=false; break end
                                reagents[item]=(reagents[item] or 0)+quantity
                            end
                        end
                        self.db.recipes[id]={profession=profession,known=true,name=recipeName,
                            reagents=valid and reagents or nil,unsupported=not valid}
                    end
                end
            end
        end
    end
end

function M:Known(r)
    if r.live and type(r.live.known)=="boolean" then return r.live.known end
    return Read(C_SpellBook and C_SpellBook.IsSpellKnown,r.id)==true
        or Read(IsPlayerSpell,r.id)==true or Read(IsSpellKnown,r.id)==true
end

function M:Allowed(r,known)
    local e=r.entry or {}
    local faction=Read(UnitFactionGroup,"player")
    local _,race=Read(UnitRace,"player")
    if (e.faction and e.faction~=faction) or (e.side and e.side~=faction) or (e.race and e.race~=race) then return false end
    if e.races then
        local found=false; for _,v in ipairs(e.races) do if v==race then found=true end end
        if not found then return false end
    end
    if known==nil then known=self:Known(r) end
    if not known then
        local otherOnly=false
        for _,source in ipairs(e.source or {}) do
            if source~="vendor" and source~="quest" then return true end
            local locations=e[source=="vendor" and "vendors" or "quests"] or {}
            if #locations==0 then return true end
            for _,where in ipairs(locations) do
                if not where.faction or where.faction==faction then return true end
                otherOnly=true
            end
        end
        if otherOnly then return false end
    end
    return true
end

function M:Build()
    self:Skills(); self:Index()
    if not self.skills[self.profession] then
        self.profession=nil
        for id in pairs(self.skills) do if not self.profession or id<self.profession then self.profession=id end end
    end
    self:Stock()
    local skill=self.skills[self.profession]
    local rows={}
    if skill then
        for _,r in pairs(self.index) do
            if r.profession==skill.id and next(r.reagents) and self:Allowed(r) and (not r.grey or skill.rank<r.grey) then
                r.name=(r.live and r.live.name) or Spell(r.id)
                r.known=self:Known(r)
                r.bagCrafts=Crafts(r.reagents,self.bags); r.crafts=Crafts(r.reagents,self.stock)
                r.unsupported=r.live and r.live.unsupported
                if r.unsupported then r.crafts=0; r.bagCrafts=0 end
                r.required=r.required or (r.known and skill.rank or nil)
                r.target=r.grey and math.min(skill.cap,r.grey,skill.rank+r.crafts) or skill.rank
                if (not r.required or r.required<=skill.rank+25) and (not self.query or self.query=="" or r.name:lower():find(self.query,1,true)) then
                    rows[#rows+1]=r
                end
            end
        end
    end
    table.sort(rows,function(a,b)
        local function Priority(r)
            if r.unsupported then return 5 end
            if r.required and r.required>skill.rank then return 4 end
            if r.crafts==0 then return 3 end
            return r.known and 1 or 2
        end
        local aPriority,bPriority=Priority(a),Priority(b)
        if aPriority~=bPriority then return aPriority<bPriority end
        if a.crafts~=b.crafts then return a.crafts>b.crafts end
        if a.name~=b.name then return a.name<b.name end
        return a.id<b.id
    end)
    self.rows=rows
    -- Planning ignores the text filter and includes recipes unlocked along the way.
    self.plan,self.target=self:Plan(skill)
    return rows
end

function M:Plan(skill)
    if not skill then return {},0 end
    local stock,rank,steps=Copy(self.stock),skill.rank,{}
    local candidates={}
    local level=Read(UnitLevel,"player") or 0
    for _,r in pairs(self.index) do
        if r.profession==skill.id and r.grey and not (r.live and r.live.unsupported) then
            local e=r.entry or {}
            local known=self:Known(r)
            local allowed=known or (self.settings.unlearned and e.skill and not e.reputation
                and not e.reputationUnknown and not e.merchantFavor and not e.requiredSpell and not e.requiredTalent)
            if allowed and self:Allowed(r,known) and (not e.level or e.level<=level) then
                candidates[#candidates+1]={recipe=r,known=known,required=r.required or (known and skill.rank) or math.huge}
            end
        end
    end
    -- A deterministic suggestion, not an optimization: one successful point per craft.
    for _=1,math.min(500,math.max(0,skill.cap-skill.rank)) do
        local best,bestCost
        for _,candidate in ipairs(candidates) do
            local r=candidate.recipe
            if rank<r.grey and candidate.required<=rank and Crafts(r.reagents,stock)>0 then
                local cost=0; for _,n in pairs(r.reagents) do cost=cost+n end
                local orange=r.yellow~=nil and rank<r.yellow
                local bestOrange=best~=nil and best.yellow~=nil and rank<best.yellow
                if not best or (orange and not bestOrange) or (orange==bestOrange
                    and (cost<bestCost or (cost==bestCost and r.id<best.id))) then best,bestCost=r,cost end
            end
        end
        if not best then break end
        best.name=best.name or (best.live and best.live.name) or Spell(best.id)
        best.known=self:Known(best)
        best.bagCrafts=best.bagCrafts or Crafts(best.reagents,self.bags)
        best.crafts=best.crafts or Crafts(best.reagents,self.stock)
        for id,n in pairs(best.reagents) do stock[id]=stock[id]-n end
        local last=steps[#steps]
        if last and last.recipe.id==best.id then last.count=last.count+1; last.to=rank+1
        else steps[#steps+1]={recipe=best,count=1,from=rank,to=rank+1} end
        rank=rank+1
    end
    return steps,rank
end

function M:Details(r,step)
    local lines={r.name,r.known and "Rezept gelernt" or "Rezept noch lernen / im Berufsfenster bestätigen"}
    if r.required then lines[#lines+1]="Benötigte Fertigkeit: "..r.required else lines[#lines+1]="Benötigte Fertigkeit unbekannt" end
    if r.grey then
        lines[#lines+1]="Gelb ab "..(r.yellow or "?")..", grau ab "..r.grey.." (Datenbankwerte)"
    else lines[#lines+1]="Skillgrenzen fehlen: keine Skillprognose" end
    lines[#lines+1]="Herstellungen: "..(r.bagCrafts or 0).." in Taschen; "..(r.crafts or 0).." mit gewähltem Bestand"
    if step then lines[#lines+1]="Vorschlag: "..step.count.."×, Fertigkeit "..step.from.." → "..step.to.." bestenfalls" end
    if r.unsupported then lines[#lines+1]="Rezeptmaterialien nicht vollständig lesbar; nicht im Skillplan" end
    local ids={}; for id in pairs(r.reagents) do ids[#ids+1]=id end; table.sort(ids)
    for _,id in ipairs(ids) do
        local need=r.reagents[id]; local have=self.stock[id] or 0
        lines[#lines+1]=("%s: %d pro Herstellung | Taschen %d, Bank %d | fehlt %d"):format(
            Item(id),need,self.bags[id] or 0,self.settings.bank and (self.db.bank[id] or 0) or 0,math.max(0,need-have))
    end
    if not r.known then
        if r.teach then lines[#lines+1]="Benötigtes Rezept: "..Item(r.teach).." (item:"..r.teach..")" end
        local e=r.entry or {}; local sources={}
        for _,source in ipairs(e.source or {}) do sources[#sources+1]=SOURCE[source] or source end
        lines[#lines+1]="Quelle: "..(#sources>0 and table.concat(sources,", ") or "im Berufsfenster / bei der Lernübersicht prüfen")
        for _,kind in ipairs({"vendors","quests"}) do
            for _,where in ipairs(e[kind] or {}) do
                if not where.faction or where.faction==Read(UnitFactionGroup,"player") then
                    lines[#lines+1]=(where.npc and "NPC #"..where.npc or "Quest #"..(where.id or "?")).." – "
                        ..(Read(C_Map and C_Map.GetAreaInfo,where.area) or ("Gebiet #"..(where.area or "?")))
                end
            end
        end
        if e.level then lines[#lines+1]="Charakterstufe: "..e.level end
        if e.reputation or e.reputationUnknown or e.merchantFavor then lines[#lines+1]="Zusätzliche Ruf-/Händleranforderungen in der Lernübersicht prüfen" end
    end
    lines[#lines+1]="Klick: Rezept / Zauber ansehen. Jede Rezeptzeile ist eine Alternative; Material nur im Skillplan gemeinsam verrechnet."
    return lines
end

function M:Refresh()
    if not self.panel or not self.panel:IsShown() or not FT:IsEnabled("professionplanner") then return end
    self:Build()
    local p,skill=self.panel,self.skills[self.profession]
    p.profession:SetText(skill and skill.name or "Keine Herstellberufe")
    p.bank:SetText(self.settings.bank and "Bestand: Taschen + Bank" or "Bestand: nur Taschen")
    p.unlearned:SetText(self.settings.unlearned and "Plan: auch fehlende Rezepte" or "Plan: nur gelernte Rezepte")
    p.mode:SetText(self.mode=="plan" and "Ansicht: Skillplan" or "Ansicht: Rezepte")
    local bank=self.db.bankTime and ("Bankstand: "..(Read(date,"%d.%m. %H:%M",self.db.bankTime) or "gespeichert")) or "Bank noch nicht gescannt: einmal öffnen"
    p.summary:SetText(skill and (skill.name.." "..skill.rank.."/"..skill.cap.." | Skillvorschlag bis "..self.target
        .." (+"..(self.target-skill.rank).." bestenfalls)\n"..bank) or "Öffne deine Berufe, um Rezepte zu erfassen.\n"..bank)
    local list=self.mode=="plan" and self.plan or self.rows
    self.offset=math.max(0,math.min(self.offset or 0,math.max(0,#list-7)))
    for i,button in ipairs(p.rows) do
        local entry=list[self.offset+i]
        local r=entry and (self.mode=="plan" and entry.recipe or entry)
        button.row=r; button.step=self.mode=="plan" and entry or nil
        local text="–"
        if r then
            local learned=r.known and "|cff65d6adGelernt|r" or "|cffffcc66Rezept fehlt / prüfen|r"
            if self.mode=="plan" then
                text=entry.count.."× "..r.name.." | "..entry.from.." → "..entry.to.." bestenfalls\n"..learned
            else
                local target=r.grey and (" | bis "..r.target.." bestenfalls") or " | Skillgrenzen unbekannt"
                if r.unsupported then target=" | Materialien im Berufsfenster prüfen" end
                if r.required and skill and r.required>skill.rank then target=" | erst ab Fertigkeit "..r.required end
                text=r.name.." | "..learned.."\n"..r.bagCrafts.."× Taschen / "..r.crafts.."× Bestand"..target
            end
        end
        button:SetText(text); button:SetEnabled(r~=nil)
    end
    p.page:SetText((#list==0 and "Keine passenden Rezepte / kein Skillvorschlag" or (self.offset+1).."–"..math.min(#list,self.offset+7).." von "..#list)
        .." | Maus darüber: Materialien und Rezeptquelle")
end

function M:HideTooltip() if self.tooltip then self.tooltip:Hide() end end
function M:Open()
    if not FT:IsEnabled("professionplanner") then return end
    if not self.panel then
        local p=CreateFrame("Frame","ForeverToolsProfessionPlanner",UIParent,"BasicFrameTemplateWithInset"); self.panel=p
        p:SetSize(820,650); p:SetPoint("CENTER"); p:SetClampedToScreen(true); p:SetMovable(true); p:EnableMouse(true)
        p:RegisterForDrag("LeftButton"); p:SetScript("OnDragStart",p.StartMoving); p:SetScript("OnDragStop",p.StopMovingOrSizing)
        p:SetScript("OnHide",function() self:HideTooltip() end)
        p.TitleText:SetText("ForeverTools – Berufsplaner")
        UISpecialFrames[#UISpecialFrames+1]="ForeverToolsProfessionPlanner"
        local function Label(y,height)
            local f=p:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
            f:SetPoint("TOPLEFT",20,y); f:SetWidth(780); f:SetHeight(height); f:SetJustifyH("LEFT"); return f
        end
        local function Button(text,x,y,width,callback)
            local b=CreateFrame("Button",nil,p,"UIPanelButtonTemplate")
            b:SetSize(width,26); b:SetPoint("TOPLEFT",x,y); b:SetText(text); b:SetScript("OnClick",callback); return b
        end
        p.profession=Button("Beruf",20,-38,235,function()
            self:Skills(); local ids={}; for id in pairs(self.skills) do ids[#ids+1]=id end; table.sort(ids)
            for i,id in ipairs(ids) do if id==self.profession then self.profession=ids[i%#ids+1]; break end end
            self.offset=0; self:Refresh()
        end)
        p.bank=Button("",265,-38,235,function() self.settings.bank=not self.settings.bank; self.offset=0; self:Refresh() end)
        Button("Neu scannen",510,-38,135,function() self:ScanRecipes(); self:ScanBank(); self:Refresh() end)
        Button("Lernübersicht",655,-38,145,function() if FT.modules.training then FT.modules.training:Open() end end)
        p.unlearned=Button("",20,-74,285,function() self.settings.unlearned=not self.settings.unlearned; self.offset=0; self:Refresh() end)
        p.mode=Button("",315,-74,185,function() self.mode=self.mode=="plan" and "recipes" or "plan"; self.offset=0; self:Refresh() end)
        p.search=CreateFrame("EditBox",nil,p,"InputBoxTemplate"); p.search:SetSize(280,24); p.search:SetPoint("TOPLEFT",520,-75)
        p.search:SetAutoFocus(false); p.search:SetScript("OnEscapePressed",function(f) f:ClearFocus() end)
        p.search:SetScript("OnTextChanged",function(f) self.query=f:GetText():lower(); self.offset=0; self:Refresh() end)
        p.summary=Label(-110,46)
        p.rows={}
        for i=1,7 do
            local b=Button("",20,-164-(i-1)*49,780,function(button)
                if button.row and SetItemRef then
                    local r=button.row; local link=r.teach and "item:"..r.teach or "spell:"..r.id
                    SetItemRef(link,"["..r.name.."]","LeftButton")
                end
            end)
            b:SetHeight(44)
            b:SetScript("OnEnter",function(button)
                if not button.row then return end
                self.tooltip=self.tooltip or CreateFrame("GameTooltip","ForeverToolsProfessionTooltip",UIParent,"GameTooltipTemplate")
                self.tooltip:SetOwner(button,"ANCHOR_RIGHT"); self.tooltip:ClearLines()
                for _,line in ipairs(self:Details(button.row,button.step)) do self.tooltip:AddLine(line,1,1,1,true) end
                self.tooltip:Show()
            end)
            b:SetScript("OnLeave",function() self:HideTooltip() end)
            p.rows[i]=b
        end
        Button("Zurück",20,-515,100,function() self.offset=math.max(0,(self.offset or 0)-7); self:HideTooltip(); self:Refresh() end)
        Button("Weiter",130,-515,100,function() self.offset=(self.offset or 0)+7; self:HideTooltip(); self:Refresh() end)
        p.page=Label(-550,26)
        local note=Label(-581,52)
        note:SetText("Start: Bank einmal öffnen und jeden Beruf öffnen. Neu scannen aktualisiert die Daten.\nSkillplan: Materialverbrauch für diesen Beruf; Vorschlag, keine optimale Route. Gelb/Grün: Skillpunkt zufällig.\nAnnahme: +1 je Herstellung. Zwischenprodukte, Werkzeuge und Abklingzeiten im Berufsfenster prüfen.")
    end
    self.panel:SetShown(true)
    self:ScanRecipes(); self:ScanBank(); self:Refresh()
end

function M:OnSettingsChanged()
    if not FT:IsEnabled("professionplanner") then
        self:HideTooltip(); if self.panel then self.panel:SetShown(false) end
    else self:Refresh() end
end
function M:Initialize()
    ForeverToolsProfessionDB=type(ForeverToolsProfessionDB)=="table" and ForeverToolsProfessionDB or {}
    self.db=ForeverToolsProfessionDB
    for _,key in ipairs({"bank","recipes","ranks"}) do if type(self.db[key])~="table" then self.db[key]={} end end
    self.frame=CreateFrame("Frame")
    for _,event in ipairs({"BANKFRAME_OPENED","BANKFRAME_CLOSED","PLAYERBANKSLOTS_CHANGED","BAG_UPDATE_DELAYED",
        "TRADE_SKILL_SHOW","TRADE_SKILL_LIST_UPDATE","TRADE_SKILL_UPDATE","CRAFT_SHOW","CRAFT_UPDATE","SKILL_LINES_CHANGED",
        "SPELLS_CHANGED","PLAYER_ENTERING_WORLD","GET_ITEM_INFO_RECEIVED","SPELL_DATA_LOAD_RESULT"}) do
        pcall(self.frame.RegisterEvent,self.frame,event)
    end
    self.frame:SetScript("OnEvent",function(_,event)
        if event=="BANKFRAME_OPENED" then self.bankOpen=true end
        if event=="BANKFRAME_CLOSED" then self.bankOpen=false end
        if not FT:IsEnabled("professionplanner") then return end
        if event:find("TRADE_SKILL",1,true) or event:find("CRAFT",1,true) or event=="SPELLS_CHANGED" or event=="SKILL_LINES_CHANGED" then
            self:ScanRecipes()
        end
        if event=="BANKFRAME_OPENED" or event=="PLAYERBANKSLOTS_CHANGED" or event=="BAG_UPDATE_DELAYED" then self:ScanBank() end
        self:Refresh()
    end)
    SLASH_FOREVERTOOLSPROFESSIONS1="/ftberufe"
    SLASH_FOREVERTOOLSPROFESSIONS2="/ftprof"
    SlashCmdList.FOREVERTOOLSPROFESSIONS=function() self:Open() end
end
