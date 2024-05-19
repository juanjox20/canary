local expscroll = Action()

function expscroll.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    local remainingBoost = player:getExpBoostStamina()
    local currentExpBoostTime = player:getExpBoostStamina()
    local expBoostCount = player:getStorageValue(GameStore.Storages.expBoostCount)

    if expBoostCount >= 3 then -- Xp boost can only be used 3 times a day
        player:say('Has alcanzado el limite para hoy, intentalo de nuevo despues de Guardar servidor.', TALKTYPE_MONSTER_SAY)
        return true
    end
    
    if (remainingBoost > 0) then -- If player still has an active xp boost, don't let him use another one
        player:say('Ya tienes un impulso de XP activo.', TALKTYPE_MONSTER_SAY)
        return true
    end
    
    player:setStoreXpBoost(80) -- Aqui configuras la doble experiencia actualmente esta en 80% extra.
    player:setExpBoostStamina(currentExpBoostTime + 36000)
    Item(item.uid):remove(1)
    player:say('Tu hora de bonificacion de XP del 80% ha comenzado!', TALKTYPE_MONSTER_SAY)
    return true
end

expscroll:id(45043)
expscroll:register()
