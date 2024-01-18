--[[-- Gui Module - Task List
    - Adds a task list to the game which players can add, remove and edit items on
    @gui Task-List
    @alias task_list
]]
local Gui = require "expcore.gui" --- @dep expcore.gui
local Event = require "utils.event" --- @dep utils.event
local Roles = require "expcore.roles" --- @dep expcore.roles
local Datastore = require "expcore.datastore" --- @dep expcore.datastore
local config = require "config.gui.tasks" --- @dep config.gui.tasks
local Tasks = require "modules.control.tasks" --- @dep modules.control.tasks
local format_time = _C.format_time --- @dep expcore.common

--- Stores all data for the task gui by player
local TaskGuiData = Datastore.connect("TaskGuiData")
TaskGuiData:set_serializer(Datastore.name_serializer)
local PlayerIsEditing = TaskGuiData:combine("PlayerIsEditing")
PlayerIsEditing:set_default(false)
local PlayerIsCreating = TaskGuiData:combine("PlayerIsCreating")
PlayerIsCreating:set_default(false)
local PlayerSelected = TaskGuiData:combine("PlayerSelected")
PlayerSelected:set_default(nil)

-- Styles used for sprite buttons
local Styles = {
    sprite22 = {
        height = 22,
        width = 22,
        padding = -2
    },
    footer_button = {
        height = 29,
        maximal_width = 268,
        horizontally_stretchable = true,
        padding = -2
    }
}

--- If a player is allowed to use the edit buttons
local function check_player_permissions(player, task)
    if task then
        -- When a task is given check if the player can edit it
        local allow_edit_task = config.allow_edit_task

        -- Check if the player being the last to edit will override existing permisisons
        if config.user_can_edit_own_tasks and task.last_edit_name == player.name then
            return true
        end

        -- Check player has permisison based on value in the config
        if allow_edit_task == "all" then
            return true
        elseif allow_edit_task == "admin" then
            return player.admin
        elseif allow_edit_task == "expcore.roles" then
            return Roles.player_allowed(player, config.expcore_roles_allow_edit_task)
        end

        -- Return false as all other condidtions have not been met
        return false
    else
        -- When a task is not given check if the player can add a new task
        local allow_add_task = config.allow_add_task

        -- Check player has permisison based on value in the config
        if allow_add_task == "all" then
            return true
        elseif allow_add_task == "admin" then
            return player.admin
        elseif allow_add_task == "expcore.roles" then
            return Roles.player_allowed(player, config.expcore_roles_allow_add_task)
        end

        -- Return false as all other condidtions have not been met
        return false
    end
end

--- Elements

--- Button displayed in the header bar, used to add a new task
-- @element add_new_task
local add_new_task =
    Gui.element {
    type = "sprite-button",
    sprite = "utility/add",
    tooltip = {"task-list.add-tooltip"},
    style = "tool_button"
}:style(Styles.sprite22):on_click(
    function(player, _, _)
        -- Disable editing
        PlayerIsEditing:set(player, false)
        -- Clear selected
        PlayerSelected:set(player, nil)
        -- Open task create footer
        PlayerIsCreating:set(player, true)
    end
)

--- Header displayed when no tasks are in the task list
-- @element no_tasks_found
local no_tasks_found =
    Gui.element(
    function(_, parent)
        local header =
            parent.add {
            name = "no_tasks_found_element",
            type = "frame",
            style = "negative_subheader_frame"
        }
        header.style.horizontally_stretchable = true
        -- Flow used for centering the content in the subheader
        local center =
            header.add {
            type = "flow",
            style = "centering_horizontal_flow"
        }
        center.style.horizontally_stretchable = true
        center.add {
            name = "header_label",
            type = "label",
            style = "bold_label",
            caption = {"", "[img=utility/warning_white] ", {"task-list.no-tasks"}},
            tooltip = {"task-list.no-tasks-tooltip"}
        }
        return header
    end
)

