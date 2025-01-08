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
}
local ret = {}
for k, v in pairs(buffs) do
	table.insert(ret, MakeBuff(v.name, v.onattachedfn, v.onextendedfn, v.ondetachedfn, v.duration))
end

return unpack(ret)
