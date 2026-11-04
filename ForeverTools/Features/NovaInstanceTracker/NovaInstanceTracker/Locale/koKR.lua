-- Local adaptation; see ../NOTICE.txt.
local _, FT = ...
local function Component(...)
local L = LibStub("AceLocale-3.0"):NewLocale("FTNovaInstanceTracker", "koKR");
if (not L) then
    return;
end
 
L["noTimer"] = "기록 없음"; --No timer
L["noCurrentTimer"] = "현재 기록 없음"; --No current timer
L["noActiveTimers"] = "활성화된 기록 없음"; --No active timers
L["second"] = "초"; --Second (singular).
L["seconds"] = "초"; --Seconds (plural).
L["minute"] = "분"; --Minute (singular).
L["minutes"] = "분"; --Minutes (plural).
L["hour"] = "시간"; --Hour (singular).
L["hours"] = "시간"; --Hours (plural).
L["day"] = "일"; --Day (singular).
L["days"] = "일"; --Days (plural).
L["secondMedium"] = "초"; --Second (singular).
L["secondsMedium"] = "초"; --Seconds (plural).
L["minuteMedium"] = "분"; --Minute (singular).
L["minutesMedium"] = "분"; --Minutes (plural).
L["hourMedium"] = "시간"; --Hour (singular).
L["hoursMedium"] = "시간"; --Hours (plural).
L["dayMedium"] = "일"; --Day (singular).
L["daysMedium"] = "일"; --Days (plural).
L["secondShort"] = "초"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "분"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "시간"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "일"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "%s 이후 개최"; --"Starts in 1hour".
L["endsIn"] = "%s 이후 종료"; --"Ends in 1hour".
L["versionOutOfDate"] = "Nova Instance Tracker 애드온을 트위치나 URL을 통해 업데이트 해주세요. https://www.curseforge.com/wow/addons/nova-instance-tracker";
L["Options"] = "설정";
L["Reset Data"] = "데이터 초기화"; --A button to Reset data.

L["Error"] = "에러";
L["delete"] = "삭제";
L["confirmInstanceDeletion"] = "인스턴스 삭제 확인";
L["confirmCharacterDeletion"] = "캐릭터 삭제 확인";

-------------
---Config---
-------------
--There are 2 types of strings here, the names end in Title or Desc L["exampleTitle"] and L["exampleDesc"].
--Title must not be any longer than 21 characters (maybe less for chinese characters because they are larger).
--Desc can be any length.

---General Options---
L["generalHeaderDesc"] = "일반 옵션";

L["chatColorTitle"] = "채팅 메세지 색상";
L["chatColorDesc"] = "채팅 메세지 색상을 설정합니다";

L["resetColorsTitle"] = "색상 초기화";
L["resetColorsDesc"] = "색상을 기본값으로 재설정 합니다.";

L["timeStampFormatTitle"] = "시간 포맷 형식";
L["timeStampFormatDesc"] = "12시간 (1:23pm) 또는 24시간 (13:23) 시간 포맷을 설정 합니다.";

L["timeStampZoneTitle"] = "로컬 시간 / 서버 시간";
L["timeStampZoneDesc"] = "로컬 시간(내 컴퓨터 시간) 또는 서버 시간을 표시할까요?";

L["minimapButtonTitle"] = "미니맵 버튼 표시";
L["minimapButtonDesc"] = "NIT 미니맵 버튼을 표시할까요?";

---Sounds---
L["soundsHeaderDesc"] = "소리";

L["soundsTextDesc"] = "비활성화하려면 소리를 \"없음\" 으로 설정하십시오.";

L["disableAllSoundsTitle"] = "모든 소리 비활성화";
L["disableAllSoundsDesc"] = "이 애드온의 모든 소리 비활성화합니다.";

L["extraSoundOptionsTitle"] = "추가 사운드 옵션";
L["extraSoundOptionsDesc"] = "여기의 목록에 모든 애드온의 모든 사운드를 한 번에 표시하려면 이 옵션을 활성화하세요.";

L["notesHeaderDesc"] = "알림 사항:";
L["notesDesc"] = "이 애드온은 더 많은 인스턴스를 입장할 수 있을 때 해치우는 것이 가장 좋지만 블리자드의 잠금 시스템은 때때로 버그가 있으며 올바른 인스 제한에 도달하기 전에 잠길 수 있습니다. 시간당 4개만 입장하는 경우도 있지만, 시간당 6개 입장하는 경우도 있습니다.";

L["logHeaderDesc"] = "로그 창";

L["openInstanceLogFrameTitle"] = "인스턴스 로그 열기";

L["logSizeTitle"] = "로그에 표시할 인스턴스 갯수";
L["logSizeDesc"] = "로그에 몇 개의 인스턴스를 표시하시겠습니까? 최대 300개까지 저장되며 100개가 기본으로 표시됩니다(/NIT로 로그를 열 수 있음).";

