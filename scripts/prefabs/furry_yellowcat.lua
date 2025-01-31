local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("ANIM", "anim/furry_yellowcat.zip"),
    Asset("ANIM", "anim/ghost_furry_yellowcat_build.zip"),
}

-- Your character's stats
TUNING.FURRY_YELLOWCAT_HEALTH = 125
TUNING.FURRY_YELLOWCAT_HUNGER = 150
TUNING.FURRY_YELLOWCAT_SANITY = 200

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.FURRY_YELLOWCAT = {
    "furry_collar_bell",
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.FURRY_YELLOWCAT
end
local prefabs = FlattenTree(start_inv, true)

-- When the character is revived from human
local function onbecamehuman(inst)
    -- Set speed when not a ghost (optional)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "furry_yellowcat_speed_mod", 1)
end

local function onbecameghost(inst)
    -- Remove speed modifier when becoming a ghost
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "furry_yellowcat_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
    -- Minimap icon
    inst.MiniMapEntity:SetIcon("furry_yellowcat.tex")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
    -- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

    -- choose which sounds this character will play
    inst.soundsname = "willow"

    -- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"

    -- Stats	
    inst.components.health:SetMaxHealth(TUNING.FURRY_YELLOWCAT_HEALTH)
    inst.components.hunger:SetMax(TUNING.FURRY_YELLOWCAT_HUNGER)
    inst.components.sanity:SetMax(TUNING.FURRY_YELLOWCAT_SANITY)

    -- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1

    -- Hunger rate (optional)
    inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

    inst:AddComponent("furry_milking")

    inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("furry_yellowcat", prefabs, assets, common_postinit, master_postinit, prefabs)
