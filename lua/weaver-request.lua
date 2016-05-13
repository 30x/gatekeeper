function pollCommand(id)
  local sleepCount = 0
  local cmd = gobridge.GoPollRequest(id)
  while cmd == nil do
    ngx.sleep(0.001)
    sleepCount = sleepCount + 1
    cmd = gobridge.GoPollRequest(id)
  end
  print('Sleep count ', sleepCount)
  return ffi.string(cmd)
end

function sendBody(id)
  ngx.req.read_body()
  local body = ngx.req.get_body_data()
  print('4 Sending request body')
  gobridge.GoSendRequestBodyChunk(id, body)
  gobridge.GoSendLastRequestBodyChunk(id)
end

function readBody(id, discardedBody, buf)
  local data = string.sub(buf, 4)
  if not discardedBody then
    ngx.req.read_body()
    ngx.req.set_body_data(data)
  else
    ngx.req.append_body(data)
  end
end

local id = gobridge.GoCreateRequest()
print('1 create request ', id)
gobridge.GoBeginRequest(id, ngx.req.raw_header())
print('2 began request')

local discardedBody = false
local cmd
repeat
  cmdBuf = pollCommand(id)
  cmd = string.sub(cmdBuf, 0, 4)
  print('3 got command: ', cmd)

  if cmd == 'RBOD' then
    sendBody(id)
  elseif cmd == 'WBOD' then
    readBody(id, discardedBody, cmdBuf)
    discardedBody = true
  end
until cmd == 'DONE'
