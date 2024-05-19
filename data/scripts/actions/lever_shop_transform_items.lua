local lever_id = 1945 -- id of lever before pulled
local pulled_id = 1946 -- id of lever after pulled
local shop = {
    [9891] = {id = 2494, cost = 10000, count = 1},
    [9892] = {id = 2495, cost = 1000, count = 1},
    [9893] = {id = 2496, cost = 1000, count = 1},
    [9894] = {id = 2497, cost = 10000, count = 1},
    [9895] = {id = 2498, cost = 10000, count = 1},
}

local leverShopTransformItems = Action()
function leverShopTransformItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    
    local ShopItem = shop[item.uid]
    local itemType = ItemType(ShopItem.id)
    if item.itemid ~= pulled_id then
           if ShopItem then
            if(not player:removeMoney(ShopItem.cost)) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need '..ShopItem.cost..' to buy '.. itemType:getName() .. '.')
                return false
            end     
            item:transform(pulled_id)
            player:addItem(ShopItem.id, ShopItem.count)
            player:removeMoney(ShopItem.cost)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You bought a '.. itemType:getName() .. '.')
            player:getPosition():sendMagicEffect(13)   
        end
    else
        item:transform(lever_id)
        return true
    end
end

for index, value in pairs(shop) do
	leverShopTransformItems:uid(index)
end

leverShopTransformItems:register()