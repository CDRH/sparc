require 'test_helper'

class DoorwaySealedTest < ActiveSupport::TestCase
  def setup
    @item = DoorwaySealed.create(:name => "test")
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
    assert_equal all.first.name, "n/a"
    assert_equal all.last.name, "test"
    assert_equal sorted.first.name, "??"
    assert_equal sorted.last.name, "yes"
  end
end
