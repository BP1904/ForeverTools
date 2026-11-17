-- Embedded from Disenchantry 1.2.6 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
local _, ns = ...
local Policy = {overrides={}}
ns.ForecastPolicy = Policy
-- Opted-in estimates for these exact new crafts only, not all Forever rares.
-- Craft Ladder Data/Disenchant.lua (2026-11-03), buckets 335/336, guess=true.
-- See Docs/ForeverRareResearch.md. Player observations take precedence.
local lowCraft = {approximate=true,foreverCraftEstimate=true,
    {itemID=10940,chance=80,minQuantity=2,maxQuantity=3},
    {itemID=10938,chance=20,minQuantity=2,maxQuantity=3}}
local midCraft = {approximate=true,foreverCraftEstimate=true,
    {itemID=10940,chance=75,minQuantity=3,maxQuantity=4},
    {itemID=10939,chance=20,minQuantity=2,maxQuantity=3},
    {itemID=10978,chance=5,minQuantity=2,maxQuantity=2}}
for _,id in ipairs({250620,250482,250621,252424,252425,252426,252427,253885,253887}) do
    Policy.overrides[id]=lowCraft
end
for _,id in ipairs({250513,250514,250515,250516,250517,250508,250509,250510,250511,250512,250489,
    252428,252429,252430,252431,252432,252433,252494,252495,252496,252497,252498,252499,
    253889,253891,253893,253895,253897,253899,253901,253903,253905,253907,253909,253911,
    253913,253915,253917,253919,253921,253923}) do
    Policy.overrides[id]=midCraft
end
function Policy.ItemID(item)
    local ref = type(item)=="table" and (item.itemID or item.link) or item
    return type(ref)=="number" and ref or type(ref)=="string" and tonumber(ref:match("item:(%d+)")) or nil
end
function Policy.IsForever()
    return GetBuildInfo and tostring(GetBuildInfo()):match("^1%.60%.")~=nil
end
function Policy.IsUnverified(item)
    if not item then return false end
    local id=Policy.ItemID(item)
    return Policy.IsForever() and item.quality==3 and id and id>=200000 and not Policy.overrides[id] and not Policy.Estimate(item) and not Policy.Observed(item) or false
