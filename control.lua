---@class HandlerLib
---@field add_remote_interface fun()?
---@field add_commands fun()?
---@field on_init fun()?
---@field on_load fun()?
---@field on_configuration_changed fun()?
---@field events table<defines.events, fun(event: EventData)>?
---@field on_nth_tick table<number, fun(event: NthTickEventData)>?

local ev_handler = require("event_handler")
ev_handler.add_lib(require("runtime.reactor"))
