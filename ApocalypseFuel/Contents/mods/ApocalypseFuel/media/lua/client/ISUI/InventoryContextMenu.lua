local Daikon = Daikon or {}
local ApocalypseBiofuels = Daikon.ApocalypseBiofuels or {}
Daikon.ApocalypseBiofuels.PourEthanolContextMenu = function(player, context, items)
    ---@type IsoGameCharacter
    player = getSpecificPlayer(player)
    --TODO Write a check to see if item holds ethanol
    --Checks if... And if the selected item is a water container
    if c == 1 and waterContainer ~= nil then
        --Iterates over player inventory to find other items that can be poured into
        for i = 0, getSpecificPlayer(player):getInventory():getItems():size() -1 do
            local item = getSpecificPlayer(player):getInventory():getItems():get(i);
            --empty containers
            if item ~= waterContainer and item:canStoreWater() and not item:isWaterSource() then
                table.insert(pourInto, item)
            --partially full containers
            elseif item ~= waterContainer and item:canStoreWater() and item:isWaterSource() and instanceof(item, "DrainableComboItem") and (1 - item:getUsedDelta()) >= item:getUseDelta() then
                table.insert(pourInto, item)
            end
        end
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
end







Events.OnFillInventoryObjectContextMenu.Add(Daikon.ApocalypseBiofuels.PourEthanolContextMenu)