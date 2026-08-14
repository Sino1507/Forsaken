if not getgenv().Forsaken.__initialized then
    error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
end

local Settings = {}

function Settings.Init()
    local Forsaken = getgenv().Forsaken

    local settings = Forsaken.settings

    -- Define settings here
    settings.Stamina = {
        Infinite = false,
    }
end

return Settings