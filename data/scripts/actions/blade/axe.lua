local itemQuest = Action()

local storageID = 405491
local itemBau = 44833
local qntItem = 1
local itemBau1 = 3043
local qntItem1 = 100
local msgQuandoAcha = "congratulation"
local msgQuandoJaPegou = "you already got it!."


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

itemQuest:uid(37492)
itemQuest:register()