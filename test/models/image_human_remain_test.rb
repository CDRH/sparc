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

end
