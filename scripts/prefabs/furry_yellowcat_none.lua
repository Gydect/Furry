local assets =
{
	Asset("ANIM", "anim/furry_yellowcat.zip"),
	Asset("ANIM", "anim/ghost_furry_yellowcat_build.zip"),
}

local skins =
{
	normal_skin = "furry_yellowcat",
	ghost_skin = "ghost_furry_yellowcat_build",
}

return CreatePrefabSkin("furry_yellowcat_none",
	{
		base_prefab = "furry_yellowcat",
		type = "base",
		assets = assets,
		skins = skins,
		skin_tags = { "FURRY_YELLOWCAT", "CHARACTER", "BASE" },
		build_name_override = "furry_yellowcat",
		rarity = "Character",
	})
