local config = {
	boss = {
		name = "Grand Commander Soeren",
		position = Position(959, 155, 7),
	},
	playerPositions = {
		{ pos = Position(957, 184, 7), teleport = Position(957, 161, 7) },
		{ pos = Position(958, 184, 7), teleport = Position(958, 161, 7) },
		{ pos = Position(959, 184, 7), teleport = Position(959, 161, 7) },
		{ pos = Position(960, 184, 7), teleport = Position(960, 161, 7) },
		{ pos = Position(961, 184, 7), teleport = Position(961, 161, 7) },
	},
	specPos = {
		from = Position(951, 151, 7),
		to = Position(968, 166, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:aid(57608)
lever:register()
