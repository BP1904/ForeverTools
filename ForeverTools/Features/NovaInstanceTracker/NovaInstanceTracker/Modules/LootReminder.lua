-- Local adaptation; see ../NOTICE.txt.
local _, FT = ...
local function Component(...)
------------------------
---NovaInstanceTracker--
------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("FTNovaInstanceTracker");
local lootReminderFrame, lootReminderListFrame, remnantsFrame;
local lastLootNpcID, lastBossNpcID, lastBossTime, lastEncounterID;
local tinsert = tinsert;
local GetItemInfo = GetItemInfo or C_Item.GetItemInfo;
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID;

local msgTimer, fadeTimer;
local function hideMiddleMsg()
	UIFrameFadeOut(lootReminderFrame, lootReminderFrame:GetAlpha(), lootReminderFrame:GetAlpha(), 0);
	if (fadeTimer) then
		fadeTimer:Cancel();
	end
	fadeTimer = C_Timer.NewTimer(1, function()
		lootReminderFrame.StopBounce();
	end)
	if (msgTimer) then
		msgTimer:Cancel();
	end
end

local function addMsg(msg, time, noSound)
	if (not NIT.db.global.lootReminderReal) then
		return;
	end
	lootReminderFrame.StopBounce();
	if (msgTimer) then
		msgTimer:Cancel();
	end
	if (fadeTimer) then
		fadeTimer:Cancel();
	end
	lootReminderFrame.fs:SetText("|cFF00FF00[NIT]|r |cFFFFFF00" .. msg);
	UIFrameFadeIn(lootReminderFrame, 0, 0, 1)
	msgTimer = C_Timer.NewTimer(time, function()
		hideMiddleMsg();
	end)
	lootReminderFrame.StartBounce();
	if (not noSound) then
		NIT:playSound("soundsLootReminder");
	end
end

function NIT:updateLootReminderFrame(runTest)
	lootReminderFrame:SetPoint("CENTER", UIParent, NIT.db.global.lootReminderX, NIT.db.global.lootReminderY);
	lootReminderFrame.fs:SetFont(NIT.regionFont, NIT.db.global.lootReminderSize, "OUTLINE");
	lootReminderFrame.defaultX = NIT.db.global.lootReminderX;
    lootReminderFrame.defaultY = NIT.db.global.lootReminderY;
	if (runTest) then
		addMsg("Loot reminder test.", 10);
	end
end

function NIT:loadLootReminderFrame()
	local frame = CreateFrame("Frame", "NITLootReminderFrame", UIParent);
	frame:SetSize(1, 1);
	frame:SetPoint("CENTER", UIParent, -10, 100);
	frame.fs = frame:CreateFontString("NITLootReminderFrameFS", "ARTWORK");
	frame.fs:SetPoint("CENTER", 0, 0);
	--NIT:ApplyBounce(frame, 50, 0.5, nil, true);
	NIT:ApplyBounce(frame, 40, 0.4, nil, true);
	
	---Some failed testing attempts below.
	
	--[[frame.animationGroup = frame:CreateAnimationGroup();
	frame.animationGroup:SetLooping("BOUNCE");
	local bounce = frame.animationGroup:CreateAnimation("Translation");
	bounce:SetChildKey("NITLootReminderFrame");
	bounce:SetOffset(0, 40);
	bounce:SetDuration(0.05);
	bounce:SetScript("OnUpdate", function()
		bounce:SetDuration(0.05 + (bounce:GetSmoothProgress() * 0.27));
	end)]]
	
	
    --[[local fadeIn = lootReminderFrame.animationGroup:CreateAnimation("Alpha")
    fadeIn:SetChildKey("enchantBorder")
    fadeIn:SetDuration(0.4)
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)]]
    
    
    
	--[[frame.animation = {};
	frame.defaultX = -10;
	frame.defaultY = 100;
	frame.animation.startAnimation = function()
		frame.lastUpdate = 0;
		frame.yOffset = 1;
		frame.animationDirection = 1;
		frame.animationDistancePerUpdate = 2.45;
		frame.animationUpdateFrequency = 0.01;
		frame.animationHeight = 50;
		frame:SetScript("OnUpdate", function(self)
			if (GetTime() - frame.lastUpdate > frame.animationUpdateFrequency) then
				--if (frame.yOffset >= frame.animationHeight) then
				--	frame.animationDirection = 0;
				--elseif (frame.yOffset <= 0) then
				--	frame.animationDirection = 1;
				--	prin(2)
				end
				local _, _, _, x, y = frame:GetPoint();
				if (y >= frame.defaultY + frame.animationHeight) then
					frame.animationDirection = 0;
				end
				if (y <= frame.defaultY) then
					frame.animationDirection = 1;
					frame.animationDistancePerUpdate = 2.45;
				end
				local distance = GetFramerate() / 160;frame.animationDistancePerUpdate
				if (frame.animationDirection == 1) then
					frame.animationDistancePerUpdate = frame.animationDistancePerUpdate - 0.05;
					frame.yOffset = frame.yOffset + frame.animationDistancePerUpdate;
					frame:SetPoint("CENTER", UIParent, frame.defaultX, frame.defaultY + frame.yOffset);
					--frame:SetPoint("CENTER", UIParent, frame.defaultX, frame.defaultX + (frame.xOffset - (frame.xOffset * 0.3)));
				else
					frame.animationDistancePerUpdate = frame.animationDistancePerUpdate + 0.05;
					frame.yOffset = frame.yOffset - frame.animationDistancePerUpdate;
					frame:SetPoint("CENTER", UIParent, frame.defaultX, frame.defaultY + frame.yOffset);
				end
				frame.lastUpdate = GetTime();
				--print(frame.animationDirection, frame.animationDistancePerUpdate, frame.yOffset)
			end
		end)
	end
	frame.animation.stopAnimation = function()
		frame:SetScript("OnUpdate", nil);
		frame:SetPoint("CENTER", UIParent, frame.defaultX, frame.defaultY);
	end;]]
    
	lootReminderFrame = frame;
end

--Big thanks to Ghost for this animation effect.
--https://github.com/Ghostopheles/Verity/blob/719bb6f3723451e4a2e86387e93a6576d5282f61/Rustbolt/Core/Animations.lua#L22-L67
---@param object any
---@param bounceHeight? number
---@param duration? number
---@param smoothing? string
---@param doNotStart? boolean
function NIT:ApplyBounce(object, bounceHeight, duration, smoothing, doNotStart)
    local defaults = {
        BounceHeight = 50,
        Duration = 0.5,
        Smoothing = "OUT",
    };
    local point, relativeTo, relativePoint, offsetX, offsetY = object:GetPointByName("CENTER");
    local animGroup = object.AnimGroup or object:CreateAnimationGroup();
    animGroup:SetLooping("BOUNCE");
    animGroup.Anim = animGroup.Anim or animGroup:CreateAnimation("Animation");

    local anim = animGroup.Anim;
    anim:SetDuration(duration or defaults.Duration);
    anim:SetSmoothing(smoothing or defaults.Smoothing);

    local function Tick(_)
        local progress = math.sin(anim:GetSmoothProgress());
        local targetOffset = (bounceHeight or defaults.BounceHeight) * progress;
        object:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY + targetOffset);
    end

    anim:SetScript("OnUpdate", Tick);

    local function StartBounce()
        animGroup:Play();
    end

    local function StopBounce(_, noReset)
        animGroup:Stop();
        if noReset then
            return;
        end
        object:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY);
    end

    object.StartBounce = StartBounce;
    object.StopBounce = StopBounce;

    if doNotStart then
        return;
    end

    StartBounce();
end
NIT:loadLootReminderFrame();

function NIT:argentDawnTrinketReminder()
	if (not NIT.db.global.argentDawnTrinketReminder) then
		return;
	end
	if (NIT.expansionNum > 4) then
		return;
	end
	local _, _, _, _, _, _, _, instanceID = GetInstanceInfo();
	if (instanceID == 289 or instanceID == 329) then
		local factionName, _, standing = GetFactionInfoByID(529);
		if (standing and standing < 8 and standing ~= 0) then
			local trinkets = {
				[1] = {
					itemID = 23206,
					name = "|cFFa335ee[Mark of the Champion]|r",
				},
				[2] = {
					itemID = 23207,
					name = "|cFFa335ee[Mark of the Champion]|r",
				},
				[3] = {
					itemID = 13209,
					name = "|cFF0070DD[Seal of the Dawn]|r",
				},
				[4] = {
					itemID = 19812,
					name = "|cFF0070DD[Rune of the Dawn]|c",
				},
				[5] = {
					itemID = 12846,
					name = "|cFFFFFFFF[Argent Dawn Commission]|r",
				},
			};
			local isEquipped;
			for k, v in ipairs(trinkets) do
				if (C_Item.IsEquippedItem(v.itemID)) then
					isEquipped = true;
				end
			end
			local hasBuff = GetPlayerAuraBySpellID(17670); --Now we have to check for buff becaus of sod naxx buff.
			if (not isEquipped and not hasBuff) then
				for k, v in ipairs(trinkets) do
					local trinket = C_Item.GetItemCount(v.itemID);
					if (trinket and trinket > 0) then
						local _, itemLink = C_Item.GetItemInfo(v.itemID);
						local itemString;
						if (itemLink) then
							itemString = itemLink;
						else
							itemString = v.name;
						end
						NIT:print("|cFF00FF00" .. L["Reminder"] .. ":|r " .. string.format(L["missingArgentDawnTrinket"], factionName, itemString));
						addMsg("|cFF00FF00" .. L["Reminder"] .. ":|r " .. string.format(L["missingArgentDawnTrinket"], factionName, itemString), 4);
						return;
					end
				end
			end
		end
	end
