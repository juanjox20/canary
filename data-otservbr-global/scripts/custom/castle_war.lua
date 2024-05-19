-- ARQUIVOS EXTERNOS: bonus exp 10% em core/events/scripts/player.lua na function Player:onGainExperience(target, exp, rawExp)

local CASTLE = {
	castleName = "War Castle",
	positionEnterCastle = Position(2528, 2646, 7),
	positionEnterCastleOwner = Position(2533, 2620, 4),
	canEnterWithMc = false,
	levelMin = 300,

	-- special config
	startAttackTimeInMinutes = 15,
	restartAttackTimeInMinutes = 10,
	kingPosition = Position(2534, 2624, 4),

	-- action ids
	actionIdTeleportEnter = 12000,
	actionIdTeleportExit = 12001,
	actionIdTileAcess = 12003,

	-- kv
	scopedKVCastle = "war-castle",
	storageKV = "storage",
	bonusTimeKV = "bonus-time",

	-- global storages
	openWarCastle = 12000,
	guildIdOwnerCastle = 120002,
}

-- INSERT INTO `guild_events` (`event_name`, `guild_id`) VALUES ('war_castle', '0');

local CACHE_PLAYERS = {}
local CACHE_BONUS = {}

local guildsDamagedKing = nil
local eventAction = nil
local kingWarUid = nil

