local Players = game:GetService("Players")
local EffectsController = {}
local Forsaken = getgenv().Forsaken

function EffectsController:Init()
    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    local settings = Forsaken.settings
    local globals = Forsaken.globals
    local connections = Forsaken.connections

    self.settings = settings
    self.globals = globals
    self.connections = connections

    self.Player = Players.LocalPlayer
    self.cachedCharacter = self.Player.Character or nil 
    self.cachedFolder = self.cachedCharacter:FindFirstChild(self.globals.speedModifiersFolder) or nil 
    self.cachedDefaults = {}

    self.connections.EffectsCharacter = self.Player.CharacterAdded:Connect(function(character)
        self.cachedCharacter = character
        self.cachedFolder = self.cachedCharacter:WaitForChild(self.globals.speedModifiersFolder, 20)
    end)
end

function EffectsController:GetSpeedEffects()
    return self.cachedFolder and self.cachedFolder:GetChildren() or {}
end

function EffectsController:Run()
    for _, effect in self:GetSpeedEffects() do
        if effect.Name == self.globals.sprintingSpeedModifier
            and self.settings.Effects.IgnoreSprinting then
            continue
        end

        if effect.Name == self.globals.directionalSpeedModifier
            and self.settings.Effects.IgnoreDirectional then
            continue
        end

        local cached = self.cachedDefaults[effect]

        if not cached then
            if effect.Value == 1 then continue end

            cached = {
                original = effect.Value,
                modified = effect.Value,
            }

            self.cachedDefaults[effect] = cached
        elseif effect.Value ~= cached.modified and effect.Value ~= 1 then
            -- Something else changed the value.
            -- Treat the new value as the game's actual/base value.
            cached.original = effect.Value
        end

        local multiplier
        local result

        if cached.original < 1 then
            multiplier = self.settings.Effects.BuffSlownessRate
            result = math.clamp(
                1 - ((1 - cached.original) * multiplier),
                0,
                1
            )
        else
            multiplier = self.settings.Effects.BuffSpeedRate
            result = cached.original * multiplier
        end

        cached.modified = result
        effect.Value = cached.modified
    end
end

return EffectsController