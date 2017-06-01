require 'test_helper'

class OrnamentTest < ActiveSupport::TestCase
  def setup
    @item = Ornament.create
    @item.occupation = Occupation.first
    @item.feature = Feature.first
    @item.save
  end

  test "associations" do
    assert_not_nil @item.occupation
    assert_not_nil @item.feature
    assert_equal @item.feature.id, Feature.first.id

    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.strata
    assert_not_empty @item.units
  end
end
