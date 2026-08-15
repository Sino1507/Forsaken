local GeneratorController = {}
local Forsaken = getgenv().Forsaken

function GeneratorController:Init()
    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    self.settings = Forsaken.settings
    self.globals = Forsaken.globals

    self.flowGameManager = require(self.globals.flowGameManagerModule)
    self.isSolving = false
    self.solvingThread = nil
end

function GeneratorController:Run()
    if self.settings.Generator.AutoComplete then 
        if not self.isSolving and self.flowGameManager.activeGame ~= nil then 
            self.isSolving = true
            self.solvingThread = task.delay(self.settings.Generator.AutoDelay, function()
                pcall(function()
                    self.flowGameManager.activeGame:EndGame(true)
                end)

                self.isSolving = false
            end)
            Forsaken.globals.window:Toast({ title = "Started Solving", position = "Bottom", icon = 125823673784681 })
        end
    else
        if self.isSolving and self.solvingThread ~= nil then 
            task.cancel(self.solvingThread)
            self.solvingThread = nil
            self.isSolving = false 
        end
    end
end

function GeneratorController:Unload()
    if self.solvingThread ~= nil then 
        task.cancel(self.solvingThread)
        self.solvingThread = nil
    end
end

return GeneratorController