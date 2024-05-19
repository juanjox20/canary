local RewardArmor = Action()

local storageID = 3888
local itemBau = 8862
local qntItem = 1
local msgQuandoAcha = "You have found a yalahari armor."
local msgQuandoJaPegou = "The chest is empty.!"


function RewardArmor.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    if (player:getStorageValue(storageID) == 1) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoJaPegou)
        return true
    end

    player:addItem(itemBau, qntItem)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    player:setStorageValue(storageID, 1)
    return true
end

RewardArmor:uid(3889)
RewardArmor:register()