local _, FT = ...
local ns = FT.disenchantry or {}
local M = {
    title="Entzaubern: Disenchantry",
    description="Entzaubern mit Auswahl, Schutzfiltern, Sperrliste, Materialvorschau und Statistik. Mahlen/Sondieren nur bei gelerntem Beruf und passendem Client. Pro Verarbeitung ein Klick.",
}
FT:RegisterModule("disenchantry", M)
local App = ns.App
local function Combat() return InCombatLockdown and InCombatLockdown() end
local function Clone(value, seen)
    if type(value)~="table" then return value end
    seen=seen or {}; if seen[value] then return seen[value] end
    local result={}; seen[value]=result
    for key,item in pairs(value) do result[key]=Clone(item,seen) end
    return result
end
local function LegacyLoaded()
    local api=C_AddOns or _G
    return api.IsAddOnLoaded and api.IsAddOnLoaded("Disenchantry") or false
end
function M:IsAvailable() return App~=nil end
function M:Quote(reference)
    if issecretvalue and issecretvalue(reference) then return end
    local auction=FT.modules.auctionator
    if not auction or not auction.settings then return end
    local key=auction:Key(type(reference)=="number" and "item:" .. reference or reference)
    local quote=key and auction:Market().prices[key]
    local value=quote and quote.unit
    if type(value)=="number" and value>0 and value<math.huge then return value,"forevertools","ForeverTools (Scan)" end
end
function M:InstallPrices()
    local prices=ns.Prices
    local query,status,hasSource=prices.Query,prices.GetProviderStatus,prices.HasAnySource
    prices.Query=function(reference,channel)
        if channel==nil or channel=="preferred" or channel=="forevertools" or channel=="auctionator" then
            local value,key,label=self:Quote(reference)
            if value then return value,key,label end
        end
        if channel~="forevertools" then return query(reference,channel) end
    end
    prices.GetAuctionatorValue=function(id) return prices.Query(id,"preferred") end
    local function ownSource()
        local auction=FT.modules.auctionator
        return auction and auction.settings and next(auction:Market().prices)~=nil or false
    end
    prices.GetProviderStatus=function()
        local result=status()
        table.insert(result,1,{key="forevertools",label="ForeverTools (Scan)",available=ownSource()})
        return result
    end
    prices.HasAnySource=function() return ownSource() or hasSource() end
end
function M:InstallGuards()
    for _,name in ipairs({"RefreshWorkspace","RefreshUI","SyncActionTarget","ToggleMainFrame",
        "ToggleSettingsFrame","ToggleBlacklistFrame","SetCompactMode"}) do
        local original=App[name]
        App[name]=function(...)
            if not ns.IsEnabled() then
                if name=="SyncActionTarget" and not Combat() then App.DisarmAction() end
                return
            end
            return original(...)
        end
    end
    local before=ns.Action.BeforeClick
    ns.Action.BeforeClick=function(button)
        if not ns.IsEnabled() then if not Combat() then App.DisarmAction() end; return end
        if not Combat() then
            local item=App.queue[1]
            local live=item and C_Container and C_Container.GetContainerItemInfo and C_Container.GetContainerItemInfo(item.bag,item.slot)
            local cursor=CursorHasItem and CursorHasItem() or SpellIsTargeting and SpellIsTargeting()
            if not item or not live or live.isLocked or live.hyperlink~=item.link
                or (live.stackCount or 1)<App.activeMode.minStack or App.IsExcluded(item.link) or cursor then
                App.DisarmAction(); App.ClearPendingDisenchant()
                if item then App.Print("Gegenstand oder Cursor verändert. Bitte Liste aktualisieren und erneut prüfen.") end
                return
            end
        end
        return before(button)
    end
end
function M:InstallTooltips()
    if self.tooltipInstalled or not ns.IsEnabled() then return end
    self.tooltipInstalled=true
    ns.DisenchantResults.InstallTooltipHooks()
