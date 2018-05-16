local responses = require "kong.tools.responses"
local hooks = require "kong.plugins.resource-transformer.hooks"
local uuid = require "resty.jit-uuid"

local _M = {}



local ngx_log = ngx.log
local CRIT = ngx.CRIT
local NOTICE = ngx.NOTICE
local INFO = ngx.INFO
local DEBUG = ngx.DEBUG

local test_uri = "/api/v1/notifications/1/"


function dump(o)
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

local function log_message(level, msg)
  ngx_log(level, msg)
end

local rewrite_uri = function (m)
  log_message(ngx.DEBUG, "REWRITING: " .. dump(m))
  local transform_uuid = hooks:get_transform_uuid(m[1])
  local u = uuid.generate_v5(transform_uuid, m['integer_id'])
  
  local new_uri = "/" .. m[1] .. "/" .. u
  hooks:log_message(ngx.DEBUG, "NEW URI IS: " .. new_uri)
  
  return new_uri
end

local function transform_resource_id(conf)
  local resources = hooks.get_resource_list()
  local uri = ngx.var.uri
  
  for k, v in pairs(resources) do
    local newstr, n, err = ngx.re.gsub(uri, "/(" .. v .. ")/(?<integer_id>[0-9]+)", rewrite_uri)
    uri = newstr
    
    if n>0 then 
      hooks:log_message(ngx.DEBUG, "MATCH_FOUND: " .. newstr)
    else
      hooks:log_message(ngx.DEBUG, "MATCH NOT FOUND FOR: " .. v .. ". Skipping...")
    end
  
  end
  
  ngx.var.upstream_uri = uri
end

function _M.execute(conf)
  transform_resource_id(conf)
end

return _M
