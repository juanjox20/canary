local raidSchedule = {
	["31/10"] = {
		["16:00"] = { raidName = "Halloween Hare" },
	},
}

local spawnRaidsEvent = GlobalEvent("SpawnRaidsEvent")

function spawnRaidsEvent.onThink(interval, lastExecution, thinkInterval)
	local currentDayOfWeek, currentDate = os.date("%A"), getRealDate()
	local raidsToSpawn = {}

	if raidSchedule[currentDayOfWeek] then
		raidsToSpawn[#raidsToSpawn + 1] = raidSchedule[currentDayOfWeek]
	end

	if raidSchedule[currentDate] then
		raidsToSpawn[#raidsToSpawn + 1] = raidSchedule[currentDate]
	end

	if #raidsToSpawn > 0 then
		for i = 1, #raidsToSpawn do
			local currentRaidSchedule = raidsToSpawn[i][getRealTime()]
			if currentRaidSchedule and not currentRaidSchedule.alreadyExecuted then
				Game.startRaid(currentRaidSchedule.raidName)
				currentRaidSchedule.alreadyExecuted = true
			end
		end
	end
	return true
end

spawnRaidsEvent:interval(60000)
spawnRaidsEvent:register()
