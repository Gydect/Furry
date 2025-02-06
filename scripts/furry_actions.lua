--=======================================
--[[ 动作定义 ]]
--=======================================
local actions = {
    CB_ITEMUPGRADE = {
        id = "CB_ITEMUPGRADE",
        priority = 6,
        strfn = function(act)
            return "GENERIC"
        end,
        fn = function(act)
            if act.target.components.cb_itemupgrade
                and not act.target.components.cb_itemupgrade:IsMax(act.invobject.prefab)
            then
                act.target.components.cb_itemupgrade:AddItem(act.invobject, act.doer)
                if act.doer.SoundEmitter then
                    act.doer.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
                end
                return true
            end
            return false
        end
    },
}

for _, action in pairs(actions) do
    local _action = Action()
    for k, v in pairs(action) do
        _action[k] = v
    end
    AddAction(_action)
end

STRINGS.ACTIONS.CB_ITEMUPGRADE = {
    GENERIC = "升级",
}

--=======================================
--[[ 动作行为:就是执行动作的人物动画 ]]
--=======================================
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CB_ITEMUPGRADE, "domediumaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CB_ITEMUPGRADE, "domediumaction"))

--=======================================
--[[ ADD COMPONENT ACTION ]]
-- SCENE		using an object in the world                                        --args: inst, doer, actions, right
-- USEITEM		using an inventory item on an object in the world                   --args: inst, doer, target, actions, right
-- POINT		using an inventory item on a point in the world                     --args: inst, doer, pos, actions, right, target
-- EQUIPPED		using an equiped item on yourself or a target object in the world   --args: inst, doer, target, actions, right
-- INVENTORY	using an inventory item                                             --args: inst, doer, actions, right
--=======================================
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if target.components.cb_itemupgrade and not target.components.cb_itemupgrade:IsMax(inst.prefab) then
        -- 升级
        table.insert(actions, ACTIONS.CB_ITEMUPGRADE)
    end
end)

local furry_actions = {
    {
        -- 挤奶
        id = "FURRY_MILKING",
        str = "挤奶",
        fn = function(act)
            local target = act.target
            local doer = act.doer
            return target and target.components.furry_milking and target.components.furry_milking:MakeMilk(doer)
        end,
        state = "domediumaction",
    },
}

local component_actions = {
    SCENE = {
        furry_milking = function(inst, doer, actions, right)
            if right and (inst == doer or table.contains(CHARACTER_GENDERS["MALE"], doer.prefab)) then
                table.insert(actions, ACTIONS.FURRY_MILKING)
            end
        end
    }
}

for _, v in pairs(furry_actions) do
    local action = AddAction(v.id, v.str, v.fn)
    if v.actiondata then
        for k, data in pairs(v.actiondata) do
            action[k] = data
        end
    end
    AddStategraphActionHandler("wilson", ActionHandler(action, v.state))
    AddStategraphActionHandler("wilson_client", ActionHandler(action, v.state))
end

for k, v in pairs(component_actions) do
    for cmp, fn in pairs(v) do
        AddComponentAction(k, cmp, fn)
    end
end
--=======================================
--[[ 代码作者:恒子 源:能力勋章mod ]]
--=======================================
local old_actions = {
    -- 攻击(修改弹弓射击动作)
    {
        switch = true,
        id = "ATTACK",
        state = {
            testfn = function(inst, action)
                if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or (inst.components.health and inst.components.health:IsDead())) then
                    local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
                    return inst:HasTag("furry_nut_energy_bar") and weapon and weapon:HasTag("slingshot")
                end
            end,
            -- 客机动作劫持
            client_testfn = function(inst, action)
                if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or (inst.replica.health and inst.replica.health:IsDead())) then
                    local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                    return inst:HasTag("furry_nut_energy_bar") and weapon and weapon:HasTag("slingshot")
                end
            end,
            deststate = function(inst, action)
                inst.sg.mem.localchainattack = not action.forced or nil
                return "furry_slingshot_shoot"
            end,
        },
    },
}

return {
    old_actions = old_actions,
}
