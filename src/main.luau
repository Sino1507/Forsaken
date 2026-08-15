local Players = game:GetService("Players")
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
    Forsaken.cache = {}
    Forsaken.performance = {
        frameTime = 0,
        fps = 0
    }
end

Forsaken.__initialized = true
Forsaken.developmentMode = false

getgenv().Forsaken = Forsaken

-- Resolve Includes
function Include(path)
    local baseUrl = "https://raw.githubusercontent.com/Sino1507/Forsaken/main/src/"
    if Forsaken.developmentMode then
        baseUrl = "Forsaken/src/"
    end

    local url = baseUrl .. path

    if Forsaken.developmentMode then
        local filePath =  baseUrl.. path
        
        if not isfile(filePath) then
            error("File not found: " .. filePath)
        end

        local content = readfile(filePath)
        local func, err = loadstring(content)
        if func then
            return func()
        else
            error("Failed to load script from " .. filePath .. ": " .. err)
        end
    else
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
end
getgenv().Include = Include

local Globals = Include("Globals/Globals.luau")
local Settings = Include("Globals/Settings.luau")

local Saving = Include("Saving/Saving.luau")

local Cache = Include("Cache/Cache.luau")

local UI = Include("Render/UI.luau")
local ESP = Include("Render/ESP.luau")
local Watermark = Include("Render/Watermark.luau")

local StaminaController = Include("Features/StaminaController.luau")
local GeneratorController = Include("Features/GeneratorController.luau")

Globals.Init()
Settings.Init()

Saving:Init()
local LoadedSave = Saving:Load()

Cache:Init()

UI:Init()
ESP:Init()
Watermark:Init()

StaminaController:Init()
GeneratorController:Init()

Forsaken.globals.window:Toast({ title = (LoadedSave and "Save Loaded" or "No Save"), position = "Bottom", icon = 125823673784681 })

-- Main Loop tied to RenderStepped
Forsaken.connections.RenderStepped = RunService.RenderStepped:Connect(function()
    local startTime = tick()

    StaminaController:Run()
    GeneratorController:Run()
    ESP:Run()
    Watermark:Run()

    local endTime = tick()
    local frameTime = endTime - startTime
    Forsaken.performance = {
        frameTime = frameTime,
        fps = 1 / frameTime
    }
end)

Players.PlayerRemoving:Connect(function(player)
    if player == Players.LocalPlayer then 
        if Forsaken.settings.autoSave then 
            Saving:Save()
        end

        Forsaken.Unload()
    end
end)

-- Unload Function
function Forsaken.Unload()
    if Forsaken.settings.autoSave then 
        Saving:Save()
    end

    for _, connection in pairs(Forsaken.connections) do
        if connection and connection.Disconnect then
            connection:Disconnect()
        end
    end

    Forsaken.connections = {}

    Cache:Unload()
    ESP:Unload()
    UI:Unload()
    StaminaController:Unload()
    GeneratorController:Unload()

    Forsaken.__initialized = false

    for _, instance in pairs(Forsaken.instances) do
        if instance and instance.Destroy then
            instance:Destroy()
        end
    end

    Forsaken.instances = {}

    getgenv().Forsaken = nil
end