-- Grab pluginname from module name
local plugin_name = "inject-errors"
local random = math.random

-- load the base plugin object and create a subclass
local error_injection = require("kong.plugins.base_plugin"):extend()

-- constructor
function error_injection:new()
  error_injection.super.new(self, plugin_name)
end

---[[ runs in the 'access_by_lua_block'
function error_injection:access(config)
  error_injection.super.access(self)
  local percentage_random_latency = random (100)

  if config.percentage_latency > percentage_random_latency then
    local latency_diff = config.maximum_latency_msec - config.minimum_latency_msec
    local latency = 0
    if latency_diff < 0 then 
      latency = 0
    else
      latency = config.minimum_latency_msec + random(latency_diff)
    end
    if config.add_header == true then
      kong.response.add_header("X-Kong-Latency-Injected", latency)
    end
    if latency > 0 then
      ngx.sleep(latency/1000)
    end
  else
    if config.add_header == true then
      kong.response.add_header("X-Kong-Latency-Injected","none")
    end
  end 

  local percentage_random_error = random (100)

  if config.percentage_error > percentage_random_error then
    local status_code = 500
    if config.status_codes == nil then
      status_code = 500
    else 
      status_code = config.status_codes[ random( 1, #config.status_codes ) ]
    end
    if config.add_header == true then
      kong.response.add_header("X-Kong-Error-Injected",status_code)
    end
    return kong.response.exit(tonumber(status_code))
  end
  
end --]]

-- set the plugin priority, which determines plugin execution order
error_injection.PRIORITY = 995

-- return our plugin object
return error_injection

