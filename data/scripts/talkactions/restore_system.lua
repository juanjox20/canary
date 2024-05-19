--[[

O sistema de restore permite que os jogadores fortalecam seus personagens.

A cada restore o personagem recebe +1% do total de HP/MP ao resetar, e +1% de Exp bonus e Damage bonus.

Restores - Level Required - Cost -  Exp Bonus - Damage Bonus
1 - 10	     500	            15kk	2%-20%	         2%-20%
11 - 20	     650	            30kk	21%-40%	         21%-60%
31 - 40	     800	            50kk	41%-60%	         61%-80%
41 - 60	     1000	            80kk	61%-80%	         81%-90%
71 - 80      1200	            100kk	81%-90%          91%-100%
81 - 90	     1500	            150kk	91%-100%	     101%-110%
91 - 100	 1800	            200kk	101%-110%	     111%-120%
101 - 110	 2000	            250kk	111%-120%	     121%-140%
110 - 120	 2500	            300kk	121%-160%	     161%-160%
121 - 150    3000	            500kk	181%-200%        161%-200%

Por exemplo, se um personagem possuir 30 restores, ele ganhará +30% de HP/MP do total que ele tiver ao resetar, e recebera bonus de +30% Exp e +30% Damage.

Quanto mais restores o personagem possuir, maior e o atributo e bonus que ele recebe.

Para usar o sistema, basta ter o level, valor indicado e utilizar o comando "!restore" em uma area de protection zone.
Informacoes sobre seu atual nivel utilize !restore info.

Vale lembrar que ao usar o sistema de restore os skills do seu personagem permanecem e todos os seus itens sao enviados ao depot.

]]--

--[[
	functions:
	player:restorePlayerReset(restores, playerGuid)
	player:setPlayerRestores(restores, resetPlayer, playerGuid)
	player:getPlayerRestores()
	player:addPlayerRestore(playerGuid)
	player:getPlayerNextRestoreInfo()

	query:
	ALTER TABLE `players` ADD `restores` tinyint(4) UNSIGNED NOT NULL DEFAULT '0' AFTER `level`;

	-- adicionar ao look os restores do player (data\scripts\eventcallbacks\player\on_look.lua)
	-- adicionar bonus exp do player (data\events\scripts\player.lua)

]]--

local config = {
	maxRestores = 150,
	resetLevel = 25,
	restores = {
		[{1, 10}] = { requeredLevel = 500, cost = 15000000, bonus = 10 },
		[{11, 20}] = { requeredLevel = 650, cost = 30000000, bonus = 15 },
		[{31, 40}] = { requeredLevel = 800, cost = 50000000, bonus = 30 },
		[{51, 60}] = { requeredLevel = 1000, cost = 80000000, bonus = 50 },
		[{61, 70}] = { requeredLevel = 1200, cost = 100000000, bonus = 60 },
		[{71, 80}] = { requeredLevel = 1500, cost = 125000000, bonus = 70 },
		[{91, 100}] = { requeredLevel = 1800, cost = 150000000, bonus = 90 },
		[{101, 120}] = { requeredLevel = 2000, cost = 180000000, bonus = 100 },
		[{121, 150}] = { requeredLevel = 2500, cost = 200000000, bonus = 130 },		
	},
	vocationReset = {
		[{1, 2, 5, 6}] = {health = 385, mana = 585, experience = 98800, cap = 899},
		[{3, 7}] = {health = 455, mana = 400, experience = 98800, cap = 1010},
		[{4, 8}] = {health = 495, mana = 288, experience = 98800, cap = 1070},
	},
	storageExhaustion = "restore-system",
	storageRestores = "restore-system-count",
	storageRestoresBonus = "restore-system-bonus",
}

function Player.getTotalMoney(self)
	return self:getMoney() + self:getBankBalance()
end

-- player:restorePlayerReset(restores, playerGuid)
function Player.restorePlayerReset(self, restores, playerGuid)
	if restores > config.maxRestores then
		restores = config.maxRestores
	end

	for vocationTable, value in pairs(config.vocationReset) do
		if table.contains(vocationTable, self:getVocation():getId()) then
			-- enviar items do player para o depot?
			local addHealth = math.ceil((self:getMaxHealth() / 100) * restores) + value.health
			local addMana = math.ceil((self:getMaxMana() / 100) * restores) + value.mana
			local playerGuid = self:getGuid()
			self:remove()
			db.query("UPDATE `players` SET `level` = " .. config.resetLevel .. ", `health` = " .. addHealth .. ", `healthmax` = " .. addHealth .. ", `experience` = " .. value.experience .. ", `mana` = " .. addMana .. ", `manamax` = " .. addMana .. ", `cap` = " .. value.cap .. " WHERE `id` = " .. playerGuid)
			return true
		end
	end
	return false
