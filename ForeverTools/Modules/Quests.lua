-- Adapted from Guschi 1.2.1, QuickTurnIn.lua (author: Philipp).
local _, FT = ...
local M = {
    title = "Automatische Questabgabe",
    description = "Fertige Quests beim Questgeber abgeben. SHIFT pausiert; mehrere Belohnungen wählst du selbst.",
}
FT:RegisterModule("quests", M)

local function IsComplete(questID)
    if not questID or not C_QuestLog or not C_QuestLog.IsComplete then return false end
    local ok, complete = pcall(C_QuestLog.IsComplete, questID)
    return ok and complete
end

local handlers = {}

function handlers.GOSSIP_SHOW()
    if not C_GossipInfo or not C_GossipInfo.GetActiveQuests or not C_GossipInfo.SelectActiveQuest then return end
    for _, quest in ipairs(C_GossipInfo.GetActiveQuests() or {}) do
        if quest.isComplete or IsComplete(quest.questID) then
            C_GossipInfo.SelectActiveQuest(quest.questID)
            return
        end
    end
end

function handlers.QUEST_GREETING()
    if not GetNumActiveQuests or not GetActiveQuestID or not SelectActiveQuest then return end
    for index = 1, GetNumActiveQuests() do
        if IsComplete(GetActiveQuestID(index)) then
            SelectActiveQuest(index)
            return
        end
    end
end

function handlers.QUEST_PROGRESS()
    if IsQuestCompletable and IsQuestCompletable() then CompleteQuest() end
end

function handlers.QUEST_COMPLETE()
    local choices = GetNumQuestChoices()
    if choices > 1 then
        FT:Print("Questabgabe: Bitte die Belohnung selbst auswählen.")
        return
    end
    GetQuestReward(choices == 1 and 1 or 0)
end

function M:Initialize()
    if self.frame then return end
    local frame = CreateFrame("Frame")
    self.frame = frame
    for event in pairs(handlers) do frame:RegisterEvent(event) end
    frame:SetScript("OnEvent", function(_, event)
        if not FT:IsEnabled("quests") or IsShiftKeyDown() then return end
        local handler = handlers[event]
        if handler then
            local ok, errorMessage = pcall(handler)
            if not ok and not self.errorShown then
                self.errorShown = true
                FT:Print("Questabgabe abgebrochen: " .. tostring(errorMessage))
            end
        end
    end)
end
