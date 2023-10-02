local Daikon = require("daikonSkillCapper_AddTraits")

local skillCaps

---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param amount number
Daikon.TraitSkillCapper.SkillCapperTraitLogic = function(character, perk, amount)
    if skillCaps == nil then
        Daikon.TraitSkillCapper.InitCharacterSkillCaps(0,character)
    end
    print("Gained XP in" .. perk:getName())
    local maxLevel = skillCaps[perk:getName()]
    if maxLevel ~= nil then
        local characterXP = character:getXp()
        --calculate how much xp we need to reach the cap
        local howMuchExcess = perk:getTotalXpForLevel(maxLevel) - characterXP:getXP(perk)
        --if we're over the cap, add the excess.
        if howMuchExcess < 0 then
            characterXP:AddXP(perk,howMuchExcess,false,false,false)
        end
    end
end

---@param character IsoGameCharacter
Daikon.TraitSkillCapper.InitCharacterSkillCaps = function(_, character)
    skillCaps = {}
    for trait,skillNames in pairs(Daikon.TraitSkillCapper.traitsSkills) do
        --check if the character has the trait
        if character:HasTrait(trait) then
            --loop over the skills to cap
            for _, skill in ipairs(skillNames) do
                if skillCaps[skill] == nil then
                    skillCaps[skill] = 8
                elseif skillCaps[skill] > 0 then
                    skillCaps[skill] = skillCaps[skill] - 2
                end
            end
        end
    end
end

Events.OnCreatePlayer.Add(Daikon.TraitSkillCapper.InitCharacterSkillCaps)
Events.AddXP.Add(Daikon.TraitSkillCapper.SkillCapperTraitLogic)