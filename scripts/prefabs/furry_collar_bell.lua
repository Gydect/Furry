local assets =
{
    Asset("ANIM", "anim/furry_collar_bell.zip"),
}

-- 隔热保暖判断
local function UpdateInsulation(inst)
    if inst.upgrade_data.eyebrellahat == true and inst.upgrade_data.trunkvest_winter == true then
        if TheWorld.state.iswinter then
            inst.components.insulator:SetWinter()
        elseif TheWorld.state.issummer then
            inst.components.insulator:SetSummer()
        end
    elseif inst.upgrade_data.eyebrellahat == true and inst.upgrade_data.trunkvest_winter == false then
        inst.components.insulator:SetSummer()
    elseif inst.upgrade_data.eyebrellahat == true and inst.upgrade_data.trunkvest_winter == false then
        inst.components.insulator:SetWinter()
    else
        inst.components.insulator:SetInsulation(0)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "furry_collar_bell", "collarbell")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
        if inst.components.fueled.currentfuel <= 0 then
            return
        end
    end

    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("furry_collar_bell_light")
    end
    inst._light.entity:SetParent(owner.entity)

    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
    else
        owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
    owner.components.health.externalabsorbmodifiers:SetModifier("furry_collar_bell", 0.02 * inst.upgrade_data.pigskin)
    UpdateInsulation(inst)
end

local function turnoff(inst)
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
end

local function onunequip(inst, owner)
    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PopBloom(inst)
    else
        owner.AnimState:ClearBloomEffectHandle()
    end

    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    turnoff(inst)
    owner.components.health.externalabsorbmodifiers:RemoveModifier("furry_collar_bell")
    UpdateInsulation(inst)
end

local function onequiptomodel(inst, owner, from_ground)
    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PopBloom(inst)
    else
        owner.AnimState:ClearBloomEffectHandle()
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    turnoff(inst)
end

local function CLIENT_PlayFuelSound(inst)
    local parent = inst.entity:GetParent()
    local container = parent ~= nil and (parent.replica.inventory or parent.replica.container) or nil
    if container ~= nil and container:IsOpenedBy(ThePlayer) then
        TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    end
end

local function SERVER_PlayFuelSound(inst)
    local owner = inst.components.inventoryitem.owner
    if owner == nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    elseif inst.components.equippable:IsEquipped() and owner.SoundEmitter ~= nil then
        owner.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    else
        inst.playfuelsound:push()
        --Dedicated server does not need to trigger sfx
        if not TheNet:IsDedicated() then
            CLIENT_PlayFuelSound(inst)
        end
    end
end

local function nofuel(inst, data)
    if inst.components.fueled.currentfuel <= 0 then
        inst.components.equippable.walkspeedmult = nil
        if inst.upgrade_data.eyebrellahat == true then
            inst.components.waterproofer:SetEffectiveness(0)
            inst.components.insulator:SetInsulation(0)
        end
        if inst.upgrade_data.trunkvest_winter == true then
            inst.components.insulator:SetInsulation(0)
        end
        turnoff(inst)
        if inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner.components.bloomer ~= nil then
                owner.components.bloomer:PopBloom(inst)
            else
                owner.AnimState:ClearBloomEffectHandle()
            end
            owner.components.health.externalabsorbmodifiers:RemoveModifier("furry_collar_bell")
        end
        inst.cb_nofule = true
    else
        if data.oldsection > 0 then
            return
        end
        inst.components.equippable.walkspeedmult = inst.upgrade_data.cane == true and 1.45 or 1.2
        if inst.upgrade_data.eyebrellahat == true then
            inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
            inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
            UpdateInsulation(inst)
        end
        if inst.upgrade_data.trunkvest_winter == true then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
            UpdateInsulation(inst)
        end
        if inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner

            inst.components.fueled:StartConsuming()

            if inst._light == nil or not inst._light:IsValid() then
                inst._light = SpawnPrefab("furry_collar_bell_light")
            end
            inst._light.entity:SetParent(owner.entity)

            if owner.components.bloomer ~= nil then
                owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
            else
                owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            end
            owner.components.health.externalabsorbmodifiers:SetModifier("furry_collar_bell", 0.02 * inst.upgrade_data.pigskin)
        end
        inst.cb_nofule = false
    end
end

