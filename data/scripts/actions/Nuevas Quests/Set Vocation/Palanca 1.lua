local Palanca1 = Action()

function Palanca1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local teleportPosition = { x = 1271, y = 72, z = 5 }
	local stonePosition = { x = 1287, y = 108, z = 5 }

	if item.itemid == 2772 then
		local teleport = Game.createItem(1949, 1, teleportPosition)
		if teleport then
			teleport:setDestination({ x = 1293, y = 73, z = 5 })
			Position(teleportPosition):sendMagicEffect(CONST_ME_TELEPORT)
		end

		Tile(stonePosition):getItemById(8616):remove()
		item:transform(2773)
	elseif item.itemid == 2773 then
		Position(stonePosition):hasCreature({ x = 1287, y = 108, z = 5 })
		Tile(teleportPosition):getItemById(1949):remove()
		Position(teleportPosition):sendMagicEffect(CONST_ME_POFF)
		Game.createItem(8616, 1, stonePosition)
		item:transform(2772)
	end
	return true
end

Palanca1:uid(10000)
Palanca1:register()
