
local ESP = {}
local Forsaken = getgenv().Forsaken

function ESP:Init()
    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    local settings = Forsaken.settings
    local globals = Forsaken.globals
    local cache = Forsaken.cache

    self.settings = settings
    self.globals = globals
    self.cache = cache
    self.cleared = false
end

function ESP:CreateFingerprintedHighlight(part, color)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = part
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.Parent = part
    highlight.Name = "ForsakenHighlight"

    table.insert(Forsaken.instances, highlight)

    highlight.Destroying:Connect(function()
        local idx = table.find(Forsaken.instances, highlight)
        if idx then
            table.remove(Forsaken.instances, idx)
        end
    end)
    return highlight
end

function ESP:RemoveFingerprintedHighlight(part)
    local highlight = part:FindFirstChild("ForsakenHighlight")
    if highlight then
        highlight:Destroy()
    end
end

function ESP:UpdateESP()
    for _, killer in pairs(self.cache.killerModels) do
        if self.settings.ESP.ShowKillers then
            if not killer:FindFirstChild("ForsakenHighlight") then
                local highlight = self:CreateFingerprintedHighlight(killer, self.settings.ESP.Colors.KillerColor) -- Red for killers
                highlight.FillTransparency = self.settings.ESP.Transparencies.KillerTransparency
            else
                local highlight = killer:FindFirstChild("ForsakenHighlight")
                highlight.FillColor = self.settings.ESP.Colors.KillerColor
                highlight.FillTransparency = self.settings.ESP.Transparencies.KillerTransparency
            end
        else
            self:RemoveFingerprintedHighlight(killer)
        end
    end

    for _, survivor in pairs(self.cache.survivorModels) do
        if self.settings.ESP.ShowSurvivors then
            if not survivor:FindFirstChild("ForsakenHighlight") then
                local highlight = self:CreateFingerprintedHighlight(survivor, self.settings.ESP.Colors.SurvivorColor) -- Green for survivors
                highlight.FillTransparency = self.settings.ESP.Transparencies.SurvivorTransparency
            else
                local highlight = survivor:FindFirstChild("ForsakenHighlight")
                highlight.FillColor = self.settings.ESP.Colors.SurvivorColor
                highlight.FillTransparency = self.settings.ESP.Transparencies.SurvivorTransparency
            end
        else
            self:RemoveFingerprintedHighlight(survivor)
        end
    end

    for _, item in pairs(self.cache.itemParts) do
        if self.settings.ESP.ShowItems then
            if not item:FindFirstChild("ForsakenHighlight") then
                local highlight = self:CreateFingerprintedHighlight(item, self.settings.ESP.Colors.ItemColor) -- Blue for items
                highlight.FillTransparency = self.settings.ESP.Transparencies.ItemTransparency
            else
                local highlight = item:FindFirstChild("ForsakenHighlight")
                highlight.FillColor = self.settings.ESP.Colors.ItemColor
                highlight.FillTransparency = self.settings.ESP.Transparencies.ItemTransparency
            end
        else
            self:RemoveFingerprintedHighlight(item)
        end
    end

    for _, generator in pairs(self.cache.generatorModels) do
        local progress = generator:FindFirstChild("Progress")
        local ignore = false

        if progress then
            ignore = self.settings.ESP.IgnoreFinishedGens and progress.Value == 100
        end

        if self.settings.ESP.ShowGenerators and not ignore then
            if not generator:FindFirstChild("ForsakenHighlight") then
                local highlight = self:CreateFingerprintedHighlight(generator, self.settings.ESP.Colors.GeneratorColor) -- Yellow for generators
                highlight.FillTransparency = self.settings.ESP.Transparencies.GeneratorTransparency
            else
                local highlight = generator:FindFirstChild("ForsakenHighlight")
                highlight.FillColor = self.settings.ESP.Colors.GeneratorColor
                highlight.FillTransparency = self.settings.ESP.Transparencies.GeneratorTransparency
            end
        else
            self:RemoveFingerprintedHighlight(generator)
        end
    end
end

function ESP:ClearAllHighlights()
    for _, killer in pairs(self.cache.killerModels) do
        self:RemoveFingerprintedHighlight(killer)
    end

    for _, survivor in pairs(self.cache.survivorModels) do
        self:RemoveFingerprintedHighlight(survivor)
    end

    for _, item in pairs(self.cache.itemParts) do
        self:RemoveFingerprintedHighlight(item)
    end

    for _, generator in pairs(self.cache.generatorModels) do
        self:RemoveFingerprintedHighlight(generator)
    end
end

function ESP:Run()
    if not self.cache then
        error("Cache is not initialized. Please ensure that the Cache script is loaded before running the ESP.")
    end

    if self.settings.ESP.Enabled and self.globals.mapModel ~= nil then
        self:UpdateESP()
        self.cleared = false
    elseif not self.cleared then
        self:ClearAllHighlights()
        self.cleared = true
    end
end

function ESP:Unload()
    self:ClearAllHighlights()
    self.cleared = true
end

return ESP