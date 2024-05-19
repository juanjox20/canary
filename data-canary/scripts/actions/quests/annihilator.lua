local playerPosition = {
	{ x = 467, y = 177, z = 7 },
	{ x = 468, y = 177, z = 7 },
	{ x = 469, y = 177, z = 7 },
	{ x = 470, y = 177, z = 7 },
}
local newPosition = {
	{ x = 462, y = 162, z = 7 },
	{ x = 463, y = 162, z = 7 },
	{ x = 464, y = 162, z = 7 },
	{ x = 465, y = 162, z = 7 },
}

local annihilator = Action()

function annihilator.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		local players = {}
		for _, position in ipairs(playerPosition) do
			local topPlayer = Tile(position):getTopCreature()
			if not topPlayer or not topPlayer:isPlayer() or topPlayer:getLevel() < 100 or topPlayer:getStorageValue(Storage.Quest.ExampleQuest.Example) ~= -1 then
				player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
				return false
			end
			players[#players + 1] = topPlayer
		end

		for i, targetPlayer in ipairs(players) do
			Position(playerPosition[i]):sendMagicEffect(CONST_ME_POFF)
			targetPlayer:teleportTo(newPosition[i], false)
			targetPlayer:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)
		end
		item:transform(2773)
	elseif item.itemid == 2773 then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end
	return true
end

annihilator:uid(30015)
annihilator:register()
