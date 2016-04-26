-- called from nginx.conf
local benchmark = {}

function benchmark.run()

  -- note: apigee externs are defined in nginx.confg
  local benchmark = lua2go.Load('./go/benchmark.so')

  local method = ngx.req.get_method()

  local no_request_line = false
  local rawHeaders = ngx.req.raw_header(no_request_line)

  local body = ngx.req.get_body_data() or '' -- cannot be nil

--extern GoInt process(GoString p0, GoString p1, GoString p2);
  local goResult = benchmark.process(lua2go.ToGo(method), lua2go.ToGo(rawHeaders), lua2go.ToGo(body))
  lua2go.AddToGC(goResult);
  return b;
end
return benchmark