end

if (not NIT.isSOD) then
	return;
end

local dungeons = {
	[289] = {name = "Scholomance", order = 5},
	[329] = {name = "Stratholme", order = 6},
	[429] = {name = "Dire Maul", order = 7},
	[230] = {name = "Blackrock Depths", order = 2},
	[229] = {name = "Blackrock Spire", order = 1},
	[2784] = {name = "Demonfall Canyon", order = 3},
	[2875] = {name = "Karazhan Crypts", order = 4},
	--Test RFC.
	--[389] = {name = "Test"},
};

--Some bosses are missing encounter_end event in classic we need a db of all the bosses.
--Tarnished Undermine Real bosses.
--Order field is the most comon order these would be killed in for display purposes.
local turBosses = {
	--Stratholme (1-9 live side, 10+ undead side).
	[-100] = {header = true, title = L["Live Side"], instanceID = 329, order = 0},
	[11058] = {name = "Ezra Grimm", instanceID = 329, order = 1},
	[10516] = {name = "The Unforgiven", instanceID = 329, order = 2},
	[11143] = {name = "Postmaster Malown", instanceID = 329, order = 3},
	[10808] = {name = "Timmy the Cruel", instanceID = 329, order = 4},
	[11032] = {name = "Malor the Zealous", instanceID = 329, order = 5},
	[10997] = {name = "Cannon Master Willey", instanceID = 329, order = 6},
	[10811] = {name = "Archivist Galford", instanceID = 329, order = 7},
	[10812] = {name = "Balnazzar", instanceID = 329, order = 8}, --Balnazaar is Grand Crusader Dathrohan npcID when it dies and as Balnazzar corpse.
	[-101] = {header = true, title = L["Undead Side"], instanceID = 329, order = 10},
	[10437] = {name = "Nerub'enkan", instanceID = 329, order = 11},
	[10436] = {name = "Baroness Anastari", instanceID = 329, order = 12},
	[10438] = {name = "Maleki the Pallid", instanceID = 329, order = 13},
	[10435] = {name = "Magistrate Barthilas", instanceID = 329, order = 14},
	--[11121] = {name = "Black Guard Swordsmith", instanceID = 329, order = 15}, --Doesn't drop.
	[10439] = {name = "Ramstein the Gorger", instanceID = 329, order = 16},
	[10440] = {name = "Baron Rivendare", instanceID = 329, order = 17, reals = 2},
	--[11120] = {name = "Crimson Hammersmith", instanceID = 329, order = 99}, --Needs testing (spawnable mob unlikely to drop).
	--[10812] = {name = "Grand Crusader Dathrohan", instanceID = 329, order = 99}, --Becomes Balnazzar halfway through the fight.
	--[10558] = {name = "Hearthsinger Forresten", instanceID = 329, order = 99}, --Needs testing.
	--[10393] = {name = "Skul", instanceID = 329, order = 99}, --Needs testing (rare mob so unlikely to drop).
	--[10809] = {name = "Stonespine", instanceID = 329, order = 99}, --Needs testing (rare mob so unlikely to drop).
	[14684] = {name = "Balzaphon", instanceID = 329, order = 18, reals = 3},
	
	
	--Scholomance.
	[10506] = {name = "Kirtonos the Herald", instanceID = 289, order = 1},
	[10503] = {name = "Jandice Barov", instanceID = 289, order = 2},
	[11622] = {name = "Rattlegore", instanceID = 289, order = 3},
	[10433] = {name = "Marduk Blackpool", instanceID = 289, order = 4},
	[10432] = {name = "Vectus", instanceID = 289, order = 5},
	[10508] = {name = "Ras Frostwhisper", instanceID = 289, order = 6},
	[10505] = {name = "Instructor Malicia", instanceID = 289, order = 7},
	[11261] = {name = "Doctor Theolen Krastinov", instanceID = 289, order = 8},
	[10901] = {name = "Lorekeeper Polkelt", instanceID = 289, order = 9},
	[10507] = {name = "The Ravenian", instanceID = 289, order = 10},
	[10504] = {name = "Lord Alexei Barov", instanceID = 289, order = 11},
	[10502] = {name = "Lady Illucia Barov", instanceID = 289, order = 12},
	[1853] = {name = "Darkmaster Gandling", instanceID = 289, order = 13},
	[14695] = {name = "Lord Blackwood", instanceID = 289, order = 14, reals = 3},
	
	--Blackrock Depths. (Which BRD bosses can drop them? Not all can I think, this list is which on wowhead has seen a drop but probably not complete.
	[9016] = {name = "Bael'Gar", instanceID = 230, order = 1},
	[9017] = {name = "Lord Incendius", instanceID = 230, order = 2},
	[9056] = {name = "Fineous Darkvire", instanceID = 230, order = 3},
	[9033] = {name = "General Angerforge", instanceID = 230, order = 4},
	[8983] = {name = "Golem Lord Argelmach", instanceID = 230, order = 5},
	[9537] = {name = "Hurley Blackbreath", instanceID = 230, order = 6},
	[9502] = {name = "Phalanx", instanceID = 230, order = 7},
	[9156] = {name = "Ambassador Flamelash", instanceID = 230, order = 8},
	[9938] = {name = "Magmus", instanceID = 230, order = 9},
	[9019] = {name = "Emperor Dagran Thaurissan", instanceID = 230, order = 10, reals = 2},
	
	--Dire Maul (1-9 east, 10-19 west, 20+ north).
	[-102] = {header = true, title = L["East"], instanceID = 429, order = 0},
	[14354] = {name = "Pusillin", instanceID = 429, order = 1},
	[11490] = {name = "Zevrim Thornhoof", instanceID = 429, order = 2},
	[13280] = {name = "Hydrospawn", instanceID = 429, order = 3},
	[14327] = {name = "Lethtendris", instanceID = 429, order = 4},
	[11492] = {name = "Alzzin the Wildshaper", instanceID = 429, order = 5},
	[-103] = {header = true, title = L["West"], instanceID = 429, order = 10},
	[11489] = {name = "Tendris Warpwood", instanceID = 429, order = 11},
	[11488] = {name = "Illyanna Ravenoak", instanceID = 429, order = 12},
	[11487] = {name = "Magister Kalendris", instanceID = 429, order = 13},
	--[11467] = {name = "Tsu'zee", instanceID = 429, order = 14}, --Needs testing (rare mob so unlikely to drop).
	[11496] = {name = "Immol'thar", instanceID = 429, order = 15},
	[11486] = {name = "Prince Tortheldrin", instanceID = 429, order = 16},
	[-104] = {header = true, title = L["North"], instanceID = 429, order = 20},
	--[14326] = {name = "Guard Mol'dar", instanceID = 429, order = 21}, --Some north bosses don't drop, probably for tribute run reasons.
	--[14322] = {name = "Stomper Kreeg", instanceID = 429, order = 22}, --Some north bosses don't drop, probably for tribute run reasons.
	--[14321] = {name = "Guard Fengus", instanceID = 429, order = 23}, --Some north bosses don't drop, probably for tribute run reasons.
	--[14323] = {name = "Guard Slip'kik", instanceID = 429, order = 24}, --Some north bosses don't drop, probably for tribute run reasons.
	--[14325] = {name = "Captain Kromcrush", instanceID = 429, order = 25}, --Some north bosses don't drop, probably for tribute run reasons.
	--[14324] = {name = "Cho'Rush the Observer", instanceID = 429, order = 26}, --The add during the last boss fight, no drop?
	[11501] = {name = "King Gordok", instanceID = 429, order = 27, reals = 3},
	
	--Demonfall Canyon.
	[226923] = {name = "Grimroot", instanceID = 2784, order = 1},
	[228022] = {name = "The Destructor's Wraith", instanceID = 2784, order = 2},
	[226922] = {name = "Zilbagob", instanceID = 2784, order = 3},
	[232632] = {name = "Azgaloth", instanceID = 2784, order = 4, reals = 3},
	[227140] = {name = "Pyranis", instanceID = 2784, order = 5},
	[227019] = {name = "Diathorus the Seeker", instanceID = 2784, order = 6},
	[227028] = {name = "Hellscream's Phantom", instanceID = 2784, order = 7},
	
	--Blackrock Spire (1-9 lower, 10+ upper).
	[-105] = {header = true, title = L["Upper"], instanceID = 229, order = 0},
	[9816] = {name = "Pyroguard Emberseer", instanceID = 229, order = 1},
	--[10264] = {name = "Solakar Flamewreath", instanceID = 229, order = 2}, -- No drop.
	--[10899] = {name = "Goraluk Anvilcrack", instanceID = 229, order = 3}, --No drop.
	--[10339] = {name = "Gyth <Rend Blackhand's Mount>", instanceID = 229, order = 4}, --No drop.
	[10429] = {name = "Warchief Rend Blackhand", instanceID = 229, order = 5},
	[10430] = {name = "The Beast", instanceID = 229, order = 6},
	[10363] = {name = "General Drakkisath", instanceID = 229, order = 7},
	--[10509] = {name = "Jed Runewatcher", instanceID = 229, order = 99}, --No drop.
	[-106] = {header = true, title = L["Lower"], instanceID = 229, order = 10},
	[9196] = {name = "Highlord Omokk", instanceID = 229, order = 11},
	[9236] = {name = "Shadow Hunter Vosh'gajin", instanceID = 229, order = 12},
	[9237] = {name = "War Master Voone", instanceID = 229, order = 13},
	[10596] = {name = "Mother Smolderweb", instanceID = 229, order = 14},
	[10584] = {name = "Urok Doomhowl", instanceID = 229, order = 15},
	--[9736] = {name = "Quartermaster Zigris", instanceID = 229, order = 16}, --Needs testing.
	[10220] = {name = "Halycon", instanceID = 229, order = 17},
	[10268] = {name = "Gizrul the Slavener", instanceID = 229, order = 18},
	[9568] = {name = "Overlord Wyrmthalak", instanceID = 229, order = 19, reals = 3},
	
	--Karazhan crypts.
	[238213] = {name = "Sairuh Maryla", instanceID = 2875, order = 1, encounterID = 3170, sharedNPCs = {238233, 238234}, reals = 5}, --Apprentice.
	[238233] = {name = "Kaigy Maryla", instanceID = 2875, order = 2, encounterID = 3171, sharedNPCs = {238213, 238234}, reals = 5, dontCount = true}, --Apprentice.
	[238234] = {name = "Barian Maryla", instanceID = 2875, order = 3, encounterID = 3172, sharedNPCs = {238213, 238233}, reals = 5, dontCount = true}, --Apprentice.
	[1] = {name = "Opera of Malediction", instanceID = 2875, order = 4, encounterID = 3144, sharedNPCs = {2, 3}, reals = 5}, --Opera.
	[2] = {name = "Opera of Malediction", instanceID = 2875, order = 5, encounterID = 3168, sharedNPCs = {1, 3}, reals = 5, dontCount = true}, --Opera.
	[3] = {name = "Opera of Malediction", instanceID = 2875, order = 6, encounterID = 3169, sharedNPCs = {1, 2}, reals = 5, dontCount = true}, --Opera.
	[237964] = {name = "Harbringer of Sin", instanceID = 2875, order = 7, encounterID = 3141, reals = 5},
	[238024] = {name = "Creeping Malison", instanceID = 2875, order = 8, encounterID = 3146, reals = 5},
	[237439] = {name = "Kharon", instanceID = 2875, order = 9, encounterID = 3143, reals = 5},
	--[238678] = {name = "Unk'omon", instanceID = 2875, order = 10, encounterID = 3152}, --No real from this boss.
	[238055] = {name = "Dark Rider", instanceID = 2875, order = 11, encounterID = 3145, reals = 5},
	--[7] = {name = "Criminal", instanceID = 2875, order = 12, encounterID = 3142}, --Secret boss not found yet?
	
	--RFC testing.
	--[11520] = {name = "Taragaman the Hungerer", instanceID = 389, order = 13, encounterID = 2733},
	--[11518] = {name = "Jergosh the Invoker", instanceID = 389, order = 14, encounterID = 2734},
	--[11519] = {name = "Taragaman the Hungerer", instanceID = 389, order = 15, encounterID = 2735},
};

--Using encounter ID's and showing list on tooltip.
--Needs mapping to npcIDs for corpse recognition.
--All enounters here MUST be mapped by a NPC above or there will be duplicate boss kill data issues.
local turBossesUsingEncounter = {
	--Karazhan crypts.
	[3170] = {name = "Apprentice", instanceID = 2875, order = 1},
	[3171] = {name = "Apprentice", instanceID = 2875, order = 2},
	[3172] = {name = "Apprentice", instanceID = 2875, order = 3}, --Barian Maryla.
	[3144] = {name = "Opera of Malediction", instanceID = 2875, order = 4},
	[3168] = {name = "Opera of Malediction", instanceID = 2875, order = 5},
	[3169] = {name = "Opera of Malediction", instanceID = 2875, order = 6},
	[3141] = {name = "Harbringer of Sin", instanceID = 2875, order = 7},
	[3146] = {name = "Creeping Malison", instanceID = 2875, order = 8},
	[3143] = {name = "Kharon", instanceID = 2875, order = 9},
	--[3152] = {name = "Unk'omon", instanceID = 2875, order = 10},  --No real from this boss.
	[3145] = {name = "Dark Rider", instanceID = 2875, order = 11},
	--[3142] = {name = "Criminal", instanceID = 2875, order = 12}, --Secret boss not found yet?
	
	--RFC testing.
	--[2733] = {name = "Taragaman the Hungerer", instanceID = 2875, order = 11},
	--[2734] = {name = "Jergosh the Invoker", instanceID = 2875, order = 11},
	--[2735] = {name = "Taragaman the Hungerer", instanceID = 2875, order = 11},
};

--Bosses with a lockout like the world bosses and ony, no need to track coins just send a loot reminder when they die.
--Mapped to npcID.
local turBossesNoRecord = {
	[14695] = {name = "Lord Blackwood", instanceID = 289}, --Scholo.
	[14684] = {name = "Balzaphon", instanceID = 329}, --Strath.
	[6109] = {name = "Azuregos", instanceID = 2791},
	[230302] = {name = "Lord Kazzak", instanceID = 2789},
	[10184] = {name = "Onyxia", instanceID = 249},
	--MC.
	--[[[12056] = {name = "Baron Geddon", instanceID = 409},
	[228433] = {name = "Baron Geddon", instanceID = 409},
	[12057] = {name = "Garr", instanceID = 409},
	[228432] = {name = "Garr", instanceID = 409},
	[12259] = {name = "Gehennas", instanceID = 409},
	[228431] = {name = "Gehennas", instanceID = 409},
	[11988] = {name = "Golemagg the Incinerator", instanceID = 409},
	[228435] = {name = "Golemagg the Incinerator", instanceID = 409},
	[12118] = {name = "Lucifron", instanceID = 409},
	[228429] = {name = "Lucifron", instanceID = 409},
	[11982] = {name = "Magmadar", instanceID = 409},
	[228430] = {name = "Magmadar", instanceID = 409},
	[12018] = {name = "Majordomo Executus", instanceID = 409},
	[228437] = {name = "Majordomo Executus", instanceID = 409},
	[11502] = {name = "Ragnaros", instanceID = 409},
	[228438] = {name = "Ragnaros", instanceID = 409},
	[12264] = {name = "Shazzrah", instanceID = 409},
	[228434] = {name = "Shazzrah", instanceID = 409},
	[12098] = {name = "Sulfuron Harbinger", instanceID = 409},
	[228436] = {name = "Sulfuron Harbinger", instanceID = 409},
	--BWL.
	[12435] = {name = "Razorgore the Untamed", instanceID = 469},
	[12017] = {name = "Broodlord Lashlayer", instanceID = 469},
	[14020] = {name = "Chromaggus", instanceID = 469},
	[14601] = {name = "Ebonroc", instanceID = 469},
	[11983] = {name = "Firemaw", instanceID = 469},
	[11981] = {name = "Flamegor", instanceID = 469},
	[11583] = {name = "Nefarian", instanceID = 469},
	[13020] = {name = "Vaelastrasz the Corrupt", instanceID = 469},]]
};

--Encounters where the boss doesn't die, or where's there's more than 1 boss and we need to wait for all to die, use the encounter event.
--Probably end up just changing all raid bosses to this instead of the death event.
--Mapped to encounterID.
local turBossesNoRecordEncounter = {
	--[6109] = {name = "Azuregos"},
	--[230302] = {name = "Lord Kazzak"},
	--[10184] = {name = "Onyxia"},
	--MC.
	[668] = {name = "Baron Geddon"},
	[666] = {name = "Garr"},
	[665] = {name = "Gehennas"},
	[667] = {name = "Golemagg the Incinerator"},
	[663] = {name = "Lucifron"},
	[664] = {name = "Magmadar"},
	[671] = {name = "Majordomo Executus"},
	[672] = {name = "Ragnaros"},
	[667] = {name = "Shazzrah"},
	[669] = {name = "Sulfuron Harbinger"},
	--BWL.
	[610] = {name = "Razorgore the Untamed"},
	[612] = {name = "Broodlord Lashlayer"},
	[616] = {name = "Chromaggus"},
	[613] = {name = "Firemaw"},
	[615] = {name = "Flamegor/Ebonroc"}, --SoD combined these 2 bosses.
	[617] = {name = "Nefarian"},
	[611] = {name = "Vaelastrasz the Corrupt"},
	--ZG.
	[793] = {name = "Hakkar"},
	[791] = {name = "High Priestess Arlokk"},
	[792] = {name = "Jin'do the Hexxer"},
	[789] = {name = "High Priest Thekal"},
	[788] = {name = "Edge of Madness"},
	[787] = {name = "Bloodlord Mandokir"},
	[786] = {name = "High Priestess Mar'li"},
	[784] = {name = "High Priest Venoxis"},
	[785] = {name = "High Priestess Jeklik"},
	[790] = {name = "Gahz'ranka"},
	--The crystal vale.
	[3079] = {name = "Prince Thunderaan"},
	--Aq20.
	[718] = {name = "Kurinnaxx"},
	[719] = {name = "General Rajaxx"},
	[720] = {name = "Moam"},
	[721] = {name = "Buru the Gorger"},
	[722] = {name = "Ayamiss the Hunter"},
	[723] = {name = "Ossirian the Unscarred"},
	--Aq40.
	[709] = {name = "The Prophet Skeram"},
	[710] = {name = "Silithid Royalty"},
	[711] = {name = "Battleguard Sartura"},
	[712] = {name = "Fankriss the Unyielding"},
	[713] = {name = "Viscidus"},
	[714] = {name = "Princess Huhuran"},
	[715] = {name = "Twin Emperors"},
	[716] = {name = "Ouro"},
	[717] = {name = "C'thun"},
	--Nightmare grove.
	[3113] = {name = "Taerar"},
	[3114] = {name = "Ysondre"},
	[3111] = {name = "Emeriss"},
	[3112] = {name = "Lethon"},
};

local qirajiBossesNoRecordEncounter = {
	--AQ20.
	[718] = {name = "Kurinnaxx"},
	[719] = {name = "General Rajaxx"},	
	[720] = {name = "Moam"}, --Does this drop?
	[721] = {name = "Buru the Gorger"},	
	[722] = {name = "Ayamiss the Hunter"}, 	
	[723] = {name = "Ossirian the Unscarred"},
	--AQ40.
	[709] = {name = "The Prophet Skeram"},
	[710] = {name = "Silithid Royalty"},
	[711] = {name = "Battleguard Sartura"},
	[712] = {name = "Fankriss the Unyielding"},
	[713] = {name = "Viscidus"},
	[714] = {name = "Princess Huhuran"},
	[715] = {name = "Twin Emperors"},
	[716] = {name = "Ouro"},
	[717] = {name = "C'Thun"},
};

local remnantsBossesNoRecordEncounter = {
	--Naxx.
	[1107] = {name = "Anub'Rekhan"},
	[1110] = {name = "Grand Widow Faerlina"},
	[1116] = {name = "Maexxna"},
	[1117] = {name = "Noth the Plaguebringer"},
	[1112] = {name = "Heigan the Unclean"},
	[1115] = {name = "Loatheb"},
	[1113] = {name = "Instructor Razuvious"},
	[1109] = {name = "Gothik the Harvester"},
	[1121] = {name = "Baron Rivendare"},
	[1118] = {name = "Patchwerk"},
	[1111] = {name = "Grobbulus"},
	[1108] = {name = "Gluth"},
	[1120] = {name = "Thaddius"},
	[1119] = {name = "Sapphiron"},
	[1114] = {name = "Kel'Thuzad"},
};

local function getTotalDailyReals()
	local reals = 0;
	for k, v in pairs(turBosses) do
		if (not v.header and not v.dontCount) then
			reals = reals + (v.reals or 1);
		end
	end
	return reals;
end

local function getTotalRealsPerDungeon(instanceID)
	local reals = 0;
	for k, v in pairs(turBosses) do
		if (v.instanceID == instanceID and not v.header and not v.dontCount) then
			reals = reals + (v.reals or 1);
		end
	end
	return reals;
end

--[[local function isTurLockoutInstance()
	local instanceID = NIT.currentInstanceID;
	if (instanceID) then
		for k, v in pairs(turBossesNoRecord) do
			if (instanceID == v.instanceID) then
				return true;
			end
		end
	end
end]]

local function getBossCount(instanceID)
	local count, headerCount = 0, 0;
	for k, v in pairs(turBosses) do
		if (v.instanceID == instanceID and not v.header) then
			if (v.header) then
				headerCount = headerCount + 1;
			else
				count = count + 1;
			end
		end
	end
	return count, headerCount;
end

local function getLootedStatus(npcOrEncounterID, itemID, isEncounterID) --/dump getLootedStatus(2733, 226404)
	local looted, killed;
	local data = NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID];
	if (isEncounterID) then
		local data;
		local bossData;
		local bossDataID;
		local bosses = {};
		--Create a table of shared encounter npcs so we can check all for looted status.
		--Bit of a hacky way to handle multiple bosses in a rotating encounter.
		--Sorting the encounterIDs and attaching all kills and displays to the lowest ID would probably be a better solution later.
		for k, v in pairs(turBosses) do
			if (v.encounterID == npcOrEncounterID) then
				bossData = v;
				bossDataID = k;
				break;
			end
		end
		if (bossData and bossData.sharedNPCs) then
			bosses[bossDataID] = bossData;
			for k, v in pairs(bossData.sharedNPCs) do
				if (turBosses[v]) then
					bosses[v] = turBosses[v];
				end
			end
			for k, v in pairs(bosses) do
				if (NIT.data.myChars[NIT.UnitName("player")].bossKills[v.encounterID]) then
					data = NIT.data.myChars[NIT.UnitName("player")].bossKills[v.encounterID];
					if (data and data.looted and data.looted[itemID] and data.resetTime and data.resetTime > GetServerTime()) then
						looted = true;
					elseif (data and data.resetTime and data.resetTime > GetServerTime()) then
						killed = true;
					end
				end
			end
		end
	end
	if (data and data.looted and data.looted[itemID] and data.resetTime and data.resetTime > GetServerTime()) then
		looted = true;
	elseif (data and data.resetTime and data.resetTime > GetServerTime()) then
		--Killed but not looted.
		killed = true;
	end
	if (looted) then
		return true;
	elseif (killed) then
		return false, true;
	end