end

-- player:setPlayerRestores(restores, resetPlayer, playerGuid)
function Player.setPlayerRestores(self, restores, resetPlayer, playerGuid)
	if not restores then
		logger.error("[restore_system] function setPlayerRestores error in 'not restores'.")
		return false
	end

	if restores > config.maxRestores then
		restores = config.maxRestores
	end

	local bonus = 0
	for restoresConfig, value in pairs(config.restores) do
		if restores >= restoresConfig[1] and restores <= restoresConfig[2] then
			bonus = value.bonus
			break
		end
	end

	self:kv():set(config.storageRestores, restores)
	self:kv():set(config.storageRestoresBonus, bonus)

	db.query("UPDATE `players` SET `restores` = " .. restores .. " WHERE `id` = " .. playerGuid)
	self:save()

	if resetPlayer then
		if not self:restorePlayerReset(restores, playerGuid) then
			logger.error("[restore_system] function setPlayerRestores error in 'not self:restorePlayerReset()'.")
			return false
		end
	end

	return true
end

-- player:getPlayerRestores()
function Player.getPlayerRestores(self)
	local query_players = db.storeQuery("SELECT `restores` FROM `players` WHERE `id` = " .. self:getGuid() .. ";")
	if not query_players then
		return 0
	end

	local restores = Result.getNumber(query_players, "restores")
	Result.free(query_players)

	return restores
end

-- player:addPlayerRestore(playerGuid)
function Player.addPlayerRestore(self, playerGuid)
	local playerRestores = self:getPlayerRestores()
	if playerRestores >= config.maxRestores then
		return false
	end
	return self:setPlayerRestores(playerRestores + 1, true, playerGuid)
end

-- player:getPlayerNextRestoreInfo()
function Player.getPlayerNextRestoreInfo(self)
	local playerNextRestore = self:getPlayerRestores() + 1

	if playerNextRestore <= 0 then
		logger.error("[restore_system] function getPlayerNextRestoreInfo error in 'playerNextRestore <= 0'.")
		return false
	end

	if playerNextRestore > config.maxRestores then
		logger.error("[restore_system] function getPlayerNextRestoreInfo error in 'playerNextRestore > config.maxRestores'.")
		return false
	end

	local requeredLevel = 0
	local cost = 0
	local bonus = 0

	for restoresConfig, value in pairs(config.restores) do
		if playerNextRestore >= restoresConfig[1] and playerNextRestore <= restoresConfig[2] then
			requeredLevel = value.requeredLevel
			cost = value.cost
			bonus = value.bonus
			break
		end
	end

	return {requeredLevel = requeredLevel, cost = cost, bonus = bonus}
end

-- talkaction !restore e !restore info
local talkaction = TalkAction("!restore")

