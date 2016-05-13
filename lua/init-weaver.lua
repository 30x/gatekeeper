ffi = require('ffi');
ffi.cdef[[
  unsigned int GoCreateRequest();
  void GoBeginRequest(unsigned int id, const char* rawHeaders);
  char* GoPollRequest(unsigned int id);
  void GoCancelRequest(unsigned int id);
  void GoSendRequestBodyChunk(unsigned int id, const char* chunk);
  void GoSendLastRequestBodyChunk(unsigned int id);
  void GoInstallTestHandler();
]]
gobridge = ffi.load('gobridge.so')
gobridge.GoInstallTestHandler()
