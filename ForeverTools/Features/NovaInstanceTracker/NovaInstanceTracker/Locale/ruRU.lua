-- Local adaptation; see ../NOTICE.txt.
local _, FT = ...
local function Component(...)
local L = LibStub("AceLocale-3.0"):NewLocale("FTNovaInstanceTracker", "ruRU");
if (not L) then
	return;
end

--Translator ZamestoTV
L["noTimer"] = "—"; --No timer (used only in map timer frames)
L["noCurrentTimer"] = "Таймер отсутствует"; --No current timer
L["noActiveTimers"] = "Таймер отсутствует";	--No active timers
L["second"] = "сек"; --Second (singular).
L["seconds"] = "сек"; --Seconds (plural).
L["minute"] = "мин"; --Minute (singular).
L["minutes"] = "мин"; --Minutes (plural).
L["hour"] = "ч"; --Hour (singular).
L["hours"] = "ч"; --Hours (plural).
L["day"] = "д"; --Day (singular).
L["days"] = "д"; --Days (plural).
L["secondMedium"] = "sec"; --Second (singular).
L["secondsMedium"] = "secs"; --Seconds (plural).
L["minuteMedium"] = "min"; --Minute (singular).
L["minutesMedium"] = "mins"; --Minutes (plural).
L["hourMedium"] = "hour"; --Hour (singular).
L["hoursMedium"] = "hours"; --Hours (plural).
L["dayMedium"] = "day"; --Day (singular).
L["daysMedium"] = "days"; --Days (plural).
L["secondShort"] = "с"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "м"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "ч"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "д"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "Начнется через %s"; --"Starts in 1hour".
L["endsIn"] = "Закончится через %s"; --"Ends in 1hour".
L["versionOutOfDate"] = "Ваша версия аддона Nova Instance Tracker устарела. Пожалуйста, обновите ее по ссылке https://www.curseforge.com/wow/addons/nova-instance-tracker или через Twitch-клиент";
L["Options"] = "Настройки";
L["Reset Data"] = "Reset Data"; --A button to Reset data.

L["Error"] = "Error";
L["delete"] = "Delete";
L["confirmInstanceDeletion"] = "Confirm Instance Deletion";
L["confirmCharacterDeletion"] = "Confirm Character Deletion";

-------------
---Config---
-------------
--There are 2 types of strings here, the names end in Title or Desc L["exampleTitle"] and L["exampleDesc"].
--Title must not be any longer than 21 characters (maybe less for chinese characters because they are larger).
--Desc can be any length.

---General Options---
L["generalHeaderDesc"] = "Общие настройки";

L["chatColorTitle"] = "Цвет сообщений в чате";
L["chatColorDesc"] = "Какой цвет должны иметь сообщения в чате?";

L["resetColorsTitle"] = "Сброс цветов";
L["resetColorsDesc"] = "Сбросить цвета на значения по умолчанию.";

L["timeStampFormatTitle"] = "Формат времени";
L["timeStampFormatDesc"] = "Выберите формат времени: 12-часовой (1:23pm) или 24-часовой (13:23).";

L["timeStampZoneTitle"] = "Местное/Серверное время";
L["timeStampZoneDesc"] = "Использовать местное или серверное время для временных меток?";

L["minimapButtonTitle"] = "Кнопка на миникарте";
L["minimapButtonDesc"] = "Показывать кнопку NIT на миникарте?";

---Sounds---
L["soundsHeaderDesc"] = "Звуки";

L["soundsTextDesc"] = "Установите звук на \"Нет\", чтобы отключить.";

L["disableAllSoundsTitle"] = "Отключить все звуки";
L["disableAllSoundsDesc"] = "Отключить все звуки этого аддона.";

L["extraSoundOptionsTitle"] = "Дополнительные звуки";
L["extraSoundOptionsDesc"] = "Включите, чтобы отобразить все звуки из всех ваших аддонов в выпадающих списках.";

L["notesHeaderDesc"] = "Некоторые заметки:";
L["notesDesc"] = "Этот аддон старается определить, когда вы можете войти в новые подземелья, но система блокировок Blizzard иногда работает с ошибками, и вы можете быть заблокированы до достижения правильного лимита. Иногда можно войти только в 4 подземелья за час, но иногда и в 6 за час.";

L["logHeaderDesc"] = "Окно лога";

L["openInstanceLogFrameTitle"] = "Открыть лог подземелий";

