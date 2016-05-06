-- called from nginx.conf, knows about ngx
local server = {}

local events = require('./events')
local uuid = require('resty.jit-uuid')

function server.onrequest()
  local uuidInstance = uuid()             ---> v4 UUID (random)
  local headers = ngx.req.get_headers()
  local method = ngx.req.get_method()
  local uri = ngx.unescape_uri(ngx.var.request_uri)
  ngx.set_header('X-APIGEE-REQUEST-ID',uuidInstance)
  local res = events.onrequest(uri, method, headers)
  for k,v in pairs(res) do
    print(k)
    ngx.log(ngx.INFO,"printing header")
    ngx.log(ngx.INFO,v)
    ngx.log(ngx.INFO,k)
    ngx.req.set_header(k,v)
  end
  return res;
end
return server
