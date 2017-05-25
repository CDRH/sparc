require 'test_helper'

class TShapedDoorTest < ActiveSupport::TestCase
  def setup
    @item = TShapedDoor.create(:name => "test")
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
  end
end