local function castle_removePlayer(playerGuid)
	local player = Player(playerGuid)
	if player then
		player:removeCondition(CONDITION_INFIGHT)
		player:removeCondition(CONDITION_POISON)
		player:removeCondition(CONDITION_FIRE)
		player:removeCondition(CONDITION_ENERGY)
		player:addHealth(player:getMaxHealth())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(player:getTown():getTemplePosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

		player:kv():scoped(CASTLE.scopedKVCastle):remove(CASTLE.storageKV) -- treated storage kv
		player:unregisterEvent("warCastle-PrepareDeath") -- treated event

		if player:getSkull() == SKULL_WHITE or player:getSkull() == SKULL_YELLOW then
			player:setSkull(SKULL_NONE)
		end

		table.remove(CACHE_BONUS, player:getGuid())
	end

	CACHE_PLAYERS[playerGuid] = nil
end

local function castle_totalPlayers()
	local totalPlayers = 0
	for playerGuidInCastle, v in pairs(CACHE_PLAYERS) do
		totalPlayers = totalPlayers + 1
	end
	return totalPlayers
end

local function castle_removeAllPlayersNoOwner()
	local guildIdOwner = Game.getStorageValue(CASTLE.guildIdOwnerCastle)
	if guildIdOwner > 0 and castle_totalPlayers() > 0 then
		for playerGuidInCastle, guildId in pairs(CACHE_PLAYERS) do
			if guildId ~= guildIdOwner then
				castle_removePlayer(playerGuidInCastle)
			end
		end
	end
end

local function warcastle_addBonusTimeInAllPlayersOwner()
	local guildIdOwner = Game.getStorageValue(CASTLE.guildIdOwnerCastle)
	if guildIdOwner > 0 then
		for playerGuidIndex = 1, #CACHE_BONUS do
			local player = Player(CACHE_BONUS[playerGuidIndex])
			if player then
				local guild = player:getGuild()
				if guild then
					local guildId = guild:getId()
					if guildId then
						if guildId == guildIdOwner then
							player:kv():scoped(CASTLE.scopedKVCastle):set(CASTLE.bonusTimeKV, os.time() + 86400) -- 24 hrs
							player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
						else
							player:kv():scoped(CASTLE.scopedKVCastle):remove(CASTLE.bonusTimeKV) -- treated storage kv
						end
					end
				end
			end
		end
	end
end

local function warcastle_finishEvent(guildName)
	castle_removeAllPlayersNoOwner()
	warcastle_addBonusTimeInAllPlayersOwner()

	if kingWarUid then
		local kingWar = Monster(kingWarUid)
		if kingWar and kingWar:getName() == "War King" then
			kingWar:remove()
		end
	end

	Game.broadcastMessage("The guild " .. guildName .. " dominated the " .. CASTLE.castleName .. ".")
	-- A guild Y dominou o CASTELO.

	kingWarUid = nil
	eventAction = nil
	guildsDamagedKing = nil

	Game.setStorageValue(CASTLE.openWarCastle, -1)

	logger.info("[{}] O evento {} terminou, a guild {} dominou o castelo.", CASTLE.castleName:upper(), CASTLE.castleName, guildName)
end

local function getGuildOwnerName(guildId)
	local resultId = db.storeQuery("SELECT `name` FROM `guilds` WHERE `id` = " .. guildId)
	if not resultId then
		return false
	end

	local guildOwnerName = Result.getString(resultId, "name")
	Result.free(resultId)

	return guildOwnerName
end

function warcastle_startEvent() -- esta funcao e chamada em globalevents, por isso nao e local.
	local guildOwnerId = Game.getStorageValue(CASTLE.guildIdOwnerCastle)
	local guildName = nil
	if guildOwnerId > 0 then
		local guildOwnerName = getGuildOwnerName(guildOwnerId)
		if not guildOwnerName then
			logger.error("[{}] warcastle_startEvent - erro em 'not guildOwnerName' ao retornar o nome da guild dominante.", CASTLE.castleName:upper())
			guildOwnerId = 0
		else
			guildName = guildOwnerName
		end
	end

	local kingWar = Game.createMonster("War King", CASTLE.kingPosition, false, true)
	if kingWar then
		Game.broadcastMessage("Access to " .. CASTLE.castleName .. " is open and the teleport is in the main temple.")
		if guildOwnerId > 0 then
			Game.broadcastMessage("Bring your guild and try to beat the dominant guild " .. guildName .. " killing the War King in up to " .. CASTLE.startAttackTimeInMinutes .. " minutes to gain dominance of the castle.")
			-- Traga sua guilda e tente derrotar a guilda dominante X matando o Rei da Guerra em ate Y minutos para ganhar o dominio do castelo.
			eventAction = addEvent(warcastle_finishEvent, CASTLE.startAttackTimeInMinutes * 60000, guildName)
		else
			Game.broadcastMessage("Bring your guild and try to kill the War King to gain dominion over the castle.")
			-- Traga sua guilda e tente matar o Rei da Guerra para ganhar dominio sobre o castelo.
		end

		logger.info("[{}] O evento {} comecou.", CASTLE.castleName:upper(), CASTLE.castleName)

		Game.setStorageValue(CASTLE.openWarCastle, 1)
		kingWarUid = kingWar.uid
		guildsDamagedKing = {}
	else
		logger.error("[{}] warcastle_startEvent - erro em 'createMonster' ao criar o War King.", CASTLE.castleName:upper())
	end
end

-- ########################################################################################################################

local function castle_getGuildOwner()
	local resultId = db.storeQuery("SELECT `guild_id` FROM `guild_events` WHERE `event_name` = 'war_castle';")
	if not resultId then
		db.query("INSERT INTO `guild_events` (`event_name`, `guild_id`) VALUES ('war_castle', '0')")
		return 0
	end

	local guildId = Result.getNumber(resultId, "guild_id")
	Result.free(resultId)

	return guildId
end

-- GLOBALEVENTS ONSTARTUP
local globalevent = GlobalEvent("warCastleStartup")

function globalevent.onStartup()
	local guildIdOwner = castle_getGuildOwner()
	if guildIdOwner then
		Game.setStorageValue(CASTLE.guildIdOwnerCastle, guildIdOwner)
	else
		Game.setStorageValue(CASTLE.guildIdOwnerCastle, 0)
	end

	return true
end

globalevent:register()

-- ########################################################################################################################

-- MOVEMENTS ON-STEP-IN
local movements = MoveEvent()
movements:type("stepin")

function movements.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getGroup():getId() == GROUP_TYPE_GOD then
		player:teleportTo(CASTLE.positionEnterCastleOwner)
		return true
	end

	local guild = player:getGuild()
	if not guild then
		player:sendTextMessage(MESSAGE_STATUS, "You need to be in a guild to enter the " .. CASTLE.castleName .. ".")
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local guildId = guild:getId()
	if not guildId then
		player:sendTextMessage(MESSAGE_STATUS, "You need to be in a guild to enter the " .. CASTLE.castleName .. ".")
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if guildId == 0 then
		player:sendTextMessage(MESSAGE_STATUS, "You need to be in a guild to enter the " .. CASTLE.castleName .. ".")
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if player:getLevel() < CASTLE.levelMin then
		player:sendTextMessage(MESSAGE_STATUS, "You need level " .. CASTLE.levelMin .. " to enter the " .. CASTLE.castleName .. ".")
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local checkPlayer -- treated variable in loop
	for playerGuidInEvent, v in pairs(CACHE_PLAYERS) do
		checkPlayer = Player(playerGuidInEvent)
		if checkPlayer then
			if checkPlayer:getIp() == 0 then
				castle_removePlayer(playerGuidInEvent)
			end
		end
	end

	if not CASTLE.canEnterWithMc then
		for playerGuidInEvent, v in pairs(CACHE_PLAYERS) do
			checkPlayer = Player(playerGuidInEvent)
			if checkPlayer then
				if player:getIp() == checkPlayer:getIp() then
					player:sendCancelMessage("You already have another player inside the " .. CASTLE.castleName .. ".")
					-- Voce ja tem outro jogador dentro do evento.
					player:teleportTo(fromPosition)
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					return false
				end
			end
		end
	end

	local guildIdOwner = Game.getStorageValue(CASTLE.guildIdOwnerCastle)

	local gStorageCastleOpen = Game.getStorageValue(CASTLE.openWarCastle)
	if gStorageCastleOpen < 1 then
		if guildIdOwner < 1 then
			player:sendTextMessage(MESSAGE_STATUS, "Access to " .. CASTLE.castleName .. " is not yet allowed.")
			player:teleportTo(fromPosition)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		if guildIdOwner ~= guildId then
			player:sendTextMessage(MESSAGE_STATUS, "Your guild is not in the " .. CASTLE.castleName .. " domain.")
			player:teleportTo(fromPosition)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	local playerGuid = player:getGuid()
	if CACHE_PLAYERS[playerGuid] then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	player:kv():scoped(CASTLE.scopedKVCastle):set(CASTLE.storageKV, guildId)
	player:sendTextMessage(MESSAGE_STATUS, "You have entered " .. CASTLE.castleName .. ".")
	-- Voce entrou no CASTELO.
	player:addHealth(player:getMaxHealth())
	player:registerEvent("warCastle-PrepareDeath")

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	if guildIdOwner < 1 or guildIdOwner ~= guildId then
		player:teleportTo(CASTLE.positionEnterCastle)
	else
		player:teleportTo(CASTLE.positionEnterCastleOwner)
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	CACHE_PLAYERS[playerGuid] = guildId

	table.insert(CACHE_BONUS, playerGuid)

	return true
end

movements:aid(CASTLE.actionIdTeleportEnter)
movements:register()

-- ########################################################################################################################

-- MOVEMENT ONSTEPIN - EXIT
local castlewarExitTeleport = MoveEvent()
castlewarExitTeleport:type("stepin")

function castlewarExitTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:sendTextMessage(MESSAGE_STATUS, "You left the " .. CASTLE.castleName .. ".")
	castle_removePlayer(player:getGuid())

	return true
end

castlewarExitTeleport:aid(CASTLE.actionIdTeleportExit)
castlewarExitTeleport:register()

-- ########################################################################################################################

-- MOVEMENT ONSTEPIN - TILE ACESS GUILD
local castlewarTileAcess = MoveEvent()
castlewarTileAcess:type("stepin")

function castlewarTileAcess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getGroup():getId() == GROUP_TYPE_GOD then
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	end

	local gStorageCastle = Game.getStorageValue(CASTLE.guildIdOwnerCastle)
	if gStorageCastle < 1 then
		player:sendTextMessage(MESSAGE_STATUS, "Your guild is not in the castle domain.")
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local storageCastle = player:kv():scoped(CASTLE.scopedKVCastle):get(CASTLE.storageKV) or 0
	if storageCastle ~= gStorageCastle then
		player:sendTextMessage(MESSAGE_STATUS, "Your guild is not in the castle domain.")
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

	return true
end

castlewarTileAcess:aid(CASTLE.actionIdTileAcess)
castlewarTileAcess:register()

-- ########################################################################################################################

-- CREATURESCRIPT LOGIN
local castle_login = CreatureEvent("warCastle-Login")

function castle_login.onLogin(player)
	local storageCastle = player:kv():scoped(CASTLE.scopedKVCastle):get(CASTLE.storageKV) or 0
	if storageCastle > 0 then
		castle_removePlayer(player:getGuid())
	end
	return true
end

castle_login:register()

-- ########################################################################################################################

-- CREATURESCRIPT LOGOUT
local castle_logout = CreatureEvent("warCastle-Logout")

function castle_logout.onLogout(player)
	local storageCastle = player:kv():scoped(CASTLE.scopedKVCastle):get(CASTLE.storageKV) or 0
	if storageCastle > 0 then
		player:sendCancelMessage("You cannot log out inside the castle!")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	return true
end

castle_logout:register()

-- ########################################################################################################################

-- CREATURESCRIPT PREPARE-DEATH
local warcastle_preparedeath = CreatureEvent("warCastle-PrepareDeath")

function warcastle_preparedeath.onPrepareDeath(creature, killer)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local storageCastle = player:kv():scoped(CASTLE.scopedKVCastle):get(CASTLE.storageKV) or 0
	if storageCastle > 0 then
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:sendTextMessage(MESSAGE_STATUS, "You were killed in " .. CASTLE.castleName .. "!")
		castle_removePlayer(player:getGuid())

		if killer then
			killer:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)
		end

		return false
	end
	return true
