require 'test_helper'

class EggshellTest < ActiveSupport::TestCase
  def setup
    @item = Eggshell.create
    @item.eggshell_item = EggshellItem.first
    @item.occupation = Occupation.first
    @item.save
    @item.features << Feature.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
    assert_not_nil @item.eggshell_item
    assert_not_nil @item.occupation
    assert_equal @item.eggshell_item.id, EggshellItem.first.id
  end
end
