local vipPositions = {
    Position(2491, 2497, 7),
	Position(2492, 2497, 7),
	Position(2493, 2497, 7)
}

local vipMovement = MoveEvent()

function vipMovement.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end


    if player:isVip() then
	    return true
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need VIP to advance.')
        player:teleportTo(fromPosition)
        return false
    end
end

for _, pos in pairs(vipPositions) do
    vipMovement:position(pos)
end
vipMovement:register()


local resetPositions = {
    {
        pos = Position(2375, 2670, 7),
        reset = 10,
    }	
}

local resetMovement1 = MoveEvent()

function resetMovement1.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

    if #resetPositions <= 0 then
        return true
    end

    local resetData
    for _, reset in pairs(resetPositions) do
        if position:compare(reset.pos) then
            resetData = reset
        end
    end

    if not resetData then
        return true
    end
    
    if player:getPlayerRestores() >= resetData.reset then
	    return true
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need '.. resetData.reset ..' resets to advance.')
        player:teleportTo(fromPosition)
        return false
    end
end

for _, reset in pairs(resetPositions) do
    resetMovement1:position(reset.pos)
end
resetMovement1:register()

		
local resetPositions = {
    {
        pos = Position(2373, 2670, 7),
        reset = 5,
    }	
}

local resetMovement = MoveEvent()

function resetMovement.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

    if #resetPositions <= 0 then
        return true
    end

    local resetData
    for _, reset in pairs(resetPositions) do
        if position:compare(reset.pos) then
            resetData = reset
        end
    end

    if not resetData then
        return true
    end
    
    if player:getPlayerRestores() >= resetData.reset then
	    return true
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need '.. resetData.reset ..' resets to advance.')
        player:teleportTo(fromPosition)
        return false
    end
end

for _, reset in pairs(resetPositions) do
    resetMovement:position(reset.pos)
end
resetMovement:register()
