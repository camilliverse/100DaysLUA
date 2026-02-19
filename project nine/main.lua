local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--// Stamina Settings
local MAX_STAMINA = 100
local stamina = MAX_STAMINA

local STAMINA_DRAIN = 30      -- por segundo
local STAMINA_REGEN = 20      -- por segundo
local REGEN_DELAY = 1.5       -- tempo para começar regenerar

local WALK_SPEED = 16
local RUN_SPEED = 24

local isRunning = false
local canRegen = true
local lastDrainTime = 0


local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(0.3, 0, 0.03, 0)
barBackground.Position = UDim2.new(0.35, 0, 0.9, 0)
barBackground.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBackground.BorderSizePixel = 0
barBackground.Parent = gui

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.BorderSizePixel = 0
bar.Parent = barBackground

--Update Stamina Bar
local function updateBar()
	bar.Size = UDim2.new(stamina / MAX_STAMINA, 0, 1, 0)
end

--Run 
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.LeftShift then
		if stamina > 0 then
			isRunning = true
			humanoid.WalkSpeed = RUN_SPEED
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		isRunning = false
		humanoid.WalkSpeed = WALK_SPEED
	end
end)

-- Main Loop
RunService.RenderStepped:Connect(function(delta)
	if isRunning and stamina > 0 then
		stamina -= STAMINA_DRAIN * delta
		lastDrainTime = tick()
		
		if stamina <= 0 then
			stamina = 0
			isRunning = false
			humanoid.WalkSpeed = WALK_SPEED
		end
	else
		if tick() - lastDrainTime > REGEN_DELAY then
			stamina += STAMINA_REGEN * delta
			stamina = math.clamp(stamina, 0, MAX_STAMINA)
		end
	end
	
	updateBar()
end)
