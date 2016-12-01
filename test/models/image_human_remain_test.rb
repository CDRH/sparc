require 'test_helper'

class ImageHumanRemainTest < ActiveSupport::TestCase
  def setup
    @item = ImageHumanRemain.first
    @item.images << Image.first
  end

  test "associations" do
    # check generally that these respond with collections, not nil, etc
    assert_not_empty @item.images
  end

  test "hooks" do
    hr = ImageHumanRemain.create(:name => "?")
    assert_equal hr.name, "?"
    assert_not hr.displayable

    hr.update_attributes(:name => "Y")
    assert_equal hr.name, "Y"
    assert_not hr.displayable

    # alter the test fixture with name "N"
    ImageHumanRemain.find_by(:name => "N").update_attributes(:name => "Old_N")

    hr.update_attributes(:name => "N")
    assert_equal hr.name, "N"
    assert hr.displayable
  end
end
