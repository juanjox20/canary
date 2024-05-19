local config = {
	{ position = { x = 32954, y = 32398, z = 9 }, destination = { x = 34070, y = 31975, z = 14 } },
	{ position = { x = 34070, y = 31974, z = 14 }, destination = { x = 32955, y = 32398, z = 9 } },
}

local exit = MoveEvent()
function exit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

exit:type("stepin")
for value in pairs(config) do
	exit:position(config[value].position)
end
exit:register()
