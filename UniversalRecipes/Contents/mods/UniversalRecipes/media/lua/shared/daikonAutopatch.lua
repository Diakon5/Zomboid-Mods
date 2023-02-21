local daikon = {
    RecipePatcher = {

    }
}
local function patchRecipes()
    ---@type ScriptManager
    local scriptManager = ScriptManager.instance
    ---@type ArrayList
    local recipes = scriptManager:getAllRecipes()
    for i=0, recipes:size() - 1 do
        ---@type Recipe
        local recipe = recipes:get(i)
        --recipeSource is the list of items that can be used to make the recipe
        ---@type Recipe.Source
        local recipeSource = recipe:getSource()
        for j=0, recipeSource:size()-1 do
            local recipeItems = recipeSource:get(j):getItems()
            ---@type string
            local items = recipe:getName()
            for k=0, recipeItems:size()-1 do
                items = items.." "..recipeItems[k]
            end
            print(items)
        end
    end
end
return daikon