"""Quest integration tests; run with the same Lua 5.1 runtime as the merchant tests."""
import unittest
from test_forevertools import ROOT, MOCK, LuaRuntime

QUEST_MOCK = r'''
shift = false
quests = {}
complete = {}
choices = 0
selected = {}
rewards = {}
progressCalls = 0
acceptCalls = 0
autoChain = false
function IsShiftKeyDown() return shift end
C_QuestLog = {IsComplete = function(id) return complete[id] or false end}
C_GossipInfo = {}
function C_GossipInfo.GetActiveQuests() return quests end
function C_GossipInfo.SelectActiveQuest(id)
    selected[#selected+1] = id
    currentQuest = id
    if autoChain then Fire('QUEST_PROGRESS') end
end
function GetNumActiveQuests() return #quests end
function GetActiveQuestID(i) return quests[i].questID end
function SelectActiveQuest(i)
    selected[#selected+1] = i
end
function IsQuestCompletable() return currentQuest and complete[currentQuest] or false end
function CompleteQuest()
    progressCalls = progressCalls + 1
    if autoChain then Fire('QUEST_COMPLETE') end
end
function GetNumQuestChoices() return choices end
function GetQuestReward(choice)
    rewards[#rewards+1] = choice
    if autoChain then
        complete[currentQuest] = nil
        for i,q in ipairs(quests) do
            if q.questID == currentQuest then table.remove(quests,i); break end
        end
        Fire('GOSSIP_SHOW')
    end
end
function AcceptQuest() acceptCalls = acceptCalls + 1 end
'''


class QuestIntegrationTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCK + QUEST_MOCK)
        self.lua.execute('namespace = {}')
        for filename in ('Core.lua', 'Modules/Merchant.lua', 'Modules/Quests.lua', 'Menu.lua'):
            self.lua.execute('assert(loadstring(...))("ForeverTools", namespace)',
                             (ROOT / 'ForeverTools' / filename).read_text(encoding='utf-8'))
        self.lua.execute('Fire("ADDON_LOADED", "ForeverTools")')

    def test_gossip_selects_only_first_complete_quest(self):
        self.lua.execute('''
            quests={{questID=10},{questID=20,isComplete=true},{questID=30,isComplete=true}}
            Fire('GOSSIP_SHOW')
            assert(#selected==1 and selected[1]==20)
        ''')

    def test_quest_log_fallback(self):
        self.lua.execute('''
            quests={{questID=10},{questID=20}}; complete[20]=true
            Fire('GOSSIP_SHOW'); assert(selected[1]==20)
        ''')

    def test_greeting_selects_by_index(self):
        self.lua.execute('''
            quests={{questID=10},{questID=20}}; complete[20]=true
            Fire('QUEST_GREETING'); assert(#selected==1 and selected[1]==2)
        ''')

    def test_incomplete_quests_are_not_selected_or_completed(self):
        self.lua.execute('''
            quests={{questID=10}}; currentQuest=10
            Fire('GOSSIP_SHOW'); Fire('QUEST_GREETING'); Fire('QUEST_PROGRESS')
            assert(#selected==0 and progressCalls==0 and #rewards==0)
        ''')

    def test_completed_quest_progress_is_confirmed(self):
        self.lua.execute('''
            currentQuest=10; complete[10]=true
            Fire('QUEST_PROGRESS'); assert(progressCalls==1)
        ''')

    def test_no_choice_claims_reward_zero(self):
        self.lua.execute("Fire('QUEST_COMPLETE'); assert(#rewards==1 and rewards[1]==0)")

    def test_single_choice_claims_only_reward(self):
        self.lua.execute("choices=1; Fire('QUEST_COMPLETE'); assert(#rewards==1 and rewards[1]==1)")

    def test_multiple_rewards_require_manual_choice(self):
        self.lua.execute('''
            choices=3; Fire('QUEST_COMPLETE')
            assert(#rewards==0)
            assert(string.find(messages[#messages], 'selbst'))
        ''')

    def test_shift_pauses_each_stage(self):
        self.lua.execute('''
            quests={{questID=10,isComplete=true}}; complete[10]=true; currentQuest=10
            shift=true
            Fire('GOSSIP_SHOW'); Fire('QUEST_GREETING'); Fire('QUEST_PROGRESS'); Fire('QUEST_COMPLETE')
            assert(#selected==0 and progressCalls==0 and #rewards==0)
            shift=false; Fire('QUEST_COMPLETE'); assert(#rewards==1)
        ''')

    def test_switch_disables_each_stage_immediately(self):
        self.lua.execute('''
            quests={{questID=10,isComplete=true}}; complete[10]=true; currentQuest=10
            ForeverTools:SetEnabled('quests',false)
            Fire('GOSSIP_SHOW'); Fire('QUEST_GREETING'); Fire('QUEST_PROGRESS'); Fire('QUEST_COMPLETE')
            assert(#selected==0 and progressCalls==0 and #rewards==0)
            ForeverTools:SetEnabled('quests',true)
            Fire('QUEST_COMPLETE'); assert(#rewards==1)
        ''')

    def test_quests_independent_of_merchant_switch_and_saved(self):
        self.lua.execute('''
            ForeverTools:SetEnabled('merchant',false)
            Fire('QUEST_COMPLETE'); assert(#rewards==1)
            ForeverTools:SetEnabled('quests',false)
            ForeverTools:Initialize()
            Fire('QUEST_COMPLETE'); assert(#rewards==1)
        ''')

    def test_new_quests_are_never_accepted(self):
        self.lua.execute('''
            Fire('QUEST_DETAIL'); Fire('QUEST_ACCEPT_CONFIRM')
            assert(acceptCalls==0)
        ''')

    def test_multiple_finished_quests_follow_returned_npc_list(self):
        self.lua.execute('''
            quests={{questID=10},{questID=20,isComplete=true},{questID=30,isComplete=true}}
            complete[20]=true; complete[30]=true; autoChain=true
            Fire('GOSSIP_SHOW')
            assert(#selected==2 and selected[1]==20 and selected[2]==30)
            assert(#rewards==2 and progressCalls==2 and #quests==1)
            assert(quests[1].questID==10 and acceptCalls==0)
        ''')

    def test_menu_exposes_independent_quest_checkbox(self):
        self.lua.execute('''
            SlashCmdList.FOREVERTOOLS()
            local checks=ForeverTools.menu.checks
            assert(#checks==6 and checks[6].box:GetChecked())
            checks[6].box:SetChecked(false)
            checks[6].box.scripts.OnClick(checks[6].box)
            assert(not ForeverTools:IsEnabled('quests'))
            assert(ForeverTools:IsEnabled('merchant'))
        ''')

    def test_missing_gossip_and_quest_log_apis_are_tolerated(self):
        self.lua.execute('''
            C_GossipInfo=nil; C_QuestLog=nil; quests={{questID=10}}
            Fire('GOSSIP_SHOW'); Fire('QUEST_GREETING')
            assert(#selected==0)
        ''')

    def test_api_errors_do_not_escape_or_repeat_error_messages(self):
        self.lua.execute('''
            GetQuestReward=function() error('test failure') end
            local before=#messages
            Fire('QUEST_COMPLETE'); Fire('QUEST_COMPLETE')
            assert(#messages==before+1)
        ''')


if __name__ == '__main__':
    unittest.main(verbosity=2)
