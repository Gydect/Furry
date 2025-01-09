local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end
local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end

    local function OnExtended(inst, target)
        inst.components.timer:StopTimer("buffover")
        if duration then
            inst.components.timer:StartTimer("buffover", duration)
        end

        if onextendedfn ~= nil then
            onextendedfn(inst, target)
        end
    end

    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        if duration then
            inst.components.timer:StartTimer("buffover", duration)
        end
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab("buff_" .. name, fn, nil, prefabs)
end

local function RecalculatePlanarDamage(inst)
    local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if item then
        if not item.components.planardamage then
            item:AddComponent("planardamage")
            item._addplanardamage = true
        end
        item.components.planardamage:AddBonus(inst, 15, "furry_marshmallow")
    end

    local olditem = inst._furry_marshmallow_planarweapon
    if olditem ~= item then
        if olditem and olditem.components.planardamage then
            if olditem._addplanardamage then
                olditem:RemoveComponent("planardamage")
                olditem._addplanardamage = nil
            else
                olditem.components.planardamage:RemoveBonus(inst, "furry_marshmallow")
            end
        end
        inst._furry_marshmallow_planarweapon = item
    end
end

local function RemovePlanarDamage(inst)
    local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if item and item.components.planardamage then
        if item._addplanardamage then
            item:RemoveComponent("planardamage")
            item._addplanardamage = nil
        else
            item.components.planardamage:RemoveBonus(inst, "furry_marshmallow")
        end
    end
end

local function OnEquip(inst, data)
    if data ~= nil and data.item ~= nil then
        if data.eslot == EQUIPSLOTS.HANDS then
            RecalculatePlanarDamage(inst)
        end
    end
end

local function OnUnequip(inst, data)
    if data ~= nil and data.item ~= nil then
        if data.eslot == EQUIPSLOTS.HANDS then
            RecalculatePlanarDamage(inst)
        end
    end
end
--棉花糖buff锁定旺达老年伤害
local function CustomCombatDamage(inst, target, weapon, multiplier, mount)
    --判断是否有棉花糖buff
    if mount == nil and inst.components.debuffable and inst.components.debuffable:HasDebuff("buff_furry_marshmallow") then
        return TUNING.WANDA_SHADOW_DAMAGE_OLD
    end
    --调用旧方法
    return inst._furry_marshmallow_CustomCombatDamage and inst._furry_marshmallow_CustomCombatDamage(inst, target, weapon, multiplier, mount)
end
---给投射物加上10位面伤害
local function NutEnergyBarOnAttack(attacker, data)
    local projectile = data.projectile
    if projectile then
        if not projectile.components.planardamage then
            projectile:AddComponent("planardamage")
        end
        projectile.components.planardamage:AddBonus(attacker, 10, "furry_nut_energy_bar")
    end
end

local SPIDER_TAGS = { "spider" }
local function spider_update(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("pig")
        local x, y, z = owner.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.SPIDERHAT_RANGE, SPIDER_TAGS)
        for k, v in pairs(ents) do
            if v.components.follower and not v.components.follower.leader and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 10 then
                owner.components.leader:AddFollower(v)
            end
        end
    end
end

