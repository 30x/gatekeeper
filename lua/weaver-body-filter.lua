-- This is run on all responses at the end, so this is when we free up the
-- go request context
if ngx.arg[2] then
  gobridge.GoFreeRequest(ngx.ctx.id)
end