L["enteredMsgTitle"] = "던전 입장시 메시지";
L["enteredMsgDesc"] = "5인 던전에 입장하면 메인 채팅 창에 메시지를 출력하며, 새로 생성된 인스턴스를 데이터베이스에서 삭제할 수 있도록 X 아이콘을 함께 표시합니다";

L["raidEnteredMsgTitle"] = "공격대 입장시 메시지";
L["raidEnteredMsgDesc"] = "레이드에 입장하면 메인 채팅 창에 메시지가 출력되며, 원할 경우 X 아이콘을 클릭해 새로 생성된 인스턴스를 데이터베이스에서 삭제할 수 있습니다.";

L["pvpEnteredMsgTitle"] = "PvP 입장시 메시지";
L["pvpEnteredMsgDesc"] = "PvP 인스턴스 입장 시 메인 채팅 창에 안내 메시지와 함께, 새 인스턴스를 데이터베이스에서 삭제할 수 있는 X 아이콘이 표시됩니다";

L["noRaidInstanceMergeMsgTitle"] = "병합된 공격대 숨기기";
L["noRaidInstanceMergeMsgDesc"] = "레이드 진입 시 인스턴스 병합 메시지 숨기기 및 동일한 아이디 감지.";
			
L["instanceResetMsgTitle"] = "그룹 인스턴스 초기화";
L["instanceResetMsgDesc"] = "당신이 그룹 리더인 경우 성공적으로 초기화 된 인스턴스를 파티 또는 공격대에 메시지를 표시합니다. 예: \"통곡의 동굴이 초기화되었습니다.\"";

L["showMoneyTradedChatTitle"] = "거래된 골드 기록 표시";
L["showMoneyTradedChatDesc"] = "누군가에게 골드를 주고받을 때 거래 기록에 표시하시겠습니까? (그룹에서 골드를 지불하거나 받은 사람을 파악하는 데 도움이 됩니다.).";

L["instanceStatsHeaderDesc"] = "던전 통계 출력";

L["instanceStatsTextDesc"] = "던전을 나갈 때 그룹 채팅이나 채팅 창에 표시할 통계를 선택하세요.";

L["instanceStatsOutputTitle"] = "상태 표시";
L["instanceStatsOutputDesc"] = "던전에서 나갈 때 채팅으로 통계를 표시할까요?";
			
L["instanceStatsOutputWhereTitle"] = "통계 표시 위치";
L["instanceStatsOutputWhereDesc"] = "통계를 표시할 채팅창의 위치를 설정해주세요.";

L["instanceStatsOutputMobCountTitle"] = "몹 수 표시";
L["instanceStatsOutputMobCountDesc"] = "던전 안에 있는 동안 잡은 몹 숫자를 표시할까요?";

L["instanceStatsOutputXPTitle"] = "경험치 표시";
L["instanceStatsOutputXPDesc"] = "던전에서 얻은 경험치를 표시할까요?";

L["instanceStatsOutputAverageXPTitle"] = "평균 경험치 표시";
L["instanceStatsOutputAverageXPDesc"] = "던전에서 킬당 평균 경험치를 표시할까요?";

L["instanceStatsOutputTimeTitle"] = "시간 표시";
L["instanceStatsOutputTimeDesc"] = "던전에서 보낸 시간을 표시할까요?";

L["instanceStatsOutputGoldTitle"] = "순수 골드 표시";
L["instanceStatsOutputGoldDesc"] = "던전에서 잡은 몹으로 부터 얻은 골드를 표시할까요?";

L["instanceStatsOutputAverageGroupLevelDesc"] = "평균 레벨 표시";
L["instanceStatsOutputAverageGroupLevelTitle"] = "던전 내 그룹 평균 레벨을 표시할까요?";

L["showAltsLogTitle"] = "Alts 표시";
L["showAltsLogDesc"] = "인스턴스 로그에 Alts를 표시할까요?";

L["timeStringTypeTitle"] = "시간 표기 형식";
L["timeStringTypeDesc"] = "인스턴스 로그에 사용할 시간 문자열 형식은 무엇인가요?\n|cFFFFFF00Long:|r 1 minute 30 seconds\n|cFFFFFF00Medium|r: 1 min 30 secs\n|cFFFFFF00Short|r 1m30s";

L["showLockoutTimeTitle"] = "잠금 시간 표시";
L["showLockoutTimeDesc"] = "체크 시 최근 24시간 이내 인스턴스의 남은 락아웃 시간이 표시되며, 해제 시 구버전처럼 입장 시간이 표시됩니다.";

L["colorsHeaderDesc"] = "색상"

L["mergeColorTitle"] = "인스턴스 색상 합치기";
L["mergeColorDesc"] = "마지막으로 기록된 인스턴스와 동일한 인스턴스가 감지되어 데이터가 병합될 때, 채팅에 표시되는 메시지는 어떤 색상으로 해야 하나요?";

