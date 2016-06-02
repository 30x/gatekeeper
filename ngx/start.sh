#!/bin/sh

if [ ! -d ./run ]
then
  mkdir ./run
fi

cp $GOPATH/src/weaver/libgozerian.so .

openresty -p ./run -c ../nginx.conf
