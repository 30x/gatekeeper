#!/bin/sh
BASEDIR=$(dirname "$0")
openresty -p $BASEDIR/run -c ../nginx/nginx.conf -s reload
