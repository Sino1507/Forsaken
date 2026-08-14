local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not getgenv().Forsaken.__initialized then
    error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
end

local Globals = {}

function Globals.Init()
    local Forsaken = getgenv().Forsaken

    local globals = Forsaken.globals

    -- Define global variables here
    globals.sprintingModule = ReplicatedStorage.Systems.Character.Game.Sprinting
end

return Globals