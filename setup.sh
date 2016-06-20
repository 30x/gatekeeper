#!/usr/bin/env bash
#brew install homebrew/nginx/openresty
#brew install lua51
#brew install luajit
command -v openresty >/dev/null 2>&1 || { echo "openresty required but not installed. Aborting." >&2; exit 1; }
command -v luajit >/dev/null 2>&1 || { echo "luajit required but not installed. Aborting." >&2; exit 1; }
command -v luarocks-5.1 >/dev/null 2>&1 || { echo "luarocks-5.1 required but not installed. Aborting." >&2; exit 1; }
luarocks-5.1 install luasec OPENSSL_DIR=/usr/local/opt/openssl/
#luarocks-5.1 install --server=http://luarocks.org/dev lua-gozerian
pushd ngx
chmod +x clone-gozerian.sh
./clone-gozerian.sh
popd