L["logSizeTitle"] = "Количество в логе";
L["logSizeDesc"] = "Сколько подземелий показывать в логе? Максимум хранится 300, по умолчанию показывается 100 (лог открывается командой /NIT).";

L["enteredMsgTitle"] = "Сообщение о входе";
L["enteredMsgDesc"] = "Выводит сообщение в основной чат при входе в подземелье на 5 человек с иконкой X для удаления подземелья из базы данных, если нужно.";

L["raidEnteredMsgTitle"] = "Сообщение о рейде";
L["raidEnteredMsgDesc"] = "Выводит сообщение в основной чат при входе в рейд с иконкой X для удаления рейда из базы данных, если нужно.";

L["pvpEnteredMsgTitle"] = "Сообщение о PvP";
L["pvpEnteredMsgDesc"] = "Выводит сообщение в основной чат при входе на Поле Боя с иконкой X для удаления Поля Боя из базы данных, если нужно.";

L["noRaidInstanceMergeMsgTitle"] = "Скрыть объединение";
L["noRaidInstanceMergeMsgDesc"] = "Скрыть сообщение об объединении подземелья при входе в рейд и обнаружении того же ID.";

L["instanceResetMsgTitle"] = "Сброс группы";
L["instanceResetMsgDesc"] = "Показывает сообщение группе или рейду, какие подземелья были успешно сброшены, если вы лидер группы. Пример: \"Пещеры Стенаний сброшены.\"";

L["showMoneyTradedChatTitle"] = "Золото в чате";
L["showMoneyTradedChatDesc"] = "Показывать в чате, когда вы даете или получаете золото от кого-то? (Помогает отслеживать, кому вы платили или от кого получили золото в группах для буста).";

L["instanceStatsHeaderDesc"] = "Статистика подземелий";

L["instanceStatsTextDesc"] = "Выберите, какие статистические данные отображать в групповом чате или в вашем чате при выходе из подземелья.";

L["instanceStatsOutputTitle"] = "Показать статистику";
L["instanceStatsOutputDesc"] = "Показывать статистику о подземелье при выходе?";

L["instanceStatsOutputWhereTitle"] = "Где показывать";
L["instanceStatsOutputWhereDesc"] = "Где показывать статистику: в вашем чате или в групповом чате?";

L["instanceStatsOutputMobCountTitle"] = "Количество мобов";
L["instanceStatsOutputMobCountDesc"] = "Показывать, сколько мобов было убито в подземелье?";

L["instanceStatsOutputXPTitle"] = "Показать опыт";
L["instanceStatsOutputXPDesc"] = "Показывать, сколько опыта было получено в подземелье?";

L["instanceStatsOutputAverageXPTitle"] = "Средний опыт";
L["instanceStatsOutputAverageXPDesc"] = "Показывать средний опыт за убийство в подземелье?";

L["instanceStatsOutputTimeTitle"] = "Показать время";
L["instanceStatsOutputTimeDesc"] = "Показывать, сколько времени вы провели в подземелье?";

L["instanceStatsOutputGoldTitle"] = "Показать золото";
L["instanceStatsOutputGoldDesc"] = "Показывать, сколько золота было собрано с мобов в подземелье?";

L["instanceStatsOutputAverageGroupLevelDesc"] = "Средний уровень";
L["instanceStatsOutputAverageGroupLevelTitle"] = "Показывать средний уровень группы в подземелье?";

L["showAltsLogTitle"] = "Показать альтов";
L["showAltsLogDesc"] = "Показывать альтов в логе подземелий?";

L["timeStringTypeTitle"] = "Формат времени";
L["timeStringTypeDesc"] = "Какой формат времени использовать в логе подземелий?\n|cFFFFFF00Длинный:|r 1 минута 30 секунд\n|cFFFFFF00Средний|r: 1 мин 30 сек\n|cFFFFFF00Короткий|r 1м30с";

L["showLockoutTimeTitle"] = "Время блокировки";
L["showLockoutTimeDesc"] = "Показывать оставшееся время блокировки в логе для подземелий за последние 24 часа; если отключено, будет показываться время входа, как в старых версиях.";

L["colorsHeaderDesc"] = "Цвета";

L["mergeColorTitle"] = "Цвет объединения";
L["mergeColorDesc"] = "Какой цвет использовать для сообщения в чате, когда обнаружено то же подземелье, что и предыдущее, и данные объединены?";

L["detectSameInstanceTitle"] = "Обнаружение подземелья";
L["detectSameInstanceDesc"] = "Автоматически определять повторный вход в то же подземелье, чтобы аддон не считал это за два разных подземелья?";

