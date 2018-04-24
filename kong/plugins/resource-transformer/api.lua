-- api.lua
--
-- required: no

local crud = require "kong.api.crud_helpers"

return {
  ["/routes/:id/resource-transformer/"] = {
    before = function(self, dao_factory, helpers)
      crud.find_by_id_or_field(self, dao_factory.routes, {}, self.params.id)
      
      if err then
        return helpers.yield_error(err)
      end
      self.route = rows[1]
      if not self.route then
        return helpers.responses.send_HTTP_NOT_FOUND()
      end
      self.params.route_id = self.route.id
    end,
    
    GET = function(self, dao_factory)
      crud.paginated_set(self, dao_factory.resource_transformer)
    end,
    
    PUT = function(self, dao_factory)
      crud.put(self.params, dao_factory.resource_transformer)
    end,
    
    POST = function(self, dao_factory)
      crud.post(self.params, dao_factory.resource_transformer)
    end
  },
  ["/resource-transformer/"] = {
    GET = function(self, dao_factory)
      crud.paginated_set(self, dao_factory.resource_transformer)
    end
  }  
}