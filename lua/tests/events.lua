
describe("a test", function()
  -- tests go here

  -- tests
  it("checks c struct", function()
    local events = require("../events")
    local headers = "key1: val1\nkey2: val2\nkey3: val3"

    local res = events.on_request('http://someuri','PUT',headers);

    assert.is_equal(res.key1, headers.key1 .. 'modified')
    assert.is_equal(res.key2, headers.key2 .. 'modified')

  end)

  -- tests
  it("checks c struct with weird maps", function()
    local events = require("../events")
    local headers = "key1: val1,val2\nkey2: val3,val4\nkey3: val3"

    local res = events.on_request('http://someuri','PUT',headers);

    assert.is_equal(res.key1, headers.key1 .. 'modified')
    assert.is_equal(res.key2, headers.key2 .. 'modified')

  end)

end)