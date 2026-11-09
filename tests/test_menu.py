"""Menu keeps all module switches/actions accessible and reports their state."""
import unittest
import test_bundle as bundle_tests


class MenuTest(unittest.TestCase):
    def runtime(self):
        fixture = bundle_tests.BundleTest()
        lua = fixture.runtime(full=True)
        fixture.load_bundle(lua, full=True)
        lua.execute('ForeverTools:ToggleMenu(); menu=ForeverTools.menu')
        return lua

    def test_every_module_and_option_survives_expansion_without_recreating_controls(self):
        self.runtime().execute('''
            local expected=0
            for _,id in ipairs(ForeverTools.order) do
                local module=ForeverTools.modules[id]
                local section=menu.byModule[id]
                expected=expected+1+#(module.options or {})
                assert(section and not section.expanded and not section.details:IsShown())
                assert(#section.actions==#(module.actions or {}))
                section.toggle.scripts.OnClick()
                assert(section.expanded and section.details:IsShown())
                section.toggle.scripts.OnClick()
                assert(not section.expanded and not section.details:IsShown())
            end
            assert(#menu.checks==expected)
            local count=#frames
            menu:Refresh(); menu:Layout(); menu:Refresh()
            assert(#frames==count and menu.summary.text:find('21'))
        ''')

    def test_status_tracks_disabled_and_unavailable_modules(self):
        self.runtime().execute('''
            local section=menu.byModule.quests
            assert(section.status.text=='Aktiv')
            ForeverTools:SetEnabled('quests',false); menu:Refresh()
            assert(section.status.text=='Ausgeschaltet' and not section.master.box:GetChecked())
            ForeverTools.modules.quests.IsAvailable=function() return false end
            menu:Refresh(); assert(section.status.text=='Nicht bereit')
            ForeverTools.modules.quests.initError='test'
            menu:Refresh(); assert(section.status.text=='Startfehler')
        ''')


if __name__ == '__main__':
    unittest.main()