L["detectSameInstanceTitle"] = "동일한 인스턴스 감지";
L["detectSameInstanceDesc"] = "같은 인스턴스에 다시 입장했을 때 애드온이 이를 자동으로 감지하여, 두 개의 별도 인스턴스로 계산하지 않도록 할까요?";

L["showStatsInRaidTitle"] = "공격대 통계 표시";
L["showStatsInRaidDesc"] = "레이드 중에도 통계를 표시할까요? 이 옵션을 비활성화하면 5인 파티에 있을 때만 파티 채팅으로 통계가 표시됩니다. (이 옵션은 통계 출력이 그룹 채팅으로 설정되어 있을 때만 적용됩니다.).";

L["printRaidInsteadTitle"] = "공격대 중 출력";
L["printRaidInsteadDesc"] = "레이드 채팅으로 통계를 전송하지 않도록 설정한 경우, 대신 메인 채팅 창에 통계를 출력하여 본인도 확인할 수 있도록 합니다.";

L["statsOnlyWhenActivityTitle"] = "활동 시에만";
L["statsOnlyWhenActivityDesc"] = "던전 안에서 어떤 활동이 발생했을 때만 통계를 표시할까요? 즉, 몬스터를 처치했거나 경험치를 획득했거나 골드를 획득하는 등의 활동이 있을 경우에만 표시됩니다. 이렇게 하면 내용이 없는(빈) 통계가 표시되지 않습니다.";

L["show24HourOnlyTitle"] = "지난 24시간만 표시";
L["show24HourOnlyDesc"] = "인스턴스 로그에 지난 24시간 동안의 인스턴스만 표시하시겠습니까?";

L["trimDataHeaderDesc"] = "데이터 청소하기";

L["trimDataBelowLevelTitle"] = "제거할 최대 레벨";
L["trimDataBelowLevelDesc"] = "데이터베이스에서 제거할 최대 캐릭터 레벨을 선택하십시오. 이 레벨 이하의 모든 캐릭터는 삭제됩니다.";

L["trimDataBelowLevelButtonTitle"] = "캐릭터 삭제";
L["trimDataBelowLevelButtonDesc"] = "이 애드온 데이터베이스에서 선택한 레벨 이하의 모든 캐릭터를 제거하려면 이 버튼을 클릭하세요.";

L["trimDataTextDesc"] = "데이터베이스에서 여러 캐릭터 제거:";
L["trimDataText2Desc"] = "데이터베이스에서 한 캐릭터 제거:";

L["trimDataCharInputTitle"] = "하나의 캐릭터 입력 제거";
L["trimDataCharInputDesc"] = "제거할 문자를 여기에 입력하고 이름 영역(대소문자 구분)으로 형식을 지정합니다. 참고: 버프 카운트 데이터를 영구적으로 제거합니다.";

L["trimDataBelowLevelButtonConfirm"] = "데이터베이스에서 레벨 %s 아래의 모든 캐릭터를 제거하시겠습니까?";
L["trimDataCharInputConfirm"] = "데이터베이스에서 이 캐릭터 %s을(를) 제거하시겠습니까?";

L["trimDataMsg2"] = "%s 레벨 아래의 모든 캐릭터 제거.";
L["trimDataMsg3"] = "제거됨: %s.";
L["trimDataMsg4"] = "완료, 캐릭터가 없습니다.";
L["trimDataMsg5"] = "완료, 제거된 %s 캐릭터.";
L["trimDataMsg6"] = "데이터베이스에서 삭제할 유효한 캐릭터 이름을 입력하십시오.";
L["trimDataMsg7"] = "이 캐릭터 이름 %s에는 영역에 포함되어 있지 않습니다, 이름-영역을 입력하세요.";
L["trimDataMsg8"] = "데이터베이스에서 %s을(를) 제거하는 동안 오류가 발생했습니다. 캐릭터를 찾을 수 없습니다(이름은 대소문자를 구분합니다.).";
L["trimDataMsg9"] = "데이터베이스에서 %s을(를) 제거했습니다.";

L["instanceFrameSelectAltMsg"] = "‘모든 부캐 표시(Show All Alts)’가 꺼져 있을 경우 표시할 부캐를 선택합니다. 또는 ‘모든 부캐 표시’가 켜져 있을 경우, 색상을 적용할 부캐를 선택합니다.";

