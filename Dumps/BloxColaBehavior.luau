-- Script Path: game:GetService("ReplicatedStorage").Assets.Items.BloxyCola.Behavior
-- Took 0.02s to decompile.
-- Executor: Volt (1.3.7.0)

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local RunService_1 = game:GetService("RunService")
local Trove_upv_1 = require(game:GetService("ReplicatedStorage").Modules.Utilities.Trove)
local Util_upv_1 = require(game.ReplicatedStorage.Modules.Utilities.Util)
local u1 = RunService_1:IsClient()
local u2 = RunService_1:IsServer()
function tbl_upv_1.Created(a1)
    --[[
      name: Created
      line: 16
    ]]
end
function tbl_upv_1.Destroyed(a1)
    --[[
      name: Destroyed
      line: 23
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    tbl_upv_1.Unequipped(a1)
end
function tbl_upv_1.Equipped(a1)
    --[[
      name: Equipped
      line: 28
    ]]
end
function tbl_upv_1.Unequipped(a1, a2)
    --[[
      name: Unequipped
      line: 32
      upvalues:
        u2 (copy, index: 1)
        u1 (copy, index: 2)
    ]]
    local v1 = require(game.ReplicatedStorage.Modules.Gameplay.Actors).CurrentActors[a1.Player]
    if v1 and u2 and not (a2) then
        v1:ChangeExpression("Default")
    end
    if a1.__internalTrove then
        a1.__internalTrove:Destroy()
        a1.__internalTrove = nil
    end
    if a1.SpeedMultiplier then
        a1.SpeedMultiplier:Destroy()
        a1.SpeedMultiplier = nil
    end
    if u1 then
        require(game.ReplicatedStorage.Modules.Network.Network):FireConnection("DisableSprinting", "BloxyColaItem", false)
        a1.Animations.Activated:Stop()
        a1.Animations.Activated2:Stop()
    end
    a1.Cooldown = nil
    if a1.Threads and not (a1.Completed) then
        for _, value_1 in pairs(a1.Threads) do
            task.cancel(value_1)
        end
        a1.Threads = nil
    end
    if not a1.SFX then
        return
    end
    a1.SFX:Destroy()
    a1.SFX = nil
end
function tbl_upv_1.Activated(a1)
    --[[
      name: Activated
      line: 78
      upvalues:
        u1 (copy, index: 1)
        Util_upv_1 (copy, index: 2)
        Trove_upv_1 (copy, index: 3)
        tbl_upv_1 (copy, index: 4)
    ]]
    if a1.Threads then
        return
    end
    local Player_1 = a1.Player
    if not Player_1 then
        return
    end
    local Character_upv_1 = Player_1.Character
    if not Character_upv_1 then
        return
    end
    local v2 = Character_upv_1:FindFirstChildOfClass("Humanoid")
    if not v2 then
        return
    end
    if Character_upv_1:GetAttribute("NoItems") then
        if not u1 then
            return
        end
        Util_upv_1:CreateWarning("BloxyNope", "You can't use this right now.")
    else
        a1.Cooldown = true
        local v3 = Trove_upv_1.new()
        a1.__internalTrove = v3
        local u3 = v2.Health
        v3:Connect(
            v2.HealthChanged,
            function(a2)
                --[[
                  line: 108
                  upvalues:
                    u3 (ref,  index: 1)
                    tbl_upv_1 (copy, index: 2)
                    a1 (copy, index: 3)
                ]]
                if a2 >= u3 then
                    u3 = a2
                else
                    tbl_upv_1.Unequipped(a1, true)
                end
            end
        )
        v3:Connect(
            Character_upv_1:GetAttributeChangedSignal("NoItems"),
            function()
                --[[
                  line: 116
                  upvalues:
                    Character_upv_1 (copy, index: 1)
                    tbl_upv_1 (copy, index: 2)
                    a1 (copy, index: 3)
                ]]
                if not Character_upv_1:GetAttribute("NoItems") then
                    return
                end
                tbl_upv_1.Unequipped(a1, true)
            end
        )
        if game["Run Service"]:IsServer() then
            a1.SFX = require(game.ReplicatedStorage.Modules.Rendering.Sounds):Play(a1.Config.Sounds.Drinking, {Parent = Character_upv_1:FindFirstChild("Head")})
            a1.Threads = {
                task.delay(
                    1,
                    function()
                        --[[
                          line: 129
                          upvalues:
                            a1 (copy, index: 1)
                        ]]
                        local v4 = require(game.ReplicatedStorage.Modules.Gameplay.Actors).CurrentActors[a1.Player]
                        if not v4 then
                            return
                        end
                        v4:ChangeExpression("Drinking", 1.2)
                    end
                ),
                task.delay(
                    a1.Config.DrinkTime,
                    function()
                        --[[
                          line: 138
                          upvalues:
                            a1 (copy, index: 1)
                        ]]
                        a1.Completed = true
                        local CurrentSession_1 = require(game.ServerScriptService.Server.Systems.Core.RoundManager).CurrentSession
                        local v5 = CurrentSession_1 and (CurrentSession_1.LastSurvivorAlive)
                        local Config_1 = a1.Config
                        local v6 = "SpeedLevel%*"
                        local v7
                        if v5 then
                            v7 = "LMS"
                        else
                            v7 = ""
                        end
                        local v8 = Config_1[v6:format(v7)]
                        local Actors_1 = require(game.ReplicatedStorage.Modules.Gameplay.Actors)
                        local Player_2 = a1.Player and (Actors_1.CurrentActors[a1.Player])
                        local AchievementUtil_1 = require(game.ReplicatedStorage.Modules.Data.AchievementUtil)
                        if Player_2 then
                            if Player_2.Config and Player_2.Behavior and Player_2.Behavior.Abilities and Player_2.Behavior.Abilities.BloxyCola and Player_2.Cooldowns.BloxyCola and Player_2.Config.BloxyColaCooldown - a1.Config.StackingThreshold < Player_2:IsOnCooldown("BloxyCola") then
                                AchievementUtil_1:IncrementAchievementProgress(a1.Player, "NoobCola")
                            end
                            if Player_2.LastDrankCola and tick() - Player_2.LastDrankCola < a1.Config.StackingThreshold and Player_2.Rig.Name == "Noob" then
                                AchievementUtil_1:IncrementAchievementProgress(a1.Player, "NoobCola")
                            end
                            Player_2.LastDrankCola = tick()
                        end
                        local Statuses_upv_1 = require(game.ReplicatedStorage.Modules.Gameplay.Statuses)
                        Statuses_upv_1:ApplyStatus(a1.Player, "Speed", {AppliedFrom = "BloxyCola", Level = v8, Duration = a1.Config.SpeedDuration})
                        a1.__statusCheck = Statuses_upv_1.StatusApplied:Connect(
                            function(a3, a4, a5, a6)
                                --[[
                                  line: 182
                                  upvalues:
                                    a1 (copy, index: 1)
                                    Statuses_upv_1 (copy, index: 2)
                                ]]
                                if a3 ~= a1.Player or a4 ~= "Slowness" then
                                    return
                                end
                                Statuses_upv_1:RemoveStatus(a3, "Slowness")
                                Statuses_upv_1:RemoveStatus(a3, "Speed")
                                if not a1.__statusCheck then
                                    return
                                end
                                a1.__statusCheck:Disconnect()
                                a1.__statusCheck = nil
                            end
                        )
                        local function __disconnectStatusCheck()
                            --[[
                              name: __disconnectStatusCheck
                              line: 175
                              upvalues:
                                a1 (copy, index: 1)
                            ]]
                            if not a1.__statusCheck then
                                return
                            end
                            a1.__statusCheck:Disconnect()
                            a1.__statusCheck = nil
                        end
                        task.delay(a1.Config.SpeedDuration, __disconnectStatusCheck)
                        a1:Destroy()
                    end
                )
            }
        elseif game["Run Service"]:IsClient() then
            a1.Animations.Activated2:Play()
            if not (a1.SpeedMultiplier) then
                a1.SpeedMultiplier = Util_upv_1:CreateSpeedMultiplier(a1.Player, a1.Config.DrinkSpeedMultiplier, "BloxyColaItem", a1.Config.DrinkTime)
            end
            require(game.ReplicatedStorage.Modules.Network.Network):FireConnection("DisableSprinting", "BloxyColaItem", true)
        end
    end
end
function tbl_upv_1.Deactivated(a1)
    --[[
      name: Deactivated
      line: 214
    ]]
end
return tbl_upv_1
