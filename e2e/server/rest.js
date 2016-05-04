'use strict'

var restify = require('restify');


module.exports = function () {

  function respond(req, res, next) {
    console.log('request received');
    var returnVal = {};
    returnVal[key] = value  || "unknown";
    if(req.body){
      returnVal.body = req.body;
    }
    res.json(200, returnVal, {});
    next();
  }

  var server = restify.createServer({});

  server.use(restify.gzipResponse());
  server.use(restify.bodyParser());

  server.get('/', respond);

  server.post({
    path: '/'
  }, respond);
  server.put({
    path: '/'
  }, respond);

  server.del({
    path: '/'
  }, respond);

  return server;

};