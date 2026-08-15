local Saving = {}
local Forsaken = getgenv().Forsaken

local FileName = "Forsaken_Settings.json"

local HttpService = game:GetService("HttpService")

local function Serialize(value)
    if typeof(value) == "Color3" then
        return {
            __type = "Color3",
            R = value.R,
            G = value.G,
            B = value.B,
        }
    elseif type(value) == "table" then
        local result = {}

        for key, val in pairs(value) do
            result[key] = Serialize(val)
        end

        return result
    end

    return value
end

local function Deserialize(value)
    if type(value) ~= "table" then
        return value
    end

    if value.__type == "Color3" then
        return Color3.new(value.R, value.G, value.B)
    end

    local result = {}

    for key, val in pairs(value) do
        result[key] = Deserialize(val)
    end

    return result
end

local function MergeSettings(target, loaded)
    for key, value in pairs(loaded) do
        if type(value) == "table" and type(target[key]) == "table" then
            MergeSettings(target[key], value)
        else
            target[key] = value
        end
    end
end

function Saving:Init()
    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    self.settings = Forsaken.settings
end

function Saving:Save()
    if not self.settings then
        error("Saving is not initialized. Please call Saving:Init() first.")
    end

    local serialized = Serialize(self.settings)
    local encoded = HttpService:JSONEncode(serialized)

    writefile(FileName, encoded)

    Forsaken.globals.window:Toast({ title = "Saved", position = "Bottom", icon = 125823673784681 })
end

function Saving:Load()
    if not self.settings then
        error("Saving is not initialized. Please call Saving:Init() first.")
    end

    if not isfile(FileName) then
        return false
    end

    local encoded = readfile(FileName)

    local success, decoded = pcall(function()
        return HttpService:JSONDecode(encoded)
    end)

    if not success then
        warn("Failed to decode settings file:", decoded)
        return false
    end

    local deserialized = Deserialize(decoded)

    -- Merge instead of replacing the entire settings table.
    MergeSettings(self.settings, deserialized)

    return true
end

function Saving:Delete()
    if not isfile(FileName) then
        return
    end

    delfile(FileName)

    Forsaken.globals.window:Toast({ title = "Deleted Save", position = "Bottom", icon = 125823673784681 })
end

return Saving