--- Adds a compilatron that walks around the spawn area; adapted from redmew code
-- @addon Compilatron

local Event = require 'utils.event' --- @dep utils.event
local Global = require 'utils.global' --- @dep utils.global
local Task = require 'utils.task' --- @dep utils.task
local Token = require 'utils.token' --- @dep utils.token
local config = require 'config.compilatron' --- @dep config.compilatron
local messages = config.messages
local locations = config.locations

local Public = {
    compilatrons={},
    current_messages={}
}

Global.register({
    compilatrons = Public.compilatrons,
    current_messages = Public.current_messages
}, function(tbl)
    Public.compilatrons = tbl.compilatrons
    Public.current_messages = tbl.current_messages
end)

--- This will re-create the speech bubble after it de-spawns called with set_timeout
local callback =
    Token.register(
    function(data)
        local ent = data.ent
        local name = data.name
        local msg_number = data.msg_number
        local message =
            ent.surface.create_entity(
            {name = 'compi-speech-bubble', text = messages[name][msg_number], position = {0, 0}, source = ent}
        )
        Public.current_messages[name] = {message = message, msg_number = msg_number}
    end
)

--- This will move the messages onto the next message in the loop
local function circle_messages()
    for name, ent in pairs(Public.compilatrons) do
        if not ent.valid then
            Public.spawn_compilatron(game.players[1].surface, name)
        end
        local current_message = Public.current_messages[name]
        local msg_number
        local message
        if current_message ~= nil then
            message = current_message.message
            if message ~= nil then
                message.destroy()
            end
            msg_number = current_message.msg_number
            msg_number = (msg_number < #messages[name]) and msg_number + 1 or 1
        else
            msg_number = 1
        end
        -- this calls the callback above to re-spawn the message after some time
        Task.set_timeout_in_ticks(300, callback, {ent = ent, name = name, msg_number = msg_number})
    end
end

Event.on_nth_tick(config.message_cycle, circle_messages)

--- This will add a compilatron to the global and start his message cycle
-- @tparam LuaEntity entity the compilatron entity that moves around
-- @tparam string name the name of the location that the compilatron is at
function Public.add_compilatron(entity, name)
    if not entity and not entity.valid then
        return
    end

    if name == nil then
        return
    end

    Public.compilatrons[name] = entity
    local message =
        entity.surface.create_entity(
        {name = 'compi-speech-bubble', text = messages[name][1], position = {0, 0}, source = entity}
    )
    Public.current_messages[name] = {message = message, msg_number = 1}
end

--- This spawns a new compilatron on a surface with the given location tag (not a position)
-- @tparam LuaSurface surface the surface to spawn the compilatron on
-- @tparam string location the location tag that is in the config file
function Public.spawn_compilatron(surface, location)
    local position = locations[location]
    local pos = surface.find_non_colliding_position('compilatron', position, 1.5, 0.5)
    local compi = surface.create_entity {name='compilatron', position=pos, force=game.forces.neutral}
    Public.add_compilatron(compi, location)
end

-- When the first player is created this will create all compilatrons that are resisted in the config
Event.add(defines.events.on_player_created, function(event)
    if event.player_index ~= 1 then return end
    local player = game.players[event.player_index]

    for location in pairs(locations) do
        Public.spawn_compilatron(player.surface, location)
    end
end)

return Public
