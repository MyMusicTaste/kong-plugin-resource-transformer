-- daos.lua
local typedefs = require "kong.db.schema.typedefs"

return {
  -- this plugin only results in one custom DAO, named `resource_transformer`:
  resource_transformer = {
    name               = "resource_transformer", -- the actual table in the database
    endpoint_key       = "resource_name",
    primary_key        = { "id" },
    cache_key          = { "resource_name" },
    generate_admin_api = true,
    admin_api_name = "resource-transformers",
    admin_api_nested_name = "resource-transformer",
    fields = {
      { id = typedefs.uuid, },
      { created_at = typedefs.auto_timestamp_s, },
      { resource_name = { type = "string", required = true, unique = true, }, },
      { transform_uuid = typedefs.uuid { required  = true }, },
    },
  },
}
