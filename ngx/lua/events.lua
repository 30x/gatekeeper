-- called from nginx.conf

local events = {}
local ffi = require('ffi')
local c = require('./c')

ffi.cdef[[
      typedef struct {
        char *a;
        char *b;
      } Header;

      extern Header process(char* p0, char* p1, char* p2);
    ]]

function events.run()
  -- note: apigee externs are defined in nginx.confg
  local server = ffi.load('../go/server.so')
  local method = c.getCharPointer('method');
  local headers = c.getCharPointer('headers');
  local body = c.getCharPointer('body');
  local goResult = server.process(method,headers,body)
  c.free(method)
  c.free(headers)
  c.free(body)
  return goResult;
end


return events
