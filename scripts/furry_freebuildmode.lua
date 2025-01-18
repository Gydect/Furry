AddRecipePostInitAny(function(recipe)
    if recipe.canbuild ~= nil then
        recipe.FurryCanbuild = recipe.canbuild
        --修改配方的canbuild函数
        function recipe:canbuild(inst, ...)
            local success, msg = recipe:FurryCanbuild(self, inst, ...)
            if not success and inst.components.builder and inst.components.builder.furryfreebuildmode then
                success = true
            end
            return success, msg
        end
    end
end)

local function OnRecipesDirty(inst)
    if inst._parent ~= nil then
        inst._parent:PushEvent("unlockrecipe")
    end
end

local function player_classified(inst)
    inst.furryisfreebuildmode = net_bool(inst.GUID, "builder.furryisfreebuildmode", "furryrecipesdirty")
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("furryrecipesdirty", OnRecipesDirty)
    end
end
AddPrefabPostInit("player_classified", player_classified)

local function onfreebuildmode(self, freebuildmode)
    self.inst.replica.builder:SetIsFurryFreeBuildMode(freebuildmode)
end
local function builder(self)
    local _ = rawget(self, "_")
    _.furryfreebuildmode = { nil, onfreebuildmode }
    self.furryfreebuildmode = false

    local OldKnowsRecipe = self.KnowsRecipe
    function self:KnowsRecipe(recipe, ignore_tempbonus, ...)
        local result = OldKnowsRecipe(self, recipe, ignore_tempbonus, ...)
        if result then
            return result
        end
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end

        if recipe == nil then
            return false
        end

        if self.furryfreebuildmode then
            return true
        end
    end

    local OldBufferBuild = self.BufferBuild
    function self:BufferBuild(recname, ...)
        OldBufferBuild(self, recname, ...)
        if self.buffered_builds[recname] then
            self.inst:PushEvent("furry_build")
        end
    end

    local OldDoBuild = self.DoBuild
    function self:DoBuild(recname, pt, rotation, skin, ...)
        local is_buffered_build = self.buffered_builds[recname] ~= nil
        local result = OldDoBuild(self, recname, pt, rotation, skin, ...)
        if result and not is_buffered_build then
            self.inst:PushEvent("furry_build")
        end
        return result
    end
end
AddComponentPostInit("builder", builder)
local function builder_replica(self)
    function self:SetIsFurryFreeBuildMode(isfreebuildmode)
        if self.classified ~= nil then
            self.classified.furryisfreebuildmode:set(isfreebuildmode)
        end
    end

    function self:IsFurryFreeBuildMode()
        if self.classified ~= nil then
            return self.classified.furryisfreebuildmode:value()
        end
    end

    local OldKnowsRecipe = self.KnowsRecipe
    function self:KnowsRecipe(recipe, ignore_tempbonus, ...)
        local result = OldKnowsRecipe(self, recipe, ignore_tempbonus, ...)
        if result then
            return result
        end
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end
        if not self.inst.components.builder and self.classified then
            if recipe and self.classified.furryisfreebuildmode:value() then
                return true
            end
        end
        return result
    end
end
AddClassPostConstruct("components/builder_replica", builder_replica)
local function craftingmenu_widget(self)
    local OldUpdateFilterButtons = self.UpdateFilterButtons
    function self:UpdateFilterButtons()
        OldUpdateFilterButtons(self)
        local builder = self.owner ~= nil and self.owner.replica.builder or nil
        if builder ~= nil then
            if builder:IsFurryFreeBuildMode() then
                self.crafting_station_filter:SetHoverText(STRINGS.UI.CRAFTING_FILTERS.CRAFTING_STATION)
                self.crafting_station_filter:Show()
            end
        end
    end
end
AddClassPostConstruct("widgets/redux/craftingmenu_widget", craftingmenu_widget)
local function craftingmenu_hud(self)
    local OldRebuildRecipes = self.RebuildRecipes
    function self:RebuildRecipes(...)
        OldRebuildRecipes(self, ...)
        if self.owner ~= nil and self.owner.replica.builder ~= nil then
            local builder = self.owner.replica.builder
            local freecrafting = builder:IsFurryFreeBuildMode()
            for k, recipe in pairs(AllRecipes) do
                if IsRecipeValid(recipe.name) then
                    local meta = self.valid_recipes[recipe.name].meta
                    if freecrafting and meta.build_state == "hide" then
                        meta.can_build = builder:HasIngredients(recipe)
                        meta.build_state = meta.can_build and "has_ingredients" or "no_ingredients"
                    end
                end
            end
        end
    end
end
AddClassPostConstruct("widgets/redux/craftingmenu_hud", craftingmenu_hud)