local config = {
	boss = {
		name = "Bakragore",
		position = Position(51, 44, 7),
	},
	timeAfterKill = 15,
	playerPositions = {
		{ pos = Position(51, 25, 7), teleport = Position(49, 44, 7) },
		{ pos = Position(50, 25, 7), teleport = Position(48, 44, 7) },
		{ pos = Position(49, 25, 7), teleport = Position(47, 44, 7) },
		{ pos = Position(48, 25, 7), teleport = Position(46, 44, 7) },
		{ pos = Position(47, 25, 7), teleport = Position(45, 44, 7) },
	},
	specPos = {
		from = Position(42, 38, 7),
		to = Position(68, 50, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:aid(999)
lever:register()