end
function M:EnsureStarted()
    if not App or not FT:IsEnabled("disenchantry") then return false end
    if self.legacyBlocked then FT:Print("Disenchantry wurde übernommen. Bitte nochmals /reload eingeben, damit nur die integrierte Version läuft."); return false end
    if Combat() then FT:Print("Disenchantry bitte nach dem Kampf öffnen."); return false end
    if self.failed then FT:Print("Disenchantry konnte nicht vollständig geladen werden. Bitte /reload und die Lua-Fehlermeldung prüfen."); return false end
    if self.started then return true end
    local ok,err=pcall(function()
        ns.Statistics.Initialize(App.db,App.CreateStyledWindow,App.CreateStyledButton)
        App.CreateMainFrame()
        App.CreateCompactFrame()
        ns.Hotkeys.Initialize(App.db,App.queueButton,function()
            return ns.IsEnabled() and App.activeMode.key=="disenchant" and App.queueButton:IsVisible()
        end)
        App.CreateSettingsFrame()
        App.RefreshWorkspace()
    end)
    if not ok then self.failed=true; FT:Print("Disenchantry: " .. tostring(err)); return false end
    self.started=true
    return true
end
function M:Open(which)
    if not self:EnsureStarted() then return end
    if which=="settings" then App.ToggleSettingsFrame()
    elseif which=="blacklist" then App.ToggleBlacklistFrame()
    elseif which=="stats" then ns.Statistics.Toggle()
    elseif which=="compact" then App.SetCompactMode(true)
    else App.ToggleMainFrame() end
end
function M:Command(message)
    local command=(message or ""):lower():match("^%s*(.-)%s*$")
    local views={settings="settings",options="settings",blacklist="blacklist",stats="stats",compact="compact"}
    if command=="" or views[command] then self:Open(views[command]); return end
    if command=="help" or command=="?" then
        FT:Print("/ftde: öffnen; settings: Schutzfilter; blacklist: Sperrliste; stats: Statistik; compact: Kompaktleiste; de/mill/prospect: Modus; refresh: aktualisieren; check/copy: Diagnose.")
        return
    end
    if not self:EnsureStarted() then return end
    local mode=({de="disenchant",mill="milling",prospect="prospecting"})[command]
    if mode then
        local descriptor=ns.Modes.byKey[mode]
        if not App.SupportsProfession(descriptor) or not descriptor.isKnown() then App.Print(App.L.MODE_NOT_LEARNED_HINT); return end
        App.ChooseProfession(mode)
    elseif command=="refresh" then App.RefreshWorkspace()
    elseif command=="check" or command=="copy" then App.InspectWorkspace(command=="copy")
    else self:Command("help") end
end
function M:DisableCleanup()
    if not App then return end
    if Combat() then self.pendingDisable=true; return end
    self.pendingDisable=nil
    App.DisarmAction(); App.ClearPendingDisenchant()
    ns.Statistics.CancelProcessing()
    wipe(App.selected); wipe(App.queue); ns.Queue.EndSession()
    for _,name in ipairs({"mainFrame","compactFrame","settingsFrame","blacklistFrame","checkCopyFrame"}) do
        if App[name] then App[name]:Hide() end
    end
    local stats=_G.ForeverToolsDisenchantry_StatisticsFrame
    if stats then stats:Hide() end
    ns.Hotkeys.Update()
end
function M:OnSettingsChanged()
    if not App then return end
    if not FT:IsEnabled("disenchantry") then self:DisableCleanup()
    else self:InstallTooltips() end
end
local function Visible()
    return App and (App.mainFrame and App.mainFrame:IsShown() or App.compactFrame and App.compactFrame:IsShown())
