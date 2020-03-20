local typedefs = require "kong.db.schema.typedefs"


return {
  name = "resource-transformer",
  fields = {
    {
      -- this plugin will only be applied to Services or Routes
      consumer = typedefs.no_consumer
    },
    {
      run_on = typedefs.run_on_first
    },
    {
      -- this plugin will only run within Nginx HTTP module
      protocols = typedefs.protocols_http
    },
    {
      config = {
        type = "record",
        fields = {
          -- { resource_name = { type = "string", required = true, unique = true, }, },
          -- { transform_uuid = { type = "string", required = true, uuid = true, }, },
        },
      },
    },
  },
  entity_checks = {
    -- Describe your plugin's entity validation rules
    -- silly
    -- { at_least_one_of = { "config.resource_name", "config.transform_uuid" }, },
    -- We specify that both header-names cannot be the same
    -- { distinct = { "config.resource_name", "config.transform_uuid"}, },
  },
}