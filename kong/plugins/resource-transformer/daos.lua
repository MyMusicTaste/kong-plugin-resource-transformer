-- daos.lua
-- Defines a list of DAOs (Database Access Objects) that are abstractions of custom entities needed by your plugin and stored in the datastore.
-- Required: No
local SCHEMA = {
  primary_key = {"id"},
  table = "resource_transformer", -- the actual table in the database
  fields = {
    id = {type = "id", dao_insert_value = true}, -- a value to be inserted by the DAO itself (think of serial ID and the uniqueness of such required here)
    resource_name = {type = "string", required = true, unique = true}, -- resource name to check for
    transform_uuid = {type = "id", required = true}, -- 
    created_at = {type = "timestamp", immutable = true, dao_insert_value = true} -- also interted by the DAO itself
  }
}

return {resource_transformer = SCHEMA} 