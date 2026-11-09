"""Embedded profession engine: safeguards, explicit secure clicks and migration."""
import unittest
import xml.etree.ElementTree as ET
from test_forevertools import ROOT, MOCK, LuaRuntime

VENDOR=ROOT/'ForeverTools/Features/Disenchantry'
DE_MOCK=r'''
WOW_PROJECT_ID=1; WOW_PROJECT_MAINLINE=1; NUM_BAG_SLOTS=4
function GetBuildInfo() return '1.60.1',nil,nil,16001 end
function GetLocale() return 'deDE' end
function UnitGUID() return 'Player-Test' end
function UnitName() return 'Tester' end
function UnitCastingInfo() end
function UnitChannelInfo() end
function GetCVarBool() return false end
function IsAltKeyDown() return false end
function IsControlKeyDown() return false end
function IsShiftKeyDown() return false end
function GetTime() return now end
function SpellIsTargeting() return targeting or false end
wipe=function(t) for k in pairs(t) do t[k]=nil end end
strtrim=function(t) return t:match('^%s*(.-)%s*$') end
Enum={ItemQuality={Uncommon=2,Rare=3,Epic=4},ItemBind={OnAcquire=1,OnEquip=2,ToWoWAccount=7,ToBnetAccount=8,ToBnetAccountUntilEquipped=9},
BagIndex={Backpack=0},ItemClass={Tradegoods=7},ItemTradegoodsSubclass={Herb=9,MetalAndStone=7}}
spellKnown={[13262]=true}
C_Spell={GetSpellName=function(id) return ({[13262]='Entzaubern',[51005]='Mahlen',[31252]='Sondieren'})[id] end,
GetSpellTexture=function() return 136244 end}
C_SpellBook={IsSpellKnown=function(id) return spellKnown[id] or false end}
metadata={}; baglines={}
function ID(link) return type(link)=='number' and link or tonumber((link or ''):match('item:(%d+)')) end
function C_Item.GetItemInfo(link)
    local id=ID(link); local d=metadata[id]
    if not d then return end
    return d.name or 'Item'..id,'item:'..id,d.quality or 2,d.level or 20,1,'Armor','Cloth',d.maxStack or 1,
        '',123,d.vendor or 50,d.class or 4,d.subclass or 1,d.bind or 2,0,d.set
end
function C_Item.GetItemInfoInstant(link)
    local id=ID(link); local d=metadata[id] or {}
    return id,nil,nil,nil,nil,d.class or 4,d.subclass or 1
end
function C_Item.GetDetailedItemLevelInfo(link) local d=metadata[ID(link)]; return d and d.level or 0 end
function C_Item.IsEquippableItem(link) local d=metadata[ID(link)]; return d and (d.class==nil or d.class==2 or d.class==4) or false end
function C_Container.GetContainerItemLink(bag,slot) local i=inventory[bag][slot]; return i and i.hyperlink end
ItemLocation={CreateFromBagAndSlot=function(_,bag,slot) return {bag=bag,slot=slot} end}
function C_Item.DoesItemExist(loc) return inventory[loc.bag][loc.slot]~=nil end
function C_Item.GetItemGUID(loc) local i=inventory[loc.bag][loc.slot]; return i and (i.guid or ('GUID-'..loc.bag..'-'..loc.slot..'-'..i.itemID)) end
C_TooltipInfo={GetBagItem=function() return {lines={{leftText=refuse and 'nicht entzauberbar' or 'Gegenstand'}}} end}
function AddItem(bag,slot,id,quality,count)
    metadata[id]={quality=quality or 2,level=20}
    Put(bag,slot,id,quality or 2,count or 1)
end
timers={}; C_Timer={After=function(_,fn) timers[#timers+1]=fn end}
function RunTimers() local old=timers; timers={}; for _,fn in ipairs(old) do fn() end end
bindings={}; bindingOwner=nil
function ClearOverrideBindings(owner) bindings={}; bindingOwner=owner end
function SetOverrideBindingClick(owner,_,key,name) bindings[key]=name; bindingOwner=owner end
function RegisterStateDriver(frame,key,value) frame.drivers=frame.drivers or {}; frame.drivers[key]=value end
local make=CreateFrame
function CreateFrame(kind,name,parent,template)
    local f=make(kind,name); f.parent=parent; f.width=500; f.height=400; f.attributes={}; f.name=name
    f.protected=template and template:find('Secure')~=nil or false
    function f:GetName() return self.name end
    function f:SetSize(w,h) self.width=w; self.height=h end
    function f:SetHeight(h) self.height=h end
    function f:SetWidth(w) self.width=w end
    function f:GetWidth() return self.width end
    function f:GetHeight() return self.height end
    function f:GetFrameLevel() return 2 end
    function f:GetParent() return self.parent end
    function f:SetPoint(...) self.point={...} end
    function f:GetPoint() return unpack(self.point or {}) end
    function f:SetParent(p) assert(not combat); self.parent=p end
    function f:SetAttribute(k,v) assert(not combat or secure); self.attributes[k]=v end
    function f:GetAttribute(k) return self.attributes[k] end
    function f:SetFrameRef(k,v) assert(not combat); self.refs=self.refs or {}; self.refs[k]=v end
    function f:GetFrameRef(k) return self.refs and self.refs[k] end
    function f:IsProtected() return self.protected end
    function f:IsVisible() return self.shown and (not self.parent or not self.parent.IsVisible or self.parent:IsVisible()) end
    function f:Show() self:SetShown(true) end
    function f:Hide()
        assert(not combat or not self.protected or secure)
        local shown=self.shown; self.shown=false
        if shown and self.scripts.OnHide then self.scripts.OnHide(self) end
    end
    function f:GetScript(key) return self.scripts[key] end
    function f:GetVerticalScroll() return self.scroll or 0 end
    function f:SetVerticalScroll(value) self.scroll=value end
    function f:HookScript(key,fn)
        local old=self.scripts[key]
        self.scripts[key]=function(...) if old then old(...) end; fn(...) end
    end
    function f:GetText() return tostring(self.text or '') end
    function f:GetStringWidth() return #self:GetText()*6 end
    function f:GetFontString() if not self.fontString then self.fontString=CreateFrame() end; return self.fontString end
    function f:CreateTexture() return CreateFrame() end
    function f:Disable() self.enabled=false end
    function f:Enable() self.enabled=true end
    function f:SetOwner(owner) self.owner=owner end
    function f:IsOwned(owner) return self.owner==owner end
    function f:AddLine(line) self.lines=self.lines or {}; self.lines[#self.lines+1]=line end
    function f:AddDoubleLine(a,b) self:AddLine(a..' '..b) end
    function f:ClearLines() self.lines={} end
    function f:NumLines() return 0 end
    for _,method in ipairs({'SetBackdrop','SetBackdropColor','SetBackdropBorderColor','SetToplevel',
        'SetFrameLevel','SetAlpha','SetAllPoints','SetTexture','SetColorTexture','ClearAllPoints','SetTexCoord',
        'SetJustifyV','SetWordWrap','SetNormalFontObject','SetHighlightFontObject','SetDisabledFontObject',
        'RegisterForClicks','SetScale','SetFontObject','Raise','SetNumeric','SetAutoFocus','SetMaxLetters',
        'ClearFocus','SetTextInsets','EnableKeyboard','SetPropagateKeyboardInput','SetHyperlink','SetSpacing',
        'SetBagItem','SetItemByID','SetDesaturated','SetVertexColor'}) do if not f[method] then f[method]=function() end end end
    if kind=='ScrollFrame' then f.ScrollBar=CreateFrame('Slider',nil,f) end
    return f
end
GameTooltip=CreateFrame('GameTooltip','GameTooltip')
ItemRefTooltip=CreateFrame('GameTooltip','ItemRefTooltip')
function hooksecurefunc(object,key,fn)
    local original=object[key]
    object[key]=function(...) local a,b,c=original(...); fn(...); return a,b,c end
end
'''


