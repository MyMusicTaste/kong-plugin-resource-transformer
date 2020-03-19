-- api.lua
local kong = kong
local endpoints = require "kong.api.endpoints"
local resource_transformers_schema = kong.db.resource_transformer.schema

local function validate_uuid(uuid)
  local regex = "[0-9A-Fa-f]{8}-?[0-9A-Fa-f]{4}-?[1-5][0-9A-Fa-f]{3}-?[89ABab][0-9A-Fa-f]{3}-?[0-9A-Fa-f]{12}$"
  local m = ngx.re.match(uuid, regex)
  
  ngx.log(ngx.NOTICE, "VALIDATING: " .. uuid)
  if m then return true else return false end
end


return {
  ["/resource-transformers/"] = {
    schema = resource_transformers_schema,
    methods = {
      GET = endpoints.get_entity_endpoint(resource_transformers_schema),
      POST = function(self, db)
        ngx.log(ngx.NOTICE, "CREATING RESOURCE TRANSFORMER: " .. self.params.resource_name .. " with " .. self.params.transform_uuid)

        local is_valid = validate_uuid(self.params.transform_uuid)
        if is_valid then
          endpoints.post_collection_endpoint(resource_transformers_schema)
        else
          return kong.response.exit(400, {
            message = "transform_uuid is not valid."
          })
        end  
      end
    },
  },
  ["/resource-transformers/:id_or_resource_name/"] = {
    schema = resource_transformers_schema,
    methods = {
      before = function(self, db, helpers)
        local resource_transformer, _, err_t = endpoints.select_entity(self, db, resource_transformers_schema)
        if err_t then
          return endpoints.handle_error(err_t)
        end
        
        self.resource_transformer = resource_transformer
        
        if not self.resource_transformer then
          return kong.response.exit(404, { message = "Not found" })
        end
        
        self.params.id = self.resource_transformer.id
      end,
      
      GET = endpoints.get_entity_endpoint(resource_transformers_schema),
      PUT = function(self, db, helpers)
        local is_valid = validate_uuid(self.params.transform_uuid)

        if is_valid then
          endpoints.put_entity_endpoint(resource_transformers_schema)(self, db, helpers)
        else
          return kong.response.exit(400, {
            message = "transform_uuid is not valid."
          })
        end 
      end,
      DELETE = endpoints.delete_entity_endpoint(resource_transformers_schema),
    },
  },
}