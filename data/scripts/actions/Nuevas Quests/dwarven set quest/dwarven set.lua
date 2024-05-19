local itemQuest = Action()

local storageID = 505012
local itemBau = 3043
local qntItem = 10
local itemBau1 = 3396
local qntItem1 = 1
local itemBau2 = 3397
local qntItem2 = 1
local itemBau3 = 3398
local qntItem3 = 1
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

itemQuest:uid(55512)
itemQuest:register()