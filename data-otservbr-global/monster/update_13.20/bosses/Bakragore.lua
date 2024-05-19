local mType = Game.createMonsterType("Bakragore")
local monster = {}

monster.description = "Bakragore"
monster.experience = 5500000
monster.outfit = {
	lookType = 1671,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1000000
monster.maxHealth = 1000000
monster.race = "undead"
monster.corpse = 44012
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
}

monster.bosstiary = {
	bossRaceId = 2367,
	bossRace = RARITY_NEMESIS
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
}

monster.voices = {
}

monster.loot = {
	{id = 3043, chance = 100000, maxCount = 30}, 
	{id = 7643, chance = 40000, maxCount = 20},
	{id = 238, chance = 40000, maxCount = 20}, 
	{id = 7642, chance = 40000, maxCount = 20}, 
	{id = 32769, chance = 30000, maxCount = 1},
	{id = 30061, chance = 3000, maxCount = 1},
	{id = 44008, chance = 10000, maxCount = 2},
	{id = 8053, chance = 18000},
	{id = 8023, chance = 18000},
	{id = 8101, chance = 13000},
	{id = 3041, chance = 9000},
	{id = 3063, chance = 9000},
	{id = 3554, chance = 9000},
	{id = 3309, chance = 9000},
	{id = 43855, chance = 4500, maxCount = 2},
	{id = 43854, chance = 29500, maxCount = 2},
	{id = 43853, chance = 44500, maxCount = 3},
	{id = 43901, chance = 4000},
	{id = 31992, chance = 1000},
	{id = 31994, chance = 1000},
	{id = 31996, chance = 1000},
	{id = 44048, chance = 3000}, -- Spirit Horseshoe ( Spirit of Purity Mount x4 )
	{id = 3278, chance = 50}, -- Magic Longsword Ultra Rare
	{id = 43963, chance = 1000}, -- figurine bakragore
	{id = 43968, chance = 1000}, -- bakragore's amalgamation
	{id = 9058, chance = 800}, -- gold ingot
	{id = 43860, chance = 600}, -- Bag you covet
	{id = 43864, chance = 600}, -- Sanguine Items ( not grand )
	{id = 43866, chance = 600},
	{id = 43868, chance = 600},
	{id = 43870, chance = 600},
	{id = 43872, chance = 600},
	{id = 43874, chance = 600},
	{id = 43876, chance = 600},
	{id = 43877, chance = 600},
	{id = 43879, chance = 600},
	{id = 43881, chance = 600},
	{id = 31966, chance = 10000, maxCount = 1}


}

monster.attacks = {
	{ name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3000 },
	{ name ="combat", interval = 3000, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -900, maxDamage = -1100, range = 7, radius = 7, shootEffect = CONST_ANI_ICE, effect = 243, target = true },
	{ name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -1000, length = 8, spread = 3, effect = 252, target = false },
	{ name ="combat", interval = 3000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -1000, maxDamage = -2000, length = 8, spread = 3, effect = 249, target = false },
	{ name ="combat", interval = 2000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -950, maxDamage = -2400, range = 7, radius = 3, shootEffect = 37, effect = 240, target = true },
	{ name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -2500, length = 8, spread = 3, effect = 244, target = false },
}

monster.defenses = {
	defense = 135,
	armor = 135,
	{ name ="combat", interval = 3000, chance = 15, type = COMBAT_HEALING, minDamage = 2500, maxDamage = 3500, effect = 236, target = false },
	{ name ="speed", interval = 4000, chance = 80, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 }
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE , percent = 15 },
	{ type = COMBAT_DEATHDAMAGE , percent = 15 }
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false }
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)