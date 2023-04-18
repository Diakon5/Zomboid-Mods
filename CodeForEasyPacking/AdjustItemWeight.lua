--[[
Logic for weight
5 pack = 5 * weight *                   0.7
10 pack = 10 * weight *                 0.5
5 pack with sheetrope = 5 * weight *    0.3
10 pack with sheetrope = 10 * weight *  0.25
5 pack with rope = 5 * weight * 0.2
10 pack with rope = 10 * weight * 0.15
also for Electronics Scrap, Rag, Denim, Leather:
10 pack = 10 * weight * 0.7
50 pack = 50 * weight * 0.6
100 pack = 100 * weight * 0.5
]]
local listToAdjust = {}
local function WeightAdjustment(itemName, baseItemName, amount, multiplier)
    local item = ScriptManager.instance:getItem(itemName)
    local baseItem = ScriptManager.instance:getItem(baseItemName)
    if item and baseItem then
        local baseItemWeight = baseItem:getActualWeight()
        local calculated = baseItemWeight * amount * multiplier
        item:DoParam("Weight = "..calculated)
    end

end
local function AdjustWeight(itemName, baseItemName, amount, multiplier)
    if not listToAdjust[itemName] then
        listToAdjust[itemName] = {};
    end
    if not listToAdjust[itemName][baseItemName] then
        listToAdjust[itemName][baseItemName] = {}
    end
    listToAdjust[itemName][baseItemName][amount] = multiplier;
end
local function Perform()
    for itemName,v in pairs(listToAdjust) do
        for baseItemName,y in pairs(v) do
            for amount,multiplier in pairs(y) do
                if pcall(WeightAdjustment(itemName,baseItemName,amount,multiplier)) then
                    print("Could not patch Item's ",itemName," Weight calculated from base item ",baseItemName," of amount",amount," multiplied by ", multiplier)
                end
            end
        end
    end
end
--add for every packed item: Name, BaseName,Amount,Multiplier. Scroll up for for multiplier
AdjustWeight("Packing.5pkSheetRopePlank","Base.Plank",5,0.3)
AdjustWeight("Packing.10pkSheetRopePlank","Base.Plank",10,0.25)
AdjustWeight("Packing.5pkRopePlank","Base.Plank",5,0.2)
AdjustWeight("Packing.10pkRopePlank","Base.Plank",10,0.15)

AdjustWeight("Packing.5pkSheetRopePetrolCan","Base.PetrolCan",5,0.3)
AdjustWeight("Packing.10pkSheetRopePetrolCan","Base.PetrolCan",10,0.25)
AdjustWeight("Packing.5pkRopePetrolCan","Base.PetrolCan",5,0.2)
AdjustWeight("Packing.10pkRopePetrolCan","Base.PetrolCan",10,0.15)

AdjustWeight("Packing.5pkSheetRopeEmptyPetrolCan","Base.EmptyPetrolCan",5,0.3)
AdjustWeight("Packing.10pkSheetRopeEmptyPetrolCan","Base.EmptyPetrolCan",10,0.25)
AdjustWeight("Packing.5pkRopeEmptyPetrolCan","Base.EmptyPetrolCan",5,0.2)
AdjustWeight("Packing.10pkRopeEmptyPetrolCan","Base.EmptyPetrolCan",10,0.15)

AdjustWeight("Packing.5pkElectricWire","Base.ElectricWire",5,0.7)
AdjustWeight("Packing.10pkElectricWire","Base.ElectricWire",10,0.5)

AdjustWeight("Packing.5pkSheetRopePropaneTank","Base.PropaneTank",5,0.3)
AdjustWeight("Packing.10pkSheetRopePropaneTank","Base.PropaneTank",10,0.25)
AdjustWeight("Packing.5pkRopePropaneTank","Base.PropaneTank",5,0.2)
AdjustWeight("Packing.10pkRopePropaneTank","Base.PropaneTank",10,0.15)

AdjustWeight("Packing.5pkBarbedWire","Base.BarbedWire",5,0.7)
AdjustWeight("Packing.10pkBarbedWire","Base.BarbedWire",10,0.5)

