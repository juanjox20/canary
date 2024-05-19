local internalNpcName = "Sandra"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 115,
	lookBody = 95,
	lookLegs = 125,
	lookFeet = 57,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Great spirit potions as well as health and mana potions in different sizes!" },
	{ text = "If you need alchemical fluids like slime and blood, get them here." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if table.contains({ "vial", "ticket", "bonus", "deposit" }, message) then
		if player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt) < 1 then
			npcHandler:say("We have a special offer right now for depositing vials. Are you interested in hearing it?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt) >= 1 then
			npcHandler:say("Would you like to get a lottery ticket instead of the deposit for your vials?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "prize") then
		npcHandler:say("Are you here to claim a prize?", npc, creature)
		npcHandler:setTopic(playerId, 4)
	elseif string.match(message:lower(), "fafnar") then
		if player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 1 then
			npcHandler:say("Pssht, not that loud. So they have sent you to get... the stuff?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "your continued existence is payment enough") then
		if npcHandler:getTopic(playerId) == 6 then
			if player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 1 then
				npcHandler:say(
					"What?? How dare you?! I am a sorcerer of the most reknown academy on the face of this world. \
					Do you think some lousy pirates could scare me? Get lost! Now! \
					I will have no further dealings with the likes of you!",
					npc,
					creature
				)
				player:setStorageValue(Storage.TheShatteredIsles.RaysMission1, 2)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"The Edron academy has introduced a bonus system. Each time you deposit 100 vials without \
					claiming the money for it, you will receive a lottery ticket. ...",
				"Some of these lottery tickets will grant you a special potion belt accessory, \
					if you bring the ticket to me. ...",
				"If you join the bonus system now, I will ask you each time you are bringing back 100 or \
					more vials to me whether you claim your deposit or rather want a lottery ticket. ...",
				"Of course, you can leave or join the bonus system at any time by just asking me for the 'bonus'. ...",
				"Would you like to join the bonus system now?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say(
				"Great! I've signed you up for our bonus system. From now on, \
				you will have the chance to win the potion belt addon!",
				npc,
				creature
			)
			player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(283, 100) or player:removeItem(284, 100) or player:removeItem(285, 100) then
				npcHandler:say("Alright, thank you very much! Here is your lottery ticket, good luck. Would you like to deposit more vials that way?", npc, creature)
				player:addItem(5957, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say(
					"Sorry, but you don't have 100 empty flasks or vials of the SAME kind and thus don't qualify for the lottery. \
					Would you like to deposit the vials you have as usual and receive 5 gold per vial?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt) == 1 and player:removeItem(5958, 1) then
				npcHandler:say("Congratulations! Here, from now on you can wear our lovely potion belt as accessory.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt, 2)
				player:addOutfitAddon(138, 1)
				player:addOutfitAddon(133, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			else
				npcHandler:say("Sorry, but you don't have your lottery ticket with you.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 1 then
				npcHandler:say(
					"Finally. You have no idea how difficult it is to keep something secret here. \
					And you brought me all the crystal coins I demanded?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 6)
			end
		end
		return true
	end
end

keywordHandler:addKeyword({ "shop" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I sell potions and fluids. If you'd like to see my offers, ask me for a {trade}.",
})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, welcome to the fluid and potion {shop} of Edron.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|, please come back soon.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|, please come back soon.")
npcHandler:setMessage(
	MESSAGE_SENDTRADE,
	"Of course, just browse through my wares. By the way, if you'd like to join our bonus \
	system for depositing flasks and vial, you have to tell me about that {deposit}."
)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	    { itemName = "supreme health potion", clientId = 23375, buy = 625 },
	    { itemName = "ultimate mana potion", clientId = 23373, buy = 438 },
	    { itemName = "ultimate spirit potion", clientId = 23374, buy = 438 },
	    { itemName = "vial of blood", clientId = 2874, buy = 15, count = 5 },
	    { itemName = "vial of oil", clientId = 2874, buy = 20, count = 7 },
	    { itemName = "vial of slime", clientId = 2874, buy = 12, count = 6 },
	    { itemName = "vial of urine", clientId = 2874, buy = 10, count = 8 },
	    { itemName = "vial of water", clientId = 2874, buy = 8, count = 1 },
		{ itemName = "empty potion flask", clientId = 283, sell = 5 },
		{ itemName = "empty potion flask", clientId = 284, sell = 5 },
		{ itemName = "empty potion flask", clientId = 285, sell = 5 },
		{ itemName = "great health potion", clientId = 239, buy = 225 },
		{ itemName = "great mana potion", clientId = 238, buy = 144 },
		{ itemName = "great spirit potion", clientId = 7642, buy = 228 },
		{ itemName = "health potion", clientId = 266, buy = 50 },
		{ itemName = "mana potion", clientId = 268, buy = 56 },
		{ itemName = "strong health potion", clientId = 236, buy = 115 },
		{ itemName = "strong mana potion", clientId = 237, buy = 93 },
		{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
		{ itemName = "vial", clientId = 2874, sell = 5 },
		{ itemName = "avalanche rune", clientId = 3161, buy = 57 },
		{ itemName = "blank rune", clientId = 3147, buy = 10 },
		{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
		{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
		{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
		{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
		{ itemName = "energy field rune", clientId = 3164, buy = 38 },
		{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
		{ itemName = "explosion rune", clientId = 3200, buy = 31 },
		{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
		{ itemName = "fire field rune", clientId = 3188, buy = 28 },
		{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
		{ itemName = "great fireball rune", clientId = 3191, buy = 57 },
		{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
		{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
		{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
		{ itemName = "poison field rune", clientId = 3172, buy = 21 },
		{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
		{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
		{ itemName = "sudden death rune", clientId = 3155, buy = 135 },
		{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
		{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
		{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
		{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
		{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
		{ itemName = "terra rod", clientId = 3065, buy = 10000 },
		{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
		{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
		{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
		{ itemName = "wand of vortex", clientId = 3074, buy = 500 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
