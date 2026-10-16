-- Adapted from Guschi 1.2.1 (Philipp): MatUse.lua and AhButton.lua.
local _, FT = ...
local M = {
    title = "Handwerksmaterial-Infos",
    description = "Material-Tooltips mit Rezepten deiner Berufe und Suche nach passenden Rezepten im Auktionshaus.",
    defaults = {tooltips = true, auction = true},
    options = {
        {key = "tooltips", title = "Rezeptverwendung im Gegenstands-Tooltip anzeigen"},
        {key = "auction", title = "Auktionshaus: Neue Rezepte suchen"},
    },
}
FT:RegisterModule("materials", M)
local PROF = {
    [164] = "Schmiedekunst", [165] = "Lederverarbeitung", [171] = "Alchemie",
    [185] = "Kochkunst", [129] = "Erste Hilfe", [197] = "Schneiderei",
    [202] = "Ingenieurskunst", [333] = "Verzauberkunst", [186] = "Bergbau", [40] = "Gifte",
}
local ALIAS = {[2937]=171, [2938]=164, [2939]=185, [2940]=333, [2941]=202,
    [2942]=129, [2945]=165, [2946]=186, [2948]=197}
local MAX = 8

function M:Learned()
    local set = {}
    if GetProfessions and GetProfessionInfo then
        for _, index in pairs({GetProfessions()}) do
            local skill = select(7, GetProfessionInfo(index))
            if skill then set[ALIAS[skill] or skill] = true end
        end
    end
    if UnitClass and select(2, UnitClass("player")) == "ROGUE" then set[40] = true end
    return set
end

