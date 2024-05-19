local itemQuest = Action()

local storageID = 155100
local itemBau = 16160
local qntItem = 1
local itemBau1 = 16163
local qntItem1 = 1
local itemBau2 = 16161
local qntItem2 = 1
local itemBau3 = 3043
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

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    player:setStorageValue(storageID, 1)
    return true
end

itemQuest:uid(15555)
itemQuest:register()