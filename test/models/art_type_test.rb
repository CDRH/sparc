require 'test_helper'

class ArtTypeTest < ActiveSupport::TestCase

  def setup
    @item = ArtType.create(:name => "test")
    @item.soils << Soil.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.soils
  end
end
