local TeleportLvl500Exit = MoveEvent()

function TeleportLvl500Exit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getLevel() >= 800 then
		local exitPosition = Position(281, 230, 6)
		player:teleportTo(exitPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

TeleportLvl500Exit:type("stepin")
TeleportLvl500Exit:aid(19997)
TeleportLvl500Exit:register()
