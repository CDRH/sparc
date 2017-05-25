require 'test_helper'

class SelectArtifactOccupationTest < ActiveSupport::TestCase
  def setup
    @item = SelectArtifactOccupation.create(:name => "test")
    @item.select_artifacts << SelectArtifact.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.select_artifacts
  end
end
