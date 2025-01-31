local Milking = Class(function(self, inst)
    self.inst = inst

    self:Setup()
end)

function Milking:Setup()
    if not self.inst.components.timer then
        self.inst:AddComponent("timer")
    end
end
--判断是否在冷却中
function Milking:InCooldown(name)
    local timer = self.inst.components.timer
    return timer and timer:TimerExists(name)
end
--冷却计时
function Milking:Cooldown(name, time)
    local timer = self.inst.components.timer
    if timer then
        timer:StartTimer(name, time)
    end
end

function Milking:MakeMilk(doer)
    local target = self.inst
    if doer then
        if self:InCooldown(doer.userid) then
            return
        end

        local num = 0
        --冷却时间
        local cooldown = 0
        if target == doer then
            num = math.random(1, 2)
            --480秒，游戏一天
            cooldown = 480
        else
            num = math.random(6, 9)
            cooldown = 1440
        end
        local item = SpawnPrefab("furry_wolf_milk")
        if item then
            item.components.stackable:SetStackSize(num)
            if not doer.components.inventory:GiveItem(item) then
                item.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
            --冷却
            self:Cooldown(doer.userid, cooldown)
            return true
        end
    end
end

return Milking