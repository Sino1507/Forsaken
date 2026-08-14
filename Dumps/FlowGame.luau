-- Script Path: game:GetService("ReplicatedStorage").Modules.Minigames.FlowGameManager.FlowGame
-- Took 0.04s to decompile.
-- Executor: Volt (1.3.7.0)

local TweenService_upv_1 = game:GetService("TweenService")
local UserInputService_upv_1 = game:GetService("UserInputService")
local Debris_upv_1 = game:GetService("Debris")
local Sounds_upv_1 = require(game.ReplicatedStorage.Modules.Rendering.Sounds)
local PathFinder_upv_1 = require(script.PathFinder)
local Generator_upv_1 = require(script.Generator)
local Settings_upv_1 = require(script.Settings)
local defaultButtonColor_upv_1 = Settings_upv_1.defaultButtonColor
local Assets_upv_1 = script.Assets
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local u1 = LocalPlayer_upv_1:GetMouse()
local tbl_upv_1 = {}
tbl_upv_1.Line = {
    updown = {Assets_upv_1.VerticalLine},
    leftright = {Assets_upv_1.HorizontalLine},
    downright = {Assets_upv_1.HalfLineDown, Assets_upv_1.HalfLineRight},
    downleft = {Assets_upv_1.HalfLineDown, Assets_upv_1.HalfLineLeft},
    upright = {Assets_upv_1.HalfLineUp, Assets_upv_1.HalfLineRight},
    upleft = {Assets_upv_1.HalfLineUp, Assets_upv_1.HalfLineLeft},
    up = {Assets_upv_1.HalfLineUp},
    down = {Assets_upv_1.HalfLineDown},
    left = {Assets_upv_1.HalfLineLeft},
    right = {Assets_upv_1.HalfLineRight}
}
tbl_upv_1.Circle = {up = {Assets_upv_1.HalfLineUp, Assets_upv_1.Circle}, down = {Assets_upv_1.HalfLineDown, Assets_upv_1.Circle}, left = {Assets_upv_1.HalfLineLeft, Assets_upv_1.Circle}, right = {Assets_upv_1.HalfLineRight, Assets_upv_1.Circle}, none = {Assets_upv_1.Circle}}
function getDirection(a1, a2, a3, a4)
    --[[
      name: getDirection
      line: 39
    ]]
    if a3 >= a1 then
        if a1 >= a3 then
            if a4 >= a2 then
                if a2 < a4 then
                    return "right"
                end
            else
                return "left"
            end
        else
            return "down"
        end
    else
        return "up"
    end
end
function isNeighbour(a1, a2, a3, a4)
    --[[
      name: isNeighbour
      line: 57
    ]]
    if a3 == a1 - 1 and a4 == a2 then
        return "up"
    end
    if a3 == a1 + 1 and a4 == a2 then
        return "down"
    end
    if a3 == a1 and a4 == a2 - 1 then
        return "left"
    elseif a3 == a1 and a4 == a2 + 1 then
        return "right"
    else
        return false
    end
end
function removeAfterCoordinates(a1, a2, a3)
    --[[
      name: removeAfterCoordinates
      line: 70
      upvalues:
        Sounds_upv_1 (copy, index: 1)
    ]]
    local v1 = nil
    for key_1, value_1 in ipairs(a1) do
        if value_1.row ~= a2 then
            continue
        end
        if value_1.col == a3 then
            v1 = key_1
            break
        end
    end
    if not v1 then
        return
    end
    for n_1 = #a1, v1 + 1, -1 do
        table.remove(a1, n_1)
        Sounds_upv_1:Play("lineErase")
    end
end
function sameLocation(a1, a2)
    --[[
      name: sameLocation
      line: 88
    ]]
    return (a1.row == a2.row) and (a1.col == a2.col)
end
local function ColorDifference(a1, a2)
    --[[
      name: ColorDifference
      line: 97
    ]]
    return (math.sqrt(((((a2.R * 255) - (a1.R * 255)) ^ 2) + (((a2.G * 255) - (a1.G * 255)) ^ 2)) + (((a2.B * 255) - (a1.B * 255)) ^ 2)))
