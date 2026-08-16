local Players = game:GetService("Players")
local Cache = {}
local Forsaken = getgenv().Forsaken

function Cache:CacheKillerModels()
    for _, child in pairs(Forsaken.globals.killerFolder:GetChildren()) do
        if self.localPlayer.Character ~= nil and self.localPlayer.Character == child then 
            continue
        end

        Forsaken.cache.killerModels[child] = child
        child.Destroying:Connect(function()
            Forsaken.cache.killerModels[child] = nil
        end)
    end
end

function Cache:CacheSurvivorModels()
    for _, child in pairs(Forsaken.globals.survivorFolder:GetChildren()) do
        if self.localPlayer.Character ~= nil and self.localPlayer.Character == child then 
            continue
        end

        Forsaken.cache.survivorModels[child] = child
        child.Destroying:Connect(function()
            Forsaken.cache.survivorModels[child] = nil
        end)
    end
end

function Cache:CacheMapParts()
    for _, child in pairs(Forsaken.globals.mapModel:GetChildren()) do
        if child:IsA("Tool") then
            Forsaken.cache.itemParts[child] = child
            child.Destroying:Connect(function()
                Forsaken.cache.itemParts[child] = nil
            end)
        elseif child:IsA("Model") and child.Name == "Generator" then
            Forsaken.cache.generatorModels[child] = child
            child.Destroying:Connect(function()
                Forsaken.cache.generatorModels[child] = nil
            end)
        end
    end
end

function Cache:ClearKillerCache()
    Forsaken.cache.killerModels = {}
end

function Cache:ClearSurvivorCache()
    Forsaken.cache.survivorModels = {}
end

function Cache:ClearItemsCache()
    Forsaken.cache.itemParts = {}
end

function Cache:ClearGeneratorCache()
    Forsaken.cache.generatorModels = {}
end

function Cache:ClearAll()
    self:ClearKillerCache()
    self:ClearSurvivorCache()
    self:ClearItemsCache()
    self:ClearGeneratorCache()
end

function Cache:Init()
    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing the cache.")
    end

    Forsaken.cache = {
        killerModels = {},
        survivorModels = {},
        itemParts = {},
        generatorModels = {}
    }

    self.localPlayer = Players.LocalPlayer

    Forsaken.connections.killerModels = Forsaken.globals.killerFolder.ChildAdded:Connect(function(child)
        if self.localPlayer.Character ~= nil and self.localPlayer.Character == child then 
            return
        end

        task.delay(1, function()
            Forsaken.cache.killerModels[child] = child
        end)
        child.Destroying:Connect(function()
            Forsaken.cache.killerModels[child] = nil
        end)
    end)

    Forsaken.connections.survivorModels = Forsaken.globals.survivorFolder.ChildAdded:Connect(function(child)
        if self.localPlayer.Character ~= nil and self.localPlayer.Character == child then 
            return
        end

        task.delay(1, function()
            Forsaken.cache.survivorModels[child] = child
        end)
        child.Destroying:Connect(function()
            Forsaken.cache.survivorModels[child] = nil
        end)
    end)

    if Forsaken.globals.mapModel ~= nil then 
        Forsaken.connections.mapParts = Forsaken.globals.mapModel.ChildAdded:Connect(function(child)
            if child:IsA("Model") and child.Name == "Generator" then
                Forsaken.cache.generatorModels[child] = child
                child.Destroying:Connect(function()
                    Forsaken.cache.generatorModels[child] = nil
                end)
            elseif child:IsA("Tool") then 
                Forsaken.cache.itemParts[child] = child
                child.Destroying:Connect(function()
                    Forsaken.cache.itemParts[child] = nil
                end)
            end
        end)
    end

    Forsaken.connections.mapRemoved = Forsaken.globals.mapFolder.ChildRemoved:Connect(function(child)
        if child:IsA("Model") and child.Name == "Map" then
            Forsaken.globals.mapModel = nil
            self:ClearAll()

            if Forsaken.connections.mapPart ~= nil then 
                Forsaken.connections.mapParts:Disconnect()
                Forsaken.connections.mapParts = nil
            end

            -- Clear all instances that arent the watermark for performance
            for i, instance in pairs(Forsaken.instances) do 
                if instance:IsA("ScreenGui") or instance:IsA("Frame") or instance:IsA("TextLabel") then continue end 

                if instance.Destroy then 
                    table.remove(Forsaken.instances, i)
                    instance:Destroy()
                end
            end
        end
    end)

    Forsaken.connections.mapUpdate = Forsaken.globals.mapFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child.Name == "Map" then 
            -- Clear all instances that arent the watermark for performance
            for i, instance in pairs(Forsaken.instances) do 
                if instance:IsA("ScreenGui") or instance:IsA("Frame") or instance:IsA("TextLabel") then continue end 

                if instance.Destroy then 
                    table.remove(Forsaken.instances, i)
                    instance:Destroy()
                end
            end

            self:ClearItemsCache()
            self:ClearGeneratorCache()

            Forsaken.globals.mapModel = child
            self:CacheMapParts()
            
            if Forsaken.connections.mapParts ~= nil then 
                Forsaken.connections.mapParts:Disconnect()
                Forsaken.connections.mapParts = nil 
            end

            Forsaken.connections.mapParts = Forsaken.globals.mapModel.ChildAdded:Connect(function(newChild)
                if newChild:IsA("Model") and newChild.Name == "Generator" then
                    Forsaken.cache.generatorModels[newChild] = newChild
                    newChild.Destroying:Connect(function()
                        Forsaken.cache.generatorModels[newChild] = nil
                    end)
                elseif newChild:IsA("Tool") then 
                    Forsaken.cache.itemParts[newChild] = newChild
                    newChild.Destroying:Connect(function()
                        Forsaken.cache.itemParts[newChild] = nil
                    end)
                end
            end)
        end
    end)

    -- Initialize the cache with existing children
    self:CacheKillerModels()
    self:CacheSurvivorModels()
    
    if Forsaken.globals.mapModel ~= nil then 
        self:CacheMapParts()
    end
end

function Cache:Unload()
    if Forsaken.connections.killerModels then
        Forsaken.connections.killerModels:Disconnect()
        Forsaken.connections.killerModels = nil
    end

    if Forsaken.connections.survivorModels then
        Forsaken.connections.survivorModels:Disconnect()
        Forsaken.connections.survivorModels = nil
    end

    if Forsaken.connections.mapParts then
        Forsaken.connections.mapParts:Disconnect()
        Forsaken.connections.mapParts = nil
    end

    Forsaken.cache = {
        killerModels = {},
        survivorModels = {},
        itemParts = {},
        generatorModels = {}
    }
end

return Cache