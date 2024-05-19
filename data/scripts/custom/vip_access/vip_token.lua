local viptoken = Action() 

local config = {
	idviptoken = 45730
}

function viptoken.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getItemCount(config.idviptoken) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a Vip Access.")
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:setStorageValue(Storage.VipAccess, 1)
		item:remove(1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need a Vip Token to receive Vip Access.")
	end
	return true
end

viptoken:id(config.idviptoken)
viptoken:register()