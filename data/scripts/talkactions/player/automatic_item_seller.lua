local sell = TalkAction("!sell")
function sell.onSay(player, words, param)
    local money = 0
    for _, item in ipairs(player:getSlotItem(CONST_SLOT_BACKPACK):getItems(true)) do
        local price = ItemType(item:getId()):getSellPrice()
        if price >= 1000 then
            local totalCost = price * item:getCount()
            money = money + totalCost
            player:removeItem(item:getId(), item:getCount())
            player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", item:getCount(), ItemType(item:getId()):getName(), totalCost))
        end
    end
    player:addMoney(money)
    return false
end

sell:groupType("normal")
sell:separator(" ")
sell:register()