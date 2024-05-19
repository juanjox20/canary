local config = {
	boss = {
		name = "Grand Chaplain Gaunder",
		position = Position(893, 155, 7),
	},
	playerPositions = {
		{ pos = Position(891, 184, 7), teleport = Position(891, 161, 7) },
		{ pos = Position(892, 184, 7), teleport = Position(892, 161, 7) },
		{ pos = Position(893, 184, 7), teleport = Position(893, 161, 7) },
		{ pos = Position(894, 184, 7), teleport = Position(894, 161, 7) },
		{ pos = Position(895, 184, 7), teleport = Position(895, 161, 7) },
	},
	specPos = {
		from = Position(885, 151, 7),
		to = Position(902, 166, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:aid(57606)
lever:register()

