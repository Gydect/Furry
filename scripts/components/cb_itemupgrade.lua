local pre = debug.getinfo(1, 'S').source:match("([^/]+)itemupgrade%.lua$") --当前文件前缀

--- 主客机通用组件，记录物品升级所需资源
local Upgrade = Class(function(self, inst)
    self.inst = inst

    self.items = {}        --主要数据
    self.item_names = {}   --所有物品的名字，用于UI显示
    self.ongetitemfn = nil --当获得物品时，(inst, data, doer)
    self.data = {}         --临时数据存放，一般是用来标记用的

    self.uisuffixfn = nil  --自定义UI内容
end)

function Upgrade:Setup(items, ongetitemfn, uisuffixfn)
    for _, d in ipairs(items) do
        local name = d[1]
        local max = d[2]
        local current = (max <= 7 and net_tinybyte
            or max <= 63 and net_smallbyte
            or max <= 255 and net_byte
            or max <= 65535 and net_ushortint
            or net_uint)(self.inst.GUID, pre .. "itemupgrade.item_" .. name)
        self.items[name] = {
            key = d[3],
            current = current,
            max = max
        }
        table.insert(self.item_names, name)
    end

    self.ongetitemfn = ongetitemfn
    self.uisuffixfn = uisuffixfn
end

function Upgrade:HasItem(item)
    return self.items[item] ~= nil
end

function Upgrade:GetItemCount(item)
    return self.items[item] and self.items[item].current:value() or 0
end

function Upgrade:IsMax(item)
    if not self.items[item] then return true end

    return self.items[item].current:value() >= self.items[item].max
end

function Upgrade:KeyIsMax(key)
    for _, d in pairs(self.items) do
        if d.key == key and d.current:value() < d.max then
            return false
        end
    end

    return true
end

function Upgrade:GetMaxKeyCount()
    local keys = {}
    local count = 0
    for k, d in pairs(self.items) do
        if d.key then
            if not keys[d.key] then
                count = count + (self:KeyIsMax(d.key) and 1 or 0)
                keys[d.key] = true
            end
        else
            count = count + (self:IsMax(k) and 1 or 0)
        end
    end
    return count
end

function Upgrade:AddItem(item, doer)
    local d = self.items[item.prefab]
    local need = d.max - d.current:value()
    if need <= 0 then return end

    local cost = math.min(GetStackSize(item), need)
    d.current:set(d.current:value() + cost)

    if item.components.stackable then
        item.components.stackable:Get(cost):Remove()
    else
        item:Remove()
    end

    if self.ongetitemfn then
        self.ongetitemfn(self.inst, self.data, doer)
    end
end

--- 获取显示的文本
function Upgrade:GetUISuffix()
    if self.uisuffixfn then
        return self.uisuffixfn(self.inst, self)
    end

    local strs = {}
    for i, name in ipairs(self.item_names) do
        local d = self.items[name]
        if i ~= 1 then
            table.insert(strs, "\n")
        end
        table.insert(strs, STRINGS.NAMES[string.upper(name)] or name)
        table.insert(strs, "：")
        table.insert(strs, d.current:value())
        table.insert(strs, "/")
        table.insert(strs, d.max)
    end

    return table.concat(strs)
end

function Upgrade:OnSave()
    local items = {}
    for name, d in pairs(self.items) do
        items[name] = d.current:value()
    end

    return { items = items }
end

function Upgrade:OnLoad(data)
    if not data then return end

    for name, count in pairs(data.items or {}) do
        if self.items[name] then
            self.items[name].current:set(math.min(self.items[name].max, count))
        end
    end

    self.inst:DoTaskInTime(0, function()
        for _, d in pairs(self.items) do
            if d.current:value() > 0 then
                if self.ongetitemfn then
                    self.ongetitemfn(self.inst, self.data)
                end
                break
            end
        end
    end)
end

return Upgrade
