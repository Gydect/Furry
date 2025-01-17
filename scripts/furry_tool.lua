FURRY_TOOL = {
    -- 注册贴图集
    Tool_RegisterInventoryItemAtlas = function(atlas_path)
        local atlas = resolvefilepath(atlas_path)

        local file = io.open(atlas, "r")
        local data = file and file:read("*all") or ""
        if file then
            file:close()
        end

        local str = string.gsub(data, "%s+", "")
        local _, _, elements = string.find(str, "<Elements>(.-)</Elements>")

        for s in string.gmatch(elements, "<Element(.-)/>") do
            local _, _, image = string.find(s, "name=\"(.-)\"")
            if image ~= nil then
                RegisterInventoryItemAtlas(atlas, image)
                RegisterInventoryItemAtlas(atlas, hash(image)) -- for client
            end
        end
    end
}

-- 一个合并函数
local function CombineTags(tags1, tags2)
    if tags2 ~= nil then
        for _, v in pairs(tags2) do
            table.insert(tags1, v)
        end
    end
    return tags1
end
-- 建筑与伙伴标签,代码作者:梧桐
local function TagsFriendly(othertags)
    return CombineTags({
        "INLIMBO", "NOCLICK", "notarget", "noattack", "playerghost", --"invisible"
        "wall", "structure", "balloon",
        "companion", "glommer", "friendlyfruitfly", "abigail", "shadowminion"
    }, othertags)
end

local Furry_Fns = {
    TagsFriendly = TagsFriendly,
}

return Furry_Fns
