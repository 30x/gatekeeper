-- called from nginx.conf

local events = {}
local ffi = require('ffi')
local c = require('./c')

ffi.cdef[[
    extern Header process(char* p0, GoSlice p1, char* p2);
]]

function events.run(method, headers, body)
  -- note: apigee externs are defined in nginx.confg
  local server = ffi.load('../go/server.so')
  local methodString = c.ToCharPointer(method);
  local headersTable = c.KeyValueToGoSlice(headers);
  local bodyString = c.ToCharPointer(body);
  local goResult = server.process(methodString,headersTable,bodyString)

  return goResult;
end

return events
