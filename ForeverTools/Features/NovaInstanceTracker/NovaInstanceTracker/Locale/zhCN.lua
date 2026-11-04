-- Local adaptation; see ../NOTICE.txt.
local _, FT = ...
local function Component(...)
local L = LibStub("AceLocale-3.0"):NewLocale("FTNovaInstanceTracker", "zhCN");
if (not L) then
	return;
end

L["noTimer"] = "无计时器";
L["noCurrentTimer"] = "无当前计时器";
L["noActiveTimers"] = "无活动计时器";
L["second"] = "秒";
L["seconds"] = "秒";
L["minute"] = "分钟";
L["minutes"] = "分钟";
L["hour"] = "小时";
L["hours"] = "小时";
L["day"] = "天";
L["days"] = "天";
L["year"] = "年";
L["years"] = "年";
L["secondMedium"] = "秒";
L["secondsMedium"] = "秒";
L["minuteMedium"] = "分";
L["minutesMedium"] = "分";
L["hourMedium"] = "小时";
L["hoursMedium"] = "小时";
L["dayMedium"] = "天";
L["daysMedium"] = "天";
L["yearMedium"] = "年";
L["yearsMedium"] = "年";
L["secondShort"] = "秒";
L["minuteShort"] = "分";
L["hourShort"] = "时";
L["dayShort"] = "天";
L["yearShort"] = "年";
L["startsIn"] = "%s后开始";
L["endsIn"] = "%s后结束";
L["versionOutOfDate"] = "Nova Instance Tracker 已过期，请到 https://www.curseforge.com/wow/addons/nova-instance-tracker 更新";
L["Options"] = "选项";
L["Reset Data"] = "重置数据";

L["Error"] = "错误";
L["delete"] = "删除";
L["confirmInstanceDeletion"] = "确认删除副本";
L["confirmCharacterDeletion"] = "确认删除角色";

-------------
---配置---
-------------
---这里的字符串有两种类型，名称以 Title 或 Desc 结尾，例如 L["exampleTitle"] 和 L["exampleDesc"]。
---Title 不能超过 21 个字符（中文字符可能更少，因为它们更大）。
---Desc 可以是任意长度。

---常规选项---
L["generalHeaderDesc"] = "常规选项";

L["chatColorTitle"] = "聊天信息颜色";
L["chatColorDesc"] = "聊天信息应使用什么颜色？";

L["resetColorsTitle"] = "重置颜色";
L["resetColorsDesc"] = "将颜色重置为默认值。";

L["timeStampFormatTitle"] = "时间戳格式";
L["timeStampFormatDesc"] = "设置使用哪种时间戳格式：12小时制 (1:23pm) 或 24小时制 (13:23)。";

L["timeStampZoneTitle"] = "本地时间 / 服务器时间";
L["timeStampZoneDesc"] = "时间戳使用本地时间还是服务器时间？";

L["minimapButtonTitle"] = "显示小地图按钮";
L["minimapButtonDesc"] = "在小地图上显示 NIT 按钮吗？";

---音效---
L["soundsHeaderDesc"] = "音效";

L["soundsTextDesc"] = "将音效设置为“无”以禁用。";

L["disableAllSoundsTitle"] = "禁用所有音效";
L["disableAllSoundsDesc"] = "禁用此插件的所有音效。";

L["extraSoundOptionsTitle"] = "额外音效选项";
L["extraSoundOptionsDesc"] = "启用此项可在此处的下拉列表中一次性显示您所有插件的所有音效。";

L["notesHeaderDesc"] = "一些说明：";
L["notesDesc"] = "此插件尽力计算您何时可以进入更多副本，但暴雪的锁定系统有时存在错误，您可能在达到正确限制前就被锁定。有时您每小时只能进入4次，但有时也可以进入6次。";

L["logHeaderDesc"] = "日志窗口";

L["openInstanceLogFrameTitle"] = "打开副本日志";

L["logSizeTitle"] = "日志中显示多少副本";
L["logSizeDesc"] = "您希望在日志中显示多少个副本？最多存储300个，默认显示100个（可以用 /NIT 打开日志）。";

L["enteredMsgTitle"] = "地下城进入信息";
L["enteredMsgDesc"] = "当您进入5人地下城时，此选项会在主聊天窗口打印一条信息，并带有一个 X 图标，以便您从数据库中删除新副本（如果需要）。";

