--[[
	tags所有标签: fruit-水果度, monster-怪物度, sweetener-甜度, veggie-菜度, meat-肉度, frozen-冰度, fish-鱼度, egg-蛋度
	decoration-装饰度-蝴蝶翅膀, fat-油脂度-黄油, dairy-奶度, inedible-不可食用度, seed-种子-桦栗果, magic-魔法度-噩梦燃料
    ]]

local foods = {
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
    -- 香蕉冻奶布丁
    furry_banana_milk_pudding = {
        test = function(cooker, names, tags)
            return (names.cave_banana or names.cave_banana_cooked) and names.furry_wolf_milk and names.glommerfuel and tags.frozen
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.BANANA_MILK_PUDDING.FOODTYPE,
        health = TUNING_FURRY.BANANA_MILK_PUDDING.HEALTH,
        hunger = TUNING_FURRY.BANANA_MILK_PUDDING.HUNGER,
        perishtime = TUNING_FURRY.BANANA_MILK_PUDDING.PERISH,
        sanity = TUNING_FURRY.BANANA_MILK_PUDDING.SANITY,
        cooktime = TUNING_FURRY.BANANA_MILK_PUDDING.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "cave_banana", 1 }, { "furry_wolf_milk", 1 }, { "glommerfuel", 1 }, { "ice", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wendy" then
                eater:AddDebuff("buff_furry_banana_milk_pudding", "buff_furry_banana_milk_pudding")
            end
        end
    },
    -- 酥麻蝴蝶派
    furry_crispy_butterfly_pie = {
        test = function(cooker, names, tags)
            return names.butterflywings and names.furry_wolf_milk == 2 and names.lightninggoathorn
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.CRISPY_BUTTERFLY_PIE.FOODTYPE,
        health = TUNING_FURRY.CRISPY_BUTTERFLY_PIE.HEALTH,
        hunger = TUNING_FURRY.CRISPY_BUTTERFLY_PIE.HUNGER,
        perishtime = TUNING_FURRY.CRISPY_BUTTERFLY_PIE.PERISH,
        sanity = TUNING_FURRY.CRISPY_BUTTERFLY_PIE.SANITY,
        cooktime = TUNING_FURRY.CRISPY_BUTTERFLY_PIE.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "butterflywings", 1 }, { "furry_wolf_milk", 2 }, { "lightninggoathorn", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wx78" then
                if eater.components.upgrademoduleowner ~= nil then
                    eater.components.upgrademoduleowner:AddCharge(3)
                end
                eater:AddDebuff("buff_furry_crispy_butterfly_pie", "buff_furry_crispy_butterfly_pie")
            end
        end
    },
    -- 提神花草茶
    furry_herbal_tea = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and tags.sweetener and tags.frozen and names.forgetmelots
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.HERBAL_TEA.FOODTYPE,
        health = TUNING_FURRY.HERBAL_TEA.HEALTH,
        hunger = TUNING_FURRY.HERBAL_TEA.HUNGER,
        perishtime = TUNING_FURRY.HERBAL_TEA.PERISH,
        sanity = TUNING_FURRY.HERBAL_TEA.SANITY,
        cooktime = TUNING_FURRY.HERBAL_TEA.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 1 }, { "honey", 1 }, { "ice", 1 }, { "forgetmelots", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wickerbottom" then
                eater:AddDebuff("buff_furry_herbal_tea", "buff_furry_herbal_tea")
            end
        end
    },
    -- 可乐鸡翅
    furry_cola_chicken_wings = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and tags.sweetener
                and (names.batwing == 2 or names.batwing_cooked == 2 or (names.batwing and names.batwing_cooked))
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.COLA_CHICKEN_WINGS.FOODTYPE,
        health = TUNING_FURRY.COLA_CHICKEN_WINGS.HEALTH,
        hunger = TUNING_FURRY.COLA_CHICKEN_WINGS.HUNGER,
        perishtime = TUNING_FURRY.COLA_CHICKEN_WINGS.PERISH,
        sanity = TUNING_FURRY.COLA_CHICKEN_WINGS.SANITY,
        cooktime = TUNING_FURRY.COLA_CHICKEN_WINGS.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 1 }, { "honey", 1 }, { "batwing", 2 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "woodie" then
                eater:AddDebuff("buff_furry_cola_chicken_wings", "buff_furry_cola_chicken_wings")
            end
        end
    },
    -- 奶油水果派
    furry_creamy_fruit_pie = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and tags.sweetener and tags.fruit and tags.fat
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.CREAMY_FRUIT_PIE.FOODTYPE,
        health = TUNING_FURRY.CREAMY_FRUIT_PIE.HEALTH,
        hunger = TUNING_FURRY.CREAMY_FRUIT_PIE.HUNGER,
        perishtime = TUNING_FURRY.CREAMY_FRUIT_PIE.PERISH,
        sanity = TUNING_FURRY.CREAMY_FRUIT_PIE.SANITY,
        cooktime = TUNING_FURRY.CREAMY_FRUIT_PIE.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 1 }, { "honey", 1 }, { "berries", 1 }, { "butter", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wes" then
                eater:AddDebuff("buff_furry_creamy_fruit_pie", "buff_furry_creamy_fruit_pie")
            end
        end
    },
    -- 咖喱蛋包饭
    furry_curry_omelet_rice = {
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
    furry_fishball_scallion_noodles = {
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
    furry_jasmine_milk_tea = {
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
    furry_semi_cheese = {
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
    furry_tiramisu = {
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
    furry_garlic_bullfrog = {
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
    -- 奶油蛤蜊炖蛋
    furry_creamy_clam_egg_stew = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk and tags.egg
                and (names.barnacle == 2 or names.barnacle_cooked == 2 or (names.barnacle and names.barnacle_cooked))
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.CREAMY_CLAM_EGG_STEW.FOODTYPE,
        health = TUNING_FURRY.CREAMY_CLAM_EGG_STEW.HEALTH,
        hunger = TUNING_FURRY.CREAMY_CLAM_EGG_STEW.HUNGER,
        perishtime = TUNING_FURRY.CREAMY_CLAM_EGG_STEW.PERISH,
        sanity = TUNING_FURRY.CREAMY_CLAM_EGG_STEW.SANITY,
        cooktime = TUNING_FURRY.CREAMY_CLAM_EGG_STEW.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "barnacle", 2 }, { "furry_wolf_milk", 1 }, { "bird_egg", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "warly" then
                eater:AddDebuff("buff_" .. inst.prefab, "buff_" .. inst.prefab)
            end
        end
    },
    -- 甜腻蔬菜汤
    furry_sweet_vegetable_soup = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk == 2 and tags.veggie and tags.veggie >= 2
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.SWEET_VEGETABLE_SOUP.FOODTYPE,
        health = TUNING_FURRY.SWEET_VEGETABLE_SOUP.HEALTH,
        hunger = TUNING_FURRY.SWEET_VEGETABLE_SOUP.HUNGER,
        perishtime = TUNING_FURRY.SWEET_VEGETABLE_SOUP.PERISH,
        sanity = TUNING_FURRY.SWEET_VEGETABLE_SOUP.SANITY,
        cooktime = TUNING_FURRY.SWEET_VEGETABLE_SOUP.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 2 }, { "carrot", 2 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "winona" then
                eater:AddDebuff("buff_" .. inst.prefab, "buff_" .. inst.prefab)
            end
        end
    },
    -- 香草甜筒
    furry_vanilla_cone = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk == 2 and names.honey and names.ice
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.VANILLA_CONE.FOODTYPE,
        health = TUNING_FURRY.VANILLA_CONE.HEALTH,
        hunger = TUNING_FURRY.VANILLA_CONE.HUNGER,
        perishtime = TUNING_FURRY.VANILLA_CONE.PERISH,
        sanity = TUNING_FURRY.VANILLA_CONE.SANITY,
        cooktime = TUNING_FURRY.VANILLA_CONE.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "furry_wolf_milk", 2 }, { "honey", 1 }, { "ice", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "webber" then
                eater:AddDebuff("buff_" .. inst.prefab, "buff_" .. inst.prefab)
            end
        end
    },
    --火鸡盛宴
    furry_turkey_feast = {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk == 1 and tags.meat
                and (names.drumstick == 2 or names.drumstick_cooked == 2 or (names.drumstick and names.drumstick_cooked))
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.TURKEY_FEAST.FOODTYPE,
        health = TUNING_FURRY.TURKEY_FEAST.HEALTH,
        hunger = TUNING_FURRY.TURKEY_FEAST.HUNGER,
        perishtime = TUNING_FURRY.TURKEY_FEAST.PERISH,
        sanity = TUNING_FURRY.TURKEY_FEAST.SANITY,
        cooktime = TUNING_FURRY.TURKEY_FEAST.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "drumstick", 2 }, { "furry_wolf_milk", 1 }, { "meat", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "wathgrithr" then
                eater:AddDebuff("buff_" .. inst.prefab, "buff_" .. inst.prefab)
            end
        end
    },
    -- 法式波士顿龙虾
    furry_french_boston_lobster = {
        test = function(cooker, names, tags)
            return (names.wobster_sheller_land or names.wobster_sheller_dead) and names.furry_wolf_milk == 2
                and (names.garlic or names.garlic_cooked)
        end,
        priority = 20,
        weight = 1,
        foodtype = TUNING_FURRY.FRENCH_BOSTON_LOBSTER.FOODTYPE,
        health = TUNING_FURRY.FRENCH_BOSTON_LOBSTER.HEALTH,
        hunger = TUNING_FURRY.FRENCH_BOSTON_LOBSTER.HUNGER,
        perishtime = TUNING_FURRY.FRENCH_BOSTON_LOBSTER.PERISH,
        sanity = TUNING_FURRY.FRENCH_BOSTON_LOBSTER.SANITY,
        cooktime = TUNING_FURRY.FRENCH_BOSTON_LOBSTER.COOKTIME,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "wobster_sheller_land", 1 }, { "furry_wolf_milk", 2 }, { "garlic", 1 } } },
        oneatenfn = function(inst, eater)
            if eater and eater.prefab == "waxwell" then
                eater:AddDebuff("buff_" .. inst.prefab, "buff_" .. inst.prefab)
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
