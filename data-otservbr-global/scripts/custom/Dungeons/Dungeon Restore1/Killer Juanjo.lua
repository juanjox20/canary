local config = {
	boss = {
		name = "Killer Juanjo",
		position = Position(2351, 2596, 8),
	},
	
    attempts = {
        level = 250, 
        storage = 100000, 
        seconds = 3600 -- 1 h
    },
	
	timeToDefeat = 30 * 60,	
	requiredItemId = 3043, -- ID del ítem requerido para activar la Boss Lever
	playerPositions = {
		{ pos = Position(2483, 2502, 8), teleport = Position(2352, 2658, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(2483, 2503, 8), teleport = Position(2353, 2658, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(2483, 2504, 8), teleport = Position(2354, 2658, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(2484, 2502, 8), teleport = Position(2352, 2659, 9), effect = CONST_ME_TELEPORT },	
		{ pos = Position(2484, 2503, 8), teleport = Position(2353, 2659, 9), effect = CONST_ME_TELEPORT },
		{ pos = Position(2484, 2504, 8), teleport = Position(2354, 2659, 9), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "demon", pos = Position(2353, 2651, 10) },
		{ name = "demon", pos = Position(2354, 2651, 10) },
		{ name = "demon", pos = Position(2349, 2639, 10) },
		{ name = "demon", pos = Position(2350, 2639, 10) },
		{ name = "demon", pos = Position(2348, 2630, 10) },
		{ name = "demon", pos = Position(2349, 2631, 10) },		
		{ name = "demon", pos = Position(2348, 2620, 10) },
		{ name = "demon", pos = Position(2350, 2620, 10) },
		{ name = "the demon", pos = Position(2352, 2620, 10) },
	},
	specPos = {
		from = Position(2388, 2633, 10),
		to = Position(2371, 3660, 9),
	},
	exit = Position(2488, 2503, 8),
}

local lever = BossLever(config)
lever:aid(18181)
lever:register()