--- Frame element with the right styling
-- @element subfooter_frame
local subfooter_frame =
    Gui.element(
    function(_, parent, name)
        return parent.add {
            type = "frame",
            name = name,
            direction = "vertical",
            style = "subfooter_frame"
        }
    end
):style(
    {
        padding = 5,
        use_header_filler = false,
        horizontally_stretchable = true
    }
)

--- Label element preset
-- @element subfooter_label
local subfooter_label =
    Gui.element(
    function(_, parent, caption)
        return parent.add {
            name = "footer_label",
            type = "label",
            style = "heading_1_label",
            caption = caption
        }
    end
)

--- Action flow that contains action buttons
-- @element subfooter_actions
local subfooter_actions =
    Gui.element(
    function(_, parent)
        return parent.add {
            type = "flow",
            name = "actions"
        }
    end
)

--- Button element with a flow around it to fix duplicate name inside of the scroll flow
-- @element task_list_item
local task_list_item =
    Gui.element(
    function(event_trigger, parent, task)
        local flow =
            parent.add {
            type = "flow",
            name = "task-" .. task.task_id,
            caption = task.task_id
        }
        flow.style.horizontally_stretchable = true
        local button =
            flow.add {
            name = event_trigger,
            type = "button",
            style = "list_box_item",
            caption = task.title
        }
        button.style.horizontally_stretchable = true
        button.style.horizontally_squashable = true
        return flow
    end
):on_click(
    function(player, element, _)
        local task_id = element.parent.caption
        PlayerSelected:set(player, task_id)
    end
)

--- Scrollable list of all tasks
-- @element task_list
local task_list =
    Gui.element(
    function(_, parent)
        local scroll_pane =
            parent.add {
            name = "scroll",
            type = "scroll-pane",
            direction = "vertical",
            horizontal_scroll_policy = "never",
            vertical_scroll_policy = "auto",
            style = "scroll_pane_under_subheader"
        }
        scroll_pane.style.horizontally_stretchable = true
        scroll_pane.style.padding = 0
        scroll_pane.style.maximal_height = 224

        local flow =
            scroll_pane.add {
            name = "task_list",
            type = "flow",
            direction = "vertical"
        }
        flow.style.vertical_spacing = 0
        flow.style.horizontally_stretchable = true

        return flow
    end
)

--- Button element inside the task view footer to start editing a task
-- @element task_view_edit_button
local task_view_edit_button =
    Gui.element {
    type = "button",
    caption = {"", "[img=utility/rename_icon_normal] ", {"task-list.edit"}},
    tooltip = {"task-list.edit-tooltip"},
    style = "shortcut_bar_button"
}:style(Styles.footer_button):on_click(
    function(player, _, _)
        local selected = PlayerSelected:get(player)
        PlayerIsEditing:set(player, true)

        Tasks.set_editing(selected, player.name, true)
    end
)

--- Button to close the task view footer
-- @element task_view_close_button
local task_view_close_button =
Gui.element{
	type = "sprite-button",
	sprite = "utility/collapse_dark",
	hovered_sprite = "utility/collapse",
	tooltip = {"task-list.close-tooltip"}
}
:style(Styles.sprite22):on_click(
    function(player, _, _)
        PlayerSelected:set(player, nil)
    end
)

--- Button to delete the task inside the task view footer
-- @element task_view_delete_button
local task_view_delete_button =
    Gui.element {
    type = "button",
    caption = {"", "[img=utility/trash] ", {"task-list.delete"}},
    tooltip = {"task-list.delete-tooltip"},
    style = "shortcut_bar_button_red"
}:style(Styles.footer_button):on_click(
    function(player, _, _)
        local selected = PlayerSelected:get(player)
        PlayerSelected:set(player, nil)
        Tasks.remove_task(selected)
    end
)

