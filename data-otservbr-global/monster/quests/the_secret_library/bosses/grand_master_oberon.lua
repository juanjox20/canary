local mType = Game.createMonsterType("Grand Master Oberon")
local monster = {}

monster.description = "Grand Master Oberon"
monster.experience = 30000
monster.outfit = {
	lookType = 1072,
	lookHead = 21,
	lookBody = 96,
	lookLegs = 21,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1576,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "blood"
monster.corpse = 28625
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Falcon Paladin", chance = 30, interval = 1500, count = 1 },
		{ name = "Falcon Knight", chance = 30, interval = 1500, count = 1 },		
	},
}
	
monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3115, chance = 30000, maxCount = 1 }, -- bone
	{ name = "brass shield", chance = 30000, maxCount = 1 },
	{ name = "spatial warp almanac", chance = 25000, maxCount = 1 },
	{ name = "supreme health potion", chance = 53700, maxCount = 14 },
	{ name = "ultimate mana potion", chance = 48150, maxCount = 20 },
	{ name = "ultimate spirit potion", chance = 34000, maxCount = 6 },
	{ name = "silver token", chance = 6000, maxCount = 4 },
	{ name = "crystal coin", chance = 10000, maxCount = 10 },
	{ name = "platinum coin", chance = 87000, maxCount = 9 },
	{ name = "viking helmet", chance = 23000, maxCount = 1 },
	{ name = "falcon battleaxe", chance = 100, maxCount = 1 },
	{ name = "falcon longsword", chance = 100, maxCount = 1 },
	{ name = "falcon mace", chance = 100, maxCount = 1 },
	{ name = "grant of arms", chance = 500, maxCount = 1 },
	{ name = "falcon bow", chance = 100, maxCount = 1 },
	{ name = "falcon circlet", chance = 100, maxCount = 1 },
	{ name = "falcon coif", chance = 100, maxCount = 1 },
	{ name = "falcon rod", chance = 100, maxCount = 1 },
	{ name = "falcon wand", chance = 100, maxCount = 1 },
	{ name = "falcon shield", chance = 100, maxCount = 1 },
	{ name = "falcon greaves", chance = 100, maxCount = 1 },
	{ name = "falcon plate", chance = 100, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1400 },
	{ name = "combat", interval = 3000, chance = 40, type = COMBAT_HOLYDAMAGE, minDamage = -800, maxDamage = -1200, length = 8, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 4250, chance = 35, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -1000, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 5000, chance = 37, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
	{ name = "speed", interval = 1000, chance = 10, speedChange = 180, effect = CONST_ME_POFF, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
