local Palanca3 = Action()

function Palanca3.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local teleportPosition = { x = 1292, y = 114, z = 7 }
	local stonePosition = { x = 1293, y = 116, z = 7 }

	if item.itemid == 2772 then
		local teleport = Game.createItem(1949, 1, teleportPosition)
		if teleport then
			teleport:setDestination({ x = 1293, y = 118, z = 7 })
			Position(teleportPosition):sendMagicEffect(CONST_ME_TELEPORT)
		end

		Tile(stonePosition):getItemById(8616):remove()
		item:transform(2773)
	elseif item.itemid == 2773 then
		Position(stonePosition):hasCreature({ x = 1293, y = 116, z = 7 })
		Tile(teleportPosition):getItemById(1949):remove()
		Position(teleportPosition):sendMagicEffect(CONST_ME_POFF)
		Game.createItem(8616, 1, stonePosition)
		item:transform(2772)
	end
	return true
end

Palanca3:uid(11002)
Palanca3:register()