L["enteredDungeon"] = "새로운 인스턴스 %s %s, 클릭";
L["enteredDungeon2"] = "새로운 인스턴스가 아닌 경우.";
L["enteredRaid"] = "새로운 인스턴스 %s, 이 공격대는 묶인 횟수에 포함되지 않습니다.";
L["loggedInDungeon"] = "%s %s 안에서 로그인했습니다. 새 인스턴스가 아니라면 클릭하세요";
L["loggedInDungeon2"] = "이 인스턴스를 데이터베이스에서 삭제하려면 클릭하세요..";
L["reloadDungeon"] = "UI 리로드가 감지되었습니다(%s). 새 인스턴스를 생성하는 대신 마지막 인스턴스 데이터를 불러옵니다.";
L["thisHour"] = "지금 시간";
L["statsError"] = "인스턴스 ID %s 에 대한 통계를 찾는 동안 오류가 발생했습니다.";
L["statsMobs"] = "몹:";
L["statsXP"] = "XP:";
L["statsAverageXP"] = "평균 XP/몹:";
L["statsRunsPerLevel"] = "레벨당 진행 횟수:";
L["statsRunsNextLevel"] = "다음 레벨까지 남은 진행 횟수:";
L["statsTime"] = "시간:";
L["statsAverageGroupLevel"] = "평균 그룹 레벨:";
L["statsGold"] = "골드";
L["sameInstance"] = "마지막으로 감지된 인스턴스와 동일한 인스턴스 ID가 확인되었습니다(%s). 데이터베이스 항목을 병합합니다.";
L["deleteInstance"] = "데이터베이스에서 인스턴스 [%s] %s (%s 전)을(를) 삭제했습니다.";
L["deleteInstanceError"] = "%s 삭제 중 오류가 발생했습니다.";
L["countString"] = "지난 1시간 동안 %s개의 인스턴스에 입장했으며, 지난 24시간 동안은 %s개에 입장했습니다.";
L["countStringColorized"] = "지난 1시간 동안 %s %s %s 인스턴스에 입장했으며, 지난 24시간 동안은 %s %s %s에 입장했습니다.";
L["now"] = "현재";
L["in"] = "in";
L["active24"] = "24시간 잠김 활성화";
L["nextInstanceAvailable"] = "다음 인스턴스 사용 가능";
L["gave"] = "보냄";
L["received"] = "받음";
L["to"] = "to";
L["from"] = "from";
L["playersStillInside"] = "리셋 됨 (오래된 인스턴스 안에 있는 플레이어는 영역을 벗어나 새롭게 들어갈 수 있음).";
L["Gold"] = "골드";
L["gold"] = "골드";
L["silver"] = "실버";
L["copper"] = "코퍼";
L["newInstanceNow"] = "지금 새로운 인스턴스에 입장할 수 있습니다";
L["thisHour"] = "현재 1시간";
L["thisHour24"] = "현재 24시간";
L["openInstanceFrame"] = "인스턴스 프레임 열기";
L["openYourChars"] = "내 캐릭터 열기";
L["openTradeLog"] = "거래 기록 열기";
L["config"] = "설정";
L["thisChar"] = "이 캐릭터";
L["yourChars"] = "나의 캐릭터";
L["instancesPastHour"] = "지난 1시간 내 인스턴스.";
L["instancesPastHour24"] = "지난 24시간 내 인스턴스.";
L["leftOnLockout"] = "잠김중";
L["tradeLog"] = "거래 기록";
L["pastHour"] = "지난 1시간";
L["pastHour24"] = "지난 24시간";
L["older"] = "오래됨";
L["raid"] = "공격대";
L["alts"] = "Alts";
L["deleteEntry"] = "항목 삭제";
L["lastHour"] = "1시간 이내";
L["lastHour24"] = "24시간 이내";
L["entered"] = "입장";
L["ago"] = "이전";
L["stillInDungeon"] = "아직 던전 내부";
L["leftOnLockout"] = "잠김중";
L["leftOnDailyLockout"] = "일일 잠금 상태로 남아 있음";
L["noLockout"] = "이 공격대의 잠금 없음";
L["unknown"] = "알 수 없음";
L["instance"] = "인스턴스";
L["timeEntered"] = "입장 시간";
L["timeLeft"] = "퇴장 시간";
L["timeInside"] = "머무른 시간";
L["mobCount"] = "몹 수";
L["experience"] = "경험치";
L["experienceShort"] = "XP";
L["rawGoldMobs"] = "순수 몹 골드";
L["enteredLevel"] = "입장 레벨";
L["leftLevel"] = "퇴장 레벨";
L["averageGroupLevel"] = "그룹 평균 레벨";
L["currentLockouts"] = "현재 잠김";
L["repGains"] = "획득 평판";
L["groupMembers"] = "그룹 구성원";
L["tradesWhileInside"] = "안에 있는 동안 거래";
L["noDataInstance"] = "이 인스턴스에 데이터가 없습니다.";
L["restedOnlyText"] = "휴식중만 표시";
L["restedOnlyTextTooltip"] = "휴식 경험치가 있는 캐릭터만 표시할까요? 이 옵션을 해제하면 최대 레벨 캐릭터와 휴식 경험치가 없는 부캐를 포함해 모든 부캐가 표시됩니다.";
L["deleteEntry"] = "항목 삭제"; --Example: "Delete entry 5";
L["online"] = "온라인";
L["maximum"] = "최대";
L["level"] = "레벨";
L["rested"] = "휴식";
L["realmGold"] = "서버 골드:";
L["total"] = "총";
L["guild"] = "길드";
L["resting"] = "휴식중";
L["notResting"] = "휴식 없음";
L["rested"] = "휴식";
L["restedBubbles"] = "휴식 거품";
L["restedState"] = "휴식 상태";
L["bagSlots"] = "가방 슬롯";
L["durability"] = "내구도";
L["items"] = "아이템";
L["ammunition"] = "탄약";
L["petStatus"] = "펫 상태";
L["name"] = "이름";
L["family"] = "Family";
L["happiness"] = "행복도";
L["loyaltyRate"] = "충성도";
L["petExperience"] = "펫 XP";
L["unspentTrainingPoints"] = "사용하지 않은 훈련 포인트";
L["professions"] = "직업";
L["lastSeenPetDetails"] = "마지막으로 본 펫 정보";
L["currentPet"] = "현재 펫";
L["noPetSummoned"] = "소환된 펫 없음";
L["lastSeenPetDetails"] = "마지막으로 본 펫 정보";
L["noProfessions"] = "직업을 찾을 수 없습니다.";
L["cooldowns"] = "재사용 대기시간";
L["left"] = "남은"; -- This is left as in "time left";
L["ready"] = "준비.";
L["pvp"] = "PvP";
L["rank"] = "랭크";
L["lastWeek"] = "지난 주";
L["attunements"] = "입장 조건";
L["currentRaidLockouts"] = "현재 공격대 잠김";
L["none"] = "없음.";

