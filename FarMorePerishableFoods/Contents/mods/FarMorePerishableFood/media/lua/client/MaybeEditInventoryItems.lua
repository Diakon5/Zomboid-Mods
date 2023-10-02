local Daikon = require("AutomaticFoodAdjuster")

local funcCache = {}

funcCache.InventoryItem = __classmetatables[InventoryItem.class].__index
funcCache.InventoryItem_getScriptItem = funcCache.InventoryItem.getScriptItem
funcCache.InventoryItem_getOffAge = funcCache.InventoryItem.getOffAge
funcCache.InventoryItem_getOffAgeMax = funcCache.InventoryItem.getOffAgeMax
funcCache.InventoryItem_setOffAge = funcCache.InventoryItem.setOffAge
funcCache.InventoryItem_setOffAgeMax = funcCache.InventoryItem.setOffAgeMax
funcCache.InventoryItem_setAge = funcCache.InventoryItem.setAge

funcCache.ScriptItem = __classmetatables[Item.class].__index
funcCache.ScriptItem_getDaysTotallyRotten = funcCache.ScriptItem.getDaysTotallyRotten
funcCache.ScriptItem_getDaysFresh = funcCache.ScriptItem.getDaysFresh
funcCache.ScriptItem_getType = funcCache.ScriptItem.getType

funcCache.ItemContainer = __classmetatables[ItemContainer.class].__index
funcCache.ItemContainer_getItems = funcCache.ItemContainer.getItems
funcCache.ItemContainer_getType = funcCache.ItemContainer.getType

funcCache.ArrayList_base   = __classmetatables[ArrayList.class].__index
funcCache.ArrayList_size   = funcCache.ArrayList_base.size
funcCache.ArrayList_get    = funcCache.ArrayList_base.get

---@param inventoryPage ISInventoryPage
Daikon.MoreSpoilingFoods.TheRottingGaze = function(inventoryPage,state)
    if state ~= "buttonsAdded" or not SandboxVars.DaikonMorePerishables.BackwardsCompat then
        return
    end

    for i = 1, #inventoryPage.backpacks do
        ---@type ItemContainer
        local invToPatch = inventoryPage.backpacks[i].inventory
        ---@type ArrayList|InventoryItem
        local items = funcCache.ItemContainer_getItems(invToPatch)
        for j = 0, funcCache.ArrayList_size(items)-1 do
            local item = funcCache.ArrayList_get(items,j)
            local scriptItem = funcCache.InventoryItem_getScriptItem(item)
            if funcCache.InventoryItem_getOffAge(item) ~= funcCache.ScriptItem_getDaysFresh(scriptItem) or funcCache.InventoryItem_getOffAgeMax(item) ~= funcCache.ScriptItem_getDaysTotallyRotten(scriptItem) then
                funcCache.InventoryItem_setOffAge(item,funcCache.ScriptItem_getDaysFresh(scriptItem))
                funcCache.InventoryItem_setOffAgeMax(item,funcCache.ScriptItem_getDaysTotallyRotten(scriptItem))
                funcCache.InventoryItem_setAge(item,0)
                if isDebugEnabled() or SandboxVars.DaikonMorePerishables.Debug then
                    print("Updated Item: "..item:getName().." In container "..invToPatch:getType())
                end
            end
        end
    end
end

Events.OnRefreshInventoryWindowContainers.Add(Daikon.MoreSpoilingFoods.TheRottingGaze)

