local config = {
	boss = {
		name = "Apocalypse",
		position = Position(891, 53, 7),
	},
	playerPositions = {
		{ pos = Position(890, 83, 7), teleport = Position(890, 60, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(891, 83, 7), teleport = Position(891, 60, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(892, 83, 7), teleport = Position(892, 60, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(893, 83, 7), teleport = Position(893, 60, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(894, 83, 7), teleport = Position(894, 60, 7), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(884, 50, 7),
		to = Position(901, 65, 7),
	},
	monsters = {
		{ name = "Demon", pos = Position(890, 56, 7) },
		{ name = "Demon", pos = Position(890, 56, 7) },
		{ name = "Demon", pos = Position(894, 56, 7) },
		{ name = "Demon", pos = Position(894, 56, 7) },
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:aid(19325)
lever:register()
