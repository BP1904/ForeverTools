"""Temporary secure combat bindings, movement exceptions and menu controls."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

SECURE_MOCK = r'''
secure=false
bindings={
    {'MOVEFORWARD','W','UP'}, {'MOVEBACKWARD','S','DOWN'},
    {'STRAFELEFT','A'}, {'STRAFERIGHT','D'}, {'TURNLEFT','Q'}, {'TURNRIGHT','E'},
    {'JUMP','SPACE'}, {'TOGGLEAUTORUN','NUMLOCK'}, {'SITORSTAND','X'},
    {'ACTIONBUTTON1','1'}, {'ACTIONBUTTON11','-'}, {'ACTIONBUTTON12','='},
    {'OPENALLBAGS','B'}, {'TARGETNEARESTENEMY','TAB'}, {'TOGGLEGAMEMENU','ESCAPE'},
    {'OTHER_ACTION','SHIFT-W'}, {'MOUSE_ACTION','BUTTON4'},
    {'CUSTOM_ACTION','CTRL-K'}, {'MOVEFORWARD','ALT-Y'},
}
function GetNumBindings() return #bindings end
function GetBinding(i) return bindings[i][1] end
function GetBindingKey(command)
    local keys={}
    for _,entry in ipairs(bindings) do
        if entry[1]==command then for i=2,#entry do keys[#keys+1]=entry[i] end end
    end
    return unpack(keys)
end
function ExecuteSnippet(frame,body,signature,...)
    local env={}
    local loader=assert(loadstring('return function(self'..(signature or '')..') '..body..' end'))
    setfenv(loader,env)
    local fn=loader()
    local previous=secure; secure=true
    fn(frame,...)
    secure=previous
end
local create=CreateFrame
function CreateFrame(kind,name,parent,template)
    assert(not combat or not template,'secure frames cannot be created during combat')
    local f=create(kind,name)
    f.name=name; f.template=template; f.attributes={}; f.refs={}; f.bindings={}; f.hooks={}
    function f:GetName() return self.name end
    function f:SetPoint(...) assert(not combat); self.position={...} end
    function f:GetPoint() return unpack(self.position) end
    function f:ClearAllPoints() assert(not combat); self.position=nil end
    function f:Hide() self.shown=false end
    function f:RegisterForClicks(...) self.clicks={...} end
    function f:RegisterForDrag(...) self.drags={...} end
    function f:SetAttribute(key,value)
        assert(not combat or secure,'insecure protected attribute mutation')
        self.attributes[key]=value
        if self.attributes._onattributechanged then
            ExecuteSnippet(self,self.attributes._onattributechanged,',name,value',key,value)
        end
        if self.hooks.OnAttributeChanged then
            local previous=secure; secure=false
            self.hooks.OnAttributeChanged(self,key,value)
            secure=previous
        end
    end
    function f:GetAttribute(key) return self.attributes[key] end
    function f:SetFrameRef(key,value) assert(not combat); self.refs[key]=value end
    function f:GetFrameRef(key) return self.refs[key] end
    function f:HookScript(key,fn) self.hooks[key]=fn end
    function f:Execute(body) assert(not combat); ExecuteSnippet(self,body) end
    function f:RunAttribute(key) assert(secure); ExecuteSnippet(self,self.attributes[key]) end
    function f:ClearBindings() assert(secure); self.bindings={} end
    function f:SetBindingClick(priority,key,target,button)
        assert(secure); self.bindings[key]={target=target,button=button,priority=priority}
    end
    function f:SetBinding(priority,key,command)
        assert(secure); self.bindings[key]={command=command,priority=priority}
    end
    function f:StartMoving() assert(not combat); self.moving=true end
    function f:StopMovingOrSizing() assert(not combat); self.moving=false end
    return f
end
function State(combatState)
    combat=combatState
    local controller=AntiFettFinger.controller
    if not controller then return end
    local previous=secure; secure=true
    controller:SetAttribute('state-combat',combatState and 'combat' or 'peace')
    secure=previous
end
function RegisterStateDriver(frame,state,condition)
    assert(not combat and state=='combat' and condition=='[combat] combat; peace')
    State(false)
end
function InsecureAttempt() AntiFettFinger.controller:SetAttribute('enabled',false) end
'''


class AntiFettFingerTest(unittest.TestCase):
    def load_addon(self, *, in_combat=False, enabled=None):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + SECURE_MOCK)
        if enabled is not None:
            lua.execute('ForeverToolsAntiFettFingerDB={enabled=' + ('true' if enabled else 'false') + '}')
        lua.execute('combat=' + ('true' if in_combat else 'false'))
        source = (ROOT / 'ForeverTools/Features/AntiFettFinger.lua').read_text(encoding='utf-8')
        lua.execute('assert(loadstring(...))("ForeverTools",{})', source)
        lua.execute("Fire('ADDON_LOADED','ForeverTools'); A=AntiFettFinger")
        return lua

    def setUp(self):
        self.lua = self.load_addon()

    def load_forevertools_bridge(self):
        self.lua.execute('ftNamespace={}')
        for file in ('Core.lua', 'Modules/AntiFettFinger.lua', 'Menu.lua'):
            source = (ROOT / 'ForeverTools' / file).read_text(encoding='utf-8')
            self.lua.execute('assert(loadstring(...))("ForeverTools",ftNamespace)', source)
        self.lua.execute('''
            Fire('ADDON_LOADED','ForeverTools')
            ForeverTools:ToggleMenu()
            master=ForeverTools.menu.byModule.antifettfinger.master.box
        ''')

    def test_forevertools_checkbox_and_commands_sync_both_ways(self):
        self.load_forevertools_bridge()
        self.lua.execute('''
            assert(master:GetChecked() and master.enabled)
            master:SetChecked(false); master.scripts.OnClick(master)
            assert(not A:IsEnabled() and not A.controller:GetAttribute('enabled'))
            SlashCmdList.ANTIFETTFINGER('on')
            assert(master:GetChecked() and ForeverTools:IsEnabled('antifettfinger'))
            SlashCmdList.ANTIFETTFINGER('off')
            assert(not master:GetChecked() and not ForeverTools:IsEnabled('antifettfinger'))
        ''')

    def test_forevertools_combat_request_defers_until_combat_ends(self):
        self.load_forevertools_bridge()
        self.lua.execute('''
            State(true)
            master:SetChecked(false); master.scripts.OnClick(master)
            assert(not master:GetChecked() and A.requestedEnabled==false)
            assert(A.controller:GetAttribute('enabled') and A.controller.bindings.B)
            State(false); Fire('PLAYER_REGEN_ENABLED')
            assert(A.requestedEnabled==nil and not A.controller:GetAttribute('enabled'))
            assert(not A.db.enabled and not master:GetChecked())
            State(true)
            master:SetChecked(true); master.scripts.OnClick(master)
            assert(A.requestedEnabled==true and not A.controller:GetAttribute('enabled'))
            State(false); Fire('PLAYER_REGEN_ENABLED'); State(true)
            assert(A.requestedEnabled==nil and A.controller:GetAttribute('enabled'))
            assert(master:GetChecked() and A.controller.bindings.B)
        ''')

    def test_forevertools_respects_existing_character_disabled_state(self):
        self.lua.execute('A:SetEnabled(false)')
        self.load_forevertools_bridge()
        self.lua.execute('''
            assert(not master:GetChecked() and not A:IsEnabled())
            State(true); assert(not next(A.controller.bindings))
        ''')

    def test_enabled_default_and_no_overrides_in_peace(self):
        self.lua.execute('''
            assert(A.db.enabled and A.controller:GetAttribute('enabled'))
            assert(not next(A.controller.bindings))
            assert(not A.button and not AntiFettFingerSwitch)
        ''')

    def test_number_row_preserved_other_keyboard_keys_blocked(self):
        self.lua.execute('''
            State(true)
            local overrides=A.controller.bindings
            for _,key in ipairs({'1','2','3','4','5','6','7','8','9','0','-','='}) do assert(not overrides[key]) end
            for _,key in ipairs({'B','TAB','ESCAPE','F1','CTRL-K','SHIFT-1','ENTER'}) do
                assert(overrides[key].target=='AntiFettFingerBlockedKey')
            end
            assert(not AntiFettFingerBlockedKey:GetAttribute('type'))
            assert(A.controller:GetAttribute('active'))
        ''')

    def test_movement_and_modifier_combinations_keep_moving(self):
        self.lua.execute('''
            State(true)
            local overrides=A.controller.bindings
            for _,key in ipairs({'W','UP','ALT-Y'}) do assert(overrides[key].command=='MOVEFORWARD') end
            assert(overrides.S.command=='MOVEBACKWARD' and overrides.A.command=='STRAFELEFT')
            assert(overrides.D.command=='STRAFERIGHT' and overrides.SPACE.command=='JUMP')
            assert(overrides.NUMLOCK.command=='TOGGLEAUTORUN')
            assert(overrides['SHIFT-W'].command=='MOVEFORWARD')
            assert(overrides['ALT-CTRL-SHIFT-W'].command=='MOVEFORWARD')
        ''')

    def test_mouse_is_not_intercepted_and_commands_defer_in_combat(self):
        self.lua.execute('''
            State(true)
            assert(not A.controller.bindings.BUTTON4 and not A.controller.bindings.MOUSEWHEELUP)
            SlashCmdList.ANTIFETTFINGER('off')
            assert(A.db.enabled and A.controller.bindings.B and A.requestedEnabled==false)
            State(false); Fire('PLAYER_REGEN_ENABLED')
            assert(not A.db.enabled and not next(A.controller.bindings))
        ''')

    def test_no_insecure_combat_changes_and_release_at_combat_end(self):
        self.lua.execute('''
            State(true)
            assert(not pcall(InsecureAttempt))
            SlashCmdList.ANTIFETTFINGER('off')
            assert(A.controller:GetAttribute('enabled') and A.controller.bindings.B)
            State(false); assert(not next(A.controller.bindings))
            assert(GetBindingKey('OPENALLBAGS')=='B' and GetBindingKey('OTHER_ACTION')=='SHIFT-W')
        ''')

    def test_binding_changes_defer_until_combat_end(self):
        self.lua.execute('''
            State(true)
            bindings[#bindings+1]={'STRAFELEFT','R'}
            Fire('UPDATE_BINDINGS'); assert(A.pending)
            assert(A.controller.bindings.R.target)
            State(false); Fire('PLAYER_REGEN_ENABLED'); assert(not A.pending)
            State(true); assert(A.controller.bindings.R.command=='STRAFELEFT')
        ''')

    def test_saved_disabled_state_and_commands(self):
        lua = self.load_addon(enabled=False)
        lua.execute('''
            State(true); assert(not next(A.controller.bindings) and not A.db.enabled)
            State(false); SlashCmdList.ANTIFETTFINGER('on'); State(true)
            assert(A.controller.bindings.B and A.db.enabled)
            State(false); SlashCmdList.ANTIFETTFINGER('off'); State(true)
            assert(not next(A.controller.bindings))
        ''')

    def test_loading_during_combat_waits_for_safe_creation(self):
        lua = self.load_addon(in_combat=True)
        lua.execute('''
            assert(not A.controller and A.pending)
            SlashCmdList.ANTIFETTFINGER('off')
            combat=false; Fire('PLAYER_REGEN_ENABLED')
            assert(A.controller and A.db.enabled)
            State(true); assert(A.controller.bindings.B)
        ''')

    def test_no_screen_button_and_old_position_can_be_cleared(self):
        self.lua.execute('''
            assert(not A.button and not AntiFettFingerSwitch)
            A.db.position={point='TOP',relativePoint='TOP',x=10,y=-90}
            SlashCmdList.ANTIFETTFINGER('reset')
            assert(not A.db.position)
            State(true); assert(A.controller.bindings.B)
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
