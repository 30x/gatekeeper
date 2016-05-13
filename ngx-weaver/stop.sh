#!/bin/sh

openresty -p ./run -c ../nginx.conf  -s stop
