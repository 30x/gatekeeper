'use strict'

const restify = require('restify')

module.exports = function (port, cb) {
  function respond(req, res, next) {
    console.log('headers')
    Object.keys(req.headers).forEach((key)=>{
      console.log('{"%s": "%s"}',key,req.headers[key])
    })
    console.log('end headers')
    res.json(200,{testkey:'testres'});
    next();
  }
  var server = restify.createServer();
  server.get('/', respond);
  server.head('/', respond);
  server.put('/', respond);
  server.post('/', respond);
  server.del('/', respond);

  server.listen(port || 8000, function (err) {
    cb(err,server)
  });
}