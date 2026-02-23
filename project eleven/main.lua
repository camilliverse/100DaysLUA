--luz checar
local part = script.Parent
local light = part:FindFirstChildOfClass("PointLight")

local DETECTION_RADIUS = 15
local CRITICAL_CHANCE = 0.1
local DAMAGE = 5

local isCritical = false
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Função para checar jogador próximo
local function isPlayerNear()
	for _, player in pairs(players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
			if distance <= DETECTION_RADIUS then
				return player
			end
		end
	end
	return nil
end

-- Modo crítico aleatório
if math.random() < CRITICAL_CHANCE then
	isCritical = true
end

runService.Heartbeat:Connect(function()
	local nearbyPlayer = isPlayerNear()

	if nearbyPlayer then
		light.Enabled = true
		
		if isCritical then
			light.Brightness = 5
			light.Color = Color3.fromRGB(255, 0, 0)
			
			local humanoid = nearbyPlayer.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid:TakeDamage(DAMAGE)
			end
		else
			light.Brightness = 2
			light.Color = Color3.fromRGB(255, 255, 200)
		end
	else
		light.Enabled = false
	end
end)