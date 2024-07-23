local consts = require("__janky-fusion__/consts")

---@type data.RecipePrototype
local base_recipe = {
    type = "recipe",
    name = consts.prefix,
    category = "crafting",
    enabled = true,

    ingredients = {
        { type = "item", name = "raw-fish", amount = 1 },
    },

    results = {
        { type = "item", name = "raw-fish", amount = 1 },
    },

    energy_required = 0.5,
}

local reactor = table.deepcopy(base_recipe)
reactor.name = reactor.name .. "reactor"
reactor.results[1].name = consts.prefix .. "reactor"

local generator = table.deepcopy(base_recipe)
generator.name = generator.name .. "generator"
generator.results[1].name = consts.prefix .. "generator"

local cooler = table.deepcopy(base_recipe)
cooler.name = cooler.name .. "cooler"
cooler.results[1].name = consts.prefix .. "cooler"

data:extend({ reactor, generator, cooler })
