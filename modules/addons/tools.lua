local tools = {}
local format_time = _C.format_time

function tools.add_decon_log(data)
    game.write_file(tools.decon_filepath, data .. "\n", true, 0) -- write data
end
function tools.add_shoot_log(data)
    game.write_file(tools.shoot_filepath, data .. "\n", true, 0) -- write data
end
function tools.get_secs ()
    return format_time(game.tick, { hours = true, minutes = true, seconds = true, string = true })
end
function tools.pos_tostring (pos)
    return tostring(pos.x) .. "," .. tostring(pos.y)
end

function tools.add_commas(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then break end
    end
    return formatted
end

function tools.remove_commas(amount)
    return string.gsub(amount, ",", "")
end

local function sort_table_highest_value(t)
    local r = {}
    for _, val in pairs(t) do
        table.insert(r, val)
    end
    table.sort(r, function(a, b)
        return a > b
    end)
    return r
end

local function get_item_last_hour(force, item)
    return force.item_production_statistics.get_flow_count{
        name=item,
        input=false,
        precision_index = defines.flow_precision_index.one_hour
    }
end

local function get_total_last_hour(force)
    local t = {
        ["automation-science-pack"] = 0,
        ["logistic-science-pack"] = 0,
        ["chemical-science-pack"] = 0,
        ["production-science-pack"] = 0,
        ["utility-science-pack"] = 0,
        ["space-science-pack"] = 0,
        ["military-science-pack"] = 0
    }
    for science, _ in pairs(t) do
        t[science] = get_item_last_hour(force, science)
    end
    local r = sort_table_highest_value(t)
    local total = 0
    for i = 1, 5, 1 do
        total = total + r[i]
    end
    return total
end

local function get_avg_last_hour(force) 
    local total = get_total_last_hour(force)
    return total/5
end

function tools.statistics_log()
    if not global.highest_spm then
        global.highest_spm = {
            amount = 0,
            force = "",
            hour = 0
        }
    end
    global.highest_spm.hour = global.highest_spm.hour + 1
    local old_highest = global.highest_spm.amount
    for _, force in pairs(game.forces) do
        local spm = get_avg_last_hour(force)
        if spm > global.highest_spm.amount then
            global.highest_spm.amount = spm
            global.highest_spm.force = force.name
        end
    end
    if global.highest_spm.amount > old_highest then
        local playernames = {}
        local players = game.forces[global.highest_spm.force].players
        for _, player in pairs(players) do
            table.insert(playernames, player.name)
        end
        game.write_file("statistics/SPM.txt",
        "Hour "..global.highest_spm.hour..
        ":\nForce name: "..global.highest_spm.force..
        "\nSPM: "..global.highest_spm.amount..
        "\nPlayers on force: "..table.concat(playernames, ", ").."\n")
    end
end

function tools.get_keys_sorted_by_value(tbl)
    local function sort_func(a, b)
        return a < b
    end
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    
    table.sort(keys, function(a, b)
        return sort_func(tbl[a], tbl[b])
    end)
    
    return keys
end

local function table_addition(t, n)
    local new = {}
    for k, v in pairs(t) do
        new[k] = v+n
    end
    return new
end

local function table_multiplication(t, n)
    local new = {}
    for k, v in pairs(t) do
        new[k] = v*n
    end
    return new
end

local function expand_area_by_chunk(area, chunks)
    local lt = area.left_top
    local rb = area.right_bottom
    return {left_top=table_addition(lt, -chunks*32), right_bottom=table_addition(rb, chunks*32)}
end

local function get_surrounding_positions(position, n)
    local t = {}
    for x=position.x-n, position.x+n do
        for y=position.y-n, position.y+n do
            table.insert(t, {x=x, y=y})
        end
    end
    return t
end


local function get_center_of_chunk_position(chunk_position)
    return table_addition(table_multiplication(chunk_position, 32), 16)
end 

function cleanup_chunks()
    local entities_chunks = 3
    local pollution_chunks = 1
    local count = 0
    local surface = game.surfaces[1]
    local forces = {}
    local find_entities = surface.find_entities_filtered
    local get_pollution = surface.get_pollution
    for name, force in pairs(game.forces) do
        if name ~= "enemy" and name ~= "neutral" then
            table.insert(forces, name)
        end
    end
    
    for chunk in surface.get_chunks() do
        for _, position in pairs(get_surrounding_positions({chunk.x, chunk.y}, pollution_chunks)) do
            if get_pollution(get_center_of_chunk_position(position)) ~= 0 then return end
        end
        if table_size(find_entities{force=forces, area=expand_area_by_chunk(chunk.area, entities_chunks)}) == 0 then
            surface.delete_chunk({chunk.x, chunk.y})
            count = count + 1
        end
    end
    return count
end