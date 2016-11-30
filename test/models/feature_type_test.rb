require 'test_helper'

class FeatureTypeTest < ActiveSupport::TestCase
  def setup
    @item = FeatureType.create(:feature_type => "test")
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
  end
end
