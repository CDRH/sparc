require 'test_helper'

class OrnamentPeriodTest < ActiveSupport::TestCase
  def setup
    @item = OrnamentPeriod.create(:period => "test")
    @item.ornaments << Ornament.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.ornaments
  end
end