L["showStatsInRaidTitle"] = "Статистика в рейде";
L["showStatsInRaidDesc"] = "Показывать статистику в рейде? Отключите, чтобы показывать статистику только в группе на 5 человек (работает только при выборе группового чата для вывода статистики).";

L["printRaidInsteadTitle"] = "Печать в рейде";
L["printRaidInsteadDesc"] = "Если отключена отправка статистики в рейдовый чат, статистика будет выводиться в ваш чат, чтобы вы могли её видеть.";

L["statsOnlyWhenActivityTitle"] = "Только при активности";
L["statsOnlyWhenActivityDesc"] = "Показывать статистику только при наличии активности в подземелье? Это означает, что статистика будет показана только если были убиты мобы, получен опыт, собрано золото и т.д.";

L["show24HourOnlyTitle"] = "Только 24 часа";
L["show24HourOnlyDesc"] = "Показывать в логе только подземелья за последние 24 часа?";

L["trimDataHeaderDesc"] = "Очистка данных";

L["trimDataBelowLevelTitle"] = "Максимальный уровень";
L["trimDataBelowLevelDesc"] = "Выберите максимальный уровень персонажей для удаления из базы данных, все персонажи этого уровня и ниже будут удалены.";

L["trimDataBelowLevelButtonTitle"] = "Удалить персонажей";
L["trimDataBelowLevelButtonDesc"] = "Нажмите эту кнопку, чтобы удалить всех персонажей выбранного уровня и ниже из базы данных аддона.";

L["trimDataTextDesc"] = "Удалить несколько персонажей из базы данных:";
L["trimDataText2Desc"] = "Удалить одного персонажа из базы данных:";

L["trimDataCharInputTitle"] = "Удалить одного";
L["trimDataCharInputDesc"] = "Введите персонажа для удаления в формате Имя-Сервер (чувствительно к регистру). Примечание: это навсегда удаляет данные о счёте бафов.";

L["trimDataBelowLevelButtonConfirm"] = "Вы уверены, что хотите удалить всех персонажей ниже уровня %s из базы данных?";
L["trimDataCharInputConfirm"] = "Вы уверены, что хотите удалить персонажа %s из базы данных?";

L["trimDataMsg2"] = "Удаление всех персонажей ниже уровня %s.";
L["trimDataMsg3"] = "Удалено: %s.";
L["trimDataMsg4"] = "Готово, персонажи не найдены.";
L["trimDataMsg5"] = "Готово, удалено %s персонажей.";
L["trimDataMsg6"] = "Пожалуйста, введите действительное имя персонажа для удаления из базы данных.";
L["trimDataMsg7"] = "Имя персонажа %s не включает сервер, введите Имя-Сервер.";
L["trimDataMsg8"] = "Ошибка удаления %s из базы данных, персонаж не найден (имя чувствительно к регистру).";
L["trimDataMsg9"] = "Удалён %s из базы данных.";

L["instanceFrameSelectAltMsg"] = "Выберите, какого альта показывать, если \"Показать всех альтов\" отключено.\nИли какого альта подсвечивать, если \"Показать всех альтов\" включено.";

