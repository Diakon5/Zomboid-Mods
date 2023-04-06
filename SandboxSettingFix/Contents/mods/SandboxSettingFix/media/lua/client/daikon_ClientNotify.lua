local Daikon = require("daikon_WrapperToMakeTheSettingsIG")

Daikon.SandboxOptionsSyncing.DownloadSettingsInitial = function ()
    Daikon.SandboxOptionsSyncing.DownloadSettings()
    Events.OnPlayerUpdate.Remove(Daikon.SandboxOptionsSyncing.DownloadSettings)
end

Daikon.SandboxOptionsSyncing.AnticheatlessSync = function()
    if isClient() then -- Check if it's running in MP or SP (Returns true in MP and false in SP)
        sendClientCommand("SandboxOptionsSyncing", "SyncTheSettingsAnticheat", {});
    end
end

Daikon.SandboxOptionsSyncing.DownloadSettings = function ()
    ModData.request("UdderlyDaikonSandboxSyncFix")
end
Daikon.SandboxOptionsSyncing.SyncSettings = function(tableName, options)
    if tableName ~= "UdderlyDaikonSandboxSyncFix" then
        return
    end
    print("Syncing the sandbox options")    --code for loading Sandbox options from Mod Data by Udderly Evelyn
    local currentOptions = SandboxOptions.getInstance()
    if options ~= nil then
        for key,value in pairs(options) do
            ---@type SandboxOptions.SandboxOption
            local option = currentOptions:getOptionByName(key)
            if option ~= nil then
                option:asConfigOption():parse(value)
                print("Updated Sandbox Value: "..key.." -> "..value)
            end
        end
        print("Finished syncing the options")
        currentOptions:toLua()
    else
        print("No sandbox options to sync yet")
    end
end


Events.OnPlayerUpdate.Add(Daikon.SandboxOptionsSyncing.DownloadSettingsInitial)
--Events.OnPlayerUpdate.Add(Daikon.SandboxOptionsSyncing.AnticheatlessSync)
--Events.OnReceiveGlobalModData.Add(Daikon.SandboxOptionsSyncing.SyncSettings)
return Daikon ---> REMEMBER THIS NEEDS TO BE AT THE END OF THE FILE