end

local function getTotalLootedToday()
	local count = 0;
	for k, v in pairs(turBosses) do
		if (not v.header) then
			local looted = getLootedStatus(k, 226404);
			if (looted) then
				count = count + (v.reals or 1);
			end
		end
	end
	return count;
end

function NIT:getLootReminderMinimapString()
	if (NIT.currentInstanceID and dungeons[NIT.currentInstanceID] and UnitLevel("player") > 44) then
		local text = "";
		local sorted = {};
		local count = 0;
		local lootedCount = 0;
		local npcs = {};
		local usingEnconterIDs;
		for k, v in pairs(turBosses) do
			--Check if we're going by encounterID or NPC death.
			--Originally it was all just NPC deaths but now there's dungeons with rotating bosses so we need to use enounterIDs.
			--Map the npcID to enounterID in the tables above and then check here when displaying it so we only show 1 boss from the enounter rotation (like opera etc).
			--It's a bit overly complicated but it works for neatness.
			if (v.instanceID == NIT.currentInstanceID) then
				local skip;
				if (v.sharedNPCs) then
					for _, sharedID in pairs(v.sharedNPCs) do
						if (npcs[sharedID]) then
							skip = true;
						end
					end
				end
				if (not skip) then
					if (v.encounterID) then
						usingEnconterIDs = true;
						local data = turBossesUsingEncounter[v.encounterID];
						if (data) then
							local t = {
								npcID = v.encounterID,
								name = data.name,
								order = v.order,
								instanceID = v.instanceID,
								header = v.header,
								title = v.title,
								isEncounterID = true,
							};
							tinsert(sorted, t);
						end
					else
						local t = {
							npcID = k,
							name = v.name,
							order = v.order,
							instanceID = v.instanceID,
							header = v.header,
							title = v.title,
						};
						tinsert(sorted, t);
					end
					npcs[k] = true;
				end
			end
		end
		table.sort(sorted, function(a, b) return a.order < b.order end);
		for k, v in pairs(sorted) do
			count = count + 1;
			if (v.header) then
				local headerString = "|cFF9CD6DE[" .. v.title  .. "]|r";
				if (count == 1) then
					text = text .. headerString;
				else
					text = text .. "\n" .. headerString;
				end
			else
				local looted, isKilledButNotLooted = getLootedStatus(v.npcID, 226404, v.isEncounterID);
				local lootedString;
				if (isKilledButNotLooted) then
					lootedString = "|cFFFF6900(" .. L["Killed But Not Looted"] .. ")|r";
				elseif (looted) then
					lootedString = "|cFF00FF00(" .. L["Looted"] .. ")|r";
					lootedCount = lootedCount + 1;
				else
					lootedString = "|cFFFF0000(" .. L["Not Killed"] .. ")|r";
				end
				local extraInfoString = "";
				if (v.reals) then
					extraInfoString = " |cFF9CD6DE(x|cFF00FF00" .. v.reals .. "|r)|r"
				end
				if (count == 1) then
					text = text .. "|cFFFFAE42".. v.name .. extraInfoString .. "|r  " .. lootedString;
				else
					text = text .. "\n|cFFFFAE42" .. v.name .. extraInfoString .. "|r  " .. lootedString;
				end
			end
		end
		local bossCount, headerCount = getBossCount(NIT.currentInstanceID);
		if (usingEnconterIDs) then
			bossCount = #sorted;
		end
		local lootedString;
		if (lootedCount >= bossCount) then
			lootedString = "|cFF00FF00" .. lootedCount .. "/" .. bossCount .. " " .. L["Bosses Looted"] .. "|r";
		else
			lootedString = "|cFF9CD6DE " .. lootedCount .. "/" .. bossCount .. " " .. L["Bosses Looted"] .. "|r";
		end
		local header = "|cFFFFFF00" .. L["Tarnished Undermine Real"] .. "|r - " .. lootedString .. "\n";
		if (NIT.currentInstanceID == 2875) then
			local instance = NIT.data.instances[1];
			if (instance) then
				text = text .. "\n\n|cFFFF10F0" .. L["Mysterious Relic Looters"] .. "|r";
				if (instance.karaRelics and instance.karaRelics[236878]) then
					text = text .. "\n|T135371:11:11|t  |cFF009B77Sword:|r  |cFFFFFF00Looted by " .. instance.karaRelics[236878].name .. "|r";
				else
					text = text .. "\n|T135371:11:11|t  |cFF009B77Sword:|r  |cFFFFFFFFNot looted|r";
				end
				if (instance.karaRelics and instance.karaRelics[236879]) then
					text = text .. "\n|T135213:11:11|t  |cFF009B77Scythe:|r  |cFFFFFF00Looted by " .. instance.karaRelics[236879].name .. "|r";
				else
					text = text .. "\n|T135213:11:11|t  |cFF009B77Scythe:|r  |cFFFFFFFFNot looted|r";
				end
				if (instance.karaRelics and instance.karaRelics[236880]) then
					text = text .. "\n|T306709:11:11|t  |cFF009B77Staff:|r  |cFFFFFF00Looted by " .. instance.karaRelics[236880].name .. "|r";
				else
					text = text .. "\n|T306709:11:11|t  |cFF009B77Staff:|r  |cFFFFFFFFNot looted|r";
				end
			end
		end
		if (text ~= "") then
			return header .. text;
		end
	end
