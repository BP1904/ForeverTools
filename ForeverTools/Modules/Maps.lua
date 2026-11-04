-- Independent map enhancements for Forever's MapCanvas API.
local _, FT = ...
local M = {
    title = "Karten: Leatrix-Stil",
    description = "Karte aufdecken, Orte und Koordinaten anzeigen. Ziehen an der oberen Titelleiste; Größe über die Aktionen ändern.",
    defaults = {reveal=true, tint=true, dungeons=true, flights=true, travel=true,
        spirits=false, opposing=false, coordinates=true, zoneLevels=true, noFade=true,
        noBlackout=true, unlock=true, scale=1},
    options = {
        {key="reveal", title="Unerforschte Gebiete auf der Weltkarte aufdecken"},
        {key="tint", title="Unerforschte Gebiete blau markieren"},
        {key="dungeons", title="Instanzen und Schlachtzüge anzeigen"},
        {key="flights", title="Flugpunkte beider Fraktionen anzeigen"},
        {key="travel", title="Schiffe, Zeppeline, Tiefenbahn und Portale"},
        {key="spirits", title="Geistheiler anzeigen"},
        {key="opposing", title="Auch Reiseorte der gegnerischen Fraktion anzeigen"},
        {key="coordinates", title="Spieler- und Mauskoordinaten anzeigen"},
        {key="zoneLevels", title="Gebietsstufen oben beim Darüberfahren anzeigen"},
        {key="noFade", title="Karte beim Laufen sichtbar lassen"},
        {key="noBlackout", title="Schwarzen Hintergrund im Vollbild ausblenden"},
        {key="unlock", title="Karte an der oberen Titelleiste verschieben"},
    },
}
FT:RegisterModule("maps", M)

local function Combat() return InCombatLockdown and InCombatLockdown() end
local function Loaded(name)
    local api = C_AddOns or _G
    return api.IsAddOnLoaded and api.IsAddOnLoaded(name)
end
function M:Active()
    -- Never run two owners of the same map enhancements at once.
    return FT:IsEnabled("maps") and not Loaded("Leatrix_Maps")
end
local function Mode(map) return map.IsMaximized and map:IsMaximized() and "full" or "window" end
local function Points(frame)
    local result = {}
    for i=1, frame:GetNumPoints() do result[i] = {frame:GetPoint(i)} end
    return result
end
local function SetPoints(frame, points)
    frame:ClearAllPoints()
    for _, point in ipairs(points) do frame:SetPoint(unpack(point)) end
end

-- Persist original CVars across /reload so disabling restores the user's settings.
-- Turning an individual option off also releases the CVar instead of forcing a value.
function M:UpdateCVars()
    local api = C_CVar or _G
    if not api.GetCVar or not api.SetCVar then return end
    self.settings.originalCVars = self.settings.originalCVars or {}
    local saved = self.settings.originalCVars
    local active = self:Active()
    local desired = {
        worldMapShowPlayerCoords = active and self.settings.coordinates and "1" or false,
        worldMapShowCursorCoords = active and self.settings.coordinates and "1" or false,
        mapFade = active and self.settings.noFade and "0" or false,
        showDungeonEntrancesOnMap = active and self.settings.dungeons and "0" or false,
    }
    for name, value in pairs(desired) do
        local ok, current = pcall(api.GetCVar, name)
        if ok and current ~= nil then
            if value then
                if saved[name] == nil then saved[name] = current end
                if current ~= value then pcall(api.SetCVar, name, value) end
            elseif saved[name] ~= nil then
                pcall(api.SetCVar, name, saved[name]); saved[name] = nil
            end
        end
    end
end

