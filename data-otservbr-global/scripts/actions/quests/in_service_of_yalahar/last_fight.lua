local waves = {
	Position(376, 102, 7),
	Position(384, 102, 7),
	Position(379, 98, 7),
	Position(381, 98, 7),
	Position(379, 106, 7),
	Position(381, 106, 7),
}

local creatureNames = {
	[1] = "rift worm",
	[2] = "rift scythe",
	[3] = "rift brood",
	[4] = "war golem",
}

local effectPositions = {
	Position(376, 97, 7),
	Position(384, 107, 7),
}

local function doClearAreaAzerus()
	if Game.getStorageValue(GlobalStorage.InServiceOfYalahar.LastFight) == 1 then
		local spectators, spectator = Game.getSpectators(Position(380, 102, 7), false, false, 10, 10, 10, 10)
		for i = 1, #spectators do
			spectator = spectators[i]
			if spectator:isMonster() then
				spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
				spectator:remove()
			end
		end
		Game.setStorageValue(GlobalStorage.InServiceOfYalahar.LastFight, 0)
	end
	return true
end

local function doChangeAzerus()
	local spectators, spectator = Game.getSpectators(Position(380, 102, 7), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() and spectator:getName():lower() == "azerus" then
			spectator:say("No! I am losing my energy!", TALKTYPE_MONSTER_SAY)
			Game.createMonster("Azerus", spectator:getPosition(), false, true)
			spectator:remove()
			return true
		end
	end
	return false
end

local function summonMonster(name, position)
	Game.createMonster(name, position, false, true)
	--Game.createMonster(name, position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

local inServiceYalaharLastFight = Action()
function inServiceYalaharLastFight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.InServiceOfYalahar.LastFight) == 1 then
		player:say("You have to wait some time before this globe charges.", TALKTYPE_MONSTER_SAY)
		return true
	end

	local amountOfPlayers = 1
	local spectators = Game.getSpectators(Position(380, 102, 7), false, true, 10, 10, 10, 10)
	if #spectators < amountOfPlayers then
		for i = 1, #spectators do
			spectators[i]:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need atleast " .. amountOfPlayers .. " players inside the quest room.")
		end
		return true
	end

	Game.setStorageValue(GlobalStorage.InServiceOfYalahar.LastFight, 1)
	addEvent(Game.createMonster, 18 * 1000, "Azerus2", Position(380, 103, 7), false, true)
	--addEvent(Game.createMonster, 18 * 1000, "Azerus2", Position(32783, 31167, 10))

	local azeruswavemonster
	for i = 1, #creatureNames do
		azeruswavemonster = creatureNames[i]
		for k = 1, #waves do
			addEvent(summonMonster, (i - 1) * 60 * 1000, azeruswavemonster, waves[k])
		end
	end

	for i = 1, #effectPositions do
		effectPositions[i]:sendMagicEffect(CONST_ME_HOLYAREA)
	end

	addEvent(doChangeAzerus, 3 * 60 * 1000)
	addEvent(doClearAreaAzerus, 5 * 60 * 1000)
	return true
end

inServiceYalaharLastFight:uid(3086)
inServiceYalaharLastFight:register()
