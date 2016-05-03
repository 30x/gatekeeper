-- called from nginx.conf
local server = {}

local events = require('./events')

function server.rewrite_by_lua_block()

  -- note: apigee externs are defined in nginx.confg
  local rawHeaders = ngx.req.get_headers()

  local body = ngx.req.get_body_data() or '' -- cannot be nil

--extern GoInt process(GoString p0, GoString p1, GoString p2);
  local goResult = benchmark.process(lua2go.ToGo(method), lua2go.ToGo(rawHeaders), lua2go.ToGo(body))
  lua2go.AddToGC(goResult);
  return b;
end
return server
