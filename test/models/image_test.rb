require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def setup
    @item = Image.first
    @item.image_assocnoeg = ImageAssocnoeg.first
    @item.image_box = ImageBox.first
    @item.image_creator = ImageCreator.first
    @item.image_format = ImageFormat.first
    @item.image_human_remain = ImageHumanRemain.first
    @item.image_orientation = ImageOrientation.first
    @item.image_quality = ImageQuality.first
    @item.save

    @item.features << Feature.first
    @item.image_subjects << ImageSubject.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.features
    assert_not_empty @item.strata
    assert_not_empty @item.units
    assert_not_empty @item.zones
    assert_not_empty @item.image_subjects

    assert_not_nil @item.image_assocnoeg
    assert_not_nil @item.image_box
    assert_not_nil @item.image_creator
    assert_not_nil @item.image_format
    assert_not_nil @item.image_human_remain
    assert_not_nil @item.image_orientation
    assert_not_nil @item.image_quality
  end

  test "methods" do
    assert_equal @item.assocnoeg, @item.image_assocnoeg.name
    assert_equal @item.box, @item.image_box.name
    assert_equal @item.creator, @item.image_creator.name
    assert_equal @item.format, @item.image_format.name
    assert_equal @item.human_remain, @item.image_human_remain.name
    assert_equal @item.orientation, @item.image_orientation.name
    assert_equal @item.quality, @item.image_quality.name

    # first ImageHumanRemain should be true
    assert @item.displayable?
  end

end
