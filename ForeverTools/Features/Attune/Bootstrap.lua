local _, FT = ...
local saved = {
    FTAttune_DB = "ForeverToolsAttuneDB",
    FTAttuneLastViewed = "ForeverToolsAttuneLastViewed",
    FTAttuneTreeExpandStatus = "ForeverToolsAttuneTreeExpandStatus",
}
local env = {}
setmetatable(env, {
    __index = function(_, key) return _G[saved[key] or key] end,
    __newindex = function(t, key, value)
        if saved[key] then _G[saved[key]] = value else rawset(t, key, value) end
    end,
})
env._G = env
env.epoch = 0
env.frames = {}
FT.attuneEnv = env
function env.Active()
    local module = FT.modules.attune
    return module and module:Active() or false
end
-- Old delayed work must not run after disabling and enabling the module again.
env.C_Timer = setmetatable({After = function(delay, callback)
    local epoch = env.epoch
    C_Timer.After(delay, function(...)
        if env.Active() and epoch == env.epoch then callback(...) end
    end)
end}, {__index = C_Timer})
env.CreateFrame = function(...)
    local frame = CreateFrame(...)
    env.frames[#env.frames + 1] = frame
    local setScript = frame.SetScript
    frame.SetScript = function(self, script, callback)
        if callback and (script == "OnEvent" or script == "OnUpdate" or script == "OnClick") then
            local original = callback
            callback = function(...)
                if env.Active() then return original(...) end
            end
        end
        return setScript(self, script, callback)
    end
    return frame
end
