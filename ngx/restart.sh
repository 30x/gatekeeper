#!/bin/sh

cp $GOPATH/src/github.com/30x/libgozerian/libgozerian.so .

openresty -p ./run -c ../nginx.conf  -s reload
