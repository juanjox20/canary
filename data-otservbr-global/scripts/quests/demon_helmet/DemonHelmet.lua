local DemonHelmet = Action()

local storageID = 8180
local itemBau1 = 3554
local qntItem1 = 1
local itemBau2 = 3420
local qntItem2 = 1
local itemBau3 = 3387
local qntItem3 = 1
local msgQuandoAcha = "congratulation disfruta"
local msgQuandoJaPegou = "Ya Tomaste Esto Cabron!."


function DemonHelmet.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    if (player:getStorageValue(storageID) == 1) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoJaPegou)
        return true
    end

    player:addItem(itemBau1, qntItem1)
    player:addItem(itemBau2, qntItem2)
    player:addItem(itemBau3, qntItem3)
	
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    player:setStorageValue(storageID, 1)
    return true
end

DemonHelmet:uid(8180)
DemonHelmet:register()