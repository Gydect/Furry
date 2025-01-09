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

-- 兼容调味粉
GenerateSpicedFoods(foods)
local spicedfoods = require("spicedfoods")
for k, recipe in pairs(spicedfoods) do
    if recipe.basename and foods[recipe.basename] then
        AddCookerRecipe("portablespicer", recipe, true)
    end
end

AddIngredientValues({ "foliage" }, { inedible = 1 })            -- 蕨叶可以入锅
AddIngredientValues({ "furry_wolf_milk" }, { dairy = 1 })       -- 狼奶
AddIngredientValues({ "furry_butter" }, { fat = 1, dairy = 1 }) -- 劣质黄油
AddIngredientValues({ "poop" }, { inedible = 1 })               -- 粪肥
