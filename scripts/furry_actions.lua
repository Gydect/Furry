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
            --客机动作劫持
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
