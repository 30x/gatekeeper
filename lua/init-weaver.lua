 ffi = require('ffi');
ffi.cdef[[
  unsigned int GoCreateRequest();
  void GoFreeRequest(unsigned int id);
  void GoBeginRequest(unsigned int id, const char* rawHeaders);
  unsigned int GoStoreChunk(const void* data, unsigned int len);
  void GoReleaseChunk(unsigned int chunkID);
  void* GoGetChunk(unsigned int chunkID);
  unsigned int GoGetChunkLength(unsigned int chunkID);
  char* GoPollRequest(unsigned int id, int block);
  void GoCancelRequest(unsigned int id);
  void GoSendRequestBodyChunk(
    unsigned int id, int last, const void* chunk, unsigned int len);
  void GoInstallTestHandler();
]]
gobridge = ffi.load('gobridge.so')

print('Installing test handler for weaver.')
gobridge.GoInstallTestHandler()
