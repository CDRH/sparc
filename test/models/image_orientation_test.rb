require 'test_helper'

class ImageOrientationTest < ActiveSupport::TestCase
  def setup
    @item = ImageOrientation.first
    @item.images << Image.first
  end

  test "associations" do
    assert_not_empty @item.images
  end

end
