local original_CannedFood_OnCooked = CannedFood_OnCooked


function CannedFood_OnCooked(cannedFood)
    original_CannedFood_OnCooked(cannedFood)
    cannedFood:setOffAgeMax(cannedFood:getOffAgeMax()*SandboxVars.DaikonJarFoodSpoil.FullRottenMultiplier);
    cannedFood:setOffAge(cannedFood:getOffAge()*SandboxVars.DaikonJarFoodSpoil.FreshMultiplier);
    cannedFood:setAge(cannedFood:getAge() * (SandboxVars.DaikonJarFoodSpoil.FreshMultiplier+SandboxVars.DaikonJarFoodSpoil.FullRottenMultiplier)/2);
    --    print("new jared food age " .. cannedFood:getAge() .. " and max age " .. cannedFood:getOffAgeMax());
end