L["raidEnteredMsgTitle"] = "团队副本进入信息";
L["raidEnteredMsgDesc"] = "当您进入团队副本时，此选项会在主聊天窗口打印一条信息，并带有一个 X 图标，以便您从数据库中删除新副本（如果需要）。";

L["pvpEnteredMsgTitle"] = "PvP战场进入信息";
L["pvpEnteredMsgDesc"] = "当您进入PvP战场时，此选项会在主聊天窗口打印一条信息，并带有一个 X 图标，以便您从数据库中删除新副本（如果需要）。";

L["noRaidInstanceMergeMsgTitle"] = "隐藏团队副本合并信息";
L["noRaidInstanceMergeMsgDesc"] = "当您进入团队副本并检测到相同ID时，隐藏副本合并信息？";

L["instanceResetMsgTitle"] = "队伍副本重置信息";
L["instanceResetMsgDesc"] = "如果您是队长，此选项将向您的队伍或团队显示哪些副本已成功重置的信息。例如：“哀嚎洞穴已被重置。”";

L["showMoneyTradedChatTitle"] = "在聊天中显示金币交易";
L["showMoneyTradedChatDesc"] = "在交易频道显示您给予或从某人那里收到金币的信息？（有助于在代练队伍中跟踪您已支付或收到金币的对象）。";

L["instanceStatsHeaderDesc"] = "地下城结束统计输出";

L["instanceStatsTextDesc"] = "在此选择离开地下城时要在队伍聊天或您的聊天窗口中显示的统计信息。";

L["instanceStatsOutputTitle"] = "显示统计";
L["instanceStatsOutputDesc"] = "离开时显示地下城的统计信息吗？";

L["instanceStatsOutputWhereTitle"] = "统计显示位置";
L["instanceStatsOutputWhereDesc"] = "您希望在哪里显示统计信息？显示在您自己的聊天窗口还是队伍聊天中？";

L["instanceStatsOutputMobCountTitle"] = "显示怪物数量";
L["instanceStatsOutputMobCountDesc"] = "显示在地下城中杀死了多少怪物？";

L["instanceStatsOutputXPTitle"] = "显示经验值";
L["instanceStatsOutputXPDesc"] = "显示在地下城中获得了多少经验值？";

L["instanceStatsOutputAverageXPTitle"] = "显示平均经验";
L["instanceStatsOutputAverageXPDesc"] = "显示在地下城中每次击杀获得的平均经验值？";

L["instanceStatsOutputTimeTitle"] = "显示时间";
L["instanceStatsOutputTimeDesc"] = "显示您在地下城中花费了多长时间？";

L["instanceStatsOutputGoldTitle"] = "显示金币";
L["instanceStatsOutputGoldDesc"] = "显示在地下城中从怪物身上拾取了多少金币？";

L["instanceStatsOutputAverageGroupLevelTitle"] = "显示平均等级";
L["instanceStatsOutputAverageGroupLevelDesc"] = "显示地下城中队伍的平均等级？";

L["showAltsLogTitle"] = "显示小号";
L["showAltsLogDesc"] = "在副本日志中显示小号吗？";

L["timeStringTypeTitle"] = "时间字符串格式";
L["timeStringTypeDesc"] = "在副本日志中使用什么时间字符串格式？\n|cFFFFFF00长格式：|r 1分钟30秒\n|cFFFFFF00中格式：|r 1分30秒\n|cFFFFFF00短格式：|r 1分30秒";

L["showLockoutTimeTitle"] = "显示锁定剩余时间";
L["showLockoutTimeDesc"] = "这将在副本日志中显示过去24小时内副本的锁定剩余时间。如果取消勾选，则会像旧版本一样显示进入时间。";

L["colorsHeaderDesc"] = "颜色";

L["mergeColorTitle"] = "副本合并颜色";
L["mergeColorDesc"] = "当检测到与上次相同的副本并合并数据时，聊天信息应使用什么颜色？";

L["detectSameInstanceTitle"] = "检测相同副本";
L["detectSameInstanceDesc"] = "自动检测您是否重新进入同一个副本，以便插件不会将其计为两个单独的副本？";

