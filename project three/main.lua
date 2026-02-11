local transacoes = {}
local conta = {
    saldo = 5000,
    bloqueada = false,
    pontuacaoRisco = 0
}

local tempo = 0
local mensagem = "Monitorando transações..."

local cores = {
    vermelho = {0.93, 0.0, 0.0},
    verde = {0.0, 0.6, 0.2},
    amarelo = {1.0, 0.7, 0.0},
    branco = {1,1,1},
    preto = {0,0,0}
}

function love.load()
    love.window.setMode(1000, 650)
    love.window.setTitle("Sistema de Detecção de Fraudes")
    love.graphics.setBackgroundColor(1,1,1)
end


function love.update(dt)
    tempo = tempo + dt

    if tempo > 3 and not conta.bloqueada then
        gerarTransacao()
        tempo = 0
    end
end


function love.draw()

    love.graphics.setColor(cores.vermelho)
    love.graphics.rectangle("fill", 0, 0, 1000, 70)

    love.graphics.setColor(cores.branco)
    love.graphics.setFont(love.graphics.newFont(22))
    love.graphics.print("Sistema Bancário - Detecção de Fraudes", 20, 20)

    love.graphics.setColor(cores.preto)
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print("Saldo: R$ " .. conta.saldo, 40, 100)
    love.graphics.print("Pontuação de Risco: " .. conta.pontuacaoRisco, 40, 130)

    if conta.bloqueada then
        love.graphics.setColor(cores.vermelho)
        love.graphics.print("CONTA BLOQUEADA", 40, 170)
    end

    love.graphics.setColor(cores.preto)
    love.graphics.print("Histórico de Transações:", 40, 220)

    for i, t in ipairs(transacoes) do
        local y = 250 + (i - 1) * 30
        love.graphics.print(t, 50, y)
    end

    love.graphics.setColor(cores.preto)
    love.graphics.print("Pressione [R] para resetar | Pressione [F] para simular fraude", 40, 600)

    love.graphics.print(mensagem, 40, 560)
end

function gerarTransacao(forcarFraude)
    local valor

    if forcarFraude then
        valor = math.random(3000, 8000)
    else
        valor = math.random(50, 2000)
    end

    conta.saldo = conta.saldo - valor

    local risco = calcularRisco(valor, forcarFraude)
    conta.pontuacaoRisco = conta.pontuacaoRisco + risco

    local status = "NORMAL"

    if risco > 70 then
        status = "ALTO RISCO"
    elseif risco > 40 then
        status = "RISCO MÉDIO"
    end

    if conta.pontuacaoRisco > 120 then
        conta.bloqueada = true
        mensagem = "Fraude detectada. Conta bloqueada."
    else
        mensagem = "Transação processada com sucesso."
    end

    table.insert(transacoes, 1,
        "Transação: R$ " .. valor .. " | Risco: " .. risco .. " | " .. status
    )

    if #transacoes > 10 then
        table.remove(transacoes)
    end
end

function calcularRisco(valor, forcar)
    local risco = 0

    if valor > 3000 then
        risco = risco + 60
    elseif valor > 1500 then
        risco = risco + 30
    else
        risco = risco + 10
    end

    if forcar then
        risco = risco + 40
    end

    return risco
end

function love.keypressed(tecla)

    if tecla == "r" then
        conta.saldo = 5000
        conta.pontuacaoRisco = 0
        conta.bloqueada = false
        transacoes = {}
        mensagem = "Conta resetada."
    end

    if tecla == "f" and not conta.bloqueada then
        gerarTransacao(true)
    end
end
