function Monster:onSpawn(position)
    if self:getType():isRewardBoss() then
        self:setReward(true)
    end
    self:registerEvent("onDeath_randomItemDrops")

    if self:getName():lower() == "cobra scout" or
        self:getName():lower() == "cobra vizier" or
        self:getName():lower() == "cobra assassin" then
        if getGlobalStorageValue(GlobalStorage.CobraBastionFlask) >= os.time() then
            self:setHealth(self:getMaxHealth() * 0.75)
        end
    end