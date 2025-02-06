-- 料理
local foods = require("furry_preparedfoods")
for k, recipe in pairs(foods) do
    AddCookerRecipe("cookpot", recipe, true)         -- 烹饪锅
    AddCookerRecipe("portablecookpot", recipe, true) -- 便携式烹饪锅
    AddCookerRecipe("archive_cookpot", recipe, true) -- 档案馆远古窑,有好多mod作者忽略了这口锅

    if recipe.card_def then
        AddRecipeCard("cookpot", recipe) -- 食谱卡
    end
end

-- 非料理可烹饪得到物品
local nonfoods = require("furry_preparednonfoods")
for k, recipe in pairs(nonfoods) do
    AddCookerRecipe("cookpot", recipe, true)
    AddCookerRecipe("portablecookpot", recipe, true)
    AddCookerRecipe("archive_cookpot", recipe, true)
end

-- 兼容调味粉
GenerateSpicedFoods(foods)
local spicedfoods = require("spicedfoods")
for k, recipe in pairs(spicedfoods) do
    if recipe.basename and foods[recipe.basename] then
        AddCookerRecipe("portablespicer", recipe, true)
    end
end

-- 添加为可以入锅的食材
AddIngredientValues({ "foliage" }, { inedible = 1 })                        -- 蕨叶可以入锅
AddIngredientValues({ "furry_wolf_milk" }, { dairy = 1 })                   -- 狼奶
AddIngredientValues({ "furry_butter" }, { fat = 1, dairy = 1 })             -- 劣质黄油
AddIngredientValues({ "poop" }, { inedible = 1 })                           -- 粪肥
AddIngredientValues({ "glommerfuel" }, { inedible = 1 })                    -- 格罗姆的黏液
AddIngredientValues({ "wobster_sheller_dead" }, { meat = 1.0, fish = 1.0 }) -- 死龙虾
