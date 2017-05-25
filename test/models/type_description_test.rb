require 'test_helper'

class TypeDescriptionTest < ActiveSupport::TestCase
  def setup
    @item = TypeDescription.create(:name => "test")
    @item.units << Unit.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.units
  end
end
