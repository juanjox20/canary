local itemQuest = Action()

local storageID = 10500
local itemBau = 43865
local qntItem = 1
local itemBau1 = 3043
local qntItem1 = 10
local msgQuandoAcha = "congratulation disfruta"
local msgQuandoJaPegou = "Ya Tomaste Esto Cabron!."


function itemQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    if (player:getStorageValue(storageID) == 1) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoJaPegou)
        return true
    end

    player:addItem(itemBau, qntItem)
    player:addItem(itemBau1, qntItem1)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    player:setStorageValue(storageID, 1)
    return true
end

itemQuest:uid(11503)
itemQuest:register()