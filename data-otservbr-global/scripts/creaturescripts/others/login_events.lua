local loginEvents = CreatureEvent("LoginEvents")
function loginEvents.onLogin(player)
	local events = {
		"AdvanceSave",
		"RookgaardAdvance",
		"FamiliarLogin",
		"FamiliarAdvance",
		--Quests

        -- Add KaboFlow
        "tpkillboss",
        "AnimationUp",
		"KarinLogin",

		--Cults Of Tibia Quest
		"HealthPillar",
		"YalahariHealth",
		"DarkEnergyLoad1",
		"DarkEnergyLoad2",
		"DarkEnergyLoad3",
		"DarkEnergyLoad4",
	}

	for i = 1, #events do
		player:registerEvent(events[i])
	end
	return true
end

loginEvents:register()