L["showStatsInRaidTitle"] = "在团队中显示统计";
L["showStatsInRaidDesc"] = "在团队中显示统计吗？禁用此选项则仅在5人小队中显示统计信息（此选项仅在您将统计输出设置为队伍聊天时有效）。";

L["printRaidInsteadTitle"] = "在团队中改为打印";
L["printRaidInsteadDesc"] = "如果您禁用了向团队聊天发送统计信息的选项，那么此选项会将它们打印到您的聊天窗口，以便您仍然可以看到它们。";

L["statsOnlyWhenActivityTitle"] = "仅在有活动时显示";
L["statsOnlyWhenActivityDesc"] = "仅在地下城内发生活动时显示统计信息？这意味着只有当您杀死了一些怪物、获得了经验、拾取了一些金币等时才显示。这将避免显示空统计信息。";

L["show24HourOnlyTitle"] = "仅显示过去24小时";
L["show24HourOnlyDesc"] = "在副本日志中仅显示过去24小时内的副本？";

L["trimDataHeaderDesc"] = "数据清理";

L["trimDataBelowLevelTitle"] = "要删除的最高等级";
L["trimDataBelowLevelDesc"] = "选择要从数据库中删除的角色最高等级，所有等于或低于此等级的角色都将被删除。";

L["trimDataBelowLevelButtonTitle"] = "删除角色";
L["trimDataBelowLevelButtonDesc"] = "点击此按钮从此插件数据库中删除所有选定等级及以下的角色。";

L["trimDataTextDesc"] = "从数据库中删除多个角色：";
L["trimDataText2Desc"] = "从数据库中删除一个角色：";

L["trimDataCharInputTitle"] = "删除单个角色输入框";
L["trimDataCharInputDesc"] = "在此输入要删除的角色，格式为 名称-服务器（区分大小写）。注意：这会永久删除增益计数数据。";

L["trimDataBelowLevelButtonConfirm"] = "您确定要从数据库中删除所有低于 %s 级的角色吗？";
L["trimDataCharInputConfirm"] = "您确定要从数据库中删除角色 %s 吗？";

L["trimDataMsg2"] = "正在删除所有低于 %s 级的角色。";
L["trimDataMsg3"] = "已删除：%s。";
L["trimDataMsg4"] = "完成，未找到角色。";
L["trimDataMsg5"] = "完成，删除了 %s 个角色。";
L["trimDataMsg6"] = "请输入要删除的有效 角色名称-服务器。";
L["trimDataMsg7"] = "此角色名 %s 未包含服务器，请输入 名称-服务器。";
L["trimDataMsg8"] = "删除 %s 时出错，未找到该角色（名称区分大小写）。";
L["trimDataMsg9"] = "已从数据库中删除 %s。";

L["instanceFrameSelectAltMsg"] = "如果未勾选“显示所有小号”，则选择要显示哪个小号。\n或者如果勾选了“显示所有小号”，则选择要为哪个小号着色。";

