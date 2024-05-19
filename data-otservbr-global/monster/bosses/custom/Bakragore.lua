local function createBossEvent(config)
    local function getSpectators(centerPosition, diffX, diffY)
        if not centerPosition then
            local diffX = math.ceil((config.bossArea.toPos.x - config.bossArea.fromPos.x) / 2)
            local diffY = math.ceil((config.bossArea.toPos.y - config.bossArea.fromPos.y) / 2)
            centerPosition = config.bossArea.fromPos + Position(diffX, diffY, 0)
        end
        return Game.getSpectators(centerPosition, false, false, diffX, diffX, diffY, diffY)
    end

    local function onUseLever(player, item, fromPos, target, toPos, isHotkey)
        local participants = {}
        for index, pos in pairs(config.participantsPos) do
            local tile = Tile(pos)
            if not tile then error("[Warning - Tile not found]") end
            local participant = tile:getTopVisibleCreature(player)
            if participant and participant:isPlayer() then
                if index == 1 and participant ~= player then
                    player:sendCancelMessage("Only the first participant can pull the lever.")
                    return true
                end

                if participant:getStorageValue(config.attempts.storage) >= os.time() then
                    player:sendCancelMessage(string.format("The player %s must wait 4 hours before being able to enter again.", participant:getName()))
                    return true
                elseif participant:getLevel() < config.attempts.level then
                    player:sendCancelMessage(string.format("The player %s is not level %d.", participant:getName(), config.attempts.level))
                    return true
                end
                participants[#participants + 1] = participant    
            end
        end

        local spectators = getSpectators()
        for _, spectator in pairs(spectators) do
            if spectator:isPlayer() then
                player:sendCancelMessage("At this time the room is occupied, please try again later.")
                return true
            end
        end

        for _, spectator in pairs(spectators) do spectator:remove() end
        local boss = Game.createMonster(config.bossName, config.bossPosition)
        if not boss then error(Game.getReturnMessage(RETURNVALUE_NOTENOUGHROOM)) end
        boss:registerEvent("ConfigureBossLeverAll")
        for index, participant in pairs(participants) do
            config.participantsPos[index]:sendMagicEffect(CONST_ME_POFF)
            participant:teleportTo(config.bossArea.entrancePos, false)
            config.bossArea.entrancePos:sendMagicEffect(CONST_ME_TELEPORT)
            participant:setStorageValue(config.attempts.storage, os.time() + config.attempts.seconds)
        end

        config.kickEventId = addEvent(function ()
            for _, spectator in pairs(getSpectators()) do
                if spectator:isPlayer() then
                    spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                    spectator:teleportTo(config.bossArea.exitPosition, false)
                    config.bossArea.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
                    spectator:sendTextMessage(MESSAGE_INFO_DESCR, "It's been a long time and you haven't managed to defeat The Boss.")
                else
                    spectator:remove()
                end
            end
        end, config.kickParticipantAfterSeconds * 1000)

        item:transform(item:getId() == config.leverIds[1] and config.leverIds[2] or config.leverIds[1])
        return true
    end

    local function onBossDeath()
        stopEvent(config.kickEventId)
        local teleport = Game.createItem(1949, 1, config.createTeleportPos)
        if teleport then
            teleport:setDestination(config.teleportToPosition)
            addEvent(function ()
                local tile = Tile(config.createTeleportPos)
                if tile then
                    local teleport = tile:getItemById(1949)
                    if teleport then
                        teleport:remove()
                        config.teleportToPosition:sendMagicEffect(CONST_ME_POFF)
                    end
                end

                for _, spectator in pairs(getSpectators()) do
                    if spectator:isPlayer() then
                        spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                        spectator:teleportTo(config.teleportToPosition, false)
                        config.teleportToPosition:sendMagicEffect(CONST_ME_TELEPORT)
                    end
                end
            end, config.teleportRemoveSeconds * 1000)
        end
        return true
    end

    local leverAction = Action()

    function leverAction.onUse(player, item, fromPos, target, toPos, isHotkey)
        return onUseLever(player, item, fromPos, target, toPos, isHotkey)
    end

    leverAction:aid(config.actionId)
    leverAction:register()

    local creatureEvent = CreatureEvent("ConfigureBossLeverAll")

    function creatureEvent.onDeath()
        return onBossDeath()
    end

    creatureEvent:register()
end


-- Exemplos de uso
local configs = {

 	 -- Chagorz terminado
    {
    actionId = 54509, 
    bossName = "Chagorz",
    bossPosition = Position(984, 54, 7), 
    bossArea = {
        fromPos = Position(978, 53, 7), 
        toPos = Position(991, 64, 7), 
        entrancePos = Position(984, 62, 7), 
        exitPosition = Position(952, 130, 7) 
    },
    participantsAllowAnyCount = true, 
    participantsPos = {
        Position(982, 84, 7),
        Position(983, 84, 7),
        Position(984, 84, 7),
        Position(985, 84, 7),
        Position(986, 84, 7)
    },
    attempts = {
        level = 350, 
        storage = 110051, 
        seconds = 14400 -- 14400 = 4 h
    },
    createTeleportPos = Position(0, 0, 0), 
    teleportToPosition = Position(0, 0, 0), 
    teleportRemoveSeconds = 120, 
    kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	 -- Vemiath terminado
    {
        actionId = 54508, 
        bossName = "Vemiath",
        bossPosition = Position(1014, 54, 7), 
        bossArea = {
            fromPos = Position(1008, 53, 7), 
            toPos = Position(1021, 64, 7), 
            entrancePos = Position(1014, 62, 7), 
            exitPosition = Position(1017, 84, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 84, 7),
            Position(1012, 84, 7),
            Position(1016, 84, 7),
            Position(1015, 84, 7),
            Position(1013, 84, 7)
        },
        attempts = {
            level = 300, 
            storage = 110052, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore terminado

    {
        actionId = 54507, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110050, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- murcion terminado
	
    {
        actionId = 54510, 
        bossName = "murcion",
        bossPosition = Position(959, 154, 7),
        bossArea = {
            fromPos = Position(953, 153, 7), 
            toPos = Position(966, 164, 7), 
            entrancePos = Position(959, 162, 7), 
            exitPosition = Position(961, 183, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(957, 184, 7),
            Position(958, 184, 7),
            Position(960, 184, 7),
            Position(959, 184, 7),
            Position(961, 184, 7)
        },
        attempts = {
            level = 300, 
            storage = 110053, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- ichgahal terminado
    {
        actionId = 54511, 
        bossName = "ichgahal",
        bossPosition = Position(984, 103, 7),
        bossArea = {
            fromPos = Position(978, 102, 7), 
            toPos = Position(991, 113, 7), 
            entrancePos = Position(984, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(982, 133, 7),
            Position(983, 133, 7),
            Position(984, 133, 7),
            Position(985, 133, 7),
            Position(986, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110054, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- the sandking terminada
    {
        actionId = 54512, 
        bossName = "the sandking",
        bossPosition = Position(925, 154, 7),
        bossArea = {
            fromPos = Position(920, 153, 7), 
            toPos = Position(933, 164, 7), 
            entrancePos = Position(926, 162, 7), 
            exitPosition = Position(928, 183, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(924, 184, 7),
            Position(925, 184, 7),
            Position(926, 184, 7),
            Position(927, 184, 7),
            Position(928, 184, 7)
        },
        attempts = {
            level = 300, 
            storage = 110055, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- timira the many-headed terminada 
    {
        actionId = 54513, 
        bossName = "timira the many-headed",
        bossPosition = Position(893, 154, 7),
        bossArea = {
            fromPos = Position(887, 153, 7), 
            toPos = Position(900, 164, 7), 
            entrancePos = Position(893, 162, 7), 
            exitPosition = Position(895, 183, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(891, 184, 7),
            Position(892, 184, 7),
            Position(893, 184, 7),
            Position(894, 184, 7),
            Position(895, 184, 7)
        },
        attempts = {
            level = 300, 
            storage = 110056, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Scarlett Etzel terminada
    {
        actionId = 54514, 
        bossName = "Scarlett Etzel",
        bossPosition = Position(892, 102, 7),
        bossArea = {
            fromPos = Position(886, 101, 7), 
            toPos = Position(899, 112, 7), 
            entrancePos = Position(892, 110, 7), 
            exitPosition = Position(894, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(890, 132, 7),
            Position(891, 132, 7),
            Position(892, 132, 7),
            Position(893, 132, 7),
            Position(894, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110057, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Urmahlullu The Immaculate terminado
    {
        actionId = 54515, 
        bossName = "Urmahlullu The Immaculate",
        bossPosition = Position(922, 102, 7),
        bossArea = {
            fromPos = Position(916, 101, 7), 
            toPos = Position(929, 112, 7), 
            entrancePos = Position(922, 110, 7), 
            exitPosition = Position(925, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(920, 132, 7),
            Position(921, 132, 7),
            Position(922, 132, 7),
            Position(923, 132, 7),
            Position(924, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110058, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Faceless Bane terminado
    {
        actionId = 54516, 
        bossName = "Faceless Bane",
        bossPosition = Position(952, 53, 7),
        bossArea = {
            fromPos = Position(946, 52, 7), 
            toPos = Position(959, 63, 7), 
            entrancePos = Position(952, 61, 7), 
            exitPosition = Position(954, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(950, 83, 7),
            Position(951, 83, 7),
            Position(952, 83, 7),
            Position(953, 83, 7),
            Position(954, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110059, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Pale Worm termina
    {
        actionId = 54517, 
        bossName = "The Pale Worm",
        bossPosition = Position(922, 53, 7),
        bossArea = {
            fromPos = Position(916, 52, 7), 
            toPos = Position(929, 63, 7), 
            entrancePos = Position(922, 61, 7), 
            exitPosition = Position(925, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(920, 83, 7),
            Position(921, 83, 7),
            Position(922, 83, 7),
            Position(923, 83, 7),
            Position(924, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110059, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Drume terminado
    {
        actionId = 54518, 
        bossName = "Drume",
        bossPosition = Position(892, 53, 7),
        bossArea = {
            fromPos = Position(886, 52, 7), 
            toPos = Position(899, 63, 7), 
            entrancePos = Position(892, 61, 7), 
            exitPosition = Position(895, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(890, 83, 7),
            Position(891, 83, 7),
            Position(892, 83, 7),
            Position(893, 83, 7),
            Position(894, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110060, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Ahau terminado
    {
        actionId = 54519, 
        bossName = "Ahau",
        bossPosition = Position(860, 53, 7),
        bossArea = {
            fromPos = Position(867, 63, 7), 
            toPos = Position(854, 52, 7), 
            entrancePos = Position(860, 61, 7), 
            exitPosition = Position(863, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(858, 83, 7),
            Position(859, 83, 7),
            Position(860, 83, 7),
            Position(861, 83, 7),
            Position(862, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110061, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Ratmiral Blackwhiskers terminado
    {
        actionId = 54520, 
        bossName = "Ratmiral Blackwhiskers",
        bossPosition = Position(830, 53, 7),
        bossArea = {
            fromPos = Position(824, 52, 7), 
            toPos = Position(837, 63, 7), 
            entrancePos = Position(830, 61, 7), 
            exitPosition = Position(833, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(828, 83, 7),
            Position(829, 83, 7),
            Position(830, 83, 7),
            Position(831, 83, 7),
            Position(832, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110062, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Grand Master Oberon terminado
    {
        actionId = 54521, 
        bossName = "Grand Master Oberon",
        bossPosition = Position(860, 102, 7),
        bossArea = {
            fromPos = Position(854, 101, 7), 
            toPos = Position(867, 112, 7), 
            entrancePos = Position(860, 110, 7), 
            exitPosition = Position(863, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(858, 132, 7),
            Position(859, 132, 7),
            Position(860, 132, 7),
            Position(861, 132, 7),
            Position(862, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110063, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Kroazur terminado
    {
        actionId = 54522, 
        bossName = "Kroazur",
        bossPosition = Position(830, 102, 7),
        bossArea = {
            fromPos = Position(824, 101, 7), 
            toPos = Position(837, 112, 7), 
            entrancePos = Position(830, 110, 7), 
            exitPosition = Position(833, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(828, 132, 7),
            Position(829, 132, 7),
            Position(830, 132, 7),
            Position(831, 132, 7),
            Position(832, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110064, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Lady Tenebris terminado 
    {
        actionId = 54523, 
        bossName = "Lady Tenebris",
        bossPosition = Position(800, 102, 7),
        bossArea = {
            fromPos = Position(794, 101, 7), 
            toPos = Position(807, 112, 7), 
            entrancePos = Position(800, 110, 7), 
            exitPosition = Position(803, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(798, 132, 7),
            Position(799, 132, 7),
            Position(800, 132, 7),
            Position(801, 132, 7),
            Position(802, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110065, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Time Guardian terminado
    {
        actionId = 54524, 
        bossName = "The Time Guardian",
        bossPosition = Position(800, 53, 7),
        bossArea = {
            fromPos = Position(794, 52, 7), 
            toPos = Position(807, 63, 7), 
            entrancePos = Position(800, 61, 7), 
            exitPosition = Position(803, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(798, 83, 7),
            Position(799, 83, 7),
            Position(800, 83, 7),
            Position(801, 83, 7),
            Position(802, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110066, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Plagueroot terminado
    {
        actionId = 54525, 
        bossName = "Plagueroot",
        bossPosition = Position(768, 53, 7),
        bossArea = {
            fromPos = Position(762, 52, 7), 
            toPos = Position(775, 63, 7), 
            entrancePos = Position(768, 61, 7), 
            exitPosition = Position(771, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(766, 83, 7),
            Position(767, 83, 7),
            Position(768, 83, 7),
            Position(769, 83, 7),
            Position(770, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110067, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Nightmare Beast terminado
    {
        actionId = 54526, 
        bossName = "The Nightmare Beast",
        bossPosition = Position(768, 102, 7),
        bossArea = {
            fromPos = Position(762, 101, 7), 
            toPos = Position(775, 112, 7), 
            entrancePos = Position(768, 110, 7), 
            exitPosition = Position(771, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(766, 132, 7),
            Position(767, 132, 7),
            Position(768, 132, 7),
            Position(769, 132, 7),
            Position(770, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110068, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- brokul terminado
    {
        actionId = 54527, 
        bossName = "brokul",
        bossPosition = Position(738, 102, 7),
        bossArea = {
            fromPos = Position(732, 101, 7), 
            toPos = Position(745, 112, 7), 
            entrancePos = Position(738, 110, 7), 
            exitPosition = Position(741, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(736, 132, 7),
            Position(737, 132, 7),
            Position(738, 132, 7),
            Position(739, 132, 7),
            Position(740, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110069, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Last Lore Keeper terminado
    {
        actionId = 54528, 
        bossName = "The Last Lore Keeper",
        bossPosition = Position(738, 53, 7),
        bossArea = {
            fromPos = Position(732, 52, 7), 
            toPos = Position(745, 63, 7), 
            entrancePos = Position(738, 61, 7), 
            exitPosition = Position(741, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(736, 83, 7),
            Position(737, 83, 7),
            Position(738, 83, 7),
            Position(739, 83, 7),
            Position(740, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110070, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Melting Frozen Horror terminado
    {
        actionId = 54529, 
        bossName = "Melting Frozen Horror",
        bossPosition = Position(738, 152, 7),
        bossArea = {
            fromPos = Position(732, 151, 7), 
            toPos = Position(745, 162, 7), 
            entrancePos = Position(738, 160, 7), 
            exitPosition = Position(741, 181, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(736, 182, 7),
            Position(737, 182, 7),
            Position(738, 182, 7),
            Position(739, 182, 7),
            Position(740, 182, 7)
        },
        attempts = {
            level = 300, 
            storage = 110071, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Lloyd terminado
    {
        actionId = 54530, 
        bossName = "Lloyd",
        bossPosition = Position(768, 152, 7),
        bossArea = {
            fromPos = Position(762, 151, 7), 
            toPos = Position(775, 162, 7), 
            entrancePos = Position(768, 160, 7), 
            exitPosition = Position(771, 181, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(766, 182, 7),
            Position(767, 182, 7),
            Position(768, 182, 7),
            Position(769, 182, 7),
            Position(770, 182, 7)
        },
        attempts = {
            level = 300, 
            storage = 110072, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Soul Of Dragonking Zyrtarch terminado
    {
        actionId = 54531, 
        bossName = "Soul Of Dragonking Zyrtarch",
        bossPosition = Position(768, 201, 7),
        bossArea = {
            fromPos = Position(762, 200, 7), 
            toPos = Position(775, 211, 7), 
            entrancePos = Position(768, 209, 7), 
            exitPosition = Position(771, 230, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(766, 231, 7),
            Position(767, 231, 7),
            Position(768, 231, 7),
            Position(769, 231, 7),
            Position(770, 231, 7)
        },
        attempts = {
            level = 300, 
            storage = 110073, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Gelidrazah The Frozen terminado
    {
        actionId = 54532, 
        bossName = "Gelidrazah The Frozen",
        bossPosition = Position(738, 201, 7),
        bossArea = {
            fromPos = Position(732, 200, 7), 
            toPos = Position(745, 211, 7), 
            entrancePos = Position(738, 209, 7), 
            exitPosition = Position(741, 230, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(736, 231, 7),
            Position(737, 231, 7),
            Position(738, 231, 7),
            Position(739, 231, 7),
            Position(740, 231, 7)
        },
        attempts = {
            level = 300, 
            storage = 110074, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Cave Spider terminado
    {
        actionId = 54533, 
        bossName = "Cave Spider",
        bossPosition = Position(708, 201, 7),
        bossArea = {
            fromPos = Position(702, 200, 7), 
            toPos = Position(715, 211, 7), 
            entrancePos = Position(708, 209, 7), 
            exitPosition = Position(711, 230, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(706, 231, 7),
            Position(707, 231, 7),
            Position(708, 231, 7),
            Position(709, 231, 7),
            Position(710, 231, 7)
        },
        attempts = {
            level = 300, 
            storage = 110075, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Doctor Marrow terminado
    {
        actionId = 54534, 
        bossName = "Doctor Marrow",
        bossPosition = Position(708, 152, 7),
        bossArea = {
            fromPos = Position(702, 151, 7), 
            toPos = Position(715, 162, 7), 
            entrancePos = Position(708, 160, 7), 
            exitPosition = Position(711, 181, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(706, 182, 7),
            Position(707, 182, 7),
            Position(708, 182, 7),
            Position(709, 182, 7),
            Position(710, 182, 7)
        },
        attempts = {
            level = 300, 
            storage = 110076, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Alptramun terminado
    {
        actionId = 54535, 
        bossName = "Alptramun",
        bossPosition = Position(708, 102, 7),
        bossArea = {
            fromPos = Position(702, 101, 7), 
            toPos = Position(715, 112, 7), 
            entrancePos = Position(708, 110, 7), 
            exitPosition = Position(711, 131, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(706, 132, 7),
            Position(707, 132, 7),
            Position(708, 132, 7),
            Position(709, 132, 7),
            Position(710, 132, 7)
        },
        attempts = {
            level = 300, 
            storage = 110077, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Leiden terminada
    {
        actionId = 54536, 
        bossName = "Leiden",
        bossPosition = Position(708, 53, 7),
        bossArea = {
            fromPos = Position(702, 52, 7), 
            toPos = Position(715, 63, 7), 
            entrancePos = Position(708, 61, 7), 
            exitPosition = Position(711, 82, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(706, 83, 7),
            Position(707, 83, 7),
            Position(708, 83, 7),
            Position(709, 83, 7),
            Position(710, 83, 7)
        },
        attempts = {
            level = 300, 
            storage = 110078, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Obujos terminado
    {
        actionId = 54537, 
        bossName = "Obujos",
        bossPosition = Position(772, 251, 7),
        bossArea = {
            fromPos = Position(777, 265, 7), 
            toPos = Position(765, 250, 7), 
            entrancePos = Position(771, 266, 7), 
            exitPosition = Position(770, 284, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(768, 282, 7),
            Position(769, 282, 7),
            Position(770, 282, 7),
            Position(771, 282, 7),
            Position(772, 282, 7)
        },
        attempts = {
            level = 300, 
            storage = 110079, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Jaul terminado
    {
        actionId = 54538, 
        bossName = "Jaul",
        bossPosition = Position(741, 250, 7),
        bossArea = {
            fromPos = Position(735, 250, 7), 
            toPos = Position(747, 264, 7), 
            entrancePos = Position(740, 266, 7), 
            exitPosition = Position(738, 284, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(741, 282, 7),
            Position(740, 282, 7),
            Position(739, 282, 7),
            Position(738, 282, 7),
            Position(737, 282, 7)
        },
        attempts = {
            level = 300, 
            storage = 110080, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Tanjis terminado
    {
        actionId = 54539, 
        bossName = "Tanjis",
        bossPosition = Position(711, 251, 7),
        bossArea = {
            fromPos = Position(704, 249, 7), 
            toPos = Position(716, 264, 7), 
            entrancePos = Position(709, 266, 7), 
            exitPosition = Position(707, 284, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(706, 282, 7),
            Position(707, 282, 7),
            Position(708, 282, 7),
            Position(709, 282, 7),
            Position(710, 282, 7)
        },
        attempts = {
            level = 300, 
            storage = 110081, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Prince Drazzak terminado
    {
        actionId = 54540, 
        bossName = "Prince Drazzak",
        bossPosition = Position(710, 304, 7),
        bossArea = {
            fromPos = Position(702, 304, 7), 
            toPos = Position(713, 319, 7), 
            entrancePos = Position(708, 319, 7), 
            exitPosition = Position(707, 337, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(705, 335, 7),
            Position(706, 335, 7),
            Position(707, 335, 7),
            Position(708, 335, 7),
            Position(709, 335, 7)
        },
        attempts = {
            level = 300, 
            storage = 110082, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Abyssador terminado
    {
        actionId = 54541, 
        bossName = "Abyssador",
        bossPosition = Position(741, 304, 7),
        bossArea = {
            fromPos = Position(731, 301, 7), 
            toPos = Position(746, 317, 7), 
            entrancePos = Position(739, 319, 7), 
            exitPosition = Position(737, 337, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(736, 335, 7),
            Position(737, 335, 7),
            Position(738, 335, 7),
            Position(739, 335, 7),
            Position(740, 335, 7)
        },
        attempts = {
            level = 300, 
            storage = 110083, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Mega Magmaoid terminado
    {
        actionId = 54542, 
        bossName = "The Mega Magmaoid",
        bossPosition = Position(1084, 262, 7),
        bossArea = {
            fromPos = Position(1075, 258, 7), 
            toPos = Position(1092, 280, 7), 
            entrancePos = Position(1089, 277, 7), 
            exitPosition = Position(1102, 291, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1102, 286, 7),
            Position(1102, 287, 7),
            Position(1102, 288, 7),
            Position(1102, 289, 7),
            Position(1102, 290, 7)
        },
        attempts = {
            level = 300, 
            storage = 110084, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Mawhawk terminado
    {
        actionId = 54543, 
        bossName = "Mawhawk",
        bossPosition = Position(638, 212, 7),
        bossArea = {
            fromPos = Position(631, 212, 7), 
            toPos = Position(644, 225, 7), 
            entrancePos = Position(637, 227, 7), 
            exitPosition = Position(635, 245, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(634, 243, 7),
            Position(635, 243, 7),
            Position(636, 243, 7),
            Position(637, 243, 7),
            Position(638, 243, 7)
        },
        attempts = {
            level = 300, 
            storage = 110085, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Brainstealer terminado
    {
        actionId = 54544, 
        bossName = "The Brainstealer",
        bossPosition = Position(608, 212, 7),
        bossArea = {
            fromPos = Position(600, 212, 7), 
            toPos = Position(613, 225, 7), 
            entrancePos = Position(606, 227, 7), 
            exitPosition = Position(604, 245, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(607, 243, 7),
            Position(606, 243, 7),
            Position(605, 243, 7),
            Position(604, 243, 7),
            Position(603, 243, 7)
        },
        attempts = {
            level = 300, 
            storage = 110086, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Glooth Fairy terminado
    {
        actionId = 54545, 
        bossName = "Glooth Fairy",
        bossPosition = Position(577, 212, 7),
        bossArea = {
            fromPos = Position(569, 212, 7), 
            toPos = Position(582, 225, 7), 
            entrancePos = Position(575, 226, 7), 
            exitPosition = Position(573, 245, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(572, 243, 7),
            Position(573, 243, 7),
            Position(574, 243, 7),
            Position(575, 243, 7),
            Position(576, 243, 7)
        },
        attempts = {
            level = 300, 
            storage = 110087, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Tentugly's Head
    {
        actionId = 54546, 
        bossName = "Tentugly's Head",
        bossPosition = Position(578, 158, 7),
        bossArea = {
            fromPos = Position(568, 156, 7), 
            toPos = Position(586, 177, 7), 
            entrancePos = Position(576, 174, 7), 
            exitPosition = Position(575, 192, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(573, 190, 7),
            Position(574, 190, 7),
            Position(575, 190, 7),
            Position(576, 190, 7),
            Position(577, 190, 7)
        },
        attempts = {
            level = 300, 
            storage = 110088, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- World Devourer
    {
        actionId = 54547, 
        bossName = "World Devourer",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110089, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Rupture
    {
        actionId = 54548, 
        bossName = "Rupture",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110090, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Outburst
    {
        actionId = 54549, 
        bossName = "Outburst",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110091, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Eradicator
    {
        actionId = 54550, 
        bossName = "Eradicator",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110092, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Anomaly
    {
        actionId = 54551, 
        bossName = "Anomaly",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110093, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Foreshock
    {
        actionId = 54552, 
        bossName = "Foreshock",
        bossPosition = Position(770, 250, 7),
        bossArea = {
            fromPos = Position(763, 248, 7), 
            toPos = Position(781, 269, 7), 
            entrancePos = Position(771, 265, 7), 
            exitPosition = Position(2499, 2500, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(768, 282, 7),
            Position(769, 282, 7),
            Position(770, 282, 7),
            Position(771, 282, 7),
            Position(772, 282, 7)
        },
        attempts = {
            level = 300, 
            storage = 110094, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Apocalypse
    {
        actionId = 54553, 
        bossName = "Apocalypse",
        bossPosition = Position(707, 303, 7),
        bossArea = {
            fromPos = Position(700, 301, 7), 
            toPos = Position(718, 322, 7), 
            entrancePos = Position(708, 317, 7), 
            exitPosition = Position(2499, 2500, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(705, 335, 7),
            Position(706, 335, 7),
            Position(707, 335, 7),
            Position(708, 335, 7),
            Position(709, 335, 7)
        },
        attempts = {
            level = 300, 
            storage = 110095, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Ferumbras Mortal Shell
    {
        actionId = 54554, 
        bossName = "Ferumbras Mortal Shell",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110096, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Tarbaz
    {
        actionId = 54555, 
        bossName = "Tarbaz",
        bossPosition = Position(739, 250, 7),
        bossArea = {
            fromPos = Position(732, 248, 7), 
            toPos = Position(750, 269, 7), 
            entrancePos = Position(740, 265, 7), 
            exitPosition = Position(2499, 2500, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(737, 282, 7),
            Position(738, 282, 7),
            Position(739, 282, 7),
            Position(740, 282, 7),
            Position(741, 282, 7)
        },
        attempts = {
            level = 300, 
            storage = 110097, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
		-- Desde Aqui Abajo
	-- Ragiaz
    {
        actionId = 54556, 
        bossName = "Ragiaz",
        bossPosition = Position(708, 250, 7),
        bossArea = {
            fromPos = Position(701, 248, 7), 
            toPos = Position(719, 269, 7), 
            entrancePos = Position(709, 265, 7), 
            exitPosition = Position(2499, 2500, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(706, 282, 7),
            Position(707, 282, 7),
            Position(708, 282, 7),
            Position(709, 282, 7),
            Position(710, 282, 7)
        },
        attempts = {
            level = 300, 
            storage = 110098, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Mazoran
    {
        actionId = 54557, 
        bossName = "Mazoran",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110099, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Razzagorn
    {
        actionId = 54558, 
        bossName = "Razzagorn",
        bossPosition = Position(769, 303, 7),
        bossArea = {
            fromPos = Position(762, 301, 7), 
            toPos = Position(780, 322, 7), 
            entrancePos = Position(770, 317, 7), 
            exitPosition = Position(2499, 2500, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(767, 335, 7),
            Position(768, 335, 7),
            Position(769, 335, 7),
            Position(770, 335, 7),
            Position(771, 335, 7)
        },
        attempts = {
            level = 300, 
            storage = 1100100, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Plagirath
    {
        actionId = 54559, 
        bossName = "Plagirath",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110101, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- zamulosh
    {
        actionId = 54560, 
        bossName = "zamulosh",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110102, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Shulgrax
    {
        actionId = 54561, 
        bossName = "Shulgrax",
        bossPosition = Position(738, 303, 7),
        bossArea = {
            fromPos = Position(731, 301, 7), 
            toPos = Position(749, 322, 7), 
            entrancePos = Position(739, 317, 7), 
            exitPosition = Position(2499, 2500, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(736, 335, 7),
            Position(737, 335, 7),
            Position(738, 335, 7),
            Position(739, 335, 7),
            Position(740, 335, 7)
        },
        attempts = {
            level = 300, 
            storage = 110103, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Goshnar's Spite
    {
        actionId = 54562, 
        bossName = "Goshnar's Spite",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110104, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Goshnar's Greed
    {
        actionId = 54563, 
        bossName = "Goshnar's Greed",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110105, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Goshnar's Hatred
    {
        actionId = 54564, 
        bossName = "Goshnar's Hatred",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110106, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Goshnar's Cruelty
    {
        actionId = 54565, 
        bossName = "Goshnar's Cruelty",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110107, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Goshnar's Malice
    {
        actionId = 54566, 
        bossName = "Goshnar's Malice",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110108, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Magma Bubble
    {
        actionId = 54567, 
        bossName = "Magma Bubble",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110109, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Goshnar's Megalomania
    {
        actionId = 54568, 
        bossName = "Goshnar's Megalomania",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110110, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Zulazza The Corruptor
    {
        actionId = 54569, 
        bossName = "Zulazza The Corruptor",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110111, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Morshabaal
    {
        actionId = 54570, 
        bossName = "Morshabaal",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110112, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Primal Menace
    {
        actionId = 54571, 
        bossName = "The Primal Menace",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110113, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- King Zelos
    {
        actionId = 54572, 
        bossName = "King Zelos",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110114, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Count Vlarkorth
    {
        actionId = 54573, 
        bossName = "Count Vlarkorth",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110115, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Earl Osam
    {
        actionId = 54574, 
        bossName = "Earl Osam",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110116, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Duke Krule
    {
        actionId = 54575, 
        bossName = "Duke Krule",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110117, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Lord Azaram
    {
        actionId = 54576, 
        bossName = "Lord Azaram",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110118, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Custodian
    {
        actionId = 54577, 
        bossName = "Custodian",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110119, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Gaffir
    {
        actionId = 54578, 
        bossName = "Gaffir",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110120, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Ferumbras
    {
        actionId = 54579, 
        bossName = "Ferumbras",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110121, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Morgaroth
    {
        actionId = 54580, 
        bossName = "Morgaroth",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110122, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Gaz'Haragoth
    {
        actionId = 54581, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110123, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Scourge Of Oblivion
    {
        actionId = 54582, 
        bossName = "The Scourge Of Oblivion",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110124, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Gorzindel
    {
        actionId = 54583, 
        bossName = "Gorzindel",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110125, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Lokathmor
    {
        actionId = 54584, 
        bossName = "Lokathmor",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110126, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- ghulosh
    {
        actionId = 54585, 
        bossName = "ghulosh",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110127, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Mazzinor
    {
        actionId = 54586, 
        bossName = "Mazzinor",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110128, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Mad Mage
    {
        actionId = 54587, 
        bossName = "Mad Mage",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110129, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Ghazbaran
    {
        actionId = 54588, 
        bossName = "Ghazbaran",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110130, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Guilt
    {
        actionId = 54589, 
        bossName = "Guilt",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110131, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54590, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110132, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Grand Chaplain Gaunder
    {
        actionId = 54591, 
        bossName = "Grand Chaplain Gaunder",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110133, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Grand Canon Dominus
    {
        actionId = 54592, 
        bossName = "Grand Canon Dominus",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110134, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Fear Feaster
    {
        actionId = 54593, 
        bossName = "The Fear Feaster",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110135, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Lily Of Night
    {
        actionId = 54594, 
        bossName = "The Lily Of Night",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110136, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The False God
    {
        actionId = 54595, 
        bossName = "The False God",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110137, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Monster
    {
        actionId = 54596, 
        bossName = "The Monster",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110138, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Abomination
    {
        actionId = 54597, 
        bossName = "The Abomination",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110139, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Armored Voidborn
    {
        actionId = 54598, 
        bossName = "The Armored Voidborn",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110140, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Blazing Rose
    {
        actionId = 54599, 
        bossName = "The Blazing Rose",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110141, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Dread Maiden
    {
        actionId = 54601, 
        bossName = "The Dread Maiden",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110142, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- The Diamond Blossom
    {
        actionId = 54602, 
        bossName = "The Diamond Blossom",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110143, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Guard Captain Quaid
    {
        actionId = 54603, 
        bossName = "Guard Captain Quaid",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110144, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Kalyassa
    {
        actionId = 54604, 
        bossName = "Kalyassa",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110145, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Grand Commander Soeren
    {
        actionId = 54605, 
        bossName = "Grand Commander Soeren",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110146, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Izcandar The Banished
    {
        actionId = 54606, 
        bossName = "Izcandar The Banished",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110147, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54607, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110148, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Rukor Zad
    {
        actionId = 54608, 
        bossName = "Rukor Zad",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110149, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Massacre
    {
        actionId = 54609, 
        bossName = "Massacre",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110150, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Malofur Mangrinder
    {
        actionId = 54610, 
        bossName = "Malofur Mangrinder",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110151, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Shadowpelt
    {
        actionId = 54611, 
        bossName = "Shadowpelt",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110152, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Mr. Punish
    {
        actionId = 54612, 
        bossName = "Mr. Punish",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110153, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Ravenous Hunger
    {
        actionId = 54613, 
        bossName = "Ravenous Hunger",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110154, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54614, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110155, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54615, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110156, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54616, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110157, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54617, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110158, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54618, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110159, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54619, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110160, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54620, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110161, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54621, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110162, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    },
	
	-- Bakragore
    {
        actionId = 54622, 
        bossName = "Bakragore",
        bossPosition = Position(1014, 103, 7),
        bossArea = {
            fromPos = Position(1008, 102, 7), 
            toPos = Position(1021, 113, 7), 
            entrancePos = Position(1014, 111, 7), 
            exitPosition = Position(1017, 133, 7) 
        },
        participantsAllowAnyCount = true, 
        participantsPos = {
            Position(1014, 133, 7),
            Position(1012, 133, 7),
            Position(1016, 133, 7),
            Position(1015, 133, 7),
            Position(1013, 133, 7)
        },
        attempts = {
            level = 300, 
            storage = 110163, 
            seconds = 14400 -- 14400 = 4 h
        },
        createTeleportPos = Position(0, 0, 0), 
        teleportToPosition = Position(0, 0, 0), 
        teleportRemoveSeconds = 120, 
        kickParticipantAfterSeconds = 120 * 10,
        leverIds = {2772, 2773} 
    }
}



for _, cfg in ipairs(configs) do
    createBossEvent(cfg)
end
