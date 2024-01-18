--[[-- Gui Module - Player List
    - Adds a player list to show names and play time; also includes action buttons which can preform actions to players
    @gui Player-List
    @alias player_list
]]

-- luacheck:ignore 211/Colors
local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Datastore = require 'expcore.datastore' --- @dep expcore.datastore
local Event = require 'utils.event' --- @dep utils.event
local config = require 'config.gui.player_list_actions' --- @dep config.gui.player_list_actions
local Colors = require 'utils.color_presets' --- @dep utils.color_presets
local format_time = _C.format_time --- @dep expcore.common

--- Stores all data for the warp gui
local PlayerListData = Datastore.connect('PlayerListData')
PlayerListData:set_serializer(Datastore.name_serializer)
local SelectedPlayer = PlayerListData:combine('SelectedPlayer')
local SelectedAction = PlayerListData:combine('SelectedAction')

-- Set the config to use these stores
config.set_datastores(SelectedPlayer, SelectedAction)

--- Button used to open the action bar
-- @element open_action_bar
local open_action_bar =
Gui.element{
    type = 'sprite-button',
    sprite = 'utility/expand_dots_white',
    tooltip = {'player-list.open-action-bar'},
    style = 'frame_button'
}
:style{
    padding = -2,
    width = 8,
    height = 14
}
:on_click(function(player, element, _)
    local selected_player_name = element.parent.name
    local old_selected_player_name = SelectedPlayer:get(player)
    if selected_player_name == old_selected_player_name then
        SelectedPlayer:remove(player)
    else
        SelectedPlayer:set(player, selected_player_name)
    end
end)

--- Button used to close the action bar
-- @element close_action_bar
local close_action_bar =
Gui.element{
    type = 'sprite-button',
    sprite = 'utility/close_black',
    tooltip = {'player-list.close-action-bar'},
    style = 'slot_sized_button_red'
}
:style(Gui.sprite_style(30, -1, { top_margin = -1, right_margin = -1 }))
:on_click(function(player, _)
    SelectedPlayer:remove(player)
    SelectedAction:remove(player)
end)

--- Button used to confirm a reason
-- @element reason_confirm
local reason_confirm =
Gui.element{
    type = 'sprite-button',
    sprite = 'utility/confirm_slot',
    tooltip = {'player-list.reason-confirm'},
    style = 'slot_sized_button_green'
}
:style(Gui.sprite_style(30, -1, { left_margin = -2, right_margin = -1 }))
:on_click(function(player, element)
    local reason = element.parent.entry.text
    local action_name = SelectedAction:get(player)
    local reason_callback = config.buttons[action_name].reason_callback
    if reason == nil or not reason:find("%S") then reason = 'no reason given' end
    reason_callback(player, reason)
    SelectedPlayer:remove(player)
    SelectedAction:remove(player)
    element.parent.entry.text = ''
end)

--- Set of elements that are used to make up a row of the player table
-- @element add_player_base
local add_player_base =
Gui.element(function(event_trigger, parent, player_data)
    -- Add the button to open the action bar
    local toggle_action_bar_flow = parent.add{ type = 'flow', name = player_data.name }
    open_action_bar(toggle_action_bar_flow)

    -- Add the player name
    local player_name_flow = parent.add{ type = 'flow', name = 'player-name-'..player_data.index }
    local player_name = player_name_flow.add{
        type = 'label',
        name = event_trigger,
        caption = player_data.name,
        tooltip = {'player-list.open-map', player_data.name, player_data.tag, player_data.role_name}
    }
    player_name.style.padding = {0, 2,0, 0}
    player_name.style.font_color = player_data.chat_color

    -- Add the time played label
    local alignment = Gui.alignment(parent, 'player-time-'..player_data.index)
    local time_label = alignment.add{
        name = 'label',
        type = 'label',
        caption = player_data.caption,
        tooltip = player_data.tooltip
    }
    time_label.style.padding = 0

    return time_label
end)
:on_click(function(player, element, event)
    local selected_player_name = element.caption
    local selected_player = game.players[selected_player_name]
    if event.button == defines.mouse_button_type.left then
        -- LMB will open the map to the selected player
        local position = selected_player.position
        event.player.zoom_to_world(position, 1.75)
    else
        -- RMB will toggle the settings
        local old_selected_player_name = SelectedPlayer:get(player)
        if selected_player_name == old_selected_player_name then
            SelectedPlayer:remove(player)
            SelectedAction:remove(player)
        else
            SelectedPlayer:set(player, selected_player_name)
        end
    end
end)

