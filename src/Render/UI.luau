

local UI = {}

function UI:Init()
    local Forsaken = getgenv().Forsaken

    local Saving = getgenv().Include("Saving/Saving.luau")
    Saving:Init()

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
    Forsaken.globals.window = self.window

    local staminaTab = self.window:CreateTab({ name = "Stamina", icon = 93364949241311 })

    staminaTab:CreateSection({ name = "Stamina", icon = 93364949241311 })

    local noDrainToggle = staminaTab:CreateToggle({
        name = "No Drain",
        flag = "NoDrain",
        value = settings.Stamina.NoDrain,
        callback = function(value)
            settings.Stamina.NoDrain = value
        end,
    })

    staminaTab:CreateKeybind({
        name = "No Drain Keybind",
        flag = "NoDrainKeybind",
        value = Enum.KeyCode.X,
        callback = function(key)
            noDrainToggle:Set(settings.Stamina.NoDrain)
        end,
    })

    staminaTab:CreateSection({ name = "Advanced", icon = 93364949241311 })

    local drainSlider = staminaTab:CreateSlider({
        name = "Stamina Drain Rate",
        flag = "StaminaDrainRate",
        range = { 0, 200 },
        increment = 5,
        value = settings.Stamina.StaminaDrainRate * 100,
        suffix = "%",
        callback = function(value)
            settings.Stamina.StaminaDrainRate = value / 100
        end,
    })

    local recoverySlider = staminaTab:CreateSlider({
        name = "Stamina Recovery Rate",
        flag = "StaminaRecoveryRate",
        range = { 0, 200 },
        increment = 5,
        value = settings.Stamina.StaminaRecoveryRate * 100,
        suffix = "%",
        callback = function(value)
            settings.Stamina.StaminaRecoveryRate = value / 100
        end,
    })

    local speedSlider = staminaTab:CreateSlider({
        name = "Sprint Speed Multiplier",
        flag = "SprintSpeedMultiplier",
        range = { 10, 200 },
        increment = 5,
        value = settings.Stamina.SprintSpeedMultiplier * 100,
        suffix = "%",
        callback = function(value)
            settings.Stamina.SprintSpeedMultiplier = value / 100
        end,
    })

    local maxInput = staminaTab:CreateInput({
        name = "Max Stamina",
        flag = "MaxStamina",
        numeric = true,
        value = tostring(settings.Stamina.MaxStamina),
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

    local presetsDropDownStamina = staminaTab:CreateDropdown({
        name = "Presets",
        flag = "StaminaPresets",
        multiSelect = false,
        options = { "Default", "Legit", "Balanced", "Semi-Legit", "Blatant" },
        placeholder = "Custom",
        callback = function(selected)
            if selected == "Default" then 
                drainSlider:Set(100)
                recoverySlider:Set(100)
                speedSlider:Set(100)
                maxInput:Set("100")
            elseif selected == "Legit" then
                drainSlider:Set(90)
                recoverySlider:Set(105)
                speedSlider:Set(100)
                maxInput:Set("100")
            elseif selected == "Balanced" then 
                drainSlider:Set(80)
                recoverySlider:Set(110)
                speedSlider:Set(100)
                maxInput:Set("100")
            elseif selected == "Semi-Legit" then 
                drainSlider:Set(70)
                recoverySlider:Set(120)
                speedSlider:Set(100)
                maxInput:Set("100")
            elseif selected == "Blatant" then 
                drainSlider:Set(50)
                recoverySlider:Set(150)
                speedSlider:Set(110)
                maxInput:Set("100")
            end

            self.window:Toast({ title = "Preset Applied", position = "Bottom", icon = 125823673784681 })
        end,
    })

    presetsDropDownStamina:MoveToTop()

    local effectsTab = self.window:CreateTab({ name = "Effects", icon = 93364949241311 })

    effectsTab:CreateSection({ name = "Effects", icon = 93364949241311 })

    local buffSlownessSlider = effectsTab:CreateSlider({
        name = "Modiefied Slowness",
        flag = "BuffSlownessRate",
        range = { 0, 200 },
        increment = 5,
        value = settings.Effects.BuffSlownessRate * 100,
        suffix = "%",
        callback = function(value)
            settings.Effects.BuffSlownessRate = value / 100
        end,
    })

    local buffSpeedSlider = effectsTab:CreateSlider({
        name = "Modified Speed",
        flag = "BuffSpeedRate",
        range = { 10, 200 },
        increment = 5,
        value = settings.Effects.BuffSpeedRate * 100,
        suffix = "%",
        callback = function(value)
            settings.Effects.BuffSpeedRate = value / 100
        end,
    })

    effectsTab:CreateSection({ name = "Advanced", icon = 93364949241311 })

    local ignoreSprintingBuff = effectsTab:CreateToggle({
        name = "Ignore Sprinting Buff",
        flag = "IgnoreSprinting",
        value = settings.Effects.IgnoreSprinting,
        callback = function(value)
            settings.Effects.IgnoreSprinting = value
        end,
    })

    local ignoreDirectionalDebuff = effectsTab:CreateToggle({
        name = "Ignore Directional Debuff",
        flag = "IgnoreDirectional",
        value = settings.Effects.IgnoreDirectional,
        callback = function(value)
            settings.Effects.IgnoreDirectional = value
        end,
    })

    local presetsDropDownEffects = effectsTab:CreateDropdown({
        name = "Presets",
        flag = "EffectsPresets",
        multiSelect = false,
        options = { "Default", "Legit", "Balanced", "Semi-Legit", "Blatant" },
        placeholder = "Custom",
        callback = function(selected)
            if selected == "Default" then 
                buffSlownessSlider:Set(100)
                buffSpeedSlider:Set(100)
                ignoreSprintingBuff:Set(true)
                ignoreDirectionalDebuff:Set(false)
            elseif selected == "Legit" then
                buffSlownessSlider:Set(90)
                buffSpeedSlider:Set(100)
                ignoreSprintingBuff:Set(true)
                ignoreDirectionalDebuff:Set(true)
            elseif selected == "Balanced" then 
                buffSlownessSlider:Set(90)
                buffSpeedSlider:Set(110)
                ignoreSprintingBuff:Set(true)
                ignoreDirectionalDebuff:Set(true)
            elseif selected == "Semi-Legit" then 
                buffSlownessSlider:Set(80)
                buffSpeedSlider:Set(110)
                ignoreSprintingBuff:Set(true)
                ignoreDirectionalDebuff:Set(false)
            elseif selected == "Blatant" then 
                buffSlownessSlider:Set(70)
                buffSpeedSlider:Set(130)
                ignoreSprintingBuff:Set(false)
                ignoreDirectionalDebuff:Set(false)
            end

            self.window:Toast({ title = "Preset Applied", position = "Bottom", icon = 125823673784681 })
        end,
    })

    presetsDropDownEffects:MoveToTop()

    local generatorTab = self.window:CreateTab({ name = "Generator", icon = 93364949241311 })

    generatorTab:CreateSection({ name = "Generator", icon = 93364949241311 })

    generatorTab:CreateToggle({
        name = "Auto Complete",
        flag = "AutoCompleteGenerator",
        value = settings.Generator.AutoComplete,
        callback = function(value)
            settings.Generator.AutoComplete = value
        end,
    })

    local autoDelayGenerator = generatorTab:CreateSlider({
        name = "Auto Delay",
        flag = "AutoGeneratorDelay",
        range = { 0, 5 },
        increment = 0.5,
        value = settings.Generator.AutoDelay,
        suffix = "s",
        callback = function(value)
            settings.Generator.AutoDelay = value
        end,
    })

    local randomDelayGenerator = generatorTab:CreateSlider({
        name = "+ Random Delay",
        flag = "AutoGeneratorRandomDelay",
        range = { 0, 20 },
        increment = 0.5,
        value = settings.Generator.RandomDelay,
        suffix = "s",
        callback = function(value)
            settings.Generator.RandomDelay = value
        end,
    })

    local presetsDropDownGenerator = generatorTab:CreateDropdown({
        name = "Presets",
        flag = "GeneratorPresets",
        multiSelect = false,
        options = { "Default", "Legit", "Balanced", "Semi-Legit", "Blatant" },
        placeholder = "Custom",
        callback = function(selected)
            if selected == "Default" then 
                autoDelayGenerator:Set(4)
                randomDelayGenerator:Set(0)
            elseif selected == "Legit" then
                autoDelayGenerator:Set(3)
                randomDelayGenerator:Set(4)
            elseif selected == "Balanced" then 
                autoDelayGenerator:Set(3)
                randomDelayGenerator:Set(2.5)
            elseif selected == "Semi-Legit" then 
                autoDelayGenerator:Set(2.5)
                randomDelayGenerator:Set(2.5)
            elseif selected == "Blatant" then 
                autoDelayGenerator:Set(1)
                randomDelayGenerator:Set(2)
            end

            self.window:Toast({ title = "Preset Applied", position = "Bottom", icon = 125823673784681 })
        end,
    })

    presetsDropDownGenerator:MoveToTop()

    local infoTab = self.window:CreateTab({ name = "Information", icon = 93364949241311 })

    infoTab:CreateToggle({
        name = "Notify Me",
        flag = "NotifyMeInfo",
        value = settings.ExtraInfo.NotifyMe,
        callback = function(value)
            settings.ExtraInfo.NotifyMe = value
        end,
    })

    infoTab:CreateSection({ name = "Information", icon = 93364949241311 })

    infoTab:CreateToggle({
        name = "Slateskin Timer",
        flag = "SlateskinTimer",
        value = settings.ExtraInfo.SlateSkinTimer,
        callback = function(value)
            settings.ExtraInfo.SlateSkinTimer = value
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

    espTab:CreateToggle({
        name = "Health Mapped Colors",
        flag = "HealthMappedColors",
        value = settings.ESP.Colors.UseHealthSuvivors,
        callback = function(value)
            settings.ESP.Colors.UseHealthSuvivors = value
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
        value = settings.showWatermark,
        callback = function(value)
            settings.showWatermark = value
        end,
    })

    settingsTab:CreateToggle({
        name = "Show Watermark Debug",
        flag = "ShowWatermarkDebug",
        value = settings.showWatermarkdebug,
        callback = function(value)
            settings.showWatermarkdebug = value
        end,
    })


    settingsTab:CreateSection({ name = "Save", icon = 93364949241311 })

    settingsTab:CreateToggle({
        name = "Auto Save",
        flag = "AutoSave",
        value = settings.autoSave,
        callback = function(value)
            settings.autoSave = value
        end,
    })

    settingsTab:CreateButton({
        name = "Save",
        callback = function()
            Saving:Save()
        end,
    })

    settingsTab:CreateButton({
        name = "Delete",
        callback = function()
            Saving:Delete()
        end,
    })

    settingsTab:CreateSection({ name = "Unload", icon = 93364949241311 })

    settingsTab:CreateButton({
        name = "Unload",
        callback = function()
            Forsaken.Unload()
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