ffi = require('ffi');
--local
libgozerian = require('./lib/resty/gozerian/index')
--luarocks via luarocks-5.1 install --server=http://luarocks.org/dev lua-gozerian
--libgozerian = require('lua-gozerian')
gobridge = libgozerian.init()