local teleport = Position(3237, 3216, 15)
local teleportBack = Position(2508, 2504, 7)
local miningUm = Position(3239, 3216, 15)

local miningCar = Action()

function miningCar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getPosition() == miningUm then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("Voc� foi teletransportado para a �rea de mining.")
		player:teleportTo(teleport)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("Voc� foi teletransportado de volta.")
		player:teleportTo(teleportBack)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

miningCar:aid(5341)
miningCar:register()