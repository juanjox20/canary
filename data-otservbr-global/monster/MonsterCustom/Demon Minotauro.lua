local mType = Game.createMonsterType("Demon Minotauro")
local monster = {}

monster.description = "an demon minotauro"
monster.experience = 1500000
monster.outfit = {
	lookType = 1717,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1938
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 500,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Claustrophobic Inferno.",
}

monster.health = 750000
monster.maxHealth = 750000
monster.race = "blood"
monster.corpse = 33901
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 6,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.events = {
    "onDeath_randomItemDrops"
}

monster.summon = {
	maxSummons = 10,
	summons = {
		{ name = "Minotaur Bruiser", chance = 30, interval = 1500, count = 1 },
		{ name = "Minotaur Archer", chance = 30, interval = 1500, count = 4 },
		{ name = "Minotaur Guard", chance = 30, interval = 1500, count = 4 },		
		{ name = "Minotaur Mage", chance = 30, interval = 1500, count = 4 },		
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The smell of fear follows you.", yell = false },
	{ text = "Your soul will burn.", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 35000, maxCount = 100 },
	{ name = "gold coin", chance = 50000, maxCount = 99 },
	{ name = "platinum coin", chance = 45000, maxCount = 99 },
	{ name = "crystal coin", chance = 20000, maxCount = 30 },
	{ name = "golden legs", chance = 100 },
	{ name = "steel boots", chance = 3050 },
	{ name = "jewelled backpack", chance = 1192 },
	{ name = "demonic essence", chance = 8520 },
	{ name = "assassin star", chance = 2222, maxCount = 5 },
	{ name = "vile axe", chance = 880 },
	{ name = "butcher's axe", chance = 1250 },
	{ name = "great mana potion", chance = 14830, maxCount = 2 },
	{ name = "great health potion", chance = 10000, maxCount = 2 },
	{ name = "gold ingot", chance = 3140 },
	{ name = "ultimate health potion", chance = 22860, maxCount = 5 },
	{ name = "cyan crystal fragment", chance = 7430 },
	{ name = "red crystal fragment", chance = 7430 },
	{ name = "blue crystal shard", chance = 5710 },
	{ name = "small diamond", chance = 4570 },
	{ name = "blue gem", chance = 4570 },
	{ name = "green crystal fragment", chance = 3430 },
	{ name = "magma amulet", chance = 3430 },
	{ name = "mercenary sword", chance = 2860 },
	{ name = "onyx chip", chance = 2860 },
	{ name = "war axe", chance = 2860 },
	{ name = "giant sword", chance = 2860 },
	{ name = "magma boots", chance = 2290 },
	{ name = "stone skin amulet", chance = 570 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 100, maxDamage = -1500 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -1150, maxDamage = -1600, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -800, maxDamage = -1550, length = 8, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -1450, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "death chain", interval = 2000, chance = 20, minDamage = -1100, maxDamage = -1480, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.33,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
