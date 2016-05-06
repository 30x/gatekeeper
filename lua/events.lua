-- called from nginx.conf

local events = {}
local ffi = require('ffi')
local c = require('./c')

ffi.cdef[[

  /* Return type for process */
  struct process_return {
    GoString r0;
    GoString r1;
  };

  extern struct process_return process(GoString p0, GoString p1, GoString p2);

]]

function events.on_request(uri, method, headers)
  -- note: apigee externs are defined in nginx.confg
  local server = ffi.load('../go/server.so')
  local methodString = c.ToGoString(method)
  local uriString = c.ToGoString(uri)
  -- local keys,values = headersToTables(headers)
  local goResult = server.process(uriString, methodString,headers)
  print('got result')
  local uri = c.ToLuaString(goResult.r0)
  local headersString = c.ToLuaString(goResult.r1)
  local res = {
    headers = parse_headers(headersString)
  }
  local keys = c.GoSliceToTable(goResult.r1)
  local values = c.GoSliceToTable(goResult.r2)
  for i,key in ipairs(keys) do
    res[key] = values[i]
  end
  return res;
end

function parse_headers(headersString)

end

return events
