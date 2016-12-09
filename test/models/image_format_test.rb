require 'test_helper'

class ImageFormatTest < ActiveSupport::TestCase
  def setup
    @item = ImageFormat.first
    @item.images << Image.first
  end

  test "associations" do
    assert_not_empty @item.images
  end

end
