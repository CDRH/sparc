require 'test_helper'

class BoneToolTest < ActiveSupport::TestCase
  def setup
    @item = BoneTool.create
    @item.strata << Stratum.first
    @item.bone_tool_occupation = BoneToolOccupation.first
    @item.save
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.strata
    assert_not_empty @item.units
    assert_not_nil @item.bone_tool_occupation
  end
end
