local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYAREA)
combat:setArea(createCombatArea(AREA_CIRCLE4X4))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
local weapon = creature:getSlotItem(CONST_SLOT_LEFT)
	-- CHECK SANGUINE DIST WPN
if weapon and weapon:getId() == 43877 or weapon and weapon:getId() == 43879 then
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 6) + (maglevel * 5) + 800
	local max = (level / 6) + (maglevel * 7) + 1000
	return -min, -max
	end
-- CHECK GRAND SANGUINE DIST WPN
elseif weapon and weapon:getId() == 43878 or weapon and weapon:getId() == 43880 or weapon and weapon:getId() == 44818 or weapon and weapon:getId() == 44817 then
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 6) + (maglevel * 6) + 1000
	local max = (level / 6) + (maglevel * 8) + 1250
	return -min, -max
	end
else 
 	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 6) + (maglevel * 4) + 500
	local max = (level / 6) + (maglevel * 6) + 600
	return -min, -max
	end
end
	combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
	-- CHECK SANGUINE GREAVES
local legs = creature:getSlotItem(CONST_SLOT_LEGS)
	if legs and legs:getId() == 43881 then
		creature:setSkillLevel(8, creature:getSkillLevel(8) + 800)
		combat:execute(creature, var)
		creature:setSkillLevel(8, creature:getSkillLevel(8) - 800)
		else
		combat:execute(creature, var)
		end
	return true
end

spell:group("attack")
spell:id(998)
spell:name("Shadow Mas San")
spell:words("exevo gran mas san")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_Shadow_Mas_San)
spell:level(500)
spell:mana(800)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(1 * 1000)
spell:needLearn(false)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()
