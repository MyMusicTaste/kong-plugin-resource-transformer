-- schema.lua
-- Holds the schema of your plugin's configuration, so that the user can only enter valid configuration values.
-- Required: Yes

return {
  no_consumer = true, -- this plugin is available on APIs as well as on Consumers,
  fields = {
    -- Describe your plugin's configuration's schema here.
    -- resource_name = {type = "string", required = true, unique = true},
    -- transform_uuid = {type = "string", required = true, regex = "[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[4][0-9A-Fa-f]{3}-[89ABab][0-9A-Fa-f]{3}-[0-9A-Fa-f]{12}$"}
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    -- perform any custom verification
    return true
  end
}
