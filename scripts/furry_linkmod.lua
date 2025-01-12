local _G = GLOBAL
_G.FURRY_SETS = {
    ENABLEDMODS = {},
}

-- 判定别的mod是否开启，参考了风铃大佬的代码
local modsenabled = KnownModIndex:GetModsToLoad(true)
local enabledmods = {}
for k, dir in pairs(modsenabled) do
    local info = KnownModIndex:GetModInfo(dir)
    local name = info and info.name or "unknown"
    enabledmods[dir] = name
end
local function IsModEnable(name)
    for k, v in pairs(enabledmods) do
        if v and (k:match(name) or v:match(name)) then
            return true
        end
    end
    return false
end

_G.FURRY_SETS.ENABLEDMODS["legion"] = IsModEnable("Legion") or IsModEnable("棱镜") -- 棱镜
_G.FURRY_SETS.ENABLEDMODS["tastefun"] = IsModEnable("TasteFun") or IsModEnable("食趣") -- 食趣