L["enteredDungeon"] = "新副本 %s %s，点击";
L["enteredDungeon2"] = "如果这不是一个新副本。";
L["enteredRaid"] = "新副本 %s，此团队副本不计入锁定。";
L["loggedInDungeon"] = "您登录在 %s %s 内，如果这不是一个新副本，请点击";
L["loggedInDungeon2"] = "从数据库中删除此副本。";
L["reloadDungeon"] = "检测到界面重载 %s，改为加载上次副本数据而不是创建新数据。";
L["thisHour"] = "次在这小时之内";
L["statsError"] = "查找副本ID %s 的统计信息时出错。";
L["statsMobs"] = "怪物：";
L["statsXP"] = "经验：";
L["statsAverageXP"] = "平均经验/怪物：";
L["statsRunsPerLevel"] = "每级所需次数：";
L["statsRunsNextLevel"] = "升到下一级还需次数：";
L["statsTime"] = "时间：";
L["statsAverageGroupLevel"] = "队伍平均等级：";
L["statsGold"] = "金币";
L["sameInstance"] = "检测到与上次相同的副本ID %s，正在合并数据库条目。";
L["deleteInstance"] = "已从数据库中删除副本 [%s] %s（%s前）。";
L["deleteInstanceError"] = "删除 %s 时出错。";
L["countString"] = "您在过去1小时内进入了 %s 个副本，在过去24小时内进入了 %s 个副本";
L["countStringColorized"] = "您在过去1小时内进入了 %s%s %s 个副本，在过去24小时内进入了 %s%s %s 个副本";
L["now"] = "现在";
L["in"] = "于";
L["active24"] = "24小时锁定生效中";
L["nextInstanceAvailable"] = "下一个副本可进入";
L["gave"] = "给予";
L["received"] = "收到";
L["to"] = "给";
L["from"] = "来自";
L["playersStillInside"] = "已被重置（仍在旧副本内的玩家可以离开区域并进入新副本）。";
L["Gold"] = "金币";
L["gold"] = "金";
L["silver"] = "银";
L["copper"] = "铜";
L["newInstanceNow"] = "现在可以进入一个新副本";
L["thisHour24"] = "本24小时内";
L["openInstanceFrame"] = "打开副本窗口";
L["openYourChars"] = "打开您的角色";
L["openTradeLog"] = "打开交易日志";
L["config"] = "配置";
L["thisChar"] = "此角色";
L["yourChars"] = "您的角色";
L["instancesPastHour"] = "次副本在过去1小时内。";
L["instancesPastHour24"] = "次副本在过去24小时内。";
L["leftOnLockout"] = "锁定剩余";
L["tradeLog"] = "交易日志";
L["pastHour"] = "过去1小时";
L["pastHour24"] = "过去24小时";
L["older"] = "更早";
L["raid"] = "团队";
L["alts"] = "小号";
L["deleteEntry"] = "删除条目";
L["lastHour"] = "最近1小时";
L["lastHour24"] = "最近24小时";
L["entered"] = "进入于";
L["ago"] = "前";
L["stillInDungeon"] = "仍在副本内";
L["leftOnDailyLockout"] = "每日锁定剩余";
L["noLockout"] = "无锁定";
L["unknown"] = "未知";
L["instance"] = "副本";
L["timeEntered"] = "进入时间";
L["timeLeft"] = "剩余时间";
L["timeInside"] = "用时";
L["mobCount"] = "怪物数量";
L["experience"] = "经验值";
L["experienceShort"] = "经验";
L["rawGoldMobs"] = "怪物掉落金币";
L["enteredLevel"] = "进入等级";
L["leftLevel"] = "离开等级";
L["averageGroupLevel"] = "队伍平均等级";
L["currentLockouts"] = "当前锁定";
L["repGains"] = "声望获取";
L["groupMembers"] = "队伍成员";
L["tradesWhileInside"] = "副本内交易";
L["noDataInstance"] = "此副本无可用数据。";
L["restedOnlyText"] = "仅显示休息角色";
L["restedOnlyTextTooltip"] = "仅显示有休息经验值的角色？取消勾选此项以显示所有小号，包括满级和没有休息经验的小号。";
L["online"] = "在线";
L["maximum"] = "最大";
L["level"] = "等级";
L["rested"] = "休息";
L["realmGold"] = "服务器金币 -";
L["total"] = "总计";
L["guild"] = "公会";
L["resting"] = "休息中";
L["notResting"] = "未休息";
L["restedBubbles"] = "休息气泡";
L["restedState"] = "休息状态";
L["bagSlots"] = "背包空格";
L["durability"] = "耐久度";
L["items"] = "物品";
L["ammunition"] = "弹药";
L["petStatus"] = "宠物状态";
L["name"] = "名称";
L["family"] = "种类";
L["happiness"] = "快乐值";
L["loyaltyRate"] = "忠诚度提升速度";
L["petExperience"] = "宠物经验";
L["unspentTrainingPoints"] = "未使用训练点数";
L["professions"] = "专业";
L["lastSeenPetDetails"] = "上次看到的宠物详情";
L["currentPet"] = "当前宠物";
L["noPetSummoned"] = "未召唤宠物";
L["noProfessions"] = "未找到专业。";
L["cooldowns"] = "冷却时间";
L["left"] = "剩余";
L["ready"] = "就绪。";
L["pvp"] = "PvP";
L["rank"] = "等级";
L["lastWeek"] = "上周";
L["attunements"] = "门任务";
L["currentRaidLockouts"] = "当前团队副本锁定";
L["none"] = "无。";

