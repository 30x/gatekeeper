#!/bin/sh
BASEDIR=$(dirname "$0")
openresty -p $BASEDIR/run -s stop
