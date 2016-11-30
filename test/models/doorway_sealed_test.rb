require 'test_helper'

class DoorwaySealedTest < ActiveSupport::TestCase
  def setup
    @item = DoorwaySealed.create(:doorway_sealed => "test")
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
  end
end