L["instanceStatsOutputRunsPerLevelTitle"] = "레벨당 횟수";
L["instanceStatsOutputRunsPerLevelDesc"] = "레벨당 몇 번 돌아야되는지 표시할까요?";

L["instanceStatsOutputRunsNextLevelTitle"] = "다음 레벨까지 횟수";
L["instanceStatsOutputRunsNextLevelDesc"] = "다음 레벨까지 몇 번 더 돌아야되는지 표시할까요?";

L["instanceWindowWidthTitle"] = "인스턴스 창 너비";
L["instanceWindowWidthDesc"] = "인스턴스 창 너비 설정.";

L["instanceWindowHeightTitle"] = "인스턴스 창 높이";
L["instanceWindowHeightDesc"] = "인스턴스 창 높이 설정.";

L["charsWindowWidthTitle"] = "캐릭터 창 너비";
L["charsWindowWidthDesc"] = "캐릭터 창 너비 설정.";

L["charsWindowHeightTitle"] = "캐릭터 창 높이";
L["charsWindowHeightDesc"] = "캐릭터 창 높이 설정.";

L["tradeWindowWidthTitle"] = "거래 기록 창 너비";
L["tradeWindowWidthDesc"] = "거래 기록 창 너비 설정.";

L["tradeWindowHeightTitle"] = "거래 기록 창 높이";
L["tradeWindowHeightDesc"] = "거래 기록 창 높이 설정.";

L["resetFramesTitle"] = "창 초기화";
L["resetFramesDesc"] = "모든 창을 화면 중앙으로 재설정하고 크기를 기본값으로 되돌립니다.";

L["resetFramesMsg"] = "모든 창 위치 및 크기 재설정.";

L["statsRep"] = "평판:";

L["instanceStatsOutputRepTitle"] = "평판 획득";
L["instanceStatsOutputRepDesc"] = "던전 안에서 얻은 평판을 표시할까요?";

L["experiencePerHour"] = "XP/시간당";

L["instanceStatsOutputXpPerHourTitle"] = "XP/시간당 표시";
L["instanceStatsOutputXpPerHourDesc"] = "던전 안에서 얻은 시간당 경험치를 표시할까요?";

L["autoDialogueDesc"] = "자동 NPC 대화";

L["autoSlavePensTitle"] = "자동 노예 수용소";
L["autoSlavePensDesc"] = "노예 수용소 마지막 우리 안의 NPC와 자동 대화?";

L["autoCavernsFlightTitle"] = "시간의 동굴 자동 비행";
L["autoCavernsFlightDesc"] = "시간의 동굴 소환석 근처에 있는 용과 자동으로 대화하여 아래로 비행합니다. (‘주인의 둥지로(To The Master’s Lair)’ 퀘스트를 완료한 경우에만 적용됩니다.)";

L["autoBlackMorassTitle"] = "검은 늪 자동 진행";
L["autoBlackMorassDesc"] = "검은 늪(Black Morass) 시작 지점의 NPC와 자동으로 대화하여 신호기(비콘)를 받습니다. (‘혈족의 영웅(Hero of the Brood)’ 퀘스트를 완료한 경우에만 적용됩니다.)";

