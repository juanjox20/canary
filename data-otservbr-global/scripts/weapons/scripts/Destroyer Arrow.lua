local area = createCombatArea({
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 3, 1, 1 },
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 1, 1, 1 },
})

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DIAMONDARROW)
combat:setParameter(COMBAT_PARAM_IMPACTSOUND, SOUND_EFFECT_TYPE_DIAMOND_ARROW_EFFECT)
combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
function onGetFormulaValues(player, skill, attack, factor)
	local distanceSkill = player:getEffectiveSkillLevel(SKILL_DISTANCE)
	local min = (player:getLevel() / 8)
	local max = (0.3 * factor) * distanceSkill * 35 + (player:getLevel() / 8)
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
combat:setArea(area)

local DestroyerArrow= Weapon(WEAPON_AMMO)

function DestroyerArrow.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

DestroyerArrow:id(46098)
DestroyerArrow:level(25)
DestroyerArrow:attack(150)
DestroyerArrow:action("removecount")
DestroyerArrow:ammoType("arrow")
DestroyerArrow:shootType(CONST_ANI_DIAMONDARROW)
DestroyerArrow:maxHitChance(100)
DestroyerArrow:wieldUnproperly(true)
DestroyerArrow:register()
