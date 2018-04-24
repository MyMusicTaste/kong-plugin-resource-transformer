local _M = {}

local function transform_resource_id(conf)
  local uri = ngx.var.uri
  
  ngx.req.set_uri(uri)
end

function _M.execute(conf)
  transform_resource_id(conf)
end

return _M