function love.load()
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    math.randomseed(os.time())

    game = {}
    game.state = "playing"
    game.turn = "player"

    player = {
        hp = 100,
        maxHp = 100,
        mana = 50,
        maxMana = 50,
        attack = 15,
        critChance = 0.2,
        skillCooldown = 0
    }

    enemy = {
        hp = 120,
        maxHp = 120,
        attack = 12
    }

    fontBig = love.graphics.newFont(22)
    fontSmall = love.graphics.newFont(16)
end

function love.update(dt)
    if game.state ~= "playing" then return end

    if game.turn == "enemy" then
        enemyAttack()
        game.turn = "player"
    end

    if player.skillCooldown > 0 then
        player.skillCooldown = player.skillCooldown - dt
    end

    checkGameState()
end
function playerAttack()
    local damage = player.attack

    if math.random() < player.critChance then
        damage = damage * 2
    end

    enemy.hp = math.max(enemy.hp - damage, 0)
    game.turn = "enemy"
end

function playerSkill()
    if player.mana >= 20 and player.skillCooldown <= 0 then
        enemy.hp = math.max(enemy.hp - 35, 0)
        player.mana = player.mana - 20
        player.skillCooldown = 3
        game.turn = "enemy"
    end
end
function enemyAttack()
    player.hp = math.max(player.hp - enemy.attack, 0)
end
function checkGameState()
    if player.hp <= 0 then
        game.state = "lost"
    elseif enemy.hp <= 0 then
        game.state = "won"
    end
end
function love.draw()
    love.graphics.setFont(fontBig)
    love.graphics.printf("SYSTEM- Arena RPG", 0, 20, 800, "center")

    drawBars()

    love.graphics.setFont(fontSmall)

    if game.state == "playing" then
        love.graphics.printf("1 - Ataque Normal", 50, 400, 300)
        love.graphics.printf("2 - Bola de Fogo (20 mana)", 50, 430, 300)

        if player.skillCooldown > 0 then
            love.graphics.printf("Cooldown: " .. string.format("%.1f", player.skillCooldown), 50, 460, 300)
        end
    elseif game.state == "won" then
        love.graphics.printf("VITÓRIA! Pressione R para reiniciar", 0, 350, 800, "center")
    elseif game.state == "lost" then
        love.graphics.printf("GAME OVER! Pressione R para reiniciar", 0, 350, 800, "center")
    end
end
function drawBars()
    -- Player HP
    love.graphics.rectangle("line", 50, 100, 300, 20)
    love.graphics.rectangle("fill", 50, 100, 300 * (player.hp / player.maxHp), 20)
    love.graphics.print("Player HP: " .. player.hp, 50, 70)

    -- Player Mana
    love.graphics.rectangle("line", 50, 140, 300, 20)
    love.graphics.rectangle("fill", 50, 140, 300 * (player.mana / player.maxMana), 20)
    love.graphics.print("Mana: " .. player.mana, 50, 115)

    -- Enimigo HP
    love.graphics.rectangle("line", 450, 100, 300, 20)
    love.graphics.rectangle("fill", 450, 100, 300 * (enemy.hp / enemy.maxHp), 20)
    love.graphics.print("Enemy HP: " .. enemy.hp, 450, 70)
end
function love.keypressed(key)
    if game.state == "playing" then
        if key == "1" then
            playerAttack()
        elseif key == "2" then
            playerSkill()
        end
    end

    if key == "r" then
        love.load()
    end
end
