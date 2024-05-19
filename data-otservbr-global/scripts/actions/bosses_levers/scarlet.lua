local config = {
	boss = {
		name = "Scarlett Etzel",
		position = Position(55, 330, 6),
	},

	timeToDefeat = 30 * 60,
	playerPositions = {
		{ pos = Position(54, 349, 6), teleport = Position(53, 343, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(54, 350, 6), teleport = Position(54, 343, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(54, 351, 6), teleport = Position(55, 343, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(53, 350, 6), teleport = Position(56, 343, 6), effect = CONST_ME_TELEPORT },
		{ pos = Position(55, 350, 6), teleport = Position(57, 343, 6), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(44, 326, 6),
		to = Position(65, 348, 6),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:uid(1028)
lever:register()