end

warcastle_preparedeath:register()

-- ########################################################################################################################

-- TALKACTION SAY
local talkaction = TalkAction("/warcastle")

function talkaction.onSay(player, words, param)

	if Game.getStorageValue(CASTLE.openWarCastle) < 1 then
		warcastle_startEvent()
	else
		player:sendCancelMessage("The " .. CASTLE.castleName .. " event is now open.")
		-- O CASTLE ja esta aberto.
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end

	return true
end

talkaction:groupType("god")
talkaction:register()

-- ########################################################################################################################

local function warcastle_setGuildOwner(newGuildOwnerId)
	db.query("UPDATE `guild_events` SET `guild_id` = " .. newGuildOwnerId .. " WHERE `event_name` = 'war_castle';")
	return true
end

local function warcastle_guildOwnerDominated(guildNewOwnerId)
	local guild = Guild(guildNewOwnerId)
	if not guild then
		return logger.warn("[{}] function warcastle_guildOwnerDominated in 'not guild' (new guild id: {}).", CASTLE.castleName:upper(), guildNewOwnerId)
	end

	stopEvent(eventAction)
	warcastle_setGuildOwner(guildNewOwnerId)
	Game.setStorageValue(CASTLE.guildIdOwnerCastle, guildNewOwnerId)

	local timesDominated = Game.getStorageValue(CASTLE.openWarCastle) > 0 and Game.getStorageValue(CASTLE.openWarCastle) or 0
	if timesDominated >= 7 then
		eventAction = addEvent(warcastle_finishEvent, 1000, guild:getName())
		return
	end

	castle_removeAllPlayersNoOwner()

	local kingWar = Game.createMonster("War King", CASTLE.kingPosition, false, true)
	if kingWar then
		Game.broadcastMessage("The guild " .. guild:getName() .. " killed the War King and now needs to defend him for " .. CASTLE.restartAttackTimeInMinutes .. " minutes to gain dominance of the castle.")
		kingWarUid = kingWar.uid
	end

	eventAction = addEvent(warcastle_finishEvent, CASTLE.restartAttackTimeInMinutes * 60000, guild:getName())
	guildsDamagedKing = {}

	Game.setStorageValue(CASTLE.openWarCastle, timesDominated + 1)
