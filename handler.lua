-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")


-- Grab pluginname from module name
local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

-- load the base plugin object and create a subclass
local plugin = require("kong.plugins.base_plugin"):extend()

-- constructor
function plugin:new()
  plugin.super.new(self, plugin_name)
  
  -- do initialization here, runs in the 'init_by_lua_block', before worker processes are forked

end


---[[ runs in the 'access_by_lua_block'
function plugin:access(config)
  plugin.super.access(self)
  local percentage_random = math.random (100)

  if config.request_percentage_error > percentage_random then
    if #config.error_types > 0 then
      local error_type = config.error_types[ math.random( #config.error_types ) ] )
    else 
      error_type = 500
    end
      return kong.response.exit(error_type, "")
  end

  if config.request_percentage_latency > percentage_random then
    local latency_diff = config.maximum_latency_msec - config.minimum_latency_msec
    local latency = 0
    if latency_diff < 0 then 
      latency = 0
    else
      latency = config.minimum_latency_msec + math.random(latency_diff)
    end
    if config.add_header == true then
      ngx.header["X-Kong-Random-Latency"] = latency
    end
    if latency > 0 then
      ngx.sleep(latency/1000)
    end
  else
    if config.add_header == true then
      ngx.header["X-Kong-Random-Latency"] = "none"
    end
  end 
  
end --]]

---[[ runs in the 'header_filter_by_lua_block'
function plugin:header_filter(plugin_conf)
  plugin.super.access(self)

  -- your custom code here, for example;

end --]]


-- set the plugin priority, which determines plugin execution order
plugin.PRIORITY = 1000

-- return our plugin object
return plugin

