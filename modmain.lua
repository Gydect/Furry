-- 下行代码只代表查值时自动查global,增加global的变量或者修改global的变量时还是需要带"GLOBAL."
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local _G = GLOBAL

-- ※标注的地方大概率在新增内容的时候需要添加对应的参数,请仔细核对※标注的部分

-- 获取mod配置,放到官方的全局变量tuning表中
TUNING.FURRY_LANGUAGE = GetModConfigData("languages") --获取配置:语言

-- ※万物皆是prefab
PrefabFiles = {
    "furry_preparedfoods", -- mod料理
}

Assets = {
    Asset("ANIM", "anim/furry_minisign1.zip"),          -- 小木牌256高清贴图

    Asset("ATLAS", "images/furry_inventoryimages.xml"), -- 物品栏贴图集
    Asset("IMAGE", "images/furry_inventoryimages.tex"),
    -- 注册小木牌用:本mod已经准备了256原图的小木牌动画资源,这行代码是给有展示装饰的mod使用(例如棱镜的展示柜,登仙的展示柜,棱镜的展示柜我会兼容自己的256高清贴图)
    Asset("ATLAS_BUILD", "images/furry_inventoryimages.xml", 256),

    Asset("ATLAS", "images/furry_cookbookimages.xml"), -- 烹饪指南本mod料理的256贴图集
    Asset("IMAGE", "images/furry_cookbookimages.tex"),
}

-- 判定别的mod是否开启，参考了风铃大佬的代码
_G.FURRY_SETS = {
    ENABLEDMODS = {},
}
local modsenabled = KnownModIndex:GetModsToLoad(true)
local enabledmods = {}
for k, dir in pairs(modsenabled) do
    local info = KnownModIndex:GetModInfo(dir)
    local name = info and info.name or "unknown"
    enabledmods[dir] = name
end
local function IsModEnable(name)
    for k, v in pairs(enabledmods) do
        if v and (k:match(name) or v:match(name)) then
            return true
        end
    end
    return false
end
_G.FURRY_SETS.ENABLEDMODS["legion"] = IsModEnable("Legion") or IsModEnable("棱镜") -- 棱镜

-- 注册小地图图标
AddMinimapAtlas("images/furry_inventoryimages.xml")

-- 设置语言
if TUNING.FURRY_LANGUAGE == "Chinese" then
    modimport("scripts/languages/furry_chinese.lua") --※中文
elseif TUNING.FURRY_LANGUAGE == "English" then
    modimport("scripts/languages/furry_english.lua") --※英文
else
    modimport("scripts/languages/furry_chinese.lua")
end

-- 注册贴图
modimport("scripts/furry_tool.lua")
FURRY_TOOL.Tool_RegisterInventoryItemAtlas("images/furry_inventoryimages.xml")

modimport("scripts/furry_cooking.lua") -- 烹饪
modimport("scripts/furry_hook.lua")    -- 钩子
