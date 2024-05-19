local config = {
	boss = {
		name = "Grand Canon Dominus",
		position = Position(931, 158, 7),
	},
	playerPositions = {
		{ pos = Position(924, 184, 7), teleport = Position(924, 161, 7) },
		{ pos = Position(925, 184, 7), teleport = Position(925, 161, 7) },
		{ pos = Position(926, 184, 7), teleport = Position(926, 161, 7) },
		{ pos = Position(927, 184, 7), teleport = Position(927, 161, 7) },
		{ pos = Position(928, 184, 7), teleport = Position(928, 161, 7) },
	},
	specPos = {
		from = Position(918, 151, 7),
		to = Position(935, 166, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:aid(57607)
lever:register()
