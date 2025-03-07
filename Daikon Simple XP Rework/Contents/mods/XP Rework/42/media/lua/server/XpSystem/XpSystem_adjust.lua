for i=1,Perks.getMaxIndex() do
    local perk = PerkFactory.getPerk(Perks.fromIndex(i - 1))
    if perk:isCustom() == false then
        print(perk:getName())
        perk:setCustom()
    end
end
PerkFactory:Reset()
PerkFactory:AddPerk(Perks.Combat, "CombatMelee", 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Axe, "Axe", Perks.Combat, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Blunt, "Blunt", Perks.Combat, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.SmallBlunt, "SmallBlunt", Perks.Combat, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.LongBlade, "LongBlade", Perks.Combat, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.SmallBlade, "SmallBlade", Perks.Combat, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Spear, "Spear", Perks.Combat, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Maintenance, "Maintenance", Perks.Combat, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Firearm, "CombatFirearms", 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Aiming, "Aiming", Perks.Firearm, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Reloading, "Reloading", Perks.Firearm, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Crafting, "Crafting", 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Woodwork, "Carpentry", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Carving, "Carving", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Cooking, "Cooking", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Electricity, "Electricity", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Doctor, "Doctor", Perks.Survivalist, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Glassmaking, "Glassmaking", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.FlintKnapping, "FlintKnapping", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Masonry, "Masonry", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Blacksmith, "Blacksmith", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Mechanics, "Mechanics", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Pottery, "Pottery", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Tailoring, "Tailoring", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.MetalWelding, "MetalWelding", Perks.Crafting, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Survivalist, "Survivalist", 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Fishing, "Fishing", Perks.Survivalist, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.PlantScavenging, "Foraging", Perks.Survivalist, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Tracking, "Tracking", Perks.Survivalist, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Trapping, "Trapping", Perks.Survivalist, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.PhysicalCategory, "PhysicalCategory", 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(
    Perks.Fitness, "Fitness", Perks.PhysicalCategory, 1000, 2000, 4000, 6000, 12000, 20000, 40000, 60000, 80000, 100000, true
)
PerkFactory:AddPerk(
    Perks.Strength, "Strength", Perks.PhysicalCategory, 1000, 2000, 4000, 6000, 12000, 20000, 40000, 60000, 80000, 100000, true
)
PerkFactory:AddPerk(Perks.Agility, "Agility", 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Lightfoot, "Lightfooted", Perks.PhysicalCategory, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Nimble, "Nimble", Perks.PhysicalCategory, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Sprinting, "Sprinting", Perks.PhysicalCategory, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Sneak, "Sneaking", Perks.PhysicalCategory, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.FarmingCategory, "FarmingCategory", 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Farming, "Farming", Perks.FarmingCategory, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Husbandry, "Husbandry", Perks.FarmingCategory, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
PerkFactory:AddPerk(Perks.Butchering, "Butchering", Perks.FarmingCategory, 30, 60, 100, 160, 260, 420, 680, 1100, 1780, 2880)
for skill, values in pairs(SkillBook) do
    values.maxMultiplier1 = 2
    values.maxMultiplier2 = 2
    values.maxMultiplier3 = 2
    values.maxMultiplier4 = 2
    values.maxMultiplier5 = 2
end