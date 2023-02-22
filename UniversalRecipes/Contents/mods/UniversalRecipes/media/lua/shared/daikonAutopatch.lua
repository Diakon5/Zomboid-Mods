local daikon = {
    RecipePatcher = {
    }
}

local function patchRecipes()
    local scriptItems ={
        canOpeners = "[Recipe.GetItemTypes.CanOpener]",
        hammers = "[Recipe.GetItemTypes.Hammer]",
        screwdrivers = "[Recipe.GetItemTypes.Screwdriver]",
        dullKnives = "[Recipe.GetItemTypes.DullKnife]",
        sharpKnives = "[Recipe.GetItemTypes.SharpKnife]",
        scissors = "[Recipe.GetItemTypes.Scissors]",
        weldingMasks = "[Recipe.GetItemTypes.WeldingMask]",
        forks = "[Recipe.GetItemTypes.Fork]",
        disinfectants = "[Recipe.GetItemTypes.Disinfectant]",
        sugar = "[Recipe.GetItemTypes.Sugar]",
        rice = "[Recipe.GetItemTypes.Rice]",
        sewingNeedle = "[Recipe.GetItemTypes.SewingNeedle]",

    }
    ---@type ScriptManager
    local scriptManager = ScriptManager.instance
    ---@type ArrayList
    local recipes = scriptManager:getAllRecipes()
	print("DAIKON UNIVERSAL RECIPES DEBUG")
    print(scriptItems.sharpKnives)
    for i=0, recipes:size() - 1 do
        ---@type Recipe
        local recipe = recipes:get(i)
        --recipeSource is the list of items that can be used to make the recipe
        ---@type ArrayList|Recipe.Source
        local recipeSource = recipe:getSource()
        for j=0, recipeSource:size()-1 do
            if recipeSource:get(j):isKeep() then
                local recipeItems = recipeSource:get(j):getItems()
                if recipeItems:contains("Base.WeldingMask") and recipeItems:size()==1 then
                    recipeSource:remove(j)
                    recipe:DoSource(scriptItems.weldingMasks)
                end
                --replace with actual patcher code
                --[[local items = recipe:getName().."\n"
                local recipeItems = recipeSource:get(j):getItems()
                for k=0, recipeItems:size()-1 do
                    items = items.." "..recipeItems:get(k)
                end
                print(items)]]
            end
        end
    end
end

Events.OnGameBoot.Add(patchRecipes)
return daikon