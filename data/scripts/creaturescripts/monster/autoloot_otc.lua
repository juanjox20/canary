local creatureEvent = CreatureEvent("autolootCleanCache")

function creatureEvent.onLogout(player)
    setPlayerAutolootItems(player, getPlayerAutolootItems(player))
    autolootCache[player:getGuid()] = nil
    return true
end

creatureEvent:register()
