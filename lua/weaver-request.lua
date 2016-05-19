local c = require('./c')

function pollCommand(id)
  -- This part is peformance-critical. "GoPollRequest" does a non-blocking
  -- poll of a Go channel. That's very efficient. But there is no way to
  -- make nginx sleep and then wake it up from another thread, so we have
  -- to "sleep." The loop below adds a minimum of one millisecond latency to
  -- every call. We could optimize the selection of the wait time to make
  -- this lower.
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

-- Respond to Go by reading the message body and sending it to the
-- Go channel. nginx / openresty only makes it convenient to do this
-- in one big chunk.
function sendBody(id)
  -- TODO this is not going to work without a larger buffer.
  -- We need to either change nginx settings or tell Go to read the file.
  -- The Go code can handle streaming, but not Openresty right now,
  -- at least not the way that we're doing it.
  ngx.req.read_body()
  local body = ngx.req.get_body_data()
  local bodyLen
  if body == nil then
    bodyLen = 0
  else
    bodyLen = string.len(body)
  end
  gobridge.GoSendRequestBodyChunk(id, 1, body, bodyLen)
end

function setHeaders(headers)
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

-- Replace the URI on the request
function setURI(newURI)
  -- TODO I think we need to parse the new URI to also set query params
  -- TODO also, what if it is a complete URI (with a host). How do we change target?
  ngx.req.set_uri(newURI)
end

-- Replace the body of the request, before passing on to the "proxy_pass"
-- target. This supports streaming from the Go code.
function replaceRequestBody(wasWritten, chunkID)
  local newBody = getChunk(chunkID)
  if not wasWritten then
    ngx.req.read_body()
    -- TODO Hard coded response body size. Where to put?
    ngx.req.init_body(1024 * 1024)
  end
  ngx.req.append_body(newBody)
end

-- Replace the response body with content that came from Go. This
-- will only happen after a SWCH command from Go. It works in streaming mode.
function replaceResponseBody(chunkID)
  local newBody = getChunk(chunkID)
  ngx.print(newBody)
end

-- Go passes body data back to us in chunks that it allocates, and then
-- lets us access and requires that we free. This simplifies the Lua / C / Go
-- interface.
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

-- Reusable functions above. Main code starts here.

-- The ID identifies the request in the Go process. It will be released in the body filter.
local id = gobridge.GoCreateRequest()
ngx.ctx.id = id

gobridge.GoBeginRequest(id, ngx.req.raw_header())

local requestBodyWritten = false
local proxying = true
local returnStatus = 200
local cmd

repeat
  cmdBuf = pollCommand(id)
  cmd = string.sub(cmdBuf, 0, 4)
  if cmd == 'ERRR' then
    sendError(id, string.sub(cmdBuf, 5))
  elseif cmd == 'RBOD' then
    sendBody(id)
  elseif cmd == 'WHDR' then
    local headers = c.parse_headers(string.sub(cmdBuf, 5))
    if proxying then
      setHeaders(headers)
    else
      -- We can't change response headers here -- save them for later
      ngx.ctx.responseHeaders = headers
    end
  elseif cmd == 'WURI' then
    setURI(string.sub(cmdBuf, 5))
  elseif cmd == 'WBOD' then
    if proxying then
      replaceRequestBody(requestBodyWritten, string.sub(cmdBuf, 5))
      requestBodyWritten = true
    else
      replaceResponseBody(string.sub(cmdBuf, 5))
    end
  elseif cmd == 'SWCH' then
    proxying = false
    ngx.ctx.notProxying = 1
    returnStatus = tonumber(string.sub(cmdBuf, 5))
  end
until cmd == 'DONE' or cmd == 'ERRR'

if requestBodyWritten then
  ngx.req.finish_body()
end

if not proxying then
  ngx.exit(returnStatus)
end
