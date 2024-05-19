AutoLootConfig = {
    storageBase = 70000,
    freeAccountLimit = 10,
    premiumAccountLimit = 20
}

autolootCache = {}

function getPlayerLimit(player)
    return player:isPremium() and AutoLootConfig.premiumAccountLimit or AutoLootConfig.freeAccountLimit
end

function getPlayerAutolootItems(player)
    local limits = getPlayerLimit(player)
    local guid = player:getGuid()
    local itemsCache = autolootCache[guid]
    if itemsCache then
        if #itemsCache > limits then
            local newChache = {unpack(itemsCache, 1, limits)}
            autolootCache[guid] = newChache
            return newChache
        end
        return itemsCache
    end

    local items = {}
    for i = 1, limits do
        local itemType = ItemType(tonumber(player:getStorageValue(AutoLootConfig.storageBase + i)) or 0)
        if itemType and itemType:getId() ~= 0 then
            items[#items +1] = itemType:getId()
        end
    end

    autolootCache[guid] = items
    return items
end

function setPlayerAutolootItems(player, items)
    for i = 1, getPlayerLimit(player) do
        player:setStorageValue(AutoLootConfig.storageBase + i, (items[i] and items[i] or -1))
    end
    return true
end

function addPlayerAutolootItem(player, itemId)
    local items = getPlayerAutolootItems(player)
    for _, id in pairs(items) do
        if itemId == id then
            return false
        end
    end
    items[#items +1] = itemId
    return setPlayerAutolootItems(player, items)
end

function removePlayerAutolootItem(player, itemId)
    local items = getPlayerAutolootItems(player)
    for i, id in pairs(items) do
        if itemId == id then
            table.remove(items, i)
            return setPlayerAutolootItems(player, items)
        end
    end
    return false
end

function hasPlayerAutolootItem(player, itemId)
    for _, id in pairs(getPlayerAutolootItems(player)) do
        if itemId == id then
            return true
        end
    end
    return false
end
