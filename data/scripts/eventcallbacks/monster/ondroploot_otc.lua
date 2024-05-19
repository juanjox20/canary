local ec = EventCallback()

function ec.monsterOnDropLoot(monster, corpse)
    if not monster or not corpse then
        return
    end
		if not corpse:getType():isContainer() then
			  return
		end
		local mType = monster:getType()
		if not mType then
			return
		end
		if mType:isRewardBoss() then
			return
		end
    local corpseOwner = Player(corpse:getCorpseOwner())
		if not corpseOwner or not corpseOwner:canReceiveLoot() then
			return
		end
		local oldProtocol = corpseOwner:getClient().version < 1200
		if not oldProtocol then
				return
		end

    local items = corpse:getItems()
    for _, item in pairs(items) do
        if hasPlayerAutolootItem(corpseOwner, item:getId()) then
            if not item:moveTo(corpseOwner) then
                corpseOwner:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You no have capacity.")
                break
            end
        end
    end
end

ec:register()
