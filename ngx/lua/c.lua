local c = {}

local ffi = require('ffi')


function c.free(var)
  ffi.gc(var,nil)
end
function c.getCharPointer( str )
  local c_str = ffi.new("char[?]", #str)
  ffi.copy(c_str, str)
  return c_str
end

return c