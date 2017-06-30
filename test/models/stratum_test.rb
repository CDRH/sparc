require 'test_helper'

class StratumTest < ActiveSupport::TestCase
  def setup
    @item = Stratum.create
    @item.features << Feature.first

    @item.occupation = Occupation.first
    @item.strat_type = StratType.first
    @item.unit = Unit.first
    @item.save
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features

    assert_not_nil @item.occupation
    assert_not_nil @item.strat_type
    assert_not_nil @item.unit
    assert_equal @item.unit.id, Unit.first.id
  end
end
