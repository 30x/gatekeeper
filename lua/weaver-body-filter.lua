if not (ngx.ctx.notProxying == 1) then
  local body = ngx.arg[1]
  local bodyLen
  if body == nil then
    bodyLen = 0
  else
    bodyLen = string.len(body)
  end
  local last = 0
  if ngx.arg[2] then
    last = 1
  end

  local newChunkID = gobridge.GoTransformBodyChunk(ngx.ctx.id, last, body, bodyLen)

  if newChunkID == 0 then
    ngx.arg[1] = ""
  elseif newChunkID > 0 then
    local id = tonumber(newChunkID, 16)
    local data = gobridge.GoGetChunk(id)
    local len = gobridge.GoGetChunkLength(id)
    -- Made a copy of the chunk from Go land, and then we can free it
    local chunk = ffi.string(data, len)
    gobridge.GoReleaseChunk(id)
    ffi.C.free(data)
    ngx.arg[1] = chunk
  end
end

-- This is run on all responses at the end, so this is when we free up the
-- go request context
if ngx.arg[2] then
  gobridge.GoFreeRequest(ngx.ctx.id)
end
