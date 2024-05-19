local config = {
	boss = {
		name = "Goshnar's Spite",
		position = Position(374, 1576, 7),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(344, 1583, 7), teleport = Position(372, 1589, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(345, 1583, 7), teleport = Position(373, 1589, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(346, 1583, 7), teleport = Position(374, 1589, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(347, 1583, 7), teleport = Position(375, 1589, 7), effect = CONST_ME_TELEPORT },
		{ pos = Position(348, 1583, 7), teleport = Position(376, 1589, 7), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(363, 1574, 7),
		to = Position(386, 1594, 7),
	},
	exit = Position(2498, 2499, 7),
}

local lever = BossLever(config)
lever:position({ x = 343, y = 1583, z = 7 })
lever:register()
