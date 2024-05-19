-- Canary Login Modal Message
-- NvSo

local messageLogin = CreatureEvent("messageLogin")

function messageLogin.onLogin(player)
    local text = "We welcome you all to ".. configManager.getString(configKeys.SERVER_NAME) .." \nwho have come to enjoy the best of Server! Usa El Comando !restore info."
    local menu = ModalWindow{
        title = "Welcome to " .. configManager.getString(configKeys.SERVER_NAME),
        message = text
    }
    menu:addButton("Close")

    menu:sendToPlayer(player)
    return true
end

messageLogin:register() 