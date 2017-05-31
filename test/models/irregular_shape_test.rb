require 'test_helper'

class IrregularShapeTest < ActiveSupport::TestCase
  def setup
    @item = IrregularShape.create(:name => "test")
    @item.units << Unit.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.units
  end
end
