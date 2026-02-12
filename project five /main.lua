
local attacks = {}
local riskLevel = 0
local systemStatus = "Sistema Seguro"
local spawnTimer = 0
local gameOver = false

local attackTypes = {
    {name = "Brute Force", threat = 10},
    {name = "DDoS", threat = 20},
    {name = "Phishing", threat = 15},
    {name = "Malware", threat = 25}
}

function generateIP()
    return math.random(1,255).."."..
           math.random(1,255).."."..
           math.random(1,255).."."..
           math.random(1,255)
end

function spawnAttack()
    local attack = attackTypes[math.random(#attackTypes)]
    table.insert(attacks, {
        ip = generateIP(),
        type = attack.name,
        threat = attack.threat,
        time = 0
    })
end

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    if gameOver then return end

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        spawnAttack()
        spawnTimer = 0
    end

    for i = #attacks, 1, -1 do
        attacks[i].time = attacks[i].time + dt
        
        if attacks[i].time > 5 then
            riskLevel = riskLevel + attacks[i].threat
            table.remove(attacks, i)
        end
    end

    if riskLevel >= 100 then
        systemStatus = "SISTEMA COMPROMETIDO"
        gameOver = true
    end
end

function love.keypressed(key)
    if key == "space" and #attacks > 0 and not gameOver then
        -- Bloqueia o primeiro ataque da lista
        table.remove(attacks, 1)
    end

    if key == "r" and gameOver then
        attacks = {}
        riskLevel = 0
        systemStatus = "Sistema Seguro"
        gameOver = false
    end
end

function love.draw()
    love.graphics.print("=== Cyber Security Monitor ===", 20, 20)
    love.graphics.print("Nivel de Risco: "..riskLevel.."%", 20, 50)
    love.graphics.print("Status: "..systemStatus, 20, 80)

    love.graphics.print("Pressione ESPACO para bloquear ataque", 20, 110)
    love.graphics.print("Pressione R para reiniciar", 20, 130)

    local y = 170

    for i, attack in ipairs(attacks) do
        love.graphics.print(
            attack.ip.." | "..attack.type.." | Ameaça: "..attack.threat,
            20, y
        )
        y = y + 25
    end
end
