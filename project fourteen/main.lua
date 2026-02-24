local Players = game:GetService("Players")

local MAX_OXYGEN = 100
local OXYGEN_DRAIN = 1
local OXYGEN_REGEN = 2
local DAMAGE_PER_TICK = 5

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		
		local humanoid = character:WaitForChild("Humanoid")
		local head = character:WaitForChild("Head")
		
		local oxygen = MAX_OXYGEN
		
		while character.Parent do
			task.wait(1)
			
			-- Detecta se está debaixo d’água
			local isUnderwater = head.Position.Y < workspace.Terrain.WaterWaveSize
			
			if isUnderwater then
				oxygen -= OXYGEN_DRAIN
				
				if oxygen <= 0 then
					oxygen = 0
					humanoid:TakeDamage(DAMAGE_PER_TICK)
				end
			else
				oxygen += OXYGEN_REGEN
				if oxygen > MAX_OXYGEN then
					oxygen = MAX_OXYGEN
				end
			end
			
			print("Oxygen:", oxygen)
		end
	end)
end)