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

  test "sorted" do
    all = DoorwaySealed.all
    sorted = DoorwaySealed.sorted
    assert_equal all.size, sorted.size
    assert_equal all.first.doorway_sealed, "n/a"
    assert_equal all.last.doorway_sealed, "test"
    assert_equal sorted.first.doorway_sealed, "??"
    assert_equal sorted.last.doorway_sealed, "yes"
  end
end
