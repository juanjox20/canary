local shop = {}
local modalWindow = ModalWindow(99999, "~ Shop Item List ~", "List of items available in the shop.")
modalWindow:addButton(1, "Buy")
modalWindow:addButton(2, "Close")
modalWindow:setDefaultEscapeButton(2)
modalWindow:setDefaultEnterButton(2)

local index = 1
for name, item in pairs({
    -- The names are converted to lowercase letters automatically, don't worry.
    -- Note: for stackable items the maximum quantity is 100, and for non-stackable items the maximum quantity is 1
    -- Examples:
    ["Spectral Boltx5"] = { id=35902, price=10000, count=100 }, 
    ["Diamond Arrowx5"] = { id=35901, price=10000, count=100 }, 
    ["Assassin Starx5"] = { id=7368, price=1000, count=100 },		
    ["Health Potion"] = { id=266, price=4500, count=100 }, 
    ["Mana Potion"] = { id=268, price=5000, count=100 }, 
    ["Strong Mana Potion"] = { id=237, price=8000, count=100 }, 
    ["Strong Health Potion"] = { id=236, price=10000, count=100 }, 
    ["Great Health Potion"] = { id=239, price=19000, count=100 }, 
    ["Great Mana Potion"] = { id=238, price=12000, count=100 }, 
    ["Great Spirit Potion"] = { id=7642, price=19000, count=100 }, 
    ["Ultimate Health Potion"] = { id=7643, price=31000, count=100 }, 
    ["Ultimate Mana Potion"] = { id=23373, price=35000, count=100 }, 
    ["Ultimate Spirit Potion"] = { id=23374, price=35000, count=100 }, 
    ["Supreme Health Potion"] = { id=23375, price=50000, count=100 }, 
    ["Sudden Death Rune"] = { id=3155, price=5000, count=100 }, 
    ["Explosion Rune"] = { id=3200, price=3100, count=100 }, 
    ["Fire Bomb Rune"] = { id=3192, price=5500, count=100 }, 
    ["Wild Growth Rune"] = { id=3156, price=16000, count=100 }, 
    ["Ultimate Healing Rune"] = { id=3160, price=17500, count=100 }, 
    ["Paralyse Rune"] = { id=3165, price=50000, count=100 }, 
    ["Magic Wall Rune"] = { id=3180, price=5500, count=100 }, 
    ["Great Fireball Rune"] = { id=3191, price=4500, count=100 }, 
    ["Avalanche Rune"] = { id=3161, price=2500, count=100 } 

}) do
    local lowerCaseName = name:lower()
    if index <= 255 then -- This is due to the client's limitations, in the future I may improve this system so that it has pages, but for now that is all
        modalWindow:addChoice(index, string.format("[ %s x%d ]: %d gold coins.", lowerCaseName, math.min(item.count and item.count or 1, 100), item.price))
        shop[index] = lowerCaseName -- for help to modalWindow
        index = index +1
    end
    shop[lowerCaseName] = item
end

local function buyItem(player, param)
    local item = shop[param:lower()]
    if not item then
        player:sendCancelMessage(string.format("Item with name %s not found!", param))
        return false
    end

    local money = player:getMoney()
    local bankBalance = player:getBankBalance()
    local totalMoney = money + bankBalance
    if totalMoney < item.price then
        player:sendCancelMessage(string.format("You don't have enough gold coins, You need %d gold coins.", item.price))
        return false
    end

    local buyedItem = Game.createItem(item.id, math.min((item.count and item.count or 1), 100))
    if not buyedItem or not buyedItem:getType():isMovable() then
        print(string.format("Warning: The shop item with ID: %d is invalid.\n%s", item.id, debug.traceback()))
        Item.remove(buyedItem) -- in case the buyedItem is nil, no problem will occur
        return false
    end

    if player:addItemEx(buyedItem) ~= RETURNVALUE_NOERROR then
        player:sendCancelMessage(RETURNVALUE_NOTENOUGHCAPACITY)
        buyedItem:remove()
        return false
    end

    local resultMoney = money - item.price
    if resultMoney < 0 then
        player:removeMoney(money)
        player:setBankBalance(bankBalance + resultMoney)
    else
        player:removeMoney(item.price)
    end

    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your purchase was successful! (%s x%d).\nYou now have %d gold coins and %d on the bank balance.", buyedItem:getName(), buyedItem:getCount(), money, player:getBankBalance()))
    return false
end

local talkAction = TalkAction("!shop")
function talkAction.onSay(player, words, param, type)
    if param == "list" then
        modalWindow:sendToPlayer(player)
        return false
    end
    return buyItem(player, param)
end
talkAction:separator(" ")
talkAction:groupType("normal")
talkAction:register()

local creatureEvent = CreatureEvent("shopModalWindow")
function creatureEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
    if modalWindowId == 99999 then
        if buttonId == 1 then
            local param = shop[choiceId]
            if not param then
                return true
            end
            buyItem(player, param)
            return true
        end
    end
    return true
end
creatureEvent:register()

local creatureEvent = CreatureEvent("shopRegister")
function creatureEvent.onLogin(player)
    player:registerEvent("shopModalWindow")
    return true
end
creatureEvent:register()