L["enteredDungeon"] = "Новое подземелье %s %s, нажмите";
L["enteredDungeon2"] = ", если это не новое подземелье.";
L["enteredRaid"] = "Новое подземелье %s, этот рейд не учитывается в блокировке.";
L["loggedInDungeon"] = "Вы вошли внутри %s %s, если это не новое подземелье, нажмите";
L["loggedInDungeon2"] = ", чтобы удалить это подземелье из базы данных.";
L["reloadDungeon"] = "Обнаружено обновление интерфейса %s, загрузка данных последнего подземелья вместо создания нового.";
L["thisHour"] = "в этом часу";
L["statsError"] = "Ошибка поиска статистики для подземелья ID %s.";
L["statsMobs"] = "Мобы:";
L["statsXP"] = "Опыт:";
L["statsAverageXP"] = "Средний опыт/моб:";
L["statsRunsPerLevel"] = "Пробежек на уровень:";
L["statsRunsNextLevel"] = "Пробежек до следующего уровня:";
L["statsTime"] = "Время:";
L["statsAverageGroupLevel"] = "Средний уровень группы:";
L["statsGold"] = "Золото";
L["sameInstance"] = "Обнаружен тот же ID подземелья, что и ранее %s, объединение записей базы данных.";
L["deleteInstance"] = "Удалено подземелье [%s] %s (%s назад) из базы данных.";
L["deleteInstanceError"] = "Ошибка удаления %s.";
L["countString"] = "Вы вошли в %s подземелий за последний час и %s за последние 24 часа";
L["countStringColorized"] = "Вы вошли в %s %s %s подземелий за последний час и %s %s %s за последние 24 часа";
L["now"] = "сейчас";
L["in"] = "через";
L["active24"] = "Блокировка на 24 часа активна";
L["nextInstanceAvailable"] = "Следующее подземелье доступно";
L["gave"] = "Дал";
L["received"] = "Получил";
L["to"] = "кому";
L["from"] = "от";
L["playersStillInside"] = "было сброшено (игроки, всё ещё находящиеся в старом подземелье, могут выйти и войти в новое).";
L["Gold"] = "Золото";
L["gold"] = "золото";
L["silver"] = "серебро";
L["copper"] = "медь";
L["newInstanceNow"] = "Новое подземелье можно войти сейчас";
L["thisHour"] = "в этом часу";
L["thisHour24"] = "в эти 24 часа";
L["openInstanceFrame"] = "Открыть окно подземелий";
L["openYourChars"] = "Открыть ваших персонажей";
L["openTradeLog"] = "Открыть лог торгов";
L["config"] = "Настройки";
L["thisChar"] = "Этот персонаж";
L["yourChars"] = "Ваши персонажи";
L["instancesPastHour"] = "подземелий за последний час.";
L["instancesPastHour24"] = "подземелий за последние 24 часа.";
L["leftOnLockout"] = "осталось на блокировке";
L["tradeLog"] = "Лог торгов";
L["pastHour"] = "Последний час";
L["pastHour24"] = "Последние 24 часа";
L["older"] = "Старше";
L["raid"] = "Рейд";
L["alts"] = "Альты";
L["deleteEntry"] = "Удалить запись";
L["lastHour"] = "Последний час";
L["lastHour24"] = "Последние 24 часа";
L["entered"] = "Вошёл";
L["ago"] = "назад";
L["stillInDungeon"] = "Всё ещё в подземелье";
L["leftOnLockout"] = "осталось на блокировке";
L["leftOnDailyLockout"] = "осталось на ежедневной блокировке";
L["noLockout"] = "Нет блокировки для этого рейда";
L["unknown"] = "Неизвестно";
L["instance"] = "Подземелье";
L["timeEntered"] = "Время входа";
L["timeLeft"] = "Оставшееся время";
L["timeInside"] = "Время внутри";
L["mobCount"] = "Количество мобов";
L["experience"] = "Опыт";
L["experienceShort"] = "Опыт";
L["rawGoldMobs"] = "Золото с мобов";
L["enteredLevel"] = "Уровень при входе";
L["leftLevel"] = "Уровень при выходе";
L["averageGroupLevel"] = "Средний уровень группы";
L["currentLockouts"] = "текущие блокировки";
L["repGains"] = "Прирост репутации";
L["groupMembers"] = "Члены группы";
L["tradesWhileInside"] = "Торги внутри";
L["noDataInstance"] = "Нет данных для этого подземелья.";
L["restedOnlyText"] = "Только с отдыхом";
L["restedOnlyTextTooltip"] = "Показывать только персонажей с отдыхом? Снимите галочку, чтобы показывать всех альтов, включая максимальный уровень и без отдыха.";
L["deleteEntry"] = "Удалить запись"; --Example: "Delete entry 5";
L["online"] = "В сети";
L["maximum"] = "Максимум";
L["level"] = "Уровень";
L["rested"] = "Отдых";
L["realmGold"] = "Золото на сервере для";
L["total"] = "Всего";
L["guild"] = "Гильдия";
L["resting"] = "Отдыхает";
L["notResting"] = "Не отдыхает";
L["rested"] = "Отдых";
L["restedBubbles"] = "Пузырьки отдыха";
L["restedState"] = "Состояние отдыха";
L["bagSlots"] = "Слоты сумки";
L["durability"] = "Прочность";
L["items"] = "Предметы";
L["ammunition"] = "Боеприпасы";
L["petStatus"] = "Статус питомца";
L["name"] = "Имя";
L["family"] = "Семейство";
L["happiness"] = "Счастье";
L["loyaltyRate"] = "Скорость лояльности";
L["petExperience"] = "Опыт питомца";
L["unspentTrainingPoints"] = "Неиспользованные очки обучения";
L["professions"] = "Профессии";
L["lastSeenPetDetails"] = "Последние данные о питомце";
L["currentPet"] = "Текущий питомец";
L["noPetSummoned"] = "Питомец не призван";
L["lastSeenPetDetails"] = "Последние данные о питомце";
L["noProfessions"] = "Профессии не найдены.";
L["cooldowns"] = "Перезарядки";
L["left"] = "осталось"; -- This is left as in "time left";
L["ready"] = "Готово.";
L["pvp"] = "PvP"; --Must be 3 letters max to fit.
L["rank"] = "Ранг";
L["lastWeek"] = "На прошлой неделе";
L["attunements"] = "Настройки";
L["currentRaidLockouts"] = "Текущие рейдовые блокировки";
L["none"] = "Нет.";

