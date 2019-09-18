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
})

-- Lets handle all situations when a prisonshard is moved
pp = {}
pp.manager = {}
pp.tracker = {}
dofile(modpath .. "/manager.lua")
dofile(modpath .. "/tracking.lua")
return pp