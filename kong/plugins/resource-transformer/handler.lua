local BasePlugin = require "kong.plugins.base_plugin"

local access = require "kong.plugins.resource-transformer.access"

local ResourceTransformer = BasePlugin:extend()

ResourceTransformer.PRIORITY = 780
ResourceTransformer.VERSION = "0.0.1"


function ResourceTransformer:new()
  ResourceTransformer.super.new(self, "resource-transformer")
end


function ResourceTransformer:access(config)
  ResourceTransformer.super.access(self)

  access.execute(config)
end


return ResourceTransformer