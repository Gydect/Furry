-- 人物专属
-- 狼奶
AddRecipe2(
    "furry_wolf_milk",
    { Ingredient(CHARACTER_INGREDIENT.SANITY, 15) },
    TECH.NONE,
    {
        builder_tag = "furry_yellowcat",
    },
    {
        "CHARACTER"
    }
)

-- 劣质黄油
AddRecipe2(
    "furry_butter",
    { Ingredient("furry_wolf_milk", 4) },
    TECH.NONE,
    {
        builder_tag = "furry_yellowcat",
    },
    {
        "CHARACTER"
    }
)