end

local karaRelics = {
	[236878] = "Sword",
	[236879] = "Scythe",
	[236880] = "Staff",
};
local lootAnnounceAll = {

};

--This will be added as an option later.
function NIT_TrackOrbs(silent)
	lootAnnounceAll[12811] = {name = "Righteous Orb", instanceID = 329};
	if (not silent) then
		print("Now announcing Righteous Orbs looted to chat.");
	end
end

local function itemLooted(itemID, name)
	if (itemID and name) then
		--if (NIT.db.global.lootReminderItem) then
			local item = Item:CreateFromItemID(itemID);
			item:ContinueOnItemLoad(function()
				local itemName = item:GetItemName();
				local itemLink = item:GetItemLink();
				local me = NIT.UnitName("player");
				if (name == me) then
					name = "me";
				end
				if (IsInGroup()) then
					NIT:SendChatMessage("[NIT] " .. itemName .. " looted by " .. name.. "!", "PARTY");
				else
					NIT:SendChatMessage("[NIT] " .. itemName .. " looted by " .. name.. "!", "SAY");
				end
				addMsg(itemName .. " looted by " .. name .. "!", 5);
			end);
		--end
	end
end

local function relicLooted(itemID, name, class)
	if (itemID and name) then
		local _, _, _, classColorHex = GetClassColor(class);
		local nameColorized = "|c" .. classColorHex .. name .. "|r";
		local type = karaRelics[itemID];
		if (NIT.db.global.lootReminderMysRelic) then
			local item = Item:CreateFromItemID(itemID);
			item:ContinueOnItemLoad(function()
				local itemName = item:GetItemName();
				local itemLink = item:GetItemLink();
				local me = NIT.UnitName("player");
				if (name == me) then
					NIT:print(itemLink .. " (" .. type .. ") looted by you!");
					addMsg(itemName .. " (" .. type .. ") looted by you!", 5);
				else
					NIT:print(itemLink .. " (" .. type .. ") looted by " .. nameColorized .. "!");
					addMsg(itemName .. " (" .. type .. ") looted by " .. nameColorized .. "!", 5);
				end
				if (NIT.db.global.lootReminderMysRelicParty) then
					if (name == me) then
						NIT:SendChatMessage("[NIT] " .. itemName .. " (" .. type .. ") looted by " .. name.. "!", "PARTY");
					else
						NIT:SendChatMessage("[NIT] " .. itemName .. " (" .. type .. ") looted by " .. name .. "!", "PARTY");
					end
				end
			end);
		end
		local instance = NIT.data.instances[1];
		if (instance and NIT.inInstance) then
			itemID = tonumber(itemID);
			if (not instance.karaRelics) then
				instance.karaRelics = {};
			end
			instance.karaRelics[itemID] = {
				name = nameColorized,
				time = GetServerTime(),
			};
		end
	end