function M:ApplyLayout()
    if self.applying or self.dragging or not self.map then return end
    if Combat() then self.pending = true; return end
    self.applying = true
    local map = self.map
    local mode = Mode(map)
    local active = self:Active()
    local state = self.layout[mode]
    if not state then
        state = {points=Points(map), scale=self.originalScale}
        self.layout[mode] = state
    end
    local scale = tonumber(self.settings.scale) or 1
    scale = math.max(0.5, math.min(1.5, scale))
    map:SetScale(active and state.scale * scale or state.scale)
    if active and self.settings.unlock then
        if not self.movement then
            self.movement = {movable=map:IsMovable(), clamped=map:IsClampedToScreen()}
        end
        map:SetMovable(true); map:SetClampedToScreen(true)
        local position = self.settings[mode .. "Position"]
        if type(position)=="table" and type(position[3])=="number" and type(position[4])=="number" then
            map:ClearAllPoints()
            map:SetPoint(position[1], UIParent, position[2], position[3], position[4])
        end
        self.handle:Show()
        state.moved = true
    else
        self.handle:Hide()
        if self.dragging then map:StopMovingOrSizing(); self.dragging = false end
        if state.moved then SetPoints(map, state.points); state.moved = nil end
        if self.movement then
            map:SetMovable(self.movement.movable)
            map:SetClampedToScreen(self.movement.clamped)
            self.movement = nil
        end
    end
    local blackout = map.BlackoutFrame
    if blackout then
        if active and self.settings.noBlackout then
            if not self.blackout then
                self.blackout = {alpha=blackout:GetAlpha(), mouse=blackout:IsMouseEnabled()}
            end
            blackout:SetAlpha(0); blackout:EnableMouse(false)
        elseif self.blackout then
            blackout:SetAlpha(self.blackout.alpha); blackout:EnableMouse(self.blackout.mouse)
            self.blackout = nil
        end
    end
    self.applying = false
end

local function TileKey(w,h,x,y) return w .. ":" .. h .. ":" .. x .. ":" .. y end
local function FileSize(pixels)
    local size=16
    while size<pixels do size=size*2 end
    return size
end
function M:Reveal(pin)
    local textures = self.reveals[pin]
    if not textures then textures={}; self.reveals[pin]=textures end
    for _, texture in ipairs(textures) do texture:Hide() end
    if not self:Active() or not self.settings.reveal or not C_Map or not C_MapExplorationInfo then return end
    local map = pin:GetMap()
    if map ~= self.map then return end
    local mapID = map:GetMapID()
    if not mapID then return end
    local artID = C_Map.GetMapArtID(mapID)
    local tiles = FT.mapReveal and FT.mapReveal[artID]
    if not tiles then return end
    local container = map:GetCanvasContainer()
    -- GetMapID can return the player's map before the first map opening.
    -- The native layer lookup needs zoomLevels, which do not exist yet then.
    if not container or not container.GetCurrentLayerIndex
        or (container.HasZoomLevels and not container:HasZoomLevels())
        or (container.zoomLevels and not next(container.zoomLevels)) then
        self.contentPending = true
        return
    end
    local layers = C_Map.GetMapArtLayers(mapID)
    if not layers then self.contentPending = true; return end
    local index = container:GetCurrentLayerIndex()
    local layer = layers and layers[index]
    if not layer or not layer.tileWidth or not layer.tileHeight then self.contentPending = true; return end
    local tw, th = layer.tileWidth, layer.tileHeight
    if tw<=0 or th<=0 then return end
    local explored = {}
    for _, tile in ipairs(C_MapExplorationInfo.GetExploredMapTextures(mapID) or {}) do
        explored[TileKey(tile.textureWidth,tile.textureHeight,tile.offsetX,tile.offsetY)] = true
    end
    local used=0
    for _, tile in ipairs(tiles) do
        local w,h,x,y,files = unpack(tile)
        if not explored[TileKey(w,h,x,y)] then
            local cols=math.ceil(w/tw)
            for row=0, math.ceil(h/th)-1 do
                for col=0, cols-1 do
                    local file=files[row*cols+col+1]
                    if file then
                        used=used+1
                        local texture=textures[used]
                        if not texture then
                            texture=pin:CreateTexture(nil,"ARTWORK",nil,-1)
                            textures[used]=texture
                        end
                        local pw,ph=math.min(tw,w-col*tw),math.min(th,h-row*th)
                        texture:ClearAllPoints()
                        texture:SetPoint("TOPLEFT",pin,"TOPLEFT",x+col*tw,-y-row*th)
                        texture:SetSize(pw,ph)
                        texture:SetTexCoord(0,pw/FileSize(pw),0,ph/FileSize(ph))
                        texture:SetTexture(file,nil,nil,"TRILINEAR")
                        if self.settings.tint then texture:SetVertexColor(0.6,0.6,1,1)
                        else texture:SetVertexColor(1,1,1,1) end
                        texture:Show()
                    end
                end
            end
        end
    end
