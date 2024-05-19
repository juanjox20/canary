local spawns = {
	[1] = { position = Position(2574, 2623, 7), monster = "Massacre" },
	[2] = { position = Position(32574, 2623, 7), monster = "Dracola" },
	[3] = { position = Position(2574, 2623, 7), monster = "The Imperor" },
	[4] = { position = Position(2574, 2623, 7), monster = "Mr. Punish" },
	[5] = { position = Position(2574, 2623, 7), monster = "Countess Sorrow" },
	[6] = { position = Position(2574, 2623, 7), monster = "The Plasmother" },
	[7] = { position = Position(2574, 2623, 7), monster = "The Handmaiden" },
}

local pitsOfInfernoBosses = GlobalEvent("PitsOfInfernoBosses")
function pitsOfInfernoBosses.onThink(interval, lastExecution)
	local spawn = spawns[math.random(#spawns)]
	local monster = Game.createMonster(spawn.monster, spawn.position, true, true)

	if not monster then
		logger.error("[PitsOfInfernoBosses] - Failed to spawn {}", rand.bossName)
		return true
	end
	return true
end

pitsOfInfernoBosses:interval(46800000)
pitsOfInfernoBosses:register()
