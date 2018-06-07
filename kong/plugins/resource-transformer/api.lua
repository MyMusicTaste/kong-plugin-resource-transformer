-- api.lua
--
-- required: no

local responses = require "kong.tools.responses"
local crud = require "kong.api.crud_helpers"

local function validate_uuid(uuid)
  local regex = "[0-9A-Fa-f]{8}-?[0-9A-Fa-f]{4}-?[1-5][0-9A-Fa-f]{3}-?[89ABab][0-9A-Fa-f]{3}-?[0-9A-Fa-f]{12}$"
  local m = ngx.re.match(uuid, regex)
  
  ngx.log(ngx.NOTICE, "VALIDATING: " .. uuid)
  if m then return true else return false end
end


return {
  ["/resource-transformers/"] = {
    GET = function(self, dao_factory)
      return crud.paginated_set(self, dao_factory.resource_transformer)
    end,
    
    POST = function(self, dao_factory)
      ngx.log(ngx.NOTICE, "CREATING RESOURCE TRANSFORMER: " .. self.params.resource_name .. " with " .. self.params.transform_uuid)
      
      
      local is_valid = validate_uuid(self.params.transform_uuid)
      
      if is_valid then
        crud.post(self.params, dao_factory.resource_transformer)
      else
        return responses.send_HTTP_BAD_REQUEST("transform_uuid is not valid.")
      end  
    end
  },
  ["/resource-transformers/:id_or_resource_name/"] = {
    before = function(self, dao_factory, helpers)
      local rows, err = crud.find_by_id_or_field(dao_factory.resource_transformer, {}, self.params.id_or_resource_name, "resource_name")
      
      if err then
        return helpers.yield_error(err)
      end
      
      self.resource_transformer = rows[1]
      
      if not self.resource_transformer then
        return helpers.responses.send_HTTP_NOT_FOUND()
      end
      
      self.params.id = self.resource_transformer.id
    end,
    
    GET = function(self, dao_factory)
      crud.get(self.params, dao_factory.resource_transformer)
    end,
    
    PUT = function(self, dao_factory)
      local is_valid = validate_uuid(self.params.transform_uuid)
      
      if is_valid then
        crud.put(self.params, dao_factory.resource_transformer)
      else
        return responses.send_HTTP_BAD_REQUEST("transform_uuid is not valid.")
      end 
    end,

    DELETE = function(self, dao_factory)
      crud.delete(self.params, dao_factory.resource_transformer)
    end
  }
}
