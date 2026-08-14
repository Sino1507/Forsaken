
if not getgenv().Forsaken.__initialized then
    error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
end

local StaminaController = {}

function StaminaController:Init()
    local Forsaken = getgenv().Forsaken

    local settings = Forsaken.settings
    local globals = Forsaken.globals

    self.settings = settings
    self.globals = globals

    self.sprintingModule = require(globals.sprintingModule)
end

function StaminaController:SetInfiniteStamina(bool)
    self.sprintingModule.StaminaLossDisabled = bool
end

function StaminaController:GetInfiniteStamina()
    return self.sprintingModule.StaminaLossDisabled
end

function StaminaController:Update()
    self:SetInfiniteStamina(self.settings.Stamina.Infinite)
end

function StaminaController:Run()
    if not self.sprintingModule then
        error("Sprinting module is not initialized. Please ensure that the Globals script is loaded before running the StaminaController.")
    end

    if self.settings.Stamina.Infinite ~= self:GetInfiniteStamina() then
        self:Update()
        print("StaminaController: Updated infinite stamina setting to " .. tostring(self.settings.Stamina.Infinite))
    end
end

return StaminaController