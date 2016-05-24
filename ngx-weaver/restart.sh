#!/bin/sh

cp $GOPATH/src/github.com/30x/weaver/libweaver.so .

openresty -p ./run -c ../nginx.conf  -s reload
