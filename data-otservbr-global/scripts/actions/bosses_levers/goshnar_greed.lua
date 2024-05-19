local config = {
	boss = {
		name = "Goshnar's Greed",
		position = Position(375, 1611, 7),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(341, 1618, 7), teleport = Position(373, 1623, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(342, 1618, 7), teleport = Position(374, 1623, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(343, 1618, 7), teleport = Position(375, 1623, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(344, 1618, 7), teleport = Position(376, 1623, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(345, 1618, 7), teleport = Position(377, 1623, 7), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(365, 1610, 7),
		to = Position(387, 1628, 7),
	},
	exit = Position(349, 1618, 7),
}

local lever = BossLever(config)
lever:position({ x = 340, y = 1618, z = 7 })
lever:register()
