#brew install homebrew/nginx/openresty
#brew install lua51
#brew install luajit
command -v openresty >/dev/null 2>&1 || { echo "I require openresty but it's not installed.  Aborting." >&2; exit 1; }

git clone git@github.com:30x/lua-gozerian.git lua
pushd lua
chmod +x setup.sh
./setup.sh
popd