-- Removes the three elements that are added as part of the base
local function remove_player_base(parent, player)
    Gui.destroy_if_valid(parent[player.name])
    Gui.destroy_if_valid(parent['player-name-'..player.index])
    Gui.destroy_if_valid(parent['player-time-'..player.index])
end

-- Update the time label for a player using there player time data
local function update_player_base(parent, player_time)
    local time_element = parent[player_time.element_name]
    if time_element and time_element.valid then
        time_element.label.caption = player_time.caption
        time_element.label.tooltip = player_time.tooltip
    end
end

--- Adds all the buttons and flows that make up the action bar
-- @element add_action_bar
local add_action_bar_buttons =
Gui.element(function(_, parent)
    close_action_bar(parent)
    -- Loop over all the buttons in the config
    for action_name, button_data in pairs(config.buttons) do
        -- Added the permission flow
        local permission_flow = parent.add{ type = 'flow', name = action_name }
        permission_flow.visible = false
        -- Add the buttons under that permission
        for _, button in ipairs(button_data) do
            button(permission_flow)
        end
    end

    return parent
end)

--- Updates the visible state of the action bar buttons
local function update_action_bar(element)
    local player = Gui.get_player_from_element(element)
    local selected_player_name = SelectedPlayer:get(player)

    if not selected_player_name then
        -- Hide the action bar when no player is selected
        element.visible = false

    else
        local selected_player = game.players[selected_player_name]
        if not selected_player.connected then
            -- If the player is offline then reest stores
            element.visible = false
            SelectedPlayer:remove(player)
            SelectedAction:remove(player)

        else
            -- Otherwise check what actions the player is allowed to use
            element.visible = true
            for action_name, buttons in pairs(config.buttons) do
                if buttons.auth and not buttons.auth(player, selected_player) then
                    element[action_name].visible = false
                elseif Roles.player_allowed(player, action_name) then
                    element[action_name].visible = true
                end
            end

        end
    end
end

--- Main player list container for the left flow
-- @element player_list_container
local player_list_container =
Gui.element(function(event_trigger, parent)
    -- Draw the internal container
    local container = Gui.container(parent, event_trigger, 200)

    -- Draw the scroll table for the players
    local scroll_table = Gui.scroll_table(container, 184, 3)

    -- Change the style of the scroll table
    local scroll_table_style = scroll_table.style
    scroll_table_style.padding = {1, 0,1, 2}

    -- Add the action bar
    local action_bar = Gui.footer(container, nil, nil, false, 'action_bar')

    -- Change the style of the action bar
    local action_bar_style = action_bar.style
    action_bar_style.height = 35
    action_bar_style.padding = {1, 3}
    action_bar.visible = false

    -- Add the buttons to the action bar
    add_action_bar_buttons(action_bar)

    -- Add the reason bar
    local reason_bar = Gui.footer(container, nil, nil, false, 'reason_bar')

    -- Change the style of the reason bar
    local reason_bar_style = reason_bar.style
    reason_bar_style.height = 35
    reason_bar_style.padding = {-1, 3}
    reason_bar.visible = false

    -- Add the text entry for the reason bar
    local reason_field =
    reason_bar.add{
        name = 'entry',
        type = 'textfield',
        style = 'stretchable_textfield',
        tooltip = {'player-list.reason-entry'}
    }

    -- Change the style of the text entry
    local reason_entry_style = reason_field.style
    reason_entry_style.padding = 0
    reason_entry_style.height = 28
    reason_entry_style.minimal_width = 160

    -- Add the confirm reason button
    reason_confirm(reason_bar)

    -- Return the exteral container
    return container.parent
end)
:add_to_left_flow(true)

--- Button on the top flow used to toggle the player list container
-- @element toggle_player_list
Gui.left_toolbar_button('entity/character', {'player-list.main-tooltip'}, player_list_container, function(player)
    return Roles.player_allowed(player, 'gui/player-list')
end)

-- Get caption and tooltip format for a player
local function get_time_formats(online_time, afk_time)
    local tick = game.tick > 0 and game.tick or 1
    local percent = math.round(online_time/tick, 3)*100
    local caption = format_time(online_time)
    local tooltip = {'player-list.afk-time', percent, format_time(afk_time, {minutes=true, long=true})}
    return caption, tooltip
end

