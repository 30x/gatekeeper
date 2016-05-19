 ffi = require('ffi');
ffi.cdef[[
  unsigned int GoCreateRequest();
  void GoFreeRequest(unsigned int id);
  void GoBeginRequest(unsigned int id, const char* rawHeaders);
  int GoStoreChunk(const void* data, unsigned int len);
  void GoReleaseChunk(int chunkID);
  void* GoGetChunk(int chunkID);
  unsigned int GoGetChunkLength(int chunkID);
  char* GoPollRequest(unsigned int id, int block);
  void GoCancelRequest(unsigned int id);
  void GoSendRequestBodyChunk(
    unsigned int id, int last, const void* chunk, unsigned int len);
  char* GoTransformHeaders(unsigned int id, const char* rawHeaders);
  int GoTransformBodyChunk(unsigned int id, int last, const void* data, unsigned int len);
  void GoInstallTestHandler();
]]
gobridge = ffi.load('gobridge.so')

print('Installing test handler for weaver.')
gobridge.GoInstallTestHandler()
