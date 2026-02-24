--level uppppp 
local Players = game:GetService("Players")

local BASE_XP = 100
local XP_MULTIPLIER = 1.5

local function getRequiredXP(level)
	return math.floor(BASE_XP * (XP_MULTIPLIER ^ (level - 1)))
end

local function setupPlayer(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = 1
	level.Parent = leaderstats
	
	local xp = Instance.new("IntValue")
	xp.Name = "XP"
	xp.Value = 0
	xp.Parent = leaderstats
end

local function addXP(player, amount)
	local level = player.leaderstats.Level
	local xp = player.leaderstats.XP
	
	xp.Value += amount
	
	while xp.Value >= getRequiredXP(level.Value) do
		xp.Value -= getRequiredXP(level.Value)
		level.Value += 1
		
		print(player.Name .. " subiu para o level " .. level.Value)
	end
end

Players.PlayerAdded:Connect(function(player)
	setupPlayer(player)
end)

-- EXEMPLO: dar XP ao tocar numa part
workspace.ChildAdded:Connect(function(obj)
	if obj:IsA("Part") and obj.Name == "XPBlock" then
		obj.Touched:Connect(function(hit)
			local character = hit.Parent
			local player = Players:GetPlayerFromCharacter(character)
			
			if player then
				addXP(player, 25)
			end
		end)
	end
end)