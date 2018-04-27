local _M = {}

local singletons = require "kong.singletons"
local responses = require "kong.tools.responses"

local cache_resource_list_key = "resource-list"

local ngx_log = ngx.log
local CRIT = ngx.CRIT
local NOTICE = ngx.NOTICE
local INFO = ngx.INFO
local DEBUG = ngx.DEBUG



function _M:log_message(level, msg)
  ngx_log(level, msg)
end

function _M.load_transform_uuid(self, resource)
  
  _M:log_message(NOTICE, "TRYING TO LOAD TRANSFORM KEY FROM DB: " .. resource)
  
  local resources, err = singletons.dao.resource_transformer:find_all {
    resource_name = resource
  }
  if err then
    error(err)
  end
  
  _M:log_message(NOTICE, "LOADED TRANSFORM KEY FROM DB: " .. dump(resources))
  
  return resources[1]["transform_uuid"]
end

function _M:get_transform_uuid(resource)
  
  _M:log_message(NOTICE, "TRYING TO GET TRANSFORM KEY FROM CACHE: " .. resource)
  
  local cache_key = singletons.dao.resource_transformer:cache_key(resource)
  
  _M:log_message(NOTICE, "CACHE_KEY RESOLVED TO: " .. cache_key)
  local transform_uuid, err = singletons.cache:get(cache_key, nil, _M.load_transform_uuid, self, resource)
  if err then
    return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
  end
  return transform_uuid
end

function _M:load_resource_list()
  local resources, err = singletons.dao.resource_transformer:find_all()
  if err then
    error(err)
  end
  
  if not resources then
    return nil
  else
    r = {}
    for k, v in pairs(resources) do
      r[#r+1] = v['resource_name']
    end
    
    _M:log_message(NOTICE, "LOADED RESOURCE LIST FROM DB: " .. dump(r))
    return r
  end
end

function _M:get_resource_list()
  local value, err = singletons.cache:get(cache_resource_list_key, nil, _M.load_resource_list)
  
  if err then
    return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
  end
  _M:log_message(NOTICE, "LOADED RESOURCE LIST FROM CACHE: " .. dump(r))
  return value
end

return _M