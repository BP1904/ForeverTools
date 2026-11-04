-- Local adaptation; see ../NOTICE.txt.
local _, FT = ...
local function Component(...)

local _, tbl = ...
tbl.isForever = true
tbl.season = 0

end
FT.embedded.BigWigs:Add("BigWigs", Component, "BigWigs/Init_Camelot.lua")
