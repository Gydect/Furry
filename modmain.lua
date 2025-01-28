-- 下行代码只代表查值时自动查global,增加global的变量或者修改global的变量时还是需要带"GLOBAL."
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local _G = GLOBAL

-- ※标注的地方大概率在新增内容的时候需要添加对应的参数,请仔细核对※标注的部分

-- 获取mod配置,放到官方的全局变量tuning表中
TUNING.FURRY_LANGUAGE = GetModConfigData("languages") -- 获取配置:语言

require("tuning_furry")                               -- mod全局表

-- ※万物皆是prefab
PrefabFiles = {
    "furry_preparedfoods",         -- mod料理
    "furry_wolf_milk",             -- 狼奶
    "furry_buffs",                 -- 模组buff
    "furry_buffs_gyde",            -- 模组buff:Gyde
    "furry_collar_bell",           -- 铃铛
    "buff_furry_tiramisu",         -- 提拉米苏buff(临时)
    "buff_furry_jasmine_milk_tea", -- 茉莉奶绿buff(临时)
    "furry_butter",                -- 劣质黄油
    "furry_book_web_ground",       -- 克服蛛形纲恐惧症地面特效x2倍大小
    "furry_yellowcat",             -- 绒绒
    "furry_yellowcat_none",        -- 人物皮肤
}

Assets = {
    Asset("ANIM", "anim/furry_minisign1.zip"),          -- ※小木牌256高清贴图:在 furry_minisign_list.lua 中填写贴图名称和所在动画编号

    Asset("ATLAS", "images/furry_inventoryimages.xml"), -- 物品栏贴图集
    Asset("IMAGE", "images/furry_inventoryimages.tex"),
    -- 注册小木牌用:本mod已经准备了256原图的小木牌动画资源,这行代码是给有展示装饰的mod使用(例如棱镜的展示柜,登仙的展示柜,棱镜的展示柜我会兼容自己的256高清贴图)
    Asset("ATLAS_BUILD", "images/furry_inventoryimages.xml", 256),

    Asset("ATLAS", "images/furry_cookbookimages.xml"), -- 烹饪指南本mod料理的256贴图集
    Asset("IMAGE", "images/furry_cookbookimages.tex"),

    Asset("IMAGE", "bigportraits/furry_yellowcat.tex"), -- 人物立绘
    Asset("ATLAS", "bigportraits/furry_yellowcat.xml"),

    Asset("IMAGE", "images/saveslot_portraits/furry_yellowcat.tex"), -- 存档图片
    Asset("ATLAS", "images/saveslot_portraits/furry_yellowcat.xml"),

    Asset("IMAGE", "images/avatars/avatar_furry_yellowcat.tex"), -- tab键人物列表显示的头像
    Asset("ATLAS", "images/avatars/avatar_furry_yellowcat.xml"),

    Asset("IMAGE", "images/avatars/avatar_ghost_furry_yellowcat.tex"), --tab键人物列表显示的头像(幽灵)
    Asset("ATLAS", "images/avatars/avatar_ghost_furry_yellowcat.xml"),

    Asset("IMAGE", "images/avatars/self_inspect_furry_yellowcat.tex"), -- 人物物品栏右侧检查图像
    Asset("ATLAS", "images/avatars/self_inspect_furry_yellowcat.xml"),

    Asset("IMAGE", "images/selectscreen_portraits/furry_yellowcat.tex"), -- 选人界面
    Asset("ATLAS", "images/selectscreen_portraits/furry_yellowcat.xml"),

    Asset("IMAGE", "images/selectscreen_portraits/furry_yellowcat_silho.tex"), -- 选人界面(未解锁)
    Asset("ATLAS", "images/selectscreen_portraits/furry_yellowcat_silho.xml"),

    Asset("IMAGE", "images/map_icons/furry_yellowcat.tex"), -- 小地图图标
    Asset("ATLAS", "images/map_icons/furry_yellowcat.xml"),

    Asset("IMAGE", "images/names_furry_yellowcat.tex"), -- 人物名字(灰色)
    Asset("ATLAS", "images/names_furry_yellowcat.xml"),

    Asset("IMAGE", "images/names_gold_furry_yellowcat.tex"), -- 人物名字(金色)
    Asset("ATLAS", "images/names_gold_furry_yellowcat.xml"),
}

modimport("scripts/furry_linkmod.lua") -- 判定别的mod是否开启

local skin_modes = {
    {
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle",
        scale = 0.75,
        offset = { 0, -25 }
    },
}
-- 增加人物到mod人物列表 性别为男性(MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL)
AddModCharacter("furry_yellowcat", "MALE", skin_modes)

-- 注册小地图图标
AddMinimapAtlas("images/furry_inventoryimages.xml")
AddMinimapAtlas("images/map_icons/furry_yellowcat.xml")

-- 设置语言
if TUNING.FURRY_LANGUAGE == "Chinese" then
    modimport("scripts/languages/furry_chinese.lua") -- ※中文
elseif TUNING.FURRY_LANGUAGE == "English" then
    modimport("scripts/languages/furry_english.lua") -- ※英文
else
    modimport("scripts/languages/furry_chinese.lua")
end

-- 注册贴图
modimport("scripts/furry_tool.lua")
FURRY_TOOL.Tool_RegisterInventoryItemAtlas("images/furry_inventoryimages.xml")
FURRY_TOOL.Tool_RegisterInventoryItemAtlas("images/map_icons/furry_yellowcat.xml")

modimport("scripts/furry_cooking.lua")  -- 烹饪
modimport("scripts/furry_hook.lua")     -- 钩子
modimport("scripts/furry_actions.lua")  -- 动作
modimport("scripts/furry_SGwilson.lua") -- 新增人物状态机
-- 沃托克斯: 红石榴丝绒千层的效果
modimport("scripts/furry_wortox.lua")
-- 万物百科解锁其它所有科技
modimport("scripts/furry_freebuildmode.lua")
