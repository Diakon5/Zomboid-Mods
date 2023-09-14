local TireUpdateBase = Vehicles.Update.Tire
--Pointless comment
function Vehicles.Update.Tire(vehicle, part, elapsedMinutes)
    if 0 == ZombRand(SandboxVars.DaikonSturdyTires.DurabilityMulti) then
        TireUpdateBase(vehicle, part, elapsedMinutes)
    end
end