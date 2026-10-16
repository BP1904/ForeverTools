-- Classic cleansing families; only spells actually known by this character are used.
local _, FT = ...
FT.cleansingSpells = {
    PALADIN = {
        {ids={4987}, types={"Magic","Disease","Poison"}},
        {ids={1152}, types={"Disease","Poison"}},
    },
    PRIEST = {
        {ids={988,527}, types={"Magic"}},
        {ids={552,528}, types={"Disease"}},
    },
    DRUID = {
        {ids={2782}, types={"Curse"}},
        {ids={2893,8946}, types={"Poison"}},
    },
    MAGE = {{ids={475}, types={"Curse"}}},
    SHAMAN = {
        {ids={2870}, types={"Disease"}},
        {ids={526}, types={"Poison"}},
    },
}
