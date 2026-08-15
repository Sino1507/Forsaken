-- Script Path: game:GetService("ReplicatedStorage").Modules.Gameplay.Statuses
-- Took 0.04s to decompile.
-- Executor: Volt (1.3.7.0)

local tbl_upv_1 = {}
tbl_upv_1.CurrentStatuses = {}
tbl_upv_1.StatusCounts = {}
local ReplicatedStorage_upv_1 = game:GetService("ReplicatedStorage")
local _ = game:GetService("CollectionService")
local RunService_upv_1 = game:GetService("RunService")
local Network_upv_1 = require(ReplicatedStorage_upv_1.Modules.Network.Network)
local Sounds_upv_1 = require(ReplicatedStorage_upv_1.Modules.Rendering.Sounds)
local Util_upv_1 = require(ReplicatedStorage_upv_1.Modules.Utilities.Util)
local Signal_1 = require(ReplicatedStorage_upv_1.Modules.Utilities.Signal)
local StatusEffects_upv_1 = ReplicatedStorage_upv_1.Modules.Schematics.StatusEffects
function tbl_upv_1.ApplyStatus(self, player, statusType, statusData)
    --[[
      name: ApplyStatus
      line: 18
      upvalues:
        RunService_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        StatusEffects_upv_1 (copy, index: 3)
        Util_upv_1 (copy, index: 4)
        ReplicatedStorage_upv_1 (copy, index: 5)
        Sounds_upv_1 (copy, index: 6)
        Network_upv_1 (copy, index: 7)
    ]]
    assert(RunService_upv_1:IsServer(), "Can only apply statuses on server.")
    local v1 = ((player:IsA("Model")) and (game.Players:GetPlayerFromCharacter(player))) or player
    local v2
    if (v1:IsA("Model")) and (v1) then
        v2 = v1
    else
        v2 = v1.Character
    end
    tbl_upv_1.CurrentStatuses[v1] = tbl_upv_1.CurrentStatuses[v1] or {}
    local v3 = StatusEffects_upv_1:FindFirstChild(tostring(statusType), true)
    local _ = v3 and (require(v3))
    local v4 = tbl_upv_1.CurrentStatuses[v1][statusType] ~= nil
    local u1 = tbl_upv_1.CurrentStatuses[v1][statusType] or (v3 and (Util_upv_1:CopyTable(v3)))
    if not u1 or not v2 then
        return
    end
    local v5 = v3 and (v3.Data and (v3.Data.IsNegative == true))
    local v6 = statusData and (statusData.BypassInvincibility == true)
    if v5 and v2:GetAttribute("Invincible") and not (v6) then
        return
    end
    local u2 = require(ReplicatedStorage_upv_1.Modules.Gameplay.Actors).CurrentActors[v1]
    if u2 and u2.Behavior and u2.Behavior[("On%*Absolute"):format(statusType)] then
        u2.Behavior[("On%*Absolute"):format(statusType)](u2.Behavior, u2)
    end
    local v7 = u2 and (u2.Config.StatusData)
    if v7 and v7.ExcludeApplying and table.find(v7.ExcludeApplying, statusType) or u1.Level and statusData and statusData.Level and statusData.Level < u1.Level and not (statusData.Stackable) then
        return
    end
    if not v2:GetAttribute(("%*Disabled"):format(statusType)) then
        for key_1, value_1 in pairs(statusData or {}) do
            u1.Data[key_1] = value_1
        end
        if u2 then
            local tbl_2 = {Priority = 5}
            Sounds_upv_1:PlayVoiceline(u2, ("%*Status"):format(statusType), tbl_2)
        end
        local v8, v9 = nil, nil
        if v4 then
            if u1.Data.TimeStackable == false or statusData.TimeStackable == false then
                return
            end
            u1.TimePast = 0
            if u1.Data.Stackable then
                u1.Level = math.clamp(u1.Level + ((statusData and (statusData.Level)) or 1), 1, u1.Data.MaxLevel or 99)
            elseif u1.Data.Level and u1.Level < u1.Data.Level then
                u1.Level = u1.Data.Level
            end
            if u1.Applied then
                u1:Applied()
            end
            local tbl_3 = {Duration = 0, TimePast = 0}
            tbl_3.Level = u1.Level
            tbl_3.Duration = u1.Data.Duration or (u1.TimeRequired)
            Network_upv_1:FireClientConnection(v1, "StatusUpdated", "REMOTE_EVENT", statusType, tbl_3)
            if u2 and u2.Behavior and u2.Behavior[("On%*"):format(statusType)] then
                u2.Behavior[("On%*"):format(statusType)](u2.Behavior, u2)
            end
        else
            u1.Player = v1
            u1.Character = v2
            u1.Level = u1.Data.Level or 1
            u1.AppliedFrom = statusData.AppliedFrom or "None"
            u1.TimeRequired = tonumber(u1.Data.Duration) or 10
            u1.TimePast = 0
            local function __updateStatusData(a5)
                --[[
                  name: __updateStatusData
                  line: 130
                  upvalues:
                    u1 (copy, index: 1)
                    u2 (copy, index: 2)
                ]]
                if not a5 or u1.AppliedFrom == (a5.ExcludeIfAppliedFrom or "") then
                    return
                end
                local v10 = a5.TotalTimeMult or 0
                if v10 > 0 and u2 and u2.Hunting then
                    local v11
                    if u2.Hunting then
                        v11 = 0.5
                    else
                        v11 = v10
                    end
                    v10 = v11
                end
                if v10 > 0 then
                    u1.TimeRequired = u1.TimeRequired * v10
                    local Data_1 = u1.Data
                    Data_1.Duration = Data_1.Duration * v10
                end
            end
            if u2 then
                local v12 = nil
                if u1.AppliedFrom ~= (u2.ExcludeIfAppliedFrom or "") then
                    v12 = u2.TotalTimeMult or 0
                    if v12 > 0 and u2 and u2.Hunting then
                        local v13
                        if u2.Hunting then
                            v13 = 0.5
                        else
                            v13 = v12
                        end
                        v12 = v13
                    end
                    if v12 > 0 then
                        u1.TimeRequired = u1.TimeRequired * v12
                        local Data_2 = u1.Data
                        Data_2.Duration = Data_2.Duration * v12
                    end
                end
            end
            v8 = v2.PrimaryPart
            if v8 and v8.Parent then
                v9 = Sounds_upv_1:Play(u1.Data.SFX, {Looped = true, RollOffMaxDistance = 48, RollOffMinDistance = 16, Parent = v8})
                if v9 then
                    v9.Name = ("%*StatusSFX"):format(statusType)
                    game.Debris:AddItem(v9, 30)
                end
            end
            if u1.Applied then
                u1:Applied()
            end
            Network_upv_1:FireClientConnection(v1, "StatusApplied", "REMOTE_EVENT", statusType, u1, u1.Data)
            if not (tbl_upv_1.CurrentStatuses[v1]) then
                tbl_upv_1.CurrentStatuses[v1] = {}
            end
            tbl_upv_1.CurrentStatuses[v1][statusType] = u1
            if u2 and u2.Behavior and u2.Behavior[("On%*"):format(statusType)] then
                u2.Behavior[("On%*"):format(statusType)](u2.Behavior, u2)
            end
            if tbl_upv_1:GetStatusCount(v1) >= 4 then
                require(ReplicatedStorage_upv_1.Modules.Data.AchievementUtil):IncrementAchievementProgress(v1, "LotsaStatuses")
            end
            tbl_upv_1.StatusCounts[v1] = (tbl_upv_1.StatusCounts[v1] or 0) + 1
            tbl_upv_1.StatusApplied:Fire(v1, statusType, u1, v4)
        end
        return u1
    end