L["instanceStatsOutputRunsPerLevelTitle"] = "每级所需次数";
L["instanceStatsOutputRunsPerLevelDesc"] = "显示升到当前等级需要多少次副本？";

L["instanceStatsOutputRunsNextLevelTitle"] = "升级还需次数";
L["instanceStatsOutputRunsNextLevelDesc"] = "显示升到下一级还需要多少次副本？";

L["instanceWindowWidthTitle"] = "副本窗口宽度";
L["instanceWindowWidthDesc"] = "副本窗口应该多宽。";

L["instanceWindowHeightTitle"] = "副本窗口高度";
L["instanceWindowHeightDesc"] = "副本窗口应该多高。";

L["charsWindowWidthTitle"] = "角色窗口宽度";
L["charsWindowWidthDesc"] = "角色信息窗口应该多宽。";

L["charsWindowHeightTitle"] = "角色窗口高度";
L["charsWindowHeightDesc"] = "角色信息窗口应该多高。";

L["tradeWindowWidthTitle"] = "交易窗口宽度";
L["tradeWindowWidthDesc"] = "交易窗口应该多宽。";

L["tradeWindowHeightTitle"] = "交易窗口高度";
L["tradeWindowHeightDesc"] = "交易窗口应该多高。";

L["resetFramesTitle"] = "重置窗口";
L["resetFramesDesc"] = "将所有窗口重置到屏幕中央并将大小恢复为默认值。";

L["resetFramesMsg"] = "正在重置所有窗口位置和大小。";

L["statsRep"] = "声望：";

L["instanceStatsOutputRepTitle"] = "获得声望";
L["instanceStatsOutputRepDesc"] = "显示在地下城中获得了多少声望？";

L["instanceStatsOutputHKTitle"] = "荣誉";
L["instanceStatsOutputHKDesc"] = "显示在战场中获得了多少荣誉？";

L["experiencePerHour"] = "经验/小时";

L["instanceStatsOutputXpPerHourTitle"] = "显示经验/小时";
L["instanceStatsOutputXpPerHourDesc"] = "显示在地下城中每小时获得多少经验？";

L["autoDialogueDesc"] = "自动NPC对话";

L["autoSlavePensTitle"] = "自动奴隶围栏";
L["autoSlavePensDesc"] = "自动与奴隶围栏笼子里的NPC对话？";

L["autoCavernsFlightTitle"] = "自动时光之穴飞行";
L["autoCavernsFlightDesc"] = "自动与时光之穴召唤石附近的龙对话飞下去？（仅当完成“前往主人的巢穴”任务后）";

L["autoBlackMorassTitle"] = "自动黑暗沼泽";
L["autoBlackMorassDesc"] = "自动与黑色沼泽起始处的NPC对话获取你的信标？（仅当完成“龙喉的英雄”任务后）";

L["autoSfkDoorTitle"] = "自动影牙城堡开门";
L["autoSfkDoorDesc"] = "自动与影牙城堡中开门的NPC对话？";

L["honorGains"] = "荣誉获取";
L["Honor"] = "荣誉";
L["Won"] = "胜利";
L["Lost"] = "失败";
L["Arena"] = "竞技场";
L["Arena Points"] = "竞技场点数";

L["stillInArena"] = "仍在竞技场内";
L["stillInBattleground"] = "仍在战场内";

L["resetAllInstancesConfirm"] = "您确定要删除日志中的所有副本数据吗？";
L["All Instance log data has been deleted."] = "所有副本日志数据已被删除。";

L["resetAllInstancesTitle"] = "重置副本数据";
L["resetAllInstancesDesc"] = "这将重置所有副本数据并从日志中删除所有内容。这不重置交易记录。";

L["autoCavernsArthasTitle"] = "自动净化斯坦索姆阿尔萨斯";
L["autoCavernsArthasDesc"] = "在巫妖王版本中自动与净化斯坦索姆中的阿尔萨斯对话？";

L["Mythic Plus"] = "史诗钥石地下城";
L["mythicPlusShort"] = "M+";

L["noCurrentRaidLockouts"] = "无当前团队副本锁定。";

L["weeklyQuests"] = "每周任务";
L["dailyQuests"] = "每日任务";
L["monthlyQuests"] = "每月任务";

