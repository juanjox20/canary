local modalLeverShop = TalkAction("!buypaly")

function modalLeverShop.onSay(player, words, param)
    player:registerEvent("ArrowBolt Modal")

    local title = "ArrowBolt"
    local message = "Choose the ArrowBolt you want to buy."

    local window = ModalWindow(1000, title, message)

    window:addButton(101, "Buy 500")
    window:addButton(102, "Buy 300")
    window:addButton(103, "Buy 100")
    window:addButton(104, "Cancel")

    window:addChoice(1, "Diamond Arrow")
    window:addChoice(2, "Spectral Bolt")

    window:setDefaultEscapeButton(104)

    window:sendToPlayer(player)
    return false
end

function onModalWindow(player, modalWindow, buttonId, choiceId)
    if modalWindow:getId() == 1000 then
        local choice = modalWindow:getChoiceId(choiceId)
        if choice then
            local count = 0
            local itemId = 0

            if choice == 1 then -- Diamond Arrow
                itemId = 35901
            elseif choice == 2 then -- Spectral Bolt
                itemId = 35902
            end

            if buttonId == 101 then
                count = 500
            elseif buttonId == 102 then
                count = 300
            elseif buttonId == 103 then
                count = 100
            end

            if itemId > 0 and count > 0 then
                local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
                if backpack and backpack:getId() == backpackId then
                    player:addItem(itemId, count)
                else
                    player:sendCancelMessage("You need to have the correct backpack.")
                end
            end
        end
    end
end

modalLeverShop:groupType("normal")
modalLeverShop:register()