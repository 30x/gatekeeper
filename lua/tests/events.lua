
describe("a test", function()
  -- tests go here

  -- tests
  it("checks c struct", function()
    local events = require("../events")
    local headers = {}
    headers.key1="value1"
    headers.key2 = "value2"
    headers.key3 = "value3"

    local res = events.onrequest('http://someuri','PUT',headers);

    assert.is_equal(res.key1, headers.key1 .. 'modified')
    assert.is_equal(res.key2, headers.key2 .. 'modified')

  end)

  -- more tests pertaining to the top level
end)