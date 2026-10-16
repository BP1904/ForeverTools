-- Independent ForeverTools implementation of the supplied PallyPower feature model.
local _, FT = ...
local D = FT.paladinData
local M = {
    title = "Paladin: Segen & Gruppenbuffs",
    description = "Kleine dauerhafte Buffleiste. Zuweisungen separat über /ftpp bearbeiten.",
    defaults = {showSolo=true, duration=true, salvation=false, sync=true, freeassign=false},
    options = {
        {key="showSolo", title="Zuweisungsfenster auch ohne Gruppe anzeigen"},
        {key="duration", title="Buffvorschlag nur bei weniger als 4 Minuten"},
        {key="salvation", title="Separate Rettungs-Schaltflächen aktivieren"},
        {key="sync", title="Zuweisungen mit PallyPower synchronisieren"},
        {key="freeassign", title="Andere Gruppenmitglieder dürfen mir zuweisen"},
    },
}
M.actions = {{title="Paladin-Zuweisungen öffnen", run=function() M:ToggleWindow() end}}
FT:RegisterModule("paladin", M)
local function Secret(value) return issecretvalue and issecretvalue(value) end
local function Read(fn, fallback, ...)
    if not fn then return fallback end
    local ok, value = pcall(fn, ...)
    if not ok or Secret(value) then return fallback end
    return value
end
local function Combat() return InCombatLockdown() end
local function Name(unit)
    return Read(GetUnitName, nil, unit, true) or Read(UnitName, nil, unit)
end
local function Spell(id)
    if not id then return end
    if C_Spell and C_Spell.GetSpellInfo then
        local info = Read(C_Spell.GetSpellInfo, nil, id)
        return info and Read(function() return info.name end)
    end
    return Read(GetSpellInfo, nil, id)
end
local function Known(id)
    if C_SpellBook and Read(C_SpellBook.IsSpellKnown,false,id) then return true end
    if Read(IsPlayerSpell,false,id) then return true end
    return Read(IsSpellKnown,false,id)
end
local function Copy(value)
    if type(value) ~= "table" then return value end
    local out = {}; for k,v in pairs(value) do out[k] = Copy(v) end; return out
end
local function Wire(name) return (name:gsub(" ", "_")) end
local function Unwire(name) return (name:gsub("_", " ")) end
local function ValidBlessing(value)
    value = tonumber(value)
    return value and value >= 0 and value <= 8 and value == math.floor(value) and value or nil
end

function M:Profile(name)
    local profiles = self.db.paladins
    if type(profiles[name]) ~= "table" then profiles[name] = {} end
    local p = profiles[name]
    for _,key in ipairs({"classes", "players"}) do if type(p[key]) ~= "table" then p[key] = {} end end
    return p
end

function M:ScanSpells()
    self.spells, self.greater = {}, {}
    for id, entry in pairs(D.blessings) do
        for _, spell in ipairs(entry.normal) do
            if Known(spell) then self.spells[id] = Spell(spell); break end
        end
        for _, spell in ipairs(entry.greater) do
            if Known(spell) then self.greater[id] = Spell(spell); break end
        end
    end
    self.capabilities[self.player] = self.spells
    self:ScanAuras()
end

function M:ScanAuras()
    self.auraSpells={}
    for index,baseID in ipairs(D.auras) do
        for _,id in ipairs(D.auraRanks[index]) do
            if Known(id) then self.auraSpells[index]=id; break end
        end
        -- The spellbook resolves the currently usable rank/override by localized aura name.
        -- This also handles client-specific IDs that are absent from the static rank families.
        local name=Spell(baseID)
        if C_SpellBook and C_SpellBook.FindSpellBookSlotForSpell and C_SpellBook.GetSpellBookItemInfo then
            local ok,slot,bank=pcall(C_SpellBook.FindSpellBookSlotForSpell,name or baseID)
            if ok and not Secret(slot) and slot then
                if Secret(bank) then bank=nil end
                bank=bank or (Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player)
                local info=Read(C_SpellBook.GetSpellBookItemInfo,nil,slot,bank)
                local id=info and Read(function()
                    if info.isPassive or info.isOffSpec then return end
                    if Enum and Enum.SpellBookItemType and Enum.SpellBookItemType.FutureSpell
                        and info.itemType==Enum.SpellBookItemType.FutureSpell then return end
                    return info.spellID
                end)
                if type(id)=="number" and id>0 and name and Spell(id)==name then self.auraSpells[index]=id end
            end
        end
    end
    self.auraCapabilities[self.player]={}
    for index in pairs(self.auraSpells) do self.auraCapabilities[self.player][index]=true end
end

function M:AuraSpell(index)
    return self.auraSpells and self.auraSpells[index]
end

