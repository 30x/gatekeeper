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
  local c_str = c.getCharPointer('test');
  local goResult = server.process(c_str,c_str,c_str)
  c.free(c_str)
  return goResult;
end


return events