function talkaction.onSay(player, words, param, type)

	local exaust = player:getExhaustion(config.storageExhaustion)
	if exaust > 0 then
		player:sendCancelMessage("You must wait " .. exaust .. " " .. (exaust > 1 and "seconds" or "second") .. " to use the command again.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local position = player:getPosition()
	local tile = Tile(position)
	if not tile then
		logger.error("[restore_system] function onSay error in 'not tile'.")
		player:sendCancelMessage("You cannot use this command in this position.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not tile:hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendCancelMessage("You cannot use this command outside the protection zone.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	player:setExhaustion(config.storageExhaustion, 30)

	local restores = player:getPlayerRestores() or 0
	if restores > config.maxRestores then
		restores = config.maxRestores
	end

	if string.lower(param) == "info" then

		local text = ""
		if restores == 0 then
			text = "You don't have any restore."
		else
			local bonusDamage = player:kv():get(config.storageRestoresBonus) or 0
			text = "You have " .. restores .. " and received +" .. restores .. "% of total HP/MP when reset, and receive bonus of +" .. bonusDamage .. "% of EXP and +" .. bonusDamage .. "% damage."
		end

		if restores == config.maxRestores then
			text = text .. "\n\nYou have reached the maximum level of restores."
		else
			local infoNextRestore = player:getPlayerNextRestoreInfo()
			if infoNextRestore then
				local playerNextRestore = restores + 1
				text = text .. "\n\nTo advance to the next restore you need to be at the minimum level of " .. infoNextRestore.requeredLevel .. " and pay the amount of " .. infoNextRestore.cost .. " gold coins, "
				.. "and thus you will receive +" .. playerNextRestore .. "% of total HP/MP you have when resetting, +" .. infoNextRestore.bonus .. "% EXP bonus and +" .. infoNextRestore.bonus .. "% bonus of Damage."
			end
		end

		player:popupFYI(text)

		return false
	end

	if restores == config.maxRestores then
		player:sendCancelMessage("You already have the maximum limit of " .. config.maxRestores .. " restores.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local infoNextRestore = player:getPlayerNextRestoreInfo()

	if player:getLevel() < infoNextRestore.requeredLevel then
		player:sendCancelMessage("You need level " .. infoNextRestore.requeredLevel .. " or higher for the next restore.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local totalMoney = player:getTotalMoney()
	if totalMoney < infoNextRestore.cost then
		player:sendCancelMessage("You need " .. infoNextRestore.cost .. " gold coins for the next restore.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not player:removeMoneyBank(infoNextRestore.cost) then
		logger.error("[restore_system] function onSay error in 'not player:removeMoneyBank'.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not player:addPlayerRestore(player:getGuid()) then
		logger.error("[restore_system] function onSay error in 'not player:addPlayerRestore'.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	--local bonusRestore = player:kv():get(config.storageRestores) or 0
	--player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations, you got a new restore. Your character was reset to the level " .. config.resetLevel .. ", but now you have a bonus of +" .. bonusRestore .. "% EXP and +" .. bonusRestore .. "% Damage./n You also gained a bonus of +" .. bonusRestore .. "% HP/MP of the total you had when resetting.")

	return false
end

talkaction:separator(" ")
talkaction:groupType("normal")
talkaction:register()

-- eventcallback creatureOnTargetCombat
local restoreCreatureOnTargetCombat = EventCallback()

function restoreCreatureOnTargetCombat.creatureOnTargetCombat(creature, target)
	local player = creature:getPlayer()
	if not player or not target then
		return true
	end

	local restores = player:kv():get(config.storageRestores) or 0
	if restores > 0 then
		target:registerEvent("restoreOnHealthChange")
		if target:isPlayer() then
			target:registerEvent("restoreOnManaChange")
		end
	end

	return true
end

restoreCreatureOnTargetCombat:register()

-- creaturescript onHealthChange
local restoreOnHealthChange = CreatureEvent("restoreOnHealthChange")

function restoreOnHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)

	if not creature or not attacker or primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if primaryDamage ~= 0 and attacker:isPlayer() then
		local bonusDamage = attacker:kv():get(config.storageRestoresBonus) or 0
		if bonusDamage > 0 then
			bonusDamage = 1 + (bonusDamage / 100)
			primaryDamage = math.ceil(primaryDamage * bonusDamage)
			secondaryDamage = math.ceil(secondaryDamage * bonusDamage)
			logger.info("bonus damage onHealthChange: {}x", bonusDamage)
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

restoreOnHealthChange:register()

-- creaturescript onManaChange
local restoreOnManaChange = CreatureEvent("restoreOnManaChange")

function restoreOnManaChange.onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)

	if not creature or not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if primaryDamage ~= 0 and attacker:isPlayer() then
		local bonusDamage = attacker:kv():get(config.storageRestoresBonus) or 0
		if bonusDamage > 0 then
			bonusDamage = 1 + (bonusDamage / 100)
			primaryDamage = math.ceil(primaryDamage * bonusDamage)
			secondaryDamage = math.ceil(secondaryDamage * bonusDamage)
			logger.info("bonus damage onManaChange: {}x", bonusDamage)
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

restoreOnManaChange:register()

-- CREATURESCRIPTS ONLOGIN 
local restoreOnLogin = CreatureEvent("restoreOnLogin")

function restoreOnLogin.onLogin(player)
	local restores = player:kv():get(config.storageRestores) or 0
	if restores > 0 then
		local bonusDamage = player:kv():get(config.storageRestoresBonus) or 0
		if bonusDamage > 0 then
			player:sendTextMessage(MESSAGE_STATUS, "[RESTORE SYSTEM] You have " .. restores .. " and received +" .. restores .. "% of total HP/MP when reset, and receive bonus of +" .. bonusDamage .. "% of EXP and +" .. bonusDamage .. "% damage.")
		end
	end
	return true
end

restoreOnLogin:register()

-- eventcallback playerOnGainExperience
--[[local restorePlayerOnGainExperience = EventCallback()

function restorePlayerOnGainExperience.playerOnGainExperience(player, target, exp, rawExp)
	if not target or target:isPlayer() then
		return exp
	end

	local bonusExp = player:get(config.storageRestores) or 0
	if bonusExp > 0 then
		exp = exp * ((bonusExp / 100) + 1)
		logger.info("bonus exp playerOnGainExperience: {}x", ((bonusExp / 100) + 1))
	end
end

restorePlayerOnGainExperience:register()
]]--
