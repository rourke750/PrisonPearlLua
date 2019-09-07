minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
    minetest.debug("test")
    minetest.debug(action)
    end
)

-- Time to do damage calculation and see who to award a pearl to
local damageTable = {} -- Stored {playername: {attacker: damage}}
-- This variable stores the last time a player was attacked. Resets if no damage for 5 min
local lastHit = {} -- Stored {player_name: time}

local function get_name_damage_player(name)
    local t = damageTable[name]
    if t == nil then
        return nil
        end
    -- Now we need to iterate and see which player did the most damage
    local mAttacker, mDamage = "", 0
    for attacker, damage in pairs(t) do
        if damage > mDamage then -- Don't really care about if people do equal, just what ever was first
            -- We also want to to check if the player has a pearl, if they don't skip
            local location = {type="player", name=attacker}
            local inv = minetest.get_inventory(location)
            local stack = {name="prisonpearl:pearl", count=1, metadata=""}
            if inv:contains_item("main", stack, true) then
                mDamage = damage
                mAttacker = attacker
                end
            end
        end 
    if mAttacker == "" then return nil else return mAttacker end
end

minetest.register_on_dieplayer(function(player)
    local name = player:get_player_name()
    -- Now lets see if there was a player that damaged them
    local attacker = get_name_damage_player(name)
    -- Check if attacker exists if not escape
    if attacker == nil then
        return
        end
    -- Now we need to award a prison item to the attacker.
    local location = {type="player", name=attacker}
    local inv = minetest.get_inventory(location)
    local stack = {name="prisonpearl:pearl", count=1, metadata=""}
    for i, item in ipairs(inv:get_list("main")) do -- Update the item, 
        if item:get_name() == "prisonpearl:pearl" then -- Now we need to check if it has metadata or not
            local meta = item:get_meta()
            if not meta:contains("prisoner") then -- If no meta data then we know that we can use it
                meta:set_string("prisoner", name)
                meta:set_string("description", name .. " has been trapped")
                inv:set_stack("main", i, item)
                break
                end
            end
        end
    end
)
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    local playerName, hitterName = player:get_player_name(), hitter:get_player_name()
    if damageTable[playerName] == nil then
        damageTable[playerName] = {}
        end
    local tab = damageTable[playerName]
    if tab[hitterName] == nil then
        tab[hitterName] = 0
        end
    tab[hitterName] = tab[hitterName] + damage
    end
)