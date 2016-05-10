#brew install homebrew/nginx/openresty
#brew install lua51
#brew install luajit
command -v openresty >/dev/null 2>&1 || { echo "I require openresty but it's not installed.  Aborting." >&2; exit 1; }
command -v luajit >/dev/null 2>&1 || { echo "I require luajit but it's not installed.  Aborting." >&2; exit 1; }
command -v luarocks-5.1 >/dev/null 2>&1 || { echo "I require luarocks-5.1 but it's not installed.  Aborting." >&2; exit 1; }
luarocks-5.1 install luasec OPENSSL_DIR=/usr/local/opt/openssl/
luarocks-5.1 install lua-resty-http
luarocks-5.1 install lua-resty-jit-uuid
#luarocks-5.1 install --server=http://luarocks.org/dev lua2go
luarocks-5.1 install busted
./lua/bustedjit ./ngx/lua/tests/**.lua
