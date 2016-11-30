require 'test_helper'

class StratumTest < ActiveSupport::TestCase
  def setup
    @item = Stratum.create
    @item.bone_tools << BoneTool.first
    @item.features << Feature.first
    @item.select_artifacts << SelectArtifact.first

    @item.strat_occupation = StratOccupation.first
    @item.strat_type = StratType.first
    @item.unit = Unit.first
    @item.save
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.bone_tools
    assert_not_empty @item.features
    assert_not_empty @item.select_artifacts

    assert_not_nil @item.strat_occupation
    assert_not_nil @item.strat_type
    assert_not_nil @item.unit
    assert_equal @item.unit.id, Unit.first.id
  end
end
