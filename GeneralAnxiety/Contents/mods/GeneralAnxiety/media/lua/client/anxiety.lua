local moodleThresholds =  {}
local stressGenMultipliers =  {}

local function split(s, sep) --I just copied this from UdderlyEvelyn because I don't understand pattern matching
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(s, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function DGA_Failsafe_Defaults()
    stressGenMultipliers["Hungry"] = 4
    stressGenMultipliers["Thirst"] = 4
    stressGenMultipliers["Bleeding"] = 20
    stressGenMultipliers["Pain"] = 4
    stressGenMultipliers["Injured"] = 6
    stressGenMultipliers["Sick"] = 2
    stressGenMultipliers["Drunk"] = -10
    stressGenMultipliers["Hypothermia"] = 1
    stressGenMultipliers["Hyperthermia"] = 1
    stressGenMultipliers["FoodEaten"] = -2
    stressGenMultipliers["Wet"] = 1
    stressGenMultipliers["Panic"] = 4

    moodleThresholds["Hungry"] = 2
    moodleThresholds["Thirst"] = 2
    moodleThresholds["Bleeding"] = 1
    moodleThresholds["Pain"] = 1
    moodleThresholds["Injured"] = 2
    moodleThresholds["Sick"] = 2
    moodleThresholds["Drunk"] = 1
    moodleThresholds["Hypothermia"] = 2
    moodleThresholds["Hyperthermia"] = 2
    moodleThresholds["FoodEaten"] = 1
    moodleThresholds["Wet"] = 2
    moodleThresholds["Panic"] = 2
end

local function DGA_Init()
    local sandboxSettings = SandboxVars.DaikonGeneralAnxiety.MoodleList
    if sandboxSettings ~= nil then
        local BUILDUP_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.GlobalBuildupMultiplier or 1
        local REDUCTION_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.GlobalReductionMultiplier or 1
        for _, item in ipairs(split(sandboxSettings,";")) do --This gives an array of strings that should be like "Moodle=Lvl:Mult"

            if (string.find(item, "@") or string.find(item, "=")) and string.find(item, ":") then
                local keyAndValues = split(item,"@")
                if string.find(item, "=") then
                    keyAndValues = split(item, "=")
                end
                 --An array that should have "Moodle" at 1, then "Lvl:Mult" at 2
                local values = split(keyAndValues[2],":") --An array that should have "Lvl" at 1, then "Mult" at 2

                if isDebugEnabled() and false then
                    print("Item:",item)
                    print("Key:",keyAndValues[1],"Values:",keyAndValues[2])
                    print("Value 1:",values[1],"Value 2:",values[2])
                end
                moodleThresholds[keyAndValues[1]] = tonumber(values[1])
                if tonumber(values[2])>0 then
                    stressGenMultipliers[keyAndValues[1]] = tonumber(values[2])* BUILDUP_MULTIPLIER
                else
                    stressGenMultipliers[keyAndValues[1]] = tonumber(values[2]) * REDUCTION_MULTIPLIER
                end
            end
        end
        --print("GENERAL ANXIETY: SETUP COMPLETE, STANDARD")
    else
        DGA_Failsafe_Defaults()
        --print("GENERAL ANXIETY: SETUP COMPLETE, FAILSAFE")
    end
    --if isDebugEnabled() then
    --    for k in pairs(moodleThresholds) do
    --        print(k,moodleThresholds[k],stressGenMultipliers[k])
    --    end
    --end
end


---@param player IsoPlayer
local function DGA_extraAnxiety(player)
    DGA_Init()
    local baseStressIncrease = 0.001 * getGameTime():getMultiplier()
    ---@type Stats
    local stats = player:getStats()
    ---@type Moodles
    local moodles = player:getMoodles()
    local LEVEL_BUILDUP_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.LeveledBuildupMultiplier or 1
    local LEVEL_REDUCTION_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.LeveledReductionMultiplier or 1
    local totalStressMult = 0
    for k in pairs(moodleThresholds) do
        local moodleLevel = moodles:getMoodleLevel(MoodleType[k])
        if moodleThresholds[k] <= moodleLevel then
            if stressGenMultipliers[k]>0 then
                totalStressMult = totalStressMult + (stressGenMultipliers[k] * (1 + (moodleLevel - moodleThresholds[k]) * LEVEL_BUILDUP_MULTIPLIER))
            else
                totalStressMult = totalStressMult + (stressGenMultipliers[k] * (1 + (moodleLevel - moodleThresholds[k]) * LEVEL_REDUCTION_MULTIPLIER))
            end
        end
    end

	if totalStressMult ~= 0 then
		stats:setStress(math.min(math.max(stats:getStress()+totalStressMult*baseStressIncrease,0),1)) -- This clamps the stress in values between 0 and 1
        if isDebugEnabled() then
            print("Stress multiplier:",totalStressMult, "Stress change: ",totalStressMult*baseStressIncrease)
        end
	end
    if getActivatedMods():contains("daikonGeneralAnxietyMoodleFramework") then
        daikonGeneralAnxiety.DGA_extraAnxietyMoodleFramework(player)
    end
end

--Events.OnPlayerUpdate.Add(DGA_extraAnxiety)
Events.EveryOneMinute.Add(function()
    DGA_extraAnxiety(getPlayer())
end)