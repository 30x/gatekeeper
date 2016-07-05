#!/bin/sh
if [ ! -d ./run ]
then
  mkdir ./run
fi
BASEDIR=$(dirname "$0")
openresty -p $BASEDIR/run -c ../nginx/nginx.conf
