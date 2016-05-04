'use strict'
const rest = require('./rest')
const server = rest()
server.listen(process.env.REST_PORT || 8000)