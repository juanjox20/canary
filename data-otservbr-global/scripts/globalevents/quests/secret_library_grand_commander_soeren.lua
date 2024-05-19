local config = {
	monsterName = "Grand Commander Soeren",
	bossPosition = Position(2570, 2620, 7),
	centerPosition = Position(2574, 2623, 7),
	rangeX = 50,
	rangeY = 50,
}

local grandCommander = GlobalEvent("grand commander")
function grandCommander.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

grandCommander:interval(15 * 60 * 1000) -- 15 minutes
grandCommander:register()
