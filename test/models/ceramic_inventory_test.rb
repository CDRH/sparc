require 'test_helper'

class CeramicInventoryTest < ActiveSupport::TestCase
  def setup
    @item = CeramicInventory.create
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
    assert_not_empty @item.strata
    assert_not_empty @item.units
  end
end