end

local function addLootedReal(npcOrEncounterID, itemID)
	local resetTime = GetServerTime() + C_DateAndTime.GetSecondsUntilDailyReset();
	if (not NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID]) then
		NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID] = {};
	end
	if (not NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID].looted) then
		NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID].looted = {};
	end
	if (not NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID].resetTime or
			(NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID].resetTime < GetServerTime() - 300)) then
		NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID].resetTime = resetTime;
		NIT:debug("Missing boss kill reset time", npcOrEncounterID); --Possiblly if a boss not on the list drops a token?
	end
	NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID].looted[itemID] = true;
end

local function chatMsgLoot(...)
	local msg = ...;
    local amount;
    local name = NIT.UnitName("player");
    
    ---This was changed to use an old liv LebDeformat to fix issues with korean strings.
    ---The SELF loot strings were triggering for other people, so item counts would count everyone in the party.
    ---The lib fixed this.
    
    local otherPlayer, item, loot;
    --Self loot multiple item "You receive loot: [Item]x2"
	--local itemLink, amount = strmatch(msg, string.gsub(string.gsub(LOOT_ITEM_SELF_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)"));
	local itemLink, amount = NIT.libDeformat(msg, LOOT_ITEM_SELF_MULTIPLE);
	if (not itemLink) then
 		--Self receive single loot "You receive loot: [Item]"
    	--itemLink = msg:match(LOOT_ITEM_SELF:gsub("%%s", "(.+)"));
    	itemLink = NIT.libDeformat(msg, LOOT_ITEM_SELF);
		if (not itemLink) then
 			--Self receive single item "You receive item: [Item]"
			--itemLink = msg:match(LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)"));
			itemLink = NIT.libDeformat(msg, LOOT_ITEM_PUSHED_SELF);
			item = true;
		end
    end
    --If no matches for self loot then check other player loot msgs.
    if (not itemLink) then
    	otherPlayer = true;
    	--Other player receive multiple loot "Otherplayer receives loot: [Item]x2"
    	name, itemLink, amount = NIT.libDeformat(msg, LOOT_ITEM_MULTIPLE);
    	if (not itemLink) then
    		--Other player receive single loot "Otherplayer receives loot: [Item]"
    		name, itemLink = NIT.libDeformat(msg, LOOT_ITEM);
			if (not itemLink) then
				--Other player loot multiple item "Otherplayer receives item: [Item]x2"
				name, itemLink, amount = NIT.libDeformat(msg, LOOT_ITEM_PUSHED_MULTIPLE);
				item = true;
				if (not itemLink) then
	 				--Other player receive single item "Otherplayer receives item: [Item]"
					name, itemLink = NIT.libDeformat(msg, LOOT_ITEM_PUSHED);
					item = true;
				end
			end
    	end
    end
    if (itemLink) then
    	if (not item) then
	    	loot = true;
	    end
    	if (NIT.inInstance) then
	    	local itemID = string.match(itemLink, "item:(%d+)");
	    	if (itemID) then
	    		itemID = tonumber(itemID);
	    		if (lootAnnounceAll[itemID] and lootAnnounceAll[itemID].instanceID == NIT.currentInstanceID and not item) then
	    			if (otherPlayer) then
		    			itemLooted(itemID,  name);
	    			else
	    				local me = NIT.UnitName("player");
		    			itemLooted(itemID,  me);
	    			end
	    		end
	    		if (otherPlayer) then
	    			if (karaRelics[itemID]) then
	    				local class;
	    				if (IsInRaid()) then
							for i = 1, 40 do
								local n, r = NIT.UnitName("raid" .. i);
								if (name == n or (r and name == n .. "-" .. r)) then
									local _, classEnglish = UnitClass("raid" .. i);
									class = classEnglish;
									break;
								end
							end
						elseif (IsInGroup()) then
							for i = 1, 5 do
								local n, r = NIT.UnitName("party" .. i);
								if (name == n or (r and name == n .. "-" .. r)) then
									local _, classEnglish = UnitClass("party" .. i);
									class = classEnglish;
									break;
								end
							end
						end
	    				relicLooted(itemID, name, class);
	    			end
	    		else
		    		if (karaRelics[itemID]) then
		    			local me = NIT.UnitName("player");
		    			local _, classEnglish = UnitClass("player");
		    			relicLooted(itemID,  me, classEnglish);
		    		elseif (itemID == 226404) then
		    			hideMiddleMsg();
		    			if (NIT.currentInstanceID and dungeons[NIT.currentInstanceID]) then
		    				if (NIT.currentInstanceID == 2875 and (lastEncounterID == 3144 or lastEncounterID == 3168 or lastEncounterID == 3169)) then
		    					NIT:debug("Using lastEncounterID:", lastEncounterID, lastLootNpcID);
			    				addLootedReal(lastEncounterID, itemID);
		    				else
				    			if (lastLootNpcID) then
				    				NIT:debug("Using lastLootNpcID:", lastLootNpcID);
				    				if (turBosses[lastLootNpcID].encounterID) then
				    					addLootedReal(turBosses[lastLootNpcID].encounterID, itemID);
				    				else
				    					addLootedReal(lastLootNpcID, itemID);
				    				end
								elseif (lastBossNpcID) then
									NIT:debug("Using backup lastBossNpcID:", lastBossNpcID);
									if (turBosses[lastBossNpcID].encounterID) then
				    					addLootedReal(turBosses[lastBossNpcID].encounterID, itemID);
				    				else
										addLootedReal(lastBossNpcID, itemID);
									end
								else
									NIT:debug("Loot ID error:", itemID, lastLootNpcID, lastBossNpcID);
								end
							end
							lastLootNpcID = nil;
						end
					elseif (itemID == 21229 or itemID == 236397) then
		    			hideMiddleMsg();
		    		end
		    	end
	    	end
    	end
    end
end

local function lootOpened()
	--lastLootNpcID = nil; --Delete old ID on looting real instead.
	local sources = {GetLootSourceInfo(1)}
	--Always only 1 source in classic.
	local guid = sources[1];
	--Check loot sources first.
	if (guid) then
		local _, _, _, _, zoneID, npcID = strsplit("-", guid);
		if (npcID) then
			npcID = tonumber(npcID);
			if (npcID and turBosses[npcID]) then
				lastLootNpcID = npcID;
			end
		end
		return;
	end
	local guid = UnitGUID("target");
	--Check target as backup.
	if (guid) then
		if (issecretvalue and issecretvalue(guid)) then
			return;
		end
		local _, _, _, _, zoneID, npcID = strsplit("-", guid);
		if (npcID) then
			npcID = tonumber(npcID);
			if (npcID and turBosses[npcID]) then
				lastLootNpcID = npcID;
			end
		end
	end
end

--local function lootClosed()
	--It was unreliable removing the npcID when loot closed, it can close before the items are looted to your bags with auto loot.
	--And using a delay timer would be unreliable with ping I think.
	--Just clear the last npcID when loot is opened for now and see how reliable it is.
	--lastLootNpcID = nil;
--end

local function skipRealMsgIfCapped()
	if (NIT.db.global.skipRealMsgIfCapped) then
		local itemCount = C_Item.GetItemCount(226404);
		if (itemCount and itemCount == 150) then
			return true;
		end
	end
end

local function addBossDied(npcOrEncounterID)
	local resetTime = GetServerTime() + C_DateAndTime.GetSecondsUntilDailyReset();
	if (not NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID]) then
		NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID] = {};
	end
	NIT.data.myChars[NIT.UnitName("player")].bossKills[npcOrEncounterID].resetTime = resetTime;
