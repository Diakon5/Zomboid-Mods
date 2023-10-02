local Daikon = {}
Daikon.TraitSkillCapper = {}
Daikon.TraitSkillCapper.traitsSkills = {
    ["DSC_City_Person"] = {"Fishing","PlantScavenging","PlantScavenging","Farming"},
    ["DSC_Heavy_footed"] = {"Lightfoot","Lightfoot","Sneak","Sneak"},
    ["DSC_LikeFastFood"] = {"Cooking","Cooking","Cooking"},
    ["DSC_Unhandy"] = {"Woodwork","Electricity","Maintenance","Mechanics"},
}

Daikon.TraitSkillCapper.InitTraits = function()
    TraitFactory.addTrait("DSC_City_Person",
                                getText("UI_trait_DSC_city_person"),
                                -4,
                                getText("UI_trait_DSC_city_person_desc"),
                            false,
                            false)
    TraitFactory.addTrait("DSC_Heavy_footed",
                            getText("UI_trait_DSC_Heavy_footed"),
                            -4,
                            getText("UI_trait_DSC_Heavy_footed_desc"),
                            false,
                            false)
    TraitFactory.addTrait("DSC_LikeFastFood",
                            getText("UI_trait_DSC_LikeFastFood"),
                            -3,
                            getText("UI_trait_DSC_LikeFastFood_desc"),
                            false,
                            false)
    TraitFactory.addTrait("DSC_Unhandy",
                            getText("UI_trait_DSC_Unhandy"),
                            -5,
                            getText("UI_trait_DSC_Unhandy_desc"),
                            false,
                            false)
    TraitFactory.addTrait("DSC_LowReadingComprehension",
            getText("UI_trait_DSC_LowReadingComprehension"),
            -4,
            getText("UI_trait_DSC_LowReadingComprehension_desc"),
            false,
            false)

end

Events.OnGameBoot.Add(Daikon.TraitSkillCapper.InitTraits)
return Daikon