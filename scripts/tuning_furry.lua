local seg_time = 30
local cook_time = 1 / 20             -- 1秒
local total_day_time = seg_time * 16 -- 480秒,游戏里的一天

TUNING_FURRY = {
    -- 狼奶
    WOLF_MILK = {
        HEALTH = 10,                 -- 生命
        HUNGER = 0,                  -- 饥饿
        SANITY = -50,                -- 理智
        PERISH = 6 * total_day_time, -- 腐烂
    },
    -- 咖喱蛋包饭
    CURRY_OMELET_RICE = {
        HEALTH = 20,
        HUNGER = 75,
        SANITY = 33,
        PERISH = 15 * total_day_time,
        COOKTIME = 15 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 鱼丸葱面
    FISHBALL_SCALLION_NOODLES = {
        HEALTH = 20,
        HUNGER = 37.5,
        SANITY = 5,
        PERISH = 15 * total_day_time,
        COOKTIME = 15 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 茉莉奶绿
    JASMINE_MILK_TEA = {
        HEALTH = 5,
        HUNGER = 12.5,
        SANITY = 80,
        PERISH = 10 * total_day_time,
        COOKTIME = 10 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
    -- 半熟芝士
    SEMI_CHEESE = {
        HEALTH = 60,
        HUNGER = 37.5,
        SANITY = 33,
        PERISH = 25 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
    -- 提拉米苏
    TIRAMISU = {
        HEALTH = 60,
        HUNGER = 62.5,
        SANITY = 33,
        PERISH = 20 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
    -- 蒜香牛蛙
    GARLIC_BULLFROG = {
        HEALTH = 35,
        HUNGER = 62.5,
        SANITY = 15,
        PERISH = 15 * total_day_time,
        COOKTIME = 15 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 劣质黄油
    BUTTER = {
        HEALTH = 20,
        HUNGER = 12.5,
        SANITY = 0,
        PERISH = 20 * total_day_time,
        COOKTIME = 60 * cook_time,
        FOODTYPE = FOODTYPE.GENERIC,
    },
    -- 紫苏包肉
    ZISUBAOROU = {
        HEALTH = 15,
        HUNGER = 37.5,
        SANITY = 5,
        PERISH = 15 * total_day_time,
        COOKTIME = 15 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 冒菜炖肉
    SPICY_STEW = {
        HEALTH = 5,
        HUNGER = 75,
        SANITY = -15,
        PERISH = 15 * total_day_time,
        COOKTIME = 15 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 芝士土豆焗奶
    CHEESE_POTATO_BAKE = {
        HEALTH = 5,
        HUNGER = 62.5,
        SANITY = 5,
        PERISH = 20 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.VEGGIE,
    },
    -- 香蕉冻奶布丁
    BANANA_MILK_PUDDING = {
        HEALTH = 10,
        HUNGER = 12.5,
        SANITY = 33,
        PERISH = 10 * total_day_time,
        COOKTIME = 10 * cook_time,
        FOODTYPE = FOODTYPE.VEGGIE,
    },
    -- 酥麻蝴蝶派
    CRISPY_BUTTERFLY_PIE = {
        HEALTH = 30,
        HUNGER = 12.5,
        SANITY = 10,
        PERISH = 20 * total_day_time,
        COOKTIME = 30 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
    -- 提神花草茶
    HERBAL_TEA = {
        HEALTH = 10,
        HUNGER = 12.5,
        SANITY = 50,
        PERISH = 15 * total_day_time,
        COOKTIME = 45 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
    -- 可乐鸡翅
    COLA_CHICKEN_WINGS = {
        HEALTH = 20,
        HUNGER = 75,
        SANITY = 5,
        PERISH = 15 * total_day_time,
        COOKTIME = 15 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 奶油水果派
    CREAMY_FRUIT_PIE = {
        HEALTH = 60,
        HUNGER = 150,
        SANITY = 15,
        PERISH = 10 * total_day_time,
        COOKTIME = 30 * cook_time,
        FOODTYPE = FOODTYPE.VEGGIE,
    },
    -- 法式波士顿龙虾
    FRENCH_BOSTON_LOBSTER = {
        HEALTH = 60,
        HUNGER = 75,
        SANITY = 15,
        PERISH = 15 * total_day_time,
        COOKTIME = 60 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 火鸡盛宴
    TURKEY_FEAST = {
        HEALTH = 25,
        HUNGER = 75,
        SANITY = 5,
        PERISH = 15 * total_day_time,
        COOKTIME = 30 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 香草甜筒
    VANILLA_CONE = {
        HEALTH = 40,
        HUNGER = 12.5,
        SANITY = 33,
        PERISH = 5 * total_day_time,
        COOKTIME = 10 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
    -- 甜腻蔬菜汤
    SWEET_VEGETABLE_SOUP = {
        HEALTH = 10,
        HUNGER = 37.5,
        SANITY = 5,
        PERISH = 15 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.VEGGIE,
    },
    -- 奶油蛤蜊炖蛋
    CREAMY_CLAM_EGG_STEW = {
        HEALTH = 20,
        HUNGER = 37.5,
        SANITY = 15,
        PERISH = 15 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.MEAT,
    },
    -- 红石榴丝绒千层
    POMEGRANATE_VELVET = {
        HEALTH = 20,
        HUNGER = 75,
        SANITY = 5,
        PERISH = 10 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.VEGGIE,
    },
    -- 营养杯
    NUTRITION_CUP = {
        HEALTH = 0,
        HUNGER = 0,
        SANITY = 0,
        PERISH = nil,
        COOKTIME = 30 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
    -- 榴莲酱千层
    DURIAN_MILLE_FEUILLE = {
        HEALTH = 40,
        HUNGER = 12.5,
        SANITY = -15,
        PERISH = 8 * total_day_time,
        COOKTIME = 25 * cook_time,
        FOODTYPE = FOODTYPE.VEGGIE,
    },
    -- 坚果能量棒
    NUT_ENERGY_BAR = {
        HEALTH = 15,
        HUNGER = 37.5,
        SANITY = 10,
        PERISH = 60 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.VEGGIE,
    },
    -- 棉花糖
    MARSHMALLOW = {
        HEALTH = -3,
        HUNGER = 25,
        SANITY = 33,
        PERISH = 15 * total_day_time,
        COOKTIME = 20 * cook_time,
        FOODTYPE = FOODTYPE.GOODIES,
    },
}