end
function M:OnEvent(event,...)
    if event=="PLAYER_REGEN_ENABLED" and self.pendingDisable then self:DisableCleanup() end
    if not ns.IsEnabled() then return end
    if event=="AUCTION_HOUSE_CLOSED" then ns.Prices.ClearCache() end
    if not self.started then return end
    ns.Statistics.OnEvent(event,...)
    if event=="BAG_UPDATE_DELAYED" or event=="PLAYER_LOGIN" or event=="AUCTION_HOUSE_CLOSED" then
        if Visible() then App.RefreshWorkspace() end
    elseif event=="GET_ITEM_INFO_RECEIVED" then
        local id,success=...
        if ns.DisenchantResults.ItemLoaded(id) and success and Visible() then
            if Combat() then App.needsRefreshAfterCombat=true else App.RefreshUI() end
        end
    elseif event=="PLAYER_REGEN_DISABLED" then
        App.ClearPendingDisenchant(); App.needsRefreshAfterCombat=true; App.HideMainFrameForCombat()
    elseif event=="PLAYER_REGEN_ENABLED" then
        App.InstallCombatVisibility(); ns.Hotkeys.Update()
        if App.db.compactMode and App.compactFrame:IsShown() and App.queueButton:GetParent()~=App.compactFrame then App.DockQueueButtonToCompact() end
        App.needsRefreshAfterCombat=false; App.RefreshWorkspace()
    elseif event=="CHAT_MSG_LOOT" then
        if not App.pendingDisenchantItem or GetTime()>App.pendingLootUntil then return end
        local source=select(12,...); local player=UnitGUID and UnitGUID("player")
        if issecretvalue and (issecretvalue(source) or issecretvalue(player)) then return end
        if ns.Client.IsPublicString(source) and player and source~=player then return end
        App.ClearPendingDisenchant()
    elseif event=="UI_ERROR_MESSAGE" or event=="UI_INFO_MESSAGE" or event=="CHAT_MSG_SYSTEM" then
        if not App.pendingDisenchantItem or GetTime()>App.pendingDisenchantUntil then return end
        local failure=App.activeMode.classifyFailure(App.ExtractMessageFromEventArgs(...))
        if failure=="hard" then App.ValidatePendingItemForBlacklist(0.1,true)
        elseif failure=="generic" then App.ValidatePendingItemForBlacklist(0.25) end
    end
end
function M:Initialize()
    if not App or self.initialized then return end
    self.initialized=true
    if type(ForeverToolsDisenchantryDB)~="table" then
        if type(DisenchantryDB)=="table" then ForeverToolsDisenchantryDB=Clone(DisenchantryDB)
        else
            -- Begin with explicit item selection and uncommon items only.
            ForeverToolsDisenchantryDB={compactMode=false,qualityFilter={[2]=true,[3]=false,[4]=false}}
        end
    end
    App.OpenPreferences(); App.ActivateProfession(App.db.activeMode)
    self:InstallPrices(); self:InstallGuards()
    if LegacyLoaded() then self.legacyBlocked=true; FT:RetireLegacyAddon("Disenchantry") end
    self:InstallTooltips()
    self.frame=App.addon
    self.frame:SetScript("OnEvent",function(_,event,...) self:OnEvent(event,...) end)
    for _,event in ipairs({"PLAYER_LOGIN","BAG_UPDATE_DELAYED","GET_ITEM_INFO_RECEIVED","CHAT_MSG_LOOT",
        "UI_ERROR_MESSAGE","UI_INFO_MESSAGE","CHAT_MSG_SYSTEM","PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED",
        "AUCTION_HOUSE_CLOSED","UNIT_SPELLCAST_SENT","UNIT_SPELLCAST_SUCCEEDED","UNIT_SPELLCAST_FAILED",
        "UNIT_SPELLCAST_INTERRUPTED","LOOT_READY","LOOT_OPENED","LOOT_CLOSED"}) do self.frame:RegisterEvent(event) end
    SLASH_FOREVERTOOLSDISENCHANTRY1="/ftde"
    SLASH_FOREVERTOOLSDISENCHANTRY2="/ftentzaubern"
    SlashCmdList.FOREVERTOOLSDISENCHANTRY=function(message) self:Command(message) end
end
M.actions={
    {title="Disenchantry öffnen",run=function() M:Open() end},
    {title="Schutzfilter und Einstellungen",run=function() M:Open("settings") end},
    {title="Sperrliste öffnen",run=function() M:Open("blacklist") end},
    {title="Entzauber-Statistik",run=function() M:Open("stats") end},
    {title="Kompaktleiste öffnen",run=function() M:Open("compact") end},
}
