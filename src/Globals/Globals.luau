local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Globals = {}

function Globals.Init()
    local Forsaken = getgenv().Forsaken

    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    local globals = Forsaken.globals

    -- Define global variables here
    globals.version = "1.2.4"

    globals.window = nil

    globals.sprintingModule = ReplicatedStorage:WaitForChild("Systems", 20):WaitForChild("Character", 20):WaitForChild("Game", 20):WaitForChild("Sprinting", 20)
    globals.flowGameManagerModule = ReplicatedStorage:WaitForChild("Modules", 20):WaitForChild("Minigames", 20):WaitForChild("FlowGameManager", 20)

    globals.speedModifiersFolder = "SpeedMultipliers"
    globals.sprintingSpeedModifier = "Sprinting"
    globals.directionalSpeedModifier = "DirectionalMovement"


    globals.killerFolder = Workspace:WaitForChild("Players", 20):WaitForChild("Killers", 20)
    globals.survivorFolder = Workspace:WaitForChild("Players", 20):WaitForChild("Survivors", 20)
    globals.spectatorFolder = Workspace:WaitForChild("Players", 20):WaitForChild("Spectating", 20)
    globals.mapFolder = Workspace:WaitForChild("Map", 20):WaitForChild("Ingame", 20)
    globals.mapModel = globals.mapFolder:FindFirstChild("Map") or nil
end

return Globals