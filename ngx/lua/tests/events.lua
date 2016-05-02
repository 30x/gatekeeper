local ffi = require('ffi')
describe("a test", function()
  -- tests go here

  -- tests
  it("checks c struct", function()
    local events = require("../events")
    local headers = {}
    headers.key1="value1"
    headers.key2 = "value2"
    headers.key3 = "value3"

    local res = events.rewrite_by_lua_block('PUT',headers,'body body');
    assert.is_equal('1',ffi.string(res.key))
    assert.is_equal('2',ffi.string(res.val))

  end)

  -- more tests pertaining to the top level
end)