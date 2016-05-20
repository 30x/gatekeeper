local common = require('./weaver-common')

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
    ngx.arg[1] = common.getChunk(newChunkID)
  end
end

-- This is run on all responses at the end, so this is when we free up the
-- go request context
if ngx.arg[2] then
  gobridge.GoFreeRequest(ngx.ctx.id)
end
