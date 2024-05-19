local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYAREA)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
local weapon = creature:getSlotItem(CONST_SLOT_LEFT)
	-- CHECK SANGUINE DIST WPN
if weapon and weapon:getId() == 43877 or weapon and weapon:getId() == 43879 then
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 4) + (maglevel * 4) + 200
	local max = (level / 4) + (maglevel * 6) + 400
	return -min, -max
	end
-- CHECK GRAND SANGUINE DIST WPN
elseif weapon and weapon:getId() == 43878 or weapon and weapon:getId() == 43880 then
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 4) + (maglevel * 5) + 250
	local max = (level / 4) + (maglevel * 7) + 450
	return -min, -max
	end
else 
	function onGetFormulaValues(player, level, maglevel)
	local min = (level / 4) + (maglevel * 3) + 300
	local max = (level / 4) + (maglevel * 5) + 550
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
spell:id(124)
spell:name("Divine Caldera")
spell:words("exevo mas san")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_DIVINE_CALDERA)
spell:level(50)
spell:mana(180)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(3 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()
