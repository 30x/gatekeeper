-- called from nginx.conf, knows about ngx
local server = {}

local events = require('./events')

function server.onrequest()

  local headers = ngx.req.get_headers()
  local method = ngx.req.get_method()
  local uri = ngx.var.uri
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
