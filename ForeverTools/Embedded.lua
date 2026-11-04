-- Internal package loader for applications originally shipped as separate addons.
-- API replacements apply only to the embedded application's Lua environment.
local _, FT = ...
FT.embedded = {}

function FT:NewEmbeddedRuntime(feature, definitions)
    local runtime = {feature=feature, packages={}, order={}, frames={}, running=false}
    local env = setmetatable({}, {__index=_G})
    env._G = env
    env.SlashCmdList = setmetatable({}, {__newindex=function(t, key, callback)
        rawset(t, key, callback)
        SlashCmdList["FTEMBED_" .. feature .. key] = function(...)
            if runtime.running then return callback(...) end
        end
    end})
    env.C_PartyInfo = setmetatable({}, {__index=C_PartyInfo})
    runtime.env = env
    for _, definition in ipairs(definitions) do
        definition.chunks = {}
        definition.namespace = {}
        runtime.packages[definition.name] = definition
        runtime.order[#runtime.order+1] = definition.name
    end
    local function Package(value)
        if type(value) == "number" then value = runtime.order[value] end
        if value == "FTNovaInstanceTracker" then value = "NovaInstanceTracker" end
        return runtime.packages[value]
    end
    local native = C_AddOns or _G
    local api = setmetatable({}, {__index=native})
    env.C_AddOns = api
    function api.GetNumAddOns() return #runtime.order end
    function api.GetAddOnInfo(value)
        local package = Package(value)
        if package then return package.name, package.meta.Title, package.meta.Notes, true, nil, "INSECURE" end
        if native.GetAddOnInfo then return native.GetAddOnInfo(value) end
    end
    function api.GetAddOnMetadata(value, key)
        local package = Package(value)
        if package then return package.meta[key] end
        if native.GetAddOnMetadata then return native.GetAddOnMetadata(value, key) end
    end
    function api.IsAddOnLoaded(value)
        local package = Package(value)
        if package then return package.loaded or false end
        return native.IsAddOnLoaded and native.IsAddOnLoaded(value) or false
    end
    function api.IsAddOnLoadOnDemand(value)
        local package = Package(value)
        if package then return package.lod end
        return native.IsAddOnLoadOnDemand and native.IsAddOnLoadOnDemand(value) or false
    end
    function api.GetAddOnEnableState(value, character)
        if Package(value) then return 2 end
        return native.GetAddOnEnableState and native.GetAddOnEnableState(value, character) or 0
    end
    function api.GetAddOnDependencies(value)
        local package = Package(value)
        if package then return unpack(package.deps) end
        if native.GetAddOnDependencies then return native.GetAddOnDependencies(value) end
    end
    function api.GetAddOnOptionalDependencies(value)
        -- Embedded libraries are already present. Do not load external old copies.
        if Package(value) then return end
        if native.GetAddOnOptionalDependencies then return native.GetAddOnOptionalDependencies(value) end
    end
    function api.EnableAddOn(value)
        if Package(value) then return end
        -- Upstream may suggest enabling missing content; keep unrelated addons untouched.
    end
    function api.DisableAddOn(value)
        if Package(value) then return end
    end
    function api.DoesAddOnHaveLoadError(value)
        local package = Package(value)
        return package and package.failed or false
    end
    function api.LoadAddOn(value)
        local package = Package(value)
        if package then return runtime:Load(package.name) end
        if native.LoadAddOn then return native.LoadAddOn(value) end
        return nil, "MISSING"
    end
    for _, name in ipairs({"GetNumAddOns", "GetAddOnInfo", "GetAddOnMetadata", "IsAddOnLoaded",
        "IsAddOnLoadOnDemand", "GetAddOnEnableState", "GetAddOnDependencies", "GetAddOnOptionalDependencies",
        "EnableAddOn", "DisableAddOn", "LoadAddOn"}) do env[name] = api[name] end
    env.UIParentLoadAddOn = api.LoadAddOn

    env.CreateFrame = function(...)
        local frame = CreateFrame(...)
        runtime.frames[#runtime.frames+1] = frame
        local setScript = frame.SetScript
        frame.SetScript = function(self, script, callback)
            if callback then
                local original = callback
                callback = function(...)
                    if runtime.running then return original(...) end
                end
            end
            return setScript(self, script, callback)
        end
        return frame
    end
    if C_Timer then
        env.C_Timer = setmetatable({}, {__index=C_Timer})
        for _, name in ipairs({"After", "NewTimer", "NewTicker"}) do
            local method = C_Timer[name]
            if method then env.C_Timer[name] = function(delay, callback, ...)
                return method(delay, function(...)
                    if runtime.running then return callback(...) end
                end, ...)
            end end
        end
    end
    env.hooksecurefunc = function(target, method, callback)
        local function Guard(fn)
            return function(...) if runtime.running then return fn(...) end end
        end
        if callback then return hooksecurefunc(target, method, Guard(callback)) end
        return hooksecurefunc(target, Guard(method))
    end
    -- All application globals are private except actual saved-variable tables,
    -- which AceDB also accesses through the real global environment.
    setmetatable(env, {
        __index=_G,
        __newindex=function(t, key, value)
            if key:match("^SLASH_") then _G["SLASH_FTEMBED_" .. feature .. key:sub(7)] = value; rawset(t, key, value)
            elseif key:match("^ForeverTools.*DB$") then _G[key] = value
            else rawset(t, key, value) end
        end,
    })
    function runtime:Add(packageName, chunk, path)
        local package = assert(self.packages[packageName], packageName)
        package.chunks[#package.chunks+1] = {run=chunk, path=path}
        setfenv(chunk, self.env)
    end
    function runtime:Dispatch(event, ...)
        -- A virtual ADDON_LOADED must reach only this application's frames.
        -- Snapshot the count because handlers may create additional frames.
        local count = #self.frames
        for i=1,count do
            local frame = self.frames[i]
            if frame:IsEventRegistered(event) then
                local callback = frame:GetScript("OnEvent")
                if callback then callback(frame, event, ...) end
            end
        end
    end
    function runtime:Load(name)
        local package = self.packages[name]
        if not self.running or not package then return nil, "DISABLED" end
        if package.loaded then return true end
        if package.failed or package.loading then return nil, "CORRUPT" end
        package.loading = true
        for _, dependency in ipairs(package.deps) do
            if self.packages[dependency] and not self:Load(dependency) then
                package.loading = nil
                package.failed = true
                return nil, "DEP_NOT_LOADED"
            end
        end
        local currentPath = name
        local ok, err = pcall(function()
            for _, chunk in ipairs(package.chunks) do
                currentPath = chunk.path
                chunk.run(name, package.namespace)
            end
            package.loaded = true
            self:Dispatch("ADDON_LOADED", name)
        end)
        package.loading = nil
        if not ok then
            package.failed = true
            package.loaded = false
            FT:Print(feature .. ": Fehler in " .. currentPath .. ": " .. tostring(err))
            return nil, "CORRUPT"
        end
        return true
    end
    function runtime:Stop()
        self.running = false
        for _, frame in ipairs(self.frames) do
            if frame.UnregisterAllEvents then frame:UnregisterAllEvents() end
            if frame.Hide then frame:Hide() end
        end
        local app = self.env.NIT
        if app and app.UnregisterAllComm then app:UnregisterAllComm() end
    end
    return runtime
end