end
-- User-selected fallback for all new Forever rares, regardless of acquisition.
-- Low-level distributions are estimates; higher brackets use Classic rules.
function Policy.Estimate(item)
    local id=Policy.ItemID(item)
    local level=tonumber(item and item.baseItemLevel)
    if not Policy.IsForever() or not id or id<200000 or item.quality~=3 or not level
        or level<5 or level>99 or (item.classID~=2 and item.classID~=4) then return end
    local rows={approximate=true,foreverCraftEstimate=true}
    local function add(material,chance,minimum,maximum)
        rows[#rows+1]={itemID=material,chance=chance,minQuantity=minimum or 1,maxQuantity=maximum or minimum or 1}
    end
    local weapon=item.classID==2
    if level<=15 then
        add(10940,weapon and 20 or 80,2,3)
        add(10938,weapon and 80 or 20,2,3)
    elseif level<=20 then
        add(10940,weapon and 20 or 75,3,4)
        add(10939,weapon and 75 or 20,2,3)
        add(10978,5,2)
    elseif level<=25 then add(10978,100)
    elseif level<=30 then add(11084,100)
    elseif level<=35 then add(11138,100)
    elseif level<=40 then add(11139,100)
    elseif level<=45 then add(11177,100)
    elseif level<=50 then add(11178,100)
    elseif level<=55 then add(14343,100)
    else add(14344,99.5); add(20725,0.5) end
    return rows
end
function Policy.HasSalvagerBuff()
    if not Policy.IsForever() then return false end
    if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
        local ok,aura=pcall(C_UnitAuras.GetPlayerAuraBySpellID,1283701)
        return ok and type(aura)=="table"
    end
    if AuraUtil and AuraUtil.FindAuraBySpellID then return AuraUtil.FindAuraBySpellID(1283701,"player","HELPFUL")~=nil end
    return false
end
function Policy.SalvagerActive()
    if not Policy.IsForever() then return false end
    local settings=ns.App and ns.App.db or {}
    if settings.salvagerMode=="off" then return false end
    if settings.salvagerMode=="on" then return true end
    return Policy.HasSalvagerBuff()
end
local function sampleKey(item, boosted)
    local id=Policy.ItemID(item)
    if not id or type(item)~="table" then return end
    local version,build=GetBuildInfo()
    return table.concat({version or "",build or "",id,item.quality or 0,item.baseItemLevel or 0,item.classID or 0,boosted and "salvager" or "normal"},":")
end
function Policy.Record(item, materials, boosted)
    if not Policy.IsForever() then return end
    local key=sampleKey(item,boosted)
    local db=ns.App and ns.App.db
    if not key or not db then return end
    local output={}
    for id,quantity in pairs(materials or {}) do
        if type(id)~="number" or id<=0 or type(quantity)~="number" or quantity<=0 or quantity>10000 or quantity~=math.floor(quantity) then return end
        output[id]=quantity
    end
    if not next(output) then return end
    if type(db.disenchantSamples)~="table" then db.disenchantSamples={} end
    local sample=db.disenchantSamples[key]
    if type(sample)~="table" or type(sample.count)~="number" or type(sample.materials)~="table" then sample={count=0,materials={}}; db.disenchantSamples[key]=sample end
    sample.count=sample.count+1
    for id,quantity in pairs(output) do
        local material=sample.materials[id] or {total=0,hits=0,min=quantity,max=quantity}
        material.total,material.hits=material.total+quantity,material.hits+1
        material.min,material.max=math.min(material.min,quantity),math.max(material.max,quantity)
        sample.materials[id]=material
    end
end
function Policy.Observed(item)
    if not Policy.IsForever() then return end
    local key=sampleKey(item,Policy.SalvagerActive())
    local db=ns.App and ns.App.db
    local sample=key and db and type(db.disenchantSamples)=="table" and db.disenchantSamples[key]
    -- Small samples are collected but never advertised as reliable loot tables.
    if type(sample)~="table" or type(sample.count)~="number" or sample.count<20 or sample.count>10000000 or type(sample.materials)~="table" then return end
    local rows={empirical=true,approximate=true,samples=sample.count}
    for id,data in pairs(sample.materials) do
        if type(id)=="number" and type(data)=="table" and type(data.hits)=="number" and data.hits>0 and data.hits<=sample.count
            and type(data.total)=="number" and data.total>0 and type(data.min)=="number" and type(data.max)=="number" then
            rows[#rows+1]={itemID=id,chance=100*data.hits/sample.count,minQuantity=data.min,maxQuantity=data.max,meanQuantity=data.total/data.hits}
        else return end
    end
    if #rows==0 then return end
    table.sort(rows,function(a,b) return a.itemID<b.itemID end)
    return rows
end
function Policy.BonusPercent()
    if not Policy.SalvagerActive() then return 0 end
    local value=tonumber(ns.App and ns.App.db and ns.App.db.salvagerBonusPercent) or 0
    return value==value and math.max(0,math.min(1000,value)) or 0
end
function Policy.MatchesMaterial(item, id)
    id=tonumber(id)
    if not id or id==0 then return true end
    for _, result in ipairs(ns.DisenchantResults.Get(item) or {}) do
        if result.itemID==id and result.chance>0 then return true end
    end
    return false
end
function Policy.MaterialIDs()
    local ids = {10940,10938,10939,10978,10998,11083,11082,11084,11134,11138,11137,11135,11139,
        11174,11177,11176,11175,11178,16202,14343,16204,16203,14344,20725,
        22445,22447,22448,22446,22449,22450,34054,34056,34053,34055,34052,34057,
        219946,219947,219948,219949,219950,219951,219952,219954,219955,
        243599,243600,243602,243603,243605,243606}
    local seen={}
    for _,id in ipairs(ids) do seen[id]=true end
    local db=ns.App and ns.App.db
    for _,sample in pairs(db and type(db.disenchantSamples)=="table" and db.disenchantSamples or {}) do
        for id in pairs(type(sample)=="table" and type(sample.materials)=="table" and sample.materials or {}) do
            if type(id)=="number" and id>0 and not seen[id] then ids[#ids+1]=id; seen[id]=true end
        end
    end
    return ids
end

-- Values are per item, before auction fees, with the selected selling alternative.
function Policy.Profit(item)
    if not item then return end
    local value=ns.DisenchantResults.ExpectedValue(item)
    local db=ns.App.db
    local base
    local getInfo=ns.App.GetItemInfoSafe or (C_Item and C_Item.GetItemInfo) or GetItemInfo
    local bind=item.bindType or (getInfo and select(14,getInfo(item.link)))
    local source=(db.listPriceSource=="vendor" or bind==1 or bind==4 or item.isBound) and "vendor" or "auction"
    if source=="vendor" then base=getInfo and select(11,getInfo(item.link))
    else base=item.priceCopper or ns.Prices.GetValue(item.link) end
    if not value or not base then return value,nil,base,source end
    return value,value-base,base,source
end

end
LoadComponent("ForeverTools", FT.disenchantry)
