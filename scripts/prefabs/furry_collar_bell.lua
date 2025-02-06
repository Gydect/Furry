local assets =
{
    Asset("ANIM", "anim/furry_collar_bell.zip"),
}

local ITEMS = {
    { "deerclops_eyeball", 1 },
    { "pigskin",           5 },
    { "lightbulb",         10 },
    { "horrorfuel",        1 },
    { "purebrilliance",    1 },
    { "trunk_winter",      1 },
    { "tentaclespots",     2 },
    { "walrus_tusk",       1 },
}

local function UpdateInsulator(inst)
    local self = inst.components.cb_itemupgrade
    if (TheWorld.state.isspring or TheWorld.state.iswinter) then
        if self:IsMax("trunk_winter") then
            if not inst.components.insulator then
                inst:AddComponent("insulator")
            end
            inst.components.insulator:SetWinter()
            inst.components.insulator:SetInsulation(240)
        else
            inst:RemoveComponent("insulator")
        end
    else
        if self:IsMax("deerclops_eyeball") then
            if not inst.components.insulator then
                inst:AddComponent("insulator")
            end
            inst.components.insulator:SetSummer()
            inst.components.insulator:SetInsulation(240)
        else
            inst:RemoveComponent("insulator")
        end
    end
end


local function GetGarnisher(inst)
    return inst.components.equippable:IsEquipped()
        and inst.components.inventoryitem.owner
        or nil
end

local function SetLight(inst, enable)
    if enable then
        local owner = inst.components.inventoryitem.owner

        local light = SpawnPrefab("lanternlight")
        light.OnEntityWake = nil
        light.SoundEmitter:KillSound("loop")
        light.Light:SetIntensity(0.8)
        light.Light:SetRadius(5)
        light.Light:SetFalloff(.9)
        light.entity:SetParent(owner.entity)
        light:ListenForEvent("onremove", function() light:Remove() end, inst)
        inst._light = light
    else
        if inst._light then
            inst._light:Remove()
            inst._light = nil
        end
    end
end

local function OnIsDay(inst, isday)
    local owner = inst.components.inventoryitem.owner
    local enable = not isday
        and owner
        and inst.components.cb_itemupgrade:IsMax("lightbulb")
    SetLight(inst, enable)
end


local function OnUpgrade(inst, data, doer)
    local self = inst.components.cb_itemupgrade
    if self:IsMax("deerclops_eyeball") and not data.deerclops_eyeball then
        -- 240隔热
        UpdateInsulator(inst)
        data.deerclops_eyeball = true
    end

    if self:IsMax("pigskin") and not data.pigskin then
        -- 20％防御
        local owner = GetGarnisher(inst)
        if owner and owner.components.combat then
            owner.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.8)
        end
        data.pigskin = true
    end

    if self:IsMax("lightbulb") and not data.lightbulb then
        -- 范围发光
        local owner = GetGarnisher(inst)
        if owner then
            OnIsDay(inst, TheWorld.state.isday)
        end
        data.lightbulb = true
    end

    -- 位面防御
    local planardefense = (self:IsMax("horrorfuel") and 5 or 0)
        + (self:IsMax("purebrilliance") and 5 or 0)
    if planardefense > 0 then
        if not inst.components.planardefense then
            inst:AddComponent("planardefense")
        end
        inst.components.planardefense:SetBaseDefense(planardefense)
    end

    if self:IsMax("horrorfuel") and self:IsMax("purebrilliance") and not data.horrorfuel_purebrilliance then
        -- 只能加在角色身上
        local owner = GetGarnisher(inst)
        if owner and owner.components.planardamage then
            owner.components.planardamage:AddBonus(inst, 10)
        end

        data.horrorfuel_purebrilliance = true
    end

    if self:IsMax("trunk_winter") and not data.trunk_winter then
        -- 240保暖
        UpdateInsulator(inst)
        data.trunk_winter = true
    end

    if self:IsMax("tentaclespots") and not data.tentaclespots then
        -- 100%防水
        if not inst.components.waterproofer then
            inst:AddComponent("waterproofer")
        end
        data.tentaclespots = true
    end

    if self:IsMax("walrus_tusk") then
        -- 25%移速
        inst.components.equippable.walkspeedmult = 1.25
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "furry_collar_bell", "collarbell")

    local self = inst.components.cb_itemupgrade

    if owner.components.combat and self:IsMax("pigskin") then
        owner.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.8)
    end

    if self:IsMax("horrorfuel") and self:IsMax("purebrilliance") and owner.components.planardamage then
        owner.components.planardamage:AddBonus(inst, 10)
    end

    -- 微弱照明
    inst:WatchWorldState("isday", OnIsDay)
    OnIsDay(inst, TheWorld.state.isday)

    if owner.cb_nightvision and self:IsMax("purplegem") then
        owner.cb_nightvision:set(true)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if owner.components.combat then
        owner.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, 0.8)
    end

    owner.components.planardamage:RemoveBonus(inst, 10)

    inst:StopWatchingWorldState("isday", OnIsDay)
    SetLight(inst, false)

    if owner.cb_nightvision then
        owner.cb_nightvision:set(false)
    end
end

local function OnPercentUsedChange(inst, data)
    if data and data.percent then
        if data.percent <= 0 and inst._light then
            SetLight(inst, false)
        elseif data.percent > 0 and GetGarnisher(inst) and not inst._light then
            OnIsDay(inst, TheWorld.state.isday)
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

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst:AddComponent("cb_itemupgrade"):Setup(ITEMS, OnUpgrade)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("inventoryitem")

    inst:WatchWorldState("season", UpdateInsulator)

    inst:ListenForEvent("percentusedchange", OnPercentUsedChange)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("furry_collar_bell", fn, assets)