AdjustWeight("Packing.5pkWeldingRods","Base.WeldingRods",5,0.7)
AdjustWeight("Packing.10pkWeldingRods","Base.WeldingRods",10,0.5)

AdjustWeight("Packing.5pkNailsBox","Base.NailsBox",5,0.7)
AdjustWeight("Packing.10pkNailsBox","Base.NailsBox",10,0.5)

AdjustWeight("Packing.5pkScrewsBox","Base.ScrewsBox",5,0.7)
AdjustWeight("Packing.10pkScrewsBox","Base.ScrewsBox",10,0.5)

AdjustWeight("Packing.5pkSheetMetal","Base.SheetMetal",5,0.7)
AdjustWeight("Packing.10pkSheetMetal","Base.SheetMetal",10,0.5)
AdjustWeight("Packing.5pkSheetRopeSheetMetal","Base.SheetMetal",5,0.3)
AdjustWeight("Packing.10pkSheetRopeSheetMetal","Base.SheetMetal",10,0.25)
AdjustWeight("Packing.5pkRopeSheetMetal","Base.SheetMetal",5,0.2)
AdjustWeight("Packing.10pkRopeSheetMetal","Base.SheetMetal",10,0.15)

AdjustWeight("Packing.5pkMetalBar","Base.MetalBar",5,0.7)
AdjustWeight("Packing.10pkMetalBar","Base.MetalBar",10,0.5)
AdjustWeight("Packing.5pkSheetRopeMetalBar","Base.MetalBar",5,0.3)
AdjustWeight("Packing.10pkSheetRopeMetalBar","Base.MetalBar",10,0.25)
AdjustWeight("Packing.5pkRopeMetalBar","Base.MetalBar",5,0.2)
AdjustWeight("Packing.10pkRopeMetalBar","Base.MetalBar",10,0.15)

AdjustWeight("Packing.5pkMetalPipe","Base.MetalPipe",5,0.7)
AdjustWeight("Packing.10pkMetalPipe","Base.MetalPipe",10,0.5)
AdjustWeight("Packing.5pkSheetRopeMetalPipe","Base.MetalPipe",5,0.3)
AdjustWeight("Packing.10pkSheetRopeMetalPipe","Base.MetalPipe",10,0.25)
AdjustWeight("Packing.5pkRopeMetalPipe","Base.MetalPipe",5,0.2)
AdjustWeight("Packing.10pkRopeMetalPipe","Base.MetalPipe",10,0.15)

AdjustWeight("Packing.5pkSheetRopeBranch","Base.TreeBranch",5,0.3)
AdjustWeight("Packing.10pkSheetRopeBranch","Base.TreeBranch",10,0.25)
AdjustWeight("Packing.5pkRopeBranch","Base.TreeBranch",5,0.2)
AdjustWeight("Packing.10pkRopeBranch","Base.TreeBranch",10,0.15)

AdjustWeight("Packing.5pkSheetPaper","Base.SheetPaper2",5,0.7)
AdjustWeight("Packing.10pkSheetPaper","Base.SheetPaper2",10,0.5)

AdjustWeight("Packing.6pkBeerCan","Base.BeerCan",6,0.5)
AdjustWeight("Packing.6pkBeer","Base.BeerBottle",6,0.5)

AdjustWeight("Packing.5pkScrapMetal","Base.ScrapMetal",5,0.7)
AdjustWeight("Packing.10pkScrapMetal","Base.ScrapMetal",10,0.5)

AdjustWeight("Packing.5pkScrapMetal","Base.ScrapMetal",5,0.7)
AdjustWeight("Packing.10pkScrapMetal","Base.ScrapMetal",10,0.5)

AdjustWeight("Packing.5pkMagazine","Base.Magazine",5,0.7)
AdjustWeight("Packing.10pkMagazine","Base.Magazine",10,0.5)

AdjustWeight("Packing.5pkNewspaper","Base.Newspaper",5,0.7)
AdjustWeight("Packing.10pkNewspaper","Base.Newspaper",10,0.5)