-- Get the player time to be used to update time label
local function get_player_times()
    local ctn = 0
    local player_times = {}
    for _, player in pairs(game.connected_players) do
        ctn = ctn + 1
        -- Add the player time details to the array
        local caption, tooltip = get_time_formats(player.online_time, player.afk_time)
        player_times[ctn] = {
            element_name = 'player-time-'..player.index,
            caption = caption,
            tooltip = tooltip
        }
    end

    return player_times
end

-- Get a sorted list of all online players
local function get_player_list_order()
    -- Sort all the online players into roles
    local players = {}
    for _, player in pairs(game.connected_players) do
        local highest_role = Roles.get_player_highest_role(player)
        if not players[highest_role.name] then
            players[highest_role.name] = {}
        end
        table.insert(players[highest_role.name], player)
    end

    -- Sort the players from roles into a set order
    local ctn = 0
    local player_list_order = {}
    for _, role_name in pairs(Roles.config.order) do
        if players[role_name] then
            for _, player in pairs(players[role_name]) do
                ctn = ctn + 1
                -- Add the player data to the array
                local caption, tooltip = get_time_formats(player.online_time, player.afk_time)
                player_list_order[ctn] = {
                    name = player.name,
                    index = player.index,
                    tag = player.tag,
                    role_name = role_name,
                    chat_color = player.chat_color,
                    caption = caption,
                    tooltip = tooltip
                }
            end
        end
    end

    --[[Adds fake players to the player list
    local tick = game.tick+1
    for i = 1, 10 do
        local online_time = math.random(1, tick)
        local afk_time = math.random(online_time-(tick/10), tick)
        local caption, tooltip = get_time_formats(online_time, afk_time)
        player_list_order[ctn+i] = {
            name='Player '..i,
            index=0-i,
            tag='',
            role_name = 'Fake Player',
            chat_color = table.get_random_dictionary_entry(Colors),
            caption = caption,
            tooltip = tooltip
        }
    end--]]

    return player_list_order
end

--- Update the play times every 30 sections
Event.on_nth_tick(1800, function()
    local player_times = get_player_times()
    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, player_list_container)
        local scroll_table = frame.container.scroll.table
        for _, player_time in pairs(player_times) do
            update_player_base(scroll_table, player_time)
        end
    end
end)

--- When a player leaves only remove they entry
Event.add(defines.events.on_player_left_game, function(event)
    local remove_player = game.players[event.player_index]
    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, player_list_container)
        local scroll_table = frame.container.scroll.table
        remove_player_base(scroll_table, remove_player)

        local selected_player_name = SelectedPlayer:get(player)
        if selected_player_name == remove_player.name then
            SelectedPlayer:remove(player)
            SelectedAction:remove(player)
        end
    end
end)

--- All other events require a full redraw of the table
local function redraw_player_list()
    local player_list_order = get_player_list_order()
    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, player_list_container)
        local scroll_table = frame.container.scroll.table
        scroll_table.clear()
        for _, next_player_data in ipairs(player_list_order) do
            add_player_base(scroll_table, next_player_data)
        end
    end
end

Event.add(defines.events.on_player_joined_game, redraw_player_list)
Event.add(Roles.events.on_role_assigned, redraw_player_list)
Event.add(Roles.events.on_role_unassigned, redraw_player_list)

--- When the action player is changed the action bar will update
SelectedPlayer:on_update(function(player_name, selected_player)
    local player = game.players[player_name]
    local frame = Gui.get_left_element(player, player_list_container)
    local scroll_table = frame.container.scroll.table
    update_action_bar(frame.container.action_bar)
    for _, next_player in pairs(game.connected_players) do
        local element = scroll_table[next_player.name][open_action_bar.name]
        local style = 'frame_button'
        if next_player.name == selected_player then
            style = 'tool_button'
        end
        element.style = style
        local element_style = element.style
        element_style.padding = -2
        element_style.width = 8
        element_style.height = 14
    end
end)

--- When the action name is changed the reason input will update
SelectedAction:on_update(function(player_name, selected_action)
    local player = game.players[player_name]
    local frame = Gui.get_left_element(player, player_list_container)
    local element = frame.container.reason_bar
    if selected_action then
        -- if there is a new value then check the player is still online
        local selected_player_name = SelectedPlayer:get(player_name)
        local selected_player = game.players[selected_player_name]
        if selected_player.connected then
            element.visible = true
        else
            -- Clear if the player is offline
            SelectedPlayer:remove(player)
            SelectedAction:remove(player)
        end

    else
        element.visible = false

    end
end)