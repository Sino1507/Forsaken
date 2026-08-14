-- Init Shared Space
local Forsaken = type(getgenv().GetShared) == "function" and getgenv().GetShared() or {}
if Forsaken.__initialized then
    warn("Forsaken is already initialized. Unloading previous instance.")
    Forsaken.Unload()
    Forsaken = {}
end

Forsaken.__initialized = true

function GetShared()
    return getgenv().Forsaken
end
getgenv().GetShared = GetShared

getgenv().Forsaken = Forsaken
-- Resolve Includes
function Include(path)
    local baseUrl = "https://raw.githubusercontent.com/Sino1507/Forsaken/main/src/"
    local url = baseUrl .. path

    local response = game:HttpGet(url)
    if response then
        local func, err = loadstring(response)
        if func then
            return func()
        else
            error("Failed to load script from " .. url .. ": " .. err)
        end
    else
        error("Failed to fetch script from " .. url)
    end
end

-- Unload Function
function Forsaken.Unload()
    Forsaken.__initialized = false
    getgenv().Forsaken = nil
    getgenv().GetShared = nil
end