--buff列表
local buffs = {
    {
        --紫苏包肉制作减半buff
        name = "furry_perilla_wraps",
        onattachedfn = function(inst, target)
            if target.components.builder ~= nil then
                target.components.builder.ingredientmod = TUNING.GREENAMULET_INGREDIENTMOD
            end
            inst.onitembuild = function(owner, data)
                if not (data ~= nil and data.discounted == false) then
                    target:RemoveDebuff("buff_furry_perilla_wraps", "buff_furry_perilla_wraps")
                end
            end
            inst:ListenForEvent("consumeingredients", inst.onitembuild, target)
        end,
        ondetachedfn = function(inst, target)
            if target.components.builder ~= nil then
                target.components.builder.ingredientmod = 1
            end
            inst:RemoveEventCallback("consumeingredients", inst.onitembuild, target)
        end
    },
    {
        --棉花糖buff
        name = "furry_marshmallow",
        onattachedfn = function(inst, target)
            --旺达攻击锁定老年形态
            if target.components.combat then
                if not target._furry_marshmallow_CustomCombatDamage and target.components.combat.customdamagemultfn then
                    target._furry_marshmallow_CustomCombatDamage = target.components.combat.customdamagemultfn
                    target.components.combat.customdamagemultfn = CustomCombatDamage
                end
            end
            --第一种方法给装备增加位面伤害
            --RecalculatePlanarDamage(target)
            --inst:ListenForEvent("equip", OnEquip, target)
            --inst:ListenForEvent("unequip", OnUnequip, target)
            --第二种直接给人物加位面伤害
            if not target.components.planardamage then
                target:AddComponent("planardamage")
                --标记一下
                target._addplanardamage = true
            end
            target.components.planardamage:AddBonus(inst, 15, "furry_marshmallow")
        end,
        ondetachedfn = function(inst, target)
            --buff消失移除装备增加的额外位面伤害
            --RemovePlanarDamage(inst)
            --inst:RemoveEventCallback("equip", OnEquip, target)
            --inst:RemoveEventCallback("unequip", OnUnequip, target)
            --第二种方法
            if target.components.planardamage then
                --如果有标记，就移除位面伤害组件
                if target._addplanardamage then
                    target:RemoveComponent("planardamage")
                    --移除标记
                    target._addplanardamage = nil
                else
                    target.components.planardamage:RemoveBonus(inst, "furry_marshmallow")
                end
            end
        end,
        duration = 120
    },
    {
        --坚果能量棒buff
        name = "furry_nut_energy_bar",
        onattachedfn = function(inst, target)
            --监听onattackother，给投射物加上位面伤害
            inst:ListenForEvent("onattackother", NutEnergyBarOnAttack, target)
        end,
        ondetachedfn = function(inst, target)
            inst:RemoveEventCallback("onattackother", NutEnergyBarOnAttack, target)
        end,
        duration = 180
    },
    {
        --榴莲酱千层buff
        name = "furry_durian_mille_feuille",
        onattachedfn = function(inst, target)
            if target.components.hunger then
                target.components.hunger:SetPercent(0)
            end
            if target.components.locomotor then
                target.components.locomotor:SetExternalSpeedMultiplier(inst, "furry_durian_mille_feuille", 1.2)
            end
            --可以吃肉食
            if target.components.eater then
                local caneat = target.components.eater.caneat or {}
                local preferseating = target.components.eater.preferseating or {}
                table.insert(caneat, FOODTYPE.MEAT)
                table.insert(preferseating, FOODTYPE.MEAT)
                target.components.eater:SetDiet(caneat, preferseating)
            end
        end,
        ondetachedfn = function(inst, target)
            if target.components.locomotor then
                target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "furry_durian_mille_feuille")
            end
            if target.components.eater then
                local caneat = target.components.eater.caneat or {}
                local preferseating = target.components.eater.preferseating or {}
                for k, v in ipairs(caneat) do
                    if v == FOODTYPE.MEAT then
                        table.remove(caneat, k)
                        break
                    end
                end
                for k, v in ipairs(preferseating) do
                    if v == FOODTYPE.MEAT then
                        table.remove(preferseating, k)
                        break
                    end
                end
                target.components.eater:SetDiet(caneat, preferseating)
            end
        end,
        duration = 960
    },
    {
        --营养杯buff
        name = "furry_nutrition_cup",
        onattachedfn = function(inst, target)
            --缓慢回复30点血
            inst.task = inst:DoPeriodicTask(2, function()
                if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
                    target.components.health:DoDelta(2)
                end
            end)
        end,
        ondetachedfn = function(inst, target)
            if inst.task then
                inst.task:Cancel()
                inst.task = nil
            end
        end,
        duration = 30
    },
    {
        --红石榴丝绒千层buff
        name = "furry_pomegranate_velvet",
        onattachedfn = function(inst, target)
            target:AddTag("furry_pomegranate_velvet")
        end,
        ondetachedfn = function(inst, target)
            target:RemoveTag("furry_pomegranate_velvet")
        end,
        duration = 180
    },
    {
        --奶油蛤蜊炖蛋buff
        name = "furry_creamy_clam_egg_stew",
        onattachedfn = function(inst, target)
            --食用同种料理无惩罚
            if target.components.foodmemory and not target.FurryOldRememberFood then
                target.FurryOldRememberFood = target.components.foodmemory.RememberFood
                function target.components.foodmemory:RememberFood(...)
                    if self.inst:HasDebuff("buff_furry_creamy_clam_egg_stew") then
                        return
                    end
                    target.FurryOldRememberFood(self, ...)
                end
            end
        end,
        ondetachedfn = function(inst, target)
        end,
        duration = 360
    },
    {
        --甜腻蔬菜汤buff
        name = "furry_sweet_vegetable_soup",
        onattachedfn = function(inst, target)
            --移除hungrybuilder标签
            if target:HasTag("hungrybuilder") then
                target:RemoveTag("hungrybuilder")
                target.furry_hungrybuilder = true
            end
            --    饱食度下降缓慢
            if target.components.hunger then
                target.components.hunger.burnratemodifiers:SetModifier(inst, 0.5)
            end
            --    快速搬运重物
            target:AddTag("furry_strong")
        end,
        ondetachedfn = function(inst, target)
            if target.furry_hungrybuilder then
                target:AddTag("hungrybuilder")
                target.furry_hungrybuilder = nil
            end
            if target.components.hunger then
                target.components.hunger.burnratemodifiers:RemoveModifier(inst)
            end
            target:RemoveTag("furry_strong")
        end,
        duration = 720
    },
    {
        --香草甜筒buff
        name = "furry_vanilla_cone",
        onattachedfn = function(inst, target)
            if target and target.components.leader then
                target:AddTag("monster")
                target:AddTag("spiderdisguise")
            end
            inst.updatetask = inst:DoPeriodicTask(0.5, spider_update, 1)
        end,
        ondetachedfn = function(inst, target)
            if inst.updatetask then
                inst.updatetask:Cancel()
                inst.updatetask = nil
            end
            if target and target.components.leader then
                if not target:HasTag("spiderwhisperer") then
                    if not target:HasTag("playermonster") then
                        target:RemoveTag("monster")
                    end
                    target:RemoveTag("spiderdisguise")
                end
            end
        end,
        duration = 360
    },
    {
        --火鸡盛宴buff
        name = "furry_pomegranate_velvet",
        onattachedfn = function(inst, target)
            --    力量加成0.25
            if target.components.combat then
                target.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
            end
            --    每次攻击理智和回血翻倍
            if target.components.battleborn then
                local battleborn_bonus = target.components.battleborn.battleborn_bonus
                local clamp_max = target.components.battleborn.clamp_max
                target.components.battleborn:SetBattlebornBonus(battleborn_bonus * 2)
                target.components.battleborn:SetClampMax(clamp_max * 2)
            end
        end,
        ondetachedfn = function(inst, target)
            if target.components.combat then
                target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end
            if target.components.battleborn then
                local battleborn_bonus = target.components.battleborn.battleborn_bonus
                local clamp_max = target.components.battleborn.clamp_max
                target.components.battleborn:SetBattlebornBonus(battleborn_bonus / 2)
                target.components.battleborn:SetClampMax(clamp_max / 2)
            end
        end,
        duration = 180
    },
}
local ret = {}
for k, v in pairs(buffs) do
    table.insert(ret, MakeBuff(v.name, v.onattachedfn, v.onextendedfn, v.ondetachedfn, v.duration))
end

return unpack(ret)
