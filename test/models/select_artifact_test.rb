require 'test_helper'

class SelectArtifactTest < ActiveSupport::TestCase
  def setup
    @item = SelectArtifact.create
    @item.select_artifact_occupation = SelectArtifactOccupation.first
    @item.save

    @item.strata << Stratum.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.strata
    assert_not_empty @item.units

    assert_not_nil @item.select_artifact_occupation
  end
end
