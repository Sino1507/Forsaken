local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SlateTimer = {}

function SlateTimer:ShowEffect(char: Model, duration: number)
	local torso = char:FindFirstChild("Torso")
	if not torso then return end

	local oldGui = torso:FindFirstChild("CombatEffect")
	if oldGui then
		oldGui:Destroy()
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CombatEffect"
	billboard.Adornee = torso
	billboard.Size = UDim2.fromOffset(220, 55)
	billboard.StudsOffset = Vector3.new(0, 0, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 100
	billboard.Parent = torso

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(0.7, 0.7)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 60, 60)
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Parent = billboard

	-- Pop in
	local popIn = TweenService:Create(
		label,
		TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = UDim2.fromScale(1, 1) }
	)

	popIn:Play()

	local startTime = os.clock()

	while true do
		local elapsed = os.clock() - startTime
		local remaining = duration - elapsed

		if remaining <= 0 then
			break
		end

		label.Text = string.format("%s %.1fs", "Slateskin", remaining)

		task.wait(0.05)
	end

	-- Fade out
	local fade = TweenService:Create(
		label,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}
	)

	fade:Play()
	fade.Completed:Wait()

	billboard:Destroy()
end

function SlateTimer:Init(Noob: Model)
    local Forsaken = getgenv().Forsaken

    if not Forsaken.__initialized then
        error("Forsaken is not initialized. Please ensure that the main script is loaded before accessing other scripts.")
    end

    local globals = Forsaken.globals
    local settings = Forsaken.settings

    if Noob == nil then 
        return
    end

    local username = Noob:GetAttribute("Username")

    if username == Players.LocalPlayer.Name then 
        return
    end

    local Slateskin: Part = Noob:WaitForChild("Slateskin", 10)

    if Slateskin == nil then 
        return 
    end

    Slateskin.Changed:Connect(function(attr: string)
        if not settings.ExtraInfo.SlateSkinTimer then 
            return
        end

        if attr == "Transparency" then 
            local NoobData = require(ReplicatedStorage.Assets.Survivors.Noob.Config)
            local Duration = NoobData.SlateskinEffectDuration

            if Slateskin.Transparency == 1 then
                if settings.ExtraInfo.NotifyMe then 
                    globals.window:Notify({
                        title = "Slateskin",
                        content = "Slateskin was just used by " .. username .. ".",
                        duration = 3,
                    })
                end

                self:ShowEffect(Noob, Duration)
            end
        end
    end)
end

return SlateTimer