require 'test_helper'

class ResidentialFeatureTest < ActiveSupport::TestCase
  def setup
    @item = ResidentialFeature.create(:name => "test")
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
  end
end
