describe("a test", function()
  -- tests go here

  -- tests
  it("checks c struct", function()
    local events = require("../events")
    local res = events.run();
    assert.is_equal('1',string.char(res.a[0]))
    assert.is_equal('2',string.char(res.b[0]))

  end)

  -- more tests pertaining to the top level
end)