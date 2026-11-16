-- Embedded from Disenchantry 1.2.5 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local App, UI=ns.App,ns.UI
local ru=GetLocale()=="ruRU"
function App.ForecastPreferencesChanged()
    ns.Prices.ClearCache()
    if InCombatLockdown() then App.needsRefreshAfterCombat=true
    else App.RefreshWorkspace() end
    if ns.AuctionScan and ns.AuctionScan.running then
        ns.AuctionScan.Stop(); ns.AuctionScan.Start()
    elseif ns.AuctionScan and ns.AuctionScan.OnChanged then ns.AuctionScan.OnChanged() end
end
function App.ToggleForecastPreferences()
    if App.forecastPreferences then UI.Toggle(App.forecastPreferences); return end
    local window=App.CreateStyledWindow("ForeverToolsDisenchantry_ForecastPreferences",490,550)
    App.forecastPreferences=window
    UI.Anchor(window,{{"CENTER",UIParent,"CENTER",0,0}})
    window.title:SetText(ru and "Оценка и отображение" or "Forecast and display")
    UI.Text(window,ru and "Кнопка миникарты открывает:" or "Minimap button opens:",nil,{{"TOPLEFT",18,-45}})
    local controls={}
    local function choice(values,y,field)
        for index,entry in ipairs(values) do
            local key=entry[1]
            controls[#controls+1]={field=field,key=key,button=UI.Button(window,{text=entry[2],width=140,height=24,
                points={{"TOPLEFT",18+(index-1)*150,-y}},click=function()
                    App.db[field]=key; App.ForecastPreferencesChanged(); window:GetScript("OnShow")(window)
                end})}
        end
    end
    choice({{"compact",ru and "Компактный" or "Compact"},{"full",ru and "Полный" or "Full"},{"last",ru and "Последний" or "Last used"}},66,"minimapOpenMode")
    UI.Text(window,ru and "Цена в полном списке (за единицу):" or "Full list price (per item):",nil,{{"TOPLEFT",18,-108}})
    choice({{"auction",ru and "Аукцион" or "Auction house"},{"vendor",ru and "Торговец" or "Vendor"}},129,"listPriceSource")
    UI.Text(window,"Arcane Salvager:",nil,{{"TOPLEFT",18,-172}})
    choice({{"auto",ru and "По бафу" or "Detect buff"},{"off",ru and "Без бонуса" or "No bonus"},{"on",ru and "Планировать" or "Plan with bonus"}},193,"salvagerMode")
    UI.Text(window,ru and "Оценочный бонус к стоимости (%):" or "Estimated value bonus (%):",nil,{{"TOPLEFT",18,-242}})
    local input=CreateFrame("EditBox",nil,window,"InputBoxTemplate")
    input:SetSize(70,24); input:SetPoint("TOPLEFT",335,-236); input:SetAutoFocus(false); input:SetMaxLetters(7)
    local function commit(self)
        local normalized=(self:GetText() or ""):gsub(",",".")
        local number=tonumber(normalized)
        if number and number==number and number>=0 and number<=1000 then
            App.db.salvagerBonusPercent=number; App.ForecastPreferencesChanged()
        end
        self:SetText(tostring(App.db.salvagerBonusPercent or 0))
    end
    input:SetScript("OnEditFocusLost",commit)
    input:SetScript("OnEnterPressed",function(self) self:ClearFocus() end)
    input:SetScript("OnEscapePressed",function(self) self:SetText(tostring(App.db.salvagerBonusPercent or 0)); self:ClearFocus() end)
    local info=UI.Text(window,ru and "Точный бонус Salvager не подтверждён. 0% сохраняет базовую оценку. Введённый процент — ваша модель ожидаемой стоимости, а не игровые шансы; дополнительные материалы в неё не включены.\n\nРезультаты ваших распылений сохраняются отдельно с бафом Salvager и без него. После 20 наблюдений для предмета используется средний фактический выход. До этого используется расчёт по типу и уровню предмета." or "The exact Salvager bonus is unverified. 0% keeps the baseline. Your percentage models expected value, not in-game probabilities; additional materials are not included.\n\nYour yields are saved separately with and without the Salvager buff. After 20 samples per item, forecasts use observed mean yields. Until then, forecasts use item type and level.","GameFontHighlightSmall",{{"TOPLEFT",18,-280},{"RIGHT",window,"RIGHT",-18,0}})
    info:SetWordWrap(true)
    local protection=UI.Button(window,{text=ru and "Защита по прибыли" or "Profit protection",width=220,height=24,
        points={{"TOPLEFT",18,-420}},click=function()
            App.db.profitProtection=not App.db.profitProtection
            App.ForecastPreferencesChanged(); window:GetScript("OnShow")(window)
        end})
    UI.Text(window,ru and "Минимальная прибыль (% от цены выше):" or "Minimum profit (% of selected price):",nil,{{"TOPLEFT",18,-460}})
    local margin=CreateFrame("EditBox",nil,window,"InputBoxTemplate")
    margin:SetSize(70,24); margin:SetPoint("TOPLEFT",350,-452); margin:SetAutoFocus(false); margin:SetMaxLetters(7)
    margin:SetScript("OnEditFocusLost",function(self)
        local value=tonumber(((self:GetText() or ""):gsub(",",".")))
        if value and value==value and value>=0 and value<=1000 then App.db.minDEProfitPercent=value; App.ForecastPreferencesChanged() end
        self:SetText(tostring(App.db.minDEProfitPercent or 0))
    end)
    margin:SetScript("OnEnterPressed",function(self) self:ClearFocus() end)
    UI.Text(window,ru and "Защита автоматической очереди. Ручной выбор её обходит.\nБез цен предмет пропускается. Прибыль до комиссии аукциона." or "Protects the automatic queue; manual selection overrides it.\nMissing prices skip the item. Profit is before AH fees.","GameFontHighlightSmall",{{"TOPLEFT",18,-495}})
    window:SetScript("OnShow",function()
        protection:SetText((ru and "Защита по прибыли: " or "Profit protection: ")..(App.db.profitProtection and (ru and "вкл." or "on") or (ru and "выкл." or "off")))
        margin:SetText(tostring(App.db.minDEProfitPercent or 0))
        for _,control in ipairs(controls) do control.button:SetEnabled(App.db[control.field]~=control.key) end
        input:SetText(tostring(App.db.salvagerBonusPercent or 0))
    end)
    table.insert(UISpecialFrames,"ForeverToolsDisenchantry_ForecastPreferences")
    window:Hide(); window:Show()
end

end
LoadComponent("ForeverTools", FT.disenchantry)
