--[[-- Gui Module - Rocket Info
    - Adds a rocket infomation gui which shows general stats, milestones and build progress of rockets
    @gui Rocket-Info
    @alias rocket_info
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Event = require 'utils.event' --- @dep utils.event
local config = require 'config.gui.rockets' --- @dep config.gui.rockets
local Colors = require 'utils.color_presets' --- @dep utils.color_presets
local Rockets = require 'modules.control.rockets' --- @dep modules.control.rockets
local format_time = _C.format_time --- @dep expcore.common

local time_formats = {
	caption = function(value) return format_time(value, {minutes=true, seconds=true}) end,
	caption_hours = function(value) return format_time(value) end,
	tooltip = function(value) return format_time(value, {minutes=true, seconds=true, long=true}) end,
	tooltip_hours = function(value) return format_time(value, {hours=true, minutes=true, seconds=true, long=true}) end
}

--- Check if a player is allowed to use certain interactions
local function check_player_permissions(player, action)
    if not config.progress['allow_'..action] then
        return false
    end

    if config.progress[action..'_admins_only'] and not player.admin then
        return false
    end

	if config.progress[action..'_role_permission']
	and not Roles.player_allowed(player, config.progress[action..'_role_permission']) then
        return false
    end

    return true
end

--- Button to toggle the auto launch on a rocket silo
-- @element toggle_launch
local toggle_launch =
Gui.element{
	type = 'sprite-button',
	sprite = 'utility/play',
	tooltip = {'rocket-info.toggle-rocket-tooltip'}
}
:style(Gui.sprite_style(16))
:on_click(function(_, element, _)
	local rocket_silo_name = element.parent.name:sub(8)
	local rocket_silo = Rockets.get_silo_entity(rocket_silo_name)
	if rocket_silo.auto_launch then
        element.sprite = 'utility/play'
        element.tooltip = {'rocket-info.toggle-rocket-tooltip'}
        rocket_silo.auto_launch = false
    else
        element.sprite = 'utility/stop'
        element.tooltip = {'rocket-info.toggle-rocket-tooltip-disabled'}
        rocket_silo.auto_launch = true
    end
end)

--- Button to remotely launch a rocket from a silo
-- @element launch_rocket
local launch_rocket =
Gui.element{
	type = 'sprite-button',
	sprite = 'utility/center',
	tooltip = {'rocket-info.launch-tooltip'}
}
:style(Gui.sprite_style(16, -1))
:on_click(function(player, element, _)
	local rocket_silo_name = element.parent.name:sub(8)
    local silo_data = Rockets.get_silo_data_by_name(rocket_silo_name)
    if silo_data.entity.launch_rocket() then
        element.enabled = false
    else
        player.print({'rocket-info.launch-failed'}, Colors.orange_red)
    end
end)

--- XY cords that allow zoom to map when pressed
-- @element silo_cords
local silo_cords =
Gui.element(function(event_trigger, parent, silo_data)
	local silo_name = silo_data.silo_name
	local pos = silo_data.position
	local name = config.progress.allow_zoom_to_map and event_trigger or nil
	local tooltip = config.progress.allow_zoom_to_map and {'rocket-info.progress-label-tooltip'} or nil

	-- Add the x cord flow
	local flow_x = parent.add{
		type ='flow',
		name = 'label-x-'..silo_name,
        caption = silo_name
	}
	flow_x.style.padding = {0, 2,0, 1}

	-- Add the x cord label
	flow_x.add{
		type = 'label',
		name = name,
		caption = {'rocket-info.progress-x-pos', pos.x},
		tooltip = tooltip
	}

	-- Add the y cord flow
	local flow_y = parent.add{
		type ='flow',
		name = 'label-y-'..silo_name,
        caption = silo_name
	}
	flow_y.style.padding = {0, 2,0, 1}

	-- Add the y cord label
	flow_y.add{
		type = 'label',
		name = name,
		caption = {'rocket-info.progress-y-pos', pos.y},
		tooltip = tooltip
	}

end)
:on_click(function(player, element, _)
    local rocket_silo_name = element.parent.caption
    local rocket_silo = Rockets.get_silo_entity(rocket_silo_name)
    player.zoom_to_world(rocket_silo.position, 2)
end)

--- Base element for each rocket in the progress list
-- @element rocket_entry
local rocket_entry =
Gui.element(function(_, parent, silo_data)
	local silo_name = silo_data.silo_name
	local player = Gui.get_player_from_element(parent)

	-- Add the toggle auto launch if the player is allowed it
	if check_player_permissions(player, 'toggle_active') then
		local flow = parent.add{ type = 'flow', name = 'toggle-'..silo_name}
		local button = toggle_launch(flow)
		button.tooltip = silo_data.toggle_tooltip
		button.sprite = silo_data.toggle_sprite
	end

	-- Add the remote launch if the player is allowed it
	if check_player_permissions(player, 'remote_launch') then
		local flow = parent.add{ type = 'flow', name = 'launch-'..silo_name}
		local button = launch_rocket(flow)
		button.enabled = silo_data.allow_launch
	end

	-- Draw the silo cords element
	silo_cords(parent, silo_data)

	-- Add a progress label
	local alignment = Gui.alignment(parent, silo_name)
	local element =
	alignment.add{
		type = 'label',
		name = 'label',
		caption = silo_data.progress_caption,
		tooltip = silo_data.progress_tooltip
	}

	-- Return the progress label
	return element
end)

--- Data label which contains a name and a value label pair
-- @element data_label
local data_label =
Gui.element(function(_, parent, label_data)
	local data_name = label_data.name
	local data_subname = label_data.subname
	local data_fullname = data_subname and data_name..data_subname or data_name

	-- Add the name label
	local name_label = parent.add{
		type = 'label',
		name = data_fullname..'-label',
        caption = {'rocket-info.data-caption-'..data_name, data_subname},
        tooltip = {'rocket-info.data-tooltip-'..data_name, data_subname}
	}
	name_label.style.padding = {0, 2}

    --- Right aligned label to store the data
	local alignment = Gui.alignment(parent, data_fullname)
	local element =
    alignment.add{
        type = 'label',
        name = 'label',
        caption = label_data.value,
        tooltip = label_data.tooltip
	}
	element.style.padding = {0, 2}

	return element
end)

-- Used to update the captions and tooltips on the data labels
local function update_data_labels(parent, data_label_data)
	for _, label_data in ipairs(data_label_data) do
		local data_name = label_data.subname and label_data.name..label_data.subname or label_data.name
		if not parent[data_name] then
			data_label(parent, label_data)
		else
			local data_label_element = parent[data_name].label
			data_label_element.tooltip = label_data.tooltip
			data_label_element.caption = label_data.value
		end
	end
end

local function get_progress_data(force_name)
	local force_silos = Rockets.get_silos(force_name)
	local progress_data = {}

	for _, silo_data in pairs(force_silos) do
		local rocket_silo = silo_data.entity
		if not rocket_silo or not rocket_silo.valid then
			-- Remove from list if not valid
			force_silos[silo_data.name] = nil
			table.insert(progress_data, {
				silo_name = silo_data.name,
				remove = true
			})

		else
			-- Get the progress caption and tooltip
			local progress_color = Colors.white
			local progress_caption = {'rocket-info.progress-caption', rocket_silo.rocket_parts}
			local progress_tooltip = {'rocket-info.progress-tooltip', silo_data.launched or 0}
			local status = rocket_silo.status == defines.entity_status.waiting_to_launch_rocket
			if status and silo_data.awaiting_reset then
				progress_caption = {'rocket-info.progress-launched'}
				progress_color = Colors.green
			elseif status then
				progress_caption = {'rocket-info.progress-caption', 100}
				progress_color = Colors.cyan
			else
				silo_data.awaiting_reset = false
			end

			-- Get the toggle button data
			local toggle_tooltip = {'rocket-info.toggle-rocket-tooltip-disabled'}
			local toggle_sprite = 'utility/play'
			if rocket_silo.auto_launch then
				toggle_tooltip = {'rocket-info.toggle-rocket-tooltip'}
				toggle_sprite = 'utility/stop'
			end

			-- Insert the gui data
			table.insert(progress_data, {
				silo_name = silo_data.name,
				position = rocket_silo.position,
				allow_launch = not silo_data.awaiting_reset and status or false,
				progress_color = progress_color,
				progress_caption = progress_caption,
				progress_tooltip = progress_tooltip,
				toggle_tooltip = toggle_tooltip,
				toggle_sprite = toggle_sprite
			})
		end
	end

	return progress_data
end

--- Update the build progress section
local function update_build_progress(parent, progress_data)
	local show_message = true
	for _, silo_data in ipairs(progress_data) do
		parent.parent.no_silos.visible = false
		parent.visible = true
		local silo_name = silo_data.silo_name
		local progress_label = parent[silo_name]
		if silo_data.remove then
			-- Remove the rocket from the list
			Gui.destroy_if_valid(parent['toggle-'..silo_name])
            Gui.destroy_if_valid(parent['launch-'..silo_name])
            Gui.destroy_if_valid(parent['label-x-'..silo_name])
            Gui.destroy_if_valid(parent['label-y-'..silo_name])
			Gui.destroy_if_valid(parent[silo_name])

		elseif not progress_label then
			-- Add the rocket to the list
			show_message = false
			rocket_entry(parent, silo_data)

		else
			show_message = false
			-- Update the existing labels
			progress_label = progress_label.label
			progress_label.caption = silo_data.progress_caption
			progress_label.tooltip = silo_data.progress_tooltip
			progress_label.style.font_color = silo_data.progress_color

			-- Update the toggle button
			local toggle_button = parent['toggle-'..silo_name]
			if toggle_button then
				toggle_button = toggle_button[toggle_launch.name]
				toggle_button.tooltip = silo_data.toggle_tooltip
				toggle_button.sprite = silo_data.toggle_sprite
			end

			-- Update the launch button
			local launch_button = parent['launch-'..silo_name]
			if launch_button then
				launch_button = launch_button[launch_rocket.name]
				launch_button.enabled = silo_data.allow_launch
			end
		end
	end
	if show_message then parent.parent.no_silos.visible = true parent.visible = false end
end

--- Gets the label data for all the different stats
local function get_stats_data(force_name)
    local force_rockets = Rockets.get_rocket_count(force_name)
	local stats = Rockets.get_stats(force_name)
	local stats_data = {}

	-- Format the first launch data
	if config.stats.show_first_rocket then
		local value = stats.first_launch or 0
		table.insert(stats_data, {
			name = 'first-launch',
			value = time_formats.caption_hours(value),
			tooltip = time_formats.tooltip_hours(value)
		})
	end

	-- Format the last launch data
	if config.stats.show_last_rocket then
		local value = stats.last_launch or 0
		table.insert(stats_data, {
			name = 'last-launch',
			value = time_formats.caption_hours(value),
			tooltip = time_formats.tooltip_hours(value)
		})
    end

	-- Format fastest launch data
	if config.stats.show_fastest_rocket then
		local value = stats.fastest_launch or 0
		table.insert(stats_data, {
			name = 'fastest-launch',
			value = time_formats.caption_hours(value),
			tooltip = time_formats.tooltip_hours(value)
		})
    end

	-- Format total rocket data
    if config.stats.show_total_rockets then
        local total_rockets = Rockets.get_game_rocket_count()
        total_rockets = total_rockets == 0 and 1 or total_rockets
		local percentage = math.round(force_rockets/total_rockets, 3)*100
		table.insert(stats_data, {
			name = 'total-rockets',
			value = force_rockets,
			tooltip = {'rocket-info.value-tooltip-total-rockets', percentage}
		})
    end

	-- Format game avg data
    if config.stats.show_game_avg then
		local avg = force_rockets > 0 and math.floor(game.tick/force_rockets) or 0
		table.insert(stats_data, {
			name = 'avg-launch',
			value = time_formats.caption(avg),
			tooltip = time_formats.tooltip(avg)
		})
    end

	-- Format rolling avg data
    for _, avg_over in pairs(config.stats.rolling_avg) do
		local avg = Rockets.get_rolling_average(force_name, avg_over)
		table.insert(stats_data, {
			name = 'avg-launch-n',
			subname = avg_over,
			value = time_formats.caption(avg),
			tooltip = time_formats.tooltip(avg)
		})
	end

	-- Return formated data
	return stats_data
end

--- Gets the label data for the milestones
local function get_milestone_data(force_name)
	local force_rockets = Rockets.get_rocket_count(force_name)
	local milestone_data = {}

	for _, milestone in ipairs(config.milestones) do
        if milestone <= force_rockets then
			local time = Rockets.get_rocket_time(force_name, milestone)
			table.insert(milestone_data, {
				name = 'milestone-n',
				subname = milestone,
				value = time_formats.caption_hours(time),
				tooltip = time_formats.tooltip_hours(time)
			})
		else
			table.insert(milestone_data, {
				name = 'milestone-n',
				subname = milestone,
				value = {'rocket-info.data-caption-milestone-next'},
				tooltip = {'rocket-info.data-tooltip-milestone-next'}
			})
            break
        end
	end

	return milestone_data
end

-- Button to toggle a section dropdown
-- @element toggle_section
local toggle_section =
Gui.element{
	type = 'sprite-button',
	sprite = 'utility/expand_dark',
	hovered_sprite = 'utility/expand',
	tooltip = {'rocket-info.toggle-section-tooltip'}
}
:style(Gui.sprite_style(20))
:on_click(function(_, element, _)
	local header_flow = element.parent
	local flow_name = header_flow.caption
	local flow = header_flow.parent.parent[flow_name]
	if Gui.toggle_visible_state(flow) then
        element.sprite = 'utility/collapse_dark'
        element.hovered_sprite = 'utility/collapse'
        element.tooltip = {'rocket-info.toggle-section-collapse-tooltip'}
	else
        element.sprite = 'utility/expand_dark'
        element.hovered_sprite = 'utility/expand'
        element.tooltip = {'rocket-info.toggle-section-tooltip'}
	end
end)

-- Used to assign an event to the header label to trigger a toggle
-- @element header_toggle
local header_toggle = Gui.element()
:on_click(function(_, element, event)
	event.element = element.parent.alignment[toggle_section.name]
	toggle_section:raise_custom_event(event)
end)

-- Draw a section header and main scroll
-- @element rocket_list_container
local section =
Gui.element(function(_, parent, section_name, table_size)
	-- Draw the header for the section
    local header = Gui.header(
        parent,
		{'rocket-info.section-caption-'..section_name},
        {'rocket-info.section-tooltip-'..section_name},
		true,
		section_name..'-header',
		header_toggle.name
	)

	-- Right aligned button to toggle the section
	header.caption = section_name
	toggle_section(header)

    -- Table used to store the data
	local scroll_table = Gui.scroll_table(parent, 215, table_size, section_name)
	scroll_table.parent.visible = false

	-- Return the flow table
	return scroll_table
end)

--- Main gui container for the left flow
-- @element rocket_list_container
local rocket_list_container =
Gui.element(function(event_trigger, parent)
    -- Draw the internal container
    local container = Gui.container(parent, event_trigger, 200)

    -- Set the container style
    local style = container.style
	style.padding = 0

	local player = Gui.get_player_from_element(parent)
	local force_name = player.force.name
	-- Draw stats section
	if config.stats.show_stats then
		update_data_labels(section(container, 'stats', 2), get_stats_data(force_name))
	end

	-- Draw milestones section
	if config.milestones.show_milestones then
		update_data_labels(section(container, 'milestones', 2), get_milestone_data(force_name))
	end

	-- Draw build progress list
	if config.progress.show_progress then
		local col_count = 3
        if check_player_permissions(player, 'remote_launch') then col_count = col_count+1 end
		if check_player_permissions(player, 'toggle_active') then col_count = col_count+1 end
		local progress = section(container, 'progress', col_count)
		-- Label used when there are no active silos
        local no_silos = progress.parent.add{
            type = 'label',
            name = 'no_silos',
            caption = {'rocket-info.progress-no-silos'}
		}
		no_silos.style.padding = {1, 2}
		update_build_progress(progress, get_progress_data(force_name))
	end

	-- Return the exteral container
	return container.parent
end)
:add_to_left_flow(function(player)
    return player.force.rockets_launched > 0 and Roles.player_allowed(player, 'gui/rocket-info')
end)

--- Button on the top flow used to toggle the container
-- @element toggle_rocket_info
Gui.left_toolbar_button('item/satellite', {'rocket-info.main-tooltip'}, rocket_list_container, function(player)
    return Roles.player_allowed(player, 'gui/rocket-info')
end)

--- Update the gui for all players on a force
local function update_rocket_gui_all(force_name)
	local stats = get_stats_data(force_name)
	local milestones = get_milestone_data(force_name)
	local progress = get_progress_data(force_name)
	for _, player in pairs(game.forces[force_name].players) do
        local frame = Gui.get_left_element(player, rocket_list_container)
		local container = frame.container
		update_data_labels(container.stats.table, stats)
		update_data_labels(container.milestones.table, milestones)
		update_build_progress(container.progress.table, progress)
	end
end

--- Event used to update the stats when a rocket is launched
Event.add(defines.events.on_rocket_launched, function(event)
    local force = event.rocket_silo.force
	update_rocket_gui_all(force.name)
end)

--- Update only the progress gui for a force
local function update_rocket_gui_progress(force_name)
	local progress = get_progress_data(force_name)
	for _, player in pairs(game.forces[force_name].players) do
        local frame = Gui.get_left_element(player, rocket_list_container)
		local container = frame.container
		update_build_progress(container.progress.table, progress)
	end
end

--- Event used to set a rocket silo to be awaiting reset
Event.add(defines.events.on_rocket_launch_ordered, function(event)
	local silo = event.rocket_silo
	local silo_data = Rockets.get_silo_data(silo)
	silo_data.awaiting_reset = true
	update_rocket_gui_progress(silo.force.name)
end)

Event.on_nth_tick(150, function()
	for _, force in pairs(game.forces) do
		if #Rockets.get_silos(force.name) > 0 then
			update_rocket_gui_progress(force.name)
		end
	end
end)

--- Adds a silo to the list when it is built
local function on_built(event)
    local entity = event.created_entity
    if entity.valid and entity.name == 'rocket-silo' then
        update_rocket_gui_progress(entity.force.name)
    end
end

Event.add(defines.events.on_built_entity, on_built)
Event.add(defines.events.on_robot_built_entity, on_built)

--- Redraw the progress section on role change
local function role_update_event(event)
	if not config.progress.show_progress then return end
	local player = game.players[event.player_index]
	local container = Gui.get_left_element(player, rocket_list_container).container
	local progress_scroll = container.progress
	Gui.destroy_if_valid(progress_scroll.table)

	local col_count = 3
	if check_player_permissions(player, 'remote_launch') then col_count = col_count+1 end
	if check_player_permissions(player, 'toggle_active') then col_count = col_count+1 end
	local progress = progress_scroll.add{
        type = 'table',
        name = 'table',
        column_count = col_count
    }

	update_build_progress(progress, get_progress_data(player.force.name))
end

Event.add(Roles.events.on_role_assigned, role_update_event)
Event.add(Roles.events.on_role_unassigned, role_update_event)

return rocket_list_container