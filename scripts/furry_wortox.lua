local function CanSoulhop(inst, souls, ...)
    local num = inst:HasTag("furry_pomegranate_velvet") and souls and souls > 2 and 2 or 1
    if inst.replica.inventory:Has("wortox_soul", num or 1) then
        local rider = inst.replica.rider
        if rider == nil or not rider:IsRiding() then
            return true
        end
    end
    return inst.FurryCanSoulhop and inst:FurryCanSoulhop(souls, ...)
end

local function WorToxPrefabFiles(inst)
    inst.FurryCanSoulhop = inst.CanSoulhop
    -- 客户端玩家身上灵魂数量判断是否可以进行灵魂跳跃
    inst.CanSoulhop = CanSoulhop
    -- 客户端监听是否有buff，简单点的话，就直接用标签代替也可以
    inst._furry_nut_energy_bar = net_bool(inst.GUID, "wortox.furry_nut_energy_bar", "furry_nut_energy_bar")
    if not TheWorld.ismastersim then
        return inst
    end
    -- 红石榴丝绒千层灵魂回血翻倍
    local OldDoDelta = inst.components.health.DoDelta
    function inst.components.health:DoDelta(amount, overtime, cause, ...)
        if inst:HasDebuff("buff_furry_pomegranate_velvet") and cause == "wortox_soul" then
            amount = amount * 2
        end
        OldDoDelta(self, amount, overtime, cause, ...)
    end
end
AddPrefabPostInit("wortox", WorToxPrefabFiles)

-- 地图跳跃
local Old_ACTIONS_MAP_REMAP = ACTIONS_MAP_REMAP[ACTIONS.BLINK.code]
ACTIONS_MAP_REMAP[ACTIONS.BLINK.code] = function(act, ...)
    local doer = act.doer
    local act_remap = Old_ACTIONS_MAP_REMAP(act, ...)
    -- 判断是否有红石榴丝绒千层buff，有的话，如果灵魂消耗大于2，就把灵魂消耗设置为2
    if doer and doer:HasTag("furry_pomegranate_velvet") and act_remap then
        act_remap.distancecount = act_remap.distancecount and act_remap.distancecount > 2 and 2 or act_remap.distancecount
    end
    return act_remap
end
