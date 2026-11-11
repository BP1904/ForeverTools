-- Local Attune adaptation; original copyright retained. See NOTICE.txt.
local _, FT = ...
local function Component(...)

-- [ -> {
-- : -> =
-- "ID" -> ID
-- %20 -> space
-- %27 -> '	
-- Expac names (remove - raid)
-- remove \t\r\n
-- Rep -> Rep


FTAttune_Data.attunes = 	{
	-- dungeon quests
	{ID="163",NAME=FTAttuneLang["The Hall of Thanes"],SHORT="HoT",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_statue_07", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="13-15"},
	{ID="166",NAME=FTAttuneLang["The Hall of Thanes"],SHORT="HoT",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_statue_07", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="13-15", DEFAULTSKIP=true},
	{ID="160",NAME=FTAttuneLang["Ragefire Chasm"],SHORT="RFC",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\spell_fire_fire", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="13-16"},
    {ID="183",NAME=FTAttuneLang["Ruins of Lordaeron"],SHORT="RoL",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_bone_humanskull_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="15-17"},
	{ID="186",NAME=FTAttuneLang["Ruins of Lordaeron"],SHORT="RoL",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_bone_humanskull_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="15-17"},
	{ID="170",NAME=FTAttuneLang["The Deadmines"],SHORT="VC",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_head_human_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="18-21"},
	{ID="177",NAME=FTAttuneLang["Wailing Caverns"],SHORT="WC",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\spell_nature_poisoncleansingtotem", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="19-22"},
    {ID="180",NAME=FTAttuneLang["Wailing Caverns"],SHORT="WC",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\spell_nature_poisoncleansingtotem", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="19-22"},
	{ID="190",NAME=FTAttuneLang["Shadowfang Keep"],SHORT="SFK",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\ability_mount_whitedirewolf", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="23-26"},
    {ID="195",NAME=FTAttuneLang["Excavation Site"],SHORT="ES",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_pick_02", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="24-29"},
	{ID="196",NAME=FTAttuneLang["Excavation Site"],SHORT="ES",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_pick_02", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="24-29"},
    {ID="200",NAME=FTAttuneLang["Blackfathom Deeps"],SHORT="BFD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\spell_frost_summonwaterelemental", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="25-28"},
	{ID="210",NAME=FTAttuneLang["Blackfathom Deeps"],SHORT="BFD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\spell_frost_summonwaterelemental", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="25-28"},
	{ID="220",NAME=FTAttuneLang["The Stockade"],SHORT="STK",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_key_03", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="26-29"},
	{ID="225",NAME=FTAttuneLang["City of Dalaran"],SHORT="CoD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\spell_arcane_starfire", DESC=FTAttuneLang["DungeonQuest_Desc"].."\n\n"..FTAttuneLang["Dal_Desc"], GROUPSIZE=5, LEVELS="28-32"},
	{ID="226",NAME=FTAttuneLang["City of Dalaran"],SHORT="CoD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\spell_arcane_starfire", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="28-32"},
    {ID="250",NAME=FTAttuneLang["Razorfen Kraul"],SHORT="RFK",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\spell_magic_polymorphpig", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="30-33"},
	{ID="251",NAME=FTAttuneLang["Razorfen Kraul"],SHORT="RFK",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\spell_magic_polymorphpig", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="30-33"},
	{ID="230",NAME=FTAttuneLang["Gnomeregan"],SHORT="Gnomer",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_gear_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="31-34"},
	{ID="240",NAME=FTAttuneLang["Gnomeregan"],SHORT="Gnomer",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_gear_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="31-34"},
	{ID="260",NAME=FTAttuneLang["Scarlet Monastery"],SHORT="SM",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_cape_18", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="31-42"},
	{ID="270",NAME=FTAttuneLang["Scarlet Monastery"],SHORT="SM",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_cape_18", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="31-42"},
    {ID="275",NAME=FTAttuneLang["The Drowned City"],SHORT="DC",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Both",ICON="Interface\\Icons\\spell_frost_wizardmark", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="35-38"},
	{ID="280",NAME=FTAttuneLang["Razorfen Downs"],SHORT="RFD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\spell_shadow_raisedead", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="38-41"},
	{ID="290",NAME=FTAttuneLang["Razorfen Downs"],SHORT="RFD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\spell_shadow_raisedead", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="35-41"},
	{ID="295",NAME=FTAttuneLang["Krol'dok Stronghold"],SHORT="KS",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Both",ICON="Interface\\Icons\\inv_misc_monsterclaw_04", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="40-52"},
    {ID="320",NAME=FTAttuneLang["Uldaman"],SHORT="Ulda",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_pick_05", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="44-47"},
	{ID="330",NAME=FTAttuneLang["Uldaman"],SHORT="Ulda",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_pick_05", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="44-47"},
	{ID="350",NAME=FTAttuneLang["Zul'Farrak"],SHORT="ZF",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\achievement_boss_trollgore", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="45-48"},
	{ID="351",NAME=FTAttuneLang["Zul'Farrak"],SHORT="ZF",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\achievement_boss_trollgore", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="45-48"},
    {ID="355",NAME=FTAttuneLang["Alcaz Prison"],SHORT="AP",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Both",ICON="Interface\\Icons\\inv_misc_key_04", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="48-51"},
	{ID="300",NAME=FTAttuneLang["Maraudon"],SHORT="Mara",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_head_centaur_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="48-51"},
	{ID="310",NAME=FTAttuneLang["Maraudon"],SHORT="Mara",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_head_centaur_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="48-51"},
	{ID="370",NAME=FTAttuneLang["The Temple of Atal'Hakkar"],SHORT="ST",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="52-55"},
	{ID="380",NAME=FTAttuneLang["The Temple of Atal'Hakkar"],SHORT="ST",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="52-55"},
    {ID="390",NAME=FTAttuneLang["Blackrock Depths"],SHORT="BRD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_key_08", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="52-57"},
	{ID="400",NAME=FTAttuneLang["Blackrock Depths"],SHORT="BRD",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_key_08", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="52-57"},
    {ID="405",NAME=FTAttuneLang["Blackmaw Hold"],SHORT="BH",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Both",ICON="Interface\\Icons\\ability_druid_demoralizingroar", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="55-60"},
    {ID="340",NAME=FTAttuneLang["Dire Maul"],SHORT="DM",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_jewelry_talisman_10", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="55-60"},
    {ID="341",NAME=FTAttuneLang["Dire Maul"],SHORT="DM",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_jewelry_talisman_10", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="55-60"},
    {ID="345",NAME=FTAttuneLang["Lower Blackrock Spire"],SHORT="LBRS",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_gem_bloodstone_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="57-60"},
    {ID="346",NAME=FTAttuneLang["Lower Blackrock Spire"],SHORT="LBRS",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_gem_bloodstone_01", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="57-60"},
	{ID="410",NAME=FTAttuneLang["Scholomance"],SHORT="Scholo",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_book_11", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="58-60"},
	{ID="420",NAME=FTAttuneLang["Scholomance"],SHORT="Scholo",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_book_11", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="58-60"},
    {ID="415",NAME=FTAttuneLang["The Shapers Terrace"],SHORT="TST",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Both",ICON="Interface\\Icons\\inv_misc_gem_crystal_02", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="58-60"},
    {ID="360",NAME=FTAttuneLang["Stratholme"],SHORT="Strat",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_bone_skull_02", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="59-60"},
    {ID="361",NAME=FTAttuneLang["Stratholme"],SHORT="Strat",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_bone_skull_02", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="59-60"},
    {ID="365",NAME=FTAttuneLang["Upper Blackrock Spire"],SHORT="UBRS",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Alliance",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="58-60"},
    {ID="366",NAME=FTAttuneLang["Upper Blackrock Spire"],SHORT="UBRS",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['DUNGEONS'], FACTION="Horde",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath", DESC=FTAttuneLang["DungeonQuest_Desc"], GROUPSIZE=5, LEVELS="58-60"},
    
    -- keys
	{ID="159",NAME=FTAttuneLang["Tome of Dalaran"],SHORT="Dal Boss",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['KEYS'], FACTION="Both",ICON="Interface\\Icons\\inv_misc_book_04", DESC=FTAttuneLang["TD_Desc"]},
	{ID="154",NAME=FTAttuneLang["Dalaran Sewer Key"],SHORT="Dal Key",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['KEYS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_key_02", DESC=FTAttuneLang["Dal_Desc"]},
    {ID="155",NAME=FTAttuneLang["Dalaran Sewer Key"],SHORT="Dal Key",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['KEYS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_key_02", DESC=FTAttuneLang["Dal_Desc"]},
	{ID="125",NAME=FTAttuneLang["Scarlet Key"],SHORT="SM Key",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['KEYS'], FACTION="Both",ICON="Interface\\Icons\\inv_misc_key_01", DESC=FTAttuneLang["SK_Desc"]},
	{ID="120",NAME=FTAttuneLang["Blackrock Depths"],SHORT="BRD Key",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['KEYS'], FACTION="Both",ICON="Interface\\Icons\\inv_misc_key_08", DESC=FTAttuneLang["OnlyOne_Desc"]},
	{ID="140",NAME=FTAttuneLang["Scholomance"],SHORT="Scholo Key",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['KEYS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_key_11", DESC=FTAttuneLang["OnlyOne_Desc"]},
	{ID="150",NAME=FTAttuneLang["Scholomance"],SHORT="Scholo Key",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['KEYS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_key_11", DESC=FTAttuneLang["OnlyOne_Desc"]},

    -- raids
    {ID="20",NAME=FTAttuneLang["Molten Core"],SHORT="MC",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['RAIDS'], FACTION="Both",ICON="Interface\\Icons\\inv_hammer_unique_sulfuras", DESC=FTAttuneLang["MC_Desc"], GROUPSIZE=40, SHOWRAIDPLANNER=1},
	{ID="30",NAME=FTAttuneLang["Onyxia's Lair"],SHORT="Ony",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['RAIDS'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_head_dragon_01", DESC=FTAttuneLang["Ony_Desc"], GROUPSIZE=40, SHOWRAIDPLANNER=1},
	{ID="40",NAME=FTAttuneLang["Onyxia's Lair"],SHORT="Ony",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['RAIDS'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_head_dragon_01", DESC=FTAttuneLang["Ony_Desc"], GROUPSIZE=40, SHOWRAIDPLANNER=1},
	{ID="50",NAME=FTAttuneLang["Blackwing Lair"],SHORT="BWL",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['RAIDS'], FACTION="Both",ICON="Interface\\Icons\\inv_misc_head_dragon_black", DESC=FTAttuneLang["BWL_Desc"], GROUPSIZE=40, SHOWRAIDPLANNER=1},
	{ID="60",NAME=FTAttuneLang["Naxxramas"],SHORT="Naxx",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['RAIDS'], FACTION="Both",ICON="Interface\\Icons\\inv_trinket_naxxramas06", DESC=FTAttuneLang["All_Desc"], GROUPSIZE=40, SHOWRAIDPLANNER=1},

    -- misc
	{ID="90",NAME=FTAttuneLang["Cozy Sleeping Bag"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['MISC'], FACTION="Horde",ICON="Interface\\Icons\\inv_misc_bag_bigbagofenchantments", DESC=FTAttuneLang["CSB_Desc"]},
	{ID="95",NAME=FTAttuneLang["Cozy Sleeping Bag"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['MISC'], FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_bag_bigbagofenchantments", DESC=FTAttuneLang["CSB_Desc"]},
	{ID="80",NAME=FTAttuneLang["Aqual Quintessence"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['MISC'], FACTION="Both",ICON="Interface\\Icons\\inv_potion_76", DESC=FTAttuneLang["MC2_Desc"]},
	{ID="100",NAME=FTAttuneLang["Scepter of the Shifting Sands"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang['MISC'], FACTION="Both",ICON="Interface\\Icons\\inv_hammer_25", DESC=FTAttuneLang["AQ_Desc"]},
	

}

FTAttune_Data.noattunes = {
	{ID="1170",NAME=FTAttuneLang["Magtheridon's Lair"], GROUPSIZE=25, SHOWRAIDPLANNER=2},
	{ID="1190",NAME=FTAttuneLang["Gruul's Lair"], GROUPSIZE=25, SHOWRAIDPLANNER=2},
	{ID="2100",NAME=FTAttuneLang["Zul'Aman"], GROUPSIZE=10, SHOWRAIDPLANNER=5},
	{ID="2200",NAME=FTAttuneLang["Sunwell Plateau"], GROUPSIZE=25, SHOWRAIDPLANNER=2},
}

FTAttune_Data.steps = 	{

	{ID_ATTUNE="20",ID="20",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="1"},
	{ID_ATTUNE="20",ID="30",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7848",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="2"}, -- quest: Attunement to the Core
	{ID_ATTUNE="20",ID="40",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="18412",ICON="Interface\\Icons\\inv_misc_gem_opal_01",FOLLOWS="30",STAGE="3"}, -- item: Core Fragment
	{ID_ATTUNE="20",ID="45",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7848",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="4"}, -- quest: Attunement to the Core
	{ID_ATTUNE="20",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_hammer_unique_sulfuras",FOLLOWS="45",STAGE="5"},

	{ID_ATTUNE="30",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="30",ID="20",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4903",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="50"}, -- quest: Warlord's Command
	{ID_ATTUNE="30",ID="30",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="9196",ICON="Interface\\Icons\\achievement_reputation_ogre",FOLLOWS="20",STAGE="60"}, -- npc: Highlord Omokk
	{ID_ATTUNE="30",ID="40",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="9237",ICON="Interface\\Icons\\achievement_character_troll_male",FOLLOWS="20",STAGE="60"}, -- npc: War Master Voone
	{ID_ATTUNE="30",ID="50",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="9568",ICON="Interface\\Icons\\achievement_boss_overlord_wyrmthalak",FOLLOWS="20",STAGE="60"}, -- npc: Overlord Wyrmthalak
	{ID_ATTUNE="30",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12562",ICON="Interface\\Icons\\inv_scroll_02",FOLLOWS="20",STAGE="60"}, -- item: Important Blackrock Documents
	{ID_ATTUNE="30",ID="65",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4903",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60&30&40&50",STAGE="70"}, -- quest: Warlord's Command
	{ID_ATTUNE="30",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="4941",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="65",STAGE="80"}, -- quest: Eitrigg's Wisdom
	{ID_ATTUNE="30",ID="80",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="4974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="90"}, -- quest: For The Horde!
	{ID_ATTUNE="30",ID="90",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10429",ICON="Interface\\Icons\\inv_misc_head_orc_01",FOLLOWS="80",STAGE="100"}, -- npc: Warchief Rend Blackhand
	{ID_ATTUNE="30",ID="95",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="4974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="105"}, -- quest: For The Horde!
	{ID_ATTUNE="30",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="6566",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="95",STAGE="110"}, -- quest: What the Wind Carries
	{ID_ATTUNE="30",ID="110",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="6567",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="100",STAGE="120"}, -- quest: The Champion of the Horde
	{ID_ATTUNE="30",ID="115",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="10182",ICON="Interface\\Icons\\inv_rexxar",FOLLOWS="110",STAGE="130"}, -- npc: Rexxar
	{ID_ATTUNE="30",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="6568",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="115",STAGE="140"}, -- quest: The Testament of Rexxar
	{ID_ATTUNE="30",ID="130",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="6569",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="150"}, -- quest: Oculus Illusions
	{ID_ATTUNE="30",ID="140",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="16786",ICON="Interface\\Icons\\inv_misc_eye_01",FOLLOWS="130",STAGE="160", COUNT=20}, -- item: Black Dragonspawn Eye
	{ID_ATTUNE="30",ID="145",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="6569",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="140",STAGE="165"}, -- quest: Oculus Illusions
	{ID_ATTUNE="30",ID="150",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6570",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="145",STAGE="170"}, -- quest: Emberstrife
	{ID_ATTUNE="30",ID="160",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6584",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="150",STAGE="180"}, -- quest: The Test of Skulls, Chronalis
	{ID_ATTUNE="30",ID="170",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6582",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="150",STAGE="180"}, -- quest: The Test of Skulls, Scryer
	{ID_ATTUNE="30",ID="180",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6583",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="150",STAGE="180"}, -- quest: The Test of Skulls, Somnus
	{ID_ATTUNE="30",ID="190",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8197",ICON="Interface\\Icons\\inv_misc_head_dragon_bronze",FOLLOWS="160",STAGE="190"}, -- npc: Chronalis
	{ID_ATTUNE="30",ID="195",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6584",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="190",STAGE="195"}, -- quest: The Test of Skulls, Chronalis
	{ID_ATTUNE="30",ID="200",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="10664",ICON="Interface\\Icons\\inv_misc_head_dragon_blue",FOLLOWS="170",STAGE="190"}, -- npc: Scryer
	{ID_ATTUNE="30",ID="205",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6582",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="200",STAGE="195"}, -- quest: The Test of Skulls, Scryer
	{ID_ATTUNE="30",ID="210",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="12900",ICON="Interface\\Icons\\inv_misc_head_dragon_green",FOLLOWS="180",STAGE="190"}, -- npc: Somnus
	{ID_ATTUNE="30",ID="215",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6583",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="210",STAGE="195"}, -- quest: The Test of Skulls, Somnus
	{ID_ATTUNE="30",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6585",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="195&205&215",STAGE="200"}, -- quest: The Test of Skulls, Axtroz
	{ID_ATTUNE="30",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="12899",ICON="Interface\\Icons\\inv_misc_head_dragon_red",FOLLOWS="220",STAGE="210"}, -- npc: Axtroz
	{ID_ATTUNE="30",ID="235",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6585",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="215"}, -- quest: The Test of Skulls, Axtroz
	{ID_ATTUNE="30",ID="240",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="6601",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="235",STAGE="220"}, -- quest: Ascension...
	{ID_ATTUNE="30",ID="245",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="10182",ICON="Interface\\Icons\\inv_rexxar",FOLLOWS="240",STAGE="230"}, -- npc: Rexxar
	{ID_ATTUNE="30",ID="250",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="6602",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="245",STAGE="240"}, -- quest: Blood of the Black Dragon Champion
	{ID_ATTUNE="30",ID="260",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10363",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath",FOLLOWS="250",STAGE="250"}, -- npc: General Drakkisath
	{ID_ATTUNE="30",ID="265",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="10182",ICON="Interface\\Icons\\inv_rexxar",FOLLOWS="260",STAGE="260"}, -- npc: Rexxar
	{ID_ATTUNE="30",ID="268",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="6602",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="265",STAGE="265"}, -- quest: Blood of the Black Dragon Champion
	{ID_ATTUNE="30",ID="270",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_jewelry_talisman_11",FOLLOWS="268",STAGE="270"},


	{ID_ATTUNE="40",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 48",LOCATION="",ID_WOWHEAD="48",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="1"},
	{ID_ATTUNE="40",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4182",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="2"}, -- quest: Dragonkin Menace
	{ID_ATTUNE="40",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4183",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="3"}, -- quest: The True Masters
	{ID_ATTUNE="40",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="4184",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="4"}, -- quest: The True Masters
	{ID_ATTUNE="40",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="4185",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="5"}, -- quest: The True Masters
	{ID_ATTUNE="40",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="4186",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="6"}, -- quest: The True Masters
	{ID_ATTUNE="40",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="4223",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="7"}, -- quest: The True Masters
	{ID_ATTUNE="40",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4224",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="8"}, -- quest: The True Masters
	{ID_ATTUNE="40",ID="90",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4241",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="9"}, -- quest: Marshal Windsor
	{ID_ATTUNE="40",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4242",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="10"}, -- quest: Abandoned Hope
	{ID_ATTUNE="40",ID="110",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11446",ICON="Interface\\Icons\\inv_misc_note_05",FOLLOWS="100",STAGE="11"}, -- item: A Crumpled Up Note
	{ID_ATTUNE="40",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4264",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="12"}, -- quest: A Crumpled Up Note
	{ID_ATTUNE="40",ID="130",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4282",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="13"}, -- quest: A shred of Hope
	{ID_ATTUNE="40",ID="140",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="8983",ICON="Interface\\Icons\\inv_misc_head_dwarf_01",FOLLOWS="130",STAGE="14"}, -- npc: Golem Lord Argelmach
	{ID_ATTUNE="40",ID="150",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="9033",ICON="Interface\\Icons\\inv_misc_head_dwarf_01",FOLLOWS="130",STAGE="14"}, -- npc: General Angerforge
	{ID_ATTUNE="40",ID="160",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11465",ICON="Interface\\Icons\\inv_misc_rune_07",FOLLOWS="140",STAGE="15"}, -- item: Marshal Windsor's Lost Information
	{ID_ATTUNE="40",ID="170",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11464",ICON="Interface\\Icons\\inv_misc_rune_07",FOLLOWS="150",STAGE="15"}, -- item: Marshal Windsor's Lost Information
	{ID_ATTUNE="40",ID="175",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4282",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="170&160",STAGE="16"}, -- quest: A shred of Hope
	{ID_ATTUNE="40",ID="180",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4322",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="175",STAGE="17"}, -- quest: Jail Break
	{ID_ATTUNE="40",ID="190",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="6402",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="180",STAGE="18"}, -- quest: Stormwind Rendezvous
	{ID_ATTUNE="40",ID="200",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="17804",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="190",STAGE="19"}, -- npc: Squire Rowe
	{ID_ATTUNE="40",ID="210",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="6403",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="200",STAGE="20"}, -- quest: The Great Masquerade
	{ID_ATTUNE="40",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="6501",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="210",STAGE="21"}, -- quest: The Dragon's Eye
	{ID_ATTUNE="40",ID="230",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="10929",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="220",STAGE="22"}, -- npc: Haleh
	{ID_ATTUNE="40",ID="240",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="6502",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="23"}, -- quest: Drakefire Amulet
	{ID_ATTUNE="40",ID="250",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10363",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath",FOLLOWS="240",STAGE="24"}, -- npc: General Drakkisath
	{ID_ATTUNE="40",ID="260",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="10929",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="250",STAGE="25"}, -- npc: Haleh
	{ID_ATTUNE="40",ID="265",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="6502",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="260",STAGE="26"}, -- quest: Drakefire Amulet
	{ID_ATTUNE="40",ID="270",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_jewelry_talisman_11",FOLLOWS="265",STAGE="27"},

	{ID_ATTUNE="50",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="50",ID="20",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="9046",ICON="Interface\\Icons\\inv_misc_head_orc_01",FOLLOWS="10",STAGE="20"}, -- npc: Scarshield Quartermaster
	{ID_ATTUNE="50",ID="30",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="18987",ICON="Interface\\Icons\\inv_letter_17",FOLLOWS="20",STAGE="30"}, -- item: Blackhand's Command
	{ID_ATTUNE="50",ID="40",TYPE="Pick Up",STEP=" Command",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- quest: Blackhand's Command
	{ID_ATTUNE="50",ID="50",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10363",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath",FOLLOWS="40",STAGE="50"}, -- npc: General Drakkisath
	{ID_ATTUNE="50",ID="60",TYPE="Click",STEP=FTAttuneLang["Drakkisath's Brand"],LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="1",ICON="Interface\\Icons\\inv_misc_orb_05",FOLLOWS="50",STAGE="60"},
	{ID_ATTUNE="50",ID="65",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="65"}, -- quest: Blackhand's Command
	{ID_ATTUNE="50",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_head_dragon_black",FOLLOWS="65",STAGE="70"},

	{ID_ATTUNE="60",ID="5",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="5"},
	{ID_ATTUNE="60",ID="10",TYPE="Rep",STEP=FTAttuneLang["Honored with"].." "..FTAttuneLang["Argent Dawn"],LOCATION="529",ID_WOWHEAD="9000",ICON="Interface\\Icons\\inv_jewelry_talisman_07",FOLLOWS="5",STAGE="10", OR=true},
	{ID_ATTUNE="60",ID="20",TYPE="Rep",STEP=FTAttuneLang["Revered with"].." "..FTAttuneLang["Argent Dawn"],LOCATION="529",ID_WOWHEAD="21000",ICON="Interface\\Icons\\inv_jewelry_talisman_07",FOLLOWS="5",STAGE="10", OR=true},
	{ID_ATTUNE="60",ID="30",TYPE="Rep",STEP=FTAttuneLang["Exalted with"].." "..FTAttuneLang["Argent Dawn"],LOCATION="529",ID_WOWHEAD="42000",ICON="Interface\\Icons\\inv_jewelry_talisman_07",FOLLOWS="5",STAGE="10", OR=true},
	{ID_ATTUNE="60",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="9121",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Dread Citadel - Naxxramas
	{ID_ATTUNE="60",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="9122",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="20"}, -- quest: The Dread Citadel - Naxxramas
	{ID_ATTUNE="60",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="9123",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="20"}, -- quest: The Dread Citadel - Naxxramas
	{ID_ATTUNE="60",ID="90",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_trinket_naxxramas06",FOLLOWS="40|50|60",STAGE="30"},

	
    {ID_ATTUNE="100",ID="5",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="5"},
    {ID_ATTUNE="100",ID="10",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="15180",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="0",STAGE="10"}, -- npc: Baristolth of the Shifting Sands
	{ID_ATTUNE="100",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="8286",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: What Tomorrow Brings
	{ID_ATTUNE="100",ID="30",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="8288",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: Only One May Rise
	{ID_ATTUNE="100",ID="40",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="12017",ICON="Interface\\Icons\\inv_misc_head_dragon_black",FOLLOWS="30",STAGE="40"}, -- npc: Broodlord Lashlayer
	{ID_ATTUNE="100",ID="50",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="20383",ICON="Interface\\Icons\\spell_shadow_curseoftounges",FOLLOWS="40",STAGE="50"}, -- item: Head of the Broodlord Lashlayer
	{ID_ATTUNE="100",ID="60",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="8288",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- quest: Only One May Rise
	{ID_ATTUNE="100",ID="65",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="100",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="8301",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- quest: The Path of the Righteous
	{ID_ATTUNE="100",ID="80",TYPE="Rep",STEP=FTAttuneLang["Neutral with"].." "..FTAttuneLang["Brood of Nozdormu"],LOCATION="910",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_head_dragon_bronze",FOLLOWS="0",STAGE="70", OFFSET=42000},
	{ID_ATTUNE="100",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="8303",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80&70",STAGE="80"}, -- quest: Anachronos
	{ID_ATTUNE="100",ID="110",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8305",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="100",STAGE="90"}, -- quest: Long Forgotten Memories
	{ID_ATTUNE="100",ID="120",TYPE="Click",STEP=FTAttuneLang["Crystalline Tear"],LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="2",ICON="Interface\\Icons\\inv_misc_gem_ruby_01",FOLLOWS="110",STAGE="100"},
	{ID_ATTUNE="100",ID="130",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="8519",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="110"}, -- quest: A Pawn on the Eternal Board
	{ID_ATTUNE="100",ID="140",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8555",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="120"}, -- quest: The Charge of the Dragonflights
	{ID_ATTUNE="100",ID="150",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="13020",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="140",STAGE="130"}, -- npc: Vaelastrasz the Corrupt
	{ID_ATTUNE="100",ID="160",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="8730",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="150",STAGE="140"}, -- quest: Nefarius's Corruption
	{ID_ATTUNE="100",ID="170",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="11583",ICON="Interface\\Icons\\inv_misc_head_dragon_black",FOLLOWS="160",STAGE="150"}, -- npc: Nefarian
	{ID_ATTUNE="100",ID="180",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="21138",ICON="Interface\\Icons\\inv_misc_gem_ruby_03",FOLLOWS="170",STAGE="160"}, -- item: Red Scepter Shard
	{ID_ATTUNE="100",ID="190",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="8730",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="180",STAGE="170"}, -- quest: Nefarius's Corruption
	{ID_ATTUNE="100",ID="200",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="15362",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="140",STAGE="130"}, -- npc: Malfurion Stormrage
	{ID_ATTUNE="100",ID="210",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="8733",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="200",STAGE="140"}, -- quest: Eranikus, Tyrant of the Dream
	{ID_ATTUNE="100",ID="220",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="15624",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="210",STAGE="150"}, -- npc: Forest Wisp
	{ID_ATTUNE="100",ID="230",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="8734",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="160"}, -- quest: Tyrande and Remulos
	{ID_ATTUNE="100",ID="241",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="160"},
	{ID_ATTUNE="100",ID="242",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="160"},
	{ID_ATTUNE="100",ID="240",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="8735",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="170"}, -- quest: The Nightmare's Corruption
	{ID_ATTUNE="100",ID="241",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Hinterlands"],ID_WOWHEAD="21146",ICON="Interface\\Icons\\spell_shadow_antimagicshell",FOLLOWS="0",STAGE="170"}, -- item: Fragment of the Nightmare's Corruption
	{ID_ATTUNE="100",ID="242",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="170"},
	{ID_ATTUNE="100",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="180"},
	{ID_ATTUNE="100",ID="251",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="21147",ICON="Interface\\Icons\\spell_shadow_antimagicshell",FOLLOWS="0",STAGE="180"}, -- item: Fragment of the Nightmare's Corruption
	{ID_ATTUNE="100",ID="252",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="182"},
	{ID_ATTUNE="100",ID="253",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="21148",ICON="Interface\\Icons\\spell_shadow_antimagicshell",FOLLOWS="0",STAGE="182"}, -- item: Fragment of the Nightmare's Corruption
	{ID_ATTUNE="100",ID="254",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="184"},
	{ID_ATTUNE="100",ID="255",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Duskwood"],ID_WOWHEAD="21149",ICON="Interface\\Icons\\spell_shadow_antimagicshell",FOLLOWS="0",STAGE="184"}, -- item: Fragment of the Nightmare's Corruption
	{ID_ATTUNE="100",ID="259",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="190"},
	{ID_ATTUNE="100",ID="260",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="8735",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240&241&251&253&255",STAGE="190"}, -- quest: The Nightmare's Corruption
	{ID_ATTUNE="100",ID="261",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="190"},
	{ID_ATTUNE="100",ID="262",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="190"},
	{ID_ATTUNE="100",ID="269",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="200"},
	{ID_ATTUNE="100",ID="270",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="8736",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="260",STAGE="200"}, -- quest: The Nightmare Manifests
	{ID_ATTUNE="100",ID="271",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="200"},
	{ID_ATTUNE="100",ID="272",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="200"},
	{ID_ATTUNE="100",ID="279",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="210"},
	{ID_ATTUNE="100",ID="280",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="21139",ICON="Interface\\Icons\\inv_misc_gem_emerald_03",FOLLOWS="270",STAGE="210"}, -- item: Green Scepter Shard
	{ID_ATTUNE="100",ID="281",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="210"},
	{ID_ATTUNE="100",ID="282",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="210"},
	{ID_ATTUNE="100",ID="289",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="220"},
	{ID_ATTUNE="100",ID="290",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="8741",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="280",STAGE="220"}, -- quest: The Champion Returns
	{ID_ATTUNE="100",ID="291",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="220"},
	{ID_ATTUNE="100",ID="292",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="220"},
	{ID_ATTUNE="100",ID="299",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="130"},
	{ID_ATTUNE="100",ID="300",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="15481",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="140",STAGE="130"}, -- npc: Spirit of Azuregos
	{ID_ATTUNE="100",ID="309",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="140"},
	{ID_ATTUNE="100",ID="310",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="8575",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="300",STAGE="140"}, -- quest: Azuregos's Magical Ledger
	{ID_ATTUNE="100",ID="319",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="150"},
	{ID_ATTUNE="100",ID="320",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="11811",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="310",STAGE="150"}, -- npc: Narain Soothfancy
	{ID_ATTUNE="100",ID="327",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="222"},
	{ID_ATTUNE="100",ID="328",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="222"},
	{ID_ATTUNE="100",ID="329",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="222"},
	{ID_ATTUNE="100",ID="330",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8576",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="222"}, -- quest: Translating the Ledger
	{ID_ATTUNE="100",ID="339",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="225"},
	{ID_ATTUNE="100",ID="349",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="230"},
	{ID_ATTUNE="100",ID="358",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="240"},
	{ID_ATTUNE="100",ID="368",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="250"},
	{ID_ATTUNE="100",ID="531",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="276"},
	{ID_ATTUNE="100",ID="549",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="280"},
	{ID_ATTUNE="100",ID="551",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="281"},
	{ID_ATTUNE="100",ID="553",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="283"},
	{ID_ATTUNE="100",ID="555",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="284"},
	{ID_ATTUNE="100",ID="557",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="285"},
	{ID_ATTUNE="100",ID="559",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="286"},
	{ID_ATTUNE="100",ID="561",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="287"},
	{ID_ATTUNE="100",ID="563",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="288"},
	{ID_ATTUNE="100",ID="565",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="289"},
	{ID_ATTUNE="100",ID="567",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="290"},
	{ID_ATTUNE="100",ID="450",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8597",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="225"}, -- quest: Draconic for Dummies
	{ID_ATTUNE="100",ID="460",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="15526",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="450",STAGE="230"}, -- npc: Meridith the Mermaiden
	{ID_ATTUNE="100",ID="470",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8599",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="460",STAGE="240"}, -- quest: Love Song for Narain
	{ID_ATTUNE="100",ID="480",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="15526",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="470",STAGE="250"}, -- npc: Meridith the Mermaiden
	{ID_ATTUNE="100",ID="490",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8597",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="480",STAGE="260"}, -- quest: Draconic for Dummies
	{ID_ATTUNE="100",ID="500",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8598",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="490",STAGE="270"}, -- quest: rAnS0m
	{ID_ATTUNE="100",ID="510",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8606",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="500",STAGE="272"}, -- quest: Decoy!
	{ID_ATTUNE="100",ID="520",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="15554",ICON="Interface\\Icons\\ability_hunter_pet_gorilla",FOLLOWS="510",STAGE="274"}, -- npc: Number Two
	{ID_ATTUNE="100",ID="530",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8606",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="276"}, -- quest: Decoy!
	{ID_ATTUNE="100",ID="540",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8620",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="278"}, -- quest: The Only Prescription
	{ID_ATTUNE="100",ID="546",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="15552",ICON="Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_gnome_male",FOLLOWS="0",STAGE="278"}, -- npc: Doctor Weavil
	{ID_ATTUNE="100",ID="550",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="21103",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="546",STAGE="280"}, -- item: Draconic for Dummies - Chapter I
	{ID_ATTUNE="100",ID="552",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blasted Lands"],ID_WOWHEAD="21104",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="0",STAGE="281"}, -- item: Draconic for Dummies - Chapter II
	{ID_ATTUNE="100",ID="554",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="21105",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="0",STAGE="283"}, -- item: Draconic for Dummies - Chapter III
	{ID_ATTUNE="100",ID="556",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="21106",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="0",STAGE="284"}, -- item: Draconic for Dummies - Chapter IV
	{ID_ATTUNE="100",ID="558",TYPE="Item",STEP="",LOCATION="Stormwind",ID_WOWHEAD="21107",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="0",STAGE="285"}, -- item: Draconic for Dummies - Chapter V
	{ID_ATTUNE="100",ID="560",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Onyxia's Lair"],ID_WOWHEAD="10184",ICON="Interface\\Icons\\inv_misc_head_dragon_01",FOLLOWS="0",STAGE="286"}, -- npc: Onyxia
	{ID_ATTUNE="100",ID="562",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="21108",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="560",STAGE="287"}, -- item: Draconic for Dummies - Chapter VI
	{ID_ATTUNE="100",ID="564",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackwing Lair"],ID_WOWHEAD="21109",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="0",STAGE="288"}, -- item: Draconic for Dummies - Chapter VII
	{ID_ATTUNE="100",ID="566",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="11502",ICON="Interface\\Icons\\inv_hammer_unique_sulfuras",FOLLOWS="0",STAGE="289"}, -- npc: Ragnaros
	{ID_ATTUNE="100",ID="568",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="21110",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="566",STAGE="290"}, -- item: Draconic for Dummies - Chapter VIII
	{ID_ATTUNE="100",ID="570",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="21111",ICON="Interface\\Icons\\inv_misc_book_06",FOLLOWS="540&550&552&554&556&558&562&564&568",STAGE="295"}, -- item: Draconic For Dummies: Volume II
	{ID_ATTUNE="100",ID="580",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8620",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="570",STAGE="300"}, -- quest: The Only Prescription
	{ID_ATTUNE="100",ID="571",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="295"},
	{ID_ATTUNE="100",ID="581",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="300"},
	{ID_ATTUNE="100",ID="680",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8584",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="225"}, -- quest: Never Ask Me About My Business
	{ID_ATTUNE="100",ID="690",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8585",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="680",STAGE="230"}, -- quest: The Isle of Dread!
	{ID_ATTUNE="100",ID="695",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="12803",ICON="Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\ability_hunter_pet_chimera",FOLLOWS="690",STAGE="240"}, -- npc: Lord Lakmaeran
	{ID_ATTUNE="100",ID="700",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="21027",ICON="Interface\\Icons\\inv_misc_food_15",FOLLOWS="695",STAGE="250"}, -- item: Lakmaeran's Carcass
	{ID_ATTUNE="100",ID="710",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="21024",ICON="Interface\\Icons\\inv_misc_food_70",FOLLOWS="700",STAGE="260", COUNT=20}, -- item: Chimaerok Tenderloin
	{ID_ATTUNE="100",ID="720",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8585",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="710",STAGE="270"}, -- quest: The Isle of Dread!
	{ID_ATTUNE="100",ID="730",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8586",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="720",STAGE="272"}, -- quest: Dirge's Kickin' Chimaerok Chops
	{ID_ATTUNE="100",ID="740",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8587",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="274"}, -- quest: Return to Narain
	{ID_ATTUNE="100",ID="790",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8577",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="225"}, -- quest: Stewvul, Ex-B.F.F.
	{ID_ATTUNE="100",ID="800",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="8578",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="790",STAGE="230"}, -- quest: Scrying Goggles? No Problem!
	{ID_ATTUNE="100",ID="810",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="20951",ICON="Interface\\Icons\\inv_helmet_47",FOLLOWS="800",STAGE="240"}, -- item: Narain's Scrying Goggles
	{ID_ATTUNE="100",ID="820",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8578",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="810",STAGE="250"}, -- quest: Scrying Goggles? No Problem!
	{ID_ATTUNE="100",ID="887",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="310"},
	{ID_ATTUNE="100",ID="888",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="310"},
	{ID_ATTUNE="100",ID="889",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="310"},	
	{ID_ATTUNE="100",ID="890",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8728",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="580&820&740",STAGE="310"}, -- quest: The Good News and The Bad News
	{ID_ATTUNE="100",ID="900",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8729",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="890",STAGE="320"}, -- quest: The Wrath of Neptulon
	{ID_ATTUNE="100",ID="910",TYPE="Kill",STEP="Maws",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="15571",ICON="Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\inv_pet_babyshark",FOLLOWS="900",STAGE="330"}, -- npc: Maws
	{ID_ATTUNE="100",ID="920",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="21137",ICON="Interface\\Icons\\inv_misc_gem_sapphire_03",FOLLOWS="910",STAGE="340"}, -- item: Blue Scepter Shard
	{ID_ATTUNE="100",ID="930",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8729",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="920",STAGE="350"}, -- quest: The Wrath of Neptulon
	{ID_ATTUNE="100",ID="940",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="8742",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="190&290&930",STAGE="360"}, -- quest: The Might of Kalimdor
	{ID_ATTUNE="100",ID="941",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="360"},
	{ID_ATTUNE="100",ID="942",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="360"},
	{ID_ATTUNE="100",ID="943",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="360"},
	--{ID_ATTUNE="100",ID="950",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="21175",ICON="Interface\\Icons\\inv_hammer_25",FOLLOWS="940",STAGE="370"}, -- item: The Scepter of the Shifting Sands
	{ID_ATTUNE="100",ID="960",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="8745",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="940",STAGE="380"}, -- quest: Treasure of the Timeless One
	{ID_ATTUNE="100",ID="970",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="",ICON="Interface\\Icons\\inv_hammer_25",FOLLOWS="960",STAGE="390"},
	

--v247
	{ID_ATTUNE="120",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 48",LOCATION="",ID_WOWHEAD="48",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="120",ID="20",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="8888",ICON="Interface\\Icons\\achievement_character_dwarf_male",FOLLOWS="10",STAGE="20"}, -- npc: Franclorn Forgewright
	{ID_ATTUNE="120",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="3801",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: Dark Iron Legacy
	{ID_ATTUNE="120",ID="40",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="3802",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- quest: Dark Iron Legacy
	{ID_ATTUNE="120",ID="50",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="9056",ICON="Interface\\Icons\\Inv_misc_head_dwarf_01",FOLLOWS="40",STAGE="50"}, -- npc: Fineous Darkvire
	{ID_ATTUNE="120",ID="60",TYPE="Click",STEP=FTAttuneLang["Shrine of Thaurissan"],LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="3",ICON="Interface\\Icons\\inv_hammer_23",FOLLOWS="50",STAGE="60"},
	{ID_ATTUNE="120",ID="65",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="3802",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="65"}, -- quest: Dark Iron Legacy
	{ID_ATTUNE="120",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_key_08",FOLLOWS="65",STAGE="70"},


	{ID_ATTUNE="140",ID="4",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="4"},
	{ID_ATTUNE="140",ID="6",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5096",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="4",STAGE="6"}, -- quest: Scarlet Diversions
	{ID_ATTUNE="140",ID="7",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5098",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="6",STAGE="7"}, -- quest: All Along the Watchtowers
	{ID_ATTUNE="140",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="7",STAGE="10"},
	{ID_ATTUNE="140",ID="20",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="10837",ICON="Interface\\Icons\\inv_misc_head_undead_01",FOLLOWS="10",STAGE="20"}, -- npc: High Executor Derrington
	{ID_ATTUNE="140",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="838",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: Scholomance
	{ID_ATTUNE="140",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="964",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- quest: Skeletal Fragments
	{ID_ATTUNE="140",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5514",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- quest: Mold Rhymes With...
	{ID_ATTUNE="140",ID="60",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="5514",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- quest: Mold Rhymes With...
	{ID_ATTUNE="140",ID="70",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="5802",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- quest: Fire Plume Forged
	{ID_ATTUNE="140",ID="80",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5802",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- quest: Fire Plume Forged
	{ID_ATTUNE="140",ID="90",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5804",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- quest: Araj's Scarab
	{ID_ATTUNE="140",ID="100",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="1852",ICON="Interface\\Icons\\spell_frost_frostarmor",FOLLOWS="90",STAGE="100"}, -- npc: Araj the Summoner
	{ID_ATTUNE="140",ID="110",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="14610",ICON="Interface\\Icons\\spell_shadow_grimward",FOLLOWS="100",STAGE="110"}, -- item: Araj's Scarab
	{ID_ATTUNE="140",ID="120",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5804",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="120"}, -- quest: Araj's Scarab
	{ID_ATTUNE="140",ID="130",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5511",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="130"}, -- quest: The Key to Scholomance
	{ID_ATTUNE="140",ID="140",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_key_11",FOLLOWS="130",STAGE="140"},
	
	{ID_ATTUNE="150",ID="4",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="4"},
	{ID_ATTUNE="150",ID="6",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5092",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="4",STAGE="6"}, -- quest: Clear the Way
	{ID_ATTUNE="150",ID="7",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5097",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="6",STAGE="7"}, -- quest: All Along the Watchtowers
	{ID_ATTUNE="150",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="7",STAGE="10"},
	{ID_ATTUNE="150",ID="20",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="10838",ICON="Interface\\Icons\\inv_bannerpvp_02",FOLLOWS="10",STAGE="20"}, -- npc: Commander Ashlam Valorfist
	{ID_ATTUNE="150",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5533",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: Scholomance
	{ID_ATTUNE="150",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5537",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- quest: Skeletal Fragments
	{ID_ATTUNE="150",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5538",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- quest: Mold Rhymes With...
	{ID_ATTUNE="150",ID="60",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="5538",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- quest: Mold Rhymes With...
	{ID_ATTUNE="150",ID="70",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="5801",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- quest: Fire Plume Forged
	{ID_ATTUNE="150",ID="80",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5801",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- quest: Fire Plume Forged
	{ID_ATTUNE="150",ID="90",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5803",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- quest: Araj's Scarab
	{ID_ATTUNE="150",ID="100",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="1852",ICON="Interface\\Icons\\spell_frost_frostarmor",FOLLOWS="90",STAGE="100"}, -- npc: Araj the Summoner
	{ID_ATTUNE="150",ID="110",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="14610",ICON="Interface\\Icons\\spell_shadow_grimward",FOLLOWS="100",STAGE="110"}, -- item: Araj's Scarab
	{ID_ATTUNE="150",ID="120",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5803",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="120"}, -- quest: Araj's Scarab
	{ID_ATTUNE="150",ID="130",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5505",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="130"}, -- quest: The Key to Scholomance
	{ID_ATTUNE="150",ID="140",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_key_11",FOLLOWS="130",STAGE="140"},

-- Alliance Dalaran Sewer Key (154): City of Dalaran chain through Blood in the Streets, then the key item
    {ID_ATTUNE="154",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 24",LOCATION="",ID_WOWHEAD="24",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
    {ID_ATTUNE="154",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="92432",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: an-alarming-request
    {ID_ATTUNE="154",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="92458",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: heart-of-disruption
    {ID_ATTUNE="154",ID="40",TYPE="Item",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="277507",ICON="Interface\\Icons\\inv_misc_key_02",FOLLOWS="30",STAGE="40"}, -- item: Dalaran Sewer Key
    -- {ID_ATTUNE="154",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="92459",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- quest: Friend of the Kirin Tor
    {ID_ATTUNE="154",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_key_02",FOLLOWS="40",STAGE="60"},

-- Horde Dalaran Sewer Key (155): City of Dalaran chain through Blood in the Streets, then the key item
	{ID_ATTUNE="155",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 24",LOCATION="",ID_WOWHEAD="24",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="155",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="544",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Prison Break In
	{ID_ATTUNE="155",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="93680",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Key to the City
	{ID_ATTUNE="155",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="545",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Dalaran Patrols
	{ID_ATTUNE="155",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="279469",ICON="Interface\\Icons\\inv_misc_key_02",FOLLOWS="320",STAGE="30"}, -- item: Grimy Key
	{ID_ATTUNE="155",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="430",STAGE="40"},
	{ID_ATTUNE="155",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="93680",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Key to the City
	{ID_ATTUNE="155",ID="450",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="92434",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440&340",STAGE="50"}, -- quest: Blood in the Streets
	{ID_ATTUNE="155",ID="470",TYPE="Item",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="277507",ICON="Interface\\Icons\\inv_misc_key_02",FOLLOWS="450",STAGE="60"}, -- item: Dalaran Sewer Key
	{ID_ATTUNE="155",ID="500",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_key_02",FOLLOWS="470",STAGE="70"},

-- Scarlet Key (125): both factions. Kill Arcanist Doan, then loot The Scarlet Key from Doan's Strongbox.
	{ID_ATTUNE="125",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 25",LOCATION="",ID_WOWHEAD="25",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="125",ID="20",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="6487",ICON="Interface\\Icons\\spell_nature_wispsplode",FOLLOWS="10",STAGE="20"}, -- npc: Arcanist Doan
	{ID_ATTUNE="125",ID="30",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="7146",ICON="Interface\\Icons\\inv_misc_key_01",FOLLOWS="20",STAGE="30"}, -- item: The Scarlet Key
	{ID_ATTUNE="125",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_key_01",FOLLOWS="30",STAGE="40"},

-- Tome of Dalaran (159): both factions. Black Tome is on the table behind Arugal. Use it at the Ambermill Leyline Focus.
	{ID_ATTUNE="159",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 23",LOCATION="",ID_WOWHEAD="23",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="159",ID="20",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="4275",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="10",STAGE="20"}, -- npc: Archmage Arugal
	{ID_ATTUNE="159",ID="30",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="276561",ICON="Interface\\Icons\\inv_misc_book_04",FOLLOWS="20",STAGE="30"}, -- item: Black Tome (table behind Arugal)
	{ID_ATTUNE="159",ID="40",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="ambermill",ICON="Interface\\Icons\\spell_arcane_starfire",FOLLOWS="30",STAGE="40"}, -- Ambermill Leyline Focus (63.4, 64.3); use the Black Tome
	{ID_ATTUNE="159",ID="50",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="275989",ICON="Interface\\Icons\\inv_misc_book_04",FOLLOWS="40",STAGE="50"}, -- item: Tome of Dalaran
	{ID_ATTUNE="159",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_04",FOLLOWS="50",STAGE="60"},
    
--v250
	{ID_ATTUNE="80",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="80",ID="20",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="13278",ICON="Interface\\Icons\\spell_frost_summonwaterelemental",FOLLOWS="10",STAGE="20"}, -- npc: Duke Hydraxis
	{ID_ATTUNE="80",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="6804",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: Poisoned Water
	{ID_ATTUNE="80",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="6805",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: Stormers and Rumblers
	{ID_ATTUNE="80",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="6821",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30&40",STAGE="40"}, -- quest: Eye of the Emberseer
	{ID_ATTUNE="80",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="6822",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="50"}, -- quest: The Molten Core
	{ID_ATTUNE="80",ID="68",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="0",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="80",ID="70",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="6823",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="60"}, -- quest: Agent of Hydraxis
	{ID_ATTUNE="80",ID="80",TYPE="Rep",STEP=FTAttuneLang["Honored with"].." "..FTAttuneLang["Hydraxian Waterlords"],LOCATION="749",ID_WOWHEAD="9000",ICON="Interface\\Icons\\spell_frost_summonwaterelemental",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="80",ID="90",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="6823",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70&80",STAGE="80"}, -- quest: Agent of Hydraxis
	{ID_ATTUNE="80",ID="100",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="6824",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="90"}, -- quest: Hands of the Enemy
	{ID_ATTUNE="80",ID="110",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="12264",ICON="Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\flamewalker-blue",FOLLOWS="100",STAGE="100"}, -- npc: Shazzrah
	{ID_ATTUNE="80",ID="120",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="12118",ICON="Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\flamewalker-gray",FOLLOWS="100",STAGE="100"}, -- npc: Lucifron
	{ID_ATTUNE="80",ID="130",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="12259",ICON="Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\flamewalker-red",FOLLOWS="100",STAGE="100"}, -- npc: Gehennas
	{ID_ATTUNE="80",ID="140",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="12098",ICON="Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\flamewalker-red",FOLLOWS="100",STAGE="100"}, -- npc: Sulfuron Harbinger
	{ID_ATTUNE="80",ID="150",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="17332",ICON="Interface\\Icons\\inv_gauntlets_19",FOLLOWS="110",STAGE="110"}, -- item: Hand of Shazzrah
	{ID_ATTUNE="80",ID="160",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="17329",ICON="Interface\\Icons\\inv_gauntlets_26",FOLLOWS="120",STAGE="110"}, -- item: Hand of Lucifron
	{ID_ATTUNE="80",ID="170",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="17331",ICON="Interface\\Icons\\spell_fire_immolation",FOLLOWS="130",STAGE="110"}, -- item: Hand of Gehennas
	{ID_ATTUNE="80",ID="180",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="17330",ICON="Interface\\Icons\\inv_gauntlets_03",FOLLOWS="140",STAGE="110"}, -- item: Hand of Sulfuron
	{ID_ATTUNE="80",ID="190",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="6824",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="150&160&170&180",STAGE="120"}, -- quest: Hands of the Enemy
	{ID_ATTUNE="80",ID="200",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="7486",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="190",STAGE="130"}, -- quest: A Hero's Reward
	{ID_ATTUNE="80",ID="210",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_potion_76",FOLLOWS="200",STAGE="140"},


--vForever: Ragefire Chasm (Horde)
	-- Columns L?R (higher ID = left): Power | Slaying | Testing | Satchel | Hidden Enemies
	{ID_ATTUNE="160",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 9",LOCATION="",ID_WOWHEAD="9",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	
	{ID_ATTUNE="160",ID="20",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="5722",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Searching for the Lost Satchel
	{ID_ATTUNE="160",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="5723",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Testing an Enemy's Strength
    {ID_ATTUNE="160",ID="40",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5726",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Hidden Enemies
	{ID_ATTUNE="160",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Slaying the Beast
	{ID_ATTUNE="160",ID="60",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="5725",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Power to Destroy...


    {ID_ATTUNE="160",ID="70",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="11834",ICON="Interface\\Icons\\inv_misc_bag_10",FOLLOWS="20",STAGE="30"}, -- npc: Maur Grimtotem
    {ID_ATTUNE="160",ID="80",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
    {ID_ATTUNE="160",ID="90",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="14544",ICON="Interface\\Icons\\inv_misc_rune_04",FOLLOWS="40",STAGE="30"}, -- item: Lieutenant's Insignia
    {ID_ATTUNE="160",ID="100",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="11520",ICON="Interface\\Icons\\spell_shadow_metamorphosis",FOLLOWS="50",STAGE="30"}, -- npc: Taragaman the Hungerer
    {ID_ATTUNE="160",ID="110",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},

    {ID_ATTUNE="160",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="5724",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="40"}, -- quest: Returning the Lost Satchel
    {ID_ATTUNE="160",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="160",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5726",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="40"}, -- quest: Hidden Enemies
	{ID_ATTUNE="160",ID="150",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="14540",ICON="Interface\\Icons\\inv_misc_organ_01",FOLLOWS="100",STAGE="40"}, -- item: Taragaman the Hungerer's Heart
    {ID_ATTUNE="160",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},

    {ID_ATTUNE="160",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    {ID_ATTUNE="160",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="160",ID="190",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5727",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="140",STAGE="50"}, -- quest: Hidden Enemies
    {ID_ATTUNE="160",ID="200",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="150",STAGE="50"}, -- quest: Slaying the Beast
    {ID_ATTUNE="160",ID="210",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},

    {ID_ATTUNE="160",ID="220",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="160",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="160",ID="240",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5728",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="190",STAGE="60"}, -- quest: Hidden Enemies
	{ID_ATTUNE="160",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="160",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},

    {ID_ATTUNE="160",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
    {ID_ATTUNE="160",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="160",ID="290",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="11519",ICON="Interface\\Icons\\ability_warrior_rampage",FOLLOWS="240",STAGE="70"}, -- npc: Bazzalan
    {ID_ATTUNE="160",ID="300",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="11518",ICON="Interface\\Icons\\spell_shadow_summonfelhunter",FOLLOWS="240",STAGE="70"}, -- npc: Jergosh the Invoker
	{ID_ATTUNE="160",ID="310",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="14395",ICON="Interface\\Icons\\inv_misc_book_01",FOLLOWS="60",STAGE="70"}, -- item: Spells of Shadow
    {ID_ATTUNE="160",ID="320",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Ragefire Chasm"],ID_WOWHEAD="14396",ICON="Interface\\Icons\\inv_misc_book_06",FOLLOWS="60",STAGE="70"}, -- item: Incantations from the Nether

    {ID_ATTUNE="160",ID="330",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5728",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="290&300",STAGE="80"}, -- quest: Hidden Enemies	
    {ID_ATTUNE="160",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="90"},
    {ID_ATTUNE="160",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="30",STAGE="90"},
    {ID_ATTUNE="160",ID="360",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5730",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="90"}, -- quest: Hidden Enemies
    {ID_ATTUNE="160",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="200",STAGE="90"},
    {ID_ATTUNE="160",ID="380",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="5725",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="310&320",STAGE="90"}, -- quest: The Power to Destroy...

	{ID_ATTUNE="160",ID="390",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_fire_fire",FOLLOWS="340&350&360&370&380",STAGE="100"},





--vForever: The Deadmines (Alliance)
	-- Columns L→R (higher ID = left): Memories | Red Silk | Defias | Toxic Soil→Destruction | Underground Assault | Oh Brother
	-- Longest chains (Defias, Red Silk, Toxic Soil, Underground) occupy the middle columns
	-- Toxic Soil storyline (6026): 92742→92744→92745→92747→92748→92749→92750→92751→92752→92753
	-- SIDE (beside End): 373 The Unsent Letter (Inside — letter from VanCleef)
	{ID_ATTUNE="170",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 14",LOCATION="",ID_WOWHEAD="14",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="170",ID="510",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="168",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Collecting Memories
	-- {ID_ATTUNE="170",ID="410",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="12",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The People's Militia
    {ID_ATTUNE="170",ID="410",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="170",ID="310",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="65",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Defias Brotherhood
	{ID_ATTUNE="170",ID="210",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="92742",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Testing the Wells (Toxic Soil)
	{ID_ATTUNE="170",ID="110",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2041",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Speak with Shoni
	{ID_ATTUNE="170",ID="20",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="167",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Oh Brother...
	-- STAGE 30
	{ID_ATTUNE="170",ID="520",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="1894",ICON="Interface\\Icons\\inv_misc_note_05",FOLLOWS="510",STAGE="30", COUNT=4}, -- item: Miners' Union Card
	-- {ID_ATTUNE="170",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="13",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="410",STAGE="30"}, -- quest: The People's Militia
    {ID_ATTUNE="170",ID="420",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="170",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="132",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="310",STAGE="30"}, -- quest: The Defias Brotherhood
	{ID_ATTUNE="170",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="92744",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="210",STAGE="30"}, -- quest: Murloc Gills
	{ID_ATTUNE="170",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="2040",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="30"}, -- quest: Underground Assault
	{ID_ATTUNE="170",ID="30",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="1875",ICON="Interface\\Icons\\inv_misc_note_06",FOLLOWS="20",STAGE="30"}, -- item: Thistlenettle's Badge
	-- STAGE 40
	{ID_ATTUNE="170",ID="530",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="168",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="40"}, -- quest: Collecting Memories
	-- {ID_ATTUNE="170",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="14",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="40"}, -- quest: The People's Militia
    {ID_ATTUNE="170",ID="430",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="170",ID="330",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="135",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="40"}, -- quest: The Defias Brotherhood
	{ID_ATTUNE="170",ID="230",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="92745",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="40"}, -- quest: The State of the Mines
	{ID_ATTUNE="170",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="7365",ICON="Interface\\Icons\\inv_misc_gear_01",FOLLOWS="120",STAGE="40"}, -- item: Gnoam Sprecklesprocket
	{ID_ATTUNE="170",ID="40",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="167",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- quest: Oh Brother...
	-- STAGE 50
	{ID_ATTUNE="170",ID="540",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="530",STAGE="50"},
    {ID_ATTUNE="170",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	-- {ID_ATTUNE="170",ID="440",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="50"}, -- quest: Red Silk Bandanas
	{ID_ATTUNE="170",ID="340",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="141",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="50"}, -- quest: The Defias Brotherhood
	{ID_ATTUNE="170",ID="240",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="92747",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="50"}, -- quest: Moonbrook Espionage
	{ID_ATTUNE="170",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="2040",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="50"}, -- quest: Underground Assault
	{ID_ATTUNE="170",ID="50",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="40",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="170",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="60"},
    {ID_ATTUNE="170",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	-- {ID_ATTUNE="170",ID="450",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="915",ICON="Interface\\Icons\\inv_misc_bandana_03",FOLLOWS="440",STAGE="60", COUNT=10}, -- item: Red Silk Bandana
	{ID_ATTUNE="170",ID="350",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="142",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="60"}, -- quest: The Defias Brotherhood
	{ID_ATTUNE="170",ID="250",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92748",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="60"}, -- quest: Explosive Consultation
	{ID_ATTUNE="170",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="60"},
	{ID_ATTUNE="170",ID="60",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="50",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="170",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="70"},
    {ID_ATTUNE="170",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	-- {ID_ATTUNE="170",ID="460",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="450",STAGE="70"}, -- quest: Red Silk Bandanas
	{ID_ATTUNE="170",ID="360",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="155",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="350",STAGE="70"}, -- quest: The Defias Brotherhood
	{ID_ATTUNE="170",ID="260",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92749",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="250",STAGE="70"}, -- quest: A Dynamite Plan
	{ID_ATTUNE="170",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="70"},
	{ID_ATTUNE="170",ID="70",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="60",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="170",ID="570",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="560",STAGE="80"},
	-- {ID_ATTUNE="170",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="460",STAGE="80"},
    {ID_ATTUNE="170",ID="470",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="360",STAGE="80"}, -- quest: Red Silk Bandanas
	{ID_ATTUNE="170",ID="370",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="166",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="360",STAGE="80"}, -- quest: The Defias Brotherhood
	{ID_ATTUNE="170",ID="270",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92750",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="260",STAGE="80"}, -- quest: Detonation at a Distance
	{ID_ATTUNE="170",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="80"},
	{ID_ATTUNE="170",ID="80",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="70",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="170",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="570",STAGE="90"},
	-- {ID_ATTUNE="170",ID="480",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="470",STAGE="90"},
    {ID_ATTUNE="170",ID="480",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="915",ICON="Interface\\Icons\\inv_misc_bandana_03",FOLLOWS="470",STAGE="90", COUNT=10}, -- item: Red Silk Bandana
	-- {ID_ATTUNE="170",ID="380",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="639",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="370",STAGE="90"}, -- npc: Edwin VanCleef
    {ID_ATTUNE="170",ID="380",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="3637",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="370",STAGE="90"}, -- item: Head of VanCleef
	{ID_ATTUNE="170",ID="280",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92751",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="270",STAGE="90"}, -- quest: Detonation at a Distance
	{ID_ATTUNE="170",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="170",STAGE="90"},
	{ID_ATTUNE="170",ID="90",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="80",STAGE="90"},
	-- STAGE 100
	{ID_ATTUNE="170",ID="590",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="580",STAGE="100"},
	-- {ID_ATTUNE="170",ID="490",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="480",STAGE="100"},
    {ID_ATTUNE="170",ID="490",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="480",STAGE="100"}, -- quest: Red Silk Bandanas
    {ID_ATTUNE="170",ID="390",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="166",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="380",STAGE="100"}, -- quest: The Defias Brotherhood    
	-- {ID_ATTUNE="170",ID="390",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="3637",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="380",STAGE="100"}, -- item: Head of VanCleef
	{ID_ATTUNE="170",ID="290",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="92752",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="280",STAGE="100"}, -- quest: Explosive Consultation (return to Alba)
	{ID_ATTUNE="170",ID="190",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="180",STAGE="100"},
	{ID_ATTUNE="170",ID="100",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="90",STAGE="100"},
	-- STAGE 110
	{ID_ATTUNE="170",ID="595",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="590",STAGE="110"},
	{ID_ATTUNE="170",ID="495",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="490",STAGE="110"},
	-- {ID_ATTUNE="170",ID="395",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="166",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="390",STAGE="110"}, -- quest: The Defias Brotherhood
    {ID_ATTUNE="170",ID="395",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="390",STAGE="110"},
	{ID_ATTUNE="170",ID="295",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="92753",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="290",STAGE="110"}, -- quest: Destruction in Deadmines
	{ID_ATTUNE="170",ID="195",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="190",STAGE="110"},
	{ID_ATTUNE="170",ID="105",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="100",STAGE="110"},
    -- STAGE 120
	{ID_ATTUNE="170",ID="598",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="595",STAGE="115"},
	{ID_ATTUNE="170",ID="498",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="495",STAGE="115"},
	-- {ID_ATTUNE="170",ID="395",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="166",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="390",STAGE="110"}, -- quest: The Defias Brotherhood
    {ID_ATTUNE="170",ID="398",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="395",STAGE="115"},
	{ID_ATTUNE="170",ID="298",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="92819",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="295",STAGE="115"}, -- quest: Destruction in Deadmines
	{ID_ATTUNE="170",ID="198",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="195",STAGE="115"},
	{ID_ATTUNE="170",ID="108",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="105",STAGE="115"},
	-- SIDE reminder (inside dungeon) — left of End
	{ID_ATTUNE="170",ID="610",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="373",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="115",SIDE=true}, -- quest: The Unsent Letter (Inside — letter from VanCleef)
	{ID_ATTUNE="170",ID="600",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="598&498&398&298&198&108&610",STAGE="120"},



--vForever dungeon attune 177
	-- Oasis prereqs: 886 (optional breadcrumb) → 870 → 877 → 880 → 1489 → 1490 → 914
	-- Short columns chain Spacers (FOLLOWS) so End links drop down then rejoin (no mid-tree horizontals)
	-- SIDE (beside End): 6981 (picked up inside WC)
	{ID_ATTUNE="177",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="177",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="1487",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Deviate Eradication
	{ID_ATTUNE="177",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="959",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Trouble at the Docks
	{ID_ATTUNE="177",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="865",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Raptor Horns
	{ID_ATTUNE="177",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="1486",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Deviate Hides
	-- STAGE 30
	{ID_ATTUNE="177",ID="630",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="620",STAGE="30"},
	{ID_ATTUNE="177",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="5334",ICON="Interface\\Icons\\inv_drink_10",FOLLOWS="520",STAGE="30"}, -- item: 99-Year-Old Port
	{ID_ATTUNE="177",ID="330",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1491",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: Smart Drinks
	{ID_ATTUNE="177",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="6443",ICON="Interface\\Icons\\inv_misc_pelt_wolf_ruin_03",FOLLOWS="120",STAGE="30", COUNT=20}, -- item: Deviate Hide
	-- STAGE 40
	{ID_ATTUNE="177",ID="640",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="630",STAGE="40"},
	{ID_ATTUNE="177",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="959",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: Trouble at the Docks
	{ID_ATTUNE="177",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="6464",ICON="Interface\\Icons\\spell_nature_corrosivebreath",FOLLOWS="330",STAGE="40", COUNT=6}, -- item: Wailing Essence
	{ID_ATTUNE="177",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="1486",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Deviate Hides
	-- STAGE 50
	{ID_ATTUNE="177",ID="650",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="640",STAGE="50"},
	{ID_ATTUNE="177",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="177",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1491",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="50"}, -- quest: Smart Drinks
	{ID_ATTUNE="177",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="177",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="6981",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="80",SIDE=true}, -- quest: The Glowing Shard
	{ID_ATTUNE="177",ID="750",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="650&550&350&150&720",STAGE="90"},



--vForever dungeon attune 180
	-- Main columns L→R (higher ID = left): 1487 | 959 | oasis→1489 chain | 865→1491 | 962 | 1486
	-- Oasis prereqs: 886 (optional breadcrumb) → 870 → 877 → 880 → 1489 → 1490 → 914
	-- Short columns chain Spacers (FOLLOWS) so End links drop down then rejoin (no mid-tree horizontals)
	-- SIDE (beside End): 6981 (picked up inside WC)
	{ID_ATTUNE="180",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="180",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="1487",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Deviate Eradication
	{ID_ATTUNE="180",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="959",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Trouble at the Docks
	{ID_ATTUNE="180",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="886",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Barrens Oases
	{ID_ATTUNE="180",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="865",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Raptor Horns
	{ID_ATTUNE="180",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="962",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Serpentbloom
	{ID_ATTUNE="180",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="1486",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Deviate Hides
	-- STAGE 30
	{ID_ATTUNE="180",ID="630",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="620",STAGE="30"},
	{ID_ATTUNE="180",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="5334",ICON="Interface\\Icons\\inv_drink_10",FOLLOWS="520",STAGE="30"}, -- item: 99-Year-Old Port
	{ID_ATTUNE="180",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="870",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: The Forgotten Pools
	{ID_ATTUNE="180",ID="330",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1491",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: Smart Drinks
	{ID_ATTUNE="180",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="5339",ICON="Interface\\Icons\\inv_misc_herb_03",FOLLOWS="220",STAGE="30", COUNT=10}, -- item: Serpentbloom
	{ID_ATTUNE="180",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="6443",ICON="Interface\\Icons\\inv_misc_pelt_wolf_ruin_03",FOLLOWS="120",STAGE="30", COUNT=20}, -- item: Deviate Hide
	-- STAGE 40
	{ID_ATTUNE="180",ID="640",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="630",STAGE="40"},
	{ID_ATTUNE="180",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="959",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: Trouble at the Docks
	{ID_ATTUNE="180",ID="440",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="877",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="40"}, -- quest: The Stagnant Oasis
	{ID_ATTUNE="180",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="6464",ICON="Interface\\Icons\\spell_nature_corrosivebreath",FOLLOWS="330",STAGE="40", COUNT=6}, -- item: Wailing Essence
	{ID_ATTUNE="180",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="962",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Serpentbloom
	{ID_ATTUNE="180",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="1486",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Deviate Hides
	-- STAGE 50
	{ID_ATTUNE="180",ID="650",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="640",STAGE="50"},
	{ID_ATTUNE="180",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="180",ID="450",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="880",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440",STAGE="50"}, -- quest: Altered Beings
	{ID_ATTUNE="180",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1491",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="50"}, -- quest: Smart Drinks
	{ID_ATTUNE="180",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	{ID_ATTUNE="180",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="180",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="650",STAGE="60"},
	{ID_ATTUNE="180",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="180",ID="460",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1489",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="450",STAGE="60"}, -- quest: Hamuul Runetotem
	{ID_ATTUNE="180",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="180",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="180",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="180",ID="670",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="660",STAGE="70"},
	{ID_ATTUNE="180",ID="570",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="560",STAGE="70"},
	{ID_ATTUNE="180",ID="470",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="1490",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="460",STAGE="70"}, -- quest: Nara Wildmane
	{ID_ATTUNE="180",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="70"},
	{ID_ATTUNE="180",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="260",STAGE="70"},
	{ID_ATTUNE="180",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="180",ID="680",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="670",STAGE="80"},
	{ID_ATTUNE="180",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="570",STAGE="80"},
	{ID_ATTUNE="180",ID="480",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="914",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="470",STAGE="80"}, -- quest: Leaders of the Fang
	{ID_ATTUNE="180",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="80"},
	{ID_ATTUNE="180",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="270",STAGE="80"},
	{ID_ATTUNE="180",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="170",STAGE="80"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="180",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wailing Caverns"],ID_WOWHEAD="6981",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="80",SIDE=true}, -- quest: The Glowing Shard
	{ID_ATTUNE="180",ID="750",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="680&580&480&380&280&180&720",STAGE="90"},



--vForever dungeon attune 183 (Alliance Ruins of Lordaeron)
	-- All quests start from loot inside — SIDE box only
	-- SIDE: 95189 Crest, 95195 Bloodied Insignia, 92415 Remember That I Love You, 95250 Abominable Creatures
	{ID_ATTUNE="183",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 15",LOCATION="",ID_WOWHEAD="15",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="183",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="95189",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="20",SIDE=true}, -- quest: Crest of Lordaeron (Inside)
	{ID_ATTUNE="183",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="95195",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="20",SIDE=true}, -- quest: Bloodied Insignia (Inside)
	{ID_ATTUNE="183",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="92415",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="20",SIDE=true}, -- quest: Remember That I Love You (Inside)
	{ID_ATTUNE="183",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="95250",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="20",SIDE=true}, -- quest: Abominable Creatures (Inside)
	{ID_ATTUNE="183",ID="430",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="420&320&220&120&10",STAGE="20"},


--vForever dungeon attune 186 (Horde Ruins of Lordaeron)
	-- Main columns L→R (higher ID = left):
	--   447 > 450 > 451 > 95216 The New Plague
	--   356 > 99156 > 92422 The Wrath of Rath'mael
	--   92421 Light's Justice
	--   92401 A Frightened Request
	-- SIDE (beside End): 95204 Crest of Lordaeron, 97288 Unending Torment (Inside)
	{ID_ATTUNE="186",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 15",LOCATION="",ID_WOWHEAD="15",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="186",ID="610",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="447",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Recipe For Death
	{ID_ATTUNE="186",ID="410",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="356",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Rear Guard Patrol
	{ID_ATTUNE="186",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="92421",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Light's Justice
	{ID_ATTUNE="186",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="92401",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Frightened Request
	-- STAGE 30
	{ID_ATTUNE="186",ID="615",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="450",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="610",STAGE="30"}, -- quest: A Recipe For Death
	{ID_ATTUNE="186",ID="510",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="99156",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="410",STAGE="30"}, -- quest: Rear Guard Patrol
	{ID_ATTUNE="186",ID="330",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="320",STAGE="30"},
	{ID_ATTUNE="186",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="220",STAGE="30"},
	-- STAGE 40
	{ID_ATTUNE="186",ID="616",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="451",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="615",STAGE="40"}, -- quest: A Recipe For Death
	{ID_ATTUNE="186",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="92422",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="510",STAGE="40"}, -- quest: The Wrath of Rath'mael
	{ID_ATTUNE="186",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="330",STAGE="40"},
	{ID_ATTUNE="186",ID="240",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="230",STAGE="40"},
	-- STAGE 50
	{ID_ATTUNE="186",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="95216",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="616",STAGE="50"}, -- quest: The New Plague
	{ID_ATTUNE="186",ID="445",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="420",STAGE="50"},
	{ID_ATTUNE="186",ID="345",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="186",ID="245",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="186",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="95204",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Crest of Lordaeron (Inside)
	{ID_ATTUNE="186",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ruins of Lordaeron"],ID_WOWHEAD="97288",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Unending Torment (Inside)
	{ID_ATTUNE="186",ID="630",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="620&445&345&245&520&120",STAGE="60"},





--vForever dungeon attune 190
	-- Columns L→R (higher ID = left): 1014 Arugal | 1098 Deathstalkers | 1013 Book of Ur
	{ID_ATTUNE="190",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 16",LOCATION="",ID_WOWHEAD="16",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="190",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="1014",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Arugal Must Die
	{ID_ATTUNE="190",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="1098",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Deathstalkers in Shadowfang
	{ID_ATTUNE="190",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1013",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Book of Ur
	-- STAGE 30
    {ID_ATTUNE="190",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="5442",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="320",STAGE="30"}, -- item: Head of Arugal
	-- {ID_ATTUNE="190",ID="330",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="4275",ICON="Interface\\Icons\\spell_shadow_summonfelhunter",FOLLOWS="320",STAGE="30"}, -- npc: Archmage Arugal
	{ID_ATTUNE="190",ID="230",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="3849",ICON="Interface\\Icons\\ability_stealth",FOLLOWS="220",STAGE="30"}, -- npc: Deathstalker Adamant
	{ID_ATTUNE="190",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="6283",ICON="Interface\\Icons\\inv_misc_book_08",FOLLOWS="120",STAGE="30"}, -- item: The Book of Ur
	-- STAGE 40
    {ID_ATTUNE="190",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="1014",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Arugal Must Die
	-- {ID_ATTUNE="190",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="5442",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="330",STAGE="40"}, -- item: Head of Arugal
	{ID_ATTUNE="190",ID="240",TYPE="Interact",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="4444",ICON="Interface\\Icons\\ability_stealth",FOLLOWS="230",STAGE="40"}, -- npc: Deathstalker Vincent
	{ID_ATTUNE="190",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1013",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: The Book of Ur
	-- STAGE 50
    {ID_ATTUNE="190",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	-- {ID_ATTUNE="190",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="1014",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="50"}, -- quest: Arugal Must Die
	{ID_ATTUNE="190",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="1098",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: Deathstalkers in Shadowfang
	{ID_ATTUNE="190",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	{ID_ATTUNE="190",ID="360",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="350&250&150",STAGE="60"},

--vForever dungeon attune 200
	-- Columns L→R (higher ID = left): 1198→1200 Thaelrid | 1199 Twilight | 1275 Research | 971 Knowledge
	{ID_ATTUNE="200",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 18",LOCATION="",ID_WOWHEAD="18",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="200",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="1198",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: In Search of Thaelrid (prequest)
	{ID_ATTUNE="200",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="1199",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Twilight Falls
	{ID_ATTUNE="200",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="1275",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Researching the Corruption
	{ID_ATTUNE="200",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="971",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Knowledge in the Deeps
	-- STAGE 30
	{ID_ATTUNE="200",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="1200",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Blackfathom Villainy (from Thaelrid)
	{ID_ATTUNE="200",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="5879",ICON="Interface\\Icons\\inv_jewelry_amulet_06",FOLLOWS="320",STAGE="30", COUNT=10}, -- item: Twilight Pendant
	{ID_ATTUNE="200",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="5952",ICON="Interface\\Icons\\inv_misc_organ_03",FOLLOWS="220",STAGE="30", COUNT=8}, -- item: Corrupted Brain Stem
	{ID_ATTUNE="200",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="5359",ICON="Interface\\Icons\\inv_misc_note_01",FOLLOWS="120",STAGE="30"}, -- item: Lorgalis Manuscript
	-- STAGE 40
	{ID_ATTUNE="200",ID="540",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="520",STAGE="40"},
	{ID_ATTUNE="200",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="1199",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Twilight Falls
	{ID_ATTUNE="200",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="1275",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Researching the Corruption
	{ID_ATTUNE="200",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="971",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Knowledge in the Deeps
	{ID_ATTUNE="200",ID="350",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="540&340&240&140",STAGE="50"},

--vForever dungeon attune 210
	-- Columns L→R (higher ID = left): 6921 Amongst | 6564→6565 Allegiance | 6562→6563 Essence
	-- SIDE (beside End): 6561 Blackfathom Villainy, 6922 Baron Aquanis (from inside)
	{ID_ATTUNE="210",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 17",LOCATION="",ID_WOWHEAD="17",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="210",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="6921",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Amongst the Ruins
	{ID_ATTUNE="210",ID="220",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="16790",ICON="Interface\\Icons\\inv_misc_note_06",FOLLOWS="10",STAGE="20"}, -- item: Damp Note (starts 6564)
	{ID_ATTUNE="210",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="6562",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Trouble in the Deeps (prequest)
	-- STAGE 30
	{ID_ATTUNE="210",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="16762",ICON="Interface\\Icons\\inv_misc_stonetablet_08",FOLLOWS="320",STAGE="30"}, -- item: Fathom Core
	{ID_ATTUNE="210",ID="230",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="6564",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="30"}, -- quest: Allegiance to the Old Gods (turn in note)
	{ID_ATTUNE="210",ID="130",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="6563",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="30"}, -- quest: The Essence of Aku'Mai
	-- STAGE 40
	{ID_ATTUNE="210",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="6921",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Amongst the Ruins
	{ID_ATTUNE="210",ID="240",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="6565",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Allegiance to the Old Gods
	{ID_ATTUNE="210",ID="140",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="16784",ICON="Interface\\Icons\\inv_misc_gem_sapphire_03",FOLLOWS="130",STAGE="40", COUNT=20}, -- item: Sapphire of Aku'Mai
	-- STAGE 50
	{ID_ATTUNE="210",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="210",ID="250",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="12902",ICON="Interface\\Icons\\spell_shadow_shadowbolt",FOLLOWS="240",STAGE="50"}, -- npc: Lorgus Jett
	{ID_ATTUNE="210",ID="150",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="6563",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="140",STAGE="50"}, -- quest: The Essence of Aku'Mai
	-- STAGE 60
	{ID_ATTUNE="210",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="210",ID="260",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="6565",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="250",STAGE="60"}, -- quest: Allegiance to the Old Gods
	{ID_ATTUNE="210",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="210",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="6561",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Blackfathom Villainy (from Thaelrid)
	{ID_ATTUNE="210",ID="500",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="6922",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Baron Aquanis (Strange Water Globe)
	{ID_ATTUNE="210",ID="370",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="360&260&160&520&500",STAGE="70"},

--vForever dungeon attune 220
	-- Columns L→R (higher ID = left): 303→378 Dark Iron | 388 Color | 387 Quell | 373→389→391 Unsent (center) | 377 Crime | 386 What Comes
	{ID_ATTUNE="220",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 16",LOCATION="",ID_WOWHEAD="16",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="220",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="303",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Dark Iron War
	{ID_ATTUNE="220",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="388",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Color of Blood
	{ID_ATTUNE="220",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="387",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Quell The Uprising
	{ID_ATTUNE="220",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="373",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Unsent Letter
	{ID_ATTUNE="220",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Duskwood"],ID_WOWHEAD="377",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Crime and Punishment
	{ID_ATTUNE="220",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="386",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: What Comes Around...
	-- STAGE 30
	{ID_ATTUNE="220",ID="630",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="378",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: The Fury Runs Deep
	{ID_ATTUNE="220",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Stockade"],ID_WOWHEAD="2909",ICON="Interface\\Icons\\inv_misc_bandana_03",FOLLOWS="520",STAGE="30", COUNT=10}, -- item: Red Wool Bandana
	{ID_ATTUNE="220",ID="430",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="420",STAGE="30"},
	{ID_ATTUNE="220",ID="330",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="389",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: Bazil Thredd
    {ID_ATTUNE="220",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Stockade"],ID_WOWHEAD="3628",ICON="Interface\\Icons\\inv_gauntlets_09",FOLLOWS="220",STAGE="30"}, -- item: Hand of Dextren Ward
    {ID_ATTUNE="220",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Stockade"],ID_WOWHEAD="3630",ICON="Interface\\Icons\\inv_misc_head_orc_01",FOLLOWS="120",STAGE="30"}, -- item: Head of Targorr
	-- STAGE 40
	{ID_ATTUNE="220",ID="640",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Stockade"],ID_WOWHEAD="3640",ICON="Interface\\Icons\\inv_misc_head_dwarf_01",FOLLOWS="630",STAGE="40"}, -- item: Head of Deepfury
	{ID_ATTUNE="220",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="388",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: The Color of Blood
	{ID_ATTUNE="220",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="430",STAGE="40"},
	{ID_ATTUNE="220",ID="340",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="391",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: The Stockade Riots
    {ID_ATTUNE="220",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Duskwood"],ID_WOWHEAD="377",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Crime and Punishment
    {ID_ATTUNE="220",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="386",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: What Comes Around...
	-- STAGE 50
	{ID_ATTUNE="220",ID="650",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="378",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="640",STAGE="50"}, -- quest: The Fury Runs Deep
	{ID_ATTUNE="220",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="220",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="50"},
	{ID_ATTUNE="220",ID="350",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Stockade"],ID_WOWHEAD="2926",ICON="Interface\\Icons\\inv_misc_head_human_01",FOLLOWS="340",STAGE="50"}, -- npc: Bazil Thredd
	{ID_ATTUNE="220",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Duskwood"],ID_WOWHEAD="377",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: Crime and Punishment
    {ID_ATTUNE="220",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- {ID_ATTUNE="220",ID="150",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="386",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="140",STAGE="50"}, -- quest: What Comes Around...
	-- STAGE 60
	{ID_ATTUNE="220",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="650",STAGE="60"},
	{ID_ATTUNE="220",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="220",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
	{ID_ATTUNE="220",ID="360",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="391",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="350",STAGE="60"}, -- quest: The Stockade Riots
	{ID_ATTUNE="220",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="220",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="220",ID="580",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="660&560&460&360&260&160",STAGE="80"},


--vForever dungeon attune 225 (Alliance City of Dalaran)
	-- Columns L→R: 92456 Green Sample | 92489 Power Overwhelming | 92432→92458 Alarming Request → Heart
	{ID_ATTUNE="225",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 24",LOCATION="",ID_WOWHEAD="24",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="225",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92456",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Green Sample
	{ID_ATTUNE="225",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92489",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Power Overwhelming
	{ID_ATTUNE="225",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="92432",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: An Alarming Request
	-- STAGE 30
	{ID_ATTUNE="225",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="251983",ICON="Interface\\Icons\\inv_misc_herb_fellotus",FOLLOWS="320",STAGE="30"}, -- item: Fel Infused Blossom
	{ID_ATTUNE="225",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="246016",ICON="Interface\\Icons\\spell_frost_summonwaterelemental",FOLLOWS="220",STAGE="30"}, -- npc: Arcanic Enigma
	{ID_ATTUNE="225",ID="130",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="92458",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="30"}, -- quest: Heart of Disruption
	-- STAGE 40
	{ID_ATTUNE="225",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92456",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: A Green Sample
	{ID_ATTUNE="225",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="92489",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Power Overwhelming
	{ID_ATTUNE="225",ID="140",TYPE="Item",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="251961",ICON="Interface\\Icons\\inv_misc_cutgemperfect3",FOLLOWS="130",STAGE="40"}, -- item: Arcane Mote (should be jewelcrafting_uncut-epic-gem_color1 but that's failing)
	-- STAGE 50
	{ID_ATTUNE="225",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="225",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	{ID_ATTUNE="225",ID="150",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="92458",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="140",STAGE="50"}, -- quest: Heart of Disruption
	{ID_ATTUNE="225",ID="400",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="350&250&150",STAGE="60"}, 


--vForever dungeon attune 226 (Horde City of Dalaran)
	-- Columns L→R: 96988 Source | 96986 Grave Knight | 544→545 Prison | 93680 Key
	-- 545 and Key meet at Blood in the Streets → Heart of Disruption → Shrewd Negotiations.
	-- SIDE (beside End): 96987 Opportunistic Education (Inside)
	{ID_ATTUNE="226",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 24",LOCATION="",ID_WOWHEAD="24",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="226",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="96988",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Source of Power
	{ID_ATTUNE="226",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="96986",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Grave Knight
	{ID_ATTUNE="226",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="544",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Prison Break In
	{ID_ATTUNE="226",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="93680",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Key to the City
	-- STAGE 30
	{ID_ATTUNE="226",ID="630",TYPE="Item",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="275997",ICON="Interface\\Icons\\inv_misc_gem_sapphire_02",FOLLOWS="620",STAGE="30", COUNT=6}, -- item: Cracked Sentry Core
	{ID_ATTUNE="226",ID="530",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="247126",ICON="Interface\\Icons\\spell_shadow_raisedead",FOLLOWS="520",STAGE="30"}, -- npc: Atrexis the Grave Knight
	{ID_ATTUNE="226",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="545",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Dalaran Patrols
	{ID_ATTUNE="226",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="279469",ICON="Interface\\Icons\\inv_misc_key_03",FOLLOWS="320",STAGE="30"}, -- item: Grimy Key
	-- STAGE 40
	{ID_ATTUNE="226",ID="640",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="96988",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="40"}, -- quest: Source of Power
	{ID_ATTUNE="226",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="96986",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: The Grave Knight
	{ID_ATTUNE="226",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="430",STAGE="40"},
	{ID_ATTUNE="226",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="93680",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Key to the City
	-- STAGE 50
	{ID_ATTUNE="226",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="226",ID="450",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="92434",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440&340",STAGE="50"}, -- quest: Blood in the Streets
	-- STAGE 60
    {ID_ATTUNE="226",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="226",ID="460",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="96984",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="450",STAGE="60"}, -- quest: Heart of Disruption
	-- STAGE 70
    {ID_ATTUNE="226",ID="570",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="226",ID="470",TYPE="Item",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="251961",ICON="Interface\\Icons\\inv_misc_cutgemperfect3",FOLLOWS="460",STAGE="70"}, -- item: Arcane Mote	
	-- STAGE 80
	{ID_ATTUNE="226",ID="680",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="640",STAGE="80"},
	{ID_ATTUNE="226",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="80"},
    {ID_ATTUNE="226",ID="480",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="96984",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="470",STAGE="80"}, -- quest: Heart of Disruption
	{ID_ATTUNE="226",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="226",ID="690",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="680",STAGE="90"},
	{ID_ATTUNE="226",ID="590",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="580",STAGE="90"},
    {ID_ATTUNE="226",ID="490",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="97287",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="480",STAGE="90"}, -- quest: Shrewd Negotiations
    {ID_ATTUNE="226",ID="390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},

	{ID_ATTUNE="226",ID="190",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["City of Dalaran"],ID_WOWHEAD="96987",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="80",SIDE=true}, -- quest: Opportunistic Education (Inside)
	{ID_ATTUNE="226",ID="7000",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="690&590&490&190",STAGE="100"},


--vForever dungeon attune 230
	-- Columns L→R (higher ID = left): 2929 Betrayal | 2924 Artificials | 2928 Gyro | 2927→2926 Gnogaine | 2923→2922 Techbot
	-- SIDE (beside End): 80324 Mad King, 2904 A Fine Mess, 79987 Return of the Ring
	{ID_ATTUNE="230",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="230",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2929",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Grand Betrayal
	{ID_ATTUNE="230",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2924",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Essential Artificials
	{ID_ATTUNE="230",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="2928",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Gyrodrillmatic Excavationators
	{ID_ATTUNE="230",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2927",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Day After (prequest)
	{ID_ATTUNE="230",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2923",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Tinkmaster Overspark (prequest)
	-- STAGE 30
	{ID_ATTUNE="230",ID="530",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="7800",ICON="Interface\\Icons\\inv_misc_head_gnome_01",FOLLOWS="520",STAGE="30"}, -- npc: Mekgineer Thermaplugg
	{ID_ATTUNE="230",ID="430",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="9278",ICON="Interface\\Icons\\inv_gizmo_01",FOLLOWS="420",STAGE="30", COUNT=12}, -- item: Essential Artificial
	{ID_ATTUNE="230",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="9309",ICON="Interface\\Icons\\inv_gizmo_02",FOLLOWS="320",STAGE="30", COUNT=24}, -- item: Robo-mechanical Guts
	{ID_ATTUNE="230",ID="230",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2926",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="30"}, -- quest: Gnogaine
	{ID_ATTUNE="230",ID="130",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2922",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="30"}, -- quest: Save Techbot's Brain!
	-- STAGE 40
	{ID_ATTUNE="230",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2929",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: The Grand Betrayal
	{ID_ATTUNE="230",ID="440",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2924",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="40"}, -- quest: Essential Artificials
	{ID_ATTUNE="230",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="2928",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Gyrodrillmatic Excavationators
	{ID_ATTUNE="230",ID="240",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="9284",ICON="Interface\\Icons\\inv_drink_01",FOLLOWS="230",STAGE="40"}, -- item: Full Leaden Collection Phial
	{ID_ATTUNE="230",ID="140",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="6231",ICON="Interface\\Icons\\inv_battery_01",FOLLOWS="130",STAGE="40"}, -- npc: Techbot
	-- STAGE 50
	{ID_ATTUNE="230",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="230",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="50"},
	{ID_ATTUNE="230",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="230",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2926",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: Gnogaine
	{ID_ATTUNE="230",ID="150",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="9277",ICON="Interface\\Icons\\inv_battery_01",FOLLOWS="140",STAGE="50"}, -- item: Techbot's Memory Core
	-- STAGE 60
	{ID_ATTUNE="230",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="230",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
	{ID_ATTUNE="230",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="230",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="230",ID="160",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2922",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="150",STAGE="60"}, -- quest: Save Techbot's Brain!
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="230",ID="640",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="80324",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: The Mad King
	{ID_ATTUNE="230",ID="630",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="2904",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: A Fine Mess (Kernobee)
	{ID_ATTUNE="230",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="79987",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Return of the Ring
	{ID_ATTUNE="230",ID="570",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="560&460&360&260&160&640&630&620",STAGE="70"},

--vForever dungeon attune 240
	-- Columns L→R (higher ID = left): 2841 Rig Wars | 2842→2843 Scooty chain
	-- SIDE (beside End): 80325 Mad King, 2904 A Fine Mess, 80140 Return of the Ring
	{ID_ATTUNE="240",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="240",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="2841",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Rig Wars
	{ID_ATTUNE="240",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="2842",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Chief Engineer Scooty (prequest)
	-- STAGE 30
	{ID_ATTUNE="240",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="7800",ICON="Interface\\Icons\\inv_misc_head_gnome_01",FOLLOWS="220",STAGE="30"}, -- npc: Mekgineer Thermaplugg
	{ID_ATTUNE="240",ID="130",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stranglethorn Vale"],ID_WOWHEAD="2843",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="30"}, -- quest: Gnomer-gooooone!
	-- STAGE 40
    {ID_ATTUNE="240",ID="240",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="9299",ICON="Interface\\Icons\\inv_misc_note_05",FOLLOWS="230",STAGE="40"}, -- item: Thermaplugg's Safe Combination
	{ID_ATTUNE="240",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},    
	-- STAGE 50
	{ID_ATTUNE="240",ID="250",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="9153",ICON="Interface\\Icons\\inv_misc_note_06",FOLLOWS="240",STAGE="50"}, -- item: Rig Blueprints
	{ID_ATTUNE="240",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
    -- STAGE 60
	{ID_ATTUNE="240",ID="260",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="2841",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="250",STAGE="60"}, -- quest: Rig Wars
	{ID_ATTUNE="240",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="240",ID="340",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="80325",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: The Mad King
	{ID_ATTUNE="240",ID="330",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="2904",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: A Fine Mess (Kernobee)
	{ID_ATTUNE="240",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Gnomeregan"],ID_WOWHEAD="80140",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Return of the Ring
	{ID_ATTUNE="240",ID="270",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="260&160&340&330&320",STAGE="70"},

--vForever dungeon attune 250 (Alliance)
	-- Columns L→R (higher ID = left): 1142 Mortality | 1100→1101 Crone | 1221 Tubers
	-- SIDE (beside End): 1144 Willix the Importer (escort inside)
	{ID_ATTUNE="250",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="250",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="1142",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Mortality Wanes (from Heralath inside)
	{ID_ATTUNE="250",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1100",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Lonebrow's Journal (prequest)
	{ID_ATTUNE="250",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1221",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Blueleaf Tubers
	-- STAGE 30
	{ID_ATTUNE="250",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="5825",ICON="Interface\\Icons\\inv_jewelry_necklace_01",FOLLOWS="320",STAGE="30"}, -- item: Treshala's Pendant
	{ID_ATTUNE="250",ID="230",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="1101",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="30"}, -- quest: The Crone of the Kraul
	{ID_ATTUNE="250",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="5876",ICON="Interface\\Icons\\inv_misc_herb_07",FOLLOWS="120",STAGE="30", COUNT=6}, -- item: Blueleaf Tuber
	-- STAGE 40
	{ID_ATTUNE="250",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="1142",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Mortality Wanes
	{ID_ATTUNE="250",ID="240",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="4421",ICON="Interface\\Icons\\spell_nature_thorns",FOLLOWS="230",STAGE="40"}, -- npc: Charlga Razorflank
	{ID_ATTUNE="250",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1221",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Blueleaf Tubers
	-- STAGE 50
	{ID_ATTUNE="250",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="250",ID="250",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="5792",ICON="Interface\\Icons\\inv_jewelry_talisman_01",FOLLOWS="240",STAGE="50"}, -- item: Razorflank's Medallion
	{ID_ATTUNE="250",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="250",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="250",ID="260",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="1101",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="250",STAGE="60"}, -- quest: The Crone of the Kraul
	{ID_ATTUNE="250",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- SIDE reminder (inside dungeon) — left of End
	{ID_ATTUNE="250",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="1144",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Willix the Importer
	{ID_ATTUNE="250",ID="370",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_magic_polymorphpig",FOLLOWS="360&260&160&420",STAGE="70"},

--vForever dungeon attune 251 (Horde)
	-- Columns L→R (higher ID = left): 1109 Guano | 1102 Vengeful | 1221 Tubers
	-- SIDE (beside End): 6522 An Unholy Alliance (Small Scroll from Charlga), 1144 Willix the Importer
	{ID_ATTUNE="251",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="251",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1109",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Going, Going, Guano!
	{ID_ATTUNE="251",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="1102",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Vengeful Fate
	{ID_ATTUNE="251",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1221",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Blueleaf Tubers
	-- STAGE 30
	{ID_ATTUNE="251",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="5801",ICON="Interface\\Icons\\inv_misc_slime_01",FOLLOWS="320",STAGE="30"}, -- item: Kraul Guano
	{ID_ATTUNE="251",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="4421",ICON="Interface\\Icons\\spell_nature_thorns",FOLLOWS="220",STAGE="30"}, -- npc: Charlga Razorflank
	{ID_ATTUNE="251",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="5876",ICON="Interface\\Icons\\inv_misc_herb_07",FOLLOWS="120",STAGE="30", COUNT=6}, -- item: Blueleaf Tuber
	-- STAGE 40
	{ID_ATTUNE="251",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1109",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Going, Going, Guano!
	{ID_ATTUNE="251",ID="240",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="5793",ICON="Interface\\Icons\\inv_misc_organ_01",FOLLOWS="230",STAGE="40"}, -- item: Razorflank's Heart
	{ID_ATTUNE="251",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1221",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Blueleaf Tubers
	-- STAGE 50
	{ID_ATTUNE="251",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="251",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="1102",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: A Vengeful Fate
	{ID_ATTUNE="251",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="251",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="6522",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: An Unholy Alliance (Small Scroll from Charlga → RFD)
	{ID_ATTUNE="251",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="1144",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Willix the Importer
	{ID_ATTUNE="251",ID="370",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_magic_polymorphpig",FOLLOWS="350&250&150&430&420",STAGE="60"},

--vForever dungeon attune 260
	-- Columns L→R (higher ID = left): 1053 Name of the Light (→4 kills ‖) | 1050 Mythology
	-- Kill row (same STAGE): Loksey ‖ Herod ‖ Mograine ‖ Whitemane
	{ID_ATTUNE="260",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 28",LOCATION="",ID_WOWHEAD="28",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="260",ID="520",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="260",ID="420",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="260",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="6141",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Brother Anton
	{ID_ATTUNE="260",ID="220",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="260",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="1050",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Mythology of the Titans
	-- STAGE 30
	{ID_ATTUNE="260",ID="530",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="260",ID="430",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="260",ID="330",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="261",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: Down the Scarlet Path
	{ID_ATTUNE="260",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
    {ID_ATTUNE="260",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="5536",ICON="Interface\\Icons\\inv_misc_book_10",FOLLOWS="120",STAGE="30"}, -- item: Mythology of the Titans
	-- STAGE 40
	{ID_ATTUNE="260",ID="540",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="260",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="260",ID="340",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1052",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Down the Scarlet Path
	{ID_ATTUNE="260",ID="240",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="260",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="1050",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Mythology of the Titans
	-- STAGE 50
	{ID_ATTUNE="260",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="260",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="260",ID="350",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1053",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="50"}, -- quest: In the Name of the Light
	{ID_ATTUNE="260",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="260",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- STAGE 60 — 4 kills on one row (all FOLLOWS Pick Up)
	{ID_ATTUNE="260",ID="560",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3974",ICON="Interface\\Icons\\ability_hunter_beastcall",FOLLOWS="350",STAGE="60"}, -- npc: Houndmaster Loksey
	{ID_ATTUNE="260",ID="460",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3975",ICON="Interface\\Icons\\ability_warrior_challange",FOLLOWS="350",STAGE="60"}, -- npc: Herod
	{ID_ATTUNE="260",ID="360",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3976",ICON="Interface\\Icons\\spell_holy_prayerofhealing02",FOLLOWS="350",STAGE="60"}, -- npc: Scarlet Commander Mograine
	{ID_ATTUNE="260",ID="260",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3977",ICON="Interface\\Icons\\spell_holy_resurrection",FOLLOWS="350",STAGE="60"}, -- npc: High Inquisitor Whitemane
	-- {ID_ATTUNE="260",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="260",ID="570",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="260",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
    {ID_ATTUNE="260",ID="370",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1053",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="560&460&360&260",STAGE="70"}, -- quest: In the Name of the Light
	{ID_ATTUNE="260",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="260",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="70"},
	{ID_ATTUNE="260",ID="580",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="370&170",STAGE="80"},


--vForever dungeon attune 270
	-- Columns L→R: 1051 Vorrel | 1109→1113 Guano | Test of Lore (→1160) | 1049 Compendium | 1048 Into SM → (Loksey ‖ Herod ‖ Mograine ‖ Whitemane)
	{ID_ATTUNE="270",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 25",LOCATION="",ID_WOWHEAD="25",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="270",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1109",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Going, Going, Guano! (prequest)
	{ID_ATTUNE="270",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1149",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Test of Faith
	{ID_ATTUNE="270",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="1049",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Compendium of the Fallen
	{ID_ATTUNE="270",ID="420",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
    {ID_ATTUNE="270",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1048",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Into The Scarlet Monastery
	{ID_ATTUNE="270",ID="220",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="270",ID="120",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
    {ID_ATTUNE="270",ID="020",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="1051",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Vorrel's Revenge
	
	-- STAGE 30 — 4 kills on one row (all FOLLOWS Pick Up)
	{ID_ATTUNE="270",ID="730",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="1113",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="720",STAGE="30"}, -- quest: Hearts of Zeal
	{ID_ATTUNE="270",ID="630",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1150",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: Test of Endurance
	{ID_ATTUNE="270",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="5535",ICON="Interface\\Icons\\inv_misc_book_05",FOLLOWS="520",STAGE="30"}, -- item: Compendium of the Fallen
	{ID_ATTUNE="270",ID="430",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3974",ICON="Interface\\Icons\\ability_hunter_beastcall",FOLLOWS="320",STAGE="30"}, -- npc: Houndmaster Loksey
	{ID_ATTUNE="270",ID="330",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3975",ICON="Interface\\Icons\\ability_warrior_challange",FOLLOWS="320",STAGE="30"}, -- npc: Herod
    {ID_ATTUNE="270",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3976",ICON="Interface\\Icons\\spell_holy_prayerofhealing02",FOLLOWS="320",STAGE="30"}, -- npc: Scarlet Commander Mograine
	{ID_ATTUNE="270",ID="130",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="3977",ICON="Interface\\Icons\\spell_holy_resurrection",FOLLOWS="320",STAGE="30"}, -- npc: High Inquisitor Whitemane
    {ID_ATTUNE="270",ID="030",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="5538",ICON="Interface\\Icons\\inv_jewelry_ring_03",FOLLOWS="020",STAGE="30"}, -- item: Vorrel's Wedding Ring
	-- STAGE 40
	{ID_ATTUNE="270",ID="740",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="5805",ICON="Interface\\Icons\\inv_misc_organ_02",FOLLOWS="730",STAGE="40", COUNT=20}, -- item: Heart of Zeal
	{ID_ATTUNE="270",ID="640",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1151",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="40"}, -- quest: Test of Strength
	{ID_ATTUNE="270",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="1049",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: Compendium of the Fallen
	{ID_ATTUNE="270",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="270",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1048",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430&330&230&130",STAGE="40"}, -- quest: Into The Scarlet Monastery
	{ID_ATTUNE="270",ID="240",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="270",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="270",ID="040",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1051",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="030",STAGE="40"}, -- quest: Vorrel's Revenge (Tarren Mill)
	-- STAGE 50
	{ID_ATTUNE="270",ID="750",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1113",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="740",STAGE="50"}, -- quest: Hearts of Zeal
	{ID_ATTUNE="270",ID="650",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="1152",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="640",STAGE="50"}, -- quest: Test of Lore (find Braug)
	{ID_ATTUNE="270",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="270",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    {ID_ATTUNE="270",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="270",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="270",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    {ID_ATTUNE="270",ID="050",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="040",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="270",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="60"},
	{ID_ATTUNE="270",ID="660",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="1154",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="650",STAGE="60"}, -- quest: Test of Lore (Legacy of the Aspects)
	{ID_ATTUNE="270",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="270",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="270",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="270",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="270",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="270",ID="060",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="050",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="270",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="760",STAGE="70"},
	{ID_ATTUNE="270",ID="670",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="6627",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="660",STAGE="70"}, -- quest: Test of Lore (Braug's question)
	{ID_ATTUNE="270",ID="570",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="560",STAGE="70"},
	{ID_ATTUNE="270",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="270",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="70"},
	{ID_ATTUNE="270",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="270",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
    {ID_ATTUNE="270",ID="070",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="060",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="270",ID="780",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="770",STAGE="80"},
	{ID_ATTUNE="270",ID="680",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1159",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="670",STAGE="80"}, -- quest: Test of Lore (find Parqual)
	{ID_ATTUNE="270",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="570",STAGE="80"},
	{ID_ATTUNE="270",ID="480",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="270",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="80"},
	{ID_ATTUNE="270",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="270",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
    {ID_ATTUNE="270",ID="080",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="070",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="270",ID="790",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="780",STAGE="90"},
	{ID_ATTUNE="270",ID="690",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="1160",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="680",STAGE="90"}, -- quest: Test of Lore (Beginnings of the Undead Threat)
	{ID_ATTUNE="270",ID="590",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="580",STAGE="90"},
	{ID_ATTUNE="270",ID="490",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	{ID_ATTUNE="270",ID="390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="380",STAGE="90"},
	{ID_ATTUNE="270",ID="290",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	{ID_ATTUNE="270",ID="190",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
    {ID_ATTUNE="270",ID="090",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="080",STAGE="90"},
	-- STAGE 100 — book; other columns hold their place
	{ID_ATTUNE="270",ID="700",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="790",STAGE="100"},
	{ID_ATTUNE="270",ID="600",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scarlet Monastery"],ID_WOWHEAD="5861",ICON="Interface\\Icons\\inv_misc_book_08",FOLLOWS="690",STAGE="100"}, -- item: Beginnings of the Undead Threat
	{ID_ATTUNE="270",ID="500",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="590",STAGE="100"},
	{ID_ATTUNE="270",ID="400",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="100"},
	{ID_ATTUNE="270",ID="300",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="390",STAGE="100"},
	{ID_ATTUNE="270",ID="200",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="100"},
	{ID_ATTUNE="270",ID="100",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="100"},
	{ID_ATTUNE="270",ID="000",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="090",STAGE="100"},
	-- STAGE 110 — book turn-in
	{ID_ATTUNE="270",ID="710",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="700",STAGE="110"},
	{ID_ATTUNE="270",ID="610",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1160",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="600",STAGE="110"}, -- quest: Test of Lore
	{ID_ATTUNE="270",ID="510",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="500",STAGE="110"},
	{ID_ATTUNE="270",ID="410",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="110"},
	{ID_ATTUNE="270",ID="310",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="300",STAGE="110"},
	{ID_ATTUNE="270",ID="210",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="110"},
	{ID_ATTUNE="270",ID="110",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="110"},
	{ID_ATTUNE="270",ID="010",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="000",STAGE="110"},

	{ID_ATTUNE="270",ID="900",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="010&710&610&510&310",STAGE="120"},

--vForever dungeon attune 280
	-- Columns L→R (higher ID = left): 3636 Bring the Light | 6626 Host of Evil
	-- SIDE (beside End): 3523 Scourge of the Downs (Inside — Belnistrasz)
	{ID_ATTUNE="280",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 28",LOCATION="",ID_WOWHEAD="28",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="280",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="3636",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Bring the Light
	{ID_ATTUNE="280",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="6626",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Host of Evil
	-- STAGE 30
	{ID_ATTUNE="280",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Razorfen Downs"],ID_WOWHEAD="7358",ICON="Interface\\Icons\\spell_frost_frostbolt",FOLLOWS="220",STAGE="30"}, -- npc: Amnennar the Coldbringer
	{ID_ATTUNE="280",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="30"},
	-- STAGE 40
	{ID_ATTUNE="280",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="3636",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Bring the Light
	{ID_ATTUNE="280",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},
	-- SIDE reminder (inside dungeon) — left of End
	{ID_ATTUNE="280",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Razorfen Downs"],ID_WOWHEAD="3523",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="40",SIDE=true}, -- quest: Scourge of the Downs (Inside)
	{ID_ATTUNE="280",ID="250",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="240&140&320",STAGE="50"},

--vForever dungeon attune 290
	-- Columns L→R: 3341 Bring the End | 6522→6521 Unholy Alliance (longest) | 6626 Host of Evil
	-- SIDE (beside End): 3523 Scourge of the Downs (Inside — Belnistrasz)
	{ID_ATTUNE="290",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 28",LOCATION="",ID_WOWHEAD="28",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="290",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="3341",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Bring the End
	{ID_ATTUNE="290",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="6522",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: An Unholy Alliance (Small Scroll from RFK)
	{ID_ATTUNE="290",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="6626",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Host of Evil
	-- STAGE 30
	{ID_ATTUNE="290",ID="330",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Razorfen Downs"],ID_WOWHEAD="7358",ICON="Interface\\Icons\\spell_frost_frostbolt",FOLLOWS="320",STAGE="30"}, -- npc: Amnennar the Coldbringer
	{ID_ATTUNE="290",ID="230",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="6521",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="30"}, -- quest: An Unholy Alliance
	{ID_ATTUNE="290",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="30"},
	-- STAGE 40
	{ID_ATTUNE="290",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Downs"],ID_WOWHEAD="10420",ICON="Interface\\Icons\\inv_misc_bone_humanskull_01",FOLLOWS="330",STAGE="40"}, -- item: Skull of the Coldbringer
	{ID_ATTUNE="290",ID="240",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="12865",ICON="Interface\\Icons\\spell_shadow_raisedead",FOLLOWS="230",STAGE="40"}, -- npc: Ambassador Malcin
	{ID_ATTUNE="290",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},
	-- STAGE 50
	{ID_ATTUNE="290",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="3341",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="50"}, -- quest: Bring the End
	{ID_ATTUNE="290",ID="250",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="17009",ICON="Interface\\Icons\\inv_misc_head_undead_01",FOLLOWS="240",STAGE="50"}, -- item: Ambassador Malcin's Head
	{ID_ATTUNE="290",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="290",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="290",ID="260",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="6521",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="250",STAGE="60"}, -- quest: An Unholy Alliance
	{ID_ATTUNE="290",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- SIDE reminder (inside dungeon) — left of End
	{ID_ATTUNE="290",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Razorfen Downs"],ID_WOWHEAD="3523",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: Scourge of the Downs (Inside)
	{ID_ATTUNE="290",ID="370",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="360&260&160&420",STAGE="70"},

--vForever dungeon attune 300
	-- Columns L→R: 7065 Corruption | 7044 Legends (Noxxion→Rod ‖ Vyletongue→Diamond) | 7041 Vyletongue Corruption | 7028 Twisted Evils | 7070 Shadowshard | 7067 Pariah
	-- SIDE (beside End): 7066 Seed of Life, 7046 The Scepter of Celebras (Inside)
	{ID_ATTUNE="300",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 39",LOCATION="",ID_WOWHEAD="39",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="300",ID="720",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7065",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Corruption of Earth and Seed
	{ID_ATTUNE="300",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7044",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Legends of Maraudon
	{ID_ATTUNE="300",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7041",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Vyletongue Corruption
	{ID_ATTUNE="300",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7028",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Twisted Evils
	{ID_ATTUNE="300",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="7070",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Shadowshard Fragments
	{ID_ATTUNE="300",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7067",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Pariah's Instructions
	-- STAGE 30 
	{ID_ATTUNE="300",ID="730",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="12201",ICON="Interface\\Icons\\spell_nature_earthquake",FOLLOWS="720",STAGE="30"}, -- npc: Princess Theradras
    {ID_ATTUNE="300",ID="630",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="620",STAGE="30"},
	{ID_ATTUNE="300",ID="430",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="420",STAGE="30"},
	{ID_ATTUNE="300",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17684",ICON="Interface\\Icons\\inv_misc_gem_stone_01",FOLLOWS="320",STAGE="30",COUNT=15}, -- item: Theradric Crystal Carving
	{ID_ATTUNE="300",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17756",ICON="Interface\\Icons\\inv_misc_gem_amethyst_02",FOLLOWS="220",STAGE="30",COUNT=10}, -- item: Shadowshard Fragment
	{ID_ATTUNE="300",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17758",ICON="Interface\\Icons\\inv_jewelry_amulet_04",FOLLOWS="120",STAGE="30"}, -- item: Amulet of Union
	-- STAGE 40 
	{ID_ATTUNE="300",ID="740",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7065",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="40"}, -- quest: Corruption of Earth and Seed
    {ID_ATTUNE="300",ID="640",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="630",STAGE="40"},
	{ID_ATTUNE="300",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="430",STAGE="40"},
	{ID_ATTUNE="300",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7028",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Twisted Evils
	{ID_ATTUNE="300",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="7070",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Shadowshard Fragments
	{ID_ATTUNE="300",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7067",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: The Pariah's Instructions
	-- STAGE 50 (Noxxion ‖ Lord Vyletongue)
	-- {ID_ATTUNE="300",ID="750",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="50"},
  	{ID_ATTUNE="300",ID="650",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="13282",ICON="Interface\\Icons\\spell_nature_acid_01",FOLLOWS="640",STAGE="50"}, -- npc: Noxxion
	{ID_ATTUNE="300",ID="450",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="12236",ICON="Interface\\Icons\\spell_shadow_shadowwordpain",FOLLOWS="640",STAGE="50"}, -- npc: Lord Vyletongue
	{ID_ATTUNE="300",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="300",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="300",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	-- STAGE 60 (Celebrian Rod ‖ Celebrian Diamond)
	-- {ID_ATTUNE="300",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="300",ID="660",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17702",ICON="Interface\\Icons\\inv_wand_07",FOLLOWS="650",STAGE="60"}, -- item: Celebrian Rod
	{ID_ATTUNE="300",ID="460",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17703",ICON="Interface\\Icons\\inv_misc_gem_diamond_02",FOLLOWS="450",STAGE="60"}, -- item: Celebrian Diamond
	{ID_ATTUNE="300",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="300",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="300",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	-- STAGE 70 (Legends turn-in requires both items)
	{ID_ATTUNE="300",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="70"},
	{ID_ATTUNE="300",ID="670",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7044",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="660&460",STAGE="70"}, -- quest: Legends of Maraudon
	{ID_ATTUNE="300",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="70"},
	{ID_ATTUNE="300",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="70"},
	{ID_ATTUNE="300",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="70"},
	{ID_ATTUNE="300",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="70"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="300",ID="820",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7066",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="80",SIDE=true}, -- quest: Seed of Life (Inside — Zaetar's Spirit)
	{ID_ATTUNE="300",ID="810",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7046",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="80",SIDE=true}, -- quest: The Scepter of Celebras (Inside)
	{ID_ATTUNE="300",ID="760",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="770&670&470&370&270&170&820&810",STAGE="90"},

--vForever dungeon attune 310
	-- Columns L→R: 7029 Vyletongue Corruption | 7064 Corruption | 7044 Legends (Noxxion→Rod ‖ Vyletongue→Diamond) | 7028 Twisted Evils | 7068 Shadowshard | 7067 Pariah
	-- SIDE (beside End): 7066 Seed of Life, 7046 The Scepter of Celebras (Inside)
	-- Legends: 2 blank rows before Noxxion ‖ Lord Vyletongue so kills align with other quests' later stages
	{ID_ATTUNE="310",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 39",LOCATION="",ID_WOWHEAD="39",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="310",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7029",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Vyletongue Corruption
	{ID_ATTUNE="310",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7064",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Corruption of Earth and Seed
	{ID_ATTUNE="310",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7044",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Legends of Maraudon
	-- {ID_ATTUNE="310",ID="420",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="310",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7028",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Twisted Evils
	{ID_ATTUNE="310",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="7068",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Shadowshard Fragments
	{ID_ATTUNE="310",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7067",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Pariah's Instructions
	-- STAGE 30 (Legends blank row 1)
	{ID_ATTUNE="310",ID="730",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="720",STAGE="30"},
	{ID_ATTUNE="310",ID="630",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="12201",ICON="Interface\\Icons\\spell_nature_earthquake",FOLLOWS="620",STAGE="30"}, -- npc: Princess Theradras
	{ID_ATTUNE="310",ID="530",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="520",STAGE="30"},
	-- {ID_ATTUNE="310",ID="430",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="310",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17684",ICON="Interface\\Icons\\inv_jewelry_talisman_07",FOLLOWS="320",STAGE="30",COUNT=15}, -- item: Theradric Crystal Carving
	{ID_ATTUNE="310",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17756",ICON="Interface\\Icons\\inv_misc_gem_amethyst_03",FOLLOWS="220",STAGE="30",COUNT=10}, -- item: Shadowshard Fragment
	{ID_ATTUNE="310",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17758",ICON="Interface\\Icons\\inv_jewelry_amulet_04",FOLLOWS="120",STAGE="30"}, -- item: Amulet of Union
	-- STAGE 40 (Legends blank row 2)
	{ID_ATTUNE="310",ID="740",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="730",STAGE="40"},
	{ID_ATTUNE="310",ID="640",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7064",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="40"}, -- quest: Corruption of Earth and Seed
	{ID_ATTUNE="310",ID="540",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="530",STAGE="40"},
	-- {ID_ATTUNE="310",ID="440",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="430",STAGE="40"},
	{ID_ATTUNE="310",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7028",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Twisted Evils
	{ID_ATTUNE="310",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="7068",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Shadowshard Fragments
	{ID_ATTUNE="310",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Desolace"],ID_WOWHEAD="7067",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: The Pariah's Instructions
	-- STAGE 50 (Noxxion ‖ Lord Vyletongue)
	-- {ID_ATTUNE="310",ID="750",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="50"},
	-- {ID_ATTUNE="310",ID="650",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="640",STAGE="50"},
	{ID_ATTUNE="310",ID="550",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="13282",ICON="Interface\\Icons\\spell_nature_acid_01",FOLLOWS="540",STAGE="50"}, -- npc: Noxxion
	{ID_ATTUNE="310",ID="450",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="12236",ICON="Interface\\Icons\\spell_shadow_shadowwordpain",FOLLOWS="540",STAGE="50"}, -- npc: Lord Vyletongue
	-- {ID_ATTUNE="310",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	-- {ID_ATTUNE="310",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	{ID_ATTUNE="310",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	-- STAGE 60 (Celebrian Rod ‖ Celebrian Diamond)
	-- {ID_ATTUNE="310",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="60"},
	-- {ID_ATTUNE="310",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="650",STAGE="60"},
	{ID_ATTUNE="310",ID="560",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17702",ICON="Interface\\Icons\\inv_wand_07",FOLLOWS="550",STAGE="60"}, -- item: Celebrian Rod
	{ID_ATTUNE="310",ID="460",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="17703",ICON="Interface\\Icons\\inv_misc_gem_diamond_02",FOLLOWS="450",STAGE="60"}, -- item: Celebrian Diamond
	-- {ID_ATTUNE="310",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	-- {ID_ATTUNE="310",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="310",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	-- STAGE 70 (Legends turn-in requires both items)
	{ID_ATTUNE="310",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="70"},
	{ID_ATTUNE="310",ID="670",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="640",STAGE="70"},
	{ID_ATTUNE="310",ID="570",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7044",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="560&460",STAGE="70"}, -- quest: Legends of Maraudon
	-- {ID_ATTUNE="310",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="460",STAGE="70"},
	{ID_ATTUNE="310",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="70"},
	{ID_ATTUNE="310",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="70"},
	{ID_ATTUNE="310",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="70"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="310",ID="820",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7066",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: Seed of Life (Inside — Zaetar's Spirit)
	{ID_ATTUNE="310",ID="810",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Maraudon"],ID_WOWHEAD="7046",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: The Scepter of Celebras (Inside)
	{ID_ATTUNE="310",ID="780",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="770&670&570&370&270&170&820&810",STAGE="80"},

--vForever dungeon attune 320
	-- Columns L→R: 2398→2240 Dwarves | 1139 Tablets | 2500→17 Fungus | 720→722 Hope/Amulet | 2418 Stones | 1360 Treasures | 709 Solution
	-- Row 30 is only Dentrium ‖ An'Alleum. Other chains skip this row.
	-- SIDE (beside End): 2198 The Shattered Necklace (Inside), 2278 The Platinum Discs (Inside)
	{ID_ATTUNE="320",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="320",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2398",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Lost Dwarves
	{ID_ATTUNE="320",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1139",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Lost Tablets of Will
	{ID_ATTUNE="320",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="2500",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Badlands Reagent Run (prereq)
	{ID_ATTUNE="320",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="720",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Sign of Hope (prereq)
	{ID_ATTUNE="320",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2418",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Power Stones
	{ID_ATTUNE="320",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1360",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Reclaimed Treasures
	{ID_ATTUNE="320",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="709",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Solution to Doom
	-- STAGE 30 (Power Stones only — other chains skip this row)
    {ID_ATTUNE="320",ID="355",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
    {ID_ATTUNE="320",ID="345",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="320",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8052",ICON="Interface\\Icons\\inv_misc_gem_sapphire_02",FOLLOWS="320",STAGE="30",COUNT=8}, -- item: An'Alleum Power Stone
	{ID_ATTUNE="320",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8009",ICON="Interface\\Icons\\inv_misc_gem_diamond_01",FOLLOWS="320",STAGE="30",COUNT=8}, -- item: Dentrium Power Stone
	-- STAGE 40
	{ID_ATTUNE="320",ID="730",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="2240",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="720",STAGE="40"}, -- quest: The Hidden Chamber
	{ID_ATTUNE="320",ID="630",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="5824",ICON="Interface\\Icons\\inv_misc_rune_01",FOLLOWS="620",STAGE="40"}, -- item: Tablet of Will
	{ID_ATTUNE="320",ID="530",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="17",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="40"}, -- quest: Uldaman Reagent Run
	{ID_ATTUNE="320",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="721",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="40"}, -- quest: A Sign of Hope
	{ID_ATTUNE="320",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2418",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340&330",STAGE="40"}, -- quest: Power Stones
	{ID_ATTUNE="320",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8027",ICON="Interface\\Icons\\inv_drink_03",FOLLOWS="220",STAGE="40"}, -- item: Krom Stoutarm's Treasure
	{ID_ATTUNE="320",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="4631",ICON="Interface\\Icons\\inv_misc_rune_02",FOLLOWS="120",STAGE="40"}, -- item: Tablet of Ryun'eh
	-- STAGE 50
	{ID_ATTUNE="320",ID="740",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="730",STAGE="50"},
	{ID_ATTUNE="320",ID="640",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1139",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="50"}, -- quest: The Lost Tablets of Will
	{ID_ATTUNE="320",ID="540",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8047",ICON="Interface\\Icons\\inv_mushroom_01",FOLLOWS="530",STAGE="50",COUNT=12}, -- item: Magenta Fungus Cap
	{ID_ATTUNE="320",ID="440",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="722",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="50"}, -- quest: Amulet of Secrets
	{ID_ATTUNE="320",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="50"},
	{ID_ATTUNE="320",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1360",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="50"}, -- quest: Reclaimed Treasures
	{ID_ATTUNE="320",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="709",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="50"}, -- quest: Solution to Doom
	-- STAGE 60
	{ID_ATTUNE="320",ID="750",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="60"},
	{ID_ATTUNE="320",ID="650",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="640",STAGE="60"},
	{ID_ATTUNE="320",ID="550",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="17",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="540",STAGE="60"}, -- quest: Uldaman Reagent Run
	{ID_ATTUNE="320",ID="450",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="4635",ICON="Interface\\Icons\\inv_jewelry_amulet_03",FOLLOWS="440",STAGE="60"}, -- item: Hammertoe's Amulet
	{ID_ATTUNE="320",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="60"},
	{ID_ATTUNE="320",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="60"},
	{ID_ATTUNE="320",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="320",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="70"},
	{ID_ATTUNE="320",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="650",STAGE="70"},
	{ID_ATTUNE="320",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="70"},
	{ID_ATTUNE="320",ID="460",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="722",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="450",STAGE="70"}, -- quest: Amulet of Secrets
	{ID_ATTUNE="320",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="70"},
	{ID_ATTUNE="320",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="70"},
	{ID_ATTUNE="320",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="70"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="320",ID="810",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="2198",ICON="Interface\\Icons\\inv_jewelry_necklace_02",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: The Shattered Necklace (Inside)
	{ID_ATTUNE="320",ID="800",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="2278",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: The Platinum Discs (Inside)
	{ID_ATTUNE="320",ID="780",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="760&660&560&460&380&260&160&810&800",STAGE="80"},

--vForever dungeon attune 330
	-- Columns L→R: 2342 Treasures | 2258→2202 Fungus | 2418 Stones | 2283 Necklace | 709 Tablet
	-- Row 30 is only Dentrium ‖ An'Alleum. Other chains skip that row.
	-- SIDE (beside End): 2318 Translating the Journal (Inside), 2278 The Platinum Discs (Inside)
	{ID_ATTUNE="330",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="330",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="2342",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Reclaimed Treasures
	{ID_ATTUNE="330",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2258",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Badlands Reagent Run (prereq)
	{ID_ATTUNE="330",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2418",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Power Stones
	{ID_ATTUNE="330",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="2283",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Necklace Recovery
	{ID_ATTUNE="330",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="709",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Solution to Doom
	-- STAGE 30 (Power Stones only — other chains skip this row)
	{ID_ATTUNE="330",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8052",ICON="Interface\\Icons\\inv_battery_01",FOLLOWS="320",STAGE="30",COUNT=8}, -- item: An'Alleum Power Stone
	{ID_ATTUNE="330",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8009",ICON="Interface\\Icons\\inv_battery_02",FOLLOWS="320",STAGE="30",COUNT=8}, -- item: Dentrium Power Stone
	-- STAGE 40
	{ID_ATTUNE="330",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8026",ICON="Interface\\Icons\\inv_box_01",FOLLOWS="520",STAGE="40"}, -- item: Garrett Family Treasure
	{ID_ATTUNE="330",ID="430",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2202",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="40"}, -- quest: Uldaman Reagent Run
	{ID_ATTUNE="330",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2418",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340&330",STAGE="40"}, -- quest: Power Stones
	{ID_ATTUNE="330",ID="230",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="2284",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="40"}, -- quest: Necklace Recovery, Take 2
	{ID_ATTUNE="330",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="4631",ICON="Interface\\Icons\\inv_misc_rune_02",FOLLOWS="120",STAGE="40"}, -- item: Tablet of Ryun'eh
	-- STAGE 50
	{ID_ATTUNE="330",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="2342",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="50"}, -- quest: Reclaimed Treasures
	{ID_ATTUNE="330",ID="440",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="8047",ICON="Interface\\Icons\\inv_mushroom_01",FOLLOWS="430",STAGE="50",COUNT=12}, -- item: Magenta Fungus Cap
	{ID_ATTUNE="330",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="50"},
	{ID_ATTUNE="330",ID="240",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2339",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="50"}, -- quest: Find the Gems and Power Source
	{ID_ATTUNE="330",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="709",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="50"}, -- quest: Solution to Doom
	-- STAGE 60
	{ID_ATTUNE="330",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="60"},
	{ID_ATTUNE="330",ID="450",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2202",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440",STAGE="60"}, -- quest: Uldaman Reagent Run
	{ID_ATTUNE="330",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="60"},
	{ID_ATTUNE="330",ID="250",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="7672",ICON="Interface\\Icons\\inv_misc_orb_03",FOLLOWS="240",STAGE="60"}, -- item: Shattered Necklace Power Source
	{ID_ATTUNE="330",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="330",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="70"},
	{ID_ATTUNE="330",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="70"},
	{ID_ATTUNE="330",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="70"},
	{ID_ATTUNE="330",ID="260",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="2339",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="250",STAGE="70"}, -- quest: Find the Gems and Power Source
	{ID_ATTUNE="330",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="70"},
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="330",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="2318",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: Translating the Journal (Inside)
	{ID_ATTUNE="330",ID="610",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Uldaman"],ID_WOWHEAD="2278",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: The Platinum Discs (Inside)
	{ID_ATTUNE="330",ID="580",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="560&460&380&260&160&620&610",STAGE="80"},

--vForever dungeon attune 340 (Alliance)
	-- Columns L→R: 7494→7488 Web | 7441 Pusillin | 5526 Felvine | 7482 Elven | 7461 Madness (Inside)
	{ID_ATTUNE="340",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 54",LOCATION="",ID_WOWHEAD="54",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="340",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="7494",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Feathermoon Stronghold
	{ID_ATTUNE="340",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7441",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Pusillin and the Elder Azj'Tordin
	{ID_ATTUNE="340",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5526",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Shards of the Felvine
	{ID_ATTUNE="340",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7482",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Elven Legends
	-- STAGE 30
	{ID_ATTUNE="340",ID="430",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7488",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Lethtendris's Web
	{ID_ATTUNE="340",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="18261",ICON="Interface\\Icons\\inv_misc_book_07",FOLLOWS="320",STAGE="30"}, -- item: Book of Incantations
	{ID_ATTUNE="340",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="18501",ICON="Interface\\Icons\\inv_enchant_shardradientsmall",FOLLOWS="220",STAGE="30"}, -- item: Felvine Shard
	{ID_ATTUNE="340",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="30"},
	-- STAGE 40
	{ID_ATTUNE="340",ID="440",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="18426",ICON="Interface\\Icons\\spell_nature_web",FOLLOWS="430",STAGE="40"}, -- item: Lethtendris's Web
	{ID_ATTUNE="340",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7441",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Pusillin and the Elder Azj'Tordin
	{ID_ATTUNE="340",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5526",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Shards of the Felvine
	{ID_ATTUNE="340",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},
	-- STAGE 50
	{ID_ATTUNE="340",ID="450",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7488",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440",STAGE="50"}, -- quest: Lethtendris's Web
	{ID_ATTUNE="340",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="340",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	{ID_ATTUNE="340",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	{ID_ATTUNE="340",ID="610",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="7461",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: The Madness Within (Inside)
	{ID_ATTUNE="340",ID="460",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="450&350&250&150&610",STAGE="60"},


--vForever dungeon attune 341 (Horde)
	-- Columns L→R: 7492→7489 Web | 7441 Pusillin | 5526 Felvine | 7481 Elven | 7461 Madness (Inside)
	{ID_ATTUNE="341",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 54",LOCATION="",ID_WOWHEAD="54",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="341",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="7492",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Camp Mojache
	{ID_ATTUNE="341",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7441",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Pusillin and the Elder Azj'Tordin
	{ID_ATTUNE="341",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5526",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Shards of the Felvine
	{ID_ATTUNE="341",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7481",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Elven Legends
	-- STAGE 30
	{ID_ATTUNE="341",ID="430",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7489",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Lethtendris's Web
	{ID_ATTUNE="341",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="18261",ICON="Interface\\Icons\\inv_misc_book_07",FOLLOWS="320",STAGE="30"}, -- item: Book of Incantations
	{ID_ATTUNE="341",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="18501",ICON="Interface\\Icons\\inv_enchant_shardradientsmall",FOLLOWS="220",STAGE="30"}, -- item: Felvine Shard
	{ID_ATTUNE="341",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="30"},
	-- STAGE 40
	{ID_ATTUNE="341",ID="440",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="18426",ICON="Interface\\Icons\\spell_nature_web",FOLLOWS="430",STAGE="40"}, -- item: Lethtendris's Web
	{ID_ATTUNE="341",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7441",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Pusillin and the Elder Azj'Tordin
	{ID_ATTUNE="341",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5526",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Shards of the Felvine
	{ID_ATTUNE="341",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},
	-- STAGE 50
	{ID_ATTUNE="341",ID="450",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7489",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440",STAGE="50"}, -- quest: Lethtendris's Web
	{ID_ATTUNE="341",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="341",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	{ID_ATTUNE="341",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	{ID_ATTUNE="341",ID="610",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="7461",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="60",SIDE=true}, -- quest: The Madness Within (Inside)
	{ID_ATTUNE="341",ID="460",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="450&350&250&150&610",STAGE="60"},


--vForever dungeon attune 350 (Alliance)
	-- Columns L→R: 2768 Rod | 2991 Nekrum | 2770 Gahz'rilla | 3520→3527 Mosh'aru | 2846 Tiara | 3042 Temper | 2865 Scarabs
	-- Row 40 is only the two Mosh'aru tablets. Item turn-ins are row 50.
	{ID_ATTUNE="350",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 40",LOCATION="",ID_WOWHEAD="40",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="350",ID="920",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2768",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Divino-matic Rod
	{ID_ATTUNE="350",ID="820",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blasted Lands"],ID_WOWHEAD="2991",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Nekrum's Medallion
	{ID_ATTUNE="350",ID="720",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="2770",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Gahz'rilla
	{ID_ATTUNE="350",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="3520",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Screecher Spirits
	{ID_ATTUNE="350",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="2846",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Tiara of the Deep
	{ID_ATTUNE="350",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3042",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Troll Temper
	{ID_ATTUNE="350",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2865",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Scarab Shells
	-- STAGE 30
	{ID_ATTUNE="350",ID="930",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="8548",ICON="Interface\\Icons\\inv_wand_08",FOLLOWS="920",STAGE="30"}, -- item: Divino-matic Rod (Sergeant Bly)
	{ID_ATTUNE="350",ID="830",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="9471",ICON="Interface\\Icons\\inv_jewelry_amulet_01",FOLLOWS="820",STAGE="30"}, -- item: Nekrum's Medallion
	{ID_ATTUNE="350",ID="730",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="8707",ICON="Interface\\Icons\\inv_misc_monsterscales_17",FOLLOWS="720",STAGE="30"}, -- item: Gahz'rilla's Electrified Scale
	{ID_ATTUNE="350",ID="630",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="350",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="9234",ICON="Interface\\Icons\\inv_jewelry_amulet_05",FOLLOWS="320",STAGE="30"}, -- item: Tiara of the Deep
	{ID_ATTUNE="350",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="9523",ICON="Interface\\Icons\\inv_potion_08",FOLLOWS="220",STAGE="30",COUNT=20}, -- item: Troll Temper
	{ID_ATTUNE="350",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="9238",ICON="Interface\\Icons\\inv_misc_monsterscales_01",FOLLOWS="120",STAGE="30",COUNT=5}, -- item: Uncracked Scarab Shell
	-- STAGE 40 (Mosh'aru tablets only)
	-- {ID_ATTUNE="350",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="350",ID="640",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="10660",ICON="Interface\\Icons\\inv_misc_rune_04",FOLLOWS="630",STAGE="40"}, -- item: First Mosh'aru Tablet
	{ID_ATTUNE="350",ID="540",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="10661",ICON="Interface\\Icons\\inv_misc_rune_08",FOLLOWS="630",STAGE="40"}, -- item: Second Mosh'aru Tablet
    -- STAGE 50 (item turn-ins)
	{ID_ATTUNE="350",ID="950",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2768",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="930",STAGE="50"}, -- quest: Divino-matic Rod
	{ID_ATTUNE="350",ID="850",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blasted Lands"],ID_WOWHEAD="2991",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="830",STAGE="50"}, -- quest: Nekrum's Medallion
	{ID_ATTUNE="350",ID="750",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="2770",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="50"}, -- quest: Gahz'rilla
	{ID_ATTUNE="350",ID="650",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="640&540",STAGE="50"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="350",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="2846",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="50"}, -- quest: Tiara of the Deep
	{ID_ATTUNE="350",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3042",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="50"}, -- quest: Troll Temper
	{ID_ATTUNE="350",ID="150",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2865",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="50"}, -- quest: Scarab Shells
	{ID_ATTUNE="350",ID="1000",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="950&850&750&650&350&250&150",STAGE="60"},


--vForever dungeon attune 351 (Horde)
	-- Columns L→R: 2768 Rod | 2770 Gahz'rilla | 3520→3527 Mosh'aru | 2933→2936 Spider God (longest) | 2846 Tiara | 3042 Temper | 2865 Scarabs
	-- Row 40 is only the two Mosh'aru tablets. Item turn-ins are row 50.
	{ID_ATTUNE="351",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 40",LOCATION="",ID_WOWHEAD="40",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="351",ID="920",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2768",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Divino-matic Rod
	{ID_ATTUNE="351",ID="720",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="2770",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Gahz'rilla
	{ID_ATTUNE="351",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="3520",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Screecher Spirits
	{ID_ATTUNE="351",ID="420",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="9321",ICON="Interface\\Icons\\inv_potion_19",FOLLOWS="10",STAGE="20"}, -- item: Venom Bottle (starts Venom Bottles)
	{ID_ATTUNE="351",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="2846",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Tiara of the Deep
	{ID_ATTUNE="351",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3042",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Troll Temper
	{ID_ATTUNE="351",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2865",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Scarab Shells
	-- STAGE 30
	{ID_ATTUNE="351",ID="930",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="8548",ICON="Interface\\Icons\\inv_wand_08",FOLLOWS="920",STAGE="30"}, -- item: Divino-matic Rod (Sergeant Bly)
	{ID_ATTUNE="351",ID="730",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="8707",ICON="Interface\\Icons\\inv_misc_monsterscales_17",FOLLOWS="720",STAGE="30"}, -- item: Gahz'rilla's Electrified Scale
	{ID_ATTUNE="351",ID="630",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="351",ID="430",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="2933",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Venom Bottles
	{ID_ATTUNE="351",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="9234",ICON="Interface\\Icons\\inv_jewelry_amulet_05",FOLLOWS="320",STAGE="30"}, -- item: Tiara of the Deep
	{ID_ATTUNE="351",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="9523",ICON="Interface\\Icons\\inv_potion_08",FOLLOWS="220",STAGE="30",COUNT=20}, -- item: Troll Temper
	{ID_ATTUNE="351",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="9238",ICON="Interface\\Icons\\inv_misc_monsterscales_01",FOLLOWS="120",STAGE="30",COUNT=5}, -- item: Uncracked Scarab Shell
	-- STAGE 40 (Mosh'aru tablets only)
    {ID_ATTUNE="351",ID="640",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="10660",ICON="Interface\\Icons\\inv_misc_rune_04",FOLLOWS="630",STAGE="40"}, -- item: First Mosh'aru Tablet
	{ID_ATTUNE="351",ID="540",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="10661",ICON="Interface\\Icons\\inv_misc_rune_08",FOLLOWS="630",STAGE="40"}, -- item: Second Mosh'aru Tablet
    {ID_ATTUNE="351",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="351",ID="240",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    -- STAGE 50 (item turn-ins)
	{ID_ATTUNE="351",ID="950",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2768",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="930",STAGE="50"}, -- quest: Divino-matic Rod
	{ID_ATTUNE="351",ID="750",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="2770",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="50"}, -- quest: Gahz'rilla
	{ID_ATTUNE="351",ID="650",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="640&540",STAGE="50"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="351",ID="450",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="2934",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="50"}, -- quest: Undamaged Venom Sac
	{ID_ATTUNE="351",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="2846",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="50"}, -- quest: Tiara of the Deep
	{ID_ATTUNE="351",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3042",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="50"}, -- quest: Troll Temper
	{ID_ATTUNE="351",ID="150",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="2865",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="50"}, -- quest: Scarab Shells
	-- STAGE 60
	{ID_ATTUNE="351",ID="960",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="950",STAGE="60"},
	{ID_ATTUNE="351",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="60"},
	{ID_ATTUNE="351",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="650",STAGE="60"},
	{ID_ATTUNE="351",ID="460",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="9322",ICON="Interface\\Icons\\inv_misc_organ_02",FOLLOWS="450",STAGE="60"}, -- item: Undamaged Venom Sac
	{ID_ATTUNE="351",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="351",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="351",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="351",ID="970",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="960",STAGE="70"},
	{ID_ATTUNE="351",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="760",STAGE="70"},
	{ID_ATTUNE="351",ID="670",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="660",STAGE="70"},
	{ID_ATTUNE="351",ID="470",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="2934",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="460",STAGE="70"}, -- quest: Undamaged Venom Sac
	{ID_ATTUNE="351",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="70"},
	{ID_ATTUNE="351",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="260",STAGE="70"},
	{ID_ATTUNE="351",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="351",ID="980",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="970",STAGE="80"},
	{ID_ATTUNE="351",ID="780",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="770",STAGE="80"},
	{ID_ATTUNE="351",ID="680",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="670",STAGE="80"},
	{ID_ATTUNE="351",ID="480",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2935",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="470",STAGE="80"}, -- quest: Consult Master Gadrin
	{ID_ATTUNE="351",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="80"},
	{ID_ATTUNE="351",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="270",STAGE="80"},
	{ID_ATTUNE="351",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="170",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="351",ID="990",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="980",STAGE="90"},
	{ID_ATTUNE="351",ID="790",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="780",STAGE="90"},
	{ID_ATTUNE="351",ID="690",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="680",STAGE="90"},
	{ID_ATTUNE="351",ID="490",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Zul'Farrak"],ID_WOWHEAD="2936",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="480",STAGE="90"}, -- quest: The Spider God
	{ID_ATTUNE="351",ID="390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="380",STAGE="90"},
	{ID_ATTUNE="351",ID="290",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="280",STAGE="90"},
	{ID_ATTUNE="351",ID="190",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="180",STAGE="90"},
	{ID_ATTUNE="351",ID="1000",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="990&790&690&490&390&290&190",STAGE="100"},

--vForever dungeon attune 360 (Alliance)
	-- Columns L→R: 5243 Holy Water | 5251→5263 Archivist | 5461→5463 Ras | 5742→5848 Redemption (longest) | 5212→5213 Flesh | 5281→5282 Souls | 5214 Grimm
	-- SIDE: 5125 Aurius' Reckoning (Inside)
	{ID_ATTUNE="360",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 52",LOCATION="",ID_WOWHEAD="52",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="360",ID="820",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5243",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Houses of the Holy
	{ID_ATTUNE="360",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5251",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Archivist
	{ID_ATTUNE="360",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5461",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Human, Ras Frostwhisper
	{ID_ATTUNE="360",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5742",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Redemption
	{ID_ATTUNE="360",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5212",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Flesh Does Not Lie
	{ID_ATTUNE="360",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5281",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Restless Souls
	{ID_ATTUNE="360",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Great Fras Siabi
	-- STAGE 30
	{ID_ATTUNE="360",ID="821",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13180",ICON="Interface\\Icons\\inv_potion_75",FOLLOWS="820",STAGE="30",COUNT=5}, -- item: Stratholme Holy Water
	{ID_ATTUNE="360",ID="732",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="721",STAGE="130"},
	{ID_ATTUNE="360",ID="621",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="13585",ICON="Interface\\Icons\\inv_misc_book_04",FOLLOWS="620",STAGE="30"}, -- item: Keepsake of Remembrance
	{ID_ATTUNE="360",ID="521",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5781",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Of Forgotten Memories
	{ID_ATTUNE="360",ID="421",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13174",ICON="Interface\\Icons\\inv_misc_pelt_bear_ruin_03",FOLLOWS="420",STAGE="30",COUNT=20}, -- item: Plagued Flesh Sample
	{ID_ATTUNE="360",ID="322",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5282",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: The Restless Souls
	{ID_ATTUNE="360",ID="221",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13172",ICON="Interface\\Icons\\inv_crate_01",FOLLOWS="220",STAGE="30"}, -- item: Grimm's Premium Tobacco
	-- STAGE 40
	{ID_ATTUNE="360",ID="822",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5243",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="821",STAGE="40"}, -- quest: Houses of the Holy
	{ID_ATTUNE="360",ID="722",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="5262",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="720",STAGE="30"}, -- quest: The Truth Comes Crashing Down
	{ID_ATTUNE="360",ID="622",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5461",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="621",STAGE="40"}, -- quest: The Human, Ras Frostwhisper
	{ID_ATTUNE="360",ID="522",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="14613",ICON="Interface\\Icons\\inv_hammer_01",FOLLOWS="521",STAGE="40"}, -- item: Taelan's Hammer
	{ID_ATTUNE="360",ID="422",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5212",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="421",STAGE="40"}, -- quest: The Flesh Does Not Lie
	{ID_ATTUNE="360",ID="324",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="322",STAGE="40"},
	{ID_ATTUNE="360",ID="222",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="221",STAGE="40"}, -- quest: The Great Fras Siabi
	-- STAGE 50
	{ID_ATTUNE="360",ID="823",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="822",STAGE="50"},
	{ID_ATTUNE="360",ID="723",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13250",ICON="Interface\\Icons\\spell_shadow_possession",FOLLOWS="722",STAGE="40"}, -- item: Head of Balnazzar
	{ID_ATTUNE="360",ID="623",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5462",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="622",STAGE="50"}, -- quest: The Dying, Ras Frostwhisper
	{ID_ATTUNE="360",ID="523",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5781",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="522",STAGE="50"}, -- quest: Of Forgotten Memories
	{ID_ATTUNE="360",ID="423",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5213",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="422",STAGE="50"}, -- quest: The Active Agent
	{ID_ATTUNE="360",ID="325",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="324",STAGE="50"},
	{ID_ATTUNE="360",ID="223",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="222",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="360",ID="824",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="823",STAGE="60"},
	{ID_ATTUNE="360",ID="724",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5262",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="723",STAGE="50"}, -- quest: The Truth Comes Crashing Down
	{ID_ATTUNE="360",ID="625",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="5463",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="623",STAGE="60"}, -- quest: Menethil's Gift
	{ID_ATTUNE="360",ID="524",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5845",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="523",STAGE="60"}, -- quest: Of Lost Honor
	{ID_ATTUNE="360",ID="424",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13176",ICON="Interface\\Icons\\inv_misc_rune_07",FOLLOWS="423",STAGE="60"}, -- item: Scourge Data
	{ID_ATTUNE="360",ID="326",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="325",STAGE="60"},
	{ID_ATTUNE="360",ID="224",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="223",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="360",ID="825",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="824",STAGE="70"},
	{ID_ATTUNE="360",ID="725",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5263",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="724",STAGE="60"}, -- quest: Above and Beyond
	{ID_ATTUNE="360",ID="626",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="632",STAGE="130"},
	{ID_ATTUNE="360",ID="525",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="14625",ICON="Interface\\Icons\\inv_banner_02",FOLLOWS="524",STAGE="70"}, -- item: Symbol of Lost Honor
	{ID_ATTUNE="360",ID="425",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5213",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="424",STAGE="70"}, -- quest: The Active Agent
	{ID_ATTUNE="360",ID="327",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="326",STAGE="70"},
	{ID_ATTUNE="360",ID="225",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="224",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="360",ID="826",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="825",STAGE="80"},
	{ID_ATTUNE="360",ID="727",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13251",ICON="Interface\\Icons\\spell_shadow_charm",FOLLOWS="725",STAGE="70"}, -- item: Head of Baron Rivendare
	{ID_ATTUNE="360",ID="627",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="625",STAGE="70"},
	{ID_ATTUNE="360",ID="526",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5845",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="525",STAGE="80"}, -- quest: Of Lost Honor
	{ID_ATTUNE="360",ID="426",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="425",STAGE="80"},
	{ID_ATTUNE="360",ID="328",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="327",STAGE="80"},
	{ID_ATTUNE="360",ID="226",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="225",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="360",ID="827",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="826",STAGE="90"},
	{ID_ATTUNE="360",ID="728",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5263",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="727",STAGE="80"}, -- quest: Above and Beyond
	{ID_ATTUNE="360",ID="628",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="627",STAGE="80"},
	{ID_ATTUNE="360",ID="527",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5846",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="526",STAGE="90"}, -- quest: Of Love and Family
	{ID_ATTUNE="360",ID="427",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="426",STAGE="90"},
	{ID_ATTUNE="360",ID="329",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="328",STAGE="90"},
	{ID_ATTUNE="360",ID="227",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="226",STAGE="90"},
	-- STAGE 100
	{ID_ATTUNE="360",ID="828",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="827",STAGE="100"},
	{ID_ATTUNE="360",ID="729",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="728",STAGE="90"},
	{ID_ATTUNE="360",ID="629",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="628",STAGE="90"},
	{ID_ATTUNE="360",ID="528",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="531",STAGE="130"},
	{ID_ATTUNE="360",ID="428",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="427",STAGE="100"},
	{ID_ATTUNE="360",ID="330",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="329",STAGE="100"},
	{ID_ATTUNE="360",ID="228",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="227",STAGE="100"},
	-- STAGE 110
	{ID_ATTUNE="360",ID="829",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="828",STAGE="110"},
	{ID_ATTUNE="360",ID="730",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="729",STAGE="100"},
	{ID_ATTUNE="360",ID="630",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="629",STAGE="100"},
	{ID_ATTUNE="360",ID="529",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5848",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="527",STAGE="100"}, -- quest: Of Love and Family
	{ID_ATTUNE="360",ID="429",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="428",STAGE="110"},
	{ID_ATTUNE="360",ID="331",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="330",STAGE="110"},
	{ID_ATTUNE="360",ID="229",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="228",STAGE="110"},
	-- STAGE 120
	{ID_ATTUNE="360",ID="830",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="829",STAGE="120"},
	{ID_ATTUNE="360",ID="731",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="730",STAGE="110"},
	{ID_ATTUNE="360",ID="631",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="630",STAGE="110"},
	{ID_ATTUNE="360",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="14679",ICON="Interface\\Icons\\inv_scroll_06",FOLLOWS="529",STAGE="110"}, -- item: Of Love and Family
	{ID_ATTUNE="360",ID="430",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="429",STAGE="120"},
	{ID_ATTUNE="360",ID="332",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="331",STAGE="120"},
	{ID_ATTUNE="360",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="229",STAGE="120"},
	-- STAGE 130
	{ID_ATTUNE="360",ID="831",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="830",STAGE="130"},
	{ID_ATTUNE="360",ID="721",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="731",STAGE="120"},
	{ID_ATTUNE="360",ID="632",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="631",STAGE="120"},
	{ID_ATTUNE="360",ID="531",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5848",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="120"}, -- quest: Of Love and Family
	{ID_ATTUNE="360",ID="431",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="430",STAGE="130"},
	{ID_ATTUNE="360",ID="333",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="332",STAGE="130"},
	{ID_ATTUNE="360",ID="231",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="230",STAGE="130"},
	{ID_ATTUNE="360",ID="1400",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="5125",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="140",SIDE=true}, -- quest: Aurius' Reckoning (Inside)
	{ID_ATTUNE="360",ID="1401",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_bone_skull_02",FOLLOWS="831&732&626&528&431&333&231&1400",STAGE="140"},

--vForever dungeon attune 361 (Horde)
	-- Columns L→R: 5281→5282 Souls | 5243 Holy Water | 5214 Grimm | 5742→5848 Redemption (longest) | 5212→5213 Flesh | 5251→5263 Archivist | 5461→5463 Ras | (gap) | 5961→6163 Nathanos
	-- Nathanos row: 6042 ‖ 6022 ‖ 6133, then 6135 ‖ 6136, then 6144 → 6163
	-- SIDE: 5125 Aurius' Reckoning (Inside)
	{ID_ATTUNE="361",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 52",LOCATION="",ID_WOWHEAD="52",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="361",ID="720",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5243",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Houses of the Holy
	{ID_ATTUNE="361",ID="820",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5281",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Restless Souls
	{ID_ATTUNE="361",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Great Fras Siabi
	{ID_ATTUNE="361",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5742",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Redemption
	{ID_ATTUNE="361",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5212",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Flesh Does Not Lie
	{ID_ATTUNE="361",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5251",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Archivist
	{ID_ATTUNE="361",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5461",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Human, Ras Frostwhisper
	{ID_ATTUNE="361",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="361",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5961",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Champion of the Banshee Queen
    {ID_ATTUNE="361",ID="110",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	-- STAGE 30
	{ID_ATTUNE="361",ID="721",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13180",ICON="Interface\\Icons\\inv_potion_75",FOLLOWS="720",STAGE="30",COUNT=5}, -- item: Stratholme Holy Water
	{ID_ATTUNE="361",ID="822",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5282",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="820",STAGE="30"}, -- quest: The Restless Souls
	{ID_ATTUNE="361",ID="621",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13172",ICON="Interface\\Icons\\inv_crate_01",FOLLOWS="620",STAGE="30"}, -- item: Grimm's Premium Tobacco
	{ID_ATTUNE="361",ID="521",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5781",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Of Forgotten Memories
	{ID_ATTUNE="361",ID="421",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13174",ICON="Interface\\Icons\\inv_misc_pelt_bear_ruin_03",FOLLOWS="420",STAGE="30",COUNT=20}, -- item: Plagued Flesh Sample
	{ID_ATTUNE="361",ID="322",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="5262",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: The Archivist
	{ID_ATTUNE="361",ID="221",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="13585",ICON="Interface\\Icons\\inv_misc_book_04",FOLLOWS="220",STAGE="30"}, -- item: Keepsake of Remembrance
    {ID_ATTUNE="361",ID="122",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6042",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="30"}, -- quest: Un-Life's Little Annoyances
	{ID_ATTUNE="361",ID="119",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6022",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="30"}, -- quest: To Kill With Purpose
	{ID_ATTUNE="361",ID="118",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6133",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="30"}, -- quest: The Ranger Lord's Behest
	-- STAGE 40
	{ID_ATTUNE="361",ID="722",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5243",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="721",STAGE="40"}, -- quest: Houses of the Holy
	{ID_ATTUNE="361",ID="824",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="822",STAGE="40"},
	{ID_ATTUNE="361",ID="622",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5214",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="621",STAGE="40"}, -- quest: The Great Fras Siabi
	{ID_ATTUNE="361",ID="522",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="14613",ICON="Interface\\Icons\\inv_hammer_01",FOLLOWS="521",STAGE="40"}, -- item: Taelan's Hammer
	{ID_ATTUNE="361",ID="422",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5212",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="421",STAGE="40"}, -- quest: The Flesh Does Not Lie
	{ID_ATTUNE="361",ID="323",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13250",ICON="Interface\\Icons\\spell_shadow_possession",FOLLOWS="322",STAGE="40"}, -- item: Head of Balnazzar
	{ID_ATTUNE="361",ID="222",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5461",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="221",STAGE="40"}, -- quest: The Human, Ras Frostwhisper
    {ID_ATTUNE="361",ID="151",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="361",ID="121",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="122&119&118",STAGE="40"},
    {ID_ATTUNE="361",ID="111",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	-- {ID_ATTUNE="361",ID="152",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	-- {ID_ATTUNE="361",ID="122",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6042",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="121",STAGE="40"}, -- quest: Un-Life's Little Annoyances
	-- {ID_ATTUNE="361",ID="119",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6022",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="121",STAGE="40"}, -- quest: To Kill With Purpose
	-- {ID_ATTUNE="361",ID="118",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6133",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="121",STAGE="40"}, -- quest: The Ranger Lord's Behest
	-- STAGE 50
	{ID_ATTUNE="361",ID="723",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="722",STAGE="50"},
	{ID_ATTUNE="361",ID="825",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="824",STAGE="50"},
	{ID_ATTUNE="361",ID="623",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="622",STAGE="50"},
	{ID_ATTUNE="361",ID="523",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5781",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="522",STAGE="50"}, -- quest: Of Forgotten Memories
	{ID_ATTUNE="361",ID="423",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5213",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="422",STAGE="50"}, -- quest: The Active Agent
	{ID_ATTUNE="361",ID="324",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5262",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="323",STAGE="50"}, -- quest: The Truth Comes Crashing Down
	{ID_ATTUNE="361",ID="223",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5462",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="222",STAGE="50"}, -- quest: The Dying, Ras Frostwhisper
	{ID_ATTUNE="361",ID="123",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6135",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="121",STAGE="50"}, -- quest: Duskwing, Oh How I Hate Thee...
    {ID_ATTUNE="361",ID="117",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="361",ID="116",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6136",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="121",STAGE="50"}, -- quest: The Corpulent One
	-- {ID_ATTUNE="361",ID="153",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="361",ID="724",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="723",STAGE="60"},
	{ID_ATTUNE="361",ID="826",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="825",STAGE="60"},
	{ID_ATTUNE="361",ID="624",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="623",STAGE="60"},
	{ID_ATTUNE="361",ID="524",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5845",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="523",STAGE="60"}, -- quest: Of Lost Honor
	{ID_ATTUNE="361",ID="424",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13176",ICON="Interface\\Icons\\inv_misc_rune_07",FOLLOWS="423",STAGE="60"}, -- item: Scourge Data
	{ID_ATTUNE="361",ID="325",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5263",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="324",STAGE="60"}, -- quest: Above and Beyond
	{ID_ATTUNE="361",ID="225",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5463",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="223",STAGE="60"}, -- quest: Menethil's Gift
	{ID_ATTUNE="361",ID="154",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="361",ID="124",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="6144",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="123&116",STAGE="60"}, -- quest: The Call to Command
    {ID_ATTUNE="361",ID="115",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="361",ID="725",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="724",STAGE="70"},
	{ID_ATTUNE="361",ID="827",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="826",STAGE="70"},
	{ID_ATTUNE="361",ID="625",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="624",STAGE="70"},
	{ID_ATTUNE="361",ID="525",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="14625",ICON="Interface\\Icons\\inv_banner_02",FOLLOWS="524",STAGE="70"}, -- item: Symbol of Lost Honor
	{ID_ATTUNE="361",ID="425",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5213",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="424",STAGE="70"}, -- quest: The Active Agent
	{ID_ATTUNE="361",ID="327",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="13251",ICON="Interface\\Icons\\spell_shadow_charm",FOLLOWS="325",STAGE="70"}, -- item: Head of Baron Rivendare
	{ID_ATTUNE="361",ID="226",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="5463",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="225",STAGE="70"}, -- quest: Menethil's Gift
	{ID_ATTUNE="361",ID="155",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="361",ID="126",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6163",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="124",STAGE="70"}, -- quest: Ramstein
    {ID_ATTUNE="361",ID="114",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="361",ID="726",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="725",STAGE="80"},
	{ID_ATTUNE="361",ID="828",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="827",STAGE="80"},
	{ID_ATTUNE="361",ID="626",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="625",STAGE="80"},
	{ID_ATTUNE="361",ID="526",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5845",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="525",STAGE="80"}, -- quest: Of Lost Honor
	{ID_ATTUNE="361",ID="426",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="425",STAGE="80"},
	{ID_ATTUNE="361",ID="328",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5263",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="327",STAGE="80"}, -- quest: Above and Beyond
	{ID_ATTUNE="361",ID="227",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="226",STAGE="80"},
	{ID_ATTUNE="361",ID="156",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="361",ID="128",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="15880",ICON="Interface\\Icons\\inv_misc_head_elf_01",FOLLOWS="126",STAGE="80"}, -- item: Head of Ramstein the Gorger
    {ID_ATTUNE="361",ID="113",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="361",ID="727",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="726",STAGE="90"},
	{ID_ATTUNE="361",ID="829",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="828",STAGE="90"},
	{ID_ATTUNE="361",ID="627",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="626",STAGE="90"},
	{ID_ATTUNE="361",ID="527",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5846",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="526",STAGE="90"}, -- quest: Of Love and Family
	{ID_ATTUNE="361",ID="427",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="426",STAGE="90"},
	{ID_ATTUNE="361",ID="329",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="328",STAGE="90"},
	{ID_ATTUNE="361",ID="228",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="227",STAGE="90"},
	{ID_ATTUNE="361",ID="157",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	{ID_ATTUNE="361",ID="129",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="6163",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="128",STAGE="90"}, -- quest: Ramstein
    {ID_ATTUNE="361",ID="112",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	-- STAGE 100
	{ID_ATTUNE="361",ID="728",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="727",STAGE="100"},
	{ID_ATTUNE="361",ID="830",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="829",STAGE="100"},
	{ID_ATTUNE="361",ID="628",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="627",STAGE="100"},
	{ID_ATTUNE="361",ID="529",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5848",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="527",STAGE="100"}, -- quest: Of Love and Family
	{ID_ATTUNE="361",ID="428",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="427",STAGE="100"},
	{ID_ATTUNE="361",ID="330",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="329",STAGE="100"},
	{ID_ATTUNE="361",ID="229",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="228",STAGE="100"},
	{ID_ATTUNE="361",ID="158",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="100"},
	{ID_ATTUNE="361",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="129",STAGE="100"},
    {ID_ATTUNE="361",ID="111",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="100"},
	-- STAGE 110
	{ID_ATTUNE="361",ID="729",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="728",STAGE="110"},
	{ID_ATTUNE="361",ID="832",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="830",STAGE="110"},
	{ID_ATTUNE="361",ID="629",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="628",STAGE="110"},
	{ID_ATTUNE="361",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="14679",ICON="Interface\\Icons\\inv_scroll_06",FOLLOWS="529",STAGE="110"}, -- item: Of Love and Family
	{ID_ATTUNE="361",ID="429",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="428",STAGE="110"},
	{ID_ATTUNE="361",ID="331",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="330",STAGE="110"},
	{ID_ATTUNE="361",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="229",STAGE="110"},
	{ID_ATTUNE="361",ID="159",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="110"},
	{ID_ATTUNE="361",ID="131",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="110"},
    {ID_ATTUNE="361",ID="109",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="110"},
	-- STAGE 120
	{ID_ATTUNE="361",ID="730",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="729",STAGE="120"},
	{ID_ATTUNE="361",ID="833",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="832",STAGE="120"},
	{ID_ATTUNE="361",ID="630",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="629",STAGE="120"},
	{ID_ATTUNE="361",ID="531",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5848",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="120"}, -- quest: Of Love and Family
	{ID_ATTUNE="361",ID="430",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="429",STAGE="120"},
	{ID_ATTUNE="361",ID="332",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="331",STAGE="120"},
	{ID_ATTUNE="361",ID="232",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="230",STAGE="120"},
	{ID_ATTUNE="361",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="120"},
	{ID_ATTUNE="361",ID="132",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="131",STAGE="120"},
    {ID_ATTUNE="361",ID="108",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="120"},
	{ID_ATTUNE="361",ID="1400",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stratholme"],ID_WOWHEAD="5125",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="130",SIDE=true}, -- quest: Aurius' Reckoning (Inside)
	{ID_ATTUNE="361",ID="1401",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_bone_skull_02",FOLLOWS="730&833&630&531&430&332&232&132&1400",STAGE="130"},

--vForever dungeon attune 370
	-- Columns L→R: 1475 Tablets | 1446 Jammal'an | 3520→3528 Hakkar (longest) | 3445→3446 Sunken Temple | 3447 Circle
	-- SIDE: 3373 Essence of Eranikus (Inside)
	{ID_ATTUNE="370",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 38",LOCATION="",ID_WOWHEAD="38",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="370",ID="900",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1475",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Into The Temple of Atal'Hakkar
	{ID_ATTUNE="370",ID="700",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="1446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Jammal'an the Prophet
	{ID_ATTUNE="370",ID="500",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="3520",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Screecher Spirits
	{ID_ATTUNE="370",ID="300",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3445",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Sunken Temple
	{ID_ATTUNE="370",ID="100",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	-- STAGE 30
	{ID_ATTUNE="370",ID="910",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="6288",ICON="Interface\\Icons\\inv_misc_stonetablet_04",FOLLOWS="900",STAGE="30",COUNT=10}, -- item: Atal'ai Tablet
	{ID_ATTUNE="370",ID="710",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="6212",ICON="Interface\\Icons\\inv_misc_head_troll_01",FOLLOWS="700",STAGE="30"}, -- item: Head of Jammal'an
	{ID_ATTUNE="370",ID="510",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="500",STAGE="30"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="370",ID="310",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="3444",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="300",STAGE="30"}, -- quest: The Stone Circle
	{ID_ATTUNE="370",ID="110",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	-- STAGE 40
	{ID_ATTUNE="370",ID="920",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1475",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="910",STAGE="40"}, -- quest: Into The Temple of Atal'Hakkar
	{ID_ATTUNE="370",ID="720",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="1446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="710",STAGE="40"}, -- quest: Jammal'an the Prophet
	{ID_ATTUNE="370",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4787",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="510",STAGE="40"}, -- quest: The Ancient Egg
	{ID_ATTUNE="370",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="310",STAGE="40"}, -- quest: Into the Depths
	{ID_ATTUNE="370",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3447",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="310",STAGE="40"}, -- quest: Secret of the Circle
	-- STAGE 50
	{ID_ATTUNE="370",ID="930",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="920",STAGE="50"},
	{ID_ATTUNE="370",ID="730",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="720",STAGE="50"},
	{ID_ATTUNE="370",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="12402",ICON="Interface\\Icons\\inv_egg_03",FOLLOWS="520",STAGE="50"}, -- item: Ancient Egg
	{ID_ATTUNE="370",ID="330",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="50"}, -- quest: Into the Depths
	{ID_ATTUNE="370",ID="130",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3447",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="50"}, -- quest: Secret of the Circle
	-- STAGE 60
	{ID_ATTUNE="370",ID="940",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="930",STAGE="60"},
	{ID_ATTUNE="370",ID="740",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="730",STAGE="60"},
	{ID_ATTUNE="370",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4787",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="60"}, -- quest: The Ancient Egg
	{ID_ATTUNE="370",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="330",STAGE="60"},
	{ID_ATTUNE="370",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="370",ID="950",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="940",STAGE="70"},
	{ID_ATTUNE="370",ID="750",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="70"},
	{ID_ATTUNE="370",ID="550",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3528",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="540",STAGE="70"}, -- quest: The God Hakkar
	{ID_ATTUNE="370",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="70"},
	{ID_ATTUNE="370",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="370",ID="960",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="950",STAGE="80"},
	{ID_ATTUNE="370",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="80"},
	{ID_ATTUNE="370",ID="560",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="10662",ICON="Interface\\Icons\\inv_egg_05",FOLLOWS="550",STAGE="80"}, -- item: Filled Egg of Hakkar
	{ID_ATTUNE="370",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="80"},
	{ID_ATTUNE="370",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="370",ID="970",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="960",STAGE="90"},
	{ID_ATTUNE="370",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="760",STAGE="90"},
	{ID_ATTUNE="370",ID="570",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3528",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="560",STAGE="90"}, -- quest: The God Hakkar
	{ID_ATTUNE="370",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="90"},
	{ID_ATTUNE="370",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="90"},
	-- SIDE (inside dungeon)
	{ID_ATTUNE="370",ID="1100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3373",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: The Essence of Eranikus (Inside)
	{ID_ATTUNE="370",ID="1200",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="970&770&570&370&170&1100",STAGE="100"},

--vForever dungeon attune 380
	-- Columns L→R: 1446 Jammal'an | 1424→1445 Temple (long) | 3520→3528 Hakkar (longest) | 3380→3446 Sunken Temple | 3447 Circle
	-- SIDE: 3373 Essence of Eranikus (Inside)
	{ID_ATTUNE="380",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 38",LOCATION="",ID_WOWHEAD="38",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="380",ID="900",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="1446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Jammal'an the Prophet
	{ID_ATTUNE="380",ID="700",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="1424",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Pool of Tears
	{ID_ATTUNE="380",ID="500",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="3520",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Screecher Spirits
	{ID_ATTUNE="380",ID="300",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3380",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Sunken Temple
	{ID_ATTUNE="380",ID="100",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	-- STAGE 30
	{ID_ATTUNE="380",ID="910",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="6212",ICON="Interface\\Icons\\inv_misc_head_troll_01",FOLLOWS="900",STAGE="30"}, -- item: Head of Jammal'an
	{ID_ATTUNE="380",ID="710",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="6175",ICON="Interface\\Icons\\inv_misc_idol_03",FOLLOWS="700",STAGE="30",COUNT=10}, -- item: Atal'ai Artifact
	{ID_ATTUNE="380",ID="510",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="500",STAGE="30"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="380",ID="310",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="3444",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="300",STAGE="30"}, -- quest: The Stone Circle
	{ID_ATTUNE="380",ID="110",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	-- STAGE 40
	{ID_ATTUNE="380",ID="920",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="1446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="910",STAGE="40"}, -- quest: Jammal'an the Prophet
	{ID_ATTUNE="380",ID="720",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="1424",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="710",STAGE="40"}, -- quest: Pool of Tears
	{ID_ATTUNE="380",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4787",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="510",STAGE="40"}, -- quest: The Ancient Egg
	{ID_ATTUNE="380",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="310",STAGE="40"}, -- quest: Into the Depths
	{ID_ATTUNE="380",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3447",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="310",STAGE="40"}, -- quest: Secret of the Circle
	-- STAGE 50
	{ID_ATTUNE="380",ID="930",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="920",STAGE="50"},
	{ID_ATTUNE="380",ID="730",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="1429",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="720",STAGE="50"}, -- quest: The Atal'ai Exile
	{ID_ATTUNE="380",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="12402",ICON="Interface\\Icons\\inv_egg_03",FOLLOWS="520",STAGE="50"}, -- item: Ancient Egg
	{ID_ATTUNE="380",ID="330",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3446",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="50"}, -- quest: Into the Depths
	{ID_ATTUNE="380",ID="130",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3447",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="50"}, -- quest: Secret of the Circle
	-- STAGE 60
	{ID_ATTUNE="380",ID="940",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="930",STAGE="60"},
	{ID_ATTUNE="380",ID="740",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="1444",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="60"}, -- quest: Return to Fel'Zerul
	{ID_ATTUNE="380",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4787",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="60"}, -- quest: The Ancient Egg
	{ID_ATTUNE="380",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="330",STAGE="60"},
	{ID_ATTUNE="380",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="380",ID="950",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="940",STAGE="70"},
	{ID_ATTUNE="380",ID="750",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="1445",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="740",STAGE="70"}, -- quest: The Temple of Atal'Hakkar
	{ID_ATTUNE="380",ID="550",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3528",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="540",STAGE="70"}, -- quest: The God Hakkar
	{ID_ATTUNE="380",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="70"},
	{ID_ATTUNE="380",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="380",ID="960",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="950",STAGE="80"},
	{ID_ATTUNE="380",ID="760",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="6181",ICON="Interface\\Icons\\inv_misc_bone_humanskull_01",FOLLOWS="750",STAGE="80",COUNT=20}, -- item: Fetish of Hakkar
	{ID_ATTUNE="380",ID="560",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="10662",ICON="Interface\\Icons\\inv_egg_05",FOLLOWS="550",STAGE="80"}, -- item: Filled Egg of Hakkar
	{ID_ATTUNE="380",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="80"},
	{ID_ATTUNE="380",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="380",ID="970",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="960",STAGE="90"},
	{ID_ATTUNE="380",ID="770",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="1445",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="760",STAGE="90"}, -- quest: The Temple of Atal'Hakkar
	{ID_ATTUNE="380",ID="570",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3528",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="560",STAGE="90"}, -- quest: The God Hakkar
	{ID_ATTUNE="380",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="90"},
	{ID_ATTUNE="380",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="90"},
	-- SIDE (inside dungeon)
	{ID_ATTUNE="380",ID="1100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3373",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: The Essence of Eranikus (Inside)
	{ID_ATTUNE="380",ID="1200",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="970&770&570&370&170&1100",STAGE="100"},

--vForever dungeon attune 390
	-- Columns L→R: 20 Molten Core | 4262→4263 Incendius | 4123 Heart | 3911 Last Element | 4022→4024 Taste of Flame | 3702→4363 Kharan/Princess | 4182→4241 Windsor | 4128→4126 Thunderbrew | 4136 Ribbly | 4286 Fanny Packs | 120 Shadowforge Key
	{ID_ATTUNE="390",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 48",LOCATION="",ID_WOWHEAD="48",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="390",ID="1020",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4123",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Heart of the Mountain
	{ID_ATTUNE="390",ID="920",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="3911",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Last Element
	{ID_ATTUNE="390",ID="820",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4022",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Taste of Flame
	{ID_ATTUNE="390",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="3702",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Smoldering Ruins of Thaurissan
	{ID_ATTUNE="390",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4182",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Dragonkin Menace
	{ID_ATTUNE="390",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blasted Lands"],ID_WOWHEAD="4128",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Ragnar Thunderbrew
	{ID_ATTUNE="390",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4136",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Ribbly Screwspigot
	{ID_ATTUNE="390",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4286",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Good Stuff
	{ID_ATTUNE="390",ID="1220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="4262",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Overmaster Pyron
	-- STAGE 30
	{ID_ATTUNE="390",ID="1030",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11309",ICON="Interface\\Icons\\inv_misc_gem_bloodstone_02",FOLLOWS="1020",STAGE="30"}, -- item: The Heart of the Mountain
	{ID_ATTUNE="390",ID="930",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11129",ICON="Interface\\Icons\\inv_enchant_shardglowinglarge",FOLLOWS="920",STAGE="30",COUNT=10}, -- item: Essence of the Elements
	{ID_ATTUNE="390",ID="830",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4024",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="820",STAGE="30"}, -- quest: A Taste of Flame
	{ID_ATTUNE="390",ID="730",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="3701",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="720",STAGE="30"}, -- quest: The Smoldering Ruins of Thaurissan
	{ID_ATTUNE="390",ID="530",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4183",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: The True Masters
	{ID_ATTUNE="390",ID="430",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="4126",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Hurley Blackbreath
	{ID_ATTUNE="390",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11313",ICON="Interface\\Icons\\inv_misc_head_orc_01",FOLLOWS="320",STAGE="30"}, -- item: Ribbly's Head
	{ID_ATTUNE="390",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11468",ICON="Interface\\Icons\\inv_misc_bag_09",FOLLOWS="220",STAGE="30",COUNT=20}, -- item: Dark Iron Fanny Pack
	{ID_ATTUNE="390",ID="1230",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4263",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="1220",STAGE="30"}, -- quest: Incendius!
	-- STAGE 40
	{ID_ATTUNE="390",ID="1040",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4123",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="1030",STAGE="40"}, -- quest: The Heart of the Mountain
	{ID_ATTUNE="390",ID="940",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="3911",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="930",STAGE="40"}, -- quest: The Last Element
	{ID_ATTUNE="390",ID="840",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11230",ICON="Interface\\Icons\\spell_fire_sealoffire",FOLLOWS="830",STAGE="40"}, -- item: Encased Fiery Essence
	{ID_ATTUNE="390",ID="740",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4341",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="40"}, -- quest: Kharan Mighthammer
	{ID_ATTUNE="390",ID="540",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="4184",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: The True Masters
	{ID_ATTUNE="390",ID="440",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11312",ICON="Interface\\Icons\\inv_misc_note_03",FOLLOWS="430",STAGE="40"}, -- item: Lost Thunderbrew Recipe
	{ID_ATTUNE="390",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4136",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: Ribbly Screwspigot
	{ID_ATTUNE="390",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4286",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: The Good Stuff
	{ID_ATTUNE="390",ID="1240",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1230",STAGE="40"},
	-- STAGE 50
	{ID_ATTUNE="390",ID="1050",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1040",STAGE="50"},
	{ID_ATTUNE="390",ID="950",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="940",STAGE="50"},
	{ID_ATTUNE="390",ID="850",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4024",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="840",STAGE="50"}, -- quest: A Taste of Flame
	{ID_ATTUNE="390",ID="750",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4342",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="740",STAGE="50"}, -- quest: Kharan's Tale
	{ID_ATTUNE="390",ID="550",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="4185",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="540",STAGE="50"}, -- quest: The True Masters
	{ID_ATTUNE="390",ID="450",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="4126",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440",STAGE="50"}, -- quest: Hurley Blackbreath
	{ID_ATTUNE="390",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="390",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	{ID_ATTUNE="390",ID="1250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1240",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="390",ID="1060",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1050",STAGE="60"},
	{ID_ATTUNE="390",ID="960",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="950",STAGE="60"},
	{ID_ATTUNE="390",ID="860",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="850",STAGE="60"},
	{ID_ATTUNE="390",ID="760",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="4361",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="750",STAGE="60"}, -- quest: The Bearer of Bad News
	{ID_ATTUNE="390",ID="560",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="4186",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="550",STAGE="60"}, -- quest: The True Masters
	{ID_ATTUNE="390",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
	{ID_ATTUNE="390",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="390",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="390",ID="1260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1250",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="390",ID="1070",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1060",STAGE="70"},
	{ID_ATTUNE="390",ID="970",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="960",STAGE="70"},
	{ID_ATTUNE="390",ID="870",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="860",STAGE="70"},
	{ID_ATTUNE="390",ID="770",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4362",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="760",STAGE="70"}, -- quest: The Fate of the Kingdom
	{ID_ATTUNE="390",ID="570",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="4223",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="560",STAGE="70"}, -- quest: The True Masters
	{ID_ATTUNE="390",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="460",STAGE="70"},
	{ID_ATTUNE="390",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="70"},
	{ID_ATTUNE="390",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="260",STAGE="70"},
	{ID_ATTUNE="390",ID="1270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1260",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="390",ID="1080",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1070",STAGE="80"},
	{ID_ATTUNE="390",ID="980",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="970",STAGE="80"},
	{ID_ATTUNE="390",ID="880",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="870",STAGE="80"},
	{ID_ATTUNE="390",ID="780",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="4363",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="770",STAGE="80"}, -- quest: The Princess's Surprise
	{ID_ATTUNE="390",ID="580",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4224",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="570",STAGE="80"}, -- quest: The True Masters
	{ID_ATTUNE="390",ID="480",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="470",STAGE="80"},
	{ID_ATTUNE="390",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="80"},
	{ID_ATTUNE="390",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="270",STAGE="80"},
	{ID_ATTUNE="390",ID="1280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1270",STAGE="80"},
	-- STAGE 90
	{ID_ATTUNE="390",ID="1090",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1080",STAGE="90"},
	{ID_ATTUNE="390",ID="990",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="980",STAGE="90"},
	{ID_ATTUNE="390",ID="890",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="880",STAGE="90"},
	{ID_ATTUNE="390",ID="790",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="780",STAGE="90"},
	{ID_ATTUNE="390",ID="590",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4241",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="580",STAGE="90"}, -- quest: Marshal Windsor
	{ID_ATTUNE="390",ID="490",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="480",STAGE="90"},
	{ID_ATTUNE="390",ID="390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="380",STAGE="90"},
	{ID_ATTUNE="390",ID="290",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="280",STAGE="90"},
	{ID_ATTUNE="390",ID="1290",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1280",STAGE="90"},
	-- STAGE 20 attunes (standalone)
	{ID_ATTUNE="390",ID="1320",TYPE="FTAttune",STEP=FTAttuneLang["Molten Core"],LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\inv_hammer_unique_sulfuras",FOLLOWS="10",STAGE="20"},
	{ID_ATTUNE="390",ID="120",TYPE="FTAttune",STEP=FTAttuneLang["Blackrock Depths"],LOCATION="",ID_WOWHEAD="120",ICON="Interface\\Icons\\inv_misc_key_08",FOLLOWS="10",STAGE="20"},
	{ID_ATTUNE="390",ID="1330",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1320",STAGE="30"},
	{ID_ATTUNE="390",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="30"},
	{ID_ATTUNE="390",ID="1340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1330",STAGE="40"},
	{ID_ATTUNE="390",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},
	{ID_ATTUNE="390",ID="1350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1340",STAGE="50"},
	{ID_ATTUNE="390",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	{ID_ATTUNE="390",ID="1360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1350",STAGE="60"},
	{ID_ATTUNE="390",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	{ID_ATTUNE="390",ID="1370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1360",STAGE="70"},
	{ID_ATTUNE="390",ID="170",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="70"},
	{ID_ATTUNE="390",ID="1380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1370",STAGE="80"},
	{ID_ATTUNE="390",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="170",STAGE="80"},
	{ID_ATTUNE="390",ID="1390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1380",STAGE="90"},
	{ID_ATTUNE="390",ID="190",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="180",STAGE="90"},
	-- SIDE (inside dungeon)
	{ID_ATTUNE="390",ID="1120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4201",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: The Love Potion (Inside)
	{ID_ATTUNE="390",ID="1110",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4242",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: Abandoned Hope (Inside)
	{ID_ATTUNE="390",ID="1100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4264",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: A Crumpled Up Note (Inside)
	{ID_ATTUNE="390",ID="1300",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="1390&1290&1090&990&890&790&590&490&390&290&190&1120&1110&1100",STAGE="100"},

--vForever dungeon attune 400
	-- Columns L→R: 20 Molten Core | 4081→4082 KOS | 7201 Last Element | 4022→4024 Taste of Flame | 4063 Argelmach | 3906→4004 Royal Rescue (longest) | 4136 Ribbly | 4134 Recipe | 4123 Heart | 120 Shadowforge Key
	{ID_ATTUNE="400",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 48",LOCATION="",ID_WOWHEAD="48",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="400",ID="1020",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="7201",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Last Element
	{ID_ATTUNE="400",ID="920",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4022",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: A Taste of Flame
	{ID_ATTUNE="400",ID="820",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4063",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Rise of the Machines
	{ID_ATTUNE="400",ID="320",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4123",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Heart of the Mountain
	{ID_ATTUNE="400",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4136",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Ribbly Screwspigot
	{ID_ATTUNE="400",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4134",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Lost Thunderbrew Recipe
	{ID_ATTUNE="400",ID="1220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4081",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: KILL ON SIGHT: Dark Iron Dwarves
	{ID_ATTUNE="400",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="3906",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Disharmony of Flame
	-- STAGE 30
	{ID_ATTUNE="400",ID="1030",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11129",ICON="Interface\\Icons\\inv_enchant_shardglowinglarge",FOLLOWS="1020",STAGE="30",COUNT=10}, -- item: Essence of the Elements
	{ID_ATTUNE="400",ID="930",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4024",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="920",STAGE="30"}, -- quest: A Taste of Flame
	{ID_ATTUNE="400",ID="830",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11268",ICON="Interface\\Icons\\inv_misc_head_dwarf_01",FOLLOWS="820",STAGE="30"}, -- item: Elemental Shard / Argelmach's Head
	{ID_ATTUNE="400",ID="330",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11309",ICON="Interface\\Icons\\inv_misc_gem_bloodstone_02",FOLLOWS="320",STAGE="30"}, -- item: The Heart of the Mountain
	{ID_ATTUNE="400",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11313",ICON="Interface\\Icons\\inv_misc_head_orc_01",FOLLOWS="520",STAGE="30"}, -- item: Ribbly's Head
	{ID_ATTUNE="400",ID="430",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11312",ICON="Interface\\Icons\\inv_misc_note_03",FOLLOWS="420",STAGE="30"}, -- item: Lost Thunderbrew Recipe
	{ID_ATTUNE="400",ID="1230",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4082",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="1220",STAGE="30"}, -- quest: KILL ON SIGHT: High Ranking Dark Iron Officials
	{ID_ATTUNE="400",ID="630",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="3907",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: Disharmony of Fire
	-- STAGE 40
	{ID_ATTUNE="400",ID="1040",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="7201",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="1030",STAGE="40"}, -- quest: The Last Element
	{ID_ATTUNE="400",ID="940",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11230",ICON="Interface\\Icons\\spell_fire_sealoffire",FOLLOWS="930",STAGE="40"}, -- item: Encased Fiery Essence
	{ID_ATTUNE="400",ID="840",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="11269",ICON="Interface\\Icons\\inv_misc_gem_opal_01",FOLLOWS="830",STAGE="40",COUNT=10}, -- item: Intact Elemental Core
	{ID_ATTUNE="400",ID="340",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4123",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="330",STAGE="40"}, -- quest: The Heart of the Mountain
	{ID_ATTUNE="400",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4136",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: Ribbly Screwspigot
	{ID_ATTUNE="400",ID="440",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4134",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="40"}, -- quest: Lost Thunderbrew Recipe
    {ID_ATTUNE="400",ID="1240",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1230",STAGE="40"},
	{ID_ATTUNE="400",ID="640",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="3981",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="40"}, -- quest: Commander Gor'shak
	-- STAGE 50
	{ID_ATTUNE="400",ID="1050",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1040",STAGE="50"},
	{ID_ATTUNE="400",ID="950",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4024",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="940",STAGE="50"}, -- quest: A Taste of Flame
	{ID_ATTUNE="400",ID="850",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4063",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="840",STAGE="50"}, -- quest: The Rise of the Machines
	{ID_ATTUNE="400",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	{ID_ATTUNE="400",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="400",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="50"},
	{ID_ATTUNE="400",ID="1250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1240",STAGE="50"},
	{ID_ATTUNE="400",ID="650",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4001",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="640",STAGE="50"}, -- quest: What Is Going On?
	-- STAGE 60
	{ID_ATTUNE="400",ID="1060",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1050",STAGE="60"},
	{ID_ATTUNE="400",ID="960",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="950",STAGE="60"},
	{ID_ATTUNE="400",ID="860",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="850",STAGE="60"},
	{ID_ATTUNE="400",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	{ID_ATTUNE="400",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="400",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
	{ID_ATTUNE="400",ID="1260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1250",STAGE="60"},
	{ID_ATTUNE="400",ID="660",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="4002",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="650",STAGE="60"}, -- quest: The Eastern Kingdoms
	-- STAGE 70
	{ID_ATTUNE="400",ID="1070",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1060",STAGE="70"},
	{ID_ATTUNE="400",ID="970",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="960",STAGE="70"},
	{ID_ATTUNE="400",ID="870",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="860",STAGE="70"},
	{ID_ATTUNE="400",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="70"},
	{ID_ATTUNE="400",ID="570",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="560",STAGE="70"},
	{ID_ATTUNE="400",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="460",STAGE="70"},
	{ID_ATTUNE="400",ID="1270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1260",STAGE="70"},
	{ID_ATTUNE="400",ID="670",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4003",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="660",STAGE="70"}, -- quest: The Royal Rescue
	-- STAGE 80
	{ID_ATTUNE="400",ID="1080",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1070",STAGE="80"},
	{ID_ATTUNE="400",ID="980",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="970",STAGE="80"},
	{ID_ATTUNE="400",ID="880",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="870",STAGE="80"},
	{ID_ATTUNE="400",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="80"},
	{ID_ATTUNE="400",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="570",STAGE="80"},
	{ID_ATTUNE="400",ID="480",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="470",STAGE="80"},
	{ID_ATTUNE="400",ID="1280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1270",STAGE="80"},
	{ID_ATTUNE="400",ID="680",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="4004",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="670",STAGE="80"}, -- quest: The Princess Saved?
	-- STAGE 90
	{ID_ATTUNE="400",ID="1090",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1080",STAGE="90"},
	{ID_ATTUNE="400",ID="990",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="980",STAGE="90"},
	{ID_ATTUNE="400",ID="890",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="880",STAGE="90"},
	{ID_ATTUNE="400",ID="390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="380",STAGE="90"},
	{ID_ATTUNE="400",ID="590",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="580",STAGE="90"},
	{ID_ATTUNE="400",ID="490",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="480",STAGE="90"},
	{ID_ATTUNE="400",ID="1290",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1280",STAGE="90"},
	{ID_ATTUNE="400",ID="690",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="680",STAGE="90"},

    {ID_ATTUNE="400",ID="1320",TYPE="FTAttune",STEP=FTAttuneLang["Molten Core"],LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\inv_hammer_unique_sulfuras",FOLLOWS="10",STAGE="20"},
	{ID_ATTUNE="400",ID="220",TYPE="FTAttune",STEP=FTAttuneLang["Blackrock Depths"],LOCATION="",ID_WOWHEAD="120",ICON="Interface\\Icons\\inv_misc_key_08",FOLLOWS="10",STAGE="20"},
	{ID_ATTUNE="400",ID="1330",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1320",STAGE="30"},
	{ID_ATTUNE="400",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="220",STAGE="30"},
	{ID_ATTUNE="400",ID="1340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1330",STAGE="40"},
	{ID_ATTUNE="400",ID="240",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="230",STAGE="40"},
	{ID_ATTUNE="400",ID="1350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1340",STAGE="50"},
	{ID_ATTUNE="400",ID="250",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="240",STAGE="50"},
	{ID_ATTUNE="400",ID="1360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1350",STAGE="60"},
	{ID_ATTUNE="400",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="400",ID="1370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1360",STAGE="70"},
	{ID_ATTUNE="400",ID="270",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="260",STAGE="70"},
	{ID_ATTUNE="400",ID="1380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1370",STAGE="80"},
	{ID_ATTUNE="400",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="270",STAGE="80"},
	{ID_ATTUNE="400",ID="1390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="1380",STAGE="90"},
	{ID_ATTUNE="400",ID="290",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="280",STAGE="90"},
    
	{ID_ATTUNE="400",ID="1400",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blackrock Depths"],ID_WOWHEAD="4201",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: The Love Potion (Inside)
	{ID_ATTUNE="400",ID="1100",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="1390&1290&1090&990&890&690&590&490&390&290&1400",STAGE="100"},

--vForever dungeon attune 410
	-- Columns L→R: 5522→5531→4771 Dawn's Gambit | 5466 Ras | 5382→5384 Krastinov | blank | 5343→5344 Barov | blank | 5529 Hatchlings
	-- Stage 35 is only the four Barov deeds, with a blank column on each side
	{ID_ATTUNE="410",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 52",LOCATION="",ID_WOWHEAD="52",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="410",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5522",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Leonid Barthalomew
	{ID_ATTUNE="410",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5466",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Lich, Ras Frostwhisper
	{ID_ATTUNE="410",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5382",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Doctor Theolen Krastinov, the Butcher
	{ID_ATTUNE="410",ID="310",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="410",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5343",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Barov Family Fortune
	{ID_ATTUNE="410",ID="210",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="410",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5529",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Plagued Hatchlings
	-- STAGE 30
	{ID_ATTUNE="410",ID="530",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5531",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Betina Bigglezink
	{ID_ATTUNE="410",ID="430",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13626",ICON="Interface\\Icons\\inv_misc_head_scourge_01",FOLLOWS="420",STAGE="30"}, -- item: Human Head of Ras Frostwhisper
	{ID_ATTUNE="410",ID="330",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5515",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: Krastinov's Bag of Horrors
    {ID_ATTUNE="410",ID="313",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
    {ID_ATTUNE="410",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="410",ID="213",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="410",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="30"},
    -- STAGE 32
    {ID_ATTUNE="410",ID="540",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="4771",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="32"}, -- quest: Dawn's Gambit
    {ID_ATTUNE="410",ID="440",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5466",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="32"}, -- quest: The Lich, Ras Frostwhisper
    {ID_ATTUNE="410",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13725",ICON="Interface\\Icons\\inv_misc_bag_07",FOLLOWS="330",STAGE="32"}, -- item: Krastinov's Bag of Horrors
    {ID_ATTUNE="410",ID="311",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="32"},
    {ID_ATTUNE="410",ID="229",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="220",STAGE="32"},
    {ID_ATTUNE="410",ID="211",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="32"},
    {ID_ATTUNE="410",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="32"},
    -- STAGE 35 (Barov deeds only)   
    {ID_ATTUNE="410",ID="512",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="35"},
    {ID_ATTUNE="410",ID="245",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="35"},
	{ID_ATTUNE="410",ID="234",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13448",ICON="Interface\\Icons\\inv_misc_note_05",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Caer Darrow
	{ID_ATTUNE="410",ID="233",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13471",ICON="Interface\\Icons\\inv_misc_note_02",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Brill
	{ID_ATTUNE="410",ID="232",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13451",ICON="Interface\\Icons\\inv_misc_note_01",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Tarren Mill
	{ID_ATTUNE="410",ID="231",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13450",ICON="Interface\\Icons\\inv_misc_note_06",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Southshore
	-- STAGE 40
    {ID_ATTUNE="410",ID="535",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="40"},
	{ID_ATTUNE="410",ID="435",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="40"},
	{ID_ATTUNE="410",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5515",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="40"}, -- quest: Krastinov's Bag of Horrors
	{ID_ATTUNE="410",ID="312",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="410",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5343",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="234&233&232&231",STAGE="40"}, -- quest: Barov Family Fortune
	{ID_ATTUNE="410",ID="212",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="410",ID="135",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},
	-- STAGE 50
    {ID_ATTUNE="410",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="535",STAGE="50"},
	{ID_ATTUNE="410",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="435",STAGE="50"},
    {ID_ATTUNE="410",ID="360",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="5384",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="350",STAGE="50"}, -- quest: Kirtonos the Herald
	{ID_ATTUNE="410",ID="314",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="410",ID="250",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5344",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: The Last Barov
	{ID_ATTUNE="410",ID="214",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="410",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="135",STAGE="50"},
    -- STAGE 60
    {ID_ATTUNE="410",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="410",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
    {ID_ATTUNE="410",ID="370",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="10506",ICON="Interface\\Icons\\ability_hunter_pet_bat",FOLLOWS="360",STAGE="60"}, -- npc: Kirtonos the Herald
	{ID_ATTUNE="410",ID="315",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="410",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="410",ID="215",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="410",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- STAGE 80
	{ID_ATTUNE="410",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="560",STAGE="80"},
    {ID_ATTUNE="410",ID="480",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="460",STAGE="80"},
	{ID_ATTUNE="410",ID="380",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5384",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="370",STAGE="80"}, -- quest: Kirtonos the Herald
	{ID_ATTUNE="410",ID="317",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="410",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="260",STAGE="80"},
	{ID_ATTUNE="410",ID="217",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="410",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="80"},

    {ID_ATTUNE="410",ID="490",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5582",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="90", SIDE=true}, -- quest: healthy-dragon-scale
	{ID_ATTUNE="410",ID="500",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="580&490&480&380&280&180",STAGE="90"},

--vForever dungeon attune 420
	-- Columns L→R: 5522→5531→4771 Dawn's Gambit | 5466 Ras | 5382→5384 Krastinov | blank | 5341→5342 Barov | blank | 5529 Hatchlings
	-- Stage 35 is only the four Barov deeds, with a blank column on each side
	{ID_ATTUNE="420",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 52",LOCATION="",ID_WOWHEAD="52",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="420",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5522",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Leonid Barthalomew
	{ID_ATTUNE="420",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5466",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Lich, Ras Frostwhisper
	{ID_ATTUNE="420",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5382",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Doctor Theolen Krastinov, the Butcher
	{ID_ATTUNE="420",ID="310",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="420",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5341",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Barov Family Fortune
	{ID_ATTUNE="420",ID="210",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="420",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5529",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Plagued Hatchlings
	-- STAGE 30
	{ID_ATTUNE="420",ID="530",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5531",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Betina Bigglezink
	{ID_ATTUNE="420",ID="430",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13626",ICON="Interface\\Icons\\inv_misc_head_scourge_01",FOLLOWS="420",STAGE="30"}, -- item: Human Head of Ras Frostwhisper
	{ID_ATTUNE="420",ID="330",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5515",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: Krastinov's Bag of Horrors
    {ID_ATTUNE="420",ID="313",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
    {ID_ATTUNE="420",ID="230",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="420",ID="213",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="420",ID="140",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="120",STAGE="30"},
    -- STAGE 32
    {ID_ATTUNE="420",ID="540",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="4771",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="32"}, -- quest: Dawn's Gambit
    {ID_ATTUNE="420",ID="440",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5466",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="32"}, -- quest: The Lich, Ras Frostwhisper
    {ID_ATTUNE="420",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13725",ICON="Interface\\Icons\\inv_misc_bag_07",FOLLOWS="330",STAGE="32"}, -- item: Krastinov's Bag of Horrors
    {ID_ATTUNE="420",ID="311",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="32"},
    {ID_ATTUNE="420",ID="229",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="220",STAGE="32"},
    {ID_ATTUNE="420",ID="211",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="32"},
    {ID_ATTUNE="420",ID="130",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="32"},
    -- STAGE 35 (Barov deeds only)   
    {ID_ATTUNE="420",ID="512",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="35"},
    {ID_ATTUNE="420",ID="245",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="35"},
	{ID_ATTUNE="420",ID="234",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13448",ICON="Interface\\Icons\\inv_misc_note_05",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Caer Darrow
	{ID_ATTUNE="420",ID="233",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13471",ICON="Interface\\Icons\\inv_misc_note_02",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Brill
	{ID_ATTUNE="420",ID="232",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13451",ICON="Interface\\Icons\\inv_misc_note_01",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Tarren Mill
	{ID_ATTUNE="420",ID="231",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="13450",ICON="Interface\\Icons\\inv_misc_note_06",FOLLOWS="229",STAGE="35"}, -- item: The Deed to Southshore
	-- STAGE 40
    {ID_ATTUNE="420",ID="535",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="40"},
	{ID_ATTUNE="420",ID="435",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="40"},
	{ID_ATTUNE="420",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5515",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="40"}, -- quest: Krastinov's Bag of Horrors
	{ID_ATTUNE="420",ID="312",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="420",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5341",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="234&233&232&231",STAGE="40"}, -- quest: Barov Family Fortune
	{ID_ATTUNE="420",ID="212",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="420",ID="135",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="130",STAGE="40"},
	-- STAGE 50
    {ID_ATTUNE="420",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="535",STAGE="50"},
	{ID_ATTUNE="420",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="435",STAGE="50"},
    {ID_ATTUNE="420",ID="360",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="5384",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="350",STAGE="50"}, -- quest: Kirtonos the Herald
	{ID_ATTUNE="420",ID="314",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="420",ID="250",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5342",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: The Last Barov
	{ID_ATTUNE="420",ID="214",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="420",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="135",STAGE="50"},
    -- STAGE 60
    {ID_ATTUNE="420",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="420",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
    {ID_ATTUNE="420",ID="370",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Scholomance"],ID_WOWHEAD="10506",ICON="Interface\\Icons\\ability_hunter_pet_bat",FOLLOWS="360",STAGE="60"}, -- npc: Kirtonos the Herald
	{ID_ATTUNE="420",ID="315",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="420",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="420",ID="215",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="420",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- STAGE 80
	{ID_ATTUNE="420",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="560",STAGE="80"},
    {ID_ATTUNE="420",ID="480",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="460",STAGE="80"},
	{ID_ATTUNE="420",ID="380",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5384",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="370",STAGE="80"}, -- quest: Kirtonos the Herald
	{ID_ATTUNE="420",ID="317",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="420",ID="280",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="260",STAGE="80"},
	{ID_ATTUNE="420",ID="217",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="420",ID="180",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="160",STAGE="80"},

    {ID_ATTUNE="420",ID="490",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="5582",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="90", SIDE=true}, -- quest: healthy-dragon-scale
	{ID_ATTUNE="420",ID="500",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="580&490&480&380&280&180",STAGE="90"},

--vForever dungeon attune 163 (Alliance Hall of Thanes)
	-- Columns L→R: 96394 Restless Dead | 96393 Durgen | 96403 Heirlooms
	-- SIDE (beside End): 96395 An Ancient Grudge, 98423 The Treaty of Understanding (Inside)
	{ID_ATTUNE="163",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="163",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="96394",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Restless Dead
	{ID_ATTUNE="163",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="96393",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Old Ironforge Incursion
	{ID_ATTUNE="163",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="96403",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Important Heirlooms
	-- STAGE 30
	{ID_ATTUNE="163",ID="330",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="320",STAGE="30"},
	{ID_ATTUNE="163",ID="230",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Hall of Thanes"],ID_WOWHEAD="274286",ICON="Interface\\Icons\\inv_misc_head_dwarf_01",FOLLOWS="220",STAGE="30"}, -- item: Durgen Dirgehammer's Head
	{ID_ATTUNE="163",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Hall of Thanes"],ID_WOWHEAD="274289",ICON="Interface\\Icons\\trade_archaeology_silverdoorknocker-of-female-dwarf",FOLLOWS="120",STAGE="30",COUNT=8}, -- item: Dwarven Heirloom
	-- STAGE 40
	{ID_ATTUNE="163",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="330",STAGE="40"},
	{ID_ATTUNE="163",ID="240",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="96393",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="230",STAGE="40"}, -- quest: Old Ironforge Incursion
	{ID_ATTUNE="163",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="96403",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Important Heirlooms
	-- SIDE reminders (inside dungeon) — left of End
	{ID_ATTUNE="163",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Hall of Thanes"],ID_WOWHEAD="96395",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="50",SIDE=true}, -- quest: An Ancient Grudge (Inside)
	{ID_ATTUNE="163",ID="410",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Hall of Thanes"],ID_WOWHEAD="98423",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="50",SIDE=true}, -- quest: The Treaty of Understanding (Inside — Reliquary of Kings vault)
	{ID_ATTUNE="163",ID="360",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="340&240&140&420&410",STAGE="60"},

--vForever dungeon attune 166 (Horde Hall of Thanes — no Alliance-only 96393/96394)
	-- Columns L→R: 96403 Heirlooms
	-- SIDE (beside End): 96395 An Ancient Grudge (Inside — Ghostly Attendant)
	{ID_ATTUNE="166",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="166",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="96403",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Important Heirlooms
	-- STAGE 30
	{ID_ATTUNE="166",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Hall of Thanes"],ID_WOWHEAD="274289",ICON="Interface\\Icons\\inv_misc_statue_07",FOLLOWS="120",STAGE="30",COUNT=8}, -- item: Dwarven Heirloom
	-- STAGE 40
	{ID_ATTUNE="166",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="96403",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Important Heirlooms
	-- SIDE reminder (inside dungeon) — left of End
	{ID_ATTUNE="166",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Hall of Thanes"],ID_WOWHEAD="96395",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="40",SIDE=true}, -- quest: An Ancient Grudge (Inside)
	{ID_ATTUNE="166",ID="150",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="140&220",STAGE="50"},



--vForever dungeon attune 195 (Alliance Excavation Site: Wetlands)
	-- Columns L→R: 95737→95647→95809 Thicket | 469→98815 Hides | Greenwarden→95646 Horrors (longest) | 95772→95795 Songblade
	-- SIDE (beside End): 95810 Lost Relic Carry (Inside — Titan Relic from Relic Guardian; Prehistoric Prism follows in-game)
	{ID_ATTUNE="195",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 24",LOCATION="",ID_WOWHEAD="24",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="195",ID="720",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="95737",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Seeking Caitlin (prereq)
	{ID_ATTUNE="195",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="469",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Daily Delivery
	{ID_ATTUNE="195",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="463",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Greenwarden
	{ID_ATTUNE="195",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="95772",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Songblade Search
	-- STAGE 30
	{ID_ATTUNE="195",ID="730",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="95647",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="720",STAGE="30"}, -- quest: Lost in the Thicket Things
	{ID_ATTUNE="195",ID="630",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="98815",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: Highland Hides
	{ID_ATTUNE="195",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="276",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: Tramping Paws
	{ID_ATTUNE="195",ID="330",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="95795",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: Fallen in the Fen
	-- STAGE 40
	{ID_ATTUNE="195",ID="740",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="95809",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="40"}, -- quest: Heartwoven
	{ID_ATTUNE="195",ID="640",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Excavation Site"],ID_WOWHEAD="284845",ICON="Interface\\Icons\\inv_misc_pelt_bear_ruin_05",FOLLOWS="630",STAGE="40",COUNT=4}, -- item: Thicket Raptor Hide
	{ID_ATTUNE="195",ID="440",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="277",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="40"}, -- quest: Fire Taboo
	{ID_ATTUNE="195",ID="340",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="330",STAGE="40"},
	-- STAGE 50
	{ID_ATTUNE="195",ID="750",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="50"},
	{ID_ATTUNE="195",ID="650",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="98815",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="640",STAGE="50"}, -- quest: Highland Hides
	{ID_ATTUNE="195",ID="450",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="275",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440",STAGE="50"}, -- quest: Blisters on The Land
	{ID_ATTUNE="195",ID="350",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="340",STAGE="50"},
	-- STAGE 60
	{ID_ATTUNE="195",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="60"},
	{ID_ATTUNE="195",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="650",STAGE="60"},
	{ID_ATTUNE="195",ID="460",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="95646",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="450",STAGE="60"}, -- quest: Horrors in the Highland
	{ID_ATTUNE="195",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="60"},
	-- STAGE 70
	{ID_ATTUNE="195",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="760",STAGE="70"},
	{ID_ATTUNE="195",ID="670",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="660",STAGE="70"},
	{ID_ATTUNE="195",ID="470",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Excavation Site"],ID_WOWHEAD="270180",ICON="Interface\\Icons\\inv_misc_herb_07",FOLLOWS="460",STAGE="70"}, -- item: Horrible Rootcore (Highland Horror)
	{ID_ATTUNE="195",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="70"},
	-- STAGE 80
	{ID_ATTUNE="195",ID="780",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="770",STAGE="80"},
	{ID_ATTUNE="195",ID="680",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="670",STAGE="80"},
	{ID_ATTUNE="195",ID="480",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="95646",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="470",STAGE="80"}, -- quest: Horrors in the Highland
	{ID_ATTUNE="195",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="80"},
	-- SIDE reminder (inside dungeon) — left of End
	{ID_ATTUNE="195",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Excavation Site"],ID_WOWHEAD="95810",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="80",SIDE=true}, -- quest: Lost Relic Carry (Inside — Titan Relic from Relic Guardian)
	{ID_ATTUNE="195",ID="790",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="780&680&480&380&520",STAGE="90"},

--vForever dungeon attune 196 (Horde Excavation Site: Wetlands)
	-- Columns L→R: 95663→95682 Maw | 95697 Tastes
	-- SIDE (beside End): 95664 Elder Knowledge (Inside — Titan Relic from Relic Guardian; Earthen Echo follows in-game)
	{ID_ATTUNE="196",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 24",LOCATION="",ID_WOWHEAD="24",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- STAGE 20
	{ID_ATTUNE="196",ID="220",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="95663",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Dragonmaw Rumors
	{ID_ATTUNE="196",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="95697",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Changing Tastes
	-- STAGE 30
	{ID_ATTUNE="196",ID="230",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="95682",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="220",STAGE="30"}, -- quest: Open the Maw
	{ID_ATTUNE="196",ID="130",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Excavation Site"],ID_WOWHEAD="271100",ICON="Interface\\Icons\\inv_misc_food_71",FOLLOWS="120",STAGE="30",COUNT=4}, -- item: Thicket Raptor Meat
	-- STAGE 40
	{ID_ATTUNE="196",ID="240",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Excavation Site"],ID_WOWHEAD="284844",ICON="Interface\\Icons\\inv_misc_note_06",FOLLOWS="230",STAGE="40"}, -- item: Dragonmaw Dispatch
	{ID_ATTUNE="196",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="95697",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: Changing Tastes
	-- STAGE 50
	{ID_ATTUNE="196",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="95682",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: Open the Maw
	{ID_ATTUNE="196",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	-- SIDE reminder (inside dungeon) — left of End
	{ID_ATTUNE="196",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Excavation Site"],ID_WOWHEAD="95664",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="50",SIDE=true}, -- quest: Elder Knowledge (Inside — Titan Relic from Relic Guardian)
	{ID_ATTUNE="196",ID="260",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_book_09",FOLLOWS="250&150&320",STAGE="60"},


--vForever: Lower Blackrock Spire (Alliance 345)
	-- Columns L→R: Bijou→Maxwell | Put Her Down | 3520→4788 Tablets | Worg Pup | Mother's Milk | Spider Eggs
	-- SIDE: 4742→4743 Seal of Ascension (Inside — Vaelan) | 4867 Urok Doomhowl (Inside) | 5089 General Drakkisath's Command (Inside — item 12780)
	-- Doomrigger's Clasp (4766→4764) is on Upper Blackrock Spire, attune 365.
	-- Onyxia's Drakefire chain stays on attune 40. Demon Forge (5127) is Blacksmith-only and is omitted.
	{ID_ATTUNE="345",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Bijou → Maxwell's Mission
	{ID_ATTUNE="345",ID="820",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="5001",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Bijou's Belongings
	{ID_ATTUNE="345",ID="830",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12345",ICON="Interface\\Icons\\inv_misc_bag_19",FOLLOWS="820",STAGE="30"}, -- item: Bijou's Belongings
	{ID_ATTUNE="345",ID="840",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="5001",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="830",STAGE="40"}, -- quest: Bijou's Belongings
	{ID_ATTUNE="345",ID="850",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="5002",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="840",STAGE="50"}, -- quest: Message to Maxwell
	{ID_ATTUNE="345",ID="855",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="850",STAGE="60"},
	{ID_ATTUNE="345",ID="860",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="5081",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="855",STAGE="70"}, -- quest: Maxwell's Mission
	{ID_ATTUNE="345",ID="870",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="9196",ICON="Interface\\Icons\\achievement_reputation_ogre",FOLLOWS="860",STAGE="80"}, -- npc: Highlord Omokk
	{ID_ATTUNE="345",ID="872",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="9237",ICON="Interface\\Icons\\achievement_character_troll_male",FOLLOWS="860",STAGE="80"}, -- npc: War Master Voone
	{ID_ATTUNE="345",ID="874",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="9568",ICON="Interface\\Icons\\achievement_boss_overlord_wyrmthalak",FOLLOWS="860",STAGE="80"}, -- npc: Overlord Wyrmthalak
	{ID_ATTUNE="345",ID="880",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="5081",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="870&872&874",STAGE="90"}, -- quest: Maxwell's Mission
	-- {ID_ATTUNE="345",ID="890",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="880",STAGE="90"},
	-- Put Her Down
	{ID_ATTUNE="345",ID="720",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4701",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Put Her Down
	{ID_ATTUNE="345",ID="730",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="10220",ICON="Interface\\Icons\\ability_hunter_pet_wolf",FOLLOWS="720",STAGE="30"}, -- npc: Halycon
	{ID_ATTUNE="345",ID="740",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4701",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="730",STAGE="40"}, -- quest: Put Her Down
	{ID_ATTUNE="345",ID="750",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="50"},
	{ID_ATTUNE="345",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="60"},
	{ID_ATTUNE="345",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="760",STAGE="70"},
	-- {ID_ATTUNE="345",ID="780",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="770",STAGE="80"},
	{ID_ATTUNE="345",ID="790",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="770",STAGE="90"},
	-- The Final Tablets (3520 Screecher Spirits → 4788)
	{ID_ATTUNE="345",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="3520",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Screecher Spirits
	{ID_ATTUNE="345",ID="630",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="345",ID="640",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="4787",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="40"}, -- quest: The Ancient Egg
	{ID_ATTUNE="345",ID="650",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3528",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="640",STAGE="50"}, -- quest: The God Hakkar
	{ID_ATTUNE="345",ID="660",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5065",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="650",STAGE="60"}, -- quest: The Lost Tablets of Mosh'aru
	{ID_ATTUNE="345",ID="670",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4788",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="660",STAGE="70"}, -- quest: The Final Tablets
	{ID_ATTUNE="345",ID="680",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12740",ICON="Interface\\Icons\\inv_misc_stonetablet_05",FOLLOWS="670",STAGE="80"}, -- item: Fifth Mosh'aru Tablet
	{ID_ATTUNE="345",ID="682",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12741",ICON="Interface\\Icons\\inv_misc_stonetablet_03",FOLLOWS="670",STAGE="80"}, -- item: Sixth Mosh'aru Tablet
	{ID_ATTUNE="345",ID="690",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4788",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="680&682",STAGE="90"}, -- quest: The Final Tablets
	-- Kibler's Exotic Pets
	{ID_ATTUNE="345",ID="520",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4729",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Kibler's Exotic Pets
	{ID_ATTUNE="345",ID="530",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12263",ICON="Interface\\Icons\\inv_box_petcarrier_01",FOLLOWS="520",STAGE="30"}, -- item: Caged Worg Pup
	{ID_ATTUNE="345",ID="540",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4729",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="530",STAGE="40"}, -- quest: Kibler's Exotic Pets
	{ID_ATTUNE="345",ID="550",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="345",ID="560",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="550",STAGE="60"},
	{ID_ATTUNE="345",ID="570",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="560",STAGE="70"},
	{ID_ATTUNE="345",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="345",ID="590",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="570",STAGE="90"},
	-- Mother's Milk
	{ID_ATTUNE="345",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4866",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Mother's Milk
	{ID_ATTUNE="345",ID="430",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="10596",ICON="Interface\\Icons\\inv_misc_monsterspidercarapace_01",FOLLOWS="420",STAGE="30"}, -- npc: Mother Smolderweb
	{ID_ATTUNE="345",ID="440",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4866",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="40"}, -- quest: Mother's Milk
	{ID_ATTUNE="345",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="50"},
	{ID_ATTUNE="345",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
	{ID_ATTUNE="345",ID="470",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="460",STAGE="70"},
	{ID_ATTUNE="345",ID="480",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="345",ID="490",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="470",STAGE="90"},
	-- En-Ay-Es-Tee-Why
	{ID_ATTUNE="345",ID="92",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4862",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: En-Ay-Es-Tee-Why
	{ID_ATTUNE="345",ID="93",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12530",ICON="Interface\\Icons\\inv_egg_02",FOLLOWS="92",STAGE="30", COUNT=15}, -- item: Spire Spider Egg
	{ID_ATTUNE="345",ID="94",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4862",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="93",STAGE="40"}, -- quest: En-Ay-Es-Tee-Why
	{ID_ATTUNE="345",ID="95",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="94",STAGE="50"},
	{ID_ATTUNE="345",ID="96",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="95",STAGE="60"},
	{ID_ATTUNE="345",ID="97",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="96",STAGE="70"},
	{ID_ATTUNE="345",ID="98",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="345",ID="99",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="97",STAGE="90"},

    {ID_ATTUNE="345",ID="25",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},

	{ID_ATTUNE="345",ID="1200",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4742",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: Seal of Ascension (Inside)
	{ID_ATTUNE="345",ID="1100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4743",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: Seal of Ascension (Inside)
	{ID_ATTUNE="345",ID="1080",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4867",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: Urok Doomhowl (Inside)
	{ID_ATTUNE="345",ID="1020",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="5089",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="100",SIDE=true}, -- quest: General Drakkisath's Command (Inside — item 12780)
	{ID_ATTUNE="345",ID="900",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_gem_bloodstone_01",FOLLOWS="880&790&690&590&490&99&1200&1100&1080&1020",STAGE="100"},


-- --vForever: Lower Blackrock Spire (Horde 346)
	-- Columns L→R: Worg Pup | Warlord's Command | Pack Mistress | Operative Bijou | 3520→4788 Tablets | Darkstone | Mother's Milk | Spider Eggs
	-- SIDE: 4742→4743 Seal of Ascension (Inside — Vaelan) | 4867 Urok Doomhowl (Inside)
	{ID_ATTUNE="346",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Kibler's Exotic Pets
	{ID_ATTUNE="346",ID="820",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4729",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Kibler's Exotic Pets
	{ID_ATTUNE="346",ID="830",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12263",ICON="Interface\\Icons\\inv_box_petcarrier_01",FOLLOWS="820",STAGE="30"}, -- item: Caged Worg Pup
	{ID_ATTUNE="346",ID="840",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4729",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="830",STAGE="50"}, -- quest: Kibler's Exotic Pets
	{ID_ATTUNE="346",ID="850",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="840",STAGE="60"},
	{ID_ATTUNE="346",ID="860",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="850",STAGE="70"},
	{ID_ATTUNE="346",ID="870",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="860",STAGE="80"},
	-- {ID_ATTUNE="346",ID="880",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="870",STAGE="90"},
	{ID_ATTUNE="346",ID="890",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="870",STAGE="100"},
	-- Warlord's Command
	{ID_ATTUNE="346",ID="720",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4903",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Warlord's Command
	{ID_ATTUNE="346",ID="736",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12562",ICON="Interface\\Icons\\inv_scroll_02",FOLLOWS="720",STAGE="30"}, -- item: Important Blackrock Documents
	{ID_ATTUNE="346",ID="740",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4903",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="736",STAGE="50"}, -- quest: Warlord's Command
	{ID_ATTUNE="346",ID="750",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="740",STAGE="60"},
	{ID_ATTUNE="346",ID="760",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="750",STAGE="70"},
	{ID_ATTUNE="346",ID="770",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="760",STAGE="80"},
	-- {ID_ATTUNE="346",ID="780",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="770",STAGE="90"},
	{ID_ATTUNE="346",ID="790",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="770",STAGE="100"},
	-- The Pack Mistress
	{ID_ATTUNE="346",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4724",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Pack Mistress
	{ID_ATTUNE="346",ID="630",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="10220",ICON="Interface\\Icons\\ability_hunter_pet_wolf",FOLLOWS="620",STAGE="30"}, -- npc: Halycon
	{ID_ATTUNE="346",ID="640",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4724",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="50"}, -- quest: The Pack Mistress
	{ID_ATTUNE="346",ID="650",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="640",STAGE="60"},
	{ID_ATTUNE="346",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="650",STAGE="70"},
	{ID_ATTUNE="346",ID="670",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="660",STAGE="80"},
	{ID_ATTUNE="346",ID="680",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	{ID_ATTUNE="346",ID="690",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="670",STAGE="100"},
	-- Operative Bijou
	{ID_ATTUNE="346",ID="520",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4981",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Operative Bijou
	-- {ID_ATTUNE="346",ID="530",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4981",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Operative Bijou
	{ID_ATTUNE="346",ID="540",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4982",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Bijou's Belongings
	{ID_ATTUNE="346",ID="550",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12345",ICON="Interface\\Icons\\inv_misc_bag_19",FOLLOWS="540",STAGE="50"}, -- item: Bijou's Belongings
	{ID_ATTUNE="346",ID="560",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4982",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="550",STAGE="60"}, -- quest: Bijou's Belongings
	{ID_ATTUNE="346",ID="570",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4983",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="560",STAGE="70"}, -- quest: Bijou's Reconnaissance Report
	{ID_ATTUNE="346",ID="580",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="570",STAGE="80"},
	{ID_ATTUNE="346",ID="590",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="580",STAGE="100"},
	-- The Final Tablets (3520 Screecher Spirits → 4788)
	{ID_ATTUNE="346",ID="420",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="3520",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Screecher Spirits
	{ID_ATTUNE="346",ID="430",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="3527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="420",STAGE="30"}, -- quest: The Prophecy of Mosh'aru
	{ID_ATTUNE="346",ID="440",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Hinterlands"],ID_WOWHEAD="4787",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="50"}, -- quest: The Ancient Egg
	{ID_ATTUNE="346",ID="450",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="3528",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="440",STAGE="60"}, -- quest: The God Hakkar
	{ID_ATTUNE="346",ID="460",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="5065",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="450",STAGE="70"}, -- quest: The Lost Tablets of Mosh'aru
	{ID_ATTUNE="346",ID="470",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4788",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="460",STAGE="80"}, -- quest: The Final Tablets
	{ID_ATTUNE="346",ID="480",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12740",ICON="Interface\\Icons\\inv_misc_rune_08",FOLLOWS="470",STAGE="90"}, -- item: Fifth Mosh'aru Tablet
	{ID_ATTUNE="346",ID="482",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12741",ICON="Interface\\Icons\\inv_misc_rune_04",FOLLOWS="470",STAGE="90"}, -- item: Sixth Mosh'aru Tablet
	{ID_ATTUNE="346",ID="490",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Tanaris"],ID_WOWHEAD="4788",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="480&482",STAGE="100"}, -- quest: The Final Tablets
	-- The Darkstone Tablet
	{ID_ATTUNE="346",ID="320",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="4769",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Vivian Lagrave and the Darkstone Tablet
	{ID_ATTUNE="346",ID="330",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4768",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="320",STAGE="30"}, -- quest: The Darkstone Tablet
	{ID_ATTUNE="346",ID="340",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12358",ICON="Interface\\Icons\\inv_misc_rune_06",FOLLOWS="330",STAGE="50"}, -- item: Darkstone Tablet
	{ID_ATTUNE="346",ID="350",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Badlands"],ID_WOWHEAD="4768",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="340",STAGE="60"}, -- quest: The Darkstone Tablet
	{ID_ATTUNE="346",ID="360",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="350",STAGE="70"},
	{ID_ATTUNE="346",ID="370",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="360",STAGE="80"},
	-- {ID_ATTUNE="346",ID="380",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="90"},
	{ID_ATTUNE="346",ID="390",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="370",STAGE="100"},
	-- Mother's Milk
	{ID_ATTUNE="346",ID="92",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4866",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Mother's Milk
	{ID_ATTUNE="346",ID="93",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="10596",ICON="Interface\\Icons\\inv_misc_monsterspidercarapace_01",FOLLOWS="92",STAGE="30"}, -- npc: Mother Smolderweb
	{ID_ATTUNE="346",ID="94",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4866",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="93",STAGE="50"}, -- quest: Mother's Milk
	{ID_ATTUNE="346",ID="95",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="94",STAGE="60"},
	{ID_ATTUNE="346",ID="96",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="95",STAGE="70"},
	{ID_ATTUNE="346",ID="97",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="96",STAGE="80"},
	-- {ID_ATTUNE="346",ID="98",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="97",STAGE="90"},
	{ID_ATTUNE="346",ID="99",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="97",STAGE="100"},
	-- En-Ay-Es-Tee-Why
	{ID_ATTUNE="346",ID="72",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4862",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: En-Ay-Es-Tee-Why
	{ID_ATTUNE="346",ID="73",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12530",ICON="Interface\\Icons\\inv_egg_02",FOLLOWS="72",STAGE="30", COUNT=15}, -- item: Spire Spider Egg
	{ID_ATTUNE="346",ID="74",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4862",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="73",STAGE="50"}, -- quest: En-Ay-Es-Tee-Why
	{ID_ATTUNE="346",ID="75",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="74",STAGE="60"},
	{ID_ATTUNE="346",ID="76",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="75",STAGE="70"},
	{ID_ATTUNE="346",ID="77",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="76",STAGE="80"},
	-- {ID_ATTUNE="346",ID="78",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	{ID_ATTUNE="346",ID="79",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="77",STAGE="100"},
	{ID_ATTUNE="346",ID="1200",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4742",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="110",SIDE=true}, -- quest: Seal of Ascension (Inside)
	{ID_ATTUNE="346",ID="1100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4743",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="110",SIDE=true}, -- quest: Seal of Ascension (Inside)
	{ID_ATTUNE="346",ID="1000",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="4867",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="110",SIDE=true}, -- quest: Urok Doomhowl (Inside)
	{ID_ATTUNE="346",ID="900",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_gem_bloodstone_01",FOLLOWS="890&790&690&590&490&390&99&79&1200&1100&1000",STAGE="110"},


-- --vForever: Upper Blackrock Spire (Alliance 365)
-- 	-- Shared columns: Eggs | Blackhand's Command | Matron | Eye of the Emberseer | Drakkisath | Doomrigger's Clasp
-- 	-- SIDE: 5047 Finkle Einhorn (Inside)
-- 	-- Drakefire Amulet stays on the Onyxia attune. Mayara Brightwing (4766→4764) moved here from Lower Spire 345.
	{ID_ATTUNE="365",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="365",ID="620",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4734",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Egg Freezing
	{ID_ATTUNE="365",ID="630",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4734",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: Egg Freezing
	{ID_ATTUNE="365",ID="640",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4735",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="630",STAGE="40"}, -- quest: Egg Collection
	{ID_ATTUNE="365",ID="650",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="12241",ICON="Interface\\Icons\\inv_misc_gem_sapphire_02",FOLLOWS="640",STAGE="50", COUNT=8}, -- item: Collected Dragon Egg
	{ID_ATTUNE="365",ID="660",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4735",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="650",STAGE="60"}, -- quest: Egg Collection
	{ID_ATTUNE="365",ID="520",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="18987",ICON="Interface\\Icons\\inv_letter_17",FOLLOWS="10",STAGE="20"}, -- item: Blackhand's Command
	{ID_ATTUNE="365",ID="530",TYPE="Pick Up",STEP=" Command",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Blackhand's Command
	{ID_ATTUNE="365",ID="540",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10363",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath",FOLLOWS="530",STAGE="40"}, -- npc: General Drakkisath
	{ID_ATTUNE="365",ID="550",TYPE="Click",STEP=FTAttuneLang["Drakkisath's Brand"],LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="1",ICON="Interface\\Icons\\inv_misc_orb_05",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="365",ID="560",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="550",STAGE="60"}, -- quest: Blackhand's Command
	{ID_ATTUNE="365",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="5160",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Matron Protectorate
	{ID_ATTUNE="365",ID="430",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="12923",ICON="Interface\\Icons\\inv_misc_monsterscales_10",FOLLOWS="420",STAGE="30"}, -- item: Awbee's Scale
	{ID_ATTUNE="365",ID="440",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="5160",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="40"}, -- quest: The Matron Protectorate
	{ID_ATTUNE="365",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="50"},
	{ID_ATTUNE="365",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
	{ID_ATTUNE="365",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="6821",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Eye of the Emberseer
	{ID_ATTUNE="365",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="9816",ICON="Interface\\Icons\\spell_fire_lavaspawn",FOLLOWS="220",STAGE="30"}, -- npc: Pyroguard Emberseer
	{ID_ATTUNE="365",ID="240",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="17322",ICON="Interface\\Icons\\inv_misc_gem_pearl_04",FOLLOWS="230",STAGE="40"}, -- item: Eye of the Emberseer
	{ID_ATTUNE="365",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="6821",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: Eye of the Emberseer
	{ID_ATTUNE="365",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="365",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="5102",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: General Drakkisath's Demise
	{ID_ATTUNE="365",ID="130",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10363",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath",FOLLOWS="120",STAGE="30"}, -- npc: General Drakkisath
	{ID_ATTUNE="365",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="5102",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: General Drakkisath's Demise
	{ID_ATTUNE="365",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	{ID_ATTUNE="365",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	-- Doomrigger's Clasp (Mayara Brightwing)
	{ID_ATTUNE="365",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="4766",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Mayara Brightwing
	{ID_ATTUNE="365",ID="30",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4764",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: Doomrigger's Clasp
	{ID_ATTUNE="365",ID="40",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Lower Blackrock Spire"],ID_WOWHEAD="12352",ICON="Interface\\Icons\\inv_belt_12",FOLLOWS="30",STAGE="40"}, -- item: Doomrigger's Clasp
	{ID_ATTUNE="365",ID="50",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4764",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- quest: Doomrigger's Clasp
	{ID_ATTUNE="365",ID="60",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="50",STAGE="60"},
	{ID_ATTUNE="365",ID="1200",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="5047",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: Finkle Einhorn, At Your Service! (Inside)
	{ID_ATTUNE="365",ID="700",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_head_dragon_black",FOLLOWS="660&560&460&260&160&60&1200",STAGE="70"},


-- --vForever: Upper Blackrock Spire (Horde 366)
	{ID_ATTUNE="366",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 55",LOCATION="",ID_WOWHEAD="55",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="366",ID="620",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4734",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Egg Freezing
	-- {ID_ATTUNE="366",ID="630",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4734",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: Egg Freezing
	{ID_ATTUNE="366",ID="640",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4735",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="620",STAGE="30"}, -- quest: Egg Collection
	{ID_ATTUNE="366",ID="650",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="12241",ICON="Interface\\Icons\\inv_misc_gem_sapphire_02",FOLLOWS="640",STAGE="40", COUNT=8}, -- item: Collected Dragon Egg
	{ID_ATTUNE="366",ID="655",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="4735",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="650",STAGE="50"}, -- quest: Egg Collection
    {ID_ATTUNE="366",ID="660",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="655",STAGE="60"},
	{ID_ATTUNE="366",ID="520",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="18987",ICON="Interface\\Icons\\inv_letter_17",FOLLOWS="10",STAGE="20"}, -- item: Blackhand's Command
	{ID_ATTUNE="366",ID="530",TYPE="Pick Up",STEP=" Command",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="520",STAGE="30"}, -- quest: Blackhand's Command
	{ID_ATTUNE="366",ID="540",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10363",ICON="Interface\\Icons\\achievement_boss_generaldrakkisath",FOLLOWS="530",STAGE="40"}, -- npc: General Drakkisath
	{ID_ATTUNE="366",ID="550",TYPE="Click",STEP=FTAttuneLang["Drakkisath's Brand"],LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="1",ICON="Interface\\Icons\\inv_misc_orb_05",FOLLOWS="540",STAGE="50"},
	{ID_ATTUNE="366",ID="560",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Blackrock Mountain"],ID_WOWHEAD="7761",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="550",STAGE="60"}, -- quest: Blackhand's Command
	{ID_ATTUNE="366",ID="420",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="5160",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: The Matron Protectorate
	{ID_ATTUNE="366",ID="430",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="12923",ICON="Interface\\Icons\\inv_misc_monsterscales_10",FOLLOWS="420",STAGE="30"}, -- item: Awbee's Scale
	{ID_ATTUNE="366",ID="440",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="5160",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="430",STAGE="40"}, -- quest: The Matron Protectorate
	{ID_ATTUNE="366",ID="450",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="440",STAGE="50"},
	{ID_ATTUNE="366",ID="460",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="450",STAGE="60"},
	{ID_ATTUNE="366",ID="220",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="6821",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: Eye of the Emberseer
	{ID_ATTUNE="366",ID="230",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="9816",ICON="Interface\\Icons\\spell_fire_lavaspawn",FOLLOWS="220",STAGE="30"}, -- npc: Pyroguard Emberseer
	{ID_ATTUNE="366",ID="240",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="17322",ICON="Interface\\Icons\\inv_misc_gem_pearl_04",FOLLOWS="230",STAGE="40"}, -- item: Eye of the Emberseer
	{ID_ATTUNE="366",ID="250",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="6821",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="240",STAGE="50"}, -- quest: Eye of the Emberseer
	{ID_ATTUNE="366",ID="260",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="250",STAGE="60"},
	{ID_ATTUNE="366",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="4974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: For The Horde!
	{ID_ATTUNE="366",ID="130",TYPE="Kill",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="10429",ICON="Interface\\Icons\\inv_misc_head_orc_01",FOLLOWS="120",STAGE="30"}, -- npc: Warchief Rend Blackhand
	{ID_ATTUNE="366",ID="140",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="4974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="130",STAGE="40"}, -- quest: For The Horde!
	{ID_ATTUNE="366",ID="150",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="140",STAGE="50"},
	{ID_ATTUNE="366",ID="160",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="150",STAGE="60"},
	{ID_ATTUNE="366",ID="1200",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Upper Blackrock Spire"],ID_WOWHEAD="5047",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="70",SIDE=true}, -- quest: Finkle Einhorn, At Your Service! (Inside)
	{ID_ATTUNE="366",ID="700",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_head_dragon_black",FOLLOWS="660&560&460&260&160&1200",STAGE="70"},

	-- Cozy Sleeping Bag (Horde). Alliance (95) swaps the first two zones.
	{ID_ATTUNE="90",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 14",LOCATION="",ID_WOWHEAD="14",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="90",ID="20",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="79007",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: ... and that note you found (Burned-Out Remains)
	{ID_ATTUNE="90",ID="30",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="79007",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: ... and that note you found (Nailed Plank)
	{ID_ATTUNE="90",ID="40",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="79192",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- quest: Stepping Stones (Nailed Plank)
	{ID_ATTUNE="90",ID="50",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79192",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- quest: Stepping Stones (Pocket Litter)
	{ID_ATTUNE="90",ID="60",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79980",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- quest: Scramble (Pocket Litter)
	{ID_ATTUNE="90",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79980",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- quest: Scramble (Mound of Dirt)
	{ID_ATTUNE="90",ID="80",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- quest: Wet Job (Mound of Dirt)
	{ID_ATTUNE="90",ID="90",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="79974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- quest: Wet Job (Carved Figurine)
	{ID_ATTUNE="90",ID="100",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="79975",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- quest: Eagle's Fist (Carved Figurine)
	{ID_ATTUNE="90",ID="110",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="79975",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="100",STAGE="110"}, -- quest: Eagle's Fist (Messenger Bag)
	{ID_ATTUNE="90",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="79976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="120"}, -- quest: This Must Be The Place (Messenger Bag)
	{ID_ATTUNE="90",ID="130",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="79976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="130"}, -- quest: This Must Be The Place (Hastily Rolled-Up Satchel)
	{ID_ATTUNE="90",ID="140",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_bag_bigbagofenchantments",FOLLOWS="130",STAGE="140"},

	-- Cozy Sleeping Bag (Alliance): Westfall first, then The Barrens
	{ID_ATTUNE="95",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 14",LOCATION="",ID_WOWHEAD="14",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="95",ID="20",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="79008",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- quest: ... and that note you found (Burned-Out Remains)
	{ID_ATTUNE="95",ID="30",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="79008",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- quest: ... and that note you found (Burned-Out Remains)
	{ID_ATTUNE="95",ID="40",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="79192",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- quest: Stepping Stones (Nailed Plank)
	{ID_ATTUNE="95",ID="50",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79192",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- quest: Stepping Stones (Pocket Litter)
	{ID_ATTUNE="95",ID="60",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79980",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- quest: Scramble (Pocket Litter)
	{ID_ATTUNE="95",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79980",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- quest: Scramble (Mound of Dirt)
	{ID_ATTUNE="95",ID="80",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="79974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- quest: Wet Job (Mound of Dirt)
	{ID_ATTUNE="95",ID="90",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="79974",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- quest: Wet Job (Carved Figurine)
	{ID_ATTUNE="95",ID="100",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="79975",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- quest: Eagle's Fist (Carved Figurine)
	{ID_ATTUNE="95",ID="110",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="79975",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="100",STAGE="110"}, -- quest: Eagle's Fist (Messenger Bag)
	{ID_ATTUNE="95",ID="120",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="79976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="120"}, -- quest: This Must Be The Place (Messenger Bag)
	{ID_ATTUNE="95",ID="130",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="79976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="120",STAGE="130"}, -- quest: This Must Be The Place (Hastily Rolled-Up Satchel)
	{ID_ATTUNE="95",ID="140",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_bag_bigbagofenchantments",FOLLOWS="130",STAGE="140"},
}

-- Character trials. Most requirements read a statistic (GetStatistic):
-- 1198 creatures killed, 64222 times camped, 98 quests completed,
-- 588 total honorable kills, and 932 five-player dungeons entered.
-- Professions, including cooking (185), fishing (356), and first aid (129), read the profession rank.
-- The chain is placed right to left, so a higher step id sits further left.
-- Top row: level, kills, quests, honorable kills, dungeons, times camped.
-- Bottom row: cooking, fishing, first aid, two professions.
do
	local steps = FTAttune_Data.steps
	local attunes = FTAttune_Data.attunes
	local expac = FTAttuneLang["World of Warcraft"]
	local group = FTAttuneLang["CHARACTER"]
	local icon = {
		level = "Interface\\Icons\\spell_holy_innerfire",
		kills = "Interface\\Icons\\ability_warrior_savageblow",
		camped = "Interface\\Icons\\inv_camelot_camping_welcomingcampfire",
		quests = "Interface\\Icons\\inv_scroll_03",
		honor = "Interface\\Icons\\inv_bannerpvp_02",
		dungeons = "Interface\\Icons\\inv_misc_key_03",
		cooking = "Interface\\Icons\\inv_misc_food_15",
		fishing = "Interface\\Icons\\trade_fishing",
		aid = "Interface\\Icons\\spell_holy_sealofsacrifice",
		prof = "Interface\\Icons\\inv_misc_book_09",
	}

	-- Sit ahead of dungeons. Class quests insert in front of this group when they load.
	local insertAt = #attunes + 1
	for i, a in ipairs(attunes) do
		if a.GROUP == FTAttuneLang["DUNGEONS"] then
			insertAt = i
			break
		end
	end

	local function addAttune(id, nameKey, descKey, iconPath, level)
		table.insert(attunes, insertAt, {
			ID = id,
			NAME = FTAttuneLang[nameKey],
			SHORT = tostring(level),
			EXPAC = expac,
			GROUP = group,
			FACTION = "Both",
			ICON = iconPath,
			DESC = FTAttuneLang[descKey],
			LEVELS = tostring(level),
		})
		insertAt = insertAt + 1
	end

	addAttune("500", "Initiate", "Initiate_Desc", "Interface\\Icons\\achievement_level_20", 20)
	addAttune("510", "Intermediate", "Intermediate_Desc", "Interface\\Icons\\achievement_level_40", 40)
	addAttune("520", "Veteran", "Veteran_Desc", "Interface\\Icons\\achievement_level_60", 60)


    -- https://wowwiki-archive.fandom.com/wiki/Complete_list_of_Achievement_ID%27s for the achievement IDs

	local function addTier(id, level, kills, camped, skill, quests, honor, dungeons)
		local profLabel = (FTAttuneLang["ProfessionsAt"] or "2 professions at ##SKILL##"):gsub("##SKILL##", tostring(skill))
		steps[#steps + 1] = {ID_ATTUNE=id, ID="30", TYPE="Level", STEP=FTAttuneLang["Reach level"].." "..level, LOCATION="", ID_WOWHEAD=tostring(level), ICON=icon.level, FOLLOWS="0", STAGE="10"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="20", TYPE="Stat", STEP=FTAttuneLang["Creatures killed"], LOCATION="", ID_WOWHEAD="1198", COUNT=kills, ICON=icon.kills, FOLLOWS="0", STAGE="10"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="18", TYPE="Stat", STEP=FTAttuneLang["Quests completed"], LOCATION="", ID_WOWHEAD="98", COUNT=quests, ICON=icon.quests, FOLLOWS="0", STAGE="20"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="15", TYPE="Stat", STEP=FTAttuneLang["Honorable kills"], LOCATION="", ID_WOWHEAD="588", COUNT=honor, ICON=icon.honor, FOLLOWS="0", STAGE="20"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="12", TYPE="Stat", STEP=FTAttuneLang["5-player dungeons"], LOCATION="", ID_WOWHEAD="932", COUNT=dungeons, ICON=icon.dungeons, FOLLOWS="0", STAGE="30"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="10", TYPE="Stat", STEP=FTAttuneLang["Times camped"], LOCATION="", ID_WOWHEAD="64222", COUNT=camped, ICON=icon.camped, FOLLOWS="0", STAGE="30"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="70", TYPE="Prof", STEP=profLabel, LOCATION="", ID_WOWHEAD="0", COUNT=skill, NEED=2, ICON=icon.prof, FOLLOWS="0", STAGE="40"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="40", TYPE="Stat", STEP=FTAttuneLang["Cooking skill"], LOCATION="", ID_WOWHEAD="0", SKILL_LINE=185, COUNT=skill, ICON=icon.cooking, FOLLOWS="0", STAGE="40"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="60", TYPE="Stat", STEP=FTAttuneLang["Fishing skill"], LOCATION="", ID_WOWHEAD="0", SKILL_LINE=356, COUNT=skill, ICON=icon.fishing, FOLLOWS="0", STAGE="50"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="50", TYPE="Stat", STEP=FTAttuneLang["First Aid skill"], LOCATION="", ID_WOWHEAD="0", SKILL_LINE=129, COUNT=skill, ICON=icon.aid, FOLLOWS="0", STAGE="50"}
		steps[#steps + 1] = {ID_ATTUNE=id, ID="80", TYPE="End", STEP="Attuned", LOCATION="", ID_WOWHEAD="0", ICON=icon.level, FOLLOWS="30&20&18&15&12&10&70&60&50&40", STAGE="60"}
	end


	-- ID, level, kills, times camped, skill, quests, honor kills, dungeons
	addTier("500", 20, 750, 10, 100, 100, 5, 5)
	addTier("510", 40, 3000, 25, 200, 300, 50, 15)
	addTier("520", 60, 7500, 60, 300, 600, 500, 50)
end

-- Skill line id and name. Any two at the tier's skill count.
-- Jewelcrafting and Inscription are included so they count where those professions exist.
FTAttune_Data.primaryProfessions = {
	{171, "Alchemy"},
	{164, "Blacksmithing"},
	{333, "Enchanting"},
	{202, "Engineering"},
	{182, "Herbalism"},
	{773, "Inscription"},
	{755, "Jewelcrafting"},
	{165, "Leatherworking"},
	{186, "Mining"},
	{393, "Skinning"},
	{197, "Tailoring"},
}

-- [id] = title, minlevel, groupsize, desc
FTAttune_Data.quests = {
	[7848]={55,5},			[7847]={46,1},			[4903]={55,5},			[4941]={55,1},			[4974]={55,10},			[6566]={55,1},			[6567]={55,1},
	[6568]={55,1},			[6569]={55,10},			[6570]={55,1},			[6582]={55,5},			[6583]={55,5},			[6584]={55,5},			[6585]={55,5},
	[6601]={55,1},			[6602]={55,10},			[4182]={48,2},			[4183]={48,1},			[4184]={48,1},			[4185]={48,1},			[4186]={48,1},
	[4223]={48,1},			[4224]={48,1},			[4241]={48,5},			[4242]={48,1},			[4264]={50,1},			[4282]={50,5},			[4322]={50,5},
	[6402]={50,1},			[6403]={50,1},			[6501]={50,1},			[6502]={50,10},			[7761]={55,10},			[9122]={60,1},			[9121]={60,1},
	[9123]={60,1},			[8286]={60,1},			[8288]={60,40},			[8301]={60,2},			[8303]={60,1},			[8305]={60,1},			[8519]={60,1},	
	[8555]={60,1},			[8575]={60,1},			[8576]={60,1},			[8577]={60,1},			[8578]={60,40},			[8728]={60,1},			[8729]={60,25},	
	[8742]={60,1},			[8745]={60,1},			[8584]={60,1},			[8585]={60,8},			[8586]={60,1},			[8587]={60,1},			[8597]={60,1},
	[8599]={60,1},			[8598]={60,1},			[8606]={60,1},			[8620]={60,40},			[8733]={60,5},			[8734]={60,1},			[8735]={60,40},
	[8736]={60,40},			[8741]={60,1},			[8730]={60,40},			[10755]={68,1},			[10756]={68,1},			[10757]={68,1},			[10758]={68,3},
	[10754]={68,1},			[10762]={68,1},			[10763]={68,1},			[10764]={68,3},			[9824]={68,1},			[9825]={68,1},			[9826]={68,1},
	[9829]={68,1},			[9831]={68,5},			[9832]={68,5},			[10266]={67,1},			[10267]={67,1},			[10268]={67,1},			[10269]={67,1},
	[10275]={67,1},			[10276]={67,1},			[10280]={67,1},			[10704]={67,1},			[10265]={67,1},			[10262]={67,1},			[10205]={67,1},
	[9836]={68,5},			[9837]={68,1},			[9838]={68,1},			[9630]={70,10},			[9638]={70,10},			[9639]={70,10},			[9640]={70,10},
	[9645]={70,10},			[9680]={70,1},			[9631]={70,1},			[9637]={70,5},			[9644]={70,10},			[10279]={66,1},			[10277]={66,1},
	[10282]={66,5},			[10283]={66,5},			[10284]={66,5},			[10285]={66,5},			[10901]={70,5},			[10900]={70,5},			[10681]={68,1},
	[10458]={68,1},			[10480]={68,1},			[10481]={68,1},			[10513]={68,1},			[10514]={68,1},			[10515]={68,1},			[10519]={68,1},
	[10521]={68,1},			[10527]={68,1},			[10546]={68,1},			[10522]={68,1},			[10528]={68,1},			[10547]={68,1},			[10523]={68,1},
	[10537]={68,1},			[10550]={68,1},			[10540]={68,1},			[10570]={68,1},			[10541]={68,1},			[10576]={68,1},			[10577]={68,1},
	[10578]={68,5},			[10579]={68,1},			[10883]={70,1},			[10588]={68,5},			[10884]={70,5},			[10885]={70,5},			[10886]={70,5},
	[10888]={70,25},		[10680]={68,1},			[10445]={70,25},		[10683]={68,1},			[10684]={68,1},			[10685]={68,1},			[10686]={68,1},
	[10568]={68,1},			[10571]={68,1},			[10574]={68,1},			[10575]={68,1},			[10622]={68,1},			[10628]={68,1},			[10705]={68,1},
	[10706]={69,1},			[10707]={68,5},			[10708]={70,1},			[10944]={70,1},			[10946]={70,25},		[10947]={70,25},		[10948]={70,1},
	[10949]={70,1},			[10985]={70,1},			[10984]={70,1},			[10983]={70,1},			[10995]={70,5},			[10996]={70,5},			[10997]={70,5},
	[10998]={70,5},			[11000]={70,5},			[11022]={70,1},			[11009]={70,1},			[10804]={70,1},			[10811]={70,1},			[10814]={70,1},
	[10836]={70,1},			[10837]={70,1},			[10854]={70,1},			[10858]={70,1},			[10866]={70,5},			[10870]={70,1},			[3801]={48,1},
	[3802]={48, 5},			[838]={55,1},			[964]={55,1},			[5514]={55,1},			[5537]={55,1},			[5802]={55,1},			[5804]={55,3},
	[5511]={55,1},			[5803]={55,3},			[5533]={55,1},			[5538]={55,1},			[5801]={55,1},			[5097]={50,1},			[5098]={50,1},
	[5505]={50,1},			[5096]={50,1},			[5092]={50,1},			[6804]={55,1},			[6805]={55,1},			[6821]={55,10},			[6822]={55,40},
	[6823]={55,40},			[6824]={55,40},			[7486]={55,1},
	-- Ragefire Chasm / Deadmines
	[5726]={9,1},			[5727]={9,1},			[5728]={9,5},			[5729]={9,1},			[5730]={9,1},
	[5722]={9,5},			[5723]={9,5},			[5724]={9,1},			[5725]={9,5},			[5761]={9,5},
	[12]={9,1},				[13]={9,1},				[14]={9,1},				[65]={14,1},				[132]={14,1},
	[135]={14,1},			[141]={14,1},			[142]={14,1},			[155]={14,1},			[166]={14,5},
	[167]={15,5},			[168]={14,5},			[214]={14,5},			[2040]={15,5},			[2041]={15,1},
	[373]={16,1},			[92742]={14,1},			[92744]={14,1},			[92745]={15,1},			[92747]={16,1},
	[92748]={16,1},			[92749]={16,1},			[92750]={17,1},			[92751]={17,1},			[92752]={17,1},
	[92753]={18,5},			[92819]={18,5},
	-- Forever dungeon quests
	[17]={38,5},			[261]={34,1},			[303]={22,5},			[377]={22,5},			[378]={22,5},			[386]={22,5},			[387]={22,5},
	[388]={22,5},			[389]={16,1},			[391]={16,5},			[709]={30,5},			[720]={35,1},			[721]={35,5},
	[722]={35,5},			[865]={13,1},			[870]={10,1},			[877]={13,1},			[880]={16,5},
	[886]={10,1},			[914]={10,5},			[959]={14,1},			[962]={14,5},
	[971]={10,5},			[1013]={16,5},			[1014]={18,5},			[1048]={33,5},			[1049]={28,5},
	[1050]={28,5},			[1051]={25,1},			[1052]={34,1},			[1053]={34,5},			[1098]={18,5},
	[1100]={29,1},			[1101]={29,5},			[1102]={29,5},			[1109]={30,5},			[1113]={30,1},
	[1139]={35,5},			[1142]={25,5},			[1144]={22,5},			[1149]={25,1},			[1150]={25,5},
	[1151]={25,5},			[1152]={26,1},			[1154]={26,5},			[1159]={26,1},			[1160]={26,5},
	[1198]={18,1},			[1199]={20,5},
	[1200]={18,5},			[1221]={20,5},			[1275]={18,5},			[1360]={33,5},			[1394]={26,1},
	[1424]={38,1},			[1429]={38,1},			[1444]={38,1},			[1445]={38,5},			[1446]={38,5},			[1475]={38,5},			[1486]={13,5},			[1487]={15,5},			[1489]={10,1},
	[1490]={10,1},			[1491]={13,5},			[2198]={37,1},			[2200]={37,5},			[2201]={37,5},			[2202]={36,5},
	[2204]={37,5},			[2240]={35,5},			[2278]={40,5},			[2279]={40,1},			[2280]={40,1},
	[2258]={39,1},			[2283]={37,5},			[2284]={37,5},			[2318]={37,1},			[2339]={37,5},			[2342]={33,5},			[2398]={35,1},
	[2418]={30,5},			[2500]={39,1},			[2768]={40,5},			[2770]={40,5},			[2841]={25,5},			[2842]={20,1},
	[2843]={20,1},			[2846]={40,5},			[2865]={40,5},			[2904]={20,5},			[2922]={20,1},
	[2923]={20,1},			[2924]={24,5},			[2926]={20,1},			[2927]={20,1},			[2928]={20,5},
	[2929]={25,5},			[2933]={40,1},			[2934]={40,1},			[2935]={40,1},			[2936]={45,5},			[2991]={45,5},			[3042]={40,5},			[3341]={37,5},
	[3369]={15,1},			[3373]={48,5},			[3380]={46,1},			[3444]={46,1},			[3445]={46,1},
	[3446]={46,5},			[3447]={46,5},			[3520]={40,1},			[3523]={32,5},			[3525]={32,5},			[3527]={40,5},
	[3528]={40,5},			[4787]={40,1},			[3636]={39,5},			[3906]={48,1},			[3907]={48,5},			[3981]={48,5},
	[4001]={48,1},			[4002]={48,1},			[4003]={48,5},			[4004]={48,1},			[4022]={52,1},			[4024]={52,5},
	[4063]={52,5},			[4081]={48,5},			[4082]={50,5},			[4123]={50,5},			[4126]={50,5},
	[4134]={50,5},			[4136]={48,5},			[4201]={50,5},			[4262]={48,1},			[4263]={48,5},
	[4286]={50,5},			[4341]={50,5},			[4342]={50,1},			[4361]={50,1},			[4362]={50,5},
	[4363]={50,1},			[3701]={50,1},			[3702]={50,1},			[3911]={48,5},			[4128]={50,1},			[7201]={48,5},			[5212]={55,5},			[5213]={55,5},			[5214]={55,5},			[5243]={55,5},
	[5125]={60,5},			[5251]={55,5},			[5262]={55,1},			[5263]={55,5},			[5281]={55,1},			[5282]={55,5},
	[5461]={60,1},			[5462]={60,1},			[5742]={52,1},			[5781]={56,1},			[5845]={56,1},			[5846]={57,1},
	[5961]={56,1},			[6022]={58,1},			[6042]={56,1},			[6133]={60,5},			[6135]={60,5},			[6136]={60,5},
	[6144]={60,1},			[6163]={60,5},			[5341]={52,5},
	[5342]={52,1},			[5343]={52,5},			[5344]={52,1},			[5382]={55,5},			[5384]={55,5},          [5582]={55,5},
	[5463]={57,5},			[5466]={57,5},			[5515]={55,5},			[5522]={57,1},			[5526]={56,5},			[5529]={55,5},
	[5531]={57,1},			[4771]={57,5},
	[5848]={52,5},			[6141]={34,1},			[6521]={28,1},			[6522]={28,1},			[6561]={18,5},
	[6562]={17,1},			[6563]={17,1},			[6564]={17,1},			[6565]={17,5},			[6626]={28,1},
	[6627]={26,1},			[6628]={26,1},			[6921]={21,5},			[6922]={21,5},			[6981]={15,5},			[7028]={41,5},			[7029]={41,5},			[7041]={41,5},
	[7044]={41,5},			[7046]={41,5},			[7064]={45,5},			[7065]={45,5},			[7066]={39,1},
	[7067]={39,5},			[7068]={39,1},			[7070]={39,1},			[7441]={54,5},			[7461]={56,5},
	[7462]={56,1},			[7481]={54,5},			[7482]={54,5},			[7488]={54,5},			[7489]={54,5},			[7492]={54,1},			[7494]={54,1},
	[356]={6,1},			[447]={9,1},			[450]={9,1},			[451]={9,1},			[99156]={6,1},
	[92401]={15,1},			[92415]={15,1},			[92421]={15,5},			[92422]={15,5},			[95189]={16,1},
	[95195]={16,1},			[95204]={16,1},			[95216]={16,5},			[95250]={16,5},			[96393]={9,5},
	[96394]={10,5},			[96395]={10,5},			[96403]={10,5},			[97288]={16,1},
	[98423]={16,5},
	[79987]={40,5},			[80140]={40,5},
	[80324]={40,5},			[80325]={40,5},
	[4701]={55,5},			[4724]={55,5},			[4729]={55,5},			[4734]={57,5},			[4735]={57,5},
	[4742]={57,5},			[4743]={57,5},			[4764]={57,5},			[4766]={57,1},			[4768]={57,5},
	[4769]={57,1},			[4788]={40,5},			[5065]={40,1},			[4862]={55,5},			[4866]={55,5},			[4867]={55,5},
	[4981]={55,1},			[4982]={55,5},			[4983]={55,1},			[5001]={55,5},			[5002]={55,1},
	[5047]={57,1},			[5081]={55,5},			[5089]={55,1},			[5102]={55,5},			[5160]={57,1},
	-- Excavation Site: Wetlands (Forever)
	[275]={20,1},			[276]={20,1},			[277]={20,1},			[463]={20,1},			[469]={18,1},
	[95646]={24,5},			[95647]={24,5},			[95663]={24,1},			[95664]={24,5},
	[95682]={24,5},			[95697]={24,5},			[95737]={24,1},			[95772]={24,5},			[95795]={24,1},
	[95809]={24,1},			[95810]={24,5},			[98815]={24,5},
	-- Cozy Sleeping Bag
	[79007]={14,1},			[79008]={14,1},			[79192]={14,1},			[79980]={14,1},
	[79974]={14,1},			[79975]={14,1},			[79976]={14,1},
	-- City of Dalaran (Alliance)
	[92432]={30,1},			[92456]={24,5},			[92458]={24,5},			[92459]={24,1},			[92489]={24,5},
	-- City of Dalaran (Horde)
	[544]={30,1},			[545]={30,1},
	[93680]={30,1},			[92434]={30,1},			[96984]={24,5},			[96986]={24,5},
	[96987]={24,5},			[96988]={24,5},			[97287]={24,1},
}


-- level, type, kind, desc
FTAttune_Data.npcs = {
	[3296] = { "55", "", "Org Grunt"},
	[6466] = { "12", "", "Gamon"},
	[3100] = { "8", "",  "Elder Mottled Boar"},	
	[9568] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]},
	[9237] = { "59", FTAttuneLang["Elite"], FTAttuneLang["Troll"]},
	[9196] = { "59", FTAttuneLang["Elite"], FTAttuneLang["Ogre"]},
	[10429] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Orc"]},
	[8197] = { "61", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]},
	[10664] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]},
	[12900] = { "62", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]},
	[12899] = { "62", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]},
	[10182] = { "??", FTAttuneLang["Elite"], FTAttuneLang["Half-Orc"]},
	[10929]	= { "62", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin (in Blood Elf form)"]},
	[17804]	= { "52", "", FTAttuneLang["Human"]},
	[10363]	= { "??", FTAttuneLang["Boss"], FTAttuneLang["Dragonkin"]},
	[8983]	= { "57", FTAttuneLang["Elite"], FTAttuneLang["Dwarf"]},
	[9033]	= { "57", FTAttuneLang["Elite"], FTAttuneLang["Dwarf"]},
	[9046]	= { "55", FTAttuneLang["Rare Elite"], FTAttuneLang["Orc"]},
	[22037]	= { "69", "", FTAttuneLang["Orc"]},
	[18733] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Mechanical"]},
	[18473] = { "69", FTAttuneLang["Elite"], FTAttuneLang["Arakkoa"]},	
	[18472] = { "69", FTAttuneLang["Elite"], FTAttuneLang["Arakkoa"]},	
	[20142] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]},	
	[18096] = { "68", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]},	
	[20130] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin (in Humanoid form)"]},
	[19880] = { "70", "", FTAttuneLang["Ethereal"]},	
	[19641] = { "70", "", FTAttuneLang["Ethereal"]},	
	[19220] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Blood Elf"]},	
	[17977] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]},	
	[18481] = { "73", FTAttuneLang["Elite"], FTAttuneLang["Shiny thingy"]},	
	[17613] = { "70", "", FTAttuneLang["Human"]},	
	[18708] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]},	
	[17797] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Naga"]},
	[20870] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Demon"]},	
	[15608] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Human"]},	
	[22421] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Naga"]},	
	[19044] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Gronn"]},
	[17225] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Undead (in Dragon form)"]},	
	[21938] = { "68", "", FTAttuneLang["Tauren"]},	
	[21183] = { "70", "", FTAttuneLang["Orc"]},	
	[21291] = { "70", "", FTAttuneLang["Orc"]},	
	[21292] = { "70", "", FTAttuneLang["Orc"]},	
	[21293] = { "70", "", FTAttuneLang["Orc"]},	
	[18166] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Human"]},	
	[16808] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Orc"]},	
	[16807] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Orc"]},	
	[17798] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Naga"]},	
	[20912] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Qiraji"]},	
	[20977] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Gnome"]},	
	[21937] = { "65", "", FTAttuneLang["Broken"]},	
	[17257] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Demon"]},	
	[19935] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin (in Blood Elf form)"]},	
	[19622] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Blood Elf"]},	
	[21212] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Naga"]},	
	[21402] = { "70", "", FTAttuneLang["Draenei"]},	
	[21955] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Blood Elf"]},	
	[21962] = { "70", "", FTAttuneLang["Broken"]},	
	[22006] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Orc"]},	
	[22820] = { "70", "", FTAttuneLang["Broken"]},	
	[21700] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Broken"]},	
	[19514] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Elemental"]},	
	[17767] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Undead"]},	
	[18528] = { "70", FTAttuneLang["Elite"], FTAttuneLang["Shiny thingy"]},	
	[15552] = { "63", FTAttuneLang["Elite"], FTAttuneLang["Gnome"]},
	[15554] = { "61", FTAttuneLang["Elite"], FTAttuneLang["Gorilla"]},	
	[15571] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Shark"]},	
	[12803] = { "62", FTAttuneLang["Elite"], FTAttuneLang["Chimaera"]},	
	[11583] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Dragonkin"]},	
	[13020] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Dragonkin"]},	
	[12017] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Dragonkin"]},	
	[15624] = { "8", "", FTAttuneLang["Wisp"]},	
	[15180] = { "60", "", FTAttuneLang["Night-Elf"]},	
	[15526] = { "60", "", FTAttuneLang["Naga"]},	
	[11811] = { "45", "", FTAttuneLang["Gnome"]},	
	[15362] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Night-Elf"]},	
	[15481] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Dragonkin"]},	
	[11502] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Elemental"]},	
	[10184] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Dragonkin"]},	
	[16524] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Undead"]},
	[22497] = { "72", FTAttuneLang["Elite"], FTAttuneLang["Shiny thingy"]},	
	[22941] = { "68", "", FTAttuneLang["Ogre"]},
	[22113] = { "71", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin (in Blood Elf form)"]},		
	[8888]  = { "60", FTAttuneLang["Elite"], FTAttuneLang["Dwarf"]}, 
	[9056]  = { "54", FTAttuneLang["Elite"], FTAttuneLang["Dwarf"]},
	[10837] = { "61", "", FTAttuneLang["Undead"] },
	[10838] = { "61", "", FTAttuneLang["Human"] },
	[1852]  = { "61", FTAttuneLang["Elite"], FTAttuneLang["Undead"] },
	[13278] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]},	
	[12264] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Flamewaker"]},	
	[12118] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Flamewaker"]},	
	[12259] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Flamewaker"]},	
	[12098] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Flamewaker"]},	
	-- Ragefire Chasm
	[11520] = { "16", FTAttuneLang["Elite"], FTAttuneLang["Demon"]},		-- Taragaman the Hungerer
	[11519] = { "16", FTAttuneLang["Elite"], FTAttuneLang["Demon"]},		-- Bazzalan
	[11518] = { "16", FTAttuneLang["Elite"], FTAttuneLang["Orc"]},			-- Jergosh the Invoker
	[11834] = { "14", "", FTAttuneLang["Tauren"]},					-- Maur Grimtotem
	-- The Deadmines
	[639]   = { "20", FTAttuneLang["Elite"], FTAttuneLang["Human"]},		-- Edwin VanCleef
	-- Shadowfang Keep
	[4275]  = { "26", FTAttuneLang["Elite"], FTAttuneLang["Human"]},		-- Archmage Arugal
	[3849]  = { "18", "", FTAttuneLang["Undead"]},					-- Deathstalker Adamant
	[4444]  = { "18", "", FTAttuneLang["Undead"]},					-- Deathstalker Vincent
	-- Blackfathom Deeps
	[4787]  = { "20", FTAttuneLang["Elite"], FTAttuneLang["Night-Elf"]},	-- Argent Guard Thaelrid
	[4832]  = { "25", FTAttuneLang["Elite"], FTAttuneLang["Human"]},		-- Twilight Lord Kelris
	[12902] = { "24", FTAttuneLang["Elite"], FTAttuneLang["Human"]},		-- Lorgus Jett
	-- Gnomeregan
	[7800]  = { "28", FTAttuneLang["Elite"], FTAttuneLang["Gnome"]},		-- Mekgineer Thermaplugg
	[6231]  = { "26", FTAttuneLang["Elite"], FTAttuneLang["Mechanical"]},	-- Techbot
	[7850]  = { "28", "", FTAttuneLang["Gnome"]},					-- Kernobee
	-- Razorfen Kraul
	[4421]  = { "33", FTAttuneLang["Elite"], FTAttuneLang["Quillboar"]},	-- Charlga Razorflank
	[4508]  = { "28", "", FTAttuneLang["Human"]},					-- Willix the Importer
	-- Scarlet Monastery
	[3974] = { "34", FTAttuneLang["Elite"], FTAttuneLang["Human"]}, -- Houndmaster Loksey
	[3975] = { "40", FTAttuneLang["Elite"], FTAttuneLang["Human"]}, -- Herod
	[3976] = { "42", FTAttuneLang["Elite"], FTAttuneLang["Human"]}, -- Scarlet Commander Mograine
	[3977] = { "42", FTAttuneLang["Elite"], FTAttuneLang["Human"]}, -- High Inquisitor Whitemane
    [6487] = { "37", FTAttuneLang["Elite"], FTAttuneLang["Human"]}, -- Arcanist Doan
	-- Razorfen Downs / Maraudon / Hall of Thanes
	[7358] = { "41", FTAttuneLang["Boss"], FTAttuneLang["Undead"]}, -- Amnennar the Coldbringer
	[12865] = { "35", FTAttuneLang["Elite"], FTAttuneLang["Undead"]}, -- Ambassador Malcin
	[12201] = { "51", FTAttuneLang["Boss"], FTAttuneLang["Elemental"]}, -- Princess Theradras
	[13282] = { "48", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]}, -- Noxxion
	[12236] = { "47", FTAttuneLang["Elite"], FTAttuneLang["Demon"]}, -- Lord Vyletongue
	[261319] = { "18", FTAttuneLang["Elite"], FTAttuneLang["Dwarf"]}, -- Durgen Dirgehammer
	[261306] = { "15", FTAttuneLang["Elite"], FTAttuneLang["Undead"]}, -- Faldrim Anvilmar
	-- Post-SM dungeon NPCs
	[2748] = { "40", FTAttuneLang["Boss"], FTAttuneLang["Giant"]}, -- Archaedas
	[5710] = { "50", FTAttuneLang["Elite"], FTAttuneLang["Troll"]}, -- Jammal'an the Prophet
	[7272] = { "46", FTAttuneLang["Elite"], FTAttuneLang["Undead"]}, -- Theka the Martyr
	[7273] = { "46", FTAttuneLang["Elite"], FTAttuneLang["Beast"]}, -- Gahz'rilla
	[7795] = { "46", FTAttuneLang["Elite"], FTAttuneLang["Troll"]}, -- Hydromancer Velratha
	[7797] = { "40", FTAttuneLang["Elite"], FTAttuneLang["Troll"]}, -- Nekrum Gutchewer
	[9016] = { "54", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]}, -- Bael'Gar
	[9017] = { "55", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]}, -- Lord Incendius
	[9019] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Dwarf"]}, -- Emperor Dagran Thaurissan
	[9543] = { "53", FTAttuneLang["Elite"], FTAttuneLang["Gnome"]}, -- Ribbly Screwspigot
	[10439] = { "61", FTAttuneLang["Boss"], FTAttuneLang["Undead"]}, -- Ramstein the Gorger
	[10440] = { "62", FTAttuneLang["Boss"], FTAttuneLang["Undead"]}, -- Baron Rivendare
	[10506] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Undead"]}, -- Kirtonos the Herald
	[10811] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Human"]}, -- Archivist Galford
	[11486] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Night-Elf"]}, -- Prince Tortheldrin
	[11496] = { "??", FTAttuneLang["Boss"], FTAttuneLang["Demon"]}, -- Immol'thar
	[14327] = { "57", FTAttuneLang["Elite"], FTAttuneLang["Demon"]}, -- Lethtendris
	[10220] = { "59", FTAttuneLang["Elite"], FTAttuneLang["Beast"]}, -- Halycon
	[10321] = { "54", FTAttuneLang["Elite"], FTAttuneLang["Dragonkin"]}, -- Emberstrife
	[10584] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Ogre"]}, -- Urok Doomhowl
	[10596] = { "59", FTAttuneLang["Elite"], FTAttuneLang["Beast"]}, -- Mother Smolderweb
	[9816] = { "60", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]}, -- Pyroguard Emberseer
	[260322] = { "26", FTAttuneLang["Elite"], FTAttuneLang["Beast"]}, -- Saltspine
	[260325] = { "27", FTAttuneLang["Elite"], FTAttuneLang["Beast"]}, -- Shadetooth
	[260808] = { "28", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]}, -- Highland Horror
	[260326] = { "29", FTAttuneLang["Boss"], FTAttuneLang["Elemental"]}, -- Relic Guardian
	[247126] = { "32", FTAttuneLang["Elite"], FTAttuneLang["Undead"]}, -- Atrexis the Grave Knight
	[246016] = { "??", FTAttuneLang["Elite"], FTAttuneLang["Elemental"]}, -- Arcanic Enigma
}

end
setfenv(Component, FT.attuneEnv)
Component(...)
