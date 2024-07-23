require("util")

return {
    prefix = "JF_",
    graphics_path = "__janky-fusion__/graphics/",

    plasma_base_temp = 1000000,
    plasma_units_per_second = 120,
    coolant_plasma_ratio = 2,
    time_per_plasma_cycle = 1,          -- in seconds
    fuel_cell_burn_time = 800,          -- in seconds
    reactor_base_power = 100 * 1000000, -- 100MW
    reactor_power_input = 10 * 1000000, -- 10MW
}
