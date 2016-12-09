require 'test_helper'

class ZoneTest < ActiveSupport::TestCase
  def setup
    @item = Zone.create(:number => "test")
    feat = Feature.first
    feat.images << Image.first
    strat = Stratum.first
    strat.features << feat
    unit = Unit.first
    unit.strata << strat
    @item.units << unit
  end

  test "associations" do
    assert_not_empty @item.units
    assert_not_empty @item.images
  end

end
