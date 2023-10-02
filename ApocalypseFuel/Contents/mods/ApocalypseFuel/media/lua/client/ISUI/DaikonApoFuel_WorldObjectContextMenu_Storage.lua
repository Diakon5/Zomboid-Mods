local Daikon = require("DaikonApoFuel_SetupFile")

---@param context ISContextMenu
---@param worldObjects table
Daikon.ApocalypseBiofuels.PourIntoBarrelContextMenu = function(playerNum, context, worldObjects, test)
    for k,v in pairs(worldObjects) do
        ---@type IsoObject
        local object = v
        local properties = object:getProperties()
        for i=0, properties:getPropertyNames():size()-1 do
            print(properties:getPropertyNames():get(i))
        end
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(Daikon.ApocalypseBiofuels.PourIntoBarrelContextMenu)