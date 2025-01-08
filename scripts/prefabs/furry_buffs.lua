local function OnTimerDone(inst, data)
		if data.name == "buffover" then
				inst.components.debuff:Stop()
		end
end
local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
		local function OnAttached(inst, target)
				inst.entity:SetParent(target.entity)
				inst.Transform:SetPosition(0, 0, 0) --in case of loading
				inst:ListenForEvent("death", function()
						inst.components.debuff:Stop()
				end, target)
				
				if onattachedfn ~= nil then
						onattachedfn(inst, target)
				end
		end
		
		local function OnExtended(inst, target)
				inst.components.timer:StopTimer("buffover")
				if duration then
						inst.components.timer:StartTimer("buffover", duration)
				end
				
				if onextendedfn ~= nil then
						onextendedfn(inst, target)
				end
		end
		
		local function OnDetached(inst, target)
				if ondetachedfn ~= nil then
						ondetachedfn(inst, target)
				end
				inst:Remove()
		end
		
		local function fn()
				local inst = CreateEntity()
				
				if not TheWorld.ismastersim then
						--Not meant for client!
						inst:DoTaskInTime(0, inst.Remove)
						return inst
				end
				
				inst.entity:AddTransform()
				
				--[[Non-networked entity]]
				--inst.entity:SetCanSleep(false)
				inst.entity:Hide()
				inst.persists = false
				
				inst:AddTag("CLASSIFIED")
				
				inst:AddComponent("debuff")
				inst.components.debuff:SetAttachedFn(OnAttached)
				inst.components.debuff:SetDetachedFn(OnDetached)
				inst.components.debuff:SetExtendedFn(OnExtended)
				inst.components.debuff.keepondespawn = true
				
				inst:AddComponent("timer")
				if duration then
						inst.components.timer:StartTimer("buffover", duration)
				end
				inst:ListenForEvent("timerdone", OnTimerDone)
				
				return inst
		end
		
		return Prefab("buff_" .. name, fn, nil, prefabs)
end

local function RecalculatePlanarDamage(inst)
		local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if item then
				if not item.components.planardamage then
						item:AddComponent("planardamage")
						item._addplanardamage = true
				end
				item.components.planardamage:AddBonus(inst, 15, "furry_marshmallow")
		end
		
		local olditem = inst._furry_marshmallow_planarweapon
		if olditem ~= item then
				if olditem and olditem.components.planardamage then
						if olditem._addplanardamage then
								olditem:RemoveComponent("planardamage")
								olditem._addplanardamage = nil
						else
								olditem.components.planardamage:RemoveBonus(inst, "furry_marshmallow")
						end
				end
				inst._furry_marshmallow_planarweapon = item
		end
end

local function RemovePlanarDamage(inst)
		local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if item and item.components.planardamage then
				if item._addplanardamage then
						item:RemoveComponent("planardamage")
						item._addplanardamage = nil
				else
						item.components.planardamage:RemoveBonus(inst, "furry_marshmallow")
				end
		end
end

local function OnEquip(inst, data)
		if data ~= nil and data.item ~= nil then
				if data.eslot == EQUIPSLOTS.HANDS then
						RecalculatePlanarDamage(inst)
				end
		end
end

local function OnUnequip(inst, data)
		if data ~= nil and data.item ~= nil then
				if data.eslot == EQUIPSLOTS.HANDS then
						RecalculatePlanarDamage(inst)
				end
		end
end
--棉花糖buff锁定旺达老年伤害
local function CustomCombatDamage(inst, target, weapon, multiplier, mount)
		--判断是否有棉花糖buff
		if mount == nil and inst.components.debuffable and inst.components.debuffable:HasDebuff("buff_furry_marshmallow") then
				return TUNING.WANDA_SHADOW_DAMAGE_OLD
		end
		--调用旧方法
		return inst._furry_marshmallow_CustomCombatDamage and inst._furry_marshmallow_CustomCombatDamage(inst, target, weapon, multiplier, mount)
end

