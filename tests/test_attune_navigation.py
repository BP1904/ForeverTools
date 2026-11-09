"""Attune search preserves canonical paths, progress and expanded categories."""
import unittest
import test_attune as attune_tests


class AttuneNavigationTest(unittest.TestCase):
    def runtime(self):
        return attune_tests.AttuneTest().load()

    def test_search_matches_names_categories_and_literal_characters_without_mutation(self):
        self.runtime().execute('''
            local first={value='1',text='|cff00ff00Düsterbruch|r',tip='Düsterbruch',short='DM',done=true}
            local second={value='2',text='Test [A]',skipped=true}
            local tree={{value='Classic',text='Classic',children={
                {value='Dungeons',text='Dungeons',children={first,second}},
                {value='Klassen',text='Klassenquests',children={{value='3',text='Paladin'}}},
            }}}
            local filtered,count,total=env.FTAttune_FilterNavigationTree(tree,'DÜSTER')
            assert(count==1 and total==3 and filtered[1].children[1].children[1]==first)
            assert(filtered~=tree and #tree[1].children[1].children==2 and first.done)
            filtered,count=env.FTAttune_FilterNavigationTree(tree,'[A]')
            assert(count==1 and filtered[1].children[1].children[1]==second and second.skipped)
            filtered,count=env.FTAttune_FilterNavigationTree(tree,'dungeons'); assert(count==2)
            filtered,count=env.FTAttune_FilterNavigationTree(tree,'dm'); assert(count==1)
            filtered,count=env.FTAttune_FilterNavigationTree(tree,'nicht vorhanden'); assert(count==0 and #filtered==0)
            filtered,count=env.FTAttune_FilterNavigationTree(tree,'  '); assert(filtered==tree and count==3)
        ''')

    def test_clearing_search_restores_groups_and_selected_path(self):
        self.runtime().execute('''
            local canonical={{value='Classic',text='Classic',children={
                {value='Dungeons',text='Dungeons',children={{value='1',text='Burg'}}},
            }}}
            local path='Classic'..string.char(1)..'Dungeons'..string.char(1)..'1'
            local tree={tree=canonical,localstatus={selected=path,groups={Classic=false}}}
            function tree:SetTree(data) self.tree=data end
            local apply=env.FTAttune_ApplyNavigationFilter
            local function SetUpvalue(name,value)
                for i=1,20 do
                    local key=debug.getupvalue(apply,i)
                    if key==name then debug.setupvalue(apply,i,value); return end
                end
                error('missing upvalue '..name)
            end
            SetUpvalue('attunelocal_treeframe',tree)
            SetUpvalue('attunelocal_treeIsShown',true)
            SetUpvalue('attunelocal_tree',canonical)
            env.attunelocal_navQuery='Burg'; apply()
            assert(tree.tree~=canonical and tree.localstatus.groups.Classic)
            assert(tree.localstatus.selected==path)
            assert(env.FTAttuneTreeExpandStatus.Classic==0)
            env.FTAttune_SaveTreeExpandStatus()
            assert(env.FTAttuneTreeExpandStatus.Classic==0)
            env.attunelocal_navQuery=''; apply()
            assert(tree.tree==canonical and not tree.localstatus.groups.Classic)
            assert(tree.localstatus.selected==path and not tree.attuneSearchGroups)
        ''')

    def test_summary_uses_dependencies_and_prioritizes_main_steps(self):
        self.runtime().execute('''
            local function Step(id,stage,follows,side,kind)
                return {ID_ATTUNE='test',ID=id,STAGE=stage,FOLLOWS=follows,SIDE=side,TYPE=kind or 'Quest'}
            end
            env.FTAttune_Data.stepsByAttune={test={
                Step('1',10,'0'),Step('2',20,'1'),Step('3',30,'2'),
                Step('4',1,'0',true),Step('5',40,'3',false,'End'),Step('6',0,'0',false,'Spacer'),
            }}
            local toon={done={['test-1']=1},attuned={test=25}}
            local percent,completed,total,nextStep=env.FTAttune_ChainSummary('test',toon)
            assert(percent==25 and completed==1 and total==4 and nextStep.ID=='2')
            assert(toon.done['test-1']==1 and not toon.done['test-2'] and toon.attuned.test==25)
            toon.done['test-2']=1; toon.done['test-3']=1
            percent,completed,total,nextStep=env.FTAttune_ChainSummary('test',toon)
            assert(nextStep.ID=='4')
            toon.done['test-4']=1
            percent,completed,total,nextStep=env.FTAttune_ChainSummary('test',toon)
            assert(completed==total and not nextStep)
        ''')


if __name__=='__main__':
    unittest.main()
