local assets =
{
    Asset("ANIM", "anim/furry_foods.zip"),
    Asset("SCRIPT", "scripts/prefabs/fertilizer_nutrient_defs.lua"),
}

local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local function OnBurn(inst)
    DefaultBurnFn(inst)
end

local function GetFertilizerKey(inst)
    return inst.prefab
end

local function fertilizerresearchfn(inst)
    return inst:GetFertilizerKey()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("furry_foods")
    inst.AnimState:SetBuild("furry_foods")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:OverrideSymbol("swap_food", "furry_foods", "furry_nutrition_cup")

    inst:AddTag("heal_fertilize")

    -- inst:AddTag("slowfertilize") -- 自我施肥标签

    MakeInventoryFloatable(inst)
    MakeDeployableFertilizerPristine(inst) -- 可施肥相关部署

    inst:AddTag("fertilizerresearchable")  -- 可以被耕作先驱研究

    inst.GetFertilizerKey = GetFertilizerKey -- 获取肥料密钥...

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("fertilizerresearchable")
    inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

    -- 就用肥料包的参数了
    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.COMPOSTWRAP_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.COMPOSTWRAP_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.COMPOSTWRAP_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.compostwrap.nutrients)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    -- 不知道,看别的肥料都有这个组件
    inst:AddComponent("smotherer")

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    inst.components.burnable:SetOnIgniteFn(OnBurn)
    MakeSmallPropagator(inst)

    MakeDeployableFertilizer(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("furry_nutrition_cup", fn, assets)
