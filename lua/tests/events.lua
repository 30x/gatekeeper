
describe("a test", function()
  -- tests go here

  -- tests
  it("checks c struct", function()
    local events = require("../events")
    local headers = "X-MyHeader-key1: val1\nX-MyHeader-key2: val2\nX-MyHeader-key3: val3"

    local res = events.on_request('http://someuri','PUT',headers);
    assert.is_equal(res.headers['X-MyHeader-key1'][1], 'modifiedval1')
    assert.is_equal(res.headers['X-MyHeader-key2'][1], 'modifiedval2')

  end)

  -- tests
  it("checks c struct with weird maps", function()
    local events = require("../events")
    local headers = "X-MyHeader-key1: val1,val2\nX-MyHeader-key2: val3,val4\nX-MyHeader-key3: val3"

    local res = events.on_request('http://someuri','PUT',headers);

    assert.is_equal(res.headers['X-MyHeader-key1'][1], 'modifiedval1')
    assert.is_equal(res.headers['X-MyHeader-key2'][1], 'modifiedval3')

  end)

end)