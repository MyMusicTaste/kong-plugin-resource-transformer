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
    fields = {
      {
        -- a value to be inserted by the DAO itself
        -- (think of serial id and the uniqueness of such required here)
        id = typedefs.uuid,
      },
      {
        -- also interted by the DAO itself
        created_at = typedefs.auto_timestamp_s,
      },
      {
        -- a foreign key to a consumer's id
        resource_name = {
          type      = "string",
          required   = true,
          unique = true,
        },
      },
      {
        -- a unique API key
        transform_uuid = {
          type      = "uuid",
          required  = true
        },
      },
    },
  },
}
