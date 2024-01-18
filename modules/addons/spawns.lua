local Event = require("utils.event")
local config = require("config.oarc")
local Global = require("utils.global")

local player_spawns = {}
Global.register(player_spawns, function(tbl)
    player_spawns = tbl
end)

local spawns = {}

local function get_distance(pos1, pos2)
    local pos1 = {x = pos1.x or pos1[1], y = pos1.y or pos1[2]}
    local pos2 = {x = pos2.x or pos2[1], y = pos2.y or pos2[2]}
    local a = math.abs(pos1.x - pos2.x)
    local b = math.abs(pos1.y - pos2.y)
    local c = math.sqrt(a ^ 2 + b ^ 2)
    return c
end

local function tp(player, position, surface)
    local surface = surface or player.surface
    player.teleport(surface.find_non_colliding_position('character', position, 32, 1), surface.name)
end

function spawns.get_near_spawn_position()
    local distance = 0
    local near_distance = config.near_distance
    local min, max = near_distance.min, near_distance.max
    local t = {}
    while (distance < min or distance > max) do
        t.x, t.y = math.random(-max, max), math.random(-max, max)
        distance = get_distance({x=0, y=0}, t)
    end
    return t
end

function spawns.get_far_spawn_position()
    local distance = 0
    local far_distance = config.far_distance
    local min, max = far_distance.min, far_distance.max
    local t = {}
    while (distance < min or distance > max) do
        t.x, t.y = math.random(-max, max), math.random(-max, max)
        distance = get_distance({x=0, y=0}, t)
    end
    return t
end

function spawns.check_distance_from_players(position)
    for name, spawn in pairs(player_spawns) do
        if get_distance(position, spawn) <= config.distance_from_another_player then
            return false
        end
    end
    return true
end

function spawns.downgrade_area(position, radius, probability)
    local create_entity = game.surfaces['oarc'].create_entity
    local small_bugs = {"small-worm-turret", "small-biter", "small-spitter"}
    local medium_bugs = {"medium-worm-turret", "medium-biter", "medium-spitter"}
    local big_bugs = {"big-worm-turret", "big-biter", "big-spitter"}
    local behemoth_bugs = {"behemoth-worm-turret", "behemoth-biter", "behemoth-spitter"}
    local spawner_table = {}
    
    local bugs = game.surfaces['oarc'].find_entities_filtered{position=position, radius=radius, force="enemy"}
    for i, bug in pairs(bugs) do
        if small_bugs[bug.name] then bug.destroy() end
        if medium_bugs[bug.name] then
            create_entity{name=bug.name.gsub("medium", "small"), position=bug.position, force="enemy"}
            bug.destroy()
        end
        if big_bugs[bug.name] then
            create_entity{name=bug.name.gsub("big", "medium"), position=bug.position, force="enemy"}
            bug.destroy()
        end
        if behemoth_bugs[bug.name] then
            create_entity{name=bug.name.gsub("behemoth", "medium"), position=bug.position, force="enemy"}
            bug.destroy()
        end
        if bug.name == "biter_spawner" or bug.name == "spitter_spawner" then
            table.insert(spawner_table, bug)
        end
        for each, spawner in pairs(spawner_table) do
            if math.random(probability) == probability then
                spawner.destroy()
            end
        end
    end
end

local function fy_shuffle(tInput)
    local tReturn = {}
    for i = #tInput, 1, -1 do
        local j = math.random(i)
        tInput[i], tInput[j] = tInput[j], tInput[i]
        table.insert(tReturn, tInput[i])
    end
    return tReturn
end

local function create_water_strip(surface, leftPos, length)
    local waterTiles = {}
    for i = 0, length, 1 do
        table.insert(waterTiles,
        {name = "water", position = {leftPos.x + i, leftPos.y}})
    end
    surface.set_tiles(waterTiles)
end

local function generate_resource_patch(surface, resourceName, diameter, pos, amount)
    local midPoint = math.floor(diameter / 2)
    if (diameter == 0) then return end
    for y = -midPoint, midPoint do
        for x = -midPoint, midPoint do
            surface.create_entity({
                name = resourceName,
                amount = amount,
                position = {pos.x + x, pos.y + y}
            })
        end
    end
end

