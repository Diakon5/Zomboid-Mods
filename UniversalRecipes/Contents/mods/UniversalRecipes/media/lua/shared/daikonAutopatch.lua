local daikon = {
    RecipePatcher = {

    }
}
local function patchRecipes()
    ---@type ScriptManager
    local scriptManager = ScriptManager.instance
    ---@type ArrayList
    local recipes = scriptManager:getAllRecipes()
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