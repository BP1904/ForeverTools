local addonName,FT=...
local previous=_G.AutoRank
if type(previous)=="table" and previous.db and type(previous.SetEnabled)=="function" then
    FT.autoRank=previous
    local migration=CreateFrame("Frame")
    migration:RegisterEvent("ADDON_LOADED")
    migration:SetScript("OnEvent",function(_,_,name)
        if name~=addonName then return end
        migration:UnregisterEvent("ADDON_LOADED")
        ForeverToolsAutoRankDB=previous.db
        FT:RetireLegacyAddon("AutoRank")
    end)
    return
end
local A={}
FT.autoRank=A
_G.AutoRank=A
local function Secret(value) return issecretvalue and issecretvalue(value) end
local function Read(fn,fallback,...)
    if not fn then return fallback end
    local ok,value=pcall(fn,...)
    if not ok or Secret(value) then return fallback end
    return value
end
local function Combat() return Read(InCombatLockdown,true) end
local function Print(message) DEFAULT_CHAT_FRAME:AddMessage("|cff65d6adAuto Rank:|r "..message) end
local function Spell(id)
    if C_Spell and C_Spell.GetSpellInfo then
        local info=Read(C_Spell.GetSpellInfo,nil,id)
        return info and Read(function() return info.name end)
    end
    return Read(GetSpellInfo,nil,id)
end
local function Subtext(id)
    if C_Spell and C_Spell.GetSpellSubtext then return Read(C_Spell.GetSpellSubtext,"",id) end
    if GetSpellSubtext then return Read(GetSpellSubtext,"",id) end
    local ok,_,rank=pcall(function() return GetSpellInfo(id) end)
    return ok and not Secret(rank) and rank or ""
end
local function Rank(subtext)
    return type(subtext)=="string" and tonumber(subtext:match("%d+")) or 0
end
local function Key(name,subtext)
    -- Non-rank subtitles distinguish different variants with the same name.
    if type(subtext)=="string" and subtext~="" and not subtext:match("%d+") then
        return name.."\031"..subtext
    end
    return name
end
local function Action(slot)
    local ok,kind,id=pcall(GetActionInfo,slot)
    if not ok or Secret(kind) or Secret(id) then return false end
    return true,kind,id
end
local function CursorEmpty()
    if not GetCursorInfo then return false end
    local ok,kind=pcall(GetCursorInfo)
    return ok and not Secret(kind) and kind==nil
end

function A:IsEnabled() return self.db and self.db.enabled and true or false end
function A:NotifyState()
    for _,listener in ipairs(self.listeners or {}) do listener(self) end