end

-- CreatureScript onHealthChange
local warcastle_onHealthChange = CreatureEvent("castleWar-onHealthChange")

function warcastle_onHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not attacker or not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if not attacker:isPlayer() then
		if not attacker:getMaster() then
			return
		end
		attacker = attacker:getMaster()
	end

	local guildAttacker = attacker:getGuild()
	if not guildAttacker then
		return
	end

	local guildIdAttacker = guildAttacker:getId()
	if not guildIdAttacker then
		return
	end

	local guildIdOwner = Game.getStorageValue(CASTLE.guildIdOwnerCastle)
	if guildIdOwner > 0 and guildIdAttacker == guildIdOwner then
		return
	end

	local isGuild = false
	local damage = primaryDamage + secondaryDamage

	for _, value in pairs(guildsDamagedKing) do
		if value[1] == guildIdAttacker then
			value = {value[1], value[2] + damage}
			isGuild = true
			break
		end
	end

	if not isGuild then
		guildsDamagedKing[#guildsDamagedKing + 1] = {guildIdAttacker, damage}
	end

	if (creature:getHealth() - damage) <= 0 then
		table.sort(guildsDamagedKing, function(a, b) return a[2] > b[2] end)
		warcastle_guildOwnerDominated(guildsDamagedKing[1][1])
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

warcastle_onHealthChange:register()

-- ########################################################################################################################

-- EventCallback creatureOnTargetCombat
local creatureOnTargetCombat = EventCallback()

function creatureOnTargetCombat.creatureOnTargetCombat(creature, target)
	local enemy = target:getPlayer()
	if not creature or not enemy then
		return true
	end

	--[[
	if creature:isPlayer() then
		local selfStorageKV = player:kv():scoped(CASTLE.scopedKVCastle):get(CASTLE.storageKV) or 0
		if selfStorageKV > 0 then
			local enemyStorageKV = enemy:kv():scoped(CASTLE.scopedKVCastle):get(CASTLE.storageKV) or 0
			if selfStorageKV == enemyStorageKV then
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
			end
		end
	end
	]]--

	if creature:isMonster() then
		local enemyStorageKV = enemy:kv():scoped(CASTLE.scopedKVCastle):get(CASTLE.storageKV) or 0
		if enemyStorageKV > 0 and enemyStorageKV == Game.getStorageValue(CASTLE.guildIdOwnerCastle) then
			creature:searchTarget()
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
	end

	return true
end

creatureOnTargetCombat:register()

-- ########################################################################################################################

-- MONSTER 1
local mType = Game.createMonsterType("War King")
local monster = {}

monster.description = "a war king"
monster.experience = 0
monster.outfit = {
	lookType = 1224,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2000000
monster.maxHealth = 2000000
monster.race = "undead"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.events = {
	"castleWar-onHealthChange",
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -45 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -40, range = 5, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 10,
	armor = 10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
