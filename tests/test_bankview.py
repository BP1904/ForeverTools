"""Bank snapshot persistence, slot scanning and the combined-bag button in Lua 5.1."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

EXTRA = r'''
BANK_CONTAINER=-1;NUM_BANKBAGSLOTS=2;NUM_TOTAL_EQUIPPED_BAG_SLOTS=4
sizes[-1]=28;sizes[5]=4;sizes[6]=0
inventory[-1]={[1]={itemID=100,stackCount=12,hyperlink='|Hitem:100:1|h[Test]|h',iconFileID=123,quality=2},
    [28]={itemID=200,stackCount=1,hyperlink='item:200',iconFileID=456,quality=3}}
inventory[5]={[2]={itemID=100,stackCount=5,hyperlink='item:100',iconFileID=123,quality=2}}
names={[100]='Kupfererz',[200]='Schwert'}
C_Item.GetItemInfo=function(ref)
    local id=type(ref)=='number' and ref or tonumber(ref:match('item:(%d+)'))
    return names[id]
end
requests={}
C_Item.RequestLoadItemDataByID=function(id) requests[id]=(requests[id] or 0)+1 end
function time() return 123456 end
function date() return '08.11.2026 16:00' end
secret={};function issecretvalue(value) return rawequal(value,secret) end
ITEM_QUALITY_COLORS={[2]={r=0,g=1,b=0},[3]={r=0,g=0,b=1}}
timers={};C_Timer={After=function(_,fn) timers[#timers+1]=fn end}
function RunTimers() local list=timers;timers={};for _,fn in ipairs(list) do fn() end end
local create=CreateFrame
function CreateFrame(kind,name,parent,...)
    local f=create(kind,name,parent,...);f.parent=parent
    function f:SetAutoFocus() end
    function f:ClearFocus() end
    function f:GetText() return self.text or '' end
    function f:SetParent(parent) self.parent=parent end
    function f:ClearAllPoints() self.point=nil end
    function f:SetPoint(...) self.point={...} end
    function f:GetFrameLevel() return self.level or 1 end
    function f:SetFrameLevel(level) self.level=level end
    function f:HookScript(event,fn)
        local old=self.scripts[event]
        self.scripts[event]=function(...) if old then old(...) end;fn(...) end
    end
    function f:SetOwner(owner) self.owner=owner end
    function f:ClearLines() self.lines={} end
    function f:AddLine(text) self.lines[#self.lines+1]=text end
    function f:SetHyperlink(link) self.hyperlink=link end
    function f:Show() self.shown=true end
    function f:Hide() self.shown=false end
    function f:SetTexture(texture) self.texture=texture end
    return f
end
ContainerFrameCombinedBags=CreateFrame('Frame')
function SetItemRef(link) openedLink=link end
function IsShiftKeyDown() return shift end
function ChatEdit_InsertLink(link) chatLink=link end
'''


class BankViewTest(unittest.TestCase):
    def runtime(self, before=''):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + EXTRA + before + '\nnamespace={}\n')
        for filename in ('Core.lua', 'Modules/BankView.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8'))
        lua.execute("Fire('ADDON_LOADED','ForeverTools');m=namespace.modules.bankview;assert(not m.initError,m.initError)")
        return lua

    def test_combined_bag_button_and_empty_snapshot_message(self):
        self.runtime().execute('''
            assert(m.button and m.button.parent==ContainerFrameCombinedBags and m.button.text=='Bank')
            m.button.scripts.OnClick();assert(m.panel.shown)
            assert(m.panel.status.text:find('Noch kein Bankstand',1,true))
            assert(not m.panel.slots[1].shown)
            m.button.scripts.OnClick();assert(not m.panel.shown)
            SlashCmdList.FOREVERTOOLSBANK();assert(m.panel.shown)
            m:AttachButton();assert(m.button==ForeverToolsBagBankButton)
        ''')

    def test_bank_saves_all_items_counts_and_free_slots_per_character(self):
        self.runtime().execute('''
            assert(not m.db.snapshot)
            Fire('BANKFRAME_OPENED');local s=m.db.snapshot
            assert(s.savedAt==123456 and s.total==32 and s.occupied==3)
            assert(s.bags[1].items[1].count==12 and s.bags[1].items[28].id==200)
            assert(s.bags[2].items[2].count==5)
            assert(not s.bags[1].items[2])
            assert(m.db==ForeverToolsBankDB)
            m:Open();assert(m.panel.slots[1].count.text=='12')
            assert(m.panel.slots[28].count.text=='')
            assert(m.panel.slots[30].count.text=='5')
            assert(m.panel.slots[32].shown and not m.panel.slots[33].shown)
        ''')

    def test_updates_at_bank_and_keeps_snapshot_away_from_bank(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED');inventory[-1][1].stackCount=3
            inventory[-1][28]=nil;Fire('PLAYERBANKSLOTS_CHANGED')
            assert(m.db.snapshot.bags[1].items[1].count==3 and m.db.snapshot.occupied==2)
            Fire('BANKFRAME_CLOSED');local saved=m.db.snapshot
            C_Container.GetContainerNumSlots=function() error('bank must not be read remotely') end
            C_Container.GetContainerItemInfo=function() error('bank must not be read remotely') end
            Fire('BAG_UPDATE_DELAYED');RunTimers();m:Open()
            assert(m.db.snapshot==saved and m.panel.slots[1].count.text=='3')
        ''')

    def test_empty_bank_replaces_previous_items_but_unavailable_bank_does_not(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED');local old=m.db.snapshot
            sizes[-1]=0;Fire('BAG_UPDATE_DELAYED');assert(m.db.snapshot==old)
            sizes[-1]=28;inventory[-1]={};inventory[5]={};Fire('BAG_UPDATE_DELAYED')
            assert(m.db.snapshot.total==32 and m.db.snapshot.occupied==0)
            assert(not next(m.db.snapshot.bags[1].items))
        ''')

    def test_failed_and_secret_scans_preserve_last_complete_snapshot(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED');local old=m.db.snapshot
            local original=C_Container.GetContainerItemInfo
            C_Container.GetContainerItemInfo=function(b,s) if s==28 then error('not readable') end;return original(b,s) end
            assert(not m:Scan() and m.db.snapshot==old)
            C_Container.GetContainerItemInfo=original
            inventory[-1][28].stackCount=secret
            assert(not m:Scan() and m.db.snapshot==old)
            inventory[-1][28]=secret
            assert(not m:Scan() and m.db.snapshot==old)
        ''')

    def test_delayed_scan_retries_loading_and_cancels_old_visit(self):
        self.runtime().execute('''
            sizes[-1]=0;Fire('BANKFRAME_OPENED');assert(not m.db.snapshot and #timers==1)
            sizes[-1]=28;RunTimers();assert(m.db.snapshot and m.db.snapshot.occupied==3)
            Fire('BAG_UPDATE_DELAYED');Fire('BANKFRAME_CLOSED')
            local old=m.db.snapshot;RunTimers();assert(m.db.snapshot==old)
            Fire('BANKFRAME_OPENED');RunTimers();assert(m.db.snapshot~=old)
        ''')

    def test_persistence_search_names_item_ids_and_item_cache_loading(self):
        self.runtime().execute('''
            Fire('BANKFRAME_OPENED');Fire('BANKFRAME_CLOSED');m:Open()
            m.panel.search:SetText('kupfer');m.panel.search.scripts.OnTextChanged(m.panel.search)
            assert(#m.rows==2 and m.rows[1].item.count==12 and m.rows[2].item.count==5)
            m.query='200';m:Refresh();assert(#m.rows==1 and m.rows[1].item.id==200)
            m.query='does not exist';m:Refresh();assert(#m.rows==0)
            names[100]=nil;m.db.snapshot.bags[1].items[1].name=nil
            m:ItemName(m.db.snapshot.bags[1].items[1]);m:ItemName(m.db.snapshot.bags[1].items[1])
            assert(requests[100]==1)
            names[100]='Neuer Name';m.query='neuer name';Fire('GET_ITEM_INFO_RECEIVED')
            assert(#m.rows==2)
        ''')
        self.runtime("ForeverToolsBankDB={snapshot={savedAt=111,total=1,occupied=1,bags={{name='Bank',size=1,items={{id=200,count=7,link='item:200',icon=456}}}}}}") .execute('''
            m:Open();assert(m.panel.slots[1].count.text=='7' and not m.bankOpen)
        ''')

    def test_bank_tabs_use_character_only_and_never_carried_bags(self):
        self.runtime().execute('''
            Enum={BankType={Character=0,Account=2},BagIndex={CharacterBankTab_1=20,CharacterBankTab_2=21}}
            C_Bank={FetchPurchasedBankTabIDs=function(kind) assert(kind==0);return {20,21} end,
                FetchPurchasedBankTabData=function(kind) assert(kind==0);return {{ID=20,name='Materialien'},{ID=21,name='Ausrüstung'}} end}
            sizes[20]=4;sizes[21]=2;inventory[20]={[1]={itemID=100,stackCount=99,iconFileID=123}}
            inventory[21]={}
            Fire('BANKFRAME_OPENED')
            local s=m.db.snapshot;assert(s.total==6 and s.occupied==1 and #s.bags==2)
            assert(s.bags[1].name=='Materialien' and s.bags[1].items[1].count==99)
        ''')

    def test_legacy_container_api(self):
        self.runtime().execute('''
            local slots=C_Container.GetContainerNumSlots
            local info=C_Container.GetContainerItemInfo
            GetContainerNumSlots=slots
            function GetContainerItemInfo(b,s)
                local item=info(b,s)
                if item then return item.iconFileID,item.stackCount,false,item.quality,false,false,item.hyperlink,nil,nil,item.itemID end
            end
            C_Container=nil;Fire('BANKFRAME_OPENED')
            assert(m.db.snapshot.occupied==3 and m.db.snapshot.bags[1].items[1].id==100)
        ''')

    def test_pagination_tooltip_and_item_links_never_move_or_use_items(self):
        self.runtime().execute('''
            sizes[-1]=100;Fire('BANKFRAME_OPENED');Fire('BANKFRAME_CLOSED');m:Open()
            assert(m.panel.next.enabled and not m.panel.previous.enabled)
            m.panel.next.scripts.OnClick();assert(m.page==2 and m.panel.previous.enabled)
            m.panel.previous.scripts.OnClick();assert(m.page==1)
            local b=m.panel.slots[1];b.scripts.OnEnter(b)
            assert(m.tooltip.shown and m.tooltip.lines[1]=='Gespeicherter Stapel: 12')
            b.scripts.OnLeave();assert(not m.tooltip.shown)
            b.scripts.OnClick(b);assert(openedLink=='item:100:1')
            shift=true;b.scripts.OnClick(b);assert(chatLink=='|Hitem:100:1|h[Test]|h')
            m.panel.slots[2].scripts.OnClick(m.panel.slots[2]);assert(openedLink=='item:100:1')
            namespace:SetEnabled('bankview',false)
            assert(not m.panel.shown and not m.button.shown)
            local old=m.db.snapshot;Fire('BANKFRAME_OPENED');assert(m.db.snapshot==old)
            namespace:SetEnabled('bankview',true);assert(m.button.shown)
        ''')

    def test_lazy_bag_frame_and_combat_attachment(self):
        self.runtime('ContainerFrameCombinedBags=nil').execute('''
            assert(not m.button)
            ContainerFrameCombinedBags=CreateFrame('Frame');combat=true;Fire('ADDON_LOADED')
            assert(not m.button)
            combat=false;Fire('PLAYER_REGEN_ENABLED');assert(m.button and m.button.parent==ContainerFrameCombinedBags)
        ''')

    def test_forever_combined_backpack_uses_visible_container_frame_one(self):
        self.runtime('''
            ContainerFrameCombinedBags:SetShown(false)
            ContainerFrame1=CreateFrame('Frame');ContainerFrame1.level=30
        ''').execute('''
            assert(m.button.parent==ContainerFrame1)
            assert(m.button.point[1]=='BOTTOMLEFT' and m.button.point[2]==ContainerFrame1)
            assert(m.button.level==50)
            m.button.scripts.OnClick();assert(m.panel.shown)
        ''')

    def test_button_follows_bag_mode_switches_and_delayed_creation(self):
        self.runtime().execute('''
            local button=m.button
            ContainerFrame1=CreateFrame('Frame');ContainerFrame1:SetShown(false)
            m:AttachButton()
            local shown=0
            -- Preserve existing bag scripts when adding our visibility hook.
            ContainerFrame1:HookScript('OnShow',function() shown=shown+1 end)
            ContainerFrameCombinedBags:SetShown(false);ContainerFrame1:SetShown(true)
            assert(m.button==button and button.parent==ContainerFrame1 and shown==1)
            ContainerFrame1:SetShown(false);ContainerFrameCombinedBags:SetShown(true)
            assert(button.parent==ContainerFrameCombinedBags)
        ''')
        self.runtime('ContainerFrameCombinedBags=nil').execute('''
            assert(not m.button)
            ContainerFrame1=CreateFrame('Frame');Fire('BAG_UPDATE_DELAYED')
            assert(m.button.parent==ContainerFrame1)
        ''')


if __name__ == '__main__':
    unittest.main()
