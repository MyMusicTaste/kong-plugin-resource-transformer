-- api.lua
local kong = kong
local endpoints = require "kong.api.endpoints"
local resource_transformers_schema = kong.db.resource_transformer.schema
local utils = require "kong.tools.utils"

local ngx = ngx


return {
  ["/resource-transformers"] = {
    schema = resource_transformers_schema,
    methods = {
      GET = endpoints.get_collection_endpoint(resource_transformers_schema),
      POST = function(self, db)
        ngx.log(ngx.NOTICE, "CREATING RESOURCE TRANSFORMER: " .. self.params.resource_name .. " with " .. self.params.transform_uuid)

        local is_valid = utils.is_valid_uuid(self.params.transform_uuid)
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
  ["/resource-transformers/:resource_transformer"] = {
    schema = resource_transformers_schema,
    methods = {
      before = function(self, db, helpers)
        local resource_transformer, _, err_t = endpoints.select_entity(self, db, resource_transformers_schema)
        if err_t then
          return endpoints.handle_error(err_t)
        end

        if not resource_transformer then
          return kong.response.exit(404, { message = "Not found" })
        end

        self.resource_transformer = resource_transformer
        self.params.id = resource_transformer.id
      end,
      
      GET = endpoints.get_entity_endpoint(resource_transformers_schema),
      PUT = function(self, db, helpers)
        local is_valid = utils.is_valid_uuid(self.params.transform_uuid)

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