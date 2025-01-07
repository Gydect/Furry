FURRY_TOOL = {
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
