local consts = require("__janky-fusion__/consts")

---@type data.FuelCategory
local category = {
    type = "fuel-category",
    name = consts.prefix .. "fusion",
}

---@type data.ItemPrototype
local item = {
    type = "item",
    name = consts.prefix .. "fusion-fuel-cell",
    subgroup = "intermediate-product",
    order = "s[fusion-fuel-cell]",

    stack_size = 50,

    fuel_category = category.name,
    fuel_value = "80GJ",

    icon = consts.graphics_path .. "fusion-fuel-cell.png",
    icon_size = 64,
}

---@type data.RecipePrototype
local recipe = {
    type = "recipe",
    name = consts.prefix .. "fusion-fuel-cell",
    category = "centrifuging",
    enabled = true,

    ingredients = {
        { type = "item",  name = "iron-plate", amount = 10 },
        { type = "fluid", name = "water",      amount = 10000 },
    },

    results = {
        { type = "item", name = consts.prefix .. "fusion-fuel-cell", amount = 1 },
    },

    energy_required = 60,
}

data:extend({ category, item, recipe })
