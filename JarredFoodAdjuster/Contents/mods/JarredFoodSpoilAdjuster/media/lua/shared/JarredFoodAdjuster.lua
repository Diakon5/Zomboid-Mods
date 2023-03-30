local FRESH_TIME_MULTIPLIER, ROT_TIME_MULTIPLIER

--Reads the sandbox options variables, and sets the defaults just in case.
local function DCF_setLocalSandboxVars()
	FRESH_TIME_MULTIPLIER = SandboxVars.DaikonJarFoodSpoil.FreshMultiplier
	if FRESH_TIME_MULTIPLIER == nil then
		FRESH_TIME_MULTIPLIER = 4;
	end

	ROT_TIME_MULTIPLIER = SandboxVars.DaikonJarFoodSpoil.FullRottenMultiplier
	if ROT_TIME_MULTIPLIER == nil then
		ROT_TIME_MULTIPLIER = 4;
	end
end

--The actual Finder and Adjuster
local function DCF_FindAndAdjustCannedFoods()
	if isDebugEnabled() then
		print("AdjustedJarredFoodsBeHere")
	end
	local scriptManager = ScriptManager.instance
	local recipes = scriptManager:getAllRecipes()
	for i=0, recipes:size() - 1 do
		local recipe = recipes:get(i)
		--recipeSource is the list of items that can be used to make the recipe
		local recipeSource = recipe:getSource()
		local foundAJar = false
		local foundALid = false
		--it's a list so I need to iterate again
		for j=0, recipeSource:size()-1 do
			--Safe to assume that canning something is a cooking recipe
			if recipe:getCategory() ~= "Cooking" then
				break
			end
			--Again, we get another java list, but at last we have some strings
			--Three lists, O(n^3) complexity
			local recipeItem = recipeSource:get(j):getItems()
			if recipeItem:contains("Base.EmptyJar") then
				foundAJar = true
			end
			if recipeItem:contains("Base.JarLid") then
				foundALid = true
			end
			--if both are true, we can abort early
			if foundAJar and foundALid then
				break
			end
		end
		--we check if the recipe we looped through found both a jar and a lid
		if foundAJar and foundALid then
			--getFullType returns the item with its module, important with mods
			local item = scriptManager:FindItem(recipe:getResult():getFullType())
			--Our mod would break on anything that isn't a food anyway
			if item:getTypeString() == "Food" then
				--I need to do this to get ReplaceOnRotten, ugh	
				local rottenReplace = item:InstanceItem(nil):getReplaceOnRotten() 
				--we did this because some mods include fermenting as the preparation process, in which the item rots
				--I should probably make this another loop to get to the final item, in case of several fermenting steps
				if rottenReplace ~= nil then
					item = scriptManager:FindItem(rottenReplace)
				end
				local daysFreshBase = item:getDaysFresh()
				local daysTotallyRottenBase = item:getDaysTotallyRotten()
				--getDaysFresh seems to return 1000000000 for unspoilable items. Same for getDaysTotallyRotten
				if not (daysFreshBase == 1000000000 and daysTotallyRottenBase == 1000000000) then
					local daysFreshAdjusted = math.floor(daysFreshBase*FRESH_TIME_MULTIPLIER + 0.5)
					local daysTotallyRottenAdjusted = math.floor(daysTotallyRottenBase*ROT_TIME_MULTIPLIER + 0.5)
					--make sure daysTotallyRotten isn't lower than daysFresh. Dunno if that causes a bug, but just in case
					if daysFreshAdjusted > daysTotallyRottenAdjusted then
						daysTotallyRottenAdjusted = daysFreshAdjusted+1
					end
					item:setDaysFresh(daysFreshAdjusted)
					item:setDaysTotallyRotten(daysTotallyRottenAdjusted)
				end
				--debug logging
				if isDebugEnabled() then
					print("Jarred Food Adjusted: ",item,item:getDaysFresh(),item:getDaysTotallyRotten())
				end
				
			end
			
		end
	end
end

--a wrapper function
local function DCF_Init()
	DCF_setLocalSandboxVars()
	DCF_FindAndAdjustCannedFoods()
end

--This should execute when the save begins to loa
Events.OnInitGlobalModData.Add(DCF_Init)