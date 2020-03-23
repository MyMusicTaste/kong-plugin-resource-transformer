local kong = kong

local cache_resource_list_key = "resource-list"
local uuid = require "resty.jit-uuid"

local _M = {}

local ngx_log = ngx.log
local CRIT = ngx.CRIT
local NOTICE = ngx.NOTICE
local INFO = ngx.INFO
local DEBUG = ngx.DEBUG


local function log_message(level, msg)
  ngx_log(level, msg)
end


local function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end


local function load_transform_uuid(resource)

  log_message(NOTICE, "TRYING TO LOAD TRANSFORM KEY FROM DB: " .. resource)

  local resources, err = kong.db.resource_transformer:select_by_key(resource)

  if not resources then
    return nil, err
  end

  log_message(NOTICE, "LOADED TRANSFORM KEY FROM DB: " .. dump(resources))

  return resources[1]['transform_uuid']
end


local function get_transform_uuid(resource)
  
  log_message(NOTICE, "TRYING TO GET TRANSFORM KEY FROM cache:: " .. resource)

  local cache_key = kong.db.resource_transformer:cache_key(resource)
  
  log_message(NOTICE, "CACHE_KEY RESOLVED TO: " .. cache_key)
  local transform_uuid, err = kong.cache:get(cache_key, nil,
                                             load_transform_uuid,
                                             resource)
  if err then
    kong.log.err(err)
    return kong.response.exit(500, {
      message = "Unexpected error"
    })
  end
  return transform_uuid
end


local function load_resource_list()
  r = {}
  for resource, err in kong.db.resource_transformer:each(1000) do
    if err then
      kong.log.err("Error when iterating over resource transformers: " .. err)
      return nil
    end
    r[#r+1] = resource['resource_name']
    kong.log("id: " .. resource.id)
  end
  log_message(NOTICE, "LOADED RESOURCE LIST FROM DB: " .. dump(r))
  return r
end


local function get_resource_list()
  local value, err = kong.cache:get(cache_resource_list_key, nil, load_resource_list)
  
  if err then
    kong.log.err(err)
    return kong.response.exit(500, {
      message = "Unexpected error"
    })
  end
  log_message(NOTICE, "LOADED RESOURCE LIST FROM CACHE: " .. dump(r))
  return value
end


local rewrite_uri = function (m)
  log_message(ngx.DEBUG, "REWRITING: " .. dump(m))
  local transform_uuid = get_transform_uuid(m[1])
  local u = uuid.generate_v5(transform_uuid, m['integer_id']):gsub("-", "")
  
  local new_uri = "/" .. m[1] .. "/" .. u .. "/"
  log_message(ngx.DEBUG, "NEW URI IS: " .. new_uri)
  
  return new_uri
end


local function transform_resource_id(conf)
  local resources = get_resource_list()
  local uri = ngx.var.uri
  
  for k, v in pairs(resources) do
    local newstr, n, err = ngx.re.gsub(uri, "/(" .. v .. ")/(?<integer_id>[0-9]+)/", rewrite_uri)
    uri = newstr
    
    if n>0 then 
      log_message(DEBUG, "MATCH_FOUND: " .. newstr)
    else
      log_message(DEBUG, "MATCH NOT FOUND FOR: " .. v .. ". Skipping...")
    end
  
  end

  ngx.var.upstream_uri = uri
end


function _M.execute(config)
  transform_resource_id(config)
end


return _M
