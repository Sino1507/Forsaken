-- Script Path: game:GetService("ReplicatedStorage").Modules.Minigames.FlowGameManager
-- Took 0.01s to decompile.
-- Executor: Volt (1.3.7.0)

local FlowGame_upv_1 = require(script.FlowGame)
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new()
    --[[
      name: new
      line: 6
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.activeGame = nil
    v1.Completed = nil
    return v1
end
function tbl_upv_1.startGame(a1, a2, a3)
    --[[
      name: startGame
      line: 13
      upvalues:
        FlowGame_upv_1 (copy, index: 1)
    ]]
    if a1.activeGame then
        a1.activeGame:EndGame()
    end
    local v2 = script.PuzzleUI:Clone()
    v2.Parent = game.Players.LocalPlayer.PlayerGui
    a1.puzzleUI = v2
    local v3 = game.Players.LocalPlayer:GetAttribute("CompletedGenPuzzle")
    if not (v3) then
        v2.Container.Tutorial.Visible = true
        v2.Container.Position = UDim2.fromScale(0.5, 0.55)
    end
    a1.activeGame = FlowGame_upv_1.new(v2, a2, a3)
    a1.activeGame.completedEvent = Instance.new("BindableEvent")
    a1.Completed = a1.activeGame.completedEvent.Event
end
function tbl_upv_1.endGame(a1, a2)
    --[[
      name: endGame
      line: 31
    ]]
    if not a1.activeGame or a2 and a1.activeGame.id ~= a2 then
        return
    end
    a1.activeGame:EndGame()
    a1.activeGame = nil
end
return tbl_upv_1.new()
