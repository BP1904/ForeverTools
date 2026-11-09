local _, FT = ...
local LIMIT=20
local function Public(value)
    if issecretvalue and issecretvalue(value) then return end
    if type(value)=="string" then return value:sub(1,180) end
end

function FT:RecordDiagnostic(event, addon, action)
    if not self.db then return end
    event,addon,action=Public(event),Public(addon),Public(action)
    if not event or not addon or not action then return end
    local log=type(self.db.diagnostics)=="table" and self.db.diagnostics or {}
    self.db.diagnostics=log
    local combat=InCombatLockdown and InCombatLockdown() and true or false
    local stamp=date and date("%d.%m.%Y %H:%M:%S") or tostring(GetTime and GetTime() or 0)
    local last=log[#log]
    if type(last)=="table" and last.event==event and last.addon==addon
        and last.action==action and last.combat==combat then
        last.count=(tonumber(last.count) or 1)+1; last.stamp=stamp
        return
    end
    local entry={event=event,addon=addon,action=action,combat=combat,stamp=stamp,count=1}
    if debugstack and event~="INITIALIZE_ERROR" then
        local ok,stack=pcall(debugstack,3,8,0)
        if ok and not (issecretvalue and issecretvalue(stack)) and type(stack)=="string" then
            entry.stack=stack:sub(1,2000)
        end
    end
    log[#log+1]=entry
    while #log>LIMIT do table.remove(log,1) end
end

local events=CreateFrame("Frame")
for _,event in ipairs({"ADDON_ACTION_BLOCKED","ADDON_ACTION_FORBIDDEN","MACRO_ACTION_BLOCKED","MACRO_ACTION_FORBIDDEN"}) do
    pcall(events.RegisterEvent,events,event)
end
events:SetScript("OnEvent",function(_,event,addon,action)
    if event=="MACRO_ACTION_BLOCKED" or event=="MACRO_ACTION_FORBIDDEN" then addon,action="Makro",addon end
    FT:RecordDiagnostic(event,addon,action)
end)

SLASH_FOREVERTOOLSERRORS1="/ftfehler"
SlashCmdList.FOREVERTOOLSERRORS=function(message)
    local saved=FT.db and FT.db.diagnostics
    local log=type(saved)=="table" and saved or {}
    FT:Print("Diagnose: "..#log.." Einträge (letzte 5):")
    for i=math.max(1,#log-4),#log do
        local entry=log[i]
        if type(entry)=="table" then
            local function Text(value) return (Public(value) or "?"):gsub("|","||") end
            FT:Print(Text(entry.stamp).." | "..Text(entry.event).." | "..Text(entry.addon).." | "
                ..Text(entry.action)..(entry.combat and " | im Kampf" or " | außerhalb des Kampfes")
                .." | "..(tonumber(entry.count) or 1).."×")
            if message=="details" and type(entry.stack)=="string" then FT:Print(entry.stack:gsub("|","||")) end
        end
    end
    if #log==0 then FT:Print("Noch keine blockierte Aktion aufgezeichnet. Nach erneutem Auftreten /ftfehler eingeben.") end
    FT:Print("Der gemeldete Addonname ist ein Hinweis; die ursprüngliche Ursache kann auch in einem anderen Addon liegen.")
end