L["openLockouts"] = "打开锁定信息";

L["autoGammaBuffDesc"] = "伽马/暮光地下城";

L["autoGammaBuffTitle"] = "自动获取伽马增益";
L["autoGammaBuffDesc"] = "在伽马地下城中与增益NPC对话时，自动获取适合您职业的伽马增益。";

L["autoGammaBuffReminderTitle"] = "伽马增益提醒";
L["autoGammaBuffReminderDesc"] = "在副本开始时向聊天窗口发送一条信息，提醒您如果没有增益就去获取。";

L["autoGammaBuffTypeTitle"] = "伽马增益类型";
L["autoGammaBuffTypeDesc"] = "您想要什么类型的增益？“自动选择”将根据您的专精在近战/远程/治疗/坦克之间自动选择。或者您可以用不同的选择覆盖它。增益选择是角色特定的配置选项。";

L["dungeonPopTimerTitle"] = "副本就绪计时器";
L["dungeonPopTimerDesc"] = "在副本队列就绪窗口上显示一个计时器，显示点击进入的剩余时间？";

L["autoWrathDailiesTitle"] = "自动接/交每日任务";
L["autoWrathDailiesDesc"] = "自动从达拉然的兰达洛克大法师处接取和交还巫妖王之怒的每日任务";

L["gammaConfigWarning"] = "伽马增益选择是角色特定的，如果您在此角色上更改它，不会影响您的其他角色。";
L["autoGammaBuffReminder"] = "从 %s 获取伽马地下城增益。";
L["Sunreaver Warden"] = "夺日者看守";
L["Silver Covenant Warden"] = "银色盟约看守";
L["note"] = "注意：";
L["Click an entry to post stats."] = "点击条目发布统计信息。";
L["Show Alts"] = "显示小号";
L["showAltsTooltip"] = "在副本日志中显示所有小号？（锁定是按角色计算的）";
L["PvE"] = "PvE";
L["Hold to drag"] = "按住拖动";
L["Raid Lockouts (Including Alts)"] = "团队副本锁定（包括小号）";
L["No trade logs found."] = "未找到交易日志。";
L["Today"] = "今天";
L["Yesterday"] = "昨天";

L["Level Log"] = "等级日志";
L["Mouseover log entry for more info"] = "鼠标悬停日志条目查看更多信息";
L["Current Level"] = "当前等级";
L["Leveling history for"] = "的升级历史";
L["Unknown Time"] = "未知时间";
L["Unknown Zone"] = "未知区域";
L["Zone"] = "区域";
L["SubZone"] = "子区域";
L["Ding"] = "升级"; --Level up.
L["Map coords"] = "地图坐标";
L["Gold owned at start of level"] = "本等级开始时的金币";
L["Gold change during this level"] = "本等级期间金币变化";
L["Quests completed during this level"] = "本等级完成的Quest";
L["Mobs that gave exp during this level"] = "本等级给予经验的怪物";
L["Played time this level"] = "本等级游戏时间";
L["Total Played"] = "总游戏时间";
L["firstTimeSeeingCharPlayed"] = "首次看到此角色时处于此等级，本等级的游戏时间可能不准确。";

L["Left-Click"] = "左键点击";
L["Right-Click"] = "右键点击";
L["Shift Left-Click"] = "Shift+左键点击";
L["Shift Right-Click"] = "Shift+右键点击";
L["Middle-Click"] = "中键点击";
L["Control Left-Click"] = "Ctrl+左键点击";

L["Lockouts"] = "锁定";
L["ZoneID"] = "区域ID";
L["Show dungeons and raids?"] = "显示地下城和团队副本？";
L["Show battleground and arena instances?"] = "显示战场和竞技场副本？";
L["Party"] = "小队";
L["Copy Paste"] = "复制粘贴";
L["Print"] = "打印";
L["Post Stats for log"] = "发布日志的统计信息";
L["Alts (Mouseover names for info)"] = "小号（鼠标悬停名称查看信息）";
L["Min Level"] = "最低等级";
L["No guild"] = "无公会";
L["No guild rank"] = "无公会等级";
L["Show leveling history for"] = "显示的升级历史";
L["Test Instance"] = "测试副本";
L["Long"] = "长格式";
L["Medium"] = "中格式";
L["Short"] = "短格式";
L["Chat Window"] = "聊天窗口";
L["Group Chat (Party/Raid)"] = "队伍聊天（小队/团队）";
L["12 hour"] = "12小时制";
L["24 hour"] = "24小时制";

