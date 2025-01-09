--[[
	tags所有标签: fruit-水果度, monster-怪物度, sweetener-甜度, veggie-菜度, meat-肉度, frozen-冰度, fish-鱼度, egg-蛋度
	decoration-装饰度-蝴蝶翅膀, fat-油脂度-黄油, dairy-奶度, inedible-不可食用度, seed-种子-桦栗果, magic-魔法度-噩梦燃料
    ]]

-- 计算食物和烹饪食物的数量,函数是可以的,就是智能锅无法预测
local function Cooked(names, name)
    local num1 = names[name] or 0
    local num2 = names[name .. "_cooked"] or 0
    local num = num1 + num2
    return num > 0 and num
end

local foods =
{
    -- 紫苏包肉
    furry_perilla_wraps = {
        test = function(cooker, names, tags)
            return names.foliage and names.furry_wolf_milk and tags.meat and tags.veggie
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.PERILLA_WRAPS.FOODTYPE,
        health = TUNING_FURRY.PERILLA_WRAPS.HEALTH,
        hunger = TUNING_FURRY.PERILLA_WRAPS.HUNGER,
        sanity = TUNING_FURRY.PERILLA_WRAPS.SANITY,
        perishtime = TUNING_FURRY.PERILLA_WRAPS.PERISH,
        cooktime = TUNING_FURRY.PERILLA_WRAPS.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "foliage", 1 }, { "furry_wolf_milk", 1 }, { "meat", 1 }, { "carrot", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wilson" then
                eater:AddDebuff("buff_furry_perilla_wraps", "buff_furry_perilla_wraps")
            end
        end
    },
    -- 冒菜炖肉
    furry_spicy_stew = {
        test = function(cooker, names, tags)
            return (names.pepper or names.pepper_cooked) and names.furry_wolf_milk
                and tags.meat and tags.meat >= 1 and tags.veggie and tags.veggie > 1
        end,
        priority = 25,
        weight = 1,
        foodtype = TUNING_FURRY.SPICY_STEW.FOODTYPE,
        health = TUNING_FURRY.SPICY_STEW.HEALTH,
        hunger = TUNING_FURRY.SPICY_STEW.HUNGER,
        sanity = TUNING_FURRY.SPICY_STEW.SANITY,
        perishtime = TUNING_FURRY.SPICY_STEW.PERISH,
        cooktime = TUNING_FURRY.SPICY_STEW.COOKTIME,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
        nochill = true,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "pepper", 2 }, { "meat", 1 }, { "furry_wolf_milk", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "willow" then
                eater:AddDebuff("buff_furry_spicy_stew", "buff_furry_spicy_stew")
            end
        end
    },
    -- 芝士土豆焗奶
    furry_cheese_potato_bake = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk == 2 and (names.potato or names.potato_cooked) and tags.egg and tags.egg >= 1
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.CHEESE_POTATO_BAKE.FOODTYPE,
        health = TUNING_FURRY.CHEESE_POTATO_BAKE.HEALTH,
        hunger = TUNING_FURRY.CHEESE_POTATO_BAKE.HUNGER,
        perishtime = TUNING_FURRY.CHEESE_POTATO_BAKE.PERISH,
        sanity = TUNING_FURRY.CHEESE_POTATO_BAKE.SANITY,
        cooktime = TUNING_FURRY.CHEESE_POTATO_BAKE.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "potato", 1 }, { "furry_wolf_milk", 2 }, { "bird_egg", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wolfgang" then
                eater:AddDebuff("buff_furry_cheese_potato_bake_a", "buff_furry_cheese_potato_bake_a")
                eater:AddDebuff("buff_furry_cheese_potato_bake_b", "buff_furry_cheese_potato_bake_b")
            end
        end
    },
    -- 咖喱蛋包饭
    furry_curry_omelet_rice =
    {
        -- 配方
        test = function(cooker, names, tags)
            return tags.meat and tags.meat >= 1 and (names.potato or names.potato_cooked) and names.furry_wolf_milk and tags.egg and tags.egg >= 1
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.CURRY_OMELET_RICE.FOODTYPE,
        health = TUNING_FURRY.CURRY_OMELET_RICE.HEALTH,
        hunger = TUNING_FURRY.CURRY_OMELET_RICE.HUNGER,
        perishtime = TUNING_FURRY.CURRY_OMELET_RICE.PERISH,
        sanity = TUNING_FURRY.CURRY_OMELET_RICE.SANITY,
        cooktime = TUNING_FURRY.CURRY_OMELET_RICE.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "potato", 1 }, { "meat", 1 }, { "bird_egg", 1 }, { "furry_wolf_milk", 1 } } },
    },
    -- 鱼丸葱面
    furry_fishball_scallion_noodles =
    {
        test = function(cooker, names, tags)
            return tags.fish and tags.fish >= 1.5 and names.furry_wolf_milk
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.FISHBALL_SCALLION_NOODLES.FOODTYPE,
        health = TUNING_FURRY.FISHBALL_SCALLION_NOODLES.HEALTH,
        hunger = TUNING_FURRY.FISHBALL_SCALLION_NOODLES.HUNGER,
        perishtime = TUNING_FURRY.FISHBALL_SCALLION_NOODLES.PERISH,
        sanity = TUNING_FURRY.FISHBALL_SCALLION_NOODLES.SANITY,
        cooktime = TUNING_FURRY.FISHBALL_SCALLION_NOODLES.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "fishmeat_small", 3 }, { "furry_wolf_milk", 1 } } },
    },
    -- 茉莉奶绿
    furry_jasmine_milk_tea =
    {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and tags.sweetener and tags.sweetener >= 1 and tags.frozen and tags.frozen >= 1 and names.foliage
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.JASMINE_MILK_TEA.FOODTYPE,
        health = TUNING_FURRY.JASMINE_MILK_TEA.HEALTH,
        hunger = TUNING_FURRY.JASMINE_MILK_TEA.HUNGER,
        perishtime = TUNING_FURRY.JASMINE_MILK_TEA.PERISH,
        sanity = TUNING_FURRY.JASMINE_MILK_TEA.SANITY,
        cooktime = TUNING_FURRY.JASMINE_MILK_TEA.COOKTIME,
        floater = { "med", nil, 0.55 },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil then
                eater:AddDebuff("buff_furry_jasmine_milk_tea", "buff_furry_jasmine_milk_tea")
            end
        end,
        card_def = { ingredients = { { "furry_wolf_milk", 1 }, { "honey", 1 }, { "ice", 1 }, { "foliage", 1 } } },
        potlevel = "low",
    },
    -- 半熟芝士
    furry_semi_cheese =
    {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and tags.fat and tags.fat >= 1 and tags.egg and tags.egg >= 2
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.SEMI_CHEESE.FOODTYPE,
        health = TUNING_FURRY.SEMI_CHEESE.HEALTH,
        hunger = TUNING_FURRY.SEMI_CHEESE.HUNGER,
        perishtime = TUNING_FURRY.SEMI_CHEESE.PERISH,
        sanity = TUNING_FURRY.SEMI_CHEESE.SANITY,
        cooktime = TUNING_FURRY.SEMI_CHEESE.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 1 }, { "butter", 1 }, { "bird_egg", 2 } } },
    },
    -- 提拉米苏
    furry_tiramisu =
    {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and tags.sweetener and tags.sweetener >= 3
                and tags.fat and tags.fat >= 1 and tags.egg and tags.egg >= 1
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.TIRAMISU.FOODTYPE,
        health = TUNING_FURRY.TIRAMISU.HEALTH,
        hunger = TUNING_FURRY.TIRAMISU.HUNGER,
        perishtime = TUNING_FURRY.TIRAMISU.PERISH,
        sanity = TUNING_FURRY.TIRAMISU.SANITY,
        cooktime = TUNING_FURRY.TIRAMISU.COOKTIME,
        floater = { "med", nil, 0.55 },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil then
                eater:AddDebuff("buff_furry_tiramisu", "buff_furry_tiramisu")
            end
        end,
        card_def = { ingredients = { { "furry_wolf_milk", 1 }, { "royal_jelly", 1 }, { "butter", 1 }, { "bird_egg", 1 } } },
    },
    -- 蒜香牛蛙
    furry_garlic_bullfrog =
    {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and (names.garlic or names.garlic_cooked)
                and (names.froglegs == 2 or names.froglegs_cooked == 2 or (names.froglegs and names.froglegs_cooked))
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.GARLIC_BULLFROG.FOODTYPE,
        health = TUNING_FURRY.GARLIC_BULLFROG.HEALTH,
        hunger = TUNING_FURRY.GARLIC_BULLFROG.HUNGER,
        perishtime = TUNING_FURRY.GARLIC_BULLFROG.PERISH,
        sanity = TUNING_FURRY.GARLIC_BULLFROG.SANITY,
        cooktime = TUNING_FURRY.GARLIC_BULLFROG.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "froglegs", 2 }, { "garlic", 1 }, { "furry_wolf_milk", 1 } } },
    },
    -- 劣质黄油
    furry_butter =
    {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk == 4
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.BUTTER.FOODTYPE,
        health = TUNING_FURRY.BUTTER.HEALTH,
        hunger = TUNING_FURRY.BUTTER.HUNGER,
        perishtime = TUNING_FURRY.BUTTER.PERISH,
        sanity = TUNING_FURRY.BUTTER.SANITY,
        cooktime = TUNING_FURRY.BUTTER.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 4 } } },
    },
    -- 棉花糖
    furry_marshmallow = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk == 2 and names.honey == 2
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.MARSHMALLOW.FOODTYPE,
        health = TUNING_FURRY.MARSHMALLOW.HEALTH,
        hunger = TUNING_FURRY.MARSHMALLOW.HUNGER,
        perishtime = TUNING_FURRY.MARSHMALLOW.PERISH,
        sanity = TUNING_FURRY.MARSHMALLOW.SANITY,
        cooktime = TUNING_FURRY.MARSHMALLOW.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 2 }, { "honey", 2 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wanda" then
                eater:AddDebuff("buff_furry_marshmallow", "buff_furry_marshmallow")
            end
        end
    },
    -- 坚果能量棒
    furry_nut_energy_bar = {
        test = function(cooker, names, tags)
            return (names.acorn or names.acorn_cooked) and names.furry_wolf_milk
                and (names.berries == 2 or names.berries_cooked == 2 or (names.berries and names.berries_cooked))
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.NUT_ENERGY_BAR.FOODTYPE,
        health = TUNING_FURRY.NUT_ENERGY_BAR.HEALTH,
        hunger = TUNING_FURRY.NUT_ENERGY_BAR.HUNGER,
        perishtime = TUNING_FURRY.NUT_ENERGY_BAR.PERISH,
        sanity = TUNING_FURRY.NUT_ENERGY_BAR.SANITY,
        cooktime = TUNING_FURRY.NUT_ENERGY_BAR.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "berries", 2 }, { "acorn", 1 }, { "furry_wolf_milk", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "walter" then
                eater:AddDebuff("buff_furry_nut_energy_bar", "buff_furry_nut_energy_bar")
            end
        end
    },
    -- 榴莲酱千层
    furry_durian_mille_feuille = {
        test = function(cooker, names, tags)
            return names.honey and names.furry_wolf_milk and tags.egg and (names.durian or names.durian_cooked)
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.DURIAN_MILLE_FEUILLE.FOODTYPE,
        health = TUNING_FURRY.DURIAN_MILLE_FEUILLE.HEALTH,
        hunger = TUNING_FURRY.DURIAN_MILLE_FEUILLE.HUNGER,
        perishtime = TUNING_FURRY.DURIAN_MILLE_FEUILLE.PERISH,
        sanity = TUNING_FURRY.DURIAN_MILLE_FEUILLE.SANITY,
        cooktime = TUNING_FURRY.DURIAN_MILLE_FEUILLE.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "durian", 1 }, { "bird_egg", 1 }, { "honey", 1 }, { "furry_wolf_milk", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wurt" then
                eater:AddDebuff("buff_furry_durian_mille_feuille", "buff_furry_durian_mille_feuille")
            end
        end
    },
    -- 营养杯
    furry_nutrition_cup = {
        test = function(cooker, names, tags)
            return names.glommerfuel and names.furry_wolf_milk and names.poop == 2
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.NUTRITION_CUP.FOODTYPE,
        health = TUNING_FURRY.NUTRITION_CUP.HEALTH,
        hunger = TUNING_FURRY.NUTRITION_CUP.HUNGER,
        perishtime = TUNING_FURRY.NUTRITION_CUP.PERISH,
        sanity = TUNING_FURRY.NUTRITION_CUP.SANITY,
        cooktime = TUNING_FURRY.NUTRITION_CUP.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "glommerfuel", 1 }, { "furry_wolf_milk", 1 }, { "poop", 2 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wormwood" then
                if eater.components.bloomness then
                    --设置3级开花
                    eater.components.bloomness:SetLevel(3)
                    --设置1000点开花值
                    eater.components.bloomness:Fertilize(1000)
                end
                --缓慢回血30buff
                eater:AddDebuff("buff_furry_nutrition_cup", "buff_furry_nutrition_cup")
            end
        end
    },
    -- 红石榴丝绒千层
    furry_pomegranate_velvet = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and names.ice
                and (names.pomegranate == 2 or names.pomegranate_cooked == 2 or (names.pomegranate and names.pomegranate_cooked))
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.POMEGRANATE_VELVET.FOODTYPE,
        health = TUNING_FURRY.POMEGRANATE_VELVET.HEALTH,
        hunger = TUNING_FURRY.POMEGRANATE_VELVET.HUNGER,
        perishtime = TUNING_FURRY.POMEGRANATE_VELVET.PERISH,
        sanity = TUNING_FURRY.POMEGRANATE_VELVET.SANITY,
        cooktime = TUNING_FURRY.POMEGRANATE_VELVET.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "pomegranate", 2 }, { "furry_wolf_milk", 1 }, { "ice", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wortox" then
                eater:AddDebuff("buff_furry_pomegranate_velvet", "buff_furry_pomegranate_velvet")
            end
        end
    },
}

for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0

    v.cookbook_category = "mod"
    if v.overridebuild == nil then
        v.overridebuild = "furry_foods"
    end

    -- 烹饪指南里的料理贴图
    v.cookbook_atlas = "images/furry_cookbookimages.xml"
    v.cookbook_tex = "" .. k .. ".tex"
end

return foods