L["autoSfkDoorTitle"] = "그림자송곳니 문 자동 열기";
L["autoSfkDoorDesc"] = "그림자송곳니 성채 문 여는 NPC와 자동 대화";

L["honorGains"] = "명예 획득";
L["Honor"] = "명예";
L["Won"] = "승리";
L["Lost"] = "패배";
L["Arena"] = "투기장";
L["Arena Points"] = "투기장 포인트";

L["stillInArena"] = "아직 진행중";
L["stillInBattleground"] = "아직 진행중";

L["resetAllInstancesConfirm"] = "로그에서 모든 인스턴스 데이터를 삭제하시겠습니까?";
L["All Instance log data has been deleted."] = "모든 인스턴스 로그 데이터가 삭제되었습니다.";

L["resetAllInstancesTitle"] = "인스턴스 데이터 초기화";
L["resetAllInstancesDesc"] = "모든 인스턴스 데이터가 초기화되고 로그에서 모든 것이 제거됩니다. 거래 기록을 초기화하지 않습니다.";

L["autoCavernsArthasTitle"] = "Auto CoS Arthas";
L["autoCavernsArthasDesc"] = "Auto dialogue owith arthas in the Culling of Strathholme in Wrath.";

L["Mythic Plus"] = "Mythic Plus";
L["mythicPlusShort"] = "Mythic+";

L["noCurrentRaidLockouts"] = "No current raid lockouts.";

L["weeklyQuests"] = "Weekly Quests";
L["dailyQuests"] = "Daily Quests";
L["monthlyQuests"] = "Monthly Quests";

L["openLockouts"] = "Open Lockouts";

L["autoGammaBuffDesc"] = "Gamma/Twilight Dungeons";

L["autoGammaBuffTitle"] = "Auto Gamma Buff";
L["autoGammaBuffDesc"] = "Auto get the right gamma buff for your class when you talk to the buff NPC in a Gamma Dungeon.";

L["autoGammaBuffReminderTitle"] = "Gamma Buff Reminder";
L["autoGammaBuffReminderDesc"] = "Print a msg to chat at the start of the dung remimding you to get the buff if you don't have it.";

L["autoGammaBuffTypeTitle"] = "Gamma Buff Type";
L["autoGammaBuffTypeDesc"] = "What buff type fo you want, Auto Select will auto choose between melee/ranged/healer/tank based off your spec. Or you can override it with a different selection. Buff selection is a character specific config option.";

L["dungeonPopTimerTitle"] = "Dungeon Pop Timer";
L["dungeonPopTimerDesc"] = "Show a timer on the dungeon queue pop window that shows how long left to click enter?";

L["autoWrathDailiesTitle"] = "Auto Get Daily Quests";
L["autoWrathDailiesDesc"] = "Auto get and hand in wrath daily quests from Archmage Lan'dalock in Dalaran";
			
L["gammaConfigWarning"] = "Gamma buff choice is character specific, if you change it on this character it won't effect your other characters.";
L["autoGammaBuffReminder"] = "Get Gamma Dungeon buff from %s.";
L["Sunreaver Warden"] = "Sunreaver Warden";
L["Silver Covenant Warden"] = "Silver Covenant Warden";
L["note"] = "Note:";
L["Click an entry to post stats."] = "Click an entry to post stats.";
L["Show Alts"] = "Show Alts";
L["showAltsTooltip"] = "Show all alts in the instance log? (Lockouts are per character)";
L["PvE"] = "PvE"; --Must be 3 letters max to fit. (PvP already exists further up)
L["Hold to drag"] = "Hold to drag";
L["Raid Lockouts (Including Alts)"] = "Raid Lockouts (Including Alts)";
L["No trade logs found."] = "No trade logs found.";
L["Today"] = "Today";
L["Yesterday"] = "Yesterday";

L["Level Log"] = "Level Log";
L["Mouseover log entry for more info"] = "Mouseover log entry for more info";
L["Current Level"] = "Current Level";
L["Leveling history for"] = "Leveling history for";
L["Unknown Time"] = "Unknown Time";
L["Unknown Zone"] = "Unknown Zone";
L["Zone"] = "Zone";
L["SubZone"] = "SubZone";
L["Ding"] = "Ding"; --Level up.
L["Map coords"] = "Map coords";
L["Gold owned at start of level"] = "Gold owned at start of level";
L["Gold change during this level"] = "Gold change during this level";
L["Quests completed during this level"] = "Quests completed during this level";
L["Mobs that gave exp during this level"] = "Mobs that gave exp during this level";
L["Played time this level"] = "Played time this level";
L["Total Played"] = "Total Played";
L["firstTimeSeeingCharPlayed"] = "First time seeing this character was at this level, played time for this level is likely wrong.";

