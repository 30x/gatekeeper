local c = {}

local ffi = require('ffi')


ffi.cdef[[
  // standard Go definitions //

  typedef signed char GoInt8;
  typedef unsigned char GoUint8;
  typedef short GoInt16;
  typedef unsigned short GoUint16;
  typedef int GoInt32;
  typedef unsigned int GoUint32;
  typedef long long GoInt64;
  typedef unsigned long long GoUint64;
  typedef GoInt64 GoInt;
  typedef GoUint64 GoUint;
  typedef float GoFloat32;
  typedef double GoFloat64;
  typedef __complex float GoComplex64;
  typedef __complex double GoComplex128;

  // static assertion to make sure the file is being used on architecture
  // at least with matching size of GoInt.
  typedef char _check_for_64_bit_pointer_matching_GoInt[sizeof(void*)==64/8 ? 1:-1];

  // change to Go struct: add 'const' declaration to char * (required by Lua FFI)
  // typedef struct { char *p; GoInt n; } GoString;
  typedef struct { const char *p; GoInt n; } GoString;

  typedef void *GoMap;
  typedef void *GoChan;
  typedef struct { void *t; void *v; } GoInterface;
  typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;

  // C stdlib definitions //

  void free(void *ptr);
]]

function c.free(var)
 local p = ffi.gc(var, nil)
 p = nil
end

function c.ToGoArray(table)
  local luaType = type(table[1])
  local makeGoArray = goArrayConstructors[luaType]
  local goArray = makeGoArray(#table)
  local toGoType = goConverters[luaType]
  for index, value in next, table do
    goArray[index - 1] = toGoType(value)
  end
  return goArray
end


function c.getCharPointer( str )
  local c_str = ffi.new("char[?]", #str)
  ffi.copy(c_str, str)
  return c_str
end

return c