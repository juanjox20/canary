local autoloot = TalkAction("!autoloot")

function autoloot.onSay(player, words, param, type)
	local oldProtocol = player:getClient().version < 1200
	if not oldProtocol then
		player:sendCancelMessage("Only old protocol allowed.")
		return
	end

	local split = param:splitTrimmed(",")
	local action = split[1]
	if not action then
		player:showTextDialog(34266, string.format("Examples of use:\n%s add,gold coin\n%s remove,gold coin\n%s clear\n%s show\n\n~Available slots~\nfreeAccount: %d\npremiumAccount: %d", words, words, words, words, AutoLootConfig.freeAccountLimit, AutoLootConfig.premiumAccountLimit), false)
		return false
	end

	if action == "clear" then
		setPlayerAutolootItems(player, {})
		player:sendCancelMessage("Autoloot list cleaned.")
	elseif action == "show" then
		local items = getPlayerAutolootItems(player)
		local description = { string.format('~ Your autoloot list, capacity: %d/%d ~\n', #items, getPlayerLimit(player)) }
		for i, itemId in pairs(items) do
			description[#description + 1] = string.format("%d) %s", i, ItemType(itemId):getName())
		end
		player:showTextDialog(34266, table.concat(description, '\n'), false)
	else
		if not table.contains({ "add", "remove" }, action) then
			player:showTextDialog(34266, string.format("Examples of use:\n%s add,gold coin\n%s remove,gold coin\n%s clear\n%s show\n\n~Available slots~\nfreeAccount: %d\npremiumAccount: %d", words, words, words, words, AutoLootConfig.freeAccountLimit, AutoLootConfig.premiumAccountLimit), false)
			return false
		end

		local id = tonumber(split[2])
		local itemType = ItemType(id)
		if not itemType then
			player:sendCancelMessage(string.format("The item %s does not exists!", id))
			return false
		end

		if action == "add" then
			local limits = getPlayerLimit(player)
			if #getPlayerAutolootItems(player) >= limits then
				player:sendCancelMessage(string.format("Your auto loot only allows you to add %d items.", limits))
				return false
			end

			if addPlayerAutolootItem(player, itemType:getId()) then
				player:sendCancelMessage(string.format("Perfect you have added to the list: %s", itemType:getName()))
			else
				player:sendCancelMessage(string.format("The item %s already exists!", itemType:getName()))
			end
		elseif action == "remove" then
			if removePlayerAutolootItem(player, itemType:getId()) then
				player:sendCancelMessage(string.format("Perfect you have removed to the list the article: %s", itemType:getName()))
			else
				player:sendCancelMessage(string.format("The item %s does not exists in the list.", itemType:getName()))
			end
		end
	end

	return true
end

autoloot:groupType("normal")
autoloot:separator(" ")
autoloot:register()