end

local function encounterEndSuccess(encounterID)
	if (turBossesUsingEncounter[encounterID]) then
		if (not skipRealMsgIfCapped()) then
			addMsg(string.format(L["lootTheItem"], L["Tarnished Undermine Real"]) .. "!", 10);
			addBossDied(encounterID);
		end
	elseif (turBossesNoRecordEncounter[encounterID]) then
		if (not skipRealMsgIfCapped()) then
			addMsg(string.format(L["lootTheItem"], L["Tarnished Undermine Real"]) .. "!", 10);
		end
	elseif (qirajiBossesNoRecordEncounter[encounterID]) then
		local _, _, standing = GetFactionInfoByID(910); --Brood of Nozdormu.
		local _, _, standing2 = GetFactionInfoByID(609); --Cenarion Circle.
		if ((standing and standing < 8 and standing ~= 0) or (standing2 and standing2 < 8 and standing2 ~= 0)) then
			addMsg(string.format(L["lootTheItem"], L["Qiraji Lord's Insignia"]) .. "!", 10);
		end
	elseif (remnantsBossesNoRecordEncounter[encounterID]) then
		addMsg(string.format(L["lootTheItem"], L["Remnants of Valor"]) .. "!", 10);
	end
end

local function combatLogEventUnfiltered(...)
	local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
			destName, destFlags, destRaidFlags, _, spellName = CombatLogGetCurrentEventInfo();
	if (subEvent == "UNIT_DIED" and NIT.inInstance and destGUID and string.match(destGUID, "Creature")) then
		local _, _, _, _, zoneID, npcID = strsplit("-", destGUID);
		npcID = tonumber(npcID);
		local _, instanceType, difficultyID, _, _, _, _, instanceID = GetInstanceInfo();
		if (turBosses[npcID] and not turBosses[npcID].encounterID) then
			if (dungeons[instanceID] and (not NIT.data.myChars[NIT.UnitName("player")].bossKills[npcID]
					or NIT.data.myChars[NIT.UnitName("player")].bossKills[npcID].resetTime < GetServerTime())) then
				if (not skipRealMsgIfCapped()) then
					addMsg(L["Loot the Tarnished Undermine Real"] .. "!", 10);
				end
				addBossDied(npcID);
				lastBossNpcID = npcID;
				lastBossTime = GetServerTime();
			end
		elseif (turBossesNoRecord[npcID] and turBossesNoRecord[npcID].instanceID == NIT.currentInstanceID) then
			if (not skipRealMsgIfCapped()) then
				addMsg(L["Loot the Tarnished Undermine Real"] .. "!", 10);
			end
		end
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("CHAT_MSG_LOOT");
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
f:RegisterEvent("LOOT_OPENED");
f:RegisterEvent("ENCOUNTER_END");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		combatLogEventUnfiltered(...);
	elseif (event == "CHAT_MSG_LOOT") then
		chatMsgLoot(...);
	elseif (event == "ENCOUNTER_END") then
		local encounterID, _, _, _, success = ...;
		if (success == 1) then
			lastEncounterID = encounterID;
			encounterEndSuccess(encounterID);
		end
	elseif (event == "LOOT_OPENED") then
		lootOpened();
	end
end)

