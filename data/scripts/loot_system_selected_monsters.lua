local config = {
    ["rat"] = {
        chance = 2500, -- chance out of 10000. 2500 = 25% of an additional item dropping in monsters.
        tiers = {
            -- A random number is rolled between 1 to 10000.
            -- If the number is between or equal to these numbers, that tier is selected.
           
            -- [chance_lower, chance_higher] = {tier = {"text", enabled?}, effect = {effect, enabled?}}
            [{  1,  5000}] = { tier = {"normal", true}, effect = {CONST_ME_SOUND_WHITE, true}, itemList = {
                    {2160, 1, 1, 10000},
                    {2160, 2, 2, 5000}, -- {itemid, amount_min, amount_max, chance} -- chance out of 10000.
                    {2160, 3, 3, 5000}
                }
            },
            [{5001,  8500}] = { tier = {"enchanted", true}, effect = {CONST_ME_SOUND_PURPLE, true}, itemList = {
                    {2160, 1, 1, 10000},
                    {2160, 2, 2, 5000}, -- note; DO NOT SET amount_min, amount_max higher then 1, if that item is not stackable.
                    {2160, 3, 3, 5000}
                }
            },
            [{8501,  9500}] = { tier = {"epic", true}, effect = {CONST_ME_SOUND_BLUE, true}, itemList = {
                    {2160, 1, 1, 10000},
                    {2160, 2, 2, 5000}, -- note; Even though a reward tier has been selected, if all item chances fail to reward an item, it's possible that a player will not receive any item.
                    {2160, 3, 3, 5000}  -- for that reason, I suggest that at least 1 item's chance is set to 10000, so that a player is garenteed to receive an item.
                }
            },
            [{9501, 10000}] = { tier = {"legendary", true}, effect = {CONST_ME_SOUND_YELLOW, true}, itemList = {
                    {2160, 1, 1, 10000},
                    {2160, 2, 2, 5000},
                    {2160, 3, 3, 5000}
                }
            }
        }
    },
    ["cave rat"] = {
        chance = 2500, tiers = {
            [{   1,  5000}] = {tier = {"normal", true},    effect = {CONST_ME_SOUND_WHITE, true},  itemList = {{6500, 1, 1, 10000}, {6500, 2, 2, 5000}, {6500, 3, 3, 5000} }},
            [{5001,  8500}] = {tier = {"enchanted", true}, effect = {CONST_ME_SOUND_PURPLE, true}, itemList = {{6500, 1, 1, 10000}, {6500, 2, 2, 5000}, {6500, 3, 3, 5000} }},
            [{8501,  9500}] = {tier = {"epic", true},      effect = {CONST_ME_SOUND_BLUE, true},   itemList = {{6500, 1, 1, 10000}, {6500, 2, 2, 5000}, {6500, 3, 3, 5000} }},
            [{9501, 10000}] = {tier = {"legendary", true}, effect = {CONST_ME_SOUND_YELLOW, true}, itemList = {{6500, 1, 1, 10000}, {6500, 2, 2, 5000}, {6500, 3, 3, 5000} }}
        }
    },
}

local creatureevent = CreatureEvent("onDeath_randomItemDrops")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local monster = config[creature:getName():lower()]
    -- check if monster is in table
    if monster then
        -- check if corpse item has available space to receive an additional item.
        if corpse:getEmptySlots() > 0 then
            -- check if an additional item will drop.
            if math.random(10000) > monster.chance then
                return true
            end
            -- choose a tier.
            local rand = math.random(10000)
            for chance, index in pairs(monster.tiers) do
                if chance[1] <= rand and chance[2] >= rand then
                    -- create loot list.
                    local rewardItems = {}
                    for i = 1, #index.itemList do
                        if math.random(10000) <= index.itemList[i][4] then
                            rewardItems[#rewardItems + 1] = i
                        end
                    end
                    -- give a random item, if there are any to give.
                    if rewardItems[1] then
                        rand = math.random(#rewardItems)
                        corpse:addItem(index.itemList[rand][1], math.random(index.itemList[rand][2], index.itemList[rand][3]))
                        if index.tier[2] == true then
                            creature:say(index.tier[1], TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())
                        end
                        if index.effect[2] == true then
                            local position = creature:getPosition()
                            for i = 1, 4 do
                                addEvent(function() position:sendMagicEffect(index.effect[1]) end, (i - 1) * 500)
                            end
                        end
                    end
                    return true
                end
            end
        end
    end
    return true
end

creatureevent:register()