end
local tbl_upv_2 = {}
tbl_upv_2.__index = tbl_upv_2
local function shuffleTable(a1)
    --[[
      name: shuffleTable
      line: 46
    ]]
    if not a1 then
        return
    end
    local v2 = table.clone(a1)
    for n_2 = #v2, 2, -1 do
        local v3 = math.random(n_2)
        local v4 = v2[n_2]
        v2[n_2] = v2[v3]
        v2[v3] = v4
    end
    return v2
end
function tbl_upv_2.new(a1, a2, a3)
    --[[
      name: new
      line: 143
      upvalues:
        tbl_upv_2 (copy, index: 1)
        Settings_upv_1 (copy, index: 2)
        shuffleTable (copy, index: 3)
    ]]
    local v5 = setmetatable({}, tbl_upv_2)
    v5.id = 0
    local v6 = setmetatable(table.clone(a3 or {}), Settings_upv_1)
    v5.GUI = a1
    v5.containerFrame = v5.GUI.Container
    v5.gridHolder = v5.containerFrame.GridHolder
    v5.gridFrame = v5.gridHolder.Grid
    v5.gridSize = a2 or (Settings_upv_1.DefaultGridSize)
    v5.colors = shuffleTable(v6.Colors)
    v5.paths = {}
    v5.targetPairs = {}
    v5.isDrawing = false
    v5.drawingStart = nil
    v5.gameEnded = false
    v5.dragDebounce = {}
    v5.Connections = {}
    v5.Settings = v6
    v5:Init()
    return v5
end
local function GenerateColor(a1, a2)
    --[[
      name: GenerateColor
      line: 103
    ]]
    local u2 = 0
    local function IsValidColor_1(a3)
        --[[
          name: IsValidColor
          line: 109
          upvalues:
            u2 (ref,  index: 1)
            a1 (copy, index: 2)
        ]]
        local v7 = ((a3.R + a3.G) + a3.B) / 3
        if v7 >= 0.6 and v7 <= 0.8 then
            if u2 <= 500 then
                for _, value_2 in ipairs(a1) do
                    if math.sqrt(((((value_2.R * 255) - (a3.R * 255)) ^ 2) + (((value_2.G * 255) - (a3.G * 255)) ^ 2)) + (((value_2.B * 255) - (a3.B * 255)) ^ 2)) >= 75 then
                        continue
                    end
                    return false
                end
            end
            return true
        end
        return false
    end
    local v8 = nil
    while true do
        v8 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        u2 = u2 + 1
        if IsValidColor_1(v8) or a2 then
            break
        end
    end
    return v8
