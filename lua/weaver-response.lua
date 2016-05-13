local c = require('./c')

if ngx.ctx.responseStarted == nil then
  ngx.ctx.responseStarted = 1
  local rawHeaders = c.serialize_headers(ngx.resp.get_headers())
  print('Headers sent: ', ngx.headers_sent)
  print('Headers: ', rawHeaders)
  ngx.header['X-APIGEE-LUA'] = 'yes'
  --[[
  TODO
  Move headers into a weaver-headers-filter function.
  Then for body, we already know if the user wants it or not.
  Pass the raw headers along to go code.
  Save response id in a variable.
  Start to poll.
  If you get DONE, then other invocations do nothing.
  If you get WHDR, then update headers.
  If you get RBOD, then write to the Go channel and keep writing.
  If you get WBOD, then write it, and discard existing bod.
  ]]--
else
  --[[
  TODO keep polling the response
  If you get WHDR, it is an error.
  If you get DONE, then great.
  Throw away content.
  If you get WBOD, then write it.
  ]]--
  print('second time')
end
