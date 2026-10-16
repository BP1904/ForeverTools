local addonName, A = ...
_G.AntiFettFinger = A
local MOVEMENT = {
    MOVEFORWARD=true, MOVEBACKWARD=true, STRAFELEFT=true, STRAFERIGHT=true,
    TURNLEFT=true, TURNRIGHT=true, JUMP=true, TOGGLEAUTORUN=true,
    STARTAUTORUN=true, STOPAUTORUN=true, PITCHUP=true, PITCHDOWN=true,
    SITORSTAND=true, ASCEND=true, DESCEND=true,
}
local ROW = { ["1"]=true,["2"]=true,["3"]=true,["4"]=true,["5"]=true,["6"]=true,
    ["7"]=true,["8"]=true,["9"]=true,["0"]=true,["-"]=true,["="]=true }
local MODIFIERS = {"","SHIFT-","CTRL-","ALT-","CTRL-SHIFT-","ALT-SHIFT-","ALT-CTRL-","ALT-CTRL-SHIFT-"}
local COMMON = {"ESCAPE","TAB","SPACE","BACKSPACE","ENTER","INSERT","DELETE",
    "HOME","END","PAGEUP","PAGEDOWN","UP","DOWN","LEFT","RIGHT","CAPSLOCK",
    "NUMLOCK","SCROLLLOCK","PRINTSCREEN","PAUSE","`","-","=","[","]","\\",";","'",",",".","/",
    "NUMPADPLUS","NUMPADMINUS","NUMPADMULTIPLY","NUMPADDIVIDE","NUMPADDECIMAL","NUMPADENTER"}
