local _G = GLOBAL
--================================================================================================================
--[[ 重写小木牌(插在地上的)的绘图机制，让小木牌可以画上本mod里的物品 ]]
--================================================================================================================
local invPrefabList = require("furry_minisign_list") -- mod中有物品栏图片的prefabs的表
local invBuildMaps = { "furry_minisign1" }
local function OnDrawn_minisign(inst, image, src, atlas, bgimage, bgatlas, ...)
    -- 这里image是所用图片的名字，而非prefab的名字
    if inst.drawable_ondrawnfn_furry ~= nil then
        inst.drawable_ondrawnfn_furry(inst, image, src, atlas, bgimage, bgatlas, ...)
    end
    -- src在重载后就没了，所以没法让信息存在src里
    if image ~= nil and invPrefabList[image] ~= nil then
        inst.AnimState:OverrideSymbol("SWAP_SIGN", invBuildMaps[invPrefabList[image]] or invBuildMaps[1], image)
    end
    if bgimage ~= nil and invPrefabList[bgimage] ~= nil then
        inst.AnimState:OverrideSymbol("SWAP_SIGN_BG", invBuildMaps[invPrefabList[bgimage]] or invBuildMaps[1], bgimage)
    end
end
local function MiniSign_init(inst)
    if inst.drawable_ondrawnfn_furry == nil and inst.components.drawable ~= nil then
        inst.drawable_ondrawnfn_furry = inst.components.drawable.ondrawnfn
        inst.components.drawable:SetOnDrawnFn(OnDrawn_minisign)
    end
end
AddPrefabPostInit("minisign", MiniSign_init)
AddPrefabPostInit("minisign_drawn", MiniSign_init)
AddPrefabPostInit("decor_pictureframe", MiniSign_init)

