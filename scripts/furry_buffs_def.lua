--==============================
--[[ 酥麻蝴蝶派buff相关函数 ]]
--==============================
local function taser_cooldown(inst)
    inst._cdtask = nil
end
local function taser_onblockedorattacked(wx, data, inst)
    if (data ~= nil and data.attacker ~= nil and not data.redirected) and inst._cdtask == nil then
        inst._cdtask = inst:DoTaskInTime(0.3, taser_cooldown)

        if data.attacker.components.combat ~= nil
            and (data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead())
            and (data.attacker.components.inventory == nil or not data.attacker.components.inventory:IsInsulated())
            and (data.weapon == nil or
                (data.weapon.components.projectile == nil
                    and (data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil))
            ) then
            SpawnPrefab("electrichitsparks"):AlignToTarget(data.attacker, wx, true)

            local damage_mult = 1
            if not (data.attacker:HasTag("electricdamageimmune") or
                    (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated())) then
                damage_mult = TUNING.ELECTRIC_DAMAGE_MULT

                local wetness_mult = (data.attacker.components.moisture ~= nil and data.attacker.components.moisture:GetMoisturePercent())
                    or (data.attacker:GetIsWet() and 1)
                    or 0
                damage_mult = damage_mult + wetness_mult
            end

            data.attacker.components.combat:GetAttacked(wx, damage_mult * TUNING.WX78_TASERDAMAGE, nil, "electric")
        end
    end
end

local function herbal_tea_read(wicker, data)
    local book = data.book
    if data.success == true then
        if book.prefab == "book_tentacles" or book.prefab == "book_birds" or book.prefab == "book_bees"
            or book.prefab == "book_horticulture" or book.prefab == "book_horticulture_upgraded"
            or book.prefab == "book_brimstone" then
            if book.components.book.onread ~= nil then
                book.components.book.onread(book, wicker)
            end
        else
            return
        end
        wicker:RemoveDebuff("buff_furry_herbal_tea")
    end
end

