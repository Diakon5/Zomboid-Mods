require "TimedActions/ISReadABook"

local original_checkMultiplier = ISReadABook.checkMultiplier

function ISReadABook:checkMultiplier()
    original_checkMultiplier(self)
    if self.character:HasTrait("DSC_LowReadingComprehension") then
        local trainedStuff = SkillBook[self.item:getSkillTrained()]
        local characterXP = self.character:getXp()
        if trainedStuff then
            local multiplier = characterXP:getMultiplier(trainedStuff.perk)
            if multiplier > 0 then
                characterXP:addXpMultiplier(trainedStuff.perk, multiplier/2, self.item:getLvlSkillTrained(), self.item:getMaxLevelTrained());
            end
        end
    end
end