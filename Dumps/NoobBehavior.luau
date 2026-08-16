-- Script Path: game:GetService("ReplicatedStorage").Assets.Survivors.Noob.Behavior
-- Took 0.02s to decompile.
-- Executor: Volt (1.3.7.0)

local tbl_1 = {}
local Util_upv_1 = require(game.ReplicatedStorage.Modules.Utilities.Util)
require(game.ReplicatedStorage.Modules.Gameplay.Statuses)
local Network_upv_1 = require(game.ReplicatedStorage.Modules.Network.Network)
require(game.ReplicatedStorage.Modules.Rendering.Sounds)
require(game.ReplicatedStorage.Modules.Data.AchievementUtil)
local tbl_2 = {}
local tbl_3 = {LayoutOrder = 1, Icon = "rbxassetid://133994175153795", KeybindType = "AltAbility1"}
function tbl_3.Callback(a1, a2)
    --[[
      name: Callback
      line: 26
      upvalues:
        Network_upv_1 (copy, index: 1)
        Util_upv_1 (copy, index: 2)
    ]]
    a1.Animations.Drinking1:Play()
    Network_upv_1:FireConnection("DisableSprinting", "NoobDrinking", true)
    local u1 = Util_upv_1:CreateSpeedMultiplier(a1.Player, 1, "DrinkingCola")
    local v1 = TweenInfo.new(0.2)
    local tbl_4 = {}
    tbl_4.Value = a1.Config.DrinkingColaSpeedMultiplier
    game.TweenService:Create(u1, v1, tbl_4):Play()
    task.delay(
        2.45,
        function()
            --[[
              line: 117
              upvalues:
                Network_upv_1 (copy, index: 1)
                u1 (copy, index: 2)
            ]]
            Network_upv_1:FireConnection("DisableSprinting", "NoobDrinking", false)
            game.Debris:AddItem(u1, 0.2)
            local tbl_5 = {Value = 1}
            game.TweenService:Create(u1, TweenInfo.new(0.2), tbl_5):Play()
        end
    )
end
tbl_2.BloxyCola = tbl_3
local tbl_6 = {LayoutOrder = 2, Icon = "rbxassetid://133354880475554", KeybindType = "AltAbility2"}
function tbl_6.Callback(a1, a2)
    --[[
      name: Callback
      line: 130
      upvalues:
        Network_upv_1 (copy, index: 1)
        Util_upv_1 (copy, index: 2)
    ]]
    if a2 == "Drink" then
        a1.Animations.Drinking2:Play()
        Network_upv_1:FireConnection("DisableSprinting", "NoobDrinkingSlateskin", true)
        local u2 = Util_upv_1:CreateSpeedMultiplier(a1.Player, 1, "DrinkingSlateskin")
        local v2 = TweenInfo.new(0.2)
        local tbl_7 = {}
        tbl_7.Value = a1.Config.DrinkingSlateskinSpeedMultiplier
        game.TweenService:Create(u2, v2, tbl_7):Play()
        task.delay(
            1.2,
            function()
                --[[
                  line: 225
                  upvalues:
                    Network_upv_1 (copy, index: 1)
                    u2 (copy, index: 2)
                ]]
                Network_upv_1:FireConnection("DisableSprinting", "NoobDrinkingSlateskin", false)
                game.Debris:AddItem(u2, 0.2)
                local tbl_8 = {Value = 1}
                game.TweenService:Create(u2, TweenInfo.new(0.2), tbl_8):Play()
            end
        )
    end