--================
--[[ buff列表 ]]
--================
local furry_buffs = {
    -- 冒菜炖肉
    furry_spicy_stew = {
        name = "furry_spicy_stew",
        onattachedfn = function(inst, target)
            if target.components.combat ~= nil then
                target.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
            end

            -- 为伯尼绑定攻击力加成
            local function apply_bernie_buff()
                if target.bigbernies ~= nil then
                    for bigbernie, _ in pairs(target.bigbernies) do
                        if bigbernie.components.combat ~= nil then
                            bigbernie.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
                        end
                    end
                end
            end
            inst._bernie_buff_task = target:DoPeriodicTask(1, apply_bernie_buff) -- 每秒检查
        end,
        ondetachedfn = function(inst, target)
            if target.components.combat ~= nil then
                target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end

            -- 移除伯尼的攻击力加成
            if inst._bernie_buff_task ~= nil then
                inst._bernie_buff_task:Cancel()
                inst._bernie_buff_task = nil
                if target.bigbernies ~= nil then
                    for bigbernie, _ in pairs(target.bigbernies) do
                        if bigbernie.components.combat ~= nil then
                            bigbernie.components.combat.externaldamagemultipliers:RemoveModifier(inst)
                        end
                    end
                end
            end
        end,
        duration = 180, -- 持续时间 180 秒
        prefabs = {},
    },

    -- 芝士土豆焗奶(移速加成)
    furry_cheese_potato_bake_a = {
        name = "furry_cheese_potato_bake_a",
        onattachedfn = function(inst, target)
            if target.components.locomotor then
                target.components.locomotor:SetExternalSpeedMultiplier(inst, "furry_cheese_potato_bake", 1.2)
            end
        end,
        ondetachedfn = function(inst, target)
            if target.components.locomotor then
                target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "furry_cheese_potato_bake")
            end
        end,
        duration = 180,
    },

    -- 芝士土豆焗奶(饱食度下降减缓&&锁定健身值)
    furry_cheese_potato_bake_b = {
        name = "furry_cheese_potato_bake_b",
        onattachedfn = function(inst, target)
            if target.components.hunger ~= nil then
                target.components.hunger.burnratemodifiers:SetModifier(inst, 0.5)
            end
            if target.components.mightiness ~= nil then
                target.components.mightiness:Furry_Lock()
            end
        end,
        ondetachedfn = function(inst, target)
            if target.components.hunger ~= nil then
                target.components.hunger.burnratemodifiers:SetModifier(inst, 0.5)
            end
            if target.components.mightiness ~= nil then
                target.components.mightiness:Furry_Unlock()
            end
        end,
        duration = 720,
    },

    -- 香蕉冻奶布丁
    furry_banana_milk_pudding = {
        name = "furry_banana_milk_pudding",
        onattachedfn = function(inst, target)
            if target.components.combat ~= nil then
                target.components.combat.externaldamagemultipliers:SetModifier(inst, 4 / 3)
            end
            local function apply_abigail_buff()
                if target.components.leader ~= nil then
                    for follower, _ in pairs(target.components.leader.followers) do
                        if follower.prefab == "abigail" then
                            if follower:HasTag("furry_banana_milk_pudding") then
                                return
                            end
                            follower:AddTag("furry_banana_milk_pudding")
                            follower.UpdateDamage(follower)
                        end
                    end
                end
            end
            inst._abigail_buff_task = target:DoPeriodicTask(1, apply_abigail_buff)
        end,
        ondetachedfn = function(inst, target)
            if target.components.combat ~= nil then
                target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end
            if inst._abigail_buff_task ~= nil then
                inst._abigail_buff_task:Cancel()
                inst._abigail_buff_task = nil
                if target.components.leader ~= nil then
                    for follower, _ in pairs(target.components.leader.followers) do
                        if follower.prefab == "abigail" then
                            follower:RemoveTag("furry_banana_milk_pudding")
                            follower.UpdateDamage(follower)
                        end
                    end
                end
            end
        end,
        duration = 480,
    },

    -- 酥麻蝴蝶派
    furry_crispy_butterfly_pie = {
        name = "furry_crispy_butterfly_pie",
        onattachedfn = function(inst, target)
            -- 攻击带电部分
            if target.components.electricattacks == nil then
                target:AddComponent("electricattacks")
            end
            target.components.electricattacks:AddSource(inst)
            if inst._onattackother == nil then
                inst._onattackother = function(attacker, data)
                    if data.weapon ~= nil then
                        if data.projectile == nil then
                            if data.weapon.components.projectile ~= nil then
                                return
                            elseif data.weapon.components.complexprojectile ~= nil then
                                return
                            elseif data.weapon.components.weapon:CanRangedAttack() then
                                return
                            end
                        end
                        if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
                            return
                        end
                    end
                    if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
                        SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
                    end
                end
                inst:ListenForEvent("onattackother", inst._onattackother, target)
            end
            SpawnPrefab("electricchargedfx"):SetTarget(target)

            -- 被攻击带电反伤部分
            if inst._onblocked == nil then
                inst._onblocked = function(owner, data)
                    taser_onblockedorattacked(owner, data, inst)
                end
            end

            inst:ListenForEvent("blocked", inst._onblocked, target)
            inst:ListenForEvent("attacked", inst._onblocked, target)

            if target.components.inventory ~= nil then
                target.components.inventory.isexternallyinsulated:SetModifier(inst, true)
            end
        end,
        onextendedfn = function(inst, target)
            SpawnPrefab("electricchargedfx"):SetTarget(target)
        end,
        ondetachedfn = function(inst, target)
            -- 攻击带电部分
            if target.components.electricattacks ~= nil then
                target.components.electricattacks:RemoveSource(inst)
            end
            if inst._onattackother ~= nil then
                inst:RemoveEventCallback("onattackother", inst._onattackother, target)
                inst._onattackother = nil
            end

            -- 被攻击带电反伤部分
            inst:RemoveEventCallback("blocked", inst._onblocked, target)
            inst:RemoveEventCallback("attacked", inst._onblocked, target)

            if target.components.inventory ~= nil then
                target.components.inventory.isexternallyinsulated:RemoveModifier(inst)
            end
        end,
        duration = 480,
    },

    -- 提神花草茶
    furry_herbal_tea = {
        name = "furry_herbal_tea",
        onattachedfn = function(inst, target)
            target:ListenForEvent("furry_read", herbal_tea_read)
        end,
        ondetachedfn = function(inst, target)
            target:RemoveEventCallback("furry_read", herbal_tea_read)
        end,
    },

    --恒温
    furry_constant_temperature = {
        name = "furry_constant_temperature",
        onattachedfn = function(inst, target)
            if target.components.temperature then
                inst.task = inst:DoPeriodicTask(0, function()
                    local current = target.components.temperature:GetCurrent()
                    if current < 30 then
                        target.components.temperature:SetTemperature(35)
                    elseif current > 40 then
                        target.components.temperature:SetTemperature(35)
                    end
                end, nil, target)
            end
        end,
        ondetachedfn = function(inst, target)
            if inst.task ~= nil then
                inst.task:Cancel()
                inst.task = nil
            end
        end,
        duration = 180,
    },
}

return furry_buffs
