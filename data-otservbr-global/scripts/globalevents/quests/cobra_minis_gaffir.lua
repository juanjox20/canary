local config = {
	monsterName = "Gaffir",
	bossPosition = Position(2570, 2620, 7),
	centerPosition = Position(2574, 2623, 7),
	rangeX = 50,
	rangeY = 50,
}

local miniBoss = GlobalEvent("gaffir")
function miniBoss.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

miniBoss:interval(15 * 60 * 1000)
miniBoss:register()
