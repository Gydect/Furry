local isCh = locale == "zh" or locale == "zhr" or locale == "zht"
-- 名称
name = isCh and "绒绒" or "Furry Fluff"
-- 描述
description = [[
    可爱的人物模组，并添加了许多有趣又好看的料理
    ]]
-- 作者
author = "Gyde(码) & 王筱巫(画)"
-- 版本
version = "1.0.0.1"
-- klei官方论坛地址，为空则默认是工坊的地址
forumthread = ""
-- modicon
icon_atlas = "modicon.xml"
icon = "modicon.tex"
-- 服务器标签
server_filter_tags = { "FurryFluff", "绒绒" }
-- dst兼容
dst_compatible = true
-- 是否是客户端mod
client_only_mod = false
-- 是否是所有客户端都需要安装
all_clients_require_mod = true
-- 饥荒api版本，固定填10
api_version = 10
-- 优先级，值越大越先加载 默认0
priority = 0

-- 配置项大标题，该函数受勋章模组代码启发，视觉上直观很多
local function Headline(name)
    return
    {
        name = name,
        label = name,
        options = { { description = "", data = false }, },
        default = false,
    }
end

-- mod的配置项，后面介绍
configuration_options = isCh and
    {
        Headline("基础设置"),
        {
            name = "languages", -- 配置项名换，在modmain.lua里获取配置值时要用到
            label = "语言",
            hover = "选择你的语言", -- 鼠标移到配置项上时所显示的信息
            options = {
                { -- 配置项目可选项
                    description = "简体中文", -- 可选项上显示的内容
                    hover = "简体中文", -- 鼠标移动到可选项上显示的信息
                    data = 'Chinese' -- 可选项选中时的值，在modmain.lua里获取到的值就是这个数据，类型可以为整形，布尔，浮点，字符串
                },
                {
                    description = "英文",
                    hover = "英文",
                    data = 'English'
                }
            },
            default = 'Chinese' -- 默认值，与可选项里的值匹配作为默认值
        },
    }
    or
    {
        Headline("Basic Settings"),
        {
            name = "languages",
            label = "Languages",
            hover = "Choose your language",
            options = {
                {
                    description = "English",
                    hover = "English",
                    data = 'English'
                },
                {
                    description = "Simplified Chinese",
                    hover = "Simplified Chinese",
                    data = 'Chinese'
                }
            },
            default = 'English'
        },
    }
