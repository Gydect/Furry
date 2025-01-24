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
--[[ 高清256*256贴图兼容食趣的冰柜 ]]
--================================================================================================================
local function HookBeverageCabinet(inst)
    if not TheWorld.ismastersim then
        return
    end
    local old_onclosefn = inst.components.container.onclosefn
    local function OnClose_chest(inst)
        old_onclosefn(inst)
        for i = 1, 9, 1 do
            Furry_SetShowSlot(inst, i)
        end
    end
    inst.components.container.onclosefn = OnClose_chest
    inst:ListenForEvent("itemget", Furry_ItemGet_chest)
end
if _G.FURRY_SETS.ENABLEDMODS["tastefun"] then
    AddPrefabPostInit("tf_beverage_cabinet", HookBeverageCabinet)
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
--[[ hook移除组件，甜腻蔬菜汤buff快速搬运重物 ]]
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

--================================================================================================================
--[[ 修改影怪的索敌逻辑,对有法式波士顿龙虾buff的角色保持中立 ]]
--================================================================================================================
local shadowcreatures = { "terrorbeak", "crawlinghorror", "oceanhorror", "dreadeye", "crawlingnightmare", "nightmarebeak" }
local function DelayInitShadowCreature(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat then
        local FurryCanTarget = inst.components.combat.CanTarget
        function inst.components.combat:CanTarget(target, ...)
            if target and target:HasDebuff("buff_furry_french_boston_lobster") then
                return
            end
            return FurryCanTarget(self, target, ...)
        end

        local FurrySetTarget = inst.components.combat.SetTarget
        function inst.components.combat:SetTarget(target, ...)
            if target and target:HasDebuff("buff_furry_french_boston_lobster") then
                return false
            end
            return FurrySetTarget(self, target, ...)
        end
    end
end
for k, v in ipairs(shadowcreatures) do
    AddPrefabPostInit(v, DelayInitShadowCreature)
end
-- 修改暗影小人攻速
local function NewState(inst)
    local leader = inst.components.follower and inst.components.follower.leader
    if leader and leader:HasDebuff("buff_furry_french_boston_lobster") and inst.sg:HasStateTag("attack") then
        inst.components.combat:SetAttackPeriod(0.5)
    end
end
AddPrefabPostInit("shadowprotector", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("newstate", NewState)
end)

--================================================================================================================
--[[ 给读书组件book的OnRead函数添加一个推送事件,服务提神花草茶buff ]]
--================================================================================================================
local function FurryHookBook(self)
    local OldOnRead = self.OnRead
    self.OnRead = function(self, reader)
        local success, reason = OldOnRead(self, reader)
        reader:PushEvent("furry_read", { book = self.inst, success = success })
        return success, reason
    end
end
AddComponentPostInit("book", FurryHookBook)

--================================================================================================================
--[[ hook各种书籍,使其在有提神花草茶buff时,阅读后实现不一样的效果,真是个蠢办法 ]]
--================================================================================================================

--[[ 月之魔典阅读之后,当天月相变新月 ]]
AddPrefabPostInit("book_moon", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local old_onread = inst.components.book.onread
    inst.components.book.onread = function(inst, reader)
        if reader:HasDebuff("buff_furry_herbal_tea") then
            if TheWorld:HasTag("cave") then
                return false, "NOMOONINCAVES"
            elseif TheWorld.state.moonphase == "new" then
                return false, "ALREADYFULLMOON"
            end

            TheWorld:PushEvent("ms_setmoonphase", { moonphase = "new", iswaxing = true })

            if not TheWorld.state.isnight then
                reader.components.talker:Say(GetString(reader, "ANNOUNCE_BOOK_MOON_DAYTIME"))
            end

            reader:RemoveDebuff("buff_furry_herbal_tea")
            return true
        else
            return old_onread(inst, reader)
        end
    end
end)

--[[ 永恒之光和永恒之光复兴,阅读之后,天光时间翻倍 ]]
AddPrefabPostInit("book_light", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local old_onread = inst.components.book.onread
    inst.components.book.onread = function(inst, reader)
        if reader:HasDebuff("buff_furry_herbal_tea") then
            TheWorld:PushEvent("ms_forcequake")
            local x, y, z = reader.Transform:GetWorldPosition()
            local light = SpawnPrefab("booklight")
            light.Transform:SetPosition(x, y, z)

            light:SetDuration(TUNING.TOTAL_DAY_TIME)

            reader:RemoveDebuff("buff_furry_herbal_tea")
            return true
        else
            return old_onread(inst, reader)
        end
    end
end)
AddPrefabPostInit("book_light_upgraded", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local old_onread = inst.components.book.onread
    inst.components.book.onread = function(inst, reader)
        if reader:HasDebuff("buff_furry_herbal_tea") then
            TheWorld:PushEvent("ms_forcequake")
            local x, y, z = reader.Transform:GetWorldPosition()
            local light = SpawnPrefab("booklight")
            light.Transform:SetPosition(x, y, z)

            -- TODO: is 2 days too much?(哈哈哈,官方码师的质问:两天很多吗?)
            light:SetDuration(TUNING.TOTAL_DAY_TIME * 4)
            reader:RemoveDebuff("buff_furry_herbal_tea")
            return true
        else
            return old_onread(inst, reader)
        end
    end
end)

--[[ 控温学可以保持恒温3分钟 ]]
AddPrefabPostInit("book_temperature", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local old_onread = inst.components.book.onread
    inst.components.book.onread = function(inst, reader)
        if reader:HasDebuff("buff_furry_herbal_tea") then
            local x, y, z = reader.Transform:GetWorldPosition()
            local players = FindPlayersInRange(x, y, z, TUNING.BOOK_TEMPERATURE_RADIUS, true)

            for _, player in pairs(players) do
                player.components.temperature:SetTemperature(TUNING.BOOK_TEMPERATURE_AMOUNT)
                player.components.moisture:SetMoistureLevel(0)
                player:AddDebuff("buff_furry_constant_temperature", "buff_furry_constant_temperature")

                local fx = SpawnPrefab(player.components.rider ~= nil and player.components.rider:IsRiding() and "fx_book_temperature_mount" or "fx_book_temperature")
                fx.Transform:SetPosition(player.Transform:GetWorldPosition())
                fx.Transform:SetRotation(player.Transform:GetRotation())

                local items = player.components.inventory:ReferenceAllItems()
                for _, item in ipairs(items) do
                    if item.components.inventoryitem ~= nil then
                        item.components.inventoryitem:DryMoisture()
                    end
                end
            end

            local frozens = TheSim:FindEntities(x, y, z, TUNING.BOOK_TEMPERATURE_RADIUS, { "freezable" }, { "INLIMBO", "frozen" })
            for _, frozen in ipairs(frozens) do
                if frozen.components.freezable then -- Just in case.
                    frozen.components.freezable:Unfreeze()
                end
            end

            reader:RemoveDebuff("buff_furry_herbal_tea")
            return true
        else
            return old_onread(inst, reader)
        end
    end
end)

--[[ 克服蛛形纲恐惧症阅读之后,蛛网面积x2,减速范围x2 ]]
AddPrefabPostInit("book_web", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local old_onread = inst.components.book.onread
    inst.components.book.onread = function(inst, reader)
        if reader:HasDebuff("buff_furry_herbal_tea") then
            local x, y, z = reader.Transform:GetWorldPosition()
            local ground_web = SpawnPrefab("furry_book_web_ground")
            ground_web.Transform:SetPosition(x, y, z)
            reader:RemoveDebuff("buff_furry_herbal_tea")
            return true
        else
            return old_onread(inst, reader)
        end
    end
end)

--[[ 万物百科阅读之后,可解锁其他科技台物品 ]]
AddPrefabPostInit("book_research_station", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local old_onread = inst.components.book.onread
    inst.components.book.onread = function(inst, reader)
        local result = old_onread(inst, reader)
        if reader:HasDebuff("buff_furry_herbal_tea") and reader.components.builder then
            if reader.onfurryitembuild == nil then
                reader.components.builder.furryfreebuildmode = true
                reader.onfurryitembuild = function()
                    reader.components.builder.furryfreebuildmode = false
                    reader:RemoveEventCallback("consumeingredients", reader.onfurryitembuild)
                    reader.onfurryitembuild = nil
                end
                reader:ListenForEvent("consumeingredients", reader.onfurryitembuild)
            end
        end
        return result
    end
end)

--================================================================================================================
--[[ 修改官方的动作,此处代码参考了能力勋章mod,感谢恒子,前人栽树后人乘凉 ]]
--================================================================================================================
local actions_status, actions_data = pcall(require, "furry_actions")
if actions_status then
    -- 修改老动作
    if actions_data.old_actions then
        for _, act in pairs(actions_data.old_actions) do
            if act.switch then
                local action = GLOBAL.ACTIONS[act.id]
                if act.actiondata then
                    for k, data in pairs(act.actiondata) do
                        action[k] = data
                    end
                end
                if act.state then
                    local testfn = act.state.testfn
                    AddStategraphPostInit("wilson", function(sg)
                        local old_handler = sg.actionhandlers[action].deststate
                        sg.actionhandlers[action].deststate = function(inst, action)
                            if testfn and testfn(inst, action) and act.state.deststate then
                                return act.state.deststate(inst, action)
                            end
                            return old_handler(inst, action)
                        end
                    end)
                    if act.state.client_testfn then
                        testfn = act.state.client_testfn
                    end
                    AddStategraphPostInit("wilson_client", function(sg)
                        local old_handler = sg.actionhandlers[action].deststate
                        sg.actionhandlers[action].deststate = function(inst, action)
                            if testfn and testfn(inst, action) and act.state.deststate then
                                return act.state.deststate(inst, action)
                            end
                            return old_handler(inst, action)
                        end
                    end)
                end
            end
        end
    end
end