local function Combat() return InCombatLockdown() end
local function Print(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff65d6adAnti Fett Finger:|r "..message)
end
local function IsKeyboard(key)
    return type(key)=="string" and key~="" and not key:match("BUTTON%d")
        and not key:find("MOUSEWHEEL",1,true) and not key:match("^PAD")
end

-- Construct a fixed plan outside combat. No saved binding is changed.
function A:BuildPlan()
    local keys, movement = {}, {}
    for _,key in ipairs(COMMON) do keys[key]=true end
    for byte=string.byte("A"),string.byte("Z") do keys[string.char(byte)]=true end
    for i=0,9 do keys[tostring(i)]=true; keys["NUMPAD"..i]=true end
    for i=1,24 do keys["F"..i]=true end
    local boundKeys={}
    for i=1,GetNumBindings() do
        local command=GetBinding(i)
        if command then
            local bindings={GetBindingKey(command)}
            for _,key in pairs(bindings) do
                if IsKeyboard(key) then
                    boundKeys[key]=true
                    if MOVEMENT[command] then movement[key]=command end
                end
            end
        end
    end
    -- Preserve movement while modifiers are held, without exposing a different
    -- non-movement command on that combination (e.g. Shift-W).
    local allowedMovement={}
    for key,command in pairs(movement) do
        allowedMovement[key]=command
        if not key:find("-",1,true) then
            for _,prefix in ipairs(MODIFIERS) do
                if not movement[prefix..key] then allowedMovement[prefix..key]=command end
            end
        end
    end
    local blocked={}
    for key in pairs(keys) do
        for _,prefix in ipairs(MODIFIERS) do blocked[prefix..key]=true end
    end
    for key in pairs(boundKeys) do blocked[key]=true end
    for key in pairs(ROW) do blocked[key]=nil end
    for key in pairs(allowedMovement) do blocked[key]=nil end
    local plan={}
    for key in pairs(blocked) do plan[#plan+1]={key=key} end
    for key,command in pairs(allowedMovement) do plan[#plan+1]={key=key,command=command} end
    table.sort(plan,function(a,b) return a.key<b.key end)
    return plan
end

local APPLY = [[
    self:ClearBindings()
    local active = self:GetAttribute("enabled") and self:GetAttribute("state-combat") == "combat"
    if active then
        for i=1,self:GetAttribute("key-count") do
            local key=self:GetAttribute("key-"..i)
            local command=self:GetAttribute("command-"..i)
            if command then
                self:SetBinding(true,key,command)
            else
                self:SetBindingClick(true,key,"AntiFettFingerBlockedKey","LeftButton")
            end
        end
    end
    self:SetAttribute("active",active and true or false)
]]
local ATTRIBUTE = [[
    if name == "enabled" or name == "state-combat" then self:RunAttribute("apply") end
]]
local TOGGLE = [[
    if button == "LeftButton" and not down then
        local controller=self:GetFrameRef("controller")
        controller:SetAttribute("enabled",not controller:GetAttribute("enabled"))
    end
]]

function A:RefreshStatus()
    local enabled=self.controller:GetAttribute("enabled") and true or false
    local active=self.controller:GetAttribute("active")
    self.db.enabled=enabled
    self.button:SetText(not enabled and "Anti Fett Finger: AUS"
        or active and "Anti Fett Finger: GESPERRT" or "Anti Fett Finger: bereit")
    self:NotifyState()
end

function A:IsEnabled()
    if self.requestedEnabled~=nil then return self.requestedEnabled end
    if self.controller then return self.controller:GetAttribute("enabled") and true or false end
    return self.db and self.db.enabled and true or false
end

function A:NotifyState()
    for _,listener in ipairs(self.listeners or {}) do listener(self) end
end

function A:RegisterStateListener(listener)
    self.listeners=self.listeners or {}
    self.listeners[#self.listeners+1]=listener
end

function A:SetEnabled(enabled)
    enabled=enabled and true or false
    if Combat() then
        self.requestedEnabled=enabled
        self:NotifyState()
        return false
    end
    self.requestedEnabled=nil
    self.db.enabled=enabled
    if self.controller then self.controller:SetAttribute("enabled",enabled) else self:Create() end
    return true
end

function A:UpdatePlan()
    if Combat() then self.pending=true; return end
    local plan=self:BuildPlan()
    local controller=self.controller
    controller:SetAttribute("key-count",#plan)
    for i,entry in ipairs(plan) do
        controller:SetAttribute("key-"..i,entry.key)
        controller:SetAttribute("command-"..i,entry.command)
    end
    self.pending=false
    controller:Execute([[ self:RunAttribute("apply") ]])
end

function A:StopMoving()
    if not self.moving or Combat() then return end
    self.button:StopMovingOrSizing(); self.moving=false
    local point,_,relativePoint,x,y=self.button:GetPoint()
    self.db.position={point=point,relativePoint=relativePoint,x=x,y=y}
end

function A:Create()
    if self.controller then return end
    if Combat() then self.pending=true; return end
    if self.requestedEnabled~=nil then self.db.enabled=self.requestedEnabled; self.requestedEnabled=nil end
    local sink=CreateFrame("Button","AntiFettFingerBlockedKey",UIParent,"SecureActionButtonTemplate")
    sink:SetSize(1,1); sink:Hide() -- No action attributes: blocked key presses do nothing.
    local controller=CreateFrame("Frame","AntiFettFingerController",UIParent,
        "SecureHandlerAttributeTemplate")
    self.controller=controller
    local button=CreateFrame("Button","AntiFettFingerSwitch",UIParent,
        "UIPanelButtonTemplate,SecureHandlerClickTemplate")
    self.button=button
    button:SetSize(205,24); button:SetClampedToScreen(true); button:SetMovable(true)
    local p=self.db.position
    if type(p)=="table" and type(p.point)=="string" and type(p.relativePoint)=="string"
        and type(p.x)=="number" and type(p.y)=="number" then
        button:SetPoint(p.point,UIParent,p.relativePoint,p.x,p.y)
    else button:SetPoint("TOP",UIParent,"TOP",0,-90) end
    button:RegisterForClicks("LeftButtonUp"); button:RegisterForDrag("RightButton")
    button:SetFrameRef("controller",controller); button:SetAttribute("_onclick",TOGGLE)
    button:SetScript("OnDragStart",function(_,mouse)
        if mouse=="RightButton" and not Combat() then self.moving=true; button:StartMoving() end
    end)
    button:SetScript("OnDragStop",function() self:StopMoving() end)
    button:SetScript("OnEnter",function()
        GameTooltip:SetOwner(button,"ANCHOR_BOTTOM")
        GameTooltip:AddLine("Anti Fett Finger")
        GameTooltip:AddLine("Im Kampf: 1 bis ´ und belegte Bewegungstasten bleiben frei.",1,1,1,true)
        GameTooltip:AddLine("Linksklick: Sperre ein/aus, auch im Kampf.",1,1,1,true)
        GameTooltip:AddLine("Rechts ziehen: verschieben, außerhalb des Kampfes.",0.8,0.8,0.8,true)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave",function() GameTooltip:Hide() end)
    controller:SetAttribute("apply",APPLY)
    controller:SetAttribute("enabled",self.db.enabled)
    controller:HookScript("OnAttributeChanged",function(_,name)
        if name=="enabled" then self.requestedEnabled=nil end
        if name=="active" or name=="enabled" then self:RefreshStatus() end
    end)
    self:UpdatePlan()
    controller:SetAttribute("_onattributechanged",ATTRIBUTE)
    RegisterStateDriver(controller,"combat","[combat] combat; peace")
    self:RefreshStatus()
    Print("geladen. Im Kampf: 1 bis ´ und Bewegung. Mausbutton oben: ein/aus. Hilfe: /aff")
end

function A:Command(text)
    local command=(text or ""):lower():match("^%s*(%S*)")
    if command=="on" or command=="off" then
        if Combat() then Print("Im Kampf den Mausbutton oben zum Ein-/Ausschalten anklicken."); return end
        self:SetEnabled(command=="on")
    elseif command=="reset" then
        if Combat() then Print("Position erst außerhalb des Kampfes zurücksetzen."); return end
        self.db.position=nil; self.button:ClearAllPoints(); self.button:SetPoint("TOP",UIParent,"TOP",0,-90)
    else
        Print("/aff on | off | reset. Im Kampf bleiben 1 bis ´ und Bewegung frei. Mausbutton schaltet sofort um.")
    end
end

local events=CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent",function(_,event,name)
    if event=="ADDON_LOADED" then
        if name~=addonName then return end
        events:UnregisterEvent("ADDON_LOADED")
        AntiFettFingerDB=type(AntiFettFingerDB)=="table" and AntiFettFingerDB or {}
        A.db=AntiFettFingerDB
        if A.db.enabled==nil then A.db.enabled=true end
        events:RegisterEvent("UPDATE_BINDINGS"); events:RegisterEvent("PLAYER_REGEN_ENABLED")
        events:RegisterEvent("PLAYER_ENTERING_WORLD")
        SLASH_ANTIFETTFINGER1="/aff"
        SLASH_ANTIFETTFINGER2="/antifettfinger"
        SlashCmdList.ANTIFETTFINGER=function(text)
            if A.controller then A:Command(text) else Print("Einrichtung wartet auf das Kampfende.") end
        end
        A:Create()
    elseif not A.controller then A:Create()
    elseif event=="PLAYER_REGEN_ENABLED" then
        A:StopMoving()
        if A.requestedEnabled~=nil then A:SetEnabled(A.requestedEnabled) end
        if A.pending then A:UpdatePlan() end
    else A:UpdatePlan() end
end)
