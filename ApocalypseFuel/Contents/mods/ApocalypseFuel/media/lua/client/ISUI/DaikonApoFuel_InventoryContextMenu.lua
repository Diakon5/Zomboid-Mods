local Daikon = require("DaikonApoFuel_SetupFile")

---@param context ISContextMenu
Daikon.ApocalypseBiofuels.PourEthanolContextMenu = function(player, context, items)
    print(#items)
    ---@type IsoGameCharacter
    player = getSpecificPlayer(player)
    local ethanolItem
    for _, v in ipairs(items) do
        ---@type InventoryItem
        ethanolItem= v
        if not instanceof(v, "InventoryItem") then ethanolItem = v.items[1] end
        --print(ethanolItem)
    end
    if ethanolItem:hasTag("ApoFuelEthanol") and ethanolItem:getDelta()>0 then
        ---@type InventoryContainer
        local inventory = player:getInventory()
        local eligibleFuelItems = {}
        local fuelItemsFull = inventory:getAllTag("ApoFuelEthanol",ArrayList.new())
        fuelItemsFull = inventory:getAllTag("ApoFuelEmptyEthanol",fuelItemsFull)
        for i=0,fuelItemsFull:size()-1 do
            ---@type InventoryItem
            local fuelItem = fuelItemsFull:get(i)
            if fuelItem ~= ethanolItem then
                if instanceof(fuelItem,"DrainableComboItem") then
                    --Had to nest here, otherwise full drainables would get caught by the else condition
                    if fuelItem:getDelta()<1 then
                        table.insert(eligibleFuelItems,fuelItem)
                    end

                    --print(fuelItem:getType(), " ValidFuelItem with "..fuelItem:getDelta())
                else
                    table.insert(eligibleFuelItems,fuelItem)
                    --print(fuelItem:getType(), "ValidEmptyFuelItem")
                end
            end
        end
        if #eligibleFuelItems > 0 then
            local subMenuOption = context:addOption(getText("ContextMenu_Pour_into"), items, nil);
            local subMenu = context:getNew(context)
            --adding the submenu?
            context:addSubMenu(subMenuOption, subMenu)
            for _,item in ipairs(eligibleFuelItems) do
                --check if item is a partially filled item to create the other item's tooltip. Then move to a different function
                if instanceof(item, "DrainableComboItem") then
                    local subOption = subMenu:addOption(item:getName(), items, Daikon.ApocalypseBiofuels.OnPourEthanol, ethanolItem, item, player, true);
                    local tooltip = ISInventoryPaneContextMenu.addToolTip()
                    local tx = getTextManager():MeasureStringX(tooltip.font, getText("ContextMenu_EthanolName") .. ":") + 20
                    tooltip.description = string.format("%s: <SETX:%d> %d / %d",
                            getText("ContextMenu_EthanolName"), tx, item:getDrainableUsesInt(), 1.0 / item:getUseDelta() + 0.0001)
                    subOption.toolTip = tooltip
                else
                    subMenu:addOption(item:getName(), items, Daikon.ApocalypseBiofuels.OnPourEthanol, ethanolItem, item, player, false);
                end
            end
        end
    end
end

--This function prepares items to pour
Daikon.ApocalypseBiofuels.OnPourEthanol = function(items, itemFrom, itemTo, player, isAlreadyDrainable)
    --print("Moving water from " .. itemFrom:getName() .. " to " .. itemTo:getName());
    if not isAlreadyDrainable then
        local newItemType = itemTo:getReplaceType("EthanolSource");
        local newItem = InventoryItemFactory.CreateItem(newItemType,0);
        newItem:setFavorite(itemTo:isFavorite());
        newItem:setCondition(itemTo:getCondition());
        player:getInventory():AddItem(newItem);
        if player:getPrimaryHandItem() == itemTo then
            player:setPrimaryHandItem(newItem)
        end
        if player:getSecondaryHandItem() == itemTo then
            player:setSecondaryHandItem(newItem)
        end
        player:getInventory():Remove(itemTo);

        itemTo = newItem;
    end
    --
    local waterStorageAvailable = (1 - itemTo:getUsedDelta()) / itemTo:getUseDelta();
    local waterStorageNeeded = itemFrom:getUsedDelta() / itemFrom:getUseDelta();

    local itemFromEndingDelta = 0;
    local itemToEndingDelta = nil;
    --
    if waterStorageAvailable >= waterStorageNeeded then
        --Transfer all water to the the second container.
        local waterInA = itemTo:getUsedDelta() / itemTo:getUseDelta();
        local waterInB = itemFrom:getUsedDelta() / itemFrom:getUseDelta();
        local totalWater = waterInA + waterInB;

        itemToEndingDelta = totalWater * itemTo:getUseDelta();
        itemFromEndingDelta = 0;
    end

    if waterStorageAvailable < waterStorageNeeded then
        --Transfer what we can. Leave the rest in the container.
        local waterInB = itemFrom:getUsedDelta() / itemFrom:getUseDelta();
        local waterRemainInB = waterInB - waterStorageAvailable;

        itemFromEndingDelta = waterRemainInB * itemFrom:getUseDelta();
        itemToEndingDelta = 1;
    end

    ISInventoryPaneContextMenu.transferIfNeeded(player, itemFrom)

    ISTimedActionQueue.add(ISTransferWaterAction:new(player, itemFrom, itemTo, itemFromEndingDelta, itemToEndingDelta));
end



Events.OnFillInventoryObjectContextMenu.Add(Daikon.ApocalypseBiofuels.PourEthanolContextMenu)
return Daikon