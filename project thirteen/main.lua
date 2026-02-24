--inimigo sistema rpg robloxstudio
local inimigo = script.Parent
local humanoide = inimigo:WaitForChild("Humanoid")

local VIDA_MAXIMA = 100
local TEMPO_RESPAWN = 5
local CHANCE_DROP = 0.5
local XP_RECOMPENSA = 50

humanoide.MaxHealth = VIDA_MAXIMA
humanoide.Health = VIDA_MAXIMA

local posicaoInicial = inimigo:GetPivot()
local Players = game:GetService("Players")

local function recompensarJogador(jogador)
	if jogador:FindFirstChild("leaderstats") then
		local xp = jogador.leaderstats:FindFirstChild("XP")
		if xp then
			xp.Value += XP_RECOMPENSA
		end
	end
end

humanoide.Died:Connect(function()
	local tag = humanoide:FindFirstChild("criador")
	
	if tag and tag.Value and tag.Value:IsA("Player") then
		if math.random() <= CHANCE_DROP then
			recompensarJogador(tag.Value)
			print("XP concedido para " .. tag.Value.Name)
		end
	end
	
	task.wait(TEMPO_RESPAWN)
	
	inimigo:PivotTo(posicaoInicial)
	humanoide.Health = VIDA_MAXIMA
end)

--jogaor causa dano no inimigo 
local tag = Instance.new("ObjectValue")
tag.Name = "criador"
tag.Value = jogador
tag.Parent = humanoide
game:GetService("Debris"):AddItem(tag, 2)