L["instanceStatsOutputRunsPerLevelTitle"] = "Пробежек на уровень";
L["instanceStatsOutputRunsPerLevelDesc"] = "Показывать, сколько пробежек нужно на уровень?";

L["instanceStatsOutputRunsNextLevelTitle"] = "До следующего уровня";
L["instanceStatsOutputRunsNextLevelDesc"] = "Показывать, сколько пробежек нужно до следующего уровня?";

L["instanceWindowWidthTitle"] = "Ширина окна";
L["instanceWindowWidthDesc"] = "Какой ширины должно быть окно подземелий.";

L["instanceWindowHeightTitle"] = "Высота окна";
L["instanceWindowHeightDesc"] = "Какой высоты должно быть окно подземелий.";

L["charsWindowWidthTitle"] = "Ширина окна персонажей";
L["charsWindowWidthDesc"] = "Какой ширины должно быть окно информации о персонажах.";

L["charsWindowHeightTitle"] = "Высота окна персонажей";
L["charsWindowHeightDesc"] = "Какой высоты должно быть окно информации о персонажах.";

L["tradeWindowWidthTitle"] = "Ширина окна торгов";
L["tradeWindowWidthDesc"] = "Какой ширины должно быть окно торгов.";

L["tradeWindowHeightTitle"] = "Высота окна торгов";
L["tradeWindowHeightDesc"] = "Какой высоты должно быть окно торгов.";

L["resetFramesTitle"] = "Сброс окон";
L["resetFramesDesc"] = "Сбросить все окна в центр экрана и вернуть размеры по умолчанию.";

L["resetFramesMsg"] = "Сброс позиций и размеров всех окон.";

L["statsRep"] = "Репутация:";

L["instanceStatsOutputRepTitle"] = "Полученная репутация";
L["instanceStatsOutputRepDesc"] = "Показывать, сколько репутации было получено в подземелье?";

L["instanceStatsOutputHKTitle"] = "Честь";
L["instanceStatsOutputHKDesc"] = "Показывать, сколько чести было получено на поле боя?";

L["experiencePerHour"] = "Опыт/час";

L["instanceStatsOutputXpPerHourTitle"] = "Показать опыт/час";
L["instanceStatsOutputXpPerHourDesc"] = "Показывать, сколько опыта в час было получено в подземелье?";

L["autoDialogueDesc"] = "Автодиалог с NPC";

L["autoSlavePensTitle"] = "Авто Узилище";
L["autoSlavePensDesc"] = "Автоматический диалог с НПС в клетке в конце Узилища?";

L["autoCavernsFlightTitle"] = "Авто полёт в ПТ";
L["autoCavernsFlightDesc"] = "Автоматический диалог с драконом у призывного камня в Пещерах Времени для полёта вниз? (Только если задание \"Логово господина\" выполнено)";

L["autoBlackMorassTitle"] = "Авто Чёрные топи";
L["autoBlackMorassDesc"] = "Автоматический диалог с НПС в начале Чёрных топей для получения маяка? (Только если задание \"Герой драконьего племени\" выполнено)";

L["autoSfkDoorTitle"] = "Авто дверь КТК";
L["autoSfkDoorDesc"] = "Автоматический диалог с НПС в Крепости Темного Клыка, открывающим дверь?";

L["honorGains"] = "Прирост чести";
L["Honor"] = "Честь";
L["Won"] = "Победа";
L["Lost"] = "Поражение";
L["Arena"] = "Арена";
L["Arena Points"] = "Очки арены";

L["stillInArena"] = "Всё ещё на арене";
L["stillInBattleground"] = "Всё ещё на поле боя";

L["resetAllInstancesConfirm"] = "Вы уверены, что хотите удалить все данные лога подземелий?";
L["All Instance log data has been deleted."] = "Все данные лога подземелий удалены.";

