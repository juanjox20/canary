local config = {
	boss = {
		name = "Grand Master Oberon",
		position = Position(88, 53, 7),
	},
	playerPositions = {
		{ pos = Position(920, 83, 7), teleport = Position(919, 60, 7) },
		{ pos = Position(921, 83, 7), teleport = Position(920, 60, 7) },
		{ pos = Position(922, 83, 7), teleport = Position(921, 60, 7) },
		{ pos = Position(923, 83, 7), teleport = Position(922, 60, 7) },
		{ pos = Position(924, 83, 7), teleport = Position(923, 60, 7) },
	},
	specPos = {
		from = Position(914, 50, 7),
		to = Position(931, 65, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:aid(57605)
lever:register()
