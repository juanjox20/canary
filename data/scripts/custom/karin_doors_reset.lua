Karin.DoorsReset = {
    doors = {
        {
            pos = Position(230, 385, 7),
            reset = 1,
        },
        {
            pos = Position(230, 369, 7),
            reset = 2,
        },		
        {
            pos = Position(230, 373, 7),
            reset = 5,
        },
        {
            pos = Position(218, 377, 7),
            reset = 5,
        },
        {
            pos = Position(276, 243, 6),
            reset = 10,
        },
        {
            pos = Position(276, 241, 6),
            reset = 10,
        },
        {
            pos = Position(276, 239, 6),
            reset = 10,
        },
        {
            pos = Position(276, 237, 6),
            reset = 10,
        },
        {
            pos = Position(276, 235, 6),
            reset = 10,
        },
        {
            pos = Position(276, 233, 6),
            reset = 10,
        },
        {
            pos = Position(276, 231, 6),
            reset = 10,
        },
        {
            pos = Position(276, 229, 6),
            reset = 10,
        },
        {
            pos = Position(276, 227, 6),
            reset = 10,
        },
        {
            pos = Position(276, 225, 6),
            reset = 10,
        },
        {
            pos = Position(286, 227, 6),
            reset = 10,
        },
        {
            pos = Position(286, 225, 6),
            reset = 10,
        },
        {
            pos = Position(286, 229, 6),
            reset = 10,
        },
        {
            pos = Position(286, 233, 6),
            reset = 10,
        },
        {
            pos = Position(286, 235, 6),
            reset = 10,
        },
        {
            pos = Position(286, 237, 6),
            reset = 10,
        },
        {
            pos = Position(286, 239, 6),
            reset = 10,
        },
        {
            pos = Position(286, 241, 6),
            reset = 10,
        },
        {
            pos = Position(286, 243, 6),
            reset = 10,
        },
        {
            pos = Position(277, 242, 5),
            reset = 20,
        },
        {
            pos = Position(277, 240, 5),
            reset = 20,
        },
        {
            pos = Position(277, 238, 5),
            reset = 20,
        },
        {
            pos = Position(277, 236, 5),
            reset = 20,
        },
        {
            pos = Position(277, 234, 5),
            reset = 20,
        },
        {
            pos = Position(277, 232, 5),
            reset = 20,
        },
        {
            pos = Position(277, 230, 5),
            reset = 20,
        },
        {
            pos = Position(277, 228, 5	),
            reset = 20,
        },
        {
            pos = Position(277, 226, 5),
            reset = 20,
        },
        {
            pos = Position(277, 224, 5),
            reset = 20,
        },
        {
            pos = Position(284, 224, 5),
            reset = 20,
        },
        {
            pos = Position(284, 226, 5),
            reset = 20,
        },
        {
            pos = Position(284, 228, 5),
            reset = 20,
        },
        {
            pos = Position(284, 230, 5),
            reset = 20,
        },
        {
            pos = Position(284, 232, 5),
            reset = 20,
        },
        {
            pos = Position(284, 234, 5),
            reset = 20,
        },
        {
            pos = Position(284, 236, 5),
            reset = 20,
        },
        {
            pos = Position(284, 238, 5),
            reset = 20,
        },
        {
            pos = Position(284, 240, 5),
            reset = 20,
        },
        {
            pos = Position(284, 242, 5),
            reset = 20,
        },
    }
}
__System = {
    checkDoor = function(self, player, pos)
        local isDoor = false
        for _, door in pairs(self.doors) do
            if door.pos:compare(pos) then
                isDoor = true
                if player:getPlayerRestores() >= door.reset then
                    return isDoor, true
                else
                    player:sendCancelMessage('You need ' .. door.reset .. ' resets to pass.')
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need ' .. door.reset .. ' resets to pass.')
                end
            end
        end
        
        return isDoor, false
    end
}

Karin.DoorsReset = setmetatable(
    Karin.DoorsReset,
    { __index = __System }
)

