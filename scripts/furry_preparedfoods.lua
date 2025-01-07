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
            return tags.meat and tags.meat >= 1 and (names.potato or names.potato_cooked) and tags.dairy and tags.dairy >= 1 and tags.egg and tags.egg >= 1
        end,
        priority = 20,                                                                                         -- 优先级
        weight = 1,                                                                                            -- 权重
        foodtype = FOODTYPE.MEAT,                                                                              -- 蔬菜:VEGGIE 肉:MEAT 好东西:GOODIES
        health = 20,                                                                                           -- 生命值
        hunger = 75,                                                                                           -- 饥饿
        perishtime = TUNING.PERISH_PRESERVED,                                                                  -- 腐烂时间
        sanity = 33,                                                                                           -- 精神
        cooktime = 1,                                                                                          -- 烹饪时间:1对应20s
        floater = { "med", nil, 0.55 },                                                                        -- 漂浮在水面的参数
        card_def = { ingredients = { { "potato", 1 }, { "meat", 1 }, { "bird_egg", 1 }, { "goatmilk", 1 } } }, -- 食谱卡
    },
    -- 鱼丸葱面
    furry_fishball_scallion_noodles =
    {
        test = function(cooker, names, tags)
            return tags.fish and tags.fish >= 1.5 and tags.dairy and tags.dairy >= 1
        end,
        priority = 20,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 20,
        hunger = 37.5,
        perishtime = TUNING.PERISH_PRESERVED,
        sanity = 5,
        cooktime = 1,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "fishmeat_small", 3 }, { "goatmilk", 1 } } },
    },
    -- 茉莉奶绿
    furry_jasmine_milk_tea =
    {
        test = function(cooker, names, tags)
            return tags.dairy and tags.dairy >= 1 and tags.sweetener and tags.sweetener >= 1 and tags.frozen and tags.frozen >= 1 and names.foliage
        end,
        priority = 20,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 5,
        hunger = 12.5,
        perishtime = TUNING.PERISH_PRESERVED,
        sanity = 80,
        cooktime = 1,
        floater = { "med", nil, 0.55 },
        card_def = { ingredients = { { "goatmilk", 1 }, { "honey", 1 }, { "ice", 1 }, { "foliage", 1 } } },
        potlevel = "low",
    },
}

for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0

    v.cookbook_category = "mod"
    v.overridebuild = "furry_foods"

    -- 烹饪指南里的料理贴图
    v.cookbook_atlas = "images/furry_cookbookimages.xml"
    v.cookbook_tex = "" .. k .. ".tex"
end

return foods
