local Watermark = {}
local Forsaken = getgenv().Forsaken

function Watermark:Init()
    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    self.settings = Forsaken.settings
    self.globals = Forsaken.globals
    self.cache = Forsaken.cache
    self.connections = Forsaken.connections
    self.instances = Forsaken.instances

    local developerMode = Forsaken.developmentMode

    -- Make a little watermark that is just text displaying the name of the script and the version number
    -- if developer mode is enabled, display the useful information like the performance of the main loop, number of connections, number of instances, number of cached models
    -- Watermark should be in the top left corner of the screen, and should be visible at all times, but should not interfere with the game in any way
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ForsakenWatermark"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Name = "ForsakenWatermarkFrame"
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui
    
    local watermark = Instance.new("TextLabel")
    watermark.Name = "ForsakenWatermark"
    watermark.Text = "Forsaken v" .. Forsaken.globals.version
    watermark.Size = UDim2.new(1, 0, 1, 0)
    watermark.Position = UDim2.new(0, 10, 0, 10)
    watermark.BackgroundTransparency = 0.5
    watermark.BackgroundColor3 = Color3.new(0, 0, 0)
    watermark.TextColor3 = Color3.new(1, 1, 1)
    watermark.TextScaled = true
    watermark.Parent = frame

    self.watermark = watermark

    table.insert(self.instances, screenGui)
    table.insert(self.instances, frame)
    table.insert(self.instances, watermark)
end

function Watermark:Run()
    -- Update the watermark text with the current information
    if self.settings.showWatermark then
        self.watermark.Visible = true
        if self.settings.showWatermarkdebug then
            -- because connections are stored in a lookup table without table.insert rather connections[x] = y we need to calculate the number of connections diffrently than #connections
            local numConnections = 0
            for _, _ in pairs(Forsaken.connections) do
                numConnections = numConnections + 1
            end

            local numInstances = #Forsaken.instances

            local numCachedKillers = 0
            local numCachedSurvivors = 0
            local numCachedItems = 0

            for _, _ in pairs(Forsaken.cache.killerModels) do
                numCachedKillers = numCachedKillers + 1
            end
            for _, _ in pairs(Forsaken.cache.survivorModels) do
                numCachedSurvivors = numCachedSurvivors + 1
            end
            for _, _ in pairs(Forsaken.cache.itemParts) do
                numCachedItems = numCachedItems + 1
            end

            self.watermark.Size = UDim2.new(1, 0, 1, 0)
            self.watermark.Text = string.format(
                "Forsaken v%s by Sino\nPossible Frame Time: %.2f ms\nPossible FPS: %.2f\nConnections: %d\nInstances: %d\nCached Killers: %d\nCached Survivors: %d\nCached Items: %d",
                Forsaken.globals.version,
                Forsaken.performance.frameTime * 1000,
                Forsaken.performance.fps,
                numConnections,
                numInstances,
                numCachedKillers,
                numCachedSurvivors,
                numCachedItems
            )
        else
            self.watermark.Size = UDim2.new(1, 0, 0.3, 0)
            self.watermark.Text = "Forsaken v" .. Forsaken.globals.version .. " By Sino"
        end
    else
        self.watermark.Visible = false
    end
end

return Watermark