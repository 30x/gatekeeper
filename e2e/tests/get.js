const assert = require('assert')
const request = require('request')
const server = require('../server/rest')
const port = process.env.REST_PORT || 8000

describe('valid rest return', function () {
  before(function (done) {
    done()
  })

  it('on get', function (done) {
    this.timeout(10000)
    var restify = null;
    var closed = false
    var first = false
    server(port, function (key, value) {
      console.log('header {%s:%s}', key, value)
      if (!closed && value.includes('modifiedtest1')) {
        console.log('done')
        restify.close()
        first && done()
        first = true
        closed = true
      }
    }, function (err, restifyInner) {
      restify = restifyInner
      console.log('started')
      request({
        uri: 'http://localhost:3000/',
        headers: {
          'X-MyHeader-Something': 'test1',
          'X-MyHeader-Something2': 'test2',
          'X-MyHeader-SomethingMore': ['test3','test4']
        }
      }, function (err, r, body) {
        console.log('request received');
        Object.keys(r.headers).forEach((key) => {
          if(key == 'x-response-newheader'){
            first && done()
            first = true
          }
        })
      })
    })
  })
})