class DisenchantryTest(unittest.TestCase):
    def test_drag_stops_and_ui_rebuild_are_deferred_in_combat(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            local app=ns.App
            stops=0
            app.mainFrame.StopMovingOrSizing=function() assert(not combat); stops=stops+1 end
            app.compactFrame.StopMovingOrSizing=function() assert(not combat); stops=stops+1 end
            combat=true
            app.mainFrame.TitleBar.scripts.OnDragStart()
            app.mainFrame.TitleBar.scripts.OnDragStop()
            app.compactFrame.scripts.OnDragStop(app.compactFrame)
            local update=app.UpdateModeSurface
            app.UpdateModeSurface=function() assert(not combat); return update() end
            app.RefreshUI()
            assert(stops==0 and app.pendingDragStops and app.needsRefreshAfterCombat)
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(stops==2 and not app.pendingDragStops)
        ''')
    def test_compact_close_runs_securely_during_combat(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            local bar=ns.App.compactFrame
            bar:Show(); combat=true
            assert(not pcall(bar.Hide,bar))
            secure=true
            local close=bar.CloseButton
            local run=assert(loadstring(close:GetAttribute('_onclick')))
            setfenv(run,setmetatable({self=close},{__index=_G})); run()
            secure=false
            assert(not bar:IsShown())
        ''')

    def runtime(self,extra='',with_minimap=False):
        lua=LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK+DE_MOCK+extra)
        lua.execute('namespace={}')
        files=[ROOT/'ForeverTools/Core.lua',ROOT/'ForeverTools/Modules/Auctionator.lua',VENDOR/'Bootstrap.lua']
        files += [VENDOR/element.attrib['file'] for element in ET.parse(VENDOR/'Manifest.xml').getroot()]
        files += [ROOT/'ForeverTools/Modules/Disenchantry.lua']
        if with_minimap:
            files += [ROOT/'ForeverTools/Modules/DisenchantryMinimap.lua']
        for path in files:
            lua.execute('assert(loadstring(...))("ForeverTools",namespace)',path.read_text(encoding='utf-8'))
        lua.execute('Fire("ADDON_LOADED","ForeverTools"); M=ForeverTools.modules.disenchantry; ns=namespace.disenchantry; A=ns.App')
        return lua

    def start(self,lua):
        lua.execute('assert(M:EnsureStarted(),messages[#messages]); assert(M.started)')

    def test_license_isolation_safe_defaults_and_lazy_start(self):
        self.runtime().execute('''
            assert(A.db==ForeverToolsDisenchantryDB and DisenchantryDB==nil)
            assert(not M.started and not A.mainFrame)
            assert(not A.db.compactMode and A.db.qualityFilter[3]==false and A.db.qualityFilter[4]==false)
            assert(A.IS_NON_RETAIL_CLIENT)
            assert(SlashCmdList.DISENCHANTRY==nil and SlashCmdList.FOREVERTOOLSDISENCHANTRY)
            assert(ns.Prices.GetProviderStatus()[1].key=='forevertools')
        ''')
        self.assertIn('Rakuga',(VENDOR/'LICENSE.txt').read_text())
        self.assertIn('x_Raven_x',(VENDOR/'LICENSE.txt').read_text())

    def test_full_ui_starts_without_external_libraries(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            assert(LibStub==nil and A.mainFrame and A.compactFrame and A.settingsFrame and A.blacklistFrame)
            assert(A.queueButton:GetName()=='ForeverToolsDisenchantry_QueueAction')
            assert(not A.queueButton:GetAttribute('type'))
            M:Open(); assert(A.mainFrame:IsShown())
            M:Open('settings'); assert(A.settingsFrame:IsShown())
            M:Open('blacklist'); assert(A.blacklistFrame:IsShown())
            M:Open('stats'); assert(ForeverToolsDisenchantry_StatisticsFrame:IsShown())
        ''')

    def test_scan_excludes_locked_high_quality_blacklist_and_non_equipment(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            AddItem(0,1,100,2); AddItem(0,2,101,3); AddItem(0,3,102,4)
            AddItem(0,4,103,2); inventory[0][4].isLocked=true
            AddItem(0,5,104,2); metadata[104].class=7
            AddItem(0,6,105,2); A.ExclusionBook()['105']=true
            A.DiscoverCandidates(); assert(#A.items==1 and A.items[1].link=='item:100')
            assert(#A.queue==0)
        ''')

    def test_manual_selection_one_target_and_changed_slot_disarms(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            AddItem(0,1,100); AddItem(0,2,101); A.DiscoverCandidates()
            local item=A.items[1]; A.selected[item.key]=true; A.ReplanWork(); A.SyncActionTarget()
            assert(#A.queue==1 and A.queueButton:GetAttribute('type')=='spell')
            ns.Action.BeforeClick(A.queueButton)
            assert(A.pendingDisenchantItem and A.queueButton:GetAttribute('target-key')==item.key)
            inventory[item.bag][item.slot].guid='NEW-INSTANCE'; now=1
            ns.Action.BeforeClick(A.queueButton); assert(not A.queueButton:GetAttribute('type'))
        ''')

    def test_locked_cursor_changed_quantity_and_blacklist_disarm(self):
        for mutation in ("inventory[0][1].isLocked=true", "cursor={}", "targeting=true", "A.ExclusionBook()['100']=true", "inventory[0][1]=nil"):
            with self.subTest(mutation=mutation):
                lua=self.runtime(); self.start(lua)
                lua.execute('''
                    AddItem(0,1,100); A.DiscoverCandidates(); A.selected[A.items[1].key]=true
                    A.ReplanWork(); A.SyncActionTarget()
                '''+mutation+'''
                    ns.Action.BeforeClick(A.queueButton)
                    assert(not A.queueButton:GetAttribute('type') and not A.pendingDisenchantItem)
                ''')

    def test_automatic_queue_applies_set_level_and_unknown_value_protection(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            AddItem(0,1,100); AddItem(0,2,101); metadata[101].set=5
            A.SetCompactMode(true); assert(#A.queue==1 and A.queue[1].link=='item:100')
            A.db.ilvlCapEnabled=true; A.db.ilvlCap=20; A.RefreshWorkspace(); assert(#A.queue==0)
            A.db.ilvlCapEnabled=false; A.db.priceWarnEnabled=true; A.db.priceThresholdGold=5
            A.RefreshWorkspace(); assert(#A.queue==0)
            local prices=ForeverTools.modules.auctionator:Market().prices
            prices['100:0']={unit=100,stamp=100000}; A.RefreshWorkspace()
            assert(#A.queue==1 and A.queue[1].link=='item:100')
        ''')

    def test_forevertools_prices_and_material_expected_value(self):
        self.runtime().execute('''
            local prices=ForeverTools.modules.auctionator:Market().prices
            prices['10940:0']={unit=100}; prices['10938:0']={unit=500}
            local value,source=ns.Prices.GetValue('item:10940'); assert(value==100 and source=='forevertools')
            local item={baseItemLevel=10,quality=2,classID=4,expansionID=0}
            assert(ns.DisenchantResults.IsSupported())
            assert(math.abs(ns.DisenchantResults.ExpectedValue(item)-270)<0.0001)
            prices['10940:0'].unit=200; assert(ns.Prices.GetValue('item:10940')==200)
            prices['10938:0']=nil; assert(ns.DisenchantResults.ExpectedValue(item)==nil)
        ''')

    def test_migration_deep_copies_and_blocks_duplicate_engine_until_reload(self):
        self.runtime('''
            DisenchantryDB={compactMode=true,blacklist={['item:100']=true},statistics={old=true}}
            disabled={}
            C_AddOns={IsAddOnLoaded=function() return true end,DisableAddOn=function(name) disabled[name]=true end}
        ''').execute('''
            assert(M.legacyBlocked and disabled.Disenchantry and not M:EnsureStarted())
            assert(A.db~=DisenchantryDB and A.db.blacklist.disenchant['100'])
            A.db.statistics.old=false; assert(DisenchantryDB.statistics.old)
        ''')

    def test_module_disable_clears_action_bindings_and_blocks_callbacks(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            AddItem(0,1,100); A.SetCompactMode(true)
            A.db.disenchantKey='F8'; ns.Hotkeys.Update(); assert(bindings.F8)
            assert(A.queueButton:GetAttribute('type'))
            ForeverTools:SetEnabled('disenchantry',false)
            assert(not A.queueButton:GetAttribute('type') and not bindings.F8 and #A.queue==0)
            A.RefreshWorkspace(); A.SyncActionTarget(); RunTimers()
            assert(not A.queueButton:GetAttribute('type') and not A.compactFrame:IsShown())
            M:Open(); assert(not A.compactFrame:IsShown())
        ''')

    def test_combat_disable_defers_protected_changes_and_finishes_after_combat(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            AddItem(0,1,100); A.SetCompactMode(true)
            combat=true; secure=true
            local script=assert(loadstring('local self,newstate=...; '..A.queueButton:GetAttribute('_onstate-processingcombat')))
            script(A.queueButton,'blocked'); secure=false
            assert(not A.queueButton:GetAttribute('type'))
            ForeverTools:SetEnabled('disenchantry',false); assert(M.pendingDisable)
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(not M.pendingDisable and not A.queueButton:GetAttribute('type') and #A.queue==0)
        ''')

    def test_material_modes_require_five_items_and_known_spell(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            spellKnown[31252]=true
            AddItem(0,1,2770,1,4); metadata[2770].class=7; metadata[2770].subclass=7
            A.ChooseProfession('prospecting'); A.DiscoverCandidates(); assert(#A.items==0)
            inventory[0][1].stackCount=5; A.DiscoverCandidates(); assert(#A.items==1)
            A.selected[A.items[1].key]=true; A.ReplanWork(); A.SyncActionTarget()
            assert(A.queueButton:GetAttribute('spell')=='Sondieren')
            inventory[0][1].stackCount=4; ns.Action.BeforeClick(A.queueButton)
            assert(not A.queueButton:GetAttribute('type'))
        ''')

    def test_statistics_count_success_and_loot_once_not_failed_cast(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            AddItem(0,1,100); A.DiscoverCandidates(); A.selected[A.items[1].key]=true
            A.ReplanWork(); A.SyncActionTarget(); ns.Action.BeforeClick(A.queueButton)
            Fire('UNIT_SPELLCAST_SENT','player','','CAST-1',13262)
            Fire('UNIT_SPELLCAST_SUCCEEDED','player','CAST-1',13262)
            local total=A.db.statistics.characters['Player-Test'].total
            assert(total.count==1 and total.vendor==50 and total.items['item:100']==1)
            LOOT_ITEM_SELF_MULTIPLE='You receive loot: %sx%d.'
            function GetNumLootItems() return 1 end
            function GetLootSlotLink() return '|Hitem:10940|h[Dust]|h' end
            function GetLootSlotInfo() return nil,nil,2 end
            Fire('LOOT_READY'); Fire('LOOT_OPENED')
            Fire('CHAT_MSG_LOOT','You receive loot: |Hitem:10940|h[Dust]|hx2.')
            Fire('CHAT_MSG_LOOT','You receive loot: |Hitem:10940|h[Dust]|hx2.')
            assert(total.materials[10940]==2)
            Fire('UNIT_SPELLCAST_FAILED','player','CAST-2',13262); assert(total.count==1)
        ''')

    def test_tooltip_gate_and_separate_marker(self):
        self.runtime().execute('''
            metadata[100]={quality=2,level=20,class=4}
            GameTooltip:SetHyperlink('item:100')
            assert(GameTooltip.foreverToolsDisenchantryResults and not GameTooltip.disenchantryResults)
            GameTooltip.lines={}; GameTooltip.foreverToolsDisenchantryResults=nil
            ForeverTools:SetEnabled('disenchantry',false)
            GameTooltip:SetHyperlink('item:100'); assert(#GameTooltip.lines==0)
        ''')

    def test_delayed_blacklist_does_not_target_replacement_instance(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            AddItem(0,1,100); A.DiscoverCandidates()
            A.SetPendingDisenchant(A.items[1]); A.ValidatePendingItemForBlacklist(0.1,true)
            inventory[0][1].guid='NEW-INSTANCE'; RunTimers()
            assert(not A.ExclusionBook()['100'] and not A.pendingDisenchantItem)
            A.DiscoverCandidates(); A.SetPendingDisenchant(A.items[1])
            A.ValidatePendingItemForBlacklist(0.1,true); RunTimers()
            assert(A.ExclusionBook()['100'])
        ''')

    def test_mode_commands_require_learned_profession_and_never_cast(self):
        lua=self.runtime(); self.start(lua)
        lua.execute('''
            function CastSpellByID() error('must require hardware click') end
            M:Command('mill'); assert(A.activeMode.key=='disenchant')
            spellKnown[51005]=true; M:Command('mill'); assert(A.activeMode.key=='milling')
            M:Command('de'); assert(A.activeMode.key=='disenchant')
            local started=M.started; M:Command('help'); assert(M.started==started)
        ''')


if __name__=='__main__':
    unittest.main()
