local function check_percentage(given_value, given_config)
  local percentage = tonumber(given_value)
  if percentage == nil then
    return false, "Only numbers between 0 and 100"
  end

  if percentage > 100 then
    return false, "Maximum percentage is 100"
  end

  if percentage < 0 then
    return false, "Minimum percentage is 0"
  end

  given_config.request_percentage=percentage
end

local function check_minimum(given_value, given_config)
  local minimum = tonumber(given_value)
  if minimum == nil then
    return false, "Only numbers allowed"
  end


  if minimum < 0 then
    return false, "Minimum latency must not be smaller than 0"
  end

  --if minimum > given_config.maximum_latency_msec then
  --  return false, "Minimum latency must not be bigger than maximum latency"
  --end

  given_config.minimum_latency_msec = minimum
end

local function check_maximum(given_value, given_config)
  local maximum = tonumber(given_value)
  if maximum == nil then
    return false, "Only numbers allowed"
  end


  if maximum < 0 then
    return false, "Maximum latency must not be smaller than 0"
  end

  --if maximum < given_config.minimum_latency_msec then
  --  return false, "Minimum latency must not be bigger than maximum latency"
  --end

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
    -- perform any custom verification
    return true
  end
}

