-- Script Path: game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting
-- Took 0.02s to decompile.
-- Executor: Volt (1.3.7.0)

local tbl_upv_1 = {}
tbl_upv_1.timeUntilStaminaRecovers = 0
tbl_upv_1.StaminaFreezeLocks = {}
tbl_upv_1.DefaultConfig = {StaminaLossDisabled = false, IsSprinting = false, BindsEnabled = true, SprintSpeed = 26, MaxStamina = 100, isSpeedLocked = false, StaminaGain = 20, StaminaLoss = 10, MinStamina = 0}
local DataHandler_upv_1 = require(game.ReplicatedStorage.Modules.Data.DataHandler)
local TweenService_upv_1 = game:GetService("TweenService")
local Network_upv_1 = require(game.ReplicatedStorage.Modules.Network.Network)
function tbl_upv_1.ChangeStat(a1, a2, a3)
    --[[
      name: ChangeStat
      line: 26
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if not tbl_upv_1[a2] then
        return
    end
    tbl_upv_1[a2] = a3
end
function tbl_upv_1.CanRegenStamina(a1)
    --[[
      name: CanRegenStamina
      line: 32
    ]]
    return a1.timeUntilStaminaRecovers <= 0
end
function tbl_upv_1.SetStaminaFrozen(a1, a2, a3)
    --[[
      name: SetStaminaFrozen
      line: 37
    ]]
    if a3 then
        a1.StaminaFreezeLocks[a2] = true
    else
        a1.StaminaFreezeLocks[a2] = nil
    end
end
function tbl_upv_1.IsStaminaFrozen(a1)
    --[[
      name: IsStaminaFrozen
      line: 45
    ]]
    local v1 = next(a1.StaminaFreezeLocks) ~= nil
    return v1
end
function tbl_upv_1.Toggle(a1, a2)
    --[[
      name: Toggle
      line: 49
      upvalues:
        tbl_upv_1 (copy, index: 1)
        Network_upv_1 (copy, index: 2)
        TweenService_upv_1 (copy, index: 3)
    ]]
    local Character_1 = game.Players.LocalPlayer.Character
    local v2 = Character_1 and (Character_1:FindFirstChild("Humanoid"))
    if not v2 then
        return
    end
    if tbl_upv_1.__currentSpeedTween then
        tbl_upv_1.__currentSpeedTween:Cancel()
        tbl_upv_1.__currentSpeedTween = nil
    end
    if tbl_upv_1.__currentFOVTween then
        tbl_upv_1.__currentFOVTween:Cancel()
        tbl_upv_1.__currentFOVTween = nil
    end
    if a2 then
        local v3 = Character_1:GetAttribute("FootstepsMuted")
        if not (v3) then
            Network_upv_1:FireServerConnection("FootSP", "UREMOTE_EVENT", 1)
        end
        local tbl_2 = {Value = 1.125}
        tbl_upv_1.__currentFOVTween = TweenService_upv_1:Create(tbl_upv_1.__FOVMultiplier, TweenInfo.new(0.75), tbl_2)
        tbl_upv_1.__currentFOVTween:Play()
        if not (tbl_upv_1.isSpeedLocked) then
            tbl_upv_1.__currentSpeedTween = TweenService_upv_1:Create(tbl_upv_1.__speedMultiplier, TweenInfo.new(0.75), {Value = tbl_upv_1.SprintSpeed / (Character_1:GetAttribute("BaseSpeed") or 16)})
            tbl_upv_1.__currentSpeedTween:Play()
            return
        end
    else
        local tbl_3 = {Value = 1}
        tbl_upv_1.__currentFOVTween = TweenService_upv_1:Create(tbl_upv_1.__FOVMultiplier, TweenInfo.new(0.75), tbl_3)
        tbl_upv_1.__currentFOVTween:Play()
        if not (tbl_upv_1.isSpeedLocked) then
            local tbl_4 = {Value = 1}
            tbl_upv_1.__currentSpeedTween = TweenService_upv_1:Create(tbl_upv_1.__speedMultiplier, TweenInfo.new(0.75), tbl_4)
            tbl_upv_1.__currentSpeedTween:Play()
        end
    end
end
function tbl_upv_1.Resync(a1)
    --[[
      name: Resync
      line: 90
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    tbl_upv_1:Toggle(tbl_upv_1.IsSprinting)
end
function tbl_upv_1.Init(a1)
    --[[
      name: Init
      line: 95
      upvalues:
        tbl_upv_1 (copy, index: 1)
        DataHandler_upv_1 (copy, index: 2)
        Network_upv_1 (copy, index: 3)
    ]]
    local LocalPlayer_1 = game.Players.LocalPlayer
    local Character_upv_2 = LocalPlayer_1.Character
    local _ = Character_upv_2:WaitForChild("Humanoid")
    for key_1, value_1 in pairs(tbl_upv_1.DefaultConfig) do
        tbl_upv_1[key_1] = value_1
    end
    tbl_upv_1.StaminaCap = nil
    tbl_upv_1.StaminaLossDisabled = false
    table.clear(tbl_upv_1.StaminaFreezeLocks)
    tbl_upv_1.DefaultsSet = true
    tbl_upv_1.__sprintedEvent = Instance.new("BindableEvent")
    tbl_upv_1.__staminaChangedEvent = Instance.new("BindableEvent")
    tbl_upv_1.__speedMultiplier = Instance.new("NumberValue")
    tbl_upv_1.__speedMultiplier.Value = 1
    tbl_upv_1.__speedMultiplier.Name = "Sprinting"
    tbl_upv_1.__speedMultiplier.Parent = Character_upv_2:WaitForChild("SpeedMultipliers", 10)
    tbl_upv_1.__FOVMultiplier = Instance.new("NumberValue")
    tbl_upv_1.__FOVMultiplier.Value = 1
    tbl_upv_1.__FOVMultiplier.Name = "Sprinting"
    tbl_upv_1.__FOVMultiplier.Parent = Character_upv_2:WaitForChild("FOVMultipliers", 10)
    tbl_upv_1.CanSprint = true
    tbl_upv_1.SprintToggled = tbl_upv_1.__sprintedEvent.Event
    tbl_upv_1.StaminaChanged = tbl_upv_1.__staminaChangedEvent.Event
    tbl_upv_1.Stamina = tbl_upv_1.MaxStamina
    tbl_upv_1.SprintToggled:Connect(
        function(a2)
            --[[
              line: 131
              upvalues:
                tbl_upv_1 (copy, index: 1)
            ]]
            tbl_upv_1:Toggle(a2)
        end
    )
    tbl_upv_1.timeUntilStaminaRecovers = 0
    task.spawn(
        function()
            --[[
              line: 168
              upvalues:
                Character_upv_2 (copy, index: 1)
                tbl_upv_1 (copy, index: 2)
            ]]
            while true do
                local v4 = game["Run Service"].Heartbeat:Wait()
                if not (Character_upv_2.Parent) then
                    break
                end
                if not Character_upv_2.PrimaryPart then
                    return
                end
                if tbl_upv_1:IsStaminaFrozen() then
                    continue
                end
                if tbl_upv_1.IsSprinting and tbl_upv_1.MinStamina < tbl_upv_1.Stamina and Character_upv_2.PrimaryPart.Velocity.Magnitude > 0.4 and Character_upv_2.PrimaryPart.Anchored ~= true and tbl_upv_1.CanSprint then
                    if tbl_upv_1.StaminaLossDisabled or Character_upv_2.Parent.Name == "Spectating" then
                        if tbl_upv_1.StaminaLossDisabled or not tbl_upv_1.IsSprinting then
                            tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers - v4, 0, 3)
                            if Character_upv_2:GetAttribute("StaminaPenaltyActive") then
                                if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                                    continue
                                end
                                Character_upv_2:SetAttribute("StaminaPenaltyActive", nil)
                            end
                            if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                                continue
                            end
                            if not (Character_upv_2:GetAttribute("AbilityStaminaOverride")) then
                                tbl_upv_1.Stamina = math.clamp(tbl_upv_1.Stamina + (tbl_upv_1.StaminaGain * v4), tbl_upv_1.MinStamina, tbl_upv_1.StaminaCap or (tbl_upv_1.MaxStamina))
                                tbl_upv_1.__staminaChangedEvent:Fire(tbl_upv_1.Stamina)
                                continue
                            end
                        elseif Character_upv_2.PrimaryPart.Velocity.Magnitude <= 0.4 then
                            tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers - v4, 0, 3)
                            if Character_upv_2:GetAttribute("StaminaPenaltyActive") then
                                if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                                    continue
                                end
                                Character_upv_2:SetAttribute("StaminaPenaltyActive", nil)
                            end
                            if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                                continue
                            end
                            if not (Character_upv_2:GetAttribute("AbilityStaminaOverride")) then
                                tbl_upv_1.Stamina = math.clamp(tbl_upv_1.Stamina + (tbl_upv_1.StaminaGain * v4), tbl_upv_1.MinStamina, tbl_upv_1.StaminaCap or (tbl_upv_1.MaxStamina))
                                tbl_upv_1.__staminaChangedEvent:Fire(tbl_upv_1.Stamina)
                                continue
                            end
                        else
                            if Character_upv_2.PrimaryPart.Anchored ~= true then
                                continue
                            end
                            if tbl_upv_1.Stamina < tbl_upv_1.MaxStamina or tbl_upv_1.StaminaCap and tbl_upv_1.StaminaCap < tbl_upv_1.Stamina then
                                tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers - v4, 0, 3)
                                if Character_upv_2:GetAttribute("StaminaPenaltyActive") then
                                    if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                                        continue
                                    end
                                    Character_upv_2:SetAttribute("StaminaPenaltyActive", nil)
                                end
                                if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                                    continue
                                end
                                if not (Character_upv_2:GetAttribute("AbilityStaminaOverride")) then
                                    tbl_upv_1.Stamina = math.clamp(tbl_upv_1.Stamina + (tbl_upv_1.StaminaGain * v4), tbl_upv_1.MinStamina, tbl_upv_1.StaminaCap or (tbl_upv_1.MaxStamina))
                                    tbl_upv_1.__staminaChangedEvent:Fire(tbl_upv_1.Stamina)
                                    continue
                                end
                            end
                        end
                    else
                        tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers + (v4 * 0.05), 0.2, 3)
                        tbl_upv_1.Stamina = math.clamp(tbl_upv_1.Stamina - (tbl_upv_1.StaminaLoss * v4), tbl_upv_1.MinStamina, tbl_upv_1.StaminaCap or (tbl_upv_1.MaxStamina))
                        tbl_upv_1.__staminaChangedEvent:Fire(tbl_upv_1.Stamina)
                        if tbl_upv_1.Stamina <= tbl_upv_1.MinStamina then
                            tbl_upv_1.IsSprinting = false
                            tbl_upv_1.__sprintedEvent:Fire(false)
                            tbl_upv_1.timeUntilStaminaRecovers = 2
                            Character_upv_2:SetAttribute("StaminaPenaltyActive", true)
                            continue
                        end
                    end
                elseif tbl_upv_1.StaminaLossDisabled or not tbl_upv_1.IsSprinting then
                    tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers - v4, 0, 3)
                    if Character_upv_2:GetAttribute("StaminaPenaltyActive") then
                        if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                            continue
                        end
                        Character_upv_2:SetAttribute("StaminaPenaltyActive", nil)
                    end
                    if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                        continue
                    end
                    if not (Character_upv_2:GetAttribute("AbilityStaminaOverride")) then
                        tbl_upv_1.Stamina = math.clamp(tbl_upv_1.Stamina + (tbl_upv_1.StaminaGain * v4), tbl_upv_1.MinStamina, tbl_upv_1.StaminaCap or (tbl_upv_1.MaxStamina))
                        tbl_upv_1.__staminaChangedEvent:Fire(tbl_upv_1.Stamina)
                        continue
                    end
                elseif Character_upv_2.PrimaryPart.Velocity.Magnitude <= 0.4 then
                    tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers - v4, 0, 3)
                    if Character_upv_2:GetAttribute("StaminaPenaltyActive") then
                        if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                            continue
                        end
                        Character_upv_2:SetAttribute("StaminaPenaltyActive", nil)
                    end
                    if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                        continue
                    end
                    if not (Character_upv_2:GetAttribute("AbilityStaminaOverride")) then
                        tbl_upv_1.Stamina = math.clamp(tbl_upv_1.Stamina + (tbl_upv_1.StaminaGain * v4), tbl_upv_1.MinStamina, tbl_upv_1.StaminaCap or (tbl_upv_1.MaxStamina))
                        tbl_upv_1.__staminaChangedEvent:Fire(tbl_upv_1.Stamina)
                        continue
                    end
                else
                    if Character_upv_2.PrimaryPart.Anchored ~= true then
                        continue
                    end
                    if tbl_upv_1.Stamina < tbl_upv_1.MaxStamina or tbl_upv_1.StaminaCap and tbl_upv_1.StaminaCap < tbl_upv_1.Stamina then
                        tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers - v4, 0, 3)
                        if Character_upv_2:GetAttribute("StaminaPenaltyActive") then
                            if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                                continue
                            end
                            Character_upv_2:SetAttribute("StaminaPenaltyActive", nil)
                        end
                        if tbl_upv_1.timeUntilStaminaRecovers > 0 then
                            continue
                        end
                        if not (Character_upv_2:GetAttribute("AbilityStaminaOverride")) then
                            tbl_upv_1.Stamina = math.clamp(tbl_upv_1.Stamina + (tbl_upv_1.StaminaGain * v4), tbl_upv_1.MinStamina, tbl_upv_1.StaminaCap or (tbl_upv_1.MaxStamina))
                            tbl_upv_1.__staminaChangedEvent:Fire(tbl_upv_1.Stamina)
                            continue
                        end
                    end
                end
            end
        end
    )
    local tbl_5 = {}
    local v5 = DataHandler_upv_1:ReadPath("Settings/Keybinds")
    for v8, value_2 in pairs({v5.Sprinting.Value, v5["Sprinting~Console"].Value}) do
        for v9, value_3 in pairs(Enum.KeyCode:GetEnumItems()) do
            if value_3.Name == value_2 then
                table.insert(tbl_5, value_3)
                break
            end
        end
        for v10, value_4 in pairs(Enum.UserInputType:GetEnumItems()) do
            if value_4.Name == value_2 then
                table.insert(tbl_5, value_4)
                break
            end
        end
    end
    local function sprint(a3, a4)
        --[[
          name: sprint
          line: 137
          upvalues:
            tbl_upv_1 (copy, index: 1)
        ]]
        if not tbl_upv_1.CanSprint or not tbl_upv_1.BindsEnabled then
            return
        end
        if require(game.ReplicatedStorage.Modules.Utilities.Device):GetPlayerDevice() == "Mobile" then
            if a4 ~= Enum.UserInputState.Begin then
                return
            end
            local v6 = ((tbl_upv_1.IsSprinting) and (Enum.UserInputState.End)) or (Enum.UserInputState.Begin)
            a4 = v6
        end
        if a4 == Enum.UserInputState.Begin and tbl_upv_1.MinStamina < tbl_upv_1.Stamina and not (tbl_upv_1.IsSprinting) then
            tbl_upv_1.IsSprinting = true
            tbl_upv_1.__sprintedEvent:Fire(true)
            return
        end
        if tbl_upv_1.IsSprinting then
            tbl_upv_1.IsSprinting = false
            tbl_upv_1.__sprintedEvent:Fire(false)
            if tbl_upv_1.timeUntilStaminaRecovers <= 0.1 then
                tbl_upv_1.timeUntilStaminaRecovers = 0.1
            else
                tbl_upv_1.timeUntilStaminaRecovers = math.clamp(tbl_upv_1.timeUntilStaminaRecovers + 0.1, 0, 3)
                return
            end
        end
    end
    game.ContextActionService:BindActionAtPriority("Sprinting", sprint, false, 10000, unpack(tbl_5))
    if not (tbl_upv_1.MobileButton) then
        local u1 = script.SprintingButton:Clone()
        u1.Parent = LocalPlayer_1.PlayerGui:WaitForChild("MainUI")
        local Device_upv_1 = require(game.ReplicatedStorage.Modules.Utilities.Device)
        u1.Visible = Device_upv_1:GetPlayerDevice() == "Mobile"
        local function toggleButton()
            --[[
              name: toggleButton
              line: 256
              upvalues:
                Device_upv_1 (copy, index: 1)
                u1 (copy, index: 2)
            ]]
            u1.Visible = Device_upv_1:GetPlayerDevice() == "Mobile"
        end
        Device_upv_1.Changed:Connect(toggleButton)
        tbl_upv_1.MobileButton = u1
    end
    if tostring(LocalPlayer_1.Character.Parent) == "Spectating" and tbl_upv_1.MobileButton then
        tbl_upv_1.MobileButton.AnchorPoint = Vector2.new(0, 0)
        tbl_upv_1.MobileButton.Position = UDim2.new(1, -250, 1, -135)
        tbl_upv_1.MobileButton.Size = UDim2.fromOffset(83, 83)
    end
    if tbl_upv_1.CurrentButtonConnection1 then
        tbl_upv_1.CurrentButtonConnection1:Disconnect()
    end
    tbl_upv_1.CurrentButtonConnection1 = tbl_upv_1.MobileButton.MouseButton1Down:Connect(
        function()
            --[[
              line: 276
              upvalues:
                tbl_upv_1 (copy, index: 1)
                sprint (copy, index: 2)
            ]]
            tbl_upv_1.MobileButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
            sprint("Sprinting", Enum.UserInputState.Begin)
        end
    )
    if tbl_upv_1.CurrentButtonConnection2 then
        tbl_upv_1.CurrentButtonConnection2:Disconnect()
    end
    tbl_upv_1.CurrentButtonConnection2 = tbl_upv_1.MobileButton.MouseButton1Up:Connect(
        function()
            --[[
              line: 282
              upvalues:
                tbl_upv_1 (copy, index: 1)
                sprint (copy, index: 2)
            ]]
            tbl_upv_1.MobileButton.ImageColor3 = Color3.new(1, 1, 1)
            sprint("Sprinting", Enum.UserInputState.End)
        end
    )
    local tbl_upv_6 = {}
    local function toggleSprintingDisabled(a5, a6)
        --[[
          name: toggleSprintingDisabled
          line: 290
          upvalues:
            tbl_upv_6 (copy, index: 1)
            tbl_upv_1 (copy, index: 2)
        ]]
        tbl_upv_6[a5] = a6
        local v9 = true
        for _, value_5 in pairs(tbl_upv_6) do
            if value_5 == true then
                v9 = false
                break
            end
        end
        tbl_upv_1.CanSprint = v9
        if (v9) or not tbl_upv_1.IsSprinting then
            return
        end
        tbl_upv_1.IsSprinting = false
        tbl_upv_1.__sprintedEvent:Fire(false)
    end
    Network_upv_1:SetConnection("DisableSprinting", "BINDABLE_EVENT", toggleSprintingDisabled)
    Network_upv_1:SetConnection("DisableSprintingSV", "REMOTE_EVENT", toggleSprintingDisabled)
    Network_upv_1:SetConnection(
        "GrantStamina",
        "REMOTE_EVENT",
        function(a7)
            --[[
              line: 315
              upvalues:
                tbl_upv_1 (copy, index: 1)
            ]]
            tbl_upv_1.Stamina = math.min(tbl_upv_1.Stamina + a7, tbl_upv_1.MaxStamina)
        end
    )
    tbl_upv_1.Character = Character_upv_2
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 324
      upvalues:
        Network_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    Network_upv_1:RemoveConnection("DisableSprinting", "REMOTE_EVENT")
    Network_upv_1:RemoveConnection("DisableSprintingSV", "BINDABLE_EVENT")
    Network_upv_1:RemoveConnection("GrantStamina", "REMOTE_EVENT")
    tbl_upv_1.__sprintedEvent:Destroy()
    tbl_upv_1.__staminaChangedEvent:Destroy()
    tbl_upv_1.__speedMultiplier:Destroy()
    tbl_upv_1.__FOVMultiplier:Destroy()
end
return tbl_upv_1
