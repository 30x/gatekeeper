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
    server(port, function (key, value) {
      console.log('header {%s:%s}', key, value)
      if (!closed && value.includes('modifiedtest1')) {
        console.log('done')
        restify.close()
        done()
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
        console.log(r.headers)
      })
    })
  })
})