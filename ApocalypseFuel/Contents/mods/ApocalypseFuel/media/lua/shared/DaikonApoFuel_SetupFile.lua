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
local ScriptManager = ScriptManager.instance
for emptyItem, fullItem in pairs(Daikon.ApocalypseBiofuels.ItemsToMakeEthanolContainers) do
    local emptyItemActualItem = ScriptManager:getItem(emptyItem)
    emptyItemActualItem:getTags():add("ApoFuelEmptyEthanol")
    emptyItemActualItem:getReplaceTypesMap():putMapEntries(emptyItem,fullItem)
end
return Daikon