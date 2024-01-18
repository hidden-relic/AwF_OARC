--[[-- Commands Module - Toggle Friendly Fire
    - Adds a command that toggle all friendly fire
    @commands Toggle Friendly Fire
]]

local Commands = require 'expcore.commands' --- @dep expcore.commands
require 'config.expcore.command_general_parse'

-- For Modded Server Use
Commands.new_command('toggle-friendly-fire', 'Toggle Friendly Fire')
:add_param('force', true, 'force')
:set_defaults{force=function(player)
    return player.force
end}
:register(function(_, force)
    force.friendly_fire = not force.friendly_fire
    return Commands.success{'expcom-ff.ff', force.friendly_fire}
end)
