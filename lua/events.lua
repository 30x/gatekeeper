-- called from nginx.conf

local events = {}
local ffi = require('ffi')
local table = require('table')
local c = require('./c')

ffi.cdef[[

  /* Return type for process */
 struct process_return {
	char* r0;
	char* r1;
  char* r2;
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
  local uriResult = c.ToLua(goResult.r0)
  local methodResult = c.ToLua(goResult.r1)
  local headerResult = c.ToLua(goResult.r2)
  local headers = parse_headers(headerResult)

  local res = {
    headers = headers,
    uri = uriResult,
    method = methodResult
  }
  return res;
end

function parse_headers(headersString)
  local result = {};
  local headersRows = lines(headersString)
  for i,row in ipairs(headersRows) do
    local keyValues = split(row,": ")
    local length = #keyValues
    if length == 2 then
      local key = keyValues[1]
      local value = keyValues[2]

      if key and value then
        local t = result[key]
        if not t then
          t = {}
          result[key] = t
        end
        local splitValues = split(value,',')
        for i,splitValue in ipairs(splitValues) do
          t[#t + 1] = splitValue
        end
      end
    end
  end
  return result
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end
return events
