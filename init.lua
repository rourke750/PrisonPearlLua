-- Load config parameters
local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.debug("PrisonPearl initialised.")

minetest.register_craft({
	output = "prisonpearl:pearl",
	recipe = {
		{"", "default:cobble", ""},
		{"", "", ""},
		{"", "default:cobble", ""},
	}
})

local function pearl_on_use(itemstack, user)
    minetest.chat_send_player(user:get_player_name(), "test")
end

minetest.register_craftitem("prisonpearl:pearl", {
	description = "Prison Pearl",
	inventory_image = "default_stick.png",
	groups = {pearl = 1},
    stack_max = 1,
    on_secondary_use = pearl_on_use,
    on_drop = function(itemstack, dropper, pos)
        local meta = itemstack:get_meta()
        if meta:contains("prisoner") then
            name = meta:get_string("prisoner")
            pearl = pp.manager:get_pearl_by_name(name)
            if pearl == nil then
                minetest.debug("Faulty pearl detected with name: " .. name .. " deleting.")
                local meta = itemstack:get_meta()
                meta:set_string("prisoner", "")
                meta:set_string("description", "Prison Pearl")
            else 
                location = {type="ground", pos=pos}
                pp.manager:update_pearl_location(pearl, location)
                end
            end
        minetest.item_drop(itemstack, dropper, pos)
        return itemstack
    end,
    
})

-- Lets handle all situations when a prisonshard is moved
pp = {}
pp.manager = {}
pp.tracker = {}
pp.table = {}
dofile(modpath .. "/table.save-1.0.lua" )
dofile(modpath .. "/manager.lua")
dofile(modpath .. "/tracking.lua")
return pp