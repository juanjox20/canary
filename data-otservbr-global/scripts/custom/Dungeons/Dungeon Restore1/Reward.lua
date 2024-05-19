local NovatoReward = Action()

local lastRewardTimeStorage = 5557 -- Nuevo almacenamiento para registrar el último tiempo que se otorgó la recompensa
local rewardInterval = 1 * 60 -- Intervalo de 1 hora en segundos
local itemBau = 3043
local qntItem = 5
local itemBau1 = 22118
local qntItem1 = 1
local msgQuandoAcha = "¡Felicidades, disfruta tu recompensa!"
local msgQuandoJaPegou = "¡Ya tomaste tu recompensa esta hora!"
local expToAdd = 100000 -- Cantidad de experiencia que se añadirá al jugador

function NovatoReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local lastRewardTime = player:getStorageValue(lastRewardTimeStorage)
    local currentTime = os.time()

    -- Verificar si ya se recogió la recompensa en la última hora
    if lastRewardTime ~= 0 and currentTime - lastRewardTime < rewardInterval then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoJaPegou)
        return true
    end

    -- Otorgar la recompensa
    player:addItem(itemBau, qntItem)
    player:addItem(itemBau1, qntItem1)
    player:addExperience(expToAdd) -- Agregar experiencia al jugador
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msgQuandoAcha)

    -- Registrar el tiempo de la última recompensa
    player:setStorageValue(lastRewardTimeStorage, currentTime)
    return true
end

NovatoReward:uid(5557)
NovatoReward:register()