L["resetAllInstancesTitle"] = "Сброс данных";
L["resetAllInstancesDesc"] = "Сбросит все данные подземелий и удалит всё из лога. Это не сбрасывает торги.";

L["autoCavernsArthasTitle"] = "Авто Артас в ОС";
L["autoCavernsArthasDesc"] = "Автоматический диалог с Артасом в Очищении Стратхольма в Wrath.";

L["Mythic Plus"] = "Эпохальные+";
L["mythicPlusShort"] = "Эпохальные+";

L["noCurrentRaidLockouts"] = "Нет текущих рейдовых блокировок.";

L["weeklyQuests"] = "Еженедельные квесты";
L["dailyQuests"] = "Ежедневные квесты";
L["monthlyQuests"] = "Ежемесячные квесты";

L["openLockouts"] = "Открытые блокировки";

L["autoGammaBuffDesc"] = "Гамма-подземелья";

L["autoGammaBuffTitle"] = "Авто Гамма-бафф";
L["autoGammaBuffDesc"] = "Автоматически получать правильный гамма-бафф для вашего класса при разговоре с НПС баффа в Гамма-подземелье.";

L["autoGammaBuffReminderTitle"] = "Напоминание о баффе";
L["autoGammaBuffReminderDesc"] = "Выводить сообщение в чат в начале подземелья, напоминая получить бафф, если у вас его нет.";

L["autoGammaBuffTypeTitle"] = "Тип Гамма-баффа";
L["autoGammaBuffTypeDesc"] = "Какой тип баффа вы хотите? Автовыбор выберет между ближним/дальним/хилером/танком на основе вашей специализации. Или вы можете выбрать другой вариант. Выбор баффа — настройка для каждого персонажа.";

L["dungeonPopTimerTitle"] = "Таймер очереди";
L["dungeonPopTimerDesc"] = "Показывать таймер в окне очереди подземелий, сколько времени осталось, чтобы нажать \"Войти\"?";

L["autoWrathDailiesTitle"] = "Авто ежедневки Wrath";
L["autoWrathDailiesDesc"] = "Автоматически брать и сдавать ежедневные квесты Wrath у Архимага Лан'далока в Даларане";

L["gammaConfigWarning"] = "Выбор гамма-баффа индивидуален для персонажа, изменение на этом персонаже не повлияет на других.";
L["autoGammaBuffReminder"] = "Получите бафф Гамма-подземелья от %s.";
L["Sunreaver Warden"] = "Хранитель Похитителей Солнца";
L["Silver Covenant Warden"] = "Хранитель Серебряного Союза";
L["note"] = "Заметка:";
L["Click an entry to post stats."] = "Нажмите на запись, чтобы опубликовать статистику.";
L["Show Alts"] = "Показать альтов";
L["showAltsTooltip"] = "Показывать всех альтов в логе подземелий? (Блокировки индивидуальны для персонажа)";
L["PvE"] = "PvE"; --Must be 3 letters max to fit. (PvP already exists further up)
L["Hold to drag"] = "Удерживайте для перетаскивания";
L["Raid Lockouts (Including Alts)"] = "Рейдовые блокировки (включая альтов)";
L["No trade logs found."] = "Логи торгов не найдены.";
L["Today"] = "Сегодня";
L["Yesterday"] = "Вчера";

L["Level Log"] = "Лог уровней";
L["Mouseover log entry for more info"] = "Наведите на запись лога для дополнительной информации";
L["Current Level"] = "Текущий уровень";
L["Leveling history for"] = "История прокачки для";
L["Unknown Time"] = "Неизвестное время";
L["Unknown Zone"] = "Неизвестная зона";
L["Zone"] = "Зона";
L["SubZone"] = "Подзона";
L["Ding"] = "Звон"; --Level up.
L["Map coords"] = "Координаты карты";
L["Gold owned at start of level"] = "Золото на начале уровня";
L["Gold change during this level"] = "Изменение золота за этот уровень";
L["Quests completed during this level"] = "Квесты, завершённые за этот уровень";
L["Mobs that gave exp during this level"] = "Мобы, давшие опыт за этот уровень";
L["Played time this level"] = "Время игры на этом уровне";
L["Total Played"] = "Общее время игры";
L["firstTimeSeeingCharPlayed"] = "Первое появление этого персонажа на этом уровне, время игры на этом уровне, вероятно, неверное.";

