#!/bin/sh
if [ ! -d ./run ]
then
  mkdir ./run
fi
BASEDIR=$(dirname "$0")
openresty -p $BASEDIR/run -c ../nginx/nginx.conf

#Verify the process started
if [ $? -eq 0 ]
then
  echo "Succesfully started openresty"
else
  echo "Could not start openresty" >&2
fi
