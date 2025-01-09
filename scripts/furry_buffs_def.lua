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
        onextendedfn = function(inst, target)
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
}

return furry_buffs
