local buyStaminaForGold = TalkAction("!stamina")
function buyStaminaForGold.onSay(player, words, param)

  local goldMultiplier = 5000 --this is the price for 1 minute of regular stamina
  local maxBuyStamina = 300 --maximum amount of minutes you can have (40 hours = 2400 minutes) this restricts the buying of bonus stamina (or not)

  local count = tonumber(param)

  if count == nil then
    player:sendCancelMessage("You must specify a number of minutes you want to buy")
    player:getPosition():sendMagicEffect(CONST_ME_POFF)
    return false
  end
  if player:getStamina() >= maxBuyStamina then
    player:sendCancelMessage("You already have enough stamina, you can only buy up to " .. math.floor(maxBuyStamina/60) .." hours.")
    player:getPosition():sendMagicEffect(CONST_ME_POFF)
    return false
  end
  if player:getStamina() + count > maxBuyStamina then
    excess = math.floor(player:getStamina() + count - 2520 + (2520 - maxBuyStamina))
    else
    excess = 0
  end

  local price = math.floor((count - excess) * goldMultiplier)
  if player:removeMoneyBank(price) then
    player:setStamina(player:getStamina() + count - excess)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have bought " .. count - excess .. " minute(s) of stamina.")
    return true
    else
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have enough money, " .. count - excess .. " minute(s) of stamina costs " .. price .. " gold coins.")
    player:getPosition():sendMagicEffect(CONST_ME_POFF)
    return false
  end
end

buyStaminaForGold:separator(" ")
buyStaminaForGold:groupType("normal")
buyStaminaForGold:register()