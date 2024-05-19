local shop = {
    [1800] = {id = 236, cost = 9300, count = 100},
    [1801] = {id = 237, cost = 1000, count = 100},
    [1802] = {id = 239, cost = 19000, count = 100},
    [1803] = {id = 238, cost = 13900, count = 100},
    [1804] = {id = 7642, cost = 18500, count = 100},
    [1805] = {id = 7643, cost = 31000, count = 100},		
    [1806] = {id = 3180, cost = 31000, count = 100},	
    [1807] = {id = 3165, cost = 31000, count = 100},	
    [1808] = {id = 3192, cost = 31000, count = 100},	
    [1809] = {id = 3160, cost = 31000, count = 100},	
    [1810] = {id = 3161, cost = 31000, count = 100},	
    [1811] = {id = 3155, cost = 31000, count = 100},		
    [1812] = {id = 8778, cost = 31000, count = 1},	
    [1813] = {id = 11455, cost = 31000, count = 1},	
    [1814] = {id = 11684, cost = 31000, count = 1},	
    [1815] = {id = 8150, cost = 31000, count = 1},		
    [1816] = {id = 11588, cost = 31000, count = 1},	
    [1817] = {id = 12252, cost = 31000, count = 5},	
    [1818] = {id = 12310, cost = 31000, count = 5},	

    [1819] = {id = 3447, cost = 31000, count = 100},	
    [1820] = {id = 3448, cost = 31000, count = 100},	
    [1821] = {id = 3449, cost = 31000, count = 100},	
    [1822] = {id = 7365, cost = 31000, count = 100},	
    [1823] = {id = 7364, cost = 31000, count = 100},	
    [1824] = {id = 14252, cost = 31000, count = 100},	
    [1825] = {id = 3287, cost = 31000, count = 100},	
    [1826] = {id = 7366, cost = 31000, count = 100},	
    [1827] = {id = 7368, cost = 31000, count = 100},	
    [1828] = {id = 3446, cost = 31000, count = 100},	
    [1829] = {id = 7363, cost = 31000, count = 100},
    [1830] = {id = 3450, cost = 31000, count = 100},	
    [1831] = {id = 45424, cost = 31000, count = 100},	
}

local leverShop = Action()
function leverShop.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local ShopItem = shop[item.uid]
    local itemType = ItemType(ShopItem.id)
    if ShopItem then
        if(not player:removeMoney(ShopItem.cost)) then
		    player:sendCancelMessage("choose your potion you want to buy.") 
            return false
        end     
        player:addItem(ShopItem.id, ShopItem.count)
        player:removeMoney(ShopItem.cost)
        player:sendCancelMessage("You need buy potions.")		
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    end
    return true
end

for index, value in pairs(shop) do
	leverShop:uid(index)
end

leverShop:register()