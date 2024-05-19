local config = {
	boss = {
		name = "Magma Bubble",
		position = Position(1086, 266, 7),
	},
	playerPositions = {
		{ pos = Position(1102, 286, 7), teleport = Position(1084, 277, 7) },
		{ pos = Position(1102, 287, 7), teleport = Position(1085, 277, 7) },
		{ pos = Position(1102, 288, 7), teleport = Position(1086, 277, 7) },
		{ pos = Position(1102, 289, 7), teleport = Position(1087, 277, 7) },
		{ pos = Position(1102, 290, 7), teleport = Position(1088, 277, 7) },
	},	
	specPos = {
		from = Position(1075, 257, 7),
		to = Position(1096, 280, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:aid(57609)
lever:register()