require 'test_helper'

class SelectArtifactTest < ActiveSupport::TestCase
  def setup
    @item = SelectArtifact.create
    @item.occupation = Occupation.first
    @item.save

    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
    assert_not_empty @item.units

    assert_not_nil @item.occupation
  end
end
