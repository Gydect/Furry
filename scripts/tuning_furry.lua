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
}
