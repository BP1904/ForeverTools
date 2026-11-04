-- Local Attune adaptation; original copyright retained. See NOTICE.txt.
local _, FT = ...
local function Component(...)
-------------------------------------------------------------------------
--
--	Copyright (c) 2019-2021 by Antoine Desmarets.
--	Cixi Delmont/Gaya Greyhoof of Wow Forever Horde
--
--	FTAttune is distributed in the hope that it will be useful/entertaining
--	but WITHOUT ANY WARRANTY. Use at your own risk.
--
-------------------------------------------------------------------------

-- 16001-34
--   - Added the Bear Form quest for Skyborne elves.
--
-- 16001-33
--   - Added a new option to change the size of the treeview text.
--   - Fixed an issue where completed steps would not show right away.
--   - Fixed a number of icons that were misleading
--   - Fixed an issue where zoomed chains would overlap text.
--   - Added the Upper Blackrock Spire attunement.
--   - Added the Lower Blackrock Spire attunement.
--
-- 16001-32
--   - The attunements and dungeons are now shown as icons (Change back in the options or the toggle above the list).
--   - Completed chains are now moved to a Completed section (Change back in the options).
--   - The Results tab has been changed to allow sorting on class and level, and can now scroll horizontally
--   - Class quest categories are listed above dungeon quests.
--   - The selection pane can be resized to show more or less icons.
--   - The selected attunement is saved on a per-character basis.
--
-- 16001-31
--   - Added a toggle above the attunement list to switch between the list and icons.
--   - Added the Scarlet Key.
--   - Added the Tome of Dalaran.
--   - Added the Scarlet Key quests.
--   - Added the Dalaran Sewer Key quest for Alliance.
--   - Fixed missing quests in Horde Paladin class quests.
--   - Warrior class quests added.
--   - Shaman class quests added.
--
-- 16001-30
--   - Priest class quests added.
--   - Rogue class quests added.
--   - Paladin class quests added.
-- 
-- 16001-29
--   - Mage class quests added.
--   - Warlock class quests added.
--
-- 16001-28
--   - Scholomance quests added.
--   - Stratholme quests added.
--   - Hunter class quests added.
--
-- 16001-27
--   - Added the Dalaran Sewer Key (Horde)
--   - Added Blackrock Depths quests
--   - Started on Class Quests. Druid class quests added.
--   - Fixed issues with displaying counts
--   - Menu categories now clickable to expand/collapse
--   - Menu expand/collapse state is kept across reloads
--   - Option to display class quests of all classes 
--
-- 16001-26
--   - Fixed an issue with displaying City of Dalaran
--   - Added the Dire Maul quests
--  
-- 16001-25
--   - Added City of Dalaran quests
--   - Added Lazy Sleeping Bag quests
--
-- 16001-24
--   - Added Excavation Site: Wetlands quests
--   - Fixed an issue where FTAttune was interfering with the treeview in other addons
--
-- 16001-23
--   - Added Placeholders for upcoming dungeons
--   - Changed step colors for quests and items: yellow if you have the quest or some of the required items, green is you have all the required items or have completed the quest, grey otherwise
--   - Added Zul'Farrak quests
--   - Added The Temple of Atal'Hakkar quests
--   - if you are not at the minimum level for a quest, the quest level text will show in red
--
-- 16001-22
--   - Added option to use full map in quest details
--   - Added missing Wailing Caverns quests for Alliance
--   - Added dungeon art as background
--   - Added level range for dungeons
--
-- 16001-21
--   - Click a quest to list its reward items and map of the quest giver. Click it again to go back to the treeview
--   - FTAttune now uses the Forever frame
--
-- 16001-20
--   - Added quest giver in tooltip and map display
--   - Changed default to not announce completion in guild chat
--
-- 16001-19
--  Updated dungeons up to Maraudon
--



-------------------------------------------------------------------------
-- ADDON VARIABLES
-------------------------------------------------------------------------

local addonName, addon = ...

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetNumAddOns = C_AddOns.GetNumAddOns or GetNumAddOns
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded or IsAddOnLoaded;
local IsAddOnLoadOnDemand = C_AddOns.IsAddOnLoadOnDemand or IsAddOnLoadOnDemand;
local GetAddOnInfo = C_AddOns.GetAddOnInfo or GetAddOnInfo
local GetAddOnDependencies = C_AddOns.GetAddOnDependencies or GetAddOnDependencies
-- C_Item.GetItemCount ignores a string id and returns 0, so "4770" never matches the belt in the bag.
local function GetItemCount(itemId, includeBank, includeUses, includeReagentBank)
	local raw = (C_Item and C_Item.GetItemCount) or _G.GetItemCount
	if not raw then return 0 end
	local id = tonumber(itemId)
	if not id then return 0 end
	local ok, count = pcall(raw, id, includeBank, includeUses, includeReagentBank)
	if not ok or type(count) ~= "number" then return 0 end
	return count
end
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo

-- Forever / Midnight use C_Reputation; Classic still has GetFactionInfoByID.
local function FTAttune_GetFactionInfoByID(factionID)
	factionID = tonumber(factionID)
	if not factionID then return nil end
	if C_Reputation and C_Reputation.GetFactionDataByID then
		local data = C_Reputation.GetFactionDataByID(factionID)
		if not data then return nil end
		-- Match legacy GetFactionInfoByID return positions used by this addon (name @1, earned @6).
		return data.name, data.description, data.reaction, data.currentReactionThreshold, data.nextReactionThreshold, data.currentStanding
	end
	if GetFactionInfoByID then
		return GetFactionInfoByID(factionID)
	end
end

-- Midnight (12.0+) and Forever/Camelot (1.60.x / Interface 16001) forbid CLEU registration.
local attunelocal_interfaceVersion = select(4, GetBuildInfo())
local attunelocal_hasCombatLog = not (
	attunelocal_interfaceVersion >= 120000
	or (attunelocal_interfaceVersion >= 16000 and attunelocal_interfaceVersion < 20000)
)

FTAttune = LibStub("AceAddon-3.0"):NewAddon("FTAttune", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0")
FTAttune_Data = {};							-- Attunements / steps / tooltips

FTAttuneLang = LibStub("AceLocale-3.0"):GetLocale("FTAttune")

local AceGUI = LibStub("AceGUI-3.0")

-- Declared here so the layout and style functions below close over them.
-- A local's scope starts on the next line, so these cannot live further down.
local attunelocal_treeMinWidth = 130
local attunelocal_treeMaxWidth = 370
local attunelocal_treeDefaultWidth = 265

-- Current clients collapse a frame that is anchored to opposite edges and also
-- given an explicit size. AceGUI does both. Fix that on FTAttune's own widgets
-- only; Libs stays untouched and other addons keep stock AceGUI.
local function FTAttune_InstallLayoutFix(widget)
	if widget == nil or widget.attuneLayoutFixed then return end
	local kind = widget.type
	if kind == "Frame" then
		widget.OnWidthSet = function(self, width)
			local content = self.content
			local contentwidth = content:GetWidth()
			if not contentwidth or contentwidth <= 0 then
				contentwidth = width - 34
			end
			if contentwidth < 0 then contentwidth = 0 end
			content.width = contentwidth
		end
		widget.OnHeightSet = function(self, height)
			local content = self.content
			local contentheight = content:GetHeight()
			if not contentheight or contentheight <= 0 then
				contentheight = height - 57
			end
			if contentheight < 0 then contentheight = 0 end
			content.height = contentheight
		end
	elseif kind == "SimpleGroup" then
		widget.OnWidthSet = function(self, width)
			self.content.width = width
		end
		widget.OnHeightSet = function(self, height)
			self.content.height = height
		end
	elseif kind == "TreeGroup" then
		widget.OnWidthSet = function(self, width)
			local content = self.content
			local treeframe = self.treeframe
			local status = self.status or self.localstatus
			status.fullwidth = width

			local contentwidth = width - status.treewidth - 20
			if contentwidth < 0 then contentwidth = 0 end
			content.width = contentwidth

			local maxtreewidth = math.min(attunelocal_treeMaxWidth, width - 50)
			local mintreewidth = attunelocal_treeMinWidth
			-- Icon grid needs two icons. A configured min below that still has to fit them.
			if FTAttune_MinTreeWidth then mintreewidth = math.max(mintreewidth, FTAttune_MinTreeWidth()) end
			if maxtreewidth < mintreewidth then maxtreewidth = mintreewidth end
			if status.treewidth < mintreewidth then
				self:SetTreeWidth(mintreewidth, true)
			elseif maxtreewidth > mintreewidth and status.treewidth > maxtreewidth then
				self:SetTreeWidth(maxtreewidth, status.treesizable)
			end
			if treeframe.SetResizeBounds then
				treeframe:SetResizeBounds(mintreewidth, 1, maxtreewidth, 1600)
			else
				treeframe:SetMinResize(mintreewidth, 1)
				treeframe:SetMaxResize(maxtreewidth, 1600)
			end
		end
		widget.OnHeightSet = function(self, height)
			local contentheight = height - 20
			if contentheight < 0 then contentheight = 0 end
			self.content.height = contentheight
		end
	else
		return
	end
	widget.attuneLayoutFixed = true
end

-- Same as AceGUI's Fill, but the child is anchored before it is sized so the
-- explicit size matches the anchors instead of cutting the pane in half.
AceGUI:RegisterLayout("FTAttuneFill", function(content, children)
	local child = children[1]
	if not child then return end
	local frame = child.frame
	local w = content:GetWidth() or 0
	local h = content:GetHeight() or 0
	frame:ClearAllPoints()
	frame:SetAllPoints(content)
	frame:Show()
	if w > 0 then frame:SetWidth(w) end
	if h > 0 then frame:SetHeight(h) end
	if child.OnWidthSet then child:OnWidthSet(w) end
	if child.OnHeightSet then child:OnHeightSet(h) end
	local layoutHeight = h > 0 and h or frame:GetHeight()
	if content.obj and content.obj.LayoutFinished then
		pcall(content.obj.LayoutFinished, content.obj, nil, layoutHeight)
	end
end)

local function FTAttune_AceCreate(widgetType, ...)
	local base = AceGUI.WidgetBase
	local origWidth, origHeight = base.SetWidth, base.SetHeight
	base.SetWidth = function(self, width)
		FTAttune_InstallLayoutFix(self)
		return origWidth(self, width)
	end
	base.SetHeight = function(self, height)
		FTAttune_InstallLayoutFix(self)
		return origHeight(self, height)
	end
	local ok, widget = pcall(AceGUI.Create, AceGUI, widgetType)
	base.SetWidth, base.SetHeight = origWidth, origHeight
	if not ok then error(widget, 0) end
	-- TreeGroup does not size itself inside OnAcquire, so install after Create as well.
	FTAttune_InstallLayoutFix(widget)
	return widget
end

-- Clicking a category name toggles it the same way the +/- button does.
-- Leaf rows keep AceGUI's select-on-click behavior.
local function FTAttune_HookTreeButton(button)
	if button.attuneClickHooked then return end
	button.attuneClickHooked = true
	local originalOnClick = button:GetScript("OnClick")
	button:SetScript("OnClick", function(frame, mouseButton)
		local line = frame.treeline
		if line and line.hasChildren then
			local self = frame.obj
			local status = (self.status or self.localstatus).groups
			status[frame.uniquevalue] = not status[frame.uniquevalue]
			self:RefreshTree()
			AceGUI:ClearFocus()
			FTAttune_SaveTreeExpandStatus()
			return
		end
		if originalOnClick then
			originalOnClick(frame, mouseButton)
		end
	end)

	-- +/- uses its own click handler, and a double-click toggles as well.
	if button.toggle and not button.toggle.attuneClickHooked then
		button.toggle.attuneClickHooked = true
		local originalToggle = button.toggle:GetScript("OnClick")
		button.toggle:SetScript("OnClick", function(frame, mouseButton)
			if originalToggle then
				originalToggle(frame, mouseButton)
			end
			FTAttune_SaveTreeExpandStatus()
		end)
	end
	local originalDouble = button:GetScript("OnDoubleClick")
	button:SetScript("OnDoubleClick", function(frame, mouseButton)
		if originalDouble then
			originalDouble(frame, mouseButton)
		end
		local line = frame.treeline
		if line and line.hasChildren then
			FTAttune_SaveTreeExpandStatus()
		end
	end)
end

-- Style FTAttune's own TreeGroup only (never patch shared AceGUI:Create).
local function FTAttune_StyleTreeGroup(widget)
	if widget.treeframe then
		widget.treeframe:SetBackdropColor(0, 0, 0, 0.5)
	end
	if widget.border then
		widget.border:SetBackdropColor(0, 0, 0, 0.5)
	end
	-- Second argument keeps the drag handle enabled. AceGUI treats a missing flag as fixed width.
	local minTree = attunelocal_treeMinWidth
	if FTAttune_MinTreeWidth then minTree = math.max(minTree, FTAttune_MinTreeWidth()) end
	local treeWidth = attunelocal_treeDefaultWidth
	if FTAttune_DB and FTAttune_DB.treeWidth and FTAttune_DB.treeWidth >= minTree and FTAttune_DB.treeWidth <= attunelocal_treeMaxWidth then
		treeWidth = FTAttune_DB.treeWidth
	end
	widget:SetTreeWidth(treeWidth, true)

	-- The right pane is anchored to the list and to the window. On current
	-- clients that mixed anchor makes StartSizing ignore the separator until
	-- the window itself is moved or resized. Keep both of the pane's points
	-- on the tree widget, and follow the list width while it is dragged.
	local function syncBorder()
		local border = widget.border
		local treeframe = widget.treeframe
		local parent = widget.frame
		if not border or not treeframe or not parent then return end
		if border.attuneSyncing then return end
		local width = treeframe:GetWidth() or 0
		if width < 1 then return end
		if border.attuneTreeWidth and math.abs(border.attuneTreeWidth - width) < 0.1 then return end
		border.attuneSyncing = true
		border.attuneTreeWidth = width
		border:ClearAllPoints()
		border:SetPoint("TOPLEFT", parent, "TOPLEFT", width, 0)
		border:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
		border.attuneSyncing = false
	end
	if widget.treeframe and not widget.treeframe.attuneBorderSynced then
		widget.treeframe.attuneBorderSynced = true
		widget.treeframe:HookScript("OnSizeChanged", syncBorder)
	end
	if widget.dragger and not widget.dragger.attuneSizingHooked then
		widget.dragger.attuneSizingHooked = true
		-- Same click must unlock sizing. A later hook would run after StartSizing.
		-- Moving the window once is what the client needs before a child StartSizing works.
		widget.dragger:SetScript("OnMouseDown", function(frame)
			local treeframe = frame:GetParent()
			if not treeframe then return end
			if not frame.attuneSizingReady then
				frame.attuneSizingReady = true
				pcall(function()
					local host = treeframe
					while host and host ~= UIParent and not host:IsMovable() do
						host = host:GetParent()
					end
					if host and host ~= treeframe and host ~= UIParent and host:IsMovable() then
						host:StartMoving()
						host:StopMovingOrSizing()
					end
				end)
			end
			syncBorder()
			treeframe:StartSizing("RIGHT")
		end)
		widget.dragger:HookScript("OnMouseUp", syncBorder)
	end
	syncBorder()

	local createButton = widget.CreateButton
	widget.CreateButton = function(self, ...)
		local button = createButton(self, ...)
		FTAttune_HookTreeButton(button)
		return button
	end
	for _, button in ipairs(widget.buttons or {}) do
		FTAttune_HookTreeButton(button)
	end
end

-- AceGUI reserves 16px for a 14px icon, so the name sits on the icon.
-- List size also grows the font, icon, and row. The tree still measures rows as 18px,
-- so RefreshTree reports a shorter frame and then these metrics are applied.
-- Globals: the main chunk is already at Lua's 200-local limit.
function FTAttune_TreeRowMetrics()
	local scale = FTAttune_DB and FTAttune_DB.treeScale
	if scale == "large" then return 24, 20, 2 end
	if scale == "larger" then return 30, 24, 4 end
	return 18, 14, 0
end

function FTAttune_TreeFont(kind, base, extra)
	if not FTAttune_TreeFontCache then FTAttune_TreeFontCache = {} end
	local key = kind .. extra
	local font = FTAttune_TreeFontCache[key]
	if not font then
		font = CreateFont("FTAttuneTreeFont" .. key)
		FTAttune_TreeFontCache[key] = font
	end
	font:CopyFontObject(base)
	local path, size, flags = base:GetFont()
	if path then font:SetFont(path, (size or 12) + extra, flags or "") end
	return font
end

function FTAttune_ApplyTreeListMetrics(widget)
	local buttons = widget.buttons
	if not buttons then return end
	local row, iconSize, extra = FTAttune_TreeRowMetrics()
	for i = 1, #buttons do
		local button = buttons[i]
		if button:IsShown() then
			button:SetHeight(row)
			local text = button.text
			local icon = button.icon
			local level = button.level or 1
			if button.toggle then button.toggle:SetSize(iconSize, iconSize) end
			if text then
				text:SetHeight(row - 4)
				text:SetWordWrap(false)
				if text.SetMaxLines then text:SetMaxLines(1) end
				if extra > 0 then
					local normal, highlight
					if level == 1 then
						normal = FTAttune_TreeFont("Normal", GameFontNormal, extra)
						highlight = FTAttune_TreeFont("Highlight", GameFontHighlight, extra)
					else
						normal = FTAttune_TreeFont("Small", GameFontHighlightSmall, extra)
						highlight = normal
					end
					button:SetNormalFontObject(normal)
					button:SetHighlightFontObject(highlight)
				end
			end
			if icon and text and icon:GetTexture() then
				icon:ClearAllPoints()
				icon:SetSize(iconSize, iconSize)
				icon:SetPoint("LEFT", button, "LEFT", 8 * level, (level == 1) and 0 or 1)
				local iconDy = (level == 1) and 0 or 1
				local right = -8
				if extra > 0 and button.toggle and button.toggle:IsShown() then
					right = -(iconSize + 10)
				end
				text:ClearAllPoints()
				text:SetPoint("LEFT", icon, "RIGHT", 4, 2 - iconDy)
				text:SetPoint("RIGHT", button, "RIGHT", right, 2)
			elseif text and extra > 0 then
				local left = (level == 1) and 8 or (8 * level)
				local right = -8
				if button.toggle and button.toggle:IsShown() then
					right = -(iconSize + 10)
				end
				text:ClearAllPoints()
				text:SetPoint("LEFT", button, "LEFT", left, 2)
				text:SetPoint("RIGHT", button, "RIGHT", right, 2)
			end
			if extra > 0 then
				local hl = button:GetHighlightTexture()
				if hl then
					hl:ClearAllPoints()
					hl:SetAllPoints(button)
				end
			end
		end
	end
end

local _G = getfenv(1)

local attunelocal_ldb = LibStub("LibDataBroker-1.1")
local FTAttune_Broker = nil
local attunelocal_minimapicon = LibStub("LibDBIcon-1.0")
local attunelocal_brokervalue = nil
local attunelocal_brokerlabel = nil
local attunelocal_settingsCategoryID = nil

local attunelocal_version = "16001-34"
local attunelocal_prefix = "Attune_Channel"			-- used for addon chat communications
local attunelocal_versionprefix = "Attune_Version"	-- used for addon version check
local attunelocal_syncprefix = "Attune_Sync"		-- used for addon version check
local attunelocal_detectedNewer = false;			-- flag to only warn about new version once per session

-- Defaults for Node size
local attunelocal_Node_Width = 170
local attunelocal_Node_Height = 48
local attunelocal_Node_HGap = 10

-- HALFSIZE steps occupy half a column (layout slot and drawn width).
local function FTAttune_NodeWidth(step)
	if step and step.HALFSIZE then
		return (attunelocal_Node_Width - attunelocal_Node_HGap) / 2
	end
	return attunelocal_Node_Width
end

local attunelocal_Node_VGap = 30
local attunelocal_Icon_Size = 32
local attunelocal_Line_Thickness = 6
local attunelocal_Side_Pad = 10			-- padding inside the Inside-quests box
local attunelocal_Side_VGap = 8			-- vertical gap between stacked Inside quests
local attunelocal_Side_BoxGap = 28		-- horizontal gap between box edge and End (for side connector)

-- Graph zoom (SetScale on the chain container)
local attunelocal_Zoom_Min = 0.5
local attunelocal_Zoom_Max = 1.0
local attunelocal_Zoom_Step = 0.01

-- Frame variables
local attunelocal_frame						-- main frame
local attunelocal_tree = {}					-- tree data (nodes and leaves)
local attunelocal_treeframe					-- Ace TreeGroup object for attune tab
-- attunelocal_iconView is global: the main chunk is already at Lua's 200-local limit.
local attunelocal_guildframe				-- Ace SimpleGroup object for result tab
local attunelocal_treeIsShown = false		-- indicates whether we're on the tree view or result view
local attunelocal_right						-- right panel of the TreeGroup object
local attunelocal_scroll					-- scroller inside of the TreeGroup right panel
local attunelocal_dungeonArt				-- loading-screen art behind the dungeon view
local attunelocal_gscroll					-- scroller inside the SimpleGroup of the result tab
local attunelocal_glist						-- individual rows of data inside the result tab
local attunelocal_export_frame				-- export submenu frame
local attunelocal_survey_frame				-- survey submenu frame
local attunelocal_resultselection = 1 		-- indicates whether to show last survey results(0) or guild results(1) or all(2)
local attunelocal_exportselection = 0 		-- indicates what dataset to export 0:me, 1:last survey, 2:guild, 3:all, 4:all my alts
local attunelocal_gflabel					-- table header (used to update the number of characters in list)
local attunelocal_showResultAttunes = true 	-- profiles UI disabled; keep true to always show attune results
local attunelocal_graphRoot					-- container for attune chain nodes (scaled for zoom)
local attunelocal_graphHeight = 0			-- unscaled chain height (for live zoom scroll updates)
local attunelocal_contentHeight = 50		-- scroll content height accounting for zoom
local attunelocal_graphHeaderOffset = 10    -- px below AceGUI title/desc, in scroll-content space
local attunelocal_zoomSlider				-- fixed overlay zoom slider (not inside scroll)
local attunelocal_graphPanX = 0				-- horizontal pan, in scroll-content pixels
local attunelocal_graphMaxExtent = 0		-- unscaled half-width of widest stage
local attunelocal_graphMaxPanX = 0			-- max |panX| allowed at current zoom/view
local attunelocal_graphDragging = false		-- true while click-dragging the chain
local attunelocal_graphDragLastX = 0
local attunelocal_graphDragLastY = 0
local attunelocal_graphPanHooked = false	-- Shift+wheel hook installed on scrollframe
local attunelocal_wipFrame					-- centered "work in progress" overlay for empty trees

--local attunelocal_repWidget					-- Reputation Widget frame
--local attunelocal_repWidget_frames = {} 	-- list of non-Ace frames for the rep widget (to reuse them later)

local attunelocal_syncProgressWidget		-- Sync Progress Widget
local attunelocal_syncProgressStatusBar		-- actual progress bar
local attunelocal_syncProgress_frames = {} 	-- list of non-Ace frames for the sync progess widget (to reuse them later)
local attunelocal_syncStartTime = nil		-- to calculate sync duration
local attunelocal_syncAmountToReceive = 0	-- Total amount we're due to receive
local attunelocal_syncAmountReceived = 0	-- amount we've received so far
local attunelocal_syncAmountToSend = 0		-- Total amount we're due to send
local attunelocal_syncAmountSent = 0		-- amount we've sent so far
local attunelocal_syncChunksSent = 0		-- chunks sent so far

local attunelocal_frames = {} 				-- list of non-Ace frames (to reuse them later)
local attunelocal_initial = true			-- first run

local attunelocal_myguild = ""				-- Guild of the current character
-- local attunelocal_realm = GetRealmName()	-- Realm of the current character

local guildToonMap = {}						-- matching guild to toon

local attunelocal_data = {}					-- data being exported to website
local attunelocal_count = 0					-- count of toons being exported

local attunelocal_myFirst = "FirstName"
local attunelocal_myLast = "LastName"
local attunelocal_myFullName = attunelocal_myFirst .. " " .. attunelocal_myLast
local attunelocal_charKey = attunelocal_myFullName --.. "-" .. attunelocal_realm			-- Character unique name
local attunelocal_statusText = FTAttuneLang["Version"]:gsub("##VERSION##", attunelocal_version)		-- Default status text

local attunelocal_refreshDone = false		-- flag to indicate when the UI refresh has been done, to avoid doing it too many times and freezing UI)

local attunelocal_syncTarget = nil
local attunelocal_syncStatus = -1

--[=[ Raid Planner locals disabled for now
local attunelocal_raidframe						-- main frame
local attunelocal_raidtree = {}					-- tree data (nodes and leaves)
local attunelocal_raidtreeframe					-- Ace TreeGroup object for attune tab
local attunelocal_raidscroll					-- scroller inside of the raid
local attunelocal_raidroster					-- scroller inside the raid SimpleGroup of the result tab
--local attunelocal_raidtoonIcon = {}				-- Icon object of the toon list
local attunelocal_raidspotIcon = {}				-- Icon object of the raid spots
]=]
local attunelocal_faction = ""
--[=[ Raid Planner locals disabled for now
local attunelocal_raidname = ""					-- selected Raid name
local attunelocal_raidsize = 0					-- selected Raid size
local attunelocal_raidcount = 1  				-- selected raid, number of raid groups to show
]=]

local attunelocal_inactivity = 60*60*24*30		-- number of seconds to account for inactivity

--local attunelocal_achieveDelayDone = false		-- Wait a few seconds to avoid the barrage of achieves when one first logs in

local patch = 0

-- This is to work around the fact that xpcall is quite costly and drops framerate when spammed for lots of little events
-- Thanks @RoadBlock for this
-- On Forever/Midnight, CLEU is forbidden; PARTY_KILL / UNIT_DIED replace kill detection.
local cleu_parser = CreateFrame("Frame")
cleu_parser.OnEvent = function(frame, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		FTAttune.COMBAT_LOG_EVENT_UNFILTERED(FTAttune, event, ...)
	elseif event == "PARTY_KILL" then
		FTAttune:PARTY_KILL(...)
	elseif event == "UNIT_DIED" then
		FTAttune:UNIT_DIED_KILL(...)
	end
end
cleu_parser:SetScript("OnEvent", cleu_parser.OnEvent)
-- End of xpcall workaround


local IsQuestFlaggedCompleted = _G.IsQuestFlaggedCompleted or C_QuestLog.IsQuestFlaggedCompleted  -- This is to handle the changes in TBC (C_QuestLog)


local attune_options = {
    name = "FTAttune",
    handler = FTAttune,
    type = "group",
	childGroups = "tab",
    args = {
        tab1 = {
            type = "group",
            name = FTAttuneLang["Settings"],
			width = "full",
			order = 1,
			args = {

				spacer1 = {
					type = "description",
					name = " ",
					width = "full",
					order = 2,
				},
				showMinimapButton = {
					type = "toggle",
					name = FTAttuneLang["MinimapButton_TEXT"],
					desc = FTAttuneLang["MinimapButton_DESC"],
					get = function(info) return not FTAttune_DB.minimapbuttonpos.hide end,
					set = function(info, val)
							if val then attunelocal_minimapicon:Show("FTAttune_Broker") else attunelocal_minimapicon:Hide("FTAttune_Broker") end
							FTAttune_DB.minimapbuttonpos.hide = not val
						end,
					width = 2.5,
					order = 5,
				},
				useFullMap = {
					type = "toggle",
					name = FTAttuneLang["FullMap_TEXT"],
					desc = FTAttuneLang["FullMap_DESC"],
					get = function(info) return FTAttune_DB.useFullMap end,
					set = function(info, val)
						FTAttune_DB.useFullMap = val
						if FTAttune_RefreshQuestMapMode then FTAttune_RefreshQuestMapMode() end
					end,
					width = 1.65,
					order = 6,
				},
				showAllClassQuests = {
					type = "toggle",
					name = FTAttuneLang["ShowAllClassQuests_TEXT"],
					desc = FTAttuneLang["ShowAllClassQuests_DESC"],
					get = function(info) return FTAttune_DB.showAllClassQuests end,
					set = function(info, val)
						FTAttune_DB.showAllClassQuests = val
						FTAttune_ReloadAttuneTree()
					end,
					width = 1.65,
					order = 7,
				},
				treeScale = {
					type = "select",
					name = FTAttuneLang["TreeScale_TEXT"],
					desc = FTAttuneLang["TreeScale_DESC"],
					values = {
						normal = FTAttuneLang["TreeScale_Normal"],
						large = FTAttuneLang["TreeScale_Large"],
						larger = FTAttuneLang["TreeScale_Larger"],
					},
					sorting = { "normal", "large", "larger" },
					get = function() return FTAttune_DB.treeScale or "normal" end,
					set = function(info, val)
						FTAttune_DB.treeScale = val
						local tree = attunelocal_treeframe
						if tree and tree.RefreshTree and attunelocal_treeIsShown and not FTAttune_DB.iconView then
							tree:RefreshTree()
						end
					end,
					width = 1.65,
					order = 8,
				},                
				iconView = {
					type = "toggle",
					name = FTAttuneLang["IconView_TEXT"],
					desc = FTAttuneLang["IconView_DESC"],
					get = function(info) return FTAttune_DB.iconView end,
					set = function(info, val)
						FTAttune_SetIconView(val)
					end,
					width = 1.65,
					order = 8.5,
				},
				archiveCompleted = {
					type = "toggle",
					name = FTAttuneLang["ArchiveCompleted_TEXT"],
					desc = FTAttuneLang["ArchiveCompleted_DESC"],
					get = function(info) return FTAttune_DB.archiveCompleted end,
					set = function(info, val)
						FTAttune_DB.archiveCompleted = val
						FTAttune_ReloadAttuneTree()
					end,
					width = 1.65,
					order = 9,
				},
				autosurvey = {
					type = "toggle",
					name = FTAttuneLang["AutoSurvey_TEXT"],
					desc = FTAttuneLang["AutoSurvey_DESC"],
					get = function(info) return FTAttune_DB.autosurvey end,
					set = function(info, val) FTAttune_DB.autosurvey = val end,
					width = 2.5,
					order = 10,
				},                
				showSurveyed = {
					type = "toggle",
					name = FTAttuneLang["ShowSurveyed_TEXT"],
					desc = FTAttuneLang["ShowSurveyed_DESC"],
					get = function(info) return FTAttune_DB.showSurveyed end,
					set = function(info, val) FTAttune_DB.showSurveyed = val end,
					width = 1.65,
					order = 15,
				},
				showResponses = {
					type = "toggle",
					name = FTAttuneLang["ShowResponses_TEXT"],
					desc = FTAttuneLang["ShowResponses_DESC"],
					get = function(info) return FTAttune_DB.showResponses end,
					set = function(info, val) FTAttune_DB.showResponses = val end,
					width = 1.65,
					order = 16,
				},
				showStepReached = {
					type = "toggle",
					name = FTAttuneLang["ShowSetMessages_TEXT"],
					desc = FTAttuneLang["ShowSetMessages_DESC"],
					get = function(info) return FTAttune_DB.showStepReached end,
					set = function(info, val) FTAttune_DB.showStepReached = val end,
					width = 1.65,
					order = 17,
				},
				announceAttuneCompleted = {
					type = "toggle",
					name = FTAttuneLang["AnnounceToGuild_TEXT"],
					desc = FTAttuneLang["AnnounceToGuild_DESC"],
					get = function(info) return FTAttune_DB.announceAttuneCompleted end,
					set = function(info, val) FTAttune_DB.announceAttuneCompleted = val end,
					width = 1.65,
					order = 18,
				},
				showOtherChat = {
					type = "toggle",
					name = FTAttuneLang["ShowOther_TEXT"],
					desc = FTAttuneLang["ShowOther_DESC"],
					get = function(info) return FTAttune_DB.showOtherChat end,
					set = function(info, val) FTAttune_DB.showOtherChat = val end,
					width = 1.65,
					order = 19,
				},
--[[				announceAchieveCompleted = {
					type = "toggle",
					name = FTAttuneLang["AnnounceAchieve_TEXT"],
					desc = FTAttuneLang["AnnounceAchieve_DESC"],
					get = function(info) return FTAttune_DB.toons[attunelocal_charKey].announceAchieveCompleted end,
					set = function(info, val) FTAttune_DB.toons[attunelocal_charKey].announceAchieveCompleted = val end,
					width = 2.6,
					order = 20,
				},				
				achieveMinPoints = {
					type = "select",
					name = "",
					desc = "",
					values = {	
						[10] = "10 Points", 
						[20] = "20 Points",
						[25] = "25 Points",
						[30] = "30 Points",
						[40] = "40 Points",
						[50] = "50 Points",
						[60] = "60 Points",
						[70] = "70 Points",
						[80] = "80 Points",
						[90] = "90 Points",
						[100] = "100 Points",
					},
					get = function(info) return FTAttune_DB.toons[attunelocal_charKey].achieveMinPoints end,
					set = function(info, val) FTAttune_DB.toons[attunelocal_charKey].achieveMinPoints = val end,
					width = 0.7,
					order = 21,
				},
]]--
				showList = {
					type = "toggle",
					name = FTAttuneLang["ShowGuildies_TEXT"],
					desc = FTAttuneLang["ShowGuildies_DESC"],
					get = function(info) return FTAttune_DB.showList end,
					set = function(info, val) FTAttune_DB.showList = val end,
					width = 2.8,
					order = 23,
				},
				maxListSize = {
					type = "input",
					name = "",
					desc = "",
					get = function(info) return FTAttune_DB.maxListSize end,
					set = function(info, val) FTAttune_DB.maxListSize = val end,
					width = 0.5,
					order = 24,
				},
				-- showListAlt = {
				-- 	type = "toggle",
				-- 	name = FTAttuneLang["ShowAltsInstead_TEXT"],
				-- 	desc = FTAttuneLang["ShowAltsInstead_DESC"],
				-- 	get = function(info) return FTAttune_DB.showListAlt end,
				-- 	set = function(info, val) FTAttune_DB.showListAlt = val end,
				-- 	width = 2.5,
				-- 	order = 26,
				-- },
				-- showDeprecatedAttunes = {
				-- 	type = "toggle",
				-- 	name = FTAttuneLang["showDeprecatedAttunes_TEXT"],
				-- 	desc = FTAttuneLang["showDeprecatedAttunes_DESC"],
				-- 	get = function(info) return FTAttune_DB.showDeprecatedAttunes end,
				-- 	set = function(info, val) FTAttune_DB.showDeprecatedAttunes = val; 	FTAttune_LoadTree(); 	FTAttune_ForceAttuneTabRefresh() end,
				-- 	width = 2.5,
				-- 	order = 27,
				-- },
				websiteUrl = {
					type = "input",
					name = "Database Website URL",
					desc = "URL of a World of Warcraft database website",
					get = function(info) return FTAttune_DB.websiteUrl end,
					set = function(info, val) FTAttune_DB.websiteUrl = val end,
					width = "full",
					order = 28,
				},
				spacer3 = {
					type = "description",
					name = " ",
					width = "full",
					order = 30,
				},
				spacer4 = {
					type = "description",
					name = " ",
					width = "full",
					order = 40,
				},
				deleteAll = {
					type = "execute",
					name = FTAttuneLang["ClearAll_TEXT"],
					desc = FTAttuneLang["ClearAll_DESC"],
					confirm = true,
					confirmText = FTAttuneLang["ClearAll_CONF"],
					func = function(info, val)
						for kt, t in pairs(FTAttune_DB.toons) do
							if kt ~= attunelocal_charKey then
								FTAttune_DB.toons[kt] = nil
							end
						end
						if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["ClearAll_TEXT"]) end
					end,
					width = 1.6,
					order = 32,
				},
				deleteGuild = {
					type = "execute",
					name = FTAttuneLang["DelNonGuildies_TEXT"],
					desc = FTAttuneLang["DelNonGuildies_DESC"],
					confirm = true,
					confirmText = FTAttuneLang["DelNonGuildies_CONF"],
					func = function(info, val)
						for kt, t in pairs(FTAttune_DB.toons) do
							if kt ~= attunelocal_charKey then
								if t.guild ~= nil then
									if t.guild ~= attunelocal_myguild then
										FTAttune_DB.toons[kt] = nil
									end
								end
							end
						end
						if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["DelNonGuildies_DONE"]) end
					end,
					width = 1.6,
					order = 33,
				},

	--[[
				spacer5 = {
					type = "description",
					name = " ",
					width = "full",
					order = 40,
				},
	]]

				credits = {
					type = "description",
					name = FTAttuneLang["Credits"],
					width = "full",
					fontSize = "medium",
					order = 45,
				},
  --[[				showWidget = {
					type = "toggle",
					name = "Show Reputation Widget",
					desc = "Displays a reputation tracking window, allowing you to check your attunement reputation gains and progress.",
					get = function(info) return FTAttune_DB.repWidget.showWidget end,
					set = function(info, val) FTAttune_DB.repWidget.showWidget = val;
						if attunelocal_repWidget ~= nil then
							if val then attunelocal_repWidget:Show()
							else attunelocal_repWidget:Hide()
							end
						end
					end,
					width = 1.7,
					order = 41,
				},
				lockWidget = {
					type = "toggle",
					name = "Lock Reputation Widget",
					desc = "Lock the reputation widget in place, preventing its movement and hiding usage information.",
					get = function(info) return FTAttune_DB.repWidget.lockWidget end,
					set = function(info, val) FTAttune_DB.repWidget.lockWidget = val
						if attunelocal_repWidget ~= nil then
							print("in")
							if val then
								attunelocal_repWidget:SetMovable(false)
								print("NOT movable")
							else
								attunelocal_repWidget:SetMovable(true)
								print("movable")
							end
						end
					end,
					width = 1.7,
					order = 42,
				},
  ]]
			},
		},

        tab2 = {
            type = "group",
            name = FTAttuneLang["Survey Log"],
			width = "full",
			order = 100,
			args = {
				logs = {
					type = "description",
					name = "",
					width = "full",
					order = 110,
				},
			},
		},
	},
}

-------------------------------------------------------------------------
-- EVENT: Addon is Initialized
-------------------------------------------------------------------------

function FTAttune:FTRegisterOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("FTAttune", attune_options, nil)
	-- Second return is the Settings category ID (numeric on modern clients).
	local _, categoryID = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FTAttune")
	attunelocal_settingsCategoryID = categoryID
end

-------------------------------------------------------------------------
-- EVENT: Addon is enabled
-------------------------------------------------------------------------

function FTAttune:FTStart()
	-- Called when the addon is enabled
	-- Class quests are already merged; index them before any completion event.
	FTAttune_BuildStepIndex()
	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_prefix)
	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_versionprefix)
    --	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_syncprefix)


	FTAttune:RegisterComm(attunelocal_syncprefix)

	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_REMOVED")
	self:RegisterEvent("QUEST_TURNED_IN")
	self:RegisterEvent("UPDATE_FACTION")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
--	self:RegisterEvent("ACHIEVEMENT_EARNED")

    attunelocal_myFirst, attunelocal_myLast = UnitName("player")
    attunelocal_myFullName = attunelocal_myFirst .. " " .. attunelocal_myLast
    attunelocal_charKey = attunelocal_myFullName --.. "-" .. attunelocal_realm			-- Character unique name
    
	--self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	if attunelocal_hasCombatLog then
		cleu_parser:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		-- Forever / Midnight: CLEU registration is ADDON_ACTION_FORBIDDEN
		cleu_parser:RegisterEvent("PARTY_KILL")
		cleu_parser:RegisterEvent("UNIT_DIED")
	end

	_, _, _, patch	 = GetBuildInfo()
	
	if FTAttune_DB == nil then FTAttune_DB = {} end
	if FTAttune_DB.width == nil then FTAttune_DB.width = 1200 end
	if FTAttune_DB.height == nil then FTAttune_DB.height = 720 end
	if FTAttune_DB.zoom == nil then FTAttune_DB.zoom = 1.0 end	-- proportional scale of the attune chain (0.5–1.0)
	if FTAttune_DB.zoom < attunelocal_Zoom_Min then FTAttune_DB.zoom = attunelocal_Zoom_Min end
	if FTAttune_DB.zoom > attunelocal_Zoom_Max then FTAttune_DB.zoom = attunelocal_Zoom_Max end
	if FTAttune_DB.toons == nil then FTAttune_DB.toons = {} end
	if FTAttune_DB.toons[attunelocal_charKey] == nil then FTAttune_DB.toons[attunelocal_charKey] = {} end
	if FTAttune_DB.survey == nil then FTAttune_DB.survey = {} end
	if FTAttune_DB.sortresult == nil then FTAttune_DB.sortresult = { 0, true } end -- sort order for the result tab (attune, asc/desc)  (0 for name)
	if FTAttune_DB.showList == nil then FTAttune_DB.showList = true end
	if FTAttune_DB.showListAlt == nil then FTAttune_DB.showListAlt = false end
	if FTAttune_DB.showSurveyed == nil then FTAttune_DB.showSurveyed = false end
	if FTAttune_DB.showResponses == nil then FTAttune_DB.showResponses = true end
	if FTAttune_DB.showStepReached == nil then FTAttune_DB.showStepReached = true end
	if FTAttune_DB.announceAttuneCompleted == nil then FTAttune_DB.announceAttuneCompleted = false end
	if FTAttune_DB.showDeprecatedAttunes == nil then FTAttune_DB.showDeprecatedAttunes = true end
		
	
--[[	--convert global setting to a per toon setting
	local oldAnnounceAchieveCompleted = true
	if FTAttune_DB.announceAchieveCompleted ~= nil then oldAnnounceAchieveCompleted = FTAttune_DB.announceAchieveCompleted;  end --get previous setting
	if FTAttune_DB.toons[attunelocal_charKey].announceAchieveCompleted == nil then FTAttune_DB.toons[attunelocal_charKey].announceAchieveCompleted = oldAnnounceAchieveCompleted end

	local oldAchieveMinPoints = 20
	if FTAttune_DB.achieveMinPoints ~= nil then oldAchieveMinPoints = FTAttune_DB.achieveMinPoints  end  --get previous setting
	if FTAttune_DB.toons[attunelocal_charKey].achieveMinPoints == nil then FTAttune_DB.toons[attunelocal_charKey].achieveMinPoints = oldAchieveMinPoints end

	local oldAnnounceAchieveSurvey = false
	if FTAttune_DB.announceAchieveSurvey ~= nil then oldAnnounceAchieveSurvey = FTAttune_DB.announceAchieveSurvey  end  --get previous setting
	if FTAttune_DB.toons[attunelocal_charKey].announceAchieveSurvey == nil then FTAttune_DB.toons[attunelocal_charKey].announceAchieveSurvey = oldAnnounceAchieveSurvey end
]]
	
	if FTAttune_DB.showOtherChat == nil then FTAttune_DB.showOtherChat = true end
	if FTAttune_DB.maxListSize == nil then FTAttune_DB.maxListSize = "20" end
	if FTAttune_DB.logs == nil then FTAttune_DB.logs = {} end
	if FTAttune_DB.minimapbuttonpos == nil then FTAttune_DB.minimapbuttonpos = {} end
	if FTAttune_DB.minimapbuttonpos.hide == nil then FTAttune_DB.minimapbuttonpos.hide = true end
	if FTAttune_DB.autosurvey == nil then FTAttune_DB.autosurvey = false end
	if FTAttune_DB.useFullMap == nil then FTAttune_DB.useFullMap = false end
	if FTAttune_DB.showAllClassQuests == nil then FTAttune_DB.showAllClassQuests = false end
	if FTAttune_DB.iconView == nil then FTAttune_DB.iconView = true end
	if FTAttune_DB.treeScale ~= "large" and FTAttune_DB.treeScale ~= "larger" then FTAttune_DB.treeScale = "normal" end
	if FTAttune_DB.archiveCompleted == nil then FTAttune_DB.archiveCompleted = true end
	if FTAttune_DB.websiteUrl == nil then FTAttune_DB.websiteUrl = "https://wowhead.com/forever" end
	if FTAttuneTreeExpandStatus == nil then FTAttuneTreeExpandStatus = {} end
	
	

	--[=[ Raid planner disabled for now
	--raid planner
	if FTAttune_DB.raidShowMains == nil then FTAttune_DB.raidShowMains = true end
	if FTAttune_DB.raidShowAlts == nil then FTAttune_DB.raidShowAlts = false end
	if FTAttune_DB.raidShowUnattuned == nil then FTAttune_DB.raidShowUnattuned = false end
	if FTAttune_DB.raidShowUnspecified == nil then FTAttune_DB.raidShowUnspecified = false end
	if FTAttune_DB.raidGuildOnly == nil then FTAttune_DB.raidGuildOnly = true end
	
	if FTAttune_DB.raidPlans == nil then FTAttune_DB.raidPlans = {} end
	if FTAttune_DB.raidNames == nil then FTAttune_DB.raidNames = {} end
	attunelocal_faction = UnitFactionGroup("player")
	if FTAttune_DB.raidPlans[attunelocal_faction] == nil then FTAttune_DB.raidPlans[attunelocal_faction] = {} end
	if FTAttune_DB.raidNames[attunelocal_faction] == nil then FTAttune_DB.raidNames[attunelocal_faction] = {} end
	if FTAttune_DB.raidSelection == nil then FTAttune_DB.raidSelection = {} end
	if FTAttune_DB.raidSelection[attunelocal_faction] == nil then FTAttune_DB.raidSelection[attunelocal_faction] = 115 end
	]=]
	attunelocal_faction = UnitFactionGroup("player")
	--[[	local gameLocale = GetLocale()
		if gameLocale == "enGB" then
			gameLocale = "enUS"
		end
		if FTAttune_DB.preferredLocale == nil then FTAttune_DB.preferredLocale = gameLocale end
	
	if (FTAttune_DB.repWidget == nil) then FTAttune_DB.repWidget = {}; end
	if (FTAttune_DB.repWidget.showWidget == nil) then FTAttune_DB.repWidget.showWidget = false; end
	if (FTAttune_DB.repWidget.lockWidget == nil) then FTAttune_DB.repWidget.lockWidget = false; end
	if (FTAttune_DB.repWidget.showInRaid == nil) then FTAttune_DB.repWidget.showInRaid = true; end
	if (FTAttune_DB.repWidget.showInDungeon == nil) then FTAttune_DB.repWidget.showInDungeon = true; end
	if (FTAttune_DB.repWidget.showInWorld == nil) then FTAttune_DB.repWidget.showInWorld = true; end
	if (FTAttune_DB.repWidget.showInBg == nil) then FTAttune_DB.repWidget.showInBg = true; end
	if (FTAttune_DB.repWidget.point == nil) then FTAttune_DB.repWidget.point = nil; end
]]

	if FTAttune_DB.showOtherChat then DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[FTAttune]|r "..FTAttuneLang["Splash"]:gsub("##VERSION##", attunelocal_version)) end


	-- add new fields to toons data
	for kt, t in pairs(FTAttune_DB.toons) do
		if t.status == nil then t.status = "None" end
		if t.role == nil then t.role = "None" end
		if t.survey == nil then t.survey = 0 end
		if t.guild == nil then t.guild = "" end
		if t.class == nil then t.class = "UNKNOWN" end
		if t.attuned == nil then t.attuned = {} end
		if t.done == nil then t.done = {} end
		for i, a in pairs(FTAttune_Data.noattunes) do
			--mark as automatically attuned for those raids that do not require attunement
			if t.attuned[a.ID] == nil then t.attuned[a.ID] = 100 end
		end
		for i, a in pairs(FTAttune_Data.attunes) do
			if t.attuned[a.ID] == nil then t.attuned[a.ID] = 0 end
		end


--[[	-- NOW REMOVED as it was clearing alt status

		-- tentative fix for SSC
		-- attune was granted on error (picking up quest instead of turning in)
		t.attuned["120"] = 0		-- removing completion status
		t.done["120-60"] = nil		-- removing kill and item
		t.done["120-70"] = nil		-- removing kill and item
		t.done["120-80"] = nil		-- removing kill and item
		t.done["120-90"] = nil		-- removing kill and item
		t.done["120-110"] = nil		-- removing 'end' step
		t.done["120-100"] = nil		-- removing bad step (mark of vashj)
		t.done["120-95"] = nil		-- removing quest turn in step  --  this should re-complete itself automatically if the player has done it
]]
	end 

	FTAttune_UpdateLogs()

	FTAttune_CheckProgress() -- get your own standing
	FTAttune:BAG_UPDATE(nil)


	-- calculate how many steps this toon has done on the attune
	local attuneDone = {}
	local t = FTAttune_DB.toons[attunelocal_charKey]
	FTAttune_AutoCompleteSpacers(attunelocal_charKey)
	local spacerDone = {}
	for _, s in pairs(FTAttune_Data.steps) do
		if s.TYPE == "Spacer" then spacerDone[s.ID_ATTUNE .. "-" .. s.ID] = true end
	end
	local attuneSteps = {}
	for i, s in pairs(FTAttune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE ~= "Spacer" then
				if attuneSteps[s.ID_ATTUNE] == nil then attuneSteps[s.ID_ATTUNE] = 0 end
				attuneSteps[s.ID_ATTUNE] = attuneSteps[s.ID_ATTUNE] +1
			end
		end
	end
	for i, d in pairs(t.done) do
		if not spacerDone[i] then
			local Ids = FTAttune_split(i, "-")
			if attuneDone[Ids[1]] == nil then attuneDone[Ids[1]] = 0 end
			attuneDone[Ids[1]] = attuneDone[Ids[1]] +1
		end
	end
	if t.attuned == nil then t.attuned = {} end
	for i, a in pairs(FTAttune_Data.attunes) do
		if attuneDone[a.ID] == nil then attuneDone[a.ID] = 0 end
		if (attuneSteps[a.ID] or 0) > 0 then
			t.attuned[a.ID] = math.floor(100*(attuneDone[a.ID]/attuneSteps[a.ID]))
		else
			t.attuned[a.ID] = 0
		end

	end
	-- End step done means fully attuned (Kill/Interact may lag behind in the done map)
	FTAttune_ApplyCompletedEndSteps(t)
	-- No saved selection yet: open on the first attunement this character has not finished.
	FTAttune_EnsureDefaultView()



	-- sending a couple version checks to make sure people update to the latest version
	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then
		C_Timer.After(11, function()
			if attunelocal_myguild ~= "" then FTAttune:SendCommMessage(attunelocal_versionprefix, attunelocal_version, "GUILD", ""); end
		end)
	end

--[[	C_Timer.After(15, function()
		attunelocal_achieveDelayDone = true -- after 10s the spam should have been done
	end)
]]
	-- sending a couple version checks to make sure people update to the latest version

	if FTAttune_DB.autosurvey then
		C_Timer.After(13, function()
			if attunelocal_myguild ~= "" then 
				if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["StartAutoGuildSurvey"]) end
				FTAttune:SendCommMessage(attunelocal_prefix, "SILENTSURVEY", "GUILD", ""); 
			end
		end)
	end



	FTAttune_Broker = attunelocal_ldb:NewDataObject("FTAttune_Broker", {
		type = "data source",
		label = "FTAttune",
		text = "Click me!",
		icon = "Interface\\Icons\\inv_scroll_03",
		OnClick = function(self, button)
			if button=="LeftButton" then
				FTAttune_SlashCommandHandler("")
			elseif button=="RightButton" then
				if Settings and Settings.OpenToCategory and type(attunelocal_settingsCategoryID) == "number" then
					Settings.OpenToCategory(attunelocal_settingsCategoryID)
				elseif InterfaceOptionsFrame_OpenToCategory then
					InterfaceOptionsFrame_OpenToCategory("FTAttune")
					InterfaceOptionsFrame_OpenToCategory("FTAttune")
				else
					LibStub("AceConfigDialog-3.0"):Open("FTAttune")
				end
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine("|cFFffffffAttune v"..attunelocal_version.."|r")

			if 	attunelocal_brokerlabel ~= nil then
				tooltip:AddLine(" ")
				tooltip:AddLine("|cffffd100"..attunelocal_brokerlabel..":|r |cFFffffff"..attunelocal_brokervalue.."|r")
			end

			tooltip:AddLine(" ")
			tooltip:AddLine("|cffffd100"..FTAttuneLang["LeftClick"].."|r"..FTAttuneLang["OpenAttune"].."\n|cffffd100"..FTAttuneLang["RightClick"].."|r"..FTAttuneLang["OpenSettings"], 0.2, 1, 0.2)
		end,
	})





	local aid = nil
	-- Find the last selected attunement for this character
	local lastViewed = FTAttune_GetLastViewed()
	local st = lastViewed and string.find(lastViewed, "\001")

	if st ~= nil then -- not top level
		--get actual attune (remove expac/group)
		expac, group, sel = strsplit("\001", lastViewed);
		if sel ~= "" and sel ~= nil then
			aid = sel
		end
	end

	if aid ~= nil then
		for k, a in pairs(FTAttune_Data.attunes) do
			if a.ID == aid then
				attunelocal_brokerlabel = a.NAME
			end
		end
		if FTAttune_DB.toons[attunelocal_charKey].attuned[aid] ~= nil then
			attunelocal_brokervalue = FTAttune_DB.toons[attunelocal_charKey].attuned[aid].."%"
		else
			attunelocal_brokervalue = "0%"
		end
		FTAttune_Broker.text = attunelocal_brokervalue
	end


	attunelocal_minimapicon:Register("FTAttune_Broker", FTAttune_Broker, FTAttune_DB.minimapbuttonpos)
	if FTAttune_DB.minimapbuttonpos.hide then attunelocal_minimapicon:Hide("FTAttune_Broker"); attunelocal_minimapicon:Hide("FTAttune_Broker") else attunelocal_minimapicon:Show("FTAttune_Broker");attunelocal_minimapicon:Show("FTAttune_Broker") end


--[[
	C_Timer.After(10, function()
		if not FTAttune_DB.toons[attunelocal_charKey].announceAchieveSurvey then
			StaticPopupDialogs["ACHIEVEANNOUNCE_CONFIRM"] = {
				text = FTAttuneLang["\n"..FTAttuneLang["AchieveSurvey"]:gsub("##WHO##", attunelocal_myFullName).."\n\n"],
				button1 = FTAttuneLang["Yes"],
				button2 = FTAttuneLang["No"],
				timeout = 0,
				hasEditBox = false,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnAccept = function()
					FTAttune_DB.toons[attunelocal_charKey].announceAchieveSurvey = true
					FTAttune_DB.toons[attunelocal_charKey].announceAchieveCompleted = true
				end,
				OnCancel = function (_,reason)
					FTAttune_DB.toons[attunelocal_charKey].announceAchieveSurvey = true
					FTAttune_DB.toons[attunelocal_charKey].announceAchieveCompleted = false
				end,
			}
			StaticPopup_Show ("ACHIEVEANNOUNCE_CONFIRM")
		end
	end)
]]

	--FTAttune_CreateRepWidget()



	-- Remedy can be time consuming because of the recursive loop.
	-- Only perform when a new version of the addon is found
	local ind = 0
	if FTAttune_DB.version == nil or FTAttune_DB.version < attunelocal_version then 
		-- remedy IsNext
		for it, tt in pairs(FTAttune_DB.toons) do
			if tt.next ~= nil then 

				C_Timer.After(0.200*ind, function() --stagger those to not freeze
					--print("Checking "..it)
					for i, n in FTAttune_spairs(tt.next, function(t,a,b) 
							local aa = FTAttune_split(a, "-")
							local bb = FTAttune_split(b, "-")
							local aaa = aa[1]*1000 + aa[2]
							local bbb = bb[1]*1000 + bb[2]
							return (bbb < aaa) 
						end) do
						local ts = FTAttune_Data.stepsByKey and FTAttune_Data.stepsByKey[i]
						if ts and showPatchStep(ts) and ts.FOLLOWS ~= "0" then
							--this is where the remediation needs to happen
							FTAttune_remedyIsNext(it, ts.ID_ATTUNE, ts.FOLLOWS)
						end
					end
				end)
				ind = ind + 1
			end
		end
		FTAttune_DB.version = attunelocal_version
	end

end

-------------------------------------------------------------------------
-- Remedy IsNext (some interact / kill steps remain as IsNext)
-------------------------------------------------------------------------

function FTAttune_remedyIsNext(who, aID, follows)

	-- there can be multi-follows (for example FOLLOW=160|170)
	-- We need to recurse both paths
	local fIDs = FTAttune_split(follows, "&")
	if string.find(follows, "|") then fIDs = FTAttune_split(follows, "|") end

	for fi, f in pairs(fIDs) do
		local s = FTAttune_Data.stepsByKey and FTAttune_Data.stepsByKey[aID .. "-" .. f]
		if s and showPatchStep(s) then
			if string.find(follows, "|") == nil then -- don't recurse OR, as we don't know which parent was actually done
				if FTAttune_DB.toons[who].next[s.ID_ATTUNE .. "-" .. s.ID] == 1 then
--						print(who..": Removed "..s.ID_ATTUNE .. "-" .. s.ID)
					FTAttune_DB.toons[who].next[s.ID_ATTUNE .. "-" .. s.ID] = nil
				end
				if follows ~= 0 then -- no need to recurse first level
					FTAttune_remedyIsNext(who, s.ID_ATTUNE, s.FOLLOWS)
				end
			end
		end
	end

end


-------------------------------------------------------------------------
-- EVENT: Addon is disabled
-------------------------------------------------------------------------

function FTAttune:OnDisable()
	-- Called when the addon is disabled
	self:Print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Addon disabled"])
end


-------------------------------------------------------------------------
-- EVENT: Fired when an achievement is gained
-------------------------------------------------------------------------
--[[
function FTAttune:ACHIEVEMENT_EARNED(event, id)
	local FEAT_OF_STRENGTH_CATEGID = 81

	--send a guild message when an achievement is earned 
	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then attunelocal_myguild = guildName end

	local achieveId, achieveName, achievePoints = GetAchievementInfo(id)
	local categId = GetAchievementCategory(id)
	
	if 	(achievePoints >= FTAttune_DB.toons[attunelocal_charKey].achieveMinPoints or categId == FEAT_OF_STRENGTH_CATEGID)
		and FTAttune_DB.toons[attunelocal_charKey].announceAchieveCompleted
		and attunelocal_myguild ~= ""
		and attunelocal_achieveDelayDone then 

			local msg = "[FTAttune] "..FTAttuneLang["AchieveCompleteGuild"]:gsub("##LINK##", GetAchievementLink(id))
			if categId ~= FEAT_OF_STRENGTH_CATEGID then -- don't show points for FoS
				msg = msg .. " "..FTAttuneLang["AchieveCompletePoints"]:gsub("##POINTS##", GetTotalAchievementPoints())
			end
			SendChatMessage(msg , "GUILD")
	end
end
]]
-------------------------------------------------------------------------
-- EVENT: Addon Chat message is received
-------------------------------------------------------------------------

function FTAttune:CHAT_MSG_ADDON(event, arg1, arg2, arg3, arg4)

	--attune data channel
	if arg1 == attunelocal_prefix then
		if arg2 == 'SURVEY' or arg2 == 'SILENTSURVEY' then
			attunelocal_count = 0
			attunelocal_data = {}
			attunelocal_data['_faction'] = ""
			attunelocal_data['_realm'] = ""
			attunelocal_data['_guild'] = ""

			if arg2 == 'SURVEY' and arg4 ~= attunelocal_charKey then
				if FTAttune_DB.showSurveyed then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["SendingDataTo"]:gsub("##NAME##", FTAttune_split(arg4, "-")[1]))  end
			end

			-- log all surveys (silent or not) unless they were sent by us
			if arg4 ~= attunelocal_charKey then
				FTAttune_DB.logs[time()] = FTAttuneLang["ReceivedRequestFrom"]:gsub("##FROM##", arg4)
				FTAttune_UpdateLogs()
			end

			FTAttune_SendRequestResults(arg4)
		else
			FTAttune_HandleRequestResults(arg2)
		end
	end

	--version check channel
	if arg1 == attunelocal_versionprefix then
		if arg2 > attunelocal_version and not attunelocal_detectedNewer then
			attunelocal_detectedNewer = true
			if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["NewVersionAvailable"].." (v"..arg2..")") end -- 	ved check with a newer version, warn the user
		end
	end


end

-------------------------------------------------------------------------
-- EVENT: Detect a mob has been killed
-------------------------------------------------------------------------

local function FTAttune_NpcIdFromGUID(guid)
	-- Use == nil (not truthiness): secret strings error on string conversion.
	if guid == nil then return -1 end

	-- Forever/Midnight: PARTY_KILL / UNIT_DIED may pass secret GUIDs.
	-- strsplit/tostring on secrets errors under tainted execution.
	if issecretvalue and issecretvalue(guid) then
		-- UnitTokenFromGUID accepts secret GUIDs when tainted; UnitCreatureID
		-- returns a readable ID when unit identity is not restricted (e.g. open world).
		local unit = UnitTokenFromGUID and UnitTokenFromGUID(guid)
		if unit ~= nil and UnitCreatureID then
			local id = UnitCreatureID(unit)
			if id ~= nil then return id end
		end
		-- Some clients still resolve creature ID from a secret GUID.
		if C_CreatureInfo and C_CreatureInfo.GetCreatureID then
			local ok, id = pcall(C_CreatureInfo.GetCreatureID, guid)
			if ok and id ~= nil then return id end
		end
		return -1
	end

	if C_CreatureInfo and C_CreatureInfo.GetCreatureID then
		local id = C_CreatureInfo.GetCreatureID(guid)
		if id ~= nil then return id end
	end

	local _, _, _, _, _, npc_id = strsplit("-", guid)
	return tonumber(npc_id) or -1
end

-- Resolve the NPC being talked to without converting secret GUIDs to strings.
local function FTAttune_GetInteractNpcID()
	if UnitCreatureID then
		local id = UnitCreatureID("npc")
		if id == nil then id = UnitCreatureID("target") end
		if id ~= nil then return id end
	end

	local guid = UnitGUID("npc")
	if guid == nil then guid = UnitGUID("target") end
	if guid == nil then return -1 end
	return FTAttune_NpcIdFromGUID(guid)
end

-- One-time maps so completion events look up a quest, npc, or item
-- instead of walking every step and every attunement.
function FTAttune_BuildStepIndex()
	local attuneById = {}
	local attuneClass = {}
	for _, a in pairs(FTAttune_Data.attunes) do
		attuneById[a.ID] = a
		if a.CLASS ~= nil and a.CLASS ~= "" then
			attuneClass[a.ID] = a.CLASS
		end
	end
	FTAttune_Data.attuneById = attuneById
	FTAttune_Data.attuneClass = attuneClass

	local stepsByKey = {}
	local stepsByAttune = {}
	local stepsByType = {}
	local stepsByPickup = {}
	local stepsByTurnIn = {}
	local stepsByKill = {}
	local stepsByInteract = {}
	local stepsByItem = {}

	local function add(map, id, s)
		local list = map[id]
		if list == nil then
			list = {}
			map[id] = list
		end
		list[#list + 1] = s
	end

	local function addQuests(map, wowhead, s)
		if wowhead == nil or wowhead == "" or wowhead == "0" then return end
		wowhead = tostring(wowhead)
		local start = 1
		local bar = string.find(wowhead, "|", start, true)
		if bar == nil then
			local n = tonumber(wowhead)
			if n then add(map, n, s) end
			return
		end
		while bar do
			local n = tonumber(string.sub(wowhead, start, bar - 1))
			if n then add(map, n, s) end
			start = bar + 1
			bar = string.find(wowhead, "|", start, true)
		end
		local n = tonumber(string.sub(wowhead, start))
		if n then add(map, n, s) end
	end

	for _, s in pairs(FTAttune_Data.steps) do
		stepsByKey[s.ID_ATTUNE .. "-" .. s.ID] = s
		add(stepsByAttune, s.ID_ATTUNE, s)
		add(stepsByType, s.TYPE, s)
		if s.TYPE == "Pick Up" then
			addQuests(stepsByPickup, s.ID_WOWHEAD, s)
		elseif s.TYPE == "Quest" or s.TYPE == "Turn In" then
			addQuests(stepsByTurnIn, s.ID_WOWHEAD, s)
		elseif s.TYPE == "Kill" then
			add(stepsByKill, tostring(s.ID_WOWHEAD), s)
		elseif s.TYPE == "Interact" then
			add(stepsByInteract, tostring(s.ID_WOWHEAD), s)
		elseif s.TYPE == "Item" then
			add(stepsByItem, tostring(s.ID_WOWHEAD), s)
		end
	end

	FTAttune_Data.stepsByKey = stepsByKey
	FTAttune_Data.stepsByAttune = stepsByAttune
	FTAttune_Data.stepsByType = stepsByType
	FTAttune_Data.stepsByPickup = stepsByPickup
	FTAttune_Data.stepsByTurnIn = stepsByTurnIn
	FTAttune_Data.stepsByKill = stepsByKill
	FTAttune_Data.stepsByInteract = stepsByInteract
	FTAttune_Data.stepsByItem = stepsByItem
end

-- Class file for a class-quest chain (DRUID, MAGE, ...), or nil for a normal attunement.
local function FTAttune_AttuneClass(attuneId)
	local classes = FTAttune_Data.attuneClass
	if classes ~= nil then
		return classes[attuneId]
	end
	for _, a in pairs(FTAttune_Data.attunes) do
		if a.ID == attuneId then
			if a.CLASS ~= nil and a.CLASS ~= "" then return a.CLASS end
			return nil
		end
	end
	return nil
end

-- Class used when deciding whether this character may complete a class quest.
local function FTAttune_ProgressClass(t)
	if t ~= nil and attunelocal_charKey ~= nil and t == FTAttune_DB.toons[attunelocal_charKey] then
		local _, classFile = UnitClass("player")
		if classFile then return classFile end
	end
	if t ~= nil and t.class ~= nil and t.class ~= "" and t.class ~= "UNKNOWN" then
		return string.upper(t.class)
	end
	return nil
end

-- Normal attunements are always tracked. Class quests only for that class.
local function FTAttune_MayRecordAttuneProgress(t, attuneId)
	local required = FTAttune_AttuneClass(attuneId)
	if required == nil then return true end
	local classFile = FTAttune_ProgressClass(t)
	return classFile ~= nil and classFile == required
end

local function FTAttune_ClearAttuneProgress(att, attuneId)
	if att == nil or attuneId == nil then return end
	local prefix = tostring(attuneId) .. "-"
	local plen = #prefix
	if att.done then
		for key in pairs(att.done) do
			if type(key) == "string" and key:sub(1, plen) == prefix then
				att.done[key] = nil
			end
		end
	end
	if att.next then
		for key in pairs(att.next) do
			if type(key) == "string" and key:sub(1, plen) == prefix then
				att.next[key] = nil
			end
		end
	end
	if att.attuned then
		att.attuned[attuneId] = 0
	end
end

-- Predecessors done, so this Kill/Interact step is the current one.
local function FTAttune_StepIsNext(s)
	if s.FOLLOWS == nil or s.FOLLOWS == "0" then return true end
	local done = FTAttune_DB.toons[attunelocal_charKey].done
	local followOR = string.find(s.FOLLOWS, "|", 1, true) ~= nil
	local fIDs = FTAttune_split(s.FOLLOWS, followOR and "|" or "&")
	if followOR then
		for _, f in pairs(fIDs) do
			if done[s.ID_ATTUNE .. "-" .. f] then return true end
		end
		return false
	end
	for _, f in pairs(fIDs) do
		if done[s.ID_ATTUNE .. "-" .. f] == nil then return false end
	end
	return true
end

-- Mark one matching step, announce it, and optionally close out the attunement.
-- Returns true when this call newly completed the step.
local function FTAttune_MarkStepDone(s, typeLabel, stepLabel, checkComplete)
	local toon = FTAttune_DB.toons[attunelocal_charKey]
	local key = s.ID_ATTUNE .. "-" .. s.ID
	if toon.done[key] ~= nil then return false end

	local a = FTAttune_Data.attuneById and FTAttune_Data.attuneById[s.ID_ATTUNE]
	if a == nil then return false end
	if a.DEPRECATED ~= nil and not FTAttune_DB.showDeprecatedAttunes then return false end

	local faction = UnitFactionGroup("player")
	if not ((a.FACTION == faction or a.FACTION == "Both") and FTAttune_MayRecordAttuneProgress(toon, a.ID)) then
		return false
	end

	toon.done[key] = 1
	PlaySound(1210) --putdownring
	if FTAttune_DB.showStepReached then
		print("|cffff00ff[FTAttune]|r "..FTAttuneLang["CompletedStep"]:gsub("##TYPE##", typeLabel):gsub("##STEP##", stepLabel):gsub("##NAME##", a.NAME))
	end
	FTAttune_SendPushInfo("TOON")
	FTAttune_SendPushInfo(key)
	if checkComplete then
		FTAttune_CheckComplete(false)
		if toon.attuned[a.ID] >= 100 then
			PlaySound(5275) -- AuctionWindowClose
			if FTAttune_DB.showStepReached then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["FTAttuneComplete"]:gsub("##NAME##", a.NAME)) end
			if FTAttune_DB.announceAttuneCompleted and attunelocal_myguild ~= "" then SendChatMessage("[FTAttune] "..FTAttuneLang["FTAttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
		end
	end
	FTAttune_SendPushInfo("OVER")
	return true
end

local function FTAttune_ProcessKill(npc_id)
	if npc_id == nil or npc_id == -1 then return end
	local steps = FTAttune_Data.stepsByKill and FTAttune_Data.stepsByKill[tostring(npc_id)]
	if steps == nil then return end

	local refreshNeeded = false
	for _, s in ipairs(steps) do
		if showPatchStep(s) and FTAttune_StepIsNext(s) then
			if FTAttune_MarkStepDone(s, FTAttuneLang[s.TYPE], FTAttuneLang["N1_"..s.ID_WOWHEAD], true) then
				refreshNeeded = true
			end
		end
	end

	if refreshNeeded then FTAttune_ForceAttuneTabRefresh() end -- refresh view if needed
end

function FTAttune:COMBAT_LOG_EVENT_UNFILTERED(event, arg1, arg2, arg3, arg4)
	local param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16 = CombatLogGetCurrentEventInfo()

	--party kill is the better option as it knows your group did the kill (your tag), but doesn't work in raid.
	--for raids, use UNIT_DIED, as since it's a raid mob your group obviously had the tag
	if (param2 == "PARTY_KILL" and not IsInRaid()) or (param2 == "UNIT_DIED" and IsInRaid()) then
		FTAttune_ProcessKill(FTAttune_NpcIdFromGUID(param8))
	end
end

-- Forever / Midnight replacements for CLEU kill detection
function FTAttune:PARTY_KILL(attackerGUID, targetGUID)
	if IsInRaid() then return end
	FTAttune_ProcessKill(FTAttune_NpcIdFromGUID(targetGUID))
end

function FTAttune:UNIT_DIED_KILL(unitGUID)
	if not IsInRaid() then return end
	FTAttune_ProcessKill(FTAttune_NpcIdFromGUID(unitGUID))
end

-------------------------------------------------------------------------
-- EVENT: Detect a level up
-------------------------------------------------------------------------

function FTAttune:PLAYER_LEVEL_UP(event, arg1)

	local levels = FTAttune_Data.stepsByType and FTAttune_Data.stepsByType["Level"]
	if levels == nil then return end

	local refreshNeeded = false
	for _, s in ipairs(levels) do
		if showPatchStep(s) and arg1 >= tonumber(s.ID_WOWHEAD) then
			-- Level messages keep the raw type word used before this lookup.
			if FTAttune_MarkStepDone(s, s.TYPE, s.STEP, false) then
				refreshNeeded = true
			end
		end
	end

	if refreshNeeded then FTAttune_ForceAttuneTabRefresh() end -- refresh view if needed

end


-------------------------------------------------------------------------
-- EVENT: Quest accepted
-------------------------------------------------------------------------

-- Picking a quest up again means that turn-in is no longer done.
-- Returns true when a recorded turn-in was cleared.
function FTAttune_ClearTurnInOnAccept(questID)
	local toon = FTAttune_DB.toons[attunelocal_charKey]
	if toon == nil or toon.done == nil or questID == nil then return false end
	local list = FTAttune_Data.stepsByTurnIn and FTAttune_Data.stepsByTurnIn[questID]
	if list == nil then return false end

	local attunes = nil
	for _, s in ipairs(list) do
		if showPatchStep(s) then
			local key = s.ID_ATTUNE .. "-" .. s.ID
			if toon.done[key] then
				toon.done[key] = nil
				if attunes == nil then attunes = {} end
				attunes[s.ID_ATTUNE] = true
			end
		end
	end
	if attunes == nil then return false end

	local ends = FTAttune_Data.stepsByType and FTAttune_Data.stepsByType["End"]
	if ends then
		for _, s in pairs(ends) do
			if attunes[s.ID_ATTUNE] and showPatchStep(s) and toon.done[s.ID_ATTUNE .. "-" .. s.ID] then
				local still = false
				if s.FOLLOWS ~= nil and s.FOLLOWS ~= "0" then
					local orMode = string.find(s.FOLLOWS, "|", 1, true) ~= nil
					local ids = FTAttune_split(s.FOLLOWS, orMode and "|" or "&")
					if orMode then
						for _, flw in pairs(ids) do
							if toon.done[s.ID_ATTUNE .. "-" .. flw] then still = true break end
						end
					else
						still = true
						for _, flw in pairs(ids) do
							if not toon.done[s.ID_ATTUNE .. "-" .. flw] then still = false break end
						end
					end
				end
				if not still then
					toon.done[s.ID_ATTUNE .. "-" .. s.ID] = nil
					FTAttune_RecountAttune(s.ID_ATTUNE)
				end
			end
		end
	end
	return true
end

-- Step-count percent for one attunement. Used when a finished chain is reopened.
function FTAttune_RecountAttune(attuneId)
	local t = FTAttune_DB.toons[attunelocal_charKey]
	if t == nil or t.done == nil or attuneId == nil then return end
	if t.attuned == nil then t.attuned = {} end
	local total, done = 0, 0
	local chain = FTAttune_Data.stepsByAttune and FTAttune_Data.stepsByAttune[attuneId]
	for _, s in pairs(chain or FTAttune_Data.steps) do
		if (chain ~= nil or s.ID_ATTUNE == attuneId) and showPatchStep(s) and s.TYPE ~= "Spacer" then
			total = total + 1
			if t.done[s.ID_ATTUNE .. "-" .. s.ID] then done = done + 1 end
		end
	end
	if total > 0 then
		t.attuned[attuneId] = math.floor(100 * done / total)
	else
		t.attuned[attuneId] = 0
	end
end

function FTAttune:QUEST_ACCEPTED(event, arg1, arg2)
	-- Forever passes questID; Classic passes questLogIndex, questID.
	local questID = tonumber(arg2) or tonumber(arg1)
	if questID == nil then return end
	-- The quest log often omits the quest until after this event.
	-- Remember it now so the Pick Up / Quest cell paints yellow immediately.
	if FTAttune_LogQuests == nil then FTAttune_LogQuests = {} end
	FTAttune_LogQuests[questID] = GetTime()
	local refreshNeeded = FTAttune_ClearTurnInOnAccept(questID)
	local steps = FTAttune_Data.stepsByPickup and FTAttune_Data.stepsByPickup[questID]
	if steps then
		for _, s in ipairs(steps) do
			if showPatchStep(s) then
				if FTAttune_MarkStepDone(s, FTAttuneLang[s.TYPE], FTAttuneLang["Q1_"..s.ID_WOWHEAD], false) then
					refreshNeeded = true
				end
			end
		end
		refreshNeeded = true
	end
	if FTAttune_Data.stepsByTurnIn and FTAttune_Data.stepsByTurnIn[questID] then
		refreshNeeded = true
	end

	if refreshNeeded then
		FTAttune_ForceAttuneTabRefresh()
		if C_Timer and C_Timer.After then
			C_Timer.After(0.5, function()
				FTAttune_SyncQuestLog()
				FTAttune_ForceAttuneTabRefresh()
			end)
		end
	end

end

-- Abandon and turn-in both remove the quest from the log.
-- Wait briefly so a turn-in can record completion before the cell drops back to grey.
function FTAttune:QUEST_REMOVED(event, arg1)
	local questID = tonumber(arg1)
	if questID == nil or FTAttune_LogQuests == nil then return end
	local stamp = FTAttune_LogQuests[questID]
	if stamp == nil then return end
	if not (C_Timer and C_Timer.After) then
		FTAttune_LogQuests[questID] = nil
		return
	end
	C_Timer.After(0.5, function()
		if FTAttune_LogQuests == nil then return end
		if type(stamp) == "number" and FTAttune_LogQuests[questID] ~= stamp then return end
		FTAttune_LogQuests[questID] = nil
		local known = (FTAttune_Data.stepsByPickup and FTAttune_Data.stepsByPickup[questID])
			or (FTAttune_Data.stepsByTurnIn and FTAttune_Data.stepsByTurnIn[questID])
		if known then FTAttune_ForceAttuneTabRefresh() end
	end)
end

-------------------------------------------------------------------------
-- EVENT: Quest turned in
-------------------------------------------------------------------------

function FTAttune:QUEST_TURNED_IN(event, arg1)
	local questID = tonumber(arg1)
	if questID == nil then return end
	local steps = FTAttune_Data.stepsByTurnIn and FTAttune_Data.stepsByTurnIn[questID]
	if steps == nil then return end

	local refreshNeeded = false
	for _, s in ipairs(steps) do
		if showPatchStep(s) then
			if FTAttune_MarkStepDone(s, FTAttuneLang[s.TYPE], FTAttuneLang["Q1_"..s.ID_WOWHEAD], true) then
				refreshNeeded = true
			end
		end
	end

	if refreshNeeded then FTAttune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Interact with NPC
-------------------------------------------------------------------------
function FTAttune:QUEST_DETAIL(event)
	--print("QUEST_DETAIL")
	FTAttune:GOSSIP_SHOW(event)
end
-------------------------------------------------------------------------
function FTAttune:GOSSIP_SHOW(event)
	-- Forever/Midnight: UnitGUID may be secret; never use it in a truthiness
	-- check (that forces string conversion and errors when tainted).
	local npc_id = FTAttune_GetInteractNpcID()
	if npc_id == -1 then return end
	local steps = FTAttune_Data.stepsByInteract and FTAttune_Data.stepsByInteract[tostring(npc_id)]
	if steps == nil then return end

	local refreshNeeded = false
	for _, s in ipairs(steps) do
		if showPatchStep(s) and FTAttune_StepIsNext(s) then
			if FTAttune_MarkStepDone(s, FTAttuneLang[s.TYPE], FTAttuneLang["N1_"..s.ID_WOWHEAD], true) then
				refreshNeeded = true
			end
		end
	end

	if refreshNeeded then FTAttune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Looted stuff
-------------------------------------------------------------------------

local attuneItemScanQueued = false

local function FTAttune_ScanItemSteps()
	local items = FTAttune_Data.stepsByItem
	if items == nil then return end
	local toon = FTAttune_DB.toons[attunelocal_charKey]
	if toon == nil or toon.done == nil or toon.items == nil then return end

	local refreshNeeded = false

	for itemId, steps in pairs(items) do
		local pending = false
		for _, s in ipairs(steps) do
			if showPatchStep(s) and toon.done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
				pending = true
				break
			end
		end
		if pending then
			local count = GetItemCount(itemId, 1)
			-- Bandaid to fix the honored/revered key issue
			if count == 0 then
				if itemId == "185686" then count = GetItemCount("30637", 1) -- Thrallmar
				elseif itemId == "185687" then count = GetItemCount("30622", 1) -- Honor Hold
				elseif itemId == "185690" then count = GetItemCount("30623", 1) -- Cenarion
				elseif itemId == "185691" then count = GetItemCount("30633", 1) -- Lower City
				elseif itemId == "185692" then count = GetItemCount("30634", 1) -- Shatar
				elseif itemId == "185693" then count = GetItemCount("30635", 1) -- KoT
				end
			end
			for _, s in ipairs(steps) do
				if showPatchStep(s) then
					-- Partial stacks (1/12) still need a redraw; completion is not the only change.
					if toon.items[s.ID_WOWHEAD] ~= count then
						toon.items[s.ID_WOWHEAD] = count
						refreshNeeded = true
					end
					local countNeeded = 1
					if s.COUNT ~= nil then countNeeded = s.COUNT end
					if count >= countNeeded then --check bags and bank
						if FTAttune_MarkStepDone(s, FTAttuneLang[s.TYPE], FTAttuneLang["I_"..s.ID_WOWHEAD], true) then
							refreshNeeded = true
						end
					end
				end
			end
		end
	end

	if refreshNeeded then FTAttune_ForceAttuneTabRefresh() end -- refresh view if needed
end

function FTAttune:BAG_UPDATE(event)
	-- Login counts items immediately so the first percent pass sees them.
	-- Live bag events arrive in bursts (quest items included); fold them into one scan.
	if event == nil then
		FTAttune_ScanItemSteps()
		return
	end
	if attuneItemScanQueued then return end
	attuneItemScanQueued = true
	C_Timer.After(0, function()
		attuneItemScanQueued = false
		FTAttune_ScanItemSteps()
	end)
end

-------------------------------------------------------------------------
-- EVENT: Rep changed
-------------------------------------------------------------------------

function FTAttune:UPDATE_FACTION(event)
	local reps = FTAttune_Data.stepsByType and FTAttune_Data.stepsByType["Rep"]
	if reps == nil then return end

	local refreshNeeded = false
	local toon = FTAttune_DB.toons[attunelocal_charKey]
	for _, s in ipairs(reps) do
		if showPatchStep(s) then
			local name, _, _, _, _, earnedValue = FTAttune_GetFactionInfoByID(s.LOCATION)
			toon.reps[s.LOCATION] = {}
			toon.reps[s.LOCATION].earned = earnedValue or 0
			toon.reps[s.LOCATION].name = name or FTAttuneLang["Unknown Reputation"]

			if toon.reps[s.LOCATION].earned >= tonumber(s.ID_WOWHEAD) then
				if FTAttune_MarkStepDone(s, FTAttuneLang[s.TYPE], s.STEP, true) then
					refreshNeeded = true
				end
			end
		end
	end

	if refreshNeeded then FTAttune_ForceAttuneTabRefresh() end -- refresh view if needed

end



-------------------------------------------------------------------------
function FTAttune_UpdateLogs()

	local slogs = ""
	local cnt = 0
	for i, l in FTAttune_spairs(FTAttune_DB.logs, function(t,a,b) return b < a end) do
		if cnt < 40 then -- only about 40 lines fit in that area
			slogs = slogs .. date("%d %b %Y - %H:%M", i) .. " - " .. l .. "\n"
		else
			FTAttune_DB.logs[i] = nil
		end
		cnt = cnt + 1
	end

	if slogs == "" then
		attune_options.args.tab2.args.logs.name = "None yet..."
	else
		attune_options.args.tab2.args.logs.name = slogs
	end

end

-------------------------------------------------------------------------
-- Perform the attunement checks
-------------------------------------------------------------------------

function FTAttune_CheckProgress()

	FTAttune_SyncQuestLog()
	local att = FTAttune_DB.toons[attunelocal_charKey]

	if att.reps == nil then att.reps = {} end
	--if att.quests == nil then att.quests = {} end
	if att.items == nil then att.items = {} end
	if att.done == nil then att.done = {} end
	if att.attuned == nil then att.attuned = {} end
	if att.next == nil then att.next = {} end

	local faction = UnitFactionGroup("player")
	-- looping through all applicable attunes
	for i, a in pairs(FTAttune_Data.attunes) do

		if a.FACTION == faction or a.FACTION == 'Both' and (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) then 

			-- Another class's quest chain is not this character's progress.
			if not FTAttune_MayRecordAttuneProgress(att, a.ID) then
				FTAttune_ClearAttuneProgress(att, a.ID)
			else

			--looping through all steps
			for i, s in pairs(FTAttune_Data.steps) do

				if showPatchStep(s) then
					if s.ID_ATTUNE == a.ID then

						--get REPUTATION progression
						if s.TYPE == "Rep" then

							--loop on the all the character's factions
							local factionIndex = 1
							local name, _, _, _, _, earnedValue = FTAttune_GetFactionInfoByID(s.LOCATION)
							att.reps[s.LOCATION] = {}
							att.reps[s.LOCATION].earned = earnedValue or 0
							att.reps[s.LOCATION].name = name or FTAttuneLang["Unknown Reputation"]
							--repeat
							--	local name, _, _, _, _, earnedValue = GetFactionInfo(factionIndex)
							--	if (name == s.LOCATION) then
							--		att.reps[s.LOCATION] = earnedValue
							--		break
							--	end
							--	factionIndex = factionIndex + 1
							--until factionIndex > 200

							if att.reps[s.LOCATION].earned >= tonumber(s.ID_WOWHEAD) then
								text = "|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\success:16|t"
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get QUEST accepts
						if s.TYPE == "Pick Up" then
							local eitherOnQuest = false
							local qIDs = FTAttune_split(s.ID_WOWHEAD, "|")
							for i=1, #qIDs do
								if FTAttune_QuestInLog(qIDs[i]) then
									eitherOnQuest = true
								end
							end
							if eitherOnQuest then
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get QUEST completion
						-- A quest still in the log is not turned in, even if an older
						-- completion flag exists for the same quest id.
						if s.TYPE == "Quest" or s.TYPE == "Turn In" then
							local eitherCompleted = false
							local onQuest = false
							local qIDs = FTAttune_split(s.ID_WOWHEAD, "|")
							for i=1, #qIDs do
								if FTAttune_QuestInLog(qIDs[i]) then
									onQuest = true
								elseif IsQuestFlaggedCompleted(qIDs[i]) then
									eitherCompleted = true
								end
							end
							if onQuest then
								att.done[a.ID .. "-" .. s.ID] = nil
							elseif eitherCompleted then
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get ITEM possession
						if s.TYPE == "Item" then
							local countNeeded = 1
							if s.COUNT ~= nil then countNeeded = s.COUNT end
							if GetItemCount(s.ID_WOWHEAD, 1) >= countNeeded then   --check bags and bank
								att.items[s.ID_WOWHEAD] = GetItemCount(s.ID_WOWHEAD, 1);
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get LEVEL progression
						if s.TYPE == "Level" then
							if UnitLevel('player') >= tonumber(s.ID_WOWHEAD) then
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end
					end
				end
			end
			end
		end
	end

	-- some specific steps mean the whole attunement is complete. Close off the whole tree if those are done
	-- including a second pass to mark as done all non-trackable steps (interact/kill/past items) that belong to earlier (completed) quests
	FTAttune_SendPushInfo("TOON")
	FTAttune_CheckComplete(true)
	FTAttune_SendPushInfo("OVER")

	-- a third pass to mark as done all attunements used in further attunements
	for i, s in pairs(FTAttune_Data.steps) do
		--print(s.ID_ATTUNE.."-"..s.ID)
		if showPatchStep(s) then
			if s.TYPE == 'FTAttune' and att.attuned[s.ID_WOWHEAD] >= 100 and FTAttune_MayRecordAttuneProgress(att, s.ID_ATTUNE) then
				att.done[s.ID_ATTUNE.."-"..s.ID] = 1
			end
		end	
	end

end

-------------------------------------------------------------------------
-- Auto-complete Spacer steps whose FOLLOWS are done (column drop lines)
-------------------------------------------------------------------------

function FTAttune_AutoCompleteSpacers(who)
	local t = FTAttune_DB.toons[who]
	if t == nil or t.done == nil then return end

	-- Repeat until stable so Spacer→Spacer chains mark top-to-bottom
	local changed = true
	local spacers = (FTAttune_Data.stepsByType and FTAttune_Data.stepsByType["Spacer"]) or FTAttune_Data.steps
	while changed do
		changed = false
		for _, s in pairs(spacers) do
			if showPatchStep(s) and s.TYPE == "Spacer" and s.FOLLOWS ~= nil and s.FOLLOWS ~= "0" and FTAttune_MayRecordAttuneProgress(t, s.ID_ATTUNE) then
				local key = s.ID_ATTUNE .. "-" .. s.ID
				if not t.done[key] then
					local allDone = true
					local followOR = false
					local fIDs = FTAttune_split(s.FOLLOWS, "&")
					if string.find(s.FOLLOWS, "|") then fIDs = FTAttune_split(s.FOLLOWS, "|"); followOR = true end
					if followOR then
						allDone = false
						for _, flw in pairs(fIDs) do
							if t.done[s.ID_ATTUNE .. "-" .. flw] then allDone = true; break end
						end
					else
						for _, flw in pairs(fIDs) do
							if not t.done[s.ID_ATTUNE .. "-" .. flw] then allDone = false; break end
						end
					end
					if allDone then
						t.done[key] = 1
						changed = true
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------
-- Check full FTAttune completion
-------------------------------------------------------------------------

function FTAttune_CheckComplete(newComplete)
	local att = FTAttune_DB.toons[attunelocal_charKey]

	FTAttune_AutoCompleteSpacers(attunelocal_charKey)

	-- WoW
	if att.done["20-45"] and att.attuned["20"] ~= 100 	then att.done["20-50"] = 1; 	FTAttune_SendPushInfo("20-50"); 	att.attuned["20"] = 100; FTAttune_UpdateTreeGroup("20"); newComplete = true;  end	-- MC
	if att.done["30-268"] and att.attuned["30"] ~= 100	then att.done["30-270"] = 1; FTAttune_SendPushInfo("30-270"); 	att.attuned["30"] = 100; FTAttune_UpdateTreeGroup("30"); newComplete = true;  end	-- Ony Horde
	if att.done["40-265"] and att.attuned["40"] ~= 100	then att.done["40-270"] = 1; FTAttune_SendPushInfo("40-270"); 	att.attuned["40"] = 100; FTAttune_UpdateTreeGroup("40"); newComplete = true;  end	-- Ony Alliance
	if att.done["50-65"] and att.attuned["50"] ~= 100 	then att.done["50-70"] = 1; 	FTAttune_SendPushInfo("50-70"); 	att.attuned["50"] = 100; FTAttune_UpdateTreeGroup("50"); newComplete = true;  end	-- BWL
	if att.done["60-40"] and att.attuned["60"] ~= 100 	then att.done["60-90"] = 1; 	FTAttune_SendPushInfo("60-90"); 	att.attuned["60"] = 100; FTAttune_UpdateTreeGroup("60"); newComplete = true;  end	-- Naxx
	if att.done["60-50"] and att.attuned["60"] ~= 100 	then att.done["60-90"] = 1; 	FTAttune_SendPushInfo("60-90"); 	att.attuned["60"] = 100; FTAttune_UpdateTreeGroup("60"); newComplete = true;  end	-- Naxx
	if att.done["60-60"] and att.attuned["60"] ~= 100 	then att.done["60-90"] = 1; 	FTAttune_SendPushInfo("60-90"); 	att.attuned["60"] = 100; FTAttune_UpdateTreeGroup("60"); newComplete = true;  end	-- Naxx
	if att.done["80-200"] and att.attuned["80"] ~= 100 	then att.done["80-210"] = 1; FTAttune_SendPushInfo("80-210"); 	att.attuned["80"] = 100;	 FTAttune_UpdateTreeGroup("80"); newComplete = true;  end	-- MC Quintessence
	if att.done["100-960"] and att.attuned["100"] ~= 100 	then att.done["100-970"] = 1;FTAttune_SendPushInfo("100-970"); 	att.attuned["100"] = 100; FTAttune_UpdateTreeGroup("100"); newComplete = true;  end	-- scarab

	if att.done["120-65"] and att.attuned["120"] ~= 100 	then att.done["120-70"] = 1; FTAttune_SendPushInfo("120-70"); 	att.attuned["120"] = 100; FTAttune_UpdateTreeGroup("120"); newComplete = true;  end	-- brd key
	if att.done["140-130"] and att.attuned["140"] ~= 100 	then att.done["140-140"] = 1; FTAttune_SendPushInfo("140-140"); 	att.attuned["140"] = 100; FTAttune_UpdateTreeGroup("140"); newComplete = true;  end	-- scholo Horde
	if att.done["150-130"] and att.attuned["150"] ~= 100 	then att.done["150-140"] = 1; FTAttune_SendPushInfo("150-140"); 	att.attuned["150"] = 100; FTAttune_UpdateTreeGroup("150"); newComplete = true;  end	-- scholo Alliance


	-- Generic: mark End done when all its FOLLOWS are complete
	local ends = (FTAttune_Data.stepsByType and FTAttune_Data.stepsByType["End"]) or FTAttune_Data.steps
	for _, s in pairs(ends) do
		if showPatchStep(s) and s.TYPE == "End" and (att.attuned[s.ID_ATTUNE] or 0) < 100 and FTAttune_MayRecordAttuneProgress(att, s.ID_ATTUNE) then
			local allDone = true
			if s.FOLLOWS == nil or s.FOLLOWS == "0" then
				allDone = false
			else
				local fIDs = FTAttune_split(s.FOLLOWS, "&")
				for _, flw in pairs(fIDs) do
					if not att.done[s.ID_ATTUNE .. "-" .. flw] then allDone = false; break end
				end
			end
			if s.FOLLOWS ~= nil and string.find(s.FOLLOWS, "|", 1, true) then
				local anyDone = false
				for _, flw in pairs(FTAttune_split(s.FOLLOWS, "|")) do
					if att.done[s.ID_ATTUNE .. "-" .. flw] then anyDone = true; break end
				end
				allDone = anyDone
			end
			if allDone then
				att.done[s.ID_ATTUNE .. "-" .. s.ID] = 1
				FTAttune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
				att.attuned[s.ID_ATTUNE] = 100
				FTAttune_UpdateTreeGroup(s.ID_ATTUNE)
				newComplete = true
			end
		end
	end

	if newComplete then 
		for i, s in FTAttune_spairs(FTAttune_Data.steps, function(t,a,b) 	return tonumber(t[b].ID) > tonumber(t[a].ID) end) do
			if showPatchStep(s) then
				if att.done[s.ID_ATTUNE .. "-" .. s.ID] then
					-- recurse into earlier steps to mark them as done too
					C_Timer.After(0.01, function() FTAttune_recursePreviousSteps(attunelocal_charKey, s.ID_ATTUNE, s.FOLLOWS) end)
				end
			end
		end
	end
	FTAttune_CheckIsNext(attunelocal_charKey)
end

-------------------------------------------------------------------------
-- If the End step is done, force attuned % to 100 (overrides step-count math)
-------------------------------------------------------------------------

function FTAttune_ApplyCompletedEndSteps(t)
	if t == nil or t.done == nil or t.attuned == nil then return end
	local ends = (FTAttune_Data.stepsByType and FTAttune_Data.stepsByType["End"]) or FTAttune_Data.steps
	for _, s in pairs(ends) do
		if showPatchStep(s) and s.TYPE == "End" and t.done[s.ID_ATTUNE .. "-" .. s.ID] and FTAttune_MayRecordAttuneProgress(t, s.ID_ATTUNE) then
			t.attuned[s.ID_ATTUNE] = 100
		end
	end
end

-------------------------------------------------------------------------
-- Check which step is next
-------------------------------------------------------------------------

function FTAttune_CheckIsNext(who)
	local att = FTAttune_DB.toons[who]
	--print("Checking "..who)
	-- blank the array
	att.next = {}

	for i, step in pairs(FTAttune_Data.steps) do
		-- Inside reminders are optional and always available, so they are not "the current step".
		if showPatchStep(step) and not step.SIDE and FTAttune_MayRecordAttuneProgress(att, step.ID_ATTUNE) then

			if (step.ID_ATTUNE == "190" and step.ID == "120") then debug = true else debug=false end

			local next = false
			if  att.done[step.ID_ATTUNE .. "-" .. step.ID] ~= nil then
				-- if done, then not isnext
				next = false
			else

				local followOR = false
				local fIDs = FTAttune_split(step.FOLLOWS, "&")
				if string.find(step.FOLLOWS, "|") then fIDs = FTAttune_split(step.FOLLOWS, "|"); followOR = true end

				if followOR then
					next = false
					for fi, flw in pairs(fIDs) do
						if  att.done[step.ID_ATTUNE .. "-" .. flw] then next = true end
					end

				else
					next = true
					for fi, flw in pairs(fIDs) do
						if  att.done[step.ID_ATTUNE .. "-" .. flw] == nil or att.done[step.ID_ATTUNE .. "-" .. flw] == false then next = false end
					end
		
				end
				if step.FOLLOWS == "0" then next = true end
			end

			if next then
				att.next[step.ID_ATTUNE .. "-" .. step.ID] = 1
			else
				att.next[step.ID_ATTUNE .. "-" .. step.ID] = nil
			end
		end
	end
end

-------------------------------------------------------------------------
-- Update the treeview to show completed attunes
-------------------------------------------------------------------------

function FTAttune_UpdateTreeGroup(aid)
	-- Completed attunes move into Archived, so the list has to be rebuilt.
	if FTAttune_DB.archiveCompleted then
		FTAttune_ReloadAttuneTree()
		return
	end

	for i, a in pairs(FTAttune_Data.attunes) do
		if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) then 
			if a.ID == aid then

				-- parse expacs
				for iE, aE in pairs(attunelocal_tree) do
					if aE.value == a.EXPAC then

						-- parse groups
						for iG, aG in pairs(aE.children) do
							if aG.value == a.GROUP then

								local groupAllDone = true
								for iA, aA in pairs(aG.children) do
									if aA.value == a.ID then
										aA.text = "|cff00ff00"..aA.text.."|r"
										aA.icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\success"
									end
									if aA.icon ~= "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\success" then 
										groupAllDone = false
									end
								end
								if groupAllDone then 
									aG.text = "|cff00ff00"..aG.text.."|r"
								end
							end
						end
					end
				end
			end
		end
	end

end

-------------------------------------------------------------------------
-- Recurse through previous steps (following the FOLLOWS path)
-------------------------------------------------------------------------

function FTAttune_recursePreviousSteps(who, aID, follows)

    
	if (FTAttune_DB.toons[who] ~= nil) then
		if (FTAttune_DB.toons[who].done ~= nil) then

			-- there can be multi-follows (for example FOLLOW=160|170)
			-- We need to recurse both paths
			local fIDs = FTAttune_split(follows, "&")
			if string.find(follows, "|") then fIDs = FTAttune_split(follows, "|") end

			for fi, f in pairs(fIDs) do
				local s = FTAttune_Data.stepsByKey and FTAttune_Data.stepsByKey[aID .. "-" .. f]
				if s and showPatchStep(s) and FTAttune_MayRecordAttuneProgress(FTAttune_DB.toons[who], aID) then
					if string.find(follows, "|") == nil then -- don't recurse OR, as we don't know which parent was actually done
						if FTAttune_DB.toons[who].done[s.ID_ATTUNE .. "-" .. s.ID] ~= 1 then
							-- print(s.ID_ATTUNE .. "-" .. s.ID)
							FTAttune_DB.toons[who].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
							if (who == attunelocal_charKey) then FTAttune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID) end
						end
						if follows ~= 0 then -- no need to recurse first level
							FTAttune_recursePreviousSteps(who, s.ID_ATTUNE, s.FOLLOWS)
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------
-- Display name, with the level range when the entry defines one
-------------------------------------------------------------------------

local function FTAttune_DisplayName(a)
	if a.LEVELS and a.LEVELS ~= "" then
		return a.NAME .. " (" .. a.LEVELS .. ")"
	end
	return a.NAME
end

-------------------------------------------------------------------------
-- Load the data into the TreeGroup object (nodes/leaves)
-------------------------------------------------------------------------

-- Class quests stay in the tree. The Results grid does not list them.
local function FTAttune_IsClassQuest(a)
	return a.CLASS ~= nil and a.CLASS ~= ""
end

-- Class quests are shown for the player's class unless "See class quests for all classes" is on.
local function FTAttune_ClassQuestVisible(a)
	if a.CLASS == nil or a.CLASS == "" then return true end
	if FTAttune_DB.showAllClassQuests then return true end
	local _, classFile = UnitClass("player")
	return classFile ~= nil and a.CLASS == classFile
end

-- Selected attunement, stored on this character inside the account-wide saved data.
function FTAttune_GetLastViewed()
	local t = FTAttune_DB and attunelocal_charKey and FTAttune_DB.toons and FTAttune_DB.toons[attunelocal_charKey]
	if t == nil then return nil end
	-- Older builds kept this in a per-character saved variable. Copy it once.
	if (t.lastViewed == nil or t.lastViewed == "") and type(FTAttuneLastViewed) == "string" and FTAttuneLastViewed ~= "" then
		t.lastViewed = FTAttuneLastViewed
		FTAttuneLastViewed = nil
	end
	return t.lastViewed
end

function FTAttune_SetLastViewed(path)
	local t = FTAttune_DB and attunelocal_charKey and FTAttune_DB.toons and FTAttune_DB.toons[attunelocal_charKey]
	if t == nil then return end
	t.lastViewed = path
end

-- First unfinished attunement in list order. Used when this character has not opened one yet.
function FTAttune_EnsureDefaultView()
	if FTAttune_GetLastViewed() ~= nil then return end
	local withSteps = {}
	for _, s in pairs(FTAttune_Data.steps) do
		if showPatchStep(s) then
			withSteps[s.ID_ATTUNE] = true
		end
	end
	local toon = FTAttune_DB.toons[attunelocal_charKey]
	local fallback = nil
	local chosen = nil
	for _, a in ipairs(FTAttune_Data.attunes) do
		if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes)
			and (a.FACTION == attunelocal_faction or a.FACTION == "Both")
			and FTAttune_ClassQuestVisible(a)
			and FTAttune_MayRecordAttuneProgress(toon, a.ID)
			and withSteps[a.ID]
		then
			if fallback == nil then fallback = a end
			if (toon.attuned[a.ID] or 0) < 100 then
				chosen = a
				break
			end
		end
	end
	if chosen == nil then chosen = fallback end
	if chosen == nil then return end
	FTAttune_SetLastViewed(chosen.EXPAC .. "\001" .. chosen.GROUP .. "\001" .. chosen.ID)
end

local function FTAttune_CommitGroup(expacNode, groupNode, groupAllDone)
	if groupNode == nil or groupNode.children == nil or #groupNode.children == 0 then return end
	if groupAllDone then groupNode.text = "|cff00ff00"..groupNode.text.."|r" end
	table.insert(expacNode.children, groupNode)
end

function FTAttune_LoadTree()
	attunelocal_tree = {}
	local expac = ""
	local group = ""
	local expacNode = {}
	local groupNode = {}
	local groupAllDone = true
	local archivedNodes = {}
	local attunesWithSteps = {}
	for _, s in pairs(FTAttune_Data.steps) do
		if showPatchStep(s) then
			attunesWithSteps[s.ID_ATTUNE] = true
		end
	end

	for i, a in pairs(FTAttune_Data.attunes) do
		if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) and FTAttune_ClassQuestVisible(a) then 

			--Group Level
			if group ~= a.GROUP or expac ~= a.EXPAC then 

				if group ~= "" then
					FTAttune_CommitGroup(expacNode, groupNode, groupAllDone)
				end

				--Top level
				if expac ~= a.EXPAC then

					if expac ~= "" then
						table.insert(attunelocal_tree, expacNode)
					end

					-- new expac array
					expacNode = {
						value = a.EXPAC,
						text =  a.EXPAC,
						children = {}
					}
					expac = a.EXPAC
				end

				-- new group array
				groupNode = {
					value = a.GROUP,
					text =  "|cffA0A0A0"..a.GROUP.."|r",
					children = {}
				}
				group = a.GROUP
				groupAllDone = true
			end

			if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then

				local text = FTAttune_DisplayName(a)
				local icon = a.ICON
				local done = false
				if not attunesWithSteps[a.ID] then
					text = "|cff808080"..text.."|r"
					groupAllDone = false
				elseif not FTAttune_MayRecordAttuneProgress(FTAttune_DB.toons[attunelocal_charKey], a.ID) then
					groupAllDone = false
				elseif FTAttune_DB.toons[attunelocal_charKey].attuned ~= nil then
					if FTAttune_DB.toons[attunelocal_charKey].attuned[a.ID] >= 100 then
						text = "|cff00ff00"..text.."|r"
						icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\success"
						done = true
					else 
						groupAllDone = false
					end
				end


				local attuneNode = {
					value = a.ID,
					text = text,
					icon = icon,
					sourceIcon = a.ICON,
					tip = FTAttune_DisplayName(a),
					short = a.SHORT,
					dim = not attunesWithSteps[a.ID],
					done = done,
				}
				-- Completed attunes leave their category and collect at the bottom.
				if FTAttune_DB.archiveCompleted and done then
					table.insert(archivedNodes, attuneNode)
				else
					table.insert(groupNode.children, attuneNode)
				end
			end
		end
	end
	--table.insert(groupNode.children, attuneNode)
	FTAttune_CommitGroup(expacNode, groupNode, groupAllDone)
	if #archivedNodes > 0 and expacNode.children then
		table.insert(expacNode.children, {
			value = FTAttuneLang["Archived"],
			text = "|cff00ff00"..FTAttuneLang["Archived"].."|r",
			children = archivedNodes,
		})
	end
	table.insert(attunelocal_tree, expacNode)
	FTAttune_SyncLastViewedPath()

end


-------------------------------------------------------------------------
-- Path of an attune in the current tree (expac, category, id)
-------------------------------------------------------------------------

function FTAttune_PathForAttune(attuneId)
	if attuneId == nil then return nil end
	for _, expacNode in ipairs(attunelocal_tree) do
		for _, groupNode in ipairs(expacNode.children or {}) do
			for _, leaf in ipairs(groupNode.children or {}) do
				if leaf.value == attuneId then
					return expacNode.value .. "\001" .. groupNode.value .. "\001" .. leaf.value
				end
			end
		end
	end
end

function FTAttune_SyncLastViewedPath()
	local lastViewed = FTAttune_GetLastViewed()
	if lastViewed == nil then return end
	local _, _, sel = strsplit("\001", lastViewed)
	if sel == nil or sel == "" then return end
	local path = FTAttune_PathForAttune(sel)
	if path then FTAttune_SetLastViewed(path) end
end

function FTAttune_ReloadAttuneTree()
	FTAttune_LoadTree()
	local tree = attunelocal_treeframe
	-- Results view releases the tree widget. The rebuilt list is applied the next time that view opens.
	if tree == nil or not attunelocal_treeIsShown then return end
	local status = tree.status or tree.localstatus
	local lastViewed = FTAttune_GetLastViewed()
	if status and lastViewed then
		status.selected = lastViewed
	end
	if FTAttune_DB.archiveCompleted and status and status.groups then
		local archived = FTAttuneLang["Archived"]
		for _, expacNode in ipairs(attunelocal_tree) do
			if expacNode.value then
				local key = expacNode.value .. "\001" .. archived
				if FTAttuneTreeExpandStatus == nil or FTAttuneTreeExpandStatus[key] ~= 0 then
					status.groups[key] = true
				end
			end
		end
	end
	tree:SetTree(attunelocal_tree)
end


-------------------------------------------------------------------------
-- Icon grid shown in place of the tree list
-------------------------------------------------------------------------

-- Not local: FTAttune.lua's main chunk is at Lua's 200-local limit.
ATTUNE_ICON_SIZE = 48
ATTUNE_ICON_GAP = 10
ATTUNE_ICON_HEADER = 20
ATTUNE_ICON_HEADER_GAP = 6
ATTUNE_ICON_CAPTION_H = 13

-- Left inset 4, drag handle 8, scrollbar 18, plus two icons and the gap between them.
function FTAttune_MinTreeWidth()
	return ATTUNE_ICON_SIZE * 2 + ATTUNE_ICON_GAP + 30
end

function FTAttune_PlainText(text)
	if not text then return "" end
	return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""))
end

function FTAttune_IconViewUpdateScroll(view)
	local height = view.scroll:GetHeight() or 0
	local contentH = view.content:GetHeight() or 0
	local maxScroll = contentH - height
	if maxScroll < 0 then maxScroll = 0 end
	local value = view.scroll:GetVerticalScroll() or 0
	if value > maxScroll then value = maxScroll end
	if value < 0 then value = 0 end
	view.noupdate = true
	view.bar:SetMinMaxValues(0, maxScroll)
	view.bar:SetValue(value)
	view.scroll:SetVerticalScroll(value)
	view.noupdate = nil
end

function FTAttune_IconViewScroll(delta)
	local view = attunelocal_iconView
	if view == nil or not view:IsShown() then return end
	local minV, maxV = view.bar:GetMinMaxValues()
	local step = view.iconStep or (ATTUNE_ICON_SIZE + ATTUNE_ICON_GAP)
	local value = view.bar:GetValue() - delta * step
	if value < minV then value = minV end
	if value > maxV then value = maxV end
	view.bar:SetValue(value)
end

function FTAttune_IconViewButton(view)
	local button = CreateFrame("Button", nil, view.content)
	button:RegisterForClicks("LeftButtonUp")
	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.selected = button:CreateTexture(nil, "OVERLAY")
	button.selected:SetTexture("Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\spellframe")
	button.selected:SetBlendMode("ADD")
	button.selected:SetAllPoints(button.icon)
	button.selected:Hide()
	button.success = button:CreateTexture(nil, "OVERLAY")
	button.success:SetTexture("Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\success")
	button.success:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)
	button.success:Hide()
	button.caption = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	button.caption:SetPoint("TOP", button.icon, "BOTTOM", 0, -1)
	button.caption:SetJustifyH("CENTER")
	button.caption:SetWordWrap(false)
	button.caption:SetTextColor(0.9, 0.9, 0.9)
	button.caption:Hide()
	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight:SetBlendMode("ADD")
	highlight:SetAllPoints(button.icon)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tip or "")
		if self.done then
			GameTooltip:AddLine(FTAttuneLang["Attuned"], 0, 1, 0)
		end
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	button:SetScript("OnClick", function(self)
		if attunelocal_treeframe then
			attunelocal_treeframe:SelectByPath(self.expac, self.group, self.id)
		end
	end)
	button:EnableMouseWheel(true)
	button:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_IconViewScroll(delta)
	end)
	return button
end

function FTAttune_IconViewHeader(view)
	local header = CreateFrame("Frame", nil, view.content)
	header:SetHeight(ATTUNE_ICON_HEADER)
	header.text = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	header.text:SetPoint("CENTER", header, "CENTER", 0, 0)
	header.text:SetJustifyH("CENTER")
	header.text:SetTextColor(0.63, 0.63, 0.63)
	header.left = header:CreateTexture(nil, "ARTWORK")
	header.left:SetColorTexture(0.63, 0.63, 0.63, 0.55)
	header.left:SetHeight(1)
	header.right = header:CreateTexture(nil, "ARTWORK")
	header.right:SetColorTexture(0.63, 0.63, 0.63, 0.55)
	header.right:SetHeight(1)
	header:EnableMouseWheel(true)
	header:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_IconViewScroll(delta)
	end)
	return header
end

function FTAttune_LayoutIconView()
	local view = attunelocal_iconView
	if view == nil or not view:IsShown() then return end
	local width = view.scroll:GetWidth()
	if not width or width < 20 then
		if not view.pending then
			view.pending = true
			C_Timer.After(0, function()
				view.pending = false
				if view:IsShown() then FTAttune_LayoutIconView() end
			end)
		end
		return
	end

	local size = ATTUNE_ICON_SIZE
	local gap = ATTUNE_ICON_GAP
	local cols = math.floor((width + gap) / (size + gap))
	if cols < 2 then cols = 2 end
	view.iconStep = size + gap
	local gridW = cols * size + (cols - 1) * gap
	local originX = math.floor((width - gridW) / 2)
	if originX < 0 then originX = 0 end

	local status = attunelocal_treeframe and (attunelocal_treeframe.status or attunelocal_treeframe.localstatus)
	local selected = status and status.selected
	local y = 6
	local iconIndex = 0
	local headerIndex = 0
	local selectedButton = nil
	local showExpac = #attunelocal_tree > 1

	local function placeHeader(label)
		headerIndex = headerIndex + 1
		local header = view.headers[headerIndex]
		if header == nil then
			header = FTAttune_IconViewHeader(view)
			view.headers[headerIndex] = header
		end
		header:ClearAllPoints()
		header:SetPoint("TOPLEFT", view.content, "TOPLEFT", 0, -y)
		header:SetWidth(width)
		header.text:SetText(label)
		local textW = header.text:GetStringWidth() or 0
		local room = (width - textW) / 2
		header.left:ClearAllPoints()
		header.right:ClearAllPoints()
		if room > 14 then
			header.left:SetPoint("LEFT", header, "LEFT", 4, 0)
			header.left:SetPoint("RIGHT", header.text, "LEFT", -6, 0)
			header.right:SetPoint("LEFT", header.text, "RIGHT", 6, 0)
			header.right:SetPoint("RIGHT", header, "RIGHT", -4, 0)
			header.left:Show()
			header.right:Show()
		else
			header.left:Hide()
			header.right:Hide()
		end
		header:Show()
		y = y + ATTUNE_ICON_HEADER + ATTUNE_ICON_HEADER_GAP
	end

	for _, expacNode in ipairs(attunelocal_tree) do
		if showExpac and expacNode.children and #expacNode.children > 0 then
			placeHeader(FTAttune_PlainText(expacNode.text))
		end
		for _, groupNode in ipairs(expacNode.children or {}) do
			local leaves = groupNode.children
			if leaves and #leaves > 0 then
				placeHeader(FTAttune_PlainText(groupNode.text))
				local i = 1
				while i <= #leaves do
					local rowCount = math.min(cols, #leaves - i + 1)
					local rowHeight = size
					for look = 0, rowCount - 1 do
						local ahead = leaves[i + look]
						if ahead.short and ahead.short ~= "" then
							rowHeight = size + ATTUNE_ICON_CAPTION_H
							break
						end
					end
					for look = 0, rowCount - 1 do
						local leaf = leaves[i + look]
						iconIndex = iconIndex + 1
						local button = view.icons[iconIndex]
						if button == nil then
							button = FTAttune_IconViewButton(view)
							view.icons[iconIndex] = button
						end
						local x = originX + look * (size + gap)
						button:ClearAllPoints()
						button:SetSize(size, rowHeight)
						button:SetPoint("TOPLEFT", view.content, "TOPLEFT", x, -y)
						button.offsetY = y
						button.cellHeight = rowHeight
						button.icon:SetSize(size, size)
						button.expac = expacNode.value
						button.group = groupNode.value
						button.id = leaf.value
						button.tip = leaf.tip or FTAttune_PlainText(leaf.text)
						button.done = leaf.done
						button.icon:SetTexture(leaf.sourceIcon or leaf.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
						local badge = 16
						if size < 32 then badge = math.max(12, math.floor(size * 0.5)) end
						button.success:SetSize(badge, badge)
						if leaf.done then button.success:Show() else button.success:Hide() end
						local alpha = leaf.done and 0.15 or 1
						if leaf.dim then
							button.icon:SetVertexColor(0.45, 0.45, 0.45, alpha)
						else
							button.icon:SetVertexColor(1, 1, 1, alpha)
						end
						if leaf.short and leaf.short ~= "" then
							button.caption:SetWidth(size)
							button.caption:SetText(leaf.short)
							button.caption:Show()
						else
							button.caption:Hide()
						end
						local path = expacNode.value .. "\001" .. groupNode.value .. "\001" .. leaf.value
						if path == selected then
							button.selected:Show()
							selectedButton = button
						else
							button.selected:Hide()
						end
						button:Show()
					end
					y = y + rowHeight + gap
					i = i + rowCount
				end
				y = y + 4
			end
		end
	end

	for i = iconIndex + 1, #view.icons do view.icons[i]:Hide() end
	for i = headerIndex + 1, #view.headers do view.headers[i]:Hide() end

	view.content:SetWidth(width)
	view.content:SetHeight(math.max(y, 1))
	FTAttune_IconViewUpdateScroll(view)

	local viewH = view.scroll:GetHeight() or 0
	if selectedButton and viewH > 10 then
		local offset = view.scroll:GetVerticalScroll() or 0
		local top = selectedButton.offsetY
		local bottom = top + (selectedButton.cellHeight or size)
		if top < offset then
			view.bar:SetValue(top)
		elseif bottom > offset + viewH then
			view.bar:SetValue(math.max(0, bottom - viewH))
		end
	end
end

function FTAttune_EnsureIconView(widget)
	if widget.attuneIconHolder then
		attunelocal_iconView = widget.attuneIconHolder
		return widget.attuneIconHolder
	end
	local treeframe = widget.treeframe
	local holder = CreateFrame("Frame", nil, treeframe)
	holder:SetPoint("TOPLEFT", treeframe, "TOPLEFT", 4, -6)
	holder:SetPoint("BOTTOMRIGHT", treeframe, "BOTTOMRIGHT", -8, 6)
	holder:SetFrameLevel(treeframe:GetFrameLevel() + 5)
	holder:EnableMouse(true)
	holder:EnableMouseWheel(true)
	holder:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_IconViewScroll(delta)
	end)

	local scroll = CreateFrame("ScrollFrame", nil, holder)
	scroll:SetPoint("TOPLEFT", holder, "TOPLEFT", 0, 0)
	scroll:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -18, 0)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_IconViewScroll(delta)
	end)

	attunelocal_iconScrollSerial = (attunelocal_iconScrollSerial or 0) + 1
	local bar = CreateFrame("Slider", "FTAttuneIconScrollBar"..attunelocal_iconScrollSerial, holder, "UIPanelScrollBarTemplate")
	-- The template's OnValueChanged calls SetVerticalScroll on the parent. This parent is not a ScrollFrame.
	bar:SetScript("OnValueChanged", nil)
	bar:ClearAllPoints()
	bar:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 0, -16)
	bar:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, 16)
	bar:SetWidth(16)
	bar.scrollStep = ATTUNE_ICON_SIZE + ATTUNE_ICON_GAP
	holder.scroll = scroll
	holder.noupdate = true
	bar:SetScript("OnValueChanged", function(self, value)
		if holder.noupdate or not holder.scroll then return end
		holder.scroll:SetVerticalScroll(value or 0)
	end)
	bar:SetMinMaxValues(0, 0)
	bar:SetValueStep(1)
	bar:SetValue(0)
	holder.noupdate = nil

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(1, 1)
	scroll:SetScrollChild(content)

	holder.scroll = scroll
	holder.bar = bar
	holder.content = content
	holder.icons = {}
	holder.headers = {}
	holder:Hide()
	widget.attuneIconHolder = holder
	attunelocal_iconView = holder
	return holder
end

function FTAttune_ShowIconView(widget)
	for _, button in ipairs(widget.buttons or {}) do
		button:Hide()
	end
	if widget.ShowScroll then widget:ShowScroll(false) end
	local holder = FTAttune_EnsureIconView(widget)
	holder:Show()
	FTAttune_LayoutIconView()
end

function FTAttune_PaintViewToggleButton(button, active)
	button:SetAlpha(active and 1 or 0.5)
end

function FTAttune_UpdateViewToggle(widget)
	widget = widget or attunelocal_treeframe
	local header = widget and widget.attuneViewToggle
	if not header then return end
	local icons = FTAttune_DB and FTAttune_DB.iconView
	FTAttune_PaintViewToggleButton(header.listButton, not icons)
	FTAttune_PaintViewToggleButton(header.iconButton, icons)
end

function FTAttune_SetIconView(enabled)
	enabled = not not enabled
	if not FTAttune_DB then return end
	if FTAttune_DB.iconView == enabled then
		FTAttune_UpdateViewToggle()
		return
	end
	FTAttune_DB.iconView = enabled
	FTAttune_UpdateViewToggle()
	local reg = LibStub("AceConfigRegistry-3.0", true)
	if reg then reg:NotifyChange("FTAttune") end
	if attunelocal_treeframe and attunelocal_treeIsShown then
		attunelocal_treeframe:RefreshTree()
	end
end

function FTAttune_CreateViewToggleButton(parent, mode)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(18, 16)
	button.iconMode = mode == "icon"
	button.tip = FTAttuneLang[button.iconMode and "IconView_TIP" or "TreeView_TIP"]
	local edge = button:CreateTexture(nil, "BACKGROUND")
	edge:SetColorTexture(0.4, 0.4, 0.4, 1)
	edge:SetAllPoints()
	button.edge = edge
	local fill = button:CreateTexture(nil, "BACKGROUND")
	fill:SetColorTexture(0.05, 0.05, 0.05, 0.95)
	fill:SetPoint("TOPLEFT", 1, -1)
	fill:SetPoint("BOTTOMRIGHT", -1, 1)
	button.marks = {}
	if mode == "list" then
		for i = 0, 2 do
			local line = button:CreateTexture(nil, "ARTWORK")
			line:SetColorTexture(1, 1, 1, 1)
			line:SetSize(10, 2)
			line:SetPoint("CENTER", button, "CENTER", 0, 4 - i * 4)
			button.marks[#button.marks + 1] = line
		end
	else
		for row = 0, 1 do
			for col = 0, 1 do
				local sq = button:CreateTexture(nil, "ARTWORK")
				sq:SetColorTexture(1, 1, 1, 1)
				sq:SetSize(4, 4)
				sq:SetPoint("CENTER", button, "CENTER", -3 + col * 6, 3 - row * 6)
				button.marks[#button.marks + 1] = sq
			end
		end
	end
	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight:SetBlendMode("ADD")
	highlight:SetAllPoints()
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tip or "")
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	button:SetScript("OnClick", function(self)
		FTAttune_SetIconView(self.iconMode)
	end)
	button:EnableMouseWheel(true)
	button:SetScript("OnMouseWheel", function(_, delta)
		local tree = attunelocal_treeframe
		if not tree or not tree.treeframe then return end
		local wheel = tree.treeframe:GetScript("OnMouseWheel")
		if wheel then wheel(tree.treeframe, delta) end
	end)
	return button
end

function FTAttune_EnsureViewToggle(widget)
	local header = attunelocal_viewToggle
	if not header then
		-- Open band under the title, above both the list and the main pane.
		-- Parent is the window so the buttons are not inside either frame.
		local parent = attunelocal_frame and attunelocal_frame.frame or widget.frame
		header = CreateFrame("Frame", nil, parent)
		header:SetSize(40, 16)
		if attunelocal_frame and attunelocal_frame.content then
			-- Clear the portrait, which hangs into the left of this band.
			header:SetPoint("BOTTOMLEFT", attunelocal_frame.content, "TOPLEFT", 48, 4)
		else
			header:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT", 48, 4)
		end
		header:SetFrameLevel((parent:GetFrameLevel() or 0) + 30)
		header:EnableMouse(true)
		header:EnableMouseWheel(true)
		header:SetScript("OnMouseWheel", function(_, delta)
			local tree = attunelocal_treeframe
			if not tree or not tree.treeframe then return end
			local wheel = tree.treeframe:GetScript("OnMouseWheel")
			if wheel then wheel(tree.treeframe, delta) end
		end)
		header.listButton = FTAttune_CreateViewToggleButton(header, "list")
		header.listButton:SetPoint("RIGHT", header, "CENTER", -1, 0)
		header.iconButton = FTAttune_CreateViewToggleButton(header, "icon")
		header.iconButton:SetPoint("LEFT", header, "CENTER", 1, 0)
		attunelocal_viewToggle = header
	end
	widget.attuneViewToggle = header
	header:Show()
	FTAttune_UpdateViewToggle(widget)
	return header
end

function FTAttune_InstallIconView(widget)
	FTAttune_EnsureViewToggle(widget)
	if widget.attuneIconViewInstalled then return end
	widget.attuneIconViewInstalled = true
	local orig = widget.RefreshTree
	widget.RefreshTree = function(self, ...)
		if self == attunelocal_treeframe and FTAttune_DB and FTAttune_DB.iconView then
			FTAttune_ShowIconView(self)
			return
		end
		if self.attuneIconHolder then self.attuneIconHolder:Hide() end
		local treeframe = self.treeframe
		local row = FTAttune_TreeRowMetrics()
		local origGetHeight
		if treeframe and row ~= 18 and treeframe.GetHeight then
			origGetHeight = treeframe.GetHeight
			treeframe.GetHeight = function(frame)
				local h = origGetHeight(frame)
				if not h or h <= 20 then return h or 0 end
				return 20 + (h - 20) * 18 / row
			end
		end
		local ok, result = pcall(orig, self, ...)
		if origGetHeight then treeframe.GetHeight = origGetHeight end
		if not ok then error(result, 0) end
		FTAttune_ApplyTreeListMetrics(self)
		return result
	end
	local wheel = widget.treeframe:GetScript("OnMouseWheel")
	widget.treeframe:SetScript("OnMouseWheel", function(frame, delta)
		if frame.obj == attunelocal_treeframe and FTAttune_DB and FTAttune_DB.iconView then
			FTAttune_IconViewScroll(delta)
			return
		end
		if wheel then wheel(frame, delta) end
	end)
	local origRelease = widget.OnRelease
	widget.OnRelease = function(self)
		if self.attuneViewToggle then self.attuneViewToggle:Hide() end
		if origRelease then origRelease(self) end
	end
end


-------------------------------------------------------------------------

function FTAttune_SaveTreeExpandStatus()
	local tree = attunelocal_treeframe
	-- A released TreeGroup goes back into AceGUI's pool. Skip it so a reload
	-- cannot copy another tree's groups over this character's saved state.
	if tree == nil or tree.tree ~= attunelocal_tree then return end
	local groups = (tree.status or tree.localstatus).groups
	if groups == nil then return end
	if FTAttuneTreeExpandStatus == nil then FTAttuneTreeExpandStatus = {} end
	for lineId, expanded in pairs(groups) do
		if expanded then FTAttuneTreeExpandStatus[lineId] = 1 else FTAttuneTreeExpandStatus[lineId] = 0 end
	end
end

function FTAttune:PLAYER_LOGOUT()
	FTAttune_SaveTreeExpandStatus()
end


-------------------------------------------------------------------------
-- Client bronze portrait frame (same template as Cooking / profession windows)
-------------------------------------------------------------------------

local attunelocal_bronzeChrome
local ATTUNE_PORTRAIT_ATTUNE = "Interface\\Icons\\INV_Scroll_03"

local function FTAttune_ResultsPortrait()
	if UnitFactionGroup("player") == "Horde" then
		return "Interface\\Icons\\INV_BannerPVP_01"
	end
	return "Interface\\Icons\\INV_BannerPVP_02"
end

local function FTAttune_SetPortraitTexture(chrome, texture)
	if not chrome or not texture then return end
	if chrome.SetPortraitToAsset then
		chrome:SetPortraitToAsset(texture)
		return
	end
	if chrome.SetPortraitTextureRaw then
		chrome:SetPortraitTextureRaw(texture)
		return
	end
	local candidates = {
		chrome.PortraitContainer and chrome.PortraitContainer.portrait,
		chrome.portrait and (chrome.portrait.portrait or chrome.portrait),
		chrome.Portrait,
	}
	for _, tex in ipairs(candidates) do
		if tex and tex.SetTexture then
			if SetPortraitToTexture then
				pcall(SetPortraitToTexture, tex, texture)
			else
				tex:SetTexture(texture)
			end
			return
		end
	end
end

local function FTAttune_SetChromeTitle(chrome, text)
	if not chrome then return end
	if chrome.SetTitle then
		chrome:SetTitle(text)
		return
	end
	if chrome.TitleContainer and chrome.TitleContainer.TitleText then
		chrome.TitleContainer.TitleText:SetText(text)
	elseif chrome.TitleText and chrome.TitleText.SetText then
		chrome.TitleText:SetText(text)
	end
end

local function FTAttune_HideLegacyArt(frame)
	if frame.SetBackdrop then
		pcall(frame.SetBackdrop, frame, nil)
	end
	local regions = { frame:GetRegions() }
	for _, region in ipairs(regions) do
		if region.GetObjectType and region:GetObjectType() == "Texture" then
			region:Hide()
		end
	end
end

local function FTAttune_RaisePiece(piece, level)
	if piece and piece.SetFrameLevel then
		piece:SetFrameLevel(level)
	end
end

function FTAttune_UpdateWindowPortrait()
	if not attunelocal_bronzeChrome then return end
	if attunelocal_treeIsShown then
		FTAttune_SetPortraitTexture(attunelocal_bronzeChrome, ATTUNE_PORTRAIT_ATTUNE)
	else
		FTAttune_SetPortraitTexture(attunelocal_bronzeChrome, FTAttune_ResultsPortrait())
	end
	FTAttune_SetChromeTitle(attunelocal_bronzeChrome, "ForeverTools – Attune")
end

local function FTAttune_ApplyBronzeChrome(host)
	if not host or attunelocal_bronzeChrome then return end
	local ok, chrome = pcall(CreateFrame, "Frame", "FTAttuneBronzeChrome", host, "PortraitFrameTemplate")
	if not ok or type(chrome) ~= "table" then return end

	chrome:SetAllPoints(host)
	chrome:SetMovable(false)
	chrome:SetScript("OnMouseDown", nil)
	chrome:SetScript("OnDragStart", nil)
	chrome:SetFrameStrata(host:GetFrameStrata())
	chrome:SetFrameLevel(host:GetFrameLevel() + 1)
	FTAttune_HideLegacyArt(host)

	if attunelocal_frame and attunelocal_frame.titletext then
		local oldTitle = attunelocal_frame.titletext:GetParent()
		if oldTitle then oldTitle:Hide() end
	end
	if attunelocal_frame and attunelocal_frame.titlebg then
		attunelocal_frame.titlebg:Hide()
	end

	local top = chrome:GetFrameLevel() or 1
	for _, child in ipairs({ host:GetChildren() }) do
		if child ~= chrome and child.SetFrameLevel then
			child:SetFrameLevel(top + 10)
		end
	end
	-- PortraitFrameTemplate puts the border hundreds of levels above the title.
	-- Raising the title only a little leaves the text under that border.
	local borderLevel = (chrome.NineSlice and chrome.NineSlice:GetFrameLevel()) or top
	FTAttune_RaisePiece(chrome.PortraitContainer or chrome.portrait, top + 40)
	FTAttune_RaisePiece(chrome.TitleContainer, borderLevel + 10)
	FTAttune_RaisePiece(chrome.CloseButton, borderLevel + 11)

	if chrome.TitleContainer then
		chrome.TitleContainer:EnableMouse(true)
		chrome.TitleContainer:SetScript("OnMouseDown", function()
			host:StartMoving()
		end)
		chrome.TitleContainer:SetScript("OnMouseUp", function()
			host:StopMovingOrSizing()
			local widget = attunelocal_frame
			if widget then
				local status = widget.status or widget.localstatus
				if status then
					status.top = host:GetTop()
					status.left = host:GetLeft()
				end
			end
		end)
	end

	if chrome.CloseButton then
		chrome.CloseButton:SetScript("OnClick", function()
			if attunelocal_survey_frame and attunelocal_survey_frame.frame then
				attunelocal_survey_frame.frame:Hide()
			end
			attunelocal_frame:Hide()
			FTAttune_SaveTreeExpandStatus()
			FTAttune_Release()
		end)
	end

	attunelocal_bronzeChrome = chrome
	if attunelocal_frame and attunelocal_frame.content then
		-- PortraitFrameTemplate title is taller than AceGUI's header. Size comes
		-- from these two corners only; an extra SetHeight collapses the pane.
		local content = attunelocal_frame.content
		content:ClearAllPoints()
		content:SetPoint("TOPLEFT", host, "TOPLEFT", 16, -58)
		content:SetPoint("BOTTOMRIGHT", host, "BOTTOMRIGHT", -17, 40)
	end
	local portraitPiece = chrome.PortraitContainer or chrome.portrait
	if portraitPiece and portraitPiece.EnableMouse then
		portraitPiece:EnableMouse(false)
	end
end

-- Bronze border for the quest-reward panel. No portrait: that icon belongs to the main window.
local function FTAttune_ApplyButtonChrome(host, onClose)
	local ok, chrome = pcall(CreateFrame, "Frame", nil, host, "ButtonFrameTemplate")
	if not ok or type(chrome) ~= "table" then return nil end

	chrome:SetAllPoints(host)
	chrome:SetMovable(false)
	chrome:SetScript("OnMouseDown", nil)
	chrome:SetScript("OnDragStart", nil)
	chrome:SetFrameStrata(host:GetFrameStrata())
	chrome:SetFrameLevel(host:GetFrameLevel() + 1)
	FTAttune_HideLegacyArt(host)

	local above = (chrome:GetFrameLevel() or 1) + 10
	for _, child in ipairs({ host:GetChildren() }) do
		if child ~= chrome and child.SetFrameLevel then
			child:SetFrameLevel(above)
		end
	end
	if chrome.PortraitContainer then chrome.PortraitContainer:Hide() end
	if chrome.portrait and chrome.portrait.Hide then chrome.portrait:Hide() end
	local borderLevel = (chrome.NineSlice and chrome.NineSlice:GetFrameLevel()) or above
	FTAttune_RaisePiece(chrome.TitleContainer, borderLevel + 10)
	FTAttune_RaisePiece(chrome.CloseButton, borderLevel + 11)
	if chrome.CloseButton and onClose then
		chrome.CloseButton:SetScript("OnClick", onClose)
	end
	return chrome
end

-------------------------------------------------------------------------
-- Create the Main UI Frame
-------------------------------------------------------------------------

function FTAttune_Frame()

	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then attunelocal_myguild = guildName end


	attunelocal_frame = FTAttune_AceCreate("Frame", "FTAttuneFrame")
	attunelocal_frame:SetTitle("  ForeverTools – Attune")
	attunelocal_frame:SetStatusText(attunelocal_statusText)

	--print(attunelocal_frame.frame:GetAlpha())
	--attunelocal_raidspotIcon[found].frame:SetAlpha(0.25)
	attunelocal_frame:SetStatusText(attunelocal_statusText)

	attunelocal_frame:SetLayout("FTAttuneFill")
	attunelocal_frame:SetHeight(FTAttune_DB.height)
	attunelocal_frame:SetWidth(FTAttune_DB.width)

	-- Hook, so AceGUI still hears the resize and refills the tree.
	attunelocal_frame.frame:HookScript("OnSizeChanged", function(self)
		if self.attuneSizing then return end
		local hh = self:GetHeight()
		local ww = self:GetWidth()
		local parent = self:GetParent()
		if parent then
			local maxH = parent:GetHeight() - 50
			local maxW = parent:GetWidth() - 50
			if maxH > 0 and hh > maxH then hh = maxH end
			if maxW > 0 and ww > maxW then ww = maxW end
			if hh ~= self:GetHeight() or ww ~= self:GetWidth() then
				self.attuneSizing = true
				self:SetHeight(hh)
				self:SetWidth(ww)
				self.attuneSizing = false
			end
		end
		FTAttune_DB.height = hh
		FTAttune_DB.width = ww
	end)


	--attunelocal_frame.frame:SetHeight(FTAttune_DB.height)
	--attunelocal_frame.frame:SetWidth(FTAttune_DB.width)

	if attunelocal_frame.frame.SetResizeBounds then
		attunelocal_frame.frame:SetResizeBounds(1010, 550)
	else
		attunelocal_frame.frame:SetMinResize(1010, 550)
	end
	attunelocal_frame.frame:SetFrameStrata("HIGH")
	-- Escape hides this frame through UISpecialFrames and does not run the Close button.
	attunelocal_frame.frame:HookScript("OnHide", function()
		FTAttune_SaveTreeExpandStatus()
		-- Quest loot and the quest-giver map sit on top of the tree. Dismiss them with the window.
		if FTAttune_HideQuestDetail then FTAttune_HideQuestDetail() end
	end)
	attunelocal_frame.frame:HookScript("OnShow", function()
		if attunelocal_panelDirty then FTAttune_RefreshAttunePanel() end
	end)


	-- Hacking into the Ace3 frame to reduce the size of the statusbox, to allow us room for other buttons
	local closebutton, statusbg, _, _, _, _, _ = attunelocal_frame.content.obj.frame:GetChildren()
	statusbg:ClearAllPoints()
	statusbg:SetPoint("BOTTOMLEFT", 15, 15)     -- taken from AceGUIContainer-Frame.lua
	statusbg:SetPoint("BOTTOMRIGHT", -280, 15)  -- taken from AceGUIContainer-Frame.lua, modified from -132

	closebutton:SetWidth(80)
	closebutton:SetScript("OnClick", function()
		-- attunelocal_export_frame.frame:Hide() -- close other submenu
		attunelocal_survey_frame.frame:Hide() -- close other submenu
		attunelocal_frame:Hide()
		FTAttune_SaveTreeExpandStatus()
		FTAttune_Release()
	end)


	-- SURVEY BUTTON
	local surveybutton = CreateFrame("Button", nil, attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	surveybutton:SetPoint("BOTTOMRIGHT", -193, 17)
	surveybutton:SetFrameStrata("DIALOG")
	surveybutton:SetHeight(20)
	surveybutton:SetWidth(80)
	surveybutton:SetText(FTAttuneLang["Survey"])
	--if attunelocal_myguild == "" then surveybutton:Disable() end
	surveybutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(FTAttuneLang["Survey_DESC"]) end)
	surveybutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	surveybutton:SetScript("OnClick", function()
		if attunelocal_survey_frame.frame:IsShown() then
			attunelocal_survey_frame.frame:Hide()
		else
			-- attunelocal_export_frame.frame:Hide() -- close other submenu
			attunelocal_survey_frame.frame:Show()
		end
	end)

	-- SURVEY SUB MENU
		attunelocal_survey_frame = FTAttune_AceCreate("InlineGroup")
		attunelocal_survey_frame:SetLayout("Flow")
		attunelocal_survey_frame:SetWidth(160)
		attunelocal_survey_frame:SetPoint("TOPLEFT", surveybutton,"BOTTOMLEFT", 0, 10)
		attunelocal_survey_frame.frame:Hide()

		local surveyTarget = FTAttune_AceCreate("Button")
		surveyTarget:SetText(FTAttuneLang["Target"])
		surveyTarget:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			if not UnitExists("target") then
				attunelocal_frame:SetStatusText(FTAttuneLang["No Target"])
				C_Timer.After(3, function()
					attunelocal_frame:SetStatusText(attunelocal_statusText)
				end)
			else
                local targetFirst, targetLast = UnitName("target")
				FTAttune_SendRequest("Target|" .. targetFirst .. " " .. targetLast)
			end
		end)
		attunelocal_survey_frame:AddChild(surveyTarget)

		local surveyGuild = FTAttune_AceCreate("Button")
		surveyGuild:SetText(FTAttuneLang["Guild"])
		surveyGuild:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			FTAttune_SendRequest("Guild")
		end)
		attunelocal_survey_frame:AddChild(surveyGuild)

		local surveyParty = FTAttune_AceCreate("Button")
		surveyParty:SetText(FTAttuneLang["Party"])
		surveyParty:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			FTAttune_SendRequest("Party")
		end)
		attunelocal_survey_frame:AddChild(surveyParty)

		local surveyRaid = FTAttune_AceCreate("Button")
		surveyRaid:SetText(FTAttuneLang["Raid"])
		surveyRaid:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			FTAttune_SendRequest("Raid")
		end)
		attunelocal_survey_frame:AddChild(surveyRaid)

		local surveyClose = FTAttune_AceCreate("Button")
		surveyClose:SetText(FTAttuneLang["Close"])
		surveyClose:SetCallback("OnClick", function(slid)	attunelocal_survey_frame.frame:Hide()	end)
		attunelocal_survey_frame:AddChild(surveyClose)

	-- -- EXPORT BUTTON
	-- local exportbutton = CreateFrame("Button", nil, attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	-- exportbutton:SetPoint("BOTTOMRIGHT", -193, 17)
	-- exportbutton:SetFrameStrata("DIALOG")
	-- exportbutton:SetHeight(20)
	-- exportbutton:SetWidth(80)
	-- exportbutton:SetText(FTAttuneLang["Export"])
	-- exportbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(FTAttuneLang["Export_DESC"]) end)
	-- exportbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	-- exportbutton:SetScript("OnClick", function()

	-- 	if attunelocal_export_frame.frame:IsShown() then
	-- 		attunelocal_export_frame.frame:Hide()
	-- 	else
	-- 		attunelocal_survey_frame.frame:Hide() -- close other submenu
	-- 		attunelocal_export_frame.frame:Show()
	-- 	end
	-- end)

	-- -- EXPORT SUB MENU
	-- 	attunelocal_export_frame = FTAttune_AceCreate("InlineGroup")
	-- 	attunelocal_export_frame:SetLayout("Flow")
	-- 	attunelocal_export_frame:SetWidth(160)
	-- 	attunelocal_export_frame:SetPoint("TOPLEFT", exportbutton,"BOTTOMLEFT", 0, 10)
	-- 	attunelocal_export_frame.frame:Hide()

	-- 	local exportThisToon = FTAttune_AceCreate("Button")
	-- 	exportThisToon:SetText(FTAttuneLang["This Toon"])
	-- 	exportThisToon:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 0
	-- 		FTAttune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportThisToon)

	-- 	local exportMyData = FTAttune_AceCreate("Button")
	-- 	exportMyData:SetText(FTAttuneLang["My Data"])
	-- 	exportMyData:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 4
	-- 		FTAttune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportMyData)

	-- 	local exportLastSurvey = FTAttune_AceCreate("Button")
	-- 	exportLastSurvey:SetText(FTAttuneLang["Last Survey"])
	-- 	exportLastSurvey:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 1
	-- 		FTAttune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportLastSurvey)

	-- 	local exportGuildData = FTAttune_AceCreate("Button")
	-- 	exportGuildData:SetText(FTAttuneLang["Guild Data"])
	-- 	exportGuildData:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 2
	-- 		FTAttune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportGuildData)

	-- 	local exportAll = FTAttune_AceCreate("Button")
	-- 	exportAll:SetText(FTAttuneLang["All Data"])
	-- 	exportAll:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 3
	-- 		FTAttune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportAll)

	-- 	local exportClose = FTAttune_AceCreate("Button")
	-- 	exportClose:SetText(FTAttuneLang["Close"])
	-- 	exportClose:SetCallback("OnClick", function()	attunelocal_export_frame.frame:Hide()	end)
	-- 	attunelocal_export_frame:AddChild(exportClose)

	-- RESULTS BUTTON
	local guildbutton = CreateFrame("Button", "GuildButton", attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	guildbutton:SetPoint("BOTTOMRIGHT", -110, 17)
	guildbutton:SetFrameStrata("DIALOG")
	guildbutton:SetHeight(20)
	guildbutton:SetWidth(80)
	guildbutton:SetText(FTAttuneLang["Results"])
	--if attunelocal_myguild == "" then guildbutton:Disable() end
	guildbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(FTAttuneLang["Toggle_DESC"]) end)
	guildbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	guildbutton:SetScript("OnClick", function()
		-- attunelocal_export_frame.frame:Hide() -- close other submenu
		attunelocal_survey_frame.frame:Hide() -- close other submenu
		FTAttune_ToggleView()

	end)


	-- -- PLANNER BUTTON
	-- local plannerbutton = CreateFrame("Button", "GuildButton", attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	-- plannerbutton:SetPoint("BOTTOMRIGHT", -110, 17)
	-- plannerbutton:SetFrameStrata("DIALOG")
	-- plannerbutton:SetHeight(20)
	-- plannerbutton:SetWidth(80)
	-- plannerbutton:SetText(FTAttuneLang["Planner"])
	-- --if attunelocal_myguild == "" then plannerbutton:Disable() end
	-- plannerbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(FTAttuneLang["Open Raid Planner"]) end)
	-- plannerbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	-- plannerbutton:SetScript("OnClick", function()
    --     -- close main frame
	-- 	attunelocal_survey_frame.frame:Hide() -- close other submenu
	-- 	attunelocal_frame:Hide()
	-- 	FTAttune_SaveTreeExpandStatus()
	-- 	FTAttune_Release()

    --     --- open raid planner
    --     if attunelocal_raidframe ~= nil then
	-- 		if attunelocal_raidframe:IsShown() then 
	-- 			attunelocal_raidframe:Hide() 
	-- 		else
	-- 			FTAttune_RaidPlannerFrame()
	-- 		end
	-- 	else 
	-- 		FTAttune_RaidPlannerFrame()
	-- 	end

	-- end)


    -- Register the global variable `FTAttune_MainFrame` as a "special frame"
    -- so that it is closed when the escape key is pressed.
	_G["FTAttune_MainFrame"] = attunelocal_frame.frame
    tinsert(UISpecialFrames, "FTAttune_MainFrame")
	-- _G["FTAttune_ExportMenuFrame"] = attunelocal_export_frame.frame
    -- tinsert(UISpecialFrames, "FTAttune_ExportMenuFrame")
	_G["FTAttune_SurveyMenuFrame"] = attunelocal_survey_frame.frame
    tinsert(UISpecialFrames, "FTAttune_SurveyMenuFrame")

	FTAttune_ApplyBronzeChrome(attunelocal_frame.frame)
	FTAttune_ToggleView()

end

-------------------------------------------------------------------------
-- Display the attune after it being selected in tree
-------------------------------------------------------------------------

-- Classic instance loading screens (Interface\Glues\LoadingScreens), file data IDs.
-- Hall of Thanes has no screen of its own; Deeprun Tram is the underground Ironforge art.
-- Ruins of Lordaeron uses the Blizzard loading screen of those ruins.
local ATTUNE_DUNGEON_ART = {
	["160"] = 131862, -- Ragefire Chasm
	["163"] = 131834, -- Hall of Thanes
	["166"] = 131834,
	["170"] = 131833, -- The Deadmines
	["177"] = 131882, -- Wailing Caverns
	["180"] = 131882,
	["183"] = 131867, -- Ruins of Lordaeron
	["186"] = 131867,
	["190"] = 131869, -- Shadowfang Keep
	["195"] = 7963777, -- Excavation Site: Wetlands (Forever)
	["196"] = 7963777,
	["200"] = 131823, -- Blackfathom Deeps
	["210"] = 131823,
	["220"] = 131870, -- The Stockade
	["230"] = 131841, -- Gnomeregan
	["240"] = 131841,
	["250"] = 131865, -- Razorfen Kraul
	["251"] = 131865,
	["260"] = 131852, -- Scarlet Monastery
	["270"] = 131852,
	["280"] = 131864, -- Razorfen Downs
	["290"] = 131864,
	["300"] = 131850, -- Maraudon
	["310"] = 131850,
	["320"] = 131876, -- Uldaman
	["330"] = 131876,
	["340"] = 131835, -- Dire Maul
	["350"] = 131885, -- Zul'Farrak
	["351"] = 131885,
	["360"] = 131871, -- Stratholme
	["361"] = 131871,
	["370"] = 131872, -- Temple of Atal'Hakkar
	["380"] = 131872,
	["390"] = 131824, -- Blackrock Depths
	["400"] = 131824,
	["410"] = 131868, -- Scholomance
	["420"] = 131868,
	["120"] = 131824, -- Blackrock Depths (key)
	["140"] = 131868, -- Scholomance (key)
	["150"] = 131868,
}
local ATTUNE_DUNGEON_ART_ALPHA = 0.08

local function FTAttune_LayoutDungeonArt()
	local tex = attunelocal_dungeonArt
	local parent = tex and tex:GetParent()
	if not tex or not parent or not tex:IsShown() then return end
	tex:ClearAllPoints()
	tex:SetAllPoints(parent)
	-- Crop the top and bottom 20%, then stretch the middle 60% over the panel.
	tex:SetTexCoord(0, 1, 0.22, 0.80)
end

local function FTAttune_HideDungeonArt()
	if not attunelocal_dungeonArt then return end
	attunelocal_dungeonArt:Hide()
	attunelocal_dungeonArt:SetTexture(nil)
end

local function FTAttune_ShowDungeonArt(attuneId)
	-- Outer widget frame, not the ScrollFrame: art stays put and is not clipped with the quest list.
	local parent = attunelocal_scroll and attunelocal_scroll.frame
	if not parent then return end
	if not attunelocal_dungeonArt or attunelocal_dungeonArt:GetParent() ~= parent then
		FTAttune_HideDungeonArt()
		local tex = parent:CreateTexture(nil, "BACKGROUND")
		tex:SetAlpha(ATTUNE_DUNGEON_ART_ALPHA)
		tex:Hide()
		attunelocal_dungeonArt = tex
		if not parent.attuneArtSized then
			local prev = parent:GetScript("OnSizeChanged")
			parent:SetScript("OnSizeChanged", function(self, ...)
				if prev then prev(self, ...) end
				FTAttune_LayoutDungeonArt()
			end)
			parent.attuneArtSized = true
		end
	end
	local fdid = ATTUNE_DUNGEON_ART[tostring(attuneId)]
	if not fdid then
		attunelocal_dungeonArt:Hide()
		return
	end
	attunelocal_dungeonArt:SetTexture(fdid)
	attunelocal_dungeonArt:SetAlpha(ATTUNE_DUNGEON_ART_ALPHA)
	attunelocal_dungeonArt:Show()
	FTAttune_LayoutDungeonArt()
end

local function FTAttune_ShowWorkInProgress(show)
	if not show then
		if attunelocal_wipFrame then
			attunelocal_wipFrame:Hide()
		end
		return
	end
	local parent = attunelocal_scroll and attunelocal_scroll.frame
	if not parent then return end
	if not attunelocal_wipFrame then
		local holder = CreateFrame("Frame", nil, parent)
		holder:SetAllPoints(parent)
		holder:EnableMouse(false)
		local fs = holder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		fs:SetPoint("CENTER", holder, "CENTER", 0, 0)
		fs:SetJustifyH("CENTER")
		fs:SetFont(GameFontNormal:GetFont(), 22, "")
		fs:SetTextColor(1, 0.82, 0)
		fs:SetShadowColor(0, 0, 0, 1)
		fs:SetShadowOffset(1, -1)
		holder.text = fs
		attunelocal_wipFrame = holder
	end
	if attunelocal_wipFrame:GetParent() ~= parent then
		attunelocal_wipFrame:SetParent(parent)
		attunelocal_wipFrame:SetAllPoints(parent)
	end
	attunelocal_wipFrame:SetFrameLevel((parent:GetFrameLevel() or 0) + 30)
	attunelocal_wipFrame.text:SetText(FTAttuneLang["Work in progress"] or "Work in progress")
	if show then
		attunelocal_wipFrame:Show()
	else
		attunelocal_wipFrame:Hide()
	end
end

function FTAttune_Select(attuneId, quiet)
	if not quiet then PlaySound(856) end --igMainMenuOptionCheckBoxOn
	local keepPan = quiet and (attunelocal_graphPanX or 0) or 0
	local keepScroll
	if quiet and attunelocal_scroll and attunelocal_scroll.scrollframe then
		keepScroll = attunelocal_scroll.scrollframe:GetVerticalScroll()
	end
	FTAttune_ShowDungeonArt(attuneId)
	FTAttune_AutoCompleteSpacers(attunelocal_charKey)
	local scrollframe = attunelocal_scroll.content.obj.content

	attunelocal_scroll:ReleaseChildren()

	local att = FTAttune_DB.toons[attunelocal_charKey]

	-- Display Title
	for i, a in pairs(FTAttune_Data.attunes) do
		if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) then 
			if (a.ID == attuneId) then

				attunelocal_brokerlabel = a.NAME
				if FTAttune_DB.toons[attunelocal_charKey].attuned[attuneId] ~= nil then
					attunelocal_brokervalue = FTAttune_DB.toons[attunelocal_charKey].attuned[attuneId].."%"
				else
					attunelocal_brokervalue = "0%"
				end
				FTAttune_Broker.text = attunelocal_brokervalue

				local titlebutton = FTAttune_AceCreate("SimpleGroup")
				titlebutton:SetLayout("Flow")
				titlebutton:SetFullWidth(true)

					local label = FTAttune_AceCreate("Label")
					label:SetText(FTAttune_DisplayName(a))
					label:SetImage(a.ICON)
					label:SetFont(GameFontNormal:GetFont(), 24, "")
					label:SetImageSize(32,32)
					label:SetFullWidth(true)
					titlebutton:AddChild(label)


				attunelocal_scroll:AddChild(titlebutton)

				-- spacer
				local label = FTAttune_AceCreate("Label")
				label:SetText(" ")
				label:SetFullWidth(true)
				label:SetFont(GameFontHighlight:GetFont(), 20, "")
				attunelocal_scroll:AddChild(label)

				-- desc
				local label = FTAttune_AceCreate("Label")
				label:SetText(a.DESC)
				label:SetFullWidth(true)
				label:SetFont(GameFontNormal:GetFont(), 12, "")
				attunelocal_scroll:AddChild(label)
			end
		end
	end

	-- spacer
	local label = FTAttune_AceCreate("Label")
	label:SetText(" ")
	label:SetFullWidth(true)
	label:SetFont(GameFontHighlight:GetFont(), 20, "")
	attunelocal_scroll:AddChild(label)

	-- Header height in scroll-content pixels. Applied later divided by zoom, because
	-- SetPoint offsets are in the scaled graph's own space.
	if attunelocal_scroll.DoLayout then attunelocal_scroll:DoLayout() end
	attunelocal_graphHeaderOffset = 80
	do
		local st = scrollframe:GetTop()
		if st then
			local maxDist = 0
			for _, child in ipairs(attunelocal_scroll.children or {}) do
				local f = child.frame
				if f and f:IsShown() then
					local b = f:GetBottom()
					if b then
						local d = st - b
						if d > maxDist then maxDist = d end
					end
				end
			end
			if maxDist > 0 then attunelocal_graphHeaderOffset = maxDist + 8 end
		end
	end

	-- Hiding all non-Ace frames (all attune steps basically)
	for i, f in pairs(attunelocal_frames) do	_G[f]:Hide()	end
	if _G["FTAttune_SideBox"] then _G["FTAttune_SideBox"]:Hide() end
	if _G["FTAttune_SideBoxTitle"] then _G["FTAttune_SideBoxTitle"]:Hide() end

	-- Scaled container for the attune chain (icons, text, lines zoom together)
	if attunelocal_graphRoot == nil then
		attunelocal_graphRoot = CreateFrame("Frame", "FTAttune_GraphRoot", scrollframe)
	else
		attunelocal_graphRoot:SetParent(scrollframe)
	end
	attunelocal_graphPanX = keepPan
	attunelocal_graphRoot:SetWidth(1)
	attunelocal_graphRoot:SetHeight(1)
	attunelocal_graphRoot:SetScale(FTAttune_DB.zoom)
	FTAttune_ApplyGraphPan()
	attunelocal_graphRoot:Show()

	-- Count steps per stage (main chain only; SIDE reminders are placed beside End)
	local stageSteps = {}
	local stageWidthSum = {}
	local sideSteps = {}
	local endInfo = nil
	local chain = FTAttune_Data.stepsByAttune and FTAttune_Data.stepsByAttune[attuneId]
	local chainSteps = chain or FTAttune_Data.steps
	for i, s in pairs(chainSteps) do
		if (chain ~= nil or s.ID_ATTUNE == attuneId) and showPatchStep(s) then
			if s.SIDE then
				table.insert(sideSteps, s)
			else
				stageSteps[s.STAGE] = (stageSteps[s.STAGE] or 0) + 1
				stageWidthSum[s.STAGE] = (stageWidthSum[s.STAGE] or 0) + FTAttune_NodeWidth(s)
			end
		end
	end

	-- Half-width of the widest main stage (for pan limits); SIDE width added later
	attunelocal_graphMaxExtent = 0
	for stage, count in pairs(stageSteps) do
		local rowW = stageWidthSum[stage] + math.max(0, count - 1) * attunelocal_Node_HGap
		local half = rowW / 2
		if half > attunelocal_graphMaxExtent then attunelocal_graphMaxExtent = half end
	end

	if next(stageSteps) == nil then
		attunelocal_graphRoot:Hide()
		FTAttune_ShowWorkInProgress(true)
		attunelocal_scroll.frame:SetScript("OnUpdate", nil)
		return
	end
	FTAttune_ShowWorkInProgress(false)

	-- Create/position main-chain steps (defer End until SIDE nodes exist for line anchors)
	-- First stage stays at yy=0: top margin is the unscaled header offset outside the zoomed graph.
	-- Steps are visited right-to-left; consumed walks inward from the right edge so HALFSIZE slots pack tighter.
	local yy = 0
	local curStage = 0
	local consumed = 0
	local rightEdge = 0
	local firstStage = true
	local rowPlaced = {}
	local orLabels = {}
	-- OR sits in the existing gap between neighboring steps on this stage that both have OR=true.
	local function flushOrRow()
		for i = 1, #rowPlaced - 1 do
			local rightN = rowPlaced[i]
			local leftN = rowPlaced[i + 1]
			if rightN.orChoice and leftN.orChoice then
				local midX = ((rightN.x - rightN.w / 2) + (leftN.x + leftN.w / 2)) / 2
				orLabels[#orLabels + 1] = { x = midX, y = rightN.y }
			end
		end
		rowPlaced = {}
	end
	for i, s in FTAttune_spairs(chainSteps, function(t,a,b) 	return tonumber(t[b].STAGE)*10000 + tonumber(t[b].ID) > tonumber(t[a].STAGE)*10000 + tonumber(t[a].ID) end) do
		if (chain ~= nil or s.ID_ATTUNE == attuneId) and showPatchStep(s) and not s.SIDE then
			if s.STAGE ~= curStage then
				flushOrRow()
				consumed = 0
				curStage = s.STAGE
				local count = stageSteps[s.STAGE]
				local rowW = stageWidthSum[s.STAGE] + math.max(0, count - 1) * attunelocal_Node_HGap
				rightEdge = rowW / 2
				if firstStage then
					firstStage = false
				else
					yy = yy + attunelocal_Node_VGap + attunelocal_Node_Height
				end
			end
			local w = FTAttune_NodeWidth(s)
			local xx = rightEdge - consumed - (w / 2)
			consumed = consumed + w + attunelocal_Node_HGap
			rowPlaced[#rowPlaced + 1] = { id = s.ID, x = xx, w = w, y = yy, orChoice = s.OR and true or false }

			if s.TYPE == "End" then
				endInfo = { step = s, xx = xx, yy = yy }
			else
				FTAttune_CreateNode(s, attunelocal_graphRoot, xx, yy)
			end
		end
	end
	flushOrRow()

	for i, spot in ipairs(orLabels) do
		local name = "FTAttune_OrLabel_"..i
		local exist = false
		for _, f in ipairs(attunelocal_frames) do if f == name then exist = true end end
		local holder
		if exist then
			holder = _G[name]
		else
			holder = CreateFrame("Frame", name, attunelocal_graphRoot)
			holder:EnableMouse(false)
			-- Above step frames and their toplevel icons.
			holder:SetToplevel(true)
			local function circleTex(layer)
				local tex = holder:CreateTexture(nil, layer)
				tex:SetTexture("Interface\\Buttons\\WHITE8X8")
				if tex.AddMaskTexture then
					local mask = holder:CreateMaskTexture()
					mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
					tex:AddMaskTexture(mask)
					tex.circleMask = mask
				else
					tex:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
				end
				return tex
			end
			holder.ring = circleTex("BACKGROUND")
			holder.ring:SetVertexColor(1, 0.82, 0, 0.65)
			holder.fill = circleTex("BORDER")
			holder.fill:SetVertexColor(0.06, 0.05, 0.04, 1)
			holder.label = holder:CreateFontString(nil, "OVERLAY")
			holder.label:SetPoint("CENTER", 2, 0)
			holder.label:SetJustifyH("CENTER")
			holder.label:SetJustifyV("MIDDLE")
			table.insert(attunelocal_frames, name)
		end
		holder:SetParent(attunelocal_graphRoot)
		holder:SetFrameLevel((attunelocal_graphRoot:GetFrameLevel() or 0) + 40)
		holder.label:SetFont(GameFontNormal:GetFont(), 8, "OUTLINE")
		holder.label:SetText("|cffffd100"..(FTAttuneLang["OR"] or "OR").."|r")
		holder:Show()
		local textW = holder.label:GetStringWidth() or 0
		local textH = holder.label:GetStringHeight() or 0
		local diameter = math.max(20, math.ceil(math.max(textW, textH) + 10))
		holder:SetSize(diameter, diameter)
		holder.ring:ClearAllPoints()
		holder.ring:SetPoint("CENTER")
		holder.ring:SetSize(diameter, diameter)
		if holder.ring.circleMask then holder.ring.circleMask:SetAllPoints(holder.ring) end
		local inner = math.max(4, diameter - 4)
		holder.fill:ClearAllPoints()
		holder.fill:SetPoint("CENTER")
		holder.fill:SetSize(inner, inner)
		if holder.fill.circleMask then holder.fill.circleMask:SetAllPoints(holder.fill) end
		holder:ClearAllPoints()
		holder:SetPoint("CENTER", attunelocal_graphRoot, "TOP", spot.x, -(spot.y + attunelocal_Node_Height / 2))
	end

	-- Inside-dungeon reminders: stacked in a box to the left of End, side connector into End
	if endInfo and #sideSteps > 0 then
		table.sort(sideSteps, function(a, b)
			if tonumber(a.STAGE) ~= tonumber(b.STAGE) then
				return tonumber(a.STAGE) < tonumber(b.STAGE)
			end
			return tonumber(a.ID) > tonumber(b.ID)
		end)

		local n = #sideSteps
		local pad = attunelocal_Side_Pad
		local sideVGap = attunelocal_Side_VGap
		local boxGap = attunelocal_Side_BoxGap
		local innerH = n * attunelocal_Node_Height + (n - 1) * sideVGap
		local boxW = attunelocal_Node_Width + pad * 2
		local boxH = innerH + pad * 2
		-- Drop Complete below the main chain so the Inside box has room (title + box)
		-- local endY = endInfo.yy + attunelocal_Node_VGap + attunelocal_Node_Height
        local endY = endInfo.yy + (attunelocal_Node_VGap + attunelocal_Node_Height) / 2
		local colX = endInfo.xx - (FTAttune_NodeWidth(endInfo.step) / 2 + boxGap + pad + attunelocal_Node_Width / 2)
		local firstY = endY

		-- Backdrop box behind the Inside quests
		local boxName = "FTAttune_SideBox"
		local existBox = false
		for _, f in ipairs(attunelocal_frames) do if f == boxName then existBox = true end end
		local sideBox
		if existBox then
			sideBox = _G[boxName]
		else
			sideBox = CreateFrame("Frame", boxName, attunelocal_graphRoot, BackdropTemplateMixin and "BackdropTemplate" or nil)
			table.insert(attunelocal_frames, boxName)
		end
		sideBox:SetParent(attunelocal_graphRoot)
		sideBox:SetWidth(boxW)
		sideBox:SetHeight(boxH)
		sideBox:ClearAllPoints()
		sideBox:SetPoint("TOP", attunelocal_graphRoot, "TOP", colX, -(firstY - pad))
		sideBox:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 3, right = 3, top = 3, bottom = 3 }
		})
		sideBox:SetBackdropColor(0.04, 0.04, 0.06, 0.55)
		sideBox:SetBackdropBorderColor(0.55, 0.55, 0.60, 0.95)
		sideBox:SetFrameLevel((attunelocal_graphRoot:GetFrameLevel() or 0) + 1)
		sideBox:Show()

		-- Title above the box
		local titleName = "FTAttune_SideBoxTitle"
		local existTitle = false
		for _, f in ipairs(attunelocal_frames) do if f == titleName then existTitle = true end end
		local sideTitle
		if existTitle then
			sideTitle = _G[titleName]
		else
			sideTitle = sideBox:CreateFontString(titleName)
			table.insert(attunelocal_frames, titleName)
		end
		sideTitle:SetFont(GameFontNormal:GetFont(), 10, "")
		sideTitle:SetText("|cffffd100"..(FTAttuneLang["Inside the dungeon"] or "Inside the dungeon").."|r")
		sideTitle:ClearAllPoints()
		sideTitle:SetPoint("BOTTOMLEFT", sideBox, "TOPLEFT", 6, 2)
		sideTitle:Show()

		for i, s in ipairs(sideSteps) do
			local sy = firstY + (i - 1) * (attunelocal_Node_Height + sideVGap)
			FTAttune_CreateNode(s, attunelocal_graphRoot, colX, sy)
			local node = _G["FTAttune_Node_"..s.ID]
			if node then
				node:SetFrameLevel((sideBox:GetFrameLevel() or 0) + 2)
			end
		end

		local sideExtent = math.abs(colX) + boxW / 2
		if sideExtent > attunelocal_graphMaxExtent then attunelocal_graphMaxExtent = sideExtent end

		local sideBottom = firstY + (n - 1) * (attunelocal_Node_Height + sideVGap) + attunelocal_Node_Height + pad
		local endBottom = endY + attunelocal_Node_Height
		local contentBottom = math.max(sideBottom, endBottom)
		-- Spacer below Complete / Inside
		contentBottom = contentBottom + attunelocal_Node_VGap + attunelocal_Node_Height
		if contentBottom > yy then yy = contentBottom end

		FTAttune_CreateNode(endInfo.step, attunelocal_graphRoot, endInfo.xx, endY)
		FTAttune_DrawSideFeeder(endInfo.step, sideSteps, colX, boxW, endInfo.xx, endY)
	elseif endInfo then
		FTAttune_CreateNode(endInfo.step, attunelocal_graphRoot, endInfo.xx, endInfo.yy)
		-- Spacer below Complete
		local endBottom = endInfo.yy + attunelocal_Node_Height + attunelocal_Node_VGap + attunelocal_Node_Height
		if endBottom > yy then yy = endBottom end
	end

	-- Ace 'mask' needed to trick the scroller into the right size, as it doesn't detect the custom frames.
	-- Chain height is scaled so the scrollbar matches the visual (zoomed) size.
	attunelocal_graphHeight = yy
	attunelocal_contentHeight = (yy * FTAttune_DB.zoom) + 50
	local mask = FTAttune_AceCreate("SimpleGroup")
	mask:SetAutoAdjustHeight(false)
	mask:SetHeight(attunelocal_contentHeight)
	mask:SetFullWidth(true)
	mask.frame:EnableMouse(true)
	mask.frame:SetScript("OnEnter", function()
		if attunelocal_frame then attunelocal_frame:SetStatusText(FTAttuneLang["Pan_DESC"] or attunelocal_statusText) end
	end)
	mask.frame:SetScript("OnLeave", function()
		if not attunelocal_graphDragging and attunelocal_frame then
			attunelocal_frame:SetStatusText(attunelocal_statusText)
		end
	end)
	FTAttune_SetupGraphPanTarget(mask.frame)
	attunelocal_scroll:AddChild(mask)

	FTAttune_UpdateGraphPanLimits()
	FTAttune_HookGraphPanMouseWheel()

	-- Viewport stays the full pane (Fill layout). The mask above is the scrollable
	-- chain height. Forcing the viewport to that height left short chains in the top half.
	attunelocal_scroll.frame:SetScript("OnUpdate", function(self)
		local w = attunelocal_scroll.scrollframe and attunelocal_scroll.scrollframe:GetWidth() or 0
		if self._attuneLastPanW ~= w then
			self._attuneLastPanW = w
			if not attunelocal_graphDragging then
				FTAttune_UpdateGraphPanLimits()
			end
		end
	end)

	if keepScroll and keepScroll > 0 then
		C_Timer.After(0, function()
			local sf = attunelocal_scroll and attunelocal_scroll.scrollframe
			if not sf or not sf.GetVerticalScrollRange then return end
			local range = sf:GetVerticalScrollRange() or 0
			-- Layout may not have a range yet. Clamping now would jump back to the top.
			if range <= 0 then return end
			local offset = keepScroll
			if offset > range then offset = range end
			sf:SetVerticalScroll(offset)
		end)
	end

end

-------------------------------------------------------------------------
-- Horizontal pan: apply offset / clamp to view
-------------------------------------------------------------------------

function FTAttune_ApplyGraphPan()
	if not attunelocal_graphRoot or not attunelocal_scroll then return end
	local scrollframe = attunelocal_scroll.content and attunelocal_scroll.content.obj and attunelocal_scroll.content.obj.content
	if not scrollframe then return end
	if attunelocal_graphPanX > attunelocal_graphMaxPanX then attunelocal_graphPanX = attunelocal_graphMaxPanX end
	if attunelocal_graphPanX < -attunelocal_graphMaxPanX then attunelocal_graphPanX = -attunelocal_graphMaxPanX end
	-- Offsets are in the graph frame's scaled space, so a lower zoom would otherwise
	-- pull the chain up into the unscaled title and description.
	local zoom = FTAttune_DB.zoom or 1
	if zoom < 0.01 then zoom = 0.01 end
	attunelocal_graphRoot:ClearAllPoints()
	attunelocal_graphRoot:SetPoint("TOP", scrollframe, "TOP", attunelocal_graphPanX / zoom, -((attunelocal_graphHeaderOffset or 0) / zoom))
end

function FTAttune_UpdateGraphPanLimits()
	if not attunelocal_scroll then return end
	local viewW = 400
	if attunelocal_scroll.scrollframe then
		viewW = attunelocal_scroll.scrollframe:GetWidth() or viewW
	elseif attunelocal_scroll.frame then
		viewW = attunelocal_scroll.frame:GetWidth() or viewW
	end
	local zoom = FTAttune_DB.zoom or 1
	-- How far past the view edge the widest stage extends (plus a little padding)
	attunelocal_graphMaxPanX = math.max(0, (attunelocal_graphMaxExtent * zoom) - (viewW / 2) + 60)
	FTAttune_ApplyGraphPan()
end

function FTAttune_StartGraphPan(frame)
	attunelocal_graphDragging = true
	local x, y = GetCursorPosition()
	attunelocal_graphDragLastX, attunelocal_graphDragLastY = x, y
	if frame then
		frame:SetScript("OnUpdate", FTAttune_GraphPan_OnUpdate)
	end
	if attunelocal_frame then
		attunelocal_frame:SetStatusText(FTAttuneLang["Pan_DESC"] or attunelocal_statusText)
	end
end

function FTAttune_StopGraphPan(frame)
	attunelocal_graphDragging = false
	if frame then
		frame:SetScript("OnUpdate", nil)
	end
	if attunelocal_frame then
		attunelocal_frame:SetStatusText(attunelocal_statusText)
	end
end

function FTAttune_GraphPan_OnUpdate(frame)
	if not attunelocal_graphDragging then return end
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	local dx = (x - attunelocal_graphDragLastX) / scale
	local dy = (y - attunelocal_graphDragLastY) / scale
	attunelocal_graphDragLastX, attunelocal_graphDragLastY = x, y

	attunelocal_graphPanX = attunelocal_graphPanX + dx
	FTAttune_ApplyGraphPan()

	-- Vertical: drag also moves the Ace scrollbar so the whole chain follows the cursor
	if attunelocal_scroll and attunelocal_scroll.scrollbar and attunelocal_scroll.scrollBarShown then
		local contentH = attunelocal_scroll.content:GetHeight() or 0
		local viewH = attunelocal_scroll.scrollframe:GetHeight() or 1
		local diff = contentH - viewH
		if diff > 0 then
			local status = attunelocal_scroll.status or attunelocal_scroll.localstatus
			local offset = (status and status.offset or 0) + dy
			if offset < 0 then offset = 0 end
			if offset > diff then offset = diff end
			local value = offset / diff * 1000
			attunelocal_scroll.scrollbar:SetValue(value)
		end
	end
end

function FTAttune_SetupGraphPanTarget(frame, keepMouseUp)
	if not frame then return end
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		FTAttune_StartGraphPan(self)
	end)
	frame:SetScript("OnDragStop", function(self)
		FTAttune_StopGraphPan(self)
	end)
	if not keepMouseUp then
		frame:SetScript("OnMouseUp", function(self)
			if attunelocal_graphDragging then FTAttune_StopGraphPan(self) end
		end)
	end
end

function FTAttune_HookGraphPanMouseWheel()
	if attunelocal_graphPanHooked or not attunelocal_scroll or not attunelocal_scroll.scrollframe then return end
	local sf = attunelocal_scroll.scrollframe
	local prev = sf:GetScript("OnMouseWheel")
	sf:SetScript("OnMouseWheel", function(frame, delta)
		if IsShiftKeyDown() then
			attunelocal_graphPanX = attunelocal_graphPanX + delta * 50
			FTAttune_UpdateGraphPanLimits()
		elseif prev then
			prev(frame, delta)
		end
	end)
	attunelocal_graphPanHooked = true
end

-------------------------------------------------------------------------
-- Apply zoom to the graph container and update scroll height (no rebuild)
-------------------------------------------------------------------------

function FTAttune_ApplyGraphZoom(zoom)
	if zoom < attunelocal_Zoom_Min then zoom = attunelocal_Zoom_Min end
	if zoom > attunelocal_Zoom_Max then zoom = attunelocal_Zoom_Max end
	FTAttune_DB.zoom = zoom
	if attunelocal_graphRoot then
		attunelocal_graphRoot:SetScale(zoom)
	end
	attunelocal_contentHeight = (attunelocal_graphHeight * zoom) + 50
	FTAttune_UpdateGraphPanLimits()
end

-------------------------------------------------------------------------
-- Fixed zoom slider overlay (top-right of the attune panel, does not scroll)
-------------------------------------------------------------------------

function FTAttune_ReleaseZoomSlider()
	if attunelocal_zoomSlider then
		attunelocal_zoomSlider:Release()
		attunelocal_zoomSlider = nil
	end
end

function FTAttune_CreateZoomSlider()
	FTAttune_ReleaseZoomSlider()
	local parent = attunelocal_scroll and attunelocal_scroll.frame or (attunelocal_right and attunelocal_right.frame)
	if not parent then return end

	local slider = FTAttune_AceCreate("Slider")
	slider:SetWidth(160)
	slider:SetHeight(44)
	slider:SetLabel(FTAttuneLang["Zoom"])
	slider:SetIsPercent(true)
	slider:SetSliderValues(attunelocal_Zoom_Min, attunelocal_Zoom_Max, attunelocal_Zoom_Step)
	slider:SetValue(FTAttune_DB.zoom)
	slider:SetCallback("OnValueChanged", function(slid)
		FTAttune_ApplyGraphZoom(slid:GetValue())
	end)

	local f = slider.frame
	f:SetParent(parent)
	f:ClearAllPoints()
	-- Outer scroll frame does not move with content; pin flush to its right edge
	f:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -26, -2)
	f:SetFrameStrata(parent:GetFrameStrata())
	f:SetFrameLevel((parent:GetFrameLevel() or 0) + 50)
	f:Show()

	attunelocal_zoomSlider = slider
end

-------------------------------------------------------------------------

function showPatchStep(s)
	local showStep = false
	if (s.VALIDFROM == nil and s.VALIDTO == nil) then 
		showStep = true
	else
		if (s.VALIDFROM ~= nil and patch >= s.VALIDFROM) then showStep = true end
		if (s.VALIDTO ~= nil and patch < s.VALIDTO) then showStep = true end
	end
	return showStep
end

-------------------------------------------------------------------------
-- Look up a step / detect SIDE (Inside) steps
-------------------------------------------------------------------------

function FTAttune_FindStep(attuneId, stepId)
	if attuneId == nil or stepId == nil then return nil end
	local byKey = FTAttune_Data.stepsByKey
	if byKey then
		return byKey[tostring(attuneId) .. "-" .. tostring(stepId)]
	end
	for _, s in pairs(FTAttune_Data.steps) do
		if s.ID_ATTUNE == attuneId and s.ID == tostring(stepId) then
			return s
		end
	end
	return nil
end

function FTAttune_IsSideStep(attuneId, stepId)
	local s = FTAttune_FindStep(attuneId, stepId)
	return s ~= nil and s.SIDE
end

-------------------------------------------------------------------------
-- Horizontal feeder from the Inside-quests box into the End node
-------------------------------------------------------------------------

function FTAttune_DrawSideFeeder(endStep, sideSteps, colX, boxW, endX, endY)
	local endNode = _G["FTAttune_Node_"..endStep.ID]
	if not endNode then return end

	local sideFollowIds = {}
	local fIDs = FTAttune_split(endStep.FOLLOWS, "&")
	if string.find(endStep.FOLLOWS, "|") then fIDs = FTAttune_split(endStep.FOLLOWS, "|") end
	for _, flw in pairs(fIDs) do
		if FTAttune_IsSideStep(endStep.ID_ATTUNE, flw) then
			table.insert(sideFollowIds, flw)
		end
	end
	if #sideFollowIds == 0 then return end

	local allDone, anyDone = true, false
	for _, flw in ipairs(sideFollowIds) do
		if FTAttune_DB.toons[attunelocal_charKey].done[endStep.ID_ATTUNE .. "-" .. flw] then
			anyDone = true
		else
			allDone = false
		end
	end

	local lineName = "FTAttune_SideFeeder_"..endStep.ID
	local exist = false
	for _, f in ipairs(attunelocal_frames) do if f == lineName then exist = true end end
	local line
	if exist then
		line = _G[lineName]
	else
		line = endNode:CreateLine(lineName)
		table.insert(attunelocal_frames, lineName)
	end

	local endDone = FTAttune_DB.toons[attunelocal_charKey].done[endStep.ID_ATTUNE .. "-" .. endStep.ID]
		or ((FTAttune_DB.toons[attunelocal_charKey].attuned[endStep.ID_ATTUNE] or 0) >= 100)
	if endDone and allDone then
		line:SetColorTexture(0.388, 0.686, 0.388, 1)
		line:SetDrawLayer("ARTWORK", 2)
	elseif anyDone then
		line:SetColorTexture(0.851, 0.608, 0.0, 1)
		line:SetDrawLayer("ARTWORK", 1)
	else
		line:SetColorTexture(0.45, 0.45, 0.45, 1)
		line:SetDrawLayer("ARTWORK", 0)
	end
	line:SetThickness(attunelocal_Line_Thickness)

	-- Horizontal: box right edge → End left edge, at End vertical mid
	local boxRightX = colX + boxW / 2
	local midY = -attunelocal_Node_Height / 2
	line:SetStartPoint("TOP", boxRightX - endX, midY)
	line:SetEndPoint("TOP", -FTAttune_NodeWidth(endStep) / 2, midY)
	line:Show()
end

-------------------------------------------------------------------------
-- Create the frame for a single attune step (node)
-------------------------------------------------------------------------

local attunelocal_mapNameCache

local function FTAttune_MapIdForName(name)
	if not name or name == "" or not C_Map or not C_Map.GetMapChildrenInfo then return nil end
	if not attunelocal_mapNameCache then
		attunelocal_mapNameCache = {}
		for _, root in ipairs({ 947, 1414, 1415, 1463, 1464 }) do
			local children = C_Map.GetMapChildrenInfo(root, nil, true)
			if children then
				for _, info in ipairs(children) do
					if info.name and not attunelocal_mapNameCache[info.name] then
						attunelocal_mapNameCache[info.name] = info.mapID
					end
				end
			end
		end
	end
	return attunelocal_mapNameCache[name]
end

local function FTAttune_QuestIdFromStep(step)
	local questId = tonumber(step.ID_WOWHEAD)
	if not questId and step.ID_WOWHEAD and string.find(step.ID_WOWHEAD, "|", 1, true) then
		questId = tonumber(FTAttune_split(step.ID_WOWHEAD, "|")[1])
	end
	return questId
end

local attunelocal_openedQuestMap

local function FTAttune_CloseQuestGiverMap()
	if not attunelocal_openedQuestMap then return end
	attunelocal_openedQuestMap = nil
	if WorldMapFrame and WorldMapFrame:IsShown() then
		if ToggleWorldMap then ToggleWorldMap() else WorldMapFrame:Hide() end
	end
end

local function FTAttune_ShowQuestGiverMap(step)
	local questId = FTAttune_QuestIdFromStep(step)
	local loc = questId and FTAttune_Data.questGivers and FTAttune_Data.questGivers[questId]
	local uiMapID = loc and loc[1]
	local x, y = loc and loc[2], loc and loc[3]
	if uiMapID and C_Map and C_Map.GetMapInfo and not C_Map.GetMapInfo(uiMapID) then
		uiMapID, x, y = nil, nil, nil
	end
	if not uiMapID then
		uiMapID = FTAttune_MapIdForName(step.LOCATION)
		x, y = nil, nil
	end
	if not uiMapID then return end

	local wasShown = WorldMapFrame and WorldMapFrame:IsShown()
	if OpenWorldMap then
		OpenWorldMap(uiMapID)
	elseif WorldMapFrame then
		if not wasShown then ToggleWorldMap() end
		if WorldMapFrame.SetMapID then WorldMapFrame:SetMapID(uiMapID) end
	end
	if not wasShown then attunelocal_openedQuestMap = true end

	if x and y and C_Map and C_Map.SetUserWaypoint and UiMapPoint and C_Map.CanSetUserWaypointOnMap and C_Map.CanSetUserWaypointOnMap(uiMapID) then
		C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(uiMapID, x / 100, y / 100))
		if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			C_SuperTrack.SetSuperTrackedUserWaypoint(true)
		end
	end
end

local attunelocal_giverTip
local attunelocal_giverTipGap = 6

local function FTAttune_HideQuestGiverTip()
	if attunelocal_giverTip then attunelocal_giverTip:Hide() end
end

local function FTAttune_ShowQuestGiverTip(step, anchor)
	local questId = FTAttune_QuestIdFromStep(step)
	local loc = questId and FTAttune_Data.questGivers and FTAttune_Data.questGivers[questId]
	local name = loc and loc[4]
	if not name or name == "" then
		name = FTAttuneLang["Q1_"..step.ID_WOWHEAD]
	end

	if not attunelocal_giverTip then
		attunelocal_giverTip = CreateFrame("GameTooltip", "FTAttuneGiverTip", UIParent, "GameTooltipTemplate")
		attunelocal_giverTip:SetFrameStrata("TOOLTIP")
	end

	local tip = attunelocal_giverTip
	local target = GameTooltip:GetWidth() or 0
	tip:SetOwner(anchor, "ANCHOR_NONE")
	tip:ClearLines()
	if tip.SetMinimumWidth then tip:SetMinimumWidth(0) end
	tip:SetText("|cffffffff"..FTAttuneLang["Starts at"].." |r"..(name or ""))
	tip:AddLine(FTAttuneLang["Click to show map"], 0.6, 0.6, 0.6, true)
	tip:Show()
	-- Match the quest tooltip's outer width unless this bubble's own text is already wider.
	-- SetMinimumWidth adds padding on top of the number you pass, so measure and correct once.
	local natural = tip:GetWidth() or 0
	if tip.SetMinimumWidth and target > 0 and natural > 0 and natural <= target + 1 then
		tip:SetMinimumWidth(target)
		tip:Show()
		local overshoot = (tip:GetWidth() or target) - target
		if math.abs(overshoot) > 1 then
			tip:SetMinimumWidth(math.max(1, target - overshoot))
			tip:Show()
		end
	end
	-- Showing a second tooltip can hide the quest summary. Put it back, then stack them.
	GameTooltip:Show()
	tip:ClearAllPoints()
	tip:SetPoint("TOPLEFT", anchor, "TOPRIGHT", 10, 0)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", tip, "BOTTOMLEFT", 0, -attunelocal_giverTipGap)
end

-- Quest and item cells do not use the "you are on this step" highlight.
-- Quests: grey until accepted. Pick Up and Quest cells are yellow while in the log. Turn In stays grey until the required items are in hand (then yellow) or the quest is complete (then green). When those items are in hand, Pick Up turns green too. A completed quest is green on Pick Up, Quest, and Turn In.
-- Items: grey at 0, yellow for a partial stack, green at the full count or when the quest they feed is complete.
local attuneFollowerCache

local function FTAttune_FollowIDs(follows)
	if follows == nil or follows == "" or follows == "0" then return {} end
	local sep = "&"
	if string.find(follows, "|", 1, true) then sep = "|" end
	return FTAttune_split(follows, sep)
end

local function FTAttune_FollowersOf(attuneId, stepId)
	if attuneFollowerCache == nil then
		attuneFollowerCache = {}
		for _, s in pairs(FTAttune_Data.steps) do
			if showPatchStep(s) then
				local byAttune = attuneFollowerCache[s.ID_ATTUNE]
				if byAttune == nil then
					byAttune = {}
					attuneFollowerCache[s.ID_ATTUNE] = byAttune
				end
				for _, flw in ipairs(FTAttune_FollowIDs(s.FOLLOWS)) do
					local list = byAttune[flw]
					if list == nil then
						list = {}
						byAttune[flw] = list
					end
					table.insert(list, s)
				end
			end
		end
	end
	local byAttune = attuneFollowerCache[attuneId]
	if byAttune == nil then return nil end
	return byAttune[tostring(stepId)]
end

local function FTAttune_SameQuestId(step, qid)
	if step.ID_WOWHEAD == nil then return false end
	local wanted = tostring(qid)
	if step.ID_WOWHEAD == wanted then return true end
	if string.find(step.ID_WOWHEAD, "|", 1, true) then
		for _, part in ipairs(FTAttune_split(step.ID_WOWHEAD, "|")) do
			if part == wanted then return true end
		end
	end
	return false
end

local function FTAttune_IsQuestFlaggedCompleted(qid)
	if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
		local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
		if ok and done then return true end
	end
	if IsQuestFlaggedCompleted then
		local ok, done = pcall(IsQuestFlaggedCompleted, qid)
		if ok and done then return true end
	end
	return false
end

-- A saved Quest or Turn In step counts as completion for every cell of that quest.
-- Pick Up is saved as done on accept, so its own flag is not completion.
local function FTAttune_QuestRecordedComplete(attuneId, qid, doneMap)
	if not doneMap or not attuneId then return false end
	local list = FTAttune_Data.stepsByTurnIn and FTAttune_Data.stepsByTurnIn[qid]
	if list then
		for _, s in ipairs(list) do
			if s.ID_ATTUNE == attuneId and doneMap[s.ID_ATTUNE .. "-" .. s.ID] then
				return true
			end
		end
		return false
	end
	for _, s in pairs(FTAttune_Data.steps) do
		if s.ID_ATTUNE == attuneId and (s.TYPE == "Quest" or s.TYPE == "Turn In") and doneMap[s.ID_ATTUNE .. "-" .. s.ID] and FTAttune_SameQuestId(s, qid) then
			return true
		end
	end
	return false
end

-- Quest ids currently in the log. A number is the time of a fresh accept
-- (the log may not list it yet). true means a log scan confirmed it.
-- Globals: this file is already at Lua's 200-local limit.

function FTAttune_QuestIdFromLogSlot(index)
	if C_QuestLog and C_QuestLog.GetInfo then
		local info = C_QuestLog.GetInfo(index)
		if type(info) == "table" and not info.isHeader then
			return tonumber(info.questID)
		end
		return nil
	end
	if GetQuestLogTitle then
		local _, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(index)
		if not isHeader then return tonumber(questID) end
	end
	return nil
end

function FTAttune_SyncQuestLog()
	if FTAttune_LogQuests == nil then FTAttune_LogQuests = {} end
	local ok, nextQuests = pcall(function()
		local num = 0
		if C_QuestLog and C_QuestLog.GetNumQuestLogEntries then
			num = C_QuestLog.GetNumQuestLogEntries() or 0
		elseif GetNumQuestLogEntries then
			num = GetNumQuestLogEntries() or 0
		end
		if issecretvalue and issecretvalue(num) then return nil end
		local found = {}
		for i = 1, num do
			local qid = FTAttune_QuestIdFromLogSlot(i)
			if qid then found[qid] = true end
		end
		return found
	end)
	if not ok or type(nextQuests) ~= "table" then return end
	local now = GetTime()
	for id, stamp in pairs(FTAttune_LogQuests) do
		if not nextQuests[id] and type(stamp) == "number" and (now - stamp) < 2 then
			nextQuests[id] = stamp
		end
	end
	FTAttune_LogQuests = nextQuests
end

function FTAttune_QuestInLog(questID)
	questID = tonumber(questID)
	if not questID then return false end
	if FTAttune_LogQuests and FTAttune_LogQuests[questID] then return true end
	if C_QuestLog and C_QuestLog.IsOnQuest then
		local ok, on = pcall(C_QuestLog.IsOnQuest, questID)
		if ok and not (issecretvalue and issecretvalue(on)) and on == true then
			if FTAttune_LogQuests == nil then FTAttune_LogQuests = {} end
			FTAttune_LogQuests[questID] = true
			return true
		end
	end
	local index
	if C_QuestLog and C_QuestLog.GetLogIndexForQuestID then
		local ok, got = pcall(C_QuestLog.GetLogIndexForQuestID, questID)
		if ok then index = got end
	elseif GetQuestLogIndexByID then
		local ok, got = pcall(GetQuestLogIndexByID, questID)
		if ok then index = got end
	end
	if index and not (issecretvalue and issecretvalue(index)) and index > 0 then
		if FTAttune_LogQuests == nil then FTAttune_LogQuests = {} end
		FTAttune_LogQuests[questID] = true
		return true
	end
	return false
end

-- completed, active (in the quest log, not turned in)
-- A recorded turn-in stays completed even while the log still lists the quest.
-- That list updates a moment after the turn-in; the saved step is already done.
local function FTAttune_QuestState(idWowhead, attuneId)
	local completed, active = false, false
	local recorded = false
	local qIDs = FTAttune_split(tostring(idWowhead or ""), "|")
	local doneMap = FTAttune_DB.toons[attunelocal_charKey] and FTAttune_DB.toons[attunelocal_charKey].done
	for _, q in ipairs(qIDs) do
		local qid = tonumber(q)
		if qid then
			if FTAttune_QuestInLog(qid) then active = true end
			if FTAttune_QuestRecordedComplete(attuneId, qid, doneMap) then recorded = true end
			if FTAttune_IsQuestFlaggedCompleted(qid) or recorded then
				completed = true
			end
		end
	end
	-- Still in the log, and this turn-in was not recorded: not turned in.
	if active and not recorded then completed = false end
	return completed, active
end

local function FTAttune_OwnedItemCount(itemId)
	local count = 0
	if GetItemCount then
		count = GetItemCount(itemId, true) or 0
		if count == 0 then
			local alias
			if itemId == "185686" then alias = "30637" -- Thrallmar
			elseif itemId == "185687" then alias = "30622" -- Honor Hold
			elseif itemId == "185690" then alias = "30623" -- Cenarion
			elseif itemId == "185691" then alias = "30633" -- Lower City
			elseif itemId == "185692" then alias = "30634" -- Shatar
			elseif itemId == "185693" then alias = "30635" -- KoT
			end
			if alias then count = GetItemCount(alias, true) or 0 end
		end
	end
	return count
end

local function FTAttune_StepsShareQuest(a, b)
	if a.ID_WOWHEAD == nil or b.ID_WOWHEAD == nil then return false end
	if a.ID_WOWHEAD == b.ID_WOWHEAD then return true end
	local ids = {}
	for _, q in ipairs(FTAttune_split(tostring(a.ID_WOWHEAD), "|")) do
		ids[q] = true
	end
	for _, q in ipairs(FTAttune_split(tostring(b.ID_WOWHEAD), "|")) do
		if ids[q] then return true end
	end
	return false
end

-- Pick Up and Turn In of the same quest, with every item between them fully collected.
local function FTAttune_SplitItemsReady(step)
	if step.TYPE ~= "Pick Up" and step.TYPE ~= "Turn In" then return false end

	local turnIns, pickUpIds = {}, {}
	local hasPickUp = false
	local chain = FTAttune_Data.stepsByAttune and FTAttune_Data.stepsByAttune[step.ID_ATTUNE]
	for _, s in pairs(chain or FTAttune_Data.steps) do
		if showPatchStep(s) and (chain ~= nil or s.ID_ATTUNE == step.ID_ATTUNE) and FTAttune_StepsShareQuest(s, step) then
			if s.TYPE == "Turn In" then
				turnIns[#turnIns + 1] = s
			elseif s.TYPE == "Pick Up" then
				pickUpIds[s.ID] = true
				hasPickUp = true
			end
		end
	end
	if not hasPickUp or #turnIns == 0 then return false end

	local items, seen = {}, {}
	local function walk(id)
		if id == nil or id == "" or id == "0" or seen[id] or pickUpIds[id] then return end
		seen[id] = true
		local s = FTAttune_FindStep(step.ID_ATTUNE, id)
		if not s then return end
		if s.TYPE == "Item" then items[#items + 1] = s end
		for _, flw in ipairs(FTAttune_FollowIDs(s.FOLLOWS)) do
			walk(flw)
		end
	end
	for _, turnIn in ipairs(turnIns) do
		for _, flw in ipairs(FTAttune_FollowIDs(turnIn.FOLLOWS)) do
			walk(flw)
		end
	end
	if #items == 0 then return false end

	for _, item in ipairs(items) do
		local need = 1
		if item.COUNT ~= nil then need = item.COUNT end
		if FTAttune_OwnedItemCount(item.ID_WOWHEAD) < need then return false end
	end
	return true
end

local function FTAttune_QuestCellTone(step)
	local completed, active = FTAttune_QuestState(step.ID_WOWHEAD, step.ID_ATTUNE)
	if not completed and step.TYPE ~= "Pick Up" then
		local doneMap = FTAttune_DB.toons[attunelocal_charKey] and FTAttune_DB.toons[attunelocal_charKey].done
		if doneMap and doneMap[step.ID_ATTUNE .. "-" .. step.ID] then
			completed = true
		end
	end
	-- Completed quests are green on Pick Up, Quest, and Turn In alike.
	if completed then return "green" end
	-- Required items are in hand: Pick Up is done, Turn In is ready.
	if FTAttune_SplitItemsReady(step) then
		if step.TYPE == "Turn In" then return "yellow" end
		return "green"
	end
	-- Turn In stays grey until the items are in hand or the quest is complete.
	if active and step.TYPE ~= "Turn In" then return "yellow" end
	return "grey"
end

-- True when a quest this item leads into (skipping kills, clicks, other items) is complete.
local function FTAttune_ItemQuestCompleted(step)
	local seen = {}
	local queue = { step.ID }
	local i = 1
	while queue[i] do
		local id = queue[i]
		i = i + 1
		if not seen[id] then
			seen[id] = true
			local followers = FTAttune_FollowersOf(step.ID_ATTUNE, id)
			if followers then
				for _, s in ipairs(followers) do
					if s.TYPE == "Quest" or s.TYPE == "Pick Up" or s.TYPE == "Turn In" then
						local completed = FTAttune_QuestState(s.ID_WOWHEAD, s.ID_ATTUNE)
						if completed then return true end
					elseif s.TYPE ~= "End" and s.TYPE ~= "FTAttune" then
						queue[#queue + 1] = s.ID
					end
				end
			end
		end
	end
	return false
end

local function FTAttune_ItemCellTone(step, countNeeded)
	if FTAttune_ItemQuestCompleted(step) then return "green" end
	local owned = FTAttune_OwnedItemCount(step.ID_WOWHEAD)
	if owned >= countNeeded then return "green" end
	if owned > 0 then return "yellow" end
	return "grey"
end

local function FTAttune_CellTone(step)
	if step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
		return FTAttune_QuestCellTone(step)
	elseif step.TYPE == "Item" then
		local countNeeded = 1
		if step.COUNT ~= nil then countNeeded = step.COUNT end
		return FTAttune_ItemCellTone(step, countNeeded)
	end
	return nil
end

-- complete, ready: ready includes a yellow in-progress step (items in hand, quest not turned in)
local function FTAttune_StepLineState(step, seen)
	if step == nil then return false, false end
	-- Another class's chain has no progress for this character.
	if not FTAttune_MayRecordAttuneProgress(FTAttune_DB.toons[attunelocal_charKey], step.ID_ATTUNE) then
		return false, false
	end
	seen = seen or {}
	if seen[step.ID] then return false, false end
	seen[step.ID] = true

	local doneMap = FTAttune_DB.toons[attunelocal_charKey] and FTAttune_DB.toons[attunelocal_charKey].done
	local key = step.ID_ATTUNE .. "-" .. step.ID

	if step.TYPE == "Spacer" then
		local anyReady = false
		for _, flw in ipairs(FTAttune_FollowIDs(step.FOLLOWS)) do
			local prev = FTAttune_FindStep(step.ID_ATTUNE, flw)
			if prev then
				local prevComplete, prevReady = FTAttune_StepLineState(prev, seen)
				if prevComplete or prevReady then anyReady = true end
			elseif doneMap and doneMap[step.ID_ATTUNE .. "-" .. flw] then
				anyReady = true
			end
		end
		if doneMap and doneMap[key] then return true, true end
		return false, anyReady
	end

	local tone = FTAttune_CellTone(step)
	if tone == "green" then return true, true end
	if tone == "yellow" then return false, true end
	if tone == nil and doneMap and doneMap[key] then return true, true end
	return false, false
end

local function FTAttune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
	if curComplete and srcComplete then
		line:SetColorTexture(0.388, 0.686, 0.388, 1) -- green
		line:SetDrawLayer("ARTWORK", 2)
	elseif srcComplete or srcReady then
		line:SetColorTexture(0.851, 0.608, 0.0, 1) -- yellow
		line:SetDrawLayer("ARTWORK", 1)
	else
		line:SetColorTexture(0.45, 0.45, 0.45, 1)
		line:SetDrawLayer("ARTWORK", 0)
	end
end

local function FTAttune_SetNodeTone(fnode, tone)
	if tone == "green" then
		fnode:SetBackdropColor(0.373, 0.729, 0.275, 0.3)
		fnode:SetBackdropBorderColor(0.373, 0.729, 0.275)
	elseif tone == "yellow" then
		fnode:SetBackdropColor(0.851, 0.608, 0.0, 0.3)
		fnode:SetBackdropBorderColor(0.851, 0.608, 0.0, 1)
	else
		fnode:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
		fnode:SetBackdropBorderColor(0.4, 0.4, 0.4)
	end
end

function FTAttune_CreateNode(step, parent, posX, posY)
	-- Generic look and feel for the node
	local PaneBackdrop  = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}

	local countSameStep = 0
	local countCompleted = 0
	local listSameStep = ""
	local listCompleted = ""
	local dots1 = false
	local dots2 = false
	-- On class quests, badges and the "on this step" list only count that class.
	local requiredClass = FTAttune_AttuneClass(step.ID_ATTUNE)
	--calculate guildmembers on this stage
	for kt, t in FTAttune_spairs(FTAttune_DB.toons, function(t,a,b) return b > a end) do

		local filter = false

		if  FTAttune_DB.showListAlt then
			--show alts
			if t.owner == 1 then filter = true end
		else
			--show guildies
			if t.guild == attunelocal_myguild then filter = true end
		end

		if filter and requiredClass then
			local toonClass = t.class and string.upper(t.class) or ""
			if toonClass ~= requiredClass then filter = false end
		end

		if filter and not step.SIDE then
			-- calculate how many other toon has this step marked as IsNext
			-- Inside reminders are not a current step, so they get no count badge.
			if kt ~= attunelocal_charKey then
				if t.next ~= nil then
					if t.next[step.ID_ATTUNE .. "-" .. step.ID] ~= nil then
						countSameStep = countSameStep + 1
						if countSameStep <= tonumber(FTAttune_DB.maxListSize) then
							listSameStep = listSameStep .. "\n" .. FTAttune_split(kt, "-")[1]
						else
							if dots1 == false then
								listSameStep = listSameStep .. "\n..."
								dots1 = true
							end
						end

					end
				end
			end
			-- calculate how many toons have completed this attune
			if step.TYPE == "End" then
				if t.attuned ~= nil then
					if t.attuned[step.ID_ATTUNE] ~= nil then 
						if t.attuned[step.ID_ATTUNE] >= 100 then
							countCompleted = countCompleted + 1
							if countCompleted <= tonumber(FTAttune_DB.maxListSize) then
								listCompleted = listCompleted .. "\n" .. FTAttune_split(kt, "-")[1]
							else
								if dots2 == false then
									listCompleted = listCompleted .. "\n..."
									dots2 = true
								end
							end
						end
					end
				end
			end
		end
	end

	if  FTAttune_DB.showListAlt then
		if listSameStep ~= "" then
			listSameStep = "\n\n|cff00ff00"..FTAttuneLang["Alts on this step"]..":|r" .. listSameStep
		end
		if listCompleted ~= "" then
			listCompleted = "\n\n|cff00ff00"..FTAttuneLang["Attuned alts"]..":|r" .. listCompleted
		end
	else
		if listSameStep ~= "" then
			listSameStep = "\n\n|cff00ff00"..FTAttuneLang["Guild members on this step"]..":|r" .. listSameStep
		end
		if listCompleted ~= "" then
			listCompleted = "\n\n|cff00ff00"..FTAttuneLang["Attuned guild members"]..":|r" .. listCompleted
		end
	end



	-- check whether the step has been done
	if FTAttune_DB.toons[attunelocal_charKey].done == nil then FTAttune_DB.toons[attunelocal_charKey].done = {}  end
	local tracksProgress = FTAttune_MayRecordAttuneProgress(FTAttune_DB.toons[attunelocal_charKey], step.ID_ATTUNE)
	local done = tracksProgress and FTAttune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. step.ID]

	local countNeeded = 1
	if step.COUNT ~= nil then countNeeded = step.COUNT end

	-- main node frame, reuse if possible
	local fnode
	local exist = false
	for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Node_"..step.ID then exist = true end end
	if exist then 	fnode = _G["FTAttune_Node_"..step.ID] -- reusing
	else			fnode = CreateFrame("Button", "FTAttune_Node_"..step.ID, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
					table.insert(attunelocal_frames, "FTAttune_Node_"..step.ID) -- recording, to reuse
	end
	fnode:SetParent(parent)
	local nodeWidth = FTAttune_NodeWidth(step)
	fnode:SetWidth(nodeWidth)
	fnode:SetHeight(attunelocal_Node_Height)
	fnode:SetPoint("TOP", posX, -posY)
	fnode:SetScript("OnMouseUp", function(self, button) end)
	FTAttune_SetupGraphPanTarget(fnode, true)
	fnode:SetScript("OnEnter", function()

		-- put full step info in status bar
		--if step.TYPE ~= "Spacer" then attunelocal_frame:SetStatusText(step.STEP) end

		-- display Item link or quest tooltip on hover
		if step.TYPE == "Item" then
			if countNeeded == 1 then
				attunelocal_frame:SetStatusText(FTAttuneLang["I_"..step.ID_WOWHEAD])
			else
				attunelocal_frame:SetStatusText(FTAttune_OwnedItemCount(step.ID_WOWHEAD) .. "/" .. countNeeded .. " " .. FTAttuneLang["I_"..step.ID_WOWHEAD])
			end
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetHyperlink("item:"..step.ID_WOWHEAD)

			fnode:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then FTAttune_ShowWebsiteURL("item=" .. step.ID_WOWHEAD)	end
			end)

		elseif step.TYPE == "End" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(FTAttuneLang["FTAttuneColors"])
			if listCompleted ~= "" and FTAttune_DB.showList then GameTooltip:AddLine(listCompleted, 1, 1, 1, 1) end

		elseif step.TYPE == "Level" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(FTAttuneLang["Minimum Level"])

		elseif step.TYPE == "Rep" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local tempRep = FTAttune_DB.toons[attunelocal_charKey].reps[step.LOCATION].earned
			local tempGoal = step.ID_WOWHEAD
			if tonumber(tempRep) > tonumber(step.ID_WOWHEAD) then tempRep = step.ID_WOWHEAD end

			attunelocal_frame:SetStatusText("" .. FTAttune_DB.toons[attunelocal_charKey].reps[step.LOCATION].name)
			GameTooltip:SetText("" .. FTAttune_DB.toons[attunelocal_charKey].reps[step.LOCATION].name)
			GameTooltip:AddLine(FTAttuneLang["Current progress"]..": ".. tempRep .. "/" ..step.ID_WOWHEAD, 0.5, 0.5, 0.5, 1)
			if step.OFFSET ~= nil then
				tempGoal = step.ID_WOWHEAD + step.OFFSET
				tempRep = tempRep + step.OFFSET
			end
			GameTooltip:AddLine(FTAttuneLang["Completion"]..": " .. math.floor(100*tonumber(tempRep)/tonumber(tempGoal)).."%", 0.5, 0.5, 0.5, 1)

			fnode:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then FTAttune_ShowWebsiteURL("faction=" .. step.LOCATION)	end
			end)

		elseif step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
			attunelocal_frame:SetStatusText(FTAttuneLang["Q1_"..step.ID_WOWHEAD])
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)

			local quest = FTAttune_Data.quests[tonumber(step.ID_WOWHEAD)]
			if string.find(step.ID_WOWHEAD, "|") then 
				quest = FTAttune_Data.quests[tonumber(FTAttune_split(step.ID_WOWHEAD, "|")[1])]
			end
			if quest == nil then
				-- error message if quest is not in FTAttuneData.lua
				GameTooltip:SetText(FTAttuneLang["Quest information not found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				GameTooltip:SetText(FTAttuneLang["Q1_"..step.ID_WOWHEAD])
				local reqLevel = tonumber(quest[1]) or 0
				local lr, lg, lb = 0.5, 0.5, 0.5
				if UnitLevel("player") < reqLevel then lr, lg, lb = 1, 0.055, 0.075 end
				GameTooltip:AddLine(FTAttuneLang["Requires level"].." "..quest[1].."\n\n", lr, lg, lb, 1)
				if quest[2] == 1 then
					GameTooltip:AddLine(FTAttuneLang["Solo quest"].."\n\n", 0.373, 0.729, 0.275, 1)
				elseif quest[2] <= 5 then
					GameTooltip:AddLine(FTAttuneLang["Party quest"]:gsub("##NB##", quest[2]).."\n\n", 0.851, 0.608, 0.0, 1)
				else
					GameTooltip:AddLine(FTAttuneLang["Raid quest"]:gsub("##NB##", quest[2]).."\n\n", 0.857, 0.055, 0.075, 1)
				end
				if FTAttuneLang["Q2_"..step.ID_WOWHEAD] ~= nil then GameTooltip:AddLine(FTAttuneLang["Q2_"..step.ID_WOWHEAD], 1, 1, 1, 1, true) end
			end

			fnode:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then
					GameTooltip:Hide()
					FTAttune_HideQuestGiverTip()
					FTAttune_ShowWebsiteURL("quest=" .. step.ID_WOWHEAD)
				end
			end)

		elseif step.TYPE == "Kill" or step.TYPE == "Interact" then
			attunelocal_frame:SetStatusText(FTAttuneLang["N1_"..step.ID_WOWHEAD])
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local npc = FTAttune_Data.npcs[tonumber(step.ID_WOWHEAD)]
			local named = FTAttuneLang["N1_"..step.ID_WOWHEAD]
			local hasName = named ~= nil and named ~= "" and named ~= ("N1_"..step.ID_WOWHEAD)
			if npc == nil and not hasName then
				-- error message if quest is not in FTAttuneData.lua
				GameTooltip:SetText(FTAttuneLang["NPC Not Found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			elseif npc == nil then
				GameTooltip:SetText(named)
				local note = FTAttuneLang["N2_"..step.ID_WOWHEAD]
				if note ~= nil and note ~= "" and note ~= ("N2_"..step.ID_WOWHEAD) then
					GameTooltip:AddLine("\n"..note, 1, 1, 1, 1, true)
				end
			else
				-- build tooltip
				GameTooltip:SetText(FTAttuneLang["N1_"..step.ID_WOWHEAD])
				GameTooltip:AddLine(FTAttuneLang["Level"].." "..npc[1].." "..npc[2].." "..npc[3].."\n", 0.851, 0.608, 0.0, 1)
				if FTAttuneLang["N2_"..step.ID_WOWHEAD] ~= "" then
					GameTooltip:AddLine("\n"..FTAttuneLang["N2_"..step.ID_WOWHEAD], 1, 1, 1, 1, true)
				end

				fnode:SetScript("OnMouseUp", function(self, button)
					if button == "RightButton" then FTAttune_ShowWebsiteURL("npc=" .. step.ID_WOWHEAD)	end
				end)
			end

		elseif step.TYPE == "Click" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local other = FTAttuneLang["O_"..step.ID_WOWHEAD]
			if other == nil then
				-- error message if quest is not in FTAttuneData.lua
				GameTooltip:SetText(FTAttuneLang["Information not found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				attunelocal_frame:SetStatusText(FTAttuneLang[step.STEP])
				GameTooltip:SetText(other)
			end



		-- change transparency if clickable sub-attune
		elseif step.TYPE == "FTAttune" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(FTAttuneLang["Click to navigate to that attunement"])

			if done then
				fnode:SetBackdropColor(0.055, 0.306, 0.576, 0.7 * 1.25) -- blue, attune
			else
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7 * 1.25)
			end
		end

		if listSameStep ~= "" and FTAttune_DB.showList then GameTooltip:AddLine(listSameStep, 1, 1, 1, 1) end
		GameTooltip:Show()
		if (step.TYPE == "Quest" or step.TYPE == "Pick Up") and not step.SIDE then
			FTAttune_ShowQuestGiverTip(step, fnode)
		else
			FTAttune_HideQuestGiverTip()
		end

	end)
	fnode:SetScript("OnLeave", function()
		-- restore status text to default
		attunelocal_frame:SetStatusText(attunelocal_statusText)
		GameTooltip:Hide()
		FTAttune_HideQuestGiverTip()
		-- restore  transparency for clickable sub-attunes
		if step.TYPE == "FTAttune" then
			if done then
				fnode:SetBackdropColor(0.055, 0.306, 0.576, 0.7) -- blue, attune
			else
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7) -- red
			end
		end
	end)
	fnode:SetScript("OnClick", function(self, button)

		-- shif-clicking items in chat
		if step.TYPE == "Item" then
			local _, link = GetItemInfo(tonumber(step.ID_WOWHEAD));
			if link then
				HandleModifiedItemClick(link);
			end
		-- shift clicking quests not working in Classic. Keep for TBC maybe it will work there
	--		elseif step.TYPE == "Quest" then
	--			local quest = FTAttune_Data.quests[tonumber(step.ID_WOWHEAD)]
	--			if quest and IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() then
	--				ChatEdit_InsertLink(format("|cffffff00|Hquest:%d:%d|h[%s]|h|r", tonumber(step.ID_WOWHEAD), 60, quest[1]));
	--			end

		elseif (step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In") and (button == nil or button == "LeftButton") and not IsModifiedClick() then
			GameTooltip:Hide()
			FTAttune_HideQuestGiverTip()
			FTAttune_ShowQuestDetail(step)

		-- navigate to sub-attunement
		elseif step.TYPE == "FTAttune" then
			-- Open the linked attunement (ID_WOWHEAD), which may sit in another group
			for i, a in pairs(FTAttune_Data.attunes) do
				if a.ID == step.ID_WOWHEAD then
					attunelocal_treeframe:SelectByPath(a.EXPAC.."\001".. a.GROUP.."\001"..a.ID)
					break
				end
			end
		end

	end)


	local next = false
	if step.TYPE ~= "Spacer" then

		-- format node color
		fnode:SetBackdrop(PaneBackdrop)
		local tone = nil
		if step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
			tone = FTAttune_QuestCellTone(step)
		elseif step.TYPE == "Item" then
			tone = FTAttune_ItemCellTone(step, countNeeded)
		end
		if not tracksProgress then
			fnode:SetBackdropColor(0.1, 0.1, 0.1, 0.5) -- gray; not this class
			fnode:SetBackdropBorderColor(0.4, 0.4, 0.4)
			if step.TYPE == "FTAttune" or step.TYPE == "End" then
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7) -- red, attune
				fnode:SetBackdropBorderColor(1, 1, 1)
			end
		elseif tone then
			FTAttune_SetNodeTone(fnode, tone)
		elseif done then
			if step.TYPE == "FTAttune" or step.TYPE == "End" then
				fnode:SetBackdropColor(0.055, 0.306, 0.576, 0.7) -- blue, attune
				fnode:SetBackdropBorderColor(1, 1, 1)

			else
				fnode:SetBackdropColor(0.373, 0.729, 0.275, 0.3) -- green, to match website colors
				fnode:SetBackdropBorderColor(0.373, 0.729, 0.275)
			end

		else
			-- check if all predecessor are done, and mark as Next if it is the case

			local followOR = false
			local fIDs = FTAttune_split(step.FOLLOWS, "&")
			if string.find(step.FOLLOWS, "|") then fIDs = FTAttune_split(step.FOLLOWS, "|"); followOR = true end

			if followOR then
				next = false
				for fi, flw in pairs(fIDs) do
					if  FTAttune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] then next = true end
				end
			else
				next = true
				for fi, flw in pairs(fIDs) do
					if  FTAttune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] == nil or FTAttune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] == false then next = false end
				end
			end

			if step.FOLLOWS == "0" then next = true end

			if next then
				fnode:SetBackdropColor(0.851, 0.608, 0.0, 0.3) -- yellow
				fnode:SetBackdropBorderColor(0.851, 0.608, 0.0, 1)
			else
				fnode:SetBackdropColor(0.1, 0.1, 0.1, 0.5) -- gray
				fnode:SetBackdropBorderColor(0.4, 0.4, 0.4)
			end

			if step.TYPE == "FTAttune" or step.TYPE == "End" then
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7	) -- red, attune
				fnode:SetBackdropBorderColor(1, 1, 1)
			end
		end


		--icon, reuse object when possible
		local exist = false
		for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Icon_"..step.ID then exist = true end end
		local icon
		if exist then 	icon = _G["FTAttune_Icon_"..step.ID] -- reuse
		else			icon = CreateFrame("Button", "FTAttune_Icon_"..step.ID)
						table.insert(attunelocal_frames, "FTAttune_Icon_"..step.ID) -- recording, to reuse
		end
		icon:SetPoint("TOPLEFT", fnode, "TOPLEFT", 8, -8)
		icon:SetParent(fnode)
		icon:SetWidth(attunelocal_Icon_Size)
		icon:SetHeight(attunelocal_Icon_Size)
		local stepIcon = step.ICON
		if step.TYPE == "End" then
			local attune = FTAttune_Data.attuneById and FTAttune_Data.attuneById[step.ID_ATTUNE]
			if attune ~= nil and attune.ICON ~= nil then
				stepIcon = attune.ICON
			end
		end
		icon:SetNormalTexture(stepIcon)
		icon:SetHighlightTexture(stepIcon)
		icon:SetToplevel(true)
		icon:EnableMouse(false)
		icon:Disable()
		icon:Show()


		-- step information, reuse when possible
		local exist = false
		for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Title_"..step.ID then exist = true end end
		local ftitle
		if exist then 	ftitle = _G["FTAttune_Title_"..step.ID] -- reuse
		else			ftitle = fnode:CreateFontString("FTAttune_Title_"..step.ID)
						table.insert(attunelocal_frames, "FTAttune_Title_"..step.ID) -- recording, to reuse
		end
		ftitle:SetWidth(nodeWidth - 50)
		ftitle:SetHeight(16)
		ftitle:SetJustifyH("LEFT")
		-- End node gets a bigger font
		if step.TYPE == 'End' then
			ftitle:SetPoint("TOPLEFT", 44, -16)
			ftitle:SetFont(GameFontNormal:GetFont(), 12, "")
			if tracksProgress and (FTAttune_DB.toons[attunelocal_charKey].attuned[step.ID_ATTUNE] >= 100
				or FTAttune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. step.ID]) then
				ftitle:SetText(FTAttuneLang["Attuned"])
			else
				ftitle:SetText(FTAttuneLang["Not attuned"])
			end
		else
			ftitle:SetPoint("TOPLEFT", 44, -8)
			ftitle:SetFont(GameFontNormal:GetFont(), 11, "")

			if step.TYPE == "Item" then
				if countNeeded == 1 then
					--ftitle:SetText(step.STEP)
					ftitle:SetText(FTAttuneLang["I_"..step.ID_WOWHEAD])
				else
					ftitle:SetText(FTAttune_OwnedItemCount(step.ID_WOWHEAD) .. "/" .. countNeeded .. " " .. FTAttuneLang["I_"..step.ID_WOWHEAD])
				end
			elseif step.TYPE == "Kill" or step.TYPE == "Interact" then
				ftitle:SetText(FTAttuneLang["N1_"..step.ID_WOWHEAD])

			elseif step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
				ftitle:SetText(FTAttuneLang["Q1_"..step.ID_WOWHEAD])
			else
				ftitle:SetText(step.STEP)
			end
		end
		ftitle:Show()


		-- type and icon (level, interact, quest, kill...), reuse when possible
		if step.TYPE ~= 'End' then

			-- format depending on type
			local type = "|cffffd100"..FTAttuneLang[step.TYPE].."|r"
			if step.SIDE then
				type = "|cffffd100"..(FTAttuneLang["Inside"] or "Inside").."|r"
				if step.LOCATION ~= "" then type = type .. "|c60808080 ".. FTAttuneLang["in"].." "..FTAttuneLang[step.LOCATION].."|r" end
			elseif step.TYPE == "Level" then type = "|cffffd100"..FTAttuneLang["Required level"].."|r"
			elseif step.TYPE == "FTAttune" then type = "|c60808080"..FTAttuneLang["Attunement or key"].."|r"
			elseif step.TYPE == "Rep" then type = "|cffffd100"..FTAttuneLang["Reputation"].."|r"
			elseif step.LOCATION ~= "" then type = type .. "|c60808080 ".. FTAttuneLang["in"].." "..FTAttuneLang[step.LOCATION].."|r"
			end

			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Type_"..step.ID then exist = true end end
			local ftype
			if exist then 	ftype = _G["FTAttune_Type_"..step.ID] --reuse
			else			ftype = fnode:CreateFontString("FTAttune_Type_"..step.ID)
							table.insert(attunelocal_frames, "FTAttune_Type_"..step.ID) -- recording, to reuse
			end
			ftype:SetPoint("TOPLEFT", 44, -24)
			ftype:SetWidth(nodeWidth - 50)
			ftype:SetHeight(16)
			ftype:SetJustifyH("LEFT")
			ftype:SetFont(GameFontNormal:GetFont(), 9, "")
			ftype:SetText(type)
			ftype:Show()
		end


		if (countSameStep > 0 or countCompleted > 0) and not step.SIDE then

			--notification text
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_NotifText_"..step.ID then exist = true end end
			local notiftext
			if exist then 	notiftext = _G["FTAttune_NotifText_"..step.ID] -- reuse
			else			notiftext = fnode:CreateFontString("FTAttune_NotifText_"..step.ID)
							table.insert(attunelocal_frames, "FTAttune_NotifText_"..step.ID) -- recording, to reuse
			end
			notiftext:SetParent(fnode)
			notiftext:SetWidth(32)
			notiftext:SetFont(GameFontNormal:GetFont(), 10, "")
			notiftext:SetText(""..((countSameStep > 0) and countSameStep or countCompleted))
			notiftext:Show()



			--notification icon
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Notif_"..step.ID then exist = true end end
			local notif
			if exist then 	notif = _G["FTAttune_Notif_"..step.ID] -- reuse
			else			notif = CreateFrame("Button", "FTAttune_Notif_"..step.ID)
							table.insert(attunelocal_frames, "FTAttune_Notif_"..step.ID) -- recording, to reuse
			end
			notif:SetPoint("TOPRIGHT", fnode, "TOPRIGHT", 8, 5)
			notif:SetParent(fnode)
			notif:SetWidth(32)
			notif:SetHeight(16)
			notif:SetFontString(notiftext)
			notif:SetNormalTexture("Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\" .. ((countSameStep > 0) and "notification" or "completion"))
			notif:SetHighlightTexture("Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\" .. ((countSameStep > 0) and "notification" or "completion"))
			notif:SetToplevel(true)
			notif:EnableMouse(false)
			notif:Disable()
			notif:Show()
		end

	else
		--make spacer transparent
		fnode:SetBackdropColor(0, 0, 0, 0)
		fnode:SetBackdropBorderColor(1, 1, 1, 0)

		-- Fill the invisible spacer with a vertical so column-drop FOLLOWS look solid (not dashed)
		local fillName = "FTAttune_SpacerFill_"..step.ID
		local fillExist = false
		for _, f in ipairs(attunelocal_frames) do if f == fillName then fillExist = true end end
		local fill
		if fillExist then fill = _G[fillName]
		else
			fill = fnode:CreateLine(fillName)
			table.insert(attunelocal_frames, fillName)
		end
		if step.FOLLOWS ~= nil and step.FOLLOWS ~= "0" then
			local upstreamComplete, upstreamReady = false, false
			for _, flw in ipairs(FTAttune_FollowIDs(step.FOLLOWS)) do
				local prev = FTAttune_FindStep(step.ID_ATTUNE, flw)
				if prev then
					local prevComplete, prevReady = FTAttune_StepLineState(prev)
					if prevComplete then upstreamComplete = true end
					if prevComplete or prevReady then upstreamReady = true end
				end
			end
			FTAttune_ApplyLineColor(fill, upstreamComplete, upstreamComplete, upstreamReady)
			fill:SetThickness(attunelocal_Line_Thickness)
			fill:SetStartPoint("TOP", 0, 0)
			fill:SetEndPoint("TOP", 0, -attunelocal_Node_Height)
			fill:Show()
		else
			fill:Hide()
		end
	end

	fnode:Show()

	-- Create lines between nodes
	-- 3 lines for each connection. No diagonals are used, only horizontal or vertical, to make it easier to look at
	-- End ← Inside (SIDE) links use a dedicated side feeder instead (see FTAttune_DrawSideFeeder)
	if step.FOLLOWS ~= "0" then
		local followOR = false;
		local fIDs = FTAttune_split(step.FOLLOWS, "&")
		if string.find(step.FOLLOWS, "|") then fIDs = FTAttune_split(step.FOLLOWS, "|"); followOR = true end
		for fi, flw in pairs(fIDs) do

			-- Skip L-connectors from End to SIDE steps (horizontal feeder handles those)
			if step.TYPE == "End" and FTAttune_IsSideStep(step.ID_ATTUNE, flw) then
				for _, suffix in ipairs({ "Line1", "Line2", "Line3" }) do
					local ln = _G["FTAttune_"..suffix.."_"..step.ID.."_"..flw]
					if ln then ln:Hide() end
				end
			else

			local prevStep = FTAttune_FindStep(step.ID_ATTUNE, flw)
			local srcComplete, srcReady = false, false
			if prevStep then
				srcComplete, srcReady = FTAttune_StepLineState(prevStep)
			else
				local doneMap = FTAttune_DB.toons[attunelocal_charKey] and FTAttune_DB.toons[attunelocal_charKey].done
				srcComplete = doneMap and doneMap[step.ID_ATTUNE .. "-" .. flw] and true or false
				srcReady = srcComplete
			end
			local curComplete = FTAttune_StepLineState(step)


			-- VERTICAL Line from prev to just under prev
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Line1_"..step.ID.."_"..flw then exist = true end end

			local cur, _, _, curX, curY  = _G["FTAttune_Node_"..step.ID]:GetPoint()
			local prev, _, _, prevX, prevY = _G["FTAttune_Node_"..flw]:GetPoint()
			local offset = (attunelocal_Line_Thickness/2)

			local line
			if exist then 	line = _G["FTAttune_Line1_"..step.ID.."_"..flw] --reuse
			else			line = fnode:CreateLine("FTAttune_Line1_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "FTAttune_Line1_"..step.ID.."_"..flw) -- recording, to reuse
			end
			FTAttune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
			line:SetThickness(attunelocal_Line_Thickness)
			line:SetStartPoint("TOP", prevX - curX, prevY - curY - attunelocal_Node_Height)
			line:SetEndPoint("TOP", prevX - curX, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)) - offset)
			line:Show()


			-- VERTICAL Line to go all the way down to cur
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Line3_"..step.ID.."_"..flw then exist = true end end

			local line
			if exist then 	line = _G["FTAttune_Line3_"..step.ID.."_"..flw]
			else			line = fnode:CreateLine("FTAttune_Line3_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "FTAttune_Line3_"..step.ID.."_"..flw) -- recording, to reuse
			end
			FTAttune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
			line:SetThickness(attunelocal_Line_Thickness)
			line:SetStartPoint("TOP", 0, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)) + offset)
			line:SetEndPoint("TOP", 0, -2)
			line:Show()



			-- HORIZONTAL Line to center on curX
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "FTAttune_Line2_"..step.ID.."_"..flw then exist = true end end

			local line
			if exist then 	line = _G["FTAttune_Line2_"..step.ID.."_"..flw]
			else			line = fnode:CreateLine("FTAttune_Line2_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "FTAttune_Line2_"..step.ID.."_"..flw) -- recording, to reuse
			end
			FTAttune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
			line:SetThickness(attunelocal_Line_Thickness)

			if prevX < 0 or curX < 0 then offset = -offset 	end -- need for the line thickness in corners
			line:SetStartPoint("TOP", offset, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)))
			line:SetEndPoint("TOP", prevX - curX + offset, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)))
			line:Show()

			end -- not SIDE→End


		end
	end
end


-------------------------------------------------------------------------
-- Trigger a redraw of the FTAttune tab
-------------------------------------------------------------------------

-- Redraw the open attunement from saved progress.
-- Toggling the whole window left the chain on screen until a reload, and a rebuild
-- during the completion event still saw the quest in the log.
function FTAttune_RefreshAttunePanel()
	if attunelocal_initial then return end
	if attunelocal_frame == nil or not attunelocal_frame:IsShown() then
		attunelocal_panelDirty = true
		if FTAttune_DB and attunelocal_charKey then FTAttune_LoadTree() end
		return
	end
	attunelocal_panelDirty = false
	if FTAttune_HideQuestDetail then FTAttune_HideQuestDetail() end
	FTAttune_ReloadAttuneTree()
	if not attunelocal_treeIsShown then
		if attunelocal_glist then FTAttune_ShowResultList() end
		return
	end
	local lastViewed = FTAttune_GetLastViewed()
	local sel
	if lastViewed then
		_, _, sel = strsplit("\001", lastViewed)
	end
	if (sel == nil or sel == "") and attunelocal_treeframe then
		local status = attunelocal_treeframe.status or attunelocal_treeframe.localstatus
		local selected = status and status.selected
		if selected then _, _, sel = strsplit("\001", selected) end
	end
	if sel and sel ~= "" and attunelocal_scroll then
		FTAttune_Select(sel, true)
	end
end

function FTAttune_ForceAttuneTabRefresh()
	if attunelocal_initial then
		attunelocal_panelDirty = true
		return
	end
	-- Not a chunk local: this file is already at Lua's 200-local limit.
	attunelocal_panelDirty = true
	attunelocal_refreshToken = (attunelocal_refreshToken or 0) + 1
	local token = attunelocal_refreshToken
	C_Timer.After(0, function()
		if token ~= attunelocal_refreshToken then return end
		FTAttune_RefreshAttunePanel()
	end)
end


-------------------------------------------------------------------------
-- Result grid. Names stay on screen. Result columns scroll sideways.
-- Names and results scroll up and down together.
-- attunelocal_resultHolder / attunelocal_resultHeader / attunelocal_resultNames
-- are globals (200-local limit).
-------------------------------------------------------------------------

function FTAttune_ResultLevelWidth() return 48 end
function FTAttune_ResultClassWidth() return 48 end
function FTAttune_ResultCharWidth() return 162 end
function FTAttune_ResultDeleteWidth() return 44 end

-- Frozen pane: level, class, name, and the delete button.
function FTAttune_ResultNameWidth()
	return 4 + FTAttune_ResultLevelWidth() + FTAttune_ResultClassWidth() + FTAttune_ResultCharWidth() + FTAttune_ResultDeleteWidth() + 4
end

function FTAttune_ResultRowHeight()
	return 26
end

function FTAttune_ResultColumnsWidth()
	local width = 0
	local expac = ""
	local faction = UnitFactionGroup("player")
	for _, a in pairs(FTAttune_Data.attunes) do
		if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) and not FTAttune_IsClassQuest(a) then
			if (FTAttuneTreeExpandStatus[a.EXPAC] == nil or FTAttuneTreeExpandStatus[a.EXPAC] == 1)
			and (FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == nil or FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == 1) then
				local key = a.EXPAC.."-"..a.GROUP
				if expac ~= key then
					width = width + 10
					expac = key
				end
				if a.FACTION == faction or a.FACTION == "Both" then
					width = width + 30
				end
			end
		end
	end
	return width + 8
end

-- SetHorizontalScroll / SetVerticalScroll crash the client when the scroll frame has no child,
-- or when the offset is past the range the child actually has.
function FTAttune_SafeScroll(scroll, axis, offset)
	if not scroll or not scroll.GetScrollChild or not scroll:GetScrollChild() then return end
	offset = offset or 0
	if offset < 0 then offset = 0 end
	if axis == "h" then
		if scroll.GetHorizontalScrollRange then
			local range = scroll:GetHorizontalScrollRange() or 0
			if offset > range then offset = range end
		end
		scroll:SetHorizontalScroll(offset)
	else
		if scroll.GetVerticalScrollRange then
			local range = scroll:GetVerticalScrollRange() or 0
			if offset > range then offset = range end
		end
		scroll:SetVerticalScroll(offset)
	end
end

function FTAttune_ApplyResultScroll()
	local holder = attunelocal_resultHolder
	if not holder or holder.closing then return end
	local h = holder.hOffset or 0
	local v = holder.vOffset or 0
	FTAttune_SafeScroll(holder.headerScroll, "h", h)
	FTAttune_SafeScroll(holder.bodyScroll, "h", h)
	FTAttune_SafeScroll(holder.bodyScroll, "v", v)
	FTAttune_SafeScroll(holder.nameScroll, "v", v)
end

-- Ace widgets sit inside this frame. The frame itself stays the scroll child for the life of the holder.
-- Replacing the scroll child, or reparenting it, frees that frame and the client access-violates.
function FTAttune_MountResultWidget(widget, parent)
	if not widget or not widget.frame or not parent then return end
	local frame = widget.frame
	frame:SetParent(parent)
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	frame:Show()
end

function FTAttune_ResultScrollWheel(delta, horizontal)
	local holder = attunelocal_resultHolder
	if not holder or not holder:IsShown() then return end
	if horizontal == nil then horizontal = IsShiftKeyDown() end
	if horizontal then
		local _, maxW = holder.hbar:GetMinMaxValues()
		holder.hOffset = math.max(0, math.min(maxW or 0, (holder.hOffset or 0) - delta * 60))
	else
		local _, maxH = holder.vbar:GetMinMaxValues()
		holder.vOffset = math.max(0, math.min(maxH or 0, (holder.vOffset or 0) - delta * 48))
	end
	holder.noupdate = true
	holder.hbar:SetValue(holder.hOffset or 0)
	holder.vbar:SetValue(holder.vOffset or 0)
	holder.noupdate = nil
	FTAttune_ApplyResultScroll()
end

function FTAttune_BindResultFrame(frame)
	local holder = attunelocal_resultHolder
	if not frame or not holder then return end
	if not frame.attuneResultWheel then
		frame.attuneResultWheel = true
		-- SetFrameStrata on the scroll child itself access-violates. Descendants are fine.
		local parent = frame:GetParent()
		local isScrollChild = parent and parent.GetScrollChild and parent:GetScrollChild() == frame
		if not isScrollChild then
			frame.attuneResultStrata = frame:GetFrameStrata()
			frame:SetFrameStrata(holder:GetFrameStrata())
		end
		frame:EnableMouseWheel(true)
		frame:SetScript("OnMouseWheel", function(self, delta)
			if not self.attuneResultWheel then return end
			FTAttune_ResultScrollWheel(delta)
		end)
	end
	for _, child in ipairs({ frame:GetChildren() }) do
		FTAttune_BindResultFrame(child)
	end
end

function FTAttune_UnbindResultFrame(frame)
	if not frame then return end
	if frame.attuneResultWheel then
		frame.attuneResultWheel = nil
		frame:SetScript("OnMouseWheel", nil)
		if frame.attuneResultStrata then
			local parent = frame:GetParent()
			local isScrollChild = parent and parent.GetScrollChild and parent:GetScrollChild() == frame
			if not isScrollChild then
				frame:SetFrameStrata(frame.attuneResultStrata)
			end
			frame.attuneResultStrata = nil
		end
	end
	for _, child in ipairs({ frame:GetChildren() }) do
		FTAttune_UnbindResultFrame(child)
	end
end

function FTAttune_EnsureResultHolder()
	if attunelocal_resultHolder then return attunelocal_resultHolder end

	local parent = attunelocal_frame.frame
	local holder = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	holder:SetFrameStrata(parent:GetFrameStrata())
	holder:SetFrameLevel(parent:GetFrameLevel() + 20)
	holder:EnableMouse(true)
	holder:EnableMouseWheel(true)
	holder:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	holder:SetBackdropColor(0.05, 0.05, 0.05, 0.85)
	holder:SetBackdropBorderColor(0.45, 0.4, 0.3, 1)
	holder:Hide()
	holder.hOffset = 0
	holder.vOffset = 0

	local pad = 6
	holder.pad = pad

	-- Frozen name column. Vertical scroll only, kept in step with the results.
	local nameHead = CreateFrame("Frame", nil, holder)
	nameHead:EnableMouseWheel(true)
	nameHead:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_ResultScrollWheel(delta)
	end)
	if nameHead.SetClipsChildren then nameHead:SetClipsChildren(true) end
	holder.nameHead = nameHead

	local nameScroll = CreateFrame("ScrollFrame", nil, holder)
	nameScroll:EnableMouseWheel(true)
	nameScroll:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_ResultScrollWheel(delta)
	end)
	holder.nameScroll = nameScroll

	local headerScroll = CreateFrame("ScrollFrame", nil, holder)
	headerScroll:EnableMouseWheel(true)
	headerScroll:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_ResultScrollWheel(delta)
	end)
	holder.headerScroll = headerScroll

	local bodyScroll = CreateFrame("ScrollFrame", nil, holder)
	bodyScroll:EnableMouseWheel(true)
	bodyScroll:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_ResultScrollWheel(delta)
	end)
	holder.bodyScroll = bodyScroll

	-- Permanent scroll children. Created once, never swapped, never reparented.
	local function resultScrollContent(scroll)
		local content = CreateFrame("Frame", nil, scroll)
		content:SetSize(1, 1)
		scroll:SetScrollChild(content)
		return content
	end
	holder.nameContent = resultScrollContent(nameScroll)
	holder.headerContent = resultScrollContent(headerScroll)
	holder.bodyContent = resultScrollContent(bodyScroll)

	local headerBg = holder:CreateTexture(nil, "BACKGROUND")
	headerBg:SetColorTexture(0.22, 0.18, 0.1, 0.55)
	holder.headerBg = headerBg

	local nameShade = holder:CreateTexture(nil, "BACKGROUND")
	nameShade:SetColorTexture(0, 0, 0, 0.28)
	holder.nameShade = nameShade

	local divider = CreateFrame("Frame", nil, holder)
	divider:SetWidth(1)
	local dividerTex = divider:CreateTexture(nil, "ARTWORK")
	dividerTex:SetAllPoints()
	dividerTex:SetColorTexture(0.55, 0.46, 0.28, 0.9)
	holder.divider = divider

	local headerLine = CreateFrame("Frame", nil, holder)
	headerLine:SetHeight(1)
	local headerLineTex = headerLine:CreateTexture(nil, "ARTWORK")
	headerLineTex:SetAllPoints()
	headerLineTex:SetColorTexture(0.55, 0.46, 0.28, 0.9)
	holder.headerLine = headerLine

	local baseLevel = holder:GetFrameLevel()
	nameHead:SetFrameLevel(baseLevel + 6)
	nameScroll:SetFrameLevel(baseLevel + 6)
	headerScroll:SetFrameLevel(baseLevel + 3)
	bodyScroll:SetFrameLevel(baseLevel + 3)
	divider:SetFrameLevel(baseLevel + 7)
	headerLine:SetFrameLevel(baseLevel + 7)

	attunelocal_resultScrollSerial = (attunelocal_resultScrollSerial or 0) + 1
	local serial = attunelocal_resultScrollSerial

	-- Template OnValueChanged calls SetVerticalScroll on the parent. This parent is not a ScrollFrame.
	local vbar = CreateFrame("Slider", "FTAttuneResultVBar"..serial, holder, "UIPanelScrollBarTemplate")
	vbar:SetScript("OnValueChanged", nil)
	vbar:SetWidth(16)
	vbar:SetMinMaxValues(0, 0)
	vbar:SetValueStep(1)
	vbar:SetValue(0)
	vbar:Hide()
	vbar:EnableMouseWheel(true)
	vbar:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_ResultScrollWheel(delta, false)
	end)
	vbar:SetScript("OnValueChanged", function(_, value)
		if holder.noupdate then return end
		holder.vOffset = value or 0
		FTAttune_ApplyResultScroll()
	end)
	holder.vbar = vbar

	local hbar = CreateFrame("Slider", "FTAttuneResultHBar"..serial, holder)
	hbar:SetOrientation("HORIZONTAL")
	hbar:SetHeight(16)
	hbar:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	local thumb = hbar:GetThumbTexture()
	if thumb then thumb:SetSize(16, 16) end
	local track = hbar:CreateTexture(nil, "BACKGROUND")
	track:SetColorTexture(0, 0, 0, 0.45)
	track:SetAllPoints()
	hbar:SetMinMaxValues(0, 0)
	hbar:SetValueStep(1)
	hbar:SetValue(0)
	hbar:Hide()
	hbar:EnableMouseWheel(true)
	hbar:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_ResultScrollWheel(delta, true)
	end)
	hbar:SetScript("OnValueChanged", function(_, value)
		if holder.noupdate then return end
		holder.hOffset = value or 0
		FTAttune_ApplyResultScroll()
	end)
	holder.hbar = hbar
	vbar:SetFrameLevel(holder:GetFrameLevel() + 8)
	hbar:SetFrameLevel(holder:GetFrameLevel() + 8)

	holder:SetScript("OnMouseWheel", function(_, delta)
		FTAttune_ResultScrollWheel(delta)
	end)

	holder.RefreshBars = function()
		if holder.closing or holder.refreshing or not holder:IsShown() then return end
		holder.refreshing = true
		local width = holder:GetWidth() or 0
		local height = holder:GetHeight() or 0
		local headerH = headerScroll:GetHeight() or 0
		local nameW = holder.nameW or FTAttune_ResultNameWidth()
		if nameW > width - pad * 2 - 80 then nameW = math.max(80, width - pad * 2 - 80) end
		local contentW = holder.contentW or 1
		local contentH = holder.contentH or 1
		if attunelocal_resultHeader and attunelocal_resultHeader.frame then
			contentW = math.max(contentW, attunelocal_resultHeader.frame:GetWidth() or 0)
		end
		if attunelocal_glist and attunelocal_glist.frame then
			contentW = math.max(contentW, attunelocal_glist.frame:GetWidth() or 0)
			contentH = math.max(contentH, attunelocal_glist.frame:GetHeight() or 0)
		end
		if attunelocal_resultNames and attunelocal_resultNames.frame then
			contentH = math.max(contentH, attunelocal_resultNames.frame:GetHeight() or 0)
		end
		local bar = 18
		local bodyRoom = math.max(1, height - pad * 2 - headerH)
		local resultsRoom = math.max(1, width - pad * 2 - nameW)
		local needV = contentH > bodyRoom + 1
		local needH = contentW > resultsRoom + 1
		if needV then needH = contentW > (resultsRoom - bar) + 1 end
		if needH then needV = contentH > (bodyRoom - bar) + 1 end
		local right = -(pad + (needV and bar or 0))
		local bottom = pad + (needH and bar or 0)

		nameHead:ClearAllPoints()
		nameHead:SetPoint("TOPLEFT", holder, "TOPLEFT", pad, -pad)
		nameHead:SetSize(nameW, headerH)

		nameScroll:ClearAllPoints()
		nameScroll:SetPoint("TOPLEFT", nameHead, "BOTTOMLEFT", 0, 0)
		nameScroll:SetPoint("BOTTOMLEFT", holder, "BOTTOMLEFT", pad, bottom)
		nameScroll:SetWidth(nameW)

		headerScroll:ClearAllPoints()
		headerScroll:SetPoint("TOPLEFT", nameHead, "TOPRIGHT", 0, 0)
		headerScroll:SetPoint("TOPRIGHT", holder, "TOPRIGHT", right, -pad)
		headerScroll:SetHeight(headerH)

		bodyScroll:ClearAllPoints()
		bodyScroll:SetPoint("TOPLEFT", headerScroll, "BOTTOMLEFT", 0, 0)
		bodyScroll:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", right, bottom)

		holder.headerBg:ClearAllPoints()
		holder.headerBg:SetPoint("TOPLEFT", holder, "TOPLEFT", pad, -pad)
		holder.headerBg:SetPoint("TOPRIGHT", holder, "TOPRIGHT", right, -pad)
		holder.headerBg:SetHeight(math.max(headerH, 1))

		holder.nameShade:ClearAllPoints()
		holder.nameShade:SetPoint("TOPLEFT", nameHead, "TOPLEFT", 0, 0)
		holder.nameShade:SetPoint("BOTTOMRIGHT", nameScroll, "BOTTOMRIGHT", 0, 0)

		holder.divider:ClearAllPoints()
		holder.divider:SetPoint("TOP", nameHead, "TOPRIGHT", 0, 0)
		holder.divider:SetPoint("BOTTOM", nameScroll, "BOTTOMRIGHT", 0, 0)

		holder.headerLine:ClearAllPoints()
		holder.headerLine:SetPoint("TOPLEFT", nameHead, "BOTTOMLEFT", 0, 0)
		holder.headerLine:SetPoint("TOPRIGHT", headerScroll, "BOTTOMRIGHT", 0, 0)
		holder.headerLine:SetHeight(1)

		if needV then
			vbar:ClearAllPoints()
			vbar:SetPoint("TOPRIGHT", holder, "TOPRIGHT", -pad, -(pad + 16))
			vbar:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -pad, bottom + 16)
			vbar:Show()
		else
			vbar:Hide()
		end
		if needH then
			hbar:ClearAllPoints()
			hbar:SetPoint("BOTTOMLEFT", holder, "BOTTOMLEFT", pad + nameW, pad)
			hbar:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", right, pad)
			hbar:Show()
		else
			hbar:Hide()
		end

		local viewW = math.max(1, width - nameW - pad + right)
		local viewH = math.max(1, height - pad - headerH - bottom)
		local maxW = math.max(0, contentW - viewW)
		local maxH = math.max(0, contentH - viewH)
		if holder.headerContent then holder.headerContent:SetSize(math.max(contentW, 1), math.max(headerH, 1)) end
		if holder.bodyContent then holder.bodyContent:SetSize(math.max(contentW, 1), math.max(contentH, 1)) end
		if holder.nameContent then holder.nameContent:SetSize(math.max(nameW, 1), math.max(contentH, 1)) end
		if headerScroll.UpdateScrollChildRect then headerScroll:UpdateScrollChildRect() end
		if bodyScroll.UpdateScrollChildRect then bodyScroll:UpdateScrollChildRect() end
		if nameScroll.UpdateScrollChildRect then nameScroll:UpdateScrollChildRect() end
		holder.hOffset = math.max(0, math.min(maxW, holder.hOffset or 0))
		holder.vOffset = math.max(0, math.min(maxH, holder.vOffset or 0))
		holder.noupdate = true
		hbar:SetMinMaxValues(0, maxW)
		vbar:SetMinMaxValues(0, maxH)
		hbar:SetValue(holder.hOffset)
		vbar:SetValue(holder.vOffset)
		holder.noupdate = nil
		FTAttune_ApplyResultScroll()
		holder.refreshing = false
	end

	holder:SetScript("OnSizeChanged", function()
		holder.RefreshBars()
	end)

	holder:SetScript("OnUpdate", function()
		if not holder:IsShown() then return end
		local guild = attunelocal_guildframe
		local window = attunelocal_frame
		if not guild or not guild.content or not window or not window.frame then return end
		local pLeft, pTop = parent:GetLeft(), parent:GetTop()
		local cLeft, cRight, cBottom = guild.content:GetLeft(), guild.content:GetRight(), guild.content:GetBottom()
		if not pLeft or not pTop or not cLeft or not cRight or not cBottom then return end
		local filterBottom = nil
		for _, widget in ipairs(holder.above or {}) do
			local b = widget.frame and widget.frame:IsShown() and widget.frame:GetBottom()
			if b and (not filterBottom or b < filterBottom) then filterBottom = b end
		end
		if not filterBottom then return end
		local left = math.floor(cLeft - pLeft + 2)
		local top = math.floor(filterBottom - 8 - pTop)
		local right = math.floor(cRight - pLeft - 2)
		local bottom = math.floor(cBottom - pTop + 2)
		local key = left.."|"..top.."|"..right.."|"..bottom
		if key == holder.placeKey then return end
		holder.placeKey = key
		holder:ClearAllPoints()
		holder:SetPoint("TOPLEFT", parent, "TOPLEFT", left, top)
		holder:SetPoint("BOTTOMRIGHT", parent, "TOPLEFT", right, bottom)
	end)

	attunelocal_resultHolder = holder
	return holder
end

function FTAttune_CloseResultTable()
	-- Drop queued row builders before the widgets they would parent are released.
	attunelocal_resultListSerial = (attunelocal_resultListSerial or 0) + 1
	local holder = attunelocal_resultHolder
	if holder then
		holder.closing = true
		holder:Hide()
	end
	local function releaseWidget(widget)
		if not widget then return end
		FTAttune_UnbindResultFrame(widget.frame)
		-- Leave the scroll child in place. Release only the Ace widget that was mounted inside it.
		widget:Release()
	end
	releaseWidget(attunelocal_glist)
	attunelocal_glist = nil
	releaseWidget(attunelocal_resultNames)
	attunelocal_resultNames = nil
	releaseWidget(attunelocal_resultHeader)
	attunelocal_resultHeader = nil
	releaseWidget(attunelocal_resultNameHeader)
	attunelocal_resultNameHeader = nil
	if holder then
		holder.hOffset = 0
		holder.vOffset = 0
		holder.contentW = nil
		holder.contentH = nil
		holder.above = nil
		holder.placeKey = nil
		holder.noupdate = true
		if holder.hbar then
			holder.hbar:SetMinMaxValues(0, 0)
			holder.hbar:SetValue(0)
		end
		if holder.vbar then
			holder.vbar:SetMinMaxValues(0, 0)
			holder.vbar:SetValue(0)
		end
		holder.noupdate = nil
		-- Stay closed until the next results open. Scrolling here runs while the rows are being released.
		holder:Hide()
	end
end

function FTAttune_UpdateResultScroll()
	local holder = attunelocal_resultHolder
	if not holder or not holder:IsShown() or holder.updating then return end
	holder.updating = true
	local nameW = FTAttune_ResultNameWidth()
	local colW = FTAttune_ResultColumnsWidth()
	holder.nameW = nameW
	local header = attunelocal_resultHeader
	local nameHeader = attunelocal_resultNameHeader
	local hh = 36
	if header then
		header.frame:Show()
		header:SetWidth(colW)
		header:DoLayout()
		hh = header.frame:GetHeight() or 0
		if hh < 28 then hh = 28 end
		header.frame:SetSize(colW, hh)
		holder.headerScroll:SetHeight(hh)
		holder.contentW = colW
		if holder.headerScroll.UpdateScrollChildRect then holder.headerScroll:UpdateScrollChildRect() end
	end
	if nameHeader then
		nameHeader.frame:Show()
		nameHeader:SetAutoAdjustHeight(false)
		nameHeader:SetWidth(nameW)
		nameHeader:SetHeight(hh)
		nameHeader.frame:SetSize(nameW, hh)
		if holder.nameHead then holder.nameHead:SetHeight(hh) end
		-- Flow pins these labels to the top, and the label widget snaps its text
		-- back to the top whenever it is resized. Stretch each title to the header
		-- and center the fontstring in that full height.
		local content = nameHeader.content
		if content and nameHeader.children then
			local x = 0
			for _, child in ipairs(nameHeader.children) do
				local w = child.frame.width or child.frame:GetWidth() or 0
				child.OnWidthSet = function() end
				if child.label and not child._attuneCenterHook then
					local origSetText = child.SetText
					child.SetText = function(self, text)
						origSetText(self, text)
						if self._attuneCenter then self:_attuneCenter() end
					end
					child._attuneCenterHook = true
				end
				child._attuneCenter = function(self)
					if not self.label then return end
					self.label:ClearAllPoints()
					self.label:SetPoint("LEFT", self.frame, "LEFT", 0, 0)
					self.label:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
					self.label:SetJustifyV("MIDDLE")
					self.label:SetWordWrap(false)
				end
				child.frame:ClearAllPoints()
				child.frame:SetPoint("TOPLEFT", content, "TOPLEFT", x, 0)
				child.frame:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", x, 0)
				child.frame:SetWidth(w)
				x = x + w
				if child._attuneCenter then child:_attuneCenter() end
			end
		end
	end
	local lh = 1
	if attunelocal_glist then
		attunelocal_glist.frame:Show()
		attunelocal_glist:SetWidth(colW)
		attunelocal_glist.content.width = colW
		attunelocal_glist:DoLayout()
		lh = math.max(lh, attunelocal_glist.frame:GetHeight() or 0)
	end
	if attunelocal_resultNames then
		attunelocal_resultNames.frame:Show()
		attunelocal_resultNames:SetWidth(nameW)
		attunelocal_resultNames.content.width = nameW
		attunelocal_resultNames:DoLayout()
		lh = math.max(lh, attunelocal_resultNames.frame:GetHeight() or 0)
	end
	if lh < 1 then lh = 1 end
	if attunelocal_glist then
		attunelocal_glist.frame:SetSize(colW, lh)
		if holder.bodyScroll.UpdateScrollChildRect then holder.bodyScroll:UpdateScrollChildRect() end
	end
	if attunelocal_resultNames then
		attunelocal_resultNames.frame:SetSize(nameW, lh)
		if holder.nameScroll.UpdateScrollChildRect then holder.nameScroll:UpdateScrollChildRect() end
	end
	holder.contentW = colW
	holder.contentH = lh
	holder.updating = false
	holder.RefreshBars()
end

-------------------------------------------------------------------------
-- Toggle between the FTAttune tab and the result summary tab
-------------------------------------------------------------------------

function FTAttune_ToggleView(noToggle)

	FTAttune_SaveTreeExpandStatus()
	if FTAttune_HideQuestDetail then FTAttune_HideQuestDetail() end

	if noToggle == nil then noToggle = false end

	FTAttune_ReleaseZoomSlider()
	FTAttune_HideDungeonArt()
	FTAttune_ShowWorkInProgress(false)
	FTAttune_CloseResultTable()
	attunelocal_frame:ReleaseChildren()
	--Hiding all frames
	for i, f in pairs(attunelocal_frames) do _G[f]:Hide() end
	-- Take the chain off the scroll child before that scroll frame is released.
	-- SetPoint on a scroll child that still holds line regions access-violates.
	if attunelocal_graphRoot then
		attunelocal_graphRoot:Hide()
		attunelocal_graphRoot:SetParent(UIParent)
	end

	if attunelocal_treeIsShown or noToggle then

		_G["GuildButton"]:SetText(FTAttuneLang["Attunes"])

		-- SHOW RESULT FRAME
		PlaySound(856)  --igMainMenuOptionCheckBoxOn
		attunelocal_treeIsShown = false
		FTAttune_UpdateWindowPortrait()

		attunelocal_guildframe = FTAttune_AceCreate("SimpleGroup")
		attunelocal_guildframe:SetLayout("Flow")
		attunelocal_guildframe:SetFullWidth(true)
		attunelocal_guildframe:SetFullHeight(true)
		attunelocal_guildframe:SetAutoAdjustHeight(false)
		attunelocal_frame:AddChild(attunelocal_guildframe)




		--Display guild name and sort message
		local titleGroup = FTAttune_AceCreate("SimpleGroup")
		titleGroup:SetRelativeWidth(0.28)

			local label = FTAttune_AceCreate("Label")
			label:SetText(attunelocal_myguild)
			if UnitFactionGroup("player") == 'Horde' then
				label:SetImage("Interface\\Icons\\inv_bannerpvp_01")
			else
				label:SetImage("Interface\\Icons\\inv_bannerpvp_02")
			end
			label:SetFont(GameFontHighlight:GetFont(), 24, "")
			label:SetImageSize(32,32)
			label:SetFullWidth(true)
			titleGroup:AddChild(label)


			local spacer = FTAttune_AceCreate("Label")
			spacer:SetText(" \n ")
			spacer:SetFullWidth(true)
			titleGroup:AddChild(spacer)
--[[
			local spacer = FTAttune_AceCreate("Label")
			spacer:SetText(" \n ")
			spacer:SetFullWidth(true)
			titleGroup:AddChild(spacer)
]]
			
--[=[ Open Raid Planner / Show Profiles disabled for now
			local raid = FTAttune_AceCreate("Button")
			raid:SetText(FTAttuneLang["Open Raid Planner"])
			raid:SetCallback("OnClick", function()
				if attunelocal_initial == false and attunelocal_frame:IsShown() then 
					attunelocal_frame:Hide()
					FTAttune_Release()
				end
				FTAttune_RaidPlannerFrame()
				end)
			titleGroup:AddChild(raid)
			--raid:SetDisabled(true)
			raid.frame:Hide()


			local prof = FTAttune_AceCreate("Button")
			if attunelocal_showResultAttunes then
				 prof:SetText(FTAttuneLang["Show Profiles"])
				 --raid:SetDisabled(true)
				 raid.frame:Hide()
			else 
				prof:SetText(FTAttuneLang["Show Progress"])
				--raid:SetDisabled(false)
				raid.frame:Show() -- only show when looking at profiles
			end
			prof:SetCallback("OnClick", function()
				attunelocal_showResultAttunes = not attunelocal_showResultAttunes

				if attunelocal_showResultAttunes then prof:SetText(FTAttuneLang["Show Profiles"])
				else prof:SetText(FTAttuneLang["Show Progress"])
				end
				FTAttune_ToggleView(true)
			end)
			titleGroup:AddChild(prof)


]=]
		attunelocal_guildframe:AddChild(titleGroup)


		-- Two columns: My Toons / Guild members, then Last survey results / All results
		local radioGroup = FTAttune_AceCreate("SimpleGroup")
		radioGroup:SetLayout("Flow")
		radioGroup:SetRelativeWidth(0.45)

		local radio1 = FTAttune_AceCreate("CheckBox")
		radio1:SetType("radio")
		radio1:SetLabel(FTAttuneLang["Last survey results"])
		radio1:SetValue(attunelocal_resultselection == 0)
		radio1:SetRelativeWidth(0.5)

		local radio2 = FTAttune_AceCreate("CheckBox")
		radio2:SetType("radio")
		radio2:SetLabel(FTAttuneLang["Guild members"])
		radio2:SetValue(attunelocal_resultselection == 1)
		radio2:SetRelativeWidth(0.5)

		local radio3 = FTAttune_AceCreate("CheckBox")
		radio3:SetType("radio")
		radio3:SetLabel(FTAttuneLang["My Toons"])
		radio3:SetValue(attunelocal_resultselection == 2)
		radio3:SetRelativeWidth(0.5)

		local radio4 = FTAttune_AceCreate("CheckBox")
		radio4:SetType("radio")
		radio4:SetLabel(FTAttuneLang["All results"])
		radio4:SetValue(attunelocal_resultselection == 3)
		radio4:SetRelativeWidth(0.5)

		radioGroup:AddChild(radio3)
		radioGroup:AddChild(radio1)
		radioGroup:AddChild(radio2)
		radioGroup:AddChild(radio4)

		radio1:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 0
			radio1:SetValue(true)
			radio2:SetValue(false)
			radio3:SetValue(false)
			radio4:SetValue(false)
			FTAttune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
			-- else FTAttune_ShowProfileList(label)	end
		end)
		radio2:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 1
			radio1:SetValue(false)
			radio2:SetValue(true)
			radio3:SetValue(false)
			radio4:SetValue(false)
			FTAttune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
			-- else FTAttune_ShowProfileList(label)	end
		end)
		radio3:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 2
			radio1:SetValue(false)
			radio2:SetValue(false)
			radio3:SetValue(true)
			radio4:SetValue(false)
			FTAttune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
			-- else FTAttune_ShowProfileList(label)	end
		end)
		radio4:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 3
			radio1:SetValue(false)
			radio2:SetValue(false)
			radio3:SetValue(false)
			radio4:SetValue(true)
			FTAttune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
			-- else FTAttune_ShowProfileList(label)	end
		end)
		attunelocal_guildframe:AddChild(radioGroup)


		local syncGroup = FTAttune_AceCreate("SimpleGroup")
		syncGroup:SetRelativeWidth(0.25)

			--Slider
			local slider = FTAttune_AceCreate("Slider")
			slider:SetValue(FTAttune_DB.minFilterValue or 1)
			slider:SetSliderValues(1, 60, 1)
			slider:SetLabel(FTAttuneLang["Minimum level"])
			slider:SetCallback("OnValueChanged", function(slid)
				FTAttune_DB.minFilterValue = slid:GetValue()
			end)
			slider:SetCallback("OnMouseUp", function(slid)
				FTAttune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
				-- else FTAttune_ShowProfileList(label)	end
			end)
			syncGroup:AddChild(slider)

			-- local spacer = FTAttune_AceCreate("Label")
			-- spacer:SetText(" \n ")
			-- spacer:SetFullWidth(true)
			-- syncGroup:AddChild(spacer)

			-- local sync = FTAttune_AceCreate("Button")
			-- sync:SetText(FTAttuneLang["Sync with target"])
			-- sync:SetCallback("OnClick", function()
			-- 	FTAttune_SendSyncRequest()
			-- end)
			-- syncGroup:AddChild(sync)

		attunelocal_guildframe:AddChild(syncGroup)




		-- show attunes or profiles
		if attunelocal_showResultAttunes then 
			--show attunes

			-- Frozen name column, then the result columns that scroll sideways.
			local resultHolder = FTAttune_EnsureResultHolder()
			resultHolder.above = { titleGroup, radioGroup, syncGroup }
			local guildLevel = attunelocal_guildframe.frame:GetFrameLevel() or attunelocal_frame.frame:GetFrameLevel()
			resultHolder:SetFrameLevel(guildLevel + 20)
			resultHolder.closing = false
			resultHolder:Show()

			local nameHeader = FTAttune_AceCreate("SimpleGroup")
			nameHeader:SetLayout("Flow")
			nameHeader:SetWidth(FTAttune_ResultNameWidth())
			attunelocal_resultNameHeader = nameHeader
			nameHeader.frame:SetParent(resultHolder.nameHead)
			nameHeader.frame:ClearAllPoints()
			nameHeader.frame:SetPoint("TOPLEFT", resultHolder.nameHead, "TOPLEFT", 0, 0)

			local headPad = FTAttune_AceCreate("Label")
			headPad:SetWidth(4)
			nameHeader:AddChild(headPad)

			local function addSortHeader(text, width, key, startHigh, justify)
				local lab = FTAttune_AceCreate("InteractiveLabel")
				lab:SetText(text)
				lab:SetWidth(width)
				lab:SetFont(GameFontHighlight:GetFont(), 12, "")
				lab:SetJustifyH(justify or "CENTER")
				lab:SetCallback("OnClick", function()
					if FTAttune_DB.sortresult[1] == key then
						FTAttune_DB.sortresult[2] = not FTAttune_DB.sortresult[2]
					else
						FTAttune_DB.sortresult[1] = key
						-- true sorts low-to-high. Level starts with the high levels first.
						FTAttune_DB.sortresult[2] = not startHigh
					end
					FTAttune_ShowResultList(label)
				end)
				nameHeader:AddChild(lab)
				return lab
			end

			-- -5 level, -6 class, 0 name. Same keys the result sort uses.
			addSortHeader(FTAttuneLang["Level"], FTAttune_ResultLevelWidth(), -5, true, "CENTER")
			addSortHeader(FTAttuneLang["Class"], FTAttune_ResultClassWidth(), -6, false, "CENTER")
			attunelocal_gflabel = addSortHeader(FTAttuneLang["Character"], FTAttune_ResultCharWidth(), 0, false, "LEFT")

			local gftitle = FTAttune_AceCreate("SimpleGroup")
			gftitle:SetLayout("Flow")
			gftitle:SetAutoAdjustHeight(true)
			attunelocal_resultHeader = gftitle
			FTAttune_MountResultWidget(gftitle, resultHolder.headerContent)
			gftitle:SetWidth(FTAttune_ResultColumnsWidth())


			local expac = ""
			for i, a in pairs(FTAttune_Data.attunes) do
				if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) and not FTAttune_IsClassQuest(a) then 

					if (FTAttuneTreeExpandStatus[a.EXPAC] == nil 
					or FTAttuneTreeExpandStatus[a.EXPAC] == 1) 
					and (FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == nil 
					or FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == 1) then 


						if expac ~= a.EXPAC.."-"..a.GROUP then
							local gfspacer = FTAttune_AceCreate("Label")
							gfspacer:SetText(" ")
							gfspacer:SetWidth(10)
							gftitle:AddChild(gfspacer)
							expac = a.EXPAC.."-"..a.GROUP
						end

						if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then
							local gficon = FTAttune_AceCreate("Icon")
							gficon:SetImage(a.ICON)
							gficon:SetWidth(30)
							gficon:SetImageSize(24, 24)
							gficon.frame:SetScript("OnClick", function()
								if FTAttune_DB.sortresult[1] == a.ID then
									--same sort, just change order
									FTAttune_DB.sortresult[2] = not FTAttune_DB.sortresult[2]
								else
									FTAttune_DB.sortresult[1] = a.ID
									FTAttune_DB.sortresult[2] = true --desc better for attunes, but we're reversing % further down.
								end
								FTAttune_ShowResultList(label) -- profiles disabled
								-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
								-- else FTAttune_ShowProfileList(label)	end
				
							end)
							gficon.frame:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(a.NAME.." - "..a.EXPAC)  end)
							gficon.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)
							gftitle:AddChild(gficon)
						end
					end
				end
			end

			FTAttune_BindResultFrame(nameHeader.frame)
			FTAttune_BindResultFrame(gftitle.frame)

			attunelocal_resultNames = FTAttune_AceCreate("SimpleGroup")
			attunelocal_resultNames:SetLayout("List")
			attunelocal_resultNames:SetAutoAdjustHeight(true)
			FTAttune_MountResultWidget(attunelocal_resultNames, resultHolder.nameContent)
			attunelocal_resultNames:SetWidth(FTAttune_ResultNameWidth())

			attunelocal_glist = FTAttune_AceCreate("SimpleGroup")
			attunelocal_glist:SetLayout("List")
			attunelocal_glist:SetAutoAdjustHeight(true)
			FTAttune_MountResultWidget(attunelocal_glist, resultHolder.bodyContent)
			attunelocal_glist:SetWidth(FTAttune_ResultColumnsWidth())

			FTAttune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
			-- else FTAttune_ShowProfileList(label)	end

			FTAttune_BindResultFrame(nameHeader.frame)
			FTAttune_BindResultFrame(gftitle.frame)
			FTAttune_UpdateResultScroll()

--[=[ Show Profiles view disabled for now
		else

			--show profiles

			--Header row
			local gftitle = FTAttune_AceCreate("InlineGroup")
			gftitle:SetLayout("Flow")
			gftitle:SetAutoAdjustHeight(true)
			gftitle:SetFullWidth(true)


			attunelocal_gflabel = FTAttune_AceCreate("InteractiveLabel")
			attunelocal_gflabel:SetText(FTAttuneLang["Character"])
			attunelocal_gflabel:SetWidth(200)
			attunelocal_gflabel:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel:SetCallback("OnClick", function()
				if FTAttune_DB.sortresult[1] == 0 then
					--same sort, just change order
					FTAttune_DB.sortresult[2] = not FTAttune_DB.sortresult[2]
				else
					FTAttune_DB.sortresult[1] = 0
					FTAttune_DB.sortresult[2] = true
				end
				FTAttune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
				-- else FTAttune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel)

			attunelocal_gflabel2 = FTAttune_AceCreate("InteractiveLabel")
			attunelocal_gflabel2:SetText(FTAttuneLang["Guild"])
			attunelocal_gflabel2:SetWidth(240)
			attunelocal_gflabel2:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel2:SetCallback("OnClick", function()
				if FTAttune_DB.sortresult[1] == -1 then
					--same sort, just change order
					FTAttune_DB.sortresult[2] = not FTAttune_DB.sortresult[2]
				else
					FTAttune_DB.sortresult[1] = -1
					FTAttune_DB.sortresult[2] = true
				end
				FTAttune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
				-- else FTAttune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel2)

			attunelocal_gflabel3 = FTAttune_AceCreate("InteractiveLabel")
			attunelocal_gflabel3:SetText(FTAttuneLang["Status"])
			attunelocal_gflabel3:SetWidth(100)
			attunelocal_gflabel3:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel3:SetCallback("OnClick", function()
				if FTAttune_DB.sortresult[1] == -2 then
					--same sort, just change order
					FTAttune_DB.sortresult[2] = not FTAttune_DB.sortresult[2]
				else
					FTAttune_DB.sortresult[1] = -2
					FTAttune_DB.sortresult[2] = false
				end
				FTAttune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
				-- else FTAttune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel3)

			attunelocal_gflabel4 = FTAttune_AceCreate("InteractiveLabel")
			attunelocal_gflabel4:SetText(FTAttuneLang["Role"])
			attunelocal_gflabel4:SetWidth(100)
			attunelocal_gflabel4:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel4:SetCallback("OnClick", function()
				if FTAttune_DB.sortresult[1] == -3 then
					--same sort, just change order
					FTAttune_DB.sortresult[2] = not FTAttune_DB.sortresult[2]
				else
					FTAttune_DB.sortresult[1] = -3
					FTAttune_DB.sortresult[2] = false
				end
				FTAttune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
				-- else FTAttune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel4)

			attunelocal_gflabel5 = FTAttune_AceCreate("InteractiveLabel")
			attunelocal_gflabel5:SetText("    "..FTAttuneLang["Last Surveyed"])
			attunelocal_gflabel5:SetWidth(150)
			attunelocal_gflabel5:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel5:SetCallback("OnClick", function()
				if FTAttune_DB.sortresult[1] == -4 then
					--same sort, just change order
					FTAttune_DB.sortresult[2] = not FTAttune_DB.sortresult[2]
				else
					FTAttune_DB.sortresult[1] = -4
					FTAttune_DB.sortresult[2] = true
				end
				FTAttune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
				-- else FTAttune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel5)

			local gficon = FTAttune_AceCreate("Icon")
			gficon:SetImage("Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\empty")
			gficon:SetWidth(30)
			gficon:SetImageSize(24, 24)
			gftitle:AddChild(gficon)

			attunelocal_guildframe:AddChild(gftitle)


			attunelocal_gscroll = FTAttune_AceCreate("ScrollFrame")
			attunelocal_gscroll:SetLayout("Flow")
			attunelocal_gscroll:SetFullWidth(true)
			
	
			-- This script needed to allow the scrollframe resize whenever content changes or vertical size is moved
			attunelocal_gscroll.frame:SetScript("OnUpdate", function()
				attunelocal_gscroll:SetHeight(attunelocal_frame.frame:GetHeight() - 255)
			end)

			attunelocal_glist = FTAttune_AceCreate("SimpleGroup")
			attunelocal_glist:SetLayout("Flow")
			attunelocal_glist:SetAutoAdjustHeight(true)
			attunelocal_glist:SetFullWidth(true)

			FTAttune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
			-- else FTAttune_ShowProfileList(label)	end

			attunelocal_gscroll:AddChild(attunelocal_glist)

			attunelocal_guildframe:AddChild(attunelocal_gscroll)
]=]

		end

	else

		_G["GuildButton"]:SetText(FTAttuneLang["Results"])

		-- SHOW TREE FRAME
		attunelocal_treeIsShown = true
		FTAttune_UpdateWindowPortrait()

		-- create the tree
		attunelocal_treeframe = FTAttune_AceCreate("TreeGroup")
		FTAttune_StyleTreeGroup(attunelocal_treeframe)
		FTAttune_InstallIconView(attunelocal_treeframe)
		attunelocal_treeframe:SetTree(attunelocal_tree)
		attunelocal_treeframe:SetLayout("FTAttuneFill")
		attunelocal_treeframe:SetFullWidth(true)
		attunelocal_treeframe:SetFullHeight(true)
		attunelocal_treeframe:SetAutoAdjustHeight(false)
		-- Avoid AceGUI TreeGroup tooltip SetText(..., true-as-alpha) which errors on classic beta
		attunelocal_treeframe:EnableButtonTooltips(false)
		attunelocal_frame:AddChild(attunelocal_treeframe)

		for i, a in pairs(FTAttune_Data.attunes) do
			if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) then 
				if FTAttuneTreeExpandStatus[a.EXPAC] == nil then FTAttuneTreeExpandStatus[a.EXPAC] = 1 end
				if FTAttuneTreeExpandStatus[a.EXPAC] == 1 then attunelocal_treeframe:SelectByPath(a.EXPAC) end

				if FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == nil then FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] = 1 end
				if FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == 1 then attunelocal_treeframe:SelectByPath(a.EXPAC.."\001"..a.GROUP) end
			end
		end
		if FTAttune_DB.archiveCompleted then
			local archived = FTAttuneLang["Archived"]
			for _, expacNode in ipairs(attunelocal_tree) do
				if expacNode.value then
					local key = expacNode.value .. "\001" .. archived
					if FTAttuneTreeExpandStatus[key] == nil then FTAttuneTreeExpandStatus[key] = 1 end
					if FTAttuneTreeExpandStatus[key] == 1 then attunelocal_treeframe:SelectByPath(expacNode.value, archived) end
				end
			end
		end
		attunelocal_treeframe:SetCallback("OnGroupSelected", function(container, event, selection)
			--check if it's a top level expac
			local st, le = string.find(selection, "\001")
			if st ~= nil then -- not top level
				--get actual attune (remove expac/group)
				expac, group, sel = strsplit("\001", selection);
				if sel ~= "" and sel ~= nil then
					FTAttune_SetLastViewed(selection)
					FTAttune_Select(sel)
				end
			end
		end)

		attunelocal_treeframe:SetCallback("OnTreeResize", function(container, event, width)
			local minTree = attunelocal_treeMinWidth
			if FTAttune_MinTreeWidth then minTree = math.max(minTree, FTAttune_MinTreeWidth()) end
			if type(width) == "number" and width >= minTree and width <= attunelocal_treeMaxWidth then
				FTAttune_DB.treeWidth = width
			end
		end)

		attunelocal_right = FTAttune_AceCreate("SimpleGroup")
		attunelocal_right:SetLayout("FTAttuneFill")
		attunelocal_right:SetFullWidth(true)
		attunelocal_right:SetFullHeight(true)
		attunelocal_right:SetAutoAdjustHeight(false)
		attunelocal_treeframe:AddChild(attunelocal_right)

		attunelocal_scroll = FTAttune_AceCreate("ScrollFrame")
		attunelocal_scroll:SetLayout("List")
		attunelocal_scroll:SetFullWidth(true)
		attunelocal_scroll:SetFullHeight(true)
		attunelocal_scroll:SetAutoAdjustHeight(false)
		attunelocal_right:AddChild(attunelocal_scroll)

		FTAttune_CreateZoomSlider()

		--select default attune (or last viewed) for this character
		local lastViewed = FTAttune_GetLastViewed()
		if lastViewed then attunelocal_treeframe:SelectByPath(lastViewed) end

	end

end

-------------------------------------------------------------------------
-- Create the FTAttune list shown in the Result tab
-------------------------------------------------------------------------

function FTAttune_ShowResultList(title)

	local count = 0 -- number of rows displayed in table

	-- number of steps per attune - this is to calculate % completion
	local attuneSteps = {}
	for i, s in pairs(FTAttune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE ~= "Spacer" then
				if attuneSteps[s.ID_ATTUNE] == nil then attuneSteps[s.ID_ATTUNE] = 0 end
				attuneSteps[s.ID_ATTUNE] = attuneSteps[s.ID_ATTUNE] +1
			end
		end
	end

	-- adjust the title according to the selection
	if title ~= nil then
		local gg = attunelocal_myguild
		if gg == "" then gg = FTAttuneLang['Not in a guild'] end

		if attunelocal_resultselection == 0 then
			title:SetText(FTAttuneLang["Last survey results"])
		elseif attunelocal_resultselection == 1 then
			title:SetText(gg)
		elseif attunelocal_resultselection == 2 then
			title:SetText(FTAttuneLang["My Toons"])
		else
			local fact, factLoc = UnitFactionGroup("player")
			title:SetText(FTAttuneLang["All FACTION results"]:gsub("##FACTION##", factLoc ))
		end

	end

	-- Drop wheel hooks before pooled row widgets go back to Ace.
	attunelocal_resultListSerial = (attunelocal_resultListSerial or 0) + 1
	local listSerial = attunelocal_resultListSerial
	if attunelocal_glist then
		FTAttune_UnbindResultFrame(attunelocal_glist.frame)
		attunelocal_glist:ReleaseChildren()
		FTAttune_BindResultFrame(attunelocal_glist.frame)
	end
	if attunelocal_resultNames then
		FTAttune_UnbindResultFrame(attunelocal_resultNames.frame)
		attunelocal_resultNames:ReleaseChildren()
		FTAttune_BindResultFrame(attunelocal_resultNames.frame)
	end
	-- Same gap on both columns so the first name and its results stay aligned.
	local function addListGap(list)
		if not list then return end
		local gap = FTAttune_AceCreate("SimpleGroup")
		gap:SetFullWidth(true)
		gap:SetAutoAdjustHeight(false)
		gap:SetHeight(4)
		list:AddChild(gap)
	end
	addListGap(attunelocal_resultNames)
	addListGap(attunelocal_glist)
	FTAttune_UpdateResultScroll()


	-- parse all recorded toons and get their progress
	local spacerDone = {}
	for _, s in pairs(FTAttune_Data.steps) do
		if s.TYPE == "Spacer" then spacerDone[s.ID_ATTUNE .. "-" .. s.ID] = true end
	end
	for kt, t in pairs(FTAttune_DB.toons) do
		-- calculate how many steps this toon has done on the attune
		local attuneDone = {}
		if t.done ~= nil then 
			FTAttune_AutoCompleteSpacers(kt)
			for i, d in pairs(t.done) do
				if not spacerDone[i] then
					local Ids = FTAttune_split(i, "-")
					if attuneDone[Ids[1]] == nil then attuneDone[Ids[1]] = 0 end
					attuneDone[Ids[1]] = attuneDone[Ids[1]] +1
				end
			end

			if t.attuned == nil then t.attuned = {} end
			for i, a in pairs(FTAttune_Data.attunes) do
				if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) then 
					if attuneDone[a.ID] == nil then attuneDone[a.ID] = 0 end
					if (attuneSteps[a.ID] or 0) > 0 then
						t.attuned[a.ID] = math.floor(100*(attuneDone[a.ID]/attuneSteps[a.ID]))
					else
						t.attuned[a.ID] = 0
					end
				end
			end
			FTAttune_ApplyCompletedEndSteps(t)
		end
	end


	-- display the list according to the sort order
	--for kt, t in FTAttune_spairs(FTAttune_DB.toons, function(t,a,b) 	return b > a end) do
	for kt, t in FTAttune_spairs(FTAttune_DB.toons, function(t,a,b)
		if FTAttune_DB.sortresult[1] == 0 then
			if FTAttune_DB.sortresult[2] then
				return b > a
			else
				return a > b
			end
		elseif FTAttune_DB.sortresult[1] == -1 then
			if FTAttune_DB.sortresult[2] then
				return t[b].guild > t[a].guild
			else
				return t[a].guild > t[b].guild
			end
		elseif FTAttune_DB.sortresult[1] == -2 then
			if FTAttune_DB.sortresult[2] then
				return FTAttune_StatusRole(t[b].status) > FTAttune_StatusRole(t[a].status)
			else
				return FTAttune_StatusRole(t[a].status) > FTAttune_StatusRole(t[b].status)
			end
		elseif FTAttune_DB.sortresult[1] == -3 then
			if FTAttune_DB.sortresult[2] then
				return FTAttune_StatusRole(t[b].role) > FTAttune_StatusRole(t[a].role)
			else
				return FTAttune_StatusRole(t[a].role) > FTAttune_StatusRole(t[b].role)
			end
		elseif FTAttune_DB.sortresult[1] == -4 then
			if FTAttune_DB.sortresult[2] then
				return t[b].survey > t[a].survey
			else
				return t[a].survey > t[b].survey
			end
		elseif FTAttune_DB.sortresult[1] == -5 then
			local la = tonumber(t[a].level) or 0
			local lb = tonumber(t[b].level) or 0
			if la ~= lb then
				if FTAttune_DB.sortresult[2] then return lb > la else return la > lb end
			end
			if FTAttune_DB.sortresult[2] then return b > a else return a > b end
		elseif FTAttune_DB.sortresult[1] == -6 then
			local ca = string.upper(t[a].class or "")
			local cb = string.upper(t[b].class or "")
			if ca ~= cb then
				if FTAttune_DB.sortresult[2] then return cb > ca else return ca > cb end
			end
			if FTAttune_DB.sortresult[2] then return b > a else return a > b end
		else 
			--sort by attune % AND name. reversing the % with "100-" to be able to sort names alpha
			if FTAttune_DB.sortresult[2] then
				return string.format("%03i", 100-t[b].attuned[FTAttune_DB.sortresult[1]]) .. b > string.format("%03i", 100-t[a].attuned[FTAttune_DB.sortresult[1]]) .. a
			else
				return string.format("%03i", 100-t[a].attuned[FTAttune_DB.sortresult[1]]) .. a > string.format("%03i", 100-t[b].attuned[FTAttune_DB.sortresult[1]]) .. b
			end
		end
	 end) do

		-- only look at current faction (and current realm)
		--if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then  -- removing realm
        if t.faction == UnitFactionGroup("player") and (kt == t.name) then

			-- look for:
			-- 		if attunelocal_resultselection == 0, players in the same guild, or if unguilded just this player
			-- 		if attunelocal_resultselection == 1, players that have been put in the survey list
			--		if attunelocal_resultselection == 2, all players recorded
			if (attunelocal_resultselection == 0 and FTAttune_DB.survey[kt])
			or (attunelocal_resultselection == 1 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == attunelocal_myFullName))
			or (attunelocal_resultselection == 2 and t.owner == 1) 
			or (attunelocal_resultselection == 3) then

				if tonumber(t.level) >= (FTAttune_DB.minFilterValue or 1) then

					count = count + 1

					C_Timer.After(0.01*count, function()
						if listSerial ~= attunelocal_resultListSerial or not attunelocal_glist then return end
						local lev = tostring(t.level or "")

						local ggg = t.guild
						if ggg == '' then ggg = "(Not in a guild)" else ggg = "<"..ggg..">" end

						local vvv = t.version
						if vvv == nil then vvv = "- Very old addon version" else vvv = " - v"..vvv.."" end

						local sss = t.survey
						if sss == nil then sss = "- No survey date recorded" else sss = "- Last surveyed on "..date("%d %b %Y", sss).."" end
						
						local activeName = t.name
						local inactive = false
						if t.survey == nil or t.survey == 0 then 
						else
							if t.survey < time() - attunelocal_inactivity then 
								-- old inactive toon
								inactive = true
								activeName = "|c80606060"..activeName.."|r"
								sss = sss .. " (inactive)"
							end 
						end
						local rowH = FTAttune_ResultRowHeight()
						local function rowStatusIn()
							attunelocal_frame:SetStatusText(t.name.." "..ggg.." "..vvv.." "..sss)
						end
						local function rowStatusOut()
							attunelocal_frame:SetStatusText(attunelocal_statusText)
						end

						-- Frozen name. Same height as the result row so the two columns stay aligned.
						local nameRow = FTAttune_AceCreate("SimpleGroup")
						nameRow:SetLayout("Flow")
						nameRow:SetAutoAdjustHeight(false)
						nameRow:SetHeight(rowH)
						nameRow:SetFullWidth(true)
						nameRow.frame:SetScript("OnEnter", rowStatusIn)
						nameRow.frame:SetScript("OnLeave", rowStatusOut)

						local namePad = FTAttune_AceCreate("Label")
						namePad:SetWidth(4)
						nameRow:AddChild(namePad)

						local lvlLabel = FTAttune_AceCreate("Label")
						lvlLabel:SetText("|c80606060"..lev.."|r")
						lvlLabel:SetWidth(FTAttune_ResultLevelWidth())
						lvlLabel:SetJustifyH("CENTER")
						lvlLabel:SetFont(GameFontNormal:GetFont(), 12, "")
						nameRow:AddChild(lvlLabel)

						local classLabel = FTAttune_AceCreate("Label")
						classLabel:SetText("|T"..FTAttune_Icons(string.upper(t.class), nil)..":16|t")
						classLabel:SetWidth(FTAttune_ResultClassWidth())
						classLabel:SetJustifyH("CENTER")
						classLabel:SetFont(GameFontNormal:GetFont(), 12, "")
						nameRow:AddChild(classLabel)

						local glabel = FTAttune_AceCreate("Label")
						glabel:SetText(activeName)
						glabel:SetWidth(FTAttune_ResultCharWidth())
						glabel:SetFont(GameFontNormal:GetFont(), 12, "")
						nameRow:AddChild(glabel)

						-- Result columns. These are the part that scrolls sideways.
						local gframe = FTAttune_AceCreate("SimpleGroup")
						gframe:SetLayout("Flow")
						gframe:SetAutoAdjustHeight(false)
						gframe:SetHeight(rowH)
						gframe:SetFullWidth(true)
						gframe.frame:SetScript("OnEnter", rowStatusIn)
						gframe.frame:SetScript("OnLeave", rowStatusOut)

						-- Nudge the cells right so they sit under the header icons.
						local resultPad = FTAttune_AceCreate("Label")
						resultPad:SetWidth(3)
						gframe:AddChild(resultPad)

						-- Go through each FTAttune and create the corresponding % label for this toon
						local expac = ""
						for i, a in pairs(FTAttune_Data.attunes) do
							if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) and not FTAttune_IsClassQuest(a) then 

								if (FTAttuneTreeExpandStatus[a.EXPAC] == nil 
									or FTAttuneTreeExpandStatus[a.EXPAC] == 1) 
									and (FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == nil 
									or FTAttuneTreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == 1) then 
					
									-- This spacer to separate Wow classic from TBC attunes
									if expac ~= a.EXPAC.."-"..a.GROUP then
										local gfspacer = FTAttune_AceCreate("Label")
										gfspacer:SetText(" ")
										gfspacer:SetWidth(10)
										gframe:AddChild(gfspacer)
										expac = a.EXPAC.."-"..a.GROUP
									end

									-- Only look at attunes for this toon's faction
									if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then

										local gflabel = FTAttune_AceCreate("Label")
										if t.attuned[a.ID] >= 100 then
											if inactive then 
												gflabel:SetText("|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\successinactive:16|t")
											else 
												gflabel:SetText("|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\success:16|t")
											end
										else
											if inactive then 
												gflabel:SetText("|c80606060"..t.attuned[a.ID].."%|r")
											else 
												gflabel:SetText(t.attuned[a.ID].."%")
											end
										end
										gflabel:SetWidth(30)
										gframe:AddChild(gflabel)

									end
								end
							end
						end


						if attunelocal_charKey ~= kt then
							-- add a delete button, to allow removing players from our data (for example if they changed guilds)
							local gdel = FTAttune_AceCreate("Button")
							gdel:SetText("X")
							gdel:SetWidth(FTAttune_ResultDeleteWidth())
							gdel:SetCallback("OnClick", function()
								FTAttune_DB.toons[kt] = nil
								FTAttune_ShowResultList(label) -- profiles disabled
								-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
								-- else FTAttune_ShowProfileList(label)	end
					
							end)
							nameRow:AddChild(gdel)
						end

						nameRow:SetHeight(rowH)
						gframe:SetHeight(rowH)
						if attunelocal_resultNames then attunelocal_resultNames:AddChild(nameRow) end
						attunelocal_glist:AddChild(gframe)
						FTAttune_BindResultFrame(nameRow.frame)
						FTAttune_BindResultFrame(gframe.frame)
						FTAttune_UpdateResultScroll()
					end) -- end of timer function
				end
			end
		end
	end

	attunelocal_gflabel:SetText(FTAttuneLang["Characters"].." ("..count..")")
	FTAttune_UpdateResultScroll()

end

--[=[ Show Profiles list disabled for now
-------------------------------------------------------------------------
-- Create the Profile list shown in the Result tab
-------------------------------------------------------------------------

function FTAttune_ShowProfileList(title)

	local count = 0 -- number of rows displayed in table
	local att = FTAttune_DB.toons[attunelocal_charKey]

	-- adjust the title according to the selection
	if title ~= nil then
		local gg = attunelocal_myguild
		if gg == "" then gg = FTAttuneLang['Not in a guild'] end

		if attunelocal_resultselection == 0 then
			title:SetText(FTAttuneLang["Last survey results"])
		elseif attunelocal_resultselection == 1 then
			title:SetText(gg)
		elseif attunelocal_resultselection == 2 then
			title:SetText(FTAttuneLang["My Toons"])
		else
			local fact, factLoc = UnitFactionGroup("player")
			title:SetText(FTAttuneLang["All FACTION results"]:gsub("##FACTION##", factLoc ))
		end

	end

	attunelocal_glist:ReleaseChildren()


	-- display the list according to the sort order
	--for kt, t in FTAttune_spairs(FTAttune_DB.toons, function(t,a,b) 	return b > a end) do
	for kt, t in FTAttune_spairs(FTAttune_DB.toons, function(t,a,b)
		if FTAttune_DB.sortresult[1] == 0 then
			if FTAttune_DB.sortresult[2] then
				return b > a
			else
				return a > b
			end
		elseif FTAttune_DB.sortresult[1] == -1 then
			if FTAttune_DB.sortresult[2] then
				return t[b].guild > t[a].guild
			else
				return t[a].guild > t[b].guild
			end
		elseif FTAttune_DB.sortresult[1] == -2 then
			if FTAttune_DB.sortresult[2] then
				return FTAttune_StatusRole(t[b].status) > FTAttune_StatusRole(t[a].status)
			else
				return FTAttune_StatusRole(t[a].status) > FTAttune_StatusRole(t[b].status)
			end
		elseif FTAttune_DB.sortresult[1] == -3 then
			if FTAttune_DB.sortresult[2] then
				return FTAttune_StatusRole(t[b].role) > FTAttune_StatusRole(t[a].role)
			else
				return FTAttune_StatusRole(t[a].role) > FTAttune_StatusRole(t[b].role)
			end
		elseif FTAttune_DB.sortresult[1] == -4 then
			if FTAttune_DB.sortresult[2] then
				return t[b].survey > t[a].survey
			else
				return t[a].survey > t[b].survey
			end
		else 
			--sort by attune % AND name. reversing the % with "100-" to be able to sort names alpha
			if FTAttune_DB.sortresult[2] then
				return string.format("%03i", 100-FTAttune_IfNilZero(t[b].attuned[FTAttune_DB.sortresult[1] ])) .. b > string.format("%03i", 100-FTAttune_IfNilZero(t[a].attuned[FTAttune_DB.sortresult[1] ])) .. a
			else
				return string.format("%03i", 100-FTAttune_IfNilZero(t[a].attuned[FTAttune_DB.sortresult[1] ])) .. a > string.format("%03i", 100-FTAttune_IfNilZero(t[b].attuned[FTAttune_DB.sortresult[1] ])) .. b
			end
		end
	 end) do

		-- only look at current faction (and current realm)
		if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then

			-- look for:
			-- 		if attunelocal_resultselection == 0, players in the same guild, or if unguilded just this player
			-- 		if attunelocal_resultselection == 1, players that have been put in the survey list
			--		if attunelocal_resultselection == 2, all players recorded
			if (attunelocal_resultselection == 0 and FTAttune_DB.survey[kt])
			or (attunelocal_resultselection == 1 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == attunelocal_myFullName))
			or (attunelocal_resultselection == 2 and t.owner == 1) 
			or (attunelocal_resultselection == 3) then

				if tonumber(t.level) >= (FTAttune_DB.minFilterValue or 1) then

					count = count + 1

					C_Timer.After(0.01*count, function()
						local lev = t.level
						if tonumber(lev) < 10 then lev = "  "..lev end -- align numbers when under 10

						local ggg = t.guild
						if ggg == '' then ggg = "(Not in a guild)" else ggg = "<"..ggg..">" end

						local vvv = t.version
						if vvv == nil then vvv = "- Very old addon version" else vvv = "- v"..vvv.."" end

						local sss = t.survey
						if sss == nil then sss = "- No survey date recorded" else sss = "- Last surveyed on "..date("%d %b %Y", sss).."" end
						
						local activeName = t.name
						local inactive = false
						if t.survey == nil or t.survey == 0 then 
						else
							if t.survey < time() - attunelocal_inactivity then 
								-- old inactive toon
								inactive = true
								activeName = "|c80606060"..activeName.."|r"
								sss = sss .. " (inactive)"
							end 
						end

						-- container for the whole row
						local gframe = FTAttune_AceCreate("SimpleGroup")
						gframe:SetLayout("Flow")
						gframe:SetAutoAdjustHeight(true)
						gframe:SetFullWidth(true)
						gframe.frame:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(t.name.."  "..ggg.." "..sss)  end)
						gframe.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)

						-- add toon part
							local glabel = FTAttune_AceCreate("Label")
							glabel:SetText("    |c80606060"..lev.."|r  |T"..FTAttune_Icons(string.upper(t.class), nil)..":16|t  "..activeName)
							glabel:SetWidth(210)
							glabel:SetFont(GameFontNormal:GetFont(), 12, "")
							gframe:AddChild(glabel)

							local gguild = FTAttune_AceCreate("Label")
							if inactive then gguild:SetText("|c80606060"..t.guild.."|r") else gguild:SetText(t.guild) end
							gguild:SetWidth(240)
							gguild:SetFont(GameFontNormal:GetFont(), 12, "")
							gframe:AddChild(gguild)

							if t.owner == 1 or (t.guild == att.guild and att.officer == "1") then 
								local gstatus = FTAttune_AceCreate("Dropdown")
								gstatus:SetWidth(100)
								gstatus:SetList({
--									["None"] = "-",
									["Main"] = FTAttune_StatusRole("Main"),
									["Alt"] = FTAttune_StatusRole("Alt"),
									["Bank"] = FTAttune_StatusRole("Bank"),								
								}, {"Main", "Alt", "Bank"})
								if t.status == nil then t.status = "None" end
								gstatus:SetValue(t.status)
								gstatus:SetCallback("OnValueChanged", function(choice) 
									t.status = choice:GetValue() 
									if attunelocal_myguild ~= "" then FTAttune:SendCommMessage(attunelocal_prefix, t.name .. "|TOONSTATUS|" .. t.status, "GUILD") end 
								end )
								gframe:AddChild(gstatus)

								
								local grole = FTAttune_AceCreate("Dropdown")
								grole:SetWidth(100)
								grole:SetList({
--									["None"] = "-",
									["Tank"] = FTAttune_StatusRole("Tank"),
									["Healer"] = FTAttune_StatusRole("Healer"),
									["Melee"] = FTAttune_StatusRole("Melee"),
									["Ranged"] = FTAttune_StatusRole("Ranged"),
								}, {"Tank", "Healer", "Melee", "Ranged"})
								if t.role == nil then t.role = "None" end
								grole:SetValue(t.role)
								grole:SetCallback("OnValueChanged", function(choice) 
									t.role = choice:GetValue() 
									if attunelocal_myguild ~= "" then FTAttune:SendCommMessage(attunelocal_prefix, t.name .. "|TOONROLE|" .. t.role, "GUILD") end 
								end )
								gframe:AddChild(grole)

							else
								local gstatus = FTAttune_AceCreate("Label")
								if t.status == nil then t.status = "None" end
								if inactive then gstatus:SetText("|c80606060"..FTAttune_StatusRole(t.status).."|r") else gstatus:SetText(FTAttune_StatusRole(t.status)) end
								gstatus:SetWidth(100)
								gstatus:SetFont(GameFontNormal:GetFont(), 12, "")
								gframe:AddChild(gstatus)

								local grole = FTAttune_AceCreate("Label")
								if t.role == nil then t.role = "None" end
								if inactive then grole:SetText("|c80606060"..FTAttune_StatusRole(t.role).."|r") else grole:SetText(FTAttune_StatusRole(t.role)) end
								grole:SetWidth(100)
								grole:SetFont(GameFontNormal:GetFont(), 12, "")
								gframe:AddChild(grole)

							end

							local glast = FTAttune_AceCreate("Label")
							if t.survey == nil or t.survey == 0 then 
								glast:SetText("    -")
								if inactive then glast:SetText("|c80606060    -|r") else glast:SetText("    -") end
							else 
								--glast:SetText("    "..FTAttuneLang['Seconds ago']:gsub("##DURATION##", FTAttune_formatTime(time() - t.survey)) )
								glast:SetText("    "..date("%d %b %Y at %H:%M", t.survey) )
								if inactive then glast:SetText("|c80606060    "..date("%d %b %Y at %H:%M", t.survey).."|r") else glast:SetText("    "..date("%d %b %Y at %H:%M", t.survey) ) end
							end
							glast:SetWidth(190)
							glast:SetFont(GameFontNormal:GetFont(), 12, "")
							gframe:AddChild(glast)


						if attunelocal_charKey ~= kt then
							-- add a delete button, to allow removing players from our data (for example if they changed guilds)
							local gdel = FTAttune_AceCreate("Button")
							gdel:SetText("X")
							gdel:SetWidth(50)
							gdel:SetCallback("OnClick", function()
								FTAttune_DB.toons[kt] = nil
								FTAttune_ShowResultList(label) -- profiles disabled
								-- if attunelocal_showResultAttunes then FTAttune_ShowResultList(label)
								-- else FTAttune_ShowProfileList(label)	end

							end)
							gframe:AddChild(gdel)
						end

						-- add the row to the list
						attunelocal_glist:AddChild(gframe)
						attunelocal_gscroll.content.obj.content:SetHeight(attunelocal_frame.frame:GetHeight() - 80)
					end) -- end of timer function
				end
			end
		end
	end

	attunelocal_gflabel:SetText(FTAttuneLang["Characters"].." ("..count..")")
	attunelocal_gscroll.content.obj.content:SetHeight(attunelocal_frame.frame:GetHeight() - 80)

end]=]


-------------------------------------------------------------------------

function FTAttune_StatusRole(keyword)

	if keyword == "None" then return "-" end

	if keyword == "Main" then return FTAttuneLang["Main"] end
	if keyword == "Alt" then return FTAttuneLang["Alt"] end

	if keyword == "Tank" then return FTAttuneLang["Tank"] end
	if keyword == "Healer" then return FTAttuneLang["Healer"] end
	if keyword == "Melee" then return FTAttuneLang["Melee DPS"] end
	if keyword == "Ranged" then return FTAttuneLang["Ranged DPS"] end

	if keyword == "Bank" then return FTAttuneLang["Bank"] end
end

-------------------------------------------------------------------------

function FTAttune_IfNilZero(val)
	if val == nil then return 0
	else return val end
end


function FTAttune_count(tab)
	local attunelocal_count = 0
	for Index, Value in pairs(tab) do
		attunelocal_count = attunelocal_count + 1
	end
	return attunelocal_count

end


-------------------------------------------------------------------------
-- Send the Addon request (surve) to the selected channel
-------------------------------------------------------------------------

function FTAttune_SendRequest(what)

	local IsTarget = FTAttune_split(what, "|")

	FTAttune_DB.survey = {}
	if IsTarget[1] == "Target" then 
		-- local tar = IsTarget[2] .. "-" .. attunelocal_realm
        -- print("tar", tar)
		if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["SendingSurveyTo"]:gsub("##TO##", IsTarget[2])) end
		FTAttune:SendCommMessage(attunelocal_prefix, "SILENTSURVEY", "WHISPER", IsTarget[2]);
	else
		if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["SendingSurveyWhat"]:gsub("##WHAT##", FTAttuneLang[what])) end
		FTAttune:SendCommMessage(attunelocal_prefix, "SURVEY", string.upper(what), "");
	end

end

-------------------------------------------------------------------------
-- This is the same as SendRequest('Guild') except the surveyed players
-- won't see a message saying they replied.
-- Useful for debug purposes, to not annoy players with repeated messages
-------------------------------------------------------------------------

function FTAttune_SendSilentGuildRequest()
	FTAttune_DB.survey = {}
	if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["SendingGuildSilentSurvey"]) end
	if attunelocal_myguild ~= "" then FTAttune:SendCommMessage(attunelocal_prefix, "SILENTSURVEY", "GUILD", ""); end

end

-------------------------------------------------------------------------
-- Send my attune information (request results)
-- Information is sent back via addon whisper to the surveyRequestor
-- This defines what is sent back (1. toon meta, 2. steps done, 3. end)
-------------------------------------------------------------------------

function FTAttune_SendRequestResults(surveyRequestor)

	local meta = {}
	meta.l = UnitLevel("player")
	local attunelocal_faction = UnitFactionGroup("player")
	_, classFile = UnitClass("player")
	_, raceFile = UnitRace("player")

	local g = UnitSex("player")
	meta.g = 'male'
	if g == 3 then meta.g = 'female' end
	meta.c = classFile
	meta.r = raceFile   --Scourge, Troll, etc
	--meta.owner = 1

	local guildName, guildRankName, guildRank = GetGuildInfo("player");
	if guildName == nil then
		meta.o = 0 --not officer
		guildName = ""
	else
		if guildRank == 0 or CanGuildRemove() then
			meta.o = 1 --officer
		else
			meta.o = 0 --not officer
		end
	end
	attunelocal_myguild = guildName

	local att = FTAttune_DB.toons[attunelocal_charKey]
	if att.status == nil then att.status = "None" end
	if att.role == nil then 
		if meta.c == "MAGE" or meta.c == "WARLOCK"  or meta.c == "HUNTER" then att.role = "Ranged"
		elseif meta.c == "ROGUE" then att.role = "Melee"
		else att.role = "None" end
	end

	-- Send a first response with the player metadata	
	FTAttune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|TOON|" .. meta.g  .. "|" .. meta.c .. "|" .. meta.r .. "|" .. meta.l .. "|" .. meta.o .. "|".. guildName.."|"..attunelocal_version.."|"..att.status.."|"..att.role, "WHISPER", surveyRequestor)  --the last pipe is in case the guildname is empty. still need it as blank, not nil


	-- then send a bunch of followup whispers with the completed steps
	for key, status in pairs(att.done) do
		if status then --step done
			FTAttune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|DONE|" .. key, "WHISPER", surveyRequestor)
		end
	end

	-- Send a closing message after a bit (to make sure it arrives last)
	C_Timer.After(0.250, function()
		FTAttune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|OVER", "WHISPER", surveyRequestor)
	end)

end



-------------------------------------------------------------------------
-- Send my attune information (automatic push on completion)
-- Information is sent via addon guild spam
-- This defines what is sent back (1. toon meta, 2. steps done, 3. end)
-------------------------------------------------------------------------

function FTAttune_SendPushInfo(step)

	if step == "TOON" then 
		local meta = {}
		meta.l = UnitLevel("player")
		local attunelocal_faction = UnitFactionGroup("player")
		_, classFile = UnitClass("player")
		_, raceFile = UnitRace("player")

		local g = UnitSex("player")
		meta.g = 'male'
		if g == 3 then meta.g = 'female' end
		meta.c = classFile
		meta.r = raceFile   --Scourge, Troll, etc
		--meta.owner = 1

		local guildName, guildRankName, guildRank = GetGuildInfo("player");
		if guildName == nil then
			meta.o = 0 --not officer
			guildName = ""
		else
			if guildRank == 0 or CanGuildRemove() then
				meta.o = 1 --officer
			else
				meta.o = 0 --not officer
			end
		end
		attunelocal_myguild = guildName

		local att = FTAttune_DB.toons[attunelocal_charKey]
		if att.status == nil then att.status = "None" end
		if att.role == nil then 
			if meta.c == "MAGE" or meta.c == "WARLOCK"  or meta.c == "HUNTER" then att.role = "Ranged"
			elseif meta.c == "ROGUE" then att.role = "Melee"
			else att.role = "None" end
		end

		-- Send a first response with the player metadata
		if attunelocal_myguild ~= "" then FTAttune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|TOON|" .. meta.g  .. "|" .. meta.c .. "|" .. meta.r .. "|" .. meta.l .. "|" .. meta.o .. "|".. guildName.."|"..attunelocal_version.."|"..att.status.."|"..att.role, "GUILD") end --the last pipe is in case the guildname is empty. still need it as blank, not nil

	elseif step == "OVER" then 
		-- Send a closing message after a bit (to make sure it arrives last)
		C_Timer.After(0.250, function()
			if attunelocal_myguild ~= "" then FTAttune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|SILENTOVER", "GUILD") end
		end)

	else
		-- then send the data for that newly completed steps
		if attunelocal_myguild ~= "" then FTAttune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|SILENTDONE|" .. step, "GUILD") end
	end

end


-------------------------------------------------------------------------
-- Handle the replies from the survey
-- Typically comes as 1 'meta' whisper, many 'step' whispers and 1 'over'
--    META contains: name|TOON|gender|class|race|level|officer|guild
--    STEP contains: name|DONE|attune-step
--    OVER contains: name|OVER|
-------------------------------------------------------------------------

function FTAttune_HandleRequestResults(response)

	--consolidate responses
	local data = FTAttune_split(response, "|")
	local name = data[1]    --.."-"..attunelocal_realm
	local tag = data[2]


	FTAttune_DB.survey[name] = 1

	-- initialize the record for this player
	--	if attunelocal_data[name] == nil then attunelocal_data[name] = {} end
	--	local player = attunelocal_data[name]
	if FTAttune_DB.toons[name] == nil then FTAttune_DB.toons[name] = {} end
	local player = FTAttune_DB.toons[name]


	-- META reply
	if tag == 'TOON' then
		attunelocal_refreshDone = false
		attunelocal_count = attunelocal_count + 1
		player.name = data[1] -- full name
		player.gender = data[3]	--gender
		player.class = data[4]	--class
		player.race = data[5]	--race
		player.level = data[6]	--level
		player.officer = data[7]	--officer in their guild
		player.guild = data[8]	--guild
		player.version = data[9]	--version
		player.faction = UnitFactionGroup("player")
		player.survey = time()	--time of last survey
		if (data[10] ~= nil and data[10] ~= "None" and data[10] ~= "-") then player.status = data[10];	end --status
		if (data[11] ~= nil and data[11] ~= "None" and data[11] ~= "-") then player.role = data[11]; end	--role
		

		if player.status == nil then player.status = "None" end
		if player.role == nil then player.role = "None" end
		--print(""..player.name .." NORM "..player.status .. " / " .. player.role)

		if player.role == "None" then 
			if player.class == "MAGE" or player.class == "WARLOCK"  or player.class == "HUNTER" then player.role = "Ranged"
			elseif player.class == "ROGUE" then player.role = "Melee"
			end
		end

		if player.attuned == nil then player.attuned = {} end
		for i, a in pairs(FTAttune_Data.noattunes) do
			--mark as automatically attuned for those raids that do not require attunement
			if player.attuned[a.ID] == nil then player.attuned[a.ID] = 100 end
		end
			

		-- check if this is the requester or someone else
		if player.name == attunelocal_myFullName then player.owner = 1 else player.owner = 0 end

		-- initialize the STEP container
		if player.done == nil then	player.done = {}	end

		if player.version ~= nil then
			if player.version > attunelocal_version and not attunelocal_detectedNewer then
				attunelocal_detectedNewer = true
				if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["NewVersionAvailable"].." (v"..player.version..")") end-- detected someone with a newer version, warn the user
			end
		end

	elseif tag == 'TOONROLE' then
		if player.name ~= nil and data[3] ~= "None" then player.role = data[3] end   --don't add new members like this (not enough metadata)
--		print("received from "..player.name .." TOON role "..player.role)
	
	elseif tag == 'TOONSTATUS' then
		if player.name ~= nil and data[3] ~= "None" then player.status = data[3] end   --don't add new members like this (not enough metadata)
--		print("received from "..player.name .." TOON status "..player.status)


	-- STEP replies
	elseif tag == 'DONE' or tag == 'SILENTDONE' then
		--print("DONE " .. player.name .. ": " ..data[3])
		attunelocal_refreshDone = false
		-- DONE can arrive before TOON (or for a toon stub without done); ensure the table exists
		if player.done == nil then player.done = {} end
		player.done[data[3]] = 1 -- step
		if tag == 'SILENTDONE' then 
			--print("Received ".. data[3] .. " from " .. player.name)
			local s = FTAttune_Data.stepsByKey and FTAttune_Data.stepsByKey[data[3]]
			if s and showPatchStep(s) then
				-- recurse into earlier steps to mark them as done too
				C_Timer.After(0.01, function() FTAttune_recursePreviousSteps(name, s.ID_ATTUNE, s.FOLLOWS) end)
			end
		end


	-- OVER reply
	elseif tag == 'OVER' or tag == 'SILENTOVER' then
		--print(tag.." " .. player.name)
		attunelocal_refreshDone = false

		if player.name ~= attunelocal_myFullName then
			if tag == 'OVER' and FTAttune_DB.showResponses then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["ReceivedDataFromName"]:gsub("##NAME##",  player.name)) end -- received data from someone else, might as well announce it in chat
			FTAttune_CheckIsNext(name)
		end

		-- Wait a few seconds before refreshing the result tab, to avoid refreshing it multiple times
		C_Timer.After(5, function()
			if attunelocal_frame ~= nil then
				if not attunelocal_treeIsShown then
					if not attunelocal_refreshDone then 
						attunelocal_refreshDone = true
						FTAttune_ShowResultList() -- update result tab if already shown (profiles disabled)
						-- if attunelocal_showResultAttunes then FTAttune_ShowResultList()
						-- else FTAttune_ShowProfileList()	end
					end
-- Disabling the auto-swap to results as it's confusing					
--				else
--					if not attunelocal_initial then
--						attunelocal_resultselection = 0
--						FTAttune_ToggleView()
--					end
				end
				attunelocal_initial = false -- disable the 'no announce on first load'
			end
		end)
	end

end

-------------------------------------------------------------------------
-- encode data and show popup to copy it
-------------------------------------------------------------------------

function FTAttune_ExportToWebsite()

	attunelocal_data = {}
	attunelocal_data['_realm'] = GetRealmName() --attunelocal_realm
	attunelocal_data['_faction'] = UnitFactionGroup("player")

	local count = 0

	-- parse all recorded toons
	for kt, t in pairs(FTAttune_DB.toons) do

		-- only look at current faction and realm
		-- if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then  -- removing realm
        if t.faction == UnitFactionGroup("player") and (kt == t.name) then

			-- export data:
			-- 		if attunelocal_exportselection == 0, only this player
			-- 		if attunelocal_exportselection == 1, players that have been put in the survey list
			--		if attunelocal_exportselection == 2, all players in the same guild
			--		if attunelocal_exportselection == 3, all players recorded
			-- 		if attunelocal_exportselection == 4, all this player's data (main and alts)
			if (attunelocal_exportselection == 0 and kt == (attunelocal_charKey))
			or (attunelocal_exportselection == 4 and t.owner == 1)
			or (attunelocal_exportselection == 1 and FTAttune_DB.survey[kt])
			or (attunelocal_exportselection == 2 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == attunelocal_myFullName))
			or (attunelocal_exportselection == 3) then

				count = count + 1
				attunelocal_data[t.name] = {}
				attunelocal_data[t.name].g = t.gender
				attunelocal_data[t.name].c = t.class
				attunelocal_data[t.name].r = t.race
				attunelocal_data[t.name].l = t.level
				attunelocal_data[t.name].o = t.officer
				attunelocal_data[t.name].G = t.guild
				--attunelocal_data[t.name].f = t.faction
				attunelocal_data[t.name].owner = t.owner
				attunelocal_data[t.name].done = "-1"
				attunelocal_data[t.name].ro = t.role
				attunelocal_data[t.name].st = t.status
				attunelocal_data[t.name].s = t.survey

				for i, d in pairs(t.done) do
					attunelocal_data[t.name].done = attunelocal_data[t.name].done .. "|" .. i
				end
			end
		end
	end


	if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["ExportingData"]:gsub("##COUNT##", count)) end

	local serattunelocal_data = FTAttune_serialize(attunelocal_data)
	local ser = attunelocal_version .. "##" .. serattunelocal_data

	local encoded = FTAttune_enc(ser)

	StaticPopupDialogs["EXPORT_ATTUNE_GUILD"] = {
		text = FTAttuneLang["Copy the text below, then upload it to"].."\n\nhttps://warcraftratings.com/attune/upload",
		button1 = FTAttuneLang["Close"],
		OnShow = function (self, data)
			local editBox = self.EditBox or self.editBox
			editBox:SetText(""..encoded)
			editBox:HighlightText()
			editBox:SetScript("OnEscapePressed", function(self) StaticPopup_Hide ("EXPORT_ATTUNE_GUILD") end)

		end,
		timeout = 0,
		hasEditBox = true,
		editBoxWidth = 350,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show ("EXPORT_ATTUNE_GUILD")

end



-------------------------------------------------------------------------
-- send a request for a full Sync
-------------------------------------------------------------------------

function FTAttune_SendSyncRequest()
	if not UnitExists("target") then 
		if attunelocal_frame ~= nil then
			attunelocal_frame:SetStatusText(FTAttuneLang["No Target"])
			C_Timer.After(3, function()
				attunelocal_frame:SetStatusText(attunelocal_statusText)
			end)
		end
	else

		if attunelocal_syncStatus ~= -1 then 
			if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Cannot sync while another sync is in progress"]) end
		else 
            local targetFirst, targetLast = UnitName("target")
			attunelocal_syncTarget = targetFirst .. " " .. targetLast -- .. "-" .. GetRealmName()

			StaticPopupDialogs["SYNC_CONFIRM"] = {
				text = FTAttuneLang["Sending Sync Request"]:gsub("##PLAYER##", attunelocal_syncTarget) .. "\n\n" .. FTAttuneLang["Could be slow"],
				button1 = FTAttuneLang["Accept"],
				button2 = FTAttuneLang["Reject"],
				timeout = 0,
				hasEditBox = false,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnAccept = function()
					FTAttune_SentActualSyncRequest()
				end,
				OnCancel = function (_,reason)
					attunelocal_syncTarget = nil
				end,
			}
			StaticPopup_Show ("SYNC_CONFIRM")
		end
	end
end 

-------------------------------------------------------------------------

function FTAttune_SentActualSyncRequest()
	
	if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Sending Sync Request"]:gsub("##PLAYER##", attunelocal_syncTarget)) end
	attunelocal_syncStatus = 1
	--FTAttune:SendCommMessage(attunelocal_syncprefix, "SYNCREQ", "WHISPER", attunelocal_syncTarget)

	local ser = FTAttune_serialize(FTAttune_DB.toons):gsub(" = ", "="):gsub("   ", ""):gsub(" }", "}")
	--print("about to send:" ..#ser)
	FTAttune:SendCommMessage(attunelocal_syncprefix, "SYNCREQ|"..#ser, "WHISPER", attunelocal_syncTarget)
	
	-- Close request after 10s if no response
	C_Timer.After(10, function() 
		if attunelocal_syncStatus == 1 then
			--if attunelocal_frame ~= nil then
			--	attunelocal_frame:SetStatusText(FTAttuneLang["No Response From"]:gsub("##PLAYER##", attunelocal_syncTarget))
			--else 
				if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["No Response From"]:gsub("##PLAYER##", attunelocal_syncTarget)) end
			--end
			attunelocal_syncStatus = -1
			attunelocal_syncTarget = nil
			C_Timer.After(3, function()
				if attunelocal_frame ~= nil then
					 attunelocal_frame:SetStatusText(attunelocal_statusText) 
				end
			end)
		end
	end)
end

-------------------------------------------------------------------------

function FTAttune_StartSync()

	attunelocal_syncStatus = 2
	if attunelocal_syncStartTime == nil then attunelocal_syncStartTime = GetTime() end
	if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Request accepted, sending data to "]:gsub("##PLAYER##", attunelocal_syncTarget)) end

	--reuse object when possible
	local exist = false
	for _, f in ipairs(attunelocal_syncProgress_frames) do if f == "FTAttune_SyncProgress_Frame" then exist = true end end
	if exist then 	attunelocal_syncProgressWidget = _G["FTAttune_SyncProgress_Frame"] -- reuse
	else			attunelocal_syncProgressWidget = CreateFrame("Frame", "FTAttune_SyncProgress_Frame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
					table.insert(attunelocal_syncProgress_frames, "FTAttune_SyncProgress_Frame") -- recording, to reuse
	end


	attunelocal_syncProgressWidget:SetWidth(270)
	attunelocal_syncProgressWidget:SetHeight(50)
	attunelocal_syncProgressWidget:SetPoint("BOTTOM",UIParent, 0, 150)
	attunelocal_syncProgressWidget:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 32, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }	})
	attunelocal_syncProgressWidget:SetBackdropColor(0,0,0,1)
	attunelocal_syncProgressWidget:EnableMouse(true)
	attunelocal_syncProgressWidget:SetMovable(true)
	attunelocal_syncProgressWidget:SetFrameStrata("FULLSCREEN_DIALOG")
	attunelocal_syncProgressWidget:RegisterForDrag("LeftButton","RightButton");
	attunelocal_syncProgressWidget:SetClampedToScreen(true)
	attunelocal_syncProgressWidget:SetScript("OnDragStart", function()	attunelocal_syncProgressWidget:StartMoving()	end)
	attunelocal_syncProgressWidget:SetScript("OnDragStop", function()	attunelocal_syncProgressWidget:StopMovingOrSizing();	end)
	attunelocal_syncProgressWidget:Show()


	local attunelocal_syncProgressLabel = nil
	local exist = false
	for _, f in ipairs(attunelocal_syncProgress_frames) do if f == "FTAttune_SyncProgress_Label" then exist = true end end
	if exist then 	attunelocal_syncProgressLabel = _G["FTAttune_SyncProgress_Label"] -- reuse
	else			attunelocal_syncProgressLabel = attunelocal_syncProgressWidget:CreateFontString("FTAttune_SyncProgress_Label")
					table.insert(attunelocal_syncProgress_frames, "FTAttune_SyncProgress_Label") -- recording, to reuse
	end
	attunelocal_syncProgressLabel:SetPoint("TOPLEFT",attunelocal_syncProgressWidget, 10, -10)
	attunelocal_syncProgressLabel:SetFont(GameFontNormal:GetFont(), 12, "")
	attunelocal_syncProgressLabel:SetText(FTAttuneLang["Syncing FTAttune data with"]:gsub("##PLAYER##", attunelocal_syncTarget))
	

	attunelocal_syncProgressStatusBar = nil
	local exist = false
	for _, f in ipairs(attunelocal_syncProgress_frames) do if f == "FTAttune_SyncProgress_StatusBar" then exist = true end end
	if exist then 	attunelocal_syncProgressStatusBar = _G["FTAttune_SyncProgress_StatusBar"] -- reuse
	else			attunelocal_syncProgressStatusBar = CreateFrame("StatusBar", "FTAttune_SyncProgress_StatusBar", attunelocal_syncProgressWidget, BackdropTemplateMixin and "BackdropTemplate" or nil)
					table.insert(attunelocal_syncProgress_frames, "FTAttune_SyncProgress_StatusBar") -- recording, to reuse
	end
	attunelocal_syncProgressStatusBar:SetPoint("TOPLEFT",attunelocal_syncProgressWidget, 10, -26)
	attunelocal_syncProgressStatusBar:SetWidth(250)
	attunelocal_syncProgressStatusBar:SetHeight(10)
	attunelocal_syncProgressStatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	attunelocal_syncProgressStatusBar:GetStatusBarTexture():SetHorizTile(false)
	attunelocal_syncProgressStatusBar:SetStatusBarColor(1,0,0) 
	attunelocal_syncProgressStatusBar:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 32, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }	})
	attunelocal_syncProgressStatusBar:SetBackdropColor(0,0,0,1)
	attunelocal_syncProgressStatusBar:SetMinMaxValues(1, 100)
	attunelocal_syncProgressStatusBar:SetValue(0)
	attunelocal_syncProgressStatusBar:Show()


	--reduce string size
	local ser = FTAttune_serialize(FTAttune_DB.toons):gsub(" = ", "="):gsub("   ", ""):gsub(" }", "}")
	FTAttune:SendCommMessage(attunelocal_syncprefix, ser, "WHISPER", attunelocal_syncTarget, "BULK", FTAttune_OnChunkSent)

end

-------------------------------------------------------------------------

function FTAttune_OnChunkSent(arg, done, total)

	attunelocal_syncChunksSent = attunelocal_syncChunksSent + 1
	
	attunelocal_syncAmountToSend = total
	attunelocal_syncAmountSent = done
	attunelocal_syncProgressStatusBar:SetMinMaxValues(1, attunelocal_syncAmountToSend + attunelocal_syncAmountToReceive)
	attunelocal_syncProgressStatusBar:SetValue(attunelocal_syncAmountSent + attunelocal_syncAmountReceived)

	-- this is for the receiver to also show some progress (otherwise it will be stuck until this send is completely done)
	if attunelocal_syncChunksSent >= 10 then 
		FTAttune:SendCommMessage(attunelocal_syncprefix, "SYNCDONE|"..attunelocal_syncAmountSent, "WHISPER", attunelocal_syncTarget)
		attunelocal_syncChunksSent = 0
	end

	if (attunelocal_syncAmountSent + attunelocal_syncAmountReceived) >= (attunelocal_syncAmountToSend + attunelocal_syncAmountToReceive) then
		attunelocal_syncStatus = -1
		if attunelocal_syncStartTime ~= nil then
			if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Sync over"]:gsub("##DURATION##", FTAttune_formatTime(FTAttune_Round(GetTime() - attunelocal_syncStartTime, 0)))) end
		end
		attunelocal_syncProgressWidget:Hide()
		attunelocal_syncStartTime = nil
	end

end


-------------------------------------------------------------------------


function FTAttune:OnCommReceived(prefix, message, distribution, sender)

	--Sync channel
	if prefix == attunelocal_syncprefix then
		local amount = 0 
		if string.find(message, "|") then 
			local amess = FTAttune_split(message, "|")
			message = amess[1]
			amount = tonumber(amess[2])
		end

		if message == 'SYNCREQ' then
			if attunelocal_syncStatus ~= -1 then 
				FTAttune:SendCommMessage(attunelocal_syncprefix, "SYNCBUSY", "WHISPER", sender)
			else
				--print("about to receive:" ..amount)
				attunelocal_syncTarget = sender
				attunelocal_syncAmountToReceive = amount
				attunelocal_syncAmountReceived = 0
	
				if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Received request from"]:gsub("##PLAYER##", attunelocal_syncTarget)) end
				PlaySound(6675) -- BellTollTribal
				StaticPopupDialogs["SYNC_ATTUNE"] = {
					text = FTAttuneLang["Sync Request From"]:gsub("##PLAYER##", attunelocal_syncTarget).."\n\n"..FTAttuneLang["Could be slow"],
					button1 = FTAttuneLang["Accept"],
					button2 = FTAttuneLang["Reject"],
					timeout = 9,
					hasEditBox = false,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
					OnAccept = function()
						attunelocal_syncStatus = 2
						local ser = FTAttune_serialize(FTAttune_DB.toons):gsub(" = ", "="):gsub("   ", ""):gsub(" }", "}")
						--print("about to send:" ..#ser)
						FTAttune:SendCommMessage(attunelocal_syncprefix, "SYNCOK|"..#ser, "WHISPER", attunelocal_syncTarget)
						FTAttune_StartSync()
					end,
					OnCancel = function (_,reason)
						attunelocal_syncStatus = -1
						FTAttune:SendCommMessage(attunelocal_syncprefix, "SYNCNOK", "WHISPER", attunelocal_syncTarget)
						if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Request rejected"]) end
					end,
				}
				StaticPopup_Show ("SYNC_ATTUNE")
			end

		elseif message == 'SYNCOK' then
			--print("about to receive:" ..amount)
			attunelocal_syncAmountToReceive = amount
			FTAttune_StartSync()

		elseif message == 'SYNCNOK' then
			attunelocal_syncStatus = -1
			if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Request rejected"]) end

		elseif message == 'SYNCBUSY' then
			attunelocal_syncStatus = -1
			if FTAttune_DB.showOtherChat then print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Busy right now"]:gsub("##PLAYER##", sender)) end

		elseif message == 'SYNCDONE' then
			attunelocal_syncAmountReceived = amount
			--print("Processed so far " .. (attunelocal_syncAmountReceived + attunelocal_syncAmountSent) .. " / " .. (attunelocal_syncAmountToReceive + attunelocal_syncAmountToSend))
			FTAttune_OnChunkSent(arg, attunelocal_syncAmountSent, attunelocal_syncAmountToSend)

		else

			local SyncedToons = FTAttune_deserialize(message)
			for kt, t in pairs(SyncedToons) do
				t.owner = 0 -- force imports to be marked as not own
				
				if FTAttune_DB.toons[kt] == nil then
					--new toon
					FTAttune_DB.toons[kt] = t
				else 
					if FTAttune_DB.toons[kt].owner == 0 then -- do not update my own toons

						-- Check which data set has the latest survey
						if t.survey ~= nil and FTAttune_DB.toons[kt].survey ~= nil then 
							if t.survey > FTAttune_DB.toons[kt].survey then 
								-- Already have it, but this one is newer
								FTAttune_DB.toons[kt] = t
							end
						else 
							if t.survey ~= nil then 
								-- Already have it, but this one is newer (as the other doesn't have a date)
								FTAttune_DB.toons[kt] = t
							end
						end
					end
				end
			end
			C_Timer.After(1, function()
				if attunelocal_frame ~= nil then
					if not attunelocal_treeIsShown then
						FTAttune_ShowResultList() -- update result tab if already shown (profiles disabled)
						-- if attunelocal_showResultAttunes then FTAttune_ShowResultList()
						-- else FTAttune_ShowProfileList()	end
					else
						if not attunelocal_initial then
							attunelocal_resultselection = 0
							FTAttune_ToggleView()
						end
					end
					attunelocal_initial = false -- disable the 'no announce on first load'
				end
			end)
			
			attunelocal_syncAmountReceived = attunelocal_syncAmountToReceive
			FTAttune_OnChunkSent(arg, attunelocal_syncAmountSent, attunelocal_syncAmountToSend)
		end
	end
end 


-------------------------------------------------------------------------

function FTAttune_spairs(t, order)
    -- collect the keys
    local keys = {}
    local n = 0
    for k in pairs(t) do
        n = n + 1
        keys[n] = k
    end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-------------------------------------------------------------------------

function FTAttune_serialize (o)
	local res = ""
	if type(o) == "number" then
	  res = res .. o
	elseif type(o) == "string" then
		res = res .. string.format("%q", o)
	elseif type(o) == "table" then
		res = res .. "{ "
	  for k,v in pairs(o) do
		if type(k) == "number" then
			res = res .. "  [" .. k .. "] = "
		elseif type(k) == "string" then
			 res = res .. "  [\"" .. k .. "\"] = "
		end
		res = res .. FTAttune_serialize(v)
		res = res .. ", "
	  end
	  res = res ..  "}"
	elseif type(o) == "boolean" then
		if o then res = res .. "true"
		else res = res .. "false" end
	else
	  error("cannot serialize a " .. type(o))
	end
	return res
end

-------------------------------------------------------------------------
 
function FTAttune_deserialize(input)
	if type(input) == 'string' then
	   	local data = input
	   	local pos = 0
	   	function input(undo)
			if undo then
				pos = pos - 1
		  	else
				pos = pos + 1
				return string.sub(data, pos, pos)
		  	end
	   	end
	end

	local c
	repeat
		c = input()
	until c ~= ' ' and c ~= ','

	if c == '"' then
		--string value
	   	local s = ''
	   	repeat
		  	c = input()
		  	if c == '"' then
				--print("s = "..s)
				return s
		  	end
		  	s = s..c
	   	until c == ''

	elseif c == '-' or FTAttune_is_digit(c) then
		-- number value
	   	local s = c
	   	repeat
			c = input()
			local d = FTAttune_is_digit(c)
			if d then
				s = s..c
		  	end
	   	until not d
	   	input(true)
		--print("n = "..s)
	   return tonumber(s)

	elseif c == '[' then
		--print("[]")
		--Associative
	   	local o = ''
	   	repeat
		  c = input()
		  if c == ']' then
			 break
		  end
		  o = o..c
	   	until c == ''
		o = o:gsub('"', "") -- removing extra ""
	   	repeat
			c = input()
		until c == '='
		--print("o = "..o)

		local subarr = {}
		elem = FTAttune_deserialize(input)
		
		table.insert(subarr, "assoc")
		table.insert(subarr, o)
		table.insert(subarr, elem)
		return subarr

	elseif c == '{' then
		--array
		--print("{}")
	   	local arr = {}
	   	local elem
	   	repeat
		  	elem = FTAttune_deserialize(input)
			--print(type(elem))
		  	if type(elem) == 'table' then
				if elem[1] == "assoc" then 
					arr[elem[2]] = elem[3]
				else 
					table.insert(arr, elem)
				end
		  	else 
		  		table.insert(arr, elem)
			end
	   	until not elem
	   	return arr
	end
 end

------------------------------------------------------------------------- 

function FTAttune_is_digit(c)
	return c >= '0' and c <= '9'
end

-------------------------------------------------------------------------

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function FTAttune_enc(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-------------------------------------------------------------------------
-- decoding
function FTAttune_dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

-------------------------------------------------------------------------

function FTAttune_formatTime(sec)
	local str = ""

	if sec ~= nil then
		local minutes, hours
		if (sec<60) then
			str = ""..sec.."sec"
		else
			minutes = math.floor(sec/60)
			sec = sec - (minutes*60)
			if (minutes<60) then
				str =  ""..minutes.."min"
			else
				hours = math.floor(minutes/60)
				minutes = minutes - (hours*60)
				str = ""..hours.."h"
				if (minutes > 0) then str = str .. " "..minutes.."min" end
			end
			if (sec > 0) then str = str .. " "..sec.."sec" end
		end
	else
		str = ""
	end
	return str
end

-------------------------------------------------------------------------

function FTAttune_split(str, sep)
	local t = {}
	local ind = string.find(str, sep)
	while (ind ~= nil) do
		table.insert(t, string.sub(str, 1, ind-1))
		str = string.sub(str, ind+1)
		ind = string.find(str, sep, 1, true)
	end
	if (str ~="") then table.insert(t, str) end
	return t
end

-------------------------------------------------------------------------
-- find if key exists in table
function FTAttune_locate(table, value)
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end

-------------------------------------------------------------------------

function FTAttune_Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-------------------------------------------------------------------------

function FTAttune_Icons(what, gender)
	local icon = "Interface/Icons/inv_misc_questionmark"
	if (what == "DRUID") 	then icon = "Interface\\Icons\\inv_misc_monsterclaw_04" end
	if (what == "HUNTER") 	then icon = "Interface\\Icons\\inv_weapon_bow_07" end
	if (what == "MAGE") 	then icon = "Interface\\Icons\\inv_staff_13" end
	if (what == "PALADIN") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\class_paladin" end
	if (what == "PRIEST") 	then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\class_priest" 	end
	if (what == "ROGUE") 	then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\class_rogue" end
	if (what == "SHAMAN") 	then icon = "Interface\\Icons\\spell_nature_bloodlust" end
	if (what == "WARLOCK") then icon = "Interface\\Icons\\spell_nature_drowsy" end
	if (what == "WARRIOR") then icon = "Interface\\Icons\\inv_sword_27" end
	if (what == "DEATHKNIGHT") then icon = "Interface\\Icons\\Spell_deathknight_classicon" end
	if (what == "UNKNOWN") then icon = "Interface\\Icons\\Inv_misc_questionmark" end
	
	local g = 'male'
	if gender == 3 then g = 'female' end
	if (what == "Dwarf") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_dwarf_"..g end
	if (what == "Gnome") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_gnome_"..g end
	if (what == "Human") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_human_"..g end
	if (what == "NightElf") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_nightelf_"..g end
	if (what == "Orc") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_orc_"..g end
	if (what == "Tauren") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_tauren_"..g end
	if (what == "Troll") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_troll_"..g end
	if (what == "Scourge") then icon = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\achievement_character_undead_"..g end
	return icon
end

-------------------------------------------------------------------------

function FTAttune_SlashCommandHandler( msg )

	if (msg == 'help' or msg == '?') then

		print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Help1"])
		print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Help2"])
		print("|cffff00ff[FTAttune]|r ")
		print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Help3"])
		print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Help4"])
		print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Help5"])
		print("|cffff00ff[FTAttune]|r ")
		print("|cffff00ff[FTAttune]|r "..FTAttuneLang["Help6"])

	elseif (msg == 'survey') then
		FTAttune_SendRequest("Guild");

	elseif (msg == 'silentsurvey') then
		FTAttune_SendSilentGuildRequest();	-- Guild check, without triggering the response message on remote toons. Mostly for debugging without annoying players

	elseif (msg == 'sync') then
		FTAttune_SendSyncRequest()

	-- Raid Planner slash command disabled for now
	elseif false and ((msg == 'raid') or (msg == 'raidplanner') or (msg == 'planner')) then
		--[=[
		if attunelocal_raidframe ~= nil then
			if attunelocal_raidframe:IsShown() then 
				attunelocal_raidframe:Hide() 
			else
				FTAttune_RaidPlannerFrame()
			end
		else 
			FTAttune_RaidPlannerFrame()
		end
		]=]

	elseif (msg ~= '') then 
		FTAttune_SendRequest("Target|"..msg);

	elseif attunelocal_initial == false and attunelocal_frame:IsShown() then
		attunelocal_frame:Hide()
		FTAttune_SaveTreeExpandStatus()
		FTAttune_Release()
	else
		if attunelocal_initial then
			attunelocal_initial = false
			FTAttune_LoadTree()
			FTAttune_Frame()
			FTAttune_DB.survey = {}
			FTAttune_SendRequestResults(attunelocal_myFullName);  -- Send a request to myself
		end
		attunelocal_frame:Show()

	end

end


-------------------------------------------------------------------------

function FTAttune_Release()
	--[[
	if attunelocal_glist ~= nil then attunelocal_glist:ReleaseChildren() end
	if attunelocal_scroll ~= nil then attunelocal_scroll:ReleaseChildren() end
	if attunelocal_raidroster ~= nil then attunelocal_raidroster:ReleaseChildren() end
	if attunelocal_frame ~= nil then attunelocal_frame:ReleaseChildren() end
]]
end

--[=[ Raid Planner disabled for now
-------------------------------------------------------------------------

function FTAttune_LoadRaidTree()
	attunelocal_raidtree = {}


	local tankNode = {
		value = "Tank",
		text =  FTAttune_StatusRole("Tank"),
		children = {}
	}
	local healerNode = {
		value = "Healer",
		text =  FTAttune_StatusRole("Healer"),
		children = {}
	}
	local meleeNode = {
		value = "Melee",
		text =  FTAttune_StatusRole("Melee"),
		children = {}
	}
	local rangedNode = {
		value = "Ranged",
		text =  FTAttune_StatusRole("Ranged"),
		children = {}
	}
	local unspecNode = {
		value = "Unspec",
		text =  FTAttuneLang["Unspecified"],
		children = {}
	}
	
	for kt, t in FTAttune_spairs(FTAttune_DB.toons, function(t,a,b) return t[b].class > t[a].class end) do
		
		--only look at current faction and realm
		if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then
			--check they are attuned
			if FTAttune_DB.raidShowUnattuned or t.attuned[""..FTAttune_DB.raidSelection[attunelocal_faction]] >= 100 then
				
				if ((FTAttune_DB.raidShowMains and t.status == "Main") 
				or (FTAttune_DB.raidShowAlts and t.status == "Alt")
				or (FTAttune_DB.raidShowUnspecified and t.status == "None"))
				and (not FTAttune_DB.raidGuildOnly or t.guild == attunelocal_myguild)   then

					local tt = t.name
					if FTAttune_IsRaidSelected(t.name) ~= "" then tt = "|cff606060"..t.name.."|r" end

					local toonNode = {
						value = t.name,
						text = tt,
						icon = FTAttune_Icons(t.class),
					}
					
					if t.role == "Tank" then table.insert(tankNode.children, toonNode)
					elseif t.role == "Healer" then table.insert(healerNode.children, toonNode)
					elseif t.role == "Melee" then table.insert(meleeNode.children, toonNode)
					elseif t.role == "Ranged" then table.insert(rangedNode.children, toonNode)
					else table.insert(unspecNode.children, toonNode)
					end

					
				end
			end
		end
	end
	
	table.insert(attunelocal_raidtree, tankNode)
	table.insert(attunelocal_raidtree, healerNode)
	table.insert(attunelocal_raidtree, meleeNode)
	table.insert(attunelocal_raidtree, rangedNode)
	table.insert(attunelocal_raidtree, unspecNode)

end

-------------------------------------------------------------------------
-- Create the RAID PLANNER UI Frame
-------------------------------------------------------------------------

function FTAttune_RaidPlannerFrame()

	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then attunelocal_myguild = guildName end

	if FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] == nil then FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] = {} end
	if FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] == nil then FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] = {} end

	attunelocal_raidframe = FTAttune_AceCreate("Frame")
	attunelocal_raidframe:SetTitle("  FTAttune Raid Planner")
	attunelocal_raidframe:SetStatusText(FTAttuneLang["Select a raid and click on players to add them in"])
	attunelocal_raidframe:SetHeight(620)
	attunelocal_raidframe:SetWidth(1020)
	attunelocal_raidframe:SetLayout("Flow")
	
	if attunelocal_raidframe.frame.SetResizeBounds then
		attunelocal_raidframe.frame:SetResizeBounds(620, 620)
	else
		attunelocal_raidframe.frame:SetMinResize(620, 620)
	end
	attunelocal_raidframe.frame:SetFrameStrata("HIGH")

	
    -- Register the global variable as a "special frame"
    -- so that it is closed when the escape key is pressed.
	
	_G["FTAttune_MainRaidFrame"] = attunelocal_raidframe.frame
    tinsert(UISpecialFrames, "FTAttune_MainRaidFrame")

	local options = FTAttune_AceCreate("SimpleGroup")
	options:SetLayout("Flow")
	options:SetFullWidth(true)

		local dropd = FTAttune_AceCreate("SimpleGroup")
		dropd:SetLayout("Flow")
		dropd:SetWidth(200)

			local raidList = {}
			for i, a in pairs(FTAttune_Data.attunes) do
				if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) then 
					if a.SHOWRAIDPLANNER ~= nil and (a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both') then 
						--actual raid (not just attunement) for this faction
						raidList[tonumber(a.ID)] = a.NAME
					end
				end
			end
			for i, a in pairs(FTAttune_Data.noattunes) do
				--raids that require no attunement
				raidList[tonumber(a.ID)] = a.NAME
			end

			
			local raidselection = FTAttune_AceCreate("Dropdown")
			raidselection:SetWidth(150)
			raidselection:SetList(raidList)
			raidselection:SetValue(FTAttune_DB.raidSelection[attunelocal_faction])
			raidselection:SetCallback("OnValueChanged", function(choice) 
				FTAttune_DB.raidSelection[attunelocal_faction] = choice:GetValue(); 	
				if FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] == nil then FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] = {} end
				if FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] == nil then FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]] = {} end
				FTAttune_LoadRaidTree(); 	
				attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	
				FTAttune_RaidPlannerRoster() end)

			dropd:AddChild(raidselection)
			options:AddChild(dropd)

		

		local checkboxes = FTAttune_AceCreate("SimpleGroup")
		checkboxes:SetLayout("Flow")
		checkboxes:SetWidth(460)

			local cb = FTAttune_AceCreate("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(FTAttuneLang["Show Mains"])
			cb:SetValue(FTAttune_DB.raidShowMains)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	FTAttune_DB.raidShowMains = val; 	FTAttune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	FTAttune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = FTAttune_AceCreate("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(FTAttuneLang["Show Unspecified"])
			cb:SetValue(FTAttune_DB.raidShowUnspecified)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	FTAttune_DB.raidShowUnspecified = val; 	FTAttune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	FTAttune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = FTAttune_AceCreate("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(FTAttuneLang["Guildies only"])
			cb:SetValue(FTAttune_DB.raidGuildOnly)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	FTAttune_DB.raidGuildOnly = val; 	FTAttune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	FTAttune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = FTAttune_AceCreate("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(FTAttuneLang["Show Alts"])
			cb:SetValue(FTAttune_DB.raidShowAlts)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	FTAttune_DB.raidShowAlts = val; 	FTAttune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	FTAttune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = FTAttune_AceCreate("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(FTAttuneLang["Show Unattuned"])
			cb:SetValue(FTAttune_DB.raidShowUnattuned)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	FTAttune_DB.raidShowUnattuned = val; 	FTAttune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	FTAttune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			options:AddChild(checkboxes)

		local label = FTAttune_AceCreate("Label")
		label:SetText(" ")
		label:SetFullWidth(true)
		label:SetFont(GameFontNormal:GetFont(), 12, "")
		options:AddChild(label)

	attunelocal_raidframe:AddChild(options)

	
	FTAttune_LoadRaidTree()

	attunelocal_raidtreeframe = FTAttune_AceCreate("TreeGroup")
	FTAttune_StyleTreeGroup(attunelocal_raidtreeframe)
	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree)
	attunelocal_raidtreeframe:SetLayout("FTAttuneFill")
	attunelocal_raidtreeframe:SetFullWidth(true)
	attunelocal_raidtreeframe:SetFullHeight(true)
	attunelocal_raidtreeframe:SetAutoAdjustHeight(false)
	attunelocal_raidtreeframe:EnableButtonTooltips(false)
	attunelocal_raidframe:AddChild(attunelocal_raidtreeframe)


	attunelocal_raidtreeframe:SelectByPath("Unspec")
	attunelocal_raidtreeframe:SelectByPath("Healer")
	attunelocal_raidtreeframe:SelectByPath("Melee")
	attunelocal_raidtreeframe:SelectByPath("Ranged")
	attunelocal_raidtreeframe:SelectByPath("Tank")
		
	attunelocal_raidtreeframe:SetCallback("OnGroupSelected", function(container, event, group)
		local st, le = string.find(group, "\001")
		if st ~= nil then -- not a group
			local toon = string.sub(group, st+1)
			if toon ~= "" then
				local t = FTAttune_DB.toons[toon.."-"..GetRealmName()]
				local found = FTAttune_IsRaidSelected(t.name)
				
				if found ~= "" then 
					-- already in planner -> remove
					FTAttune_UpdateRaidTreeGroup(t.name, false)
					FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][found] = nil
					attunelocal_raidspotIcon[found]:SetText("|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\raidslot:16|t  Empty")
					attunelocal_raidspotIcon[found].frame:SetAlpha(0.25)
					attunelocal_raidspotIcon[found]:SetCallback("OnEnter", function() end)
		
				else
					-- not in planner -> add to raid. Find a spot
					local placed = FTAttune_FindNextRaidSpot(attunelocal_raidsize, t, 0)
					if placed then 
						FTAttune_UpdateRaidTreeGroup(t.name, true)
					else
					end
				end
				attunelocal_raidtreeframe:SelectByPath(t.role)
			end
		end
	end)
 
	attunelocal_raidroster = FTAttune_AceCreate("SimpleGroup")
	attunelocal_raidroster:SetLayout("Flow")
	attunelocal_raidroster:SetFullWidth(true)
	attunelocal_raidroster:SetFullHeight(true)
	attunelocal_raidtreeframe:AddChild(attunelocal_raidroster)

	FTAttune_RaidPlannerRoster()
end



-------------------------------------------------------------------------
-- Update the Raid treeview to show used or unused toons
-------------------------------------------------------------------------

function FTAttune_UpdateRaidTreeGroup(name, selected)
	for i, a in pairs(attunelocal_raidtree) do
		if a.children ~= nil then 
			for i2, a2 in pairs(a.children) do
				if a2.value == name then
					if selected then
						a2.text = "|cff606060"..name.."|r"
					else 
						a2.text = name
					end
				end
			end
		end
	end
end
-------------------------------------------------------------------------


function FTAttune_RaidPlannerRoster()

	attunelocal_raidroster:ReleaseChildren()

	for i, a in pairs(FTAttune_Data.attunes) do
		if (a.DEPRECATED == nil or FTAttune_DB.showDeprecatedAttunes) then 
			if tonumber(a.ID) == FTAttune_DB.raidSelection[attunelocal_faction] then 
				attunelocal_raidname = a.NAME
				attunelocal_raidsize = a.GROUPSIZE
				attunelocal_raidcount = a.SHOWRAIDPLANNER
			end
		end
	end
	for i, a in pairs(FTAttune_Data.noattunes) do
		if tonumber(a.ID) == FTAttune_DB.raidSelection[attunelocal_faction] then 
			attunelocal_raidname = a.NAME
			attunelocal_raidsize = a.GROUPSIZE
			attunelocal_raidcount = a.SHOWRAIDPLANNER
		end
	end
	attunelocal_raidspotIcon = {}	

	local raidgroup = FTAttune_AceCreate("SimpleGroup")
	raidgroup:SetLayout("FTAttuneFill")
	raidgroup:SetFullHeight(true)
	--raidgroup:SetWidth(770)
	raidgroup:SetFullWidth(true)

	local raidscroll = FTAttune_AceCreate("ScrollFrame")
	raidscroll:SetLayout("Flow")
	raidscroll:SetFullHeight(true)


	for i=1, attunelocal_raidcount, 1	do 	

		
		local rgroup = FTAttune_AceCreate("SimpleGroup")
		rgroup:SetLayout("Flow")
		rgroup:SetWidth((attunelocal_raidsize/5)*145+50)


		local inv = FTAttune_AceCreate("Button")
		inv:SetText(FTAttuneLang["Invite"])
		inv:SetWidth(70)
		inv:SetCallback("OnClick", function() 
			StaticPopupDialogs["INVITE_ATTUNE_RAID"] = {
				text = FTAttuneLang["Send raid invites to all listed players?"],
				button1 = FTAttuneLang["Accept"],
				button2 = FTAttuneLang["Reject"],
				timeout = 0,
				hasEditBox = false,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnAccept = function()
					FTAttune_SentRaidInvites(i)
				end,
				OnCancel = function (_,reason)
				end,
			}
			StaticPopup_Show ("INVITE_ATTUNE_RAID")
		end)
		rgroup:AddChild(inv)




		local sGroup = ""
		if attunelocal_raidcount > 1 then sGroup = " - " .. FTAttuneLang["Group Number"]:gsub("##NUMBER##", i) end
		
		if FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][i] == nil then 
			FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][i] = attunelocal_raidname .. " - " .. FTAttuneLang["Raid spots"]:gsub("##SIZE##", attunelocal_raidsize) .. sGroup
		end
		local label = FTAttune_AceCreate("InteractiveLabel")
		label:SetText(" "..FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][i])
		label:SetWidth((attunelocal_raidsize/5)*145+50-80)
		label.frame:SetAlpha(1)
		label:SetFont(GameFontNormal:GetFont(), 14, "")
		label:SetCallback("OnEnter", function() 
			GameTooltip:SetOwner(label.frame,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", label.frame,"BOTTOMLEFT", 10, 0)
			GameTooltip:SetText("Click to edit")
		end)				
		label:SetCallback("OnLeave", function() GameTooltip:Hide() end)
		label:SetCallback("OnClick", function() 
			StaticPopupDialogs["RENAME_ATTUNE_RAID"] = {
				text = FTAttuneLang["Enter a new name for this raid group"],
				hasEditBox = true,
				button1 = FTAttuneLang["Save"],
				button2 = FTAttuneLang["Close"],
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				editBoxWidth = 350,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnShow = function (self, data)
					local editBox = self.EditBox or self.editBox
					editBox:SetText(""..FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][i])
					--editBox:HighlightText()
					editBox:SetScript("OnEscapePressed", function(self) StaticPopup_Hide ("RENAME_ATTUNE_RAID") end)
		
				end,
				OnAccept = function(self)
					local editBox = self.EditBox or self.editBox
					FTAttune_DB.raidNames[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][i] = editBox:GetText()
					FTAttune_RaidPlannerRoster()
				end,
				OnCancel = function (_,reason)
					--
				end,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				
			}
			StaticPopup_Show ("RENAME_ATTUNE_RAID")
		end)
		rgroup:AddChild(label)


		for r=1, (attunelocal_raidsize/5), 1	do 	

			local party = FTAttune_AceCreate("InlineGroup")
			party:SetLayout("Flow")
			party:SetWidth(145)
	
			for s=1,5,1	do 	
				local spot = ((i-1)*attunelocal_raidsize) + ((r-1)*5) + s

				local icon = FTAttune_AceCreate("InteractiveLabel")
				icon:SetCallback("OnEnter", function() 
					FTAttune_SetToolTip(icon.frame, nil)
				end)				

				if FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] == nil then 
					icon:SetText("|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\raidslot:16|t  Empty")
					icon.frame:SetAlpha(0.25)
					FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] = nil
				else
					local t = FTAttune_DB.toons[FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot].."-"..GetRealmName()]
					if t ~= nil then 
						-- all good, toon is still in our data
						icon:SetText("|T"..FTAttune_Icons(t.class)..":16|t  "..t.name)
						icon.frame:SetAlpha(1)
						icon:SetCallback("OnEnter", function() 
							local gg = "<"..t.guild..">"
							if t.guild == "" then gg = FTAttuneLang["Not in a guild"] end

							FTAttune_SetToolTip(icon.frame, nil, 2)
							FTAttune_SetToolTip(icon.frame, t.name .. " (" .. t.level.." "..t.class:sub(1,1):upper()..t.class:sub(2):lower()..")\n|cffffffff"..gg.."|r")
						end)
					else
						-- issue. Toon has been deleted from data, empty slot
						icon:SetText("|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\raidslot:16|t  Empty")
						icon.frame:SetAlpha(0.25)
						FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] = nil
					end
				end

				icon:SetFont(GameFontNormal:GetFont(), 12, "")
				icon:SetWidth(140)
				icon:SetImageSize(32, 32)
				party:AddChild(icon)

				icon:SetCallback("OnLeave", function() GameTooltip:Hide() end)
				icon:SetCallback("OnClick", function(obj, ev, but) 
					
					if FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] == nil then 
						-- clicking an empty tile
						-- does nothing
					else
						-- clicking a toon
						if but == "LeftButton" then 
							-- Move to the next group
							local jumpTo = spot + (5 - (spot % 5))
							if spot % 5  == 0 then jumpTo = spot end
							local placed = FTAttune_FindNextRaidSpot(attunelocal_raidsize, FTAttune_DB.toons[FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot].."-"..GetRealmName()], jumpTo )
							if placed then 
								FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] = nil
								attunelocal_raidspotIcon[spot]:SetText("|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\raidslot:16|t  Empty")
								attunelocal_raidspotIcon[spot].frame:SetAlpha(0.25)
								attunelocal_raidspotIcon[spot]:SetCallback("OnEnter", function() end)
							end
						elseif but == "RightButton" then
							-- Remove
							
							FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] = nil
							attunelocal_raidspotIcon[spot]:SetText("|TInterface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\raidslot:16|t  Empty")
							attunelocal_raidspotIcon[spot].frame:SetAlpha(0.25)
							attunelocal_raidspotIcon[spot]:SetCallback("OnEnter", function() end)
							FTAttune_UpdateRaidTreeGroup(FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot], false)
							FTAttune_LoadRaidTree(); 	
							attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	
							FTAttune_RaidPlannerRoster()
						end
					end
				end)
				
				attunelocal_raidspotIcon[spot] = icon   -- isUsed / icon object
				
			end
			rgroup:AddChild(party)
		end

		
		local label = FTAttune_AceCreate("Label")
		label:SetText("\n")
		label:SetFullWidth(true)
		label:SetFont(GameFontNormal:GetFont(), 18, "")
		rgroup:AddChild(label)

		raidscroll:AddChild(rgroup)

	end
	
	raidgroup:AddChild(raidscroll)
	attunelocal_raidroster:AddChild(raidgroup)

end


-------------------------------------------------------------------------

function FTAttune_SentRaidInvites(raidId)
	
	local nbInv = 0
	for spot=(raidId-1)*attunelocal_raidsize+1, raidId*attunelocal_raidsize, 1	do 	

		if FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] ~= nil then 
			nbInv = nbInv + 1
			InviteUnit(FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot])
		end 
	end
	if nbInv > 0 then 	FTAttune_checkRaidGroup(0) end
end


-------------------------------------------------------------------------
--check the group until someone has joined, then convert to raid

function FTAttune_checkRaidGroup(iter) 

	-- 50 * 0.2s = 10s
	-- this checks for 10s after the first raid invite has been sent
	local iter = iter + 1
	if iter < 50 then 
		if GetNumGroupMembers() >= 2 then 
			ConvertToRaid()
			iter = iter + 999
		else
			C_Timer.After(0.2, function() FTAttune_checkRaidGroup(iter) end)
		end
	end
end

-------------------------------------------------------------------------

function FTAttune_SetToolTip(obj, text)

	GameTooltip:SetOwner(obj,"ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", obj,"TOPRIGHT", 10, 0)

	if text == nil then 
		--GameTooltip:SetText(FTAttuneLang["Empty"])
	else
		GameTooltip:SetText(text)
		GameTooltip:AddLine("\n|cffA0A0A0"..FTAttuneLang["LeftClick"].." "..FTAttuneLang["Move to next group"].."\n"..FTAttuneLang["RightClick"].." "..FTAttuneLang["Remove from raid"].."|r")
	end

end

-------------------------------------------------------------------------

function FTAttune_FindNextRaidSpot(raidsize, t, minspot)
	-- minspot used to only select spot coming after this minspot
	local placed = false
	for i=1, (50/raidsize), 1	do 	
		for r=1, (raidsize/5), 1	do 	
			for s=1,5,1	do 	
				local spot = ((i-1)*raidsize) + ((r-1)*5) + s
				if spot > minspot then
					if FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] == nil and not placed then
--						if attunelocal_raidtoonIcon[t.name] ~= nil then attunelocal_raidtoonIcon[t.name].frame:SetAlpha(0.25) end
						FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]][spot] = t.name
						attunelocal_raidspotIcon[spot]:SetText("|T"..FTAttune_Icons(t.class)..":16|t  "..t.name)
						attunelocal_raidspotIcon[spot].frame:SetAlpha(1)
						attunelocal_raidspotIcon[spot]:SetCallback("OnEnter", function() 
							local gg = "<"..t.guild..">"
							if t.guild == "" then gg = FTAttuneLang["Not in a guild"] end
							FTAttune_SetToolTip(attunelocal_raidspotIcon[spot].frame, t.name .. " (" .. t.level.." "..t.class:sub(1,1):upper()..t.class:sub(2):lower()..")\n|cffffffff"..gg.."|r")
						end)
						placed = true
						break				
					end
				end
			end
		end
	end
	return placed
end

-------------------------------------------------------------------------

function FTAttune_IsRaidSelected(name)
	-- check if already selected.
	for kr, r in pairs(FTAttune_DB.raidPlans[attunelocal_faction][FTAttune_DB.raidSelection[attunelocal_faction]]) do
		if r == name then return kr end
	end
	return ""
end]=]


-------------------------------------------------------------------------

local attunelocal_rewardFrame
local ATTUNE_REWARD_WIDTH = 300


local function FTAttune_RewardQuestIDs(idWowhead)
	local ids = {}
	local raw = tostring(idWowhead or "")
	if string.find(raw, "|", 1, true) then
		for _, part in pairs(FTAttune_split(raw, "|")) do
			local n = tonumber(part)
			if n then table.insert(ids, n) end
		end
	else
		local n = tonumber(raw)
		if n then table.insert(ids, n) end
	end
	return ids
end

local function FTAttune_AddReward(list, seen, itemID, name, texture, count, quality, choice)
	itemID = tonumber(itemID)
	if not itemID or itemID <= 0 then return end
	if seen[itemID] then return end
	seen[itemID] = true
	if type(name) ~= "string" or name == "" then name = nil end
	table.insert(list, {
		itemID = itemID,
		name = name,
		texture = texture,
		count = tonumber(count) or 1,
		quality = tonumber(quality),
		choice = choice and true or nil,
	})
end

local function FTAttune_ReadIndexedRewards(countFn, infoFn, questID, list, seen, choice)
	if type(countFn) ~= "function" or type(infoFn) ~= "function" then return end
	local ok, num = pcall(countFn, questID)
	if not ok or type(num) ~= "number" or num <= 0 then return end
	if num > 40 then num = 40 end
	for i = 1, num do
		local okInfo, name, texture, count, quality, _, itemID = pcall(infoFn, i, questID)
		if okInfo then
			if type(name) == "table" then
				local info = name
				FTAttune_AddReward(list, seen, info.itemID or info.itemId, info.name or info.itemName, info.texture or info.icon, info.quantity or info.amount or info.numItems, info.quality, choice)
			else
				FTAttune_AddReward(list, seen, itemID, name, texture, count, quality, choice)
			end
		end
	end
end

local function FTAttune_StoredItem(itemID)
	local info = FTAttune_Data.rewardItems and itemID and FTAttune_Data.rewardItems[itemID]
	if type(info) ~= "table" then return end
	local name = info[1]
	if type(name) ~= "string" or name == "" then name = nil end
	local icon = info[2]
	if type(icon) == "string" and icon ~= "" then
		if not string.find(icon, "\\", 1, true) and not string.find(icon, "/", 1, true) then
			icon = "Interface\\Icons\\" .. icon
		end
	else
		icon = nil
	end
	local quality = tonumber(info[3])
	if quality and quality < 0 then quality = nil end
	return name, icon, quality
end

-- One local for the spell-reward helpers. The main chunk is already near Lua's 200-local limit.
local spellReward = {}

function spellReward.Stored(spellID)
	local info = FTAttune_Data.rewardSpells and spellID and FTAttune_Data.rewardSpells[spellID]
	if type(info) ~= "table" then return end
	local name = info[1]
	if type(name) ~= "string" or name == "" then name = nil end
	local icon = info[2]
	if type(icon) == "string" and icon ~= "" then
		if not string.find(icon, "\\", 1, true) and not string.find(icon, "/", 1, true) then
			icon = "Interface\\Icons\\" .. icon
		end
	else
		icon = nil
	end
	return name, icon
end

-- Client name and icon when the spell is cached. Stored data fills the gap.
function spellReward.Client(spellID)
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, spellID)
		if ok and type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
			return info.name, info.iconID or info.originalIconID or info.icon
		end
	end
	if GetSpellInfo then
		local ok, name, _, icon = pcall(GetSpellInfo, spellID)
		if ok and type(name) == "string" and name ~= "" then
			return name, icon
		end
	end
end

function spellReward.Resolve(spellID)
	local name, icon = spellReward.Client(spellID)
	local storedName, storedIcon = spellReward.Stored(spellID)
	if not name or name == "" then name = storedName end
	if not icon then icon = storedIcon end
	return name, icon
end

function spellReward.Subtext(spellID)
	local text
	if C_Spell and C_Spell.GetSpellSubtext then
		local ok, sub = pcall(C_Spell.GetSpellSubtext, spellID)
		if ok then text = sub end
	end
	if (type(text) ~= "string" or text == "") and GetSpellSubtext then
		local ok, sub = pcall(GetSpellSubtext, spellID)
		if ok then text = sub end
	end
	if type(text) ~= "string" then return "" end
	if strtrim then text = strtrim(text) end
	return text or ""
end

function spellReward.Header()
	if type(REWARD_SPELL) == "string" and REWARD_SPELL ~= "" then
		return REWARD_SPELL
	end
	return "You will learn:"
end

-- Full item link when the client has it. Otherwise the stored name, so the
-- tooltip does not sit on "Retrieving item information" for an item the
-- server never answers.
local function FTAttune_ShowItemTooltip(owner, itemID, request)
	if not owner or not itemID or not owner:IsShown() then return end
	if owner.IsMouseOver and not owner:IsMouseOver() then return end
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")

	local itemName, link, itemQuality = GetItemInfo(itemID)
	if link and pcall(GameTooltip.SetHyperlink, GameTooltip, link) then
		GameTooltip:Show()
		return
	end

	local storedName, _, storedQuality = FTAttune_StoredItem(itemID)
	local name = (type(itemName) == "string" and itemName ~= "") and itemName or storedName
	local quality = itemQuality or storedQuality
	if name then
		local r, g, b = 1, 1, 1
		local color = ITEM_QUALITY_COLORS and quality and ITEM_QUALITY_COLORS[quality]
		if color then r, g, b = color.r, color.g, color.b end
		GameTooltip:SetText(name, r, g, b)
		GameTooltip:Show()
	elseif GameTooltip.SetItemByID and pcall(GameTooltip.SetItemByID, GameTooltip, itemID) then
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end

	if request and not link and C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, itemID)
	end
end

-- Spell tooltip when the client knows it. Otherwise the stored name, so the
-- line does not sit on a retrieving message for a spell the server never sends.
function spellReward.ShowTooltip(owner, spellID, request)
	if not owner or not spellID or not owner:IsShown() then return end
	if owner.IsMouseOver and not owner:IsMouseOver() then return end
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")

	local clientName = spellReward.Client(spellID)
	if clientName and GameTooltip.SetSpellByID and pcall(GameTooltip.SetSpellByID, GameTooltip, spellID) then
		if not GameTooltip.NumLines or GameTooltip:NumLines() > 0 then
			GameTooltip:Show()
			return
		end
	end

	local name = clientName or select(1, spellReward.Stored(spellID))
	if name then
		GameTooltip:SetText(name, 1, 1, 1)
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end

	if request and not clientName and C_Spell and C_Spell.RequestLoadSpellData then
		pcall(C_Spell.RequestLoadSpellData, spellID)
	end
end

local function FTAttune_RefreshRewardTooltip(rows)
	for _, row in ipairs(rows or {}) do
		if row:IsShown() and row.IsMouseOver and row:IsMouseOver() then
			if row.spellID then
				spellReward.ShowTooltip(row, row.spellID, false)
				return
			elseif row.itemID then
				FTAttune_ShowItemTooltip(row, row.itemID, false)
				return
			end
		end
	end
end

local function FTAttune_AppendStoredRewards(questID, fixed, choices, seenFixed, seenChoice)
	local row = FTAttune_Data.questRewards and FTAttune_Data.questRewards[questID]
	if not row then return end
	for _, item in ipairs(row.fixed or {}) do
		local storedName, storedIcon, storedQuality = FTAttune_StoredItem(item[1])
		FTAttune_AddReward(fixed, seenFixed, item[1], storedName, storedIcon, item[2], storedQuality, false)
	end
	for _, item in ipairs(row.choice or {}) do
		local storedName, storedIcon, storedQuality = FTAttune_StoredItem(item[1])
		FTAttune_AddReward(choices, seenChoice, item[1], storedName, storedIcon, item[2], storedQuality, true)
	end
end

function spellReward.Add(list, seen, spellID, name, texture)
	if type(spellID) == "table" then
		local info = spellID
		spellID = info.spellID or info.spellId or info.id
		if type(name) ~= "string" or name == "" then name = info.name end
		if not texture then texture = info.texture or info.icon end
	end
	spellID = tonumber(spellID)
	if not spellID or spellID <= 0 or seen[spellID] then return end
	seen[spellID] = true
	local storedName, storedIcon = spellReward.Stored(spellID)
	if type(name) ~= "string" or name == "" then name = storedName end
	if not texture then texture = storedIcon end
	table.insert(list, {
		spellID = spellID,
		name = name,
		texture = texture,
	})
end

function spellReward.AppendStored(questID, spells, seen)
	local row = FTAttune_Data.questRewards and FTAttune_Data.questRewards[questID]
	if not row then return end
	for _, spellID in ipairs(row.spells or {}) do
		spellReward.Add(spells, seen, spellID)
	end
end

function spellReward.AppendLive(questID, spells, seen)
	if C_QuestInfoSystem and C_QuestInfoSystem.GetQuestRewardSpells then
		local ok, ids = pcall(C_QuestInfoSystem.GetQuestRewardSpells, questID)
		if ok and type(ids) == "table" then
			for _, spellID in ipairs(ids) do
				local name, texture
				if type(spellID) ~= "table" and C_QuestInfoSystem.GetQuestRewardSpellInfo then
					local okInfo, info = pcall(C_QuestInfoSystem.GetQuestRewardSpellInfo, questID, spellID)
					if okInfo and type(info) == "table" then
						name, texture = info.name, info.texture
					end
				end
				spellReward.Add(spells, seen, spellID, name, texture)
			end
		end
	end
	-- These log functions describe the selected quest only. Skip them unless this quest is that selection.
	if not (GetNumQuestLogRewardSpells and GetQuestLogRewardSpell and GetQuestLogIndexByID and GetQuestLogSelection) then return end
	local index = GetQuestLogIndexByID(questID)
	if not index or index <= 0 or index ~= GetQuestLogSelection() then return end
	local ok, num = pcall(GetNumQuestLogRewardSpells)
	if not ok or type(num) ~= "number" or num <= 0 then return end
	if num > 20 then num = 20 end
	for i = 1, num do
		local okInfo, texture, name, _, _, _, _, _, _, spellID = pcall(GetQuestLogRewardSpell, i)
		if okInfo then
			if type(texture) == "table" then
				spellReward.Add(spells, seen, texture, name)
			else
				spellReward.Add(spells, seen, spellID, name, texture)
			end
		end
	end
end

local function FTAttune_CollectQuestRewards(questIDs)
	local fixed, choices, spells = {}, {}, {}
	local seenFixed, seenChoice, seenSpells = {}, {}, {}
	for _, questID in ipairs(questIDs or {}) do
		if C_QuestLog then
			FTAttune_ReadIndexedRewards(C_QuestLog.GetNumQuestRewards, C_QuestLog.GetQuestRewardInfo, questID, fixed, seenFixed, false)
			FTAttune_ReadIndexedRewards(C_QuestLog.GetNumQuestChoices or C_QuestLog.GetNumQuestLogChoices, C_QuestLog.GetQuestChoiceInfo or C_QuestLog.GetQuestLogChoiceInfo, questID, choices, seenChoice, true)
		end
		local useQuestLog = not (C_QuestLog and C_QuestLog.GetNumQuestRewards)
		if not useQuestLog and GetQuestLogIndexByID and GetQuestLogSelection then
			local index = GetQuestLogIndexByID(questID)
			useQuestLog = index and index > 0 and index == GetQuestLogSelection()
		end
		if useQuestLog then
			FTAttune_ReadIndexedRewards(GetNumQuestLogRewards, GetQuestLogRewardInfo, questID, fixed, seenFixed, false)
			FTAttune_ReadIndexedRewards(GetNumQuestLogChoices, GetQuestLogChoiceInfo, questID, choices, seenChoice, true)
		end
		-- Always merge static rows; seen* skips duplicates. Live Forever data often
		-- returns only choice rewards and omits fixed ones (e.g. Changing Tastes).
		spellReward.AppendLive(questID, spells, seenSpells)
		FTAttune_AppendStoredRewards(questID, fixed, choices, seenFixed, seenChoice)
		spellReward.AppendStored(questID, spells, seenSpells)
	end
	return fixed, choices, spells
end

-- XP from the quest log only (no static table). Returns nil when unavailable.
local function FTAttune_QuestLogIndexForID(questID)
	if C_QuestLog and C_QuestLog.GetLogIndexForQuestID then
		return C_QuestLog.GetLogIndexForQuestID(questID)
	end
	if GetQuestLogIndexByID then
		return GetQuestLogIndexByID(questID)
	end
	return nil
end

local function FTAttune_IsQuestInLog(questID)
	if C_QuestLog and C_QuestLog.IsOnQuest then
		return C_QuestLog.IsOnQuest(questID)
	end
	local index = FTAttune_QuestLogIndexForID(questID)
	return index and index > 0
end

local function FTAttune_QuestLogRewardXPForID(questID)
	questID = tonumber(questID)
	if not questID or type(GetQuestLogRewardXP) ~= "function" then return nil end
	if not FTAttune_IsQuestInLog(questID) then return nil end

	local ok, xp = pcall(GetQuestLogRewardXP, questID)
	if ok and type(xp) == "number" and xp > 0 then return xp end

	local index = FTAttune_QuestLogIndexForID(questID)
	if not index or index <= 0 or not SelectQuestLogEntry then return nil end

	local prev = GetQuestLogSelection and GetQuestLogSelection()
	SelectQuestLogEntry(index)
	ok, xp = pcall(GetQuestLogRewardXP)
	if prev and prev > 0 and prev ~= index then
		SelectQuestLogEntry(prev)
	end
	if ok and type(xp) == "number" and xp > 0 then return xp end
	return nil
end

local function FTAttune_GetQuestLogRewardXP(questIDs)
	local total, found = 0, false
	for _, questID in ipairs(questIDs or {}) do
		local xp = FTAttune_QuestLogRewardXPForID(questID)
		if xp then
			total = total + xp
			found = true
		end
	end
	if found then return total end
	return nil
end

local function FTAttune_FormatXPAmount(xp)
	if BreakUpLargeNumbers then return BreakUpLargeNumbers(xp) end
	return tostring(xp)
end

local ATTUNE_SPELL_FRAME = "Interface\\AddOns\\ForeverTools\\Features\\Attune\\Images\\spellframe"

-- Gold ring with a black center. Additive draw keeps the spell icon visible.
local function FTAttune_SetSpellFrame(row, show)
	if not show then
		if row.spellFrame then row.spellFrame:Hide() end
		return
	end
	if not row.spellFrame then
		local frame = row:CreateTexture(nil, "OVERLAY")
		frame:SetTexture(ATTUNE_SPELL_FRAME)
		frame:SetBlendMode("ADD")
		frame:SetAllPoints(row.icon)
		row.spellFrame = frame
	end
	row.spellFrame:Show()
end

local function FTAttune_CreateRewardRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(36)
	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetSize(32, 32)
	row.icon:SetPoint("LEFT", 2, 0)
	row.count = row:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
	row.count:SetPoint("BOTTOMRIGHT", row.icon, "BOTTOMRIGHT", -1, 2)
	row.count:SetJustifyH("RIGHT")
	row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
	row.name:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	row.name:SetJustifyH("LEFT")
	row.name:SetWordWrap(false)
	if row.name.SetMaxLines then row.name:SetMaxLines(1) end
	row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	row:SetScript("OnEnter", function(self)
		if self.spellID then
			spellReward.ShowTooltip(self, self.spellID, true)
		else
			FTAttune_ShowItemTooltip(self, self.itemID, true)
		end
	end)
	row:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	return row
end

local function FTAttune_HideRewardRows(frame)
	for _, row in ipairs(frame.rows) do
		row.itemID = nil
		row.spellID = nil
		row:Hide()
	end
	for _, header in ipairs(frame.headers) do header:Hide() end
end

local function FTAttune_RewardHeader(frame, index, text, y)
	local header = frame.headers[index]
	if not header then
		header = frame.content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		header:SetJustifyH("LEFT")
		frame.headers[index] = header
	end
	header:ClearAllPoints()
	header:SetPoint("TOPLEFT", 4, -y)
	header:SetPoint("RIGHT", frame.content, "RIGHT", -4, 0)
	header:SetText(text)
	header:Show()
end

local function FTAttune_PaintRewardItem(frame, entry, y)
	local index = frame.rowUsed + 1
	frame.rowUsed = index
	local row = frame.rows[index]
	if not row then
		row = FTAttune_CreateRewardRow(frame.content)
		frame.rows[index] = row
	end
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", 0, -y)
	row:SetPoint("RIGHT", frame.content, "RIGHT", 0, 0)

	row.itemID = entry.itemID
	row.spellID = nil
	FTAttune_SetSpellFrame(row, false)
	local name = entry.name
	local quality = entry.quality
	local texture = entry.texture
	local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(entry.itemID)
	if (not itemName or itemName == "") and C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, entry.itemID)
	end
	if itemName and itemName ~= "" then
		name = itemName
		quality = itemQuality
		texture = itemTexture or texture
	end
	if not name or name == "" then name = "..." end

	row.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
	row.name:SetText(name)
	local color = ITEM_QUALITY_COLORS and quality and ITEM_QUALITY_COLORS[quality]
	if color then
		row.name:SetTextColor(color.r, color.g, color.b)
	else
		row.name:SetTextColor(1, 1, 1)
	end
	if entry.count and entry.count > 1 then
		row.count:SetText(entry.count)
		row.count:Show()
	else
		row.count:Hide()
	end
	row:Show()
end

function spellReward.Paint(frame, entry, y)
	local index = frame.rowUsed + 1
	frame.rowUsed = index
	local row = frame.rows[index]
	if not row then
		row = FTAttune_CreateRewardRow(frame.content)
		frame.rows[index] = row
	end
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", 0, -y)
	row:SetPoint("RIGHT", frame.content, "RIGHT", 0, 0)

	row.itemID = nil
	row.spellID = entry.spellID
	FTAttune_SetSpellFrame(row, true)
	local name, texture = spellReward.Resolve(entry.spellID)
	if not name or name == "" then name = entry.name end
	if not texture then texture = entry.texture end
	if not name or name == "" then name = "..." end
	if not spellReward.Client(entry.spellID) and C_Spell and C_Spell.RequestLoadSpellData then
		pcall(C_Spell.RequestLoadSpellData, entry.spellID)
	end

	row.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
	row.name:SetText(name)
	row.name:SetTextColor(1, 1, 1)
	row.count:Hide()
	row:Show()
end

local function FTAttune_FillQuestRewards(frame, final, resetScroll)
	if not frame or not frame:IsShown() then return end
	local width = frame.scroll:GetWidth()
	if not width or width < 40 then width = ATTUNE_REWARD_WIDTH - 52 end
	frame.content:SetWidth(width)

	local fixed, choices, spells = FTAttune_CollectQuestRewards(frame.questIDs)
	FTAttune_HideRewardRows(frame)
	frame.rowUsed = 0

	if #fixed == 0 and #choices == 0 and #spells == 0 then
		frame.scroll:Hide()
		frame.empty:Show()
		frame.empty:SetText(final and FTAttuneLang["No item rewards"] or FTAttuneLang["Loading rewards"])
		frame.content:SetHeight(1)
		return
	end

	frame.empty:Hide()
	frame.scroll:Show()

	local y = 2
	local headerIndex = 0
	for _, entry in ipairs(fixed) do
		FTAttune_PaintRewardItem(frame, entry, y)
		y = y + 40
	end
	if #choices > 0 then
		if #fixed > 0 then y = y + 6 end
		headerIndex = headerIndex + 1
		FTAttune_RewardHeader(frame, headerIndex, FTAttuneLang["Choose one reward"], y)
		y = y + 18
		for _, entry in ipairs(choices) do
			FTAttune_PaintRewardItem(frame, entry, y)
			y = y + 40
		end
	end
	if #spells > 0 then
		if #fixed > 0 or #choices > 0 then y = y + 6 end
		headerIndex = headerIndex + 1
		FTAttune_RewardHeader(frame, headerIndex, spellReward.Header(), y)
		y = y + 18
		for _, entry in ipairs(spells) do
			spellReward.Paint(frame, entry, y)
			y = y + 40
		end
	end

	frame.content:SetHeight(math.max(y, 1))
	if resetScroll then frame.scroll:SetVerticalScroll(0) end
end

local function FTAttune_FitRewardFrame(side)
	local parent = side:GetParent()
	if not parent or not parent:IsShown() then return end
	local right = parent:GetRight()
	local screen = UIParent:GetWidth()
	if not right or not screen then return end
	local overflow = (right + side:GetWidth()) - screen
	if overflow > 4 then
		local left = parent:GetLeft() - overflow - 12
		local bottom = parent:GetBottom()
		if not left or not bottom then return end
		if left < 0 then left = 0 end
		parent:ClearAllPoints()
		parent:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
	end
end

local function FTAttune_EnsureRewardFrame()
	if attunelocal_rewardFrame then return attunelocal_rewardFrame end
	local parent = attunelocal_frame and attunelocal_frame.frame
	if not parent then return nil end

	local f = CreateFrame("Frame", "FTAttuneQuestRewardFrame", parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	f:SetWidth(ATTUNE_REWARD_WIDTH)
	f:SetPoint("TOPLEFT", parent, "TOPRIGHT", -6, 0)
	f:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", -6, 0)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 8, right = 8, top = 8, bottom = 8 },
	})
	f:SetBackdropColor(0, 0, 0, 1)
	f:EnableMouse(true)
	f:SetFrameStrata(parent:GetFrameStrata())
	f:SetFrameLevel((parent:GetFrameLevel() or 0) + 20)

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 4, 4)
	close:SetScript("OnClick", function() f:Hide() end)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOPLEFT", 18, -16)
	title:SetPoint("RIGHT", close, "LEFT", -4, 0)
	title:SetHeight(36)
	title:SetJustifyH("LEFT")
	title:SetJustifyV("MIDDLE")
	title:SetWordWrap(true)
	f.title = title

	local urlBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	urlBtn:SetHeight(22)
	urlBtn:SetPoint("BOTTOMLEFT", 16, 16)
	urlBtn:SetPoint("BOTTOMRIGHT", -16, 16)
	urlBtn:SetText(FTAttuneLang["Show link"])
	urlBtn:SetScript("OnClick", function()
		if f.qstring then FTAttune_ShowWebsiteURL(f.qstring) end
	end)
	f.urlBtn = urlBtn

	local empty = f:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	empty:SetPoint("TOPLEFT", 20, -64)
	empty:SetPoint("RIGHT", f, "RIGHT", -20, 0)
	empty:SetJustifyH("CENTER")
	empty:SetWordWrap(true)
	f.empty = empty

	local scroll = CreateFrame("ScrollFrame", "FTAttuneQuestRewardScroll", f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 16, -56)
	scroll:SetPoint("BOTTOMRIGHT", -32, 46)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local range = self:GetVerticalScrollRange() or 0
		if range <= 0 then return end
		local nextScroll = self:GetVerticalScroll() - (delta * 40)
		if nextScroll < 0 then nextScroll = 0 end
		if nextScroll > range then nextScroll = range end
		self:SetVerticalScroll(nextScroll)
	end)
	f.scroll = scroll

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(ATTUNE_REWARD_WIDTH - 52, 1)
	scroll:SetScrollChild(content)
	f.content = content
	f.rows = {}
	f.headers = {}
	f.questIDs = {}

	local listener = CreateFrame("Frame", nil, f)
	listener:SetScript("OnEvent", function(_, event, arg1)
		if not f:IsShown() then return end
		if event == "QUEST_DATA_LOAD_RESULT" then
			local wanted = false
			for _, qid in ipairs(f.questIDs) do
				if qid == arg1 then wanted = true break end
			end
			if not wanted then return end
		elseif event == "GET_ITEM_INFO_RECEIVED" then
			local wanted = false
			for _, row in ipairs(f.rows) do
				if row.itemID == arg1 then wanted = true break end
			end
			if not wanted then return end
		elseif event == "SPELL_DATA_LOAD_RESULT" then
			local wanted = false
			for _, row in ipairs(f.rows) do
				if row.spellID == arg1 then wanted = true break end
			end
			if not wanted then return end
		end
		FTAttune_FillQuestRewards(f, true)
		FTAttune_RefreshRewardTooltip(f.rows)
	end)
	f.listener = listener
	f:SetScript("OnShow", function(self)
		self.listener:RegisterEvent("QUEST_DATA_LOAD_RESULT")
		self.listener:RegisterEvent("GET_ITEM_INFO_RECEIVED")
		pcall(self.listener.RegisterEvent, self.listener, "SPELL_DATA_LOAD_RESULT")
	end)
	f:SetScript("OnHide", function(self)
		self.listener:UnregisterEvent("QUEST_DATA_LOAD_RESULT")
		self.listener:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
		pcall(self.listener.UnregisterEvent, self.listener, "SPELL_DATA_LOAD_RESULT")
		GameTooltip:Hide()
	end)

	parent:HookScript("OnHide", function()
		f:Hide()
	end)

	f.bronze = FTAttune_ApplyButtonChrome(f, function() f:Hide() end)
	if f.bronze and close then
		close:Hide()
	end

	f:Hide()
	attunelocal_rewardFrame = f
	return f
end

function FTAttune_ShowQuestRewards(step)
	if not step or not attunelocal_frame or not attunelocal_frame.frame then return end
	local f = FTAttune_EnsureRewardFrame()
	if not f then return end

	f.questIDs = FTAttune_RewardQuestIDs(step.ID_WOWHEAD)
	f.qstring = "quest=" .. step.ID_WOWHEAD
	f.token = (f.token or 0) + 1
	local title = FTAttuneLang["Q1_" .. step.ID_WOWHEAD]
	if not title or title == "" then title = FTAttuneLang["Quest rewards"] end
	if f.bronze then
		FTAttune_SetChromeTitle(f.bronze, title)
		f.title:Hide()
	else
		f.title:SetText(title)
		f.title:Show()
	end
	f.urlBtn:SetText(FTAttuneLang["Show link"])
	f:Show()
	FTAttune_FitRewardFrame(f)

	if C_QuestLog and C_QuestLog.RequestLoadQuestByID then
		for _, questID in ipairs(f.questIDs) do
			pcall(C_QuestLog.RequestLoadQuestByID, questID)
		end
	end

	FTAttune_FillQuestRewards(f, false, true)
	local token = f.token
	if C_Timer and C_Timer.After then
		C_Timer.After(0.4, function()
			if f:IsShown() and f.token == token then
				FTAttune_FillQuestRewards(f, true, false)
			end
		end)
	end
end

-------------------------------------------------------------------------

function FTAttune_ShowWebsiteURL(qstring)


--	if Dialog:ActiveDialog("FTAttuneWowheadUrlCopyDialog") then
--		Dialog:Dismiss("FTAttuneWowheadUrlCopyDialog")
--	end

	StaticPopupDialogs["ATTUNE_SHOW_URL"] = {
		text = FTAttuneLang["External link"],
		button1 = FTAttuneLang["Close"],
		OnShow = function (self, data)
			local editBox = self.EditBox or self.editBox
			editBox:SetText("".. FTAttune_DB.websiteUrl .. "/" .. qstring)
			editBox:HighlightText()
			editBox:SetScript("OnEscapePressed", function(self) StaticPopup_Hide ("ATTUNE_SHOW_URL") end)

		end,
		timeout = 0,
		hasEditBox = true,
		editBoxWidth = 350,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show ("ATTUNE_SHOW_URL")

end

-------------------------------------------------------------------------




-------------------------------------------------------------------------
-- Quest detail replaces the tree list: rewards on top, map square below
-------------------------------------------------------------------------

local attunelocal_questDetail

local function FTAttune_QuestDetailKey(step)
	return tostring(step.ID_ATTUNE) .. "-" .. tostring(step.ID) .. "-" .. tostring(step.ID_WOWHEAD)
end

local function FTAttune_DetailGiver(step)
	local questId = FTAttune_QuestIdFromStep(step)
	local loc = questId and FTAttune_Data.questGivers and FTAttune_Data.questGivers[questId]
	if not loc then return nil, nil, nil, nil end
	local uiMapID, x, y, name = loc[1], loc[2], loc[3], loc[4]
	if uiMapID and C_Map and C_Map.GetMapInfo and not C_Map.GetMapInfo(uiMapID) then
		return nil, nil, nil, name
	end
	return uiMapID, x, y, name
end

-- Shift-click shares this pin the same way the world map pin does: chat link plus clipboard.
local function FTAttune_ShareDetailPin(uiMapID, x, y)
	if not uiMapID or not x or not y or not (C_Map and C_Map.SetUserWaypoint and C_Map.GetUserWaypointHyperlink and UiMapPoint) then return end
	if C_Map.CanSetUserWaypointOnMap and not C_Map.CanSetUserWaypointOnMap(uiMapID) then return end

	local previous = C_Map.GetUserWaypoint and C_Map.GetUserWaypoint()
	local wasTracking = C_SuperTrack and C_SuperTrack.IsSuperTrackingUserWaypoint and C_SuperTrack.IsSuperTrackingUserWaypoint()

	C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(uiMapID, x / 100, y / 100))
	local link = C_Map.GetUserWaypointHyperlink()
	local waypoint = C_Map.GetUserWaypoint and C_Map.GetUserWaypoint()

	if link then
		if ChatFrameUtil and ChatFrameUtil.InsertLink then
			ChatFrameUtil.InsertLink(link)
		elseif ChatEdit_InsertLink then
			ChatEdit_InsertLink(link)
		end
	end

	if waypoint and waypoint.position and CopyToClipboard then
		local cmd = (SLASH_MAPPIN1 or "/pin") .. string.format(" %d %.1f %.1f", waypoint.uiMapID, waypoint.position.x * 100, waypoint.position.y * 100)
		CopyToClipboard(cmd)
	end

	if previous then
		C_Map.SetUserWaypoint(previous)
		if wasTracking and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			C_SuperTrack.SetSuperTrackedUserWaypoint(true)
		end
	elseif C_Map.ClearUserWaypoint then
		C_Map.ClearUserWaypoint()
	end

	if PlaySound and SOUNDKIT and SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE then
		PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE)
	end
end

-- Explored ground is a second set of tiles on top of the base map. The world map
-- draws these from C_MapExplorationInfo; without them the embed stays the blank base.
local function FTAttune_FillExploredOverlays(clip, uiMapID, tileW, tileH, left, top, scale)
	clip.explored = clip.explored or {}
	local n = 0
	local exploredMapTextures = C_MapExplorationInfo and C_MapExplorationInfo.GetExploredMapTextures and C_MapExplorationInfo.GetExploredMapTextures(uiMapID)
	if exploredMapTextures and tileW > 0 and tileH > 0 then
		for _, explored in ipairs(exploredMapTextures) do
			local files = explored.fileDataIDs
			local texW, texH = explored.textureWidth, explored.textureHeight
			if files and texW and texH and texW > 0 and texH > 0 and not explored.isShownByMouseOver then
				local cols = math.ceil(texW / tileW)
				local rows = math.ceil(texH / tileH)
				local subLevel = explored.isDrawOnTopLayer and 2 or 1
				for row = 1, rows do
					local drawH = (row < rows) and tileH or (texH - tileH * (rows - 1))
					if drawH <= 0 then drawH = tileH end
					local fileH = (row < rows) and tileH or 16
					if row == rows then
						while fileH < drawH do fileH = fileH * 2 end
					end
					for col = 1, cols do
						local file = files[(row - 1) * cols + col]
						if file then
							local drawW = (col < cols) and tileW or (texW - tileW * (cols - 1))
							if drawW <= 0 then drawW = tileW end
							local fileW = (col < cols) and tileW or 16
							if col == cols then
								while fileW < drawW do fileW = fileW * 2 end
							end
							n = n + 1
							local tex = clip.explored[n]
							if not tex then
								tex = clip:CreateTexture(nil, "ARTWORK")
								clip.explored[n] = tex
							end
							tex:SetTexture(file, nil, nil, "TRILINEAR")
							tex:SetSize(drawW * scale, drawH * scale)
							tex:SetTexCoord(0, drawW / fileW, 0, drawH / fileH)
							tex:ClearAllPoints()
							local canvasX = (explored.offsetX or 0) + tileW * (col - 1)
							local canvasY = (explored.offsetY or 0) + tileH * (row - 1)
							tex:SetPoint("TOPLEFT", clip, "TOPLEFT", (canvasX - left) * scale, -((canvasY - top) * scale))
							tex:SetDrawLayer("ARTWORK", subLevel)
							tex:Show()
						end
					end
				end
			end
		end
	end
	for i = n + 1, #clip.explored do clip.explored[i]:Hide() end
end

local function FTAttune_FillDetailMap(clip, uiMapID, x, y)
	clip.tiles = clip.tiles or {}
	for _, tex in ipairs(clip.tiles) do tex:Hide() end
	if clip.explored then
		for _, tex in ipairs(clip.explored) do tex:Hide() end
	end
	clip.pin:Hide()
	clip.pin.uiMapID, clip.pin.pinX, clip.pin.pinY = nil, nil, nil
	clip.empty:Hide()
	if not uiMapID or not x or not y or not C_Map or not C_Map.GetMapArtLayers or not C_Map.GetMapArtLayerTextures then
		clip.empty:Show()
		return
	end
	local layers = C_Map.GetMapArtLayers(uiMapID)
	if layers and layers.layerWidth then layers = { layers } end
	local layer = layers and layers[#layers]
	local textures = layer and C_Map.GetMapArtLayerTextures(uiMapID, #layers)
	if not layer or not textures or #textures == 0 or not layer.tileWidth or layer.tileWidth <= 0 then
		clip.empty:Show()
		return
	end
	local tileW, tileH = layer.tileWidth, layer.tileHeight
	local mapW, mapH = layer.layerWidth, layer.layerHeight
	local cols = math.ceil(mapW / tileW)
	local rows = math.ceil(mapH / tileH)
	local side = clip:GetWidth()
	if side < 8 then return end
	local view = math.min(mapW, mapH) * (0.35 / (clip.zoom or 1))
	if view < 1 then view = math.min(mapW, mapH) end
	local scale = side / view
	local gx = (x / 100) * mapW
	local gy = (y / 100) * mapH
	local left = gx - (view / 2)
	local top = gy - (view / 2)
	local n, i = 0, 0
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			i = i + 1
			local file = textures[i]
			if file then
				n = n + 1
				local tex = clip.tiles[n]
				if not tex then
					tex = clip:CreateTexture(nil, "ARTWORK")
					clip.tiles[n] = tex
				end
				tex:SetTexture(file)
				local tw = math.min(tileW, mapW - col * tileW)
				local th = math.min(tileH, mapH - row * tileH)
				tex:SetSize(tw * scale, th * scale)
				tex:SetTexCoord(0, tw / tileW, 0, th / tileH)
				tex:ClearAllPoints()
				tex:SetPoint("TOPLEFT", clip, "TOPLEFT", (col * tileW - left) * scale, -((row * tileH - top) * scale))
				tex:Show()
			end
		end
	end
	for k = n + 1, #clip.tiles do clip.tiles[k]:Hide() end
	FTAttune_FillExploredOverlays(clip, uiMapID, tileW, tileH, left, top, scale)
	clip.pin.uiMapID, clip.pin.pinX, clip.pin.pinY = uiMapID, x, y
	clip.pin:Show()
	clip.pin:ClearAllPoints()
	clip.pin:SetPoint("CENTER", clip, "CENTER", 0, 0)
end

local function FTAttune_DetailRewardRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(36)
	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetSize(attunelocal_Icon_Size, attunelocal_Icon_Size)
	row.icon:SetPoint("LEFT", 2, 0)
	row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.name:SetPoint("BOTTOMLEFT", row.icon, "RIGHT", 6, 1)
	row.name:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	row.name:SetJustifyH("LEFT")
	row.name:SetWordWrap(false)
	if row.name.SetMaxLines then row.name:SetMaxLines(1) end
	row.category = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.category:SetPoint("TOPLEFT", row.icon, "RIGHT", 6, -1)
	row.category:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	row.category:SetJustifyH("LEFT")
	row.category:SetWordWrap(false)
	row.category:SetTextColor(0.55, 0.55, 0.55)
	if row.category.SetMaxLines then row.category:SetMaxLines(1) end
	row:SetScript("OnEnter", function(self)
		if self.spellID then
			spellReward.ShowTooltip(self, self.spellID, true)
		else
			FTAttune_ShowItemTooltip(self, self.itemID, true)
		end
	end)
	row:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return row
end

function spellReward.HideDetailHeaders(panel)
	for _, header in ipairs(panel.headers or {}) do header:Hide() end
end

function spellReward.DetailHeader(panel, index, text, y)
	panel.headers = panel.headers or {}
	local header = panel.headers[index]
	if not header then
		header = panel.rewardChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		header:SetJustifyH("LEFT")
		panel.headers[index] = header
	end
	header:ClearAllPoints()
	header:SetPoint("TOPLEFT", 6, -y)
	header:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -6, 0)
	header:SetText(text)
	header:Show()
end

function spellReward.ShowDetail(panel, entry, y, shown)
	shown = shown + 1
	local row = panel.rows[shown]
	if not row then
		row = FTAttune_DetailRewardRow(panel.rewardChild)
		panel.rows[shown] = row
	end
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", 4, -y)
	row:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -6, 0)
	row.itemID = nil
	row.spellID = entry.spellID
	FTAttune_SetSpellFrame(row, true)
	local name, texture = spellReward.Resolve(entry.spellID)
	if not name or name == "" then name = entry.name end
	if not texture then texture = entry.texture end
	if not name or name == "" then name = "..." end
	if not spellReward.Client(entry.spellID) and C_Spell and C_Spell.RequestLoadSpellData then
		pcall(C_Spell.RequestLoadSpellData, entry.spellID)
	end
	row.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
	row.name:SetText(name)
	row.name:SetTextColor(1, 1, 1)
	local subtext = spellReward.Subtext(entry.spellID)
	row.category:SetText(subtext)
	if subtext == "" then row.category:Hide() else row.category:Show() end
	row.name:ClearAllPoints()
	row.name:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	if subtext == "" then
		row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
	else
		row.name:SetPoint("BOTTOMLEFT", row.icon, "RIGHT", 6, 1)
	end
	row:Show()
	return y + 42, shown
end

local function FTAttune_QuestRewardsKnown(panel)
	local ids = panel and panel.step and FTAttune_RewardQuestIDs(panel.step.ID_WOWHEAD) or {}
	for _, questID in ipairs(ids) do
		if panel.questLoaded and panel.questLoaded[questID] then return true end
		if FTAttune_Data.questRewards and FTAttune_Data.questRewards[questID] ~= nil then return true end
		if C_QuestLog and C_QuestLog.IsOnQuest and C_QuestLog.IsOnQuest(questID) then return true end
	end
	return false
end

local function FTAttune_LayoutQuestDetail(panel)
	if not panel or not panel:IsShown() or not panel.step then return end
	local width = panel:GetWidth()
	local height = panel:GetHeight()
	if width < 40 or height < 40 then return end

	local header = 50
	local sep = 10
	local margin = 10
	local useFullMap = FTAttune_DB and FTAttune_DB.useFullMap
	local mapSize, rewardsH
	if useFullMap then
		panel.map:Hide()
		panel.separator:Hide()
		rewardsH = height - header - margin
	else
		panel.map:Show()
		panel.separator:Show()
		mapSize = width - (margin * 2)
		rewardsH = height - header - sep - mapSize - margin
		if rewardsH < 28 then
			mapSize = math.max(64, height - header - sep - margin - 28)
			rewardsH = height - header - sep - mapSize - margin
		end
	end

	panel.rewardScroll:ClearAllPoints()
	panel.rewardScroll:SetPoint("TOPLEFT", 10, -(header + 6))
	panel.rewardScroll:SetPoint("TOPRIGHT", -12, -(header + 6))
	panel.rewardScroll:SetHeight(math.max(rewardsH - 8, 1))

	if not useFullMap then
		panel.separator:ClearAllPoints()
		panel.separator:SetPoint("TOPLEFT", 8, -(header + rewardsH))
		panel.separator:SetPoint("TOPRIGHT", -8, -(header + rewardsH))

		panel.map:ClearAllPoints()
		panel.map:SetSize(mapSize, mapSize)
		panel.map:SetPoint("BOTTOM", panel, "BOTTOM", 0, margin)
	end

	local questName = FTAttuneLang["Q1_" .. panel.step.ID_WOWHEAD]
	if not questName or questName == "" then questName = FTAttuneLang["Quest rewards"] end
	panel.title:SetText(questName)

	local questIDs = FTAttune_RewardQuestIDs(panel.step.ID_WOWHEAD)
	local fixed, choices, spells = FTAttune_CollectQuestRewards(questIDs)
	spells = spells or {}
	local items = {}
	for _, entry in ipairs(fixed) do items[#items + 1] = entry end
	for _, entry in ipairs(choices) do items[#items + 1] = entry end

	local y = 6
	local xp = FTAttune_GetQuestLogRewardXP(questIDs)
	if panel.xpText then
		if xp then
			local fmt = FTAttuneLang["Experience reward"]
			if type(fmt) ~= "string" or fmt == "" or not string.find(fmt, "%%s", 1, true) then
				fmt = "+%s XP"
			end
			panel.xpText:SetText(fmt:format(FTAttune_FormatXPAmount(xp)))
			panel.xpText:ClearAllPoints()
			panel.xpText:SetPoint("TOPLEFT", 6, -y)
			panel.xpText:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -6, 0)
			panel.xpText:Show()
			y = y + 20
		else
			panel.xpText:Hide()
		end
	end

	for _, row in ipairs(panel.rows) do
		row.itemID = nil
		row.spellID = nil
		row:Hide()
	end
	spellReward.HideDetailHeaders(panel)
	if #items == 0 and #spells == 0 then
		panel.empty:Show()
		local known = FTAttune_QuestRewardsKnown(panel)
		local msg
		if not panel.rewardsFinal and not known then
			msg = FTAttuneLang["Loading rewards"]
		elseif known then
			msg = FTAttuneLang["No item rewards"]
		else
			msg = FTAttuneLang["Rewards only if available"]
		end
		panel.empty:ClearAllPoints()
		panel.empty:SetPoint("TOPLEFT", 6, -y)
		panel.empty:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -8, 0)
		panel.empty:SetText(msg)
		panel.rewardChild:SetHeight(math.max(y + (known and 28 or 48), 28))
	else
		panel.empty:Hide()
		local shown = 0
		for _, entry in ipairs(items) do
			local name, quality, texture = entry.name, entry.quality, entry.texture
			local itemName, _, itemQuality, _, _, itemType, itemSubType, _, itemEquipSlot, itemTexture, _, classID, subClassID = GetItemInfo(entry.itemID)
			if itemName and itemName ~= "" then
				name, quality, texture = itemName, itemQuality, itemTexture or texture
			else
				local storedName, storedIcon, storedQuality = FTAttune_StoredItem(entry.itemID)
				if storedName then name = storedName end
				if storedIcon and not texture then texture = storedIcon end
				if storedQuality and not quality then quality = storedQuality end
			end
			if GetItemInfoInstant and ((not itemType or itemType == "") or not itemEquipSlot or itemEquipSlot == "") then
				local _, instantType, instantSubType, instantEquip, _, instantClass, instantSubClass = GetItemInfoInstant(entry.itemID)
				if not itemType or itemType == "" then itemType, itemSubType = instantType, instantSubType end
				if (not itemEquipSlot or itemEquipSlot == "") and instantEquip and instantEquip ~= "" then itemEquipSlot = instantEquip end
				if not classID then classID = instantClass end
				if not subClassID then subClassID = instantSubClass end
			end
			if not name or name == "" then
				if C_Item and C_Item.RequestLoadItemDataByID then
					pcall(C_Item.RequestLoadItemDataByID, entry.itemID)
				end
			end
			if not name or name == "" then
				-- Wowhead has no name for this reward slot, and the client has not cached it.
			else
			shown = shown + 1
			local row = panel.rows[shown]
			if not row then
				row = FTAttune_DetailRewardRow(panel.rewardChild)
				panel.rows[shown] = row
			end
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", 4, -y)
	row:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -6, 0)
	row.itemID = entry.itemID
	row.spellID = nil
	FTAttune_SetSpellFrame(row, false)
	row.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
			local text = name
			if entry.count and entry.count > 1 then text = text .. " x" .. entry.count end
			-- if entry.choice then text = text .. " (" .. FTAttuneLang["Choose one reward"] .. ")" end
			row.name:SetText(text)
			local slotLabel = nil
			if type(itemEquipSlot) == "string" and itemEquipSlot ~= "" and itemEquipSlot ~= "INVTYPE_NON_EQUIP_IGNORE" then
				local label = _G[itemEquipSlot]
				if type(label) == "string" and label ~= "" then slotLabel = label end
			end
			local isWeapon = classID == 2 or itemType == "Weapon"
			local isArmor = classID == 4 or itemType == "Armor"
			local isMisc = itemSubType == "Misc" or itemSubType == "Miscellaneous" or (isArmor and subClassID == 0)
			local category = ""
			if isWeapon then
				category = itemSubType or ""
			elseif isMisc then
				category = slotLabel or ""
			elseif isArmor then
				if itemSubType and itemSubType ~= "" and slotLabel then
					category = itemSubType .. " - " .. slotLabel
				elseif slotLabel then
					category = slotLabel
				else
					category = itemSubType or ""
				end
			elseif itemType and itemType ~= "" and itemSubType and itemSubType ~= "" and itemSubType ~= itemType then
				category = itemType .. " - " .. itemSubType
			elseif itemType and itemType ~= "" then
				category = itemType
			elseif itemSubType and itemSubType ~= "" then
				category = itemSubType
			end
			row.category:SetText(category)
			if category == "" then row.category:Hide() else row.category:Show() end
			row.name:ClearAllPoints()
			row.name:SetPoint("RIGHT", row, "RIGHT", -2, 0)
			if category == "" then
				row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
			else
				row.name:SetPoint("BOTTOMLEFT", row.icon, "RIGHT", 6, 1)
			end
			local color = ITEM_QUALITY_COLORS and quality and ITEM_QUALITY_COLORS[quality]
			if color then
				row.name:SetTextColor(color.r, color.g, color.b)
			else
				row.name:SetTextColor(1, 1, 1)
			end
			row:Show()
			y = y + 42
			end
		end
		if #spells > 0 then
			if shown > 0 then y = y + 4 end
			spellReward.DetailHeader(panel, 1, spellReward.Header(), y)
			y = y + 18
			for _, entry in ipairs(spells) do
				y, shown = spellReward.ShowDetail(panel, entry, y, shown)
			end
		end
		if shown == 0 then
			panel.empty:Show()
			panel.empty:SetText(FTAttuneLang["No item rewards"])
			panel.rewardChild:SetHeight(28)
		else
			panel.rewardChild:SetWidth(math.max(width - 24, 20))
			panel.rewardChild:SetHeight(math.max(y, 1))
		end
	end

	if not (FTAttune_DB and FTAttune_DB.useFullMap) then
		local uiMapID, x, y, giver = FTAttune_DetailGiver(panel.step)
		if giver and giver ~= "" then
			panel.giver:SetText(FTAttuneLang["Starts at"] .. " " .. giver)
			panel.giver:Show()
		else
			panel.giver:Hide()
		end
		panel.map.art.zoom = panel.map.zoom or 1
		FTAttune_FillDetailMap(panel.map.art, uiMapID, x, y)
	end
end

local function FTAttune_EnsureQuestDetail()
	if attunelocal_questDetail then return attunelocal_questDetail end
	local panel = CreateFrame("Frame", "FTAttuneQuestDetail", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	panel:EnableMouse(true)
	panel:SetFrameStrata("HIGH")
	panel:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	panel:SetBackdropColor(0.07, 0.07, 0.07, 1)
	panel:SetBackdropBorderColor(0.45, 0.38, 0.2, 1)
	panel.rows = {}

	panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	panel.title:SetPoint("TOPLEFT", 14, -14)
	panel.title:SetPoint("RIGHT", panel, "RIGHT", -36, 0)
	panel.title:SetJustifyH("LEFT")
    panel.title:SetFont(GameFontNormal:GetFont(), 16, "")
	panel.title:SetWordWrap(false)

	panel.subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	panel.subtitle:SetPoint("TOPLEFT", 14, -36)
	panel.subtitle:SetPoint("RIGHT", panel, "RIGHT", -36, 0)
	panel.subtitle:SetJustifyH("LEFT")
    panel.subtitle:SetFont(GameFontNormal:GetFont(), 12, "")
	panel.subtitle:SetWordWrap(false)
    panel.subtitle:SetText("Quest rewards")
    panel.subtitle:SetTextColor(0.55, 0.55, 0.55)


	local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 4, 4)
	close:SetScript("OnClick", function() FTAttune_HideQuestDetail() end)

	local scroll = CreateFrame("ScrollFrame", nil, panel)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local range = self:GetVerticalScrollRange() or 0
		if range <= 0 then return end
		local nextScroll = self:GetVerticalScroll() - (delta * 24)
		if nextScroll < 0 then nextScroll = 0 end
		if nextScroll > range then nextScroll = range end
		self:SetVerticalScroll(nextScroll)
	end)
	panel.rewardScroll = scroll
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(100, 20)
	scroll:SetScrollChild(child)
	panel.rewardChild = child
	panel.xpText = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	panel.xpText:SetJustifyH("LEFT")
	panel.xpText:SetTextColor(0.15, 0.85, 1)
	panel.xpText:Hide()
	panel.empty = child:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	panel.empty:SetPoint("TOPLEFT", 6, -20)
	panel.empty:SetPoint("RIGHT", child, "RIGHT", -8, 0)
	panel.empty:SetJustifyH("LEFT")
	panel.empty:SetWordWrap(true)

	panel.separator = panel:CreateTexture(nil, "ARTWORK")
	panel.separator:SetHeight(2)
	panel.separator:SetColorTexture(0.72, 0.58, 0.28, 0.9)

	local map = CreateFrame("Frame", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
	map:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	map:SetBackdropColor(0, 0, 0, 1)
	map:SetBackdropBorderColor(0.75, 0.6, 0.28, 1)
	panel.map = map
	local art = CreateFrame("Frame", nil, map)
	art:SetPoint("TOPLEFT", 5, -5)
	art:SetPoint("BOTTOMRIGHT", -5, 5)
	if art.SetClipsChildren then art:SetClipsChildren(true) end
	map.art = art
	map.empty = art:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	map.empty:SetPoint("CENTER")
	map.empty:SetText(FTAttuneLang["Quest information not found"])
	map.empty:Hide()
	map.pin = CreateFrame("Button", nil, art)
	map.pin:SetSize(22, 22)
	map.pin:SetFrameLevel((art:GetFrameLevel() or 0) + 6)
	map.pin:EnableMouse(true)
	map.pin:RegisterForClicks("LeftButtonUp")
	map.pin:SetHitRectInsets(-8, -8, -8, -8)
	map.pin.icon = map.pin:CreateTexture(nil, "OVERLAY")
	map.pin.icon:SetAllPoints()
	local pinned = false
	if map.pin.icon.SetAtlas then
		pcall(map.pin.icon.SetAtlas, map.pin.icon, "Waypoint-MapPin-Tracked")
		pinned = map.pin.icon.GetAtlas and map.pin.icon:GetAtlas() == "Waypoint-MapPin-Tracked"
	end
	if not pinned then
		map.pin.icon:SetTexture("Interface\\Minimap\\Tracking\\QuestBlob")
	end
	map.pin:SetScript("OnClick", function(self)
		if IsModifiedClick("CHATLINK") then
			FTAttune_ShareDetailPin(self.uiMapID, self.pinX, self.pinY)
		end
	end)
	map.pin:SetScript("OnEnter", function(self)
		if not self.uiMapID then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -16, -4)
		local title = MAP_PIN_SHARING or "Map Pin"
		if GameTooltip_SetTitle then
			GameTooltip_SetTitle(GameTooltip, title)
			if MAP_PIN_SHARING_TOOLTIP and GameTooltip_AddNormalLine then
				GameTooltip_AddNormalLine(GameTooltip, MAP_PIN_SHARING_TOOLTIP)
			end
		else
			GameTooltip:SetText(title)
			if MAP_PIN_SHARING_TOOLTIP then
				GameTooltip:AddLine(MAP_PIN_SHARING_TOOLTIP, 1, 1, 1, true)
			end
		end
		GameTooltip:Show()
	end)
	map.pin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- FillDetailMap parents tiles and the pin to the clipped art frame.
	art.pin = map.pin
	art.empty = map.empty
	panel.giver = map:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	panel.giver:SetPoint("BOTTOMLEFT", 8, 8)
	panel.giver:SetPoint("BOTTOMRIGHT", -58, 8)
	panel.giver:SetJustifyH("CENTER")
	panel.giver:SetWordWrap(false)

	local function FTAttune_NudgeMapZoom(delta)
		local zoom = map.zoom or 1
		if delta > 0 then zoom = zoom * 1.35 else zoom = zoom / 1.35 end
		if zoom < 0.35 then zoom = 0.35 end
		if zoom > 8 then zoom = 8 end
		map.zoom = zoom
		if map.art then map.art.zoom = zoom end
		if panel:IsShown() then FTAttune_LayoutQuestDetail(panel) end
	end
	local zoomOut = CreateFrame("Button", nil, map, "UIPanelButtonTemplate")
	zoomOut:SetSize(22, 20)
	zoomOut:SetPoint("BOTTOMRIGHT", -6, 6)
	zoomOut:SetText("-")
	zoomOut:SetScript("OnClick", function() FTAttune_NudgeMapZoom(-1) end)
	local zoomIn = CreateFrame("Button", nil, map, "UIPanelButtonTemplate")
	zoomIn:SetSize(22, 20)
	zoomIn:SetPoint("RIGHT", zoomOut, "LEFT", -2, 0)
	zoomIn:SetText("+")
	zoomIn:SetScript("OnClick", function() FTAttune_NudgeMapZoom(1) end)
	zoomIn:SetFrameLevel(art:GetFrameLevel() + 5)
	zoomOut:SetFrameLevel(art:GetFrameLevel() + 5)
	art:EnableMouseWheel(true)
	art:SetScript("OnMouseWheel", function(_, delta) FTAttune_NudgeMapZoom(delta) end)
	map.pin:EnableMouseWheel(true)
	map.pin:SetScript("OnMouseWheel", function(_, delta) FTAttune_NudgeMapZoom(delta) end)

	local listener = CreateFrame("Frame", nil, panel)
	listener:SetScript("OnEvent", function(_, event, arg1, arg2)
		if event == "GET_ITEM_INFO_RECEIVED" or event == "SPELL_DATA_LOAD_RESULT" then
			if not panel:IsShown() then return end
			local wanted = false
			for _, row in ipairs(panel.rows) do
				if (event == "GET_ITEM_INFO_RECEIVED" and row.itemID == arg1) or (event == "SPELL_DATA_LOAD_RESULT" and row.spellID == arg1) then
					wanted = true
					break
				end
			end
			if not wanted then return end
			FTAttune_LayoutQuestDetail(panel)
			FTAttune_RefreshRewardTooltip(panel.rows)
			return
		end
		if event == "UNIT_QUEST_LOG_CHANGED" and arg1 ~= "player" then
			return
		end
		if event == "QUEST_DATA_LOAD_RESULT" and arg1 and arg2 then
			panel.questLoaded = panel.questLoaded or {}
			panel.questLoaded[arg1] = true
		end
		if panel:IsShown() then FTAttune_LayoutQuestDetail(panel) end
	end)
	panel:SetScript("OnShow", function(self)
		listener:RegisterEvent("QUEST_DATA_LOAD_RESULT")
		listener:RegisterEvent("GET_ITEM_INFO_RECEIVED")
		pcall(listener.RegisterEvent, listener, "SPELL_DATA_LOAD_RESULT")
		listener:RegisterEvent("QUEST_LOG_UPDATE")
		listener:RegisterEvent("QUEST_ACCEPTED")
		listener:RegisterEvent("QUEST_REMOVED")
		listener:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
		pcall(listener.RegisterEvent, listener, "MAP_EXPLORATION_UPDATED")
	end)
	panel:SetScript("OnHide", function()
		listener:UnregisterEvent("QUEST_DATA_LOAD_RESULT")
		listener:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
		pcall(listener.UnregisterEvent, listener, "SPELL_DATA_LOAD_RESULT")
		listener:UnregisterEvent("QUEST_LOG_UPDATE")
		listener:UnregisterEvent("QUEST_ACCEPTED")
		listener:UnregisterEvent("QUEST_REMOVED")
		listener:UnregisterEvent("UNIT_QUEST_LOG_CHANGED")
		pcall(listener.UnregisterEvent, listener, "MAP_EXPLORATION_UPDATED")
	end)
	panel:SetScript("OnSizeChanged", function(self)
		if self:IsShown() and not self.layingOut then
			self.layingOut = true
			FTAttune_LayoutQuestDetail(self)
			self.layingOut = false
		end
	end)

	panel:Hide()
	attunelocal_questDetail = panel
	return panel
end

function FTAttune_HideQuestDetail()
	local widget = attunelocal_treeframe
	if widget and widget.treeframe then
		widget.treeframe.attuneDetailOpen = nil
	end
	if attunelocal_questDetail then
		attunelocal_questDetail:Hide()
		-- Pull it off the tree before that tree is released, so its scroll child is not torn down with the pool.
		attunelocal_questDetail:SetParent(UIParent)
		attunelocal_questDetail.key = nil
		attunelocal_questDetail.step = nil
	end
	FTAttune_CloseQuestGiverMap()
	if widget and widget.RefreshTree and widget.treeframe and widget.treeframe:IsShown() then
		widget:RefreshTree()
	end
end

function FTAttune_ShowQuestDetail(step)
	if not step or not attunelocal_treeframe or not attunelocal_treeframe.treeframe then return end
	local tree = attunelocal_treeframe.treeframe
	local panel = FTAttune_EnsureQuestDetail()
	local key = FTAttune_QuestDetailKey(step)
	if panel:IsShown() and panel.key == key then
		FTAttune_HideQuestDetail()
		return
	end
	if attunelocal_rewardFrame then attunelocal_rewardFrame:Hide() end
	panel.key = key
	panel.step = step
	panel.rewardsFinal = false
	panel.questLoaded = {}
	if panel.map then panel.map.zoom = 1 end
	panel:SetParent(tree)
	panel:ClearAllPoints()
	panel:SetAllPoints(tree)
	panel:SetFrameStrata(tree:GetFrameStrata() or "HIGH")
	panel:SetFrameLevel((tree:GetFrameLevel() or 1) + 50)
	tree.attuneDetailOpen = true
	for _, button in ipairs(attunelocal_treeframe.buttons or {}) do
		button:Hide()
	end
	if attunelocal_treeframe.scrollbar then attunelocal_treeframe.scrollbar:Hide() end
	panel:Show()
	FTAttune_LayoutQuestDetail(panel)
	if FTAttune_DB and FTAttune_DB.useFullMap then
		FTAttune_ShowQuestGiverMap(step)
	end

	if C_QuestLog and C_QuestLog.RequestLoadQuestByID then
		for _, questID in ipairs(FTAttune_RewardQuestIDs(step.ID_WOWHEAD)) do
			pcall(C_QuestLog.RequestLoadQuestByID, questID)
		end
	end
	local token = key
	if C_Timer and C_Timer.After then
		C_Timer.After(0.4, function()
			if panel:IsShown() and panel.key == token then
				panel.rewardsFinal = true
				FTAttune_LayoutQuestDetail(panel)
			end
		end)
	end
end

function FTAttune_RefreshQuestMapMode()
	local panel = attunelocal_questDetail
	if not panel or not panel:IsShown() or not panel.step then return end
	FTAttune_LayoutQuestDetail(panel)
	if FTAttune_DB and FTAttune_DB.useFullMap then
		FTAttune_ShowQuestGiverMap(panel.step)
	else
		FTAttune_CloseQuestGiverMap()
	end
end


-- ForeverTools lifecycle. FTStart runs once; toggling never recreates brokers/options.
FTAttune:SetEnabledState(false)
function FTAttune:OnInitialize() self.ftReady = true end
function FTAttune:OnEnable()
    if not ForeverTools.modules.attune:Active() then self:Disable(); return end
    if not self.ftStarted then
        local ok, err = pcall(function()
            self:FTStart()
            self:FTRegisterOptions()
        end)
        if not ok then
            ForeverTools.modules.attune.failed = true
            self:Disable()
            ForeverTools:Print("Attune: " .. tostring(err))
            return
        end
        self.ftStarted = true
    else
        for _, event in ipairs({"CHAT_MSG_ADDON", "PLAYER_LOGOUT", "PLAYER_LEVEL_UP",
            "QUEST_ACCEPTED", "QUEST_REMOVED", "QUEST_TURNED_IN", "UPDATE_FACTION",
            "BAG_UPDATE", "GOSSIP_SHOW", "QUEST_DETAIL"}) do self:RegisterEvent(event) end
        if attunelocal_hasCombatLog then cleu_parser:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else cleu_parser:RegisterEvent("PARTY_KILL"); cleu_parser:RegisterEvent("UNIT_DIED") end
        self:RegisterComm(attunelocal_syncprefix)
        FTAttune_CheckProgress()
        self:BAG_UPDATE(nil)
        FTAttune_ForceAttuneTabRefresh()
        if not FTAttune_DB.minimapbuttonpos.hide then attunelocal_minimapicon:Show("FTAttune_Broker") end
    end
end
function FTAttune:OnDisable()
    cleu_parser:UnregisterAllEvents()
    if self.ftStarted then FTAttune_SaveTreeExpandStatus() end
    attuneItemScanQueued = false
    if attunelocal_iconView then attunelocal_iconView.pending = false end
    attunelocal_syncStatus = -1
    FTAttune_CloseQuestGiverMap()
    for _, widget in pairs({main=attunelocal_frame, export=attunelocal_export_frame,
        survey=attunelocal_survey_frame, sync=attunelocal_syncProgressWidget,
        reward=attunelocal_rewardFrame, detail=attunelocal_questDetail}) do
        if widget.Hide then widget:Hide() end
    end
    attunelocal_minimapicon:Hide("FTAttune_Broker")
    LibStub("AceConfigDialog-3.0"):Close("FTAttune")
end
FTAttune.ftSendCommMessage = FTAttune.SendCommMessage
function FTAttune:SendCommMessage(...)
    if ForeverTools.modules.attune:Active() then return self:ftSendCommMessage(...) end
end

end
setfenv(Component, FT.attuneEnv)
Component(...)
