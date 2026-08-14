
local StaminaController = {}

function StaminaController:Init()
    local Forsaken = getgenv().Forsaken

    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    local settings = Forsaken.settings
    local globals = Forsaken.globals

    self.settings = settings
    self.globals = globals

    self.sprintingModule = require(globals.sprintingModule)
    self.DefaultStaminaLoss = self.sprintingModule.StaminaLoss
    self.DefaultStaminaGain = self.sprintingModule.StaminaGain
    self.DefaultSprintSpeed = self.sprintingModule.SprintSpeed
    self.DefaultMaxStamina = self.sprintingModule.MaxStamina
end

function StaminaController:SetInfiniteStamina(bool)
    self.sprintingModule.StaminaLossDisabled = bool
end

function StaminaController:GetInfiniteStamina()
    return self.sprintingModule.StaminaLossDisabled
end

function StaminaController:Update()
    if self.settings.Stamina.NoDrain ~= self:GetInfiniteStamina() then
        self:SetInfiniteStamina(self.settings.Stamina.NoDrain)
    end

    self.sprintingModule.StaminaLoss = self.DefaultStaminaLoss * self.settings.Stamina.StaminaDrainRate
    self.sprintingModule.StaminaGain = self.DefaultStaminaGain * self.settings.Stamina.StaminaRecoveryRate
    self.sprintingModule.SprintSpeed = self.DefaultSprintSpeed * self.settings.Stamina.SprintSpeedMultiplier
    self.sprintingModule.MaxStamina = self.settings.Stamina.MaxStamina
end

function StaminaController:Run()
    if not self.sprintingModule then
        error("Sprinting module is not initialized. Please ensure that the Globals script is loaded before running the StaminaController.")
    end

    self:Update()
end

function StaminaController:Unload()
    if self.sprintingModule then
        self.sprintingModule.StaminaLossDisabled = false
        self.sprintingModule.StaminaLoss = self.DefaultStaminaLoss
        self.sprintingModule.StaminaGain = self.DefaultStaminaGain
        self.sprintingModule.SprintSpeed = self.DefaultSprintSpeed
        self.sprintingModule.MaxStamina = self.DefaultMaxStamina
    end
end

return StaminaController