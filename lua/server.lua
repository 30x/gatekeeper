-- called from nginx.conf, knows about ngx
local server = {}

local events = require('./events')

function server.onrequest()

  local headers = ngx.req.get_headers()
  local method = ngx.req.get_method()
  local uri = ngx.req.get_uri()
  local res = events.onrequest(uri, method, headers)
  return res;
end
return server
