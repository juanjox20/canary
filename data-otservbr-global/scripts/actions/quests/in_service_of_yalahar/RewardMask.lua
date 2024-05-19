local RewardMask = Action()

local storageID = 3888
local itemBau = 8864
local qntItem = 1
local msgQuandoAcha = "you have found a yalahari mask."
local msgQuandoJaPegou = "The chest is empty.!"


function RewardMask.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    if (player:getStorageValue(storageID) == 1) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoJaPegou)
        return true
    end

    player:addItem(itemBau, qntItem)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    player:setStorageValue(storageID, 1)
    return true
end

RewardMask:uid(3888)
RewardMask:register()