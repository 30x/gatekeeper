-- called from nginx.conf

local events = {}
local ffi = require('ffi')
local table = require('table')
local c = require('./c')

ffi.cdef[[

/* Return type for onRequest */
struct onRequest_return {
	char* r0;
	char* r1;
	char* r2;
};

extern struct onRequest_return onRequest(GoString p0, GoString p1, GoString p2);

extern char* onResponse(GoString p0);

]]

function events.on_request(uri, method, raw_headers)
  -- note: apigee externs are defined in nginx.confg
  local server = ffi.load('../go/server.so')
  local methodString = c.ToGoString(method)
  local uriString = c.ToGoString(uri)
  local headersString = c.ToGoString(raw_headers)
  -- local keys,values = headersToTables(headers)
  local goResult = server.onRequest(uriString, methodString,headersString)
  local uriResult = c.ToLua(goResult.r0)
  local methodResult = c.ToLua(goResult.r1)
  local headerResult = c.ToLua(goResult.r2)
  local headers = c.parse_headers(headerResult)

  return {
    headers = headers,
    uri = uriResult,
    method = methodResult
  }
end

function events.on_resposne(headers)
  local serializedHeaders = c.serialize_headers(headers)
  print(serialized_headers)
  local server = ffi.load('../go/server.so')
  local cHeaders = server.onResponse(raw_headers)
  serializedHeaders = c.ToLua(cHeaders)
  local headers = c.parse_headers(serializedHeaders)
  return {
    headers=headers
  }
end




return events