--- Subfooter inside the tasklist container that holds all the elements for viewing a task
-- @element task_view_footer
local task_view_footer =
    Gui.element(
    function(_, parent)
        local footer = subfooter_frame(parent, "view")
        local flow = footer.add{ type = "flow" }
        subfooter_label(flow, {"task-list.view-footer-header"})
        local alignment = Gui.alignment(flow)
        task_view_close_button(alignment)
        local title_label =
            footer.add {
            type = "label",
            name = "title"
        }
        title_label.style.padding = 4
        title_label.style.font = "default-bold"
        title_label.style.single_line = false
        local body_label =
            footer.add {
            type = "label",
            name = "body"
        }
        body_label.style.padding = 4
        body_label.style.single_line = false

        local action_flow = subfooter_actions(footer)
        task_view_delete_button(action_flow)
        task_view_edit_button(action_flow)
        return footer
    end
)

local message_pattern = "(.-)\n(.*)"

--- Parse a string into a message object with title and body
-- @tparam string str message data
local function parse_message(str)
    -- Trim the spaces of the string
    local trimmed = string.gsub(str, "^%s*(.-)%s*$", "%1")
    local message = { title = "", body = "" }
    local title, body = string.match(trimmed, message_pattern)
    if not title then
        -- If it doesn't match the pattern return the str as a title
        message.title = trimmed
    else
        message.title = title
        message.body = body
    end
    return message
end

-- Button variable initialisation because it is used inside the textfield element events
local task_edit_confirm_button
local task_create_confirm_button

--- Textfield element used in both the task create and edit footers
-- @element task_message_textfield
local task_message_textfield =
    Gui.element {
    type = "text-box",
    text = ""
}:style(
    {
        maximal_width = 268,
        minimal_height = 100,
        horizontally_stretchable = true
    }
):on_text_changed(
    function(player, element, _)
        local isEditing = PlayerIsEditing:get(player)
        local isCreating = PlayerIsCreating:get(player)

        local valid = string.len(element.text) > 5

        if isCreating then
            element.parent.actions[task_create_confirm_button.name].enabled = valid
        elseif isEditing then
            element.parent.actions[task_edit_confirm_button.name].enabled = valid
        end
    end
)

--- Button to confirm the changes inside the task edit footer
-- @element task_edit_confirm_button
task_edit_confirm_button =
    Gui.element {
    type = "button",
    caption = {"", "[img=utility/check_mark] ", {"task-list.confirm"}},
    tooltip = {"task-list.confirm-tooltip"},
    style = "shortcut_bar_button_green"
}:style(Styles.footer_button):on_click(
    function(player, element, _)
        local selected = PlayerSelected:get(player)
        PlayerIsEditing:set(player, false)
        local new_message = element.parent.parent[task_message_textfield.name].text
        local parsed = parse_message(new_message)
        Tasks.update_task(selected, player.name, parsed.title, parsed.body)
        Tasks.set_editing(selected, player.name, nil)
    end
)

--- Button to discard the changes inside the task edit footer
-- @element edit_task_discard_button
local edit_task_discard_button =
    Gui.element {
    type = "button",
    caption = {"", "[img=utility/close_black] ", {"task-list.discard"}},
    tooltip = {"task-list.discard-tooltip"},
    style = "shortcut_bar_button_red"
}:style(Styles.footer_button):on_click(
    function(player, _, _)
        local selected = PlayerSelected:get(player)
        Tasks.set_editing(selected, player.name, nil)
        PlayerIsEditing:set(player, false)
    end
)

--- Subfooter inside the tasklist container that holds all the elements for editing a task
-- @element task_edit_footer
local task_edit_footer =
    Gui.element(
    function(_, parent)
        local footer = subfooter_frame(parent, "edit")
        subfooter_label(footer, {"task-list.edit-footer-header"})

        task_message_textfield(footer)

        local action_flow = subfooter_actions(footer)

        edit_task_discard_button(action_flow)
        task_edit_confirm_button(action_flow)

        return footer
    end
)

