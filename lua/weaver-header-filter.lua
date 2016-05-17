if ngx.ctx.notProxying == 1 then
  if not (ngx.ctx.responseHeaders == nil) then
    local headers = ngx.ctx.responseHeaders
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
  -- Let nginx compute the content length
  ngx.header['Content-Length'] = nil
end
