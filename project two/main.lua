local inputs = {}
local activeInput = nil
local users = {}
local selectedUser = nil
local message = ""

local colors = {
    red = {0.93, 0.0, 0.0},
    lightGray = {0.95, 0.95, 0.95},
    white = {1, 1, 1},
    black = {0, 0, 0}
}

function createInput(x, y, w, h, placeholder, isPassword)
    return {
        x = x, y = y, w = w, h = h,
        text = "",
        placeholder = placeholder,
        active = false,
        isPassword = isPassword or false
    }
end

function isMouseOver(input, mx, my)
    return mx > input.x and mx < input.x + input.w and
           my > input.y and my < input.y + input.h
end


function love.load()
    love.window.setTitle("Santander • Registro")
    love.window.setMode(1000, 700)
    love.graphics.setBackgroundColor(colors.white)

    inputs = {
        createInput(50, 100, 300, 40, "Nome Completo"),
        createInput(50, 160, 300, 40, "CPF"),
        createInput(50, 220, 300, 40, "Email"),
        createInput(50, 280, 300, 40, "Senha", true)
    }
end

function love.draw()
    love.graphics.setColor(colors.red)
    love.graphics.rectangle("fill", 0, 0, 1000, 70)

    love.graphics.setColor(colors.white)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print("Banco Santander - Registro", 30, 20)

    love.graphics.setFont(love.graphics.newFont(14))
    for _, input in ipairs(inputs) do
        love.graphics.setColor(colors.lightGray)
        love.graphics.rectangle("fill", input.x, input.y, input.w, input.h)

        love.graphics.setColor(input.active and colors.red or colors.black)
        love.graphics.rectangle("line", input.x, input.y, input.w, input.h)

        local text = input.text
        if input.isPassword then
            text = string.rep("*", #input.text)
        end

        if text == "" then
            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.print(input.placeholder, input.x + 10, input.y + 10)
        else
            love.graphics.setColor(colors.black)
            love.graphics.print(text, input.x + 10, input.y + 10)
        end
    end

    love.graphics.setColor(colors.red)
    love.graphics.rectangle("fill", 50, 340, 300, 45)
    love.graphics.setColor(colors.white)
    love.graphics.printf("Registrar", 50, 352, 300, "center")

    love.graphics.setColor(colors.black)
    love.graphics.print(message, 50, 400)

    love.graphics.print("Usuários Registrados:", 400, 100)

    for i, user in ipairs(users) do
        local y = 130 + (i - 1) * 60

        love.graphics.rectangle("line", 400, y, 500, 50)
        love.graphics.print(user.nome .. " | " .. user.email, 410, y + 15)

        love.graphics.setColor(colors.red)
        love.graphics.rectangle("fill", 830, y + 10, 60, 30)
        love.graphics.setColor(colors.white)
        love.graphics.printf("X", 830, y + 15, 60, "center")
    end
end

function love.textinput(t)
    if activeInput then
        activeInput.text = activeInput.text .. t
    end
end

function love.keypressed(key)
    if key == "backspace" and activeInput then
        activeInput.text = activeInput.text:sub(1, -2)
    end
end

function love.mousepressed(x, y, btn)
    if btn ~= 1 then return end

    activeInput = nil
    for _, input in ipairs(inputs) do
        input.active = false
        if isMouseOver(input, x, y) then
            input.active = true
            activeInput = input
        end
    end

    if x > 50 and x < 350 and y > 340 and y < 385 then
        registerUser()
    end

    
    for i, user in ipairs(users) do
        local yUser = 130 + (i - 1) * 60
        if x > 830 and x < 890 and y > yUser + 10 and y < yUser + 40 then
            table.remove(users, i)
            return
        end
    end
end


function registerUser()
    for _, input in ipairs(inputs) do
        if input.text == "" then
            message = "Preencha todos os campos."
            return
        end
    end

    table.insert(users, {
        nome = inputs[1].text,
        cpf = inputs[2].text,
        email = inputs[3].text,
        senha = inputs[4].text
    })

    for _, input in ipairs(inputs) do
        input.text = ""
    end

    message = "Usuário registrado com sucesso."
end
