--[[-- Commands Module - Pollution Handle
    - Adds a command that allows modifying pollution
    @commands Pollution Handle
]]

local Commands = require 'expcore.commands' --- @dep expcore.commands
require 'config.expcore.command_general_parse'

Commands.new_command('pollution-clear', 'Clear pollution')
:set_flag('admin_only')
:add_alias('pol-clr')
:add_param('surface', true, 'surface')
:set_defaults{surface=function(player)
    return player.surface
end}
:register(function(player, surface)
    surface.clear_pollution()
    return Commands.success{'expcom-pol.clr', player}
end)

Commands.new_command('pollution-off', 'Disable pollution')
:set_flag('admin_only')
:add_alias('pol-off')
:register(function(player)
    game.map_settings.pollution.enabled = false

    for _, v in pairs(game.surfaces) do
        v.clear_pollution()
    end

    return Commands.success{'expcom-pol.off', player.name}
end)
