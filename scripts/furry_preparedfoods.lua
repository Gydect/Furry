--[[
	tags所有标签: fruit-水果度, monster-怪物度, sweetener-甜度, veggie-菜度, meat-肉度, frozen-冰度, fish-鱼度, egg-蛋度
	decoration-装饰度-蝴蝶翅膀, fat-油脂度-黄油, dairy-奶度, inedible-不可食用度, seed-种子-桦栗果, magic-魔法度-噩梦燃料
    ]]
local foods =
{
    -- 咖喱蛋包饭
    furry_curry_omelet_rice =
    {
        -- 配方
        test = function(cooker, names, tags)
            return tags.meat and tags.meat >= 1 and (names.potato or names.potato_cooked) and names.furry_wolf_milk and tags.egg and tags.egg >= 1
        end,
        priority = 20,                                                                                                -- 优先级
        weight = 1,                                                                                                   -- 权重
        foodtype = TUNING_FURRY.CURRY_OMELET_RICE.FOODTYPE,                                                           -- 蔬菜:VEGGIE 肉:MEAT 好东西:GOODIES
        health = TUNING_FURRY.CURRY_OMELET_RICE.HEALTH,                                                               -- 生命值
        hunger = TUNING_FURRY.CURRY_OMELET_RICE.HUNGER,                                                               -- 饥饿
        perishtime = TUNING_FURRY.CURRY_OMELET_RICE.PERISH,                                                           -- 腐烂时间
        sanity = TUNING_FURRY.CURRY_OMELET_RICE.SANITY,                                                               -- 精神
        cooktime = TUNING_FURRY.CURRY_OMELET_RICE.COOKTIME,                                                           -- 烹饪时间:1对应20s
        floater = { "med", nil, 0.55 },                                                                               -- 漂浮在水面的参数
        card_def = { ingredients = { { "potato", 1 }, { "meat", 1 }, { "bird_egg", 1 }, { "furry_wolf_milk", 1 } } }, -- 食谱卡
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
