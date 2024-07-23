local consts = require("__janky-fusion__/consts")

---@type data.FluidPrototype
local cold_coolant = {
    type = "fluid",
    name = consts.prefix .. "coolant-cold",

    icon = consts.graphics_path .. "coolant-cold.png",
    icon_size = 32,

    default_temperature = 19,

    base_color = {
        r = 108,
        g = 228,
        b = 192,
        a = 255,
    },
    flow_color = {
        r = 108,
        g = 228,
        b = 192,
        a = 255,
    },
}

---@type data.FluidPrototype
local hot_coolant = {
    type = "fluid",
    name = consts.prefix .. "coolant-hot",

    icon = consts.graphics_path .. "coolant-hot.png",
    icon_size = 32,

    default_temperature = 100,

    base_color = {
        r = 212,
        g = 98,
        b = 89,
        a = 255,
    },
    flow_color = {
        r = 212,
        g = 98,
        b = 89,
        a = 255,
    },
}

---@type data.FluidPrototype
local plasma = {
    type = "fluid",
    name = consts.prefix .. "plasma",

    icon = consts.graphics_path .. "plasma.png",
    icon_size = 32,

    default_temperature = 0,
    max_temperature = 10000000, -- realistic max is 6 million, achievable is 7 million (handfeeding)
    heat_capacity = "0.833333J",

    base_color = {
        r = 1.0,
        g = 0.2,
        b = 1.0,
        a = 1.0,
    },
    flow_color = {
        r = 1.0,
        g = 0.2,
        b = 1.0,
        a = 1.0,
    },

    auto_barrel = false,
}

data:extend({ cold_coolant, hot_coolant, plasma })
