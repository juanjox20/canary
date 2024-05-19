local TeleportLvl300Exit = MoveEvent()

function TeleportLvl300Exit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getLevel() >= 8 then
		local exitPosition = Position(31625, 32025, 7)
		player:teleportTo(exitPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

TeleportLvl300Exit:type("stepin")
TeleportLvl300Exit:aid(19999)
TeleportLvl300Exit:register()
