local player1, player2, player3
local interval = 120 -- intervalo (en minutos)
local positions = { -- posiciones en el mapa
    top1 = Position(2501, 2498, 8),
    top2 = Position(2498, 2498, 8),
    top3 = Position(2504, 2498, 8)
}

local function getTopPlayers()
    local topPlayersQuery = db.storeQuery("SELECT `name`, `level`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons` FROM `players` WHERE `group_id` != 6 ORDER BY `level` DESC LIMIT 3")
    if topPlayersQuery then
        local index = 1
        repeat
            local playerData = {
                name = Result.getString(topPlayersQuery, "name"),
                level = Result.getNumber(topPlayersQuery, "level"),
                outfit = {
                    lookType = Result.getNumber(topPlayersQuery, "looktype"),
                    lookHead = Result.getNumber(topPlayersQuery, "lookhead"),
                    lookBody = Result.getNumber(topPlayersQuery, "lookbody"),
                    lookLegs = Result.getNumber(topPlayersQuery, "looklegs"),
                    lookFeet = Result.getNumber(topPlayersQuery, "lookfeet"),
                    lookAddons = Result.getNumber(topPlayersQuery, "lookaddons")
                }
            }
            if index == 1 then
                player1 = playerData
            elseif index == 2 then
                player2 = playerData
            elseif index == 3 then
                player3 = playerData
            end
            index = index + 1
        until not result.next(topPlayersQuery)
        result.free(topPlayersQuery)
        return true
    else
        print("[PODIUM] Error: No se pudieron recuperar los mejores jugadores.")
        return false
    end
end

local function spawnNpcs()
    if getTopPlayers() then
        local npc1 = Game.createNpc("Top one", positions.top1)
        if npc1 then
            local npcName1 = string.format("%s [%d]", player1.name, player1.level)
            npc1:setMasterPos(positions.top1)
            npc1:setName(npcName1)
            npc1:setOutfit(player1.outfit)
            Game.setStorageValue(GlobalStorage.Podium.One, npcName1)
        end

        local npc2 = Game.createNpc("Top two", positions.top2)
        if npc2 then
            local npcName2 = string.format("%s [%d]", player2.name, player2.level)
            npc2:setMasterPos(positions.top2)
            npc2:setName(npcName2)
            npc2:setOutfit(player2.outfit)
            Game.setStorageValue(GlobalStorage.Podium.Two, npcName2)
        end

        local npc3 = Game.createNpc("Top three", positions.top3)
        if npc3 then
            local npcName3 = string.format("%s [%d]", player3.name, player3.level)
            npc3:setMasterPos(positions.top3)
            npc3:setName(npcName3)
            npc3:setOutfit(player3.outfit)
            Game.setStorageValue(GlobalStorage.Podium.Three, npcName3)
        end
    end
end

local function updatePodium()
    if getTopPlayers() then
        local podiumOneStorage = Game.getStorageValue(GlobalStorage.Podium.One)
        local podiumTwoStorage = Game.getStorageValue(GlobalStorage.Podium.Two)
        local podiumThreeStorage = Game.getStorageValue(GlobalStorage.Podium.Three)

        if type(podiumOneStorage) == "string" then
            local npc1Name = string.format("%s [%d]", player1.name, player1.level)
            local npc1 = Npc(podiumOneStorage)
            npc1:setName(npc1Name)
            npc1:setOutfit(player1.outfit)
            Game.setStorageValue(GlobalStorage.Podium.One, npc1Name)
        end

        if type(podiumTwoStorage) == "string" then
            local npc2Name = string.format("%s [%d]", player2.name, player2.level)
            local npc2 = Npc(podiumTwoStorage)
            npc2:setName(npc2Name)
            npc2:setOutfit(player2.outfit)
            Game.setStorageValue(GlobalStorage.Podium.Two, npc2Name)
        end

        if type(podiumThreeStorage) == "string" then
            local npc3Name = string.format("%s [%d]", player3.name, player3.level)
            local npc3 = Npc(podiumThreeStorage)
            npc3:setName(npc3Name)
            npc3:setOutfit(player3.outfit)
            Game.setStorageValue(GlobalStorage.Podium.Three, npc3Name)
        end
    end
end

local initializePodium = GlobalEvent("initializePodium")
function initializePodium.onStartup()
    spawnNpcs()
end
initializePodium:register()

local podium = GlobalEvent("podium")
function podium.onThink(interval)
    updatePodium()
    return true
end
podium:interval(interval * 60000)
podium:register()