end
function tbl_upv_2.Init(a1)
    --[[
      name: Init
      line: 173
      upvalues:
        Assets_upv_1 (copy, index: 1)
        UserInputService_upv_1 (copy, index: 2)
        Generator_upv_1 (copy, index: 3)
        GenerateColor (copy, index: 4)
        TweenService_upv_1 (copy, index: 5)
    ]]
    local v9 = 1 / a1.gridSize
    a1.gridFrame.UIGridLayout.CellSize = UDim2.fromScale(v9, v9)
    a1.containerFrame.Size = UDim2.fromScale(0, 0)
    a1.containerFrame.Visible = true
    for n_upv_3 = 1, a1.gridSize do
        for n_upv_4 = 1, a1.gridSize do
            local v10 = Assets_upv_1.CellTemplate:Clone()
            v10.Name = n_upv_3 .. "-" .. n_upv_4
            v10.Parent = a1.gridFrame
            v10.BackgroundTransparency = a1.Settings.ButtonTransparency
            v10.Button.MouseButton1Down:Connect(
                function()
                    --[[
                      line: 186
                      upvalues:
                        a1 (copy, index: 1)
                        n_upv_3 (copy, index: 2)
                        n_upv_4 (copy, index: 3)
                    ]]
                    a1:DragBegin(n_upv_3, n_upv_4)
                end
            )
        end
    end
    table.insert(
        a1.Connections,
        UserInputService_upv_1.InputEnded:Connect(
            function(a2)
                --[[
                  line: 195
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                if a2.UserInputType ~= Enum.UserInputType.MouseButton1 and a2.UserInputType ~= Enum.UserInputType.Touch and a2.KeyCode ~= Enum.KeyCode.ButtonA then
                    return
                end
                a1:DragEnd()
            end
        )
    )
    table.insert(
        a1.Connections,
        UserInputService_upv_1.InputChanged:Connect(
            function(a3)
                --[[
                  line: 200
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                if a3.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return
                end
                a1:InputChanged(a3.Position)
            end
        )
    )
    table.insert(
        a1.Connections,
        UserInputService_upv_1.TouchMoved:Connect(
            function(a4)
                --[[
                  line: 205
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1:InputChanged(a4.Position)
            end
        )
    )
    local v11, v12
    local v13, n_upv_3
    v11, v13, n_upv_3, v12 = Generator_upv_1(a1.gridSize)
    a1.targetPairs = v11
    a1.Solution = v13
    a1.SolutionText = v12
    for n_5 = 1, #a1.targetPairs do
        a1.paths[n_5] = {}
        a1.dragDebounce[n_5] = 0
        if not (a1.colors[n_5]) then
            table.insert(a1.colors, (GenerateColor(a1.colors, a1.Settings.AllowBadColors)))
        end
    end
    if a1.Settings.Modifiers.NumberSkip then
        a1.skipNumber = math.random(1, #a1.targetPairs)
    end
    a1:updateGui()
    local v14 = TweenInfo.new(0.45)
    local tbl_3 = {}
    tbl_3.Size = UDim2.fromScale(0.4, 1)
    TweenService_upv_1:Create(a1.containerFrame, v14, tbl_3):Play()
end
function tbl_upv_2.DragBeginConsole(a1)
    --[[
      name: DragBeginConsole
      line: 237
    ]]
    if require(game.ReplicatedStorage.Modules.Utilities.Device):GetPlayerDevice() ~= "Console" then
        return
    end
    task.spawn(
        function()
            --[[
              line: 240
              upvalues:
                a1 (copy, index: 1)
            ]]
            while task.wait() and (a1.isDrawing) and (a1.containerFrame.Parent) and not a1.gameEnded do
                a1:InputChanged()
            end
        end
    )
end
function tbl_upv_2.DragBegin(a1, a2, a3)
    --[[
      name: DragBegin
      line: 250
      upvalues:
        Sounds_upv_1 (copy, index: 1)
    ]]
    if a1.gameEnded then
        return
    end
    for key_2, value_3 in ipairs(a1.targetPairs) do
        -- GenericForInit _ = ipairs(value_3), _, _
        if v15.row == a2 and v15.col == a3 then
            if os.clock() - a1.dragDebounce[key_2] >= 0.25 then
                Sounds_upv_1:Play("dragBegin")
                a1.isDrawing = true
                a1.drawingStart = {row = a2, col = a3, color = key_2}
                a1.paths[key_2] = {{row = a2, col = a3}}
                a1:CircleEffect(a2, a3)
                a1:CircleEffect(value_3[1].row, value_3[1].col, true)
                a1:CircleEffect(value_3[2].row, value_3[2].col, true)
                a1:DragBeginConsole()
                return a1:updateGui()
            end
            return
        end
    end
end
function tbl_upv_2.DragEnd(a1)
    --[[
      name: DragEnd
      line: 285
      upvalues:
        Sounds_upv_1 (copy, index: 1)
    ]]
    if a1.isDrawing then
        local color_1 = a1.drawingStart.color
        if #a1.paths[color_1] <= 1 then
            a1.paths[color_1] = {}
        end
        if a1.Settings.ConnectToTargetIfNearby and #a1.paths[color_1] > 1 and a1.paths[color_1][#a1.paths[color_1]] then
            local v16 = a1.paths[color_1][#a1.paths[color_1]]
            local v17 = a1.targetPairs[color_1]
            local v18 = ((sameLocation(a1.drawingStart, v17[1])) and 2) or 1
            local v19 = sameLocation(v16, v17[v18])
            local v20 = isNeighbour(v16.row, v16.col, v17[v18].row, v17[v18].col)
            if v19 then
                a1.dragDebounce[color_1] = os.clock()
            elseif v20 then
                table.insert(a1.paths[color_1], {row = v17[v18].row, col = v17[v18].col})
                a1.dragDebounce[color_1] = os.clock()
            end
        end
        a1.isDrawing = false
        a1.drawingStart = nil
        a1:updateGui()
        a1:checkForWin()
        Sounds_upv_1:Play("dragEnd")
    end
end
function tbl_upv_2.GetCellAtMousePosition(a1, a2)
    --[[
      name: GetCellAtMousePosition
      line: 317
      upvalues:
        u1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
    ]]
    local SelectedObject_1 = game.GuiService.SelectedObject
    if SelectedObject_1 and SelectedObject_1.Parent then
        for _, value_4 in pairs(a1.gridFrame:GetChildren()) do
            if SelectedObject_1.Parent ~= value_4 then
                continue
            end
            return value_4
        end
        local v21 = Vector2.new(u1.X, u1.Y)
        for _, value_5 in pairs(LocalPlayer_upv_1.PlayerGui:GetGuiObjectsAtPosition(v21.X, v21.Y)) do
            if value_5.Parent ~= a1.gridFrame then
                continue
            end
            return value_5
        end
        return nil
    else
        local v21 = Vector2.new(u1.X, u1.Y)
        for _, value_5 in pairs(LocalPlayer_upv_1.PlayerGui:GetGuiObjectsAtPosition(v21.X, v21.Y)) do
            if value_5.Parent ~= a1.gridFrame then
                continue
            end
            return value_5
        end
        return nil
    end
end
function tbl_upv_2.InputChanged(a1, a2)
    --[[
      name: InputChanged
      line: 342
      upvalues:
        Sounds_upv_1 (copy, index: 1)
        PathFinder_upv_1 (copy, index: 2)
    ]]
    if a1.gameEnded or not a1.isDrawing then
        return
    end
    local v22 = a1:GetCellAtMousePosition(a2)
    if not v22 then
        return
    end
    local v23, v24 = v22.Name:match("(%d+)-(%d+)")
    local num_1 = tonumber(v23)
    local num_2 = tonumber(v24)
    local v25 = a1:getGrid()
    local color_2 = a1.drawingStart.color
    local v26 = a1.paths[color_2][#a1.paths[color_2]]
    local row_1 = v26.row
    local col_1 = v26.col
    local v27 = a1.paths[color_2][1]
    local v28 = false
    if v25[row_1][col_1].status == "target" then
        v28 = false
        if v25[row_1][col_1].color == color_2 then
            v28 = true
            if row_1 == v27.row then
                v28 = col_1 ~= v27.col
            end
        end
    end
    local v29 = isNeighbour(row_1, col_1, num_1, num_2)
    local v30 = true
    if v25[num_1][num_2].status ~= "empty" then
        v30 = (v25[num_1][num_2].status == "target") and (v25[num_1][num_2].color == color_2)
    end
    local v31 = false
    for _, value_6 in ipairs(a1.paths[color_2]) do
        if value_6.row ~= num_1 then
            continue
        end
        if value_6.col == num_2 then
            v31 = true
            break
        end
    end
    if v29 and v30 and not (v28) and not (v31) then
        table.insert(a1.paths[color_2], {row = num_1, col = num_2})
        a1:updateGui()
        if v25[num_1][num_2].status ~= "target" then
            Sounds_upv_1:Play("lineDraw")
        else
            a1:CircleEffect(num_1, num_2)
            Sounds_upv_1:Play("lineConnect")
        end
        return
    end
    if v31 then
        removeAfterCoordinates(a1.paths[color_2], num_1, num_2)
        a1:updateGui()
    elseif v30 and not v28 then
        if a1.Settings.PathFinderLengthLimit > 0 then
            local v32 = PathFinder_upv_1.new(v25, v26, {row = num_1, col = num_2}, a1.Settings.PathFinderLengthLimit)
            if not v32:isPathAvailable() then
                return
            end
            for _, value_7 in ipairs(v32:shortestPath()) do
                table.insert(a1.paths[color_2], value_7)
                Sounds_upv_1:Play("lineDraw")
                a1:updateGui()
            end
        end
    end
end
function tbl_upv_2.getGrid(a1, a2)
    --[[
      name: getGrid
      line: 394
    ]]
    local tbl_4 = {}
    for n_6 = 1, a1.gridSize do
        tbl_4[n_6] = {}
        for n_7 = 1, a1.gridSize do
            tbl_4[n_6][n_7] = {status = "empty", connections = {}}
        end
    end
    if a2 then
        return tbl_4
    end
    local v33 = nil
    local v34 = nil
    local v35 = nil
    for key_3, value_8 in ipairs(a1.paths) do
        if #value_8 <= 0 then
            continue
        end
        for n_8 = 1, #value_8 do
            v33 = value_8[n_8 - 1]
            local v36 = value_8[n_8]
            local v37 = value_8[n_8 + 1]
            local tbl_5 = {}
            if v33 then
                v34 = getDirection(v36.row, v36.col, v33.row, v33.col)
                if v34 then
                    tbl_5[v34] = true
                end
            end
            if not (v37) then
                tbl_4[v36.row][v36.col].status = "path"
                tbl_4[v36.row][v36.col].color = key_3
                tbl_4[v36.row][v36.col].connections = tbl_5
                continue
            end
            v35 = getDirection(v36.row, v36.col, v37.row, v37.col)
            if v35 then
                tbl_5[v35] = true
            end
            tbl_4[v36.row][v36.col].status = "path"
            tbl_4[v36.row][v36.col].color = key_3
            tbl_4[v36.row][v36.col].connections = tbl_5
        end
    end
    for key_4, value_9 in ipairs(a1.targetPairs) do
        for _, value_10 in ipairs(value_9) do
            tbl_4[value_10.row][value_10.col].status = "target"
            tbl_4[value_10.row][value_10.col].color = key_4
        end
    end
    return tbl_4
end
function tbl_upv_2.updateGui(a1)
    --[[
      name: updateGui
      line: 446
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        defaultButtonColor_upv_1 (copy, index: 2)
        Settings_upv_1 (copy, index: 3)
    ]]
    local v38 = a1:getGrid()
    local v39, v40, v41 = nil, nil, nil
    for n_9 = 1, a1.gridSize do
        for n_10 = 1, a1.gridSize do
            v40 = a1.gridFrame:FindFirstChild(n_9 .. "-" .. n_10)
            if not (v40) then
                continue
            end
            v39 = v38[n_9][n_10]
            if v39.status == "empty" then
                a1:clearAssets(n_9, n_10)
                local tbl_6 = {}
                tbl_6.BackgroundColor3 = defaultButtonColor_upv_1
                TweenService_upv_1:Create(v40.Button, TweenInfo.new(0.15), tbl_6):Play()
                continue
            end
            if v39.status == "target" then
                for _, value_11 in pairs(v39.connections) do
                    if value_11 then
                        break
                    end
                end
                a1:updateAssets(n_9, n_10, "Circle", a1.colors[v39.color], v39.connections)
                if Settings_upv_1.showNumbers ~= true then
                    v40:FindFirstChild("Circle").Number.Visible = false
                else
                    local v42
                    if not (a1.skipNumber) or a1.skipNumber > v39.color then
                        v42 = 0
                    else
                        v42 = 1
                    end
                    v40:FindFirstChild("Circle").Number.Text = v39.color + v42
                    v40:FindFirstChild("Circle").Number.Visible = true
                end
                v41 = false
                for _, value_12 in ipairs(a1.paths[v39.color]) do
                    if value_12.row ~= n_9 then
                        continue
                    end
                    if value_12.col == n_10 then
                        v41 = true
                        break
                    end
                end
                if v41 then
                    local v43 = TweenInfo.new(0.15)
                    local tbl_7 = {}
                    tbl_7.BackgroundColor3 = defaultButtonColor_upv_1:Lerp(a1.colors[v39.color], 0.3)
                    TweenService_upv_1:Create(v40.Button, v43, tbl_7):Play()
                else
                    local tbl_8 = {}
                    tbl_8.BackgroundColor3 = defaultButtonColor_upv_1
                    TweenService_upv_1:Create(v40.Button, TweenInfo.new(0.15), tbl_8):Play()
                end
            elseif v39.status == "path" then
                a1:updateAssets(n_9, n_10, "Line", a1.colors[v39.color], v39.connections)
                local v44 = TweenInfo.new(0.15)
                local tbl_9 = {}
                tbl_9.BackgroundColor3 = defaultButtonColor_upv_1:Lerp(a1.colors[v39.color], 0.3)
                TweenService_upv_1:Create(v40.Button, v44, tbl_9):Play()
            end
        end
    end
end
function tbl_upv_2.clearAssets(a1, a2, a3)
    --[[
      name: clearAssets
      line: 500
    ]]
    for _, value_13 in ipairs(a1.gridFrame:FindFirstChild(a2 .. "-" .. a3):GetChildren()) do
        if value_13.Name == "Button" then
            continue
        end
        if value_13.Name ~= "Effects" then
            value_13:Destroy()
        end
    end
end
function tbl_upv_2.updateAssets(a1, a2, a3, a4, a5, a6)
    --[[
      name: updateAssets
      line: 509
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v45 = ""
    if (((a6.right) and ((((a6.left) and ((((a6.down) and ((((a6.up) and (v45 .. "up")) or v45) .. "down")) or v45) .. "left")) or v45) .. "right")) or v45) == "" then
        v45 = "none"
    end
    local v46 = tbl_upv_1[a4][v45]
    local v47 = a1.gridFrame:FindFirstChild(a2 .. "-" .. a3)
    if not v46 or not v47 then
        return
    end
    a1:clearAssets(a2, a3)
    for _, value_14 in v46 do
        local v48 = value_14:Clone()
        v48.Parent = v47
        v48.BackgroundColor3 = a5
    end
end
function tbl_upv_2.EndGame(a1, a2)
    --[[
      name: EndGame
      line: 530
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        Debris_upv_1 (copy, index: 2)
        TweenService_upv_1 (copy, index: 3)
    ]]
    a1.gameEnded = true
    a1.isDrawing = false
    a1.drawingStart = false
    for _, value_15 in pairs(a1.Connections) do
        value_15:Disconnect()
    end
    a1.Connections = {}
    if a1.completedEvent and a2 ~= nil then
        local completedEvent_1 = a1.completedEvent
        a1.completedEvent = nil
        completedEvent_1:Fire((a2 and "finishedPuzzle") or "leaveGenerator")
        completedEvent_1:Destroy()
    end
    if a2 then
        LocalPlayer_upv_1:SetAttribute("CompletedGenPuzzle", true)
    end
    task.spawn(
        function()
            --[[
              line: 540
              upvalues:
                Debris_upv_1 (copy, index: 1)
                a1 (copy, index: 2)
                TweenService_upv_1 (copy, index: 3)
            ]]
            Debris_upv_1:AddItem(a1.GUI, 0.5)
            local v49 = TweenInfo.new(0.5)
            local tbl_10 = {}
            tbl_10.Size = UDim2.new()
            TweenService_upv_1:Create(a1.containerFrame, v49, tbl_10):Play()
        end
    )
end
function tbl_upv_2.checkForWin(a1)
    --[[
      name: checkForWin
      line: 548
    ]]
    if not a1:checkWin() then
        return
    end
    a1:EndGame(true)
end
function tbl_upv_2.checkWin(a1)
    --[[
      name: checkWin
      line: 554
    ]]
    for key_5, value_16 in ipairs(a1.targetPairs) do
        local v50 = a1.paths[key_5]
        if #v50 < 2 then
            return false
        end
        local v51 = ((sameLocation(v50[1], value_16[1])) and (sameLocation(v50[#v50], value_16[2]))) or (sameLocation(v50[1], value_16[2]) and (sameLocation(v50[#v50], value_16[1])))
        if v51 then
            continue
        end
        return false
    end
    if not a1.Settings.MustFillEntireGrid then
        return true
    end
    local v52 = 0
    for _, value_17 in ipairs(a1.paths) do
        for v54, v53 in ipairs(value_17) do
            v52 = v52 + 1
        end
    end
    if v52 ~= a1.gridSize * a1.gridSize then
        return false
    end
    return true
end
function tbl_upv_2.CircleEffect(a1, a2, a3, a4)
    --[[
      name: CircleEffect
      line: 580
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        Debris_upv_1 (copy, index: 2)
    ]]
    local v54 = a1.gridFrame:FindFirstChild(a2 .. "-" .. a3)
    if not v54 then
        return
    end
    local Circle_1 = v54:FindFirstChild("Circle")
    if Circle_1 then
        local v55 = Circle_1:Clone()
        v55:FindFirstChild("Number"):Destroy()
        v55.Parent = v54.Effects
        if a4 then
            local v56 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true, 0)
            local tbl_11 = {}
            tbl_11.Size = UDim2.fromScale(0.8, 0.8)
            TweenService_upv_1:Create(v55, v56, tbl_11):Play()
            Debris_upv_1:AddItem(v55, 0.4)
        else
            local v57 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_12 = {BackgroundTransparency = 1}
            tbl_12.Size = UDim2.fromScale(1, 1)
            TweenService_upv_1:Create(v55, v57, tbl_12):Play()
            Debris_upv_1:AddItem(v55, 0.45)
        end
    end
end
return tbl_upv_2
