local mType = Game.createMonsterType("Broken Shaper")
local monster = {}

monster.description = "a broken shaper loot"
monster.experience = 30000
monster.outfit = {
	lookType = 932,
	lookHead = 94,
	lookBody = 76,
	lookLegs = 0,
	lookFeet = 82,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1321
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Astral Shaper Dungeon, Astral Shaper Ruins, Old Masonry",
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 25068
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "<grunt>", yell = false },
	{ text = "Raar!!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 35000, maxCount = 100 },
	{ name = "gold coin", chance = 50000, maxCount = 99 },
	{ name = "platinum coin", chance = 45000, maxCount = 69 },
	{ name = "crystal coin", chance = 20000, maxCount = 5 },
	{ name = "golden legs", chance = 1500 },
	{ name = "steel boots", chance = 3050 },
	{ name = "vile axe", chance = 880 },
	{ name = "butcher's axe", chance = 1250 },
	{ name = "gold ingot", chance = 3140 },
	{ name = "cyan crystal fragment", chance = 7430 },
	{ name = "red crystal fragment", chance = 7430 },
	{ name = "blue crystal shard", chance = 5710 },
	{ name = "green crystal fragment", chance = 3430 },
	{ name = "magma amulet", chance = 3430 },
	{ name = "mercenary sword", chance = 2860 },
	{ name = "war axe", chance = 2860 },
	{ name = "stone skin amulet", chance = 570 },
	{ id = 24390, chance = 4000 }, -- ancient coin
	{ id = 5912, chance = 1000, maxCount = 2 }, -- blue piece of cloth
	{ id = 5913, chance = 5000, maxCount = 2 }, -- brown piece of cloth
	{ id = 5914, chance = 2000, maxCount = 2 }, -- yellow piece of cloth
	{ id = 3079, chance = 230 }, -- boots of haste
	{ id = 3725, chance = 6500, maxCount = 5 }, -- brown mushroom
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 100, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 80, maxDamage = -350, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 50, maxDamage = -250, length = 5, spread = 0, effect = CONST_ME_SOUND_RED, target = false },
}

monster.defenses = {
	defense = 75,
	armor = 77,
	mitigation = 1.46,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 35, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
