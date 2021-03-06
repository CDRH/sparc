require 'test_helper'

class PerishableTest < ActiveSupport::TestCase
  def setup
    @item = Perishable.create
    @item.occupation = Occupation.first
    @item.save

    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
    assert_not_empty @item.strata
    assert_not_empty @item.units

    assert_equal @item.occupation.id, Occupation.first.id
  end
end
