local Settings = {}

function Settings.Init()
    local Forsaken = getgenv().Forsaken

    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    local settings = Forsaken.settings

    -- Define settings here
    settings.showWatermark = true
    settings.showWatermarkdebug = false
    settings.autoSave = false

    settings.Stamina = {
        NoDrain = false,
        StaminaDrainRate = 1.0,
        StaminaRecoveryRate = 1.0,
        SprintSpeedMultiplier = 1.0,
        MaxStamina = 100,
    }

    settings.Generator = {
        AutoComplete = false,
        AutoDelay = 4,
        RandomDelay = 0,
    }

    settings.Effects = {
        BuffSlownessRate = 1.0,
        BuffSpeedRate = 1.0,
        IgnoreSprinting = true,
        IgnoreDirectional = false,
    }

    settings.ESP = {
        Enabled = false,
        ShowItems = true,
        ShowKillers = true,
        ShowSurvivors = true,
        ShowGenerators = true,
        IgnoreFinishedGens = false,
        Colors = {
            ItemColor = Color3.new(0, 0, 1), -- Blue
            KillerColor = Color3.new(1, 0, 0), -- Red
            SurvivorColor = Color3.new(0, 1, 0), -- Green
            GeneratorColor = Color3.new(1, 1, 0), -- Yellow
        },
        Transparencies = {
            ItemTransparency = 0.5,
            KillerTransparency = 0.5,
            SurvivorTransparency = 0.8,
            GeneratorTransparency = 0.5,
        },
    }
end

return Settings