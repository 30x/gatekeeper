-- called from nginx.conf

local events = {}
local ffi = require('ffi')
local c = require('./c')

ffi.cdef[[

  /* Return type for process */
  struct process_return {
    GoSlice r0;
    GoSlice r1;
  };

  extern struct process_return process(GoString p0, GoSlice p1, GoSlice p2, GoString p3);

]]

function events.rewrite_by_lua_block(method, headers, body)
  -- note: apigee externs are defined in nginx.confg
  local server = ffi.load('../go/server.so')
  local methodString = c.ToGoString(method)
  local keys,values = headersToTables(headers)
  local headerKeys = c.ToGoSlice(keys)
  local headerValues = c.ToGoSlice(values)
  local bodyString = c.ToGoString(body)
  local goResult = server.process(methodString,headerKeys,headerValues,bodyString)
  ffi.gc(headerKeys,nil)
  ffi.gc(headerValues,nil)
  ffi.gc(bodyString,nil)
  ffi.gc(methodString,nil)
  local res = {}
  local keys = c.GoSliceToTable(goResult.r0)
  local values = c.GoSliceToTable(goResult.r1)
  for i,key in ipairs(keys) do
    res[key] = values[i]
  end
  return res;
end

function headersToTables(table)
  local index = 1
  local keys = {}
  local values = {}
  for key, value in pairs(table) do
    keys[index] = key
    values[index] = value
    index = index +1
  end
  return keys,values
end

return events