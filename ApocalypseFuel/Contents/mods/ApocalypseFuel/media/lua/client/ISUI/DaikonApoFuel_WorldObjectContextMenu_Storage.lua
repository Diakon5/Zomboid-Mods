local Daikon = require("DaikonApoFuel_SetupFile")

---@param context ISContextMenu
Daikon.ApocalypseBiofuels.PourIntoBarrelContextMenu = function(playerNum, context, worldobjects, test)
    for k,v in pairs( worldobjects) do
        print(k,v)
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(Daikon.ApocalypseBiofuels.PourIntoBarrelContextMenu)