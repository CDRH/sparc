require 'test_helper'

class UnitOccupationTest < ActiveSupport::TestCase
  def setup
    @item = UnitOccupation.create(:name => "test")
    feat = Feature.first
    feat.images << Image.first
    strat = Stratum.first
    strat.features << feat
    unit = Unit.first
    unit.strata << strat
    @item.units << unit
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.units
    assert_not_empty @item.images
  end
end
