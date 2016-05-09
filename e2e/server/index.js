'use strict'
const restify = require('./rest')
const port = process.env.REST_PORT || 8000
restify(port,function(key,value){
  console.log('{"%s": "%s"}',key,value)
},function(err,server){
  console.log('successfully bound to rest port %s',port)
})
