-- called from nginx.conf, knows about ngx
local server = {}

local events = require('./events')
local uuid = require('resty.jit-uuid')

function server.on_request()
  local uuidInstance = uuid()             ---> v4 UUID (random)
  local headers = ngx.req.get_headers()
  local method = ngx.req.get_method()
  local uri = ngx.unescape_uri(ngx.var.request_uri)
  ngx.req.set_header('X-APIGEE-REQUEST-ID',uuidInstance)
  local raw_headers = ngx.req.raw_header(true)

  local result = events.on_request(uri, method, raw_headers)
  local resultHeaders = result.headers
  set_request_headers(resultHeaders)

  ngx.req.set_uri(result.uri)
  -- ngx.req.set_method(somenumber)
  return result;
end

function server.on_response()
  local headers = ngx.resp.get_headers()
  local result = events.on_response(headers)
  set_response_headers(result.headers)
end

function set_request_headers(headers)
  local lower_headers = {}
  for k,v in pairs(headers) do
    ngx.req.set_header(k,v)
    lower_headers[string.lower(k)] = v
  end
  for k,v in pairs(ngx.req.get_headers()) do
    if not lower_headers[k] then
      print('deleting ' .. k)
      ngx.req.set_header(k,nil)
    end
  end
end

function set_response_headers(headers)
  local lower_headers = {}
  for k,v in pairs(headers) do
    ngx.header[k] = v
    lower_headers[string.lower(k)] = v
  end
  for k,v in pairs(ngx.resp.get_headers()) do
    if not lower_headers[k] then
      print('deleting ' .. k)
      ngx.header[k] = nil
    end
  end
end

return server
