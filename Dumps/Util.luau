-- Script Path: game:GetService("ReplicatedStorage").Modules.Utilities.Util
-- Took 0.26s to decompile.
-- Executor: Volt (1.3.7.0)

local tbl_upv_1 = {}
local UserInputService_upv_1 = game:GetService("UserInputService")
local HttpService_upv_1 = game:GetService("HttpService")
local TweenService_upv_1 = game:GetService("TweenService")
local RunService_upv_1 = game:GetService("RunService")
local Debris_upv_1 = game:GetService("Debris")
local Players_upv_1 = game:GetService("Players")
local LocalizationService_upv_1 = game:GetService("LocalizationService")
local DataHandler_upv_1 = require(game.ReplicatedStorage.Modules.Data.DataHandler)
local Maid_upv_1 = require(game.ReplicatedStorage.Modules.Utilities.Maid)
local u1 = RunService_upv_1:IsClient()
local u2 = RunService_upv_1:IsServer()
local Initializer_upv_1 = require(game.ReplicatedStorage.Initializer)
local Network_upv_1 = require(game.ReplicatedStorage.Modules.Network.Network)
local Sounds_upv_1 = require(game.ReplicatedStorage.Modules.Rendering.Sounds)
local spawn_upv_1 = task.spawn
local floor_upv_1 = math.floor
local sqrt_upv_1 = math.sqrt
local tbl_upv_2 = {}
tbl_upv_2.Head = true
tbl_upv_2.Torso = true
tbl_upv_2["Left Arm"] = true
tbl_upv_2["Left Leg"] = true
tbl_upv_2["Right Arm"] = true
tbl_upv_2["Right Leg"] = true
local _ = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local u3 = PhysicalProperties.new(0.7, 0.15, 0, 2, 2)
tbl_upv_1.KillerDistanceVector = Vector3.new(1, 4, 1)
function tbl_upv_1.RecursiveDestroy(a1, a2)
    --[[
      name: RecursiveDestroy
      line: 43
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    for _, value_1 in pairs(a2) do
        if typeof(value_1) == "table" then
            tbl_upv_1:RecursiveDestroy(value_1)
            continue
        end
        if typeof(value_1) == "Instance" then
            value_1:Destroy()
        end
    end
end
function tbl_upv_1.Lerp(a1, a2, a3, a4)
    --[[
      name: Lerp
      line: 53
    ]]
    return a2 + ((a3 - a2) * a4)
end
function tbl_upv_1.SerializeVector(a1, a2)
    --[[
      name: SerializeVector
      line: 57
    ]]
    local v1 = buffer.create(12)
    for key_1, value_2 in ipairs({a2.X, a2.Y, a2.Z}) do
        buffer.writef32(v1, 4 * (key_1 - 1), value_2)
    end
    return v1
end
function tbl_upv_1.DeserializeVector(a1, a2)
    --[[
      name: DeserializeVector
      line: 70
    ]]
    local function get(a3)
        --[[
          name: get
          line: 71
          upvalues:
            a2 (copy, index: 1)
        ]]
        return (buffer.readf32(a2, 4 * (a3 - 1)))
    end
    return (vector.create(buffer.readf32(a2, 0), buffer.readf32(a2, 4), buffer.readf32(a2, 8)))
end
function tbl_upv_1.VectorBezier(a1, a2, a3, a4, a5)
    --[[
      name: VectorBezier
      line: 78
    ]]
    local v2 = 1 - a5
    return (((v2 * v2) * a2) + (((v2 * 2) * a5) * a3)) + ((a5 * a5) * a4)
end
function tbl_upv_1.BezierBoneTracking(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
    --[[
      name: BezierBoneTracking
      line: 83
      upvalues:
        tbl_upv_1 (copy, index: 1)
        RunService_upv_1 (copy, index: 2)
    ]]
    local tbl_upv_3 = {}
    tbl_upv_3.Bones = a3
    tbl_upv_3.Root = a2
    tbl_upv_3.StartPoint = a4
    tbl_upv_3.ControlPoint = a5
    tbl_upv_3.EndPoint = a6
    tbl_upv_3.Alpha = a7 or 1
    tbl_upv_3.Time = a8 or 1
    tbl_upv_3.Definition = a9 or 40
    tbl_upv_3.MaxStretch = a10 or 4
    local function getParentSolvedWorld(a11, a12)
        --[[
          name: getParentSolvedWorld
          line: 124
          upvalues:
            a2 (copy, index: 1)
        ]]
        local Parent_1 = a11.Parent
        if Parent_1 and Parent_1:IsA("Bone") then
            return a12[Parent_1] or (Parent_1.TransformedWorldCFrame)
        elseif Parent_1 and Parent_1:IsA("BasePart") then
            return Parent_1.CFrame
        else
            return a2.CFrame
        end
    end
    local function getLocalAimAxis(a13, a14)
        --[[
          name: getLocalAimAxis
          line: 138
        ]]
        if a14 then
            local Position_1 = a14.CFrame.Position
            if Position_1.Magnitude > 0.001 then
                return Position_1.Unit
            end
        end
        return Vector3.new(0, 1, 0)
    end
    local function sampleCurveByDistance(a15, a16, a17)
        --[[
          name: sampleCurveByDistance
          line: 178
        ]]
        if a17 > 0 then
            if a16 > a17 then
                local v3, v4 = nil, nil
                for n_1 = 2, #a15 do
                    v3 = a15[n_1]
                    v4 = a15[n_1 - 1]
                    if a17 > v3.distance then
                        continue
                    end
                    local v5 = v3.distance - v4.distance
                    local v6 = 0
                    if v5 > 0.001 then
                        v6 = (a17 - v4.distance) / v5
                    end
                    return v4.point:Lerp(v3.point, v6)
                end
            end
            return a15[#a15].point
        end
        return a15[1].point
    end
    local function rotationBetweenVectors(a18, a19)
        --[[
          name: rotationBetweenVectors
          line: 98
        ]]
        local Unit_1 = a18.Unit
        local Unit_2 = a19.Unit
        local v7 = math.clamp(Unit_1:Dot(Unit_2), -1, 1)
        if v7 > 0.9999 then
            return CFrame.identity
        end
        if v7 >= -0.9999 then
            return CFrame.fromAxisAngle(Unit_1:Cross(Unit_2).Unit, math.acos(v7))
        end
        local v8 = Unit_1:Cross(Vector3.new(1, 0, 0))
        if v8.Magnitude < 0.001 then
            v8 = Unit_1:Cross(Vector3.new(0, 1, 0))
        end
        return CFrame.fromAxisAngle(v8.Unit, math.pi)
    end
    local function calculateRestLength(a20)
        --[[
          name: calculateRestLength
          line: 206
        ]]
        local v9 = 0
        local tbl_4 = {}
        local tbl_5 = {}
        for key_2, _ in ipairs(a20) do
            tbl_5[key_2] = v9
            local v10 = a20[key_2 + 1]
            if v10 then
                tbl_4[key_2] = v10.CFrame.Position.Magnitude
            else
                tbl_4[key_2] = tbl_4[key_2 - 1] or 0.5
            end
            v9 = v9 + tbl_4[key_2]
        end
        return v9, tbl_4, tbl_5
    end
    local function buildCurveSamples(a21, a22, a23, a24, a25)
        --[[
          name: buildCurveSamples
          line: 150
          upvalues:
            tbl_upv_1 (copy, index: 1)
        ]]
        local tbl_6 = {}
        local v11 = 0
        local v12 = tbl_upv_1:VectorBezier(a21, a22, a23, 0)
        tbl_6[1] = {distance = 0, point = v12}
        for n_2 = 1, a24 do
            local v13 = tbl_upv_1:VectorBezier(a21, a22, a23, (n_2 / a24) * math.max(0.01, a25 or 1))
            v11 = v11 + (v13 - v12).Magnitude
            tbl_6[n_2 + 1] = {point = v13, distance = v11}
            v12 = v13
        end
        return tbl_6, v11
    end
    tbl_upv_3.Connection = RunService_upv_1.PreSimulation:Connect(
        function(a26)
            --[[
              line: 227
              upvalues:
                tbl_upv_3 (copy, index: 1)
                calculateRestLength (copy, index: 2)
                a3 (copy, index: 3)
                buildCurveSamples (copy, index: 4)
                a2 (copy, index: 5)
                sampleCurveByDistance (copy, index: 6)
                rotationBetweenVectors (copy, index: 7)
            ]]
            if tbl_upv_3.StartPoint and tbl_upv_3.ControlPoint then
                local v14 = nil
                if tbl_upv_3.EndPoint then
                    v14 = tbl_upv_3.Alpha or 1
                    if v14 == 0 then
                        return
                    end
                    local v15, v16, v17 = calculateRestLength(a3)
                    local v18, v19 = buildCurveSamples(tbl_upv_3.StartPoint, tbl_upv_3.ControlPoint, tbl_upv_3.EndPoint, tbl_upv_3.Definition, tbl_upv_3.Time or 1)
                    local v20 = math.clamp(v19 / v15, 1, tbl_upv_3.MaxStretch)
                    local tbl_7 = {}
                    local v21, v22 = nil, nil
                    local v23 = nil
                    local value_3 = nil
                    for key_3, value_3 in ipairs(a3) do
                        local v24 = value_3.Parent
                        if not (v24) or not (v24:IsA("Bone")) then
                            if not (v24) or not (v24:IsA("BasePart")) then
                                v21 = a2.CFrame
                                v24 = value_3.Transform
                                local v25 = v17[key_3] * v20
                                local v26 = sampleCurveByDistance(v18, v19, v25)
                                local v27 = sampleCurveByDistance(v18, v19, v25 + (v16[key_3] * v20)) - v26
                                if v27.Magnitude <= 0.001 then
                                    local v28 = CFrame.new(v26) * ((v21 * value_3.CFrame) - (v21 * value_3.CFrame).Position)
                                    local v29 = value_3.CFrame:Inverse() * v21:Inverse() * v28
                                    tbl_7[value_3] = v28
                                    v22 = v29
                                    value_3.Transform = v30:Lerp(v22, v14)
                                    continue
                                end
                                local Unit_3 = v27.Unit
                                local v31 = v21 * value_3.CFrame
                                local v32 = v31 - v31.Position
                                local v33 = a3[key_3 + 1]
                                if not (v33) then
                                    v23 = Vector3.new(0, 1, 0)
                                    local v34 = rotationBetweenVectors(v31:VectorToWorldSpace(v23), Unit_3)
                                    local v35 = CFrame.new(v26) * v34 * v32
                                    v22 = value_3.CFrame:Inverse() * v21:Inverse() * v35
                                    tbl_7[value_3] = v35
                                    value_3.Transform = v30:Lerp(v22, v14)
                                    continue
                                end
                                local Position_2 = v33.CFrame.Position
                                if Position_2.Magnitude <= 0.001 then
                                    v23 = Vector3.new(0, 1, 0)
                                else
                                    v23 = Position_2.Unit
                                end
                                local v34 = rotationBetweenVectors(v31:VectorToWorldSpace(v23), Unit_3)
                                local v35 = CFrame.new(v26) * v34 * v32
                                v22 = value_3.CFrame:Inverse() * v21:Inverse() * v35
                                tbl_7[value_3] = v35
                                value_3.Transform = v30:Lerp(v22, v14)
                            end
                            v21 = v24.CFrame
                            v24 = value_3.Transform
                            local v25 = v17[key_3] * v20
                            local v26 = sampleCurveByDistance(v18, v19, v25)
                            local v27 = sampleCurveByDistance(v18, v19, v25 + (v16[key_3] * v20)) - v26
                            if v27.Magnitude <= 0.001 then
                                local v28 = CFrame.new(v26) * ((v21 * value_3.CFrame) - (v21 * value_3.CFrame).Position)
                                local v29 = value_3.CFrame:Inverse() * v21:Inverse() * v28
                                tbl_7[value_3] = v28
                                v22 = v29
                                value_3.Transform = v30:Lerp(v22, v14)
                                continue
                            end
                            local Unit_3 = v27.Unit
                            local v31 = v21 * value_3.CFrame
                            local v32 = v31 - v31.Position
                            local v33 = a3[key_3 + 1]
                            if not (v33) then
                                v23 = Vector3.new(0, 1, 0)
                                local v34 = rotationBetweenVectors(v31:VectorToWorldSpace(v23), Unit_3)
                                local v35 = CFrame.new(v26) * v34 * v32
                                v22 = value_3.CFrame:Inverse() * v21:Inverse() * v35
                                tbl_7[value_3] = v35
                                value_3.Transform = v30:Lerp(v22, v14)
                                continue
                            end
                            local Position_2 = v33.CFrame.Position
                            if Position_2.Magnitude <= 0.001 then
                                v23 = Vector3.new(0, 1, 0)
                            else
                                v23 = Position_2.Unit
                            end
                            local v34 = rotationBetweenVectors(v31:VectorToWorldSpace(v23), Unit_3)
                            local v35 = CFrame.new(v26) * v34 * v32
                            v22 = value_3.CFrame:Inverse() * v21:Inverse() * v35
                            tbl_7[value_3] = v35
                            value_3.Transform = v30:Lerp(v22, v14)
                        end
                        v21 = tbl_7[v24] or (v24.TransformedWorldCFrame)
                        v24 = value_3.Transform
                        local v25 = v17[key_3] * v20
                        local v26 = sampleCurveByDistance(v18, v19, v25)
                        local v27 = sampleCurveByDistance(v18, v19, v25 + (v16[key_3] * v20)) - v26
                        if v27.Magnitude <= 0.001 then
                            local v28 = CFrame.new(v26) * ((v21 * value_3.CFrame) - (v21 * value_3.CFrame).Position)
                            local v29 = value_3.CFrame:Inverse() * v21:Inverse() * v28
                            tbl_7[value_3] = v28
                            v22 = v29
                            value_3.Transform = v30:Lerp(v22, v14)
                            continue
                        end
                        local Unit_3 = v27.Unit
                        local v31 = v21 * value_3.CFrame
                        local v32 = v31 - v31.Position
                        local v33 = a3[key_3 + 1]
                        if not (v33) then
                            v23 = Vector3.new(0, 1, 0)
                            local v34 = rotationBetweenVectors(v31:VectorToWorldSpace(v23), Unit_3)
                            local v35 = CFrame.new(v26) * v34 * v32
                            v22 = value_3.CFrame:Inverse() * v21:Inverse() * v35
                            tbl_7[value_3] = v35
                            value_3.Transform = v30:Lerp(v22, v14)
                            continue
                        end
                        local Position_2 = v33.CFrame.Position
                        if Position_2.Magnitude <= 0.001 then
                            v23 = Vector3.new(0, 1, 0)
                        else
                            v23 = Position_2.Unit
                        end
                        local v34 = rotationBetweenVectors(v31:VectorToWorldSpace(v23), Unit_3)
                        local v35 = CFrame.new(v26) * v34 * v32
                        v22 = value_3.CFrame:Inverse() * v21:Inverse() * v35
                        tbl_7[value_3] = v35
                        value_3.Transform = v30:Lerp(v22, v14)
                    end
                elseif tbl_upv_3 and tbl_upv_3.Destroy then
                    tbl_upv_3:Destroy()
                else
                    warn("MEMORY LEAK!!!")
                end
            elseif tbl_upv_3 and tbl_upv_3.Destroy then
                tbl_upv_3:Destroy()
            else
                warn("MEMORY LEAK!!!")
            end
        end
    )
    function tbl_upv_3.Destroy(a27)
        --[[
          name: Destroy
          line: 306
          upvalues:
            tbl_upv_3 (copy, index: 1)
        ]]
        tbl_upv_3.Connection:Disconnect()
        table.clear(tbl_upv_3)
    end
    return tbl_upv_3
end
function tbl_upv_1.GetLocalTranslator(a1)
    --[[
      name: GetLocalTranslator
      line: 314
      upvalues:
        Players_upv_1 (copy, index: 1)
        LocalizationService_upv_1 (copy, index: 2)
    ]]
    local LocalPlayer_upv_1 = Players_upv_1.LocalPlayer
    if LocalPlayer_upv_1 then
        local success_1, v36 = pcall(
            function()
                --[[
                  line: 321
                  upvalues:
                    LocalizationService_upv_1 (copy, index: 1)
                    LocalPlayer_upv_1 (copy, index: 2)
                ]]
                return LocalizationService_upv_1:GetTranslatorForPlayer(LocalPlayer_upv_1)
            end
        )
        if success_1 then
            return v36
        end
        warn((("[%*]: Failed to get translator for player: %*, got: %*"):format(script:GetFullName(), LocalPlayer_upv_1, v36)))
    else
        warn((("[%*]: No local player found, returning..."):format(script:GetFullName())))
    end
end
function tbl_upv_1.AddHitboxes(a1, a2, a3)
    --[[
      name: AddHitboxes
      line: 333
      upvalues:
        u3 (copy, index: 1)
    ]]
    local v37 = ((typeof(a2) == "table") and (a2.Config)) or {}
    local v38 = ((typeof(a2) == "table") and (a2.Rig)) or a2
    local tbl_8 = {}
    local v39 = v38 and (v38:IsA("Model"))
    assert(v39, "character must be a model")
    for _, value_4 in ipairs({"CollisionHitbox", "QueryHitbox"}) do
        while v38:FindFirstChild(value_4) do
            v38[value_4]:Destroy()
        end
    end
    local v40
    if v37 then
        if v37.Instances then
            v40 = v37.Instances.CollisionHitbox
        else
            v40 = v37.CollisionHitbox
        end
    else
        v40 = nil
    end
    local v41 = (v40 or (game.ReplicatedStorage.Assets.Instances.CollisionHitbox)):Clone()
    local v42 = v41:GetAttribute("CFrameOffset") or (CFrame.new(0, 0.5, 0))
    v41.CFrame = v38.PrimaryPart.CFrame * v42
    v41.Name = "CollisionHitbox"
    local v43
    if v37 then
        if v37.Instances then
            v43 = v37.Instances.QueryHitbox
        else
            v43 = v37.QueryHitbox
        end
    else
        v43 = nil
    end
    local v44 = (v43 or (game.ReplicatedStorage.Assets.Instances.QueryHitbox)):Clone()
    local v45 = v41:GetAttribute("CFrameOffset") or (CFrame.new(0, -0.25, 0))
    v44.CFrame = v38.PrimaryPart.CFrame * v45
    v44.Name = "QueryHitbox"
    v44.CanQuery = true
    v44:SetAttribute("CFOffset", v45)
    local v46 = v38:HasTag("Replicating")
    local v47 = v46 and (game.Players:GetPlayerFromCharacter(v38))
    local v48 = nil
    for _, value_5 in pairs({v41, v44}) do
        v48 = false
        if value_5 == v44 then
            v48 = v47
        end
        local v49 = Instance.new("WeldConstraint")
        v49.Enabled = not v48
        v49.Name = "CollisionConnector"
        v49.Parent = value_5
        v49.Part1 = value_5
        v49.Part0 = v38.PrimaryPart
        value_5.CollisionGroup = a3
        value_5.CustomPhysicalProperties = u3
        value_5.Anchored = v48
        value_5.Parent = v38
        tbl_8[value_5.Name] = value_5
    end
    return tbl_8
end
function tbl_upv_1.FixCharacter(a1, a2, a3)
    --[[
      name: FixCharacter
      line: 385
      upvalues:
        tbl_upv_2 (copy, index: 1)
        u3 (copy, index: 2)
    ]]
    local tbl_9 = {}
    local v50 = nil
    for _, value_6 in ipairs(a2:GetDescendants()) do
        if value_6:GetAttribute("Hitbox") or not (value_6:IsA("BasePart")) or value_6.CollisionGroup == "Ragdolls" then
            continue
        end
        if tbl_upv_2[value_6.Name] or a2:GetAttribute("CustomRig") then
            v50 = value_6.Parent == a2
        end
        if v50 then
            table.insert(tbl_9, value_6)
        end
        value_6.Anchored = false
        value_6.Massless = not v50 and (value_6 ~= a2.PrimaryPart)
        if value_6 == a2.PrimaryPart then
            value_6.CanCollide = true
            value_6.CanQuery = true
            value_6.CanTouch = true
            value_6.CustomPhysicalProperties = u3
            value_6.CollisionGroup = a3 or "Survivors"
            continue
        end
        value_6.CanCollide = false
        value_6.CanQuery = v50 or false
        value_6.CanTouch = v50 or false
        value_6.CollisionGroup = "None"
        if value_6.Parent ~= a2 then
            value_6.RootPriority = -2
        end
    end
    for _, value_7 in ipairs(tbl_9) do
        value_7.CustomPhysicalProperties = PhysicalProperties.new(3.5 / #tbl_9, u3.Friction, u3.Elasticity, u3.FrictionWeight, u3.ElasticityWeight)
    end
end
function tbl_upv_1.GetEntityType(a1, a2)
    --[[
      name: GetEntityType
      line: 437
    ]]
    local v51 = a2:GetAttribute("EntityType")
    if v51 then
        return v51 == "Humanoid", v51
    elseif not (a2:IsDescendantOf(workspace.Players)) and not (a2:HasTag("SimulateSurvivor")) then
        if a2:GetAttribute("OwnerName") then
            return false, "Building"
        end
        return false, "Entity"
    else
        return true, "Humanoid"
    end
end
function tbl_upv_1.SnapToAxis(a1, a2)
    --[[
      name: SnapToAxis
      line: 454
    ]]
    local v52 = math.abs(a2.X)
    local v53 = math.abs(a2.Y)
    local v54 = math.abs(a2.Z)
    if v53 < v52 and v54 < v52 then
        return (Vector3.new(math.sign(a2.X), 0, 0))
    elseif v52 < v53 and v54 < v53 then
        return (Vector3.new(0, math.sign(a2.Y), 0))
    else
        return (Vector3.new(0, 0, math.sign(a2.Z)))
    end
end
function tbl_upv_1.IsPlayerKiller(a1, a2)
    --[[
      name: IsPlayerKiller
      line: 468
    ]]
    local Character_1 = a2.Character
    return Character_1 and (Character_1.Parent and (Character_1.Parent.Name == "Killers"))
end
function tbl_upv_1.GetDistanceFromGround(a1, a2)
    --[[
      name: GetDistanceFromGround
      line: 473
    ]]
    local v55 = a2:FindFirstChildOfClass("Humanoid")
    local v56 = (v55 and (v55.HipHeight)) or 2
    local tbl_10 = {a2:FindFirstChild("Left Leg"), a2:FindFirstChild("Right Leg")}
    local function absVector(a3, a4, a5)
        --[[
          name: absVector
          line: 479
        ]]
        return (Vector3.new(math.abs(a3), math.abs(a4), math.abs(a5)))
    end
    for _, value_8 in tbl_10 do
        if value_8:IsA("Model") then
            v56 = math.max(value_8:GetExtentsSize().Y, v56)
            continue
        end
        local v57 = value_8:IsA("BasePart")
        if v57 then
            local v58 = value_8.CFrame:VectorToWorldSpace(value_8.Size)
            local v59 = value_8.CFrame:VectorToObjectSpace(Vector3.new(math.abs(v58.Z), math.abs(v58.Y), math.abs(v58.X)))
            v56 = math.max(Vector3.new(math.abs(v59.X), math.abs(v59.Y), math.abs(v59.Z)).Y, v56)
        end
    end
    return (math.clamp((a2 and (v56 + a2.Size.Y / 2)) or v56, 2, 10))
end
function tbl_upv_1.IsAlive(a1, a2)
    --[[
      name: IsAlive
      line: 504
    ]]
    if a2 and typeof(a2) == "Instance" and a2.Parent and a2.PrimaryPart and a2:FindFirstChild("Humanoid") and a2.Humanoid.Health > 0 then
        return true
    end
    return false
end
function tbl_upv_1.EmitParticlesFromAttachment(a1, a2)
    --[[
      name: EmitParticlesFromAttachment
      line: 509
    ]]
    for _, value_9 in pairs(a2:GetChildren()) do
        if value_9:IsA("ParticleEmitter") then
            value_9:Emit(value_9:GetAttribute("EmitCount") or 1)
        end
    end
end
function tbl_upv_1.RemoveInstancesFromTableOfInstances(a1, a2, a3)
    --[[
      name: RemoveInstancesFromTableOfInstances
      line: 517
    ]]
    for key_4, value_10 in pairs(a2) do
        if a3[value_10.Name] or a3[value_10.ClassName] then
            table.remove(a2, key_4)
        end
    end
    return a2
end
function tbl_upv_1.DoFOVBop(a1, a2, a3, a4, a5)
    --[[
      name: DoFOVBop
      line: 527
      upvalues:
        tbl_upv_1 (copy, index: 1)
        HttpService_upv_1 (copy, index: 2)
        TweenService_upv_1 (copy, index: 3)
    ]]
    local u4 = tbl_upv_1:CreateFOVMultiplier(a2, a3, HttpService_upv_1:GenerateGUID(false))
    local v60 = TweenService_upv_1:Create(u4, a5, {Value = a4})
    v60:Play()
    v60.Completed:Once(
        function(a6)
            --[[
              line: 533
              upvalues:
                u4 (copy, index: 1)
            ]]
            u4:Destroy()
        end
    )
end
function tbl_upv_1.LoadAnimationFromID(a1, a2, a3, a4)
    --[[
      name: LoadAnimationFromID
      line: 539
    ]]
    if a2 then
        if a3 then
            if typeof(a3) ~= "string" then
                return
            end
            if a3 ~= "rbxassetid://0" then
                local v61 = a2:FindFirstChild("Animator", true)
                while not (v61) do
                    task.wait()
                    v61 = a2:FindFirstChild("Animator", true)
                end
                local v62 = a2:FindFirstChild(a3)
                if v62 then
                    return v61:LoadAnimation(v62)
                end
                local v63 = Instance.new("Animation")
                v63.Name = a3
                v63.AnimationId = a3
                v63.Parent = a2
                local v64 = v61:LoadAnimation(v63)
                local v65 = 0
                local v66 = false
                if a4 and v64.Length <= 0 then
                    local v67 = v66
                    repeat
                        v65 = v65 + task.wait()
                        if v65 >= 5 and v67 == false then
                            local v68 = true
                            warn((("[Util :: LoadAnimationFromID]: Animation %* is taking a while to load!"):format(a3)))
                            v67 = v68
                        end
                        if v64.Length > 0 then
                            break
                        end
                    until v65 >= 25
                end
                return v64
            end
            warn((("[Util :: LoadAnimationFromID]: Invalid ID %* for rig %*!"):format(a3, a2.Name)))
        else
            warn(debug.traceback("no ID found while loading animation onto rig!"))
        end
    else
        warn(debug.traceback("no rig found while loading animation from ID!"))
    end
end
function tbl_upv_1.PlayDummyCutsceneAnimations(a1, a2, a3, a4)
    --[[
      name: PlayDummyCutsceneAnimations
      line: 584
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v69 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5)
    local tbl_11 = {}
    if not v69 then
        return tbl_11
    end
    local Dummies_1 = v69:FindFirstChild("Dummies")
    if Dummies_1 then
        for _, value_upv_11 in ipairs(Dummies_1:GetChildren()) do
            if a2.Config.Animations[a4][value_upv_11.Name .. "Rig"] then
                local u5 = tbl_upv_1:LoadAnimationFromID(value_upv_11, a2.Config.Animations[a4][value_upv_11.Name .. "Rig"])
                u5.Looped = false
                u5:Play()
                u5.Stopped:Once(
                    function()
                        --[[
                          line: 597
                          upvalues:
                            value_upv_11 (copy, index: 1)
                            u5 (copy, index: 2)
                        ]]
                        for _, value_12 in ipairs(value_upv_11:GetChildren()) do
                            if value_12:IsA("BasePart") then
                                value_12.Anchored = true
                            end
                        end
                        u5:Play()
                        u5.TimePosition = u5.Length
                        u5:AdjustSpeed(0)
                    end
                )
                game.Debris:AddItem(u5, a3 + 3)
                tbl_11[value_upv_11] = u5
            end
        end
        return tbl_11
    end
end
function tbl_upv_1.GetRandomFriendLocal(a1)
    --[[
      name: GetRandomFriendLocal
      line: 617
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    assert(game:GetService("RunService"):IsClient(), "GetRandomFriendLocal() can only be called on the client context!")
    local success_2, v70 = pcall(
        function()
            --[[
              line: 620
              upvalues:
                Players_upv_1 (copy, index: 1)
            ]]
            return Players_upv_1:GetFriendsAsync(Players_upv_1.LocalPlayer.UserId)
        end
    )
    if success_2 then
        local v71 = v70:GetCurrentPage()
        local v72 = v71 and (v71[math.random(#v71)])
        return v72
    end
    warn((("[%*:GetFirstFriendLocal()]: Failed to get friends list for local player: %*"):format(script.Name, v70)))
    return nil
end
function tbl_upv_1.ApplyDamage(a1, a2, a3, a4)
    --[[
      name: ApplyDamage
      line: 634
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local tbl_12, v77
    local AchievementUtil_1 = require(game.ReplicatedStorage.Modules.Data.AchievementUtil)
    local Actors_1 = require(game.ReplicatedStorage.Modules.Gameplay.Actors)
    local Humanoid_1 = a2:FindFirstChild("Humanoid")
    local num_1 = tonumber(a3)
    if not num_1 or not Humanoid_1 or Humanoid_1.Health <= 0 or a2:GetAttribute("Invincible") then
        return
    end
    local ResistanceMultipliers_1 = a2:FindFirstChild("ResistanceMultipliers")
    local v73 = 0
    local v74 = (ResistanceMultipliers_1 and (ResistanceMultipliers_1:GetChildren())) or {}
    for _, value_13 in pairs(v74) do
        v73 = v73 + value_13.Value
    end
    local v75 = num_1 * (1 - (math.min(v73, 100) / 100))
    local v76 = Actors_1.CurrentActors[game.Players:GetPlayerFromCharacter(a2)]
    if v76 and v76.Behavior and v76.Behavior.OnHit then
        tbl_12 = {TimePast = 0}
        v76.Behavior:OnHit(v76, tbl_12, v75)
        if tbl_12.TimePast ~= 0 then
            return
        end
        tbl_12 = Humanoid_1:GetAttribute("Overheal") or 0
        v77 = a2:GetAttribute("ShatterpointHP") or 0
    else
        tbl_12 = Humanoid_1:GetAttribute("Overheal") or 0
        v77 = a2:GetAttribute("ShatterpointHP") or 0
    end
    local v78 = a2:GetAttribute("DusekkarProtected")
    local v79 = v78 and (game.Players:FindFirstChild(a2:GetAttribute("DusekkarProtected")))
    local v80 = math.max(0, tbl_12 - v75)
    if v80 < (Humanoid_1:GetAttribute("OverhealDecayMin") or 0) then
        Humanoid_1:SetAttribute("OverhealDecayMin", ((v80 > 0) and v80) or nil)
    end
    v75 = v75 - tbl_12
    local v84 = nil
    if v75 > 0 then
        if v77 > 0 then
            v84 = v75 * (a2:GetAttribute("ShatterpointResistance") or 1)
            local v82, v83 = nil, nil
            if v84 > 0 then
                v82 = tbl_upv_1:GetActor(a2)
                if v82 and v82.Behavior and v82.Behavior.sv_DamageCrystalHP then
                    v82.Behavior:sv_DamageCrystalHP(v82, v84)
                else
                    a2:SetAttribute("ShatterpointHP", (math.max(0, v77 - v84)))
                end
                v83 = v84 - v77
                if v83 <= 0 then
                    v75 = 0
                else
                    v75 = v83
                end
            end
        end
    end
    v75 = math.clamp(v75, 0, Humanoid_1.Health - (a4 or 0))
    if Humanoid_1.Health - v75 <= 0 then
        v84 = true
    else
        v84 = false
    end
    if v84 and v79 then
        Actors_1:IncrementActorStats(v79, {Money = 10, EXP = 30, Action = "Prevented the death of a Survivor", KillerChance = 0.5})
        a2:SetAttribute("DusekkarProtected", nil)
        v79.Character:SetAttribute("Protecting", nil)
        AchievementUtil_1:IncrementAchievementProgress(v79, "DusekkarUbercharge")
        return
    end
    local v85 = Humanoid_1:GetAttribute("Overheal")
    if v85 then
        Humanoid_1:SetAttribute("Overheal", ((v80 > 0) and v80) or nil)
    end
    Humanoid_1.Health = Humanoid_1.Health - v75
    if Humanoid_1.Health <= 0 then
        Humanoid_1:SetAttribute("Overheal", nil)
        Humanoid_1:ChangeState(Enum.HumanoidStateType.Dead)
    end
    if Humanoid_1.Health > 0 then
        return
    end
    if tostring(a2.Parent) == "Survivors" then
        local RoundManager_1 = game.ServerScriptService.Server.Systems.Core.RoundManager
        local v86 = require(RoundManager_1)
        local _ = require(RoundManager_1.Configuration)
        if v86.CurrentSession and v86.CurrentSession.TimePast then
            local CurrentSession_1 = v86.CurrentSession
            CurrentSession_1.TimePast = CurrentSession_1.TimePast - (tonumber(v86.CurrentSession.Gamemode and (v86.CurrentSession.Gamemode.TimeAddedOnKill)) or 20)
        end
        local str_1 = tostring(a2:GetAttribute("RecentAttacker"))
        local v87 = tonumber(a2:GetAttribute("RecentAttackerTime")) or 0
        local v88 = game.Players:FindFirstChild(str_1)
        if v88 and tick() <= v87 + 12.5 then
            require(game.ReplicatedStorage.Modules.Data.Stats):UpdatePlayerStat(v88, "Kills", "Add", 1)
            local u6 = tbl_upv_1:GetActor(v88)
            if u6 and u6.Behavior and u6.Behavior.OnKill then
                local success_3, v89 = pcall(
                    function()
                        --[[
                          line: 757
                          upvalues:
                            u6 (copy, index: 1)
                            a2 (copy, index: 2)
                        ]]
                        return u6.Behavior.OnKill(u6, a2)
                    end
                )
                if not (success_3) then
                    warn((("[%*/CreateHitbox]: Failed to call .OnKill() due to: %*"):format(script, v89)))
                end
            end
            Actors_1:IncrementActorStats(v88, {Money = 15, EXP = 45, Action = "Killed a Survivor through damage over time"})
        end
    end
end
function tbl_upv_1.Heal(a1, a2, a3, a4)
    --[[
      name: Heal
      line: 783
    ]]
    local v90 = a2:GetAttribute("HardDamage") or 0
    if a2.MaxHealth - v90 >= a2.Health then
        a2.Health = math.clamp(a2.Health + a3, 0, a2.MaxHealth - v90)
        return true
    end
    return false
end
tbl_upv_1.SpeedCaps = {}
function tbl_upv_1.SetSpeedCap(a1, a2, a3, a4, a5)
    --[[
      name: SetSpeedCap
      line: 796
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if game["Run Service"]:IsClient() or not a3 then
        return
    end
    local u7 = a2 and ((a2:IsA("Model") and a2) or (a2.Character))
    if not u7 then
        return
    end
    if a4 then
        if not (tbl_upv_1.SpeedCaps[u7]) then
            tbl_upv_1.SpeedCaps[u7] = {}
        end
        tbl_upv_1.SpeedCaps[u7][a3] = {Value = a4, ID = math.random(0, 1e+06)}
    elseif tbl_upv_1.SpeedCaps[u7] then
        if tonumber(a5) then
            local ID_upv_1 = tbl_upv_1.SpeedCaps[u7].ID
            task.delay(
                a5,
                function()
                    --[[
                      line: 815
                      upvalues:
                        tbl_upv_1 (copy, index: 1)
                        u7 (copy, index: 2)
                        ID_upv_1 (copy, index: 3)
                        a3 (copy, index: 4)
                    ]]
                    if not tbl_upv_1.SpeedCaps[u7] or tbl_upv_1.SpeedCaps[u7].ID ~= ID_upv_1 then
                        return
                    end
                    tbl_upv_1.SpeedCaps[u7][a3] = nil
                end
            )
            return
        end
        tbl_upv_1.SpeedCaps[u7][a3] = nil
    end
end
local tbl_upv_13 = {}
local tbl_upv_14 = {}
function tbl_upv_1.GiveStackableAttribute(a1, a2, a3, a4, a5)
    --[[
      name: GiveStackableAttribute
      line: 832
      upvalues:
        tbl_upv_1 (copy, index: 1)
        tbl_upv_13 (copy, index: 2)
    ]]
    if not a2 then
        return
    end
    if typeof(a2) ~= "Model" or a2 and tbl_upv_1:IsAlive(a2) then
        local u8 = a4 or "Default"
        local v91 = tbl_upv_13[a2]
        if not (v91) then
            v91 = {}
            tbl_upv_13[a2] = v91
            a2.Destroying:Once(
                function()
                    --[[
                      line: 844
                      upvalues:
                        tbl_upv_13 (copy, index: 1)
                        a2 (copy, index: 2)
                    ]]
                    table.clear(tbl_upv_13[a2] or {})
                    tbl_upv_13[a2] = nil
                end
            )
        end
        local tbl_upv_15 = v91[a3]
        if not (tbl_upv_15) then
            tbl_upv_15 = {}
            v91[a3] = tbl_upv_15
        end
        local v92 = ((not (a2:GetAttribute(a3))) and 0) or (((typeof(a2:GetAttribute(a3)) ~= "number") and 1) or (a2:GetAttribute(a3)))
        local v93 = tbl_upv_15[u8]
        if v93 then
            if typeof(v93) == "thread" then
                pcall(task.cancel, v93)
            end
            v92 = v92 - 1
        end
        tbl_upv_15[u8] = nil
        a2:SetAttribute(a3, v92 + 1)
        if a5 then
            local v94 = task.delay(
                a5,
                function()
                    --[[
                      line: 876
                      upvalues:
                        tbl_upv_1 (copy, index: 1)
                        a2 (copy, index: 2)
                        tbl_upv_13 (copy, index: 3)
                        tbl_upv_15 (ref,  index: 4)
                        u8 (copy, index: 5)
                        a3 (copy, index: 6)
                    ]]
                    if not tbl_upv_1:IsAlive(a2) or not tbl_upv_13[a2] then
                        return
                    end
                    tbl_upv_15[u8] = nil
                    if next(tbl_upv_15) then
                        local v95 = ((not (a2:GetAttribute(a3))) and 0) or (((typeof(a2:GetAttribute(a3)) ~= "number") and 1) or (a2:GetAttribute(a3)))
                        a2:SetAttribute(a3, v95 - 1)
                    else
                        a2:SetAttribute(a3, nil)
                    end
                end
            )
            tbl_upv_15[u8] = v94
        else
            tbl_upv_15[u8] = true
        end
        return
    end
end
function tbl_upv_1.RemoveStackableAttribute(a1, a2, a3, a4)
    --[[
      name: RemoveStackableAttribute
      line: 894
      upvalues:
        tbl_upv_1 (copy, index: 1)
        tbl_upv_13 (copy, index: 2)
    ]]
    if not a2 or typeof(a2) == "Model" and (not a2 or not (tbl_upv_1:IsAlive(a2))) then
        return
    end
    local v96 = tbl_upv_13[a2]
    if not v96 then
        return
    end
    local v97 = v96[a3]
    if v97 then
        local v98 = nil
        if a4 then
            v98 = v97[a4]
            if not v98 then
                return
            end
            if typeof(v98) == "thread" then
                pcall(task.cancel, v98)
            end
            v97[a4] = nil
            if next(v97) then
                local v99 = ((not (a2:GetAttribute(a3))) and 0) or (((typeof(a2:GetAttribute(a3)) ~= "number") and 1) or (a2:GetAttribute(a3)))
                a2:SetAttribute(a3, v99 - 1)
            else
                a2:SetAttribute(a3, nil)
            end
        else
            for key_5, value_14 in pairs(v97) do
                if typeof(value_14) == "thread" then
                    pcall(task.cancel, value_14)
                end
                v97[key_5] = nil
            end
            table.clear(v97 or {})
            a2:SetAttribute(a3, nil)
        end
    end
end
function tbl_upv_1.GiveStackableProperty(a1, a2, a3, a4)
    --[[
      name: GiveStackableProperty
      line: 938
      upvalues:
        tbl_upv_14 (copy, index: 1)
    ]]
    local v100 = a4 or "Default"
    local v101 = tbl_upv_14[a2]
    if not (v101) then
        v101 = {}
        tbl_upv_14[a2] = v101
        a2.Destroying:Once(
            function()
                --[[
                  line: 947
                  upvalues:
                    tbl_upv_14 (copy, index: 1)
                    a2 (copy, index: 2)
                ]]
                table.clear(tbl_upv_14[a2] or {})
                tbl_upv_14[a2] = nil
            end
        )
    end
    local v102 = v101[a3]
    if not (v102) then
        local tbl_16 = {}
        v101[a3] = tbl_16
        v102 = tbl_16
    end
    a2[a3] = true
    v102[v100] = true
end
function tbl_upv_1.HasStackableProperty(a1, a2, a3, a4)
    --[[
      name: HasStackableProperty
      line: 966
      upvalues:
        tbl_upv_14 (copy, index: 1)
    ]]
    local v103 = tbl_upv_14[a2]
    if v103 == nil then
        return false
    end
    local v104 = v103[a3]
    if v104 == nil then
        return false
    elseif a4 ~= nil then
        if v104[a4] ~= nil then
            return true
        end
        return false
    else
        local v105 = next(v104) ~= nil
        return v105
    end
end
function tbl_upv_1.RemoveStackableProperty(a1, a2, a3, a4)
    --[[
      name: RemoveStackableProperty
      line: 990
      upvalues:
        tbl_upv_14 (copy, index: 1)
    ]]
    if a2 then
        local v106 = tbl_upv_14[a2]
        if v106 then
            local v107 = v106[a3]
            if v107 then
                if a4 then
                    if v107[a4] then
                        v107[a4] = nil
                        if next(v107) then
                            warn("reasons for property", a3, "still present, not removing", v107)
                        else
                            a2[a3] = false
                        end
                    else
                        warn(a3, "not applied with reason", a4)
                    end
                else
                    for key_6, _ in pairs(v107) do
                        v107[key_6] = nil
                    end
                    table.clear(v107 or {})
                    a2[a3] = false
                end
            else
                warn((("[%*]: '%*' property cache was never created for %* (caller: %*:%*)"):format(script, a3, a2, debug.info(2, "s"), debug.info(2, "l"))))
            end
        else
            warn((("[%*]: property cache was never created for character %* (caller: %*:%*)"):format(script, a2, debug.info(2, "s"), debug.info(2, "l"))))
        end
    else
        warn("no instance")
    end
end
function tbl_upv_1.GiveInvincible(a1, a2, a3, a4)
    --[[
      name: GiveInvincible
      line: 1041
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if typeof(a2) == "Instance" then
        local v108 = a2:IsA("Model") and (a2.PrimaryPart)
        if v108 and not (v108:FindFirstChild("InvincibleFX")) then
            game.ReplicatedStorage.Assets.UI.InvincibleVFX.InvincibleFX:Clone().Parent = v108
        end
        tbl_upv_1:GiveStackableAttribute(a2, "Invincible", a3)
        if a4 then
            task.delay(
                a4,
                function()
                    --[[
                      line: 1057
                      upvalues:
                        tbl_upv_1 (copy, index: 1)
                        a2 (copy, index: 2)
                        a3 (copy, index: 3)
                    ]]
                    tbl_upv_1:RemoveInvincible(a2, a3)
                end
            )
        end
    else
        warn("Attempted to make a non-instance invincible")
    end
end
function tbl_upv_1.RemoveInvincible(a1, a2, a3)
    --[[
      name: RemoveInvincible
      line: 1063
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if typeof(a2) == "Instance" then
        tbl_upv_1:RemoveStackableAttribute(a2, "Invincible", a3)
        if not (a2:GetAttribute("Invincible")) then
            local v109 = a2:IsA("Model") and (a2.PrimaryPart)
            if v109 then
                local InvincibleFX_1 = v109:FindFirstChild("InvincibleFX")
                if InvincibleFX_1 then
                    InvincibleFX_1.Name = "Destroying"
                    InvincibleFX_1.Main.Enabled = false
                    game.Debris:AddItem(InvincibleFX_1, 0.6)
                end
            end
        end
    else
        warn("Attempted to make a non-instance not invincible")
    end
end
function tbl_upv_1.ToggleAnchored(a1, a2, a3, a4)
    --[[
      name: ToggleAnchored
      line: 1085
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v110 = a2 and (a2:IsA("Model") and (a2.PrimaryPart))
    if not v110 then
        return
    end
    if a4 then
        local v111 = a2:FindFirstChild("_anchor_part_")
        if v111 == nil then
            v111 = v110
        end
        tbl_upv_1:GiveStackableProperty(v111, "Anchored", a3)
    else
        local v112 = a2:FindFirstChild("_anchor_part_")
        if v112 == nil then
            v112 = v110
        end
        tbl_upv_1:RemoveStackableProperty(v112, "Anchored", a3)
    end
end
function tbl_upv_1.TogglePhysInterp(a1, a2, a3, a4)
    --[[
      name: TogglePhysInterp
      line: 1127
      upvalues:
        u1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        Network_upv_1 (copy, index: 3)
    ]]
    if typeof(a2) ~= "Instance" or not a2:IsA("Model") then
        return
    end
    if u1 then
        if a4 then
            tbl_upv_1:RemoveStackableAttribute(a2, "NoInterp", a3)
        else
            tbl_upv_1:GiveStackableAttribute(a2, "NoInterp", a3)
        end
    else
        Network_upv_1:FireAllClientConnection("ToggleInterp", "REMOTE_EVENT", a2, a3, a4)
    end
end
function tbl_upv_1.CreateValueMultiplier(self, player, multType, multiplier, multiplierName, duration, fadeout, valueType)
    --[[
      name: CreateValueMultiplier
      line: 1142
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        Debris_upv_1 (copy, index: 2)
    ]]
    local v113 = player and ((player:IsA("Model") and player) or (player.Character))
    local v114 = v113 and (v113:FindFirstChild(("%*Multipliers"):format(multType)))
    local _ = v114 and (v114:FindFirstChild(tostring(multiplierName)))
    local u9 = Instance.new(valueType or "NumberValue")
    u9.Value = multiplier or 1
    u9.Name = multiplierName or ("%*Multiplier"):format(multType)
    u9:SetAttribute("Tick", tick())
    u9:SetAttribute("Duration", duration)
    u9.Parent = v113
    if duration then
        if fadeout then
            task.delay(
                duration - 0.3,
                function()
                    --[[
                      line: 1152
                      upvalues:
                        TweenService_upv_1 (copy, index: 1)
                        u9 (copy, index: 2)
                    ]]
                    local tbl_17 = {Value = 1}
                    TweenService_upv_1:Create(u9, TweenInfo.new(0.3), tbl_17):Play()
                end
            )
        end
        Debris_upv_1:AddItem(u9, duration)
    end
    if v114 then
        v114:Destroy()
    end
    return u9
end
function tbl_upv_1.CreateSpeedMultiplier(a1, a2, a3, a4, a5, a6)
    --[[
      name: CreateSpeedMultiplier
      line: 1166
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    return tbl_upv_1:CreateValueMultiplier(a2, "Speed", a3, a4, a5, a6)
end
function tbl_upv_1.CreateFOVMultiplier(a1, a2, a3, a4, a5, a6)
    --[[
      name: CreateFOVMultiplier
      line: 1171
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    return tbl_upv_1:CreateValueMultiplier(a2, "FOV", a3, a4, a5, a6)
end
function tbl_upv_1.CreateCameraOffset(a1, a2, a3, a4, a5, a6)
    --[[
      name: CreateCameraOffset
      line: 1176
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    return tbl_upv_1:CreateValueMultiplier(a2, "CameraOffset", a3, a4, a5, a6, "Vector3Value")
end
function tbl_upv_1.CreateResistanceMultiplier(a1, a2, a3, a4, a5, a6)
    --[[
      name: CreateResistanceMultiplier
      line: 1181
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    return tbl_upv_1:CreateValueMultiplier(a2, "Resistance", a3, a4, a5, a6)
end
function tbl_upv_1.GetSettingValue(a1, a2, a3)
    --[[
      name: GetSettingValue
      line: 1186
      upvalues:
        u1 (copy, index: 1)
        DataHandler_upv_1 (copy, index: 2)
    ]]
    if u1 then
        local v116
        if a3 then
            v116 = DataHandler_upv_1:ReadPathFrom(a3, "Settings"):FindFirstChild(a2, true)
        else
            v116 = DataHandler_upv_1:ReadPath("Settings"):FindFirstChild(a2, true)
        end
        local v117 = v116 and v116.Value or nil
        return v117
    else
        local v118 = DataHandler_upv_1:ReadPathFrom(a3, "Settings"):FindFirstChild(a2, true)
        return (v118 and (v118.Value)) or nil
    end
end
function tbl_upv_1.ApplyOverheal(a1, a2, a3, a4)
    --[[
      name: ApplyOverheal
      line: 1202
    ]]
    local v119 = a2 and ((a2:IsA("Model") and a2) or (a2.Character))
    local u10 = v119 and (v119:FindFirstChild("Humanoid"))
    if not u10 or not tonumber(a3) then
        return
    end
    if a3 > 0 then
        if a4 then
            u10:SetAttribute("Overheal", (u10:GetAttribute("Overheal") or 0) + a3)
        else
            u10:SetAttribute("Overheal", a3)
        end
        if a4 then
            local u11 = math.random(-1e+07, 1e+07)
            u10:SetAttribute("DrainingID", u11)
            task.spawn(
                function()
                    --[[
                      line: 1228
                      upvalues:
                        u10 (copy, index: 1)
                        u11 (copy, index: 2)
                    ]]
                    while u10.Parent and u10.Health > 0 do
                        local v120
                        if u11 ~= u10:GetAttribute("DrainingID") then
                            break
                        end
                        local v121 = u10:GetAttribute("OverhealDecayMin") or 0
                        local v122 = task.wait()
                        v120 = u10:GetAttribute("Overheal")
                        local v123
                        if not (v120) then
                            break
                        end
                        v123 = math.clamp(v120 - (2 * v122), v121, math.huge)
                        if v123 > v121 then
                            u10:SetAttribute("Overheal", v123)
                            continue
                        else
                            u10:SetAttribute("Overheal", ((v121 > 0) and v121) or nil)
                            break
                        end
                    end
                    if u11 == u10:GetAttribute("DrainingID") then
                        local v124 = u10:GetAttribute("OverhealDecayMin") or 0
                        u10:SetAttribute("Overheal", ((v124 > 0) and v124) or nil)
                        u10:SetAttribute("DrainingID", nil)
                    end
                end
            )
        end
    else
        u10:SetAttribute("Overheal", nil)
        u10:SetAttribute("DrainingID", nil)
    end
end
function tbl_upv_1.GetPlayerMousePosition(a1, a2, ...)
    --[[
      name: GetPlayerMousePosition
      line: 1258
      upvalues:
        u2 (copy, index: 1)
        Network_upv_1 (copy, index: 2)
        u1 (copy, index: 3)
    ]]
    if u2 then
        return (Network_upv_1:FireClientConnection(a2, "GetMousePosition", "REMOTE_FUNCTION", ...))
    elseif u1 then
        return require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition):GetMousePos(...)
    end
end
function tbl_upv_1.GetPlayerCameraCFrame(a1, a2, ...)
    --[[
      name: GetPlayerCameraCFrame
      line: 1269
      upvalues:
        u2 (copy, index: 1)
        Network_upv_1 (copy, index: 2)
        u1 (copy, index: 3)
    ]]
    if u2 then
        return (Network_upv_1:FireClientConnection(a2, "GetCameraCFrame", "REMOTE_FUNCTION", ...))
    elseif u1 then
        return require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition):GetCameraCFrame(...)
    end
end
function tbl_upv_1.GetActor(a1, a2)
    --[[
      name: GetActor
      line: 1279
    ]]
    local v125 = a2:IsA("Model")
    local v126
    if v125 then
        v126 = game.Players:GetPlayerFromCharacter(a2)
    else
        v126 = a2
    end
    return require(game.ReplicatedStorage.Modules.Gameplay.Actors).CurrentActors[v126]
end
function tbl_upv_1.SetUpCutscene(a1, a2, a3, a4, a5)
    --[[
      name: SetUpCutscene
      line: 1289
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v127 = tbl_upv_1:GetActor(a2) or a2
    local v128 = tbl_upv_1:GetActor(a3) or a3
    a5 = a5 or "Cutscene"
    local PrimaryPart_1 = a3.PrimaryPart
    local PrimaryPart_2 = a2.PrimaryPart
    local v129 = ((typeof(v127) == "table") and (v127:GetPivot().Position)) or (PrimaryPart_2.Position)
    local v130 = ((typeof(v128) == "table") and (v128:GetPivot().Position)) or (PrimaryPart_1.Position)
    local v131 = CFrame.new(v129, Vector3.new(v130.X, v129.Y, v130.Z))
    local v132 = v131
    if v131 ~= v132 then
        v131 = PrimaryPart_2.CFrame
    end
    v127:PivotTo(v131)
    local CFrame_1 = PrimaryPart_2.CFrame
    local v133 = a4 or (CFrame.new())
    v128:PivotTo(CFrame_1 * v133)
    a2.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    a3.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    tbl_upv_1:ToggleAnchored(a2, a5, true)
    tbl_upv_1:ToggleAnchored(a3, a5, true)
    tbl_upv_1:GiveStackableAttribute(a3, "NoItems", a5, 7)
end
function tbl_upv_1.RagdollLaunch(a1, a2, a3, a4, a5)
    --[[
      name: RagdollLaunch
      line: 1317
    ]]
    local v134 = RaycastParams.new()
    v134.FilterDescendantsInstances = workspace.Players:GetDescendants()
    v134.FilterType = Enum.RaycastFilterType.Exclude
    local v135 = a2.Rig.PrimaryPart.Size.X / 2
    local v136 = ((typeof(a2) == "table") and (a2:GetPivot().Position)) or (a2.PrimaryPart.Position)
    local Magnitude_1 = a4.Magnitude
    local v137 = Magnitude_1 / 10
    local v138 = workspace:Raycast(a3.PrimaryPart.Position, a4.Unit * v137, v134)
    local v139 = v138 and v138.Distance or v137
    local v140 = a4 * game.TweenService:GetValue(v139 / v137, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    a3:SetPrimaryPartCFrame(CFrame.new(v136 + (a4.Unit * v135)))
    a3.PrimaryPart.AssemblyLinearVelocity = v140
    local Ragdolls_1 = require(game.ReplicatedStorage.Modules.Rendering.Ragdolls)
    Ragdolls_1.AddProfile(a3, {Velocity = v140})
    local EnableRagdoll_1 = Ragdolls_1.EnableRagdoll
    local v141 = a5 or (math.clamp(Magnitude_1 / 80, 0.5, 5))
    EnableRagdoll_1(a3, v141)
end
function tbl_upv_1.SelectRandomKillers(a1, a2, a3)
    --[[
      name: SelectRandomKillers
      line: 1343
      upvalues:
        DataHandler_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    local tbl_18 = {}
    local tbl_19 = {}
    local v142 = nil
    for _, value_15 in pairs(a2) do
        local Instance_1 = value_15.Instance and (DataHandler_upv_1:Get(value_15.Instance, 1))
        v142 = Instance_1 and (Instance_1:FindFirstChild("Stats"))
        local v150 = v142 and (v142:FindFirstChild("KillerChance", true))
        local v143 = Instance_1 and (Instance_1:FindFirstChild("Misc"))
        local v144 = v143 and (v143:FindFirstChild("IsCurrentlyKiller"))
        if not (v142) then
            continue
        end
        if v144 then
            value_15.KillerChance = v142
            value_15.isCurrentlyKiller = v144
            table.insert(tbl_19, value_15)
        end
    end
    local v145 = workspace:GetAttribute("ServerType") == "VIP"
    if v145 then
        tbl_upv_1:ShuffleTable(tbl_19)
    else
        table.sort(
            tbl_19,
            function(a4, a5)
                --[[
                  line: 1370
                ]]
                return a5.KillerChance.Value < a4.KillerChance.Value
            end
        )
    end
    local v146 = ((workspace:GetAttribute("ForcedKiller")) and 1) or 0
    local v147 = math.clamp(#a2 - 1, v146, math.huge)
    if v147 >= 1 then
        local v148, v148 = nil, nil
        for _ = 1, math.clamp(a3, 1, v147) do
            v148 = nil
            v142 = nil
            local v149 = workspace:GetAttribute("ForcedKiller")
            workspace:SetAttribute("ForcedKiller", nil)
            if v149 then
                for key_7, value_16 in pairs(tbl_19) do
                    if tostring(value_16.Instance) == v149 then
                        v148, v142 = value_16, key_7
                    end
                end
            end
            if not v148 then
                v148, v142 = tbl_19[1], 1
            end
            if not (v148) or not (v142) then
                continue
            end
            if not (v145) then
                v148.KillerChance.Value = 1
                v148.isCurrentlyKiller.Value = true
            end
            table.insert(tbl_18, v148)
            table.remove(tbl_19, v142)
        end
    end
    if not (v145) then
        for _, value_17 in pairs(tbl_19) do
            tbl_upv_1:AddToPlayerStat(value_17.Instance, "KillerChance", 1)
        end
    end
    return tbl_18, tbl_19
end
function tbl_upv_1.PreloadAssets(a1, a2, a3)
    --[[
      name: PreloadAssets
      line: 1445
      upvalues:
        u1 (copy, index: 1)
    ]]
    task.spawn(
        function()
            --[[
              line: 1449
              upvalues:
                u1 (copy, index: 1)
                a2 (copy, index: 2)
                a3 (copy, index: 3)
            ]]
            local u12 = {}
            local function fetchAssets(a4)
                --[[
                  name: fetchAssets
                  line: 1451
                  upvalues:
                    fetchAssets (copy, index: 1)
                    u12 (ref,  index: 2)
                    u1 (copy, index: 3)
                ]]
                for key_8, value_18 in pairs(a4) do
                    if typeof(value_18) == "table" then
                        fetchAssets(value_18)
                        continue
                    end
                    if typeof(value_18) == "Instance" then
                        table.insert(u12, value_18)
                        continue
                    end
                    if typeof(value_18) ~= "string" or not (value_18:find("rbxassetid://")) then
                        continue
                    end
                    if key_8 ~= "Sounds" then
                        table.insert(u12, value_18)
                        continue
                    end
                    if u1 then
                        local v150 = Instance.new("Sound")
                        v150.Parent = workspace:FindFirstChild("Sounds")
                        v150.SoundId = value_18
                        v150.Volume = 0
                        v150:Play()
                        game.Debris:AddItem(v150, 1)
                    end
                    table.insert(u12, value_18)
                end
            end
            fetchAssets(a2)
            game.ContentProvider:PreloadAsync(u12, a3)
            table.clear(u12)
            u12 = nil
        end
    )
end
function tbl_upv_1.ToggleLockForAbilityIcon(a1, a2, a3, a4)
    --[[
      name: ToggleLockForAbilityIcon
      line: 1479
    ]]
    local AbilityContainer_1 = game.Players.LocalPlayer.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
    local u13 = AbilityContainer_1 and (AbilityContainer_1:FindFirstChild(tostring(a2)))
    if not u13 then
        return
    end
    local function setAbilityIconTitleTransparencies(a5)
        --[[
          name: setAbilityIconTitleTransparencies
          line: 1487
          upvalues:
            u13 (copy, index: 1)
        ]]
        local Clipping_1 = u13:FindFirstChild("Clipping")
        local CooldownTime_1 = u13:FindFirstChild("CooldownTime")
        if Clipping_1 then
            Clipping_1.Visible = a5
        end
        if not CooldownTime_1 then
            return
        end
        CooldownTime_1.Visible = a5
    end
    if not (a4) or u13:FindFirstChild(a3) then
        local v151 = nil
        if not (a4) then
            v151 = u13:FindFirstChild(a3)
            if v151 then
                v151:Destroy()
            end
        end
    else
        local v152 = script.AbilityLock:Clone()
        v152.Name = a3
        v152.Parent = u13
    end
    local function v153()
        --[[
          name: updateAbilityIconTitleTransparencies
          line: 1495
          upvalues:
            u13 (copy, index: 1)
        ]]
        local v154 = false
        for _, value_19 in pairs(u13:GetChildren()) do
            if value_19:GetAttribute("IsLockObject") == true then
                v154 = true
                break
            end
        end
        local Clipping_2 = u13:FindFirstChild("Clipping")
        local CooldownTime_2 = u13:FindFirstChild("CooldownTime")
        if Clipping_2 then
            Clipping_2.Visible = not v154
        end
        if not CooldownTime_2 then
            return
        end
        CooldownTime_2.Visible = not v154
    end
    v153()
end
function tbl_upv_1.ToggleLocksForAbilityIcons(a1, a2, a3)
    --[[
      name: ToggleLocksForAbilityIcons
      line: 1530
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local AbilityContainer_2 = game.Players.LocalPlayer.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
    local v155 = (AbilityContainer_2 and (AbilityContainer_2:GetChildren())) or {}
    for _, value_20 in pairs(v155) do
        if value_20:IsA("GuiObject") then
            tbl_upv_1:ToggleLockForAbilityIcon(value_20.Name, a2, a3)
        end
    end
end
local u14 = nil
function tbl_upv_1.CreateDisplayUI(a1, a2)
    --[[
      name: CreateDisplayUI
      line: 1544
      upvalues:
        u14 (ref,  index: 1)
        TweenService_upv_1 (copy, index: 2)
        Debris_upv_1 (copy, index: 3)
    ]]
    if not (u14) then
        u14 = Instance.new("ScreenGui")
        u14.Name = "KillerIntroUI"
        u14.DisplayOrder = 10
        u14.ResetOnSpawn = false
        u14.Parent = game.Players.LocalPlayer.PlayerGui
    end
    local tbl_upv_20 = {}
    local KillerDisplays_upv_1 = game.ReplicatedStorage.Assets.UI.KillerDisplays
    local u15 = KillerDisplays_upv_1.KillerDisplayBackground:Clone()
    u15.Parent = u14
    u15.ImageTransparency = 1
    u15.Title.TextTransparency = 1
    u15.Title.Text = ((#a2 <= 1) and "This round's killer is...") or "This round's killers are..."
    local tbl_21 = {ImageTransparency = 0}
    TweenService_upv_1:Create(u15, TweenInfo.new(0.2), tbl_21):Play()
    local tbl_22 = {TextTransparency = 0}
    TweenService_upv_1:Create(u15.Title, TweenInfo.new(0.4, Enum.EasingStyle.Quint), tbl_22):Play()
    table.insert(tbl_upv_20, u15)
    table.insert(tbl_upv_20, u15.Title)
    task.delay(
        0.65,
        function()
            --[[
              line: 1567
              upvalues:
                a2 (copy, index: 1)
                KillerDisplays_upv_1 (copy, index: 2)
                u15 (copy, index: 3)
                TweenService_upv_1 (copy, index: 4)
                tbl_upv_20 (copy, index: 5)
            ]]
            for key_9, value_21 in pairs(a2) do
                local v156 = KillerDisplays_upv_1.Display:Clone()
                v156.Parent = u15.Displays
                v156.LayoutOrder = key_9
                v156.KillerName.Text = value_21.KillerName
                v156.PlayerName.Text = ("(%*)"):format(value_21.PlayerName)
                v156.KillerName.TextTransparency = 1
                v156.PlayerName.TextTransparency = 1
                local tbl_23 = {TextTransparency = 0}
                TweenService_upv_1:Create(v156.KillerName, TweenInfo.new(0.2), tbl_23):Play()
                local tbl_24 = {TextTransparency = 0.6}
                TweenService_upv_1:Create(v156.PlayerName, TweenInfo.new(0.2), tbl_24):Play()
                table.insert(tbl_upv_20, v156.KillerName)
                table.insert(tbl_upv_20, v156.PlayerName)
                if key_9 ~= #a2 then
                    local v157 = KillerDisplays_upv_1.Separator:Clone()
                    v157.Parent = u15.Displays
                    v157.LayoutOrder = key_9
                    v157.TextTransparency = 1
                    local tbl_25 = {TextTransparency = 0}
                    TweenService_upv_1:Create(v157, TweenInfo.new(0.2), tbl_25):Play()
                    table.insert(tbl_upv_20, v157)
                end
            end
        end
    )
    task.delay(
        5,
        function()
            --[[
              line: 1593
              upvalues:
                tbl_upv_20 (copy, index: 1)
                Debris_upv_1 (copy, index: 2)
                TweenService_upv_1 (copy, index: 3)
            ]]
            for _, value_22 in pairs(tbl_upv_20) do
                Debris_upv_1:AddItem(value_22, 0.5)
                if value_22:IsA("TextLabel") then
                    local tbl_26 = {TextTransparency = 1}
                    TweenService_upv_1:Create(value_22, TweenInfo.new(0.5), tbl_26):Play()
                    continue
                end
                if value_22:IsA("ImageLabel") then
                    local tbl_27 = {ImageTransparency = 1}
                    TweenService_upv_1:Create(value_22, TweenInfo.new(0.5), tbl_27):Play()
                end
            end
        end
    )
end
local u16 = nil
function tbl_upv_1.CreateTooltip(a1, a2)
    --[[
      name: CreateTooltip
      line: 1608
      upvalues:
        u16 (ref,  index: 1)
        Sounds_upv_1 (copy, index: 2)
        UserInputService_upv_1 (copy, index: 3)
    ]]
    if u16 then
        if u16.Title.Text == tostring(a2) and u16.Parent then
            if not (u16) and a2 then
                local v158 = UserInputService_upv_1:GetMouseLocation() - game.GuiService:GetGuiInset()
                u16 = script.Tooltip:Clone()
                u16.Title.Text = a2
                local Title_1 = u16.Title
                Title_1.Position = UDim2.fromOffset(v158.X, v158.Y + -28)
                local Background_1 = u16.Background
                Background_1.Position = UDim2.fromOffset(v158.X, (v158.Y + -28) - (u16.Title.AbsoluteSize.Y / 2))
                local Background_2 = u16.Background
                Background_2.Size = UDim2.fromOffset(u16.Title.AbsoluteSize.X + 64, u16.Title.AbsoluteSize.Y + 50)
                local v159 = u16
                v159.Parent = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
                Sounds_upv_1:Play("hover")
                task.spawn(
                    function()
                        --[[
                          line: 1631
                          upvalues:
                            u16 (ref,  index: 1)
                            UserInputService_upv_1 (copy, index: 2)
                        ]]
                        while u16 do
                            if u16.Parent then
                                local v160 = UserInputService_upv_1:GetMouseLocation() - game.GuiService:GetGuiInset()
                                local Title_2 = u16.Title
                                Title_2.Position = UDim2.fromOffset(v160.X, v160.Y + -28)
                                local Background_3 = u16.Background
                                Background_3.Position = UDim2.fromOffset(v160.X, (v160.Y + -28) - (u16.Title.AbsoluteSize.Y / 2))
                                local Background_4 = u16.Background
                                Background_4.Size = UDim2.fromOffset(u16.Title.AbsoluteSize.X + 64, u16.Title.AbsoluteSize.Y + 50)
                                task.wait()
                                continue
                            else
                                break
                            end
                        end
                    end
                )
            end
        else
            if u16.Parent then
                local tbl_28 = {TextSize = 0, TextTransparency = 1}
                game.TweenService:Create(u16.Title, TweenInfo.new(0.15), tbl_28):Play()
                local Background_5 = u16.Background
                local v161 = TweenInfo.new(0.15)
                local tbl_29 = {ImageTransparency = 1}
                tbl_29.Size = UDim2.fromScale()
                game.TweenService:Create(Background_5, v161, tbl_29):Play()
                game.Debris:AddItem(u16, 0.15)
                Sounds_upv_1:Play("hoverEnd")
            end
            u16 = nil
        end
    elseif not (u16) and a2 then
        local v158 = UserInputService_upv_1:GetMouseLocation() - game.GuiService:GetGuiInset()
        u16 = script.Tooltip:Clone()
        u16.Title.Text = a2
        local Title_1 = u16.Title
        Title_1.Position = UDim2.fromOffset(v158.X, v158.Y + -28)
        local Background_1 = u16.Background
        Background_1.Position = UDim2.fromOffset(v158.X, (v158.Y + -28) - (u16.Title.AbsoluteSize.Y / 2))
        local Background_2 = u16.Background
        Background_2.Size = UDim2.fromOffset(u16.Title.AbsoluteSize.X + 64, u16.Title.AbsoluteSize.Y + 50)
        local v159 = u16
        v159.Parent = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
        Sounds_upv_1:Play("hover")
        task.spawn(
            function()
                --[[
                  line: 1631
                  upvalues:
                    u16 (ref,  index: 1)
                    UserInputService_upv_1 (copy, index: 2)
                ]]
                while u16 do
                    if u16.Parent then
                        local v160 = UserInputService_upv_1:GetMouseLocation() - game.GuiService:GetGuiInset()
                        local Title_2 = u16.Title
                        Title_2.Position = UDim2.fromOffset(v160.X, v160.Y + -28)
                        local Background_3 = u16.Background
                        Background_3.Position = UDim2.fromOffset(v160.X, (v160.Y + -28) - (u16.Title.AbsoluteSize.Y / 2))
                        local Background_4 = u16.Background
                        Background_4.Size = UDim2.fromOffset(u16.Title.AbsoluteSize.X + 64, u16.Title.AbsoluteSize.Y + 50)
                        task.wait()
                        continue
                    else
                        break
                    end
                end
            end
        )
    end
    return u16
end
function tbl_upv_1.AddToPlayerStat(a1, a2, a3, a4, a5)
    --[[
      name: AddToPlayerStat
      line: 1645
      upvalues:
        DataHandler_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    if workspace:GetAttribute("ServerType") == "VIP" and a5 ~= true then
        return
    end
    local v162 = (typeof(a2) == "Instance") and (DataHandler_upv_1:Get(a2, 1))
    local v163 = v162 and (v162.Stats:FindFirstChild(tostring(a3), true))
    if not v163 then
        return
    end
    if v163:IsA("NumberValue") then
        if a3 ~= "KillerChance" or a5 or not v162.Settings.Game.MaliceDisabled.Value then
            if a3 == "Money" or a3 == "KillerChance" or a3 == "EXPBoostTime" then
                game.AnalyticsService:LogEconomyEvent(a2, Enum.AnalyticsEconomyFlowType.Source, a3, tonumber(a4) or 0, v162.Value + (tonumber(a4) or 0), Enum.AnalyticsEconomyTransactionType.Gameplay.Name)
            end
        end
        v162.Value = v162.Value + (tonumber(a4) or 0)
        if a3 ~= "Money" then
            return
        end
        tbl_upv_1:AddToPlayerStat(a2, "NetWorth", a4)
    end
end
function tbl_upv_1.CopyTable(a1, a2, a3)
    --[[
      name: CopyTable
      line: 1690
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if typeof(a2) ~= "table" then
        return a2
    end
    local v164 = a3 or {}
    a3 = v164
    local v165 = a3[a2]
    if v165 then
        return v165
    end
    local tbl_30 = {}
    a3[a2] = tbl_30
    for key_10, value_23 in next, a2 do
        tbl_30[key_10] = tbl_upv_1:CopyTable(value_23, v164)
    end
    return tbl_30
end
function tbl_upv_1.JoinTables(a1, ...)
    --[[
      name: JoinTables
      line: 1713
    ]]
    local tbl_31 = {}
    for _, value_24 in ipairs(table.pack(...)) do
        for v1, value_25 in pairs(value_24) do
            table.insert(tbl_31, value_25)
        end
    end
    return tbl_31
end
function tbl_upv_1.MergeTables(a1, a2, a3, a4)
    --[[
      name: MergeTables
      line: 1726
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if not a3 then
        return a2
    end
    local tbl_32 = {Voicelines = true, TerrorRadiusThemes = true, Emotes = true}
    local tbl_33 = {}
    for key_11, value_26 in pairs(a2 or {}) do
        if typeof(value_26) == "table" and typeof(a3[key_11]) == "table" then
            tbl_33[key_11] = tbl_upv_1:MergeTables(value_26, a3[key_11], a4)
        else
            tbl_33[key_11] = value_26
        end
    end
    for key_12, value_27 in pairs(a3 or {}) do
        if typeof(value_27) == "table" and typeof(a2[key_12]) == "table" and not (tbl_32[key_12]) then
            tbl_33[key_12] = tbl_upv_1:MergeTables(a2[key_12], value_27, a4)
            continue
        end
        if not (table.find(a4 or {}, key_12)) then
            tbl_33[key_12] = value_27
        end
    end
    return tbl_33
end
function tbl_upv_1.ShuffleTable(a1, a2)
    --[[
      name: ShuffleTable
      line: 1759
    ]]
    for n_3 = #a2, 1, -1 do
        local v166 = math.random(n_3)
        local v167 = a2[n_3]
        a2[n_3] = a2[v166]
        a2[v166] = v167
    end
    return a2
end
function tbl_upv_1.ToCommas(a1, a2)
    --[[
      name: ToCommas
      line: 1771
    ]]
    return tostring(a2):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
function tbl_upv_1.ConvertToAbbreviation(a1, a2)
    --[[
      name: ConvertToAbbreviation
      line: 1781
    ]]
    local function formatNumber(a3)
        --[[
          name: formatNumber
          line: 1782
        ]]
        if a3 % 1 ~= 0 then
            if (a3 * 10) % 1 ~= 0 then
                return string.format("%.2f", a3)
            end
            return string.format("%.1f", a3)
        end
        return string.format("%.0f", a3)
    end
    if a2 < 1e+15 then
        if a2 < 1e+12 then
            if a2 < 1e+09 then
                if a2 < 1e+06 then
                    if a2 < 1000 then
                        return formatNumber(a2)
                    end
                    return formatNumber(a2 / 1000) .. "K+"
                end
                return formatNumber(a2 / 1e+06) .. "M+"
            end
            return formatNumber(a2 / 1e+09) .. "B+"
        end
        return formatNumber(a2 / 1e+12) .. "T+"
    end
    return formatNumber(a2 / 1e+15) .. "Q+"
end
function tbl_upv_1.RoundNumber(a1, a2, a3)
    --[[
      name: RoundNumber
      line: 1807
    ]]
    return (tonumber(string.format("%." .. (a3 or 0) .. "f", a2)))
end
function tbl_upv_1.CalculateLevelFromEXP(a1, a2)
    --[[
      name: CalculateLevelFromEXP
      line: 1812
      upvalues:
        sqrt_upv_1 (copy, index: 1)
        floor_upv_1 (copy, index: 2)
    ]]
    local v168 = floor_upv_1((sqrt_upv_1((a2 * 20) + 11225) + -95) / 10)
    if v168 ~= 1 then
        return v168, a2 - ((((v168 * 5) * v168) + (v168 * 95)) - 110), (v168 * 10) + 100
    end
    return v168, a2, 100
end
function tbl_upv_1.FormatTime(a1, a2, a3)
    --[[
      name: FormatTime
      line: 1828
      upvalues:
        Initializer_upv_1 (copy, index: 1)
    ]]
    if a2 then
        if a3 then
            local v169 = math.floor(a2 / 86400)
            local v170 = math.floor((a2 % 86400) / 3600)
            local v171 = math.floor((a2 % 3600) / 60)
            local v172 = math.floor(a2 % 60)
            local v173 = ""
            if a3 ~= "Clock" then
                if a3 == "String" then
                    if v169 > 0 then
                        v173 = ("%*%*%*"):format(v173, v169, ((v169 ~= 1) and " days") or " day")
                    end
                    if v170 > 0 then
                        if v173 ~= "" then
                            local v174 = "%*%*"
                            local v175 = nil
                            if v169 > 0 and v171 > 0 or v172 > 0 then
                                v175 = ", "
                                v173 = v174:format(v173, v175)
                                v173 = ("%*%*%*"):format(v173, v170, ((v170 ~= 1) and " hours") or " hour")
                                if v171 > 0 then
                                    if v173 ~= "" then
                                        local v176 = "%*%*"
                                        if v169 <= 0 and v170 <= 0 or v172 <= 0 then
                                            v175 = " and "
                                            v173 = v176:format(v173, v175)
                                            v173 = ("%*%*%*"):format(v173, v171, ((v171 ~= 1) and " minutes") or " minute")
                                            if v172 > 0 then
                                                if v173 ~= "" then
                                                    local v177 = "%*%*"
                                                    if v169 <= 0 and v170 <= 0 and v171 <= 0 then
                                                        v175 = ""
                                                    else
                                                        v175 = " and "
                                                    end
                                                    v173 = v177:format(v173, v175)
                                                end
                                                v173 = ("%*%*%*"):format(v173, v172, ((v172 ~= 1) and " seconds") or " second")
                                            end
                                            return v173
                                        end
                                        v175 = ", "
                                        v173 = v176:format(v173, v175)
                                    end
                                    v173 = ("%*%*%*"):format(v173, v171, ((v171 ~= 1) and " minutes") or " minute")
                                end
                                if v172 > 0 then
                                    if v173 ~= "" then
                                        local v177 = "%*%*"
                                        if v169 <= 0 and v170 <= 0 and v171 <= 0 then
                                            v175 = ""
                                        else
                                            v175 = " and "
                                        end
                                        v173 = v177:format(v173, v175)
                                    end
                                    v173 = ("%*%*%*"):format(v173, v172, ((v172 ~= 1) and " seconds") or " second")
                                end
                                return v173
                            end
                            v175 = " and "
                            v173 = v174:format(v173, v175)
                        end
                        v173 = ("%*%*%*"):format(v173, v170, ((v170 ~= 1) and " hours") or " hour")
                    end
                    if v171 > 0 then
                        if v173 ~= "" then
                            local v176 = "%*%*"
                            local v175 = nil
                            if v169 <= 0 and v170 <= 0 or v172 <= 0 then
                                v175 = " and "
                                v173 = v176:format(v173, v175)
                                v173 = ("%*%*%*"):format(v173, v171, ((v171 ~= 1) and " minutes") or " minute")
                                if v172 > 0 then
                                    if v173 ~= "" then
                                        local v177 = "%*%*"
                                        if v169 <= 0 and v170 <= 0 and v171 <= 0 then
                                            v175 = ""
                                        else
                                            v175 = " and "
                                        end
                                        v173 = v177:format(v173, v175)
                                    end
                                    v173 = ("%*%*%*"):format(v173, v172, ((v172 ~= 1) and " seconds") or " second")
                                end
                                return v173
                            end
                            v175 = ", "
                            v173 = v176:format(v173, v175)
                        end
                        v173 = ("%*%*%*"):format(v173, v171, ((v171 ~= 1) and " minutes") or " minute")
                    end
                    if v172 > 0 then
                        if v173 ~= "" then
                            local v177 = "%*%*"
                            local v175
                            if v169 <= 0 and v170 <= 0 and v171 <= 0 then
                                v175 = ""
                            else
                                v175 = " and "
                            end
                            v173 = v177:format(v173, v175)
                        end
                        v173 = ("%*%*%*"):format(v173, v172, ((v172 ~= 1) and " seconds") or " second")
                    end
                end
                return v173
            elseif v169 <= 0 then
                if v170 <= 0 then
                    return (string.format("%02d:%02d", v171, v172))
                end
                return (string.format("%02d:%02d:%02d", v170, v171, v172))
            else
                return (string.format("%d:%02d:%02d:%02d", v169, v170, v171, v172))
            end
        end
        Initializer_upv_1.Debug("can't format time due to formatType being nil!")
    else
        Initializer_upv_1.Debug("can't format time due to seconds being nil!")
    end
    return ""
end
function tbl_upv_1.IntToRoman(a1, a2)
    --[[
      name: IntToRoman
      line: 1879
    ]]
    if not tonumber(a2) then
        return "IDK"
    end
    local v178 = math.round(tonumber(a2))
    local tbl_34 = {{1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"}, {100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"}, {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}}
    local v179 = ""
    a2 = v178
    for _, value_28 in pairs(tbl_34) do
        v179 = nil
        while value_28[1] <= a2 do
            v179 = v179 .. value_28[2]
            a2 = a2 - value_28[1]
        end
    end
    return v179
end
function tbl_upv_1.ApplyCameraShake(a1, a2, a3)
    --[[
      name: ApplyCameraShake
      line: 1912
      upvalues:
        DataHandler_upv_1 (copy, index: 1)
    ]]
    if not DataHandler_upv_1:Get().Settings.Customization.ScreenShakeEnabled.Value then
        return
    end
    local time_upv_1 = tick()
    local u17 = nil
    local v180 = game:GetService("RunService").RenderStepped:Connect(
        function()
            --[[
              line: 1922
              upvalues:
                time_upv_1 (copy, index: 1)
                a3 (copy, index: 2)
                a2 (copy, index: 3)
                u17 (ref,  index: 4)
            ]]
            local v181 = math.clamp((tick() - time_upv_1) / a3, 0, 1)
            local v182 = a2 * (1 - v181)
            local v183 = Vector3.new(((math.random() - 0.5) * 2) * v182, ((math.random() - 0.5) * 2) * v182, ((math.random() - 0.5) * 2) * v182)
            local CurrentCamera_1 = workspace.CurrentCamera
            CurrentCamera_1.CFrame = CurrentCamera_1.CFrame * CFrame.new(v183)
            if v181 < 1 then
                return
            end
            u17:Disconnect()
            u17 = nil
        end
    )
    u17 = v180
end
function tbl_upv_1.ApplyCameraShakeTo(a1, a2, a3, a4)
    --[[
      name: ApplyCameraShakeTo
      line: 1950
      upvalues:
        u2 (copy, index: 1)
        Network_upv_1 (copy, index: 2)
    ]]
    if not u2 then
        return
    end
    Network_upv_1:FireClientConnection(a2, "ShakeCamera", "REMOTE_EVENT", a3, a4)
end
function tbl_upv_1.RemoveCyclicReferences(a1, a2, a3)
    --[[
      name: RemoveCyclicReferences
      line: 1955
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v184 = a3 or {}
    local tbl_35 = {}
    for key_13 in pairs(a2) do
        if table.find(v184, a2[key_13]) then
            continue
        end
        if typeof(a2[key_13]) ~= "table" then
            tbl_35[key_13] = a2[key_13]
            continue
        end
        table.insert(v184, a2[key_13])
        tbl_35[key_13] = a2[key_13]
        local v185 = tbl_upv_1:RemoveCyclicReferences(a2[key_13], v184)
        for key_14 in pairs(tbl_35[key_13]) do
            if not (v185[key_14]) then
                tbl_35[key_13][key_14] = nil
            end
        end
    end
    return tbl_35
end
function tbl_upv_1.IsOnScreen(a1, a2, a3)
    --[[
      name: IsOnScreen
      line: 1979
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    if typeof(a2) ~= "Instance" then
        return
    end
    local _ = tick()
    local v186 = false
    local GetPlayerMousePosition_1 = require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition)
    local tbl_upv_36 = {}
    table.insert(tbl_upv_36, a2)
    table.insert(tbl_upv_36, game.Players.LocalPlayer.Character)
    table.insert(tbl_upv_36, workspace.CurrentCamera)
    for key_15, v190 in pairs(GetPlayerMousePosition_1.TransparentParts) do
        table.insert(tbl_upv_36, key_15)
    end
    local v187
    local function checkForVisibility(a4)
        --[[
          name: checkForVisibility
          line: 2000
          upvalues:
            tbl_upv_36 (copy, index: 1)
        ]]
        local _, v188 = workspace.CurrentCamera:WorldToViewportPoint(a4.Position)
        if v188 and #workspace.CurrentCamera:GetPartsObscuringTarget({workspace.CurrentCamera.CFrame.Position, a4.Position}, tbl_upv_36) == 0 then
            return true
        end
    end
    if a2:IsA("Model") then
        v187 = a2:FindFirstChild("Humanoid")
        local v189 = nil
        for v191, value_29 in pairs(a2:GetChildren()) do
            v189 = value_29:IsA("BasePart")
            if not (v189) then
                continue
            end
            if v187 and value_29.Parent == a2 and tbl_upv_2[value_29.Name] then
                v189 = true
            else
                v189 = false
            end
            if v189 or value_29.Transparency ~= 1 or a3 then
                v186 = checkForVisibility(value_29)
                if not (v186) then
                    continue
                end
                return v186
            end
        end
    else
        v187 = a2:IsA("BasePart")
        if v187 and (a2.Transparency ~= 1 or a3) then
            v186 = checkForVisibility(a2)
        end
    end
    return v186
end
function tbl_upv_1.CreateProgressBar(a1, a2, a3)
    --[[
      name: CreateProgressBar
      line: 2031
    ]]
    a2 = a2 or "Performing Action"
    local num_2 = tonumber(a3)
    a3 = num_2 or 5
    local u18 = game.ReplicatedStorage.Assets.UI.ProgressBar:Clone()
    u18.Title.Text = ("%*."):format(a2)
    u18.Parent = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
    game.Debris:AddItem(u18, a3)
    task.spawn(
        function()
            --[[
              line: 2041
              upvalues:
                u18 (copy, index: 1)
                a3 (ref,  index: 2)
                a2 (ref,  index: 3)
            ]]
            local v190 = 0
            local v191 = 0
            local v192 = 0
            while u18.Parent do
                local v193 = v190 / a3
                local v194 = ((v193 ~= 0) and (1 / v193)) or 0
                u18.Bar.Clipping.Size = UDim2.fromScale(v193, 1)
                u18.Bar.Clipping.Top.Size = UDim2.fromScale(v194, 1)
                if v191 >= 0.3 then
                    v191 = 0
                    v192 = v192 + 1
                    u18.Title.Text = ("%*%*"):format(a2, string.rep(".", (v192 % 3) + 1))
                end
                local v195 = game["Run Service"].Heartbeat:Wait()
                v190 = math.clamp(v190 + v195, 0, a3)
                v191 = v191 + v195
            end
        end
    )
    return u18
end
local u19 = nil
local u20 = nil
function tbl_upv_1.FadeIn(a1, a2)
    --[[
      name: FadeIn
      line: 2074
      upvalues:
        u20 (ref,  index: 1)
        Initializer_upv_1 (copy, index: 2)
        u19 (ref,  index: 3)
        TweenService_upv_1 (copy, index: 4)
    ]]
    a2 = a2 or {}
    if u20 and u20.Parent then
        Initializer_upv_1.Debug("FadeIn cancelled b/c there's already a fade that exists!")
        return
    end
    if not (u19) then
        u19 = Instance.new("ScreenGui")
        u19.Name = "FadeUI"
        u19.IgnoreGuiInset = true
        u19.ResetOnSpawn = false
        u19.DisplayOrder = 10
        u19.Parent = Initializer_upv_1.Player.PlayerGui
    end
    u20 = Instance.new("Frame")
    u20.Name = "Fade"
    u20.BackgroundTransparency = a2.StartTransparency or 1
    u20.BackgroundColor3 = a2.Color or Color3.new()
    u20.Size = UDim2.fromScale(1, 1)
    u20.Parent = u19
    if a2.InstantTween then
        u20.BackgroundTransparency = a2.EndTransparency or 0
    else
        local v197 = a2.TweenInfo or (TweenInfo.new(a2.Time or 0.325, Enum.EasingStyle.Linear))
        local v198 = TweenService_upv_1:Create(u20, v197, {BackgroundTransparency = a2.EndTransparency or 0})
        v198:Play()
        if not a2.Yield then
            return
        end
        v198.Completed:Wait()
    end
end
function tbl_upv_1.FadeOut(a1, a2)
    --[[
      name: FadeOut
      line: 2112
      upvalues:
        u20 (ref,  index: 1)
        Initializer_upv_1 (copy, index: 2)
        u19 (ref,  index: 3)
        TweenService_upv_1 (copy, index: 4)
        Debris_upv_1 (copy, index: 5)
    ]]
    a2 = a2 or {}
    if u20 then
        if u19 then
            local v199 = a2.TweenInfo or (TweenInfo.new(a2.Time or 0.325, Enum.EasingStyle.Linear))
            local v200 = TweenService_upv_1:Create(u20, v199, {BackgroundTransparency = a2.Transparency or 1})
            v200:Play()
            Debris_upv_1:AddItem(u20, v200.TweenInfo.Time)
            if a2.Yield then
                v200.Completed:Wait()
            end
            u20 = nil
        else
            Initializer_upv_1.Debug("FadeOut called before ever calling FadeIn!")
        end
    else
        Initializer_upv_1.Debug("FadeOut cancelled b/c there's no fade that exists!")
    end
end
function tbl_upv_1.CreateWarning(a1, a2, a3, a4)
    --[[
      name: CreateWarning
      line: 2134
    ]]
    local LocalPlayer_2 = game.Players.LocalPlayer
    local v201 = LocalPlayer_2.PlayerGui.TemporaryUI:FindFirstChild(a2)
    if v201 then
        v201:Destroy()
    end
    local u21 = (a4 or (game.ReplicatedStorage.Assets.UI.Warning)):Clone()
    u21.Name = a2
    u21.Title.Text = tostring(a3)
    u21.Parent = LocalPlayer_2.PlayerGui.TemporaryUI
    task.delay(
        3,
        function()
            --[[
              line: 2147
              upvalues:
                u21 (copy, index: 1)
            ]]
            if not u21.Parent then
                return
            end
            if u21:GetAttribute("InstantDeletion") then
                u21:Destroy()
            else
                game.Debris:AddItem(u21, 1)
                local tbl_37 = {BackgroundTransparency = 1}
                game.TweenService:Create(u21, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_37):Play()
                local tbl_38 = {TextTransparency = 1, BackgroundTransparency = 1, TextStrokeTransparency = 1}
                game.TweenService:Create(u21.Title, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_38):Play()
            end
        end
    )
end
function tbl_upv_1.DisplayBubble(a1, a2, a3)
    --[[
      name: DisplayBubble
      line: 2161
      upvalues:
        Network_upv_1 (copy, index: 1)
    ]]
    if not a2 then
        return
    end
    if game["Run Service"]:IsServer() then
        Network_upv_1:FireAllClientConnection("DisplayBubble", "REMOTE_EVENT", a2, a3)
    else
        game.TextChatService:DisplayBubble(a2, a3)
    end
end
function tbl_upv_1.ToggleControls(a1, a2)
    --[[
      name: ToggleControls
      line: 2171
      upvalues:
        Initializer_upv_1 (copy, index: 1)
    ]]
    local v202 = require(Initializer_upv_1.Player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
    if a2 then
        v202:Enable()
    else
        v202:Disable()
    end
end
function tbl_upv_1.ToggleResetButton(a1, a2)
    --[[
      name: ToggleResetButton
      line: 2183
    ]]
    task.spawn(
        function()
            --[[
              line: 2184
              upvalues:
                a2 (copy, index: 1)
            ]]
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", a2)
        end
    )
end
function tbl_upv_1.ToggleSprinting(a1, a2, a3, a4)
    --[[
      name: ToggleSprinting
      line: 2191
      upvalues:
        Network_upv_1 (copy, index: 1)
    ]]
    Network_upv_1:FireConnection("DisableSprinting", a2, not a3)
    if not a4 then
        return
    end
    task.delay(
        a4,
        function()
            --[[
              line: 2194
              upvalues:
                Network_upv_1 (copy, index: 1)
                a2 (copy, index: 2)
                a3 (copy, index: 3)
            ]]
            Network_upv_1:FireConnection("DisableSprinting", a2, a3)
        end
    )
end
function tbl_upv_1.CreateMoneyDisplay(a1, a2)
    --[[
      name: CreateMoneyDisplay
      line: 2201
      upvalues:
        tbl_upv_1 (copy, index: 1)
        DataHandler_upv_1 (copy, index: 2)
        Sounds_upv_1 (copy, index: 3)
        Initializer_upv_1 (copy, index: 4)
    ]]
    local u22 = Instance.new("NumberValue")
    u22:GetPropertyChangedSignal("Value"):Connect(
        function()
            --[[
              line: 2204
              upvalues:
                u22 (copy, index: 1)
                tbl_upv_1 (copy, index: 2)
                a2 (copy, index: 3)
            ]]
            a2.CurrentBalance.Text = ("%*$ "):format(tbl_upv_1:ToCommas(math.round(u22.Value)))
        end
    )
    local u23 = DataHandler_upv_1:Get():WaitForChild("Stats"):FindFirstChild("Money", true)
    u23:GetPropertyChangedSignal("Value"):Connect(
        function()
            --[[
              line: 2213
              upvalues:
                u22 (copy, index: 1)
                u23 (copy, index: 2)
                a2 (copy, index: 3)
            ]]
            local v203 = TweenInfo.new(1)
            local tbl_39 = {}
            tbl_39.Value = u23.Value
            game.TweenService:Create(u22, v203, tbl_39):Play()
            a2.CurrentBalance.TextSize = a2.CurrentBalance.AbsoluteSize.Y
        end
    )
    u22.Value = u23.Value
    a2.CurrentBalance.Text = ("%*$ "):format(tbl_upv_1:ToCommas(math.round(u22.Value)))
    a2.CurrentBalance.TextSize = a2.CurrentBalance.AbsoluteSize.Y
    a2.BuyMore.MouseEnter:Connect(
        function()
            --[[
              line: 2224
              upvalues:
                Sounds_upv_1 (copy, index: 1)
            ]]
            Sounds_upv_1:Play("hover")
        end
    )
    a2.BuyMore.MouseLeave:Connect(
        function()
            --[[
              line: 2225
              upvalues:
                Sounds_upv_1 (copy, index: 1)
            ]]
            Sounds_upv_1:Play("hoverEnd")
        end
    )
    a2.BuyMore.MouseButton1Click:Connect(
        function()
            --[[
              line: 2226
              upvalues:
                Initializer_upv_1 (copy, index: 1)
            ]]
            Initializer_upv_1.PlayerSystems.SidebarHandler.SidebarMenus.Shop:ToggleMenu(true)
            Initializer_upv_1.PlayerSystems.Shop:SwitchTab("Robux")
        end
    )
end
function tbl_upv_1.ApplyVelocity(a1, a2, a3, a4, a5)
    --[[
      name: ApplyVelocity
      line: 2235
      upvalues:
        Players_upv_1 (copy, index: 1)
        Maid_upv_1 (copy, index: 2)
        RunService_upv_1 (copy, index: 3)
    ]]
    if a2 then
        local v204 = a2:IsA("Model")
        if v204 then
            a2 = a2.PrimaryPart
        end
    end
    if not a2 then
        return nil
    end
    local AssemblyMass_1 = a2.AssemblyMass
    local v204 = AssemblyMass_1
    for u24, value_30 in a2.Parent:GetDescendants() do
        local v205 = value_30:IsA("BasePart")
        if not (v205) or value_30.Massless then
            continue
        end
        if value_30 ~= a2 then
            v204 = v204 + value_30.AssemblyMass
        end
    end
    local Actors_2 = require(game.ReplicatedStorage.Modules.Gameplay.Actors)
    local v206 = Players_upv_1:GetPlayerFromCharacter(a2.Parent)
    local u25 = v206 and (Actors_2.CurrentActors[v206])
    local u24 = u25 and (u25.GetPivot) and u25:GetPivot() or a2.CFrame
    local u26 = Instance.new("LinearVelocity")
    u26.MaxForce = v204 * 350
    u26.RelativeTo = Enum.ActuatorRelativeTo.World
    u26.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
    u26.LineDirection = Vector3.new(u24.LookVector.X, 0, u24.LookVector.Z)
    u26.LineVelocity = a3 or 0
    u26.Attachment0 = a2:FindFirstChild("RootAttachment") or a2:FindFirstChildOfClass("Attachment")
    u26.Parent = a2
    local u27 = Maid_upv_1.new()
    if a4 then
        task.spawn(
            function()
                --[[
                  line: 2262
                  upvalues:
                    u27 (copy, index: 1)
                    RunService_upv_1 (copy, index: 2)
                    u26 (copy, index: 3)
                    a2 (ref,  index: 4)
                    u24 (ref,  index: 5)
                    u25 (copy, index: 6)
                    a5 (copy, index: 7)
                ]]
                u27:Add(
                    RunService_upv_1.Heartbeat:Connect(
                        function(a6)
                            --[[
                              line: 2263
                              upvalues:
                                u26 (copy, index: 1)
                                a2 (ref,  index: 2)
                                u27 (copy, index: 3)
                                u24 (ref,  index: 4)
                                u25 (copy, index: 5)
                                a5 (copy, index: 6)
                            ]]
                            if not (u26.Active) or not (a2.Parent) then
                                u27:Destroy()
                            end
                            local v208 = ((u25 and (u25.GetPivot)) and (u25:GetPivot())) or (a2.CFrame)
                            u24 = v208
                            u26.LineDirection = u26.LineDirection:Lerp(Vector3.new(u24.LookVector.X, 0, u24.LookVector.Z), a5 or 0)
                        end
                    )
                )
            end
        )
    end
    return u26, u27
end
local u28 = TweenInfo.new(0.25)
local tbl_upv_40 = {}
local tbl_upv_41 = {}
local tbl_upv_42 = {}
function tbl_upv_1.RevealPlayerAura(a1, a2, a3, a4, a5, a6)
    --[[
      name: RevealPlayerAura
      line: 2283
      upvalues:
        tbl_upv_41 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        tbl_upv_40 (copy, index: 3)
        DataHandler_upv_1 (copy, index: 4)
        Network_upv_1 (copy, index: 5)
        Debris_upv_1 (copy, index: 6)
        TweenService_upv_1 (copy, index: 7)
        u28 (copy, index: 8)
        tbl_upv_42 (copy, index: 9)
    ]]
    if not a2 then
        return
    end
    a5 = a5 or -1
    local u29 = ((a2 and (a2:IsA("Player"))) and (a2.Character)) or a2
    local _ = u29 and (game.Players:GetPlayerFromCharacter(u29))
    local LocalPlayer_3 = game.Players.LocalPlayer
    local Character_2 = LocalPlayer_3.Character
    local v209 = tbl_upv_41[a2]
    if v209 then
        if v209.TimeCreated and v209.Duration then
            if v209.Duration == "inf" or a3 < v209.Duration - (os.clock() - v209.TimeCreated) then
                return
            end
            tbl_upv_1:RemovePlayerAuraFrom(a2, nil, true)
        end
    else
        tbl_upv_41[a2] = {}
        a2.Destroying:Once(
            function()
                --[[
                  line: 2295
                  upvalues:
                    tbl_upv_41 (copy, index: 1)
                    a2 (copy, index: 2)
                ]]
                tbl_upv_41[a2] = nil
            end
        )
    end
    tbl_upv_41[a2] = {TimeCreated = os.clock(), Duration = a3}
    if not u29 or not Character_2 or u29:GetAttribute("Undetectable") and tostring(u29.Parent) ~= tostring(Character_2.Parent) and #tbl_upv_1:GetAliveSurvivorCharacters() > 1 then
        return
    end
    local tbl_43 = {}
    tbl_43.Killers = Color3.new(1, 0, 0)
    tbl_43.Survivors = Color3.new(1, 0.75, 0)
    tbl_43.Spectating = Color3.new(1, 1, 1)
    local v210 = u29:FindFirstChild("PlayerAura") or (tbl_upv_40[u29])
    local v211 = a4 or (tbl_43[tostring(u29.Parent)] or (tbl_43[tostring(u29)] or (tbl_43.Spectating)))
    local Value_1 = DataHandler_upv_1:Get().Settings.Game.AltHighlights.Value
    if u29 then
        Network_upv_1:FireServerConnection("RevealedAura", "REMOTE_EVENT", u29, a3)
    end
    local v212 = nil
    if Value_1 then
        if u29:IsA("Model") and not (u29.PrimaryPart) then
            return
        end
        local u30 = game.ReplicatedStorage.Assets.UI.Highlight:Clone()
        u30.Name = "PlayerAura"
        local ViewportFrame_1 = u29:FindFirstChild("Head") or u29:IsA("Model") and u29.PrimaryPart or u29
        u30.Adornee = ViewportFrame_1
        u30.Container.ImageColor3 = v211
        u30.Parent = LocalPlayer_3.PlayerGui.TemporaryUI
        tbl_upv_40[u29] = u30
        ViewportFrame_1 = u30.Container.ViewportFrame
        local v213
        if u29:IsA("Model") then
            v213 = ViewportFrame_1.ModelCenter.CFrame
        else
            v213 = ViewportFrame_1.PartCenter.CFrame
        end
        local Archivable_1 = u29.Archivable
        u29.Archivable = true
        v212 = u29:Clone()
        u29.Archivable = Archivable_1
        if v212 then
            if u29:IsA("Model") then
                v212:SetPrimaryPartCFrame(v213)
            else
                v212.CFrame = v213
            end
            v212.Parent = ViewportFrame_1
            local tbl_upv_44 = {ViewportFrame_1, ViewportFrame_1.Parent}
            Debris_upv_1:AddItem(u30, tonumber(a3) or 10)
            if v210 then
                for v221, value_31 in pairs(tbl_upv_44) do
                    value_31.ImageTransparency = 0
                end
            else
                for v222, value_32 in pairs(tbl_upv_44) do
                    local tbl_45 = {ImageTransparency = 0}
                    TweenService_upv_1:Create(value_32, TweenInfo.new(1), tbl_45):Play()
                end
            end
            if a3 ~= "inf" then
                task.delay(
                    (tonumber(a3) or 10) - 1,
                    function()
                        --[[
                          line: 2406
                          upvalues:
                            u30 (ref,  index: 1)
                            tbl_upv_41 (copy, index: 2)
                            a2 (copy, index: 3)
                            tbl_upv_40 (copy, index: 4)
                            u29 (copy, index: 5)
                            tbl_upv_44 (copy, index: 6)
                            TweenService_upv_1 (copy, index: 7)
                        ]]
                        if not u30 or not u30.Parent then
                            return
                        end
                        u30.Name = "goodbai"
                        tbl_upv_41[a2] = nil
                        if tbl_upv_40[u29] == u30 then
                            tbl_upv_40[u29] = nil
                        end
                        for _, value_33 in pairs(tbl_upv_44) do
                            local tbl_46 = {ImageTransparency = 1}
                            TweenService_upv_1:Create(value_33, TweenInfo.new(1), tbl_46):Play()
                        end
                    end
                )
            end
            local v214 = u30.Adornee and (((u30.Adornee:IsA("Model")) and (u30.Adornee.PrimaryPart)) or (u30.Adornee:IsA("BasePart") and (u30.Adornee)))
            if not v214 then
                return
            end
            if a5 > 0 then
                if a5 < (v214.Position - Character_2.PrimaryPart.Position).Magnitude then
                    for v223, value_34 in pairs(tbl_upv_44) do
                        value_34.ImageTransparency = 1
                    end
                end
                local v215 = nil
                while task.wait(0.5) and (u30) and (u30.Parent) do
                    local v216 = a5 < (v214.Position - Character_2.PrimaryPart.Position).Magnitude
                    if v215 == v216 then
                        continue
                    end
                    for v224, value_35 in pairs(tbl_upv_44) do
                        local tbl_47 = {ImageTransparency = 0}
                        tbl_47.ImageTransparency = (v216 and 1) or 0
                        game.TweenService:Create(value_35, u28, tbl_47):Play()
                    end
                    v215 = v216
                end
            end
        else
            warn("i don't even know how this happens dude")
        end
    else
        local tbl_upv_48 = {}
        if v210 and tbl_upv_42[v210] then
            local v225 = tbl_upv_1:CopyTable(tbl_upv_42[v210])
            table.clear(tbl_upv_42[v210])
            tbl_upv_42[v210] = nil
        end
        for v226, value_36 in ipairs(u29:GetChildren()) do
            if not (value_36:IsA("Highlight")) then
                continue
            end
            if value_36.Name ~= "PlayerAura" then
                value_36.Parent = nil
                table.insert(tbl_upv_48, value_36)
            end
        end
        local u31 = Instance.new("Highlight")
        u31.Name = "PlayerAura"
        u31.FillColor = v211
        u31.OutlineColor = v211
        u31.Parent = u29
        for key_16, value_37 in a6 or {} do
            u31[key_16] = value_37
        end
        if a3 ~= "inf" then
            local num_3 = tonumber(a3)
            Debris_upv_1:AddItem(u31, num_3 or 10)
        end
        tbl_upv_42[u31] = tbl_upv_48
        local u32 = u29.ChildAdded:Connect(
            function(a7)
                --[[
                  line: 2485
                  upvalues:
                    u31 (ref, index: 1)
                    tbl_upv_48 (ref, index: 2)
                ]]
                if not u31 or not u31.Parent then
                    return
                end
                if a7.ClassName == "Highlight" and a7.Name ~= "PlayerAura" then
                    table.insert(tbl_upv_48, a7)
                end
            end
        )
        if not (v210) then
            local FillTransparency_1 = u31.FillTransparency
            local OutlineTransparency_1 = u31.OutlineTransparency
            u31.FillTransparency = 1
            u31.OutlineTransparency = 1
            local tbl_49 = {}
            tbl_49.FillTransparency = FillTransparency_1
            tbl_49.OutlineTransparency = OutlineTransparency_1
            TweenService_upv_1:Create(u31, TweenInfo.new(1), tbl_49):Play()
        end
        if a3 ~= "inf" then
            task.delay(
                (tonumber(a3) or 10) - 1,
                function()
                    --[[
                      line: 2506
                      upvalues:
                        u32 (copy, index: 1)
                        u31 (ref,  index: 2)
                        u29 (copy, index: 3)
                        tbl_upv_48 (ref,  index: 4)
                        tbl_upv_42 (copy, index: 5)
                        TweenService_upv_1 (copy, index: 6)
                        tbl_upv_41 (copy, index: 7)
                        a2 (copy, index: 8)
                    ]]
                    u32:Disconnect()
                    if not u31 then
                        return
                    end
                    if u31.Parent then
                        if u29 and u29.Parent then
                            for _, value_38 in pairs(tbl_upv_48) do
                                if (value_38 or value_38.Parent) and value_38.Name == "PlayerAura" then
                                    value_38.Parent = u29
                                end
                            end
                        else
                            for _, value_39 in pairs(tbl_upv_48) do
                                value_39:Destroy()
                            end
                        end
                        table.clear(tbl_upv_48)
                        tbl_upv_42[u31] = nil
                        u31.Name = "goodbai"
                        local tbl_50 = {FillTransparency = 1, OutlineTransparency = 1}
                        TweenService_upv_1:Create(u31, TweenInfo.new(1), tbl_50):Play()
                        tbl_upv_41[a2] = nil
                    end
                end
            )
        end
        local v217 = u31.Parent and (((u31.Parent:IsA("Model")) and (u31.Parent.PrimaryPart)) or (u31.Parent:IsA("BasePart") and (u31.Parent)))
        if not v217 then
            return
        end
        if a5 > 0 then
            if a5 < (v217.Position - Character_2.PrimaryPart.Position).Magnitude then
                u31.FillTransparency = 1
                u31.OutlineTransparency = 1
            end
            local v218 = nil
            while task.wait(0.5) and (u31) and (u31.Parent) do
                local v219 = a5 < (v217.Position - Character_2.PrimaryPart.Position).Magnitude
                if v218 ~= v219 then
                    local v220 = u31
                    local tbl_51 = {FillTransparency = 0, OutlineTransparency = 0}
                    tbl_51.FillTransparency = (v219 and 1) or 0.5
                    tbl_51.OutlineTransparency = (v219 and 1) or 0
                    game.TweenService:Create(v220, u28, tbl_51):Play()
                    v218 = v219
                end
            end
        end
    end
end
function tbl_upv_1.ApplyUnsafeTouched(a1, a2, a3, a4, a5)
    --[[
      name: ApplyUnsafeTouched
      line: 2559
    ]]
    local v221 = typeof(a2) == "Instance"
    assert(v221, "Bad instance, must be BasePart.")
    local v222 = type(a4) == "function"
    assert(v222, "Bad callback, must be function.")
    a5 = a5 or (a2.Size.Magnitude * 2)
    local u33 = nil
    local tbl_upv_52 = {}
    function tbl_upv_52.Disconnect()
        --[[
          name: Disconnect
          line: 2568
          upvalues:
            u33 (ref, index: 1)
        ]]
        if not u33 then
            return
        end
        u33:Disconnect()
        u33 = nil
    end
    a2.CanTouch = true
    local v223 = a2.Touched:Connect(
        function(a6)
            --[[
              line: 2577
              upvalues:
                a2 (copy, index: 1)
                a5 (ref,  index: 2)
                a4 (copy, index: 3)
                tbl_upv_52 (copy, index: 4)
            ]]
            if a5 < (a6.Position - a2.Position).Magnitude then
                return
            end
            a4(tbl_upv_52, a6)
        end
    )
    u33 = v223
    return tbl_upv_52
end
function tbl_upv_1.GetAliveSurvivorCharacters(a1)
    --[[
      name: GetAliveSurvivorCharacters
      line: 2592
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local tbl_53 = {}
    for _, value_40 in workspace.Players.Survivors:GetChildren() do
        if tbl_upv_1:IsAlive(value_40) then
            table.insert(tbl_53, value_40)
        end
    end
    return tbl_53
end
function tbl_upv_1.ApplyOnTouched(a1, a2, a3, a4)
    --[[
      name: ApplyOnTouched
      line: 2607
    ]]
    local v224 = typeof(a2) == "Instance"
    local assert_1 = assert
    assert_1(v224, "Bad instance, must be BasePart.")
    local v225 = type(a4) == "function"
    assert(v225, "Bad callback, must be function.")
    a3 = a3 or false
    local u34 = nil
    local v226 = a2.Touched:Connect(
        function(a5)
            --[[
              line: 2613
              upvalues:
                a2 (copy, index: 1)
                u34 (ref,  index: 2)
                a4 (copy, index: 3)
                a3 (ref,  index: 4)
            ]]
            if a2 and a2.Parent then
                a4(u34, a5)
                if a3 and u34 then
                    u34:Disconnect()
                end
                return
            end
            u34:Disconnect()
        end
    )
    u34 = v226
    return assert_1
end
function tbl_upv_1.RevealPlayerAuraTo(a1, a2, a3, a4, a5, a6)
    --[[
      name: RevealPlayerAuraTo
      line: 2663
      upvalues:
        Network_upv_1 (copy, index: 1)
    ]]
    if a2 then
        local v227 = a2:IsA("Model")
        if v227 then
            a2 = game.Players:GetPlayerFromCharacter(a2)
        end
    end
    Network_upv_1:FireClientConnection(a2, "RevealPlayerAura", "REMOTE_EVENT", a3, a4, a5, a6)
end
function tbl_upv_1.RemovePlayerAuraFrom(a1, a2, a3, a4)
    --[[
      name: RemovePlayerAuraFrom
      line: 2674
      upvalues:
        u2 (copy, index: 1)
        Network_upv_1 (copy, index: 2)
        u1 (copy, index: 3)
        tbl_upv_41 (copy, index: 4)
        tbl_upv_42 (copy, index: 5)
        Debris_upv_1 (copy, index: 6)
        TweenService_upv_1 (copy, index: 7)
        tbl_upv_40 (copy, index: 8)
    ]]
    if not a2 then
        return
    end
    if u2 then
        if a3 then
            Network_upv_1:FireClientConnection(a3, "RemovePlayerAura", "REMOTE_EVENT", a2)
        else
            Network_upv_1:FireAllClientConnection("RemovePlayerAura", "REMOTE_EVENT", a2)
        end
    elseif u1 then
        local v228 = ((a2:IsA("Player")) and (a2.Character)) or a2
        if not v228 then
            return
        end
        tbl_upv_41[a2] = nil
        local PlayerAura_1 = v228:FindFirstChild("PlayerAura")
        if PlayerAura_1 then
            if tostring(game.Players.LocalPlayer.Character.Parent) == tostring(v228.Parent) then
                if tbl_upv_40[v228] then
                    tbl_upv_40[v228]:Destroy()
                    tbl_upv_40[v228] = nil
                end
            else
                local tbl_54 = {}
                if tbl_upv_42[PlayerAura_1] then
                    if v228 and v228.Parent then
                        for _, value_41 in pairs(tbl_54) do
                            if value_41 or value_41.Parent then
                                value_41.Parent = v228
                            end
                        end
                    else
                        for _, value_42 in pairs(tbl_54) do
                            value_42:Destroy()
                        end
                    end
                    table.clear(tbl_upv_42[PlayerAura_1])
                    tbl_upv_42[PlayerAura_1] = nil
                end
                PlayerAura_1.Name = "goodbai"
                tbl_upv_41[a2] = nil
                if a4 then
                    PlayerAura_1:Destroy()
                else
                    Debris_upv_1:AddItem(PlayerAura_1, 1)
                    local tbl_55 = {FillTransparency = 1, OutlineTransparency = 1}
                    TweenService_upv_1:Create(PlayerAura_1, TweenInfo.new(1), tbl_55):Play()
                end
            end
        elseif tbl_upv_40[v228] then
            tbl_upv_40[v228]:Destroy()
            tbl_upv_40[v228] = nil
        end
    end
end
function tbl_upv_1.GetClosestPlayerFromPosition(a1, a2, a3)
    --[[
      name: GetClosestPlayerFromPosition
      line: 2730
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v229 = a3 or {}
    a3 = v229
    a3.MaxDistance = tonumber(a3.MaxDistance) or 9999
    a3.PlayerSelection = a3.PlayerSelection or "Survivors"
    a3.VerticalMultiplier = a3.VerticalMultiplier or 1
    local tbl_56 = {}
    if a3.IncludedSelection then
        table.move(a3.IncludedSelection, 1, #a3.IncludedSelection, 1, tbl_56)
    end
    local v230 = #tbl_upv_1:GetAliveSurvivorCharacters()
    for _, value_43 in ipairs(workspace.Players:GetChildren()) do
        if not (value_43:IsA("Folder")) or value_43.Name == "Spectating" then
            continue
        end
        if v229.PlayerSelection == "All" or v229.PlayerSelection ~= "All" and value_43.Name == v229.PlayerSelection then
            for v234, value_44 in ipairs(value_43:GetChildren()) do
                if not (value_44:GetAttribute("Undetectable")) or v229.OverrideUndetectable or v230 <= 1 then
                    table.insert(tbl_56, value_44)
                end
            end
        end
    end
    local tbl_57 = {}
    local MaxDistance_1 = v229.MaxDistance
    local VerticalMultiplier_1 = v229.VerticalMultiplier
    local v231 = nil
    for _, value_45 in ipairs(tbl_56) do
        if typeof(value_45) ~= "Instance" or not (value_45:IsDescendantOf(workspace)) or not (tbl_upv_1:IsAlive(value_45)) then
            continue
        end
        local v232 = tbl_upv_1:GetActor(value_45)
        if not (v232) or not (v232.GetPivot) then
            v231 = (not value_45:IsA("Model")) or ((not (value_45.PrimaryPart)) or (value_45.PrimaryPart.CFrame))
            if not (v231) then
                continue
            end
            local Magnitude_2 = ((v231.Position - a2) * Vector3.new(1, VerticalMultiplier_1, 1)).Magnitude
            if MaxDistance_1 >= Magnitude_2 then
                table.insert(tbl_57, {Player = value_45, Distance = Magnitude_2})
                continue
            end
        end
        v231 = v232:GetPivot()
        if not (v231) then
            continue
        end
        local Magnitude_2 = ((v231.Position - a2) * Vector3.new(1, VerticalMultiplier_1, 1)).Magnitude
        if MaxDistance_1 >= Magnitude_2 then
            table.insert(tbl_57, {Player = value_45, Distance = Magnitude_2})
        end
    end
    table.sort(
        tbl_57,
        function(a4, a5)
            --[[
              line: 2791
            ]]
            return a4.Distance < a5.Distance
        end
    )
    if v229.ReturnTable then
        return tbl_57
    end
    local v233 = tbl_57[1]
    if v233 then
        return v233.Player, v233.Distance
    end
end
function tbl_upv_1.GetPlayerRootLookVector(a1, a2)
    --[[
      name: GetPlayerRootLookVector
      line: 2804
      upvalues:
        u1 (copy, index: 1)
        Network_upv_1 (copy, index: 2)
    ]]
    if (u1) then
        return
    end
    if a2 then
        local _ = os.clock()
        local tbl_upv_58 = {}
        local v234 = Network_upv_1:FireClientConnection(a2, "GetLocalPosData", "REMOTE_FUNCTION")
        if v234 then
            v234:gsub(
                "[%d%.%-e]+",
                function(a3)
                    --[[
                      line: 2812
                      upvalues:
                        tbl_upv_58 (copy, index: 1)
                    ]]
                    table.insert(tbl_upv_58, (tonumber(a3)))
                end
            )
            v234 = Vector3.new(tbl_upv_58[4], tbl_upv_58[5], tbl_upv_58[6])
        end
        return v234 or (a2.Character and (a2.Character.PrimaryPart and (a2.Character.PrimaryPart.CFrame.LookVector)))
    end
end
function tbl_upv_1.OnPlayingStateChanged(a1)
    --[[
      name: OnPlayingStateChanged
      line: 2822
    ]]
    local LocalPlayer_4 = game.Players.LocalPlayer
    local u35 = LocalPlayer_4.Character or (LocalPlayer_4.CharacterAdded:Wait())
    task.spawn(a1, (tostring(u35.Parent)))
    u35:GetPropertyChangedSignal("Parent"):Connect(
        function()
            --[[
              line: 2826
              upvalues:
                a1 (copy, index: 1)
                u35 (copy, index: 2)
            ]]
            a1((tostring(u35.Parent)))
        end
    )
end
local tbl_upv_59 = {}
function tbl_upv_1.OnPlayerAdded(a1)
    --[[
      name: OnPlayerAdded
      line: 2833
      upvalues:
        Players_upv_1 (copy, index: 1)
        spawn_upv_1 (copy, index: 2)
        tbl_upv_59 (copy, index: 3)
    ]]
    for _, value_46 in Players_upv_1:GetPlayers() do
        spawn_upv_1(a1, value_46)
    end
    table.insert(tbl_upv_59, a1)
end
Players_upv_1.PlayerAdded:Connect(
    function(a1)
        --[[
          line: 2841
          upvalues:
            tbl_upv_59 (copy, index: 1)
            spawn_upv_1 (copy, index: 2)
        ]]
        for _, value_47 in tbl_upv_59 do
            spawn_upv_1(value_47, a1)
        end
    end
)
function tbl_upv_1.OnCharacterAdded(a1)
    --[[
      name: OnCharacterAdded
      line: 2847
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    tbl_upv_1.OnPlayerAdded(
        function(a2)
            --[[
              line: 2848
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a2.Character then
                a1(a2.Character, a2)
            end
            a2.CharacterAdded:Connect(
                function()
                    --[[
                      line: 2852
                      upvalues:
                        a1 (copy, index: 1)
                        a2 (copy, index: 2)
                    ]]
                    a1(a2.Character, a2)
                end
            )
        end
    )
end
function tbl_upv_1.ValueBaseToTable(a1, a2)
    --[[
      name: ValueBaseToTable
      line: 2858
    ]]
    local tbl_60 = {}
    local function recurse(a3, a4)
        --[[
          name: recurse
          line: 2861
          upvalues:
            recurse (copy, index: 1)
        ]]
        for _, value_48 in pairs(a3:GetChildren()) do
            local Name_1 = value_48.Name
            if value_48:IsA("Folder") then
                a4[Name_1] = {}
                recurse(value_48, a4[Name_1])
            else
                a4[Name_1] = value_48.Value
            end
        end
    end
    recurse(a2, tbl_60)
    return tbl_60
end
function tbl_upv_1.ValueTableToBase(a1, a2, a3, a4)
    --[[
      name: ValueTableToBase
      line: 2877
    ]]
    local tbl_upv_61 = {number = "IntValue", string = "StringValue", boolean = "BoolValue"}
    local u36 = 0
    local function recurse_2(a5, a6)
        --[[
          name: recurse
          line: 2886
          upvalues:
            recurse_2 (copy, index: 1)
            tbl_upv_61 (copy, index: 2)
            a4 (copy, index: 3)
            u36 (ref,  index: 4)
        ]]
        local tbl_62 = {}
        for _, value_49 in a6:GetChildren() do
            tbl_62[value_49.Name] = value_49
        end
        for key_17, value_50 in pairs(a5) do
            if key_17 == "NonInstanced" then
                continue
            end
            if typeof(value_50) ~= "table" then
                local v235 = tbl_62[key_17]
                if not v235 then
                    local v236 = tbl_upv_61[typeof(value_50)]
                    if not (v236) then
                        warn((("[Util:ValueTableToBase | LOG]: %* is not a valid datatype for %*"):format(v236, value_50)))
                        continue
                    end
                    local v237 = Instance.new(v236)
                    v237.Name = key_17
                    v235 = v237
                end
                v235.Value = nil
                v235.Parent = a6
                if not (a4) then
                    continue
                end
                u36 = u36 + 1
                if u36 >= 3 then
                    u36 = 0
                    task.wait()
                end
            else
                local v238 = tbl_62[key_17]
                if not (v238) then
                    local v239 = Instance.new("Folder")
                    v239.Name = key_17
                    v239.Parent = a6
                    v238 = v239
                end
                recurse_2(value_50, v238)
            end
        end
    end
    recurse_2(a2, a3)
end
function tbl_upv_1.EmitParticles(a1, a2)
    --[[
      name: EmitParticles
      line: 2934
    ]]
    if typeof(a2) == "Instance" then
        a2 = a2:GetDescendants()
    end
    for _, value_upv_51 in ipairs(a2) do
        if not (value_upv_51:IsA("ParticleEmitter")) then
            continue
        end
        local u37 = value_upv_51:GetAttribute("EmitCount")
        local v240 = value_upv_51:GetAttribute("EmitDelay")
        local u38 = value_upv_51:GetAttribute("EmitDuration") or (value_upv_51:GetAttribute("Toggle") or (not u37))
        local function f()
            --[[
              name: f
              line: 2944
              upvalues:
                u38 (copy, index: 1)
                value_upv_51 (copy, index: 2)
                u37 (copy, index: 3)
            ]]
            if u38 then
                value_upv_51.Enabled = true
                if typeof(u38) ~= "number" then
                    return
                end
                task.delay(
                    u38,
                    function()
                        --[[
                          line: 2949
                          upvalues:
                            value_upv_51 (copy, index: 1)
                        ]]
                        if not value_upv_51 then
                            return
                        end
                        value_upv_51.Enabled = false
                    end
                )
            else
                value_upv_51:Emit(u37)
            end
        end
        if v240 then
            task.delay(v240, f)
        else
            f()
        end
    end
end
return table.freeze(tbl_upv_1)
