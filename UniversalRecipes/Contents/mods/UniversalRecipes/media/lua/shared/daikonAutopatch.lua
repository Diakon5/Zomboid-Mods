local daikon = {
    RecipePatcher = {
    }
}

local function patchRecipes()
    local scriptItems ={
        canOpeners = PZArrayList:emptyList(),
        hammers = PZArrayList:emptyList(),
        screwdrivers = PZArrayList:emptyList(),
        dullKnives = PZArrayList:emptyList(),
        sharpKnives = PZArrayList:emptyList(),
        scissors = PZArrayList:emptyList(),
        weldingMasks = PZArrayList:emptyList(),
        forks = PZArrayList:emptyList(),
        disinfectants = PZArrayList:emptyList(),
        liquor = PZArrayList:emptyList(),
        milk = PZArrayList:emptyList(),
        sugar = PZArrayList:emptyList(),
        brokenGlass = PZArrayList:emptyList(),
        sewingNeedle = PZArrayList:emptyList(),

    }
    Recipe.GetItemTypes.CanOpener(scriptItems.canOpeners)
    Recipe.GetItemTypes.Hammer(scriptItems.hammers)
    Recipe.GetItemTypes.Screwdriver(scriptItems.screwdrivers)
    Recipe.GetItemTypes.DullKnife(scriptItems.dullKnives)
    Recipe.GetItemTypes.SharpKnife(scriptItems.sharpKnives)
    Recipe.GetItemTypes.Scissors(scriptItems.scissors)
    Recipe.GetItemTypes.WeldingMask(scriptItems.weldingMasks)
    Recipe.GetItemTypes.Fork(scriptItems.forks)
    Recipe.GetItemTypes.Disinfectant(scriptItems.disinfectants)
    Recipe.GetItemTypes.Liquor(scriptItems.liquor)
    Recipe.GetItemTypes.Milk(scriptItems.milk)
    Recipe.GetItemTypes.Sugar(scriptItems.sugar)
    Recipe.GetItemTypes.BrokenGlass(scriptItems.brokenGlass)
    Recipe.GetItemTypes.SewingNeedle(scriptItems.sewingNeedle)
    ---@type ScriptManager
    local scriptManager = ScriptManager.instance
    ---@type ArrayList
    local recipes = scriptManager:getAllRecipes()
    print(scriptItems.liquor)
    print(scriptItems.milk)
    print(scriptItems.brokenGlass)
    print(scriptItems.weldingMasks)
	print("DAIKON UNIVERSAL RECIPES DEBUG")
    for i=0, recipes:size() - 1 do
        ---@type Recipe
        local recipe = recipes:get(i)
        --recipeSource is the list of items that can be used to make the recipe
        ---@type ArrayList|Recipe.Source
        local recipeSource = recipe:getSource()
        for j=0, recipeSource:size()-1 do
            if recipeSource:get(j):isKeep() then
                --replace with actual patcher code
                local items = recipe:getName().."\n"
                local recipeItems = recipeSource:get(j):getItems()
                for k=0, recipeItems:size()-1 do
                    items = items.." "..recipeItems:get(k)
                end
                print(items)
            end
        end
    end
end

Events.OnGameBoot.Add(patchRecipes)
return daikon