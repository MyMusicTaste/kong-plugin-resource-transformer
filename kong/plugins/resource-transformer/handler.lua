-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")


-- Grab pluginname from module name
-- local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")
local plugin_name = "resource-transformer"

local rewrite = require "kong.plugins.resource-transformer.rewrite"

-- load the base plugin object and create a subclass
local ResourceTransformer = require("kong.plugins.base_plugin"):extend()



-- constructor
function ResourceTransformer:new()
  ResourceTransformer.super.new(self, plugin_name)
  
  -- do initialization here, runs in the 'init_by_lua_block', before worker processes are forked

end

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
--
-- The call to `.super.xxx(self)` is a call to the base_plugin, which does nothing, except logging
-- that the specific handler was executed.
---------------------------------------------------------------------------------------------

---[[ runs in the 'rewrite_by_lua_block' (from version 0.10.2+)
-- IMPORTANT: during the `rewrite` phase neither the `api` nor the `consumer` will have
-- been identified, hence this handler will only be executed if the plugin is 
-- configured as a global plugin!
function ResourceTransformer:rewrite(plugin_conf)
  ResourceTransformer.super.rewrite(self)
  -- your custom code here
  rewrite.execute(conf)
end --]]

--[[ runs in the 'access_by_lua'
-- Executed for every request from a client and before it is being proxied to the upstream service.
function MMTRequestTransformer:access(plugin_conf)
  MMTRequestTransformer.super.access(self)
  -- your custom code here
  access.execute(conf)
end --]]


--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)
  plugin.super.access(self)
  -- your custom code here
  
end --]]


-- set the plugin priority, which determines plugin execution order
ResourceTransformer.PRIORITY = 802
ResourceTransformer.VERSION = "0.0.1"

-- return our plugin object
return ResourceTransformer