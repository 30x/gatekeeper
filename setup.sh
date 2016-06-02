mkdir lib
pushd lib
git clone git@github.com:30x/lua-gozerian.git lua
pushd lua
./setup.sh
popd
popd