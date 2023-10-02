local Daikon = Daikon or {}
Daikon.TraitSkillCapper = {}
Daikon.TraitSkillCapper.traitsSkills = {
    ["DSC_city_person"] = {"Fishing","PlantScavenging","PlantScavenging","Farming","Farming"},
	["DSC_Heavy_footed"] = {"Lightfoot","Lightfoot","Sneak","Sneak"},
	["DSC_LikeFastFood"] = {"Cooking","Cooking","Cooking"},
	["DSC_Unhandy"] = {"Woodwork","Mechanics","Electricity","MetalWelding","Maintenance"},
	["DSC_Robophobic"] = {"Mechanics","Electricity","Mechanics","Electricity"},
	["DSC_LikeFastFood"] = {"Cooking","Cooking","Cooking"},
	["DSC_ShakyHands"] = {"Doctor","Doctor","Tailoring","Tailoring"},
	["DSC_AntiGun"] = {"Aiming", "Aiming", "Aiming", "Aiming", "Reloading", "Reloading", "Reloading"}
	["DSC_Crapenter"] = {"Woodwork","Woodwork","Woodwork","Woodwork","Woodwork"}
}

Daikon.TraitSkillCapper.InitTraits = function()
    TraitFactory.addTrait("DSC_city_person",
                                getText("UI_trait_DSC_city_person"),
                                -5,
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
    TraitFactory.addTrait("DSC_Unhandy",						--smiley5385
                            getText("UI_trait_DSC_Unhandy"),	
                            -5,
                            getText("UI_trait_DSC_Unhandy_desc"),
                            false,
                            false)
	TraitFactory.addTrait("DSC_LowComprehension",				--hoots_mc_goots
                            getText("UI_trait_DSC_LowComprehension"),
                            -4,
                            getText("UI_trait_DSC_LowComprehension_desc"),
                            false,
                            false)
	TraitFactory.addTrait("DSC_Robophobic",						--rogueoperative
                            getText("UI_trait_DSC_Robophobic"),
                            -4,
                            getText("UI_trait_DSC_Robophobic_desc"),
                            false,
                            false)
	TraitFactory.addTrait("DSC_ShakyHands",						--rogueoperative
                            getText("UI_trait_DSC_ShakyHands"),
                            -4,
                            getText("UI_trait_DSC_ShakyHands_desc"),
                            false,
                            false)
	TraitFactory.addTrait("DSC_AntiGun",
                            getText("UI_trait_DSC_AntiGun"),
                            -7,
                            getText("UI_trait_DSC_AntiGun_desc"),
                            false,
                            false)
	TraitFactory.addTrait("DSC_Crapenter",						--rogueoperative
                            getText("UI_trait_DSC_Crapenter"),
                            -4,
                            getText("UI_trait_DSC_Crapenter_desc"),
                            false,
                            false)
	TraitFactory.addTrait("DSC_AntiGun",
                            getText("UI_trait_DSC_Squeamish"),
                            -3,
                            getText("UI_trait_DSC_Squeamish_desc"),
                            false,
                            false)

end

Events.OnGameBoot.Add(Daikon.TraitSkillCapper.InitTraits)
return Daikon