--- Button to confirm the changes inside the task create footer
-- @element task_create_confirm_button
task_create_confirm_button =
    Gui.element {
    type = "button",
    caption = {"", "[img=utility/check_mark] ", {"task-list.confirm"}},
    tooltip = {"task-list.confirm-tooltip"},
    style = "shortcut_bar_button_green",
    enabled = false
}:style(Styles.footer_button):on_click(
    function(player, element, _)
        local message = element.parent.parent[task_message_textfield.name].text
        PlayerIsCreating:set(player, false)
        local parsed = parse_message(message)
        local task_id = Tasks.add_task(player.force.name, player.name, parsed.title, parsed.body)
        PlayerSelected:set(player, task_id)
    end
)

--- Button to discard the changes inside the task create footer
-- @element task_create_discard_button
local task_create_discard_button =
    Gui.element {
    type = "button",
    caption = {"", "[img=utility/close_black] ", {"task-list.discard"}},
    tooltip = {"task-list.discard-tooltip"},
    style = "shortcut_bar_button_red"
}:style(Styles.footer_button):on_click(
    function(player, _, _)
        PlayerIsCreating:set(player, false)
    end
)

--- Subfooter inside the tasklist container that holds all the elements to create a new task
-- @element task_create_footer
local task_create_footer =
    Gui.element(
    function(_, parent)
        local footer = subfooter_frame(parent, "create")
        subfooter_label(footer, {"task-list.create-footer-header"})

        task_message_textfield(footer)

        local action_flow = subfooter_actions(footer)

        task_create_discard_button(action_flow)
        task_create_confirm_button(action_flow)

        return footer
    end
)

--- Clear and repopulate the task list with all current tasks
local repopulate_task_list = function(task_list_element)
    local force = Gui.get_player_from_element(task_list_element).force
    local task_ids = Tasks.get_force_task_ids(force.name)
    task_list_element.clear()

    -- Set visibility of the no_tasks_found element depending on the amount of tasks still in the task manager
    task_list_element.parent.parent.no_tasks_found_element.visible = #task_ids == 0

    -- Add each task to the flow
    for _, task_id in ipairs(task_ids) do
        -- Add the task
        local task = Tasks.get_task(task_id)
        local element = task_list_item(task_list_element, task)
        -- Set tooltip
        local last_edit_name = task.last_edit_name
        local last_edit_time = task.last_edit_time
        element[task_list_item.name].tooltip = {"task-list.last-edit", last_edit_name, format_time(last_edit_time)}
    end
end

--- Main task list container for the left flow
-- @element task_list_container
local task_list_container =
    Gui.element(
    function(event_trigger, parent)
        -- Draw the internal container
        local container = Gui.container(parent, event_trigger, 268)
        container.style.maximal_width = 268
        container.style.minimal_width = 268

        -- Draw the header
        local header = Gui.header(container, {"task-list.main-caption"}, {"task-list.sub-tooltip"}, true)

        -- Draw the new task button
        local player = Gui.get_player_from_element(parent)
        local add_new_task_element = add_new_task(header)
        add_new_task_element.visible = check_player_permissions(player)

        -- Draw no task found element
        no_tasks_found(container)

        -- Draw task list element
        local task_list_element = task_list(container)
        repopulate_task_list(task_list_element)

        local task_view_footer_element = task_view_footer(container)
        local task_edit_footer_element = task_edit_footer(container)
        local task_create_footer_element = task_create_footer(container)
        task_view_footer_element.visible = false
        task_edit_footer_element.visible = false
        task_create_footer_element.visible = false
        -- Return the external container
        return container.parent
    end
):add_to_left_flow(
    function(player)
        local task_ids = Tasks.get_force_task_ids(player.force.name)
        return #task_ids > 0
    end
)

