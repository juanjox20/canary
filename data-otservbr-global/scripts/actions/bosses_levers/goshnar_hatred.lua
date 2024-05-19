local config = {
	boss = {
		name = "Goshnar's Hatred",
		position = Position(411, 1645, 7),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(441, 1649, 7), teleport = Position(410, 1654, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(442, 1649, 7), teleport = Position(411, 1654, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(443, 1649, 7), teleport = Position(412, 1654, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(444, 1649, 7), teleport = Position(413, 1654, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(445, 1649, 7), teleport = Position(414, 1654, 7), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(402, 1642, 7),
		to = Position(423, 1659, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:position({ x = 440, y = 1649, z = 7 })
lever:register()
