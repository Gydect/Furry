local items =
{
    furry_butter =
    {
        test = function(cooker, names, tags)
            return names.furry_wolf_milk == 4
        end,
        priority = 20,
        cooktime = TUNING_FURRY.BUTTER.COOKTIME,
        perishtime = TUNING_FURRY.BUTTER.PERISH,
        floater = { "med", nil, 0.55 },
        overridebuild = "furry_foods",
        overridesymbolname = "furry_butter",

        health = TUNING_FURRY.BUTTER.HEALTH,
        hunger = TUNING_FURRY.BUTTER.HUNGER,
        sanity = TUNING_FURRY.BUTTER.SANITY,
    },
}

for k, v in pairs(items) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0

    v.cookbook_category = "mod"
    if v.overridebuild == nil then
        v.overridebuild = "furry_foods"
    end

    -- 烹饪指南里的料理贴图
    v.cookbook_atlas = "images/furry_cookbookimages.xml"
    v.cookbook_tex = "" .. k .. ".tex"
end

return items
