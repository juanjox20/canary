local smallstaminarefill = Action()
function smallstaminarefill.onUse(player, item, ...)
    local stamina = player:getStamina()
    if stamina >= 2520 then
        player:sendCancelMessage("Ya Tienes Full Stamina Cabron!!.")
        return true
    end
    player:setStamina(math.min(2520, stamina + 420))
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    player:sendCancelMessage("Recibiste 10 Horas De Stamina Gracias Al GOD Compra Mas StaminaRefil Cabron!!.")
    item:remove(1)
    return true
end

smallstaminarefill:id(11372)
smallstaminarefill:register()