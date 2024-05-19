local effects = {
    {position = Position(2484, 2538, 8), text = 'BonusReset1', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(2486, 2538, 8), text = 'BonusReset2', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(2488, 2538, 8), text = 'BonusReset3', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(2490, 2538, 8), text = 'BonusReset4', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(2492, 2538, 8), text = 'BonusReset5', effect = CONST_ME_GROUNDSHAKER},


    {position = Position(544, 16, 7), text = 'Crystal Boots', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(542, 16, 7), text = 'Scale Boots', effect = CONST_ME_GROUNDSHAKER},

    {position = Position(2507, 2494, 7), text = 'EVENTOS', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(2499, 2500, 7), text = 'Bienvenidos', effect = CONST_ME_GROUNDSHAKER},	
    {position = Position(2504, 2489, 7), text = 'TRAINERS', effect = CONST_ME_GROUNDSHAKER},	
    {position = Position(2491, 2494, 7), text = 'Raids', effect = CONST_ME_GROUNDSHAKER},	
    {position = Position(2504, 2494, 7), text = 'Dungeon', effect = CONST_ME_GROUNDSHAKER},	
    {position = Position(2491, 2489, 7), text = 'Tps Zone', effect = CONST_ME_GROUNDSHAKER},	
    {position = Position(2494, 2489, 7), text = 'Quests', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(2494, 2494, 7), text = 'Boss Room', effect = CONST_ME_GROUNDSHAKER},
	
    {position = Position(280, 250, 7), text = 'Templo!', effect = CONST_ME_GROUNDSHAKER},
    {position = Position(280, 220, 7), text = 'Templo', effect = CONST_ME_GROUNDSHAKER},
	
    {position = Position(281, 231, 7), text = 'Tps Reset 1', effect = CONST_ME_GROUNDSHAKER},	
    {position = Position(281, 233, 6), text = 'Tps Reset 2', effect = CONST_ME_GROUNDSHAKER},   
	
    {position = Position(2487, 2496, 7), text = 'Sell Loot', effect = CONST_ME_GROUNDSHAKER},

    {position = Position(2492, 2496, 7), text = 'Vip Hunts', effect = CONST_ME_GROUNDSHAKER},  
}

local animatedText = GlobalEvent("AnimatedText") 
function animatedText.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
        if #spectators > 0 then
            if settings.text then
                for i = 1, #spectators do
                    spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
                end
            end
            if settings.effect then
                settings.position:sendMagicEffect(settings.effect)
            end
        end
    end
   return true
end

animatedText:interval(4550)
animatedText:register()