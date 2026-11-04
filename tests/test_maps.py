"""Map geometry, lifecycle, click-through pins, settings and native restoration."""
import unittest
import xml.etree.ElementTree as ET
from test_forevertools import ROOT, MOCK, LuaRuntime

MAP_MOCK = r'''
MAP_AREA_LABEL_TYPE={AREA_NAME=3,POI=4}
MapCanvasDataProviderMixin={OnAdded=function(self,map) self.map=map end}
MapCanvasPinMixin={OnReleased=function() end}
function CreateFromMixins(...)
    local result={}
    for _,mixin in ipairs({...}) do for k,v in pairs(mixin) do result[k]=v end end
    return result
end
local makeFrame=CreateFrame
function CreateFrame(...)
    local f=makeFrame(...)
    f.points={}; f.scale=1; f.alpha=1; f.width=1000; f.height=668
    function f:Show() self:SetShown(true) end
    function f:Hide() self:SetShown(false) end
    function f:HookScript(event,callback)
        local old=self.scripts[event]
        self:SetScript(event,function(...) if old then old(...) end; callback(...) end)
    end
    function f:SetPoint(...) self.points[#self.points+1]={...} end
    function f:ClearAllPoints() self.points={} end
    function f:GetPoint(i) return unpack(self.points[i or 1] or {}) end
    function f:GetNumPoints() return #self.points end
    function f:SetScale(v) assert(not combat); self.scale=v end
    function f:GetScale() return self.scale end
    function f:SetFrameLevel(v) self.level=v end
    function f:GetFrameLevel() return self.level or 1 end
    function f:GetWidth() return self.width end
    function f:GetHeight() return self.height end
    function f:SetSize(w,h) self.width=w; self.height=h end
    function f:SetAlpha(v) self.alpha=v end
    function f:GetAlpha() return self.alpha end
    function f:SetMovable(v) self.movable=v end
    function f:IsMovable() return self.movable or false end
    function f:SetClampedToScreen(v) self.clamped=v end
    function f:IsClampedToScreen() return self.clamped or false end
    function f:EnableMouse(v) self.mouse=v end
    function f:IsMouseEnabled() return self.mouse or false end
    function f:SetMouseMotionEnabled(v) self.mouseMotion=v end
    function f:StartMoving() self.moving=true end
    function f:StopMovingOrSizing() self.moving=false end
    function f:CreateTexture() return CreateFrame() end
    function f:SetAllPoints() end
    function f:SetText(t) self.text=t end
    function f:SetAtlas(v) self.atlas=v end
    function f:SetDesaturated(v) self.desaturated=v end
    function f:SetTexture(v) self.file=v end
    function f:SetTexCoord(...) self.uv={...} end
    function f:SetVertexColor(...) self.color={...} end
    function f:SetOwner(v) self.owner=v end
    function f:IsOwned(v) return self.owner==v end
    function f:AddLine(t) self.text=t end
    return f
end
function hooksecurefunc(object,method,callback)
    local old=assert(object[method])
    object[method]=function(...) local value=old(...); callback(...); return value end
end
cvars={worldMapShowPlayerCoords='0',worldMapShowCursorCoords='0',mapFade='1',showDungeonEntrancesOnMap='1'}
C_CVar={GetCVar=function(k) return cvars[k] end, SetCVar=function(k,v) cvars[k]=v end}
legacy=false
C_AddOns={IsAddOnLoaded=function(name) return name=='Leatrix_Maps' and legacy end}
function UnitFactionGroup() return 'Alliance' end
explored={}
C_Map={GetMapArtID=function() return artID or 999 end,
    GetMapArtLayers=function() return {{tileWidth=256,tileHeight=256}} end,
    GetMapInfo=function(id) return {mapID=id,name='Elwynn',mapType=3} end,
    GetMapInfoAtPosition=function() return {mapID=1411,name='Durotar'} end}
C_MapExplorationInfo={GetExploredMapTextures=function() return explored end}
function MakeMap()
    WorldMapFrame=CreateFrame()
    local map=WorldMapFrame
    map.id=1429; map.zoom=1
    map.activePins={}; map.freePins={}
    function map:AddDataProvider(provider) self.dataProviders[provider]=true; provider:OnAdded(self) end
    function map:RemoveAllPinsByTemplate(template)
        assert(template=='ForeverToolsMapPinTemplate')
        for _,pin in ipairs(self.activePins) do
            pin:OnReleased(); pin:Hide(); self.freePins[#self.freePins+1]=pin
        end
        self.activePins={}
    end
    function map:AcquirePin(template,...)
        assert(template=='ForeverToolsMapPinTemplate')
        local pin=table.remove(self.freePins)
        if not pin then
            pin=CreateFrame()
            pin.icon=pin:CreateTexture()
            pin.mouse=false; pin.mouseMotion=true
            for k,v in pairs(ForeverToolsMapPinMixin) do pin[k]=v end
            function pin:UseFrameLevelType(v) self.frameLevelType=v end
            function pin:SetScalingLimits(...) self.scaling={...} end
            function pin:SetPosition(x,y) self.x=x; self.y=y end
            function pin:ApplyCurrentScale() self.scale=1/map.zoom end
            pin:OnLoad()
        end
        pin:OnAcquired(...); pin:Show()
        self.activePins[#self.activePins+1]=pin
        return pin
    end
    function map:RefreshNativeProviders()
        for provider in pairs(self.dataProviders) do
            if provider.RefreshAllData then provider:RefreshAllData() end
        end
    end
    map.area=CreateFrame()
    map.area.Name=CreateFrame()
    map.area.labelInfoByType={}
    function map.area:GetHighestPriorityLabelInfo()
        return self.labelInfoByType[4] or self.labelInfoByType[3]
    end
    function map.area:SetLabel(kind,name)
        self.labelInfoByType[kind]=name and {name=name} or nil
    end
    function map.area:EvaluateLabels()
        local current=self:GetHighestPriorityLabelInfo()
        self.Name:SetText(current and current.name or '')
    end
    map.area:SetLabel(3,'Durotar')
    map.dataProviders={[{Label=map.area}]=true}
    function map:IsCanvasMouseFocus() return hover end
    function map:GetNormalizedCursorPosition() return 0.5,0.5 end
    map:SetPoint('TOPLEFT',UIParent,'TOPLEFT',16,-94)
    map.canvas=CreateFrame(); map.container=CreateFrame(); map.ScrollContainer=CreateFrame()
    map.container.zoomLevels={{scale=1,layerIndex=1}}
    function map.container:HasZoomLevels() return self.zoomLevels~=nil end
    function map.container:GetCurrentLayerIndex()
        for _,zoom in ipairs(self.zoomLevels) do return zoom.layerIndex end
    end
    function map.ScrollContainer:IsMouseOver() return hover end
    function map.ScrollContainer:GetNormalizedCursorPosition() return 0.5,0.5 end
    function map:GetMapID() return self.id end
    function map:GetCanvas() return self.canvas end
    function map:GetCanvasContainer() return self.container end
    function map:GetCanvasScale() return self.zoom end
    function map:IsMaximized() return self.maximized end
    function map:OnMapChanged() end
    function map:OnCanvasScaleChanged() end
    function map:OnFrameSizeChanged() end
    function map:SynchronizeDisplayState()
        self.BlackoutFrame:Show()
        self:ClearAllPoints(); self:SetPoint('CENTER',UIParent,'CENTER',0,0)
    end
    map.pin=CreateFrame()
    function map.pin:GetMap() return map end
    function map.pin:RefreshOverlays() end
    function map:EnumeratePinsByTemplate()
        local done=false
        return function() if not done then done=true; return self.pin end end
    end
    map.BlackoutFrame=CreateFrame(); map.BlackoutFrame:EnableMouse(true)
    return map
end
'''


