describe("a test", function()
  -- tests go here

  describe("a nested block", function()
    describe("can have many describes", function()
      -- tests
       it("tests insulate block does not update environment", function()
        assert.is_nil(package.loaded.mymodule)  -- mymodule is not loaded
        assert.is_nil(_G.myglobal)  -- _G.myglobal is not set
        assert.is_nil(myglobal)
      end)
    end)
  end)

  -- more tests pertaining to the top level
end)