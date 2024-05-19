local mountaddondoll = Action()

local storageID = 605050
local itemBau = 10200
local qntItem = 1
local itemBau1 = 45851
local qntItem1 = 1
local itemBau2 = 8778
local qntItem2 = 1
local itemBau3 = 3043
local qntItem3 = 10
local msgQuandoAcha = "congratulation disfruta"
local msgQuandoJaPegou = "Ya Tomaste Esto Cabron!."


function mountaddondoll.onUse(player, item, fromPosition, target, toPosition, isHotkey)

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

mountaddondoll:uid(33301)
mountaddondoll:register()