end
function tbl_upv_1.RemoveStatus(a1, a2, a3)
    --[[
      name: RemoveStatus
      line: 188
      upvalues:
        tbl_upv_1 (copy, index: 1)
        Network_upv_1 (copy, index: 2)
        ReplicatedStorage_upv_1 (copy, index: 3)
    ]]
    if a2 then
        local v14 = a2:IsA("Model")
        if v14 then
            a2 = game.Players:GetPlayerFromCharacter(a2) or a2
        end
    end
    local v15 = tbl_upv_1.CurrentStatuses[a2] and (tbl_upv_1.CurrentStatuses[a2][a3])
    local v16 = nil
    if v15 then
        if v15.Removed then
            v15:Removed()
        end
        Network_upv_1:FireClientConnection(a2, "StatusRemoved", "REMOTE_EVENT", a3)
        local v17 = a2:IsA("Player") and a2.Character or a2
        local v18 = v17 and (v17:FindFirstChild(("%*StatusSFX"):format(a3), true))
        if v18 then
            game.Debris:AddItem(v18, 0.25)
            local tbl_4 = {Volume = 0}
            game.TweenService:Create(v18, TweenInfo.new(0.25), tbl_4):Play()
        end
        v16 = require(ReplicatedStorage_upv_1.Modules.Gameplay.Actors).CurrentActors[a2]
        if v16 and v16.Behavior and v16.Behavior[("%*Ended"):format(a3)] then
            v16.Behavior[("%*Ended"):format(a3)](v16.Behavior, v16)
        end
        tbl_upv_1.CurrentStatuses[a2][a3] = nil
        tbl_upv_1.StatusCounts[a2] = math.max((tbl_upv_1.StatusCounts[a2] or 1) - 1, 0)
    end
    if tbl_upv_1:GetStatusCount(a2) ~= 0 then
        return
    end
    table.clear(tbl_upv_1.CurrentStatuses[a2])
    tbl_upv_1.CurrentStatuses[a2] = nil
    tbl_upv_1.StatusCounts[a2] = nil
