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

    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 1, result = consts.prefix .. "reactor" },

    crafting_categories = { recipe_category.name },
    crafting_speed = 1,
    ingredient_count = 0,
    show_recipe_icon = false,
    show_recipe_icon_on_map = false,
    allowed_effects = {},

    fluid_boxes = {
        {
            production_type = "input",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 1,
            base_level = -1,
            height = 2,
            pipe_connections = {
                {
                    type = "input-output",
                    positions = {
                        pipe_pos.left.top,
                        pipe_pos.top.right,
                        pipe_pos.right.bottom,
                        pipe_pos.bottom.left,
                    },
                },
                {
                    type = "input-output",
                    positions = {
                        pipe_pos.left.bottom,
                        pipe_pos.top.left,
                        pipe_pos.right.top,
                        pipe_pos.bottom.right,
                    },
                },
                {
                    type = "input-output",
                    positions = {
                        pipe_pos.right.bottom,
                        pipe_pos.bottom.left,
                        pipe_pos.left.top,
                        pipe_pos.top.right,
                    },
                },
                {
                    type = "input-output",
                    positions = {
                        pipe_pos.right.top,
                        pipe_pos.bottom.right,
                        pipe_pos.left.bottom,
                        pipe_pos.top.left,
                    },
                },
            },
        },
        {
            production_type = "output",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 2,
            base_level = 0,
            height = 5,
            pipe_connections = {
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

    icon = consts.graphics_path .. "reactor-icon.png",
    icon_size = 64,

    energy_usage = "100MW",
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
}

data:extend({ recipe_category, item, entity })

-- plasma recipes
local plasma_base = {
    type = "recipe",
    name = consts.prefix .. "plasma-n",
    category = recipe_category.name,
    enabled = true,
    hidden = true,

    ingredients = {
        { type = "fluid", name = consts.prefix .. "coolant-cold", amount = 60 },
    },

    energy_required = 1,
}

for i = 0, 6 do
    local recipe = table.deepcopy(plasma_base)
    recipe.name = recipe.name .. i
    recipe.results = {
        { type = "fluid", name = consts.prefix .. "plasma", amount = 120, temperature = 1000000 * (i + 1) },
    }

    data:extend({ recipe })
end