class MapsTest(unittest.TestCase):
    def runtime(self, before='MakeMap()'):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + MAP_MOCK)
        lua.execute('namespace={}; ' + before)
        for filename in ['Core.lua', 'Data/Maps.lua', 'Modules/Maps.lua']:
            lua.execute('assert(loadstring(...))("ForeverTools",namespace)',
                        (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8'))
        lua.execute('Fire("ADDON_LOADED","ForeverTools"); M=ForeverTools.modules.maps')
        return lua

    def test_toc_and_data_facts(self):
        for toc in ['ForeverTools.toc', 'ForeverTools_Camelot.toc']:
            text = (ROOT / 'ForeverTools' / toc).read_text(encoding='utf-8')
            self.assertLess(text.index('Data\\Maps.lua'), text.index('Modules\\Maps.lua'))
        lua = self.runtime()
        lua.execute('''
            local arts,pois=0,0
            for _,tiles in pairs(namespace.mapReveal) do
                arts=arts+1
                for _,tile in ipairs(tiles) do
                    assert(#tile[5]==math.ceil(tile[1]/256)*math.ceil(tile[2]/256))
                end
            end
            for _,rows in pairs(namespace.mapPOI) do
                for _,row in ipairs(rows) do
                    pois=pois+1
                    assert(row[2]>=0 and row[2]<=100 and row[3]>=0 and row[3]<=100)
                end
            end
            assert(arts==44 and pois==214 and namespace.mapLevels[2482][1]==60)
        ''')

    def test_training_marker_uses_existing_pin_provider(self):
        self.runtime().execute('''
            assert(M:SetTrainerMarker({mapID=1429,x=0.5,y=0.4,title='Waffenmeister'}))
            local found=false
            for _,pin in ipairs(WorldMapFrame.activePins) do
                if pin.row[1]=='TrainingTarget' then
                    assert(pin.row[4]=='Waffenmeister' and pin.x==0.5 and pin.y==0.4)
                    found=true
                end
            end
            assert(found)
            ForeverTools:SetEnabled('maps',false)
            assert(not M:SetTrainerMarker({mapID=1429,x=0.2,y=0.3,title='Other'}))
            assert(#WorldMapFrame.activePins==0)
        ''')

    def test_reveal_partial_tiles_explored_regions_and_disable(self):
        lua = self.runtime()
        lua.execute('''
            namespace.mapReveal[999]={{300,280,10,20,{1,2,3,4}}}
            M:RefreshContent()
            local textures=M.reveals[WorldMapFrame.pin]
            assert(#textures==4 and textures[4].file==4)
            assert(textures[4].width==44 and textures[4].height==24)
            assert(textures[4].uv[2]==44/64 and textures[4].uv[4]==24/32)
            assert(textures[1].color[1]==0.6)
            M.settings.tint=false; M:OnSettingsChanged(); assert(textures[1].color[1]==1)
            explored={{textureWidth=300,textureHeight=280,offsetX=10,offsetY=20}}
            WorldMapFrame.pin:RefreshOverlays()
            assert(not textures[1]:IsShown())
            explored={}; WorldMapFrame.pin:RefreshOverlays(); assert(textures[4]:IsShown())
            ForeverTools:SetEnabled('maps',false); assert(not textures[1]:IsShown())
        ''')

    def test_cvars_restore_individual_switches_and_survive_reload(self):
        lua = self.runtime()
        lua.execute('''
            assert(cvars.mapFade=='0' and cvars.worldMapShowPlayerCoords=='1')
            M.settings.coordinates=false; M:OnSettingsChanged()
            assert(cvars.worldMapShowPlayerCoords=='0' and cvars.mapFade=='0')
            -- SavedVariables already contains the original pre-reload value.
            M.settings.originalCVars.mapFade='1'; M:UpdateCVars()
            ForeverTools:SetEnabled('maps',false)
            assert(cvars.mapFade=='1' and cvars.showDungeonEntrancesOnMap=='1')
            assert(next(M.settings.originalCVars)==nil)
            ForeverTools:SetEnabled('maps',true); assert(cvars.mapFade=='0')
        ''')

    def test_zoom_poi_faction_and_click_through(self):
        lua = self.runtime()
        lua.execute('''
            namespace.mapPOI[1429]={
                {'FlightA',50,25,'Alliance',0,0}, {'FlightH',70,20,'Horde',0,0},
                {'Spirit',20,30,'Geist',0,0}, {'Dungeon',10,20,'Höhle',10,20}}
            WorldMapFrame.zoom=2; M:RefreshContent()
            assert(M.pois[1].row[4]=='Alliance' and M.pois[2].row[4]=='Horde' and M.pois[3].row[4]=='Höhle')
            assert(M.pois[1].mouse==false and M.pois[1].mouseMotion)
            assert(M.pois[1].scale==0.5 and M.pois[1].x==0.5 and M.pois[1].y==0.25)
            M.settings.opposing=true; M.settings.spirits=true; M:OnSettingsChanged()
            assert(M.pois[2].row[4]=='Horde' and M.pois[3].row[4]=='Geist')
            M.pois[1]:OnMouseEnter(); oldPin=M.pois[1]; assert(M.tooltip:IsOwned(M.pois[1]))
            WorldMapFrame.id=9999; WorldMapFrame:OnMapChanged(); Advance(1)
            assert(#M.pois==0 and not oldPin:IsShown() and not M.tooltip:IsShown())
        ''')

    def test_layout_drag_modes_combat_and_reset(self):
        lua = self.runtime()
        lua.execute('''
            local map=WorldMapFrame
            M:Resize(-0.1); assert(map.scale==0.9)
            map:SetPoint('CENTER',UIParent,'CENTER',55,66)
            map:ClearAllPoints(); map:SetPoint('CENTER',UIParent,'CENTER',55,66)
            M.handle.scripts.OnDragStart(); M.handle.scripts.OnDragStop()
            assert(M.settings.windowPosition[3]==55)
            map.maximized=true; map:SynchronizeDisplayState()
            assert(map.scale==0.9 and M.settings.fullPosition==nil)
            combat=true; M:Resize(-0.1); assert(map.scale==0.9 and M.pending)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); assert(math.abs(map.scale-0.8)<0.001)
            M:Reset(); assert(map.scale==1 and M.settings.windowPosition==nil)
            ForeverTools:SetEnabled('maps',false)
            assert(not M.handle:IsShown() and not map:IsMovable())
            assert(map.BlackoutFrame.alpha==1 and map.BlackoutFrame.mouse)
        ''')

    def test_lazy_load_legacy_conflict_and_missing_map_data(self):
        lua = self.runtime('')
        lua.execute('''
            assert(not M.map)
            MakeMap(); Fire('ADDON_LOADED','Blizzard_WorldMap'); assert(M.map)
            legacy=true; Fire('ADDON_LOADED','Leatrix_Maps')
            assert(not M:Active() and cvars.mapFade=='1' and not M.handle:IsShown())
            legacy=false; M:OnSettingsChanged(); assert(M:Active())
            artID=9999; M:RefreshContent(); assert(not M.reveals[WorldMapFrame.pin][1])
            M:UpdateZoneLabel(); assert(M.map.area.Name.text=='Durotar')
            hover=true; M:UpdateZoneLabel(); assert(M.map.area.Name.text=='Durotar (1–10)')
        ''')

    def test_first_login_without_native_zoom_levels_retries_without_losing_flights(self):
        lua = self.runtime('MakeMap(); WorldMapFrame.container.zoomLevels=nil')
        lua.execute('''
            namespace.mapReveal[999]={{128,128,0,0,{1}}}
            namespace.mapPOI[1429]={{'FlightA',50,25,'Flugpunkt',0,0}}
            M:OnSettingsChanged()
            assert(M.contentPending and not M.reveals[WorldMapFrame.pin][1])
            assert(#M.pois==0)
            hover=true; M:UpdateZoneLabel()
            assert(M.map.area.Name.text=='Durotar (1–10)')
            Advance(2); assert(M.contentPending)
            WorldMapFrame.container.zoomLevels={}
            Advance(1); assert(M.contentPending)
            WorldMapFrame.container.zoomLevels={{scale=1,layerIndex=1}}
            Advance(1)
            assert(not M.contentPending and M.reveals[WorldMapFrame.pin][1]:IsShown())
            assert(M.pois[1]:IsShown())
        ''')

    def test_flights_only_on_zone_maps_and_native_provider_lifecycle(self):
        lua = self.runtime()
        lua.execute('''
            local map=WorldMapFrame
            C_Map.GetMapInfo=function(id) return {mapID=id,name='Karte',mapType=id==1429 and 3 or id==1415 and 2 or 1} end
            namespace.mapPOI[1429]={{'FlightA',50,25,'Flugpunkt',0,0}}
            namespace.mapPOI[1415]={{'FlightA',50,25,'Übersicht',0,0}}
            C_TaxiMap={GetTaxiNodesForMap=function(id) assert(id==1429); return {} end}
            map.id=1415; map:OnMapChanged(); Advance(1); assert(#M.pois==0)
            map.id=947; map:OnMapChanged(); Advance(1); assert(#M.pois==0)
            map.id=1429; map:OnMapChanged(); Advance(1)
            assert(#M.pois==1 and M.pois[1].row[4]=='Flugpunkt')
            assert(M.pois[1].frameLevelType=='PIN_FRAME_LEVEL_FLIGHT_POINT')
            map.zoom=2; map:OnCanvasScaleChanged(); Advance(1); assert(M.pois[1].scale==0.5)
            map:RemoveAllPinsByTemplate('ForeverToolsMapPinTemplate')
            map:RefreshNativeProviders(); assert(#map.activePins==1 and M.pois[1]:IsShown())
            M.settings.flights=false; M:OnSettingsChanged(); assert(#M.pois==0)
            M.settings.flights=true; M:OnSettingsChanged(); assert(#M.pois==1)
            oldPin=M.pois[1]
            ForeverTools:SetEnabled('maps',false); assert(#M.pois==0 and not oldPin:IsShown())
        ''')

    def test_faction_colors_reset_when_pin_is_reused(self):
        lua = self.runtime()
        lua.execute('''
            namespace.mapPOI[1429]={{'FlightH',50,25,'Horde',0,0}}
            M.settings.opposing=true; M:RefreshContent()
            local pin=M.pois[1]
            assert(pin.icon.desaturated and pin.icon.color[1]==1 and pin.icon.color[3]==0.15)
            namespace.mapPOI[1429]={{'FlightA',50,25,'Allianz',0,0}}
            M:RefreshContent(); assert(M.pois[1]==pin)
            assert(pin.icon.desaturated and pin.icon.color[1]==0.15 and pin.icon.color[3]==1)
            namespace.mapPOI[1429]={{'FlightN',50,25,'Neutral',0,0}}
            M:RefreshContent()
            assert(not pin.icon.desaturated and pin.icon.color[1]==1 and pin.icon.color[2]==1)
            namespace.mapPOI[1429]={{'Dungeon',50,25,'Instanz',10,20}}
            M:RefreshContent()
            assert(not pin.icon.desaturated and pin.icon.color[1]==1 and pin.icon.color[3]==1)
        ''')

    def test_hover_levels_decorate_existing_heading_and_restore_without_overriding_poi(self):
        lua = self.runtime()
        lua.execute('''
            local label=WorldMapFrame.area
            assert(not M.zoneOverlay and not M.zoneMarkers)
            hover=true
            label:EvaluateLabels(); assert(label.Name.text=='Durotar (1–10)')
            label:EvaluateLabels(); assert(label.Name.text=='Durotar (1–10)')
            label:SetLabel(4,'Questziel'); label:EvaluateLabels(); assert(label.Name.text=='Questziel')
            label:SetLabel(4,nil); label:EvaluateLabels(); assert(label.Name.text=='Durotar (1–10)')
            hover=false; label:SetLabel(3,nil); label:EvaluateLabels(); assert(label.Name.text=='')
            hover=true; label:SetLabel(3,'Durotar'); label:EvaluateLabels()
            M.settings.zoneLevels=false; M:OnSettingsChanged(); assert(label.Name.text=='Durotar')
            M.settings.zoneLevels=true; M:OnSettingsChanged(); assert(label.Name.text=='Durotar (1–10)')
            ForeverTools:SetEnabled('maps',false); assert(label.Name.text=='Durotar')
        ''')

    def test_live_taxi_nodes_fill_snapshot_gaps_filter_factions_and_avoid_duplicates(self):
        lua = self.runtime()
        lua.execute('''
            local function Pos(x,y) return {GetXY=function() return x,y end} end
            namespace.mapPOI[1429]={{'FlightA',50,25,'Snapshot',0,0}}
            C_TaxiMap={GetTaxiNodesForMap=function(id)
                assert(id==1429)
                return {
                    {name='Aktuell',position=Pos(0.5,0.25),faction=2,atlasName='ClientAtlas'},
                    {name='Neu',position=Pos(0.4,0.3),faction=2,atlasName=''},
                    {name='Gegner',position=Pos(0.6,0.3),faction=1},
                    {name='Neutral',position=Pos(0.2,0.3),faction=0},
                    {name='Außerhalb',position=Pos(2,2),faction=2}}
            end}
            Fire('TAXI_NODE_STATUS_CHANGED')
            assert(#M.pois==4 and M.pois[1].row[4]=='Aktuell' and M.pois[1].icon.atlas=='ClientAtlas')
            assert(M.pois[2].row[4]=='Neu' and M.pois[2].icon.atlas=='TaxiNode_Alliance')
            assert(M.pois[3].row[4]=='Gegner' and M.pois[4].row[4]=='Neutral')
            M.settings.opposing=true; M:OnSettingsChanged(); assert(#M.pois==4)
        ''')

    def test_pin_template_is_virtual_click_through_and_loaded_before_module(self):
        xml=ET.parse(ROOT / 'ForeverTools/Features/Maps.xml').getroot()
        frame=xml.find('{http://www.blizzard.com/wow/ui/}Frame')
        self.assertEqual(frame.attrib['name'],'ForeverToolsMapPinTemplate')
        self.assertEqual(frame.attrib['virtual'],'true')
        self.assertEqual(frame.attrib['enableMouseClicks'],'false')
        for toc in ['ForeverTools.toc','ForeverTools_Camelot.toc']:
            text=(ROOT / 'ForeverTools' / toc).read_text(encoding='utf-8')
            self.assertLess(text.index('Features\\Maps.xml'),text.index('Modules\\Maps.lua'))

    def test_continent_only_client_taxi_data_is_projected_into_zone(self):
        lua = self.runtime()
        lua.execute('''
            namespace.mapPOI[1429]={}
            C_Map.GetMapInfo=function(id)
                return {mapID=id,mapType=id==1429 and 3 or 2,parentMapID=id==1429 and 1415 or 0}
            end
            C_Map.GetMapRectOnMap=function(id,parent)
                assert(id==1429 and parent==1415)
                return 0.2,0.4,0.3,0.5
            end
            C_TaxiMap={GetTaxiNodesForMap=function(id)
                if id==1429 then return {} end
                return {
                    {name='Im Gebiet',faction=2,position={GetXY=function() return 0.3,0.4 end}},
                    {name='Anderes Gebiet',faction=2,position={GetXY=function() return 0.8,0.9 end}}}
            end}
            M:RefreshContent()
            assert(#M.pois==1 and M.pois[1].row[4]=='Im Gebiet')
            assert(math.abs(M.pois[1].x-0.5)<0.001 and math.abs(M.pois[1].y-0.5)<0.001)
        ''')

    def test_zero_sized_canvas_recovers_after_layout(self):
        lua = self.runtime('MakeMap(); WorldMapFrame.canvas:SetSize(0,0)')
        lua.execute('''
            assert(M.contentPending)
            namespace.mapPOI[1429]={{'FlightA',50,25,'Flugpunkt',0,0}}
            WorldMapFrame.canvas:SetSize(1000,668)
            Advance(1)
            assert(not M.contentPending and M.pois[1]:IsShown())
        ''')

    def test_menethil_is_visible_for_both_player_factions_with_original_data(self):
        lua = self.runtime()
        lua.execute('''
            WorldMapFrame.id=1437
            for _,faction in ipairs({'Horde','Alliance'}) do
                UnitFactionGroup=function() return faction end
                M.settings.opposing=false
                M:RefreshContent()
                local found=false
                for _,pin in ipairs(M.pois) do
                    if pin.row[4]=='Menethil Harbor, Wetlands' then
                        found=true
                        assert(pin.row[1]=='FlightA' and pin.icon.color[3]==1)
                        assert(pin.x==0.095 and pin.y==0.597)
                    end
                end
                assert(found,'Menethil must not disappear because of the player faction')
            end
            assert(not M:ShowPOI({'TravelH',50,50,'Horde-Reiseort',0,0}))
        ''')

    def test_title_drag_does_not_snap_back_and_stops_when_locked(self):
        lua = self.runtime()
        lua.execute('''
            local map=WorldMapFrame
            assert(M.handle.mouse and #M.handle.points==2)
            assert(M.handle.level>map:GetFrameLevel())
            M.settings.windowPosition={'TOPLEFT','TOPLEFT',100,-100}
            M:ApplyLayout()
            M.handle.scripts.OnDragStart()
            map:ClearAllPoints(); map:SetPoint('TOPLEFT',UIParent,'TOPLEFT',250,-180)
            M:ApplyLayout()
            assert(map:GetPoint(1)=='TOPLEFT' and map.points[1][4]==250 and M.dragging)
            M.handle.scripts.OnDragStop()
            assert(not M.dragging and M.settings.windowPosition[3]==250)
            map:SynchronizeDisplayState()
            assert(map.points[1][4]==250 and map.points[1][5]==-180)
            M.handle.scripts.OnDragStart(); M.settings.unlock=false; M:OnSettingsChanged()
            assert(not M.dragging and not map.moving and not M.handle:IsShown())
            combat=true; M.settings.unlock=true; M.handle.scripts.OnDragStart()
            assert(not M.dragging)
        ''')


if __name__ == '__main__':
    unittest.main()
