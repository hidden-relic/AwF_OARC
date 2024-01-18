--[[-- Commands Module - Bonus
    - Adds a command that allows players to have increased stats
    @data Bonus
]]

local Roles = require 'expcore.roles' --- @dep expcore.roles
local Event = require 'utils.event' --- @dep utils.event
local config = require 'config.bonus' --- @dep config.bonuses
local Commands = require 'expcore.commands' --- @dep expcore.commands
require 'config.expcore.command_general_parse'

-- Stores the bonus for the player
local PlayerData = require 'expcore.player_data' --- @dep expcore.player_data
local PlayerBonus = PlayerData.Settings:combine('Bonus')
PlayerBonus:set_default(0)
PlayerBonus:set_metadata{
    permission = 'command/bonus',
    stringify = function(value)
        if not value or value == 0 then
            return 'None set'
        end

        return value
    end
}

--- Apply a bonus to a player
local function apply_bonus(player, stage)
    if not player.character then
        return
    end

    for _, v in pairs(config.player_bonus) do
        if v.enabled then
            if stage == 0 then
                player[v.name] = v.min
            else
                player[v.name] = v.min + (v.max - v.min) * stage / 10
            end
        end
    end
end

--- When store is updated apply new bonus to the player
PlayerBonus:on_update(function(player_name, player_bonus)
    apply_bonus(game.players[player_name], player_bonus or 0)
end)

--- Changes the amount of bonus you receive
-- @command bonus
-- @tparam number amount range 0-10 the increase for your bonus
Commands.new_command('bonus', 'Changes the amount of bonus you receive')
:add_param('amount', 'integer-range', 0, 10)
:register(function(player, amount)
    if amount > config.player_bonus_level then
        if not Roles.player_allowed(player, 'command/bonus/2') then
            Commands.print{'expcom-bonus.perm', 2}
            return
        end
    elseif amount <= config.player_bonus_level then
        if not Roles.player_allowed(player, 'command/bonus') then
            Commands.print{'expcom-bonus.perm', 1}
            return
        end
    end

    PlayerBonus:set(player, amount)

    Commands.print{'expcom-bonus.set', amount}
end)

--- When a player respawns re-apply bonus
Event.add(defines.events.on_player_respawned, function(event)
    local player = game.players[event.player_index]
    apply_bonus(player, PlayerBonus:get(player))
end)

--- Remove bonus if a player no longer has access to the command
local function role_update(event)
    local player = game.players[event.player_index]
    if not Roles.player_allowed(player, 'command/bonus') then
        apply_bonus(player, 0)
    end
end

--- When a player dies allow them to have instant respawn
Event.add(defines.events.on_player_died, function(event)
    local player = game.players[event.player_index]

    if Roles.player_has_flag(player, 'instant-respawn') then
        player.ticks_to_respawn = 120
    end
end)

Event.add(defines.events.on_player_created, function(event)
    if event.player_index ~= 1 then
        return
    end

    for _, v in pairs(config.force_bonus) do
        if v.enabled then
            game.players[event.player_index].force[v.name] = game.players[event.player_index].force[v.name] + v.max
        end
    end

    for _, v in pairs(config.surface_bonus) do
        if v.enabled then
            game.players[event.player_index].surface[v.name] = game.players[event.player_index].surface[v.name] + v.max
        end
    end
end)

Event.add(Roles.events.on_role_assigned, role_update)
Event.add(Roles.events.on_role_unassigned, role_update)
