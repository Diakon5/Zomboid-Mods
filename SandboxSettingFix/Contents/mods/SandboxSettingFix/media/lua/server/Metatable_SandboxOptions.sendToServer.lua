local Daikon = require("daikon_WrapperToMakeTheSettingsIG")

local metatable = __classmetatables[SandboxOptions.class].__index
local old_SendToServer = metatable.sendToServer
function metatable.sendToServer(self, item)
    if isServer() then
        Daikon.SandboxOptionsSyncing.UpdateGlobalModData()
        Daikon.SandboxOptionsSyncing.ForceClientsToUpdate()
    end
    if isClient() then
        Daikon.Commands["RefreshModData"]("")
    end
    old_SendToServer(self, item)
end