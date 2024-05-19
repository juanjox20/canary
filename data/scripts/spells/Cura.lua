--[[
    Bounce Heal
    Author: 𝓜𝓲𝓵𝓵𝓱𝓲𝓸𝓻𝓮 𝓑𝓣 - @millhiorebt
    Version: 1.0
    Engine: TFS
]] --
local config = {
    name = "Bounce Heal",
    words = "exura pum",
    level = 20,
    magicLevel = 5,
    range = 4,
    cooldown = 1000,
    manaCost = 100,

    maxTargets = 5,
    specRange = 4,

    combatType = COMBAT_HEALING,
    combatEffect = CONST_ME_MAGIC_BLUE,
    defaultMultiplier = 1.0,
    decreaseMultiplier = 0.1
}

local setmetatable = setmetatable
local contains = table.contains
local insert = table.insert
local sort = table.sort

---@class BounceHeal
---@field playerId integer
---@field targets integer[]
---@field currentTargetId integer
---@field lastTargetPos Position
local BounceHeal = {}

---@param player Player
---@return BounceHeal BounceHeal
local function getBounceHeal(player)
    local bounceSpell = setmetatable({}, {__index = BounceHeal})
    bounceSpell.playerId = player:getId()
    bounceSpell.targets = {}
    bounceSpell.currentTargetId = 0
    bounceSpell.lastTargetPos = player:getPosition()
    return bounceSpell
end

---@param target Creature|Player
---@return boolean
function BounceHeal:checkTarget(target)
    local player = Player(self.playerId)
    if not player then return false end
    local targetPlayer = target:getPlayer()
    return targetPlayer and self:isFriend(targetPlayer) or false
end

do
    local getSpectators = Game.getSpectators
    local x, y = config.specRange, config.specRange

    ---@param pos Position
    ---@return Player[]
    function BounceHeal:getSpectators(pos)
        local spectators = getSpectators(pos, false, true, x, x, y, y)
        local spects = {}
        for _, spectator in ipairs(spectators) do
            local spectatorId = spectator:getId()
            if spectatorId ~= self.playerId and not contains(self.targets, spectatorId) and self:checkTarget(spectator) then
                insert(spects, spectator)
            end
        end
        return spects
    end
end

---@param target Player
---@return boolean
function BounceHeal:isFriend(target)
    local player = Player(self.playerId)
    if not player then return false end

    local party = player:getParty()
    if not party then return false end

    local targetId = target:getId()
    if targetId == party:getLeader():getId() then return true end
    for _, member in ipairs(party:getMembers()) do if targetId == member:getId() then return true end end
    return false
end

---@param from Position
---@param to Position
---@return integer
local function getDistanceTo(from, to) return from:getDistance(to) end

---@param pos Position
---@return boolean
function BounceHeal:getTargets(pos)
    local spects = self:getSpectators(pos)
    if #spects > 1 then
        sort(spects, function(a, b) return getDistanceTo(pos, a:getPosition()) < getDistanceTo(pos, b:getPosition()) end)
    end

    local target = nil
    for _, spectator in ipairs(spects) do
        if pos:isSightClear(spectator:getPosition(), true) then
            target = spectator
            break
        end
    end

    if not target then return false end
    local targetId = target:getId()
    insert(self.targets, targetId)
    self.currentTargetId = targetId
    self.lastTargetPos = pos
    return true
end

local combats = {}
for divisor = 1, config.maxTargets do
    local combat = Combat()
    combat:setParameter(COMBAT_PARAM_TYPE, config.combatType)
    combat:setParameter(COMBAT_PARAM_EFFECT, config.combatEffect)
    combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
    combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

    ---@param player Player
    function onGetFormulaValues(player, level, magicLevel)
        local min = (level * 4.3) + (magicLevel * 190) + 52
        local max = (level * 4.6) + (magicLevel * 280) + 79
        return min / divisor, max / divisor
    end

    combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
    combats[#combats + 1] = combat
end

---@return boolean
function BounceHeal:execute()
    local player = Player(self.playerId)
    if not player then return false end

    local target = Creature(self.currentTargetId)
    if not target then return false end

    local combat = combats[#self.targets] or combats[#combats]
    if not combat then error("Bounce Heal: Invalid combat.") end

    local targetPos = target:getPosition()
    self.lastTargetPos:sendDistanceEffect(targetPos, CONST_ANI_ENERGY)
    combat:execute(player, Variant(targetPos))

    if #self.targets >= config.maxTargets then return false end
    self.currentTargetId = nil
    if self:getTargets(target:getPosition()) then
        addEvent(self.execute, 100 + (#self.targets * 10), self)
    end
    return true
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(player, variant, isHotkey)
    local bounceHeal = getBounceHeal(player)
    if bounceHeal:getTargets(player:getPosition()) then
        return bounceHeal:execute()
    end

    player:sendCancelMessage("There is no one to heal.")
    return false
end

spell:name(config.name)
spell:words(config.words)
spell:group("support")
spell:vocation("druid", "elder druid")
spell:id(1)
spell:cooldown(config.cooldown)
spell:level(config.level)
spell:mana(config.manaCost)
spell:magicLevel(config.magicLevel)
spell:isPremium(true)
spell:blockWalls(true)
spell:isAggressive(false)
spell:isBlocking(true)
spell:register()