AdjustWeight("Packing.5pkBook","Base.Book",5,0.7)
AdjustWeight("Packing.10pkBook","Base.Book",10,0.5)

AdjustWeight("Packing.5pkSoap","Base.soap2",5,0.7)
AdjustWeight("Packing.10pkSoap","Base.soap2",10,0.5)

AdjustWeight("Packing.5pkTissue","Base.Tissue",5,0.7)
AdjustWeight("Packing.10pkTissue","Base.Tissue",10,0.5)

AdjustWeight("Packing.5pkThread","Base.Thread",5,0.7)
AdjustWeight("Packing.10pkThread","Base.Thread",10,0.5)

AdjustWeight("Packing.5pkWire","Base.Wire",5,0.7)
AdjustWeight("Packing.10pkWire","Base.Wire",10,0.5)

AdjustWeight("Packing.20pkCigarettes","Base.Cigarettes",20,0.5)

AdjustWeight("Packing.5pkFishingLine","Base.FishingLine",5,0.7)
AdjustWeight("Packing.10pkFishingLine","Base.FishingLine",10,0.5)

AdjustWeight("Packing.5pkTwine","Base.Twine",5,0.7)
AdjustWeight("Packing.10pkTwine","Base.Twine",10,0.5)

AdjustWeight("Packing.5pkMatches","Base.Matches",5,0.7)
AdjustWeight("Packing.10pkMatches","Base.Matches",10,0.5)

AdjustWeight("Packing.5pkTwine","Base.Twine",5,0.7)
AdjustWeight("Packing.10pkTwine","Base.Twine",10,0.5)

AdjustWeight("Packing.5pkRope","Base.Rope",5,0.7)
AdjustWeight("Packing.10pkRope","Base.Rope",10,0.5)

AdjustWeight("Packing.5pkSheetRope","Base.SheetRope",5,0.7)
AdjustWeight("Packing.10pkSheetRope","Base.SheetRope",10,0.5)

AdjustWeight("Packing.5pkLighter","Base.Lighter",5,0.7)
AdjustWeight("Packing.10pkLighter","Base.Lighter",10,0.5)

AdjustWeight("Packing.5pkWoodGlue","Base.Woodglue",5,0.7)
AdjustWeight("Packing.10pkWoodGlue","Base.Woodglue",10,0.5)

AdjustWeight("Packing.5pkGlue","Base.Glue",5,0.7)
AdjustWeight("Packing.10pkGlue","Base.Glue",10,0.5)

AdjustWeight("Packing.5pkFishingNet","Base.FishingNet",5,0.7)
AdjustWeight("Packing.10pkFishingNet","Base.FishingNet",10,0.5)

AdjustWeight("Packing.5pkBattery","Base.Battery",5,0.7)
AdjustWeight("Packing.10pkBattery","Base.Battery",10,0.5)

AdjustWeight("Packing.10pkElectronicsScrap","Base.ElectronicsScrap",10,0.7)
AdjustWeight("Packing.50pkElectronicsScrap","Base.ElectronicsScrap",50,0.6)
AdjustWeight("Packing.100pkElectronicsScrap","Base.ElectronicsScrap",100,0.5)

AdjustWeight("Packing.10pkRag","Base.RippedSheets",10,0.7)
AdjustWeight("Packing.50pkRag","Base.RippedSheets",50,0.6)
AdjustWeight("Packing.100pkRag","Base.RippedSheets",100,0.5)

AdjustWeight("Packing.10pkDenim","Base.DenimStrips",10,0.7)
AdjustWeight("Packing.50pkDenim","Base.DenimStrips",50,0.6)
AdjustWeight("Packing.100pkDenim","Base.DenimStrips",100,0.5)

AdjustWeight("Packing.10pkLeather","Base.LeatherStrips",10,0.7)
AdjustWeight("Packing.50pkLeather","Base.LeatherStrips",50,0.6)
AdjustWeight("Packing.100pkLeather","Base.LeatherStrips",100,0.5)
Events.OnGameTimeLoaded.Add(Perform)