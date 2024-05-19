local modalLeverShop = Action()
function modalLeverShop.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    player:registerEvent("Potions Modal")

    local title = "Potions"
    local message = "choose your potion you want to buy."

    local window = ModalWindow(1000, title, message)

    window:addButton(101, "Buy 500")
    window:addButton(102, "Buy 200")
    window:addButton(103, "Buy 50")
    window:addButton(104, "Cancel")

    window:addChoice(1, "Mana Potion") -- 
    window:addChoice(2, "Health Potion")
    window:addChoice(3, "Strong Mana Potion")
    window:addChoice(4, "Strong Health Potion")
    window:addChoice(5, "Great Mana Potion")
    window:addChoice(6, "Great Health Potion")
    window:addChoice(7, "Great Spirit Potion")
    window:addChoice(8, "Ultimate Mana Potion")
    window:addChoice(9, "Ultimate Health Potion")
    window:addChoice(10, "Ultimate Spirit Potion")
    window:addChoice(11, "Supreme Health Potion")

    window:setDefaultEscapeButton(104)

    window:sendToPlayer(player)
    return true
end

modalLeverShop:aid(22100)
modalLeverShop:register()