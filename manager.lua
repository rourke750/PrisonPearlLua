local imprisoned_players = {} -- name : {pearl details} 

local function save_pearls()
    local modpath = minetest.get_modpath(minetest.get_current_modname())
    pp.table.save(imprisoned_players, modpath .. "/pearls.txt")
end

local function load_pearls()
    local modpath = minetest.get_modpath(minetest.get_current_modname())
    local file = io.open(modpath .. "/pearls.txt", "r")
    if file then
        imprisoned_players = pp.table.load(modpath .. "/pearls.txt")
        end
end

minetest.register_on_shutdown(function()
    save_pearls()
end)
minetest.register_on_mods_loaded(function()
    
end)
load_pearls()

-- This function let's the mod know that we need to start tracking a pearl created from someone dying
function pp.manager:award_pearl(victum, attacker)
    -- Now we need to award a prison item to the attacker.
    local location = {type="player", name=attacker}
    local inv = minetest.get_inventory(location)
    local stack = {name="prisonpearl:pearl", count=1, metadata=""}
    for i, item in ipairs(inv:get_list("main")) do -- Update the item, 
        if item:get_name() == "prisonpearl:pearl" then -- Now we need to check if it has metadata or not
            local meta = item:get_meta()
            if not meta:contains("prisoner") then -- If no meta data then we know that we can use it
                meta:set_string("prisoner", victum)
                meta:set_string("description", victum .. " has been trapped")
                inv:set_stack("main", i, item)
                break
                end
            end
        end
    -- Now we want to add the player to the db tracking
    imprisoned_players[victum] = {name=victum, location=location, isDirty=true}
    -- Now we want to ban the player
    minetest.ban_player(victum)
end

function pp.manager:update_pearl_location(pearl, location)
    minetest.debug("success")
    pearl.location = location
    pearl.isDirty = true
end

function pp.manager:is_imprisoned(name)
    return imprisoned_players[name] ~= nil
end

function pp.manager:get_pearl_by_name(name)
    return imprisoned_players[name]
end

local function get_pos_by_type(pearl)
    if pearl.location.type == 'player' then
        return minetest:get_player_by_name(pearl.location.name):get_pos()
    elseif pearl.location.type == 'node' then
        return pearl.location.pos
    elseif pearl.location.type == 'ground' then
        return pearl.location.pos
        end
end