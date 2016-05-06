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

function events.on_request(uri, method, raw_headers)
  -- note: apigee externs are defined in nginx.confg
  local server = ffi.load('../go/server.so')
  local methodString = c.ToGoString(method)
  local uriString = c.ToGoString(uri)
  local headersString = c.ToGoString(raw_headers)
  -- local keys,values = headersToTables(headers)
  local goResult = server.process(uriString, methodString,headersString)
  print('got result')
  uri = c.ToLuaString(goResult.r0)
  headersString = c.ToLuaString(goResult.r1)
  local res = {
    headers = parse_headers(headersString),
    uri = uri,
    method = method
  }
  local keys = c.GoSliceToTable(goResult.r1)
  local values = c.GoSliceToTable(goResult.r2)
  for i,key in ipairs(keys) do
    res[key] = values[i]
  end
  return res;
end

function parse_headers(headersString)
  local result = {};
  local headersRows = split(headersString,"\n")
  for i,row in ipairs(headersRows) do
    local keyValues = split(row,":")
    local key = keyValues[1]
    local value = keyValues[2]
    print(key)
    print(value)
    if result[key] then
      table.insert(result[key],value)
    else
      result[key] = {value}
    end
  end
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

return events
