require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
  def setup
    @item = Feature.create
    @item.feature_group = FeatureGroup.first
    @item.feature_occupation = FeatureOccupation.first
    @item.feature_type = FeatureType.first
    @item.doorway_sealed = DoorwaySealed.first
    @item.door_between_multiple_room = DoorBetweenMultipleRoom.first
    @item.residential_feature = ResidentialFeature.first
    @item.t_shaped_door = TShapedDoor.first
    @item.save

    @item.strata << Stratum.first

    @item.ornaments << Ornament.first
    @item.bone_inventories << BoneInventory.first
    @item.ceramic_inventories << CeramicInventory.first
    @item.eggshells << Eggshell.first
    @item.lithic_inventories << LithicInventory.first
    @item.perishables << Perishable.first
    @item.soils << Soil.first
  end

  test "associations" do
    assert_not_nil @item.feature_group
    assert_not_nil @item.feature_occupation
    assert_not_nil @item.feature_type
    assert_not_nil @item.doorway_sealed
    assert_not_nil @item.door_between_multiple_room
    assert_not_nil @item.residential_feature
    assert_not_nil @item.t_shaped_door

    assert_equal @item.t_shaped_door.id, TShapedDoor.first.id

    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.strata
    assert_not_empty @item.units

    assert_not_empty @item.ornaments
    assert_not_empty @item.bone_inventories
    assert_not_empty @item.ceramic_inventories
    assert_not_empty @item.eggshells
    assert_not_empty @item.lithic_inventories
    assert_not_empty @item.perishables
    assert_not_empty @item.soils

    assert_equal @item.soils.first.id, Soil.first.id
  end
end
