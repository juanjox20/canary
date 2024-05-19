local config = {
    minLevel = 200,
    firstPosition = Position(4397, 4042, 7),
    secondPosition = Position(4396, 4068, 7)
}

local treePass = Action();

function treePass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getLevel() >= config.minLevel then
        if player:getPosition().y == config.secondPosition.y then
            player:teleportTo(config.firstPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            player:teleportTo(config.secondPosition)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. config.minLevel .. " to access this area.")
    end
    return true
end

treePass:aid(3000)
treePass:register()