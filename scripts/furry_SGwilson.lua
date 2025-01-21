-- 此处参数使用了能力勋章mod的代码,暂时这样子吧,回头沃尔特技能树更新的时候看看官方的加攻速代码
AddStategraphState('wilson',
    -- 快速射击动画
    State {
        name = "furry_slingshot_shoot",
        tags = { "attack" },

        onenter = function(inst)
            if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            if target ~= nil and target:IsValid() then
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
                inst.sg.statemem.attacktarget = target -- this is to allow repeat shooting at the same target
            end

            inst.sg.statemem.abouttoattack = true

            -- inst.AnimState:PlayAnimation("slingshot_pre")
            inst.AnimState:PlayAnimation("sand_idle_pre")
            inst.AnimState:PushAnimation("slingshot", false)

            if inst.sg.laststate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetTime(3 * FRAMES)
            end

            inst.components.combat:StartAttack()
            inst.components.combat:SetTarget(target)
            inst.components.locomotor:Stop()

            inst.sg:SetTimeout((inst.sg.statemem.chained and 25 or 28) * FRAMES)
        end,

        timeline =
        {
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.chained then
                    local buffaction = inst:GetBufferedAction()
                    local target = buffaction ~= nil and buffaction.target or nil
                    if not (target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target)) then
                        inst:ClearBufferedAction()
                        inst.sg:GoToState("idle")
                    end
                end
            end),

            TimeEvent(2 * FRAMES, function(inst) -- start of slingshot
                if inst.sg.statemem.chained then
                    inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
                end
            end),

            TimeEvent(8 * FRAMES, function(inst)
                if inst.sg.statemem.chained then
                    local buffaction = inst:GetBufferedAction()
                    local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                    if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
                        local target = buffaction ~= nil and buffaction.target or nil
                        if target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target) then
                            inst.sg.statemem.abouttoattack = false
                            inst:PerformBufferedAction()
                            inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
                        else
                            inst:ClearBufferedAction()
                            inst.sg:GoToState("idle")
                        end
                    else -- out of ammo
                        inst:ClearBufferedAction()
                        MedalSay(inst, STRINGS.MEDAL_SHOT_SPEECH.NOAMMO)
                        inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/no_ammo")
                    end
                end
            end),

            TimeEvent(4 * FRAMES, function(inst)
                if not inst.sg.statemem.chained then
                    local buffaction = inst:GetBufferedAction()
                    local target = buffaction ~= nil and buffaction.target or nil
                    if not (target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target)) then
                        inst:ClearBufferedAction()
                        inst.sg:GoToState("idle")
                    end
                end
            end),

            TimeEvent(5 * FRAMES, function(inst) -- start of slingshot
                if not inst.sg.statemem.chained then
                    inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
                end
            end),

            TimeEvent(11 * FRAMES, function(inst)
                if not inst.sg.statemem.chained then
                    local buffaction = inst:GetBufferedAction()
                    local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                    if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
                        local target = buffaction ~= nil and buffaction.target or nil
                        if target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target) then
                            inst.sg.statemem.abouttoattack = false
                            inst:PerformBufferedAction()
                            inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
                        else
                            inst:ClearBufferedAction()
                            inst.sg:GoToState("idle")
                        end
                    else
                        inst:ClearBufferedAction()
                        MedalSay(inst, STRINGS.MEDAL_SHOT_SPEECH.NOAMMO)
                        inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/no_ammo")
                    end
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            if inst.sg.statemem.abouttoattack and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
        end,
    }
)

AddStategraphState('wilson_client',
    -- 快速射击动画
    State {
        name = "furry_slingshot_shoot",
        tags = { "attack" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            -- inst.AnimState:PlayAnimation("slingshot_pre")
            -- inst.AnimState:PushAnimation("slingshot_lag", true)
            inst.AnimState:PlayAnimation("sand_idle_pre")
            inst.AnimState:PushAnimation("slingshot", false)

            if inst.sg.laststate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetTime(3 * FRAMES)
            end

            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:ForceFacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                end

                inst:PerformPreviewBufferedAction()
            end

            inst.sg:SetTimeout(2)
        end,

        onupdate = function(inst)
            if inst.sg.timeinstate >= (inst.sg.statemem.chained and 27 or 30) * FRAMES and inst.sg.statemem.flattened_time == nil and inst:HasTag("attack") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg.statemem.flattened_time = inst.sg.timeinstate
                    inst.sg:AddStateTag("idle")
                    inst.sg:AddStateTag("canrotate")
                    inst.entity:SetIsPredictingMovement(false)
                end
            end

            if inst.bufferedaction == nil and inst.sg.statemem.flattened_time ~= nil and inst.sg.statemem.flattened_time < inst.sg.timeinstate then
                inst.sg.statemem.flattened_time = nil
                inst.entity:SetIsPredictingMovement(true)
                inst.sg:RemoveStateTag("attack")
                inst.sg:AddStateTag("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.flattened_time ~= nil then
                inst.entity:SetIsPredictingMovement(true)
            end
        end,
    }
)
