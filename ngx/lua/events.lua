-- called from nginx.conf

local events = {}
local ffi = require('ffi')
local lua2go = require('./lua2go')

ffi.cdef[[
      typedef struct {
        char *a;
        char *b;
      } Header;

      extern Header process(GoString p0, GoString p1, GoString p2);
    ]]

function events.run()
  -- note: apigee externs are defined in nginx.confg
  local benchmark = lua2go.Load('../go/server.so')

  local method = lua2go.ToGo('test')
  local headers = lua2go.ToGo('test')
  local body = lua2go.ToGo('test')
  local goResult = benchmark.process(method, headers, body)

  return goResult;
end

return benchmark
