local itemQuest = Action()

local storageID = 505000
local itemBau = 10201
local qntItem = 1
local itemBau1 = 3043
local qntItem1 = 10
local itemBau2 = 22516
local qntItem2 = 5
local itemBau3 = 22118
local qntItem3 = 10
local msgQuandoAcha = "congratulation disfruta"
local msgQuandoJaPegou = "Ya Tomaste Esto Cabron!."


function itemQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    if (player:getStorageValue(storageID) == 1) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoJaPegou)
        return true
    end

    player:addItem(itemBau, qntItem)

    player:addItem(itemBau1, qntItem1)
    player:addItem(itemBau2, qntItem1)
    player:addItem(itemBau3, qntItem1)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    player:setStorageValue(storageID, 1)
    return true
end

itemQuest:uid(55501)
itemQuest:register()