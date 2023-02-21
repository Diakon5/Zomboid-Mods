require "MF_ISMoodle"
daikonGeneralAnxiety = {}
local moodleThresholds = {}
local stressGenMultipliers = {}

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

local function DGA_MoodleFrameworkInit()
    local sandboxSettings = SandboxVars.DaikonGeneralAnxiety.MoodleListMoodleFramework
    if sandboxSettings ~= nil then
        local BUILDUP_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.GlobalBuildupMultiplier or 1
        local REDUCTION_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.GlobalReductionMultiplier or 1
        for _, item in ipairs(split(sandboxSettings,";")) do --This gives an array of strings that should be like "Moodle=Lvl:Mult"

            if string.find(item, "@") and string.find(item, ":") then
                local keyAndValues = split(item,"@") --An array that should have "Moodle" at 1, then "Lvl:Mult" at 2

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
    end
    if isDebugEnabled() and moodleThresholds ~=nil then
        for k in pairs(moodleThresholds) do
            print(k,moodleThresholds[k],stressGenMultipliers[k])
        end
    end
end


---@param player IsoPlayer
function daikonGeneralAnxiety.DGA_extraAnxietyMoodleFramework(player)
    DGA_MoodleFrameworkInit()
    local baseStressIncrease = 0.001 * getGameTime():getMultiplier()
    ---@type Stats
    local stats = player:getStats()
    ---@type Moodles
    local LEVEL_BUILDUP_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.LeveledBuildupMultiplier or 1
    local LEVEL_REDUCTION_MULTIPLIER = SandboxVars.DaikonGeneralAnxiety.LeveledReductionMultiplier or 1
    local totalStressMult = 0
    for k in pairs(moodleThresholds) do
        local moodleLevel = MF.getMoodle(k):getLevel()
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
	end
    if isDebugEnabled() then
        print("Stress multiplier Moodle Framework:",totalStressMult, "Stress change: ",totalStressMult*baseStressIncrease)
    end
end