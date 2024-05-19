--[[
TABELA DE PREÇOS DAS POTIONS

NOME----------------------/ID----------/PRICE-------/CAP-------

mana potion;              ID: 268;   Price: 50;     Cap: 2.70; 
health potion;            ID: 266;   Price: 45;     Cap: 2.70; 
strong mana potion;       ID: 237;   Price: 80;     Cap: 2.90; 
strong health potion;     ID: 236;   Price: 100;    Cap: 2.90;  
great mana potion;        ID: 238;   Price: 120;    Cap: 3.10;   
great health potion;      ID: 239;   Price: 190;    Cap: 3.10;     
great spirit potion;      ID: 7642;   Price: 190;    Cap: 3.10;     
ultimate mana potion;     ID: 23373;  Price: 350;    Cap: 3.10;     
ultimate health potion;   ID: 7643;   Price: 310;    Cap: 3.10;      
ultimate spirit potion;   ID: 23374;  Price: 350;    Cap: 3.10;     
supreme health potion;    ID: 23375;  Price: 500;    Cap: 3.50;      

Creditos ao script: tataboy67 
]]--

local potionsModal = CreatureEvent("Potions Modal")
function potionsModal.onModalWindow(player, modalWindowId, buttonId, choiceId)
	player:unregisterEvent("Potions Modal")

	local id_Potions = {268, 266, 237, 236, 238, 239, 7642, 23373, 7643, 23374, 23375} -- id das potions
	local price = {50, 45, 80, 100, 120, 190, 190, 350, 310, 350, 500} -- price 1x
	local cap = {2.70, 2.70, 2.90, 2.90, 3.10, 3.10, 3.10, 3.10, 3.10, 3.10, 3.50} -- capacity

	if modalWindowId == 1000 then
		if buttonId == 103 then -- botão de compra de 1 item (potion)
			if player:getMoney() >= price[choiceId] then
				if player:getFreeCapacity() >= cap[choiceId] then
				player:removeMoney(price[choiceId])
				player:addItem(id_Potions[choiceId],1)
				player:getPosition():sendMagicEffect(15)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You bought a potion.")
				else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "you do not have enough capacity.")
				player:getPosition():sendMagicEffect(10)
				end
			else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "you do not have enough money.")
			end
		end

		if buttonId == 101 then -- botão de compra de 1 item (potion)
			if player:getMoney() >= price[choiceId]*50 then
				if player:getFreeCapacity() >= cap[choiceId]*50 then
				player:removeMoney(price[choiceId]*50)
				player:addItem(id_Potions[choiceId],1*50)
				player:getPosition():sendMagicEffect(15)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You bought 50x potions")
				else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "you do not have enough capacity.")
				player:getPosition():sendMagicEffect(10)
				end
			else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "you do not have enough money.")
			end
		end

		if buttonId == 102 then -- botão de compra de 1 item (potion)
			if player:getMoney() >= price[choiceId]*100 then
				if player:getFreeCapacity() >= cap[choiceId]*100 then
				player:removeMoney(price[choiceId]*100)
				player:addItem(id_Potions[choiceId],1*100)
				player:getPosition():sendMagicEffect(15)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You bought 100x potions")
				else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "you do not have enough capacity.")
				player:getPosition():sendMagicEffect(10)
				end
			else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "you do not have enough money.")
			end
		end
	end
end

potionsModal:register()