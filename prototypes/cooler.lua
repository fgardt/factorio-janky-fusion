local consts = require("__janky-fusion__/consts")

---@type data.RecipeCategory
local category = {
    type = "recipe-category",
    name = consts.prefix .. "cooler",
}

---@type data.ItemPrototype
local item = {
    type = "item",
    name = consts.prefix .. "cooler",
    subgroup = "energy",
    order = "gc[fusion-cooler]",

    stack_size = 25,
    place_result = consts.prefix .. "cooler",

    icon = consts.graphics_path .. "cooler-icon.png",
    icon_size = 16,
}

local pipe_pos = {
    left = {
        top = { -3, -2 },
        center = { -3, 0 },
        bottom = { -3, 2 },
    },
    right = {
        top = { 3, -2 },
        center = { 3, 0 },
        bottom = { 3, 2 },
    },
    top = {
        left = { -2, -3 },
        center = { 0, -3 },
        right = { 2, -3 },
    },
    bottom = {
        left = { -2, 3 },
        center = { 0, 3 },
        right = { 2, 3 },
    },
}

---@type data.CraftingMachinePrototype
local entity = {
    type = "assembling-machine",
    name = consts.prefix .. "cooler",

    collision_box = { { -2.4, -2.4 }, { 2.4, 2.4 } },
    selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } },

    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 1, result = consts.prefix .. "reactor" },

    icon = consts.graphics_path .. "cooler-icon.png",
    icon_size = 16,

    crafting_categories = { category.name },
    crafting_speed = 1,
    allowed_effects = { "speed", "consumption" },

    energy_usage = "1MW",
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions = 0,
    },

    fluid_boxes = {
        {
            production_type = "input",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 1,
            height = 2,
            base_level = -1,
            pipe_connections = {
                {
                    type = "input",
                    positions = {
                        pipe_pos.bottom.right,
                        pipe_pos.left.bottom,
                        pipe_pos.top.left,
                        pipe_pos.right.top,
                    },
                },
                {
                    type = "input",
                    positions = {
                        pipe_pos.bottom.center,
                        pipe_pos.left.center,
                        pipe_pos.top.center,
                        pipe_pos.right.center,
                    },
                },
                {
                    type = "input",
                    positions = {
                        pipe_pos.bottom.left,
                        pipe_pos.left.top,
                        pipe_pos.top.right,
                        pipe_pos.right.bottom,
                    },
                },
            },
        },
        {
            production_type = "output",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 5,
            base_level = 2,
            height = 1,
            pipe_connections = {
                {
                    type = "output",
                    positions = {
                        pipe_pos.top.left,
                        pipe_pos.right.top,
                        pipe_pos.bottom.right,
                        pipe_pos.left.bottom,
                    },
                },
                {
                    type = "output",
                    positions = {
                        pipe_pos.top.center,
                        pipe_pos.right.center,
                        pipe_pos.bottom.center,
                        pipe_pos.left.center,
                    },
                },
                {
                    type = "output",
                    positions = {
                        pipe_pos.top.right,
                        pipe_pos.right.bottom,
                        pipe_pos.bottom.left,
                        pipe_pos.left.top,
                    },
                },
            },
        },
    },

    animation = {
        filename = "__core__/graphics/icons/unknown.png",
        frame_count = 1,
        size = 64,
        scale = 0.5 * 5,
    }
}

---@type data.RecipePrototype
local coolant_cooling = {
    type = "recipe",
    name = consts.prefix .. "coolant-cooling",

    category = category.name,
    enabled = true,

    ingredients = {
        { type = "fluid", name = consts.prefix .. "coolant-hot", amount = 300 },
    },

    results = {
        { type = "fluid", name = consts.prefix .. "coolant-cold", amount = 290 },
    },

    energy_required = 5
}

data:extend({ category, item, entity, coolant_cooling })
