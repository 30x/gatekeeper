local c = require('./c')

function pollCommand(id)
  local cmd = gobridge.GoPollRequest(id, 0)
  while cmd == nil do
    ngx.sleep(0.001)
    cmd = gobridge.GoPollRequest(id, 0)
  end
  local ret = ffi.string(cmd)
  ffi.C.free(cmd)
  return ret
end

function sendError(id, err)
  nginx.say(err)
  ngx.exit(500)
end

function sendBody(id)
  -- TODO this is not going to work without a larger buffer.
  -- We need to either change nginx settings or tell Go to read the file.
  -- The Go code can handle streaming, but not Openresty right now,
  -- at least not the way that we're doing it.
  ngx.req.read_body()
  local body = ngx.req.get_body_data()
  gobridge.GoSendRequestBodyChunk(id, 1, body, string.len(body))
end

function setHeaders(rawHeaders)
  local headers = c.parse_headers(rawHeaders)
  local lower_headers = {}
  for k,v in pairs(headers) do
    ngx.req.set_header(k,v)
    lower_headers[string.lower(k)] = v
  end
  for k,v in pairs(ngx.req.get_headers()) do
    if not lower_headers[k] then
      -- print('deleting ' .. k)
      ngx.req.set_header(k,nil)
    end
  end
end

function setURI(newURI)
  -- TODO I think we need to parse the new URI to also set query params
  -- TODO also, what if it is a complete URI (with a host). How do we change target?
  ngx.req.set_uri(newURI)
end

function replaceRequestBody(wasWritten, chunkID)
  local newBody = getChunk(chunkID)
  if wasWritten then
    ngx.req.append_body(newBody)
  else
    ngx.req.read_body()
    -- TODO Hard coded response body size. Where to put?
    ngx.req.init_body(1024 * 1024)
    ngx.req.append_body(newBody)
  end
end

function replaceResponseBody(chunkID)
  local newBody = getChunk(chunkID)
  ngx.print(newBody)
end

function getChunk(chunkID)
  local id = tonumber(chunkID, 16)
  local data = gobridge.GoGetChunk(id)
  local len = gobridge.GoGetChunkLength(id)
  -- Made a copy of the chunk from Go land, and then we can free it
  local chunk = ffi.string(data, len)
  gobridge.GoReleaseChunk(id)
  ffi.C.free(data)
  return chunk
end

local id = gobridge.GoCreateRequest()

gobridge.GoBeginRequest(id, ngx.req.raw_header())

local bodyWasWritten = false
local proxying = true
local returnStatus = 200
local cmd
repeat
  cmdBuf = pollCommand(id)
  cmd = string.sub(cmdBuf, 0, 4)
  -- print(cmd)

  if cmd == 'ERRR' then
    sendError(id, string.sub(cmdBuf, 5))
  elseif cmd == 'RBOD' then
    sendBody(id)
  elseif cmd == 'WHDR' then
    -- TODO to set response headers, we have to store them and then
    -- use a response header filter later on!
    if proxying then
      setHeaders(string.sub(cmdBuf, 5))
    end
  elseif cmd == 'WURI' then
    setURI(string.sub(cmdBuf, 5))
  elseif cmd == 'WBOD' then
    if proxying then
      replaceRequestBody(bodyWasWritten, string.sub(cmdBuf, 5))
      bodyWasWritten = true
    else
      replaceResponseBody(string.sub(cmdBuf, 5))
    end
  elseif cmd == 'SWCH' then
    proxying = false
    returnStatus = tonumber(string.sub(cmdBuf, 5))
  end
until cmd == 'DONE' or cmd == 'ERRR'

gobridge.GoFreeRequest(id)

if bodyWasWritten then
  ngx.req.finish_body()
end

if not proxying then
  ngx.exit(returnStatus)
end