--buff列表
local buffs = {
		{
				--紫苏包肉制作减半buff
				name = "furry_perilla_wraps",
				onattachedfn = function(inst, target)
						if target.components.builder ~= nil then
								target.components.builder.ingredientmod = TUNING.GREENAMULET_INGREDIENTMOD
						end
						inst.onitembuild = function(owner, data)
								if not (data ~= nil and data.discounted == false) then
										target:RemoveDebuff("buff_furry_perilla_wraps", "buff_furry_perilla_wraps")
								end
						end
						inst:ListenForEvent("consumeingredients", inst.onitembuild, target)
				end,
				ondetachedfn = function(inst, target)
						if target.components.builder ~= nil then
								target.components.builder.ingredientmod = 1
						end
						inst:RemoveEventCallback("consumeingredients", inst.onitembuild, target)
				end
		},
		{
				--棉花糖buff
				name = "furry_marshmallow",
				onattachedfn = function(inst, target)
						--旺达攻击锁定老年形态
						if target.components.combat then
								if not target._furry_marshmallow_CustomCombatDamage and target.components.combat.customdamagemultfn then
										target._furry_marshmallow_CustomCombatDamage = target.components.combat.customdamagemultfn
										target.components.combat.customdamagemultfn = CustomCombatDamage
								end
						end
						--第一种方法给装备增加位面伤害
						--RecalculatePlanarDamage(target)
						--inst:ListenForEvent("equip", OnEquip, target)
						--inst:ListenForEvent("unequip", OnUnequip, target)
						--第二种直接给人物加位面伤害
						if not target.components.planardamage then
								target:AddComponent("planardamage")
								--标记一下
								target._addplanardamage = true
						end
						target.components.planardamage:AddBonus(inst, 15, "furry_marshmallow")
				end,
				ondetachedfn = function(inst, target)
						--buff消失移除装备增加的额外位面伤害
						--RemovePlanarDamage(inst)
						--inst:RemoveEventCallback("equip", OnEquip, target)
						--inst:RemoveEventCallback("unequip", OnUnequip, target)
						--第二种方法
						if target.components.planardamage then
								--如果有标记，就移除位面伤害组件
								if target._addplanardamage then
										target:RemoveComponent("planardamage")
										--移除标记
										target._addplanardamage = nil
								else
										target.components.planardamage:RemoveBonus(inst, "furry_marshmallow")
								end
						end
				end,
				duration = 120
		},
		{
				--坚果能量棒buff
				name = "furry_nut_energy_bar",
				onattachedfn = function(inst, target)
				end,
				ondetachedfn = function(inst, target)
				end,
				duration = 180
		},
		{
				--榴莲酱千层buff
				name = "furry_durian_mille_feuille",
				onattachedfn = function(inst, target)
						if target.components.hunger then
								target.components.hunger:SetPercent(0)
						end
						if target.components.locomotor then
								target.components.locomotor:SetExternalSpeedMultiplier(inst, "furry_durian_mille_feuille", 1.2)
						end
						--可以吃肉食
						if target.components.eater then
								local caneat = target.components.eater.caneat or {}
								local preferseating = target.components.eater.preferseating or {}
								table.insert(caneat, FOODTYPE.MEAT)
								table.insert(preferseating, FOODTYPE.MEAT)
								inst.components.eater:SetDiet(caneat, preferseating)
						end
				end,
				ondetachedfn = function(inst, target)
						if target.components.locomotor then
								target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "furry_durian_mille_feuille")
						end
						if target.components.eater then
								local caneat = target.components.eater.caneat or {}
								local preferseating = target.components.eater.preferseating or {}
								for k, v in ipairs(caneat) do
										if v == FOODTYPE.MEAT then
												table.remove(caneat, k)
												break
										end
								end
								for k, v in ipairs(preferseating) do
										if v == FOODTYPE.MEAT then
												table.remove(preferseating, k)
												break
										end
								end
								inst.components.eater:SetDiet(caneat, preferseating)
						end
				end,
				duration = 960
		},
}
local ret = {}
for k, v in pairs(buffs) do
		table.insert(ret, MakeBuff(v.name, v.onattachedfn, v.onextendedfn, v.ondetachedfn, v.duration))
end

return unpack(ret)