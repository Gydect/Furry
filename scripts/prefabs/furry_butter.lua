local assets =
{
    Asset("ANIM", "anim/furry_foods.zip"),
}

local prefabs =
{
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("furry_foods")
    inst.AnimState:SetBuild("furry_foods")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:OverrideSymbol("swap_food", "furry_foods", "furry_butter")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst:AddComponent("tradable")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING_FURRY.BUTTER.HEALTH
    inst.components.edible.hungervalue = TUNING_FURRY.BUTTER.HUNGER

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING_FURRY.BUTTER.PERISH)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("furry_butter", fn, assets, prefabs)