function M:Roster()
    local list, byName = {}, {}
    local function Add(unit)
        if not Read(UnitExists, false, unit) then return end
        local name = Name(unit)
        local ok, _, class = pcall(UnitClass, unit)
        if not ok or Secret(class) or not name or byName[name] then return end
        for index, token in ipairs(D.classes) do
            if class == token then
                local row = {unit=unit, name=name, class=index,
                    guid=Read(UnitGUID, name, unit), tank=Read(UnitGroupRolesAssigned, "", unit)=="TANK"
                        or Read(GetPartyAssignment, false, "MAINTANK", unit)}
                list[#list+1] = row; byName[name] = row
            end
        end
    end
    if Read(IsInRaid, false) then
        for i=1, Read(GetNumGroupMembers, 0) do Add("raid"..i) end
    else
        Add("player")
        for i=1, Read(GetNumSubgroupMembers, 0) do Add("party"..i) end
    end
    table.sort(list, function(a,b)
        if a.class ~= b.class then return a.class < b.class end
        return a.name < b.name
    end)
    self.roster, self.byName = list, byName
    self.paladins = {}
    for _, row in ipairs(list) do
        if row.class == 5 then self.paladins[#self.paladins+1] = row.name end
    end
    if #self.paladins == 0 then self.paladins[1] = self.player end
    if not self.selected or not byName[self.selected] then self.selected = self.player end
end

function M:Assignment(row, owner)
    local p = self:Profile(owner or self.player)
    return p.players[row.name] or p.classes[row.class] or 0
end

-- Unknown/secret auras retain only previously measured timers; never invent a full duration.
function M:Remaining(row, wanted)
    if not wanted then return 0 end
    if Read(UnitGUID, row.guid, row.unit) ~= row.guid then return nil end
    local cacheKey = row.guid .. "|" .. wanted
    local cached = self.auraCache[cacheKey]
    local hidden, found, expiration = false, false, nil
    for i=1,255 do
        local ok, aura
        if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
            ok, aura = pcall(C_UnitAuras.GetAuraDataByIndex, row.unit, i, "HELPFUL")
        elseif UnitBuff then
            ok, aura = pcall(function()
                local name, _, _, _, duration, expires = UnitBuff(row.unit, i)
                if not name then return end
                return {name=name, duration=duration, expirationTime=expires}
            end)
        else hidden=true; break end
        if not ok or Secret(aura) then hidden=true; break end
        if not aura then break end
        local readable, matched, exp = pcall(function()
            if Secret(aura.name) then return nil end
            if aura.name ~= wanted then return false end
            if Secret(aura.expirationTime) then return true, nil end
            return true, aura.expirationTime
        end)
        if not readable or matched == nil then hidden=true
        elseif matched then found=true; expiration=exp; break end
    end
    if found and expiration then
        if expiration == 0 then self.auraCache[cacheKey] = math.huge; return math.huge end
        self.auraCache[cacheKey] = expiration
        return math.max(0, expiration - GetTime())
    end
    if found or hidden then
        if cached then return math.max(0, cached - GetTime()) end
        return nil
    end
    self.auraCache[cacheKey] = nil
    return 0
end

function M:BuffRemaining(row, id)
    local entry = D.blessings[id]
    if not entry then return 0 end
    local normal = self.spells[id] or Spell(entry.normal[#entry.normal])
    local a = self:Remaining(row, normal)
    local b = 0
    if #entry.greater > 0 then b = self:Remaining(row, self.greater[id] or Spell(entry.greater[#entry.greater])) end
    if a == nil or b == nil then
        if (a or 0) > 0 or (b or 0) > 0 then return math.max(a or 0, b or 0) end
        return nil
    end
    return math.max(a,b)
end

function M:Eligible(row, spell, salvation, manual)
    if not spell or (salvation and row.tank) then return false end
    if Read(UnitIsDeadOrGhost, true, row.unit) or not Read(UnitIsConnected, false, row.unit) then return false end
    local range
    if C_Spell and C_Spell.IsSpellInRange then range = Read(C_Spell.IsSpellInRange, nil, spell, row.unit)
    elseif IsSpellInRange then range = Read(IsSpellInRange, nil, spell, row.unit) end
    -- A manual click may try a target when the client cannot report range.
    -- A definite out-of-range result is still excluded.
    return range == true or range == 1 or (manual and range==nil)
end

function M:Pick(class, salvation, manual)
    local best, bestTime
    for _, row in ipairs(self.roster) do
        local id = salvation and 4 or self:Assignment(row)
        if (not class or row.class==class) and self:Eligible(row, self.spells[id], salvation, manual) then
            local left = self:BuffRemaining(row,id)
            if (manual or not self.settings.duration or (left and left < 240)) then
                local stamp = self.castStamps[row.name..":"..id] or 0
                local score = (left == 0 and -1e12 or 0) + stamp
                if not best or score < bestTime then best, bestTime = row, score end
            end
        end
    end
    return best
end

function M:Configure(button, row, id, allowGreater)
    if Combat() then self.dirty=true; return end
    local normal = row and self.spells[id]
    local greater = normal and allowGreater and self.greater[id] or normal
    for _, mouse in ipairs({"1","2"}) do
        local spell=mouse == "1" and greater or normal
        button:SetAttribute("type"..mouse, normal and "macro" or nil)
        button:SetAttribute("spell"..mouse, spell)
        -- Match the supplied Forever port: resolve surnamed targets through /cast @name.
        -- Spell actions use unit identifiers; macro conditionals preserve a specific full name.
        button:SetAttribute("macrotext"..mouse, normal and
            ("/cast [@"..row.name..",help,nodead] "..spell) or nil)
    end
    -- Full names keep a frozen combat assignment from following a recycled party unit token.
    button:SetAttribute("unit", row and row.name or nil)
    button.castRow, button.castID = row, id
end

function M:PrepareSmart(button, class, salvation)
    if Combat() or not FT:IsEnabled("paladin") then return end
    -- A click may arrive on both mouse-down and mouse-up. Keep one target for both.
    if button.preparedAt and GetTime()-button.preparedAt<0.2 then return end
    local row = self:Pick(class, salvation)
    -- The class field is also a manual cast button. Keep a usable binding even when
    -- every member is already buffed or the aura/range state is currently unknown.
    if not row and class then row=self:Pick(class,salvation,true) end
    local id = salvation and 4 or row and self:Assignment(row)
    local greater = not row or not self:Profile(self.player).players[row.name]
    if salvation then
        for _, member in ipairs(self.roster) do
            if row and member.class == row.class and member.tank then greater=false end
        end
    end
    self:Configure(button,row,id,greater)
    button.preparedAt=GetTime()
end

function M:Leader(name)
    local row = self.byName[name]
    return row and (Read(UnitIsGroupLeader,false,row.unit) or Read(UnitIsGroupAssistant,false,row.unit))
end

function M:CanControl(owner, sender)
    sender = sender or self.player
    return sender == owner or self:Leader(sender) or
        (owner == self.player and self.settings.freeassign) or self.freeassign[owner]
end

function M:Send(message)
    if not self.settings.sync or not FT:IsEnabled("paladin") or not C_ChatInfo or not C_ChatInfo.SendAddonMessage then return end
    if Read(GetNumGroupMembers,0)==0 or #message>250 then return end
    if #self.outbox < 200 then self.outbox[#self.outbox+1] = message end
end

function M:Broadcast()
    local p = self:Profile(self.player)
    local skills, assignments, auras = "", "", ""
    for i=1,6 do skills=skills..(i~=4 and self.spells[i] and "10" or "nn") end
    for i=1,9 do assignments=assignments..(p.classes[i] or 0) end
    self:Send("SELF "..skills.."@"..assignments)
    for index in ipairs(D.auras) do auras=auras..(self:AuraSpell(index) and "10" or "nn") end
    self:Send("ASELF "..auras.."@"..(p.aura or 0))
    self:Send(self.settings.freeassign and "FREEASSIGN YES" or "FREEASSIGN NO")
    self:Send(self.settings.salvation and "SALV YES" or "SALV NO")
    for name,id in pairs(p.players) do
        local row=self.byName[name]
        if row then self:Send(("NASSIGN %s %d %s %d"):format(Wire(self.player),row.class,Wire(name),id)) end
    end
end

function M:Receive(prefix, message, channel, sender)
    if prefix~="PLPWR" or not self.settings.sync or not FT:IsEnabled("paladin") or type(message)~="string" or #message>255 then return end
    if channel~="PARTY" and channel~="RAID" and channel~="INSTANCE_CHAT" and channel~="WHISPER" then return end
    -- Resolve only current roster names, including Forever surnames and realm suffixes.
    if not self.byName[sender] then
        local short = sender and sender:match("^([^-]+)")
        if short and self.byName[short] then sender=short else return end
    end
    if sender==self.player then return end
    if message=="REQ" then
        if not self.lastReply or GetTime()-self.lastReply>2 then self.lastReply=GetTime(); self:Broadcast() end
        return
    end
    local numbers, assignments=message:match("^SELF ([0-9a-fn]+)@([0-8n]+)$")
    if numbers and #numbers==12 and #assignments==9 and self.byName[sender].class==5 then
        local available={}
        for i=1,6 do if tonumber(numbers:sub(i*2-1,i*2-1),16) then available[i]=true end end
        self.capabilities[sender]=available
        local p=self:Profile(sender)
        for i=1,9 do p.classes[i]=tonumber(assignments:sub(i,i)) or 0 end
    end
    local owner, class, id=message:match("^ASSIGN (.+) (%d+) (%d+)$")
    class, id=tonumber(class),ValidBlessing(id)
    if owner and self.byName[owner] and self.byName[owner].class==5 and class and class>=1 and class<=9
        and id and self:CanControl(owner,sender) then self:Profile(owner).classes[class]=id end
    local bulkOwner, bulk=message:match("^PASSIGN (.+)@([0-8n]+)$")
    if bulkOwner and #bulk==9 and self.byName[bulkOwner] and self:CanControl(bulkOwner,sender) then
        for i=1,9 do self:Profile(bulkOwner).classes[i]=tonumber(bulk:sub(i,i)) or 0 end
    end
    local massOwner,massID=message:match("^MASSIGN (.+) (%d+)$")
    massID=ValidBlessing(massID)
    if massOwner and massID and self.byName[massOwner] and self:CanControl(massOwner,sender) then
        for i=1,9 do self:Profile(massOwner).classes[i]=massID end
    end
    if message=="CLEAR" or message=="CLEAR SKIP" then
        for _,ownerName in ipairs(self.paladins) do
            if self:CanControl(ownerName,sender) then
                local p=self:Profile(ownerName); p.classes={}; p.players={}
                if message=="CLEAR" then p.aura=0 end
            end
        end
    end
    if message:sub(1,8)=="NASSIGN " then
        for entry in message:sub(9):gmatch("[^@]+") do
            local who, c, target, value=entry:match("^(%S+) (%d+) (%S+) (%d+)$")
            if who then
                who,target,value=Unwire(who),Unwire(target),ValidBlessing(value)
                local row=self.byName[target]
                if value and self.byName[who] and row and row.class==tonumber(c) and self:CanControl(who,sender) then
                    self:Profile(who).players[target]=value~=0 and value or nil
                end
            end
        end
    end
    local auraOwner,aura=message:match("^AASSIGN (.+) (%d+)$")
    aura=tonumber(aura)
    if auraOwner and aura and aura<=#D.auras and self.byName[auraOwner] and self:CanControl(auraOwner,sender) then
        self:Profile(auraOwner).aura=aura
    end
    local auraSkills,auraValue=message:match("^ASELF ([0-9a-fn]+)@(%d+)$")
    if auraSkills and #auraSkills==16 and tonumber(auraValue)<=8 and self.byName[sender].class==5 then
        self:Profile(sender).aura=tonumber(auraValue)
        local available={}
        for i=1,8 do if tonumber(auraSkills:sub(i*2-1,i*2-1),16) then available[i]=true end end
        self.auraCapabilities[sender]=available
    end
    if message=="FREEASSIGN YES" then self.freeassign[sender]=true
    elseif message=="FREEASSIGN NO" then self.freeassign[sender]=nil end
    if message=="SALV YES" then self.remoteSalvation[sender]=true
    elseif message=="SALV NO" then self.remoteSalvation[sender]=false end
    self.dirty=true
end

function M:Cycle(class, target, backwards)
    if Combat() or not self:CanControl(self.selected) then return end
    local p=self:Profile(self.selected)
    local available=self.capabilities[self.selected] or {}
    local current=target and (p.players[target] or 0) or (p.classes[class] or 0)
    local nextID=current
    for i=1,9 do
        nextID=(nextID+(backwards and -1 or 1))%9
        if nextID==0 or (nextID~=4 and available[nextID]) then break end
    end
    if target then
        p.players[target]=nextID~=0 and nextID or nil
        self:Send(("NASSIGN %s %d %s %d"):format(Wire(self.selected),class,Wire(target),nextID))
    else
        p.classes[class]=nextID
        self:Send(("ASSIGN %s %d %d"):format(self.selected,class,nextID))
    end
    self:Refresh()
end

function M:AutoAssign()
    if Combat() then return end
    local owners={}
    for _,name in ipairs(self.paladins) do if self:CanControl(name) then owners[#owners+1]=name end end
    for class=1,9 do
        local used={}
        for _,name in ipairs(self.paladins) do
            if not self:CanControl(name) then used[self:Profile(name).classes[class] or 0]=true end
        end
        for _,name in ipairs(owners) do
            local available=self.capabilities[name] or {}
            local pick=0
            for _,id in ipairs(D.preferences[class]) do if available[id] and not used[id] then pick=id; break end end
            self:Profile(name).classes[class]=pick; used[pick]=true
            self:Send(("ASSIGN %s %d %d"):format(name,class,pick))
        end
    end
    self:Refresh()
end

function M:Preset(save)
    if Combat() then return end
    if save then self.db.preset=Copy(self:Profile(self.player)); FT:Print("Paladin-Voreinstellung gespeichert.")
    elseif type(self.db.preset)=="table" then
        local old=self:Profile(self.player).players
        self.db.paladins[self.player]=Copy(self.db.preset)
        for name in pairs(old) do
            local row=self.byName[name]
            if row and not self:Profile(self.player).players[name] then
                self:Send(("NASSIGN %s %d %s 0"):format(Wire(self.player),row.class,Wire(name)))
            end
        end
        self:Broadcast(); self:Refresh()
    else FT:Print("Noch keine Paladin-Voreinstellung gespeichert.") end
end

function M:CycleSelf(key, ids, backwards)
    if Combat() then return end
    local p=self:Profile(self.player)
    local index=p[key] or 0
    for i=1,#ids+1 do
        index=(index+(backwards and -1 or 1))%(#ids+1)
        if index==0 or (key=="aura" and self:AuraSpell(index)) or (key~="aura" and Known(ids[index])) then break end
    end
    p[key]=index
    if key=="aura" then self:Send("AASSIGN "..self.player.." "..index) end
    self:Refresh()
end

function M:CycleAssignedAura(backwards)
    if Combat() or not self:CanControl(self.selected) then return end
    if self.selected==self.player then self:CycleSelf("aura",D.auras,backwards); return end
    local p=self:Profile(self.selected)
    local available=self.auraCapabilities[self.selected] or {}
    local index=p.aura or 0
    for i=1,9 do
        index=(index+(backwards and -1 or 1))%9
        if index==0 or available[index] then break end
    end
    p.aura=index
    self:Send("AASSIGN "..self.selected.." "..index)
    self:Refresh()
end

local function Label(parent,text,x,y,width)
    local label=parent:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
    label:SetPoint("TOPLEFT",x,y); label:SetWidth(width or 730); label:SetJustifyH("LEFT"); label:SetText(text)
    return label
end
local function Button(parent,text,x,y,width,callback,secure)
    local button=CreateFrame("Button",nil,parent,secure and "SecureActionButtonTemplate,UIPanelButtonTemplate" or "UIPanelButtonTemplate")
    button:SetSize(width or 90,24); button:SetPoint("TOPLEFT",x,y); button:SetText(text)
    if secure then button:RegisterForClicks("AnyUp","AnyDown") else button:SetScript("OnClick",callback) end
    return button
end

local function SpellIcon(id, fallback)
    if id and C_Spell and C_Spell.GetSpellInfo then
        local info=Read(C_Spell.GetSpellInfo,nil,id)
        if info then return Read(function() return info.iconID end,fallback) or fallback end
    end
    return fallback
end

function M:CreateBar()
    if self.bar or Combat() then return end
    local frame=CreateFrame("Frame","ForeverToolsPaladinBar",UIParent)
    frame:SetSize(100,136)
    local position=self.db.barPosition
    if type(position)=="table" and type(position.x)=="number" and type(position.y)=="number"
        and position.point and position.relativePoint then
        frame:SetPoint(position.point,UIParent,position.relativePoint,position.x,position.y)
    else frame:SetPoint("LEFT",UIParent,"LEFT",20,0) end
    frame:SetClampedToScreen(true); frame:SetMovable(true)
    frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
    local function StartDrag() if not Combat() then frame:StartMoving() end end
    local function StopDrag()
        if Combat() then return end
        frame:StopMovingOrSizing()
        local point,_,relativePoint,x,y=frame:GetPoint()
        self.db.barPosition={point=point,relativePoint=relativePoint,x=x,y=y}
    end
    frame:SetScript("OnDragStart",StartDrag)
    frame:SetScript("OnDragStop",StopDrag)
    Label(frame,"Paladin",22,-2,60)
    local bar={frame=frame,classes={}}
    self.bar=bar
    bar.move=CreateFrame("Button",nil,frame,"UIPanelButtonTemplate")
    bar.move:SetSize(18,16); bar.move:SetPoint("TOPLEFT",0,0); bar.move:SetText("↔")
    bar.move:RegisterForDrag("LeftButton")
    bar.move:SetScript("OnDragStart",StartDrag)
    bar.move:SetScript("OnDragStop",StopDrag)
    bar.move:SetScript("OnEnter",function(button)
        GameTooltip:SetOwner(button,"ANCHOR_RIGHT")
        GameTooltip:AddLine("Paladin-Leiste verschieben")
        GameTooltip:AddLine("Linke Maustaste halten und ziehen (außerhalb des Kampfes).",1,1,1)
        GameTooltip:Show()
    end)
    bar.move:SetScript("OnLeave",function() GameTooltip:Hide() end)
    local function Icon(icon,x,y,title,secure,parent)
        local b=CreateFrame("Button",nil,parent or frame,secure and
            "SecureHandlerEnterLeaveTemplate,SecureActionButtonTemplate" or nil)
        b:SetSize(100,28); b:SetPoint("TOPLEFT",x,y)
        if secure then b:RegisterForClicks("AnyUp","AnyDown") end
        b.background=b:CreateTexture(nil,"BACKGROUND")
        b.background:SetAllPoints(b); b.background:SetColorTexture(0.12,0.12,0.12,0.85)
        b.classIcon=b:CreateTexture(nil,"ARTWORK")
        b.classIcon:SetSize(22,22); b.classIcon:SetPoint("TOPLEFT",3,-3); b.classIcon:SetTexture(icon)
        b.buffIcon=b:CreateTexture(nil,"ARTWORK")
        b.buffIcon:SetSize(22,22); b.buffIcon:SetPoint("TOPLEFT",27,-3)
        b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        b.title=title; b.defaultIcon=icon
        b.count=Label(b,"",51,-12,12)
        b.time=Label(b,"",63,-3,37)
        b.time2=Label(b,"",63,-15,37)
        local function Tooltip(button)
            if button.popup and (button:GetAttribute("memberCount") or 0)>0 then
                GameTooltip:Hide(); return
            end
            GameTooltip:SetOwner(button,"ANCHOR_RIGHT")
            GameTooltip:AddLine(button.title)
            if button.auraName then GameTooltip:AddLine(button.auraName,1,1,1) end
            if button.sealName then GameTooltip:AddLine(button.sealName,1,1,1) end
            if button.castRow then GameTooltip:AddLine("Ziel: "..button.castRow.name,1,1,1) end
            GameTooltip:AddLine(button.hint or (secure and "Links: großer Segen, rechts: normal" or "Zuweisungen öffnen"),0.8,0.8,0.8)
            GameTooltip:Show()
        end
        -- Preserve the inherited secure hover handler that opens the player flyout.
        if secure then
            b:HookScript("OnEnter",Tooltip)
            b:HookScript("OnLeave",function() GameTooltip:Hide() end)
        else
            b:SetScript("OnEnter",Tooltip)
            b:SetScript("OnLeave",function() GameTooltip:Hide() end)
        end
        if secure then
            b:SetScript("PostClick",function(button)
                if button.castRow and button.castID then
                    self.castStamps[button.castRow.name..":"..button.castID]=GetTime()
                end
            end)
        end
        return b
    end
    bar.makeButton=Icon
    for i,token in ipairs(D.classes) do
        local class=i
        local suffix=token:sub(1,1)..token:sub(2):lower()
        bar.classes[i]=Icon("Interface\\Icons\\ClassIcon_"..suffix,0,-(i-1)*29-109,D.labels[i],true)
        bar.classes[i]:SetScript("PreClick",function(b) self:PrepareSmart(b,class,false) end)
        bar.classes[i]:EnableMouseWheel(true)
        bar.classes[i]:SetScript("OnMouseWheel",function(_,delta)
            local previous=self.selected; self.selected=self.player
            self:Cycle(class,nil,delta>0); self.selected=previous; self:Refresh()
        end)
        local popup=CreateFrame("Frame",nil,bar.classes[i],
            "SecureHandlerStateTemplate,SecureHandlerShowHideTemplate,SecureHandlerEnterLeaveTemplate")
        popup:SetPoint("TOPLEFT",bar.classes[i],"TOPRIGHT",2,0)
        popup:SetSize(148,1); popup:SetFrameStrata("DIALOG"); popup:SetClampedToScreen(true); popup:Hide()
        bar.classes[i].popup=popup; bar.classes[i].players={}
        bar.classes[i]:SetFrameRef("popup",popup)
        bar.classes[i]:SetAttribute("_onenter",[[
            for i=1,9 do
                local other=self:GetFrameRef("other"..i)
                if other then other:Hide() end
            end
            if self:GetAttribute("memberCount") > 0 then
                local popup=self:GetFrameRef("popup")
                popup:Show()
                popup:RegisterAutoHide(0.6)
                popup:AddToAutoHide(self)
                for i=1,self:GetAttribute("memberCount") do
                    popup:AddToAutoHide(self:GetFrameRef("member"..i))
                end
            end
        ]])
    end
    for i,b in ipairs(bar.classes) do
        for j,other in ipairs(bar.classes) do if i~=j then b:SetFrameRef("other"..j,other.popup) end end
    end
    bar.smart=Icon("Interface\\Icons\\Spell_Holy_GreaterBlessingofKings",0,-20,"Nächster Buff",true)
    bar.smart:SetScript("PreClick",function(b) self:PrepareSmart(b,nil,false) end)
    bar.aura=Icon("Interface\\Icons\\Spell_Holy_DevotionAura",0,-78,"Aura (Mausrad: auswählen)",true)
    bar.fury=Icon("Interface\\Icons\\Spell_Holy_SealOfFury",0,-20,"Zorn der Gerechtigkeit",true)
    bar.seal=Icon("Interface\\Icons\\Spell_Holy_SealOfWisdom",0,-49,"Siegel (Mausrad: auswählen)",true)
    bar.aura.hint="Klick: Aura wirken · Mausrad: Aura auswählen"
    bar.fury.hint="Klick: Zorn der Gerechtigkeit wirken"
    bar.seal.hint="Klick: Siegel wirken · Mausrad: Siegel auswählen"
    bar.salvation=Icon("Interface\\Icons\\Spell_Holy_SealOfSalvation",0,-109,"Rettung",true)
    bar.salvation:SetScript("PreClick",function(b) self:PrepareSmart(b,nil,true) end)
    for _,entry in ipairs({{bar.aura,"aura",D.auras},{bar.seal,"seal",D.seals}}) do
        local b,key,ids=unpack(entry)
        b:EnableMouseWheel(true)
        b:SetScript("OnMouseWheel",function(_,delta) self:CycleSelf(key,ids,delta<0) end)
    end
    bar.settings=CreateFrame("Button",nil,frame)
    bar.settings:SetSize(16,16); bar.settings:SetPoint("TOPRIGHT",0,0)
    bar.settings:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
    bar.settings:SetScript("OnClick",function() self:ToggleWindow() end)
end

function M:RefreshBar()
    local bar=self.bar
    if not bar then return end
    bar.frame:SetShown(FT:IsEnabled("paladin") and true or false)
    local y=109
    if self.settings.salvation then y=y+29 end
    for i,b in ipairs(bar.classes) do
        b.preparedAt=nil; self:PrepareSmart(b,i,false)
        local members={}
        for _,row in ipairs(self.roster) do if row.class==i then members[#members+1]=row end end
        b:SetAttribute("memberCount",#members)
        b:ClearAllPoints(); b:SetPoint("TOPLEFT",0,-y); b:SetShown(#members>0)
        b.popup:Hide()
        if #members>0 then y=y+29 end
        local id=self:Profile(self.player).classes[i]
        local entry=D.blessings[id]
        b.buffIcon:SetTexture(entry and SpellIcon(entry.normal[#entry.normal],"Interface\\Icons\\INV_Misc_QuestionMark") or nil)
        for index,row in ipairs(members) do
            local p=b.players[index]
            if not p then
                p=bar.makeButton(b.defaultIcon,math.floor((index-1)/15)*150,-((index-1)%15)*29,row.name,true,b.popup)
                p:SetSize(148,28); p.classIcon:SetSize(16,16)
                p.buffIcon:SetTexture(nil)
                p.name=Label(p,"",22,-13,122)
                p.flags=Label(p,"",107,-2,40)
                p.time:ClearAllPoints(); p.time:SetPoint("TOPLEFT",23,-1)
                p:EnableMouseWheel(true)
                p:SetScript("OnMouseWheel",function(button,delta)
                    if not button.member then return end
                    local previous=self.selected; self.selected=self.player
                    self:Cycle(button.member.class,button.member.name,delta>0); self.selected=previous; self:Refresh()
                end)
                b.players[index]=p; b:SetFrameRef("member"..index,p)
            end
            p.member=row; p.title=row.name
            p.name:SetText(row.name:match("^%S+") or row.name)
            local assignment=self:Assignment(row)
            local spellEntry=D.blessings[assignment]
            p.classIcon:SetTexture(spellEntry and SpellIcon(spellEntry.normal[#spellEntry.normal],b.defaultIcon) or b.defaultIcon)
            self:Configure(p,row,assignment,not self:Profile(self.player).players[row.name])
            p:SetShown(true)
        end
        for index=#members+1,#b.players do
            local p=b.players[index]; p.member=nil; self:Configure(p,nil,nil); p:Hide()
        end
        b.popup:SetSize(148+math.max(0,math.ceil(#members/15)-1)*150,math.max(1,math.min(15,#members)*29))
    end
    bar.frame:SetSize(100,y+2)
    bar.smart.preparedAt=nil; self:PrepareSmart(bar.smart,nil,false)
    -- The class field already displays the active blessing; do not repeat it in a summary row.
    bar.smart:Hide()
    bar.salvation.preparedAt=nil; self:PrepareSmart(bar.salvation,nil,true)
    bar.salvation:SetShown(self.settings.salvation)
    local own=self:Profile(self.player)
    for _,entry in ipairs({{bar.aura,self:AuraSpell(own.aura)},{bar.fury,D.fury},{bar.seal,D.seals[own.seal]}}) do
        local b,id=unpack(entry)
        local name=id and (b==bar.aura or Known(id)) and Spell(id)
        for _,mouse in ipairs({"1","2"}) do
            b:SetAttribute("type"..mouse,name and "spell" or nil)
            b:SetAttribute("spell"..mouse,name)
        end
        b:SetAttribute("unit","player"); b.auraName=name
        b.classIcon:SetTexture(SpellIcon(id,b.defaultIcon))
    end
end

function M:CycleGrid(owner,class,backwards)
    if Combat() then return end
    local previous=self.selected; self.selected=owner
    if class then self:Cycle(class,nil,backwards) else self:CycleAssignedAura(backwards) end
    self.selected=previous; self:Refresh()
end

function M:ClearGridAssignments()
    if Combat() then return end
    for _,owner in ipairs(self.paladins) do
        if self:CanControl(owner) then
            local p=self:Profile(owner)
            for name in pairs(p.players) do
                local row=self.byName[name]
                if row then self:Send(("NASSIGN %s %d %s 0"):format(Wire(owner),row.class,Wire(name))) end
            end
            p.classes={}; p.players={}; p.aura=0
            self:Send("MASSIGN "..owner.." 0"); self:Send("AASSIGN "..owner.." 0")
        end
    end
    self:Refresh()
end

function M:CreateAssignmentGrid()
    local panel=CreateFrame("Frame","ForeverToolsPaladin",UIParent,"BackdropTemplate")
    panel:SetSize(912,205); panel:SetPoint("CENTER"); panel:SetClampedToScreen(true)
    panel:SetMovable(true); panel:EnableMouse(true); panel:RegisterForDrag("LeftButton")
    panel:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=12,
        insets={left=3,right=3,top=3,bottom=3}})
    panel:SetBackdropColor(0,0,0,0.9); panel:SetBackdropBorderColor(0.45,0.45,0.35,1)
    panel:SetScript("OnDragStart",function() if not Combat() then panel:StartMoving() end end)
    panel:SetScript("OnDragStop",panel.StopMovingOrSizing)
    Label(panel,"|cffffd200ForeverTools – Paladin-Zuweisungen|r",342,-7,500)
    local close=CreateFrame("Button",nil,panel,"UIPanelCloseButton")
    close:SetSize(22,22); close:SetPoint("TOPRIGHT",3,3)
    close:SetScript("OnClick",function() self:ToggleWindow() end)
    self.window=panel
    self.gridHeaders={}; self.gridRows={}; self.gridOffset=0
    local function Texture(parent,path,x,y,w,h)
        local t=parent:CreateTexture(nil,"ARTWORK"); t:SetTexture(path)
        t:SetSize(w,h); t:SetPoint("TOPLEFT",x,y); return t
    end
    local function Line(parent,x,y,w,h)
        local t=parent:CreateTexture(nil,"BORDER")
        t:SetColorTexture(0.55,0.55,0.55,0.8); t:SetSize(w,h); t:SetPoint("TOPLEFT",x,y)
        return t
    end
    self.gridMakeLine=Line
    for column=0,9 do
        local path="Interface\\Icons\\Spell_Holy_DevotionAura"
        if column>0 then
            local token=D.classes[column]
            path="Interface\\Icons\\ClassIcon_"..token:sub(1,1)..token:sub(2):lower()
        end
        Texture(panel,path,138+column*76+24,-31,28,28)
        self.gridHeaders[column]=Label(panel,"",140+column*76,-65,72)
        Line(panel,138+column*76,-20,1,60)
    end
    Line(panel,6,-79,900,1)
    local scroll=CreateFrame("ScrollFrame",nil,panel)
    scroll:SetPoint("TOPLEFT",6,-80); scroll:SetSize(900,90)
    local content=CreateFrame("Frame",nil,scroll); content:SetSize(900,90)
    scroll:SetScrollChild(content); scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel",function(_,delta)
        self.gridOffset=math.max(0,math.min(math.max(0,#self.paladins*90-450),self.gridOffset-delta*45))
        scroll:SetVerticalScroll(self.gridOffset)
    end)
    self.gridScroll,self.gridContent=scroll,content
    self.gridFree=CreateFrame("CheckButton",nil,panel,"UICheckButtonTemplate")
    self.gridFree:SetSize(22,22); self.gridFree:SetPoint("BOTTOMLEFT",5,5)
    self.gridFree.Text:SetText("Freie Zuweisung")
    self.gridFree:SetScript("OnClick",function(button)
        self.settings.freeassign=button:GetChecked() and true or false
        self:OnSettingsChanged()
    end)
    local function Footer(text,x,width,fn)
        local b=Button(panel,text,0,0,width,fn)
        b:ClearAllPoints(); b:SetPoint("BOTTOMLEFT",x,7); b:SetSize(width,20)
        return b
    end
    self.gridOptions=Footer("Optionen",526,86,function()
        if Combat() then return end
        self.db.detailsOpen=not self.db.detailsOpen; self:Refresh()
    end)
    Footer("Auto-Zuweisung",618,94,function() self:AutoAssign() end)
    Footer("Löschen",718,86,function() self:ClearGridAssignments() end)
    Footer("Aktualisieren",810,94,function() self:Send("REQ"); self:Broadcast(); self:Refresh() end)
end

function M:RefreshAssignmentGrid()
    local visibleRows=math.max(1,math.min(5,#self.paladins))
    self.window:SetSize(912,115+visibleRows*90)
    self.gridScroll:SetSize(900,visibleRows*90)
    self.gridContent:SetHeight(math.max(90,#self.paladins*90))
    self.gridOffset=math.min(self.gridOffset,math.max(0,(#self.paladins-visibleRows)*90))
    self.gridScroll:SetVerticalScroll(self.gridOffset)
    self.gridFree:SetChecked(self.settings.freeassign)
    for class=1,9 do
        local names={}
        for _,member in ipairs(self.roster) do
            if member.class==class then names[#names+1]=member.name:match("^%S+") or member.name end
        end
        local text=names[1] or ""
        if #names>1 then text=text.." +"..(#names-1) end
        self.gridHeaders[class]:SetText(text)
    end
    for index,owner in ipairs(self.paladins) do
        local row=self.gridRows[index]
        if not row then
            row={cells={}}
            row.frame=CreateFrame("Frame",nil,self.gridContent)
            row.frame:SetSize(900,90); row.frame:SetPoint("TOPLEFT",0,-(index-1)*90)
            row.name=Label(row.frame,"",2,-4,118)
            row.count=Label(row.frame,"",116,-4,16)
            row.skills=Label(row.frame,"",2,-20,132)
            row.skills2=Label(row.frame,"",2,-54,132)
            row.ready=Label(row.frame,"",2,-72,130)
            row.salvation=CreateFrame("CheckButton",nil,row.frame,"UICheckButtonTemplate")
            row.salvation:SetSize(18,18); row.salvation:SetPoint("TOPLEFT",1,-36)
            row.salvation.Text:SetText("Rettung")
            row.salvation:SetScript("OnClick",function(button)
                if row.owner~=self.player or Combat() then self:Refresh(); return end
                self.settings.salvation=button:GetChecked() and true or false
                self:OnSettingsChanged()
            end)
            for column=0,9 do
                local class=column>0 and column or nil
                local cell=CreateFrame("Button",nil,row.frame)
                cell:SetSize(32,32); cell:SetPoint("TOPLEFT",132+column*76+22,-29)
                cell:RegisterForClicks("LeftButtonUp","RightButtonUp"); cell:EnableMouseWheel(true)
                cell:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
                cell:SetScript("OnClick",function(_,mouse) self:CycleGrid(row.owner,class,mouse=="RightButton") end)
                cell:SetScript("OnMouseWheel",function(_,delta) self:CycleGrid(row.owner,class,delta>0) end)
                cell:SetScript("OnEnter",function(button)
                    GameTooltip:SetOwner(button,"ANCHOR_RIGHT")
                    GameTooltip:AddLine(row.owner.." – "..(class and D.labels[class] or "Aura"))
                    GameTooltip:AddLine(button.assignmentName or "Keine Zuweisung",1,1,1)
                    GameTooltip:AddLine("Klick/Mausrad: Zuweisung wechseln",0.8,0.8,0.8); GameTooltip:Show()
                end)
                cell:SetScript("OnLeave",function() GameTooltip:Hide() end)
                row.cells[column]=cell
                self.gridMakeLine(row.frame,132+column*76,0,1,90)
            end
            self.gridMakeLine(row.frame,0,-89,900,1)
            self.gridRows[index]=row
        end
        row.owner=owner; row.frame:Show()
        row.name:SetText(owner)
        local count=(C_Item and C_Item.GetItemCount) or GetItemCount
        row.count:SetText(owner==self.player and tostring(Read(count,0,21177)) or "")
        row.salvation:SetEnabled(owner==self.player)
        row.salvation:SetChecked((owner==self.player and self.settings.salvation) or
            (owner~=self.player and self.remoteSalvation[owner]) or false)
        local skillText={}
        for id=1,6 do
            if (self.capabilities[owner] or {})[id] then
                local ranks=D.blessings[id].normal
                local icon=SpellIcon(ranks[#ranks],"Interface\\Icons\\INV_Misc_QuestionMark")
                skillText[#skillText+1]="|T"..icon..":12|t |cffffd200✓|r"
            end
        end
        row.skills:SetText(table.concat(skillText," ",1,math.min(3,#skillText)))
        row.skills2:SetText(#skillText>3 and table.concat(skillText," ",4) or "")
        local member=self.byName[owner]
        local online=member and Read(UnitIsConnected,false,member.unit)
        row.ready:SetText(not online and "|cffaaaaaaOffline|r" or
            self.capabilities[owner] and "|cff55ee88Bereit|r" or "|cffaaaaaaKeine Daten|r")
        local profile=self:Profile(owner)
        for column=0,9 do
            local cell=row.cells[column]
            local id=column==0 and profile.aura or profile.classes[column]
            local entry=column>0 and D.blessings[id]
            local spellID=column==0 and (owner==self.player and self:AuraSpell(id) or D.auras[id]) or
                (entry and entry.normal[#entry.normal])
            cell:SetNormalTexture(SpellIcon(spellID,"Interface\\Buttons\\UI-GroupLoot-Pass-Up"))
            cell.assignmentName=column==0 and Spell(spellID) or entry and entry.label
            cell:SetEnabled(self:CanControl(owner) and true or false)
        end
    end
    for i=#self.paladins+1,#self.gridRows do self.gridRows[i].frame:Hide() end
end

function M:CreateWindow()
    if Combat() then return end
    local panel=CreateFrame("Frame","ForeverToolsPaladinDetails",UIParent,"BasicFrameTemplateWithInset")
    panel:SetSize(790,660); panel:SetPoint("CENTER"); panel:SetClampedToScreen(true)
    panel:SetMovable(true); panel:EnableMouse(true); panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart",function() if not Combat() then panel:StartMoving() end end)
    panel:SetScript("OnDragStop",panel.StopMovingOrSizing)
    -- The parent contains protected buttons: its close button and Escape must also defer in combat.
    panel.CloseButton:SetScript("OnClick",function() self.db.detailsOpen=false; self:Refresh() end)
    panel.TitleText:SetText("ForeverTools – Paladin-Segen")
    self.detailWindow=panel
    self.ownerButton=Button(panel,"",16,-34,300,function()
        if Combat() then return end
        local index=1
        for i,name in ipairs(self.paladins) do if name==self.selected then index=i%#self.paladins+1; break end end
        self.selected=self.paladins[index]; self:Refresh()
    end)
    Button(panel,"Auto-Zuweisung",326,-34,140,function() self:AutoAssign() end)
    Button(panel,"Speichern",476,-34,90,function() self:Preset(true) end)
    Button(panel,"Laden",576,-34,70,function() self:Preset(false) end)
    Button(panel,"Abgleichen",656,-34,115,function() self:Send("REQ"); self:Broadcast() end)
    self.classButtons,self.classCasts={},{}
    for i=1,9 do
        local class=i
        Label(panel,D.labels[i],16+(i-1)*84,-68,82)
        self.classButtons[i]=Button(panel,"",16+(i-1)*84,-85,82,function(_,mouse) self:Cycle(class,nil,mouse=="RightButton") end)
        self.classButtons[i]:RegisterForClicks("LeftButtonUp","RightButtonUp")
        local cast=Button(panel,"Buff",16+(i-1)*84,-112,82,nil,true)
        cast:SetScript("PreClick",function(b) self:PrepareSmart(b,class,false) end)
        self.classCasts[i]=cast
    end
    Label(panel,"Zuweisung: oben klicken, Spieler-Ausnahme per Mausrad. Buffs wirken immer deine eigenen Zuweisungen.",16,-144)
    Label(panel,"Buffklick: links großer Segen (sonst normal), rechts normal. Im Kampf bleiben vorbereitete Ziele fest.",16,-161)
    local scroll=CreateFrame("ScrollFrame",nil,panel,"UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT",16,-184); scroll:SetPoint("BOTTOMRIGHT",-35,104)
    local content=CreateFrame("Frame",nil,scroll); content:SetSize(730,40*29); scroll:SetScrollChild(content)
    self.rows={}
    for i=1,40 do
        local row={}
        row.label=Label(content,"",0,-(i-1)*29-5,245)
        row.buff=Button(content,"",250,-(i-1)*29,285,nil,true)
        row.buff:EnableMouseWheel(true)
        row.buff:SetScript("OnMouseWheel",function(_,delta)
            if row.member then self:Cycle(row.member.class,row.member.name,delta<0) end
        end)
        row.salv=Button(content,"Rettung",545,-(i-1)*29,100,nil,true)
        row.timer=Label(content,"",652,-(i-1)*29-5,65)
        self.rows[i]=row
    end
    self.content=content
    self.smart=Button(panel,"Nächster Buff",16,-570,165,nil,true)
    self.smart:SetScript("PreClick",function(b) self:PrepareSmart(b,nil,false) end)
    self.auraButton=Button(panel,"Aura",191,-570,180,nil,true)
    self.sealButton=Button(panel,"Siegel",381,-570,180,nil,true)
    self.furyButton=Button(panel,"Zorn",571,-570,200,nil,true)
    for _,entry in ipairs({{self.auraButton,"aura",D.auras},{self.sealButton,"seal",D.seals}}) do
        local button,key,ids=unpack(entry)
        button:EnableMouseWheel(true)
        button:SetScript("OnMouseWheel",function(_,delta) self:CycleSelf(key,ids,delta<0) end)
    end
    self.assignedAura=Button(panel,"Aura-Zuweisung",16,-600,300,function(_,mouse)
        self:CycleAssignedAura(mouse=="RightButton")
    end)
    self.assignedAura:RegisterForClicks("LeftButtonUp","RightButtonUp")
    Label(panel,"Aura/Siegel: Mausrad wählt.",326,-605,235)
    self.salvationButton=Button(panel,"Rettung: nächster Spieler",571,-600,200,nil,true)
    self.salvationButton:SetScript("PreClick",function(b) self:PrepareSmart(b,nil,true) end)
    self.status=Label(panel,"",16,-625)
    local function Track(button)
        button:SetScript("PostClick",function(b)
            if b.castRow and b.castID then self.castStamps[b.castRow.name..":"..b.castID]=GetTime() end
        end)
    end
    Track(self.smart)
    Track(self.salvationButton)
    for _,button in ipairs(self.classCasts) do Track(button) end
    for _,row in ipairs(self.rows) do Track(row.buff); Track(row.salv) end
    self:CreateAssignmentGrid()
end

function M:Refresh()
    if Combat() then self.dirty=true; return end
    self.dirty=false
    self:Roster()
    if FT:IsEnabled("paladin") then self:CreateBar() end
    self:RefreshBar()
    if not self.window then self:UpdateTimers(); return end
    local visible=FT:IsEnabled("paladin") and self.db.open and
        (self.settings.showSolo or Read(GetNumGroupMembers,0)>0)
    self.window:SetShown(visible and true or false)
    self.detailWindow:SetShown(visible and self.db.detailsOpen and true or false)
    self:RefreshAssignmentGrid()
    self.ownerButton:SetText("Zuweisungen: "..self.selected.."  ›")
    local p=self:Profile(self.selected)
    for i,button in ipairs(self.classButtons) do
        button:SetText(D.blessings[p.classes[i]] and D.blessings[p.classes[i]].label or "–")
        button:SetEnabled(self:CanControl(self.selected))
        self.classCasts[i].preparedAt=nil
        self:PrepareSmart(self.classCasts[i],i,false)
    end
    for i,row in ipairs(self.rows) do
        local member=self.roster[i]
        row.member=member
        row.buff:SetShown(member~=nil); row.salv:SetShown(member~=nil and self.settings.salvation)
        row.label:SetText(member and member.name or ""); row.timer:SetText("")
        if member then
            local id=self:Assignment(member)
            local selectedID=p.players[member.name]
            row.buff:SetText((D.blessings[id] and D.blessings[id].label or "Kein Segen")..
                (selectedID and (" | Ausnahme: "..D.blessings[selectedID].label) or ""))
            self:Configure(row.buff,member,id,not self:Profile(self.player).players[member.name])
            self:Configure(row.salv,self.settings.salvation and not member.tank and member or nil,4,false)
        else
            self:Configure(row.buff,nil,nil); self:Configure(row.salv,nil,nil)
        end
    end
    self.content:SetHeight(math.max(1,#self.roster*29))
    self.smart.preparedAt=nil
    self:PrepareSmart(self.smart,nil,false)
    self.salvationButton.preparedAt=nil
    self:PrepareSmart(self.salvationButton,nil,true)
    self.salvationButton:SetShown(self.settings.salvation)
    local own=self:Profile(self.player)
    local assignedID=self.selected==self.player and self:AuraSpell(p.aura) or D.auras[p.aura]
    self.assignedAura:SetText("Aura-Zuweisung: "..(Spell(assignedID) or "aus"))
    self.assignedAura:SetEnabled(self:CanControl(self.selected))
    for _,entry in ipairs({{self.auraButton, self:AuraSpell(own.aura),"Aura"},{self.sealButton,D.seals[own.seal],"Siegel"},
        {self.furyButton,D.fury,"Zorn"}}) do
        local button,id,label=unpack(entry)
        local name=id and (button==self.auraButton or Known(id)) and Spell(id)
        button:SetText(name or label..": aus")
        for _,mouse in ipairs({"1","2"}) do
            button:SetAttribute("type"..mouse,name and "spell" or nil)
            button:SetAttribute("spell"..mouse,name)
        end
        button:SetAttribute("unit","player")
        button.auraName=name
    end
    self.status:SetText("Farben: rot = fehlt, gelb = bald abgelaufen, grün = aktiv, grau/? = unbekannt.")
    self:UpdateTimers()
end

local function Timer(left, refreshThreshold)
    if left==nil then return "|cff999999?|r" end
    if left==math.huge then return "|cff55ee88aktiv|r" end
    if left<=0 then return "|cffff6666fehlt|r" end
    local color=left<(refreshThreshold or 240) and "|cffffd050" or "|cff55ee88"
    return color..math.floor(left/60)..":"..("%02d"):format(math.floor(left%60)).."|r"
end
local function BarTime(left, refreshThreshold)
    if left==nil then return "|cffaaaaaa?|r" end
    if left==math.huge then return "|cff55ee88∞|r" end
    if left<=0 then return "|cffff6666--|r" end
    return Timer(left, refreshThreshold)
end

function M:PaintGroup(button,members,salvation)
    local have,need,special,unknown=0,0,0,false
    local normalTime,specialTime
    for _,row in ipairs(members) do
        local id=salvation and 4 or self:Assignment(row)
        if id>0 and (not salvation or not row.tank) then
            local left=self:BuffRemaining(row,id)
            local override=not salvation and self:Profile(self.player).players[row.name]
            if left==nil then unknown=true
            else
                if left<240 then
                    if override then special=special+1 else need=need+1 end
                else have=have+1 end
                if override then specialTime=math.min(specialTime or math.huge,left)
                else normalTime=math.min(normalTime or math.huge,left) end
            end
        end
    end
    local state="good"
    if have==0 and need+special>0 then state="all"
    elseif need>0 then state="some"
    elseif special>0 then state="special"
    elseif unknown or have==0 then state="unknown" end
    local colors={all={0.8,0,0,0.7},some={0.85,0.8,0.25,0.7},special={0.05,0.2,0.85,0.7},
        good={0,0.55,0,0.7},unknown={0.2,0.2,0.2,0.7}}
    button.state=state
    button.background:SetColorTexture(unpack(colors[state]))
    button.count:SetText(need+special>0 and tostring(need+special) or "")
    local minimum=normalTime
    if specialTime then minimum=math.min(minimum or math.huge,specialTime) end
    button.time:SetText(minimum and BarTime(minimum) or unknown and BarTime(nil) or "")
    button.time2:SetText("")
end

function M:UpdateTimers()
    if self.bar and self.bar.frame:IsShown() then
        for i,b in ipairs(self.bar.classes) do
            local members={}
            for _,row in ipairs(self.roster) do
                if row.class==i then members[#members+1]=row end
            end
            self:PaintGroup(b,members)
            for _,p in ipairs(b.players) do
                local row=p.member
                if row then
                    local id=self:Assignment(row)
                    local left=self:BuffRemaining(row,id)
                    self:PaintGroup(p,{row})
                    p.time:SetText(id>0 and BarTime(left) or "")
                    p.time2:SetText(""); p.count:SetText("")
                    local dead=Read(UnitIsDeadOrGhost,false,row.unit)
                    local online=Read(UnitIsConnected,false,row.unit)
                    local range
                    if C_Spell and C_Spell.IsSpellInRange and self.spells[id] then
                        range=Read(C_Spell.IsSpellInRange,nil,self.spells[id],row.unit)
                    end
                    local flags=row.tank and "|cffaaaaeeT|r" or ""
                    if dead then flags=flags.."|cffff5555D|r"
                    elseif not online then flags=flags.."|cffaaaaaaOFF|r"
                    elseif range==false or range==0 then flags=flags.."|cffffdd55R|r" end
                    p.flags:SetText(flags)
                end
            end
        end
        self:PaintGroup(self.bar.smart,self.roster)
        self:PaintGroup(self.bar.salvation,self.roster,true)
        local player=self.byName[self.player]
        if player then
            for _,b in ipairs({self.bar.aura,self.bar.fury,self.bar.seal}) do
                local left=b.auraName and self:Remaining(player,b.auraName)
                -- Short-lived seals are active until they actually expire.
                local threshold=b==self.bar.seal and 0 or 240
                b.count:SetText("")
                b.time:SetText(b.auraName and BarTime(left,threshold) or "")
                local knownCount,missingCount,hidden=0,0,false
                if b.auraName then
                    knownCount=knownCount+1
                    if left==nil then hidden=true
                    elseif left<=0 or left<threshold then missingCount=missingCount+1 end
                end
                b.time2:SetText("")
                if knownCount==0 or hidden then b.background:SetColorTexture(0.2,0.2,0.2,0.7)
                elseif missingCount==knownCount then b.background:SetColorTexture(0.8,0,0,0.7)
                elseif missingCount>0 then b.background:SetColorTexture(0.85,0.8,0.25,0.7)
                else b.background:SetColorTexture(0,0.55,0,0.7) end
            end
        end
    end
    if not self.detailWindow or not self.detailWindow:IsShown() then return end
    for _,row in ipairs(self.rows) do
        if row.member then row.timer:SetText(Timer(self:BuffRemaining(row.member,self:Assignment(row.member)))) end
    end
    local player=self.byName[self.player]
    if player then
        for _,button in ipairs({self.auraButton,self.sealButton,self.furyButton}) do
            if button.auraName then
                local threshold=button==self.sealButton and 0 or 240
                button:SetText(button.auraName.." "..Timer(self:Remaining(player,button.auraName),threshold))
            end
        end
    end
end

function M:ToggleWindow()
    self.db.open=not self.db.open
    if Combat() then self.dirty=true; FT:Print("Paladin-Fenster wird nach dem Kampf umgeschaltet."); return end
    if not self.window and self.db.open then self:CreateWindow() end
    self:Refresh()
end

function M:OnSettingsChanged()
    if not FT:IsEnabled("paladin") or not self.settings.sync then self.outbox={} end
    if FT:IsEnabled("paladin") and self.settings.sync and self.db then self:Broadcast() end
    if Combat() then self.dirty=true; return end
    self:Refresh()
end

function M:Initialize()
    if self.frame then return end
    ForeverToolsPaladinDB=type(ForeverToolsPaladinDB)=="table" and ForeverToolsPaladinDB or {}
    self.db=ForeverToolsPaladinDB
    -- The editor is opened on demand; only the compact bar returns after login/reload.
    self.db.open=false
    self.db.detailsOpen=false
    self.db.paladins=type(self.db.paladins)=="table" and self.db.paladins or {}
    self.player=Name("player") or "player"
    self.capabilities,self.auraCapabilities,self.freeassign,self.auraCache,self.castStamps,self.outbox={},{},{},{},{},{}
    self.remoteSalvation={}
    self:ScanSpells(); self:Roster()
    local frame=CreateFrame("Frame"); self.frame=frame
    for _,event in ipairs({"PLAYER_LOGIN","PLAYER_ENTERING_WORLD","GROUP_ROSTER_UPDATE","SPELLS_CHANGED",
        "UNIT_AURA","PLAYER_REGEN_ENABLED","CHAT_MSG_ADDON"}) do frame:RegisterEvent(event) end
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then C_ChatInfo.RegisterAddonMessagePrefix("PLPWR") end
    frame:SetScript("OnEvent",function(_,event,...)
        if event=="CHAT_MSG_ADDON" then self:Receive(...); return end
        if event=="UNIT_AURA" then self:UpdateTimers(); return end
        if event=="SPELLS_CHANGED" or event=="PLAYER_LOGIN" or event=="PLAYER_ENTERING_WORLD" then
            self.player=Name("player") or self.player; self:ScanSpells()
        end
        if Combat() then self.dirty=true; return end
        self:Roster()
        if event=="GROUP_ROSTER_UPDATE" or event=="PLAYER_ENTERING_WORLD" then
            if not self.lastSync or GetTime()-self.lastSync>3 then
                self.lastSync=GetTime(); self:Send("REQ"); self:Broadcast()
            end
        end
        if self.db.open and FT:IsEnabled("paladin") and not self.window then self:CreateWindow() end
        self:Refresh()
    end)
    local elapsed,sendElapsed=0,0
    frame:SetScript("OnUpdate",function(_,delta)
        elapsed=elapsed+delta; sendElapsed=sendElapsed+delta
        if sendElapsed>=0.15 and #self.outbox>0 then
            sendElapsed=0
            local channel=Read(IsInRaid,false) and "RAID" or "PARTY"
            if Read(IsInGroup,false,LE_PARTY_CATEGORY_INSTANCE) then channel="INSTANCE_CHAT" end
            local message=table.remove(self.outbox,1)
            if FT:IsEnabled("paladin") and self.settings.sync and C_ChatInfo and C_ChatInfo.SendAddonMessage
                and Read(GetNumGroupMembers,0)>0 then C_ChatInfo.SendAddonMessage("PLPWR",message,channel) end
        end
        if elapsed<0.5 then return end
        elapsed=0
        if not FT:IsEnabled("paladin") then return end
        if self.dirty and not Combat() then self:Refresh() end
        self:UpdateTimers()
    end)
end

SLASH_FOREVERTOOLSPALADIN1="/ftpp"
SlashCmdList.FOREVERTOOLSPALADIN=function()
    if not FT.db then return end
    if not FT:IsEnabled("paladin") then FT:Print("Paladin-Modul zuerst unter /ad aktivieren."); return end
    M:ToggleWindow()
end