L["Left-Click"] = "ЛКМ";
L["Right-Click"] = "ПКМ";
L["Shift Left-Click"] = "Shift + ЛКМ";
L["Shift Right-Click"] = "Shift + ПКМ";
L["Middle-Click"] = "СКМ";
L["Control Left-Click"] = "Ctrl + ЛКМ";

L["Lockouts"] = "Блокировки";
L["Instance"] = "Подземелье";
L["ZoneID"] = "ID зоны";
L["Show dungeons and raids?"] = "Показывать подземелья и рейды?";
L["Show battleground and arena instances?"] = "Показывать поля боя и арены?";
L["Party"] = "Группа";
L["Guild"] = "Гильдия";
L["Copy Paste"] = "Копировать/Вставить";
L["Print"] = "Печать";
L["Post Stats for log"] = "Опубликовать статистику для лога";
L["Alts (Mouseover names for info)"] = "Альты (наведите на имена для информации)";
L["Min Level"] = "Минимальный уровень";
L["No guild"] = "Без гильдии";
L["No guild rank"] = "Без ранга в гильдии";
L["Show leveling history for"] = "Показать историю прокачки для";
L["Test Instance"] = "Тестовое подземелье";
L["Long"] = "Длинный";
L["Medium"] = "Средний";
L["Short"] = "Короткий";
L["Chat Window"] = "Окно чата";
L["Group Chat (Party/Raid)"] = "Групповой чат (Группа/Рейд)";
L["12 hour"] = "12 часов";
L["24 hour"] = "24 часа";

L["Molten Core"] = "Огненные Недра";
L["Onyxia's Lair"] = "Логово Ониксии";
L["Blackwing Lair"] = "Логово Крыла Тьмы";
L["Naxxramas"] = "Наксрамас";
L["Karazhan"] = "Каражан";
L["The Shattered Halls"] = "Разрушенные залы";
L["Serpentshrine Cavern"] = "Змеиное святилище";
L["The Arcatraz"] = "Аркатрац";
L["Black Morass"] = "Чёрные топи";
L["Battle of Mount Hyjal"] = "Битва за гору Хиджал";
L["Black Temple"] = "Чёрный храм";
L["Hellfire Citadel"] = "Цитадель Адского Пламени";
L["Coilfang Reservoir"] = "Резервуар Кривого Клыка";
L["Shadow Labyrinth"] = "Темный лабиринт";
L["Auchindoun"] = "Аукиндон";
L["Tempest Keep"] = "Крепость Бурь";
L["Caverns of Time"] = "Пещеры Времени";
L["deletedCharOnRealm"] = "Удалён персонаж %s на сервере [%s].";
L["deletedCharOnRealmNewInfo"] = "Удалён персонаж %s на сервере [%s], запись новой информации.";

L["Time"] = "Время";
L["Show time?"] = "Показывать время?";
L["Show Zone where trade happened?"] = "Показывать зону, где произошла торговля?";
L["Time Ago"] = "Время назад";
L["Show how long ago?"] = "Показывать, как давно?";
L["Records"] = "Записи";
L["How many trade records to show?"] = "Сколько записей торгов показывать?";
L["Current Hour Lockouts"] = "Текущие почасовые блокировки";
L["Current Dungeon Stats"] = "Текущая статистика подземелий";
L["Log Entry"] = "Запись лога";
L["Local Time"] = "Местное время";
L["Server Time"] = "Серверное время";
L["Example"] = "Пример";

--Abbreviated days/months.
L["Mon"] = "Пн";
L["Tue"] = "Вт";
L["Wed"] = "Ср";
L["Thu"] = "Чт";
L["Fri"] = "Пт";
L["Sat"] = "Сб";
L["Sun"] = "Вс";

L["Jan"] = "Янв";
L["Feb"] = "Фев";
L["Mar"] = "Мар";
L["Apr"] = "Апр";
L["May"] = "Май";
L["Jun"] = "Июн";
L["Jul"] = "Июл";
L["Aug"] = "Авг";
L["Sep"] = "Сен";
L["Oct"] = "Окт";
L["Nov"] = "Ноя";
L["Dec"] = "Дек";

L["Blacksmithing"] = "Кузнечное дело";
L["Leatherworking"] = "Кожевничество";
L["Alchemy"] = "Алхимия";
L["Herbalism"] = "Травничество";
L["Cooking"] = "Кулинария";
L["Mining"] = "Горное дело";
L["Tailoring"] = "Портняжное дело";
L["Engineering"] = "Инженерное дело";
L["Enchanting"] = "Наложение чар";
L["Fishing"] = "Рыбная ловля";
L["Skinning"] = "Снятие шкур";
L["Jewelcrafting"] = "Ювелирное дело";
L["Inscription"] = "Начертание";
L["First Aid"] = "Первая помощь";

