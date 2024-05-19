local rewards = {
    { id = 3039, name = "red gem" }, 
    { id = 3041, name = "blue gem" }, 
    { id = 32769, name = "white gem" }, 
    { id = 32770, name = "diamond" } 
}

local ForgeCreation = Action()

function ForgeCreation.onUse(player, item, fromPosition, target, toPosition, isHotkey)
   
    if target.itemid == 35185 then
        local randId = math.random(1, #rewards)
        local rewardItem = rewards[randId]
       
        player:addItem(rewardItem.id, 1)
        --item:remove(1)
        toPosition:sendMagicEffect(CONST_ME_FIREAREA)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewardItem.name .. '.')
        return true
    end

end

ForgeCreation:id(37171)
ForgeCreation:register()