end
function tbl_upv_1.RemoveStatuses(a1, a2, a3)
    --[[
      name: RemoveStatuses
      line: 232
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if a2 then
        local v19 = a2:IsA("Model")
        if v19 then
            a2 = game.Players:GetPlayerFromCharacter(a2) or a2
        end
    end
    for key_2, _ in pairs(tbl_upv_1.CurrentStatuses[a2] or {}) do
        tbl_upv_1:RemoveStatus(a2, key_2)
    end
    tbl_upv_1.CurrentStatuses[a2] = nil
    tbl_upv_1.StatusCounts[a2] = nil
end
function tbl_upv_1.GetStatusCount(a1, a2)
    --[[
      name: GetStatusCount
      line: 248
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    return tbl_upv_1.StatusCounts[a2] or -1
end
function tbl_upv_1.PlayerHasStatus(a1, a2, a3)
    --[[
      name: PlayerHasStatus
      line: 252
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v20 = ((a2:IsA("Model")) and (game.Players:GetPlayerFromCharacter(a2))) or a2
    return tbl_upv_1.CurrentStatuses[v20] and (tbl_upv_1.CurrentStatuses[v20][a3])
end
function tbl_upv_1.Start(a1)
    --[[
      name: Start
      line: 257
      upvalues:
        RunService_upv_1 (copy, index: 1)
        Util_upv_1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
        StatusEffects_upv_1 (copy, index: 4)
        Network_upv_1 (copy, index: 5)
    ]]
    if RunService_upv_1:IsServer() then
        Util_upv_1.OnCharacterAdded(
            function(a2, a3)
                --[[
                  line: 261
                  upvalues:
                    tbl_upv_1 (copy, index: 1)
                ]]
                tbl_upv_1:RemoveStatuses(a3)
            end
        )
        game.Players.PlayerRemoving:Connect(
            function(a4)
                --[[
                  line: 266
                  upvalues:
                    tbl_upv_1 (copy, index: 1)
                ]]
                tbl_upv_1:RemoveStatuses(a4)
            end
        )
        RunService_upv_1.Heartbeat:Connect(
            function(a5)
                --[[
                  line: 270
                  upvalues:
                    tbl_upv_1 (copy, index: 1)
                ]]
                for key_3, value_2 in tbl_upv_1.CurrentStatuses do
                    for key_4, value_3 in value_2 do
                        value_3.TimePast = value_3.TimePast + a5
                        if not (key_3.Parent) or not (value_3.Character.Parent) or value_3.TimeRequired <= value_3.TimePast then
                            tbl_upv_1:RemoveStatus(key_3, key_4)
                            continue
                        end
                        if value_3.Heartbeat then
                            value_3:Heartbeat(a5)
                        end
                    end
                end
            end
        )
    elseif RunService_upv_1:IsClient() then
        local LocalPlayer_upv_1 = game.Players.LocalPlayer
        local u3 = script.StatusContainer:Clone()
        u3.Parent = LocalPlayer_upv_1.PlayerGui.MainUI
        tbl_upv_1.CurrentStatuses[LocalPlayer_upv_1] = {}
        local u4 = tbl_upv_1.CurrentStatuses[LocalPlayer_upv_1]
        local function onStatusUpdated(a6, a7)
            --[[
              name: onStatusUpdated
              line: 347
              upvalues:
                u4 (copy, index: 1)
                Util_upv_1 (copy, index: 2)
                tbl_upv_1 (copy, index: 3)
                LocalPlayer_upv_1 (copy, index: 4)
            ]]
            local v21 = u4[a6]
            if not v21 or not v21.UI then
                return
            end
            v21.TimePast = a7.TimePast or 0
            v21.TimeRequired = a7.Duration or (v21.TimeRequired)
            v21.Level = a7.Level or (v21.Level)
            v21.CurrentTimeDisplay = 123456789
            v21.UI.Timer.Text = Util_upv_1:FormatTime(v21.CurrentTimeDisplay, "Clock")
            v21.UI.Title.Text = ("%* %*"):format(a6, Util_upv_1:IntToRoman(v21.Level))
            if v21.Info.Applied then
                v21.Info:Applied()
            end
            tbl_upv_1.StatusApplied:FireDeferred(LocalPlayer_upv_1, a6, a7, true)
        end
        local function onStatusRemoved(a8)
            --[[
              name: onStatusRemoved
              line: 370
              upvalues:
                u4 (copy, index: 1)
            ]]
            local v22 = u4[a8]
            if not v22 then
                return
            end
            if v22.Info.Removed then
                v22.Info:Removed()
            end
            v22.UI:Destroy()
            u4[a8] = nil
        end
        local function reset()
            --[[
              name: reset
              line: 412
              upvalues:
                u4 (copy, index: 1)
            ]]
            for key_5, _ in pairs(u4) do
                local v23 = u4[key_5]
                if not (v23) then
                    continue
                end
                if v23.Info.Removed then
                    v23.Info:Removed()
                end
                v23.UI:Destroy()
                u4[key_5] = nil
            end
        end
        local function onStatusApplied(a9, a10, a11)
            --[[
              name: onStatusApplied
              line: 300
              upvalues:
                u4 (copy, index: 1)
                LocalPlayer_upv_1 (copy, index: 2)
                StatusEffects_upv_1 (copy, index: 3)
                Util_upv_1 (copy, index: 4)
                u3 (copy, index: 5)
                tbl_upv_1 (copy, index: 6)
            ]]
            local Level_1 = a10.Level
            local Duration_1 = a11.Duration
            local Icon_1 = a11.Icon
            local Hidden_1 = a11.Hidden
            local v24
            if u4[a9] then
                v24 = u4[a9]
                v24.TimePast = 0
                v24.TimeRequired = Duration_1
                v24.Level = Level_1
                v24.CurrentTimeDisplay = 123456789
                if v24.Info.Applied then
                    v24.Info:Applied()
                end
            else
                v24 = {TimePast = 0}
                v24.TimeRequired = Duration_1
                v24.Level = Level_1
                v24.Player = LocalPlayer_upv_1
                v24.Character = LocalPlayer_upv_1.Character
                v24.Data = a11
                local v25 = Util_upv_1:CopyTable(require(StatusEffects_upv_1:FindFirstChild(a9, true)))
                v25.__index = v25
                v24.Info = setmetatable(v24, v25)
                if v24.Info.Applied then
                    v24.Info:Applied()
                end
                v24.UI = script.StatusDisplay:Clone()
                v24.UI.Name = a9
                v24.UI.Timer.Text = Util_upv_1:FormatTime(math.round(v24.TimeRequired - v24.TimePast), "Clock")
                v24.UI.Title.Text = ("%* %*"):format(a9, Util_upv_1:IntToRoman(v24.Level))
                v24.UI.IconHolder.Icon.Image = Icon_1 or ""
                v24.UI.Visible = not Hidden_1
                v24.UI.Parent = u3
                u4[a9] = v24
            end
            tbl_upv_1.StatusApplied:FireDeferred(LocalPlayer_upv_1, a9, a11, false)
        end
        Network_upv_1:SetConnection("StatusApplied", "REMOTE_EVENT", onStatusApplied)
        Network_upv_1:SetConnection("StatusUpdated", "REMOTE_EVENT", onStatusUpdated)
        Network_upv_1:SetConnection("StatusRemoved", "REMOTE_EVENT", onStatusRemoved)
        local function update(a12)
            --[[
              name: update
              line: 380
              upvalues:
                u4 (copy, index: 1)
                Util_upv_1 (copy, index: 2)
            ]]
            for key_upv_6, value_upv_4 in pairs(u4) do
                value_upv_4.TimePast = value_upv_4.TimePast + a12
                if value_upv_4.Info.Heartbeat then
                    value_upv_4.Info:Heartbeat(a12)
                end
                local v26 = math.ceil(value_upv_4.TimeRequired - value_upv_4.TimePast)
                if value_upv_4.CurrentTimeDisplay ~= v26 then
                    value_upv_4.CurrentTimeDisplay = v26
                    task.defer(
                        function()
                            --[[
                              line: 390
                              upvalues:
                                value_upv_4 (copy, index: 1)
                                Util_upv_1 (copy, index: 2)
                                key_upv_6 (copy, index: 3)
                            ]]
                            if not value_upv_4.UI or not value_upv_4.UI.Parent then
                                return
                            end
                            value_upv_4.UI.Timer.Text = Util_upv_1:FormatTime(value_upv_4.CurrentTimeDisplay, "Clock")
                            value_upv_4.UI.Title.Text = ("%* %*"):format(key_upv_6, Util_upv_1:IntToRoman(value_upv_4.Level))
                        end
                    )
                end
                if value_upv_4.TimeRequired > value_upv_4.TimePast then
                    continue
                end
                if value_upv_4.Info.Removed then
                    value_upv_4.Info:Removed()
                end
                if not (value_upv_4.UI) then
                    u4[key_upv_6] = nil
                    continue
                end
                if value_upv_4.UI.Parent then
                    value_upv_4.UI:Destroy()
                end
                u4[key_upv_6] = nil
            end
        end
        RunService_upv_1.Heartbeat:Connect(update)
        LocalPlayer_upv_1.CharacterAdded:Connect(reset)
    end
    for _, value_5 in ipairs(StatusEffects_upv_1:GetDescendants()) do
        if not (value_5:IsA("ModuleScript")) or value_5:HasTag("CannotInit") then
            continue
        end
        local v27 = require(value_5)
        if v27.Init then
            v27:Init()
        end
    end
end
tbl_upv_1.StatusApplied = Signal_1.new()
return tbl_upv_1
