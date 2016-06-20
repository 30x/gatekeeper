#!/bin/sh

if [ ! -d ./run ]
then
  mkdir ./run
fi

cp $GOPATH/src/github.com/30x/libgozerian/libgozerian.so .

openresty -p ./run -c ../nginx.conf
