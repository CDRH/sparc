require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  def setup
    @item = Unit.create(:unit_no => "test")
    @item.strata << Stratum.first

    @item.excavation_status = ExcavationStatus.first
    @item.inferred_function = InferredFunction.first
    @item.intact_roof = IntactRoof.first
    @item.room_type = RoomType.first
    @item.irregular_shape = IrregularShape.first
    @item.salmon_sector = SalmonSector.first
    @item.story = Story.first
    @item.type_description = TypeDescription.first
    @item.unit_class = UnitClass.first
    @item.unit_occupation = UnitOccupation.first
  end

  test "associations" do
    assert_not_empty @item.strata
    assert_not_empty @item.features

    assert_not_nil @item.excavation_status
    assert_not_nil @item.inferred_function
    assert_not_nil @item.intact_roof
    assert_not_nil @item.room_type
    assert_not_nil @item.irregular_shape
    assert_not_nil @item.salmon_sector
    assert_not_nil @item.story
    assert_not_nil @item.type_description
    assert_not_nil @item.unit_class
    assert_not_nil @item.unit_occupation
  end
end
