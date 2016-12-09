require 'test_helper'

class ImageAssocnoegTest < ActiveSupport::TestCase
  def setup
    @item = ImageAssocnoeg.first
    @item.images << Image.first
  end

  test "associations" do
    assert_not_empty @item.images
  end

end