--- Button on the top flow used to toggle the task list container
-- @element toggle_left_element
Gui.left_toolbar_button(
    "utility/not_enough_repair_packs_icon",
    {"task-list.main-tooltip"},
    task_list_container,
    function(player)
        return Roles.player_allowed(player, "gui/task-list")
    end
)

-- Function to update a single task and some of the elements inside the container
local update_task = function(player, task_list_element, task_id)
    local task = Tasks.get_task(task_id)
    local task_ids = Tasks.get_force_task_ids(player.force.name)
    -- Set visibility of the no_tasks_found element depending on the amount of tasks still in the task manager
    task_list_element.parent.parent.no_tasks_found_element.visible = #task_ids == 0

    -- Task no longer exists so should be removed from the list
    if not task then
        task_list_element["task-" .. task_id].destroy()
        return
    end

    local element
    -- If task does not exist yet add it to the list
    if not task_list_element["task-" .. task_id] then
        element = task_list_item(task_list_element, task)
    else
        -- If the task exists update the caption
        element = task_list_element["task-" .. task_id]
        element[task_list_item.name].caption = task.title
    end
    -- Set tooltip
    local last_edit_name = task.last_edit_name
    local last_edit_time = task.last_edit_time
    element[task_list_item.name].tooltip = {"task-list.last-edit", last_edit_name, format_time(last_edit_time)}
end

-- Update the footer task edit view
local update_task_edit_footer = function(player, task_id)
    local task = Tasks.get_task(task_id)
    local frame = Gui.get_left_element(player, task_list_container)
    local edit_flow = frame.container.edit

    local message_element = edit_flow[task_message_textfield.name]

    message_element.focus()
    message_element.text = task.title .. "\n" .. task.body
end

-- Update the footer task view
local update_task_view_footer = function(player, task_id)
    local task = Tasks.get_task(task_id)
    local frame = Gui.get_left_element(player, task_list_container)
    local view_flow = frame.container.view
    local has_permission = check_player_permissions(player, task)

    local title_element = view_flow.title
    local body_element = view_flow.body
    local edit_button_element = view_flow.actions[task_view_edit_button.name]
    local delete_button_element = view_flow.actions[task_view_delete_button.name]

    edit_button_element.visible = has_permission
    delete_button_element.visible = has_permission
    title_element.caption = task.title
    body_element.caption = task.body

    local players_editing = table.get_keys(task.currently_editing)
    if #players_editing > 0 then
        edit_button_element.tooltip = {"task-list.edit-tooltip", table.concat(players_editing, ", ")}
    else
        edit_button_element.tooltip = {"task-list.edit-tooltip-none"}
    end
end

--- When a new task is added it will update the task list for everyone on that force
--- Or when a task is updated it will update the specific task elements
Tasks.on_update(
    function(task_id, curr_state, prev_state)
        -- Get the force to update, task is nil when removed
        local force
        if curr_state then
            force = game.forces[curr_state.force_name]
        else
            force = game.forces[prev_state.force_name]
        end

        -- Update the task for all the players on the force
        for _, player in pairs(force.connected_players) do
            -- Update the task view elements if the player currently being looped over has this specific task selected
            local selected = PlayerSelected:get(player)
            if selected == task_id then
                if curr_state then
                    update_task_view_footer(player, selected)
                else
                    PlayerSelected:set(player, nil)
                end
            end

            local frame = Gui.get_left_element(player, task_list_container)
            local task_list_element = frame.container.scroll.task_list

            -- Update the task that was changed
            update_task(player, task_list_element, task_id)
        end
    end
)

-- When a player is creating a new task.
PlayerIsCreating:on_update(
    function(player_name, curr_state, _)
        local player = game.players[player_name]

        local frame = Gui.get_left_element(player, task_list_container)
        local create = frame.container.create

        -- Clear the textfield
        local message_element = frame.container.create[task_message_textfield.name]
        local confirm_button_element = frame.container.create.actions[task_create_confirm_button.name]
        message_element.focus()
        message_element.text = ""
        confirm_button_element.enabled = false

        if curr_state then
            create.visible = true
        else
            create.visible = false
        end
    end
)

