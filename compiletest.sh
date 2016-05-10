pushd go
chmod +x build.sh
./build.sh
popd
pushd lua
chmod +x tests.sh
./tests.sh
popd