function M:AddLines(tooltip, itemID)
    if not FT:IsEnabled("materials") or not self.settings.tooltips then return end
    local list = FT.materialUses[tonumber(itemID)]
    if not list then return end
    local have, mine, others, seen = self:Learned(), {}, {}, {}
    for _, recipe in ipairs(list) do
        if have[recipe[1]] then
            mine[#mine + 1] = recipe
        elseif not seen[recipe[1]] then
            seen[recipe[1]] = true
            others[#others + 1] = PROF[recipe[1]] or tostring(recipe[1])
        end
    end
    tooltip:AddLine(" ")
    if #mine > 0 then
        tooltip:AddLine("Verwendet für:", 1, 0.82, 0)
        for i = 1, math.min(MAX, #mine) do
            local r = mine[i]
            local name
            if C_Spell and C_Spell.GetSpellName then name = C_Spell.GetSpellName(r[2])
            elseif GetSpellInfo then name = GetSpellInfo(r[2]) end
            local known = IsPlayerSpell and IsPlayerSpell(r[2])
            tooltip:AddLine(("  %s: %s ×%d (gelb %d / grün %d)"):format(
                PROF[r[1]] or tostring(r[1]), name or ("#" .. r[2]), r[5], r[6],
                math.floor((r[6] + r[4]) / 2)), known and 0.3 or 0.6, known and 1 or 0.6,
                known and 0.3 or 0.6, true)
        end
        if #mine > MAX then
            tooltip:AddLine(("  … und %d weitere"):format(#mine - MAX), 0.6, 0.6, 0.6)
        end
    end
    if #others > 0 then tooltip:AddLine("Auch für: " .. table.concat(others, ", "), 0.5, 0.5, 0.5, true) end
    tooltip:Show()
end

function M:CancelSearch()
    self.search = nil
    self.token = (self.token or 0) + 1
end

function M:OnSettingsChanged()
    local enabled = FT:IsEnabled("materials") and self.settings.auction
    if not enabled then self:CancelSearch() end
    if self.button then self.button:SetShown(enabled) end
end

function M:ScanMail()
    local num = (C_Mail and C_Mail.GetInboxNumItems) or GetInboxNumItems
    local link = (C_Mail and C_Mail.GetInboxItemLink) or GetInboxItemLink
    if not num or not link then return end
    local items = {}
    for mail = 1, num() do
        for attachment = 1, ATTACHMENTS_MAX_RECEIVE or 16 do
            local id = tonumber((link(mail, attachment) or ""):match("item:(%d+)"))
            if id then items[id] = true end
        end
    end
    ForeverToolsMaterialMail = items
end

function M:Matches()
    local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    local count = (C_Item and C_Item.GetItemCount) or GetItemCount
    if not info or not count or not IsPlayerSpell then return {}, false end
    local learned, out, unloaded = self:Learned(), {}, false
    for item, recipe in pairs(FT.recipes) do
        if learned[recipe[1]] and not IsPlayerSpell(recipe[2]) and count(item, true) == 0
            and not ForeverToolsMaterialMail[item] then
            local reagents, have, total = FT.reagents[recipe[2]] or {}, 0, 0
            for i = 1, #reagents, 2 do
                total = total + 1
                if count(reagents[i], true) > 0 then have = have + 1 end
            end
            if total > 0 and have / total >= 0.5 then
                local name = info(item)
                if name then
                    out[#out + 1] = {id=item, name=name, have=have, total=total}
                else
                    unloaded = true
                    if C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(item) end
                end
            end
        end
    end
    table.sort(out, function(a, b)
        local x, y = a.have / a.total, b.have / b.total
        if x ~= y then return x > y end
        if a.name ~= b.name then return a.name < b.name end
        return a.id < b.id
    end)
    return out, unloaded
end

function M:SearchNext()
    local run = self.search
    if not run or not self.auctionOpen or not FT:IsEnabled("materials") or not self.settings.auction then
        self:CancelSearch(); return
    end
    run.index = run.index % #run.list + 1
    run.tries = run.tries + 1
    local match = run.list[run.index]
    self.lastItem = match.id
    self.token = self.token + 1
    local token = self.token
    local bar = AuctionHouseFrame and AuctionHouseFrame.SearchBar
    if bar and bar.SearchBox and bar.StartSearch then
        bar.SearchBox:SetText(match.name)
        bar:StartSearch()
    elseif BrowseName and AuctionFrameBrowse_Search then
        BrowseName:SetText(match.name)
        AuctionFrameBrowse_Search()
    else
        self:CancelSearch()
        FT:Print("Die Auktionshaus-Rezeptsuche ist in diesem Fenster nicht verfügbar.")
        return
    end
    FT:Print(("Rezept %d/%d: %s (%d/%d Materialsorten vorhanden)"):format(
        run.index, #run.list, match.name, match.have, match.total))
    if C_Timer and C_Timer.After then
        C_Timer.After(12, function()
            if self.search == run and self.token == token then
                self:CancelSearch()
                FT:Print("Rezeptsuche: keine Antwort vom Auktionshaus; bitte erneut klicken.")
            end
        end)
    end
end

function M:StartSearch()
    if not self.auctionOpen or not FT:IsEnabled("materials") or not self.settings.auction then return end
    self:CancelSearch()
    local list, unloaded = self:Matches()
    if #list == 0 then
        FT:Print(unloaded and "Rezeptnamen werden geladen – gleich nochmal klicken." or "Keine passenden Rezepte gefunden.")
        return
    end
    local index = 0
    for i, match in ipairs(list) do if match.id == self.lastItem then index = i; break end end
    self.search = {list=list, index=index, tries=0}
    self:SearchNext()
end

function M:OnResults()
    if not self.search then return end
    local run = self.search
    self.token = self.token + 1
    local token = self.token
    local function resolve()
        if self.search ~= run or self.token ~= token then return end
        local count
        if AuctionHouseFrame and AuctionHouseFrame.SearchBar and C_AuctionHouse and C_AuctionHouse.GetBrowseResults then
            count = #(C_AuctionHouse.GetBrowseResults() or {})
        elseif GetNumAuctionItems then count = GetNumAuctionItems("list") end
        if count == nil then self:CancelSearch(); return end
        if count > 0 then
            self:CancelSearch()
            FT:Print("Rezept im Auktionshaus gefunden.")
        elseif run.tries < #run.list then self:SearchNext()
        else
            self:CancelSearch()
            FT:Print("Keines der passenden Rezepte ist im Auktionshaus verfügbar.")
        end
    end
    if C_Timer and C_Timer.After then C_Timer.After(0.7, resolve) else resolve() end
end

function M:CreateAuctionButton()
    local parent = AuctionHouseFrame or AuctionFrame
    if self.button or not parent then return end
    local button = CreateFrame("Button", "ForeverToolsRecipeSearch", parent, "UIPanelButtonTemplate")
    button:SetSize(170, 22)
    button:SetText("Neue Rezepte suchen")
    button:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", -10, 2)
    button:SetFrameStrata("HIGH")
    button:SetScript("OnClick", function() self:StartSearch() end)
    self.button = button
    self:OnSettingsChanged()
end

function M:Initialize()
    if self.frame then return end
    ForeverToolsMaterialMail = type(ForeverToolsMaterialMail) == "table" and ForeverToolsMaterialMail or {}
    self.token = 0
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            if tooltip == GameTooltip or tooltip == ItemRefTooltip then self:AddLines(tooltip, data and data.id) end
        end)
    else
        for _, tooltip in pairs({GameTooltip, ItemRefTooltip}) do
            if tooltip.HookScript then
                tooltip:HookScript("OnTooltipSetItem", function(tip)
                    local _, link = tip:GetItem()
                    self:AddLines(tip, link and link:match("item:(%d+)"))
                end)
            end
        end
    end
    local frame = CreateFrame("Frame")
    self.frame = frame
    for _, event in ipairs({"AUCTION_HOUSE_SHOW", "AUCTION_HOUSE_CLOSED", "ADDON_LOADED",
        "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED", "AUCTION_ITEM_LIST_UPDATE", "MAIL_INBOX_UPDATE"}) do
        -- Auction events differ between the legacy and modern auction UI.
        pcall(frame.RegisterEvent, frame, event)
    end
    frame:SetScript("OnEvent", function(_, event)
        if event == "AUCTION_HOUSE_SHOW" then
            self.auctionOpen = true
            self:CreateAuctionButton()
            self:OnSettingsChanged()
        elseif event == "AUCTION_HOUSE_CLOSED" then
            self.auctionOpen = false
            self:CancelSearch()
        elseif event == "ADDON_LOADED" then self:CreateAuctionButton()
        elseif event == "MAIL_INBOX_UPDATE" then self:ScanMail()
        else self:OnResults() end
    end)
    self:CreateAuctionButton()
end
