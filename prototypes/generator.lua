local consts = require("__janky-fusion__/consts")

---@type data.RecipeCategory
local category = {
    type = "recipe-category",
    name = consts.prefix .. "generator",
}

---@type data.ItemPrototype
local item = {
    type = "item",
    name = consts.prefix .. "generator",
    subgroup = "energy",
    order = "gb[fusion-generator]",

    stack_size = 25,
    place_result = consts.prefix .. "generator",

    icon = consts.graphics_path .. "generator-icon.png",
    icon_size = 64,
}

---@type data.PipeConnectionDefinition[]
local gen_plasma_positions = {
    {
        type = "input",
        positions = {
            { -1, 3 },
            { -3, -1 },
            { 1,  -3 },
            { 3,  1 },
        },
    },
    {
        type = "input",
        positions = {
            { 1,  3 },
            { -3, 1 },
            { -1, -3 },
            { 3,  -1 },
        },
    },
    {
        type = "output",
        positions = {
            { 0,  -3 },
            { 3,  0 },
            { 0,  3 },
            { -3, 0 },
        },
    },
    {
        type = "output",
        positions = {
            { -2, 0 },
            { 0,  -2 },
            { 2,  0 },
            { 0,  2 },
        },
    },
    {
        type = "output",
        positions = {
            { 2,  0 },
            { 0,  2 },
            { -2, 0 },
            { 0,  -2 },
        },
    },
    {
        type = "output",
        positions = {
            { -2, -1 },
            { 1,  -2 },
            { 2,  1 },
            { -1, 2 },
        },
    },
    {
        type = "output",
        positions = {
            { 2,  -1 },
            { 1,  2 },
            { -2, 1 },
            { -1, -2 },
        },
    },
}

---@type data.PipeConnectionDefinition[]
local gen_coolant_positions = {
    {
        type = "output",
        positions = {
            { -1, -3 },
            { 3,  -1 },
            { 1,  3 },
            { -3, 1 },
        },
    },
    {
        type = "output",
        positions = {
            { 1,  -3 },
            { 3,  1 },
            { -1, 3 },
            { -3, -1 },
        },
    },
}

---@type data.CraftingMachinePrototype
local entity = {
    type = "assembling-machine",
    name = consts.prefix .. "generator",
    subgroup = "energy",

    icon = consts.graphics_path .. "generator-icon.png",
    icon_size = 64,

    collision_box = { { -1.4, -2.4 }, { 1.4, 2.4 } },
    selection_box = { { -1.5, -2.5 }, { 1.5, 2.5 } },

    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 1, result = consts.prefix .. "generator" },

    crafting_categories = { category.name },
    crafting_speed = 1,
    ingredient_count = 0,
    show_recipe_icon = false,
    show_recipe_icon_on_map = false,
    fixed_recipe = consts.prefix .. "generator_power_conversion",
    allowed_effects = {},

    energy_usage = "1W",
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
    },

    fluid_boxes = {
        {
            production_type = "input",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 1,
            base_level = -1,
            height = 2,
            pipe_connections = gen_plasma_positions,
        },
        {
            production_type = "output",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 1,
            base_level = 1,
            height = 2,
            pipe_connections = gen_coolant_positions,
        },
    },

    working_visualisations = {
        {
            north_animation = {
                filename = consts.graphics_path .. "generator-north_active.png",
                frame_count = 1,
                width = 200,
                height = 334,
                scale = 0.48,
                priority = "medium",
            },
            south_animation = {
                filename = consts.graphics_path .. "generator-south_active.png",
                frame_count = 1,
                width = 203,
                height = 325,
                scale = 0.48,
                priority = "medium",
            },
            east_animation = {
                filename = consts.graphics_path .. "generator-east_active.png",
                frame_count = 1,
                width = 320,
                height = 225,
                scale = 0.5,
                priority = "medium",
            },
            west_animation = {
                filename = consts.graphics_path .. "generator-west_active.png",
                frame_count = 1,
                width = 320,
                height = 225,
                scale = 0.5,
                priority = "medium",
            },
        },
        {
            draw_as_sprite = false,
            draw_as_light = true,
            east_animation = {
                filename = consts.graphics_path .. "generator-east_glow.png",
                frame_count = 1,
                width = 320,
                height = 225,
                scale = 0.5,
                priority = "medium",
                draw_as_light = true,
            },
            west_animation = {
                filename = consts.graphics_path .. "generator-west_glow.png",
                frame_count = 1,
                width = 320,
                height = 225,
                scale = 0.5,
                priority = "medium",
                draw_as_light = true,
            },
        },
    },

    animation = {
        north = {
            filename = consts.graphics_path .. "generator-north.png",
            frame_count = 1,
            width = 200,
            height = 334,
            scale = 0.48,
            priority = "medium",
        },
        south = {
            filename = consts.graphics_path .. "generator-south.png",
            frame_count = 1,
            width = 203,
            height = 325,
            scale = 0.48,
            priority = "medium",
        },
        east = {
            filename = consts.graphics_path .. "generator-east.png",
            frame_count = 1,
            width = 320,
            height = 225,
            scale = 0.5,
            priority = "medium",
        },
        west = {
            filename = consts.graphics_path .. "generator-west.png",
            frame_count = 1,
            width = 320,
            height = 225,
            scale = 0.5,
            priority = "medium",
        },
    },
}

---@type data.RecipePrototype
local power_recipe = {
    type = "recipe",
    name = consts.prefix .. "generator_power_conversion",

    category = category.name,
    enabled = true,
    hidden = true,

    ingredients = {
        { type = "fluid", name = consts.prefix .. "plasma", amount = 25 }
    },

    results = {
        { type = "fluid", name = consts.prefix .. "coolant-hot", amount = 25, temperature = 100 },
    },
}

---@type data.GeneratorPrototype
local gen = {
    type = "generator",
    name = consts.prefix .. "generator_power",

    icon = consts.graphics_path .. "generator-icon.png",
    icon_size = 64,

    collision_box = { { -1.4, -2.4 }, { 1.4, 2.4 } },
    selection_box = { { -1.5, -2.5 }, { 1.5, 2.5 } },

    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 1 },

    energy_source = {
        type = "electric",
        usage_priority = "secondary-output",
    },

    maximum_temperature = 1000000,
    scale_fluid_usage = true,
    max_power_output = "50MW",
    fluid_usage_per_tick = 1,

    horizontal_animation = {
        filename = consts.graphics_path .. "generator-east.png",
        width = 320,
        height = 225,
        scale = 0.5,
        frame_count = 1,
    },

    vertical_animation = {
        filename = consts.graphics_path .. "generator-north.png",
        width = 200,
        height = 334,
        scale = 0.48,
        frame_count = 1,
    },

    fluid_box = {
        production_type = "input",
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 2,
        base_level = 0,
        height = 1,
        filter = consts.prefix .. "plasma",
        pipe_connections = gen_plasma_positions,
    }
}

data:extend({ category, item, entity, power_recipe, gen })
