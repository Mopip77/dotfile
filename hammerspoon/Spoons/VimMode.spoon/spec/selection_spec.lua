local Selection = require('lib/selection')

describe("Selection", function()
  describe("data accessors", function()
    it("has location", function()
      local selection = Selection:new(10, 1)

      assert.are.equals(selection.location, 10)
    end)

    it("has selection length", function()
      local selection = Selection:new(10, 50)

      assert.are.equals(selection.length, 50)
    end)
  end)

  describe("#positionEnd", function()
    it("should return the location plus length", function()
      local selection = Selection:new(10, 50)

      assert.are.equals(selection:positionEnd(), 60)
    end)
  end)

  describe("#isSelected", function()
    it("is selected if length > 0", function()
      local selection = Selection:new(10, 1)

      assert.True(selection:isSelected())
    end)

    it("is not selected if length == 0", function()
      local selection = Selection:new(10, 0)

      assert.False(selection:isSelected())
    end)
  end)
end)
