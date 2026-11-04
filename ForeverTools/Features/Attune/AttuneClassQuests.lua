-- Local Attune adaptation; original copyright retained. See NOTICE.txt.
local _, FT = ...
local function Component(...)
-- Vanilla class quest chains, listed above Dungeons.
-- Quest list: Wowhead Classic class filters (Season of Discovery excluded).
-- Chain order and objectives: CMaNGOS classic-db 1.12.1.

local classAttunes = {
    -- DRUID
	{ID="5103",NAME="Bear Form",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Alliance",ICON="Interface\\Icons\\ability_racial_bearform", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5104",NAME="Bear Form",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Horde",ICON="Interface\\Icons\\ability_racial_bearform", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5105",NAME="Cure Poison",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Alliance",ICON="Interface\\Icons\\spell_nature_nullifypoison", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="14"},
	{ID="5106",NAME="Cure Poison",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Horde",ICON="Interface\\Icons\\spell_nature_nullifypoison", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="14"},
	{ID="5107",NAME="Aquatic Form",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Alliance",ICON="Interface\\Icons\\ability_druid_aquaticform", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="16"},
	{ID="5108",NAME="Aquatic Form",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Horde",ICON="Interface\\Icons\\ability_druid_aquaticform", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="16"},
	{ID="5297",NAME="Cat Form",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Alliance",ICON="Interface\\Icons\\ability_druid_catform", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5298",NAME="Cat Form",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Horde",ICON="Interface\\Icons\\ability_druid_catform", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5109",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_DRUID"], CLASS="DRUID", FACTION="Both",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},

    -- HUNTER
	{ID="5115",NAME="Taming",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_HUNTER"], CLASS="HUNTER", FACTION="Alliance",ICON="Interface\\Icons\\ability_hunter_beasttaming", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5117",NAME="Taming",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_HUNTER"], CLASS="HUNTER", FACTION="Horde",ICON="Interface\\Icons\\ability_hunter_beasttaming", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5119",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_HUNTER"], CLASS="HUNTER", FACTION="Both",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	{ID="5120",NAME="Rhok'delar",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_HUNTER"], CLASS="HUNTER", FACTION="Both",ICON="Interface\\Icons\\inv_weapon_bow_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="60"},
	
    -- MAGE
	{ID="5128",NAME="Spell Focus",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_orb_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5127",NAME="Spell Focus",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Horde",ICON="Interface\\Icons\\inv_misc_orb_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5131",NAME="Manaweave Robe",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Alliance",ICON="Interface\\Icons\\inv_chest_cloth_36", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="15"},
	{ID="5132",NAME="Spellfire Robes",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Horde",ICON="Interface\\Icons\\inv_chest_cloth_18", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="15"},
	{ID="5133",NAME="Astral Knot Garment",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Alliance",ICON="Interface\\Icons\\inv_chest_cloth_04", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="26-28"},
	{ID="5134",NAME="Nether-lace Garment",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Horde",ICON="Interface\\Icons\\inv_chest_cloth_20", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="26"},
	{ID="5136",NAME="Mage's Wand",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Both",ICON="Interface\\Icons\\inv_wand_09", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="30"},
	{ID="5137",NAME="Celestial Power",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Both",ICON="Interface\\Icons\\inv_misc_orb_03", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="35"},
	{ID="5138",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Both",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	{ID="5139",NAME="Polymorph: Pig",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_MAGE"], CLASS="MAGE", FACTION="Both",ICON="Interface\\Icons\\spell_magic_polymorphpig", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="60"},
	
    -- -- PALADIN
	{ID="5144",NAME="Redemption",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PALADIN"], CLASS="PALADIN", FACTION="Alliance",ICON="Interface\\Icons\\spell_holy_resurrection", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="12"},
	{ID="5145",NAME="Redemption",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PALADIN"], CLASS="PALADIN", FACTION="Horde",ICON="Interface\\Icons\\spell_holy_resurrection", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="12"},
	{ID="5149",NAME="Verigan's Fist",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PALADIN"], CLASS="PALADIN", FACTION="Alliance",ICON="Interface\\Icons\\inv_hammer_05", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5158",NAME="Wolfsbane",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PALADIN"], CLASS="PALADIN", FACTION="Horde",ICON="Interface\\Icons\\inv_sword_25", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5152",NAME="Warhorse",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PALADIN"], CLASS="PALADIN", FACTION="Alliance",ICON="Interface\\Icons\\spell_nature_swiftness", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="40"},
	{ID="5155",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PALADIN"], CLASS="PALADIN", FACTION="Alliance",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	{ID="5156",NAME="Charger",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PALADIN"], CLASS="PALADIN", FACTION="Alliance",ICON="Interface\\Icons\\ability_mount_charger", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="60"},
	
    -- -- PRIEST
	{ID="5164",NAME="Garments of the priest",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Horde",ICON="Interface\\Icons\\inv_chest_cloth_04", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="5"},
	{ID="5166",NAME="Garments of the priest",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Alliance",ICON="Interface\\Icons\\inv_chest_cloth_04", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="5"},
	-- {ID="5169",NAME="Desperate Prayer",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Alliance",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	-- {ID="5176",NAME="Hex of Weakness",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Horde",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	-- {ID="5181",NAME="Stars of Elune",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Alliance",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	-- {ID="5182",NAME="Touch of Weakness",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Horde",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	-- {ID="5187",NAME="A Lack of Fear",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Alliance",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	-- {ID="5190",NAME="Arcane Feedback",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Alliance",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	-- {ID="5193",NAME="Devouring Plague",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Horde",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	-- {ID="5196",NAME="Elune's Grace",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Alliance",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	-- {ID="5200",NAME="Shadowguard",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Horde",ICON="Interface\\Icons\\spell_holy_wordfortitude", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5203",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Both",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	{ID="5205",NAME="Benediction",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_PRIEST"], CLASS="PRIEST", FACTION="Both",ICON="Interface\\Icons\\inv_staff_30", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="60"},

    -- -- ROGUE
	{ID="5213",NAME="Blade of Cunning",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Alliance",ICON="Interface\\Icons\\inv_weapon_shortblade_26", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5217",NAME="Blade of Cunning",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Horde",ICON="Interface\\Icons\\inv_weapon_shortblade_26", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5222",NAME="Thieves' Tools",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Horde",ICON="Interface\\Icons\\inv_misc_gear_03", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="16"},
	{ID="5220",NAME="Certificate of Thievery",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_note_02", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="16"},
	{ID="5221",NAME="Polly",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Horde",ICON="Interface\\Icons\\inv_drink_milk_05", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="16"},
	{ID="5223",NAME="Poisons",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Horde",ICON="Interface\\Icons\\trade_brewpoison", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5224",NAME="Poisons",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Alliance",ICON="Interface\\Icons\\trade_brewpoison", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5225",NAME="Ravenholdt",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Both",ICON="Interface\\Icons\\inv_throwingknife_03", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="24"},
	{ID="5226",NAME="Junkboxes Needed",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Both",ICON="Interface\\Icons\\inv_box_03", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	{ID="5227",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_ROGUE"], CLASS="ROGUE", FACTION="Both",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	
    -- -- SHAMAN
    -- {ID="5230",NAME="A Humble Task",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\inv_drink_08", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="1"},
	{ID="5231",NAME="Call of Earth",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\inv_elemental_primal_earth", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="4"},
	{ID="5242",NAME="Call of Earth",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Alliance",ICON="Interface\\Icons\\inv_elemental_primal_earth", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="4"},
	{ID="5233",NAME="Call of Fire",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\inv_elemental_primal_fire", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5243",NAME="Call of Fire",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Alliance",ICON="Interface\\Icons\\inv_elemental_primal_fire", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5234",NAME="Call of Water",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\inv_elemental_primal_water", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5244",NAME="Call of Water",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Alliance",ICON="Interface\\Icons\\inv_elemental_primal_water", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5235",NAME="Call of Air",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\inv_elemental_primal_air", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="30"},
	{ID="5245",NAME="Call of Air",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Alliance",ICON="Interface\\Icons\\inv_elemental_primal_air", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="30"},
	-- {ID="5236",NAME="Call of Air (1531)",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\inv_elemental_primal_air", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="30"},
	{ID="5239",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Alliance",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
    {ID="5237",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	-- {ID="5238",NAME="A More Fitting Reward",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\spell_nature_lightning", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="58-60"},
	-- {ID="5239",NAME="Again Into the Great Ossuary",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\spell_nature_lightning", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="58-60"},
	-- {ID="5240",NAME="The Darkreaver Menace",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\spell_nature_lightning", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="58-60"},
	-- {ID="5241",NAME="The Darkreaver Menace (Material Assistance)",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_SHAMAN"], CLASS="SHAMAN", FACTION="Horde",ICON="Interface\\Icons\\spell_nature_lightning", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="58-60"},
	
    -- -- WARLOCK
	{ID="5252",NAME="Voidwalker",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Alliance",ICON="Interface\\Icons\\spell_shadow_summonvoidwalker", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5253",NAME="Voidwalker",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Horde",ICON="Interface\\Icons\\spell_shadow_summonvoidwalker", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5257",NAME="Succubus",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Alliance",ICON="Interface\\Icons\\spell_shadow_summonsuccubus", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5258",NAME="Incubus",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Alliance",ICON="Interface\\Icons\\ability_warlock_incubus", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5261",NAME="Succubus",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Horde",ICON="Interface\\Icons\\spell_shadow_summonsuccubus", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5259",NAME="Incubus",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Horde",ICON="Interface\\Icons\\ability_warlock_incubus", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5263",NAME="The Orb of Soran'ruk",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Both",ICON="Interface\\Icons\\inv_misc_orb_03", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5266",NAME="Felhunter",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Alliance",ICON="Interface\\Icons\\spell_shadow_summonfelhunter", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="30"},
	{ID="5267",NAME="Felhunter",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Horde",ICON="Interface\\Icons\\spell_shadow_summonfelhunter", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="30"},
	{ID="5268",NAME="Gold Bloodrobe",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Alliance",ICON="Interface\\Icons\\inv_chest_cloth_25", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="31"},
	{ID="5269",NAME="Gold Bloodrobe",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Horde",ICON="Interface\\Icons\\inv_chest_cloth_25", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="31"},
	{ID="5270",NAME="The Orb of Dar'Orahil",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Alliance",ICON="Interface\\Icons\\inv_misc_orb_03", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="35"},
	{ID="5271",NAME="The Orb of Dar'Orahil",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Horde",ICON="Interface\\Icons\\inv_misc_orb_03", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="35"},
	{ID="5272",NAME="Felsteed",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Alliance",ICON="Interface\\Icons\\spell_nature_swiftness", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="40"},
	{ID="5273",NAME="Felsteed",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Horde",ICON="Interface\\Icons\\spell_nature_swiftness", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="40"},
	{ID="5274",NAME=FTAttuneLang["Infernal"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Both",ICON="Interface\\Icons\\spell_shadow_summoninfernal", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	{ID="5275",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Both",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	{ID="5276",NAME="Dreadsteed of Xoroth",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Both",ICON="Interface\\Icons\\ability_mount_dreadsteed", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="60"},
	{ID="5277",NAME=FTAttuneLang["Doomguard"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARLOCK"], CLASS="WARLOCK", FACTION="Both",ICON="Interface\\Icons\\spell_shadow_antimagicshell", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="60"},
	
    -- -- WARRIOR
	{ID="5287",NAME="Defensive Stance",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARRIOR"], CLASS="WARRIOR", FACTION="Horde",ICON="Interface\\Icons\\ability_warrior_defensivestance", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5288",NAME="Defensive Stance",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARRIOR"], CLASS="WARRIOR", FACTION="Alliance",ICON="Interface\\Icons\\ability_warrior_defensivestance", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="10"},
	{ID="5291",NAME="Brutal Armor",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARRIOR"], CLASS="WARRIOR", FACTION="Horde",ICON="Interface\\Icons\\inv_chest_chain_07", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5292",NAME="Fire Hardened Armor",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARRIOR"], CLASS="WARRIOR", FACTION="Alliance",ICON="Interface\\Icons\\ability_warrior_savageblow", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="20"},
	{ID="5293",NAME="Berserker Stance",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARRIOR"], CLASS="WARRIOR", FACTION="Both",ICON="Interface\\Icons\\ability_racial_avatar", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="30"},
	{ID="5294",NAME=FTAttuneLang["Sunken Temple"],EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARRIOR"], CLASS="WARRIOR", FACTION="Both",ICON="Interface\\Icons\\spell_nature_acid_01", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=1, LEVELS="50"},
	-- {ID="5296",NAME="Codex of Defense",EXPAC=FTAttuneLang["World of Warcraft"], GROUP=FTAttuneLang["CLASS_WARRIOR"], CLASS="WARRIOR", FACTION="Both",ICON="Interface\\Icons\\ability_warrior_savageblow", DESC=FTAttuneLang["ClassQuest_Desc"], GROUPSIZE=5, LEVELS="60"},
}

local classSteps = {
    -- DRUID
	{ID_ATTUNE="5103",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Columns left to right (higher ID = left): Skyborne | Heeding the Call. Spacers keep that column down to End.
	{ID_ATTUNE="5103",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5923",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Heeding the Call
	{ID_ATTUNE="5103",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5924",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Heeding the Call
	{ID_ATTUNE="5103",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5925",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Heeding the Call
	{ID_ATTUNE="5103",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Zephras Isle"],ID_WOWHEAD="94006",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Great Ursera Spirit
	{ID_ATTUNE="5103",ID="29",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5103",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5921",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20|22",STAGE="30"}, -- Moonglade
	{ID_ATTUNE="5103",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5103",ID="33",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Zephras Isle"],ID_WOWHEAD="94638",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="23",STAGE="30"}, -- Strength and Mercy
	{ID_ATTUNE="5103",ID="39",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5103",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5929",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Great Bear Spirit
	{ID_ATTUNE="5103",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5103",ID="43",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="33",STAGE="40"},
	{ID_ATTUNE="5103",ID="49",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5103",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5931",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Back to Darnassus
	{ID_ATTUNE="5103",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5103",ID="53",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="43",STAGE="50"},
	{ID_ATTUNE="5103",ID="59",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5103",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6001",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Body and Heart
	{ID_ATTUNE="5103",ID="61",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5103",ID="63",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="53",STAGE="60"},
	{ID_ATTUNE="5103",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="60|63",STAGE="70"},

	{ID_ATTUNE="5104",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Columns left to right (higher ID = left): Skyborne | Heeding the Call. Spacers keep that column down to End.
	{ID_ATTUNE="5104",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="5926",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Heeding the Call
	{ID_ATTUNE="5104",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5927",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Heeding the Call
	{ID_ATTUNE="5104",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="5928",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Heeding the Call
	{ID_ATTUNE="5104",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Zephras Isle"],ID_WOWHEAD="94006",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Great Ursera Spirit
	{ID_ATTUNE="5104",ID="29",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5104",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5922",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="22|21|20",STAGE="30"}, -- Moonglade
	{ID_ATTUNE="5104",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5104",ID="33",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Zephras Isle"],ID_WOWHEAD="94638",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="23",STAGE="30"}, -- Strength and Mercy
	{ID_ATTUNE="5104",ID="39",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5104",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="5930",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Great Bear Spirit
	{ID_ATTUNE="5104",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5104",ID="43",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="33",STAGE="40"},
	{ID_ATTUNE="5104",ID="49",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5104",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="5932",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Back to Thunder Bluff
	{ID_ATTUNE="5104",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5104",ID="53",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="43",STAGE="50"},
	{ID_ATTUNE="5104",ID="59",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5104",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="6002",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Body and Heart
	{ID_ATTUNE="5104",ID="61",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5104",ID="63",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="53",STAGE="60"},
	{ID_ATTUNE="5104",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="60|63",STAGE="70"},

	{ID_ATTUNE="5105",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 14",LOCATION="",ID_WOWHEAD="14",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5105",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="6121",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Lessons Anew
	{ID_ATTUNE="5105",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="6122",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Principal Source
	{ID_ATTUNE="5105",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="6123",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Gathering the Cure
	{ID_ATTUNE="5105",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="6124",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Curing the Sick
	{ID_ATTUNE="5105",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6125",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Power over Poison
	{ID_ATTUNE="5105",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5106",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 14",LOCATION="",ID_WOWHEAD="14",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5106",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="6126",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Lessons Anew
	{ID_ATTUNE="5106",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="6127",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Principal Source
	{ID_ATTUNE="5106",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="6128",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Gathering the Cure
	{ID_ATTUNE="5106",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="6129",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Curing the Sick
	{ID_ATTUNE="5106",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="6130",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Power over Poison
	{ID_ATTUNE="5106",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5107",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 16",LOCATION="",ID_WOWHEAD="16",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5107",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="26",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- A Lesson to Learn
	{ID_ATTUNE="5107",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="29",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Trial of the Lake
	{ID_ATTUNE="5107",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="272",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Trial of the Sea Lion
	{ID_ATTUNE="5107",ID="45",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="15883",ICON="Interface\\Icons\\inv_jewelry_talisman_08",FOLLOWS="40",STAGE="45"}, -- Half Pendant of Aquatic Agility
	{ID_ATTUNE="5107",ID="46",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="15882",ICON="Interface\\Icons\\inv_jewelry_talisman_07",FOLLOWS="40",STAGE="45"}, -- Half Pendant of Aquatic Endurance
	{ID_ATTUNE="5107",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5061",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45&46",STAGE="50"}, -- Aquatic Form
	{ID_ATTUNE="5107",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5108",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 16",LOCATION="",ID_WOWHEAD="16",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5108",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="27",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- A Lesson to Learn
	{ID_ATTUNE="5108",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="28",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Trial of the Lake
	{ID_ATTUNE="5108",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="30",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Trial of the Sea Lion
	{ID_ATTUNE="5108",ID="45",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="15883",ICON="Interface\\Icons\\inv_jewelry_talisman_08",FOLLOWS="40",STAGE="45"}, -- Half Pendant of Aquatic Agility
	{ID_ATTUNE="5108",ID="46",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="15882",ICON="Interface\\Icons\\inv_jewelry_talisman_07",FOLLOWS="40",STAGE="45"}, -- Half Pendant of Aquatic Endurance
	{ID_ATTUNE="5108",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="31",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45&46",STAGE="50"}, -- Aquatic Form
	{ID_ATTUNE="5108",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5297",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5297",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="98393",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Great Cat Spirit
	{ID_ATTUNE="5297",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98394",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30", OR=true}, -- The Great Cat Spirit
	{ID_ATTUNE="5297",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98341",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30", OR=true}, -- The Great Windborne Cat Spirit
	{ID_ATTUNE="5297",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98396",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Great Cat Spirit
	{ID_ATTUNE="5297",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98404",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- The Great Windborne Cat Spirit
	{ID_ATTUNE="5297",ID="45",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="280502",ICON="Interface\\Icons\\inv_misc_monsterfang_01",FOLLOWS="40|41",STAGE="45"}, -- Relic of the Fang
	{ID_ATTUNE="5297",ID="46",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="280679",ICON="Interface\\Icons\\inv_misc_monsterclaw_01",FOLLOWS="40|41",STAGE="45"}, -- Relic of the Claw
	{ID_ATTUNE="5297",ID="47",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="280680",ICON="Interface\\Icons\\ability_druid_eclipse",FOLLOWS="40|41",STAGE="45"}, -- Relic of the Silent Shadow
	{ID_ATTUNE="5297",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98731",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45&46&47",STAGE="50"}, -- Blessings of the Great Cat Spirit
	{ID_ATTUNE="5297",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98738",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45&46&47",STAGE="50"}, -- Blessings of the Great Windborne Cat Spirit
	{ID_ATTUNE="5297",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="98397",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50|51",STAGE="60"}, -- To Darnassus
	{ID_ATTUNE="5297",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_catform",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5298",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5298",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="98340",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Great Cat Spirit
	{ID_ATTUNE="5298",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98405",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30", OR=true}, -- The Great Cat Spirit
	{ID_ATTUNE="5298",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98341",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30", OR=true}, -- The Great Windborne Cat Spirit
	{ID_ATTUNE="5298",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98342",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Great Cat Spirit
	{ID_ATTUNE="5298",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98404",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- The Great Windborne Cat Spirit
	{ID_ATTUNE="5298",ID="45",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="280502",ICON="Interface\\Icons\\inv_misc_monsterfang_01",FOLLOWS="40|41",STAGE="45"}, -- Relic of the Fang
	{ID_ATTUNE="5298",ID="46",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="280679",ICON="Interface\\Icons\\inv_misc_monsterclaw_01",FOLLOWS="40|41",STAGE="45"}, -- Relic of the Claw
	{ID_ATTUNE="5298",ID="47",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="280680",ICON="Interface\\Icons\\ability_druid_eclipse",FOLLOWS="40|41",STAGE="45"}, -- Relic of the Silent Shadow
	{ID_ATTUNE="5298",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98739",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45&46&47",STAGE="50"}, -- Blessings of the Great Cat Spirit
	{ID_ATTUNE="5298",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Moonglade"],ID_WOWHEAD="98738",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45&46&47",STAGE="50"}, -- Blessings of the Great Windborne Cat Spirit
	{ID_ATTUNE="5298",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="98362",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50|51",STAGE="60"}, -- To Thunder Bluff
	{ID_ATTUNE="5298",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_catform",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5109",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5109",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Un'Goro Crater"],ID_WOWHEAD="9063",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Torwa Pathfinder
	{ID_ATTUNE="5109",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Un'Goro Crater"],ID_WOWHEAD="9052",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Bloodpetal Poison
	{ID_ATTUNE="5109",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Un'Goro Crater"],ID_WOWHEAD="9051",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Toxic Test
    {ID_ATTUNE="5109",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Un'Goro Crater"],ID_WOWHEAD="9053",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- A Better Ingredient
	{ID_ATTUNE="5109",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="22444",ICON="Interface\\Icons\\ability_creature_poison_04",FOLLOWS="50",STAGE="60"}, -- Putrid Vine
	{ID_ATTUNE="5109",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Un'Goro Crater"],ID_WOWHEAD="9053",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- A Better Ingredient
	{ID_ATTUNE="5109",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="70",STAGE="80"},

	{ID_ATTUNE="5295",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5295",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="7506",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Emerald Dream...
	{ID_ATTUNE="5295",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_druid_maul",FOLLOWS="20",STAGE="30"},


    -- HUNTER
	{ID_ATTUNE="5115",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Dwarf: The Hunter's Path (any one) → Grif Wildheart in Kharanos
	{ID_ATTUNE="5115",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="6074",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5115",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="6075",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5115",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="6076",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	-- Night elf: The Hunter's Path (any one) → Dazalar in Dolanaar
	{ID_ATTUNE="5115",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6071",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5115",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6072",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5115",ID="25",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6073",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5115",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="6064",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="25|24|23|22|21|20",STAGE="30"}, -- Taming the Beast (Large Crag Boar)
    {ID_ATTUNE="5115",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
    {ID_ATTUNE="5115",ID="32",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5115",ID="33",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6063",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="25|24|23|22|21|20",STAGE="30"}, -- Taming the Beast (Webwood Lurker)
	{ID_ATTUNE="5115",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="6084",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="33|30",STAGE="40"}, -- Taming the Beast (Snow Leopard)
    {ID_ATTUNE="5115",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="5115",ID="42",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="5115",ID="43",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6101",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="33|30",STAGE="40"}, -- Taming the Beast (Nightsaber Stalker)
	{ID_ATTUNE="5115",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="6085",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="43|40",STAGE="50"}, -- Taming the Beast (Ice Claw Bear)
    {ID_ATTUNE="5115",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    {ID_ATTUNE="5115",ID="52",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5115",ID="53",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="6102",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="43|40",STAGE="50"}, -- Taming the Beast (Strigid Screecher)
	{ID_ATTUNE="5115",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="6086",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="53|50",STAGE="60"}, -- Training the Beast (Belia Thundergranite)
    {ID_ATTUNE="5115",ID="61",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="5115",ID="62",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5115",ID="63",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="6103",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="53|50",STAGE="60"}, -- Training the Beast (Jocaste)
	{ID_ATTUNE="5115",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_weapon_bow_07",FOLLOWS="63|60",STAGE="70"},

	{ID_ATTUNE="5117",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Tauren: The Hunter's Path (any one) → Yaw Sharpmane in Bloodhoof Village
	{ID_ATTUNE="5117",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="6065",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5117",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="6066",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5117",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="6067",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	-- Orc/Troll: The Hunter's Path (any one) → Thotar at Razor Hill
	{ID_ATTUNE="5117",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="6068",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5117",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="6069",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5117",ID="25",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="6070",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Hunter's Path
	{ID_ATTUNE="5117",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="6061",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="22|21|20",STAGE="30"}, -- Taming the Beast (Adult Plainstrider)
    {ID_ATTUNE="5117",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
    {ID_ATTUNE="5117",ID="32",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5117",ID="33",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="6062",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="25|24|23",STAGE="30"}, -- Taming the Beast (Dire Mottled Boar)
	{ID_ATTUNE="5117",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="6087",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Taming the Beast (Prairie Stalker)
    {ID_ATTUNE="5117",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
    {ID_ATTUNE="5117",ID="42",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5117",ID="43",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="6083",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="33",STAGE="40"}, -- Taming the Beast (Surf Crawler)
	{ID_ATTUNE="5117",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="6088",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Taming the Beast (Swoop)
    {ID_ATTUNE="5117",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    {ID_ATTUNE="5117",ID="52",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5117",ID="53",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="6082",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="43",STAGE="50"}, -- Taming the Beast (Armored Scorpid)
	{ID_ATTUNE="5117",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="6089",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Training the Beast (Holt Thunderhorn)
    {ID_ATTUNE="5117",ID="61",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="5117",ID="62",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5117",ID="63",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="6081",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="53",STAGE="60"}, -- Training the Beast (Ormak Grimshot)
	{ID_ATTUNE="5117",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_weapon_bow_07",FOLLOWS="63|60",STAGE="70"},

	{ID_ATTUNE="5119",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5119",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8151",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Hunter's Charm
	{ID_ATTUNE="5119",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8153",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Courser Antlers
	{ID_ATTUNE="5119",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8231",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Wavethrashing
	{ID_ATTUNE="5119",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8232",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- The Green Drake
	{ID_ATTUNE="5119",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20019",ICON="Interface\\Icons\\inv_misc_monsterfang_01",FOLLOWS="50",STAGE="60"}, -- Took of Morphaz
	{ID_ATTUNE="5119",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8232",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- The Green Drake
	{ID_ATTUNE="5119",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_monsterfang_01",FOLLOWS="70",STAGE="80"},

	{ID_ATTUNE="5120",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5120",ID="20",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="18703",ICON="Interface\\Icons\\spell_nature_resistnature",FOLLOWS="10",STAGE="20"}, -- item: Ancient Petrified Leaf
	{ID_ATTUNE="5120",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7632",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Ancient Leaf
	{ID_ATTUNE="5120",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7633",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- An Introduction
	-- Columns left to right (higher ID = left): Lamina | blank | Stave | blank | A Proper String
	{ID_ATTUNE="5120",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7635",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- A Proper String
	{ID_ATTUNE="5120",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5120",ID="52",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7636",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Stave of the Ancients
	{ID_ATTUNE="5120",ID="53",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5120",ID="54",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7634",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Ancient Sinew Wrapped Lamina

    {ID_ATTUNE="5120",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Onyxia's Lair"],ID_WOWHEAD="18705",ICON="Interface\\Icons\\spell_holy_dispelmagic",FOLLOWS="50",STAGE="60"}, -- item: Mature Black Dragon Sinew
	{ID_ATTUNE="5120",ID="61",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5120",ID="62",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="52",STAGE="60"},
	{ID_ATTUNE="5120",ID="63",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5120",ID="64",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="18704",ICON="Interface\\Icons\\inv_misc_bandage_04",FOLLOWS="54",STAGE="60"}, -- item: Mature Blue Dragon Sinew

    {ID_ATTUNE="5120",ID="80",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7635",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="65"}, -- A Proper String
	{ID_ATTUNE="5120",ID="81",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="65"},
    {ID_ATTUNE="5120",ID="82",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="62",STAGE="65"},
	-- {ID_ATTUNE="5120",ID="82",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7636",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="73&72&71&70",STAGE="80"}, -- Stave of the Ancients
	{ID_ATTUNE="5120",ID="83",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="65"},
	{ID_ATTUNE="5120",ID="84",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7634",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="64",STAGE="65"}, -- Ancient Sinew Wrapped Lamina
	
	-- Four heads on one row (higher ID = left): Simone, Klinfran, Solenor, Artorius
	{ID_ATTUNE="5120",ID="70",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="18955",ICON="Interface\\Icons\\spell_shadow_summonvoidwalker",FOLLOWS="82",STAGE="70"}, -- item: Artorius's Head
	{ID_ATTUNE="5120",ID="71",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Silithus"],ID_WOWHEAD="18954",ICON="Interface\\Icons\\spell_shadow_summonvoidwalker",FOLLOWS="82",STAGE="70"}, -- item: Solenor's Head
	{ID_ATTUNE="5120",ID="72",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="18953",ICON="Interface\\Icons\\spell_shadow_summonvoidwalker",FOLLOWS="82",STAGE="70"}, -- item: Klinfran's Head
	{ID_ATTUNE="5120",ID="73",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Un'Goro Crater"],ID_WOWHEAD="18952",ICON="Interface\\Icons\\spell_shadow_summonsuccubus",FOLLOWS="82",STAGE="70"}, -- item: Simone's Head

    -- {ID_ATTUNE="5120",ID="90",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7635",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="80"}, -- A Proper String
    {ID_ATTUNE="5120",ID="90",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="80",STAGE="80"},
	{ID_ATTUNE="5120",ID="91",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="5120",ID="92",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7636",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="73&72&71&70",STAGE="80"}, -- Stave of the Ancients
	{ID_ATTUNE="5120",ID="93",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
    {ID_ATTUNE="5120",ID="94",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="84",STAGE="80"},
	-- {ID_ATTUNE="5120",ID="94",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7634",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="64",STAGE="80"}, -- Ancient Sinew Wrapped Lamina
	{ID_ATTUNE="5120",ID="100",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_weapon_bow_07",FOLLOWS="94&92&90",STAGE="90"},


    -- MAGE
	{ID_ATTUNE="5128",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5128",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1860",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20",OR=true}, -- Speak with Jennea
	{ID_ATTUNE="5128",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1879",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20",OR=true}, -- Speak with Bink
	{ID_ATTUNE="5128",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Zephras Isle"],ID_WOWHEAD="93791",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20",OR=true}, -- Speak with Belann
	{ID_ATTUNE="5128",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1861",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Mirror Lake
	{ID_ATTUNE="5128",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1880",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Mage-tastic Gizmonitor
	{ID_ATTUNE="5128",ID="32",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Zephras Isle"],ID_WOWHEAD="93797",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="22",STAGE="30"}, -- Boughs in the Wind
	{ID_ATTUNE="5128",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_staff_13",FOLLOWS="32|31|30",STAGE="40"},

	{ID_ATTUNE="5127",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5127",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1881",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20",OR=true}, -- Speak with Anastasia
	{ID_ATTUNE="5127",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1883",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20",OR=true}, -- Speak with Un'thuwa
	{ID_ATTUNE="5127",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1882",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Balnir Farmstead
	{ID_ATTUNE="5127",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1884",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Ju-Ju Heaps
	{ID_ATTUNE="5127",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_staff_13",FOLLOWS="31|30",STAGE="40"},

	{ID_ATTUNE="5131",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 15",LOCATION="",ID_WOWHEAD="15",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5131",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1919",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Report to Jennea
	{ID_ATTUNE="5131",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1920",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Investigate the Blue Recluse
	{ID_ATTUNE="5131",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1921",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Gathering Materials
	{ID_ATTUNE="5131",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1941",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Manaweave Robe
	{ID_ATTUNE="5131",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_36",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5132",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 15",LOCATION="",ID_WOWHEAD="15",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5132",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1959",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Report to Anastasia
	{ID_ATTUNE="5132",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1960",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Investigate the Alchemist Shop
	{ID_ATTUNE="5132",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1961",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Gathering Materials
	{ID_ATTUNE="5132",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1962",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Spellfire Robes
	{ID_ATTUNE="5132",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_18",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5133",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 26",LOCATION="",ID_WOWHEAD="26",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5133",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1939",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- High Sorcerer Andromath
	{ID_ATTUNE="5133",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1938",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Ur's Treatise on Shadow Magic
	{ID_ATTUNE="5133",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1940",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Pristine Spider Silk
	{ID_ATTUNE="5133",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1942",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Astral Knot Garment
	{ID_ATTUNE="5133",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_04",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5134",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 26",LOCATION="",ID_WOWHEAD="26",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5134",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1943",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Speak with Deino
	{ID_ATTUNE="5134",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1944",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Waters of Xavian
	{ID_ATTUNE="5134",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1945",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Laughing Sisters
	{ID_ATTUNE="5134",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1946",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Nether-lace Garment
	{ID_ATTUNE="5134",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_20",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5136",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5136",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1947",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Journey to the Marsh
	{ID_ATTUNE="5136",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1948",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Items of Power
	{ID_ATTUNE="5136",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1949",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Hidden Secrets
	{ID_ATTUNE="5136",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1950",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Get the Scoop
	{ID_ATTUNE="5136",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1951",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Rituals of Power
	{ID_ATTUNE="5136",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1952",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Mage's Wand
	{ID_ATTUNE="5136",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_wand_09",FOLLOWS="70",STAGE="80"},

	{ID_ATTUNE="5137",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 35",LOCATION="",ID_WOWHEAD="35",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5137",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1953",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Return to the Marsh
	{ID_ATTUNE="5137",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1954",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Infernal Orb
	{ID_ATTUNE="5137",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1955",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Exorcism
	{ID_ATTUNE="5137",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1956",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Power in Uldaman
	{ID_ATTUNE="5137",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1957",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Mana Surges
	{ID_ATTUNE="5137",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1958",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Celestial Power
	{ID_ATTUNE="5137",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_orb_03",FOLLOWS="70",STAGE="80"},

	{ID_ATTUNE="5138",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5138",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8250",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Magecraft
	{ID_ATTUNE="5138",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8251",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Magic Dust
	{ID_ATTUNE="5138",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8252",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Siren's Coral
	{ID_ATTUNE="5138",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8253",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Destroy Morphaz
	{ID_ATTUNE="5138",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20085",ICON="Interface\\Icons\\inv_misc_gem_topaz_03",FOLLOWS="50",STAGE="60"}, -- Arcane Shard
	{ID_ATTUNE="5138",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8253",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Destroy Morphaz
	{ID_ATTUNE="5138",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_gem_topaz_03",FOLLOWS="70",STAGE="80"},

	{ID_ATTUNE="5139",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5139",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="9362",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Warlord Krellian
	{ID_ATTUNE="5139",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="9364",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Fragmented Magic
	{ID_ATTUNE="5139",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_magic_polymorphpig",FOLLOWS="30",STAGE="40"},


    -- PALADIN
	-- Dwarf | Human (any one)
	{ID_ATTUNE="5142",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 12",LOCATION="",ID_WOWHEAD="12",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5142",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1790",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Symbol of Life
	{ID_ATTUNE="5142",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1789",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Symbol of Life
	{ID_ATTUNE="5142",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_sealofmight",FOLLOWS="21|20",STAGE="30"},

	-- Dwarf (left) or Human (right). Either chain teaches Redemption.
	-- 1642 needs quest 1641 and the Tome it rewards (6775). 1646 needs quest 1645 and item 6916.
	{ID_ATTUNE="5144",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 12",LOCATION="",ID_WOWHEAD="12",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5144",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2998",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Tome of Divinity
	{ID_ATTUNE="5144",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="3681",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Tome of Divinity
	{ID_ATTUNE="5144",ID="22",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="5144",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="3000",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Tome of Divinity
	{ID_ATTUNE="5144",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="2999",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Tome of Divinity
	{ID_ATTUNE="5144",ID="25",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2997",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Tome of Divinity
	{ID_ATTUNE="5144",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1641",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5144",ID="32",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5144",ID="33",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1645",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="25|24|23",STAGE="30"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="40",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="6775",ICON="Interface\\Icons\\inv_misc_book_07",FOLLOWS="30",STAGE="40"}, -- Tome of Divinity
	{ID_ATTUNE="5144",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5144",ID="42",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5144",ID="43",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="6916",ICON="Interface\\Icons\\inv_misc_book_07",FOLLOWS="33",STAGE="40"}, -- Tome of Divinity
	{ID_ATTUNE="5144",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1642",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30&40",STAGE="50"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5144",ID="52",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5144",ID="53",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1646",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="33&43",STAGE="50"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1643",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="61",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5144",ID="62",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5144",ID="63",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1647",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="53",STAGE="60"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1644",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="71",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="5144",ID="72",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="5144",ID="73",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1648",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="63",STAGE="70"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1780",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="81",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="5144",ID="82",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="5144",ID="83",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1778",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="73",STAGE="80"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="90",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1781",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="91",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	{ID_ATTUNE="5144",ID="92",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="90"},
	{ID_ATTUNE="5144",ID="93",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1779",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="83",STAGE="90"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1786",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="101",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1790",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- The Symbol of Life
	{ID_ATTUNE="5144",ID="102",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1789",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="93",STAGE="100"}, -- The Symbol of Life
	{ID_ATTUNE="5144",ID="103",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1783",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="93",STAGE="100"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="110",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1787",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="100&101",STAGE="110"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="111",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="110"},
	{ID_ATTUNE="5144",ID="112",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="110"},
	{ID_ATTUNE="5144",ID="113",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1784",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="103&102",STAGE="110"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1788",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="120"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="121",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="120"},
	{ID_ATTUNE="5144",ID="122",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="120"},
	{ID_ATTUNE="5144",ID="123",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1785",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="113",STAGE="120"}, -- The Tome of Divinity
	{ID_ATTUNE="5144",ID="130",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_resurrection",FOLLOWS="120|123",STAGE="130"},

	-- Forsaken. 94434 through 94441 teaches Redemption.
	{ID_ATTUNE="5145",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 12",LOCATION="",ID_WOWHEAD="12",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5145",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="94434",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- A Lesson in Divinity
	{ID_ATTUNE="5145",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="94435",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- A Lesson in Divinity
	{ID_ATTUNE="5145",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="94436",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- A Lesson in Divinity
	{ID_ATTUNE="5145",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="94438",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- A Lesson in Divinity
	{ID_ATTUNE="5145",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="94440",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- A Lesson in Divinity
	{ID_ATTUNE="5145",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="94441",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- A Lesson in Divinity
	{ID_ATTUNE="5145",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_resurrection",FOLLOWS="70",STAGE="80"},

	-- 1793 or 1794, then 1649 > 1650 > 1651 > 1652 > 1653.
	-- Pick up 1654, gather its four materials, turn it in, then 1806.
	-- Left to right on the materials: ore quest, Kor gem quest, smithing hammer, whitestone lumber.
	{ID_ATTUNE="5149",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5149",ID="15",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1793",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="15", OR=true}, -- The Tome of Valor
	{ID_ATTUNE="5149",ID="16",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1794",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="15", OR=true}, -- The Tome of Valor
	{ID_ATTUNE="5149",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1649",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="16|15",STAGE="20"}, -- The Tome of Valor
	{ID_ATTUNE="5149",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="1650",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Tome of Valor
	{ID_ATTUNE="5149",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="1651",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Tome of Valor
	{ID_ATTUNE="5149",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1652",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- The Tome of Valor
	{ID_ATTUNE="5149",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1653",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Test of Righteousness
	{ID_ATTUNE="5149",ID="65",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1654",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="65"}, -- The Test of Righteousness
	{ID_ATTUNE="5149",ID="70",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="6994",ICON="Interface\\Icons\\inv_tradeskillitem_01",FOLLOWS="65",STAGE="70"}, -- Whitestone Oak Lumber
	{ID_ATTUNE="5149",ID="71",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="6895",ICON="Interface\\Icons\\inv_hammer_09",FOLLOWS="65",STAGE="70"}, -- Jordan's Smithing Hammer
	{ID_ATTUNE="5149",ID="72",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="1442",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="65",STAGE="70"}, -- Seeking the Kor Gem
	{ID_ATTUNE="5149",ID="73",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="1655",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="65",STAGE="70"}, -- Bailor's Ore Shipment
	{ID_ATTUNE="5149",ID="80",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="70",STAGE="80"},
	{ID_ATTUNE="5149",ID="81",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="71",STAGE="80"},
	{ID_ATTUNE="5149",ID="82",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="7083",ICON="Interface\\Icons\\inv_misc_gem_sapphire_02",FOLLOWS="72",STAGE="80"}, -- Purified Kor Gem
	{ID_ATTUNE="5149",ID="83",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="6993",ICON="Interface\\Icons\\inv_crate_01",FOLLOWS="73",STAGE="80"}, -- Jordan's Refined Ore Shipment
	{ID_ATTUNE="5149",ID="90",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1654",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="83&82&81&80",STAGE="90"}, -- The Test of Righteousness
	{ID_ATTUNE="5149",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1806",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- The Test of Righteousness
	{ID_ATTUNE="5149",ID="110",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_hammer_05",FOLLOWS="100",STAGE="110"},

	-- Horde mirror of Verigan's Fist. Known swaps only; the tome steps and the ore shipment have no Horde quest yet.
	-- 91858 > 91859 > 91860 > 91861 > 91862 > 96204 > 95034 > pick up 95036, then lumber, silver ingot, and the Kor gem, turn in, 95111, 95125, 95126, 95140.
	{ID_ATTUNE="5158",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 18",LOCATION="",ID_WOWHEAD="18",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5158",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="91858",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Diplomatic Incident
	{ID_ATTUNE="5158",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="91859",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="22"}, -- A Curious Pair
	{ID_ATTUNE="5158",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="91860",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="22",STAGE="24"}, -- A Grim Fate
	{ID_ATTUNE="5158",ID="26",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="91861",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="24",STAGE="26"}, -- Into Fenris Keep
	{ID_ATTUNE="5158",ID="28",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="91862",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="26",STAGE="28"}, -- Lumina Windsinger
	{ID_ATTUNE="5158",ID="29",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="96204",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="28",STAGE="29"}, -- The Windshaper's Wrath
	{ID_ATTUNE="5158",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="95034",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="29",STAGE="30"}, -- The Debt
	{ID_ATTUNE="5158",ID="40",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="95036",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- A Moon-Kissed Blade
	{ID_ATTUNE="5158",ID="50",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Deadmines"],ID_WOWHEAD="6994",ICON="Interface\\Icons\\inv_tradeskillitem_01",FOLLOWS="40",STAGE="50"}, -- Whitestone Oak Lumber
	{ID_ATTUNE="5158",ID="51",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="267361",ICON="Interface\\Icons\\inv_ingot_ghostiron",FOLLOWS="40",STAGE="50"}, -- Enchanted Silver Ingot
	{ID_ATTUNE="5158",ID="52",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="95042",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Seeking the Kor Gem
	{ID_ATTUNE="5158",ID="60",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="50",STAGE="60"},
	{ID_ATTUNE="5158",ID="61",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="51",STAGE="60"},
	{ID_ATTUNE="5158",ID="62",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Ashenvale"],ID_WOWHEAD="272448",ICON="Interface\\Icons\\inv_misc_gem_sapphire_02",FOLLOWS="52",STAGE="60"}, -- Purified Kor Gem
	{ID_ATTUNE="5158",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="95036",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="62&61&60",STAGE="70"}, -- A Moon-Kissed Blade
	{ID_ATTUNE="5158",ID="72",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="95111",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="72"}, -- An Underrated Talent
	{ID_ATTUNE="5158",ID="74",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="95125",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="72",STAGE="74"}, -- Ott's Masterwork
	{ID_ATTUNE="5158",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="95126",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="74",STAGE="80"}, -- The Moonsilver Blade
	{ID_ATTUNE="5158",ID="90",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="95140",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- Old Fire-Eye
	{ID_ATTUNE="5158",ID="100",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_sword_25",FOLLOWS="90",STAGE="100"},

	-- Tiza or Brandur, then Duthorian teaches Summon Warhorse.
	{ID_ATTUNE="5152",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 40",LOCATION="",ID_WOWHEAD="40",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5152",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="4485",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Tome of Nobility
	{ID_ATTUNE="5152",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="4486",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Tome of Nobility
	{ID_ATTUNE="5152",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1661",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- The Tome of Nobility
	{ID_ATTUNE="5152",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_nature_swiftness",FOLLOWS="30",STAGE="40"},

	{ID_ATTUNE="5155",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5155",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8415",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Chillwind Point
	{ID_ATTUNE="5155",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="8414",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Dispelling Evil
	{ID_ATTUNE="5155",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="8416",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Inert Scourgestones
	{ID_ATTUNE="5155",ID="45",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="8418",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="45"}, -- Forging the Mightstone
	{ID_ATTUNE="5155",ID="50",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20608",ICON="Interface\\Icons\\inv_feather_12",FOLLOWS="45",STAGE="50", COUNT=2}, -- Green Voodoo Feather
	{ID_ATTUNE="5155",ID="51",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20607",ICON="Interface\\Icons\\inv_feather_13",FOLLOWS="45",STAGE="50", COUNT=2}, -- Blue Voodoo Feather
	{ID_ATTUNE="5155",ID="52",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20606",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="45",STAGE="50", COUNT=2}, -- Amber Voodoo Feather
	{ID_ATTUNE="5155",ID="60",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Western Plaguelands"],ID_WOWHEAD="8418",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="52&51&50",STAGE="60"}, -- Forging the Mightstone
	{ID_ATTUNE="5155",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5156",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5156",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="7638",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Lord Grayson Shadowbreaker
	{ID_ATTUNE="5156",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="7670",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Lord Grayson Shadowbreaker
	{ID_ATTUNE="5156",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="7637",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Emphasis on Sacrifice
	{ID_ATTUNE="5156",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="7639",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- To Show Due Judgment
	{ID_ATTUNE="5156",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="7640",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Exorcising Terrordale
	{ID_ATTUNE="5156",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="7641",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Work of Grimand Elmore
	{ID_ATTUNE="5156",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="7642",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Collection of Goods
    {ID_ATTUNE="5156",ID="79",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="80"},
	{ID_ATTUNE="5156",ID="81",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="7648",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- Grimand's Finest Work
	{ID_ATTUNE="5156",ID="83",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="7645",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="80"}, -- Manna-Enriched Horse Feed
    {ID_ATTUNE="5156",ID="85",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Feralas"],ID_WOWHEAD="7643",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="83&81",STAGE="87"}, -- Ancient Equine1Spirit
	{ID_ATTUNE="5156",ID="90",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="7644",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="85",STAGE="90"}, -- Blessed Arcanite Barding
	{ID_ATTUNE="5156",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="7646",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- The Divination Scryer
	{ID_ATTUNE="5156",ID="110",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="7647",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="100",STAGE="110"}, -- Judgment and Redemption
	-- {ID_ATTUNE="5156",ID="120",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="7666",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="110",STAGE="120"}, -- Again Into the Great Ossuary
	{ID_ATTUNE="5156",ID="130",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_mount_charger",FOLLOWS="110",STAGE="130"},

    -- PRIEST
	{ID_ATTUNE="5164",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 5",LOCATION="",ID_WOWHEAD="5",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Undead (right) or Troll (left). Either garments quest completes the attunement.
	{ID_ATTUNE="5164",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="5649",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Favor of Spirituality
	{ID_ATTUNE="5164",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5651",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Favor of Darkness
	{ID_ATTUNE="5164",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="5648",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Garments of Spirituality
	{ID_ATTUNE="5164",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="5650",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Garments of Darkness
	{ID_ATTUNE="5164",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_04",FOLLOWS="31|30",STAGE="40"},

	{ID_ATTUNE="5166",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 5",LOCATION="",ID_WOWHEAD="5",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Human (left), Dwarf (middle), or Night elf (right).
	{ID_ATTUNE="5166",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="5623",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Favor of the Light
	{ID_ATTUNE="5166",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="5626",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Favor of the Light
	{ID_ATTUNE="5166",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5622",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Favor of Elune
	{ID_ATTUNE="5166",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="5624",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Garments of the Light
	{ID_ATTUNE="5166",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="5625",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Garments of the Light
	{ID_ATTUNE="5166",ID="32",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5621",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="22",STAGE="30"}, -- Garments of the Moon
	{ID_ATTUNE="5166",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_04",FOLLOWS="32|31|30",STAGE="40"},

	{ID_ATTUNE="5169",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Desperate Prayer.
	{ID_ATTUNE="5169",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="5634",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Desperate Prayer
	{ID_ATTUNE="5169",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="5635",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Desperate Prayer
	{ID_ATTUNE="5169",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5636",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Desperate Prayer
	{ID_ATTUNE="5169",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="5637",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Desperate Prayer
	{ID_ATTUNE="5169",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="5638",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Desperate Prayer
	{ID_ATTUNE="5169",ID="25",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="5639",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Desperate Prayer
	{ID_ATTUNE="5169",ID="26",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="5640",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Desperate Prayer
	{ID_ATTUNE="5169",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="26|25|24|23|22|21|20",STAGE="30"},

	{ID_ATTUNE="5176",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Hex of Weakness.
	{ID_ATTUNE="5176",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5652",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Hex of Weakness
	{ID_ATTUNE="5176",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="5654",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Hex of Weakness
	{ID_ATTUNE="5176",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="5655",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Hex of Weakness
	{ID_ATTUNE="5176",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="5656",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Hex of Weakness
	{ID_ATTUNE="5176",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="5657",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Hex of Weakness
	{ID_ATTUNE="5176",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="24|23|22|21|20",STAGE="30"},

	{ID_ATTUNE="5181",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5181",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5628",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Returning Home
	{ID_ATTUNE="5181",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5629",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Returning Home
	{ID_ATTUNE="5181",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5630",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Returning Home
	{ID_ATTUNE="5181",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5631",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Returning Home
	{ID_ATTUNE="5181",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5632",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Returning Home
	{ID_ATTUNE="5181",ID="25",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5633",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Returning Home
	{ID_ATTUNE="5181",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="5627",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="23|25|24|22|21|20",STAGE="30"}, -- Stars of Elune
	{ID_ATTUNE="5181",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="30",STAGE="40"},

	{ID_ATTUNE="5182",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Touch of Weakness.
	{ID_ATTUNE="5182",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="5658",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Touch of Weakness
	{ID_ATTUNE="5182",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="5660",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Touch of Weakness
	{ID_ATTUNE="5182",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="5661",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Touch of Weakness
	{ID_ATTUNE="5182",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5662",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Touch of Weakness
	{ID_ATTUNE="5182",ID="24",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="5663",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Touch of Weakness
	{ID_ATTUNE="5182",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="24|23|22|21|20",STAGE="30"},

	{ID_ATTUNE="5187",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Fear Ward.
	{ID_ATTUNE="5187",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="5647",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- A Lack of Fear
	{ID_ATTUNE="5187",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="5645",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- A Lack of Fear
	{ID_ATTUNE="5187",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="5641",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- A Lack of Fear
	{ID_ATTUNE="5187",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="22|21|20",STAGE="30"},

	{ID_ATTUNE="5190",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Feedback.
	{ID_ATTUNE="5190",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="5678",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Arcane Feedback
	{ID_ATTUNE="5190",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="5677",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Arcane Feedback
	{ID_ATTUNE="5190",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="5676",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Arcane Feedback
	{ID_ATTUNE="5190",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="22|21|20",STAGE="30"},

	{ID_ATTUNE="5193",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Devouring Plague.
	{ID_ATTUNE="5193",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5646",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Devouring Plague
	{ID_ATTUNE="5193",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="5679",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Devouring Plague
	{ID_ATTUNE="5193",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="5644",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Devouring Plague
	{ID_ATTUNE="5193",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="22|21|20",STAGE="30"},

	{ID_ATTUNE="5196",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Elune's Grace.
	{ID_ATTUNE="5196",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Darnassus"],ID_WOWHEAD="5672",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Elune's Grace
	{ID_ATTUNE="5196",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="5674",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Elune's Grace
	{ID_ATTUNE="5196",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="5673",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Elune's Grace
	{ID_ATTUNE="5196",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="5675",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Elune's Grace
	{ID_ATTUNE="5196",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="23|22|21|20",STAGE="30"},

	{ID_ATTUNE="5200",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- Any one of these teaches Shadowguard.
	{ID_ATTUNE="5200",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="5680",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Shadowguard
	{ID_ATTUNE="5200",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="5643",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Shadowguard
	{ID_ATTUNE="5200",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="5642",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Shadowguard
	{ID_ATTUNE="5200",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_holy_wordfortitude",FOLLOWS="22|21|20",STAGE="30"},

	{ID_ATTUNE="5203",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5203",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8254",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Cenarion Aid
	{ID_ATTUNE="5203",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8255",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Of Coursers We Know
	{ID_ATTUNE="5203",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8256",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Ichor of Undeath
	{ID_ATTUNE="5203",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8257",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Blood of Morphaz
	{ID_ATTUNE="5203",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20025",ICON="Interface\\Icons\\inv_potion_08",FOLLOWS="50",STAGE="60"}, -- Blood of Morphaz
	{ID_ATTUNE="5203",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="8257",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Blood of Morphaz
	{ID_ATTUNE="5203",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_potion_08",FOLLOWS="70",STAGE="80"},

	-- Both eyes are required. Eye of Divinity leads into the quests.
	{ID_ATTUNE="5205",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5205",ID="20",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Molten Core"],ID_WOWHEAD="18646",ICON="Interface\\Icons\\spell_holy_mindsooth",FOLLOWS="10",STAGE="20"}, -- The Eye of Divinity
	{ID_ATTUNE="5205",ID="21",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Winterspring"],ID_WOWHEAD="18665",ICON="Interface\\Icons\\spell_shadow_unholyfrenzy",FOLLOWS="10",STAGE="20"}, -- The Eye of Shadow
	{ID_ATTUNE="5205",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="7621",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- A Warning
    {ID_ATTUNE="5205",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="21",STAGE="30"},
	{ID_ATTUNE="5205",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Eastern Plaguelands"],ID_WOWHEAD="7622",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Balance of Light and Shadow
    {ID_ATTUNE="5205",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="31",STAGE="40"},
	{ID_ATTUNE="5205",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_staff_30",FOLLOWS="40&41",STAGE="50"},


    -- ROGUE
	-- Alliance: Night elf | Dwarf/Gnome | Human (any one chain)
	{ID_ATTUNE="5213",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5213",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2205",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Seek out SI: 7
	{ID_ATTUNE="5213",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2218",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Road to Salvation
	{ID_ATTUNE="5213",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="2241",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Apple Falls
	{ID_ATTUNE="5213",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2206",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Snatch and Grab
	{ID_ATTUNE="5213",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2238",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Simple Subterfugin'
	{ID_ATTUNE="5213",ID="32",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="2242",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="22",STAGE="30"}, -- Destiny Calls
	{ID_ATTUNE="5213",ID="40",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="30",STAGE="40"},
	{ID_ATTUNE="5213",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2239",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- Onin's Report
	{ID_ATTUNE="5213",ID="42",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="32",STAGE="40"},
	{ID_ATTUNE="5213",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_weapon_shortblade_26",FOLLOWS="40|41|42",STAGE="50"},

	{ID_ATTUNE="5215",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5215",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2018",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Rokar's Test
	{ID_ATTUNE="5215",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_stealth",FOLLOWS="20",STAGE="30"},

	-- Horde: Undead | Orc/Troll (any one chain)
	{ID_ATTUNE="5217",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5217",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1859",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Therzok
	{ID_ATTUNE="5217",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="1885",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Mennet Carkad
	{ID_ATTUNE="5217",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1963",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Shattered Hand
	{ID_ATTUNE="5217",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1886",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- The Deathstalkers
	{ID_ATTUNE="5217",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1858",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Shattered Hand
	{ID_ATTUNE="5217",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1898",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- The Deathstalkers
	{ID_ATTUNE="5217",ID="50",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="40",STAGE="50"},
	{ID_ATTUNE="5217",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1899",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="41",STAGE="50"}, -- The Deathstalkers
	{ID_ATTUNE="5217",ID="60",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="50",STAGE="60"},
	{ID_ATTUNE="5217",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1978",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="51",STAGE="60"}, -- The Deathstalkers
	{ID_ATTUNE="5217",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_weapon_shortblade_26",FOLLOWS="60|61",STAGE="70"},

	{ID_ATTUNE="5219",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5219",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2019",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Tools of the Trade
	{ID_ATTUNE="5219",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_stealth",FOLLOWS="20",STAGE="30"},

	{ID_ATTUNE="5220",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 16",LOCATION="",ID_WOWHEAD="16",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5220",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="2259",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Erion Shadewhisper
	{ID_ATTUNE="5220",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="2299",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- To Hulfdan!
	{ID_ATTUNE="5220",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2300",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- SI:7
	{ID_ATTUNE="5220",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2260",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Erion's Behest
	{ID_ATTUNE="5220",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2298",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Kingly Shakedown
    {ID_ATTUNE="5220",ID="32",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="22",STAGE="30"}, -- SI:7
	{ID_ATTUNE="5220",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="2281",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="32&31&30",STAGE="40"}, -- Redridge Rendezvous
	{ID_ATTUNE="5220",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="2282",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Alther's Mill
	{ID_ATTUNE="5220",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_note_02",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5221",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 16",LOCATION="",ID_WOWHEAD="16",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5221",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2378",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Find the Shattered Hand
	{ID_ATTUNE="5221",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2380",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- To Orgrimmar!
	{ID_ATTUNE="5221",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2379",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Zando'zan
	{ID_ATTUNE="5221",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="2382",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Wrenix of Ratchet
	{ID_ATTUNE="5221",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="2381",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Plundering the Plunderers
	{ID_ATTUNE="5221",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_drink_milk_05",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5222",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 16",LOCATION="",ID_WOWHEAD="16",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5222",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1998",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Fenwick Thatros
	{ID_ATTUNE="5222",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1999",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Tools of the Trade
	{ID_ATTUNE="5222",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_gear_03",FOLLOWS="30",STAGE="40"},

	{ID_ATTUNE="5223",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5223",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="2460",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Shattered Salute
	{ID_ATTUNE="5223",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2458",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Deep Cover
	{ID_ATTUNE="5223",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2478",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Mission: Possible But Not Probable
	{ID_ATTUNE="5223",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="2479",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Hinott's Assistance
	{ID_ATTUNE="5223",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="2480",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Hinott's Assistance
	{ID_ATTUNE="5223",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\trade_brewpoison",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5224",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5224",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="2360",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Mathias and the Defias
	{ID_ATTUNE="5224",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2359",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Klaven's Tower
	{ID_ATTUNE="5224",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="2607",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Touch of Zanzil
	{ID_ATTUNE="5224",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="2608",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- The Touch of Zanzil
	{ID_ATTUNE="5224",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="2609",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Touch of Zanzil
	{ID_ATTUNE="5224",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\trade_brewpoison",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5225",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 24",LOCATION="",ID_WOWHEAD="24",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5225",ID="20",TYPE="Item",STEP="",LOCATION="",ID_WOWHEAD="17126",ICON="Interface\\Icons\\inv_letter_04",FOLLOWS="10",STAGE="20"}, -- Elegant Letter
	{ID_ATTUNE="5225",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="6681",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Manor, Ravenholdt
	{ID_ATTUNE="5225",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="6701",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Syndicate Emblems
	{ID_ATTUNE="5225",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_throwingknife_03",FOLLOWS="40",STAGE="50"},

	{ID_ATTUNE="5226",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5226",ID="20",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="8249",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Junkboxes Needed
	{ID_ATTUNE="5226",ID="30",TYPE="Item",STEP="",LOCATION="",ID_WOWHEAD="16885",ICON="Interface\\Icons\\inv_box_03",FOLLOWS="20",STAGE="30", COUNT=5}, -- Heavy Junkbox
	{ID_ATTUNE="5226",ID="40",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="8249",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Junkboxes Needed
	{ID_ATTUNE="5226",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_box_03",FOLLOWS="40",STAGE="50"},

	{ID_ATTUNE="5227",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5227",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8233",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- A Simple Request
	{ID_ATTUNE="5227",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8234",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Sealed Azure Bag
	{ID_ATTUNE="5227",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8235",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Encoded Fragments
	{ID_ATTUNE="5227",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Azshara"],ID_WOWHEAD="8236",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- The Azure Key
	{ID_ATTUNE="5227",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20022",ICON="Interface\\Icons\\inv_misc_key_08",FOLLOWS="50",STAGE="60"}, -- Azure Key
	{ID_ATTUNE="5227",ID="70",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="8236",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- The Azure Key
	{ID_ATTUNE="5227",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_key_08",FOLLOWS="70",STAGE="80"},


    -- SHAMAN
    -- FAKE ATTUNEMENT, FOR TESTING PURPOSES ONLY
	-- {ID_ATTUNE="5230",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 1",LOCATION="",ID_WOWHEAD="1",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- {ID_ATTUNE="5230",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="752",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- A Humble Task
	-- {ID_ATTUNE="5230",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="753",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- A Humble Task
	-- {ID_ATTUNE="5230",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="755",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Rites of the Earthmother
	-- {ID_ATTUNE="5230",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="757",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Rite of Strength
    -- {ID_ATTUNE="5230",ID="52",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="4770",ICON="Interface\\Icons\\inv_belt_05",FOLLOWS="50",STAGE="52", COUNT=12}, -- 
    -- {ID_ATTUNE="5230",ID="55",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="757",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="52",STAGE="55"}, -- Rite of Strength
	-- {ID_ATTUNE="5230",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="763",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="55",STAGE="60"}, -- Rites of the Earthmother
	-- {ID_ATTUNE="5230",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_drink_08",FOLLOWS="60",STAGE="70"},

	-- Earth Sapta: orc/troll (Durotar) or tauren (Mulgore)
	{ID_ATTUNE="5231",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 4",LOCATION="",ID_WOWHEAD="4",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5231",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1516",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Earth
	{ID_ATTUNE="5231",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="1519",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Earth
	{ID_ATTUNE="5231",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1517",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Call of Earth
	-- {ID_ATTUNE="5231",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	-- {ID_ATTUNE="5231",ID="32",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5231",ID="33",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="1520",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Call of Earth
	-- {ID_ATTUNE="5231",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1463",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Earth Sapta
	{ID_ATTUNE="5231",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1518",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Call of Earth
	-- {ID_ATTUNE="5231",ID="42",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	-- {ID_ATTUNE="5231",ID="43",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	-- {ID_ATTUNE="5231",ID="44",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="1462",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="33",STAGE="40"}, -- Earth Sapta
	{ID_ATTUNE="5231",ID="45",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Mulgore"],ID_WOWHEAD="1521",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="33",STAGE="40"}, -- Call of Earth
	{ID_ATTUNE="5231",ID="50",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="41",STAGE="50"},
	-- {ID_ATTUNE="5231",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	-- {ID_ATTUNE="5231",ID="52",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5231",ID="53",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="45",STAGE="50"},
	{ID_ATTUNE="5231",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_earth",FOLLOWS="50|53",STAGE="60"},

	{ID_ATTUNE="5242",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 4",LOCATION="",ID_WOWHEAD="4",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5242",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="96243",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Call of Earth
	{ID_ATTUNE="5242",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="94373",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Call of Earth
	{ID_ATTUNE="5242",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="94374",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Call of Earth
	{ID_ATTUNE="5242",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="94375",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Call of Earth
	{ID_ATTUNE="5242",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_earth",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5233",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5233",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1522",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Fire
	{ID_ATTUNE="5233",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1523",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Fire
	{ID_ATTUNE="5233",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="2983",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Fire
	{ID_ATTUNE="5233",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2984",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Fire
	{ID_ATTUNE="5233",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1524",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20|22|23",STAGE="30"}, -- Call of Fire
	{ID_ATTUNE="5233",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1525",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Call of Fire
	{ID_ATTUNE="5233",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1526",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Call of Fire
	-- {ID_ATTUNE="5233",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1464",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Fire Sapta
	{ID_ATTUNE="5233",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1527",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Call of Fire
	{ID_ATTUNE="5233",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_fire",FOLLOWS="61",STAGE="70"},

	{ID_ATTUNE="5243",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5243",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="94449",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Call of Fire
	{ID_ATTUNE="5243",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="94465",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Call of Fire
	{ID_ATTUNE="5243",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="94466",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Call of Fire
	{ID_ATTUNE="5243",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="94467",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Call of Fire
	{ID_ATTUNE="5243",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="94468",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Call of Fire
	{ID_ATTUNE="5243",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_fire",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5234",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5234",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1528",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Water
	{ID_ATTUNE="5234",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1529",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Water
	{ID_ATTUNE="5234",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2985",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Water
	{ID_ATTUNE="5234",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2986",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Water
	{ID_ATTUNE="5234",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1530",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20|23|22",STAGE="30"}, -- Call of Water
	{ID_ATTUNE="5234",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1535",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Call of Water
	{ID_ATTUNE="5234",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1536",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Call of Water
	{ID_ATTUNE="5234",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1534",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Call of Water
	{ID_ATTUNE="5234",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="220",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Call of Water
	{ID_ATTUNE="5234",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="63",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- Call of Water
	{ID_ATTUNE="5234",ID="90",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="100",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- Call of Water
	{ID_ATTUNE="5234",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="96",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- Call of Water
	-- {ID_ATTUNE="5234",ID="101",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Silverpine Forest"],ID_WOWHEAD="1103",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="100"}, -- Call of Water
	-- {ID_ATTUNE="5234",ID="110",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="972",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="101",STAGE="110"}, -- Water Sapta
	{ID_ATTUNE="5234",ID="120",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_water",FOLLOWS="100",STAGE="120"},

	{ID_ATTUNE="5244",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5244",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="94495",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Call of Water
	{ID_ATTUNE="5244",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="94497",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Call of Water
	{ID_ATTUNE="5244",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="94499",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Call of Water
	{ID_ATTUNE="5244",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="94500",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Call of Water
	{ID_ATTUNE="5244",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="94501",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Call of Water
	{ID_ATTUNE="5244",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Loch Modan"],ID_WOWHEAD="94502",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Call of Water
	{ID_ATTUNE="5244",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="94503",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- Call of Water
	{ID_ATTUNE="5244",ID="90",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Westfall"],ID_WOWHEAD="94505",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="90"}, -- Call of Water
	{ID_ATTUNE="5244",ID="100",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_water",FOLLOWS="90",STAGE="100"},

	{ID_ATTUNE="5235",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5235",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1532",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Air
    {ID_ATTUNE="5235",ID="25",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1531",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Call of Air
	{ID_ATTUNE="5235",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="79360",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20|25",STAGE="30"}, -- Elemental Aid
	{ID_ATTUNE="5235",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="79364",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Eyes on the Sky
	{ID_ATTUNE="5235",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="79361",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Storm, Earth, and Fire
	{ID_ATTUNE="5235",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="79366",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Heed My Call
	{ID_ATTUNE="5235",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="79442",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- The Tempest's Weapons
	{ID_ATTUNE="5235",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_air",FOLLOWS="70",STAGE="80"},

	{ID_ATTUNE="5245",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5245",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="94789",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Call of Air
	{ID_ATTUNE="5245",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="96264",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Elemental Aid
	{ID_ATTUNE="5245",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="79358",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Storm, Earth, and Fire
	{ID_ATTUNE="5245",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="96135",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Heed My Call
	{ID_ATTUNE="5245",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="96016",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Tempest's Weapons
	{ID_ATTUNE="5245",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_air",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5236",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5236",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thousand Needles"],ID_WOWHEAD="1531",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Call of Air
	{ID_ATTUNE="5236",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_elemental_primal_air",FOLLOWS="20",STAGE="30"},

	{ID_ATTUNE="5239",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- {ID_ATTUNE="5239,ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8410",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Elemental Mastery
	{ID_ATTUNE="5239",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8411",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Mastering the Elements
	{ID_ATTUNE="5239",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8412",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Spirit Totem
	{ID_ATTUNE="5239",ID="40",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8413",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Da Voodoo
	{ID_ATTUNE="5239",ID="50",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Gurub"],ID_WOWHEAD="20608",ICON="Interface\\Icons\\inv_feather_12",FOLLOWS="40",STAGE="50", COUNT=2}, -- Green Voodoo Feather
	{ID_ATTUNE="5239",ID="51",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Gurub"],ID_WOWHEAD="20607",ICON="Interface\\Icons\\inv_feather_13",FOLLOWS="40",STAGE="50", COUNT=2}, -- Blue Voodoo Feather
	{ID_ATTUNE="5239",ID="52",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Gurub"],ID_WOWHEAD="20606",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="40",STAGE="50", COUNT=2}, -- Amber Voodoo Feather
	{ID_ATTUNE="5239",ID="60",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8413",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="52&51&50",STAGE="60"}, -- Da Voodoo
	{ID_ATTUNE="5239",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5237",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5237",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8410",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Elemental Mastery
	{ID_ATTUNE="5237",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8411",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Mastering the Elements
	{ID_ATTUNE="5237",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8412",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21&20",STAGE="30"}, -- Spirit Totem
	{ID_ATTUNE="5237",ID="40",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8413",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Da Voodoo
	{ID_ATTUNE="5237",ID="50",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Gurub"],ID_WOWHEAD="20608",ICON="Interface\\Icons\\inv_feather_12",FOLLOWS="40",STAGE="50", COUNT=2}, -- Green Voodoo Feather
	{ID_ATTUNE="5237",ID="51",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Gurub"],ID_WOWHEAD="20607",ICON="Interface\\Icons\\inv_feather_13",FOLLOWS="40",STAGE="50", COUNT=2}, -- Blue Voodoo Feather
	{ID_ATTUNE="5237",ID="52",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Zul'Gurub"],ID_WOWHEAD="20606",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="40",STAGE="50", COUNT=2}, -- Amber Voodoo Feather
	{ID_ATTUNE="5237",ID="60",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="8413",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="52&51&50",STAGE="60"}, -- Da Voodoo
	{ID_ATTUNE="5237",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5238",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 58",LOCATION="",ID_WOWHEAD="58",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5238",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="8259",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- A More Fitting Reward
	{ID_ATTUNE="5238",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_nature_lightning",FOLLOWS="20",STAGE="30"},

	-- {ID_ATTUNE="5239",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 58",LOCATION="",ID_WOWHEAD="58",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	-- {ID_ATTUNE="5239",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="7669",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Again Into the Great Ossuary
	-- {ID_ATTUNE="5239",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_nature_lightning",FOLLOWS="20",STAGE="30"},

	{ID_ATTUNE="5240",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 58",LOCATION="",ID_WOWHEAD="58",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5240",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="7668",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Darkreaver Menace
	{ID_ATTUNE="5240",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_nature_lightning",FOLLOWS="20",STAGE="30"},

	{ID_ATTUNE="5241",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 58",LOCATION="",ID_WOWHEAD="58",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5241",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="7667",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Material Assistance
	{ID_ATTUNE="5241",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="8258",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Darkreaver Menace
	{ID_ATTUNE="5241",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_nature_lightning",FOLLOWS="30",STAGE="40"},


    -- WARLOCK
	{ID_ATTUNE="5252",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5252",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1685",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Gakin's Summons
	{ID_ATTUNE="5252",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1715",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- The Slaughtered Lamb
	{ID_ATTUNE="5252",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1688",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Surena Caledon
	{ID_ATTUNE="5252",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1689",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Binding
	{ID_ATTUNE="5252",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_summonvoidwalker",FOLLOWS="40",STAGE="50"},

	{ID_ATTUNE="5253",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5253",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1478",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Halgar's Summons
	{ID_ATTUNE="5253",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1506",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Gan'rul's Summons
	{ID_ATTUNE="5253",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1473",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Creature of the Void
	{ID_ATTUNE="5253",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1501",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Creature of the Void
	{ID_ATTUNE="5253",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1471",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Binding
	{ID_ATTUNE="5253",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1504",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- The Binding
	{ID_ATTUNE="5253",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_summonvoidwalker",FOLLOWS="41|40",STAGE="50"},

	{ID_ATTUNE="5257",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5257",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1717",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Gakin's Summons
	{ID_ATTUNE="5257",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1716",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Devourer of Souls
	{ID_ATTUNE="5257",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1738",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Heartswood
	{ID_ATTUNE="5257",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1739",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- The Binding
	{ID_ATTUNE="5257",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_summonsuccubus",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5258",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5258",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="65602",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- What Is Love?
	{ID_ATTUNE="5258",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="65603",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Binding
	{ID_ATTUNE="5258",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_warlock_incubus",FOLLOWS="30",STAGE="40"},

	{ID_ATTUNE="5259",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5259",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="65593",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Hearts of the Lovers
	{ID_ATTUNE="5259",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="65601",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Love Hurts
	{ID_ATTUNE="5259",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Undercity"],ID_WOWHEAD="65597",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Binding
	{ID_ATTUNE="5259",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="65610",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Wish You Were Here
	{ID_ATTUNE="5259",ID="40",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="30",STAGE="40"},
	{ID_ATTUNE="5259",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="65604",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- The Binding
	{ID_ATTUNE="5259",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_warlock_incubus",FOLLOWS="40|41",STAGE="50"},

	{ID_ATTUNE="5261",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5261",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1472",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Devourer of Souls
	{ID_ATTUNE="5261",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1507",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Devourer of Souls
	{ID_ATTUNE="5261",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1476",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Hearts of the Pure
	{ID_ATTUNE="5261",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1508",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Blind Cazul
	{ID_ATTUNE="5261",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1474",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Binding
	{ID_ATTUNE="5261",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1509",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- News of Dogran
	{ID_ATTUNE="5261",ID="50",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="40",STAGE="50"},
	{ID_ATTUNE="5261",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="1510",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="41",STAGE="50"}, -- News of Dogran
	{ID_ATTUNE="5261",ID="60",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="50",STAGE="60"},
	{ID_ATTUNE="5261",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1511",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="51",STAGE="60"}, -- Ken'zigla's Draught
	{ID_ATTUNE="5261",ID="70",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="60",STAGE="70"},
	{ID_ATTUNE="5261",ID="71",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1515",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="61",STAGE="70"}, -- Dogran's Captivity
	{ID_ATTUNE="5261",ID="80",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="70",STAGE="80"},
	{ID_ATTUNE="5261",ID="81",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1512",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="71",STAGE="80"}, -- Love's Gift
	{ID_ATTUNE="5261",ID="90",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="80",STAGE="90"},
	{ID_ATTUNE="5261",ID="91",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Orgrimmar"],ID_WOWHEAD="1513",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="81",STAGE="90"}, -- The Binding
	{ID_ATTUNE="5261",ID="100",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_summonsuccubus",FOLLOWS="90|91",STAGE="100"},

	{ID_ATTUNE="5263",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5263",ID="20",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1740",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Orb of Soran'ruk
	{ID_ATTUNE="5263",ID="30",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Blackfathom Deeps"],ID_WOWHEAD="6914",ICON="Interface\\Icons\\inv_misc_orb_04",FOLLOWS="20",STAGE="30", COUNT=3}, -- Soran'ruk Fragment
	{ID_ATTUNE="5263",ID="31",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Shadowfang Keep"],ID_WOWHEAD="6915",ICON="Interface\\Icons\\inv_misc_orb_01",FOLLOWS="20",STAGE="30"}, -- Large Soran'ruk Fragment
	{ID_ATTUNE="5263",ID="40",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1740",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30&31",STAGE="40"}, -- The Orb of Soran'ruk
	{ID_ATTUNE="5263",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_orb_03",FOLLOWS="40",STAGE="50"},

	{ID_ATTUNE="5266",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5266",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1798",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Seeking Strahad
	{ID_ATTUNE="5266",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1758",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Tome of the Cabal
	{ID_ATTUNE="5266",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Ironforge"],ID_WOWHEAD="1802",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Tome of the Cabal
	{ID_ATTUNE="5266",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1804",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Tome of the Cabal
	{ID_ATTUNE="5266",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1795",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Binding
	{ID_ATTUNE="5266",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_summonfelhunter",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5267",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5267",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="2996",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Seeking Strahad
	{ID_ATTUNE="5267",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="3001",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Seeking Strahad
	{ID_ATTUNE="5267",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1801",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Tome of the Cabal
	{ID_ATTUNE="5267",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1803",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Tome of the Cabal
	{ID_ATTUNE="5267",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1805",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Tome of the Cabal
	{ID_ATTUNE="5267",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1795",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Binding
	{ID_ATTUNE="5267",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_summonfelhunter",FOLLOWS="60",STAGE="70"},

	{ID_ATTUNE="5268",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 31",LOCATION="",ID_WOWHEAD="31",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5268",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4736",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Search of Menara Voidrender
	{ID_ATTUNE="5268",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4738",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Search of Menara Voidrender
	{ID_ATTUNE="5268",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1796",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5268",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stranglethorn Vale"],ID_WOWHEAD="4781",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5268",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4782",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5268",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4783",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5268",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4784",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5268",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4786",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- The Completed Robe
	{ID_ATTUNE="5268",ID="90",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_25",FOLLOWS="80",STAGE="90"},

	{ID_ATTUNE="5269",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 31",LOCATION="",ID_WOWHEAD="31",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5269",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4737",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Search of Menara Voidrender
	{ID_ATTUNE="5269",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4739",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- In Search of Menara Voidrender
	{ID_ATTUNE="5269",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1796",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5269",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stranglethorn Vale"],ID_WOWHEAD="4781",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5269",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4782",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5269",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4783",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5269",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4784",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Components for the Enchanted Gold Bloodrobe
	{ID_ATTUNE="5269",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4786",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- The Completed Robe
	{ID_ATTUNE="5269",ID="90",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_cloth_25",FOLLOWS="80",STAGE="90"},

	{ID_ATTUNE="5270",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 35",LOCATION="",ID_WOWHEAD="35",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5270",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4965",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Knowledge of the Orb of Orahil
	{ID_ATTUNE="5270",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4967",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Knowledge of the Orb of Orahil
	{ID_ATTUNE="5270",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1799",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Fragments of the Orb of Orahil
	{ID_ATTUNE="5270",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4962",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40", OR=true}, -- Shard of a Felhound
	{ID_ATTUNE="5270",ID="42",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4963",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40", OR=true}, -- Shard of an Infernal
	{ID_ATTUNE="5270",ID="45",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="4961",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="41",STAGE="45"}, -- Cleansing of the Orb of Orahil
	{ID_ATTUNE="5270",ID="46",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="4961",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="42",STAGE="45"}, -- Cleansing of the Orb of Orahil
    {ID_ATTUNE="5270",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45",STAGE="50"}, -- Returning the Cleansed Orb
    {ID_ATTUNE="5270",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="46",STAGE="50"}, -- Returning the Cleansed Orb
	{ID_ATTUNE="5270",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4964",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Completed Orb of Dar'Orahil
	{ID_ATTUNE="5270",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4975",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="51",STAGE="60"}, -- The Completed Orb of Noh'Orahil
	{ID_ATTUNE="5270",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_orb_03",FOLLOWS="61|60",STAGE="70"},

	{ID_ATTUNE="5271",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 35",LOCATION="",ID_WOWHEAD="35",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5271",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4968",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Knowledge of the Orb of Orahil
	{ID_ATTUNE="5271",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4969",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Knowledge of the Orb of Orahil
	{ID_ATTUNE="5271",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="1799",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Fragments of the Orb of Orahil
	{ID_ATTUNE="5271",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4962",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40", OR=true}, -- Shard of a Felhound
	{ID_ATTUNE="5271",ID="42",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4963",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40", OR=true}, -- Shard of an Inferna
    {ID_ATTUNE="5271",ID="45",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="4961",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="41",STAGE="45"}, -- Cleansing of the Orb of Orahill
    {ID_ATTUNE="5271",ID="46",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dustwallow Marsh"],ID_WOWHEAD="4961",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="42",STAGE="45"}, -- Cleansing of the Orb of Orahill
	{ID_ATTUNE="5271",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45",STAGE="50"}, -- Returning the Cleansed Orb
	{ID_ATTUNE="5271",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4976",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="46",STAGE="50"}, -- Returning the Cleansed Orb
	{ID_ATTUNE="5271",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4964",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- The Completed Orb of Dar'Orahil
	{ID_ATTUNE="5271",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="4975",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="51",STAGE="60"}, -- The Completed Orb of Noh'Orahil
	{ID_ATTUNE="5271",ID="70",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_misc_orb_03",FOLLOWS="61|60",STAGE="70"},

	{ID_ATTUNE="5272",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 40",LOCATION="",ID_WOWHEAD="40",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5272",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4487",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Summon Felsteed
	{ID_ATTUNE="5272",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4488",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Summon Felsteed
	{ID_ATTUNE="5272",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4490",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- Summon Felsteed
	{ID_ATTUNE="5272",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_nature_swiftness",FOLLOWS="30",STAGE="40"},

	{ID_ATTUNE="5273",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 40",LOCATION="",ID_WOWHEAD="40",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5273",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="3631",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Summon Felsteed
	{ID_ATTUNE="5273",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4489",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Summon Felsteed
	{ID_ATTUNE="5273",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="4490",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20|21",STAGE="30"}, -- Summon Felsteed
	{ID_ATTUNE="5273",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_nature_swiftness",FOLLOWS="30",STAGE="40"},

	{ID_ATTUNE="5274",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5274",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7601",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- What Niby Commands
	{ID_ATTUNE="5274",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7602",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Flawless Fel Essence
	{ID_ATTUNE="5274",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7603",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Kroshius' Infernal Core
	{ID_ATTUNE="5274",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_summoninfernal",FOLLOWS="40",STAGE="50"},

	{ID_ATTUNE="5275",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5275",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="8419",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- An Imp's Request
	{ID_ATTUNE="5275",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="8420",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Hot and Itchy
	{ID_ATTUNE="5275",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="8421",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21|20",STAGE="30"}, -- The Wrong Stuff
	{ID_ATTUNE="5275",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="8422",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Trolls of a Feather
	{ID_ATTUNE="5275",ID="50",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="40",STAGE="50"},

    -- Dreadsteed
	{ID_ATTUNE="5276",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5276",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7562",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Mor'zul Bloodbringer
    {ID_ATTUNE="5276",ID="22",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="5276",ID="25",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7623",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Lord Banehollow
	{ID_ATTUNE="5276",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7563",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Rage of Blood
    {ID_ATTUNE="5276",ID="32",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5276",ID="35",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Felwood"],ID_WOWHEAD="7624",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="25",STAGE="30"}, -- Ulathek the Traitor
	{ID_ATTUNE="5276",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7564",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Wildeyes
    {ID_ATTUNE="5276",ID="42",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5276",ID="45",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7625",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="35",STAGE="40"}, -- Xorothian Stardust
	{ID_ATTUNE="5276",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7626",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Bell of Dethmoora
	{ID_ATTUNE="5276",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7627",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Wheel of the Black March
	{ID_ATTUNE="5276",ID="52",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7628",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Doomsday Candle
	{ID_ATTUNE="5276",ID="53",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7629",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45",STAGE="50"}, -- Imp Delivery
    {ID_ATTUNE="5276",ID="55",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5276",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7630",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="52&51&50",STAGE="60"}, -- Arcanite
    {ID_ATTUNE="5276",ID="62",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="5276",ID="65",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="53",STAGE="60"},
	{ID_ATTUNE="5276",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Burning Steppes"],ID_WOWHEAD="7631",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60&65",STAGE="70"}, -- Dreadsteed of Xoroth
	{ID_ATTUNE="5276",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_mount_dreadsteed",FOLLOWS="70",STAGE="80"},

	{ID_ATTUNE="5277",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5277",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blasted Lands"],ID_WOWHEAD="7581",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Prison's Bindings
	{ID_ATTUNE="5277",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blasted Lands"],ID_WOWHEAD="7582",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Prison's Casing
	{ID_ATTUNE="5277",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Blasted Lands"],ID_WOWHEAD="7583",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21&20",STAGE="30"}, -- Suppression
	{ID_ATTUNE="5277",ID="40",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\spell_shadow_antimagicshell",FOLLOWS="30",STAGE="40"},


    -- WARRIOR
	-- Orc (right) or Undead (left). Either chain completes Forged Steel.
	{ID_ATTUNE="5287",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5287",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1505",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Veteran Uzzek
	{ID_ATTUNE="5287",ID="21",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="5287",ID="23",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1818",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Speak with Dillinger
	{ID_ATTUNE="5287",ID="24",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="20"},
	{ID_ATTUNE="5287",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1498",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Path of Defense
	{ID_ATTUNE="5287",ID="31",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5287",ID="33",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1819",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="23",STAGE="30"}, -- Ulag the Cleaver
	{ID_ATTUNE="5287",ID="34",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="30"},
	{ID_ATTUNE="5287",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1502",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Thun'grim Firegaze
	{ID_ATTUNE="5287",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5287",ID="43",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1820",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="33",STAGE="40"}, -- Speak with Coleman
	{ID_ATTUNE="5287",ID="44",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="40"},
	{ID_ATTUNE="5287",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1503",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Forged Steel
	{ID_ATTUNE="5287",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5287",ID="53",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1821",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="43",STAGE="50"}, -- Agamand Heirlooms
	{ID_ATTUNE="5287",ID="54",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5287",ID="58",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5287",ID="61",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="7567",ICON="Interface\\Icons\\inv_axe_01",FOLLOWS="53",STAGE="60"}, -- Agamand Family Axe
	{ID_ATTUNE="5287",ID="62",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="7566",ICON="Interface\\Icons\\inv_sword_04",FOLLOWS="53",STAGE="60"}, -- Agamand Family Sword
	{ID_ATTUNE="5287",ID="63",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="7569",ICON="Interface\\Icons\\inv_mace_01",FOLLOWS="53",STAGE="60"}, -- Agamand Family Mace
	{ID_ATTUNE="5287",ID="64",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="7568",ICON="Interface\\Icons\\inv_weapon_shortblade_05",FOLLOWS="53",STAGE="60"}, -- Agamand Family Dagger
	{ID_ATTUNE="5287",ID="70",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="50",STAGE="70"},
	{ID_ATTUNE="5287",ID="71",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="5287",ID="73",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1822",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="64&63&62&61",STAGE="70"}, -- Heirloom Weapon
	{ID_ATTUNE="5287",ID="74",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="70"},
	{ID_ATTUNE="5287",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_warrior_defensivestance",FOLLOWS="70|73",STAGE="80"},

	-- Human (right), Dwarf (middle), or Night Elf (left). Any chain completes Grey Iron Weapons.
	{ID_ATTUNE="5288",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 10",LOCATION="",ID_WOWHEAD="10",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5288",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1638",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- A Warrior's Training
	{ID_ATTUNE="5288",ID="21",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1679",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Muren Stormpike
	{ID_ATTUNE="5288",ID="22",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1684",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20", OR=true}, -- Elanaria
	{ID_ATTUNE="5288",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1639",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Bartleby the Drunk
	{ID_ATTUNE="5288",ID="31",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1678",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="21",STAGE="30"}, -- Vejrek
	{ID_ATTUNE="5288",ID="32",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1683",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="22",STAGE="30"}, -- Vorlus Vilehoof
	{ID_ATTUNE="5288",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Stormwind City"],ID_WOWHEAD="1640",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Beat Bartleby
	{ID_ATTUNE="5288",ID="41",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1680",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="31",STAGE="40"}, -- Tormus Deepforge
	{ID_ATTUNE="5288",ID="42",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1686",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="32",STAGE="40"}, -- The Shade of Elura
    {ID_ATTUNE="5288",ID="49",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5288",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1665",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Bartleby's Mug
	{ID_ATTUNE="5288",ID="51",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1681",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="41",STAGE="50"}, -- Ironband's Compound
	{ID_ATTUNE="5288",ID="52",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="6809",ICON="Interface\\Icons\\inv_jewelry_talisman_01",FOLLOWS="42",STAGE="50"}, -- Elura's Medallion
	{ID_ATTUNE="5288",ID="53",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Darkshore"],ID_WOWHEAD="6808",ICON="Interface\\Icons\\inv_ore_iron_01",FOLLOWS="42",STAGE="50", COUNT=8}, -- Elunite Ore
	{ID_ATTUNE="5288",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1666",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="50",STAGE="60"}, -- Marshal Haggard
	{ID_ATTUNE="5288",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1682",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="51",STAGE="60"}, -- Grey Iron Weapons
	{ID_ATTUNE="5288",ID="62",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1692",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="53&52",STAGE="60"}, -- Smith Mathiel
	{ID_ATTUNE="5288",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1667",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Dead-tooth Jack
	{ID_ATTUNE="5288",ID="71",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="61",STAGE="70"},
	{ID_ATTUNE="5288",ID="72",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1693",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="62",STAGE="70"}, -- Weapons of Elunite
	{ID_ATTUNE="5288",ID="80",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_warrior_defensivestance",FOLLOWS="70|71|72",STAGE="80"},

	{ID_ATTUNE="5291",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5291",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1823",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Speak with Ruga
	{ID_ATTUNE="5291",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1824",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Trial at the Field of Giants
	{ID_ATTUNE="5291",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1825",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- Speak with Thun'grim
	{ID_ATTUNE="5291",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1838",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Brutal Armor
	{ID_ATTUNE="5291",ID="51",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="7126",ICON="Interface\\Icons\\inv_ore_tin_01",FOLLOWS="50",STAGE="55", COUNT=15}, -- Smoky Iron Ingot
	{ID_ATTUNE="5291",ID="52",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="7127",ICON="Interface\\Icons\\inv_misc_dust_02",FOLLOWS="50",STAGE="55", COUNT=10}, -- Powdered Azurite
	{ID_ATTUNE="5291",ID="53",TYPE="Item",STEP="",LOCATION="",ID_WOWHEAD="3575",ICON="Interface\\Icons\\inv_ingot_iron",FOLLOWS="50",STAGE="55", COUNT=10}, -- Iron Bar
	{ID_ATTUNE="5291",ID="54",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="6841",ICON="Interface\\Icons\\inv_potion_01",FOLLOWS="50",STAGE="55"}, -- Vial of Phlogiston
    {ID_ATTUNE="5291",ID="57",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1838",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="51&52&53&54",STAGE="57"}, -- Brutal Armor
	{ID_ATTUNE="5291",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1839",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Ula'elek and the Brutal Gauntlets
	{ID_ATTUNE="5291",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["The Barrens"],ID_WOWHEAD="1840",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Orm Stonehoof and the Brutal Helm
	{ID_ATTUNE="5291",ID="62",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1841",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Velora Nitely and the Brutal Legguards
	{ID_ATTUNE="5291",ID="63",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1848",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Brutal Hauberk
	{ID_ATTUNE="5291",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1842",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Satyr Hooves
	{ID_ATTUNE="5291",ID="71",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="1844",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="61",STAGE="70"}, -- Chimaeric Horn
	{ID_ATTUNE="5291",ID="72",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1846",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="62",STAGE="70"}, -- Dragonmaw Shinbones
    {ID_ATTUNE="5291",ID="73",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="63",STAGE="70"},
	{ID_ATTUNE="5291",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1843",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- Brutal Gauntlets
	{ID_ATTUNE="5291",ID="81",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Thunder Bluff"],ID_WOWHEAD="1845",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="71",STAGE="80"}, -- Brutal Helm
	{ID_ATTUNE="5291",ID="82",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Tirisfal Glades"],ID_WOWHEAD="1847",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="72",STAGE="80"}, -- Brutal Legguards
    {ID_ATTUNE="5291",ID="83",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="73",STAGE="80"},
	{ID_ATTUNE="5291",ID="90",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_chest_chain_07",FOLLOWS="80&83&82&81",STAGE="90"},

	{ID_ATTUNE="5292",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 20",LOCATION="",ID_WOWHEAD="20",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5292",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="1698",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Yorus Barleybrew
	{ID_ATTUNE="5292",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Redridge Mountains"],ID_WOWHEAD="1699",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Rethban Gauntlet
	{ID_ATTUNE="5292",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1702",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Shieldsmith
	{ID_ATTUNE="5292",ID="50",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1701",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="50"}, -- Fire Hardened Mail
	{ID_ATTUNE="5292",ID="51",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="6838",ICON="Interface\\Icons\\inv_misc_monsterfang_01",FOLLOWS="50",STAGE="55", COUNT=50}, -- Scorched Spider Fang
	{ID_ATTUNE="5292",ID="52",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="6839",ICON="Interface\\Icons\\inv_misc_horn_01",FOLLOWS="50",STAGE="55", COUNT=12}, -- Charred Horn
	{ID_ATTUNE="5292",ID="53",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stonetalon Mountains"],ID_WOWHEAD="6840",ICON="Interface\\Icons\\inv_misc_horn_02",FOLLOWS="50",STAGE="55"}, -- Galvanized Horn
	{ID_ATTUNE="5292",ID="54",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Razorfen Kraul"],ID_WOWHEAD="6841",ICON="Interface\\Icons\\inv_potion_01",FOLLOWS="50",STAGE="55"}, -- Vial of Phlogiston
	{ID_ATTUNE="5292",ID="57",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1701",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="51&52&53&54",STAGE="57"}, -- Fire Hardened Mail
	{ID_ATTUNE="5292",ID="60",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1704",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Klockmort Spannerspan
	{ID_ATTUNE="5292",ID="61",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1700",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Grimand Elmore
	{ID_ATTUNE="5292",ID="62",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1703",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Mathiel
	{ID_ATTUNE="5292",ID="63",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1782",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="57",STAGE="60"}, -- Furen's Armor
	{ID_ATTUNE="5292",ID="70",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1708",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="60",STAGE="70"}, -- Iron Coral
	{ID_ATTUNE="5292",ID="71",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1705",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="61",STAGE="70"}, -- Burning Blood
	{ID_ATTUNE="5292",ID="72",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1710",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="62",STAGE="70"}, -- Sunscorched Shells
	{ID_ATTUNE="5292",ID="73",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="63",STAGE="70"},
	{ID_ATTUNE="5292",ID="80",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dun Morogh"],ID_WOWHEAD="1709",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="70",STAGE="80"}, -- Klockmort's Creation
	{ID_ATTUNE="5292",ID="81",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Elwynn Forest"],ID_WOWHEAD="1706",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="71",STAGE="80"}, -- Grimand's Armor
	{ID_ATTUNE="5292",ID="82",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Teldrassil"],ID_WOWHEAD="1711",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="72",STAGE="80"}, -- Mathiel's Armor
	{ID_ATTUNE="5292",ID="83",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="73",STAGE="80"},
	{ID_ATTUNE="5292",ID="90",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_warrior_savageblow",FOLLOWS="80&83&82&81",STAGE="90"},

	{ID_ATTUNE="5293",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 30",LOCATION="",ID_WOWHEAD="30",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5293",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1718",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- The Islander
	{ID_ATTUNE="5293",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Durotar"],ID_WOWHEAD="1719",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- The Affray
	
    -- {ID_ATTUNE="5293",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1791",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- The Windwatcher
	-- Essence of the Exile stays on the left. One empty column, then liferoot and the tusks on the same row as the essence item.
	-- {ID_ATTUNE="5293",ID="45",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="1712",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="40",STAGE="45"}, -- Cyclonian
	-- {ID_ATTUNE="5293",ID="40",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    {ID_ATTUNE="5293",ID="41",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5293",ID="42",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	-- {ID_ATTUNE="5293",ID="52",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    {ID_ATTUNE="5293",ID="44",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Hillsbrad Foothills"],ID_WOWHEAD="1791",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="50"}, -- The Windwatcher
	{ID_ATTUNE="5293",ID="46",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
	{ID_ATTUNE="5293",ID="48",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="1714",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="0",STAGE="50"}, -- Essence of the Exile
	-- {ID_ATTUNE="5293",ID="49",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},
    -- {ID_ATTUNE="5293",ID="50",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="50"},

	{ID_ATTUNE="5293",ID="49",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="55"},
	{ID_ATTUNE="5293",ID="50",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="55"},
	{ID_ATTUNE="5293",ID="51",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="55"},
    {ID_ATTUNE="5293",ID="52",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="55"},
	{ID_ATTUNE="5293",ID="59",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="4480",ICON="Interface\\Icons\\inv_jewelry_talisman_02",FOLLOWS="48",STAGE="55", COUNT=8}, -- Thundering Charm
	{ID_ATTUNE="5293",ID="60",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="4479",ICON="Interface\\Icons\\inv_jewelry_talisman_01",FOLLOWS="48",STAGE="55", COUNT=8}, -- Burning Charm
	{ID_ATTUNE="5293",ID="61",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Arathi Highlands"],ID_WOWHEAD="4481",ICON="Interface\\Icons\\inv_jewelry_talisman_05",FOLLOWS="48",STAGE="55", COUNT=8}, -- Cresting Charm
    
	-- {ID_ATTUNE="5293",ID="62",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	{ID_ATTUNE="5293",ID="62",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="5293",ID="63",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="5293",ID="64",TYPE="Pick Up",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="1712",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="44",STAGE="60"}, -- Cyclonian
    {ID_ATTUNE="5293",ID="65",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
    {ID_ATTUNE="5293",ID="66",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="1714",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="61&60&59",STAGE="60"}, -- Essence of the Exile
    -- {ID_ATTUNE="5293",ID="67",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},
	-- {ID_ATTUNE="5293",ID="67",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="60"},

    {ID_ATTUNE="5293",ID="68",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="65"},
	{ID_ATTUNE="5293",ID="69",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Wetlands"],ID_WOWHEAD="3357",ICON="Interface\\Icons\\inv_misc_root_02",FOLLOWS="64",STAGE="65", COUNT=8}, -- Liferoot
	{ID_ATTUNE="5293",ID="70",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Stranglethorn Vale"],ID_WOWHEAD="3901",ICON="Interface\\Icons\\inv_misc_bone_06",FOLLOWS="64",STAGE="65", COUNT=30}, -- Bloodscalp Tusk
	-- {ID_ATTUNE="5293",ID="70",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="65"},
	{ID_ATTUNE="5293",ID="71",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="65"},
	{ID_ATTUNE="5293",ID="72",TYPE="Item",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="6851",ICON="Interface\\Icons\\inv_stone_01",FOLLOWS="66&64",STAGE="65"}, -- Essence of the Exile
	-- {ID_ATTUNE="5293",ID="73",TYPE="Spacer",STEP="Spacer",LOCATION="",ID_WOWHEAD="",ICON="",FOLLOWS="0",STAGE="65"},
	{ID_ATTUNE="5293",ID="80",TYPE="Turn In",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="1712",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="72&69&70",STAGE="70"}, -- Cyclonian
	{ID_ATTUNE="5293",ID="90",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="1713",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="80",STAGE="80"}, -- The Summoning
	{ID_ATTUNE="5293",ID="100",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Alterac Mountains"],ID_WOWHEAD="1792",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="90",STAGE="90"}, -- Whirlwind Weapon
	{ID_ATTUNE="5293",ID="110",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_skyreach_four_wind",FOLLOWS="100",STAGE="100"},

	{ID_ATTUNE="5294",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 50",LOCATION="",ID_WOWHEAD="50",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5294",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="8417",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- A Troubled Spirit
	{ID_ATTUNE="5294",ID="30",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="8423",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="20",STAGE="30"}, -- Warrior Kinship
	{ID_ATTUNE="5294",ID="40",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="8424",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="30",STAGE="40"}, -- War on the Shadowsworn
	{ID_ATTUNE="5294",ID="45",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20606",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="40",STAGE="45", COUNT=2}, -- Amber Voodoo Feather
	{ID_ATTUNE="5294",ID="46",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20607",ICON="Interface\\Icons\\inv_feather_11",FOLLOWS="40",STAGE="45", COUNT=2}, -- Blue Voodoo Feather
	{ID_ATTUNE="5294",ID="47",TYPE="Item",STEP="",LOCATION=FTAttuneLang["The Temple of Atal'Hakkar"],ID_WOWHEAD="20608",ICON="Interface\\Icons\\inv_feather_08",FOLLOWS="40",STAGE="45", COUNT=2}, -- Green Voodoo Feather
	{ID_ATTUNE="5294",ID="50",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Swamp of Sorrows"],ID_WOWHEAD="8425",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="45&46&47",STAGE="50"}, -- Voodoo Feathers
	{ID_ATTUNE="5294",ID="60",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\inv_feather_14",FOLLOWS="50",STAGE="60"},

	{ID_ATTUNE="5296",ID="10",TYPE="Level",STEP=FTAttuneLang["Reach level"].." 60",LOCATION="",ID_WOWHEAD="60",ICON="Interface\\Icons\\spell_holy_innerfire",FOLLOWS="0",STAGE="10"},
	{ID_ATTUNE="5296",ID="20",TYPE="Quest",STEP="",LOCATION=FTAttuneLang["Dire Maul"],ID_WOWHEAD="7499",ICON="Interface\\Icons\\inv_scroll_03",FOLLOWS="10",STAGE="20"}, -- Codex of Defense
	{ID_ATTUNE="5296",ID="30",TYPE="End",STEP="Attuned",LOCATION="",ID_WOWHEAD="0",ICON="Interface\\Icons\\ability_warrior_savageblow",FOLLOWS="20",STAGE="30"},
}

local classQuestInfo = {
	[3094]={1,1},
	[3120]={1,1},
	[5923]={10,1},
	[5924]={10,1},
	[5925]={10,1},
	[5921]={10,1},
	[5929]={10,1},
	[5931]={10,1},
	[6001]={10,1},
	[5926]={10,1},
	[5927]={10,1},
	[5928]={10,1},
	[5922]={10,1},
	[5930]={10,1},
	[5932]={10,1},
	[6002]={10,1},
	[7506]={60,5},
	[6121]={14,1},
	[6122]={14,1},
	[6123]={14,1},
	[6124]={14,1},
	[6125]={14,1},
	[6126]={14,1},
	[6127]={14,1},
	[6128]={14,1},
	[6129]={14,1},
	[6130]={14,1},
	[27]={16,1},
	[29]={16,1},
	[272]={16,1},
	[5061]={16,1},
	[26]={16,1},
	[28]={16,1},
	[30]={16,1},
	[31]={16,1},
	[9063]={50,1},
	[9052]={50,1},
	[9051]={50,1},
	[9053]={50,5},
	[98393]={20,1},
	[98394]={20,1},
	[98396]={20,1},
	[98731]={20,1},
	[98397]={20,1},
	[98340]={20,1},
	[98405]={20,1},
	[98341]={20,1},
	[98342]={20,1},
	[98404]={20,1},
	[98739]={20,1},
	[98738]={20,1},
	[98362]={20,1},
	[3092]={1,1},
	[3087]={1,1},
	[3108]={1,1},
	[3117]={1,1},
	[3082]={1,1},
	[6074]={10,1},
	[6075]={10,1},
	[6076]={10,1},
	[6064]={10,1},
	[6084]={10,1},
	[6085]={10,1},
	[6086]={10,1},
	[6071]={10,1},
	[6072]={10,1},
	[6073]={10,1},
	[6063]={10,1},
	[6101]={10,1},
	[6102]={10,1},
	[6103]={10,1},
	[6065]={10,1},
	[6066]={10,1},
	[6067]={10,1},
	[6061]={10,1},
	[6087]={10,1},
	[6088]={10,1},
	[6089]={10,1},
	[6068]={10,1},
	[6069]={10,1},
	[6070]={10,1},
	[6062]={10,1},
	[6083]={10,1},
	[6082]={10,1},
	[6081]={10,1},
	[8151]={50,1},
	[8153]={50,1},
	[8231]={50,1},
	[8232]={50,1},
	[7632]={60,1},
	[7634]={60,1},
	[7635]={60,1},
	[7636]={60,1},
	[7633]={60,1},
	[3104]={1,1},
	[3114]={1,1},
	[3098]={1,1},
	[3086]={1,1},
	[8328]={0,1},
	[1883]={10,1},
	[1884]={10,1},
	[1879]={10,1},
	[1880]={10,1},
	[1860]={10,1},
	[1861]={10,1},
	[1881]={10,1},
	[1882]={10,1},
	[93791]={10,1},
	[93797]={10,1},
	[94006]={10,1},
	[94638]={10,1},
	[1919]={15,1},
	[1920]={15,1},
	[1921]={15,1},
	[1941]={15,1},
	[1959]={15,1},
	[1960]={15,1},
	[1961]={15,1},
	[1962]={15,1},
	[1939]={26,1},
	[1938]={26,1},
	[1940]={26,1},
	[1942]={26,1},
	[1943]={26,1},
	[1944]={26,1},
	[1945]={26,1},
	[1946]={26,1},
	[1948]={30,1},
	[1947]={30,1},
	[1949]={30,1},
	[1950]={30,1},
	[1951]={30,1},
	[1952]={30,1},
	[1953]={35,1},
	[1954]={35,1},
	[1955]={35,1},
	[1956]={35,1},
	[1957]={35,1},
	[1958]={35,1},
	[8250]={50,1},
	[8251]={50,1},
	[8252]={50,1},
	[8253]={50,1},
	[9362]={60,1},
	[9364]={60,1},
	[3101]={1,1},
	[3107]={1,1},
	[1790]={12,1},
	[1789]={12,1},
	[1646]={12,1},
	[1647]={12,1},
	[1648]={12,1},
	[1778]={12,1},
	[1779]={12,1},
	[1783]={12,1},
	[1784]={12,1},
	[1785]={12,1},
	[1642]={12,1},
	[1643]={12,1},
	[1644]={12,1},
	[1780]={12,1},
	[1781]={12,1},
	[1786]={12,1},
	[1787]={12,1},
	[1788]={12,1},
	[2998]={12,1},
	[3681]={12,1},
	[1641]={12,1},
	[2997]={12,1},
	[2999]={12,1},
	[3000]={12,1},
	[1645]={12,1},
	[1655]={20,1},
	[1649]={20,1},
	[1650]={20,1},
	[1651]={20,1},
	[1652]={20,1},
	[1653]={20,1},
	[1442]={20,1},
	[1654]={20,1},
	[1806]={20,1},
	[1794]={20,1},
	[1793]={20,1},
	[94434]={12,1},
	[94435]={12,1},
	[94436]={12,1},
	[94438]={12,1},
	[94440]={12,1},
	[94441]={12,1},
	[91858]={18,1},
	[91859]={18,1},
	[91860]={18,1},
	[91861]={18,1},
	[91862]={18,1},
	[96204]={18,1},
	[95034]={18,1},
	[95036]={20,1},
	[95042]={20,1},
	[95111]={20,1},
	[95125]={20,1},
	[95126]={20,1},
	[95140]={20,1},
	[4485]={40,1},
	[1661]={40,1},
	[4486]={40,1},
	[8415]={50,1},
	[8414]={50,1},
	[8416]={50,1},
	[8418]={50,1},
	[7638]={60,1},
	[7637]={60,1},
	[7639]={60,1},
	[7640]={60,1},
	[7641]={60,1},
	[7642]={60,1},
	[7643]={60,1},
	[7648]={60,1},
	[7644]={60,1},
	[7645]={60,1},
	[7646]={60,1},
	[7647]={60,1},
	[7666]={60,1},
	[7670]={60,1},
	[3103]={1,1},
	[3110]={1,1},
	[3097]={1,1},
	[3119]={1,1},
	[3085]={1,1},
	[8564]={0,1},
	[5651]={5,1},
	[5650]={5,1},
	[5649]={5,1},
	[5648]={5,1},
	[5623]={5,1},
	[5624]={5,1},
	[5626]={5,1},
	[5625]={5,1},
	[5622]={5,1},
	[5621]={5,1},
	[5638]={10,1},
	[5636]={10,1},
	[5634]={10,1},
	[5639]={10,1},
	[5635]={10,1},
	[5637]={10,1},
	[5640]={10,1},
	[5652]={10,1},
	[5655]={10,1},
	[5654]={10,1},
	[5657]={10,1},
	[5656]={10,1},
	[5628]={10,1},
	[5629]={10,1},
	[5630]={10,1},
	[5631]={10,1},
	[5632]={10,1},
	[5633]={10,1},
	[5627]={10,1},
	[5658]={10,1},
	[5661]={10,1},
	[5660]={10,1},
	[5662]={10,1},
	[5663]={10,1},
	[5647]={20,1},
	[5645]={20,1},
	[5641]={20,1},
	[5678]={20,1},
	[5677]={20,1},
	[5676]={20,1},
	[5646]={20,1},
	[5679]={20,1},
	[5644]={20,1},
	[5672]={20,1},
	[5674]={20,1},
	[5673]={20,1},
	[5675]={20,1},
	[5680]={20,1},
	[5643]={20,1},
	[5642]={20,1},
	[8254]={50,1},
	[8255]={50,1},
	[8256]={50,1},
	[8257]={50,1},
	[7621]={60,1},
	[7622]={60,1},
	[3102]={1,1},
	[3113]={1,1},
	[3088]={1,1},
	[3109]={1,1},
	[3096]={1,1},
	[3118]={1,1},
	[3083]={1,1},
	[2241]={10,1},
	[2242]={10,1},
	[2218]={10,1},
	[2238]={10,1},
	[2239]={10,1},
	[2018]={10,1},
	[2205]={10,1},
	[2206]={10,1},
	[1885]={10,1},
	[1886]={10,1},
	[1898]={10,1},
	[1899]={10,1},
	[1978]={10,1},
	[1859]={10,1},
	[1963]={10,1},
	[1858]={10,1},
	[2019]={10,1},
	[2259]={16,1},
	[2299]={16,1},
	[2300]={16,1},
	[2260]={16,1},
	[2298]={16,1},
	[2281]={16,1},
	[2282]={16,1},
	[2378]={16,1},
	[2380]={16,1},
	[2379]={16,1},
	[2382]={16,1},
	[2381]={16,1},
	[1998]={16,1},
	[1999]={16,1},
	[2460]={20,1},
	[2458]={20,1},
	[2478]={20,1},
	[2479]={20,1},
	[2480]={20,1},
	[2360]={20,1},
	[2359]={20,1},
	[2607]={20,1},
	[2608]={20,1},
	[2609]={20,1},
	[6681]={24,1},
	[6701]={24,1},
	[8249]={50,1},
	[8233]={50,1},
	[8234]={50,1},
	[8235]={50,1},
	[8236]={50,1},
	[3093]={1,1},
	[3089]={1,1},
	[3084]={1,1},
	[752]={2,1},
	[753]={3,1},
	[755]={3,1},
	[757]={4,1},
	[763]={5,1},
	[1516]={4,1},
	[1517]={4,1},
	[1463]={4,1},
	[1518]={4,1},
	[1519]={4,1},
	[1520]={4,1},
	[1462]={4,1},
	[1521]={4,1},
	[1522]={10,1},
	[1523]={10,1},
	[2983]={10,1},
	[2984]={10,1},
	[1524]={10,1},
	[1525]={10,1},
	[1526]={10,1},
	[1464]={10,1},
	[1527]={10,1},
	[1528]={20,1},
	[1529]={20,1},
	[2985]={20,1},
	[2986]={20,1},
	[1530]={20,1},
	[1535]={20,1},
	[1536]={20,1},
	[1534]={20,1},
	[220]={20,1},
	[63]={20,1},
	[100]={20,1},
	[96]={20,1},
	[1103]={20,1},
	[972]={20,1},
	[1532]={30,1},
	[1531]={30,1},
	[94789]={30,1},
	[96264]={33,1},
	[79358]={40,1},
	[96135]={40,1},
	[96016]={40,1},
	[79360]={33,1},
	[79364]={33,1},
	[79361]={40,1},
	[79366]={40,1},
	[79442]={40,1},
	[96243]={10,1},
	[94373]={4,1},
	[94374]={4,1},
	[94375]={4,1},
	[94449]={10,1},
	[94465]={11,1},
	[94466]={14,1},
	[94467]={14,1},
	[94468]={14,1},
	[94495]={22,1},
	[94497]={22,1},
	[94499]={22,1},
	[94500]={23,1},
	[94501]={23,1},
	[94502]={23,1},
	[94503]={23,1},
	[94505]={23,1},
	[8410]={50,1},
	[8411]={50,1},
	[8412]={50,1},
	[8413]={50,1},
	[8259]={58,1},
	[7669]={58,1},
	[7668]={58,1},
	[7667]={58,1},
	[8258]={58,1},
	[1599]={1,1},
	[1470]={1,1},
	[3105]={1,1},
	[3115]={1,1},
	[3090]={1,1},
	[3099]={1,1},
	[1598]={1,1},
	[1485]={1,1},
	[1499]={1,1},
	[8563]={0,1},
	[8344]={0,1},
	[1685]={10,1},
	[1715]={10,1},
	[1688]={10,1},
	[1689]={10,1},
	[1478]={10,1},
	[1473]={10,1},
	[1471]={10,1},
	[1506]={10,1},
	[1501]={10,1},
	[1504]={10,1},
	[65593]={20,1},
	[65601]={20,1},
	[1717]={20,1},
	[1716]={20,1},
	[1738]={20,1},
	[1739]={20,1},
	[65603]={20,1},
	[65604]={20,1},
	[65597]={20,1},
	[1472]={20,1},
	[1476]={20,1},
	[1474]={20,1},
	[1507]={20,1},
	[1508]={20,1},
	[1509]={20,1},
	[1510]={20,1},
	[1511]={20,1},
	[1515]={20,1},
	[1512]={20,1},
	[1513]={20,1},
	[1740]={20,1},
	[65602]={20,1},
	[65610]={20,1},
	[1798]={30,1},
	[1758]={30,1},
	[1802]={30,1},
	[1804]={30,1},
	[1795]={30,1},
	[2996]={30,1},
	[3001]={30,1},
	[1801]={30,1},
	[1803]={30,1},
	[1805]={30,1},
	[1795]={30,1},
	[4737]={31,1},
	[4738]={31,1},
	[1796]={31,1},
	[4781]={31,1},
	[4782]={31,1},
	[4783]={31,1},
	[4784]={31,1},
	[4785]={31,1},
	[4786]={31,1},
	[4736]={31,1},
	[4739]={31,1},
	[1796]={31,1},
	[4781]={31,1},
	[4782]={31,1},
	[4783]={31,1},
	[4784]={31,1},
	[4785]={31,1},
	[4786]={31,1},
	[4965]={35,1},
	[4967]={35,1},
	[1799]={35,1},
	[4961]={35,1},
	[4962]={35,1},
	[4963]={35,1},
	[4976]={35,1},
	[4964]={35,1},
	[4975]={35,1},
	[4968]={35,1},
	[4969]={35,1},
	[1799]={35,1},
	[4961]={35,1},
	[4962]={35,1},
	[4963]={35,1},
	[4976]={35,1},
	[4964]={35,1},
	[4975]={35,1},
	[4487]={40,1},
	[4488]={40,1},
	[4490]={40,1},
	[3631]={40,1},
	[4489]={40,1},
	[4490]={40,1},
	[7601]={50,1},
	[7602]={50,1},
	[7603]={50,1},
	[8419]={50,1},
	[8420]={50,1},
	[8421]={50,1},
	[8422]={50,1},
	[7562]={60,1},
	[7623]={60,1},
	[7563]={60,1},
	[7624]={60,1},
	[7564]={60,1},
	[7625]={60,1},
	[7626]={60,1},
	[7627]={60,1},
	[7628]={60,1},
	[7629]={60,1},
	[7630]={60,1},
	[7631]={60,1},
	[7581]={60,1},
	[7582]={60,1},
	[7583]={60,1},
	[3100]={1,1},
	[3112]={1,1},
	[3091]={1,1},
	[2383]={1,1},
	[3106]={1,1},
	[3095]={1,1},
	[3116]={1,1},
	[3065]={1,1},
	[1638]={10,1},
	[1639]={10,1},
	[1640]={10,1},
	[1665]={10,1},
	[1666]={10,1},
	[1667]={10,1},
	[1505]={10,1},
	[1498]={10,1},
	[1502]={10,1},
	[1503]={10,1},
	[1679]={10,1},
	[1678]={10,1},
	[1680]={10,1},
	[1681]={10,1},
	[1682]={10,1},
	[1818]={10,1},
	[1819]={10,1},
	[1820]={10,1},
	[1821]={10,1},
	[1822]={10,1},
	[1684]={10,1},
	[1683]={10,1},
	[1686]={10,1},
	[1692]={10,1},
	[1693]={10,1},
	[1823]={20,1},
	[1824]={20,1},
	[1825]={20,1},
	[1838]={20,1},
	[1839]={20,1},
	[1840]={20,1},
	[1841]={20,1},
	[1848]={20,1},
	[1842]={20,1},
	[1844]={20,1},
	[1846]={20,1},
	[1843]={20,1},
	[1845]={20,1},
	[1847]={20,1},
	[1698]={20,1},
	[1699]={20,1},
	[1702]={20,1},
	[1701]={20,1},
	[1700]={20,1},
	[1703]={20,1},
	[1704]={20,1},
	[1705]={20,1},
	[1708]={20,1},
	[1710]={20,1},
	[1706]={20,1},
	[1709]={20,1},
	[1711]={20,1},
	[1782]={20,1},
	[1718]={30,1},
	[1719]={30,1},
	[1791]={30,1},
	[1712]={30,1},
	[1713]={30,1},
	[1714]={30,1},
	[1792]={30,1},
	[8417]={50,1},
	[8423]={50,1},
	[8424]={50,1},
	[8425]={50,5},
	[7499]={60,5},
}

local classQuestGivers = {
	[3120] = {1438, 58.6, 44.2, "Conservator Ilthalaine"}, -- Conservator Ilthalaine, Teldrassil
	[5923] = {1457, 34.8, 7.8, "Denatharion"}, -- Denatharion, Darnassus
	[5924] = {1453, 21.4, 51.4, "Theridran"}, -- Theridran, Stormwind City
	[5925] = {1438, 56, 61.6, "Kal"}, -- Kal, Teldrassil
	[5921] = {1457, 35.2, 8, "Mathrengyl Bearwalker"}, -- Mathrengyl Bearwalker, Darnassus
	[5929] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[5931] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[6001] = {1457, 35.2, 8, "Mathrengyl Bearwalker"}, -- Mathrengyl Bearwalker, Darnassus
	[5926] = {1456, 45.8, 64.4, "Innkeeper Pala"}, -- Innkeeper Pala
	[5927] = {1454, 54.1, 68.4, "Innkeeper Gryshka"}, -- Innkeeper Gryshka
	[5928] = {1412, 48.5, 59.6, "Gennia Runetotem"}, -- Gennia Runetotem
	[5922] = {1456, 76.4, 27.6, "Turak Runetotem"}, -- Turak Runetotem, Thunder Bluff
	[5930] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[6002] = {1456, 76.4, 27.6, "Turak Runetotem"}, -- Turak Runetotem, Thunder Bluff
	[6121] = {1457, 35.2, 8, "Mathrengyl Bearwalker"}, -- Mathrengyl Bearwalker, Darnassus
	[6122] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[6123] = {1439, 37.6, 40.6, "Alanndarian Nightsong"}, -- Alanndarian Nightsong, Darkshore
	[6124] = {1439, 37.6, 40.6, "Alanndarian Nightsong"}, -- Alanndarian Nightsong, Darkshore
	[6125] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[6126] = {1456, 76.4, 27.6, "Turak Runetotem"}, -- Turak Runetotem, Thunder Bluff
	[6127] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[6128] = {1413, 52.2, 31.8, "Tonga Runetotem"}, -- Tonga Runetotem, The Barrens
	[6129] = {1413, 52.2, 31.8, "Tonga Runetotem"}, -- Tonga Runetotem, The Barrens
	[27] = {1456, 76.4, 27.6, "Turak Runetotem"}, -- Turak Runetotem, Thunder Bluff
	[29] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[272] = {1450, 36.4, 40.2, "Tajarri"}, -- Tajarri, Moonglade
	[5061] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[26] = {1457, 35.2, 8, "Mathrengyl Bearwalker"}, -- Mathrengyl Bearwalker, Darnassus
	[28] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[30] = {1450, 36.4, 40.2, "Tajarri"}, -- Tajarri, Moonglade
	[9063] = {1456, 76.4, 27.6, "Turak Runetotem"}, -- Turak Runetotem, Thunder Bluff (also Loganaar, Moonglade 52.4, 40.4; Theridran, Stormwind City 21.4, 51.4; Mathrengyl Bearwalker, Darnassus 35.2, 8)
	[9052] = {1449, 71.6, 76, "Torwa Pathfinder"}, -- Torwa Pathfinder, Un'Goro Crater
	[9051] = {1449, 71.6, 76, "Torwa Pathfinder"}, -- Torwa Pathfinder, Un'Goro Crater
	[9053] = {1449, 71.6, 76, "Torwa Pathfinder"}, -- Torwa Pathfinder, Un'Goro Crater
	[98393] = {1457, 35.4, 8.4, "Mathrengyl Bearwalker"}, -- Mathrengyl Bearwalker
	[98394] = {1450, 56.2, 30.6, "Dendrite Starblaze"}, -- Dendrite Starblaze
	[98396] = {1450, 54.6, 75.0, "Great Cat Spirit"}, -- Great Cat Spirit
	[98731] = {1450, 54.6, 75.0, "Great Cat Spirit"}, -- Great Cat Spirit
	[98397] = {1450, 56.2, 30.6, "Dendrite Starblaze"}, -- Dendrite Starblaze
	[98340] = {1456, 76.5, 27.2, "Turak Runetotem"}, -- Turak Runetotem
	[98405] = {1450, 56.2, 30.6, "Dendrite Starblaze"}, -- Dendrite Starblaze
	[98341] = {1450, 56.2, 30.6, "Dendrite Starblaze"}, -- Dendrite Starblaze
	[98342] = {1450, 54.6, 75.0, "Great Cat Spirit"}, -- Great Cat Spirit
	[98404] = {1450, 44.0, 73.4, "Avatar of Saeyleenan"}, -- Avatar of Saeyleenan
	[98739] = {1450, 54.6, 75.0, "Great Cat Spirit"}, -- Great Cat Spirit
	[98738] = {1450, 44.0, 73.4, "Avatar of Saeyleenan"}, -- Avatar of Saeyleenan
	[98362] = {1450, 56.2, 30.6, "Dendrite Starblaze"}, -- Dendrite Starblaze
	[3087] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[3108] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[3117] = {1438, 58.6, 44.2, "Conservator Ilthalaine"}, -- Conservator Ilthalaine, Teldrassil
	[3082] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[6074] = {1426, 29.2, 67.5, "Thorgas Grimson"}, -- Thorgas Grimson, Coldridge Valley
	[6075] = {1455, 69.9, 82.9, "Regnus Thundergranite"}, -- Regnus Thundergranite, Ironforge
	[6076] = {1453, 67.3, 36.2, "Einris Brightspear"}, -- Einris Brightspear, Stormwind
	[6064] = {1426, 45.8, 53.0, "Grif Wildheart"}, -- Grif Wildheart, Kharanos
	[6084] = {1426, 45.8, 53.0, "Grif Wildheart"}, -- Grif Wildheart, Kharanos
	[6085] = {1426, 45.8, 53.0, "Grif Wildheart"}, -- Grif Wildheart, Kharanos
	[6086] = {1455, 70.9, 85.8, "Belia Thundergranite"}, -- Belia Thundergranite, Ironforge
	[6071] = {1457, 40.4, 8.6, "Jocaste"}, -- Jocaste, Darnassus
	[6072] = {1438, 58.7, 40.5, "Ayanna Everstride"}, -- Ayanna Everstride, Shadowglen
	[6073] = {1457, 42.2, 7.3, "Dorion"}, -- Dorion, Darnassus
	[6063] = {1438, 56.7, 59.5, "Dazalar"}, -- Dazalar, Dolanaar
	[6101] = {1438, 56.7, 59.5, "Dazalar"}, -- Dazalar, Dolanaar
	[6102] = {1438, 56.7, 59.5, "Dazalar"}, -- Dazalar, Dolanaar
	[6103] = {1457, 40.4, 8.6, "Jocaste"}, -- Jocaste, Darnassus
	[6065] = {1456, 58.5, 88.3, "Kary Thunderhorn"}, -- Kary Thunderhorn, Thunder Bluff
	[6066] = {1412, 44.0, 76.3, "Lanka Farshot"}, -- Lanka Farshot, Mulgore
	[6067] = {1411, 51.9, 43.5, "Thotar"}, -- Thotar, Razor Hill
	[6061] = {1412, 46.9, 59.6, "Yaw Sharpmane"}, -- Yaw Sharpmane, Bloodhoof Village
	[6087] = {1412, 46.9, 59.6, "Yaw Sharpmane"}, -- Yaw Sharpmane, Bloodhoof Village
	[6088] = {1412, 46.9, 59.6, "Yaw Sharpmane"}, -- Yaw Sharpmane, Bloodhoof Village
	[6089] = {1412, 46.9, 59.6, "Yaw Sharpmane"}, -- Yaw Sharpmane, Bloodhoof Village
	[6068] = {1411, 42.8, 69.3, "Jen'shan"}, -- Jen'shan, Valley of Trials
	[6069] = {1454, 68.0, 17.8, "Sian'dur"}, -- Sian'dur, Orgrimmar
	[6070] = {1454, 68.0, 17.8, "Sian'dur"}, -- Sian'dur, Orgrimmar
	[6062] = {1411, 51.9, 43.5, "Thotar"}, -- Thotar, Razor Hill
	[6083] = {1411, 51.9, 43.5, "Thotar"}, -- Thotar, Razor Hill
	[6082] = {1411, 51.9, 43.5, "Thotar"}, -- Thotar, Razor Hill
	[6081] = {1411, 51.9, 43.5, "Thotar"}, -- Thotar, Razor Hill
	[8151] = {1453, 62, 15, "Ulfir Ironbeard"}, -- Ulfir Ironbeard, Stormwind City (also Olmin Burningbeard, Ironforge 70.6, 83.8; Ormak Grimshot, Orgrimmar 66.2, 18.2; Holt Thunderhorn, Thunder Bluff 57.4, 89.2; Dorion, Darnassus 42.2, 7.6)
	[8153] = {1447, 42.4, 42.6, "Ogtinc"}, -- Ogtinc, Azshara
	[8231] = {1447, 42.4, 42.6, "Ogtinc"}, -- Ogtinc, Azshara
	[8232] = {1447, 42.4, 42.6, "Ogtinc"}, -- Ogtinc, Azshara
	[7632] = {1448, 48.8, 24.2, "Vartrus the Ancient"}, -- started by The Ancient Leaf; speak to Vartrus the Ancient, Felwood
	[7634] = {1448, 48.2, 24.2, "Hastat the Ancient"}, -- Hastat the Ancient, Felwood
	[7635] = {1448, 48.6, 23.2, "Stoma the Ancient"}, -- Stoma the Ancient, Felwood
	[7636] = {1448, 48.8, 24.2, "Vartrus the Ancient"}, -- Vartrus the Ancient, Felwood
	[7633] = {1448, 48.8, 24.2, "Vartrus the Ancient"}, -- Vartrus the Ancient, Felwood
	[3104] = {1429, 48.8, 41.6, "Marshal McBride"}, -- Marshal McBride, Elwynn Forest
	[3114] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[3098] = {1420, 30.8, 66.2, "Shadow Priest Sarvis"}, -- Shadow Priest Sarvis, Tirisfal Glades
	[3086] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[1883] = {1454, 39, 86, "Uthel'nay"}, -- Uthel'nay, Orgrimmar (also Thurston Xane, Thunder Bluff 25, 20.6)
	[1884] = {1411, 56.2, 75, "Un'Thuwa"}, -- Un'Thuwa, Sen'jin Village
	[1879] = {1426, 47.4, 52, "Magis Sparkmantle"}, -- Magis Sparkmantle, Kharanos
	[1880] = {1455, 27, 8.2, "Bink"}, -- Bink, Ironforge
	[1860] = {1429, 43.2, 66.2, "Zaldimar Wefhellt"}, -- Zaldimar Wefhellt, Goldshire
	[1861] = {1453, 38.6, 79.4, "Jennea Cannon"}, -- Jennea Cannon, Stormwind
	[1881] = {1420, 61.8, 52.4, "Cain Firesong"}, -- Cain Firesong, Brill
	[1882] = {1458, 85, 10.2, "Anastasia Hartwell"}, -- Anastasia Hartwell, Undercity
	[93791] = {2991, 65.8, 80.4, "Anathamaas Aetherwind"}, -- Anathamaas Aetherwind, Valanaar
	[93797] = {2991, 62.8, 77.4, "Belann Windwood"}, -- Belann Windwood, Valanaar
	[94006] = {2991, 64.0, 75.1, "Lotheluum Starbreeze"}, -- Lotheluum Starbreeze, Valanaar
	[94638] = {2991, 69.8, 61.7, "Urs'endris"}, -- Urs'endris, East Pylon Watchtower
	[1919] = {1429, 43.2, 66.2, "Zaldimar Wefhellt"}, -- Zaldimar Wefhellt, Elwynn Forest (also Dink, Ironforge 26.8, 8.4)
	[1920] = {1453, 38.6, 79.4, "Jennea Cannon"}, -- Jennea Cannon, Stormwind City
	[1921] = {1453, 38.6, 79.4, "Jennea Cannon"}, -- Jennea Cannon, Stormwind City
	[1941] = {1453, 41.6, 76.6, "Wynne Larson"}, -- Wynne Larson, Stormwind City
	[1959] = {1454, 39, 86, "Uthel'nay"}, -- Uthel'nay, Orgrimmar (also Cain Firesong, Tirisfal Glades 61.8, 52.4; Thurston Xane, Thunder Bluff 25, 20.6)
	[1960] = {1458, 85, 10.2, "Anastasia Hartwell"}, -- Anastasia Hartwell, Undercity
	[1961] = {1458, 85, 10.2, "Anastasia Hartwell"}, -- Anastasia Hartwell, Undercity
	[1962] = {1458, 70.2, 30.2, "Rhiannon Davis"}, -- Rhiannon Davis, Undercity
	[1939] = {1453, 38.6, 79.4, "Jennea Cannon"}, -- Jennea Cannon, Stormwind City (also Bink, Ironforge 27, 8.2)
	[1938] = {1453, 37.6, 81.6, "High Sorcerer Andromath"}, -- High Sorcerer Andromath, Stormwind City
	[1940] = {1453, 37.6, 81.6, "High Sorcerer Andromath"}, -- High Sorcerer Andromath, Stormwind City
	[1942] = {1453, 41.6, 76.6, "Wynne Larson"}, -- Wynne Larson, Stormwind City
	[1943] = {1458, 85, 10.2, "Anastasia Hartwell"}, -- Anastasia Hartwell, Undercity
	[1944] = {1454, 38.4, 85.8, "Deino"}, -- Deino, Orgrimmar
	[1945] = {1454, 38.4, 85.8, "Deino"}, -- Deino, Orgrimmar
	[1946] = {1413, 52.2, 31.6, "Kil'hala"}, -- Kil'hala, The Barrens
	[1948] = {1445, 46.0, 57.0, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[1947] = {1453, 38.6, 79.4, "Jennea Cannon"}, -- Jennea Cannon, Stormwind City (also Anastasia Hartwell, Undercity 85, 10.2; Bink, Ironforge 27, 8.2; Deino, Orgrimmar 38.4, 85.8; Ursyn Ghull, Thunder Bluff 25.6, 14.6)
	[1949] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[1950] = {1441, 78.2, 75.8, "Magus Tirth"}, -- Magus Tirth, Thousand Needles
	[1951] = {1441, 78.2, 75.8, "Magus Tirth"}, -- Magus Tirth, Thousand Needles
	[1952] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[1953] = {1458, 85, 10.2, "Anastasia Hartwell"}, -- Anastasia Hartwell, Undercity (also Jennea Cannon, Stormwind City 38.6, 79.4; Bink, Ironforge 27, 8.2; Deino, Orgrimmar 38.4, 85.8; Ursyn Ghull, Thunder Bluff 25.6, 14.6)
	[1954] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[1955] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[1956] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[1957] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[1958] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[8250] = {1458, 85.4, 13.8, "Pierce Shackleton"}, -- Pierce Shackleton, Undercity (also Maginor Dumas, Stormwind City 38, 81.6; Dink, Ironforge 26.8, 8.4; Uthel'nay, Orgrimmar 39, 86; Archmage Shymm, Thunder Bluff 22.6, 14.8)
	[8251] = {1447, 29.2, 40.2, "Archmage Xylem"}, -- Archmage Xylem, Azshara
	[8252] = {1447, 29.2, 40.2, "Archmage Xylem"}, -- Archmage Xylem, Azshara
	[8253] = {1447, 29.2, 40.2, "Archmage Xylem"}, -- Archmage Xylem, Azshara
	[9362] = {1447, 29.2, 40.2, "Archmage Xylem"}, -- Archmage Xylem, Azshara
	[9364] = {1447, 29.2, 40.2, "Archmage Xylem"}, -- Archmage Xylem, Azshara
	[3101] = {1429, 48.8, 41.6, "Marshal McBride"}, -- Marshal McBride, Elwynn Forest
	[3107] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[1790] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall, Cathedral of Light
	[1789] = {1455, 27.4, 12.0, "Tiza Battleforge"}, -- Tiza Battleforge, Hall of Mysteries
	[1642] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- started by item 6775; speak to Duthorian Rall
	[1646] = {1455, 27.4, 12.0, "Tiza Battleforge"}, -- started by item 6916; speak to Tiza Battleforge
	[1647] = {1455, 27.4, 12.0, "Tiza Battleforge"}, -- Tiza Battleforge
	[1648] = {1455, 22.6, 55.2, "John Turner"}, -- John Turner, Ironforge Commons
	[1778] = {1455, 22.6, 55.2, "John Turner"}, -- John Turner
	[1779] = {1455, 27.4, 12.0, "Tiza Battleforge"}, -- Tiza Battleforge
	[1783] = {1455, 23.6, 8.6, "Muiredon Battleforge"}, -- Muiredon Battleforge
	[1784] = {1426, 78.2, 58.0, "Narm Faulk"}, -- Narm Faulk, Helm's Bed Lake
	[1785] = {1455, 23.6, 8.6, "Muiredon Battleforge"}, -- Muiredon Battleforge
	[1643] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall
	[1644] = {1453, 57.0, 61.6, "Stephanie Turner"}, -- Stephanie Turner, Trade District
	[1780] = {1453, 57.0, 61.6, "Stephanie Turner"}, -- Stephanie Turner
	[1781] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall
	[1786] = {1453, 38.6, 26.6, "Gazin Tenorm"}, -- Gazin Tenorm
	[1787] = {1429, 72.6, 51.6, "Henze Faulk"}, -- Henze Faulk, Stone Cairn Lake
	[1788] = {1453, 38.6, 26.6, "Gazin Tenorm"}, -- Gazin Tenorm
	[2998] = {1429, 41.0, 66.0, "Brother Wilhelm"}, -- Brother Wilhelm, Goldshire
	[3681] = {1455, 23.4, 6.4, "Brandur Ironhammer"}, -- Brandur Ironhammer
	[1641] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall
	[2997] = {1426, 47.6, 52.0, "Azar Stronghammer"}, -- Azar Stronghammer, Kharanos
	[2999] = {1455, 23.4, 6.4, "Brandur Ironhammer"}, -- Brandur Ironhammer
	[3000] = {1453, 37.4, 32.8, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker
	[1645] = {1455, 27.4, 12.0, "Tiza Battleforge"}, -- Tiza Battleforge
	[1649] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall, Cathedral of Light. Wowhead lists him as the end.
	[1650] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall
	[1651] = {1436, 42.2, 88.6, "Daphne Stilwell"}, -- Daphne Stilwell, Westfall. Also pinned at 41.4, 88.4.
	[1652] = {1436, 42.2, 88.6, "Daphne Stilwell"}, -- Daphne Stilwell
	[1653] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall
	[1655] = {1432, 36.0, 45.0, "Bailor Stonehand"}, -- Bailor Stonehand, Thelsamar
	[1442] = {1439, 37.4, 40.2, "Thundris Windweaver"}, -- Thundris Windweaver, Auberdine
	[1654] = {1426, 52.6, 36.8, "Jordan Stilwell"}, -- Jordan Stilwell, outside the Ironforge gates. Also pinned at 52.4, 36.8.
	[1806] = {1426, 52.6, 36.8, "Jordan Stilwell"}, -- Jordan Stilwell
	[91858] = {1420, 22.0, 44.6, "Danitha Morr"}, -- Danitha Morr, Tirisfal Glades
	[91859] = {1421, 43.4, 41.0, "Trevan Rol"}, -- Trevan Rol, the Sepulcher
	[91860] = {1421, 45.8, 41.8, "Deathguard Baldren"}, -- Deathguard Baldren, the Sepulcher
	[91861] = {1421, 65.0, 34.2, "Charred Remains"}, -- Charred Remains, Fenris Isle
	[91862] = {1421, 65.7, 27.4, "Lumina Windsinger"}, -- Lumina Windsinger, Fenris Keep. Also pinned nearby, including 65.6, 23.2.
	[96204] = {1421, 65.7, 27.4, "Lumina Windsinger"}, -- Lumina Windsinger, Fenris Keep. Turn-in is the Sepulcher at 43.2, 41.0.
	[94434] = {1458, 65.4, 37.8, "Tanis Alderwood"}, -- Tanis Alderwood, Undercity. Also pinned nearby in the Trade Quarter.
	[94435] = {1458, 65.4, 37.8, "Tanis Alderwood"}, -- Tanis Alderwood
	[94436] = {1420, 22.0, 44.6, "Danitha Morr"}, -- Danitha Morr, Bandarion Keep
	[94438] = {1420, 22.0, 44.4, "Deathguard Billmuth"}, -- Deathguard Billmuth, Bandarion Keep
	[94440] = {1420, 86.6, 47.6, "Deathguard Falgan"}, -- Deathguard Falgan, Venomweb Vale. Also pinned at 86.4, 47.8 and 86.6, 47.4.
	[94441] = {1420, 22.0, 44.4, "Deathguard Billmuth"}, -- Deathguard Billmuth
	[95034] = {1421, 43.2, 41.0, "Lumina Windsinger"}, -- Lumina Windsinger, the Sepulcher
	[95036] = {1421, 43.2, 41.0, "Lumina Windsinger"}, -- Lumina Windsinger. Turn in to Trevan Rol at 43.4, 41.0.
	[95042] = {1440, 11.8, 34.6, "Ulric Frostveil"}, -- Ulric Frostveil, Zoram Strand. Also pinned at 11.8, 34.4.
	[95111] = {1421, 43.4, 41.0, "Trevan Rol"}, -- Trevan Rol, the Sepulcher
	[95125] = {1424, 60.4, 26.0, "Ott"}, -- Ott, Tarren Mill. Also pinned at 60.6, 26.0.
	[95126] = {1424, 60.6, 26.0, "Ott"}, -- Ott, Hillsbrad Foothills. Also pinned at 60.4, 26.0.
	[95140] = {1421, 43.2, 41.0, "Lumina Windsinger"}, -- Lumina Windsinger, the Sepulcher
	[1793] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall, Cathedral of Light
	[1794] = {1455, 27.4, 12.0, "Tiza Battleforge"}, -- Tiza Battleforge, Hall of Mysteries
	[4485] = {1455, 27.4, 12.0, "Tiza Battleforge"}, -- Tiza Battleforge, Hall of Mysteries
	[4486] = {1455, 23.4, 6.4, "Brandur Ironhammer"}, -- Brandur Ironhammer
	[1661] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall, Cathedral of Light
	[8415] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City (also Brandur Ironhammer, Ironforge 23.4, 6.2)
	[8414] = {1422, 42.8, 84, "Commander Ashlam Valorfist"}, -- Commander Ashlam Valorfist, Western Plaguelands
	[8416] = {1422, 52, 82.8, "High Priest Thel'danis"}, -- High Priest Thel'danis, Western Plaguelands
	[8418] = {1422, 42.8, 84.0, "Commander Ashlam Valorfist"}, -- Commander Ashlam Valorfist, Chillwind Camp
	[7638] = {1453, 39.8, 29.8, "Duthorian Rall"}, -- Duthorian Rall, Cathedral of Light
	[7670] = {1455, 23.4, 6.4, "Brandur Ironhammer"}, -- Brandur Ironhammer
	[7637] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City
	[7639] = {1455, 25, 8.4, "High Priest Rohan"}, -- High Priest Rohan, Ironforge
	[7640] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City
	[7641] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City
	[7642] = {1453, 51.6, 12.2, "Grimand Elmore"}, -- Grimand Elmore, Stormwind City
	[7643] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City
	[7648] = {1453, 51.6, 12.2, "Grimand Elmore"}, -- Grimand Elmore, Stormwind City
	[7644] = {234, nil, nil, "Ancient Equine Spirit"}, -- Ancient Equine Spirit, Dire Maul. Wowhead lists no coordinates.
	[7645] = {1424, 52, 55.6, "Merideth Carlson"}, -- Merideth Carlson, Hillsbrad Foothills
	[7646] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City
	[7666] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City
	[3103] = {1429, 48.8, 41.6, "Marshal McBride"}, -- Marshal McBride, Elwynn Forest
	[3110] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[3097] = {1420, 30.8, 66.2, "Shadow Priest Sarvis"}, -- Shadow Priest Sarvis, Tirisfal Glades
	[3119] = {1438, 58.6, 44.2, "Conservator Ilthalaine"}, -- Conservator Ilthalaine, Teldrassil
	[3085] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[5651] = {1420, 31, 66, "Dark Cleric Duesten"}, -- Dark Cleric Duesten, Deathknell
	[5650] = {1420, 61.6, 52.2, "Dark Cleric Beryl"}, -- Dark Cleric Beryl, Brill
	[5649] = {1411, 42.4, 68.8, "Ken'jai"}, -- Ken'jai, Sen'jin Village
	[5648] = {1411, 54.2, 42.8, "Tai'jin"}, -- Tai'jin, Razor Hill
	[5623] = {1429, 49.8, 39.6, "Priestess Anetta"}, -- Priestess Anetta, Northshire
	[5624] = {1429, 43.4, 65.6, "Priestess Josetta"}, -- Priestess Josetta, Goldshire
	[5626] = {1426, 28.6, 66.4, "Branstock Khalder"}, -- Branstock Khalder, Coldridge Valley
	[5625] = {1426, 47.2, 52.2, "Maxan Anvol"}, -- Maxan Anvol, Kharanos
	[5622] = {1438, 59.2, 40.4, "Shanda"}, -- Shanda, Shadowglen
	[5621] = {1438, 55.6, 56.8, "Laurna Morninglight"}, -- Laurna Morninglight, Dolanaar
	[5638] = {1453, 20.8, 50.2, "Nara Meideros"}, -- Nara Meideros, Stormwind City
	[5636] = {1438, 55.6, 56.8, "Laurna Morninglight"}, -- Laurna Morninglight, Dolanaar
	[5634] = {1453, 38.8, 26.4, "High Priestess Laurena"}, -- High Priestess Laurena, Stormwind City
	[5639] = {1455, 25, 8.4, "High Priest Rohan"}, -- High Priest Rohan, Ironforge
	[5635] = {1429, 43.4, 65.6, "Priestess Josetta"}, -- Priestess Josetta, Goldshire
	[5637] = {1426, 47.2, 52.2, "Maxan Anvol"}, -- Maxan Anvol, Kharanos
	[5640] = {1457, 39.2, 81, "Priestess Alathea"}, -- Priestess Alathea, Darnassus
	[5652] = {1454, 35.6, 87.6, "Ur'kyo"}, -- Ur'kyo, Orgrimmar
	[5655] = {1412, 47, 58.8, "Var'jun"}, -- Var'jun, Bloodhoof Village
	[5654] = {1411, 54.2, 42.8, "Tai'jin"}, -- Tai'jin, Razor Hill
	[5657] = {1458, 49.2, 18.2, "Aelthalyste"}, -- Aelthalyste, Undercity
	[5656] = {1458, 49.4, 15.4, "Father Lankester"}, -- Father Lankester, Undercity. Wowhead pins only the turn-in.
	[5628] = {1429, 43.4, 65.6, "Priestess Josetta"}, -- Priestess Josetta, Elwynn Forest
	[5629] = {1438, 55.6, 56.8, "Laurna Morninglight"}, -- Laurna Morninglight, Teldrassil
	[5630] = {1426, 47.2, 52.2, "Maxan Anvol"}, -- Maxan Anvol, Dun Morogh
	[5631] = {1453, 38.8, 26.8, "Brother Joshua"}, -- Brother Joshua, Stormwind City
	[5632] = {1453, 20.8, 50.2, "Nara Meideros"}, -- Nara Meideros, Stormwind City
	[5633] = {1455, 24.6, 9.2, "Braenna Flintcrag"}, -- Braenna Flintcrag, Ironforge
	[5627] = {1457, 39.2, 81, "Priestess Alathea"}, -- Priestess Alathea, Darnassus
	[5658] = {1458, 49.2, 18.2, "Aelthalyste"}, -- Aelthalyste, Undercity
	[5661] = {1412, 47, 58.8, "Var'jun"}, -- Var'jun, Bloodhoof Village
	[5660] = {1411, 54.2, 42.8, "Tai'jin"}, -- Tai'jin, Razor Hill
	[5662] = {1454, 35.6, 87.6, "Ur'kyo"}, -- Ur'kyo, Orgrimmar
	[5663] = {1456, 25.4, 15.4, "Miles Welsh"}, -- Miles Welsh, Thunder Bluff
	[5647] = {1457, 39.2, 81, "Priestess Alathea"}, -- Priestess Alathea, Darnassus
	[5645] = {1453, 38.8, 26.4, "High Priestess Laurena"}, -- High Priestess Laurena, Stormwind City
	[5641] = {1455, 25, 8.4, "High Priest Rohan"}, -- High Priest Rohan, Ironforge
	[5678] = {1457, 39.2, 81, "Priestess Alathea"}, -- Priestess Alathea, Darnassus
	[5677] = {1455, 25, 8.4, "High Priest Rohan"}, -- High Priest Rohan, Ironforge
	[5676] = {1453, 38.8, 26.4, "High Priestess Laurena"}, -- High Priestess Laurena, Stormwind City
	[5646] = {1454, 35.6, 87.6, "Ur'kyo"}, -- Ur'kyo, Orgrimmar
	[5679] = {1458, 49.2, 18.2, "Aelthalyste"}, -- Aelthalyste, Undercity
	[5644] = {1456, 25.4, 15.4, "Miles Welsh"}, -- Miles Welsh, Thunder Bluff
	[5672] = {1457, 39.2, 81, "Priestess Alathea"}, -- Priestess Alathea, Darnassus
	[5674] = {1453, 20.8, 50.2, "Nara Meideros"}, -- Nara Meideros, Stormwind City. Wowhead pins only the turn-in.
	[5673] = {1453, 38.8, 26.4, "High Priestess Laurena"}, -- High Priestess Laurena, Stormwind City
	[5675] = {1455, 25, 8.4, "High Priest Rohan"}, -- High Priest Rohan, Ironforge
	[5680] = {1454, 35.6, 87.6, "Ur'kyo"}, -- Ur'kyo, Orgrimmar
	[5643] = {1458, 49.2, 18.2, "Aelthalyste"}, -- Aelthalyste, Undercity
	[5642] = {1456, 25.4, 15.4, "Miles Welsh"}, -- Miles Welsh, Thunder Bluff
	[8254] = {1453, 38.8, 26.8, "Brother Joshua"}, -- Brother Joshua, Stormwind City (also High Priest Rohan, Ironforge 25, 8.4; Ur'kyo, Orgrimmar 35.6, 87.6)
	[8255] = {1447, 42.4, 42.6, "Ogtinc"}, -- Ogtinc, Azshara
	[8256] = {1447, 42.4, 42.6, "Ogtinc"}, -- Ogtinc, Azshara
	[8257] = {1447, 42.4, 42.6, "Ogtinc"}, -- Ogtinc, Azshara. Turn in to Greta Mosshoof, Felwood 51.2, 82.2.
	[7621] = {1423, 20.8, 18.4, "Eris Havenfire"}, -- Eris Havenfire, Eastern Plaguelands
	[7622] = {1423, 20.8, 18.4, "Eris Havenfire"}, -- Eris Havenfire, Eastern Plaguelands
	[3102] = {1429, 48.8, 41.6, "Marshal McBride"}, -- Marshal McBride, Elwynn Forest
	[3113] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[3088] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[3109] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[3096] = {1420, 30.8, 66.2, "Shadow Priest Sarvis"}, -- Shadow Priest Sarvis, Tirisfal Glades
	[3118] = {1438, 58.6, 44.2, "Conservator Ilthalaine"}, -- Conservator Ilthalaine, Teldrassil
	[3083] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[2241] = {1438, 56.2, 60, "Jannok Breezesong"}, -- Jannok Breezesong, Teldrassil
	[2242] = {1457, 36.8, 21.8, "Syurna"}, -- Syurna, Darnassus
	[2218] = {1426, 47.6, 52.6, "Hogral Bakkan"}, -- Hogral Bakkan, Dun Morogh
	[2238] = {1455, 51.6, 14.8, "Hulfdan Blackbeard"}, -- Hulfdan Blackbeard, Ironforge
	[2239] = {1426, 25.2, 44.4, "Onin MacHammar"}, -- Onin MacHammar, Dun Morogh
	[2205] = {1429, 43.8, 65.8, "Keryn Sylvius"}, -- Keryn Sylvius, Elwynn Forest
	[2206] = {1453, 75.8, 59.8, "Master Mathias Shaw"}, -- Master Mathias Shaw, Stormwind City
	[1885] = {1420, 61.6, 52, "Marion Call"}, -- Marion Call, Tirisfal Glades
	[1886] = {1458, 83.2, 69, "Mennet Carkad"}, -- Mennet Carkad, Undercity
	[1898] = {1458, 83.2, 69, "Mennet Carkad"}, -- Mennet Carkad, Undercity
	[1899] = {1458, 54.6, 75.6, "Andron Gant"}, -- Andron Gant, Undercity
	[1978] = {1458, 83.2, 69, "Mennet Carkad"}, -- Mennet Carkad, Undercity
	[1859] = {1411, 52, 43.6, "Kaplak"}, -- Kaplak, Durotar
	[1963] = {1454, 42.8, 53.4, "Therzok"}, -- Therzok, Orgrimmar
	[1858] = {1454, 42.8, 53.4, "Therzok"}, -- Therzok, Orgrimmar
	[2259] = {1438, 56.2, 60, "Jannok Breezesong"}, -- Jannok Breezesong, Teldrassil
	[2299] = {1426, 47.6, 52.6, "Hogral Bakkan"}, -- Hogral Bakkan, Dun Morogh
	[2300] = {1429, 43.8, 65.8, "Keryn Sylvius"}, -- Keryn Sylvius, Elwynn Forest
	[2260] = {1457, 34.6, 25.6, "Erion Shadewhisper"}, -- Erion Shadewhisper, Darnassus
	[2298] = {1455, 51.6, 14.8, "Hulfdan Blackbeard"}, -- Hulfdan Blackbeard, Ironforge
	[2281] = {1453, 75.8, 60.2, "Renzik \"The Shiv\""}, -- Renzik "The Shiv", Stormwind City
	[2282] = {1433, 28.2, 52.2, "Lucius"}, -- Lucius, Redridge Mountains
	[2378] = {1458, 83.2, 69, "Mennet Carkad"}, -- Mennet Carkad, Undercity
	[2380] = {1411, 52, 43.6, "Kaplak"}, -- Kaplak, Durotar
	[2379] = {1454, 43, 53.4, "Shenthul"}, -- Shenthul, Orgrimmar
	[2382] = {1454, 42.8, 53, "Zando'zan"}, -- Zando'zan, Orgrimmar
	[2381] = {1413, 63, 36.4, "Wrenix the Wretched"}, -- Wrenix the Wretched, The Barrens
	[1998] = {1458, 83.2, 69, "Mennet Carkad"}, -- Mennet Carkad, Undercity
	[1999] = {1458, 83.2, 69, "Mennet Carkad"}, -- Mennet Carkad, Undercity
	[2460] = {1454, 43, 53.4, "Shenthul"}, -- Shenthul, Orgrimmar
	[2458] = {1454, 43, 53.4, "Shenthul"}, -- Shenthul, Orgrimmar
	[2478] = {1413, 55.4, 5.6, "Taskmaster Fizzule"}, -- Taskmaster Fizzule, The Barrens
	[2479] = {1454, 43, 53.4, "Shenthul"}, -- Shenthul, Orgrimmar
	[2480] = {1424, 61.6, 19.2, "Serge Hinott"}, -- Serge Hinott, Hillsbrad Foothills
	[2360] = {1453, 75.8, 59.8, "Master Mathias Shaw"}, -- Master Mathias Shaw, Stormwind City
	[2359] = {1436, 68.4, 70, "Agent Kearnen"}, -- Agent Kearnen, Westfall
	[2607] = {1453, 75.8, 59.8, "Master Mathias Shaw"}, -- Master Mathias Shaw, Stormwind City
	[2608] = {1453, 78, 59, "Doc Mixilpixil"}, -- Doc Mixilpixil, Stormwind City
	[2609] = {1453, 78, 59, "Doc Mixilpixil"}, -- Doc Mixilpixil, Stormwind City
	[6681] = {1416, 84.4, 80.2, "Fahrad"}, -- Begins from the Elegant Letter. Turn in to Fahrad, Alterac Mountains.
	[6701] = {1416, 84.4, 79.4, "Ravenholdt Guard"}, -- Ravenholdt Guard, Alterac Mountains (also Ravenholdt Guard, Hillsbrad Foothills 77.6, 20)
	[8249] = {1416, 84.4, 80.2, "Fahrad"}, -- Fahrad, Alterac Mountains
	[8233] = {1454, 44, 54.4, "Ormok"}, -- Ormok, Orgrimmar (also Miles Dexter, Undercity 85, 71.2; Osborne the Night Man, Stormwind City 74.4, 52.8; Hulfdan Blackbeard, Ironforge 51.6, 14.8; Syurna, Darnassus 36.8, 21.8)
	[8234] = {1416, 86, 79, "Lord Jorach Ravenholdt"}, -- Lord Jorach Ravenholdt, Alterac Mountains
	[8235] = {1447, 29.2, 40.2, "Archmage Xylem"}, -- Archmage Xylem, Azshara
	[8236] = {1447, 29.2, 40.2, "Archmage Xylem"}, -- Archmage Xylem, Azshara. Turn in to Lord Jorach Ravenholdt, Alterac Mountains 86, 79.
	[3089] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[3084] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[752] = {1412, 44.2, 76, "Chief Hawkwind"}, -- Chief Hawkwind, Mulgore
	[753] = {1412, 48.6, 80.8, "Greatmother Hawkwind"}, -- Greatmother Hawkwind, Mulgore
	[755] = {1412, 44.2, 76, "Chief Hawkwind"}, -- Chief Hawkwind, Mulgore. Turn in to Seer Graytongue, 42.6, 92.
	[757] = {1412, 42.6, 92, "Seer Graytongue"}, -- Seer Graytongue, Mulgore
	[763] = {1412, 44.2, 76, "Chief Hawkwind"}, -- Chief Hawkwind, Mulgore. Turn in to Baine Bloodhoof, Bloodhoof Village 47.4, 60.2.
	[1516] = {1411, 42.4, 69, "Canaga Earthcaller"}, -- Canaga Earthcaller, Durotar
	[1517] = {1411, 42.4, 69, "Canaga Earthcaller"}, -- Canaga Earthcaller, Durotar
	[1463] = {1411, 42.4, 69, "Canaga Earthcaller"}, -- Canaga Earthcaller, Durotar
	[1518] = {1411, 44, 76, "Minor Manifestation of Earth"}, -- Minor Manifestation of Earth, Durotar (also Minor Manifestation of Earth, Mulgore 53.8, 80.4)
	[1519] = {1412, 44.8, 76.2, "Seer Ravenfeather"}, -- Seer Ravenfeather, Mulgore
	[1520] = {1412, 44.8, 76.2, "Seer Ravenfeather"}, -- Seer Ravenfeather, Mulgore
	[1462] = {1412, 44.8, 76.2, "Seer Ravenfeather"}, -- Seer Ravenfeather, Mulgore
	[1521] = {1412, 53.8, 80.4, "Minor Manifestation of Earth"}, -- Minor Manifestation of Earth, Mulgore (also Minor Manifestation of Earth, Durotar 44, 76)
	[1522] = {1454, 37.8, 37.4, "Searn Firewarder"}, -- Searn Firewarder, Orgrimmar
	[1523] = {1456, 25.2, 21, "Xanis Flameweaver"}, -- Xanis Flameweaver, Thunder Bluff
	[2983] = {1411, 54.4, 42.6, "Swart"}, -- Swart, Durotar
	[2984] = {1412, 48.4, 59.2, "Narm Skychaser"}, -- Narm Skychaser, Mulgore
	[1524] = {1413, 55.8, 20, "Kranal Fiss"}, -- Kranal Fiss, The Barrens
	[1525] = {1411, 38.6, 58.8, "Telf Joolam"}, -- Telf Joolam, Durotar
	[1526] = {1411, 38.6, 58.8, "Telf Joolam"}, -- Telf Joolam, Durotar
	[1464] = {1411, 38.6, 58.8, "Telf Joolam"}, -- Telf Joolam, Durotar
	[1527] = {1411, 38.9, 58.2, "Brazier of the Dormant Flame"}, -- Brazier of the Dormant Flame, Durotar
	[1528] = {1454, 37.8, 37.4, "Searn Firewarder"}, -- Searn Firewarder, Orgrimmar
	[1529] = {1456, 25.2, 21, "Xanis Flameweaver"}, -- Xanis Flameweaver, Thunder Bluff
	[2985] = {1411, 54.4, 42.6, "Swart"}, -- Swart, Durotar
	[2986] = {1412, 48.4, 59.2, "Narm Skychaser"}, -- Narm Skychaser, Mulgore
	[1530] = {1413, 65.8, 43.8, "Islen Waterseer"}, -- Islen Waterseer, The Barrens
	[1535] = {1413, 43.4, 77.4, "Brine"}, -- Brine, The Barrens
	[1536] = {1413, 43.4, 77.4, "Brine"}, -- Brine, The Barrens
	[1534] = {1413, 43.4, 77.4, "Brine"}, -- Brine, The Barrens
	[220] = {1413, 43.4, 77.4, "Brine"}, -- Brine, The Barrens
	[63] = {1413, 65.8, 43.8, "Islen Waterseer"}, -- Islen Waterseer, The Barrens
	[100] = {1421, 38.2, 44.5, "Brazier of Everfount"}, -- Brazier of Everfount, Silverpine Forest
	[96] = {1421, 38.6, 44.6, "Minor Manifestation of Water"}, -- Minor Manifestation of Water, Silverpine Forest
	[1103] = {1421, 37.4, 44, "Tiev Mordune"}, -- Tiev Mordune, Silverpine Forest
	[972] = {1413, 65.8, 43.8, "Islen Waterseer"}, -- Islen Waterseer, The Barrens
	[1532] = {1456, 25.2, 21, "Xanis Flameweaver"}, -- Xanis Flameweaver, Thunder Bluff
	[1531] = {1454, 37.8, 37.4, "Searn Firewarder"}, -- Searn Firewarder, Orgrimmar
	[94789] = {1455, 47.4, 13.6, "Eldrun Stormbreaker"}, -- Eldrun Stormbreaker, Ironforge
	[96264] = {1417, 59.8, 27.6, "Veyric Thunderhame"}, -- Veyric Thunderhame, Arathi Highlands
	[79358] = {1417, 59.8, 27.6, "Veyric Thunderhame"}, -- Veyric Thunderhame, Arathi Highlands
	[96135] = {1417, 59.8, 27.6, "Veyric Thunderhame"}, -- Veyric Thunderhame, Arathi Highlands
	[96016] = {1417, 59.8, 27.6, "Veyric Thunderhame"}, -- Veyric Thunderhame, Arathi Highlands. Turn in to Bath'rah the Windwatcher, Alterac Mountains 80.4, 66.8.
	[79360] = {1441, 53.6, 42.8, "Prate Cloudseer"}, -- Prate Cloudseer, Thousand Needles (also Rau Cliffrunner, Thousand Needles 46, 51.6). Ends at Rau Cliffrunner and Bath'rah the Windwatcher, Alterac Mountains 80.4, 66.8.
	[79364] = {1441, 46, 51.6, "Rau Cliffrunner"}, -- Rau Cliffrunner, Thousand Needles (also Bath'rah the Windwatcher, Alterac Mountains 80.4, 66.8). Ends at Prate Cloudseer, Thousand Needles 53.6, 42.8.
	[79361] = {1441, 53.6, 42.8, "Prate Cloudseer"}, -- Prate Cloudseer, Thousand Needles (also Bath'rah the Windwatcher, Alterac Mountains 80.4, 66.8)
	[79366] = {1441, 53.6, 42.8, "Prate Cloudseer"}, -- Prate Cloudseer, Thousand Needles (also Rau Cliffrunner, Thousand Needles 46, 51.6). Turn in to Rau Cliffrunner.
	[79442] = {1441, 46, 51.6, "Rau Cliffrunner"}, -- Rau Cliffrunner, Thousand Needles. Turn in to Bath'rah the Windwatcher, Alterac Mountains 80.4, 66.8.
	[96243] = {1426, 47.4, 52, "Ingrid Dunwald"}, -- Ingrid Dunwald, Dun Morogh. Also starts from Eldrun Stormbreaker, Ironforge 47.4, 13.6.
	[94373] = {1426, 28.7, 66.1, "Teo Hammerstorm"}, -- Teo Hammerstorm, Anvilmar
	[94374] = {1426, 28.7, 66.1, "Teo Hammerstorm"}, -- Teo Hammerstorm, Anvilmar
	[94375] = {1426, 24.8, 61.8, "Minor Manifestation of Earth"}, -- Minor Manifestation of Earth, Dun Morogh. Same NPC also stands in Durotar and Mulgore.
	[94449] = {1426, 47.4, 52, "Ingrid Dunwald"}, -- Ingrid Dunwald, Dun Morogh. Also starts from Eldrun Stormbreaker, Ironforge 47.4, 13.6.
	[94465] = {1426, 87.6, 43.6, "Bruegs Kindleborn"}, -- Bruegs Kindleborn, Dun Morogh
	[94466] = {1432, 32, 66, "Braldir Ashmantle"}, -- Braldir Ashmantle, Loch Modan
	[94467] = {1432, 32, 66, "Braldir Ashmantle"}, -- Braldir Ashmantle, Loch Modan
	[94468] = {1432, 31.9, 64.5, "Brazier of the Dormant Flame"}, -- Brazier of the Dormant Flame, Loch Modan. Same object also stands in Durotar.
	[94495] = {1432, 41.8, 19, "Norric Lochthane"}, -- Norric Lochthane, Loch Modan
	[94497] = {1437, 65.6, 76.4, "Hervdana Saegrund"}, -- Hervdana Saegrund, Wetlands
	[94499] = {1437, 65.6, 76.4, "Hervdana Saegrund"}, -- Hervdana Saegrund, Wetlands
	[94500] = {1437, 65.6, 76.4, "Hervdana Saegrund"}, -- Hervdana Saegrund, Wetlands
	[94501] = {1437, 65.6, 76.4, "Hervdana Saegrund"}, -- Hervdana Saegrund, Wetlands
	[94502] = {1432, 41.8, 19, "Norric Lochthane"}, -- Norric Lochthane, Loch Modan
	[94503] = {1436, 45.6, 59.9, "Forgotten Shrine"}, -- Forgotten Shrine, Westfall
	[94505] = {1436, 45.6, 59.9, "Minor Manifestation of Water"}, -- Minor Manifestation of Water, Westfall. Wowhead also pins this NPC in Silverpine Forest at 38.6, 44.6.
	[8410] = {1454, 38.6, 36.2, "Sagorne Creststrider"}, -- Sagorne Creststrider, Orgrimmar (also Beram Skychaser, Thunder Bluff 22.2, 19)
	[8411] = {1416, 80.4, 66.8, "Bath'rah the Windwatcher"}, -- Bath'rah the Windwatcher, Alterac Mountains
	[8412] = {1416, 80.4, 66.8, "Bath'rah the Windwatcher"}, -- Bath'rah the Windwatcher, Alterac Mountains
	[8413] = {1416, 80.4, 66.8, "Bath'rah the Windwatcher"}, -- Bath'rah the Windwatcher, Alterac Mountains
	[7667] = {1454, 38.6, 36.2, "Sagorne Creststrider"}, -- Sagorne Creststrider, Orgrimmar
	[8258] = {1454, 38.6, 36.2, "Sagorne Creststrider"}, -- Sagorne Creststrider, Orgrimmar
	[1599] = {1426, 28.6, 66.2, "Alamar Grimm"}, -- Alamar Grimm, Dun Morogh
	[1470] = {1420, 31, 66.2, "Venya Marthand"}, -- Venya Marthand, Tirisfal Glades
	[3105] = {1429, 48.8, 41.6, "Marshal McBride"}, -- Marshal McBride, Elwynn Forest
	[3115] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[3090] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[3099] = {1420, 30.8, 66.2, "Shadow Priest Sarvis"}, -- Shadow Priest Sarvis, Tirisfal Glades
	[1598] = {1429, 49.8, 42.6, "Drusilla La Salle"}, -- Drusilla La Salle, Elwynn Forest
	[1485] = {1411, 42.6, 69, "Ruzan"}, -- Ruzan, Durotar
	[1499] = {1411, 42.6, 69, "Ruzan"}, -- Ruzan, Durotar
	[1685] = {1429, 44.4, 66.2, "Remen Marcot"}, -- Remen Marcot, Elwynn Forest
	[1715] = {1455, 47.6, 9.6, "Lago Blackwrench"}, -- Lago Blackwrench, Ironforge
	[1688] = {1453, 25.4, 78.4, "Gakin the Darkbinder"}, -- Gakin the Darkbinder, Stormwind City
	[1689] = {1453, 25.4, 78.4, "Gakin the Darkbinder"}, -- Gakin the Darkbinder, Stormwind City
	[1478] = {1420, 61.6, 52.6, "Ageron Kargal"}, -- Ageron Kargal, Tirisfal Glades
	[1473] = {1458, 85, 25.6, "Carendin Halgar"}, -- Carendin Halgar, Undercity
	[1471] = {1458, 85, 25.6, "Carendin Halgar"}, -- Carendin Halgar, Undercity
	[1506] = {1411, 54.2, 41.2, "Ophek"}, -- Ophek, Durotar
	[1501] = {1454, 48.2, 45.6, "Gan'rul Bloodeye"}, -- Gan'rul Bloodeye, Orgrimmar
	[1504] = {1454, 48.2, 45.6, "Gan'rul Bloodeye"}, -- Gan'rul Bloodeye, Orgrimmar
	[65593] = {1458, 85, 14.8, "Godrick Farsan"}, -- Godrick Farsan, Undercity
	[65597] = {1458, 85, 25.6, "Carendin Halgar"}, -- Carendin Halgar, Undercity
	[65601] = {1454, 47.2, 46.6, "Cazul"}, -- Cazul, Orgrimmar
	[65610] = {1454, 63.4, 50, "Magar"}, -- Magar, Orgrimmar
	[65604] = {1454, 48.2, 45.6, "Gan'rul Bloodeye"}, -- Gan'rul Bloodeye, Orgrimmar
	[1717] = {1455, 47.6, 9.6, "Lago Blackwrench"}, -- Lago Blackwrench, Ironforge
	[1716] = {1453, 25.4, 78.4, "Gakin the Darkbinder"}, -- Gakin the Darkbinder, Stormwind City
	[1738] = {1413, 49.2, 57, "Takar the Seer"}, -- Takar the Seer, The Barrens
	[1739] = {1453, 25.4, 78.4, "Gakin the Darkbinder"}, -- Gakin the Darkbinder, Stormwind City
	[1472] = {1458, 85, 25.6, "Carendin Halgar"}, -- Carendin Halgar, Undercity
	[1476] = {1458, 85, 14.8, "Godrick Farsan"}, -- Godrick Farsan, Undercity
	[1474] = {1458, 85, 25.6, "Carendin Halgar"}, -- Carendin Halgar, Undercity
	[1507] = {1454, 48.2, 45.6, "Gan'rul Bloodeye"}, -- Gan'rul Bloodeye, Orgrimmar
	[1508] = {1454, 47.2, 46.6, "Cazul"}, -- Cazul, Orgrimmar
	[1509] = {1454, 37, 59.6, "Zankaja"}, -- Zankaja, Orgrimmar
	[1510] = {1413, 51.8, 30.2, "Gazrog"}, -- Gazrog, The Barrens
	[1511] = {1442, 73.2, 95, "Ken'zigla"}, -- Ken'zigla, Stonetalon Mountains
	[1515] = {1413, 44.6, 59.2, "Grunt Logmar"}, -- Grunt Logmar, The Barrens
	[1512] = {1413, 43.2, 47.8, "Grunt Dogran"}, -- Grunt Dogran, The Barrens
	[1513] = {1454, 48.2, 45.6, "Gan'rul Bloodeye"}, -- Gan'rul Bloodeye, Orgrimmar
	[1740] = {1413, 49.2, 57.2, "Doan Karhan"}, -- Doan Karhan, The Barrens
	[1798] = {1453, 25.4, 78.4, "Gakin the Darkbinder"}, -- Gakin the Darkbinder, Stormwind City
	[1758] = {1413, 62.6, 35.4, "Strahad Farsan"}, -- Strahad Farsan, The Barrens
	[1802] = {1455, 74.2, 9.8, "Krom Stoutarm"}, -- Krom Stoutarm, Ironforge
	[1804] = {1455, 74.2, 9.8, "Krom Stoutarm"}, -- Krom Stoutarm, Ironforge
	[1795] = {1413, 62.6, 35.4, "Strahad Farsan"}, -- Strahad Farsan, The Barrens
	[2996] = {1454, 48.2, 45.6, "Gan'rul Bloodeye"}, -- Gan'rul Bloodeye, Orgrimmar
	[3001] = {1458, 85, 25.6, "Carendin Halgar"}, -- Carendin Halgar, Undercity
	[1801] = {1413, 62.6, 35.4, "Strahad Farsan"}, -- Strahad Farsan, The Barrens
	[1803] = {1458, 76, 37.6, "Jorah Annison"}, -- Jorah Annison, Undercity
	[1805] = {1458, 76, 37.6, "Jorah Annison"}, -- Jorah Annison, Undercity
	[4737] = {1454, 48.4, 45.6, "Zevrost"}, -- Zevrost, Orgrimmar
	[4738] = {1453, 25.4, 78.2, "Demisette Cloyce"}, -- Demisette Cloyce, Stormwind City
	[1796] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4781] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4782] = {1434, 28.6, 76.8, "Xizk Goodstitch"}, -- Xizk Goodstitch, Stranglethorn Vale
	[4783] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4784] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4785] = {1434, 28.6, 76.8, "Xizk Goodstitch"}, -- Xizk Goodstitch, Stranglethorn Vale
	[4786] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4736] = {1455, 50.2, 6, "Briarthorn"}, -- Briarthorn, Ironforge
	[4739] = {1458, 86, 15.6, "Kaal Soulreaper"}, -- Kaal Soulreaper, Undercity
	[4785] = {1434, 28.6, 76.8, "Xizk Goodstitch"}, -- Xizk Goodstitch, Stranglethorn Vale
	[4965] = {1455, 50.2, 6, "Briarthorn"}, -- Briarthorn, Ironforge
	[4967] = {1454, 48.4, 45.6, "Zevrost"}, -- Zevrost, Orgrimmar
	[1799] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4961] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[4962] = {1413, 62.6, 35.2, "Acolyte Wytula"}, -- Acolyte Wytula, The Barrens
	[4963] = {1413, 62.6, 35.2, "Acolyte Magaz"}, -- Acolyte Magaz, The Barrens
	[4976] = {1445, 46, 57, "Tabetha"}, -- Tabetha, Dustwallow Marsh
	[4964] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4975] = {1413, 62.4, 35.4, "Menara Voidrender"}, -- Menara Voidrender, The Barrens
	[4968] = {1453, 25.4, 78.2, "Demisette Cloyce"}, -- Demisette Cloyce, Stormwind City
	[4969] = {1458, 86, 15.6, "Kaal Soulreaper"}, -- Kaal Soulreaper, Undercity
	[4487] = {1455, 50.2, 6, "Briarthorn"}, -- Briarthorn, Ironforge
	[4488] = {1453, 25.4, 78.2, "Demisette Cloyce"}, -- Demisette Cloyce, Stormwind City
	[4490] = {1413, 62.6, 35.4, "Strahad Farsan"}, -- Strahad Farsan, The Barrens
	[3631] = {1454, 48.4, 45.6, "Zevrost"}, -- Zevrost, Orgrimmar
	[4489] = {1458, 86, 15.6, "Kaal Soulreaper"}, -- Kaal Soulreaper, Undercity
	[7601] = {1448, 41.4, 44.8, "Niby the Almighty"}, -- Niby the Almighty, Felwood
	[7602] = {1448, 41.4, 44.8, "Impsy"}, -- Impsy, Felwood
	[7603] = {1448, 41.4, 44.8, "Impsy"}, -- Impsy, Felwood
	[8419] = {1453, 25.4, 78.2, "Demisette Cloyce"}, -- Demisette Cloyce, Stormwind City (also Zevrost, Orgrimmar 48.4, 45.6; Kaal Soulreaper, Undercity 86, 15.6; Briarthorn, Ironforge 50.2, 6)
	[8420] = {1448, 41.4, 44.8, "Impsy"}, -- Impsy, Felwood
	[8421] = {1448, 41.4, 44.8, "Impsy"}, -- Impsy, Felwood
	[8422] = {1448, 41.4, 44.8, "Impsy"}, -- Impsy, Felwood
	[7562] = {1453, 25.8, 77.6, "Spackle Thornberry"}, -- Spackle Thornberry, Stormwind City (also Martha Strain, Undercity 85.8, 15.8; Kurgul, Orgrimmar 47.6, 46.8; Jubahl Corpseseeker, Ironforge 52.8, 6)
	[7623] = {1428, 12.4, 31.6, "Gorzeeki Wildeyes"}, -- Gorzeeki Wildeyes, Burning Steppes
	[7563] = {1428, 12.6, 31.6, "Mor'zul Bloodbringer"}, -- Mor'zul Bloodbringer, Burning Steppes
	[7624] = {1448, 36, 44.6, "Lord Banehollow"}, -- Lord Banehollow, Felwood
	[7564] = {1428, 12.6, 31.6, "Mor'zul Bloodbringer"}, -- Mor'zul Bloodbringer, Burning Steppes
	[7625] = {1448, 36, 44.6, "Lord Banehollow"}, -- Lord Banehollow, Felwood
	[7626] = {1428, 12.6, 31.6, "Mor'zul Bloodbringer"}, -- Mor'zul Bloodbringer, Burning Steppes
	[7627] = {1428, 12.6, 31.6, "Mor'zul Bloodbringer"}, -- Mor'zul Bloodbringer, Burning Steppes
	[7628] = {1428, 12.6, 31.6, "Mor'zul Bloodbringer"}, -- Mor'zul Bloodbringer, Burning Steppes
	[7629] = {1428, 12.4, 31.6, "Gorzeeki Wildeyes"}, -- Gorzeeki Wildeyes, Burning Steppes
	[7630] = {1428, 12.4, 31.6, "Gorzeeki Wildeyes"}, -- Gorzeeki Wildeyes, Burning Steppes
	[7581] = {1419, 34, 50.2, "Daio the Decrepit"}, -- Daio the Decrepit, Blasted Lands
	[7582] = {1419, 34, 50.2, "Daio the Decrepit"}, -- Daio the Decrepit, Blasted Lands
	[7583] = {1419, 34, 50.2, "Daio the Decrepit"}, -- Daio the Decrepit, Blasted Lands
	[65602] = {1413, 49.2, 57, "Takar the Seer"}, -- Takar the Seer, The Barrens
	[65603] = {1453, 25.4, 78.4, "Gakin the Darkbinder"}, -- Gakin the Darkbinder, Stormwind City
	[7631] = {1428, 12.6, 31.6, "Mor'zul Bloodbringer"}, -- Mor'zul Bloodbringer, Burning Steppes
	[3100] = {1429, 48.8, 41.6, "Marshal McBride"}, -- Marshal McBride, Elwynn Forest
	[3112] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[2383] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[3106] = {1426, 29.8, 71.2, "Sten Stoutarm"}, -- Sten Stoutarm, Dun Morogh
	[3095] = {1420, 30.8, 66.2, "Shadow Priest Sarvis"}, -- Shadow Priest Sarvis, Tirisfal Glades
	[3116] = {1438, 58.6, 44.2, "Conservator Ilthalaine"}, -- Conservator Ilthalaine, Teldrassil
	[3065] = {1411, 42, 68.4, "Gornek"}, -- Gornek, Durotar
	[1638] = {1429, 41, 65.8, "Lyria Du Lac"}, -- Lyria Du Lac, Elwynn Forest (also Ilsa Corbin, Stormwind City 78.6, 45.6)
	[1639] = {1453, 74, 37.2, "Harry Burlguard"}, -- Harry Burlguard, Stormwind City
	[1640] = {1453, 73.8, 36.6, "Bartleby"}, -- Bartleby, Stormwind City
	[1665] = {1453, 73.8, 36.6, "Bartleby"}, -- Bartleby, Stormwind City
	[1666] = {1453, 74, 37.2, "Harry Burlguard"}, -- Harry Burlguard, Stormwind City
	[1667] = {1429, 84.6, 69.4, "Marshal Haggard"}, -- Marshal Haggard, Elwynn Forest
	[1505] = {1412, 49.4, 60.4, "Krang Stonehoof"}, -- Krang Stonehoof, Mulgore (also Tarshaw Jaggedscar, Durotar 54.2, 42.4; Sorek, Orgrimmar 80.2, 32.4)
	[1498] = {1413, 61.4, 21, "Uzzek"}, -- Uzzek, The Barrens
	[1502] = {1413, 61.4, 21, "Uzzek"}, -- Uzzek, The Barrens
	[1503] = {1413, 57.2, 30.2, "Thun'grim Firegaze"}, -- Thun'grim Firegaze, The Barrens
	[1679] = {1426, 47.2, 52.6, "Granis Swiftaxe"}, -- Granis Swiftaxe, Dun Morogh
	[1678] = {1455, 70.6, 90.4, "Muren Stormpike"}, -- Muren Stormpike, Ironforge
	[1680] = {1455, 70.6, 90.4, "Muren Stormpike"}, -- Muren Stormpike, Ironforge
	[1681] = {1455, 48.6, 43, "Tormus Deepforge"}, -- Tormus Deepforge, Ironforge
	[1682] = {1455, 48.6, 43, "Tormus Deepforge"}, -- Tormus Deepforge, Ironforge
	[1818] = {1420, 61.8, 52.4, "Austil de Mon"}, -- Austil de Mon, Tirisfal Glades
	[1819] = {1420, 58.2, 51.4, "Deathguard Dillinger"}, -- Deathguard Dillinger, Tirisfal Glades
	[1820] = {1420, 58.2, 51.4, "Deathguard Dillinger"}, -- Deathguard Dillinger, Tirisfal Glades
	[1821] = {1420, 61.8, 52.4, "Coleman Farthing"}, -- Coleman Farthing, Tirisfal Glades
	[1822] = {1420, 61.8, 52.4, "Coleman Farthing"}, -- Coleman Farthing, Tirisfal Glades
	[1684] = {1438, 55.6, 58.4, "Moon Priestess Amara"}, -- Moon Priestess Amara, Teldrassil (also Kyra Windblade, Teldrassil 56.2, 59.2)
	[1683] = {1457, 57.4, 34.8, "Elanaria"}, -- Elanaria, Darnassus
	[1686] = {1457, 57.4, 34.8, "Elanaria"}, -- Elanaria, Darnassus
	[1692] = {1457, 57.4, 34.8, "Elanaria"}, -- Elanaria, Darnassus
	[1693] = {1457, 59.2, 45.4, "Mathiel"}, -- Mathiel, Darnassus
	[1823] = {1454, 80.2, 32.4, "Sorek"}, -- Sorek, Orgrimmar (also Baltus Fowler, Undercity 47.2, 17; Torm Ragetotem, Thunder Bluff 57.6, 87.2)
	[1824] = {1413, 44.6, 59.4, "Ruga Ragetotem"}, -- Ruga Ragetotem, The Barrens
	[1825] = {1413, 44.6, 59.4, "Ruga Ragetotem"}, -- Ruga Ragetotem, The Barrens
	[1838] = {1413, 57.2, 30.2, "Thun'grim Firegaze"}, -- Thun'grim Firegaze, The Barrens
	[1839] = {1413, 57.2, 30.2, "Thun'grim Firegaze"}, -- Thun'grim Firegaze, The Barrens
	[1841] = {1413, 57.2, 30.2, "Thun'grim Firegaze"}, -- Thun'grim Firegaze, The Barrens
	[1848] = {1413, 57.2, 30.2, "Thun'grim Firegaze"}, -- Thun'grim Firegaze, The Barrens
	[1842] = {1411, 56.2, 74.4, "Ula'elek"}, -- Ula'elek, Durotar
	[1846] = {1458, 62.4, 39.2, "Velora Nitely"}, -- Velora Nitely, Undercity
	[1843] = {1411, 56.2, 74.4, "Ula'elek"}, -- Ula'elek, Durotar
	[1847] = {1458, 62.4, 39.2, "Velora Nitely"}, -- Velora Nitely, Undercity
	[1698] = {1453, 78.8, 45.6, "Wu Shen"}, -- Wu Shen, Stormwind City (also Kelv Sternhammer, Ironforge 70, 90.6; Darnath Bladesinger, Darnassus 58.6, 35.4)
	[1699] = {1433, 26.6, 44.8, "Yorus Barleybrew"}, -- Yorus Barleybrew, Redridge Mountains
	[1702] = {1433, 26.6, 44.8, "Yorus Barleybrew"}, -- Yorus Barleybrew, Redridge Mountains
	[1701] = {1453, 58, 16.8, "Furen Longbeard"}, -- Furen Longbeard, Stormwind City
	[1700] = {1453, 58, 16.8, "Furen Longbeard"}, -- Furen Longbeard, Stormwind City
	[1703] = {1453, 58, 16.8, "Furen Longbeard"}, -- Furen Longbeard, Stormwind City
	[1704] = {1453, 58, 16.8, "Furen Longbeard"}, -- Furen Longbeard, Stormwind City
	[1705] = {1453, 51.6, 12.2, "Grimand Elmore"}, -- Grimand Elmore, Stormwind City
	[1708] = {1455, 68.2, 46.2, "Klockmort Spannerspan"}, -- Klockmort Spannerspan, Ironforge
	[1710] = {1457, 59.2, 45.4, "Mathiel"}, -- Mathiel, Darnassus
	[1706] = {1453, 51.6, 12.2, "Grimand Elmore"}, -- Grimand Elmore, Stormwind City
	[1709] = {1455, 68.2, 46.2, "Klockmort Spannerspan"}, -- Klockmort Spannerspan, Ironforge
	[1711] = {1457, 59.2, 45.4, "Mathiel"}, -- Mathiel, Darnassus
	[1782] = {1453, 58, 16.8, "Furen Longbeard"}, -- Furen Longbeard, Stormwind City
	[1718] = {1456, 57.6, 87.2, "Torm Ragetotem"}, -- Torm Ragetotem, Thunder Bluff (also Baltus Fowler, Undercity 47.2, 17; Wu Shen, Stormwind City 78.8, 45.6; Kelv Sternhammer, Ironforge 70, 90.6; Sorek, Orgrimmar 80.2, 32.4)
	[1719] = {1413, 68.6, 49, "Klannoc Macleod"}, -- Klannoc Macleod, The Barrens
	[1791] = {1413, 68.6, 49, "Klannoc Macleod"}, -- Klannoc Macleod, The Barrens
	[1712] = {1416, 80.5, 66.9, "Bath'rah the Windwatcher"}, -- Bath'rah the Windwatcher, Alterac Mountains
	[1713] = {1416, 80.5, 66.9, "Bath'rah the Windwatcher"}, -- Bath'rah the Windwatcher, Alterac Mountains
	[1714] = {1416, 79.3, 66.8, "Bath'rah's Cauldron"}, -- Bath'rah's Cauldron, Alterac Mountains
	[1792] = {1416, 80.5, 66.9, "Bath'rah the Windwatcher"}, -- Bath'rah the Windwatcher, Alterac Mountains
	[8417] = {1458, 47.2, 15, "Christoph Walker"}, -- Christoph Walker, Undercity (also Wu Shen, Stormwind City 78.8, 45.6; Kelv Sternhammer, Ironforge 70, 90.6; Sorek, Orgrimmar 80.2, 32.4; Darnath Bladesinger, Darnassus 58.6, 35.4)
	[8423] = {1435, 34.2, 66, "Fallen Hero of the Horde"}, -- Fallen Hero of the Horde, Swamp of Sorrows
	[8424] = {1435, 34.2, 66, "Fallen Hero of the Horde"}, -- Fallen Hero of the Horde, Swamp of Sorrows
	[8425] = {1435, 34.2, 66, "Fallen Hero of the Horde"}, -- Fallen Hero of the Horde, Swamp of Sorrows
	[31] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[1840] = {1413, 57.2, 30.2, "Thun'grim Firegaze"}, -- Thun'grim Firegaze, The Barrens
	[1844] = {1456, 39, 55.8, "Orm Stonehoof"}, -- Orm Stonehoof, Thunder Bluff
	[1845] = {1456, 39, 55.8, "Orm Stonehoof"}, -- Orm Stonehoof, Thunder Bluff
	[2018] = {1411, 55.4, 34, "Rokar Bladeshadow"}, -- Rokar Bladeshadow, Durotar. The quest page has no pin; this is his NPC location.
	[2019] = {1411, 55.4, 34, "Rokar Bladeshadow"}, -- Rokar Bladeshadow, Durotar. The quest page has no pin; this is his NPC location.
	[3091] = {1412, 44.8, 77.2, "Grull Hawkwind"}, -- Grull Hawkwind, Mulgore
	[3092] = {1412, 44.8, 77.2, "Grull Hawkwind"}, -- Grull Hawkwind, Mulgore
	[3093] = {1412, 44.8, 77.2, "Grull Hawkwind"}, -- Grull Hawkwind, Mulgore
	[3094] = {1412, 44.8, 77.2, "Grull Hawkwind"}, -- Grull Hawkwind, Mulgore
	[5932] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[6130] = {1450, 56.2, 30.4, "Dendrite Starblaze"}, -- Dendrite Starblaze, Moonglade
	[7499] = {234, nil, nil, "Lorekeeper Kildrath"}, -- Lorekeeper Kildrath, Dire Maul. Wowhead lists no coordinates.
	[7506] = {234, nil, nil, "Lorekeeper Javon"}, -- Lorekeeper Javon, Dire Maul. Wowhead lists no coordinates.
	[7647] = {1453, 37.2, 33, "Lord Grayson Shadowbreaker"}, -- Lord Grayson Shadowbreaker, Stormwind City
	[7668] = {1454, 38.6, 36.2, "Sagorne Creststrider"}, -- Sagorne Creststrider, Orgrimmar
	[7669] = {1454, 38.6, 36.2, "Sagorne Creststrider"}, -- Sagorne Creststrider, Orgrimmar
	[8259] = {1454, 38.6, 36.2, "Sagorne Creststrider"}, -- Sagorne Creststrider, Orgrimmar
	[8328] = {1941, 38.2, 20.8, "Magistrix Erona"}, -- Magistrix Erona, Eversong Woods
	[8344] = {1941, 38.8, 21.4, "Summoner Teli'Larien"}, -- Summoner Teli'Larien, Eversong Woods
	[8563] = {1941, 38.2, 20.8, "Magistrix Erona"}, -- Magistrix Erona, Eversong Woods
	[8564] = {1941, 38.2, 20.8, "Magistrix Erona"}, -- Magistrix Erona, Eversong Woods
}

local insertAt = 1
for i, a in ipairs(FTAttune_Data.attunes) do
	if a.GROUP == FTAttuneLang["DUNGEONS"] then
		insertAt = i
		break
	end
end
for _, a in ipairs(classAttunes) do
	table.insert(FTAttune_Data.attunes, insertAt, a)
	insertAt = insertAt + 1
end
for _, s in ipairs(classSteps) do
	table.insert(FTAttune_Data.steps, s)
end
for id, info in pairs(classQuestInfo) do
	if FTAttune_Data.quests[id] == nil then
		FTAttune_Data.quests[id] = info
	end
end
for id, giver in pairs(classQuestGivers) do
	if FTAttune_Data.questGivers[id] == nil then
		FTAttune_Data.questGivers[id] = giver
	end
end
end
setfenv(Component, FT.attuneEnv)
Component(...)
