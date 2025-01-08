local assets =
{
    Asset("ANIM", "anim/furry_wolf_milk.zip"),
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

    inst.AnimState:SetBank("furry_wolf_milk")
    inst.AnimState:SetBuild("furry_wolf_milk")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)

    inst:AddTag("catfood")

    MakeInventoryFloatable(inst, "small", 0.15, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING_FURRY.WOLF_MILK.HEALTH
    inst.components.edible.hungervalue = TUNING_FURRY.WOLF_MILK.HUNGER
    inst.components.edible.sanityvalue = TUNING_FURRY.WOLF_MILK.SANITY
    inst.components.edible.foodtype = "GENERIC"

    inst:AddComponent("tradable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING_FURRY.WOLF_MILK.PERISH)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("furry_wolf_milk", fn, assets, prefabs)
