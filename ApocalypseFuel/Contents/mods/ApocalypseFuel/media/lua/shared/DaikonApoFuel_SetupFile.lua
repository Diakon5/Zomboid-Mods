Daikon =  Daikon or {}
Daikon.ApocalypseBiofuels = {}
Daikon.ApocalypseBiofuels.ItemsToMakeEthanolContainers = {
    ["Base.Saucepan"] = "Biofuels.SaucepanWithEthanol",
    ["Base.Pot"] = "Biofuels.PotWithEthanol",
    ["Base.BleachEmpty"] = "Biofuels.BleachBottleWithEthanol",
    ["Base.PopBottleEmpty"] = "Biofuels.PopBottleWithEthanol",
    ["Base.WaterBottleEmpty"] = "Biofuels.WaterBottleWithEthanol",
    ["Base.WhiskeyEmpty"] = "Biofuels.WhiskeyBottleWithEthanol",
    ["Base.BeerEmpty"] = "Biofuels.BeerBottleWithEthanol",
    ["Base.WineEmpty"] = "Biofuels.WineBottleWithEthanol",
    ["Base.WineEmpty2"] = "Biofuels.WineBottleWithEthanol"
}
Daikon.ApocalypseBiofuels.PatchItemsToEthanol = function()
    local ScriptManager = ScriptManager.instance
    for emptyItem, fullItem in pairs(Daikon.ApocalypseBiofuels.ItemsToMakeEthanolContainers) do
        ---@type Item
        local emptyItemActualItem = ScriptManager:getItem(emptyItem)
        emptyItemActualItem:getTags():add("ApoFuelEmptyEthanol")
        emptyItemActualItem:getReplaceTypesMap():put("EthanolSource",fullItem)
    end
end

Events.OnGameBoot.Add(Daikon.ApocalypseBiofuels.PatchItemsToEthanol)
return Daikon