L["Wrath Cooking Daily"] = "Ежедневка кулинарии Wrath";
L["Wrath Fishing Daily"] = "Ежедневка рыбалки Wrath";
L["Wrath Jewelcrafting Daily"] = "Ежедневка ювелирки Wrath";
L["Cata Cooking Daily"] = "Ежедневка кулинарии Cata";
L["Cata Fishing Daily"] = "Ежедневка рыбалки Cata";
L["Cata Jewelcrafting Daily"] = "Ежедневка ювелирки Cata";

L["Tarnished Undermine Real"] = "Потускневший реал Нижней шахты";

L["Dungeon weeklies remaining"] = "Осталось еженедельных подземелий";

L["Currency"] = "Валюта";
L["Currencies"] = "Валюты";

L["instanceStatsOutputCurrencyTitle"] = "Валюта";
L["instanceStatsOutputCurrencyDesc"] = "Показывать, какие валюты были получены в подземелье?";

L["lootReminderDesc"] = "Напоминания о добыче";

L["lootReminderRealTitle"] = "Реал Нижней шахты";
L["lootReminderRealDesc"] = "Показывать напоминание о сборе Потускневшего реала Нижней шахты в SoD, когда умирает босс, который может его дропнуть.";

L["lootReminderSizeTitle"] = "Размер текста";
L["lootReminderSizeDesc"] = "Какой размер текста использовать для напоминания.";

L["lootReminderXTitle"] = "Позиция X";
L["lootReminderXDesc"] = "Настройте для позиции напоминания влево/вправо.";

L["lootReminderYTitle"] = "Позиция Y";
L["lootReminderYDesc"] = "Настройте для позиции напоминания вверх/вниз.";

L["Looted"] = "Собрано";
L["Not Looted"] = "Не собрано";
L["Killed But Not Looted"] = "Убит, но не собран";
L["Loot the Tarnished Undermine Real"] = "Соберите Потускневший реал Нижней шахты";
L["Not Killed"] = "Не убит";
L["Loot Reminder List"] = "Список напоминаний о добыче";
L["Check your daily reals status"] = "Проверить статус ежедневных реалов";
L["Bosses Looted"] = "Боссы, с которых собрана добыча";
L["Total today"] = "Всего сегодня";
L["Total Reals"] = "Всего реалов";

L["Reminder"] = "Напоминание";
L["missingArgentDawnTrinket"] = "Напоминание о тринкете %s: %s не экипирован.";

L["argentDawnTrinketReminderTitle"] = "Тринкет Серебряного Рассвета";
L["argentDawnTrinketReminderDesc"] = "Напоминание в чате, если вы входите в Некроситет/Стратхольм с тринкетом в сумке и не возвышены.";

L["skipRealMsgIfCappedTitle"] = "Без сообщения при лимите";
L["skipRealMsgIfCappedDesc"] = "Пропускать сообщение о сборе реала Нижней шахты, если уже достигнут лимит в 150 токенов.";

L["Live Side"] = "Живая сторона";
L["Undead Side"] = "Мёртвая сторона";
L["East"] = "Восток";
L["West"] = "Запад";
L["North"] = "Север";
L["Upper"] = "Верх";
L["Lower"] = "Низ";

L["lootTheItem"] = "Соберите %s"; --Example: Loot the Tarnished Undermine Real
L["Qiraji Lord's Insignia"] = "Знаки различия киражского владыки";

L["soundsLootReminderTitle"] = "Звук напоминания";
L["soundsLootReminderDesc"] = "Выберите, какой звук проигрывать при отображении напоминания о добыче.";

L["lootReminderMysRelicTitle"] = "Таинственные реликвии";
L["lootReminderMysRelicDesc"] = "Показывать сообщения в центре экрана/чате, когда кто-то собирает Таинственную реликвию в криптах Каражана.";

L["lootReminderMysRelicPartyTitle"] = "Сообщение о реликвии";
L["lootReminderMysRelicPartyDesc"] = "Отправлять сообщение в групповой чат, когда кто-то собирает Таинственную реликвию в криптах Каражана.";

L["Remnants of Valor"] = "Останки доблести";

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
FT.embedded.NovaInstanceTracker:Add("NovaInstanceTracker", Component, "NovaInstanceTracker/Locale/ruRU.lua")
