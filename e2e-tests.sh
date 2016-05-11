#!/bin/bash
pushd ngx
chmod +x start.sh
./start.sh
popd
pushd e2e
./test.sh
popd
pushd ngx
./stop.sh
popd