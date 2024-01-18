--- When a player triggers protection multiple times they are automatically jailed
-- @addon protection-jail

local Event = require 'utils.event' ---@dep utils.event
local Global = require 'utils.global' ---@dep utils.global
local Jail = require 'modules.control.jail' ---@dep modules.control.jail
local Protection = require 'modules.control.protection' --- @dep modules.control.protection
local format_chat_player_name = _C.format_chat_player_name --- @dep expcore.common

--- Stores how many times the repeat violation was triggered
local repeat_count = {}
Global.register(repeat_count, function(tbl)
    repeat_count = tbl
end)

--- When a protection is triggered increment their counter and jail if needed
Event.add(Protection.events.on_repeat_violation, function(event)
    local player = game.get_player(event.player_index)

    -- Increment the counter
    if repeat_count[player.index] then
        repeat_count[player.index] = repeat_count[player.index] + 1
    else
        repeat_count[player.index] = 1
    end

    -- Jail if needed
    if repeat_count[player.index] < 3 then
        return
    end

    local player_name_color = format_chat_player_name(player)
    Jail.jail_player(player, '<protection>', 'Removed too many protected entities, please wait for a moderator.')
    game.print{'protection-jail.jail', player_name_color}
end)

--- Clear the counter when they leave the game (stops a build up of data)
Event.add(defines.events.on_player_left_game, function(event)
    repeat_count[event.player_index] = nil
end)