local consts = require("__janky-fusion__/consts")
local ev = defines.events

---@type HandlerLib
local lib = {}
lib.events = {}

---@class ReactorData
---@field in_progress boolean is reactor currently producing plasma?
---@field reactor LuaEntity the reactor entity
---@field neighbours table<integer, LuaEntity> list of neighbouring reactors
---@field power_interface LuaEntity the electric power interface of the reactor
---@field plasma_tank LuaEntity the plasma distribution tank
---@field plasma_connector_pipe LuaEntity the plasma connector pipe

local function global_setup()
    ---@type table<integer, ReactorData>
    global.reactor = global.reactor or {}

    ---@type table<integer, boolean>
    global.registered_reactors = global.registered_reactors or {}
end

lib.on_init = global_setup
lib.on_configuration_changed = global_setup

local created_effect_id = consts.prefix .. "reactor-created"
local reactor_name = consts.prefix .. "reactor"
local plasma_recipe = consts.prefix .. "plasma-n"

---@param position MapPosition
---@return MapPosition[]
local function potential_neighbour_spots(position)
    local x = position.x or position[1]
    local y = position.y or position[2]

    return {
        { x = x - 6, y = y },
        { x = x + 6, y = y },
        { x = x,     y = y - 6 },
        { x = x,     y = y + 6 },
        { x = x - 3, y = y - 6 },
        { x = x + 3, y = y - 6 },
        { x = x - 3, y = y + 6 },
        { x = x + 3, y = y + 6 },
        { x = x - 6, y = y - 3 },
        { x = x - 6, y = y + 3 },
        { x = x + 6, y = y - 3 },
        { x = x + 6, y = y + 3 },
    }
end

---@param pos1 MapPosition
---@param pos2 MapPosition
---@return boolean
local function is_same_pos(pos1, pos2)
    local x1 = pos1.x or pos1[1]
    local y1 = pos1.y or pos1[2]
    local x2 = pos2.x or pos2[1]
    local y2 = pos2.y or pos2[2]

    return math.abs(x1 - x2) <= 0.1 and math.abs(y1 - y2) <= 0.1
end

---@param event
---| EventData.on_script_trigger_effect
local function on_built(event)
    if event.effect_id ~= created_effect_id then return end

    local entity = event.target_entity

    if not entity or not entity.valid then return end

    --entity.active = false
    --entity.recipe_locked = true
    entity.set_recipe(plasma_recipe .. 0)
    global.registered_reactors[script.register_on_entity_destroyed(entity)] = true

    local surface = entity.surface
    local interface = surface.create_entity({
        name = consts.prefix .. "reactor-power",
        force = entity.force,
        position = entity.position,
    })

    if not interface or not interface.valid then
        if entity.valid then
            entity.destroy()
        end

        return
    end

    local tank = surface.create_entity({
        name = consts.prefix .. "reactor-tank",
        force = entity.force,
        position = entity.position,
        direction = entity.direction,
    })

    if not tank or not tank.valid then
        if entity.valid then
            entity.destroy()
        end

        if interface.valid then
            interface.destroy()
        end

        return
    end

    local connector_pipe = surface.create_entity({
        name = consts.prefix .. "reactor-connector-pipe",
        force = entity.force,
        position = {
            x = entity.position.x,
            y = entity.position.y + 3,
        }
    })

    if not connector_pipe or not connector_pipe.valid then
        if entity.valid then
            entity.destroy()
        end

        if interface.valid then
            interface.destroy()
        end

        if tank.valid then
            tank.destroy()
        end

        return
    end

    -- search for all possible neighbours
    local pos = entity.position
    local spots = potential_neighbour_spots(pos)
    local res = surface.find_entities_filtered({
        name = reactor_name,
        area = {
            left_top = {
                x = pos.x - 7,
                y = pos.y - 7,
            },
            right_bottom = {
                x = pos.x + 7,
                y = pos.y + 7,
            },
        },
    })

    local unit_number = entity.unit_number --[[@as integer]]
    local neighbours = {}
    for _, potential_neighbour in pairs(res) do
        if potential_neighbour.unit_number == unit_number then goto continue end

        local pn_pos = potential_neighbour.position
        local pn_unit_number = potential_neighbour.unit_number --[[@as integer]]

        for _, spot in pairs(spots) do
            if is_same_pos(spot, pn_pos) then
                neighbours[pn_unit_number] = potential_neighbour

                local pn_data = global.reactor[pn_unit_number]
                if pn_data then
                    pn_data.neighbours[unit_number] = entity
                end

                break
            end
        end

        ::continue::
    end

    global.reactor[unit_number] = {
        in_progress = false,
        reactor = entity,
        neighbours = neighbours,
        power_interface = interface,
        plasma_tank = tank,
        plasma_connector_pipe = connector_pipe,
    }
end

lib.events[ev.on_script_trigger_effect] = on_built

---@param event
---| EventData.on_entity_destroyed
local function on_destroyed(event)
    if not global.registered_reactors[event.registration_number] then return end

    global.registered_reactors[event.registration_number] = nil
    local unit_number = event.unit_number --[[@as integer]]

    local data = global.reactor[unit_number]

    if not data then return end

    if data.power_interface and data.power_interface.valid then
        data.power_interface.destroy()
    end

    if data.plasma_tank and data.plasma_tank.valid then
        data.plasma_tank.destroy()
    end

    if data.plasma_connector_pipe and data.plasma_connector_pipe.valid then
        data.plasma_connector_pipe.destroy()
    end

    for neighbour, _ in pairs(data.neighbours) do
        local neighbour_data = global.reactor[neighbour]
        if neighbour_data then
            neighbour_data.neighbours[unit_number] = nil
        end
    end

    global.reactor[unit_number] = nil
end

lib.events[ev.on_entity_destroyed] = on_destroyed

-- ---@param event
-- ---| EventData.on_player_rotated_entity
-- local function on_rotated(event)
--     local entity = event.entity

--     if not entity or not entity.valid then return end
--     if entity.name ~= reactor_name then return end

--     local data = global.reactor[ entity.unit_number --[[@as integer]] ]
--     if not data then return end

--     local plasma_tank = data.plasma_tank
--     if not plasma_tank or not plasma_tank.valid then
--         entity.destroy()
--         return
--     end

--     -- direction of rotation is not important
--     -- since there are only 2 meaningful orientations
--     plasma_tank.rotate()
-- end

-- lib.events[ev.on_player_rotated_entity] = on_rotated

local required_energy = consts.reactor_power_input * consts.time_per_plasma_cycle

---@param event
---| EventData.on_tick
local function on_tick(event)
    for _, data in pairs(global.reactor) do
        local reactor = data.reactor

        -- skip if reactor is not valid, should be removed in on_destroyed next tick
        if not reactor or not reactor.valid then goto continue end

        local plasma_tank = data.plasma_tank

        if not plasma_tank or not plasma_tank.valid then
            reactor.destroy()
            goto continue
        end

        if reactor.direction ~= plasma_tank.direction then
            plasma_tank.direction = reactor.direction
        end

        local interface = data.power_interface

        if not interface or not interface.valid then
            reactor.destroy()
            goto continue
        end

        -- skip reactor if interface does not have enough power
        if interface.energy < required_energy then
            if not data.in_progress then
                reactor.active = false
                goto continue
            end

            if not reactor.active then goto continue end
        end

        -- can enable reactor
        reactor.active = true

        if data.in_progress then
            if reactor.crafting_progress == 1 then
                data.in_progress = false
            end
        else
            if reactor.is_crafting() then
                data.in_progress = true

                interface.energy = interface.energy - required_energy

                -- check for neighbour bonus
                local bonus = 0

                for _, neighbour in pairs(data.neighbours) do
                    if neighbour and neighbour.valid and neighbour.is_crafting() then
                        bonus = bonus + 1
                    end
                end

                -- this might loose some coolant (?)
                local loss = reactor.set_recipe(plasma_recipe .. bonus)
                game.print("loss: " .. serpent.block(loss), { sound = defines.print_sound.never })
            end
        end

        ::continue::
    end
end

lib.events[ev.on_tick] = on_tick

return lib