--================================================================================================================
--[[ 高清256*256贴图兼容棱镜的白木展示柜 ]]
--================================================================================================================
local function Furry_SetShowSlot(inst, slot)
    local item = inst.components.container.slots[slot]
    if item ~= nil then
        local bgimage
        local image = FunctionOrValue(item.drawimageoverride, item, inst) or (#(item.components.inventoryitem.imagename or "") > 0 and item.components.inventoryitem.imagename) or item.prefab or nil
        if image ~= nil then
            if item.inv_image_bg ~= nil and item.inv_image_bg.image ~= nil and item.inv_image_bg.image:len() > 4 and item.inv_image_bg.image:sub(-4):lower() == ".tex" then
                bgimage = item.inv_image_bg.image:sub(1, -5)
            end
            if invPrefabList[image] ~= nil then
                inst.AnimState:ClearOverrideSymbol("slot" .. tostring(slot))
                inst.AnimState:OverrideSymbol("slot" .. tostring(slot), invBuildMaps[invPrefabList[image]] or invBuildMaps[1], image)
            end
            if bgimage ~= nil then
                if invPrefabList[bgimage] ~= nil then
                    inst.AnimState:ClearOverrideSymbol("slotbg" .. tostring(slot))
                    inst.AnimState:OverrideSymbol("slotbg" .. tostring(slot), invBuildMaps[invPrefabList[bgimage]] or invBuildMaps[1], bgimage)
                end
            end
        end
    end
end
local function Furry_ItemGet_chest(inst, data)
    if data and data.slot and data.slot <= inst.shownum_l then
        Furry_SetShowSlot(inst, data.slot)
    end
end
local function HookWhitewood(inst)
    if not TheWorld.ismastersim then
        return
    end
    local old_onclosefn = inst.components.container.onclosefn
    local function OnClose_chest(inst)
        old_onclosefn(inst)
        if not inst:HasTag("burnt") then
            for i = 1, inst.shownum_l, 1 do
                Furry_SetShowSlot(inst, i)
            end
        end
    end
    inst.components.container.onclosefn = OnClose_chest
    inst:ListenForEvent("itemget", Furry_ItemGet_chest)
end
if _G.FURRY_SETS.ENABLEDMODS["legion"] then
    AddPrefabPostInit("chest_whitewood", HookWhitewood)
    AddPrefabPostInit("chest_whitewood_inf", HookWhitewood)
    AddPrefabPostInit("chest_whitewood_big", HookWhitewood)
    AddPrefabPostInit("chest_whitewood_big_inf", HookWhitewood)
end

--================================================================================================================
--[[ 给部分物品添加可以交易的组件，使其可以给予铃铛 ]]
--================================================================================================================
local function AddTradableToPrefab(prefab_name)
    AddPrefabPostInit(prefab_name, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.tradable == nil then
            inst:AddComponent("tradable")
        end
    end)
end
-- 添加 Tradable 组件到目标物品
local target_items = { "eyebrellahat", "cane", "trunkvest_winter", "pigskin" }
for _, prefab_name in ipairs(target_items) do
    AddTradableToPrefab(prefab_name)
end

--================================================================================================================
--[[hook移除组件，甜腻蔬菜汤buff快速搬运重物 ]]
--================================================================================================================
AddComponentPostInit("locomotor", function(self)
    local oldGetSpeedMultiplier = self.GetSpeedMultiplier
    if TheWorld.ismastersim then
        self.GetSpeedMultiplier = function(self)
            if self.inst:HasTag("furry_strong") and not (self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding()) then
                local mult = self:ExternalSpeedMultiplier()
                if self.inst.components.inventory ~= nil then
                    for k, v in pairs(self.inst.components.inventory.equipslots) do
                        if v.components.equippable ~= nil then
                            local item_speed_mult = v.components.equippable:GetWalkSpeedMult()
                            mult = mult * math.max(item_speed_mult, 1)
                        end
                    end
                end
                return mult * (self:TempGroundSpeedMultiplier() or self.groundspeedmultiplier) * self.throttle
            elseif oldGetSpeedMultiplier then
                return oldGetSpeedMultiplier(self)
            end
        end
    else
        self.GetSpeedMultiplier = function(self)
            if self.inst:HasTag("furry_strong") and not (self.inst.replica.rider and self.inst.replica.rider:IsRiding()) then
                local mult = self:ExternalSpeedMultiplier()
                local inventory = self.inst.replica.inventory
                if inventory ~= nil then
                    for k, v in pairs(inventory:GetEquips()) do
                        local inventoryitem = v.replica.inventoryitem
                        if inventoryitem ~= nil then
                            local item_speed_mult = inventoryitem:GetWalkSpeedMult()
                            mult = mult * math.max(item_speed_mult, 1)
                        end
                    end
                end
                return mult * (self:TempGroundSpeedMultiplier() or self.groundspeedmultiplier) * self.throttle
            elseif oldGetSpeedMultiplier then
                return oldGetSpeedMultiplier(self)
            end
        end
    end
end)

--================================================================================================================
--[[ 给力量值组件加一个参数,该参数可以锁定沃尔夫冈的力量值 ]]
--================================================================================================================
local function LockingMightiness(self)
    self.furry_locked = false

    local OldDoDelta = self.DoDelta
    self.DoDelta = function(self, delta, force_update, delay_skin, forcesound, fromgym)
        if self.furry_locked then
            return
        end
        OldDoDelta(self, delta, force_update, delay_skin, forcesound, fromgym)
    end

    local OldDoDec = self.DoDec
    self.DoDec = function(self, dt, ignore_damage)
        if self.furry_locked then
            return
        end
        OldDoDec(self, dt, ignore_damage)
    end

    -- 添加锁定和解锁方法
    function self:Furry_Lock()
        self.furry_locked = true
    end

    function self:Furry_Unlock()
        self.furry_locked = false
    end

    function self:Furry_IsLocked()
        return self.furry_locked
    end
end
AddComponentPostInit("mightiness", LockingMightiness)

--================================================================================================================
--[[ 修改阿比盖尔的 UpdateDamage 函数,使其在有本mod标签时,默认伤害有60点 ]]
--================================================================================================================
AddPrefabPostInit("abigail", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local old_UpdateDamage = inst.UpdateDamage
    local function UpdateDamage(inst)
        old_UpdateDamage(inst)
        if inst:HasTag("furry_banana_milk_pudding") then
            inst.components.combat.defaultdamage = 60
        end
    end
    inst.UpdateDamage = UpdateDamage
    inst:WatchWorldState("phase", UpdateDamage)
    UpdateDamage(inst)
end)
