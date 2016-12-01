require 'test_helper'

class SoilTest < ActiveSupport::TestCase
  def setup
    @item = Soil.create(:art_type => ArtType.first)
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
    assert_not_empty @item.strata
    assert_not_empty @item.units
    assert @item.art_type
  end

end
