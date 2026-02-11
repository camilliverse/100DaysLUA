local estado = "login" 
local usuario = {
    nome = "Usuario",
    senha = "1234",
    saldo = 1000,
    tentativas = 0
}

local inputSenha = ""
local inputValor = ""
local mensagem = ""

local cores = {
    vermelho = {0.93, 0.0, 0.0},
    verde = {0.0, 0.6, 0.2},
    branco = {1,1,1},
    preto = {0,0,0},
    cinza = {0.9,0.9,0.9}
}

function love.load()
    love.window.setMode(900,600)
    love.window.setTitle("Sistema Bancário - Project Four")
    love.graphics.setBackgroundColor(1,1,1)
end

function love.draw()

    love.graphics.setColor(cores.vermelho)
    love.graphics.rectangle("fill",0,0,900,70)

    love.graphics.setColor(cores.branco)
    love.graphics.setFont(love.graphics.newFont(22))
    love.graphics.print("Banco Digital",20,20)

    love.graphics.setColor(cores.preto)
    love.graphics.setFont(love.graphics.newFont(16))

    if estado == "login" then
        desenharLogin()
    elseif estado == "conta" then
        desenharConta()
    elseif estado == "bloqueado" then
        desenharBloqueado()
    end

    love.graphics.print(mensagem, 40, 540)
end

function desenharLogin()
    love.graphics.print("Digite sua senha:", 40, 120)

    love.graphics.setColor(cores.cinza)
    love.graphics.rectangle("fill",40,150,300,40)

    love.graphics.setColor(cores.preto)
    love.graphics.rectangle("line",40,150,300,40)

    love.graphics.print(string.rep("*", #inputSenha),50,160)
    love.graphics.print("Pressione ENTER para acessar",40,210)
end

function desenharConta()
    love.graphics.print("Bem-vinda, "..usuario.nome,40,120)
    love.graphics.print("Saldo: R$ "..usuario.saldo,40,150)

    love.graphics.print("Digite valor:",40,220)

    love.graphics.setColor(cores.cinza)
    love.graphics.rectangle("fill",40,250,200,40)

    love.graphics.setColor(cores.preto)
    love.graphics.rectangle("line",40,250,200,40)

    love.graphics.print(inputValor,50,260)

    love.graphics.print("D = Depositar | S = Sacar | L = Logout",40,320)
end

function desenharBloqueado()
    love.graphics.setColor(cores.vermelho)
    love.graphics.print("CONTA BLOQUEADA POR EXCESSO DE TENTATIVAS",40,150)
end

function love.textinput(t)
    if estado == "login" then
        inputSenha = inputSenha .. t
    elseif estado == "conta" then
        if tonumber(t) then
            inputValor = inputValor .. t
        end
    end
end

function love.keypressed(tecla)

    if estado == "login" then
        if tecla == "backspace" then
            inputSenha = inputSenha:sub(1,-2)
        end

        if tecla == "return" then
            verificarLogin()
        end
    elseif estado == "conta" then

        if tecla == "backspace" then
            inputValor = inputValor:sub(1,-2)
        end

        if tecla == "d" then
            depositar()
        end

        if tecla == "s" then
            sacar()
        end

        if tecla == "l" then
            estado = "login"
            inputSenha = ""
            inputValor = ""
            mensagem = "Logout realizado."
        end
    end
end

function verificarLogin()
    if inputSenha == usuario.senha then
        estado = "conta"
        usuario.tentativas = 0
        mensagem = "Login realizado com sucesso."
    else
        usuario.tentativas = usuario.tentativas + 1
        mensagem = "Senha incorreta."

        if usuario.tentativas >= 3 then
            estado = "bloqueado"
        end
    end

    inputSenha = ""
end

function depositar()
    local valor = tonumber(inputValor)

    if valor and valor > 0 then
        usuario.saldo = usuario.saldo + valor
        mensagem = "Depósito realizado."
    else
        mensagem = "Valor inválido."
    end

    inputValor = ""
end

function sacar()
    local valor = tonumber(inputValor)

    if valor and valor > 0 and valor <= usuario.saldo then
        usuario.saldo = usuario.saldo - valor
        mensagem = "Saque realizado."
    else
        mensagem = "Saldo insuficiente ou valor inválido."
    end

    inputValor = ""
end