function NIT:loadLootReminderListFrame()
	if (not lootReminderListFrame) then
		local frame = CreateFrame("Frame", "NITLootReminderListFrame", UIParent, "BackdropTemplate");
		frame.scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", frame, "UIPanelScrollFrameTemplate");
		--frame.scrollFrame:SetAllPoints();
		frame.scrollChild = CreateFrame("Frame", "$parentScrollChild", frame.scrollFrame);
		frame.scrollFrame:SetScrollChild(frame.scrollChild);
		--frame.scrollChild:SetWidth(frame:GetWidth() - 30);
		frame.scrollChild:SetAllPoints();
		frame.scrollChild:SetPoint("RIGHT", -40, 0);
		frame.scrollChild:SetPoint("TOP", 0, -20);
		frame.scrollChild:SetHeight(1);
		frame.scrollChild:SetScript("OnSizeChanged", function(self,event)
			frame.scrollChild:SetWidth(self:GetWidth())
		end)
		frame.scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -8);
		frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 8);
		
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 4, left = 4, bottom = 4, right = 4},
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tileEdge = true,
			edgeSize = 16,
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
		frame:SetBackdropBorderColor(1, 1, 1, 0.7);
		frame.scrollFrame.ScrollBar:ClearAllPoints();
		frame.scrollFrame.ScrollBar:SetPoint("TOPRIGHT", -5, -(frame.scrollFrame.ScrollBar.ScrollDownButton:GetHeight()) + 1);
		frame.scrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", -5, frame.scrollFrame.ScrollBar.ScrollUpButton:GetHeight());
		frame:SetToplevel(true);
		frame:SetMovable(true);
		frame:EnableMouse(true);
		frame:SetUserPlaced(false);
		frame:SetPoint("CENTER", UIParent, 0, 100);
		frame:SetSize(650, 725);
		frame:SetFrameStrata("HIGH");
		frame:SetFrameLevel(140);
		frame:SetScript("OnMouseDown", function(self, button)
			if (button == "LeftButton" and not self.isMoving) then
				self:StartMoving();
				self.isMoving = true;
			end
		end)
		frame:SetScript("OnMouseUp", function(self, button)
			if (button == "LeftButton" and self.isMoving) then
				self:StopMovingOrSizing();
				self.isMoving = false;
			end
		end)
		frame:SetScript("OnHide", function(self)
			if (self.isMoving) then
				self:StopMovingOrSizing();
				self.isMoving = false;
			end
		end)
		
		frame.scrollChild:SetScript("OnMouseDown", function(self, button)
			if (button == "LeftButton" and not frame.isMoving) then
				frame:StartMoving();
				frame.isMoving = true;
			end
		end)
		frame.scrollChild:SetScript("OnMouseUp", function(self, button)
			if (button == "LeftButton" and frame.isMoving) then
				frame:StopMovingOrSizing();
				frame.isMoving = false;
			end
		end)
		frame.scrollChild:SetScript("OnHide", function(self)
			if (frame.isMoving) then
				frame:StopMovingOrSizing();
				frame.isMoving = false;
			end
		end)
		
		frame.scrollChild:EnableMouse(true);
		--frame.scrollChild:SetHyperlinksEnabled(true);
		--frame.scrollChild:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow);
		--Set all fonts in the module using the frame.
		--Header string.
		frame.scrollChild.fs = frame.scrollChild:CreateFontString("NITLootReminderListFrameFS", "ARTWORK");
		frame.scrollChild.fs:SetPoint("TOP", 0, -5);
		--The main display string.
		frame.scrollChild.fs2 = frame.scrollChild:CreateFontString("NITLootReminderListFrameFS2", "ARTWORK");
		frame.scrollChild.fs2:SetPoint("TOPLEFT", 50, -30);
		frame.scrollChild.fs2:SetJustifyH("LEFT");
		frame.scrollChild.fs3 = frame.scrollChild:CreateFontString("NITLootReminderListFrameFS3", "ARTWORK");
		frame.scrollChild.fs3:SetPoint("TOPLEFT", 380, -30);
		frame.scrollChild.fs3:SetJustifyH("LEFT");
		--Bottom string.
		frame.scrollChild.fs4 = frame.scrollChild:CreateFontString("NITLootReminderListFrameFS4", "ARTWORK");
		frame.scrollChild.fs4:SetPoint("BOTTOM", 0, -20);
		--frame.scrollChild.fs3:SetFont(NIT.regionFont, 14);
		--Top right X close button.
		frame.close = CreateFrame("Button", "NITLootReminderListFrameClose", frame, "UIPanelCloseButton");
		frame.close:SetPoint("TOPRIGHT", -22, -4);
		frame.close:SetWidth(20);
		frame.close:SetHeight(20);
		frame.close:SetScript("OnClick", function(self, arg)
			frame:Hide();
		end)
		frame.close:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.close:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.close:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.close:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame:SetFrameStrata("HIGH");
		frame:SetClampedToScreen(true);
		frame.scrollChild.fs:SetFont(NIT.regionFont, 14);
		--frame.scrollChild.fs2:SetFontObject(Game15Font);
		frame.scrollChild.fs2:SetFont(NIT.regionFont, 13);
		frame.scrollChild.fs3:SetFont(NIT.regionFont, 13);
		--frame.scrollChild.fs:ClearAllPoints();
		--frame.scrollChild.fs2:ClearAllPoints();
		--frame.scrollChild.fs3:ClearAllPoints();
		--frame.scrollChild.fs:SetPoint("TOP", 0, -5);
		--frame.scrollChild.fs2:SetPoint("TOP", 0, -25);
		--[[frame.scrollChild.fs3:SetPoint("TOPLEFT", 10, -48);
		frame.scrollChild.fs3:SetPoint("RIGHT", 0, -48);
		frame.scrollChild.fs3:SetJustifyH("LEFT");
		frame.scrollChild.fs3:CanWordWrap(true);
		frame.scrollChild.fs3:CanNonSpaceWrap(true);
		frame.scrollChild.fs3:SetNonSpaceWrap(true);
		frame.scrollChild.fs3:SetWordWrap(true);]]
		frame:Hide();
		lootReminderListFrame = frame;
	end
	local totalDailyReals = getTotalDailyReals();
	local totalLootedToday = getTotalLootedToday();
	local totalLootedTodayString;
	if (totalLootedToday == 0) then
		totalLootedTodayString = "|cFFFF00000|r";
	elseif (totalLootedToday < totalDailyReals) then
		totalLootedTodayString = "|cFFFFFF00" .. totalLootedToday .. "|r";
	else
		totalLootedTodayString = "|cFF00FF00" .. totalLootedToday .. "|r";
	end
	local totalDaily = "  |cFF9CD6DE(" .. L["Total today"] .. ": " .. totalLootedTodayString .. " / |cFF00FF00" .. totalDailyReals .. "|r)|r";
	lootReminderListFrame.scrollChild.fs:SetText(NIT.prefixColor.. "NIT Loot Reminder Daily List|r\n|cFF1EFF00[" .. L["Tarnished Undermine Real"] .. "]|r " .. totalDaily);
	local text = "\n\n";
	local count ,instanceCount = 0, 0;
	local dungs = {};
	for k, v in pairs(dungeons) do
		local t = v;
		t.instanceID = k;
		tinsert(dungs, t);
	end
	table.sort(dungs, function(a, b) return a.order < b.order end);
	for id, instanceData in ipairs(dungs) do
		count = count + 1;
		instanceCount = instanceCount + 1;
		if (count == 1) then
			text = text .. "|cFFFFFF00" .. instanceData.name .. "|r";
		else
			text = text .. "\n\n|cFFFFFF00" .. instanceData.name .. "|r";
		end
		text = text .. " |cFF9CD6DE(" .. L["Total Reals"] .. ": |cFF00FF00" .. getTotalRealsPerDungeon(instanceData.instanceID) .. "|r)|r";
		count = count + 1;
		local sorted = {};
		local lootedCount = 0;
		for k, v in pairs(turBosses) do
			if (v.instanceID == instanceData.instanceID) then
				local t = {
					npcID = k,
					name = v.name,
					order = v.order,
					instanceID = v.instanceID,
					header = v.header,
					title = v.title,
					reals = v.reals,
					sharedNPCs = v.sharedNPCs,
				};
				tinsert(sorted, t);
			end
		end
		--[[for k, v in pairs(turBosses) do
			if (v.instanceID == instanceData.instanceID) then
				local t = {
					npcID = k,
					name = v.name,
					order = v.order,
					instanceID = v.instanceID,
					header = v.header,
					title = v.title,
					reals = v.reals,
					sharedNPCs = v.sharedNPCs,
				};
				tinsert(sorted, t);
			end
		end]]
		
		
		local toRemove, hasLooted = {}, {}; --Remove shared bosses from table so we only display one, but prio looted names so if looted it displays the lotted one.
		for i = #sorted, 1, -1 do
			local data = sorted[i];
			if (data.sharedNPCs) then
				local looted, isKilledButNotLooted = getLootedStatus(data.npcID, 226404);
				--If looted remove all other shared npcs from sorted.
				if (looted or isKilledButNotLooted) then
					for k, v in pairs(data.sharedNPCs) do
						toRemove[v] = true;
					end
					--Make sure this looted npc isn't removed if checked earlier in the loop/
					toRemove[data.npcID] = false;
					hasLooted[data.npcID] = true;
				else
					--If not looted we end up just leaving 1 of the shared npcs to display.
					local found;
					--[[for k, v in pairs(data.sharedNPCs) do
						if (not hasLooted[v]) then
							toRemove[v] = true;
						end
						--Check if any other bosses are already added, if not then add one per share.
						--if ()
					end]]
					for k, v in pairs(data.sharedNPCs) do
						if (hasLooted[v] or toRemove[v]) then
							found = true;
						end
						--Check if any other bosses are already added, if not then add one per share.
						--if ()
					end
					if (found) then
						--print(1, data.name)
						toRemove[data.npcID] = true;
					end
				end
			end
		end
		for npcID, _ in pairs(toRemove) do
			for i = #sorted, 1, -1 do
				local v = sorted[i];
				if (v.npcID == npcID) then
					table.remove(sorted, i);
				end
			end
		end
		
		
		table.sort(sorted, function(a, b) return a.order < b.order end);
		--[[local temp = {};
		for k, v in ipairs(sorted) do
			count = count + 1;
			if (v.header) then
				local headerString = "|cFF9CD6DE[" .. v.title  .. "]|r";
				if (count == 1) then
					text = text .. headerString;
				else
					text = text .. "\n" .. headerString;
				end
			else
				local looted, isKilledButNotLooted = getLootedStatus(v.npcID, 226404);
				local lootedString;
				if (isKilledButNotLooted) then
					lootedString = "|cFFFF6900(" .. L["Killed But Not Looted"] .. ")|r";
				elseif (looted) then
					lootedString = "|cFF00FF00(" .. L["Looted"] .. ")|r";
					lootedCount = lootedCount + 1;
				else
					lootedString = "|cFFFF0000(" .. L["Not Killed"] .. ")|r";
				end
				local extraInfoString = "";
				if (v.reals) then
					extraInfoString = " |cFF9CD6DE(x" .. v.reals .. ")|r"
				end
				if (count == 1) then
					text = text .. "|cFFFFAE42".. v.name .. "|r  " .. lootedString .. extraInfoString;
				else
					text = text .. "\n|cFFFFAE42" .. v.name .. "|r  " .. lootedString .. extraInfoString;
				end
				tinsert(temp, text)
			end
		end]]
		for k, v in ipairs(sorted) do
			count = count + 1;
			if (v.header) then
				local headerString = "|cFF9CD6DE[" .. v.title  .. "]|r";
				if (count == 1) then
					text = text .. headerString;
				else
					text = text .. "\n" .. headerString;
				end
			else
				local looted, isKilledButNotLooted = getLootedStatus(v.npcID, 226404);
				local lootedString;
				if (isKilledButNotLooted) then
					lootedString = "|cFFFF6900(" .. L["Killed But Not Looted"] .. ")|r";
				elseif (looted) then
					lootedString = "|cFF00FF00(" .. L["Looted"] .. ")|r";
					lootedCount = lootedCount + 1;
				else
					lootedString = "|cFFFF0000(" .. L["Not Killed"] .. ")|r";
				end
				local extraInfoString = "";
				if (v.reals) then
					extraInfoString = " |cFF9CD6DE(x" .. v.reals .. ")|r"
				end
				if (count == 1) then
					text = text .. "|cFFFFAE42".. v.name .. "|r  " .. lootedString .. extraInfoString;
				else
					text = text .. "\n|cFFFFAE42" .. v.name .. "|r  " .. lootedString .. extraInfoString;
				end
			end
		end
		if (instanceCount == 4) then
			lootReminderListFrame.scrollChild.fs2:SetText(text);
			text = "";
		elseif (instanceCount == 7) then
			lootReminderListFrame.scrollChild.fs3:SetText(text);
		end
	end
	--newVersionFrame:SetSize(600, 50 + newVersionFrame.scrollChild.fs:GetStringHeight() + newVersionFrame.scrollChild.fs2:GetStringHeight() + newVersionFrame.scrollChild.fs3:GetStringHeight());
	lootReminderListFrame:Show();
