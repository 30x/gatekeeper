describe("lua struct conversions", function()
  -- tests go here
  local c = require("../c")

  -- tests
  it("check table with a table", function()
    local headers = {}
    headers[1] = {}
    headers[1][1] = 'test1val'
    headers[1][2] = 'test2val'
    local arr = c.ToGoSlice(headers)
    local converted = c.GoSliceToTable(arr)
    assert.is_equal('test1val,test2val',converted[1])
  end)

  -- more tests pertaining to the top level
end)