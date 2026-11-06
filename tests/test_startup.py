"""Real Forever client failure: unknown legacy AH event must not stop startup."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime


class StartupTest(unittest.TestCase):
    def runtime(self):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute(MOCK + '\nnamespace={}\n')
        for file in ('Core.lua', 'Modules/Auctionator.lua', 'Modules/AuctionatorTrading.lua', 'Menu.lua'):
            lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                        (ROOT / 'ForeverTools' / file).read_text(encoding='utf-8'))
        return lua

    def test_unknown_auction_event_still_initializes_later_module_and_launcher(self):
        lua = self.runtime()
        lua.execute('''
            local create = CreateFrame
            function CreateFrame(...)
                local frame=create(...)
                local register=frame.RegisterEvent
                function frame:RegisterEvent(event)
                    if event:find('AUCTION_',1,true) == 1 and event~='AUCTION_HOUSE_SHOW' and event~='AUCTION_HOUSE_CLOSED' then
                        error('Attempt to register unknown event '..event)
                    end
                    register(self,event)
                end
                return frame
            end
            ForeverTools:RegisterModule('later', {Initialize=function(self)
                assert(self.settings.enabled); laterStarted=true
            end})
            Minimap={}
            Fire('ADDON_LOADED','ForeverTools')
            assert(laterStarted and ForeverTools.launcher)
            local auction=ForeverTools.modules.auctionator
            assert(not auction.initError and auction.unsupportedEvents.AUCTION_ITEM_LIST_UPDATE)
            assert(auction.frame.scripts.OnEvent and auction.frame.events.AUCTION_HOUSE_SHOW)
            assert(not auction:Ready() and auction.status:find('nicht unterstützt',1,true))
            ForeverTools:ToggleMenu()
            assert(ForeverTools.menu.byModule.later.master.box:GetChecked())
        ''')

    def test_module_error_preserves_all_settings_and_launcher_across_reload(self):
        lua = self.runtime()
        lua.execute('''
            namespace.modules.auctionator.Initialize=function() error('test startup failure') end
            ForeverTools:RegisterModule('later', {Initialize=function(self)
                assert(self.settings.enabled); laterStarted=true
            end})
            Minimap={}
            Fire('ADDON_LOADED','ForeverTools')
            assert(laterStarted and ForeverTools.launcher)
            assert(ForeverTools.modules.auctionator.initError:find('test startup failure',1,true))
            assert(ForeverTools:IsEnabled('later') and not ForeverTools:IsEnabled('missing'))
            ForeverTools:ToggleMenu()
            assert(ForeverTools.menu.byModule.later.master.box:GetChecked())
            laterStarted=false
            ForeverTools:Initialize()
            assert(laterStarted and ForeverTools:IsEnabled('later'))
        ''')


if __name__ == '__main__':
    unittest.main()
