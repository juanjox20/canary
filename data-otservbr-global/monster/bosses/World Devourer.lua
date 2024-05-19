local config = {
	boss = {
		name = "World Devourer",
		position = Position(848, 247, 7),
	},
	requiredLevel = 350,
	requiredItemId = 3043, -- ID del ítem requerido para activar la Boss Lever
	playerPositions = {
		{ pos = Position(890, 252, 7), teleport = Position(846, 282, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(890, 253, 7), teleport = Position(846, 282, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(890, 254, 7), teleport = Position(846, 282, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(890, 255, 7), teleport = Position(848, 281, 7), effect = CONST_ME_TELEPORT },		
		{ pos = Position(890, 256, 7), teleport = Position(848, 281, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(891, 252, 7), teleport = Position(848, 281, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(891, 253, 7), teleport = Position(850, 282, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(891, 254, 7), teleport = Position(850, 282, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(891, 252, 7), teleport = Position(850, 282, 7), effect = CONST_ME_TELEPORT },				
		{ pos = Position(891, 256, 7), teleport = Position(848, 279, 7), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "demon", pos = Position(846, 282, 7) },
		{ name = "demon", pos = Position(846, 282, 7) },
		{ name = "demon", pos = Position(846, 282, 7) },
		{ name = "demon", pos = Position(848, 281, 7) },
		{ name = "demon", pos = Position(848, 281, 7) },
		{ name = "demon", pos = Position(848, 281, 7) },		
		{ name = "demon", pos = Position(850, 279, 7) },
		{ name = "demon", pos = Position(850, 279, 7) },
		{ name = "the demon", pos = Position(850, 279, 7) },
	},
	specPos = {
		from = Position(844, 244, 7), 
		to = Position(857, 259, 7), 		
	},
	exit = Position(895, 254, 7),
	
}

local lever = BossLever(config)
lever:aid(59500)
lever:register()
