local Commands = require("expcore.commands")
local config = require("config.graftorio")
local statics = require("modules.graftorio.statics")
local forcestats = nil
local general = nil
if config.modules.forcestats then
	forcestats = require("modules.graftorio.forcestats")
end
if config.modules.general then
	general = require("modules.graftorio.general")
end

Commands.new_command("collectdata", "Collect data for RCON usage")
		:add_param("location", true)
		:register(function()
			-- this must be first as it overwrites the stats
			-- also makes the .other table for all forces
			statics.collect_statics()
			if config.modules.general then general.collect_other() end
			if config.modules.forcestats then
				forcestats.collect_production()
				forcestats.collect_loginet()
			end
			rcon.print(game.table_to_json(general.data.output))
			return Commands.success()
		end)
