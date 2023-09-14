--[[
it will need to:

    have a blacklist  DONE

    have an override so that certain items can be tuned   DONE

    preferably have a way to detect different types of items, e.g.,
    detect "can" in the name and target them differently (or maybe detect the opening recipe?)
    so they can be adjusted differently
]]
local function split(s, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(s, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

local Daikon = Daikon or {}
Daikon.MoreSpoilingFoods =  Daikon.MoreSpoilingFoods or {}
Daikon.MoreSpoilingFoods.Blacklist = {}
Daikon.MoreSpoilingFoods.OverrideList = {}
local debug = false

Daikon.MoreSpoilingFoods.LoadSandboxTables = function()
	--Filling the Blacklist from SandboxVars
	for _,item in ipairs(split(SandboxVars.DaikonMorePerishables.Blacklist,";")) do
		Daikon.MoreSpoilingFoods.Blacklist[item] = true
		if isDebugEnabled() then
			print(item.." Added to Blacklist")
		end
	end
	--Adding extra entries to the blacklist manually
	Daikon.MoreSpoilingFoods.Blacklist["Base.Honey"] = true
	Daikon.MoreSpoilingFoods.Blacklist["Base.Bleach"] = true
	--Filling the Manual Override List
	for _, item in ipairs(split(SandboxVars.DaikonMorePerishables.OverrideList,";")) do --This gives an array of strings that should be like "Food@Frs:Rot"
		if string.find(item, "@") and string.find(item, ":") then
			local keyAndValues = split(item,"@")
			--An array that should have "Food" at 1, then "Frs:Rot" at 2
			local values = split(keyAndValues[2],":") --An array that should have "Frs" at 1, then "Rot" at 2

			if isDebugEnabled() and false then
				print("Item:",item)
				print("Key:",keyAndValues[1],"Values:",keyAndValues[2])
				print("Value 1:",values[1],"Value 2:",values[2])
			end
			Daikon.MoreSpoilingFoods.OverrideList[keyAndValues[1]] = {tonumber(values[1]),tonumber(values[2])}
		end
	end
	--Setting the debug variable
	debug = SandboxVars.DaikonMorePerishables.Debug
end

local reflectionMap
Daikon.MoreSpoilingFoods.AdjustFoodsMainLoop =  function()
	if isDebugEnabled() or debug then
		print("AdjustedNonPerishableFoodsBeHere")
	end
	local scriptManager = ScriptManager.instance
	local foodItems = scriptManager:getAllItems()
	for i=0, foodItems:size() - 1 do
		---@type Item
		local item = foodItems:get(i)
		--For script items, Type is the subclass of the result item
		if item:getTypeString() == "Food" then
			if reflectionMap == nil then
				Daikon.MoreSpoilingFoods.FillReflectionMapForScriptItem(item)
			end
			local daysFresh = item:getDaysFresh()
			local daysTotallyRotten = item:getDaysTotallyRotten()
			if isDebugEnabled()  or debug then
				print("Item "..item:getName().." Days Fresh: ".. daysFresh .."; Days to Rot: ".. daysTotallyRotten)
			end
			--getDaysFresh seems to return 1000000000 for unspoilable items. Same for getDaysTotallyRotten
			--if the Item is on the Override list, we allow it in even if it isn't perishable
			if daysFresh == 1000000000 or daysTotallyRotten == 1000000000 or Daikon.MoreSpoilingFoods.OverrideList[item:getFullName()] then
				Daikon.MoreSpoilingFoods.AdjustNonPerishableFood(item)
			end

		end
	end
end

--We adjust a singular class, so we can make an index map of the class fields for use later
Daikon.MoreSpoilingFoods.FillReflectionMapForScriptItem = function (scriptItem)
	reflectionMap = {}
	local num = getNumClassFields(scriptItem)
	for i=0, num-1 do
		local field = getClassField(scriptItem, i)
		reflectionMap[tostring(field)] = i
		if isDebugEnabled() or debug  then
			print(tostring(field), i)
		end

	end
end

---@param foodItem Item
Daikon.MoreSpoilingFoods.isLikelyFakeFood = function(foodItem)
	foodItem = foodItem:InstanceItem(nil)
	if foodItem:getHungerChange() == 0 and foodItem:getThirstChange() == 0 and foodItem:getCalories() == 0 and foodItem:getCarbohydrates() == 0 and foodItem:getLipids() == 0 and foodItem:getProteins() == 0 then
		return true
	end
	return false
end


local function WrapSetDaysFreshRot(item,daysFresh,daysRotten)
	if daysFresh > daysRotten then
		daysRotten = daysFresh +1
	end
	item:setDaysFresh(daysFresh)
	item:setDaysTotallyRotten(daysRotten)
end
--Separate function so that it's possible to return to cancel the chain early, due to a lack of "break" keyword in Lua
---@param food Item
Daikon.MoreSpoilingFoods.AdjustNonPerishableFood = function(food)

	local daysFresh,daysTotallyRotten
	--getFullName returns the item with its module, important with mods. Since it's a script item We use Name, not Type
	local foodType = food:getFullName()
	--Blacklist, both Sandbox and hard-coded
	if Daikon.MoreSpoilingFoods.Blacklist[foodType] then
		if isDebugEnabled() or debug  then
			print(foodType.." is Blacklisted, Skipping...")
		end
		return
	end
	--Manual Override list.
	if Daikon.MoreSpoilingFoods.OverrideList[foodType] then
		daysFresh = Daikon.MoreSpoilingFoods.OverrideList[foodType][1]
		daysTotallyRotten = Daikon.MoreSpoilingFoods.OverrideList[foodType][2]
		WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
		if isDebugEnabled() or debug  then
			print(foodType.." is on an OverrideList, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
		end
		return
	end
	--Some items are coded as food so they can be cooked or eaten, but have no nutritional values, don't wanna touch those usually, so below Override
	if Daikon.MoreSpoilingFoods.isLikelyFakeFood(food) then
		if isDebugEnabled() or debug  then
			print(foodType.." is likely not a food, Skipping...")
		end
		return
	end
	--The chain to read a single value not exposed by Lua. We check if the canned food variable is set
	if getClassFieldVal(food,getClassField(food,reflectionMap["public boolean zombie.scripting.objects.Item.CannedFood"])) == true then
		--Canned Food
		daysFresh = SandboxVars.DaikonMorePerishables.CannedFoodFreshDays
		daysTotallyRotten = SandboxVars.DaikonMorePerishables.CannedFoodRotDays
		WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
		if isDebugEnabled() or debug  then
			print(foodType.." is a Canned Food, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
		end
		return
	end
	--Alcohols
	if food:isAlcoholic() then
		--High Alcohols
		if not food:getTags():contains("LowAlcohol") then
			daysFresh = SandboxVars.DaikonMorePerishables.HighAlcoholFreshDays
			daysTotallyRotten = SandboxVars.DaikonMorePerishables.HighAlcoholRotDays
			WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
			if isDebugEnabled() or debug  then
				print(foodType.." is a Fine Alcohol, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
			end
			return
		else --Low Alcohols
			daysFresh = SandboxVars.DaikonMorePerishables.LowAlcoholFreshDays
			daysTotallyRotten = SandboxVars.DaikonMorePerishables.LowAlcoholRotDays
			WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
			if isDebugEnabled() or debug  then
				print(foodType.." is a Fine Alcohol, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
			end
			return
		end
	end
	--the default case
	daysFresh = 60
	daysTotallyRotten = 90
	if daysFresh > daysTotallyRotten then
		daysTotallyRotten = daysFresh +1
	end
	food:setDaysFresh(daysFresh)
	food:setDaysTotallyRotten(daysTotallyRotten)
	if isDebugEnabled() or debug  then
		print(foodType.." is a an undetermined non-perishable, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
	end
end


--a wrapper function to make both necessary calls
Daikon.MoreSpoilingFoods.Init = function()
	Daikon.MoreSpoilingFoods.LoadSandboxTables()
	Daikon.MoreSpoilingFoods.AdjustFoodsMainLoop()
end

--This should execute when the save begins to loa
Events.OnInitGlobalModData.Add(Daikon.MoreSpoilingFoods.Init)

return Daikon