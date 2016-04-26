command -v luajit >/dev/null 2>&1 || { echo "I require luajit but it's not installed.  Aborting." >&2; exit 1; }
command -v luarocks-5.1 >/dev/null 2>&1 || { echo "I require luarocks-5.1 but it's not installed.  Aborting." >&2; exit 1; }
luarocks-5.1 install ffi
luarocks-5.1 install --server=http://luarocks.org/dev lua2go
luarocks-5.1 install busted
busted ngx/lua/tests/**/*.lua
