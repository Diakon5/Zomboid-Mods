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
                if instanceof(fuelItem,"DrainableComboItem") and fuelItem:getDelta()<1 then
                    table.insert(eligibleFuelItems,fuelItem)
                    print(fuelItem:getType(), "ValidFuelItem")
                else
                    table.insert(eligibleFuelItems,fuelItem)
                    print(fuelItem:getType(), "ValidEmptyFuelItem")
                end
            end
        end
        if #eligibleFuelItems >0 then
            local subMenuOption = context:addOption(getText("ContextMenu_Pour_into"), items, nil);
            local subMenu = context:getNew(context)
            --adding the submenu?
            context:addSubMenu(subMenuOption, subMenu)
        end
    end

    --TODO Write a check to see if item holds ethanol
    --Checks if... And if the selected item is a water container
    --[[
            --if there are any containers
            if #pourInto > 0 then
                --subMenu
                local subMenuOption = context:addOption(getText("ContextMenu_Pour_into"), items, nil);
                local subMenu = context:getNew(context)
                --adding the submenu?
                context:addSubMenu(subMenuOption, subMenu)
                for _,item in ipairs(pourInto) do
                    --check if item is a partially filled item to create the other item's tooltip. Then move to a different function
                    if instanceof(item, "DrainableComboItem") then
                        local subOption = subMenu:addOption(item:getName(), items, ISInventoryPaneContextMenu.onTransferWater, waterContainer, item, player);
                        local tooltip = ISInventoryPaneContextMenu.addToolTip()
                        local tx = getTextManager():MeasureStringX(tooltip.font, getText("ContextMenu_WaterName") .. ":") + 20
                        tooltip.description = string.format("%s: <SETX:%d> %d / %d",
                                getText("ContextMenu_WaterName"), tx, item:getDrainableUsesInt(), 1.0 / item:getUseDelta() + 0.0001)
                        subOption.toolTip = tooltip
                    else
                        subMenu:addOption(item:getName(), items, ISInventoryPaneContextMenu.onTransferWater, waterContainer, item, player);
                    end
                end
            end

            context:addOption(getText("ContextMenu_Pour_on_Ground"), items, ISInventoryPaneContextMenu.onEmptyWaterContainer, waterContainer, player);
       end
       --]]
end

Events.OnFillInventoryObjectContextMenu.Add(Daikon.ApocalypseBiofuels.PourEthanolContextMenu)
return Daikon