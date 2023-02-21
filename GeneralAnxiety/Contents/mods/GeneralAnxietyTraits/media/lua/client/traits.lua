local function DGA_initTraits()
    local depressiveTrait = TraitFactory.addTrait("DGR_Depressive",    -- Incode name to refere that trait
            getText("UI_trait_DGR_Depressive"),                       -- Trait name in game
            -4,                                                       -- Cost of the trait, can be positive or negative
            getText("UI_trait_DGR_Depressive_desc"),                   -- Description of the trait
            false,                                                    -- Whether the trait is related to a profession
            false)                                                    -- Whether the trait is removed in Multiplayer
    local chronicPainTrait = TraitFactory.addTrait("DGR_ChronicPain",    -- Incode name to refere that trait
            getText("UI_trait_DGR_ChronicPain"),                       -- Trait name in game
            -4,                                                       -- Cost of the trait, can be positive or negative
            getText("UI_trait_DGR_ChronicPain_desc"),                   -- Description of the trait
            false,                                                    -- Whether the trait is related to a profession
            false)                                                    -- Whether the trait is removed in Multiplayer
end

local depressionIncrease = 100/(1440*2) --This should make the depression increase to max over the period of two days

---@param player IsoGameCharacter
local function DGA_depressivecode(player)
    if player:HasTrait("UI_trait_DGR_Depressive") then
        local bodyDamage = player:getBodyDamage()
        bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel()+depressionIncrease)
    end
end

Events.OnGameBoot.Add(DGA_initTraits)
Events.EveryOneMinute.Add(function()
    DGA_depressivecode(getPlayer())
end)