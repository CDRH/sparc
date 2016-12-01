require 'test_helper'

class FeatureOccupationTest < ActiveSupport::TestCase
    def setup
    @item = FeatureOccupation.create(:occupation => "test")
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
    assert_equal @item.features.first.id, Feature.first.id
  end
end
