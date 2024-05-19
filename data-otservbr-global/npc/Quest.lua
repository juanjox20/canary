local internalNpcName = "Resusitada"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

local storagePermission = 505000
local storageMission = 505001

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 131,
    lookHead = 38,
    lookBody = 113,
    lookLegs = 67,
    lookFeet = 95,
    lookAddons = 0,
}

npcConfig.flags = {
    floorchange = false,
}

npcConfig.voices = {
    interval = 15000,
    chance = 50,
    { text = "Hello there, adventurer! Need a deal in weapons or armor? I'm your man!" },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
    npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
    npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
    npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
    npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
    npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
    npcHandler:onCloseChannel(npc, creature)
end

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()

    -- Verificar si el jugador ha completado la misión de almacenamiento
    if player:getStorageValue(storageMission) ~= 1 then
        npcHandler:say("Lo siento, necesitas completar la misión de almacenamiento primero.", npc, creature)
        return true
    end

    -- Verificar si el jugador tiene el almacenamiento requerido
    if not player:getStorageValue(storagePermission) == 1 then
        npcHandler:say("Lo siento, necesitas permiso para hablar conmigo.", npc, creature)
        return true
    end

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    if message:lower() == "mission" then
        npcHandler:say("Lo siento, necesitas permiso para iniciar un comercio conmigo.", npc, creature)
        return true
    end

    if MsgContains(message, "2000 steel shields") then
        -- Verificar si el jugador tiene el permiso para vender los elementos
        if player:getStorageValue(storagePermission) == 1 then
            if player:getStorageValue(Storage.WhatAFoolish.Questline) ~= 29 or player:getStorageValue(Storage.WhatAFoolish.Contract) == 2 then
                npcHandler:say("My offers are weapons, armors, helmets, legs, and shields. If you'd like to see my offers, ask me for a {mission}.", npc, creature)
                return true
            end

            npcHandler:say("What? You want to buy 2000 steel shields??", npc, creature)
            npcHandler:setTopic(playerId, 2)
            return true
        else
            npcHandler:say("I'm sorry, you don't have permission to sell these items.", npc, creature)
            return true
        end
    end

    return false
end

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the blacksmith. If you need weapons or armor - just ask me." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my shop, adventurer |PLAYERNAME|! I {mission} with weapons and armor.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and come again, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and come again.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
    { itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
    { itemName = "wooden shield", clientId = 3412, buy = 15 },
}

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
    npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
    player:sendTextMessage(MESSAGE_mission, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)