end
function A:RegisterStateListener(listener)
    self.listeners=self.listeners or {}; self.listeners[#self.listeners+1]=listener
end
function A:SetEnabled(enabled)
    self.db.enabled=enabled and true or false
    if self.db.enabled then self.fault=nil; self:Schedule()
    else
        if self.reportCompletion then Print("Prüfung abgebrochen: Auto Rank wurde ausgeschaltet.") end
        self.pending=false; self.reportCompletion=nil; self.waitReason=nil
    end
    self:NotifyState()
end
function A:Schedule()
    if not self:IsEnabled() or self.writing or self.fault then return end
    self.pending=true; self.wait=0.35
end

function A:WaitFor(reason,delay)
    if self.reportCompletion and self.waitReason~=reason then Print("Prüfung wartet: "..reason) end
    self.waitReason=reason; self.wait=delay or 0.5
end

function A:Catalog()
    local catalog={groups={},byID={},ordered={}}
    local function Add(id,index,bank,name,subtext,passive)
        if type(id)~="number" or id<=0 or passive then return end
        local known=Read(C_SpellBook and (C_SpellBook.IsSpellKnownOrInSpellBook or C_SpellBook.IsSpellKnown),nil,id,bank)
        if known==false then return end
        if Read(C_Spell and C_Spell.IsSpellPassive,false,id) or Read(IsPassiveSpell,false,id) then return end
        name=name or Spell(id)
        if type(name)~="string" or name=="" then return end
        if subtext==nil or subtext=="" then subtext=Subtext(id) end
        local rank=Rank(subtext)
        local key=Key(name,subtext)
        local entry={id=id,index=index,bank=bank,name=name,rank=rank,key=key}
        local group=catalog.groups[key]
        if not group then
            group={key=key,best=entry,members={}}; catalog.groups[key]=group
            catalog.ordered[#catalog.ordered+1]=group
        elseif rank>group.best.rank then group.best=entry end
        catalog.byID[id]=group
        group.members[id]=entry
        return group
    end
    if C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines and C_SpellBook.GetSpellBookItemInfo then
        local bank=Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
        local types=Enum and Enum.SpellBookItemType
        if bank==nil or not types or not types.Spell then return nil end
        local count=Read(C_SpellBook.GetNumSpellBookSkillLines,nil)
        if type(count)~="number" or count==0 then return nil end
        for line=1,count do
            local info=Read(C_SpellBook.GetSpellBookSkillLineInfo,nil,line)
            if info then
                local ok,offset,num,skip=pcall(function()
                    return info.itemIndexOffset,info.numSpellBookItems,info.isGuild or info.shouldHide or info.offSpecID~=nil
                end)
                if ok and not Secret(skip) and not skip and not Secret(offset) and not Secret(num)
                    and type(offset)=="number" and type(num)=="number" then
                    for index=offset+1,offset+num do
                        local item=Read(C_SpellBook.GetSpellBookItemInfo,nil,index,bank)
                        if item then
                            local readable,id,name,subtext,passive=pcall(function()
                                if item.itemType~=types.Spell or item.isOffSpec then return end
                                return item.spellID or item.actionID,item.name,item.subName,item.isPassive
                            end)
                            if readable and not Secret(id) and not Secret(name) and not Secret(subtext) and not Secret(passive) then
                                local group=Add(id,index,bank,name,subtext,passive)
                                local base=Read(function() return item.actionID end)
                                if group and type(base)=="number" then catalog.byID[base]=group end
                            end
                        end
                    end
                end
            end
        end
    elseif GetNumSpellTabs and GetSpellTabInfo and GetSpellBookItemInfo then
        for tab=1,Read(GetNumSpellTabs,0) do
            local ok,_,_,offset,num=pcall(GetSpellTabInfo,tab)
            if ok and not Secret(offset) and not Secret(num) and type(offset)=="number" and type(num)=="number" then
                for index=offset+1,offset+num do
                    local readable,kind,id=pcall(GetSpellBookItemInfo,index,BOOKTYPE_SPELL or "spell")
                    if readable and not Secret(kind) and not Secret(id) and kind=="SPELL" then
                        Add(id,index,BOOKTYPE_SPELL or "spell",nil,nil,Read(IsPassiveSpell,false,index,BOOKTYPE_SPELL or "spell"))
                    end
                end
            end
        end
    else return nil end
    for _,group in ipairs(catalog.ordered) do
        local override=Read(C_SpellBook and C_SpellBook.FindSpellOverrideByID,nil,group.best.id)
        local entry=override and group.members[override]
        if entry and entry.rank>=group.best.rank then group.best=entry end
    end
    return catalog
end

function A:Family(catalog,id)
    if type(id)~="number" then return end
    if catalog.byID[id] then return catalog.byID[id] end
    local name=Spell(id)
    if type(name)=="string" then return catalog.groups[Key(name,Subtext(id))] end
end

function A:AdditionSlots()
    local slots,seen={},{}
    local function Add(slot)
        if type(slot)=="number" and slot>=1 and slot<=180 and not seen[slot] then
            seen[slot]=true; slots[#slots+1]=slot
        end
    end
    for i=1,12 do Add(i) end
    for _,bar in ipairs({{"MultiBarBottomLeft",61},{"MultiBarBottomRight",49},{"MultiBarRight",25},
        {"MultiBarLeft",37},{"MultiBar5",145},{"MultiBar6",157},{"MultiBar7",169}}) do
        local frame=_G[bar[1]]
        if frame and Read(frame.IsShown,false,frame) then
            for i=1,12 do
                local button=_G[bar[1].."Button"..i]
                local slot=button and Read(function() return button.action end)
                Add(slot or bar[2]+i-1)
            end
        end
    end
    return slots
end

function A:Put(slot,entry,expectedKind,expectedID)
    if Combat() or not CursorEmpty() then return false end
    local readable,kind,id=Action(slot)
    if not readable or kind~=expectedKind or id~=expectedID then return false end
    local pickup=C_Spell and C_Spell.PickupSpell or PickupSpell
    local ok
    if pickup then ok=pcall(pickup,entry.id)
    elseif C_SpellBook and C_SpellBook.PickupSpellBookItem then
        ok=pcall(C_SpellBook.PickupSpellBookItem,entry.index,entry.bank)
    elseif PickupSpellBookItem then ok=pcall(PickupSpellBookItem,entry.index,entry.bank) end
    if not ok then self.fault="Zauber konnte nicht aufgenommen werden."; return false end
    if Read(GetCursorInfo,nil)~="spell" then return false end
    readable,kind,id=Action(slot)
    if Combat() or not readable or kind~=expectedKind or id~=expectedID then
        if not Combat() then ClearCursor() end
        return false
    end
    ok=pcall(PlaceAction,slot)
    if Combat() then self.fault="Platzierung durch Kampfbeginn unterbrochen; Mauszeiger bitte prüfen."; return false end
    local valid,newKind,newID=Action(slot)
    local effective=Read(C_ActionBar and C_ActionBar.GetSpell,nil,slot)
    if ok and valid and newKind=="spell" and (newID==entry.id or effective==entry.id) then
        ClearCursor(); return true
    end
    -- If a swap occurred but did not produce the requested spell, put back the
    -- displaced original before discarding our own picked-up spell.
    if not Combat() and not CursorEmpty() then
        if expectedKind and valid and (newKind~=expectedKind or newID~=expectedID) then
            local restored=pcall(PlaceAction,slot)
            local readable,oldKind,oldID=Action(slot)
            if not restored or not readable or oldKind~=expectedKind or oldID~=expectedID then
                self.fault="Originalaktion bleibt am Mauszeiger. Bitte zurücklegen; Automatik pausiert."
                return false
            end
        end
        ClearCursor()
    end
    self.fault="Platzierung wurde vom Client nicht bestätigt. Automatik pausiert; /autorank scan versucht es erneut."
    return false
end

function A:Run()
    if not self:IsEnabled() then self.pending=false; return end
    if not self.ready then self:WaitFor("Die Spielwelt ist noch nicht bereit."); return end
    if Combat() then self:WaitFor("Der Kampf muss zuerst enden."); return end
    if not CursorEmpty() then self:WaitFor("Bitte den Mauszeiger freimachen."); return end
    if Read(UnitHasVehicleUI,false,"player") then self:WaitFor("Bitte zuerst die Fahrzeugsteuerung verlassen."); return end
    if not GetActionInfo or not PlaceAction or not ClearCursor then
        self.pending=false; self.reportCompletion=nil; self.waitReason=nil
        Print("Prüfung abgebrochen: Aktionsleisten-API fehlt."); return
    end
    local catalog=self:Catalog()
    if not catalog then self:WaitFor("Das Zauberbuch ist noch nicht verfügbar.",1); return end
    self.pending=false; self.writing=true
    local present,free={},{}
    local replaced,added=0,0
    local updates,bySpell={},{}
    for slot=1,180 do
        local valid,kind,id=Action(slot)
        if valid and kind=="spell" then
            local group=self:Family(catalog,id)
            if group then
                present[group.key]=true
                local best=group.best
                local currentRank=Rank(Subtext(id))
                local override=Read(C_SpellBook and C_SpellBook.FindSpellOverrideByID,nil,id)
                local effective=Read(C_ActionBar and C_ActionBar.GetSpell,nil,slot)
                if not self.fault and id~=best.id and effective~=best.id and (best.rank>currentRank or override==best.id) then
                    if self:Put(slot,best,kind,id) then
                        replaced=replaced+1
                        local update=bySpell[best.id]
                        if not update then
                            update={name=best.name,rank=best.rank,count=0}
                            bySpell[best.id]=update; updates[#updates+1]=update
                        end
                        update.count=update.count+1
                    end
                end
            end
        elseif valid and kind=="macro" and GetMacroSpell then
            local ok,a,_,c=pcall(GetMacroSpell,id)
            local spellID=ok and not Secret(c) and type(c)=="number" and c
                or ok and not Secret(a) and type(a)=="number" and a
            local group=spellID and self:Family(catalog,spellID)
            if group then present[group.key]=true end
        end
    end
    for _,group in ipairs(catalog.ordered) do
        if not self.db.seen[group.key] then self.db.waiting[group.key]=true end
        self.db.seen[group.key]=true
        if present[group.key] then self.db.waiting[group.key]=nil end
    end
    for _,slot in ipairs(self:AdditionSlots()) do
        local valid,kind=Action(slot)
        if valid and kind==nil then free[#free+1]=slot end
    end
    local nextFree=1
    for _,group in ipairs(catalog.ordered) do
        if self.db.waiting[group.key] and free[nextFree] and not self.fault then
            if self:Put(free[nextFree],group.best,nil,nil) then
                added=added+1; nextFree=nextFree+1; self.db.waiting[group.key]=nil
            end
        end
    end
    self.writing=false
    local waiting=0
    for key in pairs(self.db.waiting) do if catalog.groups[key] then waiting=waiting+1 end end
    self.last={replaced=replaced,added=added,waiting=waiting}
    for _,update in ipairs(updates) do
        local rank=update.rank>0 and ("Rang "..update.rank) or "höchste gelernte Variante"
        Print(("%s: %s eingesetzt (%d Leistenplätze)."):format(update.name,rank,update.count))
    end
    if not self.fault and self.reportCompletion and replaced==0 then
        Print(("Prüfung abgeschlossen: Keine höheren gelernten Zauberränge gefunden. %d Fähigkeiten ergänzt."):format(added))
    elseif not self.fault and (self.reportCompletion or replaced>0 or added>0) then
        Print(("Prüfung abgeschlossen: %d Leistenplätze aktualisiert, %d Fähigkeiten ergänzt."):format(replaced,added))
    end
    if waiting>0 and (self.reportCompletion or self.lastWaiting~=waiting) then
        Print(("%d Fähigkeiten warten auf freie Plätze. Bei Bedarf weitere Aktionsleisten einschalten."):format(waiting))
    end
    self.lastWaiting=waiting
    self.reportCompletion=nil; self.waitReason=nil
    if self.fault then Print("Prüfung abgebrochen: "..self.fault) end
end

function A:Command(text)
    local command=(text or ""):lower():match("^%s*(%S*)")
    if command=="on" then self:SetEnabled(true)
    elseif command=="off" then self:SetEnabled(false)
    elseif command=="scan" or command=="fill" then
        if not self:IsEnabled() then Print("Keine Prüfung gestartet: Auto Rank ist ausgeschaltet. Einschalten mit /autorank on oder in der Übersicht."); return end
        if command=="fill" then self.db.seen={} end
        self.fault=nil; self.reportCompletion=true; self.waitReason=nil; self:Schedule()
        Print(Combat() and "Prüfung nach Kampfende vorgemerkt." or "Aktionsleistenprüfung gestartet.")
    else
        Print("/autorank on | off | scan | fill. scan prüft Ränge; fill ergänzt auch absichtlich entfernte Fähigkeiten.")
    end
end

local frame=CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent",function(_,event,name)
    if event=="ADDON_LOADED" then
        if name~=addonName then return end
        frame:UnregisterEvent("ADDON_LOADED")
        ForeverToolsAutoRankDB=type(ForeverToolsAutoRankDB)=="table" and ForeverToolsAutoRankDB or {}; A.db=ForeverToolsAutoRankDB
        if A.db.enabled==nil then A.db.enabled=true end
        A.db.seen=type(A.db.seen)=="table" and A.db.seen or {}
        A.db.waiting=type(A.db.waiting)=="table" and A.db.waiting or {}
        for _,e in ipairs({"PLAYER_LOGIN","PLAYER_ENTERING_WORLD","SPELLS_CHANGED","LEARNED_SPELL_IN_SKILL_LINE",
            "SPELL_DATA_LOAD_RESULT","SPELL_TEXT_UPDATE","ACTIONBAR_SLOT_CHANGED","PLAYER_REGEN_ENABLED",
            "CURSOR_CHANGED","CVAR_UPDATE","EDIT_MODE_LAYOUTS_UPDATED"}) do
            frame:RegisterEvent(e)
        end
        SLASH_AUTORANK1="/autorank"
        SlashCmdList.AUTORANK=function(text) A:Command(text) end
        A:Schedule(); A:NotifyState()
    else
        if event=="PLAYER_ENTERING_WORLD" then A.ready=true end
        A:Schedule()
    end
end)
frame:SetScript("OnUpdate",function(_,delta)
    if not A.pending then return end
    A.wait=(A.wait or 0)-delta
    if A.wait<=0 then
        local ok,err=pcall(A.Run,A)
        if not ok then
            A.writing=false; A.pending=false; A.reportCompletion=nil; A.waitReason=nil; A.fault="Prüfung abgebrochen."
            Print("Prüfung abgebrochen: "..(not Secret(err) and type(err)=="string" and err or "unbekannter Fehler"))
        end
    end
end)
