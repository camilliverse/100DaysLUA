local button = {}
local font

function love.load()

    -- Tamanho da janela
    love.window.setMode(800, 600)
    love.window.setTitle("Interface Ajustada")

    -- Fundo ROXO CLARO
    love.graphics.setBackgroundColor(0.75, 0.6, 0.9)

    -- Fonte
    font = love.graphics.newFont(24)
    love.graphics.setFont(font)

    -- Dimensões do botão
    button.width = 220
    button.height = 60

    -- Centralização
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    button.x = (screenWidth - button.width) / 2
    button.y = (screenHeight - button.height) / 2

    button.text = "Clique Aqui"
end

function love.update(dt)
end

function love.draw()

    local screenWidth = love.graphics.getWidth()

    -- ===== TÍTULO (BRANCO) =====
    love.graphics.setColor(1,1,1)
    love.graphics.printf(
        "Interface Gráfica - Teste",
        0,
        120,
        screenWidth,
        "center"
    )

    -- ===== BOTÃO (AMARELO CLARO) =====
    love.graphics.setColor(1, 0.95, 0.4)
    love.graphics.rectangle(
        "fill",
        button.x,
        button.y,
        button.width,
        button.height,
        12, 12
    )

    -- ===== TEXTO DO BOTÃO (PRETO) =====
    love.graphics.setColor(0, 0, 0)

    love.graphics.printf(
        button.text,
        button.x,
        button.y + (button.height / 2 - font:getHeight() / 2),
        button.width,
        "center"
    )
end

function love.mousepressed(x, y, buttonPressed)
    if buttonPressed == 1 then
        if x > button.x and x < button.x + button.width and
           y > button.y and y < button.y + button.height then
            
            print("Botão clicado!")
        end
    end
end