L["Left-Click"] = "Left-Click";
L["Right-Click"] = "Right-Click";
L["Shift Left-Click"] = "Shift Left-Click";
L["Shift Right-Click"] = "Shift Right-Click";
L["Middle-Click"] = "Middle-Click";
L["Control Left-Click"] = "Ctrl Left-Click";

L["Lockouts"] = "Lockouts";
L["Instance"] = "Instance";
L["ZoneID"] = "ZoneID";
L["Show dungeons and raids?"] = "Show dungeons and raids?";
L["Show battleground and arena instances?"] = "Show battleground and arena instances?";
L["Party"] = "Party";
L["Guild"] = "Guild";
L["Copy Paste"] = "Copy Paste";
L["Print"] = "Print";
L["Post Stats for log"] = "Post Stats for log";
L["Alts (Mouseover names for info)"] = "Alts (Mouseover names for info)";
L["Min Level"] = "Min Level";
L["No guild"] = "No guild";
L["No guild rank"] = "No guild rank";
L["Show leveling history for"] = "Show leveling history for";
L["Test Instance"] = "Test Instance";
L["Long"] = "Long";
L["Medium"] = "Medium";
L["Short"] = "Short";
L["Chat Window"] = "Chat Window";
L["Group Chat (Party/Raid)"] = "Group Chat (Party/Raid)";
L["12 hour"] = "12 hour";
L["24 hour"] = "24 hour";

L["Molten Core"] = "Molten Core";
L["Onyxia's Lair"] = "Onyxia's Lair";
L["Blackwing Lair"] = "Blackwing Lair";
L["Naxxramas"] = "Naxxramas";
L["Karazhan"] = "Karazhan";
L["The Shattered Halls"] = "The Shattered Halls";
L["Serpentshrine Cavern"] = "Serpentshrine Cavern";
L["The Arcatraz"] = "The Arcatraz";
L["Black Morass"] = "Black Morass";
L["Battle of Mount Hyjal"] = "Battle of Mount Hyjal";
L["Black Temple"] = "Black Temple";
L["Hellfire Citadel"] = "Hellfire Citadel";
L["Coilfang Reservoir"] = "Coilfang Reservoir";
L["Shadow Labyrinth"] = "Shadow Labyrinth";
L["Auchindoun"] = "Auchindoun";
L["Tempest Keep"] = "Tempest Keep";
L["Caverns of Time"] = "Caverns of Time";
L["deletedCharOnRealm"] = "Deleted character %s on realm [%s].";
L["deletedCharOnRealmNewInfo"] = "Deleted character %s on realm [%s], recording new info.";

L["Time"] = "Time";
L["Show time?"] = "Show time?";
L["Show Zone where trade happened?"] = "Show Zone where trade happened?";
L["Time Ago"] = "Time Ago";
L["Show how long ago?"] = "Show how long ago?";
L["Records"] = "Records";
L["How many trade records to show?"] = "How many trade records to show?";
L["Current Hour Lockouts"] = "Current Hour Lockouts";
L["Current Dungeon Stats"] = "Current Dungeon Stats";
L["Log Entry"] = "Log Entry";
L["Local Time"] = "Local Time";
L["Server Time"] = "Server Time";
L["Example"] = "Example";

--Abbreviated days/months.
L["Mon"] = "Mon";
L["Tue"] = "Tue";
L["Wed"] = "Wed";
L["Thu"] = "Thu";
L["Fri"] = "Fri";
L["Sat"] = "Sat";
L["Sun"] = "Sun";

L["Jan"] = "Jan";
L["Feb"] = "Feb";
L["Mar"] = "Mar";
L["Apr"] = "Apr";
L["May"] = "May";
L["Jun"] = "Jun";
L["Jul"] = "Jul";
L["Aug"] = "Aug";
L["Sep"] = "Sep";
L["Oct"] = "Oct";
L["Nov"] = "Nov";
L["Dec"] = "Dec";

L["Blacksmithing"] = "대장기술";
L["Leatherworking"] = "가죽세공";
L["Alchemy"] = "연금술";
L["Herbalism"] = "약초채집";
L["Cooking"] = "요리";
L["Mining"] = "채광";
L["Tailoring"] = "재봉술";
L["Engineering"] = "기계공학";
L["Enchanting"] = "마법부여";
L["Fishing"] = "낚시";
L["Skinning"] = "무두질";
L["Jewelcrafting"] = "보석세공";
L["Inscription"] = "주문각인";
L["First Aid"] = "응급치료";

L["Wrath Cooking Daily"] = "Wrath Cooking Daily";
L["Wrath Fishing Daily"] = "Wrath Fishing Daily";
L["Wrath Jewelcrafting Daily"] = "Wrath Jewelcrafting Daily";
L["Cata Cooking Daily"] = "Cata Cooking Daily";
L["Cata Fishing Daily"] = "Cata Fishing Daily";
L["Cata Jewelcrafting Daily"] = "Cata Jewelcrafting Daily";

