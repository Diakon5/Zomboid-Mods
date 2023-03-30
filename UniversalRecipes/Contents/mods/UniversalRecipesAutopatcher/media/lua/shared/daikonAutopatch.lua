local daikon = {
    RecipePatcher = {
    }
}
local function patchRecipes()
    print("DAIKON UNIVERSAL RECIPES DEBUG")

    local function AnyKnifeProxy(scriptItems)
        Recipe.GetItemTypes.DullKnife(scriptItems)
        Recipe.GetItemTypes.SharpKnife(scriptItems)
    end

    local functionsArray = {
        [1022596018] = Recipe.GetItemTypes.CanOpener,
        [-884711072] = Recipe.GetItemTypes.Hammer,
        [788285950] = Recipe.GetItemTypes.Screwdriver,
        dullKnives = Recipe.GetItemTypes.DullKnife,
        [76907929] = Recipe.GetItemTypes.SharpKnife,
        [2060122845] = Recipe.GetItemTypes.SharpKnife,
        [752552627] = Recipe.GetItemTypes.Scissors,
        [-1250468118] = Recipe.GetItemTypes.WeldingMask,
        forks = Recipe.GetItemTypes.Fork,
        disinfectants = Recipe.GetItemTypes.Disinfectant,
        sugar = Recipe.GetItemTypes.Sugar,
        rice = Recipe.GetItemTypes.Rice,
        [-1785340309] = Recipe.GetItemTypes.SewingNeedle,
        anyKnife = AnyKnifeProxy,
        [1673755447] = AnyKnifeProxy,
    }
    local itemsArray = {}
    for k in pairs(functionsArray) do
        if type(functionsArray[k]) == "function" then
            itemsArray[k] = ArrayList.new()
            functionsArray[k](itemsArray[k])
            --print(itemsArray[k])
            for i=0, itemsArray[k]:size()-1 do
                local itemFullType = itemsArray[k]:get(i):getFullName()
                itemsArray[k]:set(i,itemFullType)
                --print(itemFullType)
            end
            --print(itemsArray[k])
        end
    end
    ---@type ScriptManager
    local scriptManager = ScriptManager.instance
    ---@type ArrayList
    local recipes = scriptManager:getAllRecipes()

    for i=0, recipes:size() - 1 do
        ---@type Recipe
        local recipe = recipes:get(i)
        --recipeSource is the list of items that can be used to make the recipe
        ---@type ArrayList|Recipe.Source
        local recipeSource = recipe:getSource()
        for j=0, recipeSource:size()-1 do
            local sourceItems = recipeSource:get(j):getItems()
            if recipeSource:get(j):isKeep() then
                local items = itemsArray[sourceItems:hashCode()] or "none"
                if items ~= "none" then
                    local didSomething = false
                    for k=0, items:size()-1 do
                        if sourceItems:indexOf(items:get(k))==-1 then
                            sourceItems:add(items:get(k))
                            didSomething = true
                        end
                    end
                    if didSomething then
                        print("Patched Recipe "..recipe:getName())
                        print(sourceItems)
                        print(recipeSource:get(j):getItems())
                    end

                end
                --[[local recipeItems = recipeSource:get(j):getItems()
                if recipeItems:contains("Base.WeldingMask") and recipeItems:size()==1 then
                    recipeSource:remove(j)
                    recipe:DoSource("keep ".. scriptItems.weldingMasks)
                    print("Patched Recipe "..recipe:getName())
                end]]
                --[[print(recipe:getName())
                --print(recipeItems)
                --print(recipeItems:hashCode())]]
            end
        end
    end
end

Events.OnInitGlobalModData.Add(patchRecipes)
return daikon