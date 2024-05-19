local TeleportLvl1000Exit = MoveEvent()

function TeleportLvl1000Exit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getLevel() >= 1500 then
		local exitPosition = Position(281, 232, 5)
		player:teleportTo(exitPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

TeleportLvl1000Exit:type("stepin")
TeleportLvl1000Exit:aid(19998)
TeleportLvl1000Exit:register()
