local tileRequeriments = MoveEvent()

function tileRequeriments.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end
 
   local tileRequeriment = item.actionid
   local tileReq = tileRequerimentsConfig[tileRequeriment]
 
   if  tileReq.storageReq > 1 and player:getStorageValue(tileReq.storageReq) < 1 then
       player:teleportTo(fromPosition)
       player:getPosition():sendMagicEffect(CONST_ME_POFF)
       player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você precisa "..tileReq.storageName.." para passar "..tileReq.zoneName..".")
       return true
   end   
   
    if  tileReq.maxLevel > 1 and player:getLevel() > tileReq.maxLevel then 
        player:teleportTo(fromPosition)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Apenas jogadores abaixo do level "..tileReq.maxLevel.." para passar "..tileReq.zoneName..".")
       return true
   end   

    if  player:getLevel() < tileReq.minLevel then 
        player:teleportTo(fromPosition)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você precisa de level "..tileReq.minLevel.." para passar "..tileReq.zoneName..".")
       return true
   end 

	if  player:getResets() < tileReq.resets then 
			player:teleportTo(fromPosition)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você precisa de resets "..tileReq.resets.." para passar "..tileReq.zoneName..".")
		   return true
	end     

    if  tileReq.teleport.x > 0 then
        player:teleportTo(tileReq.teleport)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    end

player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to "..tileReq.zoneName..".")
        return true
end

tileRequeriments:type("stepin")
for i = 36000, 36100 do
tileRequeriments:aid(i)
end
tileRequeriments:register()