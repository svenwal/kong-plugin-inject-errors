local Errors = require "kong.dao.errors"

local function check_percentage(given_value, given_config)
  local percentage = tonumber(given_value) or -1
  if percentage < 0 or percentage > 100 then
    return false, "Only numbers between 0 and 100"
  end

  given_config.request_percentage = percentage
end

local function check_minimum(given_value, given_config)
  local minimum = tonumber(given_value) or -1
  if minimum < 0 then
    return false, "Minimum latency must be a number greater than or equal to 0"
  end

  given_config.minimum_latency_msec = minimum
end

local function check_maximum(given_value, given_config)
  local maximum = tonumber(given_value) or -1

  if maximum < 0 then
    return false, "Maximum latency must be a number greater than or equal to 0"
  end

  given_config.maximum_latency_msec = maximum
end

return {
  no_consumer = false, -- this plugin is available on APIs as well as on Consumers,
  fields = {
    -- Describe your plugin's configuration's schema here.
    minimum_latency_msec = {type = "integer", required = true, func = check_minimum, default = 0},
    maximum_latency_msec = {type = "integer", required = true, func = check_maximum, default = 1000},
    request_percentage = {type = "integer", required = true, func = check_percentage, default = 50},
    add_header = {type = "boolean", default = true},

  },
  self_check = function(schema, plugin_t, dao, is_updating)
    local maximum = tonumber(plugin_t.maximum_latency_msec) or -1
    local minimum = tonumber(plugin_t.minimum_latency_msec) or -1

    if minimum > maximum then
      return false, Errors.schema "minimum latency must be smaller than maximum latency"
    end

    return true
  end
}

