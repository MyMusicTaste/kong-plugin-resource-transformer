local _M = {}

local kong = kong

local cache_resource_list_key = "resource-list"

local ngx_log = ngx.log
local CRIT = ngx.CRIT
local NOTICE = ngx.NOTICE
local INFO = ngx.INFO
local DEBUG = ngx.DEBUG



function _M:log_message(level, msg)
  ngx_log(level, msg)
end

function _M:load_transform_uuid(resource)

  _M:log_message(NOTICE, "TRYING TO LOAD TRANSFORM KEY FROM DB: " .. resource)

  local resources, err = kong.db.resource_transformer:select_by_key(resource)

  if not resources then
    return nil, err
  end

  _M:log_message(NOTICE, "LOADED TRANSFORM KEY FROM DB: " .. dump(resources))

  return resources[1]['transform_uuid']
end

function _M:get_transform_uuid(resource)
  
  _M:log_message(NOTICE, "TRYING TO GET TRANSFORM KEY FROM cache:: " .. resource)
  
  local cache_key = kong.db.resource_transformer:cache_key(resource)
  
  _M:log_message(NOTICE, "CACHE_KEY RESOLVED TO: " .. cache_key)
  local transform_uuid, err = kong.cache:get(cache_key, nil, _M:load_transform_uuid, resource)
  if err then
    kong.log.err(err)
    return kong.response.exit(500, {
      message = "Unexpected error"
    })
  end
  return transform_uuid
end

function _M:load_resource_list()
  r = {}
  for resource, err on kong.db.resource_transformer:each(1000) do
    if err then
      kong.log.err("Error when iterating over resource transformers: " .. err)
      return nil
    end
    r[#r+1] = resource['resource_name']
    kong.log("id: " .. resource.id)
  end
  _M:log_message(NOTICE, "LOADED RESOURCE LIST FROM DB: " .. dump(r))
  return r
end

function _M:get_resource_list()
  local value, err = kong.cache:get(cache_resource_list_key, nil, _M:load_resource_list)
  
  if err then
    kong.log.err(err)
    return kong.response.exit(500, {
      message = "Unexpected error"
    })
  end
  _M:log_message(NOTICE, "LOADED RESOURCE LIST FROM CACHE: " .. dump(r))
  return value
end

return _M