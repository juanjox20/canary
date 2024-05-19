local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)

local weapon = creature:getSlotItem(CONST_SLOT_LEFT)
	-- CHECK SANGUINE COIL
if weapon and weapon:getId() == 43882 then
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 8) + (maglevel * 12) + 700
	local max = (level / 8) + (maglevel * 15) + 1300
	return -min, -max
	end
-- CHECK GRAND SANGUINE COIL
elseif weapon and weapon:getId() == 43883 then
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 8) + (maglevel * 14) + 750
	local max = (level / 8) + (maglevel * 16) + 1500
	return -min, -max
	end
else 
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 8) + (maglevel * 10) + 600
	local max = (level / 8) + (maglevel * 14) + 1200
	return -min, -max
	end
end
	combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
	-- CHECK SANGUINE BOOTS
	local boots = creature:getSlotItem(CONST_SLOT_FEET)
	if boots and boots:getId() == 43884 then
		creature:setSkillLevel(8, creature:getSkillLevel(8) + 800)
		combat:execute(creature, variant)
		creature:setSkillLevel(8, creature:getSkillLevel(8) - 800)
		else
			combat:execute(creature, variant)
		end
	return true
end

spell:group("attack", "focus")
spell:id(996)
spell:name("Max Flam")
spell:words("exevo gran max flam")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_HELL_SCORE)
spell:level(500)
spell:mana(1100)
spell:isSelfTarget(true)
spell:isPremium(true)
spell:cooldown(6 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
