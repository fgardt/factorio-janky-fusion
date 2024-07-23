local consts = require("__janky-fusion__/consts")
local ev = defines.events

---@type HandlerLib
local lib = {}
lib.events = {}

---@class ReactorData
---@field neighbours table<integer, boolean> list of unit numbers of neighbouring reactors

local function global_setup()
    ---@type table<integer, ReactorData>
    global.reactor = global.reactor or {}

    ---@type table<integer, boolean>
    global.registered_reactors = global.registered_reactors or {}
end

lib.on_init = global_setup
lib.on_configuration_changed = global_setup

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
---| EventData.on_built_entity
---| EventData.on_robot_built_entity
---| EventData.script_raised_built
---| EventData.script_raised_revive
---| EventData.on_entity_cloned
local function on_built(event)
    local entity = event.created_entity or event.entity or event.destination

    if not entity or not entity.valid then return end
    if entity.name ~= reactor_name then return end

    -- entity.recipe_locked = true
    entity.set_recipe(plasma_recipe .. 0)
    global.registered_reactors[script.register_on_entity_destroyed(entity)] = true

    -- search for all possible neighbours
    local pos = entity.position
    local spots = potential_neighbour_spots(pos)
    local res = entity.surface.find_entities_filtered({
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
                neighbours[pn_unit_number] = true

                local pn_data = global.reactor[pn_unit_number]
                if pn_data then
                    pn_data.neighbours[unit_number] = true
                end

                break
            end
        end

        ::continue::
    end

    global.reactor[unit_number] = { neighbours = neighbours }
end

lib.events[ev.on_built_entity] = on_built
lib.events[ev.on_robot_built_entity] = on_built
lib.events[ev.script_raised_built] = on_built
lib.events[ev.script_raised_revive] = on_built
-- lib.events[ev.on_entity_cloned] = on_built

---@param event
---| EventData.on_entity_destroyed
local function on_destroyed(event)
    if not global.registered_reactors[event.registration_number] then return end

    global.registered_reactors[event.registration_number] = nil

    local unit_number = event.unit_number --[[@as integer]]
    for neighbour, _ in pairs(global.reactor[unit_number].neighbours) do
        local neighbour_data = global.reactor[neighbour]
        if neighbour_data then
            neighbour_data.neighbours[unit_number] = nil
        end
    end

    global.reactor[unit_number] = nil
end

lib.events[ev.on_entity_destroyed] = on_destroyed

return lib
