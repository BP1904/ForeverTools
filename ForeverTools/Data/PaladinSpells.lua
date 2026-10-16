-- Spell IDs and PLPWR class numbering checked against the supplied
-- PallyPower Forever v10.15.26. This file contains no upstream implementation.
local _, FT = ...
FT.paladinData = {
    classes = {"WARRIOR", "ROGUE", "PRIEST", "DRUID", "PALADIN", "HUNTER", "MAGE", "WARLOCK", "SHAMAN"},
    labels = {"Krieger", "Schurke", "Priester", "Druide", "Paladin", "Jäger", "Magier", "Hexer", "Schamane"},
    blessings = {
        [1]={label="Weisheit", normal={27142,25290,19854,19853,19852,19850,19742}, greater={27143,25918,25894}},
        [2]={label="Macht", normal={27140,25291,19838,19837,19836,19835,19834,19740}, greater={27141,25916,25782}},
        [3]={label="Könige", normal={20217}, greater={25898}},
        [4]={label="Rettung", normal={1038}, greater={25895}},
        [5]={label="Licht", normal={27144,19979,19978,19977}, greater={27145,25890}},
        [6]={label="Refugium", normal={27168,20914,20913,20912,20911}, greater={27169,25899}},
        [7]={label="Opferung", normal={27148,27147,20729,6940}, greater={}},
        [8]={label="Horn", normal={425600}, greater={}},
    },
    auras = {465,7294,19746,19876,19888,19891,20218,32223},
    -- Highest rank first; Aura base ranks disappear from the usable spellbook on upgrade.
    -- Rank families verified against the supplied WhatsTraining Camelot/TBC spell data.
    auraRanks = {
        {27149,10293,10292,1032,10291,643,10290,465},
        {27150,10301,10300,10299,10298,7294},
        {19746},
        {27151,19896,19895,19876},
        {27152,19898,19897,19888},
        {27153,19900,19899,19891},
        {20218},
        {32223},
    },
    seals = {20164,20165,20166,21084,21082,20375,31801,31892,348700,348704,1311656},
    fury = 25780,
    preferences = {{2,3,6,5,1},{2,3,5,1,6},{1,3,5,6,2},{3,1,2,5,6},
        {3,1,2,6,5},{2,3,1,5,6},{1,3,5,6,2},{1,3,5,6,2},{1,3,2,5,6}},
}