-- When a player selects a different warp from the list
PlayerSelected:on_update(
    function(player_name, curr_state, prev_state)
        local player = game.players[player_name]

        local frame = Gui.get_left_element(player, task_list_container)
        local task_list_element = frame.container.scroll.task_list
        local view_flow = frame.container.view
        local edit_flow = frame.container.edit
        local isEditing = PlayerIsEditing:get(player)
        local isCreating = PlayerIsCreating:get(player)

        -- If the selection has an previous state re-enable the button list element
        if prev_state then
            task_list_element["task-" .. prev_state][task_list_item.name].enabled = true
        end

        if curr_state then
            -- Disable the selected element
            task_list_element["task-" .. curr_state][task_list_item.name].enabled = false

            -- Update the view footer
            update_task_view_footer(player, curr_state)

            -- If a player is creating then remove the creation dialogue
            if isCreating then
                PlayerIsCreating:set(player, false)
            end

            -- Depending on if the player is currently editing change the current task edit footer to the current task
            if isEditing then
                update_task_edit_footer(player, curr_state)
                Tasks.set_editing(prev_state, player.name, nil)
                Tasks.set_editing(curr_state, player.name, true)
                view_flow.visible = false
                edit_flow.visible = true
            else
                view_flow.visible = true
                edit_flow.visible = false
            end
        else
            -- If curr_state nil then hide footer elements and set editing to nil for prev_state
            if prev_state and Tasks.get_task(prev_state) then
                Tasks.set_editing(prev_state, player.name, nil)
            end
            view_flow.visible = false
            edit_flow.visible = false
        end
    end
)

-- When the edit view opens or closes
PlayerIsEditing:on_update(
    function(player_name, curr_state, _)
        local player = game.players[player_name]

        local frame = Gui.get_left_element(player, task_list_container)
        local view_flow = frame.container.view
        local edit_flow = frame.container.edit

        local selected = PlayerSelected:get(player)
        if curr_state then
            update_task_edit_footer(player, selected)
            view_flow.visible = false
            edit_flow.visible = true
        else
            view_flow.visible = true
            edit_flow.visible = false
        end
    end
)

--- Makes sure the right buttons are present when roles change
local function role_update_event(event)
    local player = game.players[event.player_index]
    local container = Gui.get_left_element(player, task_list_container).container
    -- Update the view task
    local selected = PlayerSelected:get(player)
    if selected then
        update_task_view_footer(player, selected)
        PlayerSelected:set(player, selected)
        -- button to edit the task.
        -- Resetting the players selected task to make sure the player does not see an
    end

    -- Update the new task button and create footer in case the user can now add them
    local has_permission = check_player_permissions(player)
    local add_new_task_element = container.header.alignment[add_new_task.name]
    add_new_task_element.visible = has_permission
    local isCreating = PlayerIsCreating:get(player)
    if isCreating and not has_permission then
        PlayerIsCreating:set(player, false)
    end
end

Event.add(Roles.events.on_role_assigned, role_update_event)
Event.add(Roles.events.on_role_unassigned, role_update_event)

--- Redraw all tasks and clear editing/creating after joining or changing force
local function reset_task_list(event)
    -- Repopulate the task list
    local player = game.players[event.player_index]
    local frame = Gui.get_left_element(player, task_list_container)
    local task_list_element = frame.container.scroll.task_list
    repopulate_task_list(task_list_element)

    -- Check if the selected task is still valid
    local selected = PlayerSelected:get(player)
    if selected and Tasks.get_task(selected) ~= nil then
        PlayerIsCreating:set(player, false)
        PlayerIsEditing:set(player, false)
        PlayerSelected:set(player, nil)
    end
end

Event.add(defines.events.on_player_joined_game, reset_task_list)
Event.add(defines.events.on_player_changed_force, reset_task_list)