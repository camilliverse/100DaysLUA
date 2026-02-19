-- =========================================
-- CONFIGURAÇÃO DO INVENTÁRIO
-- =========================================
local TAMANHO_INVENTARIO = 9
local inventarioAberto = false
local slotSelecionado = 1

local inventario = {}

-- Itens inspirados em Minecraft
local listaItens = {
    "Espada de Diamante",
    "Picareta de Ferro",
    "Maçã Dourada",
    "Bloco de Terra",
    "Arco",
    "Carne Assada",
    "Tocha",
    "Ender Pearl",
    "Bloco de Pedra"
}

local fonte

-- =========================================
-- INICIALIZAÇÃO
-- =========================================
function love.load()
    love.window.setTitle("Project Ten - Inventário")
    love.window.setMode(1100, 600)
    love.graphics.setBackgroundColor(0.1, 0.12, 0.15)

    fonte = love.graphics.newFont(16)
    love.graphics.setFont(fonte)

    for i = 1, TAMANHO_INVENTARIO do
        inventario[i] = nil
    end
end

-- =========================================
-- FUNÇÕES DO INVENTÁRIO
-- =========================================
local function adicionarItem(nomeItem)
    for i = 1, TAMANHO_INVENTARIO do
        if inventario[i] == nil then
            inventario[i] = {nome = nomeItem, quantidade = 1}
            return
        elseif inventario[i].nome == nomeItem then
            inventario[i].quantidade = inventario[i].quantidade + 1
            return
        end
    end
end

local function removerItem(slot)
    if inventario[slot] then
        inventario[slot].quantidade = inventario[slot].quantidade - 1

        if inventario[slot].quantidade <= 0 then
            inventario[slot] = nil
        end
    end
end

-- =========================================
-- CONTROLES
-- =========================================
function love.keypressed(tecla)

    if tecla == "i" then
        inventarioAberto = not inventarioAberto
    end

    if tecla == "a" then
        local itemAleatorio = listaItens[love.math.random(#listaItens)]
        adicionarItem(itemAleatorio)
    end

    if tecla == "r" then
        removerItem(slotSelecionado)
    end

    if tecla == "right" then
        slotSelecionado = slotSelecionado + 1
        if slotSelecionado > TAMANHO_INVENTARIO then
            slotSelecionado = 1
        end
    end

    if tecla == "left" then
        slotSelecionado = slotSelecionado - 1
        if slotSelecionado < 1 then
            slotSelecionado = TAMANHO_INVENTARIO
        end
    end
end

-- =========================================
-- DESENHAR INVENTÁRIO
-- =========================================
local function desenharInventario()

    local larguraTela = love.graphics.getWidth()
    local alturaTela = love.graphics.getHeight()

    local tamanhoSlot = 85
    local espacamento = 12
    local larguraTotal = (tamanhoSlot * TAMANHO_INVENTARIO) + (espacamento * (TAMANHO_INVENTARIO - 1))

    local inicioX = (larguraTela - larguraTotal) / 2
    local posY = alturaTela / 2

    for i = 1, TAMANHO_INVENTARIO do
        local posX = inicioX + (i - 1) * (tamanhoSlot + espacamento)

        -- Destaque do slot selecionado
        if i == slotSelecionado then
            love.graphics.setColor(0.3, 0.8, 0.3)
        else
            love.graphics.setColor(0.25, 0.25, 0.3)
        end

        love.graphics.rectangle("fill", posX, posY, tamanhoSlot, tamanhoSlot, 6, 6)

        -- Borda
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.rectangle("line", posX, posY, tamanhoSlot, tamanhoSlot, 6, 6)

        -- Item
        if inventario[i] then
            love.graphics.setColor(1, 1, 1)

            love.graphics.printf(
                inventario[i].nome,
                posX,
                posY + 18,
                tamanhoSlot,
                "center"
            )

            love.graphics.printf(
                "x" .. inventario[i].quantidade,
                posX,
                posY + 50,
                tamanhoSlot,
                "center"
            )
        end
    end
end

-- =========================================
-- DESENHAR NA TELA
-- =========================================
function love.draw()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("PROJECT TEN - SISTEMA DE INVENTÁRIO", 20, 20)
    love.graphics.print("I - Abrir/Fechar Inventário", 20, 50)
    love.graphics.print("A - Adicionar Item Aleatório", 20, 70)
    love.graphics.print("R - Remover Item Selecionado", 20, 90)
    love.graphics.print("← → - Mover Seleção", 20, 110)

    if inventarioAberto then
        desenharInventario()
    else
        love.graphics.printf(
            "Pressione I para abrir o inventário",
            0,
            love.graphics.getHeight() / 2,
            love.graphics.getWidth(),
            "center"
        )
    end
end
