local function addExistingItemType(scriptItems, type)
    local all = getScriptManager():getItemsByType(type)
    for i=1,all:size() do
        local scriptItem = all:get(i-1)
        if not scriptItems:contains(scriptItem) then
            scriptItems:add(scriptItem)
        end
    end
end

function Recipe.OnTest.CheckIfPotIsCooked(item)

end
function Recipe.OnCreate.SaveNutritionInResult(items, result, player)
    local finalvalue = {}
    for i=0,items:size() - 1 do
        local item = items:get(i)
        if item and instanceof(item,"Food") then
            finalvalue["Thirst"] = (finalvalue["Thirst"] or 0) + item:getThirstChange()
            finalvalue["Carbohydrates"] =  (finalvalue["Carbohydrates"] or 0) + item:getCarbohydrates()
            finalvalue["Lipids"] = (finalvalue["Lipids"] or 0) + item:getLipids()
            finalvalue["Proteins"] = (finalvalue["Proteins"] or 0) + item:getProteins()
            finalvalue["Calories"] = (finalvalue["Calories"] or 0) + item:getCalories()
        end
    end
    result:setThirstChange(finalvalue["Thirst"])
    result:setCarbohydrates(finalvalue["Carbohydrates"])
    result:setLipids(finalvalue["Lipids"])
    result:setProteins(finalvalue["Proteins"])
    result:setCalories(finalvalue["Calories"])
end

function Recipe.GetItemTypes.Bucket(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("Bucket"))
    addExistingItemType(scriptItems, "BucketEmpty")
    addExistingItemType(scriptItems, "PaintbucketEmpty")
end


function Recipe.OnCreate.RememberTheBucketAndRopeUsed(items, result, player)
    Recipe.OnCreate.RememberTheRopeUsed(items, result, player)
    local usedBucket
    for i = 0, items:size() - 1 do
        local item = items:get(i);
        if item then
            local itemType = item:getFullType();
            if string.find(itemType, "[bB]ucket") then
                usedBucket = itemType
            end;
        end;
    end;
    result:getModData().bucketType = usedBucket;
end

function Recipe.OnCreate.RememberTheRopeUsed(items, result, player)
    local ropes = getScriptManager():getItemsTag("Rope")
    local ropeItem
    for i = 0, items:size() - 1 do
        local item = items:get(i);
        if item then
            local itemType = item:getFullType();
            if ropes:contains(itemType) then
                ropeItem = itemType
            end;
        end;
    end;
    result:getModData().ropeItem = ropeItem;
end

function Recipe.OnCreate.PrepareForDistilling(items,result,player)
    for i = 0, items:size() - 1 do
        ---@type InventoryItem
        local item = items:get(i)
        if item then
            if item:getType() == "Saucepan" then
                result:setCondition(item:getCondition())
            end
            if string.find(item:getType(),"FermentedMash",1,true) then
                player:getInventory():AddItem(item:getModData().ropeItems or "Base.Rope")
                player:getInventory():AddItem("Base.Sheet")
                if string.find(item:getType(),"Bucket",1,true) then
                    player:getInventory():AddItem(item:getModData().bucketType or "Base.BucketEmpty")
                end
            end
        end
    end

end