end
tbl_2.SlateskinPotion = tbl_6
local tbl_9 = {LayoutOrder = 3, Icon = "rbxassetid://112547374697556", KeybindType = "AltAbility3"}
function tbl_9.Callback(a1, a2)
    --[[
      name: Callback
      line: 239
      upvalues:
        Network_upv_1 (copy, index: 1)
        Util_upv_1 (copy, index: 2)
    ]]
    a1.Animations.Eating:Play()
    Network_upv_1:FireConnection("DisableSprinting", "NoobGhostBurger", true)
    local u3 = Util_upv_1:CreateSpeedMultiplier(a1.Player, 1, "EatingGhostburger")
    local v3 = TweenInfo.new(0.2)
    local tbl_10 = {}
    tbl_10.Value = a1.Config.EatingSpeedMultiplier
    game.TweenService:Create(u3, v3, tbl_10):Play()
    task.delay(
        2,
        function()
            --[[
              line: 323
              upvalues:
                Network_upv_1 (copy, index: 1)
                u3 (copy, index: 2)
            ]]
            Network_upv_1:FireConnection("DisableSprinting", "NoobGhostBurger", false)
            game.Debris:AddItem(u3, 0.2)
            local tbl_11 = {Value = 1}
            game.TweenService:Create(u3, TweenInfo.new(0.2), tbl_11):Play()
        end
    )
end
tbl_2.Ghostburger = tbl_9
tbl_1.Abilities = tbl_2
function tbl_1.OnGhostBegin(a1, a2)
    --[[
      name: OnGhostBegin
      line: 333
    ]]
    if not a2.Rig or not a2.Rig.Parent then
        return
    end
    a2.Rig.Ghostburger.Transparency = 0.1
end
function tbl_1.OnGhostConsumed(a1, a2)
    --[[
      name: OnGhostConsumed
      line: 339
    ]]
    if not a2.Rig or not a2.Rig.Parent then
        return
    end
    a2.Rig.Ghostburger.Transparency = 1
end
function tbl_1.OnBloxyBegin(a1, a2)
    --[[
      name: OnBloxyBegin
      line: 345
    ]]
    if not a2.Rig or not a2.Rig.Parent then
        return
    end
    a2.Rig.BloxyCola.Transparency = 0
end
function tbl_1.OnBloxyConsumed(a1, a2)
    --[[
      name: OnBloxyConsumed
      line: 351
    ]]
    if not a2.Rig or not a2.Rig.Parent then
        return
    end
    a2.Rig.BloxyCola.Transparency = 1
end
function tbl_1.OnSlateBegin(a1, a2)
    --[[
      name: OnSlateBegin
      line: 357
    ]]
    if not a2.Rig or not a2.Rig.Parent then
        return
    end
    a2.Rig.Slateskin.Transparency = 0.011
end
function tbl_1.OnSlateConsumed(a1, a2)
    --[[
      name: OnSlateConsumed
      line: 363
    ]]
    if not a2.Rig or not a2.Rig.Parent then
        return
    end
    a2.Rig.Slateskin.Transparency = 1
end
function tbl_1.NeedsToHide(a1, a2)
    --[[
      name: NeedsToHide
      line: 370
    ]]
    local Behavior_1 = a2.Behavior
    local v4 = ((Behavior_1.LastAuraApplied) and (Behavior_1.CurrentAuraLength - (tick() - Behavior_1.LastAuraApplied))) or -1
    local v5 = Behavior_1.LastAuraApplied and (Behavior_1.CurrentAuraLength and (v4 > 0))
    local v6 = Behavior_1.AILastSeen and (tick() - Behavior_1.AILastSeen < 2)
    return v5 or v6
end
function tbl_1.OnAuraRevealed(a1, a2, a3, a4)
    --[[
      name: OnAuraRevealed
      line: 382
    ]]
    local Behavior_2 = a2.Behavior
    local v7 = require(game.ReplicatedStorage.Modules.Gameplay.Actors).CurrentActors[a3]
    local v8 = ((Behavior_2.LastAuraApplied) and (Behavior_2.CurrentAuraLength - (tick() - Behavior_2.LastAuraApplied))) or -1
    if not v7 or v7.Rig.Parent.Name ~= "Killers" or v8 >= a4 then
        return
    end
    Behavior_2.LastAuraApplied = tick()
    Behavior_2.CurrentAuraLength = a4
end
return tbl_1
