if not game:IsLoaded() then
    game.Loaded:Wait()
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Sino1507/Forsaken/refs/heads/main/src/main.luau"))()