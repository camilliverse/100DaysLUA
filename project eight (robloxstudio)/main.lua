local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local FORCA_DASH = 80
local TEMPO_DASH = 0.2
local COOLDOWN = 2

local podeDash = true

local function pegarPersonagem()
	return player.Character or player.CharacterAdded:Wait()
end

local function dash()
	if not podeDash then return end

	local character = pegarPersonagem()
	local humanoid = character:FindFirstChild("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then return end
	
	-- Não deixa usar no ar
	if humanoid.FloorMaterial == Enum.Material.Air then return end

	podeDash = false

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = root.CFrame.LookVector * FORCA_DASH
	bodyVelocity.MaxForce = Vector3.new(1, 0, 1) * 100000
	bodyVelocity.Parent = root

	task.delay(TEMPO_DASH, function()
		bodyVelocity:Destroy()
	end)

	task.delay(COOLDOWN, function()
		podeDash = true
	end)
end

UserInputService.InputBegan:Connect(function(input, processado)
	if processado then return end

	if input.KeyCode == Enum.KeyCode.Q then
		dash()
	end
end)
