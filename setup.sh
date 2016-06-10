#brew install homebrew/nginx/openresty
#brew install lua51
#brew install luajit
command -v openresty >/dev/null 2>&1 || { echo "I require openresty but it's not installed.  Aborting." >&2; exit 1; }
#rm -rf lua
git clone git@github.com:30x/lua-gozerian.git lua
command -v luajit >/dev/null 2>&1 || { echo "I require luajit but it's not installed.  Aborting." >&2; exit 1; }
command -v luarocks-5.1 >/dev/null 2>&1 || { echo "I require luarocks-5.1 but it's not installed.  Aborting." >&2; exit 1; }
luarocks-5.1 install luasec OPENSSL_DIR=/usr/local/opt/openssl/
luarocks-5.1 install --server=http://luarocks.org/dev lua-gozerian
pushd ngx
chmod +x clone-gozerian.sh
./clone-gozerian.sh
popd

