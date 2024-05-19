local SetKina = Action()

local storageID = 100001
local itemBau = 14000
local qntItem = 1
local itemBau1 = 13999
local qntItem1 = 1
local itemBau2 = 13993
local qntItem2 = 1
local msgQuandoAcha = "congratulation disfruta"
local msgQuandoJaPegou = "Ya Tomaste Esto Cabron!."


function SetKina.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    if (player:getStorageValue(storageID) == 1) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoJaPegou)
        return true
    end

    player:addItem(itemBau, qntItem)
    player:addItem(itemBau1, qntItem1)
    player:addItem(itemBau2, qntItem1)


    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    player:setStorageValue(storageID, 1)
    return true
end

SetKina:uid(58880)
SetKina:register()