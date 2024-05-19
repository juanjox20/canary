local Reward3 = Action()

local storageID = 105000
local itemBau = 14768
local qntItem = 1
local itemBau1 = 3043
local qntItem1 = 10
local msgQuandoAcha = "congratulation disfruta"
local msgQuandoJaPegou = "Ya Tomaste Esto Cabron!."


function Reward3.onUse(player, item, fromPosition, target, toPosition, isHotkey)

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

Reward3:uid(1904)
Reward3:register()