L["Tarnished Undermine Real"] = "빛바랜 언더마인화";

L["Dungeon weeklies remaining"] = "Dungeon weeklies remaining";

L["Currency"] = "Currency";
L["Currencies"] = "Currencies";

L["instanceStatsOutputCurrencyTitle"] = "Currency";
L["instanceStatsOutputCurrencyDesc"] = "Show what currencies were gained while inside a dungeon?";

L["lootReminderDesc"] = "Loot Reminders";

L["lootReminderRealTitle"] = "Tarnished Undermine Real";
L["lootReminderRealDesc"] = "Show a reminder to loot Tarnished Undermine Real in SoD when a boss dies that can drop it.";

L["lootReminderSizeTitle"] = "Text Size";
L["lootReminderSizeDesc"] = "What size text to show on the reminder.";

L["lootReminderXTitle"] = "X Position";
L["lootReminderXDesc"] = "Adjust this for the left/right position of the reminder text.";

L["lootReminderYTitle"] = "Y Position";
L["lootReminderYDesc"] = "Adjust this for the up/down position of the reminder text.";

L["Looted"] = "Looted";
L["Not Looted"] = "Not Looted";
L["Killed But Not Looted"] = "Killed But Not Looted";
L["Loot the Tarnished Undermine Real"] = "Loot the Tarnished Undermine Real";
L["Not Killed"] = "Not Killed";
L["Loot Reminder List"] = "Loot Reminder List";
L["Check your daily reals status"] = "Check your daily reals status"; --This string can't be any longer characters than this to fit in button.
L["Bosses Looted"] = "Bosses Looted";
L["Total today"] = "Total today";
L["Total Reals"] = "Total Reals";

L["Reminder"] = "Reminder";
L["missingArgentDawnTrinket"] = "%s trinket reminder %s isn't equipped." --Argent Dawn trinket reminder [Rune of the Dawn] isn't equipped.

L["argentDawnTrinketReminderTitle"] = "Argent Dawn Trinket Reminder";
L["argentDawnTrinketReminderDesc"] = "Argent Dawn trinket reminder in chat if you enter Scholomance/Stratholme with the trinket in bags and not exalted.";

L["skipRealMsgIfCappedTitle"] = "No msg if capped";
L["skipRealMsgIfCappedDesc"] = "Skip the Tarnished Undermine Real loot msg if we're capped at 150 tokens already.";

L["Live Side"] = "Live Side";
L["Undead Side"] = "Undead Side";
L["East"] = "East";
L["West"] = "West";
L["North"] = "North";
L["Upper"] = "Upper";
L["Lower"] = "Lower";

L["lootTheItem"] = "Loot the %s"; --Example: Loot the Tarnished Undermine Real
L["Qiraji Lord's Insignia"] = "퀴라지 군주의 휘장";

L["soundsLootReminderTitle"] = "Loot Reminder Sound";
L["soundsLootReminderDesc"] = "Pick which sound to play when a loot reminder is displayed.";

L["lootReminderMysRelicTitle"] = "Mysterious Relics";
L["lootReminderMysRelicDesc"] = "Show middle of the screen/chat window msgs when someone loots a Mysterious Relic in Karazhan Crypts.";

L["lootReminderMysRelicPartyTitle"] = "Mys Relic Party Msg";
L["lootReminderMysRelicPartyDesc"] = "Do a party chat message when someone loots a Mysterious Relic in Karazhan Crypts.";

L["Remnants of Valor"] = "용맹의 잔재";

L["autoTwilightBuffReminder"] = "Get Twilight Dungeon buff from %s.";

L["douseDisclaimer"] = "Note: This douses module uses best guess based on\nlast boss killed and other factors, could be inaccurate.";
L["Not Doused"] = "Not Doused";
L["Doused"] = "Doused";
L["Aqual Quintessence"] = "Aqual Quintessence";

L["Magmadar"] = "Magmadar";
L["Gehennas"] = "Gehennas";
L["Garr"] = "Garr";
L["Baron Geddon"] = "Baron Geddon";
L["Shazzrah"] = "Shazzrah";
L["Sulfuron Harbinger"] = "Sulfuron Harbinger";
L["Golemagg the Incinerator"] = "Golemagg the Incinerator";

L["of level"] = "of level"; --This for XP display during a dung (23.4% of level)

L["World Boss"] = "World Boss";

L["autoCelestialBuffReminder"] = "Get Celestial Dungeon buff from %s.";
L["NPC"] = "NPC";

L["by"] = "by";
L["For help or suggestions"] = "For help or suggestions";
end
FT.embedded.NovaInstanceTracker:Add("NovaInstanceTracker", Component, "NovaInstanceTracker/Locale/koKR.lua")
