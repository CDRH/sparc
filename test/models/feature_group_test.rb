require 'test_helper'

class FeatureGroupTest < ActiveSupport::TestCase
  def setup
    @item = FeatureGroup.create(:feature_group => "test")
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
  end
end
