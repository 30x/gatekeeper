#!/bin/sh

cp $GOPATH/src/github.com/30x/weaver/gobridge.so ./libgobridge.so

openresty -p ./run -c ../nginx.conf  -s reload
