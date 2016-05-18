local c = require('./c')

function setResponseHeaders(headers)
  local lower_headers = {}
  for k,v in pairs(headers) do
    ngx.header[k] = v
    lower_headers[string.lower(k)] = v
  end
  for k,v in pairs(ngx.header) do
    if not lower_headers[k] then
      -- print('deleting ' .. k)
      ngx.header[k] = nil
    end
  end
end

if ngx.ctx.notProxying == 1 then
  -- Replace the headers send back as part of the generated response
  if not (ngx.ctx.responseHeaders == nil) then
    setResponseHeaders(ngx.ctx.responseHeaders)
  end
  -- Let nginx compute the content length
  ngx.header['Content-Length'] = nil

else
  -- Transform the headers that came back from a proxy response
  local outHdrs = c.serialize_headers(ngx.header)
  local newHdrs = gobridge.GoTransformHeaders(ngx.ctx.id, outHdrs)
  if not (newHdrs == nil) then
    local h = c.parse_headers(ffi.string(newHdrs))
    ffi.C.free(newHdrs)
    setResponseHeaders(h)
  end
end
