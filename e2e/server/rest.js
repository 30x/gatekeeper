'use strict'

const restify = require('restify')

module.exports = function (port, headersCb,cb) {
  function respond(req, res, next) {

    Object.keys(req.headers).forEach((key)=>{
      headersCb(key,req.headers[key])
    })

    res.json(200,{testkey:'testres'});
    next();
  }
  var server = restify.createServer();
  server.get('/', respond);
   server.get('/pass', respond);
  server.head('/', respond);
  server.put('/', respond);
  server.post('/', respond);
  server.del('/', respond);

  server.listen(port || 8000, function (err) {
    cb(err,server)
  });
}