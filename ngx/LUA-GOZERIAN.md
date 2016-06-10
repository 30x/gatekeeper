#Setting up lua dependencies
1. install the lua-gozerian dependency
2. luarocks-5.1 install --server=http://luarocks.org/dev lua-gozerian
3. you can also file copy the dependency locally into ngx/lua
4. look at the following lines in [nginx.conf](nginx.conf), init_worker_by_lua_block uncomment the method you want to use to reference the lua dependencies for gozerian
`--local reference `
`--libgozerian = require('./lib/resty/gozerian/index')`
`luarocks reference luarocks-5.1 install --server=http://luarocks.org/dev lua-gozerian`
`libgozerian = require('lua-gozerian')`

5. run clone-gozerian.sh to run lua-gozerian locally