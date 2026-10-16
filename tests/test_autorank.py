"""Rank comparisons and cursor-safe, combat-safe action bar mutations."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

AUTORANK_MOCK = r'''
secret={}
function issecretvalue(value) return value==secret end
Enum={SpellBookSpellBank={Player=0},SpellBookItemType={Spell=1,FutureSpell=2,Flyout=3}}
spells={
    [100]={name='Feuerball',rank='Rang 1'}, [101]={name='Feuerball',rank='Rang 2'},
    [102]={name='Feuerball',rank='Rang 3'}, [103]={name='Feuerball',rank='Rang 5'},
    [200]={name='Frostblitz',rank='Rang 1'}, [300]={name='Passiv',rank=''},
    [400]={name='Sprint',rank=''}, [500]={name='Zukunft',rank='Rang 1'},
    [600]={name='Inaktiv',rank=''}, [700]={name='Neu',rank=''},
    [800]={name='Variantenzauber',rank='Bär'}, [801]={name='Variantenzauber',rank='Katze'},
}
book={100,101,200,300,400,500,600}
unlearned={}
actions={[1]={'spell',100},[2]={'macro',1},[3]={'item',999},[80]={'spell',100}}
macroSpells={}
cursor=nil
places,pickups,clears=0,0,0
function GetCursorInfo() if cursor then return cursor.kind,cursor.id end end
function ClearCursor() assert(not combat); cursor=nil; clears=clears+1; Fire('CURSOR_CHANGED') end
function GetActionInfo(slot)
    assert(slot>=1 and slot<=180)
    local entry=actions[slot]
    if entry then return unpack(entry) end
end
function PlaceAction(slot)
    assert(not combat)
    if rejectPlace or (rejectRollback and places>0) then error('placement rejected') end
    assert(cursor)
    places=places+1
    local old=actions[slot]
    actions[slot]={cursor.kind,cursor.id}
    cursor=old and {kind=old[1],id=old[2]} or nil
    Fire('ACTIONBAR_SLOT_CHANGED',slot)
end
function GetMacroSpell(id) return macroSpells[id] end
function UnitHasVehicleUI() return vehicle or false end
C_Spell={
    GetSpellInfo=function(id) return spells[id] and {name=spells[id].name} end,
    GetSpellSubtext=function(id) return spells[id] and spells[id].rank end,
    IsSpellPassive=function(id) return id==300 end,
    PickupSpell=function(id)
        assert(not combat and not cursor)
        pickups=pickups+1
        if rejectPickup then return end
        cursor={kind='spell',id=wrongPickup or id}; Fire('CURSOR_CHANGED')
    end,
}
C_SpellBook={
    GetNumSpellBookSkillLines=function() return 1 end,
    GetSpellBookSkillLineInfo=function() return {itemIndexOffset=0,numSpellBookItems=#book} end,
    GetSpellBookItemInfo=function(index,bank)
        assert(bank==0)
        local id=book[index]
        if not id then return end
        return {spellID=id,name=spells[id].name,subName=spells[id].rank,
            itemType=id==500 and 2 or 1,isPassive=id==300,isOffSpec=id==600}
    end,
    IsSpellKnownOrInSpellBook=function(id) return not unlearned[id] end,
    FindSpellOverrideByID=function(id) return id end,
}
C_ActionBar={GetSpell=function(slot)
    if resolved and resolved[slot] then return resolved[slot] end
    local a=actions[slot]; return a and a[1]=='spell' and a[2] or nil
end}
'''


class AutoRankTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + AUTORANK_MOCK)
        source = (ROOT / 'ForeverTools/Features/AutoRank.lua').read_text(encoding='utf-8')
        self.lua.execute('assert(loadstring(...))("ForeverTools",{})', source)
        self.lua.execute("Fire('ADDON_LOADED','ForeverTools'); A=AutoRank")

    def run_scan(self):
        self.lua.execute("Fire('PLAYER_ENTERING_WORLD'); Advance(4)")

    def test_waits_for_world_then_updates_all_existing_ranks_preserving_other_actions(self):
        self.lua.execute('Advance(10); assert(places==0)')
        self.run_scan()
        self.lua.execute('''
            assert(actions[1][2]==101 and actions[80][2]==101)
            assert(actions[2][1]=='macro' and actions[2][2]==1)
            assert(actions[3][1]=='item' and actions[3][2]==999)
            assert(A.last.replaced==2 and not cursor and not A.fault)
        ''')

    def test_only_highest_learned_active_rank_added_once(self):
        self.run_scan()
        self.lua.execute('''
            local counts={}
            for _,entry in pairs(actions) do if entry[1]=='spell' then counts[entry[2]]=(counts[entry[2]] or 0)+1 end end
            assert(counts[101]==2 and counts[200]==1 and counts[400]==1)
            assert(not counts[300] and not counts[500] and not counts[600])
            local before=places; Fire('SPELLS_CHANGED'); Advance(4); assert(places==before)
            book[#book+1]=102; Fire('LEARNED_SPELL_IN_SKILL_LINE'); Advance(4)
            assert(actions[1][2]==102 and actions[80][2]==102)
            assert(A.last.replaced==2 and A.last.added==0)
        ''')

    def test_new_family_added_after_training(self):
        self.run_scan()
        self.lua.execute('''
            book[#book+1]=700; Fire('SPELLS_CHANGED'); Advance(4)
            local found=0
            for _,entry in pairs(actions) do if entry[2]==700 then found=found+1 end end
            assert(found==1 and A.last.added==1)
        ''')

    def test_never_downgrades_or_assumes_higher_id_means_higher_rank(self):
        self.lua.execute("actions[1]={'spell',103}; book={101,100}; actions[80]={'spell',101}")
        self.run_scan()
        self.lua.execute('assert(actions[1][2]==103 and actions[80][2]==101 and places==0)')

    def test_explicit_unlearned_rank_is_excluded(self):
        self.lua.execute('unlearned[101]=true')
        self.run_scan()
        self.lua.execute('assert(actions[1][2]==100 and actions[80][2]==100)')

    def test_combat_and_busy_cursor_defer_without_discarding_cursor(self):
        self.lua.execute("combat=true; Fire('PLAYER_ENTERING_WORLD'); Advance(8); assert(places==0)")
        self.lua.execute('''
            combat=false; cursor={kind='item',id=555}; Fire('PLAYER_REGEN_ENABLED'); Advance(8)
            assert(places==0 and clears==0 and cursor.id==555)
            cursor=nil; Fire('CURSOR_CHANGED'); Advance(4)
            assert(actions[1][2]==101 and not cursor)
        ''')

    def test_full_bars_wait_and_use_enabled_auxiliary_bar(self):
        self.lua.execute("for i=1,12 do actions[i]={'item',i} end; actions[80]={'spell',101}")
        self.run_scan()
        self.lua.execute('''
            assert(A.last.waiting==2 and places==0)
            MultiBarBottomLeft={IsShown=function() return true end}
            Fire('CVAR_UPDATE'); Advance(4)
            assert(A.last.added==2 and A.last.waiting==0)
            assert(actions[61][1]=='spell' and actions[62][1]=='spell' and not actions[13])
        ''')

    def test_manual_deletion_stays_deleted_until_explicit_fill(self):
        self.run_scan()
        self.lua.execute('''
            for slot,entry in pairs(actions) do if entry[2]==200 then actions[slot]=nil end end
            local before=places; Fire('ACTIONBAR_SLOT_CHANGED'); Advance(4)
            assert(places==before)
            SlashCmdList.AUTORANK('fill'); Advance(4)
            assert(A.last.added==1)
        ''')

    def test_macro_spell_presence_prevents_duplicate_without_rewriting_macro(self):
        self.lua.execute('macroSpells[1]=200')
        self.run_scan()
        self.lua.execute('''
            assert(actions[2][1]=='macro' and actions[2][2]==1)
            for _,entry in pairs(actions) do assert(entry[1]~='spell' or entry[2]~=200) end
        ''')

    def test_same_name_variants_remain_distinct_and_rankless_spells_not_replaced(self):
        self.lua.execute("book={800,801}; actions[1]={'spell',800}; actions[80]={'spell',801}")
        self.run_scan()
        self.lua.execute('assert(places==0 and actions[1][2]==800 and actions[80][2]==801)')

    def test_rejected_placement_preserves_original_and_stops_automatic_retries(self):
        self.lua.execute('rejectPlace=true')
        self.run_scan()
        self.lua.execute('''
            assert(A.fault and actions[1][2]==100 and not cursor)
            local before=pickups; Fire('SPELLS_CHANGED'); Advance(8); assert(pickups==before)
            rejectPlace=false; SlashCmdList.AUTORANK('scan'); Advance(4)
            assert(not A.fault and actions[1][2]==101)
        ''')

    def test_unexpected_picked_spell_rolls_back_original(self):
        self.lua.execute('wrongPickup=700')
        self.run_scan()
        self.lua.execute('assert(A.fault and actions[1][2]==100 and not cursor)')

    def test_failed_rollback_keeps_original_on_cursor_instead_of_discarding_it(self):
        self.lua.execute('wrongPickup=700; rejectRollback=true')
        self.run_scan()
        self.lua.execute('assert(A.fault and cursor and cursor.id==100 and clears==0)')

    def test_effective_highest_rank_is_already_sufficient(self):
        self.lua.execute('resolved={[1]=101,[80]=101}; book={100,101}')
        self.run_scan()
        self.lua.execute('assert(places==0 and not A.fault)')

    def test_spellbook_base_id_alias_resolves_renamed_override(self):
        self.lua.execute('''
            book={700}; actions={[1]={'spell',100}}
            C_SpellBook.GetSpellBookItemInfo=function() return {
                itemType=1,actionID=100,spellID=700,name='Neu',subName='',isPassive=false} end
            C_SpellBook.FindSpellOverrideByID=function(id) return id==100 and 700 or id end
        ''')
        self.run_scan()
        self.lua.execute('assert(actions[1][2]==700 and A.last.replaced==1 and A.last.added==0)')

    def test_disable_in_combat_is_immediate_and_enabling_defers_mutations(self):
        self.lua.execute('''
            combat=true; A:SetEnabled(false); Fire('PLAYER_ENTERING_WORLD'); Advance(4)
            assert(places==0 and not A.pending)
            A:SetEnabled(true); Advance(4); assert(places==0)
            combat=false; Fire('PLAYER_REGEN_ENABLED'); Advance(4); assert(actions[1][2]==101)
        ''')

    def test_legacy_spellbook_and_pickup_path(self):
        self.lua.execute('''
            C_SpellBook=nil
            GetNumSpellTabs=function() return 1 end
            GetSpellTabInfo=function() return 'Class',123,0,#book end
            GetSpellBookItemInfo=function(index) return 'SPELL',book[index] end
            GetSpellInfo=function(id) return spells[id].name,spells[id].rank end
            IsPassiveSpell=function(id,bank) return bank and book[id]==300 or id==300 end
            C_Spell.PickupSpell=nil
            PickupSpellBookItem=function(index,bank) assert(not combat); cursor={kind='spell',id=book[index]} end
        ''')
        self.run_scan()
        self.lua.execute('assert(actions[1][2]==101 and not A.fault)')

    def test_forevertools_checkbox_syncs_with_commands(self):
        self.lua.execute('ftNamespace={}')
        for file in ('Core.lua', 'Modules/AutoRank.lua', 'Menu.lua'):
            source = (ROOT / 'ForeverTools' / file).read_text(encoding='utf-8')
            self.lua.execute('assert(loadstring(...))("ForeverTools",ftNamespace)', source)
        self.lua.execute('''
            Fire('ADDON_LOADED','ForeverTools'); ForeverTools:ToggleMenu()
            local box=ForeverTools.menu.byModule.autorank.master.box
            assert(box.enabled and box:GetChecked())
            box:SetChecked(false); box.scripts.OnClick(box)
            assert(not A:IsEnabled())
            SlashCmdList.AUTORANK('on'); assert(box:GetChecked())
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
