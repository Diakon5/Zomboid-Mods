
local MAX_REDUCTION_MULTIPLIER = 5
local oldZombiesInSight = 0

---@param player IsoGameCharacter
local function DPF_SetCachedPanicReductionMult(player)
    local STARTING_HOURS = SandboxVars.DaikonPanicFix.StartingHours or 0
    local ADD_KILLS_MINUTES = SandboxVars.DaikonPanicFix.AddZombieKillsAsMinutes or 0
    ---@type Stats
    local baseGameMultiplier = math.floor(getGameTime():getNightsSurvived() / 30)
    baseGameMultiplier = math.min(baseGameMultiplier,5)

    local playerModData = player:getModData()
    local zombieKillsDifference = playerModData['DaikonPanic_ZombieKillsDifference']
    if zombieKillsDifference == nil then
        playerModData['DaikonPanic_ZombieKillsDifference'] = player:getZombieKills()
        zombieKillsDifference = playerModData['DaikonPanic_ZombieKillsDifference']
    end
    local newMultiplier = (player:getHoursSurvived()+STARTING_HOURS+(player:getZombieKills()-zombieKillsDifference)*ADD_KILLS_MINUTES/60)/ 720
    newMultiplier = math.min(newMultiplier,MAX_REDUCTION_MULTIPLIER)
    if isDebugEnabled() then
        print("Base Game Multiplier:",baseGameMultiplier, "New Multiplier: ", newMultiplier)
    end
    playerModData['DaikonPanic_ActualMultiplier'] = baseGameMultiplier - newMultiplier
end

---@param player IsoPlayer
local function DPF_GetCachedPanicReductionMult(player)
    local panicMult = player:getModData()['DaikonPanic_ActualMultiplier']
    if not panicMult then
        DPF_SetCachedPanicReductionMult(player)
        return player:getModData()['DaikonPanic_ActualMultiplier']
    else
        return panicMult
    end
end


---@param player IsoPlayer
local function DPF_ProperlyFixPanic(player)
    ---@type Stats
    local PlayerStats = player:getStats()
    local curPanic = PlayerStats:getPanic()
    local zombiesInSight = PlayerStats:getNumVisibleZombies()
    if curPanic > 0 and zombiesInSight <= oldZombiesInSight then
        local panicReductionValue = player:getBodyDamage():getPanicReductionValue()
        local newMultiplier = DPF_GetCachedPanicReductionMult(player)
        if curPanic + (newMultiplier*panicReductionValue)<0 then
            PlayerStats:setPanic(0)
        else
            PlayerStats:setPanic(curPanic + (newMultiplier*panicReductionValue)) --Hopefully this is always a negative number, else people will need extra Beta Blockers
        end
    end
    oldZombiesInSight = zombiesInSight
end

Events.OnGameStart.Add(function()
    DPF_SetCachedPanicReductionMult(getPlayer())
end)
Events.EveryDays.Add(function()
    DPF_SetCachedPanicReductionMult(getPlayer())
end)
Events.OnPlayerUpdate.Add(DPF_ProperlyFixPanic)