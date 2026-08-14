

local UI = {}

function UI:Init()
    local Forsaken = getgenv().Forsaken

    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    local settings = Forsaken.settings

    -- Initialize your UI components here
    self.Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

    self.window = self.Rayfield:CreateWindow({
        name = "Forsaken",
        subtitle = "Made with <3 by Sino",
    })

    local staminaTab = self.window:CreateTab({ name = "Stamina", icon = 93364949241311 })

    staminaTab:CreateSection({ name = "Stamina", icon = 93364949241311 })

    local noDrainToggle = staminaTab:CreateToggle({
        name = "No Drain",
        flag = "NoDrain",
        value = false,
        callback = function(value)
            settings.Stamina.NoDrain = value
        end,
    })

    staminaTab:CreateKeybind({
        name = "No Drain Keybind",
        value = Enum.KeyCode.LeftAlt,
        callback = function(key)
            settings.Stamina.NoDrain = not settings.Stamina.NoDrain
            noDrainToggle:Set(settings.Stamina.NoDrain, true)
        end,
    })

    staminaTab:CreateSlider({
        name = "Stamina Drain Rate",
        flag = "StaminaDrainRate",
        range = { 0, 200 },
        increment = 5,
        value = 100,
        suffix = "%",
        callback = function(value)
            settings.Stamina.StaminaDrainRate = value / 100
        end,
    })

    staminaTab:CreateSlider({
        name = "Stamina Recovery Rate",
        flag = "StaminaRecoveryRate",
        range = { 0, 200 },
        increment = 5,
        value = 100,
        suffix = "%",
        callback = function(value)
            settings.Stamina.StaminaRecoveryRate = value / 100
        end,
    })

    staminaTab:CreateSlider({
        name = "Sprint Speed Multiplier",
        flag = "SprintSpeedMultiplier",
        range = { 10, 200 },
        increment = 5,
        value = 100,
        suffix = "%",
        callback = function(value)
            settings.Stamina.SprintSpeedMultiplier = value / 100
        end,
    })

    staminaTab:CreateInput({
        name = "Max Stamina",
        flag = "MaxStamina",
        numeric = true,
        value = "100",
        placeholder = "Enter a number",
        callback = function(text)
            local toNumber = tonumber(text)
            if toNumber then
                settings.Stamina.MaxStamina = toNumber
            else
                warn("Invalid input for Max Stamina. Please enter a valid number.")
            end
        end,
    })

    local espTab = self.window:CreateTab({ name = "ESP", icon = 93364949241311 })

    espTab:CreateSection({ name = "ESP", icon = 93364949241311 })

    local espToggle = espTab:CreateToggle({
        name = "Enable ESP",
        flag = "EnableESP",
        value = settings.ESP.Enabled,
        callback = function(value)
            settings.ESP.Enabled = value
        end,
    })

    espTab:CreateToggle({
        name = "Show Killer",
        flag = "ShowKillers",
        value = settings.ESP.ShowKillers,
        callback = function(value)
            settings.ESP.ShowKillers = value
        end,
    })

    espTab:CreateToggle({
        name = "Show Survivors",
        flag = "ShowSurvivors",
        value = settings.ESP.ShowSurvivors,
        callback = function(value)
            settings.ESP.ShowSurvivors = value
        end,
    })

    espTab:CreateToggle({
        name = "Show Generators",
        flag = "ShowGenerators",
        value = settings.ESP.ShowGenerators,
        callback = function(value)
            settings.ESP.ShowGenerators = value
        end,
    })

    espTab:CreateToggle({
        name = "Show Items",
        flag = "ShowItems",
        value = settings.ESP.ShowItems,
        callback = function(value)
            settings.ESP.ShowItems = value
        end,
    })

    espTab:CreateSection({ name = "Advanced Settings", icon = 93364949241311 })
    espTab:CreateToggle({
        name = "Finished Generator Check",
        flag = "FinishedGeneratorCheck",
        value = settings.ESP.IgnoreFinishedGens,
        callback = function(value)
            settings.ESP.IgnoreFinishedGens = value
        end,
    })

    espTab:CreateSection({ name = "Color Settings", icon = 93364949241311 })

    espTab:CreateColorPicker({
        name = "Killer Color",
        flag = "KillerColor",
        color = settings.ESP.Colors.KillerColor,
        alpha = 1 - settings.ESP.Transparencies.KillerTransparency,
        callback = function(color, alpha)
            settings.ESP.Colors.KillerColor = color
            settings.ESP.Transparencies.KillerTransparency = 1 - alpha
        end,
    })

    espTab:CreateColorPicker({
        name = "Survivor Color",
        flag = "SurvivorColor",
        color = settings.ESP.Colors.SurvivorColor,
        alpha = 1 - settings.ESP.Transparencies.SurvivorTransparency,
        callback = function(color, alpha)
            settings.ESP.Colors.SurvivorColor = color
            settings.ESP.Transparencies.SurvivorTransparency = 1 - alpha
        end,
    })

    espTab:CreateColorPicker({
        name = "Generator Color",
        flag = "GeneratorColor",
        color = settings.ESP.Colors.GeneratorColor,
        alpha = 1 - settings.ESP.Transparencies.GeneratorTransparency,
        callback = function(color, alpha)
            settings.ESP.Colors.GeneratorColor = color
            settings.ESP.Transparencies.GeneratorTransparency = 1 - alpha
        end,
    })

    espTab:CreateColorPicker({
        name = "Item Color",
        flag = "ItemColor",
        color = settings.ESP.Colors.ItemColor,
        alpha = 1 - settings.ESP.Transparencies.ItemTransparency,
        callback = function(color, alpha)
            settings.ESP.Colors.ItemColor = color
            settings.ESP.Transparencies.ItemTransparency = 1 - alpha
        end,
    })

    local settingsTab = self.window:CreateTab({ name = "Settings", icon = 93364949241311 })

    settingsTab:CreateSection({ name = "Settings", icon = 93364949241311 })

    settingsTab:CreateToggle({
        name = "Show Watermark",
        flag = "ShowWatermark",
        value = true,
        callback = function(value)
            settings.showWatermark = value
        end,
    })
end

function UI:Unload()
    if self.window then
        self.window:Unload()
        self.window = nil
        self.Rayfield = nil
    end
end


return UI