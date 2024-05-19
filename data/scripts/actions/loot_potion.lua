local loot = Action()

function loot.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lootPot = lootPotion[item:getId()]
	if not lootPot then
		return false
	end

	if player:getStorageValue(STORAGEVALUE_LOOT_ID) >= 1 or player:getStorageValue(STORAGEVALUE_LOOT_TEMPO) > os.time() then
		player:sendCancelMessage("Voc� j� possui algum b�nus de loot.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	if not item:remove() then
		player:sendCancelMessage("Voc� n�o possui nenhum tipo de po��o de loot b�nus.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end


	player:sendCancelMessage("Voc� ativou um b�nus de loot de +".. lootPot.exp .."% por ".. lootPot.tempo .." hora".. (lootPot.tempo > 1 and "s" or "") ..".")
	player:getPosition():sendMagicEffect(31)
	player:setStorageValue(STORAGEVALUE_LOOT_ID, item:getId())
	player:setStorageValue(STORAGEVALUE_LOOT_TEMPO, os.time() + lootPot.tempo * 60 * 60)
	local idPlayer = player:getId()
	addEvent(function()
		local player = Player(idPlayer)
		if player then
			player:setStorageValue(STORAGEVALUE_LOOT_ID, -1)
			player:setStorageValue(STORAGEVALUE_LOOT_TEMPO, -1)
			player:sendCancelMessage("O seu tempo de loot b�nus pela po��o acabou!")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	end, lootPot.tempo * 60 * 60 * 1000)
	return true
end

loot:id(9170, 9149, 9112)
loot:register()
