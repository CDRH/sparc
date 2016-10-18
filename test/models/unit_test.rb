require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  def setup
    @item = Unit.first
  end

  test "associations" do
    assert_not_empty @item.strata
    assert_not_empty @item.features

    assert @item.excavation_status
    assert @item.inferred_function
    # assert @item.intact_roof
    # assert @item.room_type
    # assert @item.irregular_shape
    # assert @item.salmon_sector
    # assert @item.story
    # assert @item.type_description
    # assert @item.unit_class
    # assert @item.unit_occupation

  end
end
