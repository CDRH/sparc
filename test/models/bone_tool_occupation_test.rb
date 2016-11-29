require 'test_helper'

class BoneToolOccupationTest < ActiveSupport::TestCase
  def setup
    @item = BoneToolOccupation.create(:occupation => "test")
    @item.bone_tools << BoneTool.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.bone_tools
  end
end
