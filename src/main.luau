local RunService = game:GetService("RunService")

-- Init Shared Space
local Forsaken = getgenv().Forsaken or {}
if Forsaken.__initialized then
    warn("Forsaken is already initialized. Unloading previous instance.")
    Forsaken.Unload()
    Forsaken = {}
else
    Forsaken.settings = {}
    Forsaken.globals = {}
    Forsaken.instances = {}
    Forsaken.connections = {}
end

Forsaken.__initialized = true

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
getgenv().Include = Include

local Globals = Include("Globals/Globals.luau")
local Settings = Include("Globals/Settings.luau")

local StaminaController = Include("Features/StaminaController.luau")

Globals.Init()
Settings.Init()

StaminaController:Init()

-- Main Loop tied to RenderStepped
Forsaken.connections.RenderStepped = RunService.RenderStepped:Connect(function()
    StaminaController:Run()
end)



-- Unload Function
function Forsaken.Unload()
    Forsaken.__initialized = false

    for _, connection in pairs(Forsaken.connections) do
        if connection and connection.Disconnect then
            connection:Disconnect()
        end
    end

    Forsaken.connections = {}

    getgenv().Forsaken = nil
    getgenv().GetShared = nil
end

getgenv().Forsaken = Forsaken