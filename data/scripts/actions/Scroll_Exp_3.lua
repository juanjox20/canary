local expscroll = Action()

function expscroll.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    local expBoostCount = player:getStorageValue(GameStore.Storages.expBoostCount)
    
    if expBoostCount >= 10 then
        player:say('You have reached the limit for today, try again after Server Save.', TALKTYPE_MONSTER_SAY)
        return true
    end
    
    local currentBoost = player:getExpBoostStamina()
    local newBoost = currentBoost + 31536000 -- Adding 365 days worth of seconds for the new boost
    
    player:setStoreXpBoost(player:getStoreXpBoost() + 35) -- Suma el nuevo porcentaje al porcentaje de bonificación actual
    player:setExpBoostStamina(newBoost) -- Establecer el tiempo de bonificación de experiencia para representar 365 días
    
    Item(item.uid):remove(1)
    player:say('Your bonus of 35% XP has started and will last for the entire year!', TALKTYPE_MONSTER_SAY)
    return true
end

expscroll:id(45037)
expscroll:register()