end

function M:IsZoneMap()
    local mapID=self.map:GetMapID()
    local info=mapID and C_Map and C_Map.GetMapInfo(mapID)
    local types=Enum and Enum.UIMapType
    return info and info.mapType==(types and types.Zone or 3)
end

function M:POIRows()
    local rows={}
    local marker=self.trainerMarker
    if marker and marker.mapID==self.map:GetMapID() then
        rows[#rows+1]={"TrainingTarget",marker.x*100,marker.y*100,marker.title or "Waffenmeister",0,0}
    end
    local zone=self:IsZoneMap()
    for _, row in ipairs(FT.mapPOI and FT.mapPOI[self.map:GetMapID()] or {}) do
        if zone or not row[1]:match("^Flight") then rows[#rows+1]=row end
    end
    if not zone then return rows end
    -- The client's taxi database also includes Forever locations absent from the snapshot.
    local api=C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap
    local mapID=self.map:GetMapID()
    local nodes=api and api(mapID) or {}
    local rect
    -- Some maps expose taxi data only on their parent continent.
    if api and #(nodes or {})==0 and C_Map.GetMapRectOnMap then
        local info=C_Map.GetMapInfo(mapID)
        local seen={[mapID]=true}
        while info and info.parentMapID and info.parentMapID>0 and not seen[info.parentMapID] do
            local parentID=info.parentMapID
            seen[parentID]=true
            local parentNodes=api(parentID)
            local minX,maxX,minY,maxY=C_Map.GetMapRectOnMap(mapID,parentID)
            if parentNodes and #parentNodes>0 and minX and maxX and minY and maxY and maxX>minX and maxY>minY then
                nodes=parentNodes; rect={minX,maxX,minY,maxY}; break
            end
            info=C_Map.GetMapInfo(parentID)
        end
    end
    local factions=Enum and Enum.FlightPathFaction or {Alliance=2,Horde=1}
    for _, node in ipairs(nodes or {}) do
        local x,y
        if node.position and node.position.GetXY then x,y=node.position:GetXY() end
        if rect and type(x)=="number" and type(y)=="number" then
            x=(x-rect[1])/(rect[2]-rect[1]); y=(y-rect[3])/(rect[4]-rect[3])
        end
        if type(x)=="number" and type(y)=="number" and x>=0 and x<=1 and y>=0 and y<=1 then
            local kind=node.faction==factions.Alliance and "FlightA" or node.faction==factions.Horde and "FlightH" or "FlightN"
            x,y=x*100,y*100
            for i=#rows,1,-1 do
                local row=rows[i]
                if row[1]==kind and math.abs(row[2]-x)<1 and math.abs(row[3]-y)<1 then table.remove(rows,i) end
            end
            rows[#rows+1]={kind,x,y,node.name or "Flugpunkt",0,0,node.atlasName}
        end
    end
    return rows
end

local categories = {
    Dungeon={"dungeons","Dungeon","Instanz"}, Raid={"dungeons","Raid","Schlachtzug"},
    Dunraid={"dungeons","Dungeon","Instanz / Schlachtzug"},
    Flight={"flights","TaxiNode_Neutral","Flugpunkt"},
    Travel={"travel","TaxiNode_Neutral","Schiff / Zeppelin / Tiefenbahn"},
    Portal={"travel","MagePortalAlliance","Portal"},
    Spirit={"spirits","Vehicle-TempleofKotmogu-GreenBall","Geistheiler"},
}
function M:ShowPOI(row)
    local kind=row[1]
    if kind=="TrainingTarget" then return {"","TaxiNode_Neutral","Ausgewählter Lehrer"},"TaxiNode_Neutral" end
    local base=kind:gsub("[AHN]$", "")
    local category=categories[base]
    if not category or not self.settings[category[1]] then return end
    local faction=UnitFactionGroup and UnitFactionGroup("player")
    local suffix=kind:sub(-1)
    if base~="Flight" and not self.settings.opposing and ((suffix=="A" and faction=="Horde") or (suffix=="H" and faction=="Alliance")) then return end
    local atlas=category[2]
    if base=="Flight" then
        atlas=suffix=="A" and "TaxiNode_Alliance" or suffix=="H" and "TaxiNode_Horde" or atlas
    end
    return category, row[7] and row[7]~="" and row[7] or atlas
end
local PIN_TEMPLATE="ForeverToolsMapPinTemplate"
_G.ForeverToolsMapPinMixin={}
local Pin=_G.ForeverToolsMapPinMixin
function Pin:OnLoad()
    self:UseFrameLevelType("PIN_FRAME_LEVEL_FLIGHT_POINT")
    self:SetScalingLimits(1,1,1)
end
function Pin:OnAcquired(row,category,atlas)
    self.row=row; self.category=category
    self.icon:SetAtlas(atlas)
    -- Pooled pins may switch faction or become another kind of location.
    self.icon:SetDesaturated(false)
    self.icon:SetVertexColor(1,1,1,1)
    if row[1]=="FlightH" then
        self.icon:SetDesaturated(true)
        self.icon:SetVertexColor(1,0.15,0.15,1)
    elseif row[1]=="FlightA" then
        self.icon:SetDesaturated(true)
        self.icon:SetVertexColor(0.15,0.45,1,1)
    elseif row[1]=="TrainingTarget" then
        self.icon:SetDesaturated(true)
        self.icon:SetVertexColor(0.3,1,0.4,1)
    end
    self:SetAlpha(1)
    self:SetFrameStrata("HIGH")
    self:SetPosition(row[2]/100,row[3]/100)
    self:ApplyCurrentScale()
end
function M:SetTrainerMarker(target)
    if Combat() or not self:Active() or type(target)~="table" or type(target.mapID)~="number" or target.mapID<=0
        or type(target.x)~="number" or type(target.y)~="number"
        or not (target.x>=0 and target.x<=1 and target.y>=0 and target.y<=1) then return false end
    self:Attach()
    if not self.map then return false end
    if self.map:GetMapID()~=target.mapID and self.map.SetMapID then self.map:SetMapID(target.mapID) end
    if self.map:GetMapID()~=target.mapID then return false end
    self.trainerMarker={mapID=target.mapID,x=target.x,y=target.y,title=target.title}
    self:RefreshPOI(); self.dirty=true
    if not self.map:IsShown() then self.map:Show() end
    return true
end
function Pin:OnMouseEnter()
    if not M.tooltip then return end
    local tooltip=M.tooltip
    M.tooltipPin=self
    tooltip:SetOwner(self,"ANCHOR_RIGHT")
    tooltip:AddLine(self.row[4],1,0.82,0)
    tooltip:AddLine(self.category[3],1,1,1)
    tooltip:AddLine(("%.1f, %.1f"):format(self.row[2],self.row[3]),1,1,1)
    if self.row[5]>0 then tooltip:AddLine(("Stufe %d–%d"):format(self.row[5],self.row[6]),1,1,1) end
    tooltip:Show()
end
function Pin:OnMouseLeave()
    if M.tooltip and M.tooltip:IsOwned(self) then M.tooltip:Hide() end
    if M.tooltipPin==self then M.tooltipPin=nil end
end
function Pin:OnReleased()
    self:OnMouseLeave()
    MapCanvasPinMixin.OnReleased(self)
end
function M:RefreshPOI()
    local map=self.map
    map:RemoveAllPinsByTemplate(PIN_TEMPLATE)
    self.pois={}
    if not self:Active() then return end
    local canvas=map:GetCanvas()
    local container=map:GetCanvasContainer()
    if canvas:GetWidth()<=0 or canvas:GetHeight()<=0
        or (container.HasZoomLevels and not container:HasZoomLevels())
        or (container.zoomLevels and not next(container.zoomLevels)) then
        self.contentPending=true; return
    end
    for _, row in ipairs(self:POIRows()) do
        local category, atlas=self:ShowPOI(row)
        if category then
            local pin=map:AcquirePin(PIN_TEMPLATE,row,category,atlas)
            self.pois[#self.pois+1]=pin
        end
    end
end

function M:RefreshContent()
    if not self.map then return end
    self.contentPending=false
    -- Independent displays must not depend on exploration being initialized.
    self:RefreshPOI()
    if self.map.EnumeratePinsByTemplate then
        for pin in self.map:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
            if not self.hookedPins[pin] and hooksecurefunc then
                self.hookedPins[pin]=true
                hooksecurefunc(pin,"RefreshOverlays",function(p) M:Reveal(p) end)
            end
            self:Reveal(pin)
        end
    end
end
function M:DecorateAreaLabel(label)
    local current=label:GetHighestPriorityLabelInfo()
    local name=current and current.name
    label.Name:SetText(name or "")
    if not name or not self:Active() or not self.settings.zoneLevels then return end
    local areaType=MAP_AREA_LABEL_TYPE and MAP_AREA_LABEL_TYPE.AREA_NAME
    if not areaType or current~=label.labelInfoByType[areaType] then return end
    local map=self.map
    if not map:IsCanvasMouseFocus() then return end
    local x,y=map:GetNormalizedCursorPosition()
    if not x or not y or x<0 or x>1 or y<0 or y>1 then return end
    local mapID=map:GetMapID()
    local info=C_Map.GetMapInfoAtPosition(mapID,x,y) or C_Map.GetMapInfo(mapID)
    local levels=info and FT.mapLevels and FT.mapLevels[info.mapID]
    if not levels then return end
    if info.mapID~=mapID then name=info.name end
    -- Preserve an existing native level range instead of appending it twice.
    if name:find("%(%d+%-%d+%)") or name:find("%(%d+%)") then return end
    label.Name:SetText(("%s (%d–%d)"):format(name,levels[1],levels[2]))
end
function M:UpdateZoneLabel()
    if not self.map then return end
    for provider in pairs(self.map.dataProviders or {}) do
        local label=provider.Label
        if label and label.Name and label.EvaluateLabels and label.GetHighestPriorityLabelInfo then
            if not self.hookedLabels[label] then
                self.hookedLabels[label]=true
                hooksecurefunc(label,"EvaluateLabels",function(frame) M:DecorateAreaLabel(frame) end)
            end
            self:DecorateAreaLabel(label)
        end
    end
end

function M:StartDragging()
    if not self.map or not self:Active() or not self.settings.unlock or Combat() then return end
    self.dragging=true
    self.map:StartMoving()
end
function M:StopDragging()
    if not self.dragging then return end
    local map=self.map
    map:StopMovingOrSizing(); self.dragging=false
    local point,relative,relativePoint,x,y=map:GetPoint()
    if map.SetUserPlaced then map:SetUserPlaced(self.originalUserPlaced) end
    if point and (not relative or relative==UIParent) then
        self.settings[Mode(map).."Position"]={point,relativePoint,x,y}
    end
    self:ApplyLayout()
end

function M:Attach()
    local map=WorldMapFrame
    if self.map or not map or not map.GetMapID then return end
    if Combat() then self.pending=true; return end
    self.map=map; self.layout={}; self.originalScale=map:GetScale()
    self.originalUserPlaced=map.IsUserPlaced and map:IsUserPlaced() or false
    self.tooltip=CreateFrame("GameTooltip","ForeverToolsMapTooltip",UIParent,"GameTooltipTemplate")
    self.tooltip:SetFrameStrata("TOOLTIP")
    self.provider=CreateFromMixins(MapCanvasDataProviderMixin)
    self.provider.RefreshAllData=function() M:RefreshPOI(); M:UpdateZoneLabel() end
    self.provider.RemoveAllData=function() map:RemoveAllPinsByTemplate(PIN_TEMPLATE) end
    map:AddDataProvider(self.provider)
    local titleParent=map.BorderFrame or map
    local handle=CreateFrame("Frame",nil,titleParent)
    self.handle=handle
    -- Above the native title artwork; leave portrait and close/maximize buttons free.
    handle:SetPoint("TOPLEFT",map,"TOPLEFT",64,-2)
    handle:SetPoint("TOPRIGHT",map,"TOPRIGHT",-90,-2)
    handle:SetHeight(26)
    handle:SetFrameLevel(titleParent:GetFrameLevel()+20)
    handle:EnableMouse(true)
    handle:RegisterForDrag("LeftButton")
    handle:SetScript("OnDragStart",function() M:StartDragging() end)
    handle:SetScript("OnDragStop",function() M:StopDragging() end)
    map:HookScript("OnShow",function() M:ApplyLayout(); M:RefreshContent() end)
    map:HookScript("OnSizeChanged",function() M.dirty=true end)
    map:HookScript("OnHide",function()
        M:StopDragging()
    end)
    if hooksecurefunc then
        for _,method in ipairs({"SynchronizeDisplayState","OnFrameSizeChanged"}) do
            if map[method] then hooksecurefunc(map,method,function() M:ApplyLayout(); M.dirty=true end) end
        end
        for _,method in ipairs({"OnMapChanged","OnCanvasScaleChanged","OnCanvasSizeChanged"}) do
            if map[method] then hooksecurefunc(map,method,function() M.dirty=true end) end
        end
    end
    self:ApplyLayout(); self:RefreshContent()
end
function M:OnSettingsChanged()
    if not self.settings then return end
    if self.dragging and (not self:Active() or not self.settings.unlock) then self:StopDragging() end
    self:UpdateCVars()
    self:Attach(); self:ApplyLayout(); self:RefreshContent(); self:UpdateZoneLabel()
end
function M:Resize(delta)
    self.settings.scale=math.max(0.5,math.min(1.5,(tonumber(self.settings.scale) or 1)+delta))
    self:ApplyLayout()
    FT:Print(("Kartengröße: %.0f%%"):format(self.settings.scale*100))
end
function M:Reset()
    if Combat() then FT:Print("Kartenposition bitte nach dem Kampf zurücksetzen."); return end
    self.settings.windowPosition=nil; self.settings.fullPosition=nil; self.settings.scale=1
    if self.map then
        local state=self.layout[Mode(self.map)]
        if state then SetPoints(self.map,state.points) end
    end
    self:ApplyLayout()
end
M.actions = {
    {title="Karte kleiner (−10%)",run=function() M:Resize(-0.1) end},
    {title="Karte größer (+10%)",run=function() M:Resize(0.1) end},
    {title="Kartenposition und Größe zurücksetzen",run=function() M:Reset() end},
}
function M:Initialize()
    self.reveals={}; self.hookedPins={}; self.pois={}; self.hookedLabels={}
    local events=CreateFrame("Frame")
    for _, event in ipairs({"ADDON_LOADED","PLAYER_ENTERING_WORLD","PLAYER_REGEN_ENABLED","MAP_EXPLORATION_UPDATED","TAXI_NODE_STATUS_CHANGED"}) do events:RegisterEvent(event) end
    events:SetScript("OnEvent",function(_,event,name)
        if event=="ADDON_LOADED" and name=="Leatrix_Maps" then
            FT:Print("Leatrix Maps ist aktiv. Das ForeverTools-Kartenmodul pausiert, solange die Einzelversion geladen ist.")
        end
        M:OnSettingsChanged()
    end)
    local elapsed=0
    events:SetScript("OnUpdate",function(_,delta)
        elapsed=elapsed+delta
        if elapsed<0.2 then return end
        elapsed=0
        if not M.map then M:Attach() end
        if M.pending and not Combat() then M.pending=nil; M:ApplyLayout() end
        if M.map and M.map:IsShown() then
            M:UpdateZoneLabel()
            -- Discover replacement exploration pins after map transitions.
            if M.dirty or M.contentPending or M.lastMapID~=M.map:GetMapID() then
                M.lastMapID=M.map:GetMapID(); M.dirty=nil; M:RefreshContent()
            end
        end
    end)
    self:OnSettingsChanged()
    if Loaded("Leatrix_Maps") then
        FT:Print("Leatrix Maps ist aktiv. Für die integrierten Kartenfunktionen die Einzelversion deaktivieren und /reload eingeben.")
    end
end