local function generate_starting_resources(surface, pos)
    local rand_settings = config.resources.ore.random
    local tiles = config.resources.ore.tiles
    local r_list = {}
    for k, _ in pairs(tiles) do
        if (k ~= "") then table.insert(r_list, k) end
    end
    local shuffled_list = fy_shuffle(r_list)
    local angle_offset = rand_settings.angle_offset
    local num_resources = table_size(tiles)
    local theta = ((rand_settings.angle_final - rand_settings.angle_offset) /
    num_resources);
    local count = 0
    
    for _, k_name in pairs(shuffled_list) do
        local angle = (theta * count) + angle_offset;
        
        local tx = (rand_settings.radius * math.cos(angle)) + pos.x
        local ty = (rand_settings.radius * math.sin(angle)) + pos.y
        
        local pos = {x = math.floor(tx), y = math.floor(ty)}
        generate_resource_patch(surface, k_name, config.resources.ore.size, pos, tiles[k_name].amount)
        count = count + 1
    end
    
    local crude = config.resources["crude-oil"]
    local oil_patch_x = pos.x + crude.x_offset_start
    local oil_patch_y = pos.y + crude.y_offset_start
    for i = 1, crude.num_patches do
        surface.create_entity({
            name = "crude-oil",
            amount = crude.amount,
            position = {oil_patch_x, oil_patch_y}
        })
        oil_patch_x = oil_patch_x + crude.x_offset_next
        oil_patch_y = oil_patch_y + crude.y_offset_next
    end
    
    local water_data = config.resources.water
    create_water_strip(surface, {
        x = pos.x + water_data.offset.x,
        y = pos.y + water_data.offset.y
    }, water_data.length)
    create_water_strip(surface, {
        x = pos.x + water_data.offset.x,
        y = pos.y + water_data.offset.y + 1
    }, water_data.length)
end

function spawns.create_new_spawn(player, center)    
    local results = {}
    local radius = config.spawn_radius
    local rad_sq = radius ^ 2
    local border = radius*math.pi
    local surface = game.surfaces['oarc']
    
    -- safe zone
    local bugs = surface.find_entities_filtered{position=position, radius=config.zones.safe_zone.size, force="enemy"}
    for each, bug in pairs(bugs) do
        bug.destroy()
    end
    --green zone
    local this_zone = config.zones.green_zone
    spawns.downgrade_area(center, this_zone.size, this_zone.rate)
    -- yellow zone
    this_zone = config.zones.yellow_zone
    spawns.downgrade_area(center, this_zone.size, this_zone.rate)
    
    local area = {top_left={x=center.x-radius, y=center.y-radius}, bottom_right={x=center.x+radius, y=center.y+radius}}
    
    for i = area.top_left.x, area.bottom_right.x, 1 do
        for j = area.top_left.y, area.bottom_right.y, 1 do
            
            local dist = math.floor((center.x - i) ^ 2 + (center.y - j) ^ 2)
            
            if (dist < rad_sq) then
                table.insert(results, {name = "landfill", position ={i,j}})
                
                if ((dist < rad_sq) and
                (dist > rad_sq-border)) then
                    surface.create_entity({name="tree-02", force=player.force, position={i, j}})
                end
            end
        end
    end
    
    surface.set_tiles(results)
    generate_starting_resources(surface, center)
    
    player.force.chart(surface, area)
    tp(player, center, surface)
end

Event.add(defines.events.on_player_created, function (event)
    if event.player_index == 1 then
        game.create_surface('oarc')
    end
    local surface = game.surfaces['oarc']
    local spawn_position = spawns.get_far_spawn_position()
    while not spawns.check_distance_from_players(spawn_position) do
        spawn_position = spawns.get_far_spawn_position()
    end
    player_spawns[game.players[event.player_index].name] = {
        position = spawn_position
    }
    surface.request_to_generate_chunks(spawn_position, config.zones.yellow_zone.size/32)
    surface.force_generate_chunk_requests()
    local chunk_generated = surface.is_chunk_generated({x=spawn_position.x/32, y=spawn_position.y/32})
    while not chunk_generated do
        chunk_generated = surface.is_chunk_generated({x=spawn_position.x/32, y=spawn_position.y/32})
    end
    spawns.create_new_spawn(game.players[event.player_index], spawn_position)
end)

return function(player_name)
    if player_spawns[player_name] then
        return player_spawns[player_name]
    else
        return false
    end
end