L["Molten Core"] = "熔火之心";
L["Onyxia's Lair"] = "奥妮克希亚的巢穴";
L["Blackwing Lair"] = "黑翼之巢";
L["Naxxramas"] = "纳克萨玛斯";
L["Karazhan"] = "卡拉赞";
L["The Shattered Halls"] = "破碎大厅";
L["Serpentshrine Cavern"] = "毒蛇神殿";
L["The Arcatraz"] = "禁魔监狱";
L["Black Morass"] = "黑色沼泽";
L["Battle of Mount Hyjal"] = "海加尔峰之战";
L["Black Temple"] = "黑暗神殿";
L["Hellfire Citadel"] = "地狱火堡垒";
L["Coilfang Reservoir"] = "盘牙水库";
L["Shadow Labyrinth"] = "暗影迷宫";
L["Auchindoun"] = "奥金顿";
L["Tempest Keep"] = "风暴要塞";
L["Caverns of Time"] = "时光之穴";
L["deletedCharOnRealm"] = "已删除服务器 [%s] 上的角色 %s。";
L["deletedCharOnRealmNewInfo"] = "已删除服务器 [%s] 上的角色 %s，正在记录新信息。";

L["Time"] = "时间";
L["Show time?"] = "显示时间？";
L["Show Zone where trade happened?"] = "显示交易发生的区域？";
L["Time Ago"] = "多久前";
L["Show how long ago?"] = "显示多久前？";
L["Records"] = "记录";
L["How many trade records to show?"] = "显示多少条交易记录？";
L["Current Hour Lockouts"] = "当前小时锁定";
L["Current Dungeon Stats"] = "当前地下城统计";
L["Log Entry"] = "日志条目";
L["Local Time"] = "本地时间";
L["Server Time"] = "服务器时间";
L["Example"] = "示例";

--Abbreviated days/months.
L["Mon"] = "周一";
L["Tue"] = "周二";
L["Wed"] = "周三";
L["Thu"] = "周四";
L["Fri"] = "周五";
L["Sat"] = "周六";
L["Sun"] = "周日";

L["Jan"] = "1月";
L["Feb"] = "2月";
L["Mar"] = "3月";
L["Apr"] = "4月";
L["May"] = "5月";
L["Jun"] = "6月";
L["Jul"] = "7月";
L["Aug"] = "8月";
L["Sep"] = "9月";
L["Oct"] = "10月";
L["Nov"] = "11月";
L["Dec"] = "12月";

L["Blacksmithing"] = "锻造";
L["Leatherworking"] = "制皮";
L["Alchemy"] = "炼金术";
L["Herbalism"] = "草药学";
L["Cooking"] = "烹饪";
L["Mining"] = "采矿";
L["Tailoring"] = "裁缝";
L["Engineering"] = "工程学";
L["Enchanting"] = "附魔";
L["Fishing"] = "钓鱼";
L["Skinning"] = "剥皮";
L["Jewelcrafting"] = "珠宝加工";
L["Inscription"] = "铭文";
L["First Aid"] = "急救";

L["Wrath Cooking Daily"] = "巫妖王烹饪每日";
L["Wrath Fishing Daily"] = "巫妖王钓鱼每日";
L["Wrath Jewelcrafting Daily"] = "巫妖王珠宝加工每日";
L["Cata Cooking Daily"] = "大灾变烹饪每日";
L["Cata Fishing Daily"] = "大灾变钓鱼每日";
L["Cata Jewelcrafting Daily"] = "大灾变珠宝加工每日";

L["Tarnished Undermine Real"] = "黯淡的底域铸币";

L["Dungeon weeklies remaining"] = "剩余地下城周常";

L["Currency"] = "货币";
L["Currencies"] = "货币";

L["instanceStatsOutputCurrencyTitle"] = "货币";
L["instanceStatsOutputCurrencyDesc"] = "显示在地下城中获得了哪些货币？";

L["lootReminderDesc"] = "拾取提醒";

L["lootReminderRealTitle"] = "黯淡的底域铸币";
L["lootReminderRealDesc"] = "在SoD中，当可能掉落它的首领死亡时，显示拾取黯淡的底域铸币的提醒。";

L["lootReminderSizeTitle"] = "文本大小";
L["lootReminderSizeDesc"] = "在提醒上显示的文本大小。";

L["lootReminderXTitle"] = "X位置";
L["lootReminderXDesc"] = "调整此值以设置提醒文本的左右位置。";

L["lootReminderYTitle"] = "Y位置";
L["lootReminderYDesc"] = "调整此值以设置提醒文本的上下位置。";

L["Looted"] = "已拾取";
L["Not Looted"] = "未拾取";
L["Killed But Not Looted"] = "已击杀但未拾取";
L["Loot the Tarnished Undermine Real"] = "拾取黯淡的底域铸币";
L["Not Killed"] = "未击杀";
L["Loot Reminder List"] = "拾取提醒列表";
L["Check your daily reals status"] = "检查你的每日铸币状态";
L["Bosses Looted"] = "首领已拾取";
L["Total today"] = "今日总计";
L["Total Reals"] = "铸币总计";

L["Reminder"] = "提醒";
L["missingArgentDawnTrinket"] = "%s 饰品提醒 %s 未装备。" --Argent Dawn trinket reminder [Rune of the Dawn] isn't equipped.

L["argentDawnTrinketReminderTitle"] = "银色黎明饰品提醒";
L["argentDawnTrinketReminderDesc"] = "如果您进入通灵学院/斯坦索姆时背包中有饰品但声望未崇拜，则在聊天中显示银色黎明饰品提醒。";

L["skipRealMsgIfCappedTitle"] = "达到上限时不显示信息";
L["skipRealMsgIfCappedDesc"] = "如果我们已达到150个代币上限，则跳过黯淡的底域铸币拾取信息。";

L["Live Side"] = "生者区";
L["Undead Side"] = "亡灵区";
L["East"] = "东";
L["West"] = "西";
L["North"] = "北";
L["Upper"] = "上";
L["Lower"] = "下";

L["lootTheItem"] = "拾取 %s"; --Example: Loot the Tarnished Undermine Real
L["Qiraji Lord's Insignia"] = "其拉领主徽记";

L["soundsLootReminderTitle"] = "拾取提醒音效";
L["soundsLootReminderDesc"] = "选择显示拾取提醒时播放的音效。";

L["lootReminderMysRelicTitle"] = "神秘圣物提醒";
L["lootReminderMysRelicDesc"] = "当有人在卡拉赞地下墓穴中拾取一个神秘圣物时，在屏幕中间/聊天窗口显示信息。";

L["lootReminderMysRelicPartyTitle"] = "神秘圣物队伍信息";
L["lootReminderMysRelicPartyDesc"] = "当有人在卡拉赞地下墓穴中拾取一个神秘圣物时，在队伍聊天中发送一条信息。";

L["Remnants of Valor"] = "英勇残余";

L["autoTwilightBuffReminder"] = "从 %s 获取暮光地下城增益。";

L["douseDisclaimer"] = "注意：此灭火模块基于\n上次击杀的首领和其他因素进行最佳猜测，可能不准确。";
L["Not Doused"] = "未熄灭";
L["Doused"] = "已熄灭";
L["Aqual Quintessence"] = "水之精萃";

L["Magmadar"] = "玛格曼达";
L["Gehennas"] = "基赫纳斯";
L["Garr"] = "加尔";
L["Baron Geddon"] = "迦顿男爵";
L["Shazzrah"] = "沙斯拉尔";
L["Sulfuron Harbinger"] = "萨弗隆先驱者";
L["Golemagg the Incinerator"] = "焚化者古雷曼格";

L["of level"] = "的进度"; --This for XP display during a dung (23.4% of level)

L["World Boss"] = "World Boss";

L["autoCelestialBuffReminder"] = "Get Celestial Dungeon buff from %s.";
L["NPC"] = "NPC";

L["by"] = "by";
L["For help or suggestions"] = "For help or suggestions";
end
FT.embedded.NovaInstanceTracker:Add("NovaInstanceTracker", Component, "NovaInstanceTracker/Locale/zhCN.lua")
