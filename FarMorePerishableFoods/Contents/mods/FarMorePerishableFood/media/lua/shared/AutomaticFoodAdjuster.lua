local function WrapSetDaysFreshRot(item,daysFresh,daysRotten)
	if daysFresh > daysRotten then
		daysRotten = daysFresh +1
	end
	item:setDaysFresh(daysFresh)
	item:setDaysTotallyRotten(daysRotten)
end

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
		if isDebugEnabled() or debug then
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
local evolvedRecipeBastards = {}
Daikon.MoreSpoilingFoods.AdjustFoodsMainLoop =  function()
	if isDebugEnabled() or debug then
		print("AdjustedNonPerishableFoodsBeHere")
	end
	local scriptManager = ScriptManager.instance
	local foodItems = scriptManager:getAllItems()
	Daikon.MoreSpoilingFoods.GetEvolvedRecipeResults()
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
				if Daikon.MoreSpoilingFoods.AdjustNonPerishableFood(item) then
					Daikon.MoreSpoilingFoods.CatchPackingRecipes(item)
				end
			end
		end
	end
end

Daikon.MoreSpoilingFoods.GetEvolvedRecipeResults = function ()
	---@type Stack
	local evolvedRecipes = getScriptManager():getAllEvolvedRecipes()
	while not evolvedRecipes:empty() do
		---@type EvolvedRecipe
		local evoRecipe = evolvedRecipes:pop()
		evolvedRecipeBastards[evoRecipe:getFullResultItem()] = true
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
-- We check what items the item can be made out of. Packing recipes result in a loop... Finding it will require a lot of loops too
Daikon.MoreSpoilingFoods.CatchPackingRecipes = function(foodItem)
	local scriptManager = getScriptManager()
	--Loop 1, find what the adjusted item is made out of
	--For some reason getAllRecipesFor searches by item's internal name without the type. Unless recipes are stored in both ways, in which case I will be mad
	local potentialPackingRecipes = scriptManager:getAllRecipesFor(foodItem:getName())
	for i = 0, potentialPackingRecipes:size()-1 do
		---@type Recipe
		local recipe = potentialPackingRecipes:get(i)
		---@type ArrayList|Recipe.Source
		local recipeSource = recipe:getSource()

		--Loop 2, we go through the Source and analyze the items
		for j = 0, recipeSource:size()-1 do
			local recipeItems = recipeSource:get(j):getItems()
			--TODO This ignores packing recipes that have a container in them, like jars or sacks(normally they don't perish but you never know)
			if recipeItems:size() == 1 then
				--Size is 1, so we can just get index 0
				--Same as start of loop 1
				--We do this to get around the fact that getAllRecipesFor appears to break when calling with a full Name
				--And GetSource Appears to return a FullName
				local itemNameFromFullName = split(recipeItems:get(0),".")
				if #itemNameFromFullName == 2 then
					itemNameFromFullName = itemNameFromFullName[2]
				else
					itemNameFromFullName = itemNameFromFullName[1]
				end
				local innerPackingRecipes = scriptManager:getAllRecipesFor(itemNameFromFullName)
				--Yup, Loop 3, Find what the previous item is made out of
				for k = 0, innerPackingRecipes:size() - 1 do
					local innerPackingRecipe = innerPackingRecipes:get(k)
					local potentialPatchItem = innerPackingRecipe:getResult():getFullType()
					if isDebugEnabled() or debug then
						print("Analyzing "..potentialPatchItem.." for being a packed recipe")
					end
					---@type ArrayList|Recipe.Source
					local innerRecipeSource = innerPackingRecipe:getSource()
					--Already to Loop 4. I hate this
					for l = 0, innerRecipeSource:size() - 1 do
						local innerRecipeItems = innerRecipeSource:get(l):getItems()
						--And now, technically Loop 5.
						--We also check if the size is 1. Probably redundant, but I don't know all mods.
						--contains is a perfect match.
						if innerRecipeItems:contains(foodItem:getFullName()) and innerRecipeItems:size() == 1 and innerRecipeSource:get(l):getCount() > 1 then
							--This is probably a recipe for a packing item
							local itemToPatch = scriptManager:getItem(potentialPatchItem)
							--We check if it's not a drainable. If it is, then we'll just break stuff, so no touchies
							if itemToPatch:getTypeString() ~= "Drainable" then
								--We change the item's type to Food(unless it already is), then patch the item to be the same perish time as the unpacked ones.
								--I couldn't access the Item Type enum directly, so I grabbed foodItem's
								if itemToPatch:getTypeString() ~="Food" then
									itemToPatch:setType(foodItem:getType())
								end
								WrapSetDaysFreshRot(itemToPatch,foodItem:getDaysFresh(),foodItem:getDaysTotallyRotten())
								if isDebugEnabled() or debug then
									print(potentialPatchItem.." is likely a Packed Item, adjusting to match unpacked item...")
								end
								--We changed Something, let's get the F out of here
								return
							end
						end
					end
				end
			end
		end
	end
end --8 levels of nesting. I miss the Continue keyword

---@param foodItem Item
Daikon.MoreSpoilingFoods.isLikelyFakeFood = function(foodItem)
	if foodItem:getTypeString() ~= "Food" then
		return false
	end
	if evolvedRecipeBastards[foodItem:getFullName()] then
		return false
	end
	foodItem = foodItem:InstanceItem(nil)
	if foodItem:getHungerChange() == 0 and foodItem:getThirstChange() == 0 and foodItem:getCalories() == 0 and foodItem:getCarbohydrates() == 0 and foodItem:getLipids() == 0 and foodItem:getProteins() == 0 then
		return true
	end
	return false
end

--Separate function so that it's possible to return to cancel the chain early, due to a lack of "break" keyword in Lua
--we return true if the item after the process became perishable, and false otherwise
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
		return false
	end
	--Manual Override list.
	if Daikon.MoreSpoilingFoods.OverrideList[foodType] then
		daysFresh = Daikon.MoreSpoilingFoods.OverrideList[foodType][1]
		daysTotallyRotten = Daikon.MoreSpoilingFoods.OverrideList[foodType][2]
		WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
		if isDebugEnabled() or debug  then
			print(foodType.." is on an OverrideList, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
		end
		if daysFresh == daysTotallyRotten == 1000000000 then
			return false
		end
		return true
	end
	--Some items are coded as food so they can be cooked or eaten, but have no nutritional values, don't wanna touch those usually, so below Override
	if Daikon.MoreSpoilingFoods.isLikelyFakeFood(food) then
		if isDebugEnabled() or debug  then
			print(foodType.." is likely not a food, Skipping...")
		end
		return false
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
		if daysFresh == daysTotallyRotten == 1000000000 then
			return false
		end
		return true
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
			if daysFresh == daysTotallyRotten == 1000000000 then
				return false
			end
			return true
		else --Low Alcohols
			daysFresh = SandboxVars.DaikonMorePerishables.LowAlcoholFreshDays
			daysTotallyRotten = SandboxVars.DaikonMorePerishables.LowAlcoholRotDays
			WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
			if isDebugEnabled() or debug  then
				print(foodType.." is a Fine Alcohol, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
			end
			if daysFresh == daysTotallyRotten == 1000000000 then
				return false
			end
			return true
		end
	end
	if food:getTags("DriedFood") then
		daysFresh = SandboxVars.DaikonMorePerishables.DriedFoodFreshDays
		daysTotallyRotten = SandboxVars.DaikonMorePerishables.DriedFoodRotDays
		WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
		if isDebugEnabled() or debug  then
			print(foodType.." is a Dried Food, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
		end
		if daysFresh == daysTotallyRotten == 1000000000 then
			return false
		end
		return true
	end
	if food:getTags("BakingFat") then
		daysFresh = SandboxVars.DaikonMorePerishables.BakingFatFreshDays
		daysTotallyRotten = SandboxVars.DaikonMorePerishables.BakingFatRotDays
		WrapSetDaysFreshRot(food,daysFresh,daysTotallyRotten)
		if isDebugEnabled() or debug  then
			print(foodType.." is a Baking Fat, setting to DaysFresh: "..daysFresh..";DaysTotallyRotten"..daysTotallyRotten)
		end
		if daysFresh == daysTotallyRotten == 1000000000 then
			return false
		end
		return true
	end
	--TODO Potential Categories:
	--Cooking Fats (BakingFat;Oil)
	--Dried Food (DriedFood)

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
	return true
end


--a wrapper function to make both necessary calls
Daikon.MoreSpoilingFoods.Init = function()
	Daikon.MoreSpoilingFoods.LoadSandboxTables()
	Daikon.MoreSpoilingFoods.AdjustFoodsMainLoop()
end

--This should execute when the save begins to loa
Events.OnInitGlobalModData.Add(Daikon.MoreSpoilingFoods.Init)

return Daikon