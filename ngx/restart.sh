#!/bin/sh

cp $GOPATH/src/weaver/libgozerian.so .

openresty -p ./run -c ../nginx.conf  -s reload
