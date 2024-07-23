local consts = require("__janky-fusion__/consts")

---@type data.RecipeCategory
local recipe_category = {
    type = "recipe-category",
    name = consts.prefix .. "reactor",
}

---@type data.ItemPrototype
local item = {
    type = "item",
    name = consts.prefix .. "reactor",
    subgroup = "energy",
    order = "ga[fusion-reactor]",

    stack_size = 10,
    place_result = consts.prefix .. "reactor",

    icon = consts.graphics_path .. "reactor-icon.png",
    icon_size = 64,
}

local pipe_pos = {
    left = {
        top = { -3.5, -1.5 },
        bottom = { -3.5, 1.5 },
    },
    right = {
        top = { 3.5, -1.5 },
        bottom = { 3.5, 1.5 },
    },
    top = {
        left = { -1.5, -3.5 },
        right = { 1.5, -3.5 },
    },
    bottom = {
        left = { -1.5, 3.5 },
        right = { 1.5, 3.5 },
    },
}

---@type data.CraftingMachinePrototype
local entity = {
    type = "assembling-machine",
    name = consts.prefix .. "reactor",
    subgroup = "energy",

    collision_box = { { -2.9, -2.9 }, { 2.9, 2.9 } },
    selection_box = { { -3, -3 }, { 3, 3 } },

    alert_icon_shift = { 0, 0.5 },
    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 1, result = consts.prefix .. "reactor" },

    icon = consts.graphics_path .. "reactor-icon.png",
    icon_size = 64,

    energy_usage = consts.reactor_base_power .. "W",
    energy_source = {
        type = "burner",
        fuel_inventory_size = 1,
        fuel_category = consts.prefix .. "fusion",
        light_flicker = {
            minimum_intensity = 0,
            maximum_intensity = 0,
            color = { r = 0, g = 0, b = 0, a = 0 },
        },
    },

    crafting_categories = { recipe_category.name },
    crafting_speed = 1,
    ingredient_count = 0,
    show_recipe_icon = false,
    show_recipe_icon_on_map = false,
    allowed_effects = {},

    fluid_boxes = {
        {
            production_type = "input",
            -- pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 1,
            base_level = -1,
            height = 2,

            filter = consts.prefix .. "coolant-cold",

            pipe_connections = {
                {
                    position = pipe_pos.left.top,
                },
                {
                    position = pipe_pos.left.bottom,
                },
                {
                    position = pipe_pos.right.top,
                },
                {
                    position = pipe_pos.right.bottom,
                },
            },
        },
        {
            production_type = "output",
            -- pipe_picture = assembler3pipepictures(),
            -- pipe_covers = pipecoverspictures(),
            base_area = 5,
            base_level = 2,
            height = 1,

            hide_connection_info = true,

            pipe_connections = {
                {
                    type = "output",
                    position = { -0.25, 3 },
                },
                {
                    type = "output",
                    position = { 0.25, -3 },
                },
                {
                    type = "output",
                    position = { -3, -0.25 },
                },
                {
                    type = "output",
                    position = { 3, 0.25 },
                },
            },
        },
        -- { -- only for display while building in cursor
        --     production_type = "output",
        --     filter = consts.prefix .. "plasma",
        --     pipe_connections = {
        --         {
        --             position = pipe_pos.top.left,
        --         },
        --         {
        --             position = pipe_pos.top.right,
        --         },
        --         {
        --             position = pipe_pos.bottom.left,
        --         },
        --         {
        --             position = pipe_pos.bottom.right,
        --         },
        --     },
        -- },
    },

    working_visualisations = {
        {
            animation = {
                filename = consts.graphics_path .. "reactor_active.png",
                width = 395,
                height = 436,
                scale = 0.49,
                shift = { 0, -0.15 },
                frame_count = 1,
                priority = "medium",
            },
        },
        {
            draw_as_sprite = false,
            draw_as_light = true,
            animation = {
                filename = consts.graphics_path .. "reactor_glow.png",
                width = 395,
                height = 436,
                scale = 0.49,
                shift = { 0, -0.15 },
                frame_count = 1,
                priority = "medium",
                draw_as_light = true,
            },
        },
    },

    animation = {
        filename = consts.graphics_path .. "reactor.png",
        width = 395,
        height = 436,
        scale = 0.49,
        shift = { 0, -0.15 },
        frame_count = 1,
        priority = "medium",
    },

    created_effect = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                {
                    type = "script",
                    effect_id = consts.prefix .. "reactor-created",
                },
            }
        }
    },
}

---@type data.ElectricEnergyInterfacePrototype
local power_consumer = {
    type = "electric-energy-interface",
    name = consts.prefix .. "reactor-power",

    collision_box = entity.collision_box,
    selection_box = entity.selection_box,
    collision_mask = {},
    selectable_in_game = false,
    selection_priority = 0,
    alert_icon_shift = { 0, -1 },
    flags = { "not-blueprintable", "not-deconstructable", "not-selectable-in-game" },

    icon = consts.graphics_path .. "reactor-icon.png",
    icon_size = 64,
    localised_name = { "entity-name." .. consts.prefix .. "reactor" },
    localised_description = { "entity-description." .. consts.prefix .. "reactor" },

    gui_mode = "none",

    energy_production = "0W",
    energy_usage = "0W",
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        buffer_capacity = (consts.reactor_power_input * consts.time_per_plasma_cycle * 2) .. "J",
        input_flow_limit = consts.reactor_power_input .. "W",
    },
}

---@type data.StorageTankPrototype
local tank = {
    type = "storage-tank",
    name = consts.prefix .. "reactor-tank",

    collision_box = entity.collision_box,
    selection_box = entity.selection_box,
    collision_mask = {},
    selectable_in_game = false,
    selection_priority = 0,
    flags = { "not-blueprintable", "not-deconstructable", "not-selectable-in-game" },

    show_fluid_icon = false,
    flow_length_in_ticks = 600,
    window_bounding_box = { { 0, 0 }, { 0, 0 } },
    pictures = {
        picture = util.empty_sprite(),
        fluid_background = util.empty_sprite(),
        window_background = util.empty_sprite(),
        flow_sprite = util.empty_sprite(),
        gas_flow = util.empty_sprite(),
    },

    fluid_box = {
        filter = consts.prefix .. "plasma",
        base_area = 2,
        base_level = -3,
        height = 4,

        pipe_connections = {
            {
                type = "input",
                position = { 0.25, 3 },
            },
            {
                type = "input",
                position = { -0.25, -3 },
            },
            {
                type = "input",
                position = { 3, -0.25 },
            },
            {
                type = "input",
                position = { -3, 0.25 },
            },
            {
                type = "input-output",
                positions = {
                    pipe_pos.top.left,
                    pipe_pos.right.top,
                    pipe_pos.bottom.right,
                    pipe_pos.left.bottom,
                },
            },
            {
                type = "input-output",
                positions = {
                    pipe_pos.top.right,
                    pipe_pos.right.bottom,
                    pipe_pos.bottom.left,
                    pipe_pos.left.top,
                },
            },
            {
                type = "input-output",
                positions = {
                    pipe_pos.bottom.right,
                    pipe_pos.left.bottom,
                    pipe_pos.top.left,
                    pipe_pos.right.top,
                },
            },
            {
                type = "input-output",
                positions = {
                    pipe_pos.bottom.left,
                    pipe_pos.left.top,
                    pipe_pos.top.right,
                    pipe_pos.right.bottom,
                },
            },
        },
    },
}

---@type data.PipePrototype
local connector_pipe = {
    type = "pipe",
    name = consts.prefix .. "reactor-connector-pipe",

    collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    collision_mask = {},
    selectable_in_game = false,
    selection_priority = 0,
    flags = { "not-blueprintable", "not-deconstructable", "not-selectable-in-game", "hidden", "placeable-off-grid" },

    show_fluid_icon = false,
    flow_length_in_ticks = 600,
    vertical_window_bounding_box = { { 0, 0 }, { 0, 0 } },
    horizontal_window_bounding_box = { { 0, 0 }, { 0, 0 } },
    pictures = {
        gas_flow = util.empty_sprite(),
        low_temperature_flow = util.empty_sprite(),
        middle_temperature_flow = util.empty_sprite(),
        high_temperature_flow = util.empty_sprite(),

        fluid_background = util.empty_sprite(),
        vertical_window_background = util.empty_sprite(),
        horizontal_window_background = util.empty_sprite(),

        straight_horizontal = util.empty_sprite(),
        straight_horizontal_window = util.empty_sprite(),
        straight_vertical = util.empty_sprite(),
        straight_vertical_single = util.empty_sprite(),
        straight_vertical_window = util.empty_sprite(),

        cross = util.empty_sprite(),

        t_up = util.empty_sprite(),
        t_down = util.empty_sprite(),
        t_left = util.empty_sprite(),
        t_right = util.empty_sprite(),

        corner_up_left = util.empty_sprite(),
        corner_up_right = util.empty_sprite(),
        corner_down_left = util.empty_sprite(),
        corner_down_right = util.empty_sprite(),

        ending_up = util.empty_sprite(),
        ending_down = util.empty_sprite(),
        ending_left = util.empty_sprite(),
        ending_right = util.empty_sprite(),
    },

    fluid_box = {
        base_area = 1,
        base_level = 1.5,
        height = 0.5,

        pipe_connections = {
            {
                type = "input",
                position = { -0.25, -1 },
            },
            {
                type = "output",
                position = { 0.25, -1 },
            },
        },
    },
}

data:extend({ recipe_category, item, entity, power_consumer, tank, connector_pipe })

-- plasma recipes
local plasma_base = {
    type = "recipe",
    name = consts.prefix .. "plasma-n",
    category = recipe_category.name,
    enabled = true,
    hidden = true,

    ingredients = {
        {
            type = "fluid",
            name = consts.prefix .. "coolant-cold",
            amount = consts.plasma_units_per_second / consts.time_per_plasma_cycle / consts.coolant_plasma_ratio,
        },
    },

    results = {
        {
            type = "fluid",
            name = consts.prefix .. "plasma",
            amount = consts.plasma_units_per_second / consts.time_per_plasma_cycle,
            temperature = -1,
        }
    },

    energy_required = consts.time_per_plasma_cycle,
}

for i = 0, 6 do
    local recipe = table.deepcopy(plasma_base)
    recipe.name = recipe.name .. i
    recipe.results[1].temperature = consts.plasma_base_temp * (i + 1)

    data:extend({ recipe })
end