end

local function getTotalRemnants()
	local total = 0;
	for k, v in pairs(NIT.data.myChars) do
		if (v.trackedItems and v.trackedItems[236397]) then
			total = total + v.trackedItems[236397].count;
		end
	end
	return total;
end

local function getRemnantsData()
	local data = {};
	for k, v in pairs(NIT.data.myChars) do
		local t = {};
		if (v.trackedItems) then
			--Remnants of Valor.
			if (v.trackedItems[236397]) then
				t[236397] = v.trackedItems[236397];
			end
			--Heart of doom.
			if (v.trackedItems[236750]) then
				t[236750] = v.trackedItems[236750];
			end
		end
		for k, v in pairs(v.quests) do
			if (k == "Laid to Rest") then
				t.questCompleted = true;
			end
		end
		local buffLevels;
		if (next(t)) then
			--Just testing atm.
			buffLevels = {
				["Damage"] = 1.25,
			};
		end
		if (buffLevels and k ~= "Warspikez") then
			t.buffLevels = buffLevels;
		end
		if (next(t)) then
			t.name = k;
			t.class = v.classEnglish;
			t.realm = v.realm;
			tinsert(data, t);
		end
	end
	return data;
end

function NIT:loadRemnantsFrame()
	if (not lootReminderListFrame) then
		local frame = CreateFrame("Frame", "NITRemantsFrame", UIParent, "BackdropTemplate");
		frame.scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", frame, "UIPanelScrollFrameTemplate");
		--frame.scrollFrame:SetAllPoints();
		frame.scrollChild = CreateFrame("Frame", "$parentScrollChild", frame.scrollFrame);
		frame.scrollFrame:SetScrollChild(frame.scrollChild);
		--frame.scrollChild:SetWidth(frame:GetWidth() - 30);
		frame.scrollChild:SetAllPoints();
		frame.scrollChild:SetPoint("RIGHT", -40, 0);
		frame.scrollChild:SetPoint("TOP", 0, -20);
		frame.scrollChild:SetHeight(1);
		frame.scrollChild:SetScript("OnSizeChanged", function(self,event)
			frame.scrollChild:SetWidth(self:GetWidth())
		end)
		frame.scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -8);
		frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 8);
		
		frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			insets = {top = 4, left = 4, bottom = 4, right = 4},
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tileEdge = true,
			edgeSize = 16,
		});
		frame:SetBackdropColor(0, 0, 0, 0.9);
		frame:SetBackdropBorderColor(1, 1, 1, 0.7);
		frame.scrollFrame.ScrollBar:ClearAllPoints();
		frame.scrollFrame.ScrollBar:SetPoint("TOPRIGHT", -5, -(frame.scrollFrame.ScrollBar.ScrollDownButton:GetHeight()) + 1);
		frame.scrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", -5, frame.scrollFrame.ScrollBar.ScrollUpButton:GetHeight());
		frame:SetToplevel(true);
		frame:SetMovable(true);
		frame:EnableMouse(true);
		frame:SetUserPlaced(false);
		frame:SetPoint("CENTER", UIParent, 0, 100);
		frame:SetSize(550, 550);
		frame:SetFrameStrata("HIGH");
		frame:SetFrameLevel(140);
		frame:SetScript("OnMouseDown", function(self, button)
			if (button == "LeftButton" and not self.isMoving) then
				self:StartMoving();
				self.isMoving = true;
			end
		end)
		frame:SetScript("OnMouseUp", function(self, button)
			if (button == "LeftButton" and self.isMoving) then
				self:StopMovingOrSizing();
				self.isMoving = false;
			end
		end)
		frame:SetScript("OnHide", function(self)
			if (self.isMoving) then
				self:StopMovingOrSizing();
				self.isMoving = false;
			end
		end)
		
		frame.scrollChild:SetScript("OnMouseDown", function(self, button)
			if (button == "LeftButton" and not frame.isMoving) then
				frame:StartMoving();
				frame.isMoving = true;
			end
		end)
		frame.scrollChild:SetScript("OnMouseUp", function(self, button)
			if (button == "LeftButton" and frame.isMoving) then
				frame:StopMovingOrSizing();
				frame.isMoving = false;
			end
		end)
		frame.scrollChild:SetScript("OnHide", function(self)
			if (frame.isMoving) then
				frame:StopMovingOrSizing();
				frame.isMoving = false;
			end
		end)
		
		frame.scrollChild:EnableMouse(true);
		--frame.scrollChild:SetHyperlinksEnabled(true);
		--frame.scrollChild:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow);
		--Set all fonts in the module using the frame.
		--Header string.
		frame.scrollChild.fs = frame.scrollChild:CreateFontString("NITRemnantsFrameFS", "ARTWORK");
		frame.scrollChild.fs:SetPoint("TOP", 0, -5);
		--The main display string.
		frame.scrollChild.fs2 = frame.scrollChild:CreateFontString("NITRemnantsFrameFS2", "ARTWORK");
		frame.scrollChild.fs2:SetPoint("TOPLEFT", 50, -30);
		frame.scrollChild.fs2:SetJustifyH("LEFT");
		--Top right X close button.
		frame.close = CreateFrame("Button", "NITRemnantsFrameClose", frame, "UIPanelCloseButton");
		frame.close:SetPoint("TOPRIGHT", -22, -4);
		frame.close:SetWidth(20);
		frame.close:SetHeight(20);
		frame.close:SetScript("OnClick", function(self, arg)
			frame:Hide();
		end)
		frame.close:GetNormalTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.close:GetHighlightTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.close:GetPushedTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame.close:GetDisabledTexture():SetTexCoord(0.1875, 0.8125, 0.1875, 0.8125);
		frame:SetFrameStrata("HIGH");
		frame:SetClampedToScreen(true);
		frame.scrollChild.fs:SetFont(NIT.regionFont, 14);
		frame.scrollChild.fs2:SetFont(NIT.regionFont, 14);
		frame:Hide();
		remnantsFrame = frame;
	end
	local totalRemnants = getTotalRemnants();
	remnantsFrame.scrollChild.fs:SetText(NIT.prefixColor.. "NIT Naxxramas Seal of Dawn Tracker|r\n|cFFa335ee[" .. L["Remnants of Valor"] .. "]|r |cFF1EFF00Total: " .. totalRemnants .. "|r");
	local text = "|cFF9CD6DE\n";
	local data = getRemnantsData();
	if (next(data)) then
		table.sort(data, function(a, b) return a.name < b.name end);
	end
	for k, v in ipairs(data) do
		local _, _, _, classColorHex = GetClassColor(v.class);
		text = text .. "\n\n|c" .. classColorHex .. v.name .. "|r";
		if (v.buffLevels) then
			local buffText = " - Seal of the Dawn levels:";
			for k, v in NIT:pairsByKeys(v.buffLevels) do
				buffText = buffText .. " (" .. k .. " " .. v .. "%)";
			end
			text = text .. buffText .. "";
		end
		if (v[236397]) then
			text = text .. "\n    |cFFa335ee[" .. L["Remnants of Valor"] .. "]|r |cFF1EFF00x" .. v[236397].count .. "|r";
		end
		if (v.questCompleted) then
			text = text .. "\n    |cFFFFFFFFWeekly quest |cFFFFFF00[" .. L["Laid to Rest"] .. "]|r completed.|r";
		elseif (v[236750]) then
			text = text .. "\n    |cFFa335ee[" .. L["Heart of Doom"] .. "]|r |cffff0000still in bags not handed in.|r";
		end
	end
	remnantsFrame.scrollChild.fs2:SetText(text);
	--newVersionFrame:SetSize(600, 50 + newVersionFrame.scrollChild.fs:GetStringHeight() + newVersionFrame.scrollChild.fs2:GetStringHeight() + newVersionFrame.scrollChild.fs3:GetStringHeight());
	remnantsFrame:Show();
end
end
FT.embedded.NovaInstanceTracker:Add("NovaInstanceTracker", Component, "NovaInstanceTracker/Modules/LootReminder.lua")