local function UpgradeCollar(inst, item)
    if not item then return end

    if item.prefab == "cane" then
        inst.upgrade_data.cane = true
        inst.components.equippable.walkspeedmult = 1.45
        inst.components.talker:Say("移动速度加成提升至1.45！")
    elseif item.prefab == "eyebrellahat" then
        inst.upgrade_data.eyebrellahat = true
        inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        UpdateInsulation(inst)
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
        inst.components.talker:Say("提供120隔热与100%防水！")
    elseif item.prefab == "pigskin" then
        inst.upgrade_data.pigskin = inst.upgrade_data.pigskin + 1
        inst.components.talker:Say("减伤增加" .. (inst.upgrade_data.pigskin * 2) .. "%！")
    elseif item.prefab == "trunkvest_winter" then
        inst.upgrade_data.trunkvest_winter = true
        inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        inst.components.talker:Say("保温提升120点！")
    end

    -- 消耗给予的物品
    if item.components.stackable ~= nil and item.components.stackable:IsStack() then
        item.components.stackable:Get():Remove()
    else
        item:Remove()
    end
end

local function OnItemGiven(inst, giver, item)
    UpgradeCollar(inst, item)
end

local function AddUpgradable(inst)
    if inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end

    if inst.components.trader == nil then
        inst:AddComponent("trader")
        inst.components.trader:SetAbleToAcceptTest(function(inst, item)
            if item.prefab == "cane" and inst.upgrade_data.cane then
                return false
            elseif item.prefab == "eyebrellahat" and inst.upgrade_data.eyebrellahat then
                return false
            elseif item.prefab == "pigskin" and inst.upgrade_data.pigskin >= 10 then
                return false
            elseif item.prefab == "trunkvest_winter" and inst.upgrade_data.trunkvest_winter then
                return false
            end

            return item.prefab == "cane" or
                item.prefab == "eyebrellahat" or
                item.prefab == "pigskin" or
                item.prefab == "trunkvest_winter"
        end)
        inst.components.trader.onaccept = OnItemGiven
    end
end

local function onsave(inst, data)
    data.cb_nofule = inst.cb_nofule
    -- 保存升级状态
    data.cane = inst.upgrade_data.cane
    data.eyebrellahat = inst.upgrade_data.eyebrellahat
    data.pigskin = inst.upgrade_data.pigskin
    data.trunkvest_winter = inst.upgrade_data.trunkvest_winter
end

local function onpreload(inst, data)
    if data then
        if data.cb_nofule then
            inst.cb_nofule = data.cb_nofule
        end
        if data.cane then
            inst.upgrade_data.cane = data.cane
        end
        if data.eyebrellahat then
            inst.upgrade_data.eyebrellahat = data.eyebrellahat
        end
        if data.pigskin then
            inst.upgrade_data.pigskin = data.pigskin
        end
        if data.trunkvest_winter then
            inst.upgrade_data.trunkvest_winter = data.trunkvest_winter
        end
    end
end

local function OnLoad(inst)
    if inst.cb_nofule == true then
        inst.components.equippable.walkspeedmult = nil
        turnoff(inst)
    else
        inst.components.equippable.walkspeedmult = inst.upgrade_data.cane == true and 1.45 or 1.2
        if inst.upgrade_data.eyebrellahat == true then
            inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
            inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
            UpdateInsulation(inst)
        end
        if inst.upgrade_data.trunkvest_winter == true then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
            UpdateInsulation(inst)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("furry_collar_bell")
    inst.AnimState:SetBuild("furry_collar_bell")
    inst.AnimState:PlayAnimation("idle")

    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")

    inst.foleysound = "dontstarve/movement/foley/jewlery"

    inst.playfuelsound = net_event(inst.GUID, "amulet.playfuelsound")

    if not TheWorld.ismastersim then
        --delayed because we don't want any old events
        inst:DoTaskInTime(0, inst.ListenForEvent, "amulet.playfuelsound", CLIENT_PlayFuelSound)
    end

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.cb_nofule = false
    inst.upgrade_data = {
        cane = false,
        eyebrellahat = false,
        pigskin = 0,
        trunkvest_winter = false,
    }

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    inst.components.equippable.walkspeedmult = 1.2

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(turnoff)

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.AMULET_SHADOW_LEVEL)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(960)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true
    inst.components.fueled:SetTakeFuelFn(SERVER_PlayFuelSound)

    inst:AddComponent("talker")

    inst:AddComponent("insulator")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    -- 添加升级功能
    AddUpgradable(inst)

    inst:ListenForEvent("onfueldsectionchanged", nofuel)

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload
    inst.OnLoad = OnLoad

    MakeHauntableLaunch(inst)

    inst._light = nil
    inst.OnRemoveEntity = turnoff


    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.65)
    inst.Light:SetColour(223 / 255, 208 / 255, 69 / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("furry_collar_bell", fn, assets, { "furry_collar_bell_light" }),
    Prefab("furry_collar_bell_light", lightfn)
