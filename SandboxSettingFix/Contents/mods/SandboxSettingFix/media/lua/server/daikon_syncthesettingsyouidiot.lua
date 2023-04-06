local Daikon = require("daikon_WrapperToMakeTheSettingsIG")

Daikon.SandboxOptionsSyncing.UpdateGlobalModData = function()
    if isServer() then --code for putting Sandbox options to Mod Data by Udderly Evelyn
        print("Uploading the sandbox options to Global mod data")
        local options = {}
        local sandboxOptions =  getSandboxOptions()
        local count = sandboxOptions:getNumOptions()
        for i=0,count-1 do
            local option = sandboxOptions:getOptionByIndex(i)
            local tableName = option:getTableName()
            local name = option:getShortName()
            local fullName = tostring(tableName).."."..tostring(name)
            if tableName == nil then
                fullName = tostring(name)
            end
            local co = option:asConfigOption()
            local value = "nil"
            if co ~= nil then
                value = co:getValueAsLuaString()
            end
            options[fullName] = value
            print("Updated Global Sandbox Value: "..fullName.." -> "..value)
        end
        local modData = ModData.getOrCreate("UdderlyDaikonSandboxSyncFix")
        for k,v in pairs(options) do
            modData[k] = v
        end
    end
end

Daikon.SandboxOptionsSyncing.ForceClientsToUpdate = function ()
    ModData.transmit("UdderlyDaikonSandboxSyncFix")
end

local onClientCommand = function(module, command, player, args)
    if Daikon[module] and Daikon[module][command] then
        Daikon[module][command](player, args)
    end
end


if isServer() then
    Events.OnInitGlobalModData.Add(Daikon.SandboxOptionsSyncing.UpdateGlobalModData)
    Events.OnClientCommand.Add(onClientCommand)
end
return Daikon