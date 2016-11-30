require 'test_helper'

class StratOccupationTest < ActiveSupport::TestCase
  def setup
    @item = StratOccupation.create(:occupation => "test")
    @item.strata << Stratum.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.strata
  end
end
