require 'test_helper'

class ImageBoxTest < ActiveSupport::TestCase
  def setup
    @item = ImageBox.first
    @item.images << Image.first
  end

  test "associations" do
    assert_not_empty @item.images
  end

end
