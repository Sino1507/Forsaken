-- Script Path: game:GetService("Workspace").Map.Ingame.Map.Generator.Scripts.Client
-- Took 0.04s to decompile.
-- Executor: Volt (1.3.7.0)

local _ = require(game.ReplicatedStorage.GlobalTypes)
local u1 = game:GetService("RunService"):IsStudio()
local u2 = script:GetFullName():gsub("%.", "/")
local function displayWarn(a1)
    --[[
      name: displayWarn
      line: 11
      upvalues:
        u1 (copy, index: 1)
        u2 (copy, index: 2)
    ]]
    local v1 = type(a1) == "string"
    assert(v1, "bad message")
    if not u1 then
        return
    end
    warn((("[%*]: %*"):format(u2, a1)))
end
local ReplicatedStorage_1 = game:GetService("ReplicatedStorage")
local ContentProvider_upv_1 = game:GetService("ContentProvider")
local Debris_upv_1 = game:GetService("Debris")
local TweenService_upv_1 = game:GetService("TweenService")
local Players_1 = game:GetService("Players")
local Util_upv_1 = require(ReplicatedStorage_1.Modules.Utilities.Util)
local Sounds_upv_1 = require(ReplicatedStorage_1.Modules.Rendering.Sounds)
local FlowGameManager_upv_1 = require(ReplicatedStorage_1.Modules.Minigames.FlowGameManager)
local Sprinting_upv_1 = require(ReplicatedStorage_1.Systems.Character.Game.Sprinting)
local trove_1 = require(ReplicatedStorage_1.Packages.trove)
local tree_upv_1 = require(ReplicatedStorage_1.Packages.tree)
local u3 = script:FindFirstAncestor("Generator")
local v2 = tree_upv_1.Await(u3, "Remotes", 10, "Folder")
local u4 = v2:FindFirstChildOfClass("RemoteEvent")
local u5 = v2:FindFirstChildOfClass("RemoteFunction")
if u4 then
    local u6
    if u5 then
        local u7 = trove_1.new()
        local tbl_upv_1 = {}
        local LocalPlayer_upv_1 = Players_1.LocalPlayer
        local u8 = tree_upv_1.Await(u3, "Progress", 10, "NumberValue")
        u6 = tree_upv_1.Await(u3, "Main/Prompt", 10, "ProximityPrompt")
        local u9 = tree_upv_1.Await(u3, "Instances/Generator/Progress/BarUI/Bar", 10, "Frame")
        local tbl_upv_2 = {}
        local u10 = nil
        local u11 = false
        local u12 = TweenInfo.new(0.5)
        local Size_upv_1 = script.Warning.Size
        local u13 = TweenInfo.new(0.35)
        local u14 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tbl_upv_3 = {FixingLoop = "rbxassetid://82691533602949", Crouch = "rbxassetid://127802146383565"}
        local tbl_upv_4 = {
            leftAlready = "",
            dead = "Try not to die next time.",
            isKiller = "You're supposed to be killing them, not helping them. Go do that.",
            alreadyFixed = "This generator's already been fixed. Go try fixing another one.",
            isUnknownTeam = "Dude what r u doing rn you're a spectator",
            positionOccupied = "Move to another side of the generator and try again.",
            tooMany = "Too many people are fixing the generator right now. Try again later.",
            tooFar = "Move a bit closer to an available side of the generator and try again."
        }
        local function stopFixingGenerator(a1)
            --[[
              name: stopFixingGenerator
              line: 164
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
                u11 (ref,  index: 2)
                u6 (copy, index: 3)
                u1 (copy, index: 4)
                u2 (copy, index: 5)
                Sounds_upv_1 (copy, index: 6)
                u3 (copy, index: 7)
                FlowGameManager_upv_1 (copy, index: 8)
                u10 (ref,  index: 9)
                Debris_upv_1 (copy, index: 10)
                TweenService_upv_1 (copy, index: 11)
                tree_upv_1 (copy, index: 12)
                tbl_upv_1 (copy, index: 13)
                tbl_upv_2 (copy, index: 14)
                u7 (copy, index: 15)
            ]]
            assert(LocalPlayer_upv_1, "no current player")
            u11 = false
            if u6 then
                u6.Enabled = true
            end
            local v3 = ("Stop fixing generator, isDone: %*"):format(a1)
            local v4 = type(v3) == "string"
            assert(v4, "bad message")
            if u1 then
                warn((("[%*]: %*"):format(u2, v3)))
            end
            if a1 then
                Sounds_upv_1:Play("puzzlesDone", {Parent = u3.PrimaryPart})
            end
            if FlowGameManager_upv_1 then
                FlowGameManager_upv_1:endGame()
            end
            if u10 then
                Debris_upv_1:AddItem(u10, 0.4)
                local tbl_5 = {BackgroundTransparency = 1}
                TweenService_upv_1:Create(u10.Background, TweenInfo.new(0.4), tbl_5):Play()
                for _, value_1 in u10:GetDescendants() do
                    if value_1:IsA("ImageLabel") then
                        local tbl_6 = {ImageTransparency = 1}
                        TweenService_upv_1:Create(value_1, TweenInfo.new(0.3), tbl_6):Play()
                    end
                end
                if a1 then
                    local u15 = tree_upv_1.Find(u10, "Background/BarHolder/Bar/Clipping")
                    task.spawn(
                        function()
                            --[[
                              line: 210
                              upvalues:
                                TweenService_upv_1 (copy, index: 1)
                                u15 (copy, index: 2)
                            ]]
                            local v5 = TweenInfo.new(0.2)
                            local tbl_7 = {}
                            tbl_7.Size = UDim2.fromScale(1, 1)
                            TweenService_upv_1:Create(u15, v5, tbl_7):Play()
                            local Top_1 = u15:FindFirstChild("Top")
                            local v6 = TweenInfo.new(0.2)
                            local tbl_8 = {}
                            tbl_8.Size = UDim2.fromScale(1, 1)
                            TweenService_upv_1:Create(Top_1, v6, tbl_8):Play()
                        end
                    )
                end
            end
            for _, value_2 in tbl_upv_1 do
                value_2:Disconnect()
            end
            for _, value_3 in tbl_upv_2 do
                value_3:Stop()
            end
            table.clear(tbl_upv_1)
            table.clear(tbl_upv_2)
            local v7 = LocalPlayer_upv_1.Character and (LocalPlayer_upv_1.Character:FindFirstChild("SpeedMultipliers"))
            local v8 = v7 and (v7:FindFirstChild("FixingGenerator"))
            if v8 then
                v8:Destroy()
            end
            if not a1 then
                return
            end
            task.delay(
                1,
                function()
                    --[[
                      line: 248
                      upvalues:
                        u6 (copy, index: 1)
                        LocalPlayer_upv_1 (copy, index: 2)
                        u1 (copy, index: 3)
                        u2 (copy, index: 4)
                        u7 (copy, index: 5)
                    ]]
                    if u6 then
                        u6.Enabled = false
                    end
                    local v9 = ("Cleaning up generator references on Client for: %*"):format(LocalPlayer_upv_1.Name)
                    local v10 = type(v9) == "string"
                    assert(v10, "bad message")
                    if u1 then
                        warn((("[%*]: %*"):format(u2, v9)))
                    end
                    u7:Destroy()
                end
            )
        end
        local function startFixingGenerator(a1, a2)
            --[[
              name: startFixingGenerator
              line: 264
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
                u11 (ref,  index: 2)
                u6 (copy, index: 3)
                tbl_upv_3 (copy, index: 4)
                tbl_upv_2 (copy, index: 5)
                Util_upv_1 (copy, index: 6)
                u1 (copy, index: 7)
                u2 (copy, index: 8)
                u3 (copy, index: 9)
                FlowGameManager_upv_1 (copy, index: 10)
                u10 (ref,  index: 11)
                u8 (copy, index: 13)
                tree_upv_1 (copy, index: 14)
                tbl_upv_1 (copy, index: 15)
                u4 (copy, index: 16)
                Sounds_upv_1 (copy, index: 17)
                stopFixingGenerator (copy, index: 18)
                Sprinting_upv_1 (copy, index: 19)
            ]]
            assert(LocalPlayer_upv_1, "no current player")
            local v11 = (typeof(a1) == "Instance") and (a1:IsA("BasePart"))
            assert(v11, (("%* is not a BasePart"):format(a1)))
            local v12 = (typeof(a2) == "Instance") and (a2:IsA("NumberValue"))
            assert(v12, (("%* is not a NumberValue"):format(a2)))
            local Character_1 = LocalPlayer_upv_1.Character
            if not Character_1 then
                return
            end
            local PrimaryPart_upv_1 = Character_1.PrimaryPart
            if not PrimaryPart_upv_1 then
                return
            end
            local u16 = Character_1:FindFirstChildOfClass("Humanoid")
            if not u16 then
                return
            end
            u11 = true
            if u6 then
                u6.Enabled = false
            end
            for key_1, value_4 in tbl_upv_3 do
                if not (tbl_upv_2[key_1]) then
                    tbl_upv_2[key_1] = Util_upv_1:LoadAnimationFromID(Character_1, value_4, false)
                end
            end
            local v13 = ("Starting generator fixing for %* at %*"):format(LocalPlayer_upv_1.Name, a1.Name)
            local v14 = type(v13) == "string"
            assert(v14, "bad message")
            if u1 then
                warn((("[%*]: %*"):format(u2, v13)))
            end
            tbl_upv_2.Crouch:Play(0)
            tbl_upv_2.FixingLoop:Play()
            local u17 = u3:GetAttribute("Size") or 6
            FlowGameManager_upv_1:startGame(u17 + (u3:GetAttribute("cl_Completed") or 0))
            if u10 then
                u10:Destroy()
            end
            u10 = script.BackgroundUI:Clone()
            u10.Parent = LocalPlayer_upv_1.PlayerGui:FindFirstChild("TemporaryUI")
            local tbl_9 = {BackgroundTransparency = 0.75}
            completedPuzzle_upv_1:Create(u10.Background, TweenInfo.new(0.4), tbl_9):Play()
            if not (LocalPlayer_upv_1:GetAttribute("CompletedGenPuzzle")) then
                local Background_1 = u10.Background
                Background_1.Position = UDim2.fromScale(0.5, 0.55)
            end
            for _, value_5 in u10:GetDescendants() do
                if value_5:IsA("ImageLabel") then
                    local ImageTransparency_1 = value_5.ImageTransparency
                    value_5.ImageTransparency = 1
                    local tbl_10 = {}
                    tbl_10.ImageTransparency = ImageTransparency_1
                    completedPuzzle_upv_1:Create(value_5, TweenInfo.new(0.4), tbl_10):Play()
                end
            end
            local function updateGenProgress_1(a3)
                --[[
                  name: updateGenProgress
                  line: 345
                  upvalues:
                    u10 (ref,  index: 1)
                    u8 (copy, index: 2)
                    tree_upv_1 (copy, index: 3)
                ]]
                if not u10.Parent then
                    return
                end
                local v15 = math.min(u8.Value / 100, 1)
                local v16 = ((v15 ~= 0) and (1 / v15)) or 0
                local v17 = tree_upv_1.Find(u10, "Background/BarHolder/Bar/Clipping")
                local v18 = tree_upv_1.Find(v17, "Top")
                if a3 then
                    v17.Size = UDim2.fromScale(1, v15)
                    v18.Size = UDim2.fromScale(1, v16)
                else
                    local v19 = TweenInfo.new(0.2)
                    local tbl_11 = {}
                    tbl_11.Size = UDim2.fromScale(1, v15)
                    TweenService_upv_1:Create(v17, v19, tbl_11):Play()
                    local v20 = TweenInfo.new(0.2)
                    local tbl_12 = {}
                    tbl_12.Size = UDim2.fromScale(1, v16)
                    TweenService_upv_1:Create(v18, v20, tbl_12):Play()
                end
            end
            if u10.Parent then
                local v21 = math.min(u8.Value / 100, 1)
                local v22 = ((v21 ~= 0) and (1 / v21)) or 0
                local v23 = tree_upv_1.Find(u10, "Background/BarHolder/Bar/Clipping")
                local v24 = tree_upv_1.Find(v23, "Top")
                v23.Size = UDim2.fromScale(1, v21)
                v24.Size = UDim2.fromScale(1, v22)
            end
            tbl_upv_1.ProgressUI = u8:GetPropertyChangedSignal("Value"):Connect(updateGenProgress_1)
            local function completedPuzzle_upv_1(a4)
                --[[
                  name: completedPuzzle
                  line: 378
                  upvalues:
                    u8 (copy, index: 1)
                    u3 (copy, index: 2)
                    u4 (copy, index: 3)
                    u11 (ref,  index: 4)
                    Sounds_upv_1 (copy, index: 5)
                    FlowGameManager_upv_1 (copy, index: 6)
                    u17 (copy, index: 7)
                    tbl_upv_1 (copy, index: 8)
                    completedPuzzle_upv_1 (copy, index: 9)
                    completedPuzzle_upv_1 (copy, index: 10)
                    u10 (ref,  index: 11)
                ]]
                if a4 == "finishedPuzzle" then
                    local v25 = u8.Value + u3:GetAttribute("PowerGain")
                    u4:FireServer()
                    if v25 >= 100 then
                        return
                    end
                    if u11 then
                        local v26 = math.clamp(u3:GetAttribute("cl_Completed") or 0, 0, 4)
                        Sounds_upv_1:Play("puzzleDone", {Parent = u3.PrimaryPart})
                        FlowGameManager_upv_1:startGame(u17 + v26)
                        if tbl_upv_1.Completed then
                            tbl_upv_1.Completed:Disconnect()
                            tbl_upv_1.Completed = nil
                        end
                        tbl_upv_1.Completed = FlowGameManager_upv_1.Completed and FlowGameManager_upv_1.Completed:Connect(completedPuzzle_upv_1)
                        local Background_2 = u10.Background
                        local v28 = TweenInfo.new(1)
                        local tbl_13 = {}
                        tbl_13.Position = UDim2.fromScale(0.5, 0.5)
                        TweenService_upv_1:Create(Background_2, v28, tbl_13):Play()
                    end
                end
            end
            tbl_upv_1.Completed = FlowGameManager_upv_1.Completed and FlowGameManager_upv_1.Completed:Connect(completedPuzzle_upv_1)
            if (a2) and (a2.Parent) then
                tbl_upv_1.SpeedGiven = a2.AncestryChanged:Connect(
                    function(a5, a6)
                        --[[
                          line: 411
                          upvalues:
                            stopFixingGenerator (copy, index: 1)
                            a2 (copy, index: 2)
                        ]]
                        if a6 then
                            return
                        end
                        stopFixingGenerator(a2:GetAttribute("Completed"))
                    end
                )
            else
                stopFixingGenerator()
            end
            local u18 = u16.MoveDirection.Magnitude
            local u19 = os.clock()
            local u20 = false
            tbl_upv_1.Moved = u16:GetPropertyChangedSignal("MoveDirection"):Connect(
                function()
                    --[[
                      line: 423
                      upvalues:
                        u16 (copy, index: 1)
                        u18 (ref,  index: 2)
                        u19 (copy, index: 3)
                        u20 (ref,  index: 4)
                        stopFixingGenerator (copy, index: 5)
                    ]]
                    local Magnitude_1 = u16.MoveDirection.Magnitude
                    if u18 == 0 and Magnitude_1 > 0 and u19 + 0.25 <= os.clock() and not (u20) then
                        u20 = true
                        stopFixingGenerator()
                        toggleGeneratorState("Leave")
                    end
                    u18 = Magnitude_1
                end
            )
            local u21 = Sprinting_upv_1.SprintToggled
            if u21 then
                local v30 = Sprinting_upv_1.SprintToggled:Connect(
                    function(a7)
                        --[[
                          line: 434
                          upvalues:
                            stopFixingGenerator (copy, index: 1)
                        ]]
                        if not a7 then
                            return
                        end
                        stopFixingGenerator()
                        toggleGeneratorState("Leave")
                    end
                )
                u21 = v30
            end
            tbl_upv_1.Sprinted = u21
            local Position_upv_1 = u3.PrimaryPart.Position
            u21 = false
            tbl_upv_1.Teleported = PrimaryPart_upv_1:GetPropertyChangedSignal("Position"):Connect(
                function()
                    --[[
                      line: 443
                      upvalues:
                        Position_upv_1 (copy, index: 1)
                        PrimaryPart_upv_1 (copy, index: 2)
                        u21 (ref,  index: 3)
                        stopFixingGenerator (copy, index: 4)
                    ]]
                    if (Position_upv_1 - PrimaryPart_upv_1.Position).Magnitude <= 16 or (u21) then
                        return
                    end
                    u21 = true
                    stopFixingGenerator()
                    toggleGeneratorState("Leave")
                end
            )
        end
        local function createWarning(a1)
            --[[
              name: createWarning
              line: 101
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
                tree_upv_1 (copy, index: 2)
                u1 (copy, index: 3)
                u2 (copy, index: 4)
                TweenService_upv_1 (copy, index: 5)
                u13 (copy, index: 6)
                Size_upv_1 (copy, index: 7)
                Debris_upv_1 (copy, index: 8)
                u14 (copy, index: 9)
            ]]
            assert(LocalPlayer_upv_1, "no current player")
            local v31 = typeof(a1) == "string"
            assert(v31, "bad displayString, must be string")
            local v32 = tree_upv_1.Find(LocalPlayer_upv_1, "PlayerGui/TemporaryUI")
            local v33 = nil
            if v32 then
                v33 = v32:FindFirstChild("GeneratorWarning")
                if v33 then
                    v33:Destroy()
                end
                local u22 = script.Warning:Clone()
                u22.Name = "GeneratorWarning"
                u22.Title.Text = a1
                u22.Parent = v32
                u22.Size = u22.Size + UDim2.fromScale(0.025, 0.01)
                local tbl_14 = {}
                tbl_14.Size = Size_upv_1
                TweenService_upv_1:Create(u22, u13, tbl_14):Play()
                task.delay(
                    3,
                    function()
                        --[[
                          line: 134
                          upvalues:
                            u22 (copy, index: 1)
                            Debris_upv_1 (copy, index: 2)
                            TweenService_upv_1 (copy, index: 3)
                            u14 (copy, index: 4)
                        ]]
                        if not u22.Parent then
                            return
                        end
                        Debris_upv_1:AddItem(u22, 1)
                        TweenService_upv_1:Create(u22, u14, {BackgroundTransparency = 1}):Play()
                        TweenService_upv_1:Create(u22.Title, u14, {TextTransparency = 1, BackgroundTransparency = 1, TextStrokeTransparency = 1}):Play()
                    end
                )
            else
                assert(true, "bad message")
                if not u1 then
                    return
                end
                warn((("[%*]: No TemporaryUI found."):format(u2)))
            end
        end
        function toggleGeneratorState(a1)
            --[[
              name: toggleGeneratorState
              line: 456
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
                u1 (copy, index: 2)
                u2 (copy, index: 3)
                u5 (copy, index: 4)
                tbl_upv_4 (copy, index: 5)
                createWarning (copy, index: 6)
                startFixingGenerator (copy, index: 7)
            ]]
            assert(LocalPlayer_upv_1, "no current player")
            local v34 = typeof(a1) == "string"
            assert(v34, "bad state, must be string")
            local Character_2 = LocalPlayer_upv_1.Character
            if not Character_2 then
                return
            end
            if Character_2.PrimaryPart then
                local v35 = ("Entering generator state for %* with state %*"):format(LocalPlayer_upv_1.Name, a1)
                local v36 = type(v35) == "string"
                assert(v36, "bad message")
                if u1 then
                    warn((("[%*]: %*"):format(u2, v35)))
                end
                local v37, v38, v39 = u5:InvokeServer(a1)
                if tbl_upv_4[v37] then
                    createWarning(tbl_upv_4[v37])
                elseif not (v37) then
                    createWarning("An unknown error occurred while trying to fix the generator. Try again.")
                end
                if v37 == "fixing" then
                    startFixingGenerator(v38, v39)
                end
            end
        end
        task.spawn(
            function()
                --[[
                  line: 481
                  upvalues:
                    tbl_upv_3 (copy, index: 1)
                    ContentProvider_upv_1 (copy, index: 2)
                    u1 (copy, index: 3)
                    u2 (copy, index: 4)
                ]]
                local tbl_15 = {}
                for _, value_6 in tbl_upv_3 do
                    table.insert(tbl_15, value_6)
                end
                ContentProvider_upv_1:PreloadAsync(
                    tbl_15,
                    function(a1, a2)
                        --[[
                          line: 487
                          upvalues:
                            u1 (copy, index: 1)
                            u2 (copy, index: 2)
                        ]]
                        local v40 = ("Preloading animation: %*, status: %*"):format(a1, a2)
                        local v41 = type(v40) == "string"
                        assert(v41, "bad message")
                        if not u1 then
                            return
                        end
                        warn((("[%*]: %*"):format(u2, v40)))
                    end
                )
            end
        )
        if u6 then
            u7:Connect(
                u6.Triggered,
                function()
                    --[[
                      line: 497
                    ]]
                    toggleGeneratorState("Enter")
                end
            )
            u7:Connect(
                u8.Changed,
                function(a1)
                    --[[
                      line: 502
                      upvalues:
                        u9 (copy, index: 1)
                        TweenService_upv_1 (copy, index: 2)
                        u12 (copy, index: 3)
                        u7 (copy, index: 4)
                    ]]
                    if not u9 then
                        return
                    end
                    local v42 = a1 / 100
                    local v43 = TweenService_upv_1:Create(u9, u12, {Size = UDim2.fromScale(v42, 1), BackgroundTransparency = 1 - v42})
                    u7:Add(v43)
                    v43:Play()
                end
            )
            u7:Connect(
                u3.AncestryChanged,
                function(a1, a2)
                    --[[
                      line: 521
                      upvalues:
                        stopFixingGenerator (copy, index: 1)
                    ]]
                    if a2 then
                        return
                    end
                    stopFixingGenerator()
                end
            )
        else
            assert(true, "bad message")
            if u1 then
                warn((("[%*]: Generator prompt is missing. Generator will not be usable."):format(u2)))
            end
        end
        return
    end
end
assert(true, "bad message")
if not u1 then
    return
end
warn((("[%*]: No RemoteEvent or RemoteFunction found